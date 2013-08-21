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
	
	property name="optionService" type="any";
	property name="productService" type="any";
	property name="subscriptionService" type="any";
	property name="contentService" type="any";
	
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
	
	/**
	/* @hint Updates the prices of all of the SKUs in a product 
	**/
	public void function updateAllSKUPricesForProduct(productId, price){
		var skus = getProductService().getProduct(arguments.productId).getSKUs();
		for(var i=1; i LTE ArrayLen(skus); i++)
			skus[i].setPrice(price);
	}

	/**
	/* @hint Updates the wight of all of the SKUs in a product 
	**/
	public void function updateAllSKUWeightsForProduct(productId, weight){
		var skus = getProductService().getProduct(arguments.productId).getSKUs();
		for(var i=1; i LTE ArrayLen(skus); i++)
			skus[i].setShippingWeight(weight);
	}
	

	// ===================== START: Logical Methods ===========================
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	public boolean function getSkuStocksDeletableFlag( required string skuID ) {
		return getSkuDAO().getSkuStocksDeletableFlag(argumentCollection=arguments);
	}
	
	public any function getSkuBySkuCode( string skuCode ){
		return getSkuDAO().getSkuBySkuCode(argumentCollection=arguments);
	}
	
	// =====================  END: DAO Passthrough ============================
	
	// ===================== START: Process Methods ===========================
	
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
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================

}

