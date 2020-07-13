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

	Valid Reward Types
	
	merchandise
	subscription
	contentAccess
	fulfillment
	order

*/
component displayname="Promotion Reward" entityname="SlatwallPromotionReward" table="SwPromoReward" persistent="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="promotionService" hb_permission="promotionPeriod.promotionRewards" {
	
	// Persistent Properties
	property name="promotionRewardID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="amount" ormType="big_decimal" hb_formatType="custom";
	property name="currencyCode" ormtype="string" length="3";
	property name="amountType" ormType="string" hb_formatType="rbKey";
	property name="rewardType" ormType="string" hb_formatType="rbKey";
	property name="applicableTerm" ormType="string" hb_formatType="rbKey" hb_formFieldType="select";
	property name="maximumUsePerOrder" ormType="integer" hb_nullRBKey="define.unlimited";
	property name="maximumUsePerItem" ormtype="integer" hb_nullRBKey="define.unlimited";
	property name="maximumUsePerQualification" ormtype="integer" hb_nullRBKey="define.unlimited";
	property name="includedSkusCollectionConfig" ormtype="text" hb_formFieldType="json";
	property name="excludedSkusCollectionConfig" ormtype="text" hb_formFieldType="json";

	// Related Object Properties (many-to-one)
	property name="promotionPeriod" cfc="PromotionPeriod" fieldtype="many-to-one" fkcolumn="promotionPeriodID";
	property name="roundingRule" cfc="RoundingRule" fieldtype="many-to-one" fkcolumn="roundingRuleID" hb_optionsNullRBKey="define.none";

	// Related Object Properties (one-to-many)
	property name="promotionRewardCurrencies" singularname="promotionRewardCurrency" cfc="PromotionRewardCurrency" type="array" fieldtype="one-to-many" fkcolumn="promotionRewardID" cascade="all-delete-orphan" inverse="true";
	property name="skuPrices" singularname="skuPrice" cfc="SkuPrice" type="array" fieldtype="one-to-many" fkcolumn="promotionRewardID" cascade="all-delete-orphan" inverse="true";

	// Related Object Properties (many-to-many - owner)
	property name="eligiblePriceGroups" singularname="eligiblePriceGroup" cfc="PriceGroup" type="array" fieldtype="many-to-many" linktable="SwPromoRewardEligiblePriceGrp" fkcolumn="promotionRewardID" inversejoincolumn="priceGroupID";
	
	property name="fulfillmentMethods" singularname="fulfillmentMethod" cfc="FulfillmentMethod" fieldtype="many-to-many" linktable="SwPromoRewardFulfillmentMethod" fkcolumn="promotionRewardID" inversejoincolumn="fulfillmentMethodID";
	property name="shippingAddressZones" singularname="shippingAddressZone" cfc="AddressZone" fieldtype="many-to-many" linktable="SwPromoRewardShipAddressZone" fkcolumn="promotionRewardID" inversejoincolumn="addressZoneID";
	property name="shippingMethods" singularname="shippingMethod" cfc="ShippingMethod" fieldtype="many-to-many" linktable="SwPromoRewardShippingMethod" fkcolumn="promotionRewardID" inversejoincolumn="shippingMethodID";
	property name="includedStackableRewards" singularname="includedStackableReward" cfc="PromotionReward" fieldtype="many-to-many" linktable="SwPromoRewardStackIncl" fkcolumn="promotionRewardID" inversejoincolumn="linkedPromotionRewardID";
	property name="excludedStackableRewards" singularname="excludedStackableReward" cfc="PromotionReward" fieldtype="many-to-many" linktable="SwPromoRewardStackExcl" fkcolumn="promotionRewardID" inversejoincolumn="linkedPromotionRewardID";
	
	// Deprecated Properties
	property name="brands" singularname="brand" cfc="Brand" fieldtype="many-to-many" linktable="SwPromoRewardBrand" fkcolumn="promotionRewardID" inversejoincolumn="brandID";
	property name="options" singularname="option" cfc="Option" fieldtype="many-to-many" linktable="SwPromoRewardOption" fkcolumn="promotionRewardID" inversejoincolumn="optionID";
	property name="skus" singularname="sku" cfc="Sku" fieldtype="many-to-many" linktable="SwPromoRewardSku" fkcolumn="promotionRewardID" inversejoincolumn="skuID";
	property name="products" singularname="product" cfc="Product" fieldtype="many-to-many" linktable="SwPromoRewardProduct" fkcolumn="promotionRewardID" inversejoincolumn="productID";
	property name="productTypes" singularname="productType" cfc="ProductType" fieldtype="many-to-many" linktable="SwPromoRewardProductType" fkcolumn="promotionRewardID" inversejoincolumn="productTypeID";
	
	property name="excludedBrands" singularname="excludedBrand" cfc="Brand" type="array" fieldtype="many-to-many" linktable="SwPromoRewardExclBrand" fkcolumn="promotionRewardID" inversejoincolumn="brandID";
	property name="excludedOptions" singularname="excludedOption" cfc="Option" type="array" fieldtype="many-to-many" linktable="SwPromoRewardExclOption" fkcolumn="promotionRewardID" inversejoincolumn="optionID";
	property name="excludedSkus" singularname="excludedSku" cfc="Sku" fieldtype="many-to-many" linktable="SwPromoRewardExclSku" fkcolumn="promotionRewardID" inversejoincolumn="skuID";
	property name="excludedProducts" singularname="excludedProduct" cfc="Product" fieldtype="many-to-many" linktable="SwPromoRewardExclProduct" fkcolumn="promotionRewardID" inversejoincolumn="productID";
	property name="excludedProductTypes" singularname="excludedProductType" cfc="ProductType" fieldtype="many-to-many" linktable="SwPromoRewardExclProductType" fkcolumn="promotionRewardID" inversejoincolumn="productTypeID";
	// End Deprecated Properties
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	// Non-persistent entities
	property name="amountTypeOptions" persistent="false";
	property name="applicableTermOptions" persistent="false";
	property name="rewards" type="string" persistent="false";
	property name="currencyCodeOptions" persistent="false";
	property name="isDeletableFlag" type="boolean" persistent="false";
	property name="includedSkusCollection" persistent="false";
	property name="excludedSkusCollection" persistent="false";
	property name="skuCollection" persistent="false";
	//CUSTOM PROPERTIES BEGIN
property name="personalVolumeAmount" ormtype="big_decimal" hb_formatType="custom";
    property name="taxableAmountAmount" ormtype="big_decimal" hb_formatType="custom";
    property name="commissionableVolumeAmount" ormtype="big_decimal" hb_formatType="custom";
    property name="retailCommissionAmount" ormtype="big_decimal" hb_formatType="custom";
    property name="productPackVolumeAmount" ormtype="big_decimal" hb_formatType="custom";
    property name="retailValueVolumeAmount" ormtype="big_decimal" hb_formatType="custom";
    
   //CUSTOM PROPERTIES END
	public boolean function getIsDeletableFlag(){
 		return getPromotionPeriod().getIsDeletableFlag();
 	}
 	
	public string function getSimpleRepresentation() {
		return "#rbKey('entity.promotionReward')# - #getFormattedValue('rewardType')#";
	}

	// ============ START: Non-Persistent Property Methods =================
	
	public array function getApplicableTermOptions() {
		return [
			{name=rbKey("define.both"), value="both"},
			{name=rbKey("define.initial"), value="initial"},
			{name=rbKey("define.renewal"), value="renewal"}
		];
	}
	
	public array function getAmountTypeOptions() {
		if(getRewardType() == "order") {
			return [
				{name=rbKey("define.percentageOff"), value="percentageOff"},
				{name=rbKey("define.amountOff"), value="amountOff"}
			];
		} else {
			return [
				{name=rbKey("define.percentageOff"), value="percentageOff"},
				{name=rbKey("define.amountOff"), value="amountOff"},
				{name=rbKey("define.fixedAmount"), value="amount"}
			];
		}
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
	
	public numeric function getAmount(any sku, string currencyCode, numeric quantity, any account){
		
		//Get price from sku prices table for fixed amount rewards
		if(getAmountType() == 'amount' && structKeyExists(arguments,'sku')){
			if(!structKeyExists(arguments,'currencyCode')){
				arguments.currencyCode = getCurrencyCode();
			}
			var skuPrice = getSkuPriceBySkuAndCurrencyCode(argumentCollection=arguments);

			if(!isNull(skuPrice)){
				return skuPrice.getPrice();
			}
		}
		
		if(!structKeyExists(variables,'amount')){
			variables.amount = 0;
		}
		return variables.amount;
	}

	private any function getSkuPriceBySkuAndCurrencyCode(required any sku, required string currencyCode, numeric quantity, any account){
		var daoArguments = {
			skuID:arguments.sku.getSkuID(),
			promotionRewardID:this.getPromotionRewardID(),
			currencyCode:arguments.currencyCode
		};
		if(!isNull(arguments.quantity)){
			daoArguments.quantity = arguments.quantity;
		}
		if(!isNull(arguments.account)){
			daoArguments.account = arguments.account;
		}

		return getService('skuPriceService').getPromotionRewardSkuPriceForSkuByCurrencyCode(argumentCollection=daoArguments);
	}

	public numeric function getAmountByCurrencyCode(required string currencyCode, any sku, numeric quantity, any account){
		var amountParams = {};
		if(structKeyExists(arguments,'quantity')){
			amountParams['quantity'] = arguments.quantity;
		}
		if(structKeyExists(arguments,'sku')){
			amountParams['sku'] = arguments.sku;
		}
		if(structKeyExists(arguments,'account')){
			amountParams['account'] = arguments.account;
		}
		if(arguments.currencyCode neq getCurrencyCode() and getAmountType() eq 'amountOff'){
			//Check for explicity defined promotion reward currencies
			for(var i=1;i<=arraylen(variables.promotionRewardCurrencies);i++){
				if(variables.promotionRewardCurrencies[i].getCurrencyCode() eq arguments.currencyCode){
					return variables.promotionRewardCurrencies[i].getAmount();
				}
			}
			//Check for defined conversion rate 
			var currencyRate = getService("currencyService").getCurrencyDAO().getCurrentCurrencyRateByCurrencyCodes(originalCurrencyCode=getCurrencyCode(), convertToCurrencyCode=arguments.currencyCode, conversionDateTime=now());
			if(!isNull(currencyRate)) {
				return getService('HibachiUtilityService').precisionCalculate(currencyRate.getConversionRate()*getAmount(amountParams));
			}
		
		}else if(arguments.currencyCode != getCurrencyCode()){
			amountParams['currencyCode'] = arguments.currencyCode;
		}
		//Either no conversion was needed, or we couldn't find a conversion rate.
		return getAmount(argumentCollection=amountParams);
	}
	
	public any function getIncludedSkusCollection( boolean refresh=false , boolean transient=false){
		if(arguments.refresh || arguments.transient || isNull(variables.includedSkusCollection)){
			var collectionConfig = getIncludedSkusCollectionConfig();
			if(!isNull(collectionConfig)){
				var includedSkusCollection = getService("HibachiCollectionService").createTransientCollection(entityName='Sku',collectionConfig=collectionConfig);
			}else{
				var includedSkusCollection = getService("HibachiCollectionService").getSkuCollectionList();
				includedSkusCollection.setDisplayProperties('skuCode,skuName,activeFlag',{'isVisible': true, 'isSearchable': true, 'isExportable': true});
				includedSkusCollection.addDisplayProperty('skuID', 'Sku ID', {'isVisible': false, 'isSearchable': false}, true);
			}
		
			if(arguments.transient){
				return includedSkusCollection;
			}else{
				variables.includedSkusCollection = includedSkusCollection;
			}
		}
		return variables.includedSkusCollection;
	}
	
	public any function getExcludedSkusCollection( boolean refresh=false, boolean transient=false ){
		if(arguments.refresh || arguments.transient || isNull(variables.excludedSkusCollection)){
			var collectionConfig = getExcludedSkusCollectionConfig();
			if(!isNull(collectionConfig)){
				var excludedSkusCollection = getService("HibachiCollectionService").createTransientCollection(entityName='Sku',collectionConfig=collectionConfig);
			}else{
				var excludedSkusCollection = getService("HibachiCollectionService").getSkuCollectionList();
				excludedSkusCollection.setDisplayProperties('skuCode,skuName,activeFlag',{'isVisible': true, 'isSearchable': true, 'isExportable': true});
				excludedSkusCollection.addDisplayProperty('skuID', 'Sku ID', {'isVisible': false, 'isSearchable': false}, true);
			}
			
			if(arguments.transient){
				return excludedSkusCollection;
			}else{
				variables.excludedSkusCollection = excludedSkusCollection;
			}
		}
		return variables.excludedSkusCollection;
	}
	
	public void function saveIncludedSkusCollection(){
		var collectionConfig = serializeJSON(getIncludedSkusCollection().getCollectionConfigStruct());
		setIncludedSkusCollectionConfig(collectionConfig);
	}
	public void function saveExcludedSkusCollection(){
		var collectionConfig = serializeJSON(getExcludedSkusCollection().getCollectionConfigStruct());
		setExcludedSkusCollectionConfig(collectionConfig);
	}

	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================
	
	// Promotion Period (many-to-one)
	public void function setPromotionPeriod(required any promotionPeriod) {
		variables.promotionPeriod = arguments.promotionPeriod;
		if(isNew() or !arguments.promotionPeriod.hasPromotionReward( this )) {
			arrayAppend(arguments.promotionPeriod.getPromotionRewards(), this);
		}
	}
	public void function removePromotionPeriod(any promotionPeriod) {
	   if(!structKeyExists(arguments, "promotionPeriod")) {
	   		arguments.promotionPeriod = variables.promotionPeriod;
	   }
       var index = arrayFind(arguments.promotionPeriod.getPromotionRewards(),this);
       if(index > 0) {
           arrayDeleteAt(arguments.promotionPeriod.getPromotionRewards(), index);
       }
       structDelete(variables,"promotionPeriod");
    }

	// Eligible Price Groups (many-to-many - owner)
	public void function addEligiblePriceGroup(required any eligiblePriceGroup) {
		if(arguments.eligiblePriceGroup.isNew() or !hasEligiblePriceGroup(arguments.eligiblePriceGroup)) {
			arrayAppend(variables.eligiblePriceGroups, arguments.eligiblePriceGroup);
		}
		if(isNew() or !arguments.eligiblePriceGroup.hasPromotionReward( this )) {
			arrayAppend(arguments.eligiblePriceGroup.getPromotionRewards(), this);
		}
	}
	public void function removeEligiblePriceGroup(required any eligiblePriceGroup) {
		var thisIndex = arrayFind(variables.eligiblePriceGroups, arguments.eligiblePriceGroup);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.eligiblePriceGroups, thisIndex);
		}
		var thatIndex = arrayFind(arguments.eligiblePriceGroup.getPromotionRewards(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.eligiblePriceGroup.getPromotionRewards(), thatIndex);
		}
	}
	
	// Shipping Methods (many-to-many - owner)    
	public void function addShippingMethod(required any shippingMethod) {    
		if(arguments.shippingMethod.isNew() or !hasShippingMethod(arguments.shippingMethod)) {    
			arrayAppend(variables.shippingMethods, arguments.shippingMethod);    
		}    
		if(isNew() or !arguments.shippingMethod.hasPromotionReward( this )) {    
			arrayAppend(arguments.shippingMethod.getPromotionRewards(), this);    
		}    
	}    
	public void function removeShippingMethod(required any shippingMethod) {    
		var thisIndex = arrayFind(variables.shippingMethods, arguments.shippingMethod);    
		if(thisIndex > 0) {    
			arrayDeleteAt(variables.shippingMethods, thisIndex);    
		}    
		var thatIndex = arrayFind(arguments.shippingMethod.getPromotionRewards(), this);    
		if(thatIndex > 0) {    
			arrayDeleteAt(arguments.shippingMethod.getPromotionRewards(), thatIndex);    
		}    
	}
	
	// Collection Skus
	
	public boolean function hasSkuBySkuID(required any skuID){
		var checkExcluded = true;
		var checkIncluded = true;
		var hasSku = false;
		
		if( isNull( getExcludedSkusCollectionConfig() ) ){
			checkExcluded = false;
		}
		if( isNull( getIncludedSkusCollectionConfig() ) ){
			checkIncluded = false;
		}
		
		if( checkIncluded ){
			hasSku = getCollectionHasSkuBySkuID( getIncludedSkusCollection(transient=true), arguments.skuID );
		}
		
		if( checkExcluded && ( hasSku || !checkIncluded ) ){
			hasSku = !getCollectionHasSkuBySkuID( getExcludedSkusCollection(transient=true), arguments.skuID );
		}
		
		return hasSku;
	}
	
	public boolean function hasOrderItemSku(required any orderItem){
		return this.hasSkuBySkuID(arguments.orderItem.getSku().getSkuID());
	}
	
	public string function getIncludedStackableRewardsIDList( boolean includeReciprocalRecords=false ){
		var cacheKey = 'includedStackableRewardsIDList#arguments.includeReciprocalRecords#';
		if(!structKeyExists(variables,cacheKey)){
			variables[cacheKey] = ArrayToList(getDAO('PromotionDAO').getIncludedStackableRewardsIDListForPromotionReward( this, arguments.includeReciprocalRecords ));
		}
		return variables[cacheKey];
	}
	
	public string function getExcludedStackableRewardsIDList( boolean includeReciprocalRecords=false ){
		var cacheKey = 'excludedStackableRewardsIDList#arguments.includeReciprocalRecords#';
		if(!structKeyExists(variables, cacheKey)){
			variables[cacheKey] = ArrayToList(getDAO('PromotionDAO').getExcludedStackableRewardsIDListForPromotionReward( this, arguments.includeReciprocalRecords ));
		}
		return variables[cacheKey];
	}
	
	private boolean function getCollectionHasSkuBySkuID( required any skuCollection, required string skuID ){
		if(isNull(arguments.skuCollection)){
			return false;
		}
		arguments.skuCollection.setDisplayProperties('skuID');
		arguments.skuCollection.addFilter(propertyIdentifier='skuID',value=arguments.skuID, filterGroupAlias='skuIDFilter');
		return !arrayIsEmpty(arguments.skuCollection.getPageRecords(formatRecords=false,refresh=true));
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// =============== START: Custom Formatting Methods ====================
	
	public string function getAmountFormatted() {
		if(getAmountType() == "percentageOff") {
			return formatValue(getAmount(), "percentage");
		}
		
		return formatValue(getAmount(), "currency");
	}
	
	// ===============  END: Custom Formatting Methods =====================

	// ================== START: Overridden Methods ========================
	
	public string function getSimpleRepresentationPropertyName() {
		return "rewardType";
	}

	public boolean function isDeletable() {
		return !getPromotionPeriod().isExpired() && getPromotionPeriod().getPromotion().isDeletable();
	}
	
	public void function setIncludedSkusCollectionConfig( required string collectionConfig ){
		var collectionConfigStruct = deserializeJSON(arguments.collectionConfig);
		if(getService('hibachiCollectionService').collectionConfigStructHasFilter(collectionConfigStruct)){
			variables.includedSkusCollectionConfig = arguments.collectionConfig;	
		}
	}
	
	public void function setExcludedSkusCollectionConfig( required string collectionConfig ){
		var collectionConfigStruct = deserializeJSON(arguments.collectionConfig);
		if(getService('hibachiCollectionService').collectionConfigStructHasFilter(collectionConfigStruct)){
			variables.excludedSkusCollectionConfig = arguments.collectionConfig;	
		}
	}
	
	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================= START: Deprecated Methods  ========================
	
	// Brands (many-to-many - owner)
	public void function addBrand(required any brand) {
		if(arguments.brand.isNew() or !hasBrand(arguments.brand)) {
			arrayAppend(variables.brands, arguments.brand);
		}
		if(isNew() or !arguments.brand.hasPromotionReward( this )) {
			arrayAppend(arguments.brand.getPromotionRewards(), this);
		}
	}
	public void function removeBrand(required any brand) {
		var thisIndex = arrayFind(variables.brands, arguments.brand);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.brands, thisIndex);
		}
		var thatIndex = arrayFind(arguments.brand.getPromotionRewards(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.brand.getPromotionRewards(), thatIndex);
		}
	}

	// Options (many-to-many - owner)
	public void function addOption(required any option) {
		if(arguments.option.isNew() or !hasOption(arguments.option)) {
			arrayAppend(variables.options, arguments.option);
		}
		if(isNew() or !arguments.option.hasPromotionReward( this )) {
			arrayAppend(arguments.option.getPromotionRewards(), this);
		}
	}
	public void function removeOption(required any option) {
		var thisIndex = arrayFind(variables.options, arguments.option);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.options, thisIndex);
		}
		var thatIndex = arrayFind(arguments.option.getPromotionRewards(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.option.getPromotionRewards(), thatIndex);
		}
	}
	
	// Skus (many-to-many - owner)    
	public void function addSku(required any sku) {    
		if(arguments.sku.isNew() or !hasSku(arguments.sku)) {    
			arrayAppend(variables.skus, arguments.sku);    
		}    
		if(isNew() or !arguments.sku.hasPromotionReward( this )) {    
			arrayAppend(arguments.sku.getPromotionRewards(), this);    
		}    
	}    
	public void function removeSku(required any sku) {    
		var thisIndex = arrayFind(variables.skus, arguments.sku);    
		if(thisIndex > 0) {    
			arrayDeleteAt(variables.skus, thisIndex);    
		}    
		var thatIndex = arrayFind(arguments.sku.getPromotionRewards(), this);    
		if(thatIndex > 0) {    
			arrayDeleteAt(arguments.sku.getPromotionRewards(), thatIndex);    
		}    
	}

	// Products (many-to-many - owner)
	public void function addProduct(required any product) {
		if(arguments.product.isNew() or !hasProduct(arguments.product)) {
			arrayAppend(variables.products, arguments.product);
		}
		if(isNew() or !arguments.product.hasPromotionReward( this )) {
			arrayAppend(arguments.product.getPromotionRewards(), this);
		}
	}
	public void function removeProduct(required any product) {
		var thisIndex = arrayFind(variables.products, arguments.product);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.products, thisIndex);
		}
		var thatIndex = arrayFind(arguments.product.getPromotionRewards(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.product.getPromotionRewards(), thatIndex);
		}
	}
	
	// Product Types (many-to-many - owner)
	public void function addProductType(required any productType) {
		if(arguments.productType.isNew() or !hasProductType(arguments.productType)) {
			arrayAppend(variables.productTypes, arguments.productType);
		}
		if(isNew() or !arguments.productType.hasPromotionReward( this )) {
			arrayAppend(arguments.productType.getPromotionRewards(), this);
		}
	}
	public void function removeProductType(required any productType) {
		var thisIndex = arrayFind(variables.productTypes, arguments.productType);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.productTypes, thisIndex);
		}
		var thatIndex = arrayFind(arguments.productType.getPromotionRewards(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.productType.getPromotionRewards(), thatIndex);
		}
	}
	
	// Excluded Brands (many-to-many - owner)    
	public void function addExcludedBrand(required any brand) {    
		if(arguments.brand.isNew() or !hasExcludedBrand(arguments.brand)) {    
			arrayAppend(variables.excludedBrands, arguments.brand);    
		}    
		if(isNew() or !arguments.brand.hasPromotionRewardExclusion( this )) {    
			arrayAppend(arguments.brand.getPromotionRewardExclusions(), this);    
		}    
	}    
	public void function removeExcludedBrand(required any brand) {    
		var thisIndex = arrayFind(variables.excludedBrands, arguments.brand);    
		if(thisIndex > 0) {    
			arrayDeleteAt(variables.excludedBrands, thisIndex);    
		}    
		var thatIndex = arrayFind(arguments.brand.getPromotionRewardExclusions(), this);    
		if(thatIndex > 0) {    
			arrayDeleteAt(arguments.brand.getPromotionRewardExclusions(), thatIndex);    
		}    
	}
	
	// Excluded Options (many-to-many - owner)    
	public void function addExcludedOption(required any option) {    
		if(arguments.option.isNew() or !hasExcludedOption(arguments.option)) {    
			arrayAppend(variables.excludedOptions, arguments.option);    
		}    
		if(isNew() or !arguments.option.hasPromotionRewardExclusion( this )) {    
			arrayAppend(arguments.option.getPromotionRewardExclusions(), this);    
		}    
	}    
	public void function removeExcludedOption(required any option) {    
		var thisIndex = arrayFind(variables.excludedOptions, arguments.option);    
		if(thisIndex > 0) {    
			arrayDeleteAt(variables.excludedOptions, thisIndex);    
		}    
		var thatIndex = arrayFind(arguments.option.getPromotionRewardExclusions(), this);    
		if(thatIndex > 0) {    
			arrayDeleteAt(arguments.option.getPromotionRewardExclusions(), thatIndex);    
		}    
	}
	
	// Excluded Skus (many-to-many - owner)
	public void function addExcludedSku(required any sku) {
		if(arguments.sku.isNew() or !hasExcludedSku(arguments.sku)) {
			arrayAppend(variables.excludedSkus, arguments.sku);
		}
		if(isNew() or !arguments.sku.hasPromotionRewardExclusion( this )) {
			arrayAppend(arguments.sku.getPromotionRewardExclusions(), this);
		}
	}
	public void function removeExcludedSku(required any sku) {
		var thisIndex = arrayFind(variables.excludedSkus, arguments.sku);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.excludedSkus, thisIndex);
		}
		var thatIndex = arrayFind(arguments.sku.getPromotionRewardExclusions(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.sku.getPromotionRewardExclusions(), thatIndex);
		}
	}
	
	// Excluded Products (many-to-many - owner)
	public void function addExcludedProduct(required any product) {
		if(arguments.product.isNew() or !hasExcludedProduct(arguments.product)) {
			arrayAppend(variables.excludedProducts, arguments.product);
		}
		if(isNew() or !arguments.product.hasPromotionRewardExclusion( this )) {
			arrayAppend(arguments.product.getPromotionRewardExclusions(), this);
		}
	}
	public void function removeExcludedProduct(required any product) {
		var thisIndex = arrayFind(variables.excludedProducts, arguments.product);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.excludedProducts, thisIndex);
		}
		var thatIndex = arrayFind(arguments.product.getPromotionRewardExclusions(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.product.getPromotionRewardExclusions(), thatIndex);
		}
	}

	// Excluded Product Types (many-to-many - owner)
	public void function addExcludedProductType(required any productType) {
		if(arguments.productType.isNew() or !hasExcludedProductType(arguments.productType)) {
			arrayAppend(variables.excludedProductTypes, arguments.productType);
		}
		if(isNew() or !arguments.productType.hasPromotionRewardExclusion( this )) {
			arrayAppend(arguments.productType.getPromotionRewardExclusions(), this);
		}
	}
	public void function removeExcludedProductType(required any productType) {
		var thisIndex = arrayFind(variables.excludedProductTypes, arguments.productType);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.excludedProductTypes, thisIndex);
		}
		var thatIndex = arrayFind(arguments.productType.getPromotionRewardExclusions(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.productType.getPromotionRewardExclusions(), thatIndex);
		}
	}
	
	// =================  END: Deprecated Methods   ========================		//CUSTOM FUNCTIONS BEGIN

public numeric function getPersonalVolumeAmount(any sku, string currencyCode){
        arguments['customPriceField'] = 'personalVolume';
        return getCustomAmount(argumentCollection=arguments);
    }
    
    public numeric function getTaxableAmountAmount(any sku, string currencyCode){
        arguments['customPriceField'] = 'taxableAmount';
        return getCustomAmount(argumentCollection=arguments);
    }
    
    public numeric function getCommissionableVolumeAmount(any sku, string currencyCode){
        arguments['customPriceField'] = 'commissionableVolume';
        return getCustomAmount(argumentCollection=arguments);
    }
    
    public numeric function getRetailCommissionAmount(any sku, string currencyCode){
        arguments['customPriceField'] = 'retailCommission';
        return getCustomAmount(argumentCollection=arguments);
    }
    
    public numeric function getProductPackVolumeAmount(any sku, string currencyCode){
        arguments['customPriceField'] = 'productPackVolume';
        return getCustomAmount(argumentCollection=arguments);
    }
    
    public numeric function getRetailValueVolumeAmount(any sku, string currencyCode){
        arguments['customPriceField'] = 'retailValueVolume';
        return getCustomAmount(argumentCollection=arguments);
    }
    
    public string function getPersonalVolumeAmountFormatted(){
        arguments['customPriceField'] = 'personalVolume';
        return getCustomAmountFormatted(argumentCollection=arguments);
    }
    
    public string function getTaxableAmountAmountFormatted(){
        arguments['customPriceField'] = 'taxableAmount';
        return getCustomAmountFormatted(argumentCollection=arguments);
    }
    
    public string function getCommissionableVolumeAmountFormatted(){
        arguments['customPriceField'] = 'commissionableVolume';
        return getCustomAmountFormatted(argumentCollection=arguments);
    }
    
    public string function getRetailCommissionAmountFormatted(){
        arguments['customPriceField'] = 'retailCommission';
        return getCustomAmountFormatted(argumentCollection=arguments);
    }
    
    public string function getProductPackVolumeAmountFormatted(){
        arguments['customPriceField'] = 'productPackVolume';
        return getCustomAmountFormatted(argumentCollection=arguments);
    }
    
    public string function getRetailValueVolumeAmountFormatted(){
        arguments['customPriceField'] = 'retailValueVolume';
        return getCustomAmountFormatted(argumentCollection=arguments);
    }
    
    public numeric function getPersonalVolumeAmountByCurrencyCode(required string currencyCode, any sku){
        arguments['customPriceField'] = 'personalVolume';
        return getCustomAmountByCurrencyCode(argumentCollection=arguments);
    }
    
    public numeric function getTaxableAmountAmountByCurrencyCode(required string currencyCode, any sku){
        arguments['customPriceField'] = 'taxableAmount';
        return getCustomAmountByCurrencyCode(argumentCollection=arguments);
    }
    
    public numeric function getCommissionableVolumeAmountByCurrencyCode(required string currencyCode, any sku){
        arguments['customPriceField'] = 'commissionableVolume';
        return getCustomAmountByCurrencyCode(argumentCollection=arguments);
    }
    
    public numeric function getRetailCommissionAmountByCurrencyCode(required string currencyCode, any sku){
        arguments['customPriceField'] = 'retailCommission';
        return getCustomAmountByCurrencyCode(argumentCollection=arguments);
    }
    
    public numeric function getProductPackVolumeAmountByCurrencyCode(required string currencyCode, any sku){
        arguments['customPriceField'] = 'productPackVolume';
        return getCustomAmountByCurrencyCode(argumentCollection=arguments);
    }
    
    public numeric function getRetailValueVolumeAmountByCurrencyCode(required string currencyCode, any sku){
        arguments['customPriceField'] = 'retailValueVolume';
        return getCustomAmountByCurrencyCode(argumentCollection=arguments);
    }
    
    public numeric function getCustomAmountByCurrencyCode(required string customPriceField, required string currencyCode, any sku, numeric quantity, any account){
		var amountParams = {
		    'customPriceField':arguments.customPriceField
		};
		if(structKeyExists(arguments,'sku')){
			amountParams['sku'] = arguments.sku;
		}
		if(structKeyExists(arguments,'account')){
			amountParams['account'] = arguments.account;
		}
		if(arguments.currencyCode != getCurrencyCode() and getAmountType() == 'amountOff'){
		    //Check for explicity defined promotion reward currencies
			for(var i=1;i<=arraylen(variables.promotionRewardCurrencies);i++){
				if(variables.promotionRewardCurrencies[i].getCurrencyCode() == arguments.currencyCode){
					return variables.promotionRewardCurrencies[i].invokeMethod('get#customPriceField#Amount');
				}
			}
			//Check for defined conversion rate 
			var currencyRate = getService("currencyService").getCurrencyDAO().getCurrentCurrencyRateByCurrencyCodes(originalCurrencyCode=getCurrencyCode(), convertToCurrencyCode=arguments.currencyCode, conversionDateTime=now());
			if(!isNull(currencyRate)) {
				return getService('HibachiUtilityService').precisionCalculate(currencyRate.getConversionRate()*invokeMethod('get#customPriceField#Amount'));
			}
		
		}else if(arguments.currencyCode != getCurrencyCode()){
			amountParams['currencyCode'] = arguments.currencyCode;
		}
		//Either no conversion was needed, or we couldn't find a conversion rate.
		return getCustomAmount(argumentCollection=amountParams);
	}
	
	public numeric function getCustomAmount(required string customPriceField, any sku, string currencyCode, numeric quantity, any account){

		//Get price from sku prices table for fixed amount rewards
		if(getAmountType() == 'amount' && structKeyExists(arguments,'sku')){
			if(!structKeyExists(arguments,'currencyCode')){
				arguments.currencyCode = getCurrencyCode();
			}
			var skuPrice = getSkuPriceBySkuAndCurrencyCode(argumentCollection=arguments);
			if(!isNull(skuPrice)){
				return skuPrice.invokeMethod('get#customPriceField#');
			}
		}
		
		if(!structKeyExists(variables,'#customPriceField#Amount')){
			variables['#customPriceField#Amount'] = getAmount(argumentCollection=arguments);
		}
		return variables['#customPriceField#Amount'];
	}
	
    public string function getCustomAmountFormatted( required string customPriceField ) {
		if(getAmountType() == "percentageOff") {
			return formatValue(this.invokeMethod('get#customPriceField#Amount'), "percentage");
		}
		
		return formatValue(this.invokeMethod('get#customPriceField#Amount'), "currency");
	}
    //CUSTOM FUNCTIONS END
}