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
component displayname="Price Group Rate" entityname="SlatwallPriceGroupRate" table="SwPriceGroupRate" persistent=true output=false accessors=true extends="HibachiEntity" cacheuse="transactional" hb_serviceName="priceGroupService" hb_permission="priceGroup.priceGroupRates" {
	
	// Persistent Properties
	property name="priceGroupRateID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="globalFlag" ormType="boolean" default="false";
	property name="amount" ormType="big_decimal" hb_formatType="custom";
	property name="amountType" ormType="string" hb_formFieldType="select";
	property name="currencyCode" ormtype="string" length="3";

	// Remote properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
		
	// Related Object Properties (many-to-one)
	property name="priceGroup" cfc="PriceGroup" fieldtype="many-to-one" fkcolumn="priceGroupID";
	property name="roundingRule" cfc="RoundingRule" fieldtype="many-to-one" fkcolumn="roundingRuleID" hb_optionsNullRBKey="define.none";
	
	// Related Object Properties (one-to-many)
	property name="priceGroupRateCurrencies" singularname="priceGroupRateCurrency" cfc="PriceGroupRateCurrency" type="array" fieldtype="one-to-many" fkcolumn="priceGroupRateID" cascade="all-delete-orphan" inverse="true";


	// Related Object Properties (many-to-many)
	property name="productTypes" singularname="productType" cfc="ProductType" fieldtype="many-to-many" linktable="SwPriceGroupRateProductType" fkcolumn="priceGroupRateID" inversejoincolumn="productTypeID";
	property name="products" singularname="product" cfc="Product" fieldtype="many-to-many" linktable="SwPriceGroupRateProduct" fkcolumn="priceGroupRateID" inversejoincolumn="productID";
	property name="skus" singularname="sku" cfc="Sku" fieldtype="many-to-many" linktable="SwPriceGroupRateSku" fkcolumn="priceGroupRateID" inversejoincolumn="skuID";
	
	property name="excludedProductTypes" singularname="excludedProductType" cfc="ProductType" fieldtype="many-to-many" linktable="SwPriceGrpRateExclProductType" fkcolumn="priceGroupRateID" inversejoincolumn="productTypeID";
	property name="excludedProducts" singularname="excludedProduct" cfc="Product" fieldtype="many-to-many" linktable="SwPriceGroupRateExclProduct" fkcolumn="priceGroupRateID" inversejoincolumn="productID";
	property name="excludedSkus" singularname="excludedSku" cfc="Sku" fieldtype="many-to-many" linktable="SwPriceGroupRateExclSku" fkcolumn="priceGroupRateID" inversejoincolumn="skuID";
	
	// Non-persistent entities
	property name="amountTypeOptions" persistent="false";
	property name="appliesTo" type="string" persistent="false";
	property name="displayName" type="string" persistent="false";
	property name="currencyCodeOptions" persistent="false";
	
	// ============ START: Non-Persistent Property Methods =================
	
	public array function getAmountTypeOptions() {
		return [
			{name=rbKey("define.percentageOff"), value="percentageOff"},
			{name=rbKey("define.amountOff"), value="amountOff"},
			{name=rbKey("define.fixedAmount"), value="amount"}
		];
	}

    public string function getAppliesTo(){
    	var including = "";
    	var excluding = "";
    	var finalString = "";
    	var productsList = "";
    	var productTypesList = "";
    	var skusList = "";
    	var excludedProductsList = "";
    	var excludedProductTypesList = "";
    	var excludedSkusList = "";
    	
    	if(getGlobalFlag()) {
    		return rbKey('admin.pricegroup.edit.priceGroupRateAppliesToAllProducts');
    	}
    	
    	// --------- Including --------- 
    	if(arrayLen(getProducts())) {
    		productsList = "#arrayLen(getProducts())# Product" & getHibachiScope().getService('hibachiUtilityService').hibachiTernary(arrayLen(getProducts()) GT 1,'s','');
    	}
    	if(arrayLen(getProductTypes())) {
    		productTypesList = "#arrayLen(getProductTypes())# Product Type" & getHibachiScope().getService('hibachiUtilityService').hibachiTernary(arrayLen(getProductTypes()) GT 1,'s','');
    	}
    	if(arrayLen(getSkus())) {
    		SkusList = "#arrayLen(getSkus())# SKU" & getHibachiScope().getService('hibachiUtilityService').hibachiTernary(arrayLen(getSkus()) GT 1,'s','');
    	}
    	if(ListLen(productsList)) {
    		including = ListAppend(including, productsList);
    	}
    	if(ListLen(productTypesList)) {
    		including = ListAppend(including, productTypesList);
    	} 
    	if(ListLen(SkusList)) {
    		including = ListAppend(including, SkusList);
    	}
    		
    	// Replace all commas with " and ".
    	if(listLen(including)) {
    		including = Replace(including, ",", " and ");
    	}
    		
    	// --------- Excluding --------- 	
   		if(arrayLen(getExcludedProducts())) {
    		excludedProductsList = "#arrayLen(getExcludedProducts())# Product" & getHibachiScope().getService('hibachiUtilityService').hibachiTernary(arrayLen(getExcludedProducts()) GT 1,'s','');
    	}
    	if(arrayLen(getExcludedProductTypes())) {
    		excludedProductTypesList = "#arrayLen(getExcludedProductTypes())# Product Type" & getHibachiScope().getService('hibachiUtilityService').hibachiTernary(arrayLen(getExcludedProductTypes()) GT 1,'s','');
    	}
    	if(arrayLen(getExcludedSkus())) {
    		excludedSkusList = "#arrayLen(getExcludedSkus())# SKU" & getHibachiScope().getService('hibachiUtilityService').hibachiTernary(arrayLen(getExcludedSkus()) GT 1,'s','');
    	}
    	
    	if(ListLen(excludedProductsList)) { 
    		excluding = ListAppend(excluding, excludedProductsList);
    	}
    	if(ListLen(excludedproductTypesList)) {
    		excluding = ListAppend(excluding, excludedProductTypesList);
    	} 
    	if(ListLen(excludedSkusList)) {
    		excluding = ListAppend(excluding, excludedSkusList);
    	}
    		
    	// Replace all commas with " and ".
    	if(listLen(excluding)) {
    		excluding = Replace(excluding, ",", " and ");
    	}
    		
		// Assemble Including and Excluding strings
    	if(len(including)) {
    		finalString = "Including: " & including;
    	}
    		
    	if(len(excluding)) {
    		if(len(including)) {
    			finalString &= ". ";
    		}
    		finalString &= "Excluding: " & excluding;
    	}
    		
    	return finalString;
    }

    public array function getCurrencyCodeOptions() {
		if(!structKeyExists(variables, "currencyCodeOptions")) {
			variables.currencyCodeOptions = getService("currencyService").getCurrencyOptions();
		}
		return variables.currencyCodeOptions;
	}

	public string function getCurrencyCode() {
		if(!structKeyExists(variables, "currencyCode")) {
			variables.currencyCode=setting('skuCurrency');		
		}
		return variables.currencyCode;
	}


	public numeric function getAmountByCurrencyCode(required string currencyCode){
		if(arguments.currencyCode neq getCurrencyCode()){
			//Check for explicity defined priceGroup rate currencies
			for(var i=1;i<=arraylen(variables.priceGroupRateCurrencies);i++){
				if(variables.priceGroupRateCurrencies[i].getCurrencyCode() eq arguments.currencyCode){
					return variables.priceGroupRateCurrencies[i].getAmount();
				}
			}
			//Check for defined conversion rate 
			var currencyRate = getService("currencyService").getCurrencyDAO().getCurrentCurrencyRateByCurrencyCodes(originalCurrencyCode=getCurrencyCode(), convertToCurrencyCode=arguments.currencyCode, conversionDateTime=now());
			if(!isNull(currencyRate)) {
				return getService('HibachiUtilityService').precisionCalculate(currencyRate.getConversionRate()*getAmount());
			}
		
		}
		//Either no conversion was needed, or we couldn't find a conversion rate.
		return getAmount();
	}
    
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================

	// Price Group (many-to-one)
	public void function setPriceGroup(required any priceGroup) {
		variables.priceGroup = arguments.priceGroup;
		if(isNew() or !arguments.priceGroup.hasPriceGroupRate( this )) {
			arrayAppend(arguments.priceGroup.getPriceGroupRates(), this);
		}
	}
	public void function removePriceGroup(any priceGroup) {
		if(!structKeyExists(arguments, "priceGroup")) {
			arguments.priceGroup = variables.priceGroup;
		}
		var index = arrayFind(arguments.priceGroup.getPriceGroupRates(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.priceGroup.getPriceGroupRates(), index);
		}
		structDelete(variables, "priceGroup");
	}
	
	// Product Types (many-to-many - owner)
	public void function addProductType(required any productType) {
		if(arguments.productType.isNew() or !hasProductType(arguments.productType)) {
			arrayAppend(variables.productTypes, arguments.productType);
		}
		if(isNew() or !arguments.productType.hasPriceGroupRate( this )) {
			arrayAppend(arguments.productType.getPriceGroupRates(), this);
		}
	}
	public void function removeProductType(required any productType) {
		var thisIndex = arrayFind(variables.productTypes, arguments.productType);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.productTypes, thisIndex);
		}
		var thatIndex = arrayFind(arguments.productType.getPriceGroupRates(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.productType.getPriceGroupRates(), thatIndex);
		}
	}
	
	// Products (many-to-many - owner)
	public void function addProduct(required any product) {
		if(arguments.product.isNew() or !hasProduct(arguments.product)) {
			arrayAppend(variables.products, arguments.product);
		}
		if(isNew() or !arguments.product.hasPriceGroupRate( this )) {
			arrayAppend(arguments.product.getPriceGroupRates(), this);
		}
	}
	public void function removeProduct(required any product) {
		var thisIndex = arrayFind(variables.products, arguments.product);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.products, thisIndex);
		}
		var thatIndex = arrayFind(arguments.product.getPriceGroupRates(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.product.getPriceGroupRates(), thatIndex);
		}
	}
	
	// Skus (many-to-many - owner)
	public void function addSku(required any sku) {
		if(arguments.sku.isNew() or !hasSku(arguments.sku)) {
			arrayAppend(variables.skus, arguments.sku);
		}
		if(isNew() or !arguments.sku.hasPriceGroupRate( this )) {
			arrayAppend(arguments.sku.getPriceGroupRates(), this);
		}
	}
	public void function removeSku(required any sku) {
		var thisIndex = arrayFind(variables.skus, arguments.sku);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.skus, thisIndex);
		}
		var thatIndex = arrayFind(arguments.sku.getPriceGroupRates(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.sku.getPriceGroupRates(), thatIndex);
		}
	}
	
    // =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	public string function getAmountFormatted() {
		if(getAmountType() == "percentageOff") {
			return getAmount() & "%";
		} else {
			return formatValue(getAmount(),"currency");
		}
	}

	public string function getAmountFormattedByCurrencyCode(required string currencyCode) {
		if(getAmountType() == "percentageOff") {
			return getAmountByCurrencyCode(arguments.currencyCode) & "%";
		} else {
			return formatValue(getAmountByCurrencyCode(arguments.currencyCode),"currency");
		}
	}

	public string function getDisplayName(){
		return getPriceGroup().getPriceGroupName() & " - " & getAmount() & " - " & getAmountType();
	}

	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}

