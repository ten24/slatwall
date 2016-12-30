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
component extends="HibachiService" accessors="true" {

	// Slatwall Service Injection
	property name="productDAO" type="any";
	property name="skuDAO" type="any";
	property name="productTypeDAO" type="any";

	property name="hibachiDataService" type="any";
	property name="contentService" type="any";
	property name="eventRegistrationService" type="any";
	property name="imageService" type="any";
 	property name="hibachiEventService" type="any";
	property name="locationService" type="any";
	property name="optionService" type="any";
	property name="productScheduleService" type="any";
	property name="settingService" type="any";
	property name="skuService" type="any";
	property name="subscriptionService" type="any";
	property name="typeService" type="any";

	// ===================== START: Logical Methods ===========================

	public numeric function getProductRating(required any product){
		return getDao('productDao').getProductRating(arguments.product);
	}

	public void function loadDataFromFile(required string fileURL, string textQualifier = ""){
		getHibachiTagService().cfSetting(requesttimeout="3600");
		getProductDAO().loadDataFromFile(arguments.fileURL,arguments.textQualifier);
	}

	public any function getFormattedOptionGroups(required any product){
		var AvailableOptions={};

		productObjectGroups = arguments.product.getOptionGroups() ;

		for(i=1; i <= arrayLen(productObjectGroups); i++){
			AvailableOptions[productObjectGroups[i].getOptionGroupName()] = getOptionService().getOptionsForSelect(arguments.product.getOptionsByOptionGroup(productObjectGroups[i].getOptionGroupID()));
		}

		return AvailableOptions;
	}

	// @help Generates an event sku stub. Used to replace repetitive code.
	private any function createEventSkuOrSkus(required processObject, required startDateTime, required endDateTime, any productSchedule) {

		// Bundled location configuration
		if(arguments.processObject.getBundleLocationConfigurationFlag()) {

			var newSku = getSkuService().newSku();
			newSku.setProduct( arguments.processObject.getProduct() );
			newSku.setSkuCode( newSku.getProduct().getProductCode() & "-#newSku.getProduct().getNextSkuCodeCount()#");
			newSku.setSkuName( arguments.processObject.getSkuName() );
			newSku.setPrice( arguments.processObject.getPrice() );
			newSku.setEventStartDateTime( arguments.startDateTime );
			newSku.setEventEndDateTime( arguments.endDateTime );

			// Set default Sku if its not already set
			if( isNull( newSku.getProduct().getDefaultSku() ) ) {
				newSku.getProduct().setDefaultSku( newSku );
			}

			// Set publish flag based upon the response to sellIndividualSkuFlag
			if( !arguments.processObject.getSellIndividualSkuFlag() && arguments.processObject.getSchedulingType() == "recurring" ) {
				newSku.setPublishedFlag( false );
			}

			// Get the event capacity and
			var eventCapacity = 0;
			var preEventRegistrationMinutes = 0;
			var postEventRegistrationMinutes = 0;

			// Add location configurations
			for(var lc=1; lc<=listLen(arguments.processObject.getLocationConfigurations()); lc++) {

				var locationConfiguration = getLocationService().getLocationConfiguration( listGetAt(arguments.processObject.getLocationConfigurations(), lc) );
				eventCapacity += val(locationConfiguration.getLocationConfigurationCapacity());

				if(preEventRegistrationMinutes < locationConfiguration.setting('locationConfigurationAdditionalPreReservationTime')) {
					preEventRegistrationMinutes = locationConfiguration.setting('locationConfigurationAdditionalPreReservationTime');
				}
				if(postEventRegistrationMinutes < locationConfiguration.setting('locationConfigurationAdditionalPostReservationTime')){
					postEventRegistrationMinutes = locationConfiguration.setting('locationConfigurationAdditionalPostReservationTime');
				}

				newSku.addLocationConfiguration( locationConfiguration );
			}

			if(eventCapacity == 0 || isNull(eventCapacity)){
				eventCapacity = 1;
			}

			newSku.setEventCapacity( eventCapacity );

			var startResDateTime = arguments.startDateTime;
			var endResDateTime = arguments.endDateTime;
			if(isNumeric(preEventRegistrationMinutes) && preEventRegistrationMinutes gt 0) {
				startResDateTime = dateAdd("m", preEventRegistrationMinutes*-1, startResDateTime);
			}
			if(isNumeric(postEventRegistrationMinutes) && postEventRegistrationMinutes gt 0) {
				endResDateTime = dateAdd("m", postEventRegistrationMinutes, endResDateTime);
			}
			newSku.setStartReservationDateTime( startResDateTime );
			newSku.setEndReservationDateTime( endResDateTime );

			if(structKeyExists(arguments, "productSchedule")) {
				newSku.setProductSchedule( arguments.productSchedule );
			}

			newSku.generateAndSetAttendanceCode();
			
			this.saveSku(newSku);
			
		// Single location configuration
		} else {

			// For Every locationConfiguration, create a sku with the eventStartDateTime
			for(var lc=1; lc<=listLen(arguments.processObject.getLocationConfigurations()); lc++) {

				var locationConfiguration = getLocationService().getLocationConfiguration( listGetAt(arguments.processObject.getLocationConfigurations(), lc) );
				var newSku = getSkuService().newSku();
				newSku.setProduct( arguments.processObject.getProduct() );
				newSku.setSkuCode( newSku.getProduct().getProductCode() & "-#newSku.getProduct().getNextSkuCodeCount()#");
				newSku.setSkuName( arguments.processObject.getSkuName() );
				newSku.setPrice( arguments.processObject.getPrice() );
				newSku.setEventStartDateTime( createODBCDateTime(arguments.startDateTime) );
				newSku.setEventEndDateTime( createODBCDateTime(arguments.endDateTime) );

				newSku.addLocationConfiguration( locationConfiguration );
				if(!isNull(locationConfiguration.getLocationConfigurationCapacity()) && locationConfiguration.getLocationConfigurationCapacity() > 0 ){
					newSku.setEventCapacity( locationConfiguration.getLocationConfigurationCapacity() );
				} else {
					newSku.setEventCapacity(1);
				}


				// Set default Sku if its not already set
				if( isNull( newSku.getProduct().getDefaultSku() ) ) {
					newSku.getProduct().setDefaultSku( newSku );
				}

				// Set publish flag based upon the response to sellIndividualSkuFlag
				if( arguments.processObject.getSellIndividualSkuFlag() && arguments.processObject.getSchedulingType() == "recurring" ) {
					newSku.setPublishedFlag( true );
				}

				var startResDateTime = arguments.startDateTime;
				var endResDateTime = arguments.endDateTime;
				if(isNumeric(locationConfiguration.setting('locationConfigurationAdditionalPreReservationTime')) && locationConfiguration.setting('locationConfigurationAdditionalPreReservationTime') gt 0) {
					startResDateTime = dateAdd("m", locationConfiguration.setting('locationConfigurationAdditionalPreReservationTime')*-1, startResDateTime);
				}
				if(isNumeric(locationConfiguration.setting('locationConfigurationAdditionalPostReservationTime')) && locationConfiguration.setting('locationConfigurationAdditionalPostReservationTime') gt 0) {
					endResDateTime = dateAdd("m", locationConfiguration.setting('locationConfigurationAdditionalPostReservationTime'), endResDateTime);
				}
				newSku.setStartReservationDateTime( startResDateTime );
				newSku.setEndReservationDateTime( endResDateTime );

				if(structKeyExists(arguments, "productSchedule")) {
					newSku.setProductSchedule( arguments.productSchedule );
				}

				newSku.generateAndSetAttendanceCode();
				
				this.saveSku(newSku);
				
				if( newSku.hasErrors() ){
					break;
				}
			}
		}
		
		return newSku;
	}

	// @help Utilized by scheduled sku creation processes to create daily skus
	private any function createDailyScheduledSkus(required product, required processObject, required productSchedule) {

		// Set initial values for first iteration
		var newSkuStartDateTime = arguments.processObject.getEventStartDateTime();
		var newSkuEndDateTime = arguments.processObject.getEventEndDateTime();
		var latestSKu = '';

		// Create sku for every day from start date to end date
		do {

			latestSku = createEventSkuOrSkus( arguments.processObject, newSkuStartDateTime, newSkuEndDateTime, arguments.productSchedule);

			// Increment Start/End date time based on recurring time unit
			newSkuStartDateTime = dateAdd("d", 1, newSkuStartDateTime);
			newSkuEndDateTime = dateAdd("d", 1, newSkuEndDateTime);

		} while ( !latestSku.hasErrors() && newSkuStartDateTime < arguments.productSchedule.getScheduleEndDate() );
	
		if (latestSku.hasErrors()) {
			arguments.product.addErrors(latestSku.getErrors());
		}
			
		return arguments.product;
	}

	// @help Utilized by scheduled sku creation processes to create weekly skus
	private any function createWeeklyScheduledSkus(required product, required processObject, required productSchedule) {

		// Make sure days are in order
		arguments.processObject.setWeeklyRepeatDays(listSort(arguments.processObject.getWeeklyRepeatDays(),"numeric" ));
		arguments.productSchedule.setWeeklyRepeatDays( arguments.processObject.getWeeklyRepeatDays() );

		// Set initial values for first iteration
		var newSkuStartDateTime = arguments.processObject.getEventStartDateTime();
		var newSkuEndDateTime = arguments.processObject.getEventEndDateTime();
		var latestSku = '';

		var scheduleStartDay = dayOfWeek(arguments.processObject.getEventStartDateTime());
		var actualScheduleStartDay = scheduleStartDay;
		var offset = 0;

		// Default to day of start date, or 0 (start date doesn't match one of the selected days)
		var firstDaySelected = listFind(arguments.processObject.getWeeklyRepeatDays(),scheduleStartDay,",");

		// If start date doesn't match one of the selected days pick the closest future day that does
		if(firstDaySelected == 0) {

			// If first start day ends up being in the following week this calc will provide the days we have to add to get to it
			var offset = 7 - (scheduleStartDay - listGetAt(arguments.processObject.getWeeklyRepeatDays(),1,",")) ;

			// Calculate offset if first day occurrs in current week
			for(var i=1;i<=listLen(arguments.processObject.getWeeklyRepeatDays());i++) {
				currentDay = listGetAt(arguments.processObject.getWeeklyRepeatDays(),i);
				if( currentDay >= scheduleStartDay ) {
					offset = (currentDay - scheduleStartDay);
					break;
				}
			}

		}

		// Set initial values for first iteration
		newSkuStartDateTime = dateAdd("d",offset,newSkuStartDateTime);
		actualScheduleStartDay = dayOfWeek(newSkuStartDateTime);

		// Used to control sku creation days
		var dayListLength = listLen(arguments.processObject.getWeeklyRepeatDays());
		var cursorPosition = listFind(arguments.processObject.getWeeklyRepeatDays(),actualScheduleStartDay);
		var lastDay = 0;

		do {

			latestSku = createEventSkuOrSkus( arguments.processObject, newSkuStartDateTime, newSkuEndDateTime, arguments.productSchedule );

			// Increment Start/End date time based on recurring time unit
			newSkuStartDateTime = nextScheduleDate(arguments.processObject.getWeeklyRepeatDays(),newSkuStartDateTime,cursorPosition);
			newSkuEndDateTime = nextScheduleDate(arguments.processObject.getWeeklyRepeatDays(),newSkuEndDateTime,cursorPosition);

			if(cursorPosition == listLen(arguments.processObject.getWeeklyRepeatDays())) {
				cursorPosition = 1;
			} else {
				cursorPosition++;
			}

		} while ( !latestSku.hasErrors() && newSkuStartDateTime < arguments.productSchedule.getScheduleEndDate() );
		
		if (latestSku.hasErrors()) {
			arguments.product.addErrors(latestSku.getErrors());
		}
			
		return arguments.product;
	}

	// @help Utilized by scheduled sku creation processes to create monthly skus
	private any function createMonthlyScheduledSkus(required product, required processObject, required productSchedule) {

		arguments.productSchedule.setMonthlyRepeatByType( arguments.processObject.getMonthlyRepeatByType() );

		// Set initial values for first iteration
		var newSkuStartDateTime = arguments.processObject.getEventStartDateTime();
		var newSkuEndDateTime = arguments.processObject.getEventEndDateTime();
		var latestSku = '';
		
		var nextMonth = month(arguments.processObject.getEventStartDateTime());
		var nextYear = year(arguments.processObject.getEventStartDateTime());
		var monthDay = 0;

		if(arguments.processObject.getMonthlyRepeatByType() == "dayOfWeek") {
			// Day of week value that event starts on
			var repeatDay = dayOfWeek(arguments.processObject.getEventStartDateTime());
			productSchedule.getWeeklyRepeatDays(repeatDay);

			// Week of the month in which the day occurs
			var dayInstance = ceiling(day(arguments.processObject.getEventStartDateTime())/7);
		} else {
			productSchedule.getWeeklyRepeatDays(day(arguments.processObject.getEventStartDateTime()));
		}

		do {

			latestSku = createEventSkuOrSkus( arguments.processObject, newSkuStartDateTime, newSkuEndDateTime, arguments.productSchedule );

			// Increment Start/End date time based on monthly repeatBy value
			if(arguments.processObject.getMonthlyRepeatByType() == "dayOfWeek") {
				//Day of week
				if(month(newSkuStartDateTime) == 12) {
					nextMonth = 1;
					nextYear = year(newSkuStartDateTime)+1;
				} else {
					nextMonth = month(newSkuStartDateTime)+1;
				}
				monthDay = getProductScheduleService().getNthOccOfDayInMonth(dayInstance,repeatDay,nextMonth,nextYear);
				// Set next start date in a temporary var so we can use it in a calculation with the original
				var nextStartDateTime = createDateTime(nextYear,nextMonth,monthDay,hour(newSkuStartDateTime),minute(newSkuStartDateTime),0);
				// Calc day difference between last and next startdate and apply it to the end date
				var theDateDiff = dateDiff("d",newSkuStartDateTime,nextStartDateTime);
				newSkuEndDateTime = dateAdd("d",theDateDiff,newSkuEndDateTime);
				newSkuStartDateTime = nextStartDateTime;
			} else {
				// Day of month
				newSkuStartDateTime = dateAdd("m",1,newSkuStartDateTime);
				newSkuEndDateTime = dateAdd("m",1,newSkuEndDateTime);
			}

		} while ( !latestSku.hasErrors() && newSkuStartDateTime < productSchedule.getscheduleEndDate() );

		if (latestSku.hasErrors()) {
			arguments.product.addErrors(latestSku.getErrors());
		}
			
		return arguments.product;
	}

	// @help Utilized by scheduled sku creation processes to create yearly skus
	private any function createYearlyScheduledSkus(required product, required processObject, required productSchedule) {

		// Set initial values for first iteration
		var newSkuStartDateTime = arguments.processObject.getEventStartDateTime();
		var newSkuEndDateTime = arguments.processObject.getEventEndDateTime();

		var nextYear = year(arguments.processObject.getEventStartDateTime());

		do {

			latestSku = createEventSkuOrSkus( arguments.processObject, newSkuStartDateTime, newSkuEndDateTime, arguments.productSchedule );

			newSkuStartDateTime = dateAdd("yyyy",1,newSkuStartDateTime);
			newSkuEndDateTime = dateAdd("yyyy",1,newSkuEndDateTime);

		} while ( !latestSku.hasErrors() && newSkuStartDateTime < productSchedule.getscheduleEndDate() );
		
		if (latestSku.hasErrors()) {
			arguments.product.addErrors(latestSku.getErrors());
		}
			
 		return arguments.product;
	}

	// Create new incremented datetime based on recurring type (daily, weekly, monthly, etc.)
	private any function incrementDateTimeByRecurringTypeID(string recurringTypeID, string dateToIncrement) {
		var result = "";

		if(arguments.recurringTypeID == getTypeService().getTypeBySystemCode("rtuDaily").getTypeID()) {
			result = dateAdd( "d", 1, arguments.dateToIncrement );
		}
		else if(arguments.recurringTypeID == getTypeService().getTypeBySystemCode("rtuWeekdays").getTypeID()) {
			result = dateAdd( "w" ,1, arguments.dateToIncrement );
		}
		else if(arguments.recurringTypeID == getTypeService().getTypeBySystemCode("rtuWeekly").getTypeID()) {
			result = dateAdd( "ww", 1, arguments.dateToIncrement );
		}
		else if(arguments.recurringTypeID == getTypeService().getTypeBySystemCode("rtuMonthly").getTypeID()) {
			result = dateAdd( "m", 1, arguments.dateToIncrement );
		}
		else if(arguments.recurringTypeID == getTypeService().getTypeBySystemCode("rtuYearly").getTypeID()) {
			result = dateAdd( "yyyy", 1, arguments.dateToIncrement );
		}

		return result;

	}

	// @help Used when creating product schedule skus to calc next date
	private any function nextScheduleDate(required dayList,required instanceDateTime,required cursorPosition) {
		var result = instanceDateTime;
		var oldDay = dayOfWeek(instanceDateTime);
		if(cursorPosition == listLen(dayList)) {
			// if starting list over...
			nextDay = listGetAt(dayList,1,",");
			result = dateAdd("d",(7 - (oldDay - nextDay)),instanceDateTime);
		} else {
			nextDay = listGetAt(dayList,cursorPosition+1,",");
			result = dateAdd("d",(nextDay - oldDay),instanceDateTime);
		}
		return result;
	}


	// =====================  END: Logical Methods ============================

	// ===================== START: DAO Passthrough ===========================

	public any function getProductSkusBySelectedOptions(required string selectedOptions, required string productID){
		return getSkuDAO().getSkusBySelectedOptions( argumentCollection=arguments );
	}

	// ===================== START: DAO Passthrough ===========================

	// ===================== START: Process Methods ===========================

	// Process: Product
	public any function processProduct_addOptionGroup(required any product, required any processObject) {
		getOptionService().addOptionGroupByOptionGroupIDAndProductID(arguments.processObject.getOptionGroup(),arguments.product.getProductID());

		return arguments.product;
	}

	public any function processProduct_addOption(required any product, required any processObject) {

		var newOptionsData = {
			options = arguments.processObject.getOptions(),
			price = arguments.product.getDefaultSku().getPrice()
		};

		if(!isNull(arguments.product.getDefaultSku().getListPrice())) {
			newOptionsData.listPrice = arguments.product.getDefaultSku().getListPrice();
		}

		getSkuService().createSkus(arguments.product, newOptionsData);

		return arguments.product;
	}

	public any function processProduct_addProductReview(required any product, required any processObject) {
		// Check if the review should be automatically approved
		if(arguments.product.setting('productAutoApproveReviewsFlag')) {
			arguments.processObject.getNewProductReview().setActiveFlag(1);
		} else {
			arguments.processObject.getNewProductReview().setActiveFlag(0);
		}

		// Check to see if there is a current user logged in, if so attach to this review
		if(getHibachiScope().getLoggedInFlag()) {
			arguments.processObject.getNewProductReview().setAccount( getHibachiScope().getAccount() );
		}

		return arguments.product;
	}

	public any function processProduct_addEventSchedule(required any product, required any processObject) {

		// Single event instance (non-recurring)
		if(arguments.processObject.getSchedulingType() == "once" ) {

			// Create one sku
			createEventSkuOrSkus(arguments.processObject, arguments.processObject.getEventStartDateTime(), arguments.processObject.getEventEndDateTime());

		// Recurring schedule is specified for event
		} else if( arguments.processObject.getSchedulingType() == "recurring" ) {

			//Create new product schedule
			var newProductSchedule = this.newProductSchedule();

			// How frequently will event occur (Daily, Weekly, etc.)?
			newProductSchedule.setRecurringTimeUnit( arguments.processObject.getRecurringTimeUnit() );

			// Set schedule start/end dates
			newProductSchedule.setScheduleEndDate(createDateTime(year(arguments.processObject.getScheduleEndDate()),month(arguments.processObject.getScheduleEndDate()),day(arguments.processObject.getScheduleEndDate()),23,59,59));

			// Set product association
			newProductSchedule.setProduct( arguments.product );

			// Create a list of all existing  skus in the product
			var existingSkuIDList = "";

			for(var sku in product.getSkus()) {
				existingSkuIDList = listAppend(existingSkuIDList,sku.getSkuID());
			}

			// DAILY
			if( arguments.processObject.getRecurringTimeUnit() == "Daily" ) {
				arguments.product = createDailyScheduledSkus(arguments.product, arguments.processObject, newProductSchedule);

			// WEEKLY
			} else if( arguments.processObject.getRecurringTimeUnit() == "Weekly" ) {
				arguments.product = createWeeklyScheduledSkus(arguments.product, arguments.processObject, newProductSchedule);

			// MONTHLY
			} else if( arguments.processObject.getRecurringTimeUnit() == "Monthly" ) {
				arguments.product = createMonthlyScheduledSkus(arguments.product, arguments.processObject, newProductSchedule);

			// YEARLY
			} else if( arguments.processObject.getrecurringTimeUnit() == "Yearly" ) {
				arguments.product = createYearlyScheduledSkus(arguments.product, arguments.processObject, newProductSchedule);
			}
			
			if (!arguments.product.hasErrors()){

				// Persist new product schedule
				newProductSchedule = getProductScheduleService().saveProductSchedule( newProductSchedule );
	
				// Create a sku bundle for all the skus in the schedule based on response to createBundleFlag
				if( arguments.processObject.getCreateBundleFlag() ) {
					var skus = "";
	
					for(var sku in product.getSkus()) {
						if(!sku.getBundleFlag() && !listFindNoCase(existingSkuIDList,sku.getSkuID())){
							skus = listAppend(skus, sku.getSkuID());
						}
					}
	
					// Set up new bundle data
					var newBundleData = {
						skuCode = "#product.getProductCode()#-#product.getNextSkuCodeCount()#",
						price = 0,
						skus = skus
					};
	
					// Bundle newly created skus
					product = this.processProduct( product, newBundleData, 'addSkuBundle' );
				}
			}
		}

		// Return the product
		return arguments.product;
	}

	public any function processProduct_addSkuBundle(required any product, required any processObject) {
		// Create a new sku object
		var newSku = getSkuService().newSku();

		// Setup the sku
		newSku.setProduct( arguments.product );
		newSku.setSkuName( arguments.processObject.getSkuName() );
		newSku.setSkuCode( arguments.processObject.getSkuCode() );
		newSku.setPrice( arguments.processObject.getPrice() );
		newSku.setBundleFlag( true );

  		if(listLen( arguments.processObject.getSkus() )) {
  			var skuArray = listToArray( arguments.processObject.getSkus() );

  			// Setup additional data for event product
  			if(arguments.product.getBaseProductType() == "event") {
				var capacities = "";
				var preEventRegistrationMinutes = 0;
				var postEventRegistrationMinutes = 0;

				for(var i=1; i<=arrayLen(skuArray); i++) {

					capacities =  listAppend(capacities, getSkuService().getSku( skuArray[i] ).getEventCapacity());

					for(var locationConfiguration in getSkuService().getSku( skuArray[i] ).getLocationConfigurations()) {

						if(preEventRegistrationMinutes < locationConfiguration.setting('locationConfigurationAdditionalPreReservationTime')) {
							preEventRegistrationMinutes = locationConfiguration.setting('locationConfigurationAdditionalPreReservationTime');
						}
						if(postEventRegistrationMinutes < locationConfiguration.setting('locationConfigurationAdditionalPostReservationTime')){
							postEventRegistrationMinutes = locationConfiguration.setting('locationConfigurationAdditionalPostReservationTime');
						}

						newSku.addLocationConfiguration( locationConfiguration );
					}
				}

				// Calculating pre and post reservation times (setup / teardown)
				var startResDateTime = getSkuService().getSku( skuArray[1] ).getEventStartDateTime();
				var endResDateTime = getSkuService().getSku( skuArray[arrayLen(skuArray)] ).getEventEndDateTime();

				if(isNumeric(preEventRegistrationMinutes) && preEventRegistrationMinutes gt 0) {
					startResDateTime = dateAdd("m", preEventRegistrationMinutes*-1, startResDateTime);
				}
				if(isNumeric(postEventRegistrationMinutes) && postEventRegistrationMinutes gt 0) {
					endResDateTime = dateAdd("m", postEventRegistrationMinutes, endResDateTime);
				}
				
				newSku.setSkuName( arguments.processObject.getSkuName() );
				newSku.setStartReservationDateTime( startResDateTime );
				newSku.setEndReservationDateTime( endResDateTime );
				newSku.setEventStartDateTime( getSkuService().getSku( skuArray[1] ).getEventStartDateTime() );
				newSku.setEventEndDateTime( getSkuService().getSku( skuArray[arrayLen(skuArray)] ).getEventEndDateTime() );
				newSku.generateAndSetAttendanceCode();
  				newSku.setEventCapacity( arrayMax(listToArray(capacities)) );

  			}
  		}

		// Persist the new sku
		newSku = getSkuService().saveSku( newSku );

		if(arrayLen(skuArray)) {

			// Loop over skus from the process object and create entries for sku bundles
			for(var i=1; i<=arrayLen(skuArray); i++) {

				// Create a new sku bundle
				var skubundle = getSkuService().newSkuBundle();

				skuBundle.setSku( newSku );
				skuBundle.setBundledSku( getSkuService().getSku( skuArray[i] ) );
				skuBundle.setBundledQuantity(1);

				// Persist the new sku bundle
				skuBundle = getSkuService().saveSkuBundle( skuBundle );
			}
		}

		// Return the product
		return arguments.product;
	}



	public any function processProduct_addSku(required any product, required any processObject, any data) {
		var sku = getSkuService().saveSku(arguments.processObject.getNewSku());

		sku.setImageFile(sku.generateImageFileName());

		if (arguments.processObject.getNewSku().hasErrors()) {
			arguments.product.addErrors(arguments.processObject.getNewSku().getErrors());
		}

		return arguments.product;
	}

	public any function processProduct_addSubscriptionSku(required any product, required any processObject) {

		var newSubscriptionTerm = getSubscriptionService().getSubscriptionTerm( arguments.processObject.getSubscriptionTermID() );
		var newSku = getSkuService().newSku();


		newSku.setPrice( arguments.processObject.getPrice() );
		newSku.setRenewalPrice( arguments.processObject.getRenewalPrice() );
		if( !isNull(arguments.processObject.getListPrice()) && isNumeric( arguments.processObject.getListPrice() )) {
			newSku.setListPrice( arguments.processObject.getListPrice() );
		}
		newSku.setSkuCode( arguments.product.getProductCode() & "-#arrayLen(arguments.product.getSkus()) + 1#");
		newSku.setSubscriptionTerm( newSubscriptionTerm );
		for(var b=1; b <= listLen( arguments.processObject.getSubscriptionBenefits() ); b++) {
			newSku.addSubscriptionBenefit( getSubscriptionService().getSubscriptionBenefit( listGetAt(arguments.processObject.getSubscriptionBenefits(), b) ) );
		}
		for(var b=1; b <= listLen( arguments.processObject.getRenewalSubscriptionBenefits() ); b++) {
			newSku.addRenewalSubscriptionBenefit( getSubscriptionService().getSubscriptionBenefit( listGetAt(arguments.processObject.getRenewalSubscriptionBenefits(), b) ) );
		}
		newSku.setProduct( arguments.product );
		newSku.setRenewalSku( arguments.processObject.getRenewalSku());
		newSku.setImageFile( newSku.generateImageFileName() );

		return arguments.product;
	}

    private void function setListPriceOnSkuByProductAndProcessObject(required any sku, required any product, required any processObject){
		var listPrice = arguments.processObject.getListPrice(); 

        if(isNull(listPrice) || !isNumeric(listPrice) || listPrice == 0){
            listPrice = arguments.product.getListPrice(); 
        }

		if(!isNull(listPrice) && isNumeric(listPrice) && listPrice > 0) {
			arguments.sku.setListPrice(listPrice);
		}
	} 

	public any function createSingleSku(required any product, required any processObject){

		var thisSku = this.newSku();

		thisSku.setProduct(arguments.product);
		thisSku.setPrice(arguments.processObject.getPrice());
		thisSku.setImageFile(thisSku.generateImageFileName());

        setListPriceOnSkuByProductAndProcessObject(thisSku, arguments.product, arguments.processObject);

		thisSku.setSkuCode(arguments.product.getProductCode() & "-1");
		arguments.product.setDefaultSku( thisSku );
		return arguments.product;
	}

	public any function createGiftCardProduct(required any product, required any processObject){

		arguments.product = createSingleSku(arguments.product,arguments.processObject);
		arguments.product.getDefaultSku().setRedemptionAmountType(arguments.processObject.getRedemptionAmountType());
		arguments.product.getDefaultSku().setRedemptionAmount(arguments.processObject.getRedemptionAmount());
		if(!isNull(arguments.processObject.getGiftCardExpirationTermID())){
			var giftCardExpirationTerm = this.getTerm(arguments.processObject.getGiftCardExpirationTermID());
			arguments.product.getDefaultSku().setGiftCardExpirationTerm(giftCardExpirationTerm);
		}
		return arguments.product;
	}

	public any function processProduct_create(required any product, required any processObject) {

		// GENERATE - CONTENT ACCESS SKUS
		if(arguments.processObject.getGenerateSkusFlag() && arguments.processObject.getBaseProductType() == "contentAccess") {

			// Bundle Content Into A Single Sku
			if( !isNull(arguments.processObject.getBundleContentAccessFlag()) && arguments.processObject.getBundleContentAccessFlag() ) {

				var newSku = this.newSku();
				newSku.setPrice(arguments.processObject.getPrice());
				newSku.setSkuCode(arguments.product.getProductCode() & "-1");
				newSku.setProduct(arguments.product);
				newSku.setImageFile(newSku.generateImageFileName());

				for(var c=1; c<=listLen(arguments.processObject.getContents()); c++) {
					newSku.addAccessContent( getContentService().getContent( listGetAt(arguments.processObject.getContents(), c) ) );
				}
				product.setDefaultSku(newSku);

			// Create Sku for each piece of Content
			} else {

				for(var c=1; c<=listLen(arguments.processObject.getContents()); c++) {
					var newSku = this.newSku();
					newSku.setPrice(arguments.processObject.getPrice());
					newSku.setListPrice(arguments.processObject.getListPrice()); 
					newSku.setSkuCode(arguments.product.getProductCode() & "-#c#");
					newSku.setProduct(arguments.product);
					newSku.setImageFile(newSku.generateImageFileName());

					newSku.addAccessContent( getContentService().getContent( listGetAt(arguments.processObject.getContents(), c) ) );
					if(c==1) {
						arguments.product.setDefaultSku(newSku);
					}
				}

			}

		// GENERATE - EVENT SKUS
		} else if (arguments.processObject.getGenerateSkusFlag() && arguments.processObject.getBaseProductType() == "event") {

			arguments.product = this.processProduct(arguments.product, arguments.data, 'addEventSchedule');


		// GENERATE - MERCHANDISE SKUS
		} else if(arguments.processObject.getGenerateSkusFlag() && arguments.processObject.getBaseProductType() == "merchandise") {

			// If options were passed in create multiple skus
			if(!isNull(arguments.processObject.getOptions()) && len(arguments.processObject.getOptions())) {

				var optionGroups = {};
				var totalCombos = 1;
				var indexedKeys = [];
				var currentIndexesByKey = {};
				var keyToChange = "";

				// Loop over all the options to put them into a struct by groupID
				for(var i=1; i<=listLen(arguments.processObject.getOptions()); i++) {
					var option = getOptionService().getOption( listGetAt(arguments.processObject.getOptions(), i) );
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
					newSku.setPrice(arguments.processObject.getPrice());
                    setListPriceOnSkuByProductAndProcessObject(newSku, arguments.product, arguments.processObject);
					newSku.setSkuCode(product.getProductCode() & "-#arrayLen(product.getSkus()) + 1#");

					// Add the Sku to the product, and if the product doesn't have a default, then also set as default
					arguments.product.addSku(newSku);
					if(isNull(arguments.product.getDefaultSku())) {
						arguments.product.setDefaultSku(newSku);
					}

					// Add each of the options
					for(var key in optionGroups) {
						newSku.addOption( optionGroups[key][ currentIndexesByKey[key] ]);
					}

					newSku.setImageFile(newSku.generateImageFileName());

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

				arguments.product = createSingleSku(arguments.product, arguments.processObject);

			}

		// GENERATE - SUBSCRIPTION SKUS
		} else if (arguments.processObject.getGenerateSkusFlag() && arguments.processObject.getBaseProductType() == "subscription") {

			for(var i=1; i <= listLen(arguments.processObject.getSubscriptionTerms()); i++){
				var thisSku = this.newSku();
				thisSku.setProduct(arguments.product);
				thisSku.setPrice(arguments.processObject.getPrice());
				if(!isNull(arguments.processObject.getRenewalPrice())){
					thisSku.setRenewalPrice(arguments.processObject.getRenewalPrice());
				}
				thisSku.setSubscriptionTerm( getSubscriptionService().getSubscriptionTerm(listGetAt(arguments.processObject.getSubscriptionTerms(), i)) );
				thisSku.setSkuCode(product.getProductCode() & "-#i#");
				thisSku.setRenewalSku(arguments.processObject.getRenewalSku());
				for(var b=1; b <= listLen(arguments.processObject.getSubscriptionBenefits()); b++) {
					thisSku.addSubscriptionBenefit( getSubscriptionService().getSubscriptionBenefit( listGetAt(arguments.processObject.getSubscriptionBenefits(), b) ) );
				}
				for(var b=1; b <= listLen(arguments.processObject.getRenewalSubscriptionBenefits()); b++) {
					thisSku.addRenewalSubscriptionBenefit( getSubscriptionService().getSubscriptionBenefit( listGetAt(arguments.processObject.getRenewalSubscriptionBenefits(), b) ) );
				}
				if(i==1) {
					arguments.product.setDefaultSku( thisSku );
					arguments.product.setRenewalSku( arguments.processObject.getRenewalSku() );

				}
				thisSku.setImageFile(thisSku.generateImageFileName());
			}
		//GENERATE - GIFT SKUS
		}else if(arguments.processObject.getBaseProductType() == 'gift-card'){
			arguments.product = createGiftCardProduct(arguments.product,arguments.processObject);
		}

		// Generate the URL Title
		arguments.product.setURLTitle( getHibachiUtilityService().createUniqueURLTitle(titleString=arguments.product.getTitle(), tableName="SwProduct") );

		// If some skus were created, then set the default sku to the first one
		if(arrayLen(arguments.product.getSkus())) {
			arguments.product.setDefaultSku( arguments.product.getSkus()[1] );
		}

		// Call save on the product
		arguments.product = this.saveProduct(arguments.product);

        // Return the product
		return arguments.product;
	}

	//routed from processProduct_create
	public any function processProduct_createBundle(required any product, required any processObject, any data){
		arguments.product.getSkus()[1].setSkuCode(arguments.product.getProductCode() & "-1");

		// If some skus were created, then set the default sku to the first one
		if(arrayLen(arguments.product.getSkus())) {
			arguments.product.setDefaultSku( arguments.product.getSkus()[1] );
		}

		arguments.product.setURLTitle( getHibachiUtilityService().createUniqueURLTitle(titleString=arguments.product.getTitle(), tableName="SwProduct") );

		arguments.product.getSkus()[1].setImageFile(sku.generateImageFileName());

		arguments.product = this.saveProduct(arguments.product);


		return arguments.product;
	}

	public any function processProduct_deleteDefaultImage(required any product, required struct data) {
		if(structKeyExists(arguments.data, "imageFile")) {
			if(fileExists(getHibachiScope().setting('globalAssetsImageFolderPath') & '/product/default/#imageFile#')) {
				fileDelete(getHibachiScope().setting('globalAssetsImageFolderPath') & '/product/default/#imageFile#');
			}
		}

		return arguments.product;
	}

	public any function processProduct_updateDefaultImageFileNames( required any product ) {

		for(var sku in arguments.product.getSkus()) {
				var name = sku.generateImageFileName();
				var uploadDirectory = getHibachiScope().setting('globalAssetsImageFolderPath') & "/product/default";
				var fullFilePath = "#uploadDirectory#/#sku.getImageFile()#";
				var newPath = "#uploadDirectory#/#name#";

				if(!directoryExists(uploadDirectory)) {
					directoryCreate(uploadDirectory);
				}

				if(fileExists(fullFilePath) && !fileExists(newPath)){
					fileMove(fullFilePath, newPath);
				}

				sku.setImageFile(name);
		}

		return arguments.product;
	}

	public any function processProduct_updateSkus(required any product, required any processObject) {

		var skus = 	arguments.product.getSkus();
		var skuCurrencyFound=false;
		if(arrayLen(skus)){
			for(var i=1; i <= arrayLen(skus); i++){
				// Update Price
				if(arguments.processObject.getUpdatePriceFlag()) {
					skus[i].setPrice(arguments.processObject.getPrice());
				}
				// Update List Price
				if(arguments.processObject.getUpdateListPriceFlag()) {
					skus[i].setListPrice(arguments.processObject.getListPrice());
				}

				//Update currencies
				for(var processSkuCurrency in processObject.getSkuCurrencies()){
					skuCurrencyFound=false;
					skuCurrenciesToRemove=[];

					for(var skuCurrency in skus[i].getSkuCurrencies()){
						if(processSkuCurrency.currencyCode eq skuCurrency.getCurrencyCode()){
							if(len(processSkuCurrency.price) && arguments.processObject.getUpdatePriceFlag()){
								skuCurrency.setPrice(processSkuCurrency.price);
							}
							if(len(processSkuCurrency.listprice) && arguments.processObject.getUpdateListPriceFlag()){
								skuCurrency.setListPrice(processSkuCurrency.listPrice);
							}

							if(!len(processSkuCurrency.listprice) && arguments.processObject.getUpdateListPriceFlag() && !len(processSkuCurrency.price) && arguments.processObject.getUpdatePriceFlag()){
								arrayAppend(skuCurrenciesToRemove,skuCurrency);
							}

						 skuCurrencyFound=true;
						}
					}
					for(var j=1; j <= arrayLen(skuCurrenciesToRemove); j++){
						skuCurrenciesToRemove[j].removeSku(skus[i]);
					}
					if(!skuCurrencyFound && ((len(processSkuCurrency.price) && arguments.processObject.getUpdatePriceFlag()) || (len(processSkuCurrency.listPrice) && arguments.processObject.getUpdateListPriceFlag())) ){
						var newSkuCurrency=this.newSkuCurrency();
						newSkuCurrency.setCurrency(getService('currencyService').getCurrencyByCurrencyCode(processSkuCurrency.currencyCode));
						if(arguments.processObject.getUpdatePriceFlag()) {
							newSkuCurrency.setPrice(processSkuCurrency.price);
						}
						if(arguments.processObject.getUpdateListPriceFlag()) {
							newSkuCurrency.setPrice(processSkuCurrency.listPrice);
						}
						newSkuCurrency.setSku(skus[i]);
						save(newSkuCurrency);

					}
				}

			}
		}

		return arguments.product;
	}

	public any function processProduct_uploadDefaultImage(required any product, required any processObject) {
		// Wrap in try/catch to add validation error based on fileAcceptMIMEType
		try {

			// Get the upload directory for the current property
			var uploadDirectory = getHibachiScope().setting('globalAssetsImageFolderPath') & "/product/default";
			var fullFilePath = "#uploadDirectory#/#arguments.processObject.getImageFile()#";

			// If the directory where this file is going doesn't exists, then create it
			if(!directoryExists(uploadDirectory)) {
				directoryCreate(uploadDirectory);
			}

			// Do the upload, and then move it to the new location
			var uploadData = fileUpload( getHibachiTempDirectory(), 'uploadFile', arguments.processObject.getPropertyMetaData('uploadFile').hb_fileAcceptMIMEType, 'makeUnique' );
			fileMove("#getHibachiTempDirectory()#/#uploadData.serverFile#", fullFilePath);

		} catch(any e) {
			processObject.addError('imageFile', getHibachiScope().rbKey('validate.fileUpload'));
		}

		return arguments.product;
	}


	// =====================  END: Process Methods ============================

	// ====================== START: Save Overrides ===========================

	public any function saveProduct(required any product, struct data={}){

		var previousActiveFlag = arguments.product.getActiveFlag();

		if( (isNull(arguments.product.getURLTitle()) || !len(arguments.product.getURLTitle())) && (!structKeyExists(arguments.data, "urlTitle") || !len(arguments.data.urlTitle)) ) {
			if(structKeyExists(arguments.data, "productName") && len(arguments.data.productName)) {
				data.urlTitle = getHibachiUtilityService().createUniqueURLTitle(titleString=arguments.data.productName, tableName="SwProduct");
			} else if (!isNull(arguments.product.getProductName()) && len(arguments.product.getProductName())) {
				data.urlTitle = getHibachiUtilityService().createUniqueURLTitle(titleString=arguments.product.getProductName(), tableName="SwProduct");
			}
		}

		arguments.product = super.save(arguments.product, arguments.data);
		// Set default sku if no default sku was set
		if(isNull(arguments.product.getDefaultSku()) && arrayLen(arguments.product.getSkus())){
			arguments.product.setDefaultSku(arguments.product.getSkus()[1]);
		}
		if(isNull(arguments.product.getURLTitle())){
			arguments.product.setURLTitle( getHibachiUtilityService().createUniqueURLTitle(titleString=arguments.product.getTitle(), tableName="SwProduct") );
		}
		// Generate Image Files
		if(!isNull(arguments.product.getDefaultSku()) && isNull(arguments.product.getDefaultSku().getImageFile())){
			arguments.product.getDefaultSku().setImageFile( arguments.product.getDefaultSku().generateImageFileName() );
		}
		if(!arguments.product.hasErrors()){
			//if we just set an active product from active to inactive them make all skus inactive
			if(!arguments.product.isNew() && previousActiveFlag == 1 && arguments.product.getActiveFlag() == 0){
				getDao('productDao').setSkusAsInactiveByProduct(arguments.product);
				arguments.product.setPublishedFlag(false);
			}
		}
		return arguments.product;
	}

	public any function saveProductType(required any productType, struct data={}) {
		if( (isNull(arguments.productType.getURLTitle()) || !len(arguments.productType.getURLTitle())) && (!structKeyExists(arguments.data, "urlTitle") || !len(arguments.data.urlTitle)) ) {
			if(structKeyExists(arguments.data, "productTypeName") && len(arguments.data.productTypeName)) {
				data.urlTitle = getHibachiUtilityService().createUniqueURLTitle(titleString=arguments.data.productTypeName, tableName="SwProductType");
			} else if (!isNull(arguments.productType.getProductTypeName()) && len(arguments.productType.getProductTypeName())) {
				data.urlTitle = getHibachiUtilityService().createUniqueURLTitle(titleString=arguments.productType.getProductTypeName(), tableName="SwProductType");
			}
		}

		arguments.productType = super.save(arguments.productType, arguments.data);

		// if this type has a parent, inherit all products that were assigned to that parent
		if(!arguments.productType.hasErrors() && !isNull(arguments.productType.getParentProductType()) and arrayLen(arguments.productType.getParentProductType().getProducts())) {
			ormFlush();
			getProductDAO().updateProductProductType( arguments.productType.getParentProductType().getProductTypeID(), arguments.productType.getProductTypeID() );
		}

		return arguments.productType;
	}
	
	public any function saveProductReview(required any productReview, struct data={}){
		arguments.productReview = super.save(arguments.productReview, arguments.data);	
		
		if(!arguments.productReview.hasErrors()){
			getHibachiScope().addModifiedEntity(arguments.productReview.getProduct());
		}
		
		return arguments.productReview;
		
	}

	// ======================  END: Save Overrides ============================

	// ====================== START: Delete Overrides =========================

	public boolean function deleteProduct(required any product) {

		// Check delete validation
		if(arguments.product.isDeletable()) {

			// Remove the primary fields so that we can delete this entity
			arguments.product.setDefaultSku(javaCast("null", ""));

			// Remove the product relationships
			getProductDAO().removeProductFromRelatedProducts( arguments.product.getProductID() );


		}

		return delete( arguments.product );
	}

	// ======================  END: Delete Overrides ==========================

	// ==================== START: Smart List Overrides =======================

	public any function getProductSmartList(struct data={}, currentURL="") {
		arguments.entityName = "SlatwallProduct";

		var smartList = getHibachiDAO().getSmartList(argumentCollection=arguments);

		smartList.joinRelatedProperty("SlatwallProduct", "productType");
		smartList.joinRelatedProperty("SlatwallProduct", "defaultSku");
		smartList.joinRelatedProperty("SlatwallProduct", "brand", "left");

		smartList.addKeywordProperty(propertyIdentifier="calculatedTitle", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="brand.brandName", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="productName", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="productCode", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="productType.productTypeName", weight=1);

		return smartList;
	}

	public any function getProductCollectionList(struct data={}, currentURL="") {
		arguments.entityName = "Product";
		var collectionList = getHibachiDAO().getCollectionList(argumentCollection=arguments);
		return collectionList;
	}

	// ====================  END: Smart List Overrides ========================

	//  ====================  START: Wrapper Methods ========================

	public any function getResizedImageByProfileName(required any skuIDList="", any profileName="") {
		return this.getImageService().getResizedImageByProfileName(arguments.skuIDList,arguments.profileName);
	}

	//  ====================  END: Wrapper Methods ========================

	// ====================== START: Get Overrides ============================

	// ======================  END: Get Overrides =============================

	// ====================== START: Private Helper ===========================

	// ======================  END: Private Helper ============================

}

