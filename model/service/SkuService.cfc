/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.

    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms
    of your choice, provided that you follow these specific guidelines:

	- You also meet the terms and conditions of the license of each
	  independent module
	- You must not alter the default display of the Slatwall name or logo from
	  any part of the application
	- Your custom code must not alter or create any files inside Slatwall,
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets
	the above guidelines as a combined work under the terms of GPL for this program,
	provided that you include the source code of that other code when and as the
	GNU GPL requires distribution of source code.

    If you modify this program, you may extend this exception to your version
    of the program, but you are not obligated to do so.

Notes:

*/
component extends="HibachiService" persistent="false" accessors="true" output="false" {

	property name="skuDAO" type="any";
	property name="locationService" type="any";
	property name="optionService" type="any";
	property name="productService" type="any";
	property name="subscriptionService" type="any";
	property name="contentService" type="any";
	property name="stockService" type="any";
	property name="settingService" type="any";
	property name="typeService" type="any";
	
	public string function getSkuDefinitionBySkuIDAndBaseProductTypeID(required string skuID, required string baseProductTypeID){
		var skuDefinition = "";
		if(isNull(arguments.baseProductTypeID)){
			arguments.baseProductTypeID = "";
		}
		
		switch (arguments.baseProductTypeID)
		{
			//merchandist
			case "444df2f7ea9c87e60051f3cd87b435a1":
				skuDefinition = getSkuDao().getSkuDefinitionForMerchandiseBySkuID(arguments.skuID);
	    		break;
			//subscription
	    	case "444df2f9c7deaa1582e021e894c0e299":
				break;
			//event
			case "444df315a963bea00867567110d47728":
				break;

			default:
				skuDefinition = "";
		}
		return skuDefinition;
	}
	
	public any function processImageUpload(required any Sku, required struct imageUploadResult) {
		var imagePath = arguments.Sku.getImagePath();
		var imageSaved = getService("imageService").saveImageFile(uploadResult=arguments.imageUploadResult,filePath=imagePath,allowedExtensions="jpg,jpeg,png,gif");
		if(imageSaved) {
			return true;
		} else {
			return false;
		}
	}


	public array function getProductSkus(required any product, required boolean sorted, boolean fetchOptions=false) {
		var skus = getSkuDAO().getProductSkus(product=arguments.product, fetchOptions=arguments.fetchOptions);

		if(arguments.sorted && arrayLen(skus) gt 1 && arrayLen(skus[1].getOptions())) {
			var sortedSkuIDQuery = getSkuDAO().getSortedProductSkusID( productID = arguments.product.getProductID() );
			var sortedArray = arrayNew(1);
			var sortedArrayReturn = arrayNew(1);

			for(var i=1; i<=sortedSkuIDQuery.recordCount; i++) {
				arrayAppend(sortedArray, sortedSkuIDQuery.skuID[i]);
			}

			arrayResize(sortedArrayReturn, arrayLen(sortedArray));

			for(var i=1; i<=arrayLen(skus); i++) {
				var skuID = skus[i].getSkuID();
				var index = arrayFind(sortedArray, skuID);
				sortedArrayReturn[index] = skus[i];
			}

			skus = sortedArrayReturn;
		}

		return skus;
	}

	public array function getSortedProductSkus(required any product) {
		var skus = arguments.product.getSkus();
		if(arrayLen(skus) lt 2) {
			return skus;
		}

		var sortedSkuIDQuery = getSkuDAO().getSortedProductSkusID(arguments.product.getProductID());
		var sortedArray = arrayNew(1);
		var sortedArrayReturn = arrayNew(1);

		for(var i=1; i<=sortedSkuIDQuery.recordCount; i++) {
			arrayAppend(sortedArray, sortedSkuIDQuery.skuID[i]);
		}

		arrayResize(sortedArrayReturn, arrayLen(sortedArray));

		for(var i=1; i<=arrayLen(skus); i++) {
			var skuID = skus[i].getSkuID();
			var index = arrayFind(sortedArray, skuID);
			sortedArrayReturn[index] = skus[i];
		}

		return sortedArrayReturn;
	}

	public any function searchSkusByProductType(string term,string productTypeID) {
		return getSkuDAO().searchSkusByProductType(argumentCollection=arguments);
	}

	// ===================== START: Logical Methods ===========================

	// =====================  END: Logical Methods ============================

	// ===================== START: DAO Passthrough ===========================

	public boolean function getSkuStocksDeletableFlag( required string skuID ) {
		return getSkuDAO().getSkuStocksDeletableFlag(argumentCollection=arguments);
	}

	public boolean function getTransactionExistsFlag() {
		return getSkuDAO().getTransactionExistsFlag( argumentCollection=arguments );
	}

	public any function getSkuBySkuCode( string skuCode ){
		return getSkuDAO().getSkuBySkuCode(argumentCollection=arguments);
	}

	// =====================  END: DAO Passthrough ============================

	// ===================== START: Process Methods ===========================

	// @help Adds locations to event skus
	public any function processSku_addEventRegistration(required any sku, required any processObject) {
		// Create new event registration	 record
		var eventRegistration = this.newEventRegistration();
		eventRegistration.setSku(arguments.sku);
		eventRegistration.generateAndSetAttendanceCode();

		// If newAccount registrant should contain an accountID otherwise should contain first, last, email, phone
		if(arguments.processObject.getNewAccountFlag() == 0) {
			eventRegistration.setAccount( getService("AccountService").getAccount(arguments.processObject.getaccountID()) );
		} else {
			//Create new account to associate with registration
			var newAccount = getService("AccountService").newAccount();
			if(len(arguments.processObject.getfirstName())) {
				newAccount.setFirstName(arguments.processObject.getfirstName());
			}
			if(len(arguments.processObject.getlastName())) {
				newAccount.setLastName(arguments.processObject.getlastName());
			}
			if(len(arguments.processObject.getemailAddress())) {
				var newEmailAddress =  getService("AccountService").newAccountEmailAddress();
				newEmailAddress.setEmailAddress(arguments.processObject.getemailAddress());
				newAccount.setPrimaryEmailAddress(newEmailAddress);

			}
			if(len(arguments.processObject.getphoneNumber())) {
				var newPhoneNumber =  getService("AccountService").newAccountPhoneNumber();
				newPhoneNumber.setPhoneNumber(arguments.processObject.getphoneNumber());
				newAccount.setPrimaryPhoneNumber(newPhoneNumber);
			}
			newAccount = getService("AccountService").saveAccount(newAccount);
			eventRegistration.setAccount(newAccount);

		}

		if(arguments.sku.getAvailableSeatCount > 0 ) {
			eventRegistration.setEventRegistrationStatusType(getTypeService().getTypeBySystemCode("erstRegistered"));
		} else {
			eventRegistration.setEventRegistrationStatusType(getTypeService().getTypeBySystemCode("erstWaitlisted"));
		}

		eventRegistration = getService("EventRegistrationService").saveEventRegistration( eventRegistration );

		return arguments.sku;
	}

	// @help Adds locations to event skus
	public any function processSku_addLocation(required any sku, required any processObject) {
		if(arguments.processObject.getEditScope() == "none"  ){
			processObject.addError('editScope', getHibachiScope().rbKey('validate.processSku_changeEventDates.editScope'));
		}
		else if(arguments.processObject.getEditScope() == "single" || isNull(arguments.sku.getProductSchedule()) ){
			for(var lc=1; lc<=listLen(arguments.processObject.getLocationConfigurations(),","); lc++) {
				var thisLocationConfig = getLocationService().getLocationConfiguration( listGetAt(arguments.processObject.getLocationConfigurations(), lc) );
				sku.addLocationConfiguration( thisLocationConfig );
			}
		} else if(arguments.processObject.getEditScope() == "all"){

			for(var thisSku in arguments.sku.getProductSchedule().getSkus()) {
				var lcList = arguments.processObject.getLocationConfigurations();
				if(thisSku.geteventStartDateTime() > now()) {
					for(var lc=1; lc<=listLen(lcList,","); lc++) {
						var thisLocationConfig = getLocationService().getLocationConfiguration( listGetAt(lcList, lc) );
						thisSku.addLocationConfiguration( thisLocationConfig );
					}
				}
			}

		}
		return sku;
	}

	// @help Modifies capacity and waitlisting properties
	public any function processSku_editCapacity(required any sku, required any processObject) {
		if(arguments.processObject.getEditScope() == "none"  ){
			processObject.addError('editScope', getHibachiScope().rbKey('validate.processSku_changeEventDates.editScope'));
		}
		// Modifying a single event
		else if(arguments.processObject.getEditScope() == "single" || isNull(arguments.sku.getProductSchedule()) ){
			// Make sure a capacity adjustment won't cause the event to be overbooked
			if( arguments.sku.getRegisteredUserCount() > arguments.processObject.getEventCapacity() ) {
				// Notify user that the capacity decrease would the event to be overbooked
				processObject.addError('eventCapacity', getHibachiScope().rbKey('validate.processSku_editCapacity.eventCapacityInvalid.notEnoughSeats'));
			} else {
				arguments.sku.setAllowEventWaitlistingFlag(arguments.processObject.getAllowEventWaitlistingFlag());
				arguments.sku.setEventCapacity(arguments.processObject.getEventCapacity());

				// Notify waitlisted registrants if capacity has increased and waitlisting is allowed
				if(arguments.processObject.getEventCapacity() > arguments.sku.getEventCapacity() && arguments.sku.getAllowWaitlistingFlag()) {
					processSku( arguments.sku, {}, 'notifyWaitlistOpenings');
				}

			}
		// Modifying an event schedule
		} else if(arguments.processObject.getEditScope() == "all"){
			var failedCapacityValidation = [];
			var eventList = "";
			for(var thisSku in arguments.sku.getProductSchedule().getSkus()) {
				if( thisSku.getRegisteredUserCount() > arguments.processObject.getEventCapacity() ) {
					eventList = "#eventList# #thisSku.getSkuName()# #thisSku.getSkuCode()# #thisSku.getEventStartDateTime()# #thisSku.getEventEndDateTime()#<br>";
					// Add overbooked skus to array
					arrayAppend(failedCapacityValidation, thisSku.getSkuID());
				}
			}
			if(arrayIsEmpty(failedCapacityValidation)) {
				for(var thisSku in arguments.sku.getProductSchedule().getSkus()) {
					thisSku.setAllowEventWaitlistingFlag(arguments.processObject.getAllowEventWaitlistingFlag());
					thisSku.setEventCapacity(arguments.processObject.getEventCapacity());
					// Notify waitlisted registrants if capacity has increased and waitlisting is allowed
					if(arguments.processObject.getEventCapacity() > thisSku.getEventCapacity() && thisSku.getAllowWaitlistingFlag()) {
						processSku( thisSku, {}, 'notifyWaitlistOpenings');
					}
				}
			} else {
				// Notify user that the capacity decrease would cause one of the events to be overbooked
				processObject.addError('eventCapacity', "#getHibachiScope().rbKey('validate.processSku_editCapacity.eventCapacityInvalid.notEnoughSeats')#<br>#eventList#");
			}

		}

		return arguments.sku;
	}

	// @help Logs attendance for an event
	public any function processSku_logAttendance(required any sku, required any processObject) {
		// Compare the list of all registrants with the list of those that were submitted as having attended.
		// If in attended list we set registrant as attended otherwise we set registrant to registered.
		var attendedList = "";
		if(len(arguments.processObject.getEventRegistrations())) {
			attendedList = arguments.processObject.getEventRegistrations();
		}
		var registrantsSmartlist = arguments.sku.getRegistrationAttendanceSmartlist();
		for(registrant in registrantsSmartlist.getRecords()) {
			if( listFindNoCase(attendedList,registrant.getEventRegistrationID()) > 0 ) {
				registrant.setEventRegistrationStatusType(getTypeService().getTypeBySystemCode("erstAttended"));
			} else {
				registrant.setEventRegistrationStatusType(getTypeService().getTypeBySystemCode("erstRegistered"));
			}
		}
		return sku;
	}

	// @help Removes locations from event skus
	public any function processSku_removeLocation(required any sku, required any processObject) {
		if(arguments.processObject.getEditScope() == "none"  ){
			processObject.addError('editScope', getHibachiScope().rbKey('validate.processSku_changeEventDates.editScope'));
		}
		else if(arguments.processObject.getEditScope() == "single" || isNull(arguments.sku.getProductSchedule()) ){
			for(var lc=1; lc<=listLen(arguments.processObject.getLocationConfigurations(),","); lc++) {
				var thisLocationConfig = getLocationService().getLocationConfiguration( listGetAt(arguments.processObject.getLocationConfigurations(), lc) );
				arguments.sku.removeLocationConfiguration( thisLocationConfig );
			}
			// Remove this sku from product schedule
			if(!isNull(arguments.sku.getProductSchedule())) {
				arguments.sku.removeProductSchedule( arguments.sku.getProductSchedule() );
			}
		} else if(arguments.processObject.getEditScope() == "all"){

			for(var thisSku in arguments.sku.getProductSchedule().getSkus()) {
				var lcList = arguments.processObject.getLocationConfigurations();
				if(thisSku.geteventStartDateTime() > now()) {
					for(var lc=1; lc<=listLen(lcList,","); lc++) {
						var thisLocationConfig = getLocationService().getLocationConfiguration( listGetAt(lcList, lc) );
						thisSku.removeLocationConfiguration( thisLocationConfig );
					}
				}
			}

		}
		return sku;
	}

	// @help Modifies event related start/end dates based on process object data
	public any function processSku_changeEventDates(required any sku, required any processObject) {
		if(arguments.processObject.getEditScope() == "none"  ){
			processObject.addError('editScope', getHibachiScope().rbKey('validate.processSku_changeEventDates.editScope'));
		}
		else if(arguments.processObject.getEditScope() == "single" || isNull(arguments.sku.getProductSchedule()) ){
			skuLocationsList = "";
			if(arrayLen(arguments.sku.getLocations())) {
				if(arrayLen(arguments.sku.getLocations())==1) {
					skuLocationsList = arguments.sku.getLocations()[1].getLocationID();
				} else {
					for(var loc in arguments.sku.getLocations()) {
						skuLocationsList = listAppend(skuLocationsList,loc.getLocationID());
					}
				}
			}

			if(locationConflictExistsFlag(arguments.sku,arguments.processObject.getEventStartDateTime(),arguments.processObject.getEventEndDateTime(),skuLocationsList) ) {
				// There is already an event scheduled at that location in the same date range
				processObject.addError('locationConfigurations', getHibachiScope().rbKey('validate.eventScheduleConflict'));
			} else {
				// Update schedule dates/times
				arguments.sku.setEventStartDateTime(arguments.processObject.getEventStartDateTime());
				arguments.sku.setEventEndDateTime(arguments.processObject.getEventEndDateTime());
				arguments.sku.setStartReservationDateTime(arguments.processObject.getStartReservationDateTime());
				arguments.sku.setEndReservationDateTime(arguments.processObject.getEndReservationDateTime());

				// Disconnect this sku from any recurring schedule
				if(!isNull(arguments.sku.getProductSchedule())) {
  					arguments.sku.removeProductSchedule( arguments.sku.getProductSchedule() );
  				}
			}


		} else if(arguments.processObject.getEditScope() == "all"){
			for(var thisSku in arguments.sku.getProductSchedule().getSkus()) {
				var lcList = arguments.processObject.getLocationConfigurations();
				if(thisSku.getEventStartDateTime() > now()) {
  					var newEventStartDateTime = createDateTime(year(thisSku.getEventStartDateTime()),month(thisSku.getEventStartDateTime()),day(thisSku.getEventStartDateTime()),hour(arguments.processObject.getEventStartDateTime()),minute(arguments.processObject.getEventStartDateTime()),0);
  					var newEventEndDateTime = createDateTime(year(thisSku.getEventEndDateTime()),month(thisSku.getEventEndDateTime()),day(thisSku.getEventEndDateTime()),hour(arguments.processObject.getEventEndDateTime()),minute(arguments.processObject.getEventEndDateTime()),0);
  					var newReservationStartDateTime = createDateTime(year(thisSku.getStartReservationDateTime()),month(thisSku.getStartReservationDateTime()),day(thisSku.getStartReservationDateTime()),hour(arguments.processObject.getStartReservationDateTime()),minute(arguments.processObject.getStartReservationDateTime()),0);
  					var newReservationEndDateTime = createDateTime(year(thisSku.getEndReservationDateTime()),month(thisSku.getEndReservationDateTime()),day(thisSku.getEndReservationDateTime()),hour(arguments.processObject.getEndReservationDateTime()),minute(arguments.processObject.getEndReservationDateTime()),0);
  					thisSku.setEventStartDateTime(newEventStartDateTime);
					thisSku.setEventEndDateTime(newEventEndDateTime);
					thisSku.setStartReservationDateTime(newReservationStartDateTime);
					thisSku.setEndReservationDateTime(newReservationEndDateTime);
					//getStockService().saveStockAdjustment(stockAdjustment);
					this.saveSku(thisSku);
				}
			}

		}
		return arguments.sku;
	}



	//@help Takes a sku along with a start datetime, an end datetimem and a list of location configurations, to check for location/date/time conflicts with other event schedules
	public boolean function locationConflictExistsFlag(any sku, any eventStartDateTime, any eventEndDateTime, string locationList="") {
		var locationIDList = arguments.locationList;
		var result = false;

		//Build list of locationIDs from locationConfigurations
		/*if(listLen(arguments.locationList,",") == 1) {
			var locationConfigurationSmartList = getService("LocationConfigurationService").getLocationConfigurationSmartList();
			locationConfigurationSmartList.addFilter("locationConfigurationID",arguments.locationConfigurations);
			var locationID = locationConfigurationSmartList.getRecords()[1].getLocation().getLocationID();
			locationIDList = listAppend(locationIDList,locationID);
		} else {
			locationConfigs = listToArray(arguments.locationList);
			for(var configID in locationConfigs) {
				var locationConfigurationSmartList = getService("SkuService").getLocationConfigurationSmartList();
				locationConfigurationSmartList.addFilter("locationConfigurationID",configID);
				var locationID = locationConfigurationSmartList.getRecords()[1].getLocation().getLocationID();
				if(!listFindNoCase(locationIDList,locationID)) {
					listAppend(locationIDList,locationID);
				}
			}
		}*/

		for(var i=1;i<=listLen(locationIDList);i++) {
			var location = getService("LocationService").getLocation(listGetAt(locationIDList,i));
			if(location.getLocationName() == "TBD") {
				listDeleteAt(locationIDList,i);
				break;
			}
		}

		if(listLen(locationIDList)) {
			locationIDList = listQualify(locationIDList,"'",",","char" );
			// Build smartlist of conflicting events schedules
			var smartList = getService("SkuService").getSkuSmartList();
  			smartList.joinRelatedProperty("SlatwallSku", "locationConfigurations", "left");
  			smartList.joinRelatedProperty("SlatwallLocationConfiguration", "location", "left");
  			smartList.addWhereCondition("aslatwalllocation.locationID IN (:lcIDs)",{lcIDs=locationIDList});
  			smartList.addWhereCondition("aslatwallsku.skuID <> :thisSkuID",{thisSkuID=arguments.sku.getSkuID()});
  			smartList.addWhereCondition("aslatwallsku.eventStartDateTime < :thisEndDateTime",{thisEndDateTime=arguments.eventEndDateTime});
  			smartList.addWhereCondition("aslatwallsku.eventEndDateTime > :thisStartDateTime",{thisStartDateTime=arguments.eventStartDateTime});

			// Do we have conflicts?
			if(smartList.getRecordsCount() > 0) {
				result = true;
			}
		} else {
			result = false;
		}

		return result;

	}

	// TODO [paul]: makeup / breakup
	public any function processSku_MakeupBundledSkus(required any sku, required any processObject) {

		// Create a stockAdjustment
		var stockAdjustment = getStockService().newStockAdjustment();
		stockAdjustment.setStockAdjustmentType( getTypeService().getTypeBySystemCode('satMakeupBundledSkus') );
		stockAdjustment.setToLocation( arguments.processObject.getLocation() );
		stockAdjustment.setFromLocation( arguments.processObject.getLocation() );

		var makeupStock = getStockService().getStockBySkuAndLocation( sku=arguments.sku, location=arguments.processObject.getLocation() );

		var makeupItem = getStockService().newStockAdjustmentItem();
		makeupItem.setStockAdjustment( stockAdjustment );
		makeupItem.setQuantity( arguments.processObject.getQuantity() );
		makeupItem.setToStock( makeupStock );

		// Loop over every bundledSku
		for(bundledSku in arguments.entity.getBundledSkus()) {

			var thisStock = getStockService().getStockBySkuAndLocation( sku=bundledSku.getBundledSku(), location=arguments.processObject.getLocation() );

			var makeupItem = getStockService().newStockAdjustmentItem();
			makeupItem.setStockAdjustment( stockAdjustment );
			makeupItem.setQuantity( bundledSku.getBundledQuantity() );
			makeupItem.setFromStock( thisStock );

		}

		getStockService().saveStockAdjustment(stockAdjustment);

		stockAdjustment = getStockService().processStockAdjustment( stockAdjustment, {}, 'processAdjustment' );

		return arguments.sku;
	}

	public any function processSku_BreakupBundledSkus(required any sku, required any processObject) {

		// Create a stockAdjustment
		var stockAdjustment = getStockService().newStockAdjustment();
		stockAdjustment.setStockAdjustmentType( getTypeService().getTypeBySystemCode('satBreakupBundledSkus') );
		stockAdjustment.setToLocation( arguments.processObject.getLocation() );
		stockAdjustment.setFromLocation( arguments.processObject.getLocation() );

		var breakupStock = getStockService().getStockBySkuAndLocation( sku=arguments.sku, location=arguments.processObject.getLocation() );

		var breakupItem = getStockService().newStockAdjustmentItem();
		breakupItem.setStockAdjustment( stockAdjustment );
		breakupItem.setQuantity( arguments.processObject.getQuantity() );
		breakupItem.setFromStock( breakupStock );

		// Loop over every bundledSku
		for(bundledSku in arguments.entity.getBundledSkus()) {

			var thisStock = getStockService().getStockBySkuAndLocation( sku=bundledSku.getBundledSku(), location=arguments.processObject.getLocation() );

			var breakupItem = getStockService().newStockAdjustmentItem();
			breakupItem.setStockAdjustment( stockAdjustment );
			breakupItem.setQuantity( bundledSku.getBundledQuantity() );
			breakupItem.setToStock( thisStock );

		}

		getStockService().saveStockAdjustment(stockAdjustment);

		stockAdjustment = getStockService().processStockAdjustment( stockAdjustment, {}, 'processAdjustment' );

		return arguments.sku;

	}


	// @help Move event registrations from 'waitlisted' to 'pending confirmation' if seats are available
	public any function processSku_notifyWaitlistOpenings(required any sku, processObject={}) {
		if(arguments.sku.getAllowEventWaitlistingFlag()) {
			// Get waitlisted event registrations
			var waitlistedRegistrants = getService("EventRegistrationService").getWaitlistedRegistrants(arguments.sku);
			if(isDefined("waitlistedRegistrants") && arrayLen(waitlistedRegistrants)) {
				var availableSeats = getService("EventRegistrationService").getAvailableSeatCountBySku(arguments.sku);
				if(availableSeats > 0) {
					// Calculate the number of registrantions to change
					var changeToConfirmCount = availableSeats;
					if(changeToConfirmCount > arrayLen(waitlistedRegistrants)) {
						changeToConfirmCount = arrayLen(waitlistedRegistrants);
					}

					// Process event registration changes to 'pending confirmation'
					for(i=1;i<=changeToConfirmCount;i++) {
						getService("EventRegistrationService").processEventRegistration( waitlistedRegistrants[i], {}, "confirm");
					}

				}
			}
		}
		return sku;
	}

	// =====================  END: Process Methods ============================

	// ====================== START: Status Methods ===========================

	// ======================  END: Status Methods ============================

	// ====================== START: Save Overrides ===========================

	public any function saveSku(required any sku, required struct data={}){
		var previousActiveState = arguments.sku.getActiveFlag();
		if(arguments.sku.getProduct().getBaseProductType() == "subscription"){
			if(structKeyExists(arguments.data,"renewalMethod")){
				if(arguments.data.renewalMethod == "renewalsku"){
					structDelete(arguments.data, "renewalSubscriptionBenefit");
					structDelete(arguments.data, "renewalPrice");
				}
				if(arguments.data.renewalMethod == "custom"){
					structDelete(arguments.data, "renewalSku");
					if(arguments.sku.hasRenewalSku()){
						arguments.sku.setRenewalSku(javaCast("null",""));
					}
				}
			}
		}
		arguments.sku = super.save(entity=arguments.sku, data=arguments.data);
		
		if(!sku.hasErrors()){
			if(!arguments.sku.isNew() && previousActiveState == 1 && arguments.sku.getActiveFlag() == 0){
				sku.setPublishedFlag(false);
			}
		}
		
		return arguments.sku;
	}

	// ======================  END: Save Overrides ============================

	// ==================== START: Smart List Overrides =======================

	public any function getSkuSmartList(struct data={}, currentURL="") {
		arguments.entityName = "SlatwallSku";

		var smartList = getSkuDAO().getSmartList(argumentCollection=arguments);

		smartList.joinRelatedProperty("SlatwallSku", "product");
		smartList.joinRelatedProperty("SlatwallProduct", "productType");

		smartList.addKeywordProperty(propertyIdentifier="skuCode", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="skuID", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="publishedFlag", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="product.productName", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="product.productType.productTypeName", weight=1);

		smartList.addOrder('skuCode|ASC');

		return smartList;
	}

	// @hint Retrieve Smartlist of available locations based on event sku start and end dates, and locations
	public any function getAvailableLocationsByEventSmartList(required eventSku) {
		var unavailableLocationsList = "";

		// Don't show locations that are already in sku
		if(arrayLen(eventSku.getLocationConfigurations())) {
			for( var thisLocation in eventSku.getLocations()) {
				if(listFind(unavailableLocationsList,thisLocation.getLocationID()) == 0) {
					if(listLen(unavailableLocationsList)) {
						unavailableLocationsList = listAppend(unavailableLocationsList,thisLocation.getLocationID());
					} else {
						unavailableLocationsList = thisLocation.getLocationID();
					}
				}
			}
		}

		return getAvailableLocationsSmartList(eventSku.getEventStartDateTime(), eventSku.getEventEndDateTime(), eventSku.getEventCapacity(),unavailableLocationsList);
	}

	// @hint Retrieve Smartlist of available locations based on event start and end dates, and an optional unavailableLocationsList
	public any function getAvailableLocationsSmartList(required eventStartDateTime, required eventEndDateTime, required quantity=0, string unavailableLocationsList="") {

		arguments.unavailableLocationsList = listAppend(arguments.unavailableLocationsList, getSkuDAO().getUsedLocationIdsByEventDates(eventStartDateTime,eventEndDateTime) );
		arguments.unavailableLocationsList = listQualify(arguments.unavailableLocationsList, "'");
 
		// Get non-conflicting location configurations
		var availableLocationsSmartList = getService("LocationConfigurationService").getLocationConfigurationSmartList();

		if(listLen(arguments.unavailableLocationsList) > 0) {
			availableLocationsSmartList.addWhereCondition("aslatwalllocationconfiguration.location.locationID NOT IN (#arguments.unavailableLocationsList#)");
		}
		availableLocationsSmartList.addWhereCondition("aslatwalllocationconfiguration.locationConfigurationCapacity >= #arguments.quantity#");

		return availableLocationsSmartList;

	}

	// @hint Retrieve a smartlist containing valid future event skus that allow waitlisting
	public any function getFutureWaitlistEventsSmartlist(){
		arguments.entityName = "SlatwallSku";
		var smartList = getSkuSmartlist();
		var currentDateTime = dateFormat(now(),'short');
		smartlist.addFilter("product.productType.productTypeName","Event");
		smartlist.addFilter("publishedFlag","1");
		smartlist.addFilter("allowEventWaitlistingFlag","1");
		smartlist.addWhereCondition("aslatwallsku.eventStartDateTime > #currentDateTime#");
		smartlist.addWhereCondition("aslatwallsku.purchaseStartDateTime > #currentDateTime#");
		return smartList;
	}
	
	// @help Compile smartlist of conflicting events based on location and event dates
	public any function getEventConflictsSmartList( required sku ) {
		var locationConfigurationIDList = "";
		
		// Build list of this Sku's locations
		var locationIDList = "";
		for(var lc in arguments.sku.getLocationConfigurations()) {
			if( !listFind( locationIDList,lc.getLocationID() ) ) {
				locationIDList = listAppend(locationIDList,lc.getLocationID(),",");
			}
		}
		
		// Build smartlist that will return sku events occurring at the same time and location as this event
		var eventConflictsSmartList = getService("skuService").getSkuSmartlist();
		eventConflictsSmartList.joinRelatedProperty("SlatwallSku", "locationConfigurations", "Inner");
		eventConflictsSmartList.joinRelatedProperty("SlatwallLocationConfiguration", "location", "Inner");
		if( len(locationIDList) ) {
			eventConflictsSmartList.addWhereCondition("aslatwalllocation.locationID IN (:lcIDs)",{lcIDs=locationIDList});
		}
		if( len(arguments.sku.getSkuID()) ) {
			eventConflictsSmartList.addWhereCondition("aslatwallsku.skuID <> :thisSkuID",{thisSkuID=arguments.sku.getSkuID()});
		}
		eventConflictsSmartList.addfilter("bundleFlag","0");
		eventConflictsSmartList.addWhereCondition("((aslatwallsku.eventStartDateTime >= :thisStartDateTime and aslatwallsku.eventStartDateTime <= :thisEndDateTime) OR (aslatwallsku.eventEndDateTime >= :thisStartDateTime and aslatwallsku.eventEndDateTime <= :thisEndDateTime) OR (aslatwallsku.eventStartDateTime < :thisStartDateTime and aslatwallsku.eventEndDateTime > :thisEndDateTime))",{thisStartDateTime=arguments.sku.getEventStartDateTime(),thisEndDateTime=arguments.sku.getEventEndDateTime()});
	
		eventConflictsSmartList.addOrder("eventStartDateTime|ASC");
		
		return eventConflictsSmartList;
		
	}

	// ====================  END: Smart List Overrides ========================

	// ====================== START: Get Overrides ============================

	// ======================  END: Get Overrides =============================

	// =================== START: Deprecated Functions ========================

	public boolean function createSkus(required any product, required struct data ) {

		// Create Merchandise Propduct Skus Based On Options
		if(arguments.product.getProductType().getBaseProductType() == "merchandise") {

			// If options were passed in create multiple skus
			if(structKeyExists(arguments.data, "options") && len(arguments.data.options)) {

				var optionGroups = {};
				var totalCombos = 1;
				var indexedKeys = [];
				var currentIndexesByKey = {};
				var keyToChange = "";

				// Loop over all the options to put them into a struct by groupID
				for(var i=1; i<=listLen(arguments.data.options); i++) {
					var option = getOptionService().getOption( listGetAt(arguments.data.options, i) );
					if(!structKeyExists(optionGroups, option.getOptionGroup().getOptionGroupID())) {
						optionGroups[ option.getOptionGroup().getOptionGroupID() ] = [];
					}
					arrayAppend(optionGroups[ option.getOptionGroup().getOptionGroupID() ], option);
				}

				// Loop over the groups to see how many we will be creating and to setup the option indexes to use
				for(var key in optionGroups) {
					arrayAppend(indexedKeys, key);
					currentIndexesByKey[ key ] = 1;
					totalCombos = totalCombos * arrayLen(optionGroups[key]);
				}

				// Create a sku with 1 option from each group, and then update the indexes properly for the next loop
				for(var i = 1; i<=totalCombos; i++) {

					// Setup the New Sku
					var newSku = this.newSku();
					newSku.setPrice(arguments.data.price);
					if(structKeyExists(arguments.data, "listPrice") && isNumeric(arguments.data.listPrice) && arguments.data.listPrice > 0) {
						newSku.setListPrice(arguments.data.listPrice);
					}
					newSku.setSkuCode(arguments.product.getProductCode() & "-#arrayLen(arguments.product.getSkus()) + 1#");

					// Add the Sku to the product, and if the product doesn't have a default, then also set as default
					arguments.product.addSku(newSku);
					if(isNull(arguments.product.getDefaultSku())) {
						arguments.product.setDefaultSku(newSku);
					}

					// Add each of the options
					for(var key in optionGroups) {
						newSku.addOption( optionGroups[key][ currentIndexesByKey[key] ]);
					}
					if(i < totalCombos) {
						var indexesUpdated = false;
						var changeKeyIndex = 1;
						while(indexesUpdated == false) {
							if(currentIndexesByKey[ indexedKeys[ changeKeyIndex ] ] < arrayLen(optionGroups[ indexedKeys[ changeKeyIndex ] ])) {
								currentIndexesByKey[ indexedKeys[ changeKeyIndex ] ]++;
								indexesUpdated = true;
							} else {
								currentIndexesByKey[ indexedKeys[ changeKeyIndex ] ] = 1;
								changeKeyIndex++;
							}
						}
					}
				}

			// If no options were passed in we will just create a single sku
			} else {

				var thisSku = this.newSku();
				thisSku.setProduct(arguments.product);
				thisSku.setPrice(arguments.data.price);
				if(structKeyExists(arguments.data, "listPrice") && isNumeric(arguments.data.listPrice) && arguments.data.listPrice > 0) {
					thisSku.setListPrice(arguments.data.listPrice);
				}
				thisSku.setSkuCode(arguments.product.getProductCode() & "-1");
				arguments.product.setDefaultSku( thisSku );

			}

		// Create Subscription Product Skus Based On SubscriptionTerm and SubscriptionBenifit
		} else if (arguments.product.getProductType().getBaseProductType() == "subscription") {

			// Make sure there was at least one subscription benifit
			if(!structKeyExists(arguments.data, "subscriptionBenefits") || !listLen(arguments.data.subscriptionBenefits)) {
				arguments.product.addError("subscriptionBenefits", rbKey('entity.product.subscriptionbenifitsrequired'));
			}

			// Make sure there was at least one subscription term passed in
			if(!structKeyExists(arguments.data, "subscriptionTerms") || !listLen(arguments.data.subscriptionTerms)) {
				arguments.product.addError("subscriptionTerms", rbKey('entity.product.subscriptiontermsrequired'));
			}

			// If the product still doesn't have any errors then we can create the skus
			if(!arguments.product.hasErrors()) {
				for(var i=1; i <= listLen(arguments.data.subscriptionTerms); i++){
					var thisSku = this.newSku();
					thisSku.setProduct(arguments.product);
					thisSku.setPrice(arguments.data.price);
					thisSku.setRenewalPrice(arguments.data.price);
					thisSku.setSubscriptionTerm( getSubscriptionService().getSubscriptionTerm(listGetAt(arguments.data.subscriptionTerms, i)) );
					thisSku.setSkuCode(arguments.product.getProductCode() & "-#i#");
					for(var b=1; b <= listLen(arguments.data.subscriptionBenefits); b++) {
						thisSku.addSubscriptionBenefit( getSubscriptionService().getSubscriptionBenefit( listGetAt(arguments.data.subscriptionBenefits, b) ) );
					}
					for(var b=1; b <= listLen(arguments.data.renewalSubscriptionBenefits); b++) {
						thisSku.addRenewalSubscriptionBenefit( getSubscriptionService().getSubscriptionBenefit( listGetAt(arguments.data.renewalSubscriptionBenefits, b) ) );
					}
					if(i==1) {
						arguments.product.setDefaultSku( thisSku );
					}
				}
			}

		// Create Content Access Product Skus Based On Pages
		} else if (arguments.product.getProductType().getBaseProductType() == "contentAccess") {
			// Make sure there was at least one contentAccess Product
			if(!structKeyExists(arguments.data, "accessContents") || !listLen(arguments.data.accessContents)) {
				arguments.product.addError("accessContents", rbKey('validate.product.accesscontentsrequired'));
			}

			// If the product still doesn't have any errors then we can create the skus
			if(!arguments.product.hasErrors()) {
				if(structKeyExists(arguments.data, "bundleContentAccess") && arguments.data.bundleContentAccess) {
					var newSku = this.newSku();
					newSku.setPrice(arguments.data.price);
					newSku.setSkuCode(arguments.product.getProductCode() & "-1");
					newSku.setProduct(arguments.product);
					for(var c=1; c<=listLen(arguments.data.accessContents); c++) {
						newSku.addAccessContent( getContentService().getContent( listGetAt(arguments.data.accessContents, c) ) );
					}
					arguments.product.setDefaultSku(newSku);
				} else {
					for(var c=1; c<=listLen(arguments.data.accessContents); c++) {
						var newSku = this.newSku();
						newSku.setPrice(arguments.data.price);
						newSku.setSkuCode(arguments.product.getProductCode() & "-#c#");
						newSku.setProduct(arguments.product);
						newSku.addAccessContent( getContentService().getContent( listGetAt(arguments.data.accessContents, c) ) );
						if(c==1) {
							arguments.product.setDefaultSku(newSku);
						}
					}
				}
			}
		} else {
			throw("There was an unexpected error when creating this product");
		}

		return true;
	}

	// ===================  END: Deprecated Functions =========================

}

