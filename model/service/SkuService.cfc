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
	property name="stockService" type="any";
	
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
	
	public any function getSkuBySkuCode( string skuCode ){
		return getSkuDAO().getSkuBySkuCode(argumentCollection=arguments);
	}
	
	// =====================  END: DAO Passthrough ============================
	
	// ===================== START: Process Methods ===========================
	
	// TODO [paul]: makeup / breakup
	public any function processSku_makeupBundledSkus(required any entity, required struct data) {
		
		// Loop over every bundledSku
		for(skuBundle in arguments.entity.getBundledSkus()) {

			// Create inventory record
			var inventory = this.newInventory();
			
			inventory.setQuantityOut( arguments.data.quantity * skuBundle.getBundledQuantity() );
			inventory.setStock( getStockService().getStockBySkuAndLocation( sku=skuBundle.getBundledSku(), location=getService("locationService").getLocation(arguments.data.location)) );
			getHibachiDAO().save(inventory);
		}
		
		/*
		loop for every bundledSku
			var inventory = this.newInventory();
			inventory.setQuantityOut(arguments.entity.getQuantity());
			inventory.setStock(arguments.entity.getStock());
			getHibachiDAO().save(inventory);
		}
		
		create one new sku of the parent
		*/
		
		return arguments.entity;
	}
	
	public any function processSku_breakupBundledSkus(required any entity, required struct data) {
		// data.location
		
		// Loop over every bundledSku
		for(skuBundle in arguments.entity.getBundledSkus()) {
		
			// Create inventory record
			var inventory = this.newInventory();
			
			inventory.setQuantityIn( arguments.data.quantity * skuBundle.getBundledQuantity() );
			inventory.setStock(  getStockService().getStockBySkuAndLocation( sku=skuBundle.getBundledSku(), location=getService("locationService").getLocation(arguments.data.location)) );
			getHibachiDAO().save(inventory);
		}
		
		/*
		loop for every bundledSku
			var inventory = this.newInventory();
			inventory.setQuantityOut(arguments.entity.getQuantity());
			inventory.setStock(arguments.entity.getStock());
			getHibachiDAO().save(inventory);
		}
		
		create one new sku of the parent
		*/
		
		return arguments.entity;
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
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================

}

