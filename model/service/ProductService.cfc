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
	
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	public boolean function getProductIsOnTransaction(required any product) {
		return getProductDAO().getProductIsOnTransaction( argumentCollection=arguments );
	}
	
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
	
	public any function processProduct_addSubscriptionTerm(required any product, required any processObject) {
		
		var newSubscriptionTerm = getSubscriptionService().getSubscriptionTerm(arguments.processObject.getSubscriptionTermID());
		var newSku = getSkuService().newSku();
		
		newSku.setPrice( arguments.processObject.getPrice() );
		newSku.setRenewalPrice( arguments.processObject.getRenewalPrice() );
		if( arguments.processObject.getListPrice() != "" && isNumeric(arguments.processObject.getListPrice() )) {
			newSku.setListPrice( arguments.data.listPrice );	
		}
		newSku.setSkuCode( arguments.product.getProductCode() & "-#arrayLen(arguments.product.getSkus()) + 1#");
		newSku.setSubscriptionTerm( newSubscriptionTerm );
		for(var b=1; b <= arrayLen( arguments.product.getDefaultSku().getSubscriptionBenefits() ); b++) {
			newSku.addSubscriptionBenefit( arguments.product.getDefaultSku().getSubscriptionBenefits()[b] );
		}
		for(var b=1; b <= arrayLen( arguments.product.getDefaultSku().getRenewalSubscriptionBenefits() ); b++) {
			newSku.addRenewalSubscriptionBenefit( arguments.product.getDefaultSku().getRenewalSubscriptionBenefits()[b] );
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
		} else if (arguments.processObject.getBaseProductType() == "subscription") {
			
			for(var i=1; i <= listLen(arguments.processObject.getSubscriptionTerms()); i++){
				var thisSku = this.newSku();
				thisSku.setProduct(arguments.product);
				thisSku.setPrice(arguments.data.price);
				thisSku.setRenewalPrice(arguments.data.price);
				thisSku.setSubscriptionTerm( getSubscriptionService().getSubscriptionTerm(listGetAt(arguments.processObject.getSubscriptionTerms(), i)) );
				thisSku.setSkuCode(arguments.product.getProductCode() & "-#arrayLen(arguments.product.getSkus()) + 1#");
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
			
			
		// Create Content Access Product Skus Based On Pages
		} else if (arguments.processObject.getBaseProductType() == "contentAccess") {
			
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
			
		} else if (arguments.processObject.getBaseProductType() == "event") {
			
			if(arguments.processObject.getBundleLocationConfigurationFlag()) {
				var newSku = this.newSku();
				
				newSku.setPrice( arguments.processObject.getPrice() );
				newSku.setSkuCode( arguments.product.getProductCode() & "-1");
				newSku.setProduct( arguments.product );
				
				for(var lc=1; lc<=listLen(arguments.processObject.getLocationConfigurations()); lc++) {
					newSku.addLocationConfiguration( getLocationService().getLocationConfiguration( listGetAt(arguments.processObject.getLocationConfigurations(), lc) ) );
				}
				
				arguments.product.setDefaultSku( newSku );	
				
			} else {
				for(var lc=1; lc<=listLen(arguments.processObject.getLocationConfigurations()); lc++) {
					var newSku = this.newSku();
					
					newSku.setPrice( arguments.processObject.getPrice() );
					newSku.setSkuCode( arguments.product.getProductCode() & "-#lc#");
					newSku.setProduct( arguments.product );
					newSku.addLocationConfiguration( getLocationService().getLocationConfiguration( listGetAt(arguments.processObject.getLocationConfigurations(), lc) ) );
					if(lc==1) {
						arguments.product.setDefaultSku( newSku );	
					}
				}
			}
			
			
			// For Every locationConfiguration, create a sku with the eventStartDateTime
			
		} else {
			throw("There was an unexpected error when creating this product");
		}
		
			
		// Generate Image Files
		arguments.product = this.processProduct(arguments.product, {}, 'updateDefaultImageFileNames');
		
		arguments.product = this.saveProduct(arguments.product);
        
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
				// Update Event Start Date
				if(arguments.processObject.geteventStartDateTime()) {
					skus[i].seteventStartDateTime(arguments.processObject.geteventStartDateTime());	
				}
				// Update Event End Date
				if(arguments.processObject.geteventEndDateTime()) {
					skus[i].seteventEndDateTime(arguments.processObject.geteventEndDateTime());	
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

