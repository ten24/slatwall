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
component entityname="SlatwallSku" table="SwSku" persistent=true accessors=true output=false extends="HibachiEntity" cacheuse="transactional" hb_serviceName="skuService" hb_permission="this" hb_processContexts="changeEventDates,addLocation,removeLocation" {

	// Persistent Properties
	property name="skuID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="activeFlag" ormtype="boolean" default="1";
	property name="publishedFlag" ormtype="boolean" default="0";
	property name="skuName" ormtype="string";
	property name="skuDescription" ormtype="string" length="4000" hb_formFieldType="wysiwyg";
	property name="skuCode" ormtype="string" unique="true" length="50" index="PI_SKUCODE";
	property name="eventAttendanceCode" ormtype="string" length="8" hint="Unique code to track event attendance";
	property name="listPrice" ormtype="big_decimal" hb_formatType="currency" default="0";
	property name="price" ormtype="big_decimal" hb_formatType="currency" default="0";
	property name="renewalPrice" ormtype="big_decimal" hb_formatType="currency" default="0";
	property name="currencyCode" ormtype="string" length="3";
	property name="imageFile" ormtype="string" length="250";
	property name="userDefinedPriceFlag" ormtype="boolean" default="0";
	property name="eventStartDateTime" ormtype="timestamp" hb_formatType="dateTime";
	property name="eventEndDateTime" ormtype="timestamp" hb_formatType="dateTime";
	property name="startReservationDateTime" ormtype="timestamp" hb_formatType="dateTime";
	property name="endReservationDateTime" ormtype="timestamp" hb_formatType="dateTime";
	property name="purchaseStartDateTime" ormtype="timestamp" hb_formatType="dateTime";
	property name="purchaseEndDateTime" ormtype="timestamp" hb_formatType="dateTime";
	property name="bundleFlag" ormtype="boolean" default="0";
	property name="eventCapacity" ormtype="integer";
	property name="attendedQuantity" ormtype="integer" hint="Optional field for manually entered event attendance.";
	property name="allowEventWaitlistingFlag" ormtype="boolean" default="0";
	property name="redemptionAmountType" ormtype="string" hb_formFieldType="select" hint="used for gift card credit calculation. Values sameAsPrice, fixedAmount, Percentage"  hb_formatType="rbKey";
	property name="redemptionAmount" hb_formatType="currency" ormtype="big_decimal" hint="value to be used in calculation conjunction with redeptionAmountType";
	property name="inventoryTrackBy" ormtype="string" default="Quantity" hb_formFieldType="select";
	property name="nextDeliveryScheduleDate" ormtype="timestamp" description="This field is repopulated by deliveryScheduleDate";

	// Calculated Properties
	property name="calculatedQATS" ormtype="float";
	property name="calculatedQOH" ormtype="float";
	property name="calculatedQOQ" ormtype="float";
	property name="calculatedSkuDefinition" ormtype="string";
	property name="calculatedLastCountedDateTime" ormtype="timestamp" hb_formatType="dateTime";
	property name="calculatedOptionsHash" ormtype="string";
	property name="calculatedSkuPricesCount" ormtype="integer";

	// Related Object Properties (many-to-one)
	property name="product" cfc="Product" fieldtype="many-to-one" fkcolumn="productID" hb_cascadeCalculate="true";
	property name="productSchedule" cfc="ProductSchedule" fieldtype="many-to-one" fkcolumn="productScheduleID";
	property name="renewalSku" cfc="Sku" fieldtype="many-to-one" fkcolumn="renewalSkuID";
	property name="subscriptionTerm" cfc="SubscriptionTerm" fieldtype="many-to-one" fkcolumn="subscriptionTermID";
	property name="waitlistQueueTerm" cfc="Term" fieldtype="many-to-one" fkcolumn="termID" hint="Term that a waitlisted registrant has to claim offer.";
	property name="giftCardExpirationTerm" cfc="Term" fieldType="many-to-one" fkcolumn="giftCardExpirationTermID" hint="Term that is used to set the Expiration Date of the ordered gift card.";
	property name="inventoryMeasurementUnit" cfc="MeasurementUnit" fieldType="many-to-one" fkcolumn="measurementUnitID" hint="Unit used if inventory is tracked by measurement." hb_formFieldType="select";

	// Related Object Properties (one-to-many)
	property name="alternateSkuCodes" singularname="alternateSkuCode" fieldtype="one-to-many" fkcolumn="skuID" cfc="AlternateSkuCode" inverse="true" cascade="all-delete-orphan";
	property name="attributeValues" singularname="attributeValue" cfc="AttributeValue" type="array" fieldtype="one-to-many" fkcolumn="skuID" cascade="all-delete-orphan" inverse="true";
	property name="orderItems" singularname="orderItem" fieldtype="one-to-many" fkcolumn="skuID" cfc="OrderItem" inverse="true" lazy="extra";
	property name="skuPrices" singularname="skuPrice" fieldtype="one-to-many" fkcolumn="skuID" cfc="SkuPrice" cascade="all-delete-orphan" lazy="extra";
	property name="skuCosts" singularname="skuCost" fieldtype="one-to-many" fkcolumn="skuID" cfc="SkuCost" cascade="all-delete-orphan";
	property name="skuCurrencies" singularname="skuCurrency" cfc="SkuCurrency" type="array" fieldtype="one-to-many" fkcolumn="skuID" cascade="all-delete-orphan" inverse="true";
	property name="stocks" singularname="stock" fieldtype="one-to-many" fkcolumn="skuID" cfc="Stock" inverse="true" hb_cascadeCalculate="true" cascade="all-delete-orphan";
	property name="bundledSkus" singularname="bundledSku" fieldtype="one-to-many" fkcolumn="skuID" cfc="SkuBundle" inverse="true" cascade="all-delete-orphan" orderBy="sortOrder";
	property name="eventRegistrations" singularname="eventRegistration" fieldtype="one-to-many" fkcolumn="skuID" cfc="EventRegistration" inverse="true" cascade="all-delete-orphan";
	property name="assignedSkuBundles" singularname="assignedSkuBundle" fieldtype="one-to-many" fkcolumn="bundledSkuID" cfc="SkuBundle" inverse="true" cascade="all-delete-orphan" lazy="extra"; // No Bi-Directional
	property name="productBundleGroups" type="array" cfc="ProductBundleGroup" singularname="productBundleGroup"  fieldtype="one-to-many" fkcolumn="productBundleSkuID" cascade="all-delete-orphan" inverse="true";
	property name="productReviews" singularname="productReview" cfc="ProductReview" fieldtype="one-to-many" fkcolumn="skuID" cascade="all-delete-orphan" inverse="true";
	property name="vendorOrderItems" singularname="vendorOrderItem" fieldtype="one-to-many" fkcolumn="skuID" cfc="VendorOrderItem" inverse="true" lazy="extra";
	property name="minMaxStockTransferItems" singularname="minMaxStockTransferItem" fieldtype="one-to-many" fkcolumn="skuID" cfc="MinMaxStockTransferItem" inverse="true" lazy="extra";
	property name="skuLocationQuantities" singularname="skuLocationQuantity" fieldtype="one-to-many" fkcolumn="skuID" cfc="SkuLocationQuantity" inverse="true" cascade="all-delete-orphan";
	property name="deliveryScheduleDates" singularname="deliveryScheduleDate" cfc="DeliveryScheduleDate" fieldtype="one-to-many" fkcolumn="skuID" cascade="all-delete-orphan";

	// Related Object Properties (many-to-many - owner)
	property name="options" singularname="option" cfc="Option" type="array" fieldtype="many-to-many" linktable="SwSkuOption" fkcolumn="skuID" inversejoincolumn="optionID";
	property name="accessContents" singularname="accessContent" cfc="Content" type="array" fieldtype="many-to-many" linktable="SwSkuAccessContent" fkcolumn="skuID" inversejoincolumn="contentID";
	property name="subscriptionBenefits" singularname="subscriptionBenefit" cfc="SubscriptionBenefit" type="array" fieldtype="many-to-many" linktable="SwSkuSubsBenefit" fkcolumn="skuID" inversejoincolumn="subscriptionBenefitID";
	property name="renewalSubscriptionBenefits" singularname="renewalSubscriptionBenefit" cfc="SubscriptionBenefit" type="array" fieldtype="many-to-many" linktable="SwSkuRenewalSubsBenefit" fkcolumn="skuID" inversejoincolumn="subscriptionBenefitID";
	property name="locationConfigurations" singularname="locationConfiguration" cfc="LocationConfiguration" type="array" fieldtype="many-to-many" linktable="SwSkuLocationConfiguration" fkcolumn="skuID" inversejoincolumn="locationConfigurationID";
	property name="assignedAlternateImages" singularname="assignedAlternateImage" cfc="Image" type="array" fieldtype="many-to-many" linktable="SwAlternateImageSku" fkcolumn="skuID" inversejoincolumn="imageID";

	// Related Object Properties (many-to-many - inverse)
	property name="promotionRewards" singularname="promotionReward" cfc="PromotionReward" fieldtype="many-to-many" linktable="SwPromoRewardSku" fkcolumn="skuID" inversejoincolumn="promotionRewardID" inverse="true";
	property name="promotionRewardExclusions" singularname="promotionRewardExclusion" cfc="PromotionReward" type="array" fieldtype="many-to-many" linktable="SwPromoRewardExclSku" fkcolumn="skuID" inversejoincolumn="promotionRewardID" inverse="true";
	property name="promotionQualifiers" singularname="promotionQualifier" cfc="PromotionQualifier" fieldtype="many-to-many" linktable="SwPromoQualSku" fkcolumn="skuID" inversejoincolumn="promotionQualifierID" inverse="true";
	property name="promotionQualifierExclusions" singularname="promotionQualifierExclusion" cfc="PromotionQualifier" type="array" fieldtype="many-to-many" linktable="SwPromoQualExclSku" fkcolumn="skuID" inversejoincolumn="promotionQualifierID" inverse="true";
	property name="loyaltyAccruements" singularname="loyaltyAccruement" cfc="LoyaltyAccruement" fieldtype="many-to-many" linktable="SwLoyaltyAccruSku" fkcolumn="skuID" inversejoincolumn="loyaltyAccruementID" inverse="true";
	property name="loyaltyAccruementExclusions" singularname="loyaltyAccruementExclusion" cfc="LoyaltyAccruement" type="array" fieldtype="many-to-many" linktable="SwLoyaltyAccruExclSku" fkcolumn="skuID" inversejoincolumn="loyaltyAccruementID" inverse="true";
	property name="loyaltyRedemptions" singularname="loyaltyRedemption" cfc="LoyaltyRedemption" type="array" fieldtype="many-to-many" linktable="SwLoyaltyRedemptionSku" fkcolumn="skuID" inversejoincolumn="loyaltyRedemptionID" inverse="true";
	property name="loyaltyRedemptionExclusions" singularname="loyaltyRedemptionExclusion" cfc="LoyaltyRedemption" type="array" fieldtype="many-to-many" linktable="SwLoyaltyRedemptionExclSku" fkcolumn="skuID" inversejoincolumn="loyaltyRedemptionID" inverse="true";
	property name="priceGroupRates" singularname="priceGroupRate" cfc="PriceGroupRate" fieldtype="many-to-many" linktable="SwPriceGroupRateSku" fkcolumn="skuID" inversejoincolumn="priceGroupRateID" inverse="true";
	property name="physicals" singularname="physical" cfc="Physical" type="array" fieldtype="many-to-many" linktable="SwPhysicalSku" fkcolumn="skuID" inversejoincolumn="physicalID" inverse="true";

	// Remote properties
	property name="remoteID" ormtype="string";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	// Non-Persistent Properties
	property name="adminIcon" persistent="false";
	property name="allImageOptionCodes" persistent="false";
	property name="assignedOrderItemAttributeSetSmartList" persistent="false";
	property name="availableForPurchaseFlag" persistent="false";
	property name="availableSeatCount" persistent="false";
	property name="averageCost" persistent="false" hb_formatType="currency";
	property name="averageLandedCost" persistent="false" hb_formatType="currency";
	property name="currentMargin" persistent="false" hb_formatType="percentage";
	property name="currentLandedMargin" persistent="false" hb_formatType="percentage";
	property name="currentMarginBeforeDiscount" persistent="false" hb_formatType="percentage";
	property name="currentAssetValue" persistent="false" hb_formatType="currency";
	//property name="currentRevenueTotal" persistent="false" hb_formatType="currency";
	property name="averagePriceSold" persistent="false" hb_formatType="currency";
	property name="averagePriceSoldAfterDiscount" persistent="false" hb_formatType="currency";
	property name="averageDiscountAmount" persistent="false" hb_formatType="currency";
	property name="averageMarkup" persistent="false" hb_formatType="percentage";
	property name="averageLandedMarkup" persistent="false" hb_formatType="percentage";
	property name="averageProfit" persistent="false" hb_formatType="currency";
	property name="averageLandedProfit" persistent="false" hb_formatType="currency";
	property name="baseProductType" persistent="false";
	property name="currentAccountPrice" type="numeric" hb_formatType="currency" persistent="false";
	property name="currencyDetails" type="struct" persistent="false";
	property name="eligibleCurrencyCodeList" type="string" persistent="false";
	property name="defaultFlag" type="boolean" persistent="false";
	property name="eligibleFulfillmentMethods" type="array" persistent="false";
	property name="eventConflictsSmartList" persistent="false";
	property name="eventConflictExistsFlag" type="boolean" persistent="false";
	property name="eventOverbookedFlag" type="boolean" persistent="false";
	property name="giftCardExpirationTermOptions" persistent="false";
	property name="giftCardAutoGenerateCodeFlag" persistent="false";
	property name="giftCardRecipientRequiredFlag" persistent="false";
	property name="imageExistsFlag" type="boolean" persistent="false";
	property name="imageFileName" type="string" persistent="false";
	property name="imagePath" type="string" persistent="false";
	property name="livePrice" type="numeric" hb_formatType="currency" persistent="false";
	property name="locations" type="array" persistent="false";
	property name="nextEstimatedAvailableDate" type="string" persistent="false";
	property name="optionsByOptionGroupCodeStruct" persistent="false";
	property name="optionsByOptionGroupIDStruct" persistent="false";
	property name="optionsIDList" persistent="false";
	property name="placedOrderItemsSmartList" type="any" persistent="false";
	property name="productScheduleSmartList" type="any" persistent="false";
	property name="bundledSkusCount" type="any" persistent="false";
	property name="eventStatus" type="any" persistent="false";
	property name="qats" type="numeric" persistent="false";
	property name="qoh" type="numeric" persistent="false";
	property name="qoq" persistent="false";
	property name="registeredUserCount" type="integer" persistent="false";
	property name="registrantCount" type="integer" persistent="false";
	property name="registrantEmailList" type="array" persistent="false";
	property name="renewalMethod" persistent="false" hb_formFieldType="select";
	property name="salePriceDetails" type="struct" persistent="false";
	property name="salePrice" type="numeric" hb_formatType="currency" persistent="false";
	property name="salePriceDiscountType" type="string" persistent="false";
	property name="salePriceDiscountAmount" type="string" persistent="false";
	property name="salePriceExpirationDateTime" type="date" hb_formatType="datetime" persistent="false";
	property name="skuDefinition" persistent="false";
	property name="skuPricesCount" persistent="false";
	property name="stocksDeletableFlag" persistent="false" type="boolean";
	property name="transactionExistsFlag" persistent="false" type="boolean";
	property name="redemptionAmountTypeOptions" persistent="false";
	property name="formattedRedemptionAmount" persistent="false";
	property name="weight" persistent="false"; 
	property name="allowWaitlistedRegistrations" persistent="false";
	property name="lastCountedDateTime" ormtype="timestamp" persistent="false";
	property name="optionsHash" persistent="false";
	property name="inventoryTrackByOptions" persistent="false";
	property name="inventoryMeasurementUnitOptions" persistent="false";
	
	// Deprecated Properties


	// ==================== START: Logical Methods =========================	
	public any function getSkuBundleCollectionList(){
		var skuCollectionList = getService('skuService').getSkuCollectionList();
		skuCollectionList.addFilter('assignedSkuBundles.sku.skuID',getSkuID());
		return skuCollectionList;
	}
	
	public any function getVendorSkusSmartList(){
		var vendorSkuSmartList = getService('VendorOrderService').getVendorSkuSmartList();
		vendorSkuSmartList.addFilter('sku.skuID',this.getSkuID());
		return vendorSkuSmartList;
	}

	public numeric function getAveragePriceSold(required string currencyCode="USD"){
		return getDao('skuDao').getAveragePriceSold(skuID=this.getSkuID(),currencyCode=arguments.currencyCode);
	}
	
	public numeric function getAveragePriceSoldAfterDiscount(required string currencyCode="USD"){
		return getDao('skuDao').getAveragePriceSoldAfterDiscount(skuID=this.getSkuID(),currencyCode=arguments.currencyCode);
	}
	
	public numeric function getAverageDiscountAmount(required string currencyCode="USD"){
		return getDao('skuDao').getAverageDiscountAmount(skuID=this.getSkuID(),currencyCode=arguments.currencyCode);
	}

	public numeric function getCurrentAssetValue(required string currencyCode="USD"){
		return getQOH(currencyCode=arguments.currencyCode) * getAverageCost(arguments.currencyCode);
	}
	
//	public numeric function getCurrentRevenueTotal(){
//		
//		return getQuantity('QDOO') * getAveragePriceSold();
//	}
	
	public numeric function getCurrentMargin(required string currencyCode="USD"){
		return getDao('skuDao').getCurrentMargin(this.getSkuID(),arguments.currencyCode);
	}
	
	public numeric function getCurrentMarginBeforeDiscount(required string currencyCode="USD"){
		return getDao('skuDao').getCurrentMarginBeforeDiscount(this.getSkuID(),arguments.currencyCode);
	}
	
	public numeric function getCurrentLandedMargin(required string currencyCode="USD"){
		return getDao('skuDao').getCurrentLandedMargin(this.getSkuID(),arguments.currencyCode);
	}

	public numeric function getAverageProfit(required string currencyCode="USD"){
		return getDao('skuDao').getAverageProfit(this.getSkuID(),arguments.currencyCode);
	}
	
	public numeric function getAverageLandedProfit(required string currencyCode="USD"){
		return getDao('skuDao').getAverageLandedProfit(this.getSkuID(),arguments.currencyCode);
	}
	
	public numeric function getAverageMarkup(required string currencyCode="USD"){
		return getDao('skuDao').getAverageMarkup(this.getSkuID(),arguments.currencyCode);
	}
	
	public numeric function getAverageLandedMarkup(required string currencyCode="USD"){
		return getDao('skuDao').getAverageLandedMarkup(this.getSkuID(),arguments.currencyCode);
	}

	public array function getGiftCardExpirationTermOptions(){
		if(!structKeyExists(variables,'giftCardExpirationTermIDOptions')){
			variables.giftCardExpirationTermIDOptions = [];
			var termSmartList = getService('hibachiService').getTermSmartList();
			termSmartList.addSelect('termID','value');
			termSmartList.addSelect('termName','name');
			variables.giftCardExpirationTermIDOptions = termSmartList.getRecords();
			var option = {};
			option['name'] = 'None';
			option['value'] = '';
			arrayPrepend(variables.giftCardExpirationTermIDOptions,option);
		}
		return variables.giftCardExpirationTermIDOptions;
	}

	public boolean function getGiftCardAutoGenerateCodeFlag() {
		return setting('skuGiftCardAutoGenerateCode');
	}

	public boolean function getGiftCardRecipientRequiredFlag() {
		return setting('skuGiftCardRecipientRequired');
	}

	public array function getRedemptionAmountTypeOptions(){
		if(!structKeyExists(variables,'redemptionAmountTypeOptions')){

			variables.redemptionAmountTypeOptions = [];
			var optionValues = 'sameAsPrice,fixedAmount,percentage';
			var optionValuesArray = listToArray(optionValues);

			var option = {};
			option['name'] = rbKey('entity.Sku.redemptionAmountType.select');
			option['value'] = "";
			arrayAppend(variables.redemptionAmountTypeOptions,option);

			for(var optionValue in optionValuesArray){
				var option = {};
				option['name'] = rbKey('define.#optionValue#');
				option['value'] = optionValue;
				arrayAppend(variables.redemptionAmountTypeOptions,option);
			}
		}

		return variables.redemptionAmountTypeOptions;
	}

	public array function getInventoryTrackByOptions(){
		if(!structKeyExists(variables, 'inventoryTrackByOptions')){
			variables.inventoryTrackByOptions = ['Quantity','Measurement'];
		}
		return variables.inventoryTrackByOptions;
	}

	public array function getInventoryMeasurementUnitOptions(){
		if(!structKeyExists(variables,'inventoryMeasurementUnitOptions')){
			var measurementUnitCollection = getService('hibachiService').getMeasurementUnitCollectionList();
			measurementUnitCollection.setDisplayProperties('unitCode,unitName');
			var records = measurementUnitCollection.getRecords();
			var recordOptions = [{'name'='','value'=''}];
			for(var record in records){
				arrayAppend(recordOptions, {'name'=record.unitName,'value'=record.unitCode});
			}
			variables.inventoryMeasurementUnitOptions = recordOptions;
		}
		return variables.inventoryMeasurementUnitOptions;
	}

	// @hint Returns sku purchaseStartDateTime if defined, or product purchaseStartDateTime if not defined in sku.
	public any function getPurchaseStartDateTime() {
		if(!structKeyExists(variables, "purchaseStartDateTime")) {
			if(!isNull(getProduct())) {
				return getProduct().getPurchaseStartDateTime();
			}
		} else {
			return variables.purchaseStartDateTime;
		}
	}

	// @hint Returns sku purchaseEndDateTime if defined, or product purchaseStartDateTime if not defined in sku.
	public any function getPurchaseEndDateTime() {
		if(!structKeyExists(variables, "purchaseEndDateTime")) {
			if(!isNull(getProduct())) {
				return getProduct().getPurchaseEndDateTime();
			}
		} else {
			return variables.purchaseEndDateTime;
		}
	}

	//returns gift card redemption amount, or 0 if incorrectly configured
	public any function getRedemptionAmount(numeric userDefinedPrice){
    	var amount = getPrice();
	    if(
	        !isNull(getUserDefinedPriceFlag()) && getUserDefinedPriceFlag()
	    ){
	        if(structKeyExists(arguments,'userDefinedPrice')){
	            amount = arguments.userDefinedPrice;
	        }
	    }

	    if(structKeyExists(variables, "redemptionAmountType")){
	        switch(variables.redemptionAmountType){
	            case "sameAsPrice":
	                break;
	            case "fixedAmount":
	                if(!isNull(getUserDefinedPriceFlag()) && !getUserDefinedPriceFlag() && structKeyExists(variables, "redemptionAmount")){
	                    amount = variables.redemptionAmount;
	                }
	                break;
	            case "percentage":
	                amount = getService('HibachiUtilityService').precisionCalculate(getService('HibachiUtilityService').precisionCalculate(amount * variables.redemptionAmount)/100);
	                break;
	        }
	    }else{
	        amount = 0;
	    }

	    return amount;
	}


	public string function getFormattedRedemptionAmount(){

		if(this.isGiftCardSku() && structKeyExists(variables, "redemptionAmountType")){
			switch(variables.redemptionAmountType){
				case "percentage":
					return getService("HibachiUtilityService").formatValue_percentage(this.getRedemptionAmount());
					break;
				default:
					formatDetails = {};
					formatDetails.currencyCode = this.getCurrencyCode();
					return getService("HibachiUtilityService").formatValue_Currency(this.getRedemptionAmount(), formatDetails);
					break;
			}
		} else {
			return "";
		}

	}

	// START: Image Methods

	public string function getAllImageOptionCodes(){
		var optionString = "";
		for(var option in getOptions()){
			if(option.getOptionGroup().getImageGroupFlag()){
				optionString &= getProduct().setting('productImageOptionCodeDelimiter') & reReplaceNoCase(option.getOptionCode(), "[^a-z0-9\-\_]","","all");
			}
		}
		return optionString;
	}

	//@hint normally on missing method would handle this, but in the case of options it tries to use the wrong function.
	public any function getOptionsSmartList() {
    	return getPropertySmartList(propertyName="options");
	}

	//@hint Generates the image path based upon product code, and image options for this sku
	public string function generateImageFileName() {

		var imageNameString = getService("HibachiUtilityService").replaceStringTemplate(template=setting("skuDefaultImageNamingConvention"), object=this);
		var name = getService("HibachiUtilityService").createSEOString(imageNameString, getProduct().setting('productImageOptionCodeDelimiter'));
		var ext = ".#getProduct().setting('productImageDefaultExtension')#";

		return name & ext;
	}

	public string function getImageFileName() {
		return generateImageFileName();
	}

    public string function getImageExtension() {
		return listLast(getImageFile(), ".");
	}

	public string function getImagePath() {
   	 	return "#getHibachiScope().getBaseImageURL()#/product/default/#getImageFile()#";
    }

    public string function getImage() {
   	 	return getResizedImage(argumentcollection=arguments);
    }

	public string function getResizedImage() {

		// Setup Image Path
		arguments.imagePath = getImagePath();

		// Alt Title Setting
		if(!structKeyExists(arguments, "alt") && len(setting('imageAltString'))) {
			arguments.alt = stringReplace(setting('imageAltString'));
		}

		// Missing Image Path Setting
		if(!structKeyExists(arguments, "missingImagePath")) {
			arguments.missingImagePath = setting('imageMissingImagePath');
		}

		// DEPRECATED SIZE LOGIC
		if((structKeyExists(arguments, 1) || structKeyExists(arguments, "size")) && !isNull(getProduct()) && !structKeyExists(arguments, "width") && !structKeyExists(arguments, "height")) {
			if(structKeyExists(arguments, "size")) {
				var thisSize = lcase(arguments.size);
				structDelete(arguments, "size");
			} else if (structKeyExists(arguments, 1)) {
				var thisSize = lcase(arguments[1]);
				structDelete(arguments, 1);
			}
			if(thisSize eq "l") {
				thisSize = "Large";
			} else if (thisSize eq "m") {
				thisSize = "Medium";
			} else if (thisSize eq "s") {
				thisSize = "Small";
			}
			arguments.width = getProduct().setting("productImage#thisSize#Width");
			arguments.height = getProduct().setting("productImage#thisSize#Height");
			arguments.resizeMethod = "scaleBest";
		}

		return getService("imageService").getResizedImage(argumentCollection=arguments);
	}

	public string function getResizedImagePath() {

		// Setup Image Path
		arguments.imagePath = getImagePath();

		// Missing Image Path Setting
		if(!structKeyExists(arguments, "missingImagePath")) {
			arguments.missingImagePath = setting('imageMissingImagePath');
		}

		// DEPRECATED SIZE LOGIC
		if(structKeyExists(arguments, "size") && !isNull(getProduct()) && !structKeyExists(arguments, "width") && !structKeyExists(arguments, "height")) {
			arguments.size = lcase(arguments.size);
			if(arguments.size eq "l") {
				arguments.size = "Large";
			} else if (arguments.size eq "m") {
				arguments.size = "Medium";
			} else {
				arguments.size = "Small";
			}
			arguments.width = getProduct().setting("productImage#arguments.size#Width");
			arguments.height = getProduct().setting("productImage#arguments.size#Height");
			arguments.resizeMethod = "scaleBest";
			structDelete(arguments, "size");
		}

		return getService("imageService").getResizedImagePath(argumentCollection=arguments);
	}

	public boolean function getImageExistsFlag() {
		if( fileExists(expandPath(getImagePath())) ) {
			return true;
		} else {
			return false;
		}
	}

	// END: Image Methods

	public boolean function getEventConflictExistsFlag() {
		if( this.setting('skuEventEnforceConflicts') && !this.getBundleFlag()){
			var eventConflictsSmartList = getService("skuService").getEventConflictsSmartList(sku=this);
			
			if(eventConflictsSmartList.getRecordsCount() GT 0) {
				return true;
			}
		}
		return false;
	}

	public boolean function getEventOverbookedFlag() {
		if(getRegisteredUserCount() > getEventCapacity() ) {
			return true;
		}
		return false;
	}

	// START: Option Methods

	public string function getOptionsDisplay(delimiter=" ") {
    	var dspOptions = "";
    	for(var i=1;i<=arrayLen(getOptions());i++) {
    		dspOptions = listAppend(dspOptions, getOptions()[i].getOptionName(), arguments.delimiter);
    	}
		return dspOptions;
    }

	public any function getOptionByOptionGroupID(required string optionGroupID) {
		if(structKeyExists(getOptionsByOptionGroupIDStruct(), arguments.optionGroupID)) {
			return getOptionsByOptionGroupIDStruct()[ arguments.optionGroupID ];
		}
	}

	public any function getOptionByOptionGroupCode(required string optionGroupCode) {
		if(structKeyExists(getOptionsByOptionGroupCodeStruct(), arguments.optionGroupCode)) {
			return getOptionsByOptionGroupCodeStruct()[ arguments.optionGroupCode ];
		}
	}

	// END: Option Methods

	// START: Price / Currency Methods

	public numeric function getPriceByPromotion( required any promotion) {
		return getService("promotionService").calculateSkuPriceBasedOnPromotion(sku=this, promotion=arguments.promotion);
	}

	public numeric function getPriceByPriceGroup( required any priceGroup) {
		return getService("priceGroupService").calculateSkuPriceBasedOnPriceGroup(sku=this, priceGroup=arguments.priceGroup);
	}

	public numeric function getPriceByPriceGroupAndCurrencyCode( required any priceGroup,required string currencyCode) {
		return getService("priceGroupService").calculateSkuPriceBasedOnPriceGroupAndCurrencyCode(sku=this, priceGroup=arguments.priceGroup,currencyCode=arguments.currencyCode);
	}

	public any function getAppliedPriceGroupRateByPriceGroup( required any priceGroup) {
		return getService("priceGroupService").getRateForSkuBasedOnPriceGroup(sku=this, priceGroup=arguments.priceGroup);
	}

	public any function getPriceByCurrencyCode( string currencyCode='USD', numeric quantity=1, array priceGroups=getHibachiScope().getAccount().getPriceGroups() ) {
		var cacheKey = 'getPriceByCurrencyCode#arguments.currencyCode#';
		
		for(var priceGroup in arguments.priceGroups){
			cacheKey &= '_#priceGroup.getPriceGroupID()#';
		}
		
		if(structKeyExists(arguments, "quantity")){
			cacheKey &= '#arguments.quantity#';
			if(!structKeyExists(variables,cacheKey)){
				var skuPriceResults = getDAO("SkuPriceDAO").getSkuPricesForSkuCurrencyCodeAndQuantity(this.getSkuID(), arguments.currencyCode, arguments.quantity,arguments.priceGroups);
				if(!isNull(skuPriceResults) && isArray(skuPriceResults) && arrayLen(skuPriceResults) > 0){
					var prices = [];
					for(var i=1; i <= arrayLen(skuPriceResults); i++){
						ArrayAppend(prices, skuPriceResults[i]['price']);
					}
					ArraySort(prices, "numeric","asc");
					variables[cacheKey]= prices[1];
				} 
				
				if(structKeyExists(variables,cacheKey)){
					return variables[cacheKey];
				}
				
				var baseSkuPrice = getDAO("SkuPriceDAO").getBaseSkuPriceForSkuByCurrencyCode(this.getSkuID(), arguments.currencyCode);  
				if(!isNull(baseSkuPrice)){
					variables[cacheKey] = baseSkuPrice.getPrice(); 
				}
				
			}
			
			if(structKeyExists(variables,cacheKey)){
				return variables[cacheKey];
			}
			
		}
		
		
    	if(structKeyExists(getCurrencyDetails(), arguments.currencyCode)) {
    		variables[cacheKey]= getCurrencyDetails()[ arguments.currencyCode ].price;
    		return variables[cacheKey];
    	}
    }

    public any function getListPriceByCurrencyCode( required string currencyCode ) {
    	if(structKeyExists(getCurrencyDetails(), arguments.currencyCode) && structKeyExists(getCurrencyDetails()[ arguments.currencyCode ], "listPrice")) {
    		return getCurrencyDetails()[ arguments.currencyCode ].listPrice;
    	}
    }

    public any function getRenewalPriceByCurrencyCode( required string currencyCode ) {
    	if(structKeyExists(getCurrencyDetails(), arguments.currencyCode) && structKeyExists(getCurrencyDetails()[ arguments.currencyCode ], "renewalPrice")) {
    		return getCurrencyDetails()[ arguments.currencyCode ].renewalPrice;
    	}
    }

	// END: Price / Currency Methods

	public numeric function getWeight(){
		return this.setting( 'skuShippingWeight' );
	} 


	// START: Quantity Helper Methods

	public numeric function getQuantity(required string quantityType, string locationID, string stockID, string currencyCode) {


		// Request for calculated quantity
		if( listFindNoCase("MQATSBOM,QC,QE,QNC,QATS,QIATS,QOQ", arguments.quantityType) ) {
			// If this is a calculated quantity and locationID exists, then delegate
			if( structKeyExists(arguments, "locationID") ) {
				
				// Don't need to loop over locations for MQATSBOM as this is handled in the service calculationa.
				if (arguments.quantityType == 'MQATSBOM' ){
					var stock = getService("stockService").findStockBySkuIDAndLocationID(this.getSkuID(), arguments.locationID);

					
					return stock.getQuantity(arguments.quantityType);
					
				}else{
					//Need to get location and all children of location
					var locations = getService("locationService").getLocationAndChildren(arguments.locationID);
					var totalQuantity = 0;
					
					for(var i=1;i<=arraylen(locations);i++) {
						var location = getService('locationService').getLocation(locations[i]['value']);
						if ( arguments.quantityType != 'QATS' || ( arguments.quantityType == 'QATS' && ( !location.setting('locationExcludeFromQATS') && !location.hasChildLocation() )) ){
							var stock = getService("stockService").findStockBySkuIDAndLocationID(this.getSkuID(), locations[i]['value']);
							totalQuantity += stock.getQuantity(arguments.quantityType);
							
						}  
				}
				
				return totalQuantity;

				}

			// If this is a calculated quantity and stockID exists, then delegate
			} else if ( structKeyExists(arguments, "stockID") ) {
				var stock = getService("stockService").getStock(arguments.stockID);
				return stock.getQuantity(arguments.quantityType);
			}
		}

		// Standard Logic
		if( !structKeyExists(variables, arguments.quantityType) ) {
			if(listFindNoCase("QOH,QOSH,QNDOO,QNDORVO,QNDOSA,QNRORO,QNROVO,QNROSA,QDOO", arguments.quantityType)) {
				arguments.skuID = this.getSkuID();
				return getProduct().getQuantity(argumentCollection=arguments);
			} else if(listFindNoCase("MQATSBOM,QC,QE,QNC,QATS,QIATS,QOQ", arguments.quantityType)) {
				variables[ arguments.quantityType ] = getService("inventoryService").invokeMethod("get#arguments.quantityType#", {entity=this});
			} else {
				throw("The quantity type you passed in '#arguments.quantityType#' is not a valid quantity type.  Valid quantity types are: QOH, QOSH, QNDOO, QNDORVO, QNDOSA, QNRORO, QNROVO, QNROSA, QC, QE, QNC, QATS, QIATS");
			}
		}
		return variables[ arguments.quantityType ];
	}

	// END: Quantity Helper Methods

	// START: Gift Card Logical Methods

	public boolean function isGiftCardSku() {
		if(!isNull(this.getProduct()) && this.getProduct().getBaseProductType() == "gift-card"){
			return true;
		}
		return false;
	}

	// END: Gift Card Logical Methods

	//@hint Generates a unique event attendance code and sets it as this sku's code
	public string function generateAndSetAttendanceCode() {
		var uniq = false;
		var code = "";
		do {
			code = getService("EventRegistrationService").generateAttendanceCode(8);
			if(codeIsUnique(code)) {
				uniq = true;
			}
		} while (uniq == false);
		this.setEventAttendanceCode(code);
		return code;
	}

	// @hint Used to determine uniqueness of generated attendance code
	private boolean function codeIsUnique(required string code) {
		var result = false;
		var smartList =  getService("SkuService").getSkuSmartList();
		smartList.addFilter("eventAttendanceCode",arguments.code);
		if(smartList.getRecordsCount() == 0) {
			result = true;
		}
		return result;
	}


	// ====================  END: Logical Methods ==========================

	// ============ START: Non-Persistent Property Methods =================

	public string function getAdminIcon() {
		return getImage(width=55, height=55);
	}

	public any function getAssignedOrderItemAttributeSetSmartList(){
		if(!structKeyExists(variables, "assignedOrderItemAttributeSetSmartList")) {

			variables.assignedOrderItemAttributeSetSmartList = getService("attributeService").getAttributeSetSmartList();
			variables.assignedOrderItemAttributeSetSmartList.setSelectDistinctFlag(true);
			variables.assignedOrderItemAttributeSetSmartList.addFilter('activeFlag', 1);
			variables.assignedOrderItemAttributeSetSmartList.addFilter('attributeSetObject', 'OrderItem');

			variables.assignedOrderItemAttributeSetSmartList.joinRelatedProperty("SlatwallAttributeSet", "productTypes", "left");
			variables.assignedOrderItemAttributeSetSmartList.joinRelatedProperty("SlatwallAttributeSet", "products", "left");
			variables.assignedOrderItemAttributeSetSmartList.joinRelatedProperty("SlatwallAttributeSet", "brands", "left");
			variables.assignedOrderItemAttributeSetSmartList.joinRelatedProperty("SlatwallAttributeSet", "skus", "left");

			var wc = "(";
			wc &= " aslatwallattributeset.globalFlag = 1";
			wc &= " OR aslatwallproducttype.productTypeID IN ('#replace(getProduct().getProductType().getProductTypeIDPath(),",","','","all")#')";
			wc &= " OR aslatwallproduct.productID = '#getProduct().getProductID()#'";
			if(!isNull(getProduct().getBrand())) {
				wc &= " OR aslatwallbrand.brandID = '#getProduct().getBrand().getBrandID()#'";
			}
			wc &= " OR aslatwallsku.skuID = '#getSkuID()#'";
			wc &= ")";

			variables.assignedOrderItemAttributeSetSmartList.addWhereCondition( wc );
		}

		return variables.assignedOrderItemAttributeSetSmartList;
	}

	public any function getAssignedOrderItemAttributeSetCollectionList(){
		if(!structKeyExists(variables, 'assignedOrderItemAttributeSetCollectionList')){
			variables.assignedOrderItemAttributeSetCollectionList = getService('attributeService').getAttributeSetCollectionList();
			variables.assignedOrderItemAttributeSetCollectionList.addFilter('activeFlag',1);
			variables.assignedOrderItemAttributeSetCollectionList.addFilter('attributeSetObject','OrderItem');
			variables.assignedOrderItemAttributeSetCollectionList.addFilter('globalFlag',1,'=','OR','','group2');
			variables.assignedOrderItemAttributeSetCollectionList.addFilter('productTypes.productTypeID','#replace(getProduct().getProductType().getProductTypeIDPath(),",","','","all")#','IN','OR','','group2');
			variables.assignedOrderItemAttributeSetCollectionList.addFilter('products.productID',getProduct().getProductID(),'=','OR','','group2');
			if(!isNull(getProduct().getBrand())) {
				variables.assignedOrderItemAttributeSetCollectionList.addFilter('brands.brandID',getProduct().getBrand().getBrandID(),'=','OR','','group2');
			}
			variables.assignedOrderItemAttributeSetCollectionList.addFilter('skus.skuID',getSkuID(),'=','OR','','group2');
			
		}
		return variables.assignedOrderItemAttributeSetCollectionList;
	
	}

	// @hint Returns boolean indication whether this sku is available for purchase based on purchase start/end dates.
	public any function getAvailableForPurchaseFlag() {
		if(!structKeyExists(variables, "availableForPurchaseFlag")) {
			// If purchase dates are null OR now() is between purchase start and end dates then this product is available for purchase
			if(	getActiveFlag()
				&& (
				( isNull(this.getPurchaseStartDateTime()) && isNull(this.getPurchaseStartDateTime()) )
				|| ( !isNull(this.getPurchaseStartDateTime()) && !isNull(this.getPurchaseStartDateTime()) && dateCompare(now(),this.getPurchaseStartDateTime(),"s") == 1 && dateCompare(now(),this.getPurchaseEndDateTime(),"s") == -1 ) )
				)
			{
				variables.availableForPurchaseFlag = true;
			} else {
				variables.availableForPurchaseFlag = false;
			}
		}
		return variables.availableForPurchaseFlag;
	}

	// @hint Returns the number of seats that are still available for this event
	public any function getAvailableSeatCount() {
		if(!structkeyExists(variables,"availableSeatCount")) {
			if(this.getProduct().getBaseProductType() == "event") {
				variables.availableSeatCount = this.getEventCapacity() - getService("EventRegistrationService").getNonWaitlistedCountBySku(this);
			} else {
				variables.availableSeatCount = "N/A";
			}
		}
		return variables.availableSeatCount;
	}

	public any function getBaseProductType() {
		if(!isnull(getProduct()) && !isnull(getProduct().getBaseProductType())){
			return getProduct().getBaseProductType();
		}
	}

	public string function getCurrencyCode() {
		if(!structKeyExists(variables, "currencyCode")) {
				this.setCurrencyCode(this.setting('skuCurrency'));

			}
		return variables.currencyCode;
	}

	public string function getEligibleCurrencyCodeList(){
		if(!structKeyExists(variables, "eligibleCurrencyCodeList")) {
			variables.currencyCodeList = "";

			for(var key in this.getCurrencyDetails()){
				variables.currencyCodeList = listAppend(variables.currencyCodeList, key);
			}
		}
		return variables.currencyCodeList;
	}

	public struct function getCurrencyDetails() {
		if(!structKeyExists(variables, "currencyDetails")) {
			variables.currencyDetails = {};

			var eligibleCurrencyCL = getService("currencyService").getCurrencyCollectionList();
 			eligibleCurrencyCL.setDisplayProperties('currencyCode');

			if(len(setting('skuEligibleCurrencies'))) {

				eligibleCurrencyCL.addFilter('currencyCode', setting('skuEligibleCurrencies'),'IN');
 				var currencies = eligibleCurrencyCL.getRecords();

				for(var i = 1; i<=arrayLen(currencies); i++) {

					var currentCurrencyCode = currencies[i]['currencyCode'];

					variables.currencyDetails[ currentCurrencyCode ] = {};
					variables.currencyDetails[ currentCurrencyCode ].skuCurrencyID = "";

					// Check to see if thisCurrency is the same as the 	 currency
					if(currentCurrencyCode eq this.setting('skuCurrency')) {
						if(!isNull(getRenewalPrice())) {
							variables.currencyDetails[ currentCurrencyCode ].renewalPrice = getRenewalPrice();
							variables.currencyDetails[ currentCurrencyCode ].renewalPriceFormatted = getFormattedValue("renewalPrice");
						}
						if(!isNull(getListPrice())) {
							variables.currencyDetails[ currentCurrencyCode ].listPrice = getListPrice();
							variables.currencyDetails[ currentCurrencyCode ].listPriceFormatted = getFormattedValue("listPrice");
						}
						variables.currencyDetails[ currentCurrencyCode ].price = getPrice();
						variables.currencyDetails[ currentCurrencyCode ].priceFormatted = getFormattedValue("price");
						variables.currencyDetails[ currentCurrencyCode ].converted = false;
					}
					// Look through the definitions to see if this currency is defined for this sku
					var baseSkuPriceForCurrencyCode = getDAO("SkuPriceDAO").getBaseSkuPriceForSkuByCurrencyCode(this.getSkuID(), currentCurrencyCode);
					if(!isNull(baseSkuPriceForCurrencyCode)){
						if(!isNull(baseSkuPriceForCurrencyCode.getRenewalPrice())) {
							variables.currencyDetails[ currentCurrencyCode ].renewalPrice = baseSkuPriceForCurrencyCode.getRenewalPrice();
							variables.currencyDetails[ currentCurrencyCode ].renewalPriceFormatted = baseSkuPriceForCurrencyCode.getFormattedValue("renewalPrice");
						}
						if(!isNull(baseSkuPriceForCurrencyCode.getListPrice())) {
							variables.currencyDetails[ currentCurrencyCode ].listPrice = baseSkuPriceForCurrencyCode.getListPrice();
							variables.currencyDetails[ currentCurrencyCode ].listPriceFormatted = baseSkuPriceForCurrencyCode.getFormattedValue("listPrice");
						}
						variables.currencyDetails[ currentCurrencyCode ].price = baseSkuPriceForCurrencyCode.getPrice();
						variables.currencyDetails[ currentCurrencyCode ].priceFormatted = baseSkuPriceForCurrencyCode.getFormattedValue("price");
						variables.currencyDetails[ currentCurrencyCode ].converted = false;
						variables.currencyDetails[ currentCurrencyCode ].skuPriceID = baseSkuPriceForCurrencyCode.getSkuPriceID();

					}
					// Use a conversion mechinism
					if(!structKeyExists(variables.currencyDetails[ currentCurrencyCode ], "price")) {
						if(!isNull(getRenewalPrice())) {
							variables.currencyDetails[ currentCurrencyCode ].renewalPrice = getService("currencyService").convertCurrency(getRenewalPrice(), this.setting('skuCurrency'), currentCurrencyCode);
							variables.currencyDetails[ currentCurrencyCode ].renewalPriceFormatted = formatValue( variables.currencyDetails[ currentCurrencyCode ].renewalPrice, "currency", {currencyCode=currentCurrencyCode});
						}
						if(!isNull(getListPrice())) {
							variables.currencyDetails[ currentCurrencyCode ].listPrice = getService("currencyService").convertCurrency(getListPrice(), this.setting('skuCurrency'), currentCurrencyCode);
							variables.currencyDetails[ currentCurrencyCode ].listPriceFormatted = formatValue( variables.currencyDetails[ currentCurrencyCode ].listPrice, "currency", {currencyCode=currentCurrencyCode});
						}
						if(!isNull(getPrice())) {
							if(!isNull(getPrice())) {
								variables.currencyDetails[ currentCurrencyCode ].price = getService("currencyService").convertCurrency(getPrice(), this.setting('skuCurrency'), currentCurrencyCode);
							} else {
								variables.currencyDetails[ currentCurrencyCode ].price = 0;
							}
						} else {
							variables.currencyDetails[ currentCurrencyCode ].price = 0;
						}
						variables.currencyDetails[ currentCurrencyCode ].priceFormatted = formatValue( variables.currencyDetails[ currentCurrencyCode ].price, "currency", {currencyCode=currentCurrencyCode});
						variables.currencyDetails[ currentCurrencyCode ].converted = true;
					}
				}
			}
		}
		return variables.currencyDetails;
	}
	/**
	* @Suppress
	*/
	public any function getCurrentAccountPrice() {
		if(!structKeyExists(variables, "currentAccountPrice")) {
			variables.currentAccountPrice = getService("priceGroupService").calculateSkuPriceBasedOnCurrentAccount(sku=this);
		}
		return variables.currentAccountPrice;
	}
	
	public any function getPriceByAccount(required any account) {
		if(!structKeyExists(variables, "accountPrice")) {
			variables.accountPrice = getService("priceGroupService").calculateSkuPriceBasedOnAccount(sku=this, account=arguments.account);
		}
		return variables.accountPrice;
	}


	public any function getCurrentAccountPriceByCurrencyCode(required string currencyCode) {
		if(!structKeyExists(variables, "currentAccountPrice_#arguments.currencyCode#")) {
			variables["currentAccountPrice_#arguments.currencyCode#"] = getService("priceGroupService").calculateSkuPriceBasedOnCurrentAccountAndCurrencyCode(sku=this, currencyCode=arguments.currencyCode);
			if(!structKeyExists(variables, "currentAccountPrice_#arguments.currencyCode#")) {
				return;	
			}
		}
		
		return variables["currentAccountPrice_#arguments.currencyCode#"];
	}

	public any function getPriceByCurrencyCodeAndAccount(required string currencyCode, required any account) {
		if(!structKeyExists(variables, "accountPrice_#arguments.currencyCode#")) {
			variables["accountPrice_#arguments.currencyCode#"] = getService("priceGroupService").calculateSkuPriceBasedOnAccountAndCurrencyCode(sku=this, account=arguments.account, currencyCode=arguments.currencyCode);
			if(!structKeyExists(variables, "AccountPrice_#arguments.currencyCode#")) {
				return;	
			}
		}
		
		return variables["accountPrice_#arguments.currencyCode#"];
	}
	
	public boolean function getDefaultFlag() {
    	if(!isNull(getProduct().getDefaultSku()) && getProduct().getDefaultSku().getSkuID() == getSkuID()) {
    		return true;
    	}
    	return false;
    }

	public array function getEligibleFulfillmentMethods() {
		if(!structKeyExists(variables, "eligibleFulfillmentMethods")) {
			var sl = getService("fulfillmentService").getFulfillmentMethodSmartList();
			sl.addInFilter('fulfillmentMethodID', setting('skuEligibleFulfillmentMethods'));
			sl.addOrder('sortOrder|ASC');
			variables.eligibleFulfillmentMethods = sl.getRecords();
		}
		return variables.eligibleFulfillmentMethods;
	}

	public any function getBundledSkusCount() {
		if(!structKeyExists(variables, "bundledSkusCount")){
			variables.bundledSkusCount = 0;
			if(arrayLen(this.getBundledSkus())){
				variables.bundledSkusCount = arrayLen(this.getBundledSkus());
			}
		}
		return variables.bundledSkusCount;
	}

	// @hint Returns count of registered or waitlisted users associated with this sku
	public any function getRegistrantCount() {
		if(!structKeyExists(variables, "registrantCount")) {
			variables.registrantCount = 0;
			if(arrayLen(this.getEventRegistrations())) {
				variables.registrantCount = arrayLen(this.getEventRegistrations());
			}
		}
		return variables.registrantCount;
	}

	// @hint Returns count of registered or pending confirmation users associated with this sku
	public any function getRegisteredUserCount() {
		if(!structKeyExists(variables, "registeredUserCount")) {
			var ruCount = 0;
			if(arrayLen(this.getEventRegistrations())) {
				var statusList = "#getService('typeService').getTypeBySystemCode('erstRegistered').getTypeID()#,#getService('typeService').getTypeBySystemCode('erstPendingConfirmation').getTypeID()#";
				for(var er in this.getEventRegistrations()) {
					if( listFindNoCase( statusList, er.getEventRegistrationStatusType().getTypeID() ) ) {
						ruCount++;
					}
				}
			}
			variables.registeredUserCount = ruCount;
		}
		return variables.registeredUserCount;
	}

	public any function getSkuPricesCount() {
		if(!structKeyExists(variables, "skuPricesCount")){
			variables.skuPricesCount = 0;
			if(arrayLen(this.getSkuPrices())){
				variables.skuPricesCount = arrayLen(this.getSkuPrices());
			}
		}
		return variables.skuPricesCount;
	}


	// @hint Returns a list of registrant emails for this sku
	public any function getRegistrantEmailList() {
		if(!structKeyExists(variables, "registrantEmailList")) {
			variables.registrantEmailList = [];
			var eventRegistrationsSmartList = getEventRegistrations();
			for(var registration in eventRegistrationsSmartList.getRecords()) {
				if( len(registration.getemailaddress().getemailaddress()) ) {
					arrayAppend(variables.registrantEmailList,registration.getemailaddress().getemailaddress());
				}
			}
		}
		return variables.registrantEmailList;
	}
	
	// @hint Returns the renewal price for this sku
	public any function getRenewalPrice(){
		if(!isNull(this.getRenewalSku())){
			return this.getRenewalSku().getPrice();
		} else if(!structKeyExists(variables, "renewalPrice")){
			variables.renewalPrice = 0;
			
			if(!isNull(getPrice())) {
				variables.renewalPrice = getPrice();
			}
		}
		return variables.renewalPrice;
	}

	// @hint Returns the status of this event
	public any function getEventStatus() {
		if(!structKeyExists(variables, "eventStatus")) {
			variables.eventStatus = getService("settingService").getTypeBySystemCode('estRegOpen');
			if(now() > getstartReservationDateTime() ){
				variables.eventStatus = getService("settingService").getTypeBySystemCode('estRegClosed');
			}
		}
		return variables.eventStatus;
	}

	// @hint Retrieve event registrations related to this sku
	public any function getEventRegistrationsSmartlist() {
		if(!structKeyExists(variables, "eventRegistrationsSmartList")) {
			variables.eventRegistrationsSmartList = getService("EventRegistrationService").getEventRegistrationSmartList();
			variables.eventRegistrationsSmartList.addFilter('sku.skuID', "#getSkuID()#");
		}
		return variables.eventRegistrationsSmartList;
	}

	// Retrieve event registrations related to this sku
	public any function getRegistrationAttendanceSmartlist() {
		if(!structKeyExists(variables, "registrationAttendanceSmartlist")) {
			var smartList = getService("eventRegistrationService").getRegistrationAttendenceSmartList();
			smartlist.addFilter('skuID','#this.getSkuID()#');
			variables.registrationAttendanceSmartlist = smartList;
		}

		return variables.registrationAttendanceSmartlist;
	}

	public string function getNextEstimatedAvailableDate() {
		if(!structKeyExists(variables, "nextEstimatedAvailableDate")) {
			if(getQuantity("QIATS") > 0) {
				return dateFormat(now(), setting('globalDateFormat'));
			}
			var quantityNeeded = getQuantity("QNC") * -1;
			var dates = getProduct().getEstimatedReceivalDates( skuID=getSkuID() );
			for(var i = 1; i<=arrayLen(dates); i++) {
				if(quantityNeeded lt dates[i].quantity) {
					if(dates[i].estimatedReceivalDateTime gt now()) {
						return dateFormat(dates[i].estimatedReceivalDateTime, setting('globalDateFormat'));
					}
					return dateFormat(now(), setting('globalDateFormat'));
				} else {
					quantityNeeded - dates[i].quantity;
				}
			}
		}

		return "";
	}

	public any function getLivePrice() {
		if(!structKeyExists(variables, "livePrice")) {
			// Create a prices array, and add the
			var prices = [getPrice()];
			// Add the current account price, and sale price
			arrayAppend(prices, getSalePrice());
			arrayAppend(prices, getCurrentAccountPrice());
			// Sort by best price
			arraySort(prices, "numeric", "asc");
			// set that in the variables scope
			variables.livePrice = prices[1];
		}
		return variables.livePrice;
	}

	public any function getLivePriceByCurrencyCode(required string currencyCode, numeric quantity=1, any account = getHibachiScope().getAccount()) {
		
		if(!structKeyExists(variables, "livePrice_#arguments.currencyCode##arguments.quantity##arguments.account.getAccountID()#")) {
			// Create a prices array, and add the
			var price = getPriceByCurrencyCode(arguments.currencyCode, arguments.quantity, arguments.account.getPriceGroups());
			var prices = [];
			if(!isNull(price)){
				arrayAppend(prices,price);
			}

			// Add the current account price, and sale price
			var salePrice = getSalePriceByCurrencyCode(currencyCode=arguments.currencyCode, quantity=arguments.quantity);
			if(!isNull(salePrice)){
				arrayAppend(prices,salePrice);
			}
			
			var currentAccountPrice = getPriceByCurrencyCodeAndAccount(currencyCode=arguments.currencyCode, account=arguments.account);
			// var currentAccountPrice = getCurrentAccountPriceByCurrencyCode(currencyCode=arguments.currencyCode);
			if(!isNull(currentAccountPrice)){
				arrayAppend(prices, currentAccountPrice);	
			}

			if(!arraylen(prices)){
				return;
			}

			// Sort by best price
			arraySort(prices, "numeric", "asc");
			
			// set that in the variables scope
			variables["livePrice_#arguments.currencyCode##arguments.quantity##arguments.account.getAccountID()#"]= prices[1];
		
			
		}
		if(structKeyExists(variables,'livePrice_#arguments.currencyCode##arguments.quantity##arguments.account.getAccountID()#')){
			return variables["livePrice_#arguments.currencyCode##arguments.quantity##arguments.account.getAccountID()#"];
		}
	}


	/**
	* Returns an array of locations associated with this sku.
	*/
	public any function getLocations() {
		if(!structKeyExists(variables,"locations")) {
			variables.locations = [];
			if(this.hasLocationConfiguration()) {
				for(var config in this.getLocationConfigurations()) {
					arrayAppend(variables.locations,config.getLocation());
				}
			}
		}
		return variables.locations;
	}

	public any function getOptionsByOptionGroupCodeStruct() {
		if(!structKeyExists(variables, "optionsByOptionGroupCodeStruct")) {
			variables.optionsByOptionGroupCodeStruct = {};
			for(var option in getOptions()) {
				if( !structKeyExists(variables.optionsByOptionGroupCodeStruct, option.getOptionGroup().getOptionGroupCode())){
					variables.optionsByOptionGroupCodeStruct[ option.getOptionGroup().getOptionGroupCode() ] = option;
				}
			}
		}
		return variables.optionsByOptionGroupCodeStruct;
	}

	public any function getOptionsByOptionGroupIDStruct() {
		if(!structKeyExists(variables, "optionsByOptionGroupIDStruct")) {
			variables.optionsByOptionGroupIDStruct = {};
			for(var option in getOptions()) {
				if( !structKeyExists(variables.optionsByOptionGroupIDStruct, option.getOptionGroup().getOptionGroupID())){
					variables.OptionsByGroupIDStruct[ option.getOptionGroup().getOptionGroupID() ] = option;
				}
			}
		}
		return variables.optionsByOptionGroupIDStruct;
	}

	public string function getOptionsIDList() {
    	if(!structKeyExists(variables, "optionsIDList")) {
    		variables.optionsIDList = "";
    		
    		var optionsCollectionList = getService('OptionService').getOptionCollectionList();
    		optionsCollectionList.addFilter('skus.skuID',this.getSkuID());
    		optionsCollectionList.setOrderBy('optionID');
    		for(var option in optionsCollectionList.getRecords()) {
	    		variables.optionsIDList = listAppend(variables.optionsIDList, option['optionID']);
	    	}
    	}

		return variables.optionsIDList;
    }

    public any function getPlacedOrderItemsSmartList() {
		if(!structKeyExists(variables, "placedOrderItemsSmartList")) {
			variables.placedOrderItemsSmartList = getService("OrderService").getOrderItemSmartList();
			variables.placedOrderItemsSmartList.addFilter('sku.skuID', getSkuID());
			variables.placedOrderItemsSmartList.addInFilter('order.orderStatusType.systemCode', 'ostNew,ostProcessing,ostOnHold,ostClosed,ostCanceled');
		}

		return variables.placedOrderItemsSmartList;
	}
	
	public any function getPlacedOrderItemsCollectionList() {
		if(!structKeyExists(variables, "placedOrderItemsCollectionList")) {
			variables.placedOrderItemsCollectionList = getService("OrderService").getOrderItemCollectionList();
			variables.placedOrderItemsCollectionList.addFilter('sku.skuID', getSkuID());
			variables.placedOrderItemsCollectionList.addFilter('order.orderStatusType.systemCode', 'ostNew,ostProcessing,ostOnHold,ostClosed,ostCanceled','IN');
		}

		return variables.placedOrderItemsCollectionList;
	}

	public any function getPlacedVendorOrderItemsSmartList() {
		if(!structKeyExists(variables, "placedVendorOrderItemsSmartList")) {
			variables.placedVendorOrderItemsSmartList = getService("VendorOrderService").getVendorOrderItemSmartList();
			variables.placedVendorOrderItemsSmartList.addFilter('stock.sku.skuID', getSkuID());
			variables.placedVendorOrderItemsSmartList.addInFilter('vendorOrder.vendorOrderStatusType.systemCode','vostNew,vostPartiallyReceived,vostClosed');
		}

		return variables.placedVendorOrderItemsSmartList;
	}

	public any function getQATS(string locationID) {
		if ( structKeyExists(arguments, 'locationID') ){
			return getQuantity(quantityType="QATS", locationID=arguments.locationID );
		}	
		return getQuantity("QATS");
	}

	public any function getQOH(string locationID,string currencyCode) {
		var params = {quantityType="QOH"};
		if(structKeyExists(arguments,'currencyCode') && len(arguments.currencyCode)){
			params.currencyCode=arguments.currencyCode;
		}
		if ( structKeyExists(arguments, 'locationID') && len(arguments.locationID) ){
			params.locationID=arguments.locationID;
		}
		return getQuantity(argumentCollection=params);
	}
	
	public any function getQOQ(string locationID) {
		if ( structKeyExists(arguments, 'locationID') ){
			return getQuantity(quantityType="QOQ", locationID=arguments.locationID );
		}	
		return getQuantity("QOQ");
	}

	/**
	* @Suppress
	*/
	public any function getSalePriceDetails() {
		if(!structKeyExists(variables, "salePriceDetails")) {
			variables.salePriceDetails = getProduct().getSkuSalePriceDetails(skuID=getSkuID());
		}
		return variables.salePriceDetails;
	}
	/**
	* @Suppress
	*/
	public any function getSalePriceDetailsByCurrencyCode(required string currencyCode) {
		if(!structKeyExists(variables, "salePriceDetailsByCurrencyCode_#currencyCode#")) {
			variables["salePriceDetails_#currencyCode#"] = getProduct().getSkuSalePriceDetailsByCurrencyCode(skuID=getSkuID(),currencyCode=arguments.currencyCode);
		}
		return variables["salePriceDetails_#currencyCode#"] ;
	}

	public any function getSalePrice() {
		if(structKeyExists(getSalePriceDetails(), "salePrice")) {
			return getSalePriceDetails()[ "salePrice"];
		}
		return getPrice();
	}

	public any function getSalePriceByCurrencyCode(required string currencyCode, numeric quantity) {
		if(structKeyExists(getSalePriceDetailsByCurrencyCode(arguments.currencyCode), "salePrice")) {
			return getSalePriceDetailsByCurrencyCode(arguments.currencyCode)[ "salePrice"];
		}
		return getPriceByCurrencyCode(arguments.currencyCode);
	}

	public any function getSalePriceDiscountType() {
		if(structKeyExists(getSalePriceDetails(), "salePriceDiscountType")) {
			return getSalePriceDetails()[ "salePriceDiscountType"];
		}
		return "";
	}

	public any function getSalePriceExpirationDateTime() {
		if(structKeyExists(getSalePriceDetails(), "salePriceExpirationDateTime")) {
			return getSalePriceDetails()[ "salePriceExpirationDateTime"];
		}
		return "";
	}

	public boolean function getStocksDeletableFlag() {
		if(!structKeyExists(variables, "stocksDeletableFlag")) {
			variables.stocksDeletableFlag = getService("skuService").getSkuStocksDeletableFlag( skuID=this.getSkuID() );
		}
		return variables.stocksDeletableFlag;
	}

	public string function getSkuDefinitionByBaseProductType(string baseProductType){
		
		var skuDefinition = "";
		if(isNull(arguments.baseProductType)){
			arguments.baseProductType = "";
		}
		
		switch (arguments.baseProductType)
		{
			case "merchandise":
				skuDefinition = skuDefinition & getDao('skuDao').getSkuDefinitionForMerchandiseBySkuID(getSkuID());
	    		break;

	    	case "subscription":
	    		if(!isNull(getSubscriptionTerm()) && !isNull(getSubscriptionTerm().getSubscriptionTermName())){
	    			skuDefinition = "#rbKey('entity.subscriptionTerm')#: #getSubscriptionTerm().getSubscriptionTermName()#";
	    		}
				break;

			case "event":
				var configs = this.getLocationConfigurations();
				
				for (var i=1; i <= this.getLocationConfigurationsCount(); i++ ){
					skuDefinition = skuDefinition & configs[i].getlocationPathName() & "(#configs[i].getLocationConfigurationName()#)";
				
					if (i != this.getLocationConfigurationsCount()){
						skuDefinition = skuDefinition & ', ';
					}
				}
				break;

			default:
				skuDefinition = "";
		}
		return skuDefinition;
	}

	public string function getSkuDefinition() {
		if(!structKeyExists(variables, "skuDefinition")) {
			variables.skuDefinition = getSkuDefinitionByBaseProductType(getBaseProductType());

			if(variables.skuDefinition == "" && !isNull(getSkuName())){
				variables.skuDefinition = getSkuName();
			}
		}
		return trim(variables.skuDefinition);
	}

	public any function getLastCountedDateTime() {
		if(!structKeyExists(variables, "lastCountedDateTime")) {
			var pcisl = getService('physicalService').getPhysicalCountItemSmartlist();
			pcisl.addFilter("Stock.Sku.skuID",this.getSkuId());
			pcisl.addOrder("countPostDateTime desc");
			if(arrayLen(pcisl.getRecords())) {
				variables.lastCountedDateTime = pcisl.getRecords()[1].getCountPostDateTime();
			} else {
				variables.lastCountedDateTime = "";
			}
		}
		if(structKeyExists(variables,'lastCountedDateTime')){
			return variables.lastCountedDateTime;
		}
	}

	public boolean function getTransactionExistsFlag() {
		if(!structKeyExists(variables, "transactionExistsFlag")) {
			variables.transactionExistsFlag = getService("skuService").getTransactionExistsFlag( skuID=this.getSkuID() );
		}
		return variables.transactionExistsFlag;
	}
	
	public boolean function allowWaitlistedRegistrations() {
 		if (this.getAvailableSeatCount() <= 0 ){
			if(this.getAllowEventWaitlistingFlag() == 0){
				return false;
			}
		}
		return true;
	}

	public any function getAverageCost(required string currencyCode, any location){
		var params.skuID = this.getSkuID();
		params.currencyCode = arguments.currencyCode;
		if(!isNull(arguments.location)){
			params.locationID=arguments.location.getLocationID();
		}
		
		return getDao('skuDao').getAverageCost(argumentCollection=params);
	}
	
	public any function getAverageLandedCost(required string currencyCode, any location){
		var params.skuID = this.getSkuID();
		params.currencyCode = arguments.currencyCode;
		if(!isNull(arguments.location)){
			params.locationID=arguments.location.getLocationID();
		}
		
		return getDao('skuDao').getAverageLandedCost(argumentCollection=params);
	}


	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	// Product (many-to-one)
	public void function setProduct(required any product) {
		variables.product = arguments.product;
		if(isNew() or !arguments.product.hasSku( this )) {
			arrayAppend(arguments.product.getSkus(), this);
		}
	}
	public void function removeProduct(any product) {
		if(!structKeyExists(arguments, "product")) {
			arguments.product = variables.product;
		}
		var index = arrayFind(arguments.product.getSkus(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.product.getSkus(), index);
		}
		structDelete(variables, "product");
	}

	// Product Schedule (many-to-one)
	public void function setProductSchedule(required any productSchedule) {
		variables.productSchedule = arguments.productSchedule;
		if(isNew() or !arguments.productSchedule.hasSku( this )) {
			arrayAppend(arguments.productSchedule.getSkus(), this);
		}
	}
	public void function removeProductSchedule(any productSchedule) {
		if(!structKeyExists(arguments, "productSchedule")) {
			arguments.productSchedule = variables.productSchedule;
		}
		var index = arrayFind(arguments.productSchedule.getSkus(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.productSchedule.getSkus(), index);
		}
		structDelete(variables, "productSchedule");
	}

	// SubscriptionTerm (many-to-one)
	public void function setSubscriptionTerm(required any subscriptionTerm) {
		variables.subscriptionTerm = arguments.subscriptionTerm;
		if(isNew() or !arguments.subscriptionTerm.hasSku( this )) {
			arrayAppend(arguments.subscriptionTerm.getSkus(), this);
		}
	}
	public void function removeSubscriptionTerm(any subscriptionTerm) {
		if(!structKeyExists(arguments, "subscriptionTerm")) {
			arguments.subscriptionTerm = variables.subscriptionTerm;
		}
		var index = arrayFind(arguments.subscriptionTerm.getSkus(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.subscriptionTerm.getSkus(), index);
		}
		structDelete(variables, "subscriptionTerm");
	}

	// Alternate Sku Codes (one-to-many)
	public void function addAlternateSkuCode(required any alternateSkuCode) {
		arguments.alternateSkuCode.setSku( this );
	}
	public void function removeAlternateSkuCode(required any alternateSkuCode) {
		arguments.alternateSkuCode.removeSku( this );
	}

	// Attribute Values (one-to-many)
	public void function addAttributeValue(required any attributeValue) {
		arguments.attributeValue.setSku( this );
	}
	public void function removeAttributeValue(required any attributeValue) {
		arguments.attributeValue.removeSku( this );
	}
	
	// Event Registrations (one-to-many)    
	public void function addEventRegistrations(required any eventRegistration) {    
		arguments.eventRegistration.setSku( this );    
	}    
	public void function removeEventRegistration(required any eventRegistration) {    
		arguments.eventRegistration.removeSku( this );    
	}
	
	// Sku Currencies (one-to-many)    
	public void function addSkuCurrency(required any skuCurrency) {    
		arguments.skuCurrency.setSku( this );    
	}    
	public void function removeSkuCurrency(required any skuCurrency) {    
		arguments.skuCurrency.removeSku( this );    
	}

	// Stocks (one-to-many)
	public void function addStock(required any stock) {
		arguments.stock.setSku( this );
	}
	public void function removeStock(required any stock) {
		arguments.stock.removeSku( this );
	}

	// Product Bundle Groups (one-to-many)
	public void function addProductBundleGroup(required any productBundleGroup) {
		arguments.productBundleGroup.setProductBundleSku( this );
	}
	public void function removeProductBundleGroup(required any productBundleGroup) {
		arguments.productBundleGroup.removeProductBundleSku( this );
	}

	// Product Reviews (one-to-many)
	public void function addProductReview(required any productReview) {
		arguments.productReview.setSku( this );
	}
	public void function removeProductReview(required any productReview) {
		arguments.productReview.removeSku( this );
	}

	// Bundled Skus (one-to-many)
	public void function addBundledSku(required any bundledSku) {
		arguments.bundledSku.setSku( this );
	}
	public void function removeBundledSku(required any bundledSku) {
		arguments.bundledSku.removeSku( this );
	}

	// Access Contents (many-to-many - owner)
	public void function addAccessContent(required any accessContent) {
		if(isNew() or !hasAccessContent(arguments.accessContent)) {
			arrayAppend(variables.accessContents, arguments.accessContent);
		}
		if(arguments.accessContent.isNew() or !arguments.accessContent.hasSku( this )) {
			arrayAppend(arguments.accessContent.getSkus(), this);
		}
	}
	public void function removeAccessContent(required any accessContent) {
		var thisIndex = arrayFind(variables.accessContents, arguments.accessContent);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.accessContents, thisIndex);
		}
		var thatIndex = arrayFind(arguments.accessContent.getSkus(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.accessContent.getSkus(), thatIndex);
		}
	}
	
		// Assigned Alternate Images (many-to-many - owner)
	public void function addAssignedAlternateImage(required any image) {
		if(isNew() or !hasAssignedAlternateImage(arguments.image)) {
			arrayAppend(variables.assignedAlternateImages, arguments.image);
		}
		if(arguments.image.isNew() or !arguments.image.hasAssignedSku( this )) {
			arrayAppend(arguments.image.getAssignedSkus(), this);
		}
	}
	public void function removeAssignedAlternateImage(required any image) {
		var thisIndex = arrayFind(variables.assignedAlternateImages, arguments.image);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.assignedAlternateImages, thisIndex);
		}
		var thatIndex = arrayFind(arguments.image.getAssignedSkus(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.image.getAssignedSkus(), thatIndex);
		}
	}

	// Subscription Benefits (many-to-many - owner)
	public void function addSubscriptionBenefit(required any subscriptionBenefit) {
		if(arguments.subscriptionBenefit.isNew() or !hasSubscriptionBenefit(arguments.subscriptionBenefit)) {
			arrayAppend(variables.subscriptionBenefits, arguments.subscriptionBenefit);
		}
		if(isNew() or !arguments.subscriptionBenefit.hasSku( this )) {
			arrayAppend(arguments.subscriptionBenefit.getSkus(), this);
		}
	}
	public void function removeSubscriptionBenefit(required any subscriptionBenefit) {
		var thisIndex = arrayFind(variables.subscriptionBenefits, arguments.subscriptionBenefit);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.subscriptionBenefits, thisIndex);
		}
		var thatIndex = arrayFind(arguments.subscriptionBenefit.getSkus(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.subscriptionBenefit.getSkus(), thatIndex);
		}
	}

	// Location Configurations (many-to-many - owner)
	public void function addLocationConfiguration(required any locationConfiguration) {
		if(arguments.locationConfiguration.isNew() or !hasLocationConfiguration(arguments.locationConfiguration)) {
			arrayAppend(variables.locationConfigurations, arguments.locationConfiguration);
		}
		if(isNew() or !arguments.locationConfiguration.hasSku( this )) {
			arrayAppend(arguments.locationConfiguration.getSkus(), this);
		}
	}
	public void function removeLocationConfiguration(required any locationConfiguration) {
		var thisIndex = arrayFind(variables.locationConfigurations, arguments.locationConfiguration);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.locationConfigurations, thisIndex);
		}
		var thatIndex = arrayFind(arguments.locationConfiguration.getSkus(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.locationConfiguration.getSkus(), thatIndex);
		}
	}

	// Physicals (many-to-many - inverse)
	public void function addPhysical(required any physical) {
		arguments.physical.addSku( this );
	}
	public void function removePhysical(required any physical) {
		arguments.physical.removeSku( this );
	}

	// Loyalty Accruements (many-to-many - inverse)
	public void function addLoyaltyAccruement(required any loyaltyAccruement) {
		arguments.loyaltyAccruement.addSku( this );
	}
	public void function removeloyaltyAccruement(required any loyaltyAccruement) {
		arguments.loyaltyAccruement.removeSku( this );
	}

	// Loyalty Accruement Exclusions (many-to-many - inverse)
	public void function addLoyaltyAccruementExclusion(required any loyaltyAccruementExclusion) {
		arguments.loyaltyAccruementExclusion.addSku( this );
	}
	public void function removeloyaltyAccruementExclusion(required any loyaltyAccruementExclusion) {
		arguments.loyaltyAccruementExclusion.removeSku( this );
	}

	// Loyalty Redemptions (many-to-many - inverse)
	public void function addLoyaltyRedemption(required any loyaltyRedemption) {
		arguments.loyaltyRedemption.addSku( this );
	}
	public void function removeLoyaltyRedemption(required any loyaltyRedemption) {
		arguments.loyaltyRedemption.removeSku( this );
	}

	// Loyalty Redemption Exclusions (many-to-many - inverse)
	public void function addLoyaltyRedemptionExclusion(required any loyaltyRedemptionExclusion) {
		arguments.loyaltyRedemptionExclusion.addSku( this );
	}
	public void function removeLoyaltyRedemptionExclusion(required any loyaltyRedemptionExclusion) {
		arguments.loyaltyRedemptionExclusion.removeSku( this );
	}

	// Promotion Rewards (many-to-many - inverse)
	public void function addPromotionReward(required any promotionReward) {
		arguments.promotionReward.addSku( this );
	}
	public void function removePromotionReward(required any promotionReward) {
		arguments.promotionReward.removeSku( this );
	}

	// Promotion Reward Exclusions (many-to-many - inverse)
	public void function addPromotionRewardExclusion(required any promotionReward) {
		arguments.promotionReward.addExcludedSku( this );
	}
	public void function removePromotionRewardExclusion(required any promotionReward) {
		arguments.promotionReward.removeExcludedSku( this );
	}

	// Promotion Qualifiers (many-to-many - inverse)
	public void function addPromotionQualifier(required any promotionQualifier) {
		arguments.promotionQualifier.addSku( this );
	}
	public void function removePromotionQualifier(required any promotionQualifier) {
		arguments.promotionQualifier.removeSku( this );
	}

	// Promotion Qualifier Exclusions (many-to-many - inverse)
	public void function addPromotionQualifierExclusion(required any promotionQualifier) {
		arguments.promotionQualifier.addExcludedSku( this );
	}
	public void function removePromotionQualifierExclusion(required any promotionQualifier) {
		arguments.promotionQualifier.removeExcludedSku( this );
	}

	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================


	// @hint this method validates that this skus has a unique option combination that no other sku has
	public any function hasUniqueOptions() {
		var optionsList = "";

		for(var i=1; i<=arrayLen(getOptions()); i++){
			optionsList = listAppend(optionsList, getOptions()[i].getOptionID());
		}

		if(isNull(getProduct()) || getProduct().getNewFlag()) {
			return true;
		}
		var skus = getProduct().getSkusBySelectedOptions(selectedOptions=optionsList);
		if(!arrayLen(skus) || (arrayLen(skus) == 1 && skus[1].getSkuID() == getSkuID() )) {
			return true;
		}

		return false;
	}

	// @hint this method validates that this skus has a unique option combination that no other sku has
	public any function hasOneOptionPerOptionGroup() {
		var optionGroupList = "";

		for(var i=1; i<=arrayLen(getOptions()); i++){
			if(listFind(optionGroupList, getOptions()[i].getOptionGroup().getOptionGroupID())) {
				return false;
			} else {
				optionGroupList = listAppend(optionGroupList, getOptions()[i].getOptionGroup().getOptionGroupID());
			}
		}

		return true;
	}

	// ===============  END: Custom Validation Methods =====================

	// =============== START: Custom Formatting Methods ====================

	// ===============  END: Custom Formatting Methods =====================

	// ============== START: Overridden Implicit Getters ===================

	public string function getImageName() {
		if(!structKeyExists(variables, "imageName")) {
			variables.imageName = generateImageFileName();
		}
		return variables.imageName;
	}

	// ==============  END: Overridden Implicit Getters ====================

	// ============= START: Overridden Smart List Getters ==================

	// =============  END: Overridden Smart List Getters ===================

	// ================== START: Overridden Methods ========================

	public void function setInventoryTrackBy(required any trackBy){
		variables.inventoryTrackBy = arguments.trackBy;
		if(arguments.trackBy == "Quantity"){
			this.setInventoryMeasurementUnit();
		}
	}

	public void function setInventoryMeasurementUnit(any measurementUnit){
		if(this.getInventoryTrackBy() == "Quantity" || isNull(arguments.measurementUnit) || isSimpleValue(arguments.measurementUnit)){
			structDelete(variables,'inventoryMeasurementUnit');
			return;
		}
		variables.inventoryMeasurementUnit = arguments.measurementUnit;
	}

	public string function getSimpleRepresentationPropertyName() {
    		return "skuCode";
    }

    public any function getAssignedAttributeSetSmartList(){
		if(!structKeyExists(variables, "assignedAttributeSetSmartList")) {

			variables.assignedAttributeSetSmartList = getService("attributeService").getAttributeSetSmartList();
			variables.assignedAttributeSetSmartList.setSelectDistinctFlag(true);
			variables.assignedAttributeSetSmartList.addFilter('activeFlag', 1);
			variables.assignedAttributeSetSmartList.addFilter('attributeSetObject', 'Sku');

			variables.assignedAttributeSetSmartList.joinRelatedProperty("SlatwallAttributeSet", "productTypes", "left");
			variables.assignedAttributeSetSmartList.joinRelatedProperty("SlatwallAttributeSet", "products", "left");
			variables.assignedAttributeSetSmartList.joinRelatedProperty("SlatwallAttributeSet", "brands", "left");
			variables.assignedAttributeSetSmartList.joinRelatedProperty("SlatwallAttributeSet", "skus", "left");

			var wc = "(";
			wc &= " aslatwallattributeset.globalFlag = 1";

			if(!isNull(getProduct())) {
				wc &= " OR aslatwallproduct.productID = '#getProduct().getProductID()#'";

				if(!isNull(getProduct().getProductType())) {
					wc &= " OR aslatwallproducttype.productTypeID IN ('#replace(getProduct().getProductType().getProductTypeIDPath(),",","','","all")#')";
				}
				if(!isNull(getProduct().getBrand())) {
					wc &= " OR aslatwallbrand.brandID = '#getProduct().getBrand().getBrandID()#'";
				}
			}

			wc &= " OR aslatwallsku.skuID = '#getSkuID()#'";
			wc &= ")";

			variables.assignedAttributeSetSmartList.addWhereCondition( wc );
		}

		return variables.assignedAttributeSetSmartList;
	}

	// @help Compile smartlist of conflicting events based on location and event dates
	public any function getEventConflictsSmartList() {
		if(!structKeyExists(variables, "eventConflictsSmartList")) {
			variables.eventConflictsSmartList =getService("skuService").getEventConflictsSmartList(sku=this);
		}

		return variables.eventConflictsSmartList;

	}

	// @help we override this so that the onMM below will work
	public struct function getPropertyMetaData(string propertyName) {

		// if the len is 32 them this propertyName is probably an optionGroupID
		if(len(arguments.propertyName) eq "32") {
			for(var i=1; i<=arrayLen(getOptions()); i++) {
				if(getOptions()[i].getOptionGroup().getOptionGroupID() == arguments.propertyName) {
					return getOptions()[i].getPropertyMetaData('optionName');
				}
			}
		}

		return super.getPropertyMetaData(argumentCollection=arguments);
	}

	 // @hint we override the oMM to look for options by optionGroupID
 	public any function onMissingMethod(required string missingMethodName, required struct missingMethodArguments) {

		// getXXX() 			Where XXX is a optionGroupID
		if (left(arguments.missingMethodName, 3) == "get") {

			var potentialOptionGroupID = right(arguments.missingMethodName, len(arguments.missingMethodName)-3);

			for(var i=1; i<=arrayLen(getOptions()); i++) {
				if(getOptions()[i].getOptionGroup().getOptionGroupID() == potentialOptionGroupID) {
					return getOptions()[i].getOptionName();
				}
			}
		}

		return super.onMissingMethod(argumentCollection=arguments);
	}

	public void function updateCalculatedProperties(boolean runAgain=false) {
		if(!structKeyExists(variables, "calculatedUpdateRunFlag") || runAgain) {
			super.updateCalculatedProperties(argumentCollection=arguments);
			getHibachiScope().flushORMSession();
			getService("skuService").processSku(this, "updateInventoryCalculationsForLocations");
		}
	}

	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	// ===================  END:  ORM Event Hooks  =========================

	// ================== START: Deprecated Methods ========================

	// @hint: USE skuDefinition()
	public string function displayOptions(delimiter=" ") {
    	var dspOptions = "";
    	var optionsCount = arrayLen(getOptions());
    	for(var i=1;i<=optionsCount;i++) {
    		dspOptions = listAppend(dspOptions, getOptions()[i].getOptionName(), arguments.delimiter);
    	}
		return dspOptions;
    }

    // @hint: USE getOptionsByOptionGroupIDStruct()
    public any function getOptionsByGroupIDStruct() {
    	return getOptionsByOptionGroupIDStruct();
    }

    // @hint: NEVER USE
    public struct function getOptionsValueStruct() {
    	var options = {};
    	for(var i=1;i<=arrayLen(getOptions());i++) {
    		options[getOptions()[i].getOptionGroup().getOptionGroupName()] = getOptions()[i].getOptionID();
    	}
		return options;
    }

    // @hint: USE getDefaultFlag()
    public boolean function isNotDefaultSku() {
		return !getDefaultFlag();
    }

	// ==================  END:  Deprecated Methods ========================


}
