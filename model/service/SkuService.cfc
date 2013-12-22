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
		eventRegistration.setEventRegistrationStatusType(getSettingService().getTypeBySystemCode("erstPending"));
		if(arguments.sku.getAvailableSeatCount > 0 ) {
			eventRegistration.setEventRegistrationStatusType(getSettingService().getTypeBySystemCode("erstRegistered"));
		} else {
			eventRegistration.setEventRegistrationStatusType(getSettingService().getTypeBySystemCode("erstWaitlisted"));
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
		else if(arguments.processObject.getEditScope() == "single" || isNull(arguments.sku.getProductSchedule()) ){
			arguments.sku.setAllowEventWaitlistingFlag(arguments.processObject.getAllowEventWaitlistingFlag());
			arguments.sku.setEventCapacity(arguments.processObject.getEventCapacity());
		} else if(arguments.processObject.getEditScope() == "all"){
			for(var thisSku in arguments.sku.getProductSchedule().getSkus()) {
				thisSku.setAllowEventWaitlistingFlag(arguments.processObject.getAllowEventWaitlistingFlag());
				thisSku.setEventCapacity(arguments.processObject.getEventCapacity());
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
				sku.removeLocationConfiguration( thisLocationConfig );
			}
			// Remove this sku from product schedule
			if(!isNull(arguments.sku.getProductSchedule())) {
				arguments.sku.setProductSchedule(javaCast("null", ""));
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
			
			if(locationConflictExistsFlag(arguments.sku,arguments.processObject.getEventStartDateTime(),arguments.processObject.getEventEndDateTime(),arguments.processObject.getLocationConfigurations())) {
				// There is already an event scheduled at that location in the same date range
				processObject.addError('locationConfigurations', getHibachiScope().rbKey('validate.eventScheduleConflict'));
			} else {

				// Update schedule dates/times
				arguments.sku.setEventStartDateTime(arguments.processObject.getEventStartDateTime());
				arguments.sku.setEventEndDateTime(arguments.processObject.getEventEndDateTime());
				arguments.sku.setStartReservationDateTime(arguments.processObject.getStartReservationDateTime());
				arguments.sku.setEndReservationDateTime(arguments.processObject.getEndReservationDateTime());

				// Remove deleted location configurations
				for(var locationConfig in arguments.sku.getLocationConfigurations()) {
					var lcExistsAt = listFindNoCase(arguments.processObject.getLocationConfigurations(),locationConfig.getLocationConfigurationID(),"," );
					if(lcExistsAt == 0) {
						getDAO("SkuDAO").deleteSkuLocationConfiguration(arguments.sku.getSkuID(), locationConfig.getLocationConfigurationID());
					} else {
						// remove existing location configurations from processObject so we don't add them again
						arguments.processObject.setLocationConfigurations(listDeleteAt(arguments.processObject.getLocationConfigurations(),lcExistsAt));
					}
				}
				
				// Update/add locations
				var newConfigCount = listLen(arguments.processObject.getLocationConfigurations(),",");
				if(newConfigCount > 0) {
					// Add new location configurations
					for(var lc=1; lc<=newConfigCount; lc++) {
						var thisLocationConfig = getLocationService().getLocationConfiguration( listGetAt(arguments.processObject.getLocationConfigurations(), lc) );
						arguments.sku.addLocationConfiguration( thisLocationConfig );
					}
				}
				
				// Disconnect this sku from any recurring schedule
				arguments.sku.setProductSchedule(javaCast("null",""));
			}
			
		
		} else if(arguments.processObject.getEditScope() == "all"){
			for(var thisSku in arguments.sku.getProductSchedule().getSkus()) {
				var lcList = arguments.processObject.getLocationConfigurations();
				if(thisSku.geteventStartDateTime() > now()) {
					var newEventStartDateTime = createDateTime(year(thisSku.getEventStartDateTime()),month(thisSku.getEventStartDateTime()),day(thisSku.getEventStartDateTime()),hour(arguments.processObject.getEventStartTime()),minute(arguments.processObject.getEventStartTime()),0);
					var newEventEndDateTime = createDateTime(year(thisSku.getEventEndDateTime()),month(thisSku.getEventEndDateTime()),day(thisSku.getEventEndDateTime()),hour(arguments.processObject.getEventEndTime()),minute(arguments.processObject.getEventEndTime()),0);
					var newReservationStartDateTime = createDateTime(year(thisSku.getStartReservationDateTime()),month(thisSku.getStartReservationDateTime()),day(thisSku.getStartReservationDateTime()),hour(arguments.processObject.getReservationStartTime()),minute(arguments.processObject.getReservationStartTime()),0);
					var newReservationEndDateTime = createDateTime(year(thisSku.getEndReservationDateTime()),month(thisSku.getEndReservationDateTime()),day(thisSku.getEndReservationDateTime()),hour(arguments.processObject.getReservationEndTime()),minute(arguments.processObject.getReservationEndTime()),0);
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
	public boolean function locationConflictExistsFlag(any sku, any eventStartDateTime, any eventEndDateTime, any locationConfigurations) {
		var locationIDList = "";
		var result = false;

		//Build list of locationIDs from locationConfigurations
		if(listLen(arguments.locationConfigurations,",") == 1) {
			var locationConfigurationSmartList = getService("LocationConfigurationService").getLocationConfigurationSmartList();
			locationConfigurationSmartList.addFilter("locationConfigurationID",arguments.locationConfigurations);
			var locationID = locationConfigurationSmartList.getRecords()[1].getLocation().getLocationID();
			locationIDList = listAppend(locationIDList,locationID);
		} else {
			locationConfigs = listToArray(arguments.locationConfigurations);
			for(var configID in locationConfigs) {
				var locationConfigurationSmartList = getService("SkuService").getLocationConfigurationSmartList();
				locationConfigurationSmartList.addFilter("locationConfigurationID",configID);
				var locationID = locationConfigurationSmartList.getRecords()[1].getLocation().getLocationID();
				if(!listFindNoCase(locationIDList,locationID)) {
					listAppend(locationIDList,locationID);
				}
			} 
		}
		
		// Build smartlist of conflicting events schedules
		var smartlist = getService("SkuService").getSkuSmartList();
		smartlist.joinRelatedProperty("SlatwallSku", "locationConfigurations", "left");
		smartlist.joinRelatedProperty("SlatwallLocationConfiguration", "location", "left");
		smartlist.addWhereCondition("aslatwalllocation.locationID IN (:lcIDs)",{lcIDs=locationIDList});
		smartlist.addWhereCondition("aslatwallsku.skuID <> :thisSkuID",{thisSkuID=arguments.sku.getSkuID()});
		smartlist.addWhereCondition("aslatwallsku.eventStartDateTime < :thisEndDateTime",{thisEndDateTime=arguments.eventEndDateTime});
		smartlist.addWhereCondition("aslatwallsku.eventEndDateTime > :thisStartDateTime",{thisStartDateTime=arguments.eventStartDateTime});

		// Do we have conflicts?
		if(smartList.getRecordsCount() > 0) {
			result = true;
		}
		
		return result;
		
	}
	
	// TODO [paul]: makeup / breakup
	public any function processSku_MakeupBundledSkus(required any sku, required any processObject) {
		
		// Create a stockAdjustment
		var stockAdjustment = getStockService().newStockAdjustment();
		stockAdjustment.setStockAdjustmentType( getSettingService().getTypeBySystemCode('satMakeupBundledSkus') ); 
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
		stockAdjustment.setStockAdjustmentType( getSettingService().getTypeBySystemCode('satBreakupBundledSkus') ); 
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
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Status Methods ===========================
	
	// ======================  END: Status Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	public any function getSkuSmartList(struct data={}, currentURL="") {
		arguments.entityName = "SlatwallSku";
		
		var smartList = getSkuDAO().getSmartList(argumentCollection=arguments);
		
		smartList.joinRelatedProperty("SlatwallSku", "product");
		smartList.joinRelatedProperty("SlatwallProduct", "productType");
		smartList.joinRelatedProperty("SlatwallSku", "alternateSkuCodes", "left");
		
		smartList.addKeywordProperty(propertyIdentifier="skuCode", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="skuID", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="product.productName", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="product.productType.productTypeName", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="alternateSkuCodes.alternateSkuCode", weight=1);
				
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
		
		// Get skus that have datetimes that overlap with current sku
		var skuSmartList = getService("SkuService").getSkuSmartList();
		//skuSmartList.addWhereCondition("aslatwallsku.skuID <> :thisSkuID",{thisSkuID=sku.getSkuID()});
		skuSmartList.addWhereCondition("aslatwallsku.eventStartDateTime < :thisEndDateTime",{thisEndDateTime=arguments.eventEndDateTime});
		skuSmartList.addWhereCondition("aslatwallsku.eventEndDateTime > :thisStartDateTime",{thisStartDateTime=arguments.eventStartDateTime});
		
		// Build list of unavailable locations from sku list
		var concurrentSkus = skuSmartList.getRecords();
		for( var thisSku in concurrentSkus ) {
			if(arrayLen(thisSku.getLocationConfigurations())) {
				for( var thisLocation in thisSku.getLocations()) {
					if(listFind(arguments.unavailableLocationsList,thisLocation.getLocationID()) == 0) {
						if(listLen(arguments.unavailableLocationsList)) {
							arguments.unavailableLocationsList = listAppend(arguments.unavailableLocationsList,thisLocation.getLocationID() );
						} else {
							arguments.unavailableLocationsList = thisLocation.getLocationID();
						}
					}
				}
			}
		}
		
		arguments.unavailableLocationsList = listQualify(unavailableLocationsList,"'",",","char" );
		
		// Get non-conflicting location configurations
		var availableLocationsSmartList = getService("LocationConfigurationService").getLocationConfigurationSmartList();
		//availableLocationsSmartList.addKeywordProperty(propertyIdentifier="locationCapacity", weight=1);
		
		if(listLen(arguments.unavailableLocationsList) > 0) {
			availableLocationsSmartList.addWhereCondition("aslatwalllocationconfiguration.location.locationID NOT IN (#arguments.unavailableLocationsList#)");
		}
		availableLocationsSmartList.addWhereCondition("aslatwalllocationconfiguration.locationConfigurationCapacity >= #arguments.quantity#");
		
		return availableLocationsSmartList;

	}
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================

}

