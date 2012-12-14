/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

*/
component extends="BaseService" accessors="true" {
	
	// Slatwall Service Injection
	property name="skuDAO" type="any";
	property name="productTypeDAO" type="any";
	property name="dataService" type="any";  
	property name="contentService" type="any";
	property name="skuService" type="any";
	property name="subscriptionService" type="any";
	property name="utilityFileService" type="any";
	property name="utilityTagService" type="any";
	property name="optionService" type="any";
	
	
	// ===================== START: Logical Methods ===========================
	
	public void function loadDataFromFile(required string fileURL, string textQualifier = ""){
		getUtilityTagService().cfSetting(requesttimeout="3600"); 
		getDAO().loadDataFromFile(arguments.fileURL,arguments.textQualifier);
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
	
	public any function updateImageFileNameForProductSkus( required any product ) {
		for(var i=1; i<=arrayLen(arguments.product.getSkus()); i++) {
			arguments.product.getSkus()[i].setImageFile( arguments.product.getSkus()[i].generateImageFileName() );	
		}
	}
	
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	public boolean function getProductIsOnTransaction(required any product) {
		return getDAO().getProductIsOnTransaction(product=arguments.product);
	}
	
	public any function getProductSkusBySelectedOptions(required string selectedOptions, required string productID){
		return getSkuDAO().getSkusBySelectedOptions(argumentCollection=arguments);
	}
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	public any function processProduct(required any product, struct data={}, string processContext="process") {
		
		switch(arguments.processContext){
			case 'updateSkus':
				var skus = 	arguments.product.getSkus();
				if(arrayLen(skus)){
					for(i=1; i <= arrayLen(skus); i++){
						// Update Price
						if(arguments.data.updatePrice) {
							skus[i].setPrice(arguments.data.price);	
						}
						// Update List Price
						if(arguments.data.updateListPrice) {
							skus[i].setListPrice(arguments.data.listPrice);	
						}
					}
				}
				
				break;
			
			case 'addOptionGroup':
				var skus = 	arguments.product.getSkus();
				var options = getOptionService().getOptionGroup(arguments.data.optionGroup).getOptions();
				
				if(arrayLen(options)){
					for(i=1; i <= arrayLen(skus); i++){
						skus[i].addOption(options[1]);
					}
				}
				
				updateImageFileNameForProductSkus( arguments.product );
				
				break;
			
			case 'addOption':
			
				var newOption = getOptionService().getOption(arguments.data.option);
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
				
				updateImageFileNameForProductSkus( arguments.product );
				
				break;
			
			case 'addSubscriptionTerm':
			
				var newSubscriptionTerm = getSubscriptionService().getSubscriptionTerm(arguments.data.subscriptionTermID);
				var newSku = getSkuService().newSku();
				
				newSku.setPrice( arguments.data.price );
				if( arguments.data.listPrice != "" && isNumeric(arguments.data.listPrice)) {
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
				
				updateImageFileNameForProductSkus( arguments.product );
				
			break;
		}
		
	}
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	public any function saveProduct(required any product, required struct data) {
		// populate bean from values in the data Struct
		arguments.product.populate(arguments.data);
		
		if(isNull(arguments.product.getURLTitle())) {
			arguments.product.setURLTitle(getDataService().createUniqueURLTitle(titleString=arguments.product.getTitle(), tableName="SlatwallProduct"));
		}
		
		// If this is a new product and it doesn't have any errors... there are a few additional steps we need to take
		if(arguments.product.isNew() && !arguments.product.hasErrors()) {
			
			// Create Skus
			getSkuService().createSkus(arguments.product, arguments.data);
			
		}
		
		// Update the Image FileName for all the skus
		updateImageFileNameForProductSkus( arguments.product );
		
		// validate the product
		arguments.product.validate();
		
		// If the product passed validation then call save in the DAO, otherwise set the errors flag
        if(!arguments.product.hasErrors()) {
        	arguments.product = getDAO().save(target=arguments.product);
        } else {
            getSlatwallScope().setORMHasErrors( true );
        }
        
        // Return the product
		return arguments.product;
	}
	
	public any function saveProductType(required any productType, required struct data) {
		if( (isNull(arguments.productType.getURLTitle()) || !len(arguments.productType.getURLTitle())) && (!structKeyExists(arguments.data, "urlTitle") || !len(arguments.data.urlTitle)) ) {
			if(!isNull(arguments.productType.getProductTypeName())) {
				param name="arguments.data.productTypeName" default="#arguments.productType.getProductTypeName()#";
			} else {
				param name="arguments.data.productTypeName" default="";
			}
			data.urlTitle = getDataService().createUniqueURLTitle(titleString=arguments.data.productTypeName, tableName="SlatwallProduct");
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
		
		var smartList = getDAO().getSmartList(argumentCollection=arguments);
		
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
