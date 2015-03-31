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
component entityname="SlatwallProductBundleGroup" table="SwProductBundleGroup" persistent="true" accessors="true" extends="HibachiEntity" hb_serviceName="productService" hb_permission="productBundleSku.productBundleGroups" {
	
	

	// Persistent Properties
	property name="productBundleGroupID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="activeFlag" ormtype="boolean" hb_formatType="yesno";
	property name="minimumQuantity" ormtype="integer" hb_formFieldType="number" default="1";
	property name="maximumQuantity" ormtype="integer" hb_formFieldType="number" default="1";
	property name="amountType" ormtype="string" hb_formFieldType="select" hb_formatType="rbKey";
	property name="amount" hb_formFieldType="number" ormtype="big_decimal" default="0";
	property name="skuCollectionConfig" ormtype="string" length="8000" hb_auditable="false" hb_formFieldType="json";

	// Calculated Properties

	// Related Object Properties (many-to-one)
	property name="productBundleSku" cfc="Sku" fieldtype="many-to-one" fkcolumn="productBundleSkuID";
	property name="productBundleGroupType" cfc="Type" fieldtype="many-to-one" fkcolumn="productBundleGroupTypeID" hb_optionsSmartListData="f:parentType.systemCode=productBundleGroupType";
	
	// Related Object Properties (one-to-many)
	property name="attributeValues" singularname="attributeValue" cfc="AttributeValue" fieldtype="one-to-many" fkcolumn="productBundleGroupID" cascade="all-delete-orphan" inverse="true";
	
	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)
	
	// Remote Properties
	property name="remoteID" hb_populateEnabled="false" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// Non-Persistent Properties
	property name="amountTypeOptions" persistent="false";
	// Deprecated Properties


	// ==================== START: Logical Methods =========================
	public array function getAmountTypeOptions() {
		//none | fixed | fixedPerQuantity | skuPrice | skuPricePercentageIncrease | skuPricePercentageDecrease
		var amountOptions = [];
		var valuesList = 'none,fixed,skuPrice,skuPricePercentageIncrease,skuPricePercentageDecrease';
		var namesList = 'entity.productBundleGroup.none,entity.productBundleGroup.fixed,entity.productBundleGroup.skuPrice,entity.productBundleGroup.skuPricePercentageIncrease,entity.productBundleGroup.skuPricePercentageDecrease';
		var valuesArray = ListToArray(valuesList);
		var namesArray = ListToArray(namesList);
		var valuesArrayLength = arrayLen(valuesArray);
		
		for(var i = 1; i <= valuesArrayLength; i++){
			var optionStruct = {};
			optionStruct['value'] = valuesArray[i];
			optionStruct['name'] = rbKey(namesArray[i]);
			arrayAppend(amountOptions,optionStruct);
		}
    	return amountOptions;
    }

    public string function getSkuCollectionConfig(){
    	if(isNull(variables.skuCollectionConfig)){
    		var defaultSkuCollectionConfig = {};
    		defaultSkuCollectionConfig["baseEntityName"]='Sku';
			defaultSkuCollectionConfig["baseEntityAlias"]='_sku';
			
			defaultSkuCollectionConfig["filterGroups"]=[{"filterGroup"=[]}];
			defaultSkuCollectionConfig["columns"]=[];
			var defaultColumnsArray = ['skuID','activeFlag','publishedFlag','skuName','skuDescription','skuCode','listPrice','price','renewalPrice'];
			
			for(var column in defaultColumnsArray){
				var columnStruct = {};
				columnStruct['propertyIdentifier'] = '_sku.#column#';
				columnStruct['title'] = getService('HibachiRBService').getRBKey('entity.sku.#column#');
				columnStruct['isVisible'] = true;
				ArrayAppend(defaultSkuCollectionConfig["columns"],columnStruct);
			}
    		variables.skuCollectionConfig = serializeJson(defaultSkuCollectionConfig);
    	}
    	return variables.skuCollectionConfig;
    }

	/*
	public any function getSkuOptionsCollection() {
		
		var bgiCollection = var soCollection = getService('collectionService').newCollection();
		bgiCollection.setBaseEntityName('ProductBundleGroupItem');
		bgiCollection.addFilter('productBundleGroup.productBundleGroupID', this.getProductBundleGroupID());
		
		var soCollection = getService('collectionService').newCollection();
		soCollection.setBaseEntityName('Sku');
		
		soCollection.addFilter('sku.skuID in bgiCollection.sku.skID');
		// OR
		soCollection.addFilter('sku.product.productID in bgiCollection.product.productID');
		// OR
		soCollection.addFilter('sku.product.brand.brandID in bgiCollection.brand.brandID');
		// OR
		
		
		SELECT
			sku
		FROM
			Sku sku
		WHERE
			// BAKED IN
			
			sku.skuID in (SELECT skuID FROM ProductBundleGroupItem pbgi WHERE pbgi.productBundleGroup.productBundleGroupID = this.getProductBundleGroupID() )
		  OR
		  	sku.product.productID in (SELECT productID FROM ProductBundleGroupItem pbgi WHERE pbgi.productBundleGroup.productBundleGroupID = this.getProductBundleGroupID())
		  OR
		  	sku.product.productTypeID in (SELECT productID FROM ProductBundleGroupItem pbgi WHERE pbgi.productBundleGroup.productBundleGroupID = this.getProductBundleGroupID())
		  OR
		  	sku.skuID in ( {SKU COLLECTION QUERY HERE} )	
		  	
		  	// CUSTOM ADDED FILTERS BY USER
		  AND
		  	sku.brand.brandID 
		
	}
	*/
	public any function getSkuOptions() {
		return getSkuOptionsCollection().getRecords(returnObjects=true);
	}
	
	
	
	// ====================  END: Logical Methods ==========================
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Product Bundle Sku (many-to-one)    
	public void function setProductBundleSku(required any productBundleSku) {    
		variables.productBundleSku = arguments.productBundleSku;    
		if(isNew() or !arguments.productBundleSku.hasProductBundleGroup( this )) {    
			arrayAppend(arguments.productBundleSku.getProductBundleGroups(), this);    
		}    
	}    
	public void function removeProductBundleSku(any productBundleSku) {    
		if(!structKeyExists(arguments, "productBundleSku")) {
			arguments.productBundleSku = variables.productBundleSku;    
		}    
		var index = arrayFind(arguments.productBundleSku.getProductBundleGroups(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.productBundleSku.getProductBundleGroups(), index);    
		}    
		structDelete(variables, "productBundleSku");    
	}
	
	// Attribute Values (one-to-many)    
	public void function addAttributeValue(required any attributeValue) {    
		arguments.attributeValue.setProductBundleGroup( this );    
	}    
	public void function removeAttributeValue(required any attributeValue) {    
		arguments.attributeValue.removeProductBundleGroup( this );    
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================
	
	// ============== START: Overridden Implicit Getters ===================
	
	// ==============  END: Overridden Implicit Getters ====================
	
	// ============= START: Overridden Smart List Getters ==================
	
	// =============  END: Overridden Smart List Getters ===================

	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================
	
}