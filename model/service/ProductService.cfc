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
			arguments.product.setURLTitle(getDataService().createUniqueURLTitle(titleString=arguments.product.getTitle(), tableName="SlatwallProduct"));
		}
		
		// validate the product
		arguments.product.validate( context="save" );
		
		// If this is a new product and it doesn't have any errors... there are a few additional steps we need to take
		if(arguments.product.isNew() && !arguments.product.hasErrors()) {
			
			// Create Skus
			getSkuService().createSkus(arguments.product, arguments.data);
			
			// Generate Image Files
			arguments.product = this.processProduct(arguments.product, {}, 'updateDefaultImageFileNames');
		}
		
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
				data.urlTitle = getDataService().createUniqueURLTitle(titleString=arguments.data.productTypeName, tableName="SlatwallProductType");	
			} else if (!isNull(arguments.productType.getProductTypeName()) && len(arguments.productType.getProductTypeName())) {
				data.urlTitle = getDataService().createUniqueURLTitle(titleString=arguments.productType.getProductTypeName(), tableName="SlatwallProductType");
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

