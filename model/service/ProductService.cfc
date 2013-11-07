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
	
	property name="dataService" type="any";  
	property name="contentService" type="any";
	property name="locationService" type="any";
	property name="productScheduleService" type="any";
	property name="settingService" type="any";
	property name="skuService" type="any";
	property name="subscriptionService" type="any";
	property name="optionService" type="any";
	
	
	// ===================== START: Logical Methods ===========================
	
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
	
	private any function buildSkuCombinations(Array storage, numeric position, any data, String currentOption){
		var keys = StructKeyList(arguments.data);
		var i = 1;
		
		if(listlen(keys)){
			for(i=1; i<= arrayLen(arguments.data[listGetAt(keys,position)]); i++){
				if(arguments.position eq listlen(keys)){
					arrayAppend(arguments.storage,arguments.currentOption & '|' & arguments.data[listGetAt(keys,position)][i].value) ;
				}else{
					arguments.storage = buildSkuCombinations(arguments.storage,arguments.position + 1, arguments.data, arguments.currentOption & '|' & arguments.data[listGetAt(keys,position)][i].value);
				}
			}
		}
		
		return arguments.storage;
	}
	
	
	// Generates an event sku stub. Used to replace repetitive code.
	private any function createEventSkuStub(required processObject, required startDate, required endDate, required qualifier, required locationConfiguration) {
		var newSku = this.newSku();
		var preEventRegistrationMinutes = getLocationService().getLocationConfiguration( locationConfiguration ).setting('locationConfigurationAdditionalPreReservationTime');
		var postEventRegistrationMinutes = getLocationService().getLocationConfiguration( locationConfiguration ).setting('locationConfigurationAdditionalPostReservationTime');
		newSku.setProduct( arguments.processObject.getproduct() );
		newSku.setSkuCode( arguments.processObject.getproduct().getProductCode() & "-#arguments.qualifier#");
		newSku.setPrice( arguments.processObject.getPrice() );
		newSku.setEventStartDateTime( arguments.startDate );
		newSku.setEventEndDateTime( arguments.endDate );
		newSku.setstartReservationDateTime( dateAdd("n",(preEventRegistrationMinutes*-1),arguments.startDate) );
		newSku.setendReservationDateTime( dateAdd("n",postEventRegistrationMinutes,arguments.endDate) );				
		return newSku;
	}
	
	
	// Returns the highest sku code qualifier of a product's skus
	private string function getMaxSkuQualifier(required array skus) {
		var result = 0;
		for(var sku in arguments.skus) {
			var qualifier = listlast(sku.getSkuCode(),"-");
			if(isDefined("qualifier") && isNumeric(qualifier) && qualifier > result) {
				result = qualifier;
			}
		}
		writeLog(file="slatwall",text="Q: #result#");
		return result;
	}
	
	// Create new incremented datetime based on recurring type (daily, weekly, monthly, etc.)
	private any function incrementDateTimeByRecurringTypeID(string recurringTypeID, string dateToIncrement) {
		var result = "";

		if(arguments.recurringTypeID == getSettingService().getTypeBySystemCode("rtuDaily").getTypeID()) {
			result = dateAdd( "d", 1, arguments.dateToIncrement );
		}
		else if(arguments.recurringTypeID == getSettingService().getTypeBySystemCode("rtuWeekdays").getTypeID()) {
			result = dateAdd( "w" ,1, arguments.dateToIncrement );
		}
		else if(arguments.recurringTypeID == getSettingService().getTypeBySystemCode("rtuWeekly").getTypeID()) {
			result = dateAdd( "ww", 1, arguments.dateToIncrement );
		}
		else if(arguments.recurringTypeID == getSettingService().getTypeBySystemCode("rtuMonthly").getTypeID()) {
			result = dateAdd( "m", 1, arguments.dateToIncrement );
		}
		else if(arguments.recurringTypeID == getSettingService().getTypeBySystemCode("rtuYearly").getTypeID()) {
			result = dateAdd( "yyyy", 1, arguments.dateToIncrement );
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
		var skus = 	arguments.product.getSkus();
		var options = getOptionService().getOptionGroup(arguments.processObject.getOptionGroup()).getOptions();
		
		if(arrayLen(options)){
			for(i=1; i <= arrayLen(skus); i++){
				skus[i].addOption(options[1]);
			}
		}
		
		arguments.product = this.processProduct(arguments.product, {}, 'updateDefaultImageFileNames');
		
		return arguments.product;
	}
	
	public any function processProduct_addOption(required any product, required any processObject) {
		
		var newOption = getOptionService().getOption(arguments.processObject.getOption());
		var newOptionsData = {
			options = newOption.getOptionID(),
			price = arguments.product.getDefaultSku().getPrice()
		};
		if(!isNull(arguments.product.getDefaultSku().getListPrice())) {
			newOptionsData.listPrice = arguments.product.getDefaultSku().getListPrice();
		}
		
		// Loop over each of the existing skus
		for(var s=1; s<=arrayLen(arguments.product.getSkus()); s++) {
			// Loop over each of the existing options for those skus
			for(var o=1; o<=arrayLen(arguments.product.getSkus()[s].getOptions()); o++) {
				// If this option is not of the same option group, and it isn't already in the list, then we can add it to the list
				if(arguments.product.getSkus()[s].getOptions()[o].getOptionGroup().getOptionGroupID() != newOption.getOptionGroup().getOptionGroupID() && !listFindNoCase(newOptionsData.options, arguments.product.getSkus()[s].getOptions()[o].getOptionID())) {
					newOptionsData.options = listAppend(newOptionsData.options, arguments.product.getSkus()[s].getOptions()[o].getOptionID());
				}
			}
		}
		
		getSkuService().createSkus(arguments.product, newOptionsData);
		
		arguments.product = this.processProduct(arguments.product, {}, 'updateDefaultImageFileNames');
		
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
		
		// Single or recurring?
		var schedulingType = getSettingService().getTypeByTypeID(arguments.processObject.getSchedulingType());
		
		//Create new product schedule
		var newProductSchedule = this.newProductSchedule();
		newProductSchedule.setSchedulingType( schedulingType );
		
		var SkusToCreate = 1;
		
		// Generate next highest sku qualifier
		var SkuQualifier = getMaxSkuQualifier(arguments.product.getSkus()) + 1; 
		
		// Set date and time for first sku
		var newSkuStartDateTime = arguments.processObject.getEventStartDateTime();
		var newSkuEndDateTime = arguments.processObject.getEventEndDateTime();
		
		// Single event instance (non-recurring)
		if(arguments.processObject.getSchedulingType() == getSettingService().getTypeBySystemCode("schSingle").getTypeID() ) {
			// For Every locationConfiguration, create a sku with the eventStartDateTime
			for(var lc=1; lc<=listLen(arguments.processObject.getLocationConfigurations()); lc++) {
				var newSku = createEventSkuStub(arguments.processObject,newSkuStartDateTime,newSkuEndDateTime,SkuQualifier,listGetAt(arguments.processObject.getLocationConfigurations(), lc));
				skuQualifier++;
				newSku.addLocationConfiguration( getLocationService().getLocationConfiguration( listGetAt(arguments.processObject.getLocationConfigurations(), lc) ) );
			}
		}
		
		
		// Recurring schedule is specified for event
		else if(arguments.processObject.getSchedulingType() == getSettingService().getTypeBySystemCode("schRecurring").getTypeID()) {
			
			// How frequently will event occur (Daily, Weekly, etc.)?
			newProductSchedule.setrecurringTimeUnit(getSettingService().getTypeByTypeID(arguments.processObject.getrecurringTimeUnit())); 
			// Is end type based on occurrences or date?
			newProductSchedule.setscheduleEndType(getSettingService().getTypeByTypeID(arguments.processObject.getscheduleEndType()));
			
			// Schedule ends based on occurrences
			if(arguments.processObject.getScheduleEndType() == getSettingService().getTypeBySystemCode("setOccurrences").getTypeID()) {
				newProductSchedule.setScheduleEndOccurrences(arguments.processObject.getScheduleEndOccurrences());
				SkusToCreate = arguments.processObject.getScheduleEndOccurrences();
				
				//Create SKU(s) for every occurrence
				for(var i=1;i<=SkusToCreate;i++) {
					
					// For Every locationConfiguration, create a sku with the eventStartDateTime
					for(var lc=1; lc<=listLen(arguments.processObject.getLocationConfigurations()); lc++) {
						var newSku = createEventSkuStub(arguments.processObject,newSkuStartDateTime,newSkuEndDateTime,SkuQualifier,listGetAt(arguments.processObject.getLocationConfigurations(), lc));
						newSku.setProductSchedule(newProductSchedule); 
						skuQualifier++;
						newSku.addLocationConfiguration( getLocationService().getLocationConfiguration( listGetAt(arguments.processObject.getLocationConfigurations(), lc) ) );
						
						// Increment Start/End date time based on recurring time unit
						newSkuStartDateTime = incrementDateTimeByRecurringTypeID(arguments.processObject.getrecurringTimeUnit(),newSkuStartDateTime);
						newSkuEndDateTime = incrementDateTimeByRecurringTypeID(arguments.processObject.getrecurringTimeUnit(),newSkuEndDateTime);
						
					}
					
				}
			}
			
			else 
			// Schedule ends based on date
			{
				newProductSchedule.setScheduleEndDate(arguments.processObject.getScheduleEndDate());
				
				do {
					
					// For Every locationConfiguration, create a sku with the eventStartDateTime
					for(var lc=1; lc<=listLen(arguments.processObject.getLocationConfigurations()); lc++) {
						var newSku = createEventSkuStub(arguments.processObject,newSkuStartDateTime,newSkuEndDateTime,SkuQualifier,listGetAt(arguments.processObject.getLocationConfigurations(), lc));
						newSku.setProductSchedule(newProductSchedule); 
						skuQualifier++;
						newSku.addLocationConfiguration( getLocationService().getLocationConfiguration( listGetAt(arguments.processObject.getLocationConfigurations(), lc) ) );
					}
					
					// Increment Start/End date time based on recurring time unit
					newSkuStartDateTime = incrementDateTimeByRecurringTypeID(arguments.processObject.getrecurringTimeUnit(),newSkuStartDateTime);
					newSkuEndDateTime = incrementDateTimeByRecurringTypeID(arguments.processObject.getrecurringTimeUnit(),newSkuEndDateTime);
					
						
				} while ( newSkuEndDateTime < arguments.processObject.getscheduleEndDate() );
				
			}
			
		}
		
		//Persist new product schedule
		getProductScheduleService().saveProductSchedule( newProductSchedule );
		
		// Generate Image Files
		arguments.product = this.processProduct(arguments.product, {}, 'updateDefaultImageFileNames');
        
        // validate the product
		arguments.product.validate( context="save" );
		
		// If the product passed validation then call save in the DAO, otherwise set the errors flag
        if(!product.hasErrors()) {
        		arguments.product = getHibachiDAO().save(target=arguments.product);
        }
		
		// Return the product
		return arguments.product;
	}
	
	public any function processProduct_addSkuBundle(required any product, required any processObject) {
		// Create a new sku object
		var newSku = getSkuService().newSku();
		
		// Setup the sku
		newSku.setProduct( arguments.product );
		newSku.setSkuCode( arguments.processObject.getSkuCode() );
		newSku.setPrice( arguments.processObject.getPrice() );
		newSku.setBundleFlag( true );

		// Persist the new sku
		newSku = getSkuService().saveSku( newSku );
		
		if(listLen( arguments.processObject.getSkus() )) {
			var skuArray = listToArray( arguments.processObject.getSkus() );
			
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
		
		arguments.product = this.processProduct(arguments.product, {}, 'updateDefaultImageFileNames');
		
		return arguments.product;
	}
	
	public any function processProduct_create(required any product, required any processObject) {
		if(isNull(arguments.product.getURLTitle())) {
			arguments.product.setURLTitle(getDataService().createUniqueURLTitle(titleString=arguments.product.getTitle(), tableName="SwProduct"));
		}
		
		// Create Merchandise Product Skus Based On Options
		if(arguments.processObject.getBaseProductType() == "merchandise") {
			
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
				

				// ==============================================
				// BEGIN MERCHANDISE SKU GENERATION (OPTIONS)
				// ==============================================
				if(arguments.processObject.getGenerateSkusFlag() == 1) {
					// Create a sku with 1 option from each group, and then update the indexes properly for the next loop
					for(var i = 1; i<=totalCombos; i++) {
						
						// Setup the New Sku
						var newSku = this.newSku();
						newSku.setPrice(arguments.processObject.getPrice());
						if(isNumeric(arguments.product.getlistPrice()) && arguments.product.getlistPrice() > 0) {
							newSku.setListPrice(arguments.product.getlistPrice());	
						}
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
				}
				// ==============================================
				// END MERCHANDISE SKU GENERATION (OPTIONS)
				// ==============================================
				
			// If no options were passed in we will just create a single sku
			} else {
				// ==============================================
				// BEGIN MERCHANDISE SKU GENERATION (NO OPTIONS)
				// ==============================================
				if(arguments.processObject.getGenerateSkusFlag() == 1) {
					var thisSku = this.newSku();
					thisSku.setProduct(arguments.product);
					thisSku.setPrice(arguments.processObject.getPrice()); 
					if(isNumeric(arguments.product.getlistPrice()) && arguments.product.getlistPrice() > 0) {
						thisSku.setListPrice(arguments.product.getlistPrice());	
					}
					thisSku.setSkuCode(arguments.product.getProductCode() & "-1");
					arguments.product.setDefaultSku( thisSku );
				}
				// ==============================================
				// END MERCHANDISE SKU GENERATION (NO OPTIONS)
				// ==============================================
				
			}
			
		// Create Subscription Product Skus Based On SubscriptionTerm and SubscriptionBenifit
		} else if (arguments.processObject.getBaseProductType() == "subscription") {
			
			// ===================================
			// BEGIN SUBSCRIPTION SKU GENERATION
			// ===================================
			if(arguments.processObject.getGenerateSkusFlag() == 1) {
				for(var i=1; i <= listLen(arguments.processObject.getSubscriptionTerms()); i++){
					var thisSku = this.newSku();
					thisSku.setProduct(arguments.product);
					thisSku.setPrice(arguments.processObject.getPrice());
					thisSku.setRenewalPrice(arguments.processObject.getPrice());
					thisSku.setSubscriptionTerm( getSubscriptionService().getSubscriptionTerm(listGetAt(arguments.processObject.getSubscriptionTerms(), i)) );
					thisSku.setSkuCode(product.getProductCode() & "-#arrayLen(product.getSkus()) + 1#");
					for(var b=1; b <= listLen(arguments.processObject.subscriptionBenefits); b++) {
						thisSku.addSubscriptionBenefit( getSubscriptionService().getSubscriptionBenefit( listGetAt(arguments.processObject.subscriptionBenefits, b) ) );
					}
					for(var b=1; b <= listLen(arguments.processObject.renewalSubscriptionBenefits); b++) {
						thisSku.addRenewalSubscriptionBenefit( getSubscriptionService().getSubscriptionBenefit( listGetAt(arguments.processObject.renewalSubscriptionBenefits, b) ) );
					}
					if(i==1) {
						product.setDefaultSku( thisSku );	
					}
				}
			}
			
			// ===================================
			// END SUBSCRIPTION GENERATION
			// ===================================
			
			
		// Create Content Access Product Skus Based On Pages
		} else if (arguments.processObject.getBaseProductType() == "contentAccess") {
			
			// ===================================
			// BEGIN CONTENT ACCESS SKU GENERATION
			// ===================================
				
			if(arguments.processObject.getGenerateSkusFlag() == 1) {
			
				if(structKeyExists(arguments.processObject, "bundleContentAccess") && arguments.processObject.bundleContentAccess) {
					var newSku = this.newSku();
					newSku.setPrice(arguments.processObject.getPrice());
					newSku.setSkuCode(arguments.product.getProductCode() & "-1");
					newSku.setProduct(arguments.product);
					for(var c=1; c<=listLen(arguments.processObject.accessContents); c++) {
						newSku.addAccessContent( getContentService().getContent( listGetAt(arguments.processObject.accessContents, c) ) );
					}
					product.setDefaultSku(newSku);
				} else {
					for(var c=1; c<=listLen(arguments.processObject.accessContents); c++) {
						var newSku = this.newSku();
						newSku.setPrice(arguments.product.getPrice());
						newSku.setSkuCode(arguments.product.getProductCode() & "-#c#");
						newSku.setProduct(arguments.product);
						newSku.addAccessContent( getContentService().getContent( listGetAt(arguments.processObject.accessContents, c) ) );
						if(c==1) {
							arguments.product.setDefaultSku(newSku);	
						}
					}
				}
			
			}
			
			// ===================================
			// END CONTENT ACCESS SKU GENERATION
			// ===================================
			
			
			
		} else if (arguments.processObject.getBaseProductType() == "event") {
			
			// ===================================
			// BEGIN EVENT SKU GENERATION
			// ===================================
				
			if(arguments.processObject.getGenerateSkusFlag() == 1) {
				// Single or recurring?
				var schedulingType = getSettingService().getTypeByTypeID(arguments.processObject.getSchedulingType());
				
				//Create new product schedule
				var newProductSchedule = this.newProductSchedule();
				newProductSchedule.setSchedulingType( schedulingType );
				
				var SkusToCreate = 1; // Increments with each new sku
				var isFirstSku = true; // Used to set default sku
				var SkuQualifier = 1; // Gets incremented and appended to each sku to make unique
				
				// Set date and time for first sku
				var newSkuStartDateTime = arguments.processObject.getEventStartDateTime();
				var newSkuEndDateTime = arguments.processObject.getEventEndDateTime();
				
				// Single event instance (non-recurring)
				if(arguments.processObject.getSchedulingType() == getSettingService().getTypeBySystemCode("schSingle").getTypeID() ) {
					
					// Bundled location configuration
					if(arguments.processObject.getBundleLocationConfigurationFlag()) {
						var newSku = createEventSkuStub(arguments.processObject,newSkuStartDateTime,newSkuEndDateTime,SkuQualifier,listGetAt(arguments.processObject.getLocationConfigurations(), 1));
						// Add location configurations
						for(var lc=1; lc<=listLen(arguments.processObject.getLocationConfigurations()); lc++) {
							newSku.addLocationConfiguration( getLocationService().getLocationConfiguration( listGetAt(arguments.processObject.getLocationConfigurations(), lc) ) );
						}
						// Set first as default sku
						if(isFirstSku) {
							arguments.product.setDefaultSku( newSku );	
							isFirstSku = false;
						}
					}
					
					// Single location configuration
					else {
						// For Every locationConfiguration, create a sku with the eventStartDateTime
						for(var lc=1; lc<=listLen(arguments.processObject.getLocationConfigurations()); lc++) {
							var newSku = createEventSkuStub(arguments.processObject,newSkuStartDateTime,newSkuEndDateTime,SkuQualifier,listGetAt(arguments.processObject.getLocationConfigurations(), lc));
							skuQualifier++;
							newSku.addLocationConfiguration( getLocationService().getLocationConfiguration( listGetAt(arguments.processObject.getLocationConfigurations(), lc) ) );
							
							// Set first as default sku
							if(isFirstSku) {
								arguments.product.setDefaultSku( newSku );	
								isFirstSku = false;
							}
						}
					}
				}
				
				
				// Recurring schedule is specified for event
				else if(arguments.processObject.getSchedulingType() == getSettingService().getTypeBySystemCode("schRecurring").getTypeID()) {
					
					// How frequently will event occur (Daily, Weekly, etc.)?
					newProductSchedule.setrecurringTimeUnit(getSettingService().getTypeByTypeID(arguments.processObject.getrecurringTimeUnit())); 
					
					// Is end type based on occurrences or date?
					newProductSchedule.setscheduleEndType(getSettingService().getTypeByTypeID(arguments.processObject.getscheduleEndType()));
					
					// Schedule ends based on occurrences
					if(arguments.processObject.getScheduleEndType() == getSettingService().getTypeBySystemCode("setOccurrences").getTypeID()) {
						newProductSchedule.setScheduleEndOccurrences(arguments.processObject.getScheduleEndOccurrences());
						SkusToCreate = arguments.processObject.getScheduleEndOccurrences();
						
						//Create SKU(s) for every occurrence
						for(var i=1;i<=SkusToCreate;i++) {
						
							// Bundled location configuration
							if(arguments.processObject.getBundleLocationConfigurationFlag()) {
								var newSku = createEventSkuStub(arguments.processObject,newSkuStartDateTime,newSkuEndDateTime,SkuQualifier,listGetAt(arguments.processObject.getLocationConfigurations(), 1)); 
								newSku.setProductSchedule(newProductSchedule); 
								skuQualifier++;
								// Add location configurations
								for(var lc=1; lc<=listLen(arguments.processObject.getLocationConfigurations()); lc++) {
									newSku.addLocationConfiguration( getLocationService().getLocationConfiguration( listGetAt(arguments.processObject.getLocationConfigurations(), lc) ) );
								}
								// Set first as default sku
								if(isFirstSku) {
									arguments.product.setDefaultSku( newSku );	
									isFirstSku = false;
								}
							}
							
							// Single location configuration
							else {
								// For Every locationConfiguration, create a sku with the eventStartDateTime
								for(var lc=1; lc<=listLen(arguments.processObject.getLocationConfigurations()); lc++) {
									var newSku = createEventSkuStub(arguments.processObject,newSkuStartDateTime,newSkuEndDateTime,SkuQualifier,listGetAt(arguments.processObject.getLocationConfigurations(), lc));
									newSku.setProductSchedule(newProductSchedule); 
									skuQualifier++;
									newSku.addLocationConfiguration( getLocationService().getLocationConfiguration( listGetAt(arguments.processObject.getLocationConfigurations(), lc) ) );
									
									// Set first as default sku
									if(isFirstSku) {
										arguments.product.setDefaultSku( newSku );	
										isFirstSku = false;
									}
								}
							}
							
							// Increment Start/End date time based on recurring time unit
							newSkuStartDateTime = incrementDateTimeByRecurringTypeID(arguments.processObject.getrecurringTimeUnit(),newSkuStartDateTime);
							newSkuEndDateTime = incrementDateTimeByRecurringTypeID(arguments.processObject.getrecurringTimeUnit(),newSkuEndDateTime);
							
						} // End sku creation
						
						
					} // End schedule based on occurrences
					
					else 
					// Schedule ends based on date
					{
						newProductSchedule.setScheduleEndDate(arguments.processObject.getScheduleEndDate());
						
						do {
							// Bundled location configuration
							if(arguments.processObject.getBundleLocationConfigurationFlag()) {
								var newSku = createEventSkuStub(arguments.processObject,newSkuStartDateTime,newSkuEndDateTime,SkuQualifier,listGetAt(arguments.processObject.getLocationConfigurations(), 1)); 
								newSku.setProductSchedule(newProductSchedule); 
								skuQualifier++;
								// Add location configurations
								for(var lc=1; lc<=listLen(arguments.processObject.getLocationConfigurations()); lc++) {
									newSku.addLocationConfiguration( getLocationService().getLocationConfiguration( listGetAt(arguments.processObject.getLocationConfigurations(), lc) ) );
								}
								// Set first as default sku
								if(isFirstSku) {
									arguments.product.setDefaultSku( newSku );	
									isFirstSku = false;
								}
							} 
							
							// Single location configuration
							else {
								// For Every locationConfiguration, create a sku with the eventStartDateTime
								for(var lc=1; lc<=listLen(arguments.processObject.getLocationConfigurations()); lc++) {
									var newSku = createEventSkuStub(arguments.processObject,newSkuStartDateTime,newSkuEndDateTime,SkuQualifier,listGetAt(arguments.processObject.getLocationConfigurations(), lc));
									newSku.setProductSchedule(newProductSchedule); 
									skuQualifier++;
									newSku.addLocationConfiguration( getLocationService().getLocationConfiguration( listGetAt(arguments.processObject.getLocationConfigurations(), lc) ) );
									
									// Set first as default sku
									if(isFirstSku) {
										arguments.product.setDefaultSku( newSku );	
										isFirstSku = false;
									}
								}
							}
							
							// Increment Start/End date time based on recurring time unit
							newSkuStartDateTime = incrementDateTimeByRecurringTypeID(arguments.processObject.getrecurringTimeUnit(),newSkuStartDateTime);
							newSkuEndDateTime = incrementDateTimeByRecurringTypeID(arguments.processObject.getrecurringTimeUnit(),newSkuEndDateTime);
							
								
						} while ( newSkuEndDateTime < arguments.processObject.getscheduleEndDate() );
						
					} // End schedule ends based on date
					
				}
			
				//Persist new product schedule
				getProductScheduleService().saveProductSchedule( newProductSchedule );
			}
				
			// ===================================
			// END EVENT SKU GENERATION
			// ===================================
					
		} else {
			throw("There was an unexpected error when creating this product");
		}
		
		
		
		// Generate Image Files
		arguments.product = this.processProduct(arguments.product, {}, 'updateDefaultImageFileNames');
		//arguments.product = this.saveProduct(arguments.product,arguments.processObject.getProductProperties());
        
        // validate the product
		arguments.product.validate( context="save" );
		
		// If the product passed validation then call save in the DAO, otherwise set the errors flag
        if(!product.hasErrors()) {
        		arguments.product = getHibachiDAO().save(target=arguments.product);
        }
        
        // Return the product
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
			sku.setImageFile( sku.generateImageFileName() );
		}
		
		return arguments.product;
	}
	
	public any function processProduct_updateSkus(required any product, required any processObject) {

		var skus = 	arguments.product.getSkus();
		if(arrayLen(skus)){
			for(i=1; i <= arrayLen(skus); i++){
				// Update Price
				if(arguments.processObject.getUpdatePriceFlag()) {
					skus[i].setPrice(arguments.processObject.getPrice());	
				}
				// Update List Price
				if(arguments.processObject.getUpdateListPriceFlag()) {
					skus[i].setListPrice(arguments.processObject.getListPrice());	
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
	
	public any function saveProduct(required any product, required struct data) {
		
		// populate bean from values in the data Struct
		arguments.product.populate(arguments.data);
		
		if(isNull(arguments.product.getURLTitle())) {
			arguments.product.setURLTitle(getDataService().createUniqueURLTitle(titleString=arguments.product.getTitle(), tableName="SwProduct"));
		}
		
		// validate the product
		arguments.product.validate( context="save" );
		
		// If the product passed validation then call save in the DAO, otherwise set the errors flag
        if(!arguments.product.hasErrors()) {
        		arguments.product = getHibachiDAO().save(target=arguments.product);
        }
        
        // Return the product
		return arguments.product;
	}
	
	public any function saveProductType(required any productType, required struct data) {
		if( (isNull(arguments.productType.getURLTitle()) || !len(arguments.productType.getURLTitle())) && (!structKeyExists(arguments.data, "urlTitle") || !len(arguments.data.urlTitle)) ) {
			if(structKeyExists(arguments.data, "productTypeName") && len(arguments.data.productTypeName)) {
				data.urlTitle = getDataService().createUniqueURLTitle(titleString=arguments.data.productTypeName, tableName="SwProductType");	
			} else if (!isNull(arguments.productType.getProductTypeName()) && len(arguments.productType.getProductTypeName())) {
				data.urlTitle = getDataService().createUniqueURLTitle(titleString=arguments.productType.getProductTypeName(), tableName="SwProductType");
			}
		}
		
		arguments.productType = super.save(arguments.productType, arguments.data);

		// if this type has a parent, inherit all products that were assigned to that parent
		if(!arguments.productType.hasErrors() && !isNull(arguments.productType.getParentProductType()) and arrayLen(arguments.productType.getParentProductType().getProducts())) {
			arguments.productType.setProducts(arguments.productType.getParentProductType().getProducts());
		}
		
		return arguments.productType;
	}
	
	// ======================  END: Save Overrides ============================
	
	// ====================== START: Delete Overrides =========================
	
	public boolean function deleteProduct(required any product) {
	
		// Set the default sku temporarily in this local so we can reset if delete fails
		var defaultSku = arguments.product.getDefaultSku();
		
		// Remove the default sku so that we can delete this entity
		arguments.product.setDefaultSku(javaCast("null", ""));
	
		// Use the base delete method to check validation
		var deleteOK = super.delete(arguments.product);
		
		// If the delete failed, then we just reset the default sku into the product and return false
		if(!deleteOK) {
			arguments.product.setDefaultSku(defaultSku);
		
			return false;
		}
	
		return true;
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
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
	
}

