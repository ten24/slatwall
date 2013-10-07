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
component entityname="SlatwallSku" table="SwSku" persistent=true accessors=true output=false extends="HibachiEntity" cacheuse="transactional" hb_serviceName="skuService" hb_permission="this" {
	
	// Persistent Properties
	property name="skuID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="activeFlag" ormtype="boolean" default="1";
	property name="publishedFlag" ormtype="boolean" default="0";
	property name="skuName" ormtype="string";
	property name="skuDescription" ormtype="string" length="4000" hb_formFieldType="wysiwyg";
	property name="skuCode" ormtype="string" unique="true" length="50";
	property name="listPrice" ormtype="big_decimal" hb_formatType="currency" default="0";
	property name="price" ormtype="big_decimal" hb_formatType="currency" default="0";
	property name="renewalPrice" ormtype="big_decimal" hb_formatType="currency" default="0";
	property name="imageFile" ormtype="string" length="50";
	property name="userDefinedPriceFlag" ormtype="boolean" default="0";
	property name="eventStartDateTime" ormtype="timestamp" hb_formatType="dateTime";
	property name="eventEndDateTime" ormtype="timestamp" hb_formatType="dateTime";
	property name="startReservationDateTime" ormtype="timestamp" hb_formatType="dateTime";
	property name="endReservationDateTime" ormtype="timestamp" hb_formatType="dateTime";
	
	// Calculated Properties
	property name="calculatedQATS" ormtype="integer";
	
	// Related Object Properties (many-to-one)
	property name="product" fieldtype="many-to-one" fkcolumn="productID" cfc="Product" hb_cascadeCalculate="true";
	property name="subscriptionTerm" cfc="SubscriptionTerm" fieldtype="many-to-one" fkcolumn="subscriptionTermID";
	
	// Related Object Properties (one-to-many)
	property name="alternateSkuCodes" singularname="alternateSkuCode" fieldtype="one-to-many" fkcolumn="skuID" cfc="AlternateSkuCode" inverse="true" cascade="all-delete-orphan";
	property name="attributeValues" singularname="attributeValue" cfc="AttributeValue" type="array" fieldtype="one-to-many" fkcolumn="skuID" cascade="all-delete-orphan" inverse="true";
	property name="orderItems" singularname="orderItem" fieldtype="one-to-many" fkcolumn="skuID" cfc="OrderItem" inverse="true" lazy="extra";
	property name="skuCurrencies" singularname="skuCurrency" cfc="SkuCurrency" type="array" fieldtype="one-to-many" fkcolumn="skuID" cascade="all-delete-orphan" inverse="true";
	property name="stocks" singularname="stock" fieldtype="one-to-many" fkcolumn="skuID" cfc="Stock" inverse="true" cascade="all-delete-orphan";
	
	// Related Object Properties (many-to-many - owner)
	property name="options" singularname="option" cfc="Option" fieldtype="many-to-many" linktable="SwSkuOption" fkcolumn="skuID" inversejoincolumn="optionID"; 
	property name="accessContents" singularname="accessContent" cfc="Content" type="array" fieldtype="many-to-many" linktable="SwSkuAccessContent" fkcolumn="skuID" inversejoincolumn="contentID"; 
	property name="subscriptionBenefits" singularname="subscriptionBenefit" cfc="SubscriptionBenefit" type="array" fieldtype="many-to-many" linktable="SwSkuSubsBenefit" fkcolumn="skuID" inversejoincolumn="subscriptionBenefitID";
	property name="renewalSubscriptionBenefits" singularname="renewalSubscriptionBenefit" cfc="SubscriptionBenefit" type="array" fieldtype="many-to-many" linktable="SwSkuRenewalSubsBenefit" fkcolumn="skuID" inversejoincolumn="subscriptionBenefitID";
	property name="locationConfigurations" singularname="locationConfiguration" cfc="LocationConfiguration" type="array" fieldtype="many-to-many" linktable="SwSkuLocationConfiguration" fkcolumn="skuID" inversejoincolumn="locationConfigurationID";
	
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
	
	// Audit properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties
	property name="adminIcon" persistent="false";
	property name="assignedOrderItemAttributeSetSmartList" persistent="false";
	property name="baseProductType" persistent="false";
	property name="currentAccountPrice" type="numeric" hb_formatType="currency" persistent="false";
	property name="currencyCode" type="string" persistent="false";
	property name="currencyDetails" type="struct" persistent="false";
	property name="defaultFlag" type="boolean" persistent="false";
	property name="eligibleFulfillmentMethods" type="array" persistent="false";
	property name="eventRegistrations" type="array" persistent="false";
	property name="imageExistsFlag" type="boolean" persistent="false";
	property name="livePrice" type="numeric" hb_formatType="currency" persistent="false";
	property name="nextEstimatedAvailableDate" type="string" persistent="false";
	property name="optionsByOptionGroupCodeStruct" persistent="false";
	property name="optionsByOptionGroupIDStruct" persistent="false";
	property name="optionsIDList" persistent="false";
	property name="placedOrderItemsSmartList" type="any" persistent="false";
	property name="qats" type="numeric" persistent="false";
	property name="salePriceDetails" type="struct" persistent="false";
	property name="salePrice" type="numeric" hb_formatType="currency" persistent="false";
	property name="salePriceDiscountType" type="string" persistent="false";
	property name="salePriceDiscountAmount" type="string" persistent="false";
	property name="salePriceExpirationDateTime" type="date" hb_formatType="datetime" persistent="false";
	property name="skuDefinition" persistent="false";
	property name="stocksDeletableFlag" persistent="false" type="boolean";
	property name="transactionExistsFlag" persistent="false" type="boolean";
	
	// Deprecated Properties
	
	
	// ==================== START: Logical Methods =========================
	
	// START: Image Methods
	
	//@hint Generates the image path based upon product code, and image options for this sku
	public string function generateImageFileName() {
		var optionString = "";
		for(var option in getOptions()){
			if(option.getOptionGroup().getImageGroupFlag()){
				optionString &= getProduct().setting('productImageOptionCodeDelimiter') & reReplaceNoCase(option.getOptionCode(), "[^a-z0-9\-\_]","","all");
			}
		}
		return reReplaceNoCase(getProduct().getProductCode(), "[^a-z0-9\-\_]","","all") & optionString & ".#getProduct().setting('productImageDefaultExtension')#";
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
			return getOptionsByOptionGroupIDStruct()[ arguments.optionGroupCode ];	
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
	
	public any function getAppliedPriceGroupRateByPriceGroup( required any priceGroup) {
		return getService("priceGroupService").getRateForSkuBasedOnPriceGroup(sku=this, priceGroup=arguments.priceGroup);
	}
	
	public any function getPriceByCurrencyCode( required string currencyCode ) {
    	if(structKeyExists(getCurrencyDetails(), arguments.currencyCode)) {
    		return getCurrencyDetails()[ arguments.currencyCode ].price;
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
	
	// START: Quantity Helper Methods
	
	public numeric function getQuantity(required string quantityType, string locationID, string stockID) {
		
		
		// Request for calculated quantity
		if( listFindNoCase("QC,QE,QNC,QATS,QIATS", arguments.quantityType) ) {
			// If this is a calculated quantity and locationID exists, then delegate
			if( structKeyExists(arguments, "locationID") ) {
				//Need to get location and all children of location 
				var locations = getService("locationService").getLocationAndChildren(arguments.locationID);
				var totalQuantity = 0;
				for(var i=1;i<=arraylen(locations);i++) {
					var location = getService("locationService").getLocation(locations[i].value);
					var stock = getService("stockService").getStockBySkuAndLocation(this, location);
					totalQuantity += stock.getQuantity(arguments.quantityType);
				}
				return totalQuantity;
			
			// If this is a calculated quantity and stockID exists, then delegate
			} else if ( structKeyExists(arguments, "stockID") ) {
				var stock = getService("stockService").getStock(arguments.stockID);
				return stock.getQuantity(arguments.quantityType);
			}
		}
		
		// Standard Logic
		if( !structKeyExists(variables, arguments.quantityType) ) {
			if(listFindNoCase("QOH,QOSH,QNDOO,QNDORVO,QNDOSA,QNRORO,QNROVO,QNROSA", arguments.quantityType)) {
				arguments.skuID = this.getSkuID();
				return getProduct().getQuantity(argumentCollection=arguments);
			} else if(listFindNoCase("QC,QE,QNC,QATS,QIATS", arguments.quantityType)) {
				variables[ arguments.quantityType ] = getService("inventoryService").invokeMethod("get#arguments.quantityType#", {entity=this});
			} else {
				throw("The quantity type you passed in '#arguments.quantityType#' is not a valid quantity type.  Valid quantity types are: QOH, QOSH, QNDOO, QNDORVO, QNDOSA, QNRORO, QNROVO, QNROSA, QC, QE, QNC, QATS, QIATS");
			}
		}
		return variables[ arguments.quantityType ];
	}
	
	// END: Quantity Helper Methods
	
	// ====================  END: Logical Methods ==========================
	
	// ============ START: Non-Persistent Property Methods =================

	public string function getAdminIcon() {
		return getImage(width=55, height=55);
	}
	
	public any function getAssignedOrderItemAttributeSetSmartList(){
		if(!structKeyExists(variables, "assignedOrderItemAttributeSetSmartList")) {
			
			variables.assignedOrderItemAttributeSetSmartList = getService("attributeService").getAttributeSetSmartList();
			
			variables.assignedOrderItemAttributeSetSmartList.addFilter('activeFlag', 1);
			variables.assignedOrderItemAttributeSetSmartList.addFilter('attributeSetType.systemCode', 'astOrderItem');
			
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
	
	public any function getBaseProductType() {
		return getProduct().getBaseProductType();
	}
	
	public string function getCurrencyCode() {
		if(!structKeyExists(variables, "currencyCode")) {
			variables.currencyCode = this.setting('skuCurrency');
		}
		return variables.currencyCode;
	}
	
	public struct function getCurrencyDetails() {
		if(!structKeyExists(variables, "currencyDetails")) {
			variables.currencyDetails = {};
			
			var eligibleCurrencySL = getService("currencyService").getCurrencySmartList();
			
			if(len(setting('skuEligibleCurrencies'))) {
				
				eligibleCurrencySL.addInFilter('currencyCode', setting('skuEligibleCurrencies') );
				
				for(var i = 1; i<=arrayLen(eligibleCurrencySL.getRecords()); i++) {
					
					var thisCurrency = eligibleCurrencySL.getRecords()[i];
					
					variables.currencyDetails[ thisCurrency.getCurrencyCode() ] = {};
					variables.currencyDetails[ thisCurrency.getCurrencyCode() ].skuCurrencyID = "";
					
					// Check to see if thisCurrency is the same as the default currency
					if(thisCurrency.getCurrencyCode() eq this.setting('skuCurrency')) {
						if(!isNull(getRenewalPrice())) {
							variables.currencyDetails[ thisCurrency.getCurrencyCode() ].renewalPrice = getRenewalPrice();
							variables.currencyDetails[ thisCurrency.getCurrencyCode() ].renewalPriceFormatted = getFormattedValue("renewalPrice");
						}
						if(!isNull(getListPrice())) {
							variables.currencyDetails[ thisCurrency.getCurrencyCode() ].listPrice = getListPrice();
							variables.currencyDetails[ thisCurrency.getCurrencyCode() ].listPriceFormatted = getFormattedValue("listPrice");
						}
						variables.currencyDetails[ thisCurrency.getCurrencyCode() ].price = getPrice();
						variables.currencyDetails[ thisCurrency.getCurrencyCode() ].priceFormatted = getFormattedValue("price");
						variables.currencyDetails[ thisCurrency.getCurrencyCode() ].converted = false;
					}
					// Look through the definitions to see if this currency is defined for this sku
					for(var c=1; c<=arrayLen(getSkuCurrencies()); c++) {
						if(getSkuCurrencies()[c].getCurrencyCode() eq thisCurrency.getCurrencyCode()) {
							if(!isNull(getSkuCurrencies()[c].getRenewalPrice())) {
								variables.currencyDetails[ thisCurrency.getCurrencyCode() ].renewalPrice = getSkuCurrencies()[c].getRenewalPrice();
								variables.currencyDetails[ thisCurrency.getCurrencyCode() ].renewalPriceFormatted = getSkuCurrencies()[c].getFormattedValue("renewalPrice");
							}
							if(!isNull(getSkuCurrencies()[c].getListPrice())) {
								variables.currencyDetails[ thisCurrency.getCurrencyCode() ].listPrice = getSkuCurrencies()[c].getListPrice();
								variables.currencyDetails[ thisCurrency.getCurrencyCode() ].listPriceFormatted = getSkuCurrencies()[c].getFormattedValue("listPrice");
							}
							variables.currencyDetails[ thisCurrency.getCurrencyCode() ].price = getSkuCurrencies()[c].getPrice();
							variables.currencyDetails[ thisCurrency.getCurrencyCode() ].priceFormatted = getSkuCurrencies()[c].getFormattedValue("price");
							variables.currencyDetails[ thisCurrency.getCurrencyCode() ].converted = false;
							variables.currencyDetails[ thisCurrency.getCurrencyCode() ].skuCurrencyID = getSkuCurrencies()[c].getSkuCurrencyID();
						}
					}
					// Use a conversion mechinism
					if(!structKeyExists(variables.currencyDetails[ thisCurrency.getCurrencyCode() ], "price")) {
						if(!isNull(getRenewalPrice())) {
							variables.currencyDetails[ thisCurrency.getCurrencyCode() ].renewalPrice = getService("currencyService").convertCurrency(getRenewalPrice(), this.setting('skuCurrency'), thisCurrency.getCurrencyCode());
							variables.currencyDetails[ thisCurrency.getCurrencyCode() ].renewalPriceFormatted = formatValue( variables.currencyDetails[ thisCurrency.getCurrencyCode() ].renewalPrice, "currency", {currencyCode=thisCurrency.getCurrencyCode()});
						}
						if(!isNull(getListPrice())) {
							variables.currencyDetails[ thisCurrency.getCurrencyCode() ].listPrice = getService("currencyService").convertCurrency(getListPrice(), this.setting('skuCurrency'), thisCurrency.getCurrencyCode());
							variables.currencyDetails[ thisCurrency.getCurrencyCode() ].listPriceFormatted = formatValue( variables.currencyDetails[ thisCurrency.getCurrencyCode() ].listPrice, "currency", {currencyCode=thisCurrency.getCurrencyCode()});
						}
						variables.currencyDetails[ thisCurrency.getCurrencyCode() ].price = getService("currencyService").convertCurrency(getPrice(), this.setting('skuCurrency'), thisCurrency.getCurrencyCode());
						variables.currencyDetails[ thisCurrency.getCurrencyCode() ].priceFormatted = formatValue( variables.currencyDetails[ thisCurrency.getCurrencyCode() ].price, "currency", {currencyCode=thisCurrency.getCurrencyCode()});
						variables.currencyDetails[ thisCurrency.getCurrencyCode() ].converted = true;
					}
				}
			}
		}
		return variables.currencyDetails;
	}
	
	public any function getCurrentAccountPrice() {
		if(!structKeyExists(variables, "currentAccountPrice")) {
			variables.currentAccountPrice = getService("priceGroupService").calculateSkuPriceBasedOnCurrentAccount(sku=this);
		}
		return variables.currentAccountPrice;
	}
	
	public boolean function getDefaultFlag() {
    	if(getProduct().getDefaultSku().getSkuID() == getSkuID()) {
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
	
	// Retrieve event registrations related to this sku
	public any function getEventRegistrations() {
		if(!structKeyExists(variables, "eventRegistrationsSmartList")) {
			var smartList = getService("eventRegistrationService").getEventRegistrations();
			variables.eventRegistrationsSmartList = smartList;
		}
		var orderItemsArray = [];
		var orderItemIDList = "";
		for( var orderItem in getorderItems() ) {
			arrayAppend(orderItemsArray,orderItem.getorderItemID());
		}	
		if(arraylen(orderItemsArray)) {
			orderItemIDList = arrayToList(orderItemsArray);
			variables.eventRegistrationsSmartList = getService("eventRegistrationService").getEventRegistrations(orderItemIDList);
		} else {
			variables.eventRegistrationsSmartList.addFilter('orderItemID','');
		}
				
		return variables.eventRegistrationsSmartList;
	}
	
	public string function getNextEstimatedAvailableDate() {
		if(!structKeyExists(variables, "nextEstimatedAvailableDate")) {
			if(getQuantity("QIATS")) {
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
	
	public any function getOptionsByOptionGroupCodeStruct() {
		if(!structKeyExists(variables, "optionsByOptionGroupCodeStruct")) {
			variables.optionsByOptionGroupIDStruct = {};
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
    		for(var option in getOptions()) {
	    		variables.optionsIDList = listAppend(variables.optionsIDList, option.getOptionID());
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
	
	
	public any function getQATS() {
		return getQuantity("QATS");
	}
	
	public any function getSalePriceDetails() {
		if(!structKeyExists(variables, "salePriceDetails")) {
			variables.salePriceDetails = getProduct().getSkuSalePriceDetails( getSkuID() );
		}
		return variables.salePriceDetails;
	}
	
	public any function getSalePrice() {
		if(structKeyExists(getSalePriceDetails(), "salePrice")) {
			return getSalePriceDetails()[ "salePrice"];
		}
		return getPrice();
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
	
	public string function getSkuDefinition() {
		if(!structKeyExists(variables, "skuDefinition")) {
			variables.skuDefinition = "";
			var baseProductType = getBaseProductType();
			switch (baseProductType) 
			{
				case "merchandise":
					for(var option in getOptions()) {
			    			variables.skuDefinition = listAppend(variables.skuDefinition, " #option.getOptionGroup().getOptionGroupName()#: #option.getOptionName()#", ",");
			    			}
			    		break;
			    		
			    	case "subscription":
					variables.skuDefinition = "#rbKey('entity.subscriptionTerm')#: #getSubscriptionTerm().getSubscriptionTermName()#";
					break;
					
				case "event":
					var configs = getLocationConfigurations();
					for(config in configs){
			    			variables.skuDefinition = variables.skuDefinition & config.getlocationConfigurationName() & "<br>";
			    			/*variables.skuDefinition = listAppend(variables.skuDefinition, config.getlocation().getlocationName() & ">" & config.getlocationConfigurationName(), ",");*/
					}
					break;
					
				default: 
					variables.skuDefinition = "";
			}
			
		}
		return trim(variables.skuDefinition);
	}
	
	public boolean function getTransactionExistsFlag() {
		if(!structKeyExists(variables, "transactionExistsFlag")) {
			variables.transactionExistsFlag = getService("skuService").getTransactionExistsFlag( skuID=this.getSkuID() );
		}
		return variables.transactionExistsFlag;
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
	
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	
	// @hint this method validates that this skus has a unique option combination that no other sku has
	public any function hasUniqueOptions() {
		var optionsList = "";
		
		for(var i=1; i<=arrayLen(getOptions()); i++){
			optionsList = listAppend(optionsList, getOptions()[i].getOptionID());
		}
		
		if(isNull(getProduct())) {
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
	
	public string function getSimpleRepresentationPropertyName() {
    	return "skuCode";
    }
    
    public any function getAssignedAttributeSetSmartList(){
		if(!structKeyExists(variables, "assignedAttributeSetSmartList")) {
			
			variables.assignedAttributeSetSmartList = getService("attributeService").getAttributeSetSmartList();
			
			variables.assignedAttributeSetSmartList.addFilter('activeFlag', 1);
			variables.assignedAttributeSetSmartList.addFilter('attributeSetType.systemCode', 'astSku');
			
			variables.assignedAttributeSetSmartList.joinRelatedProperty("SlatwallAttributeSet", "productTypes", "left");
			variables.assignedAttributeSetSmartList.joinRelatedProperty("SlatwallAttributeSet", "products", "left");
			variables.assignedAttributeSetSmartList.joinRelatedProperty("SlatwallAttributeSet", "brands", "left");
			variables.assignedAttributeSetSmartList.joinRelatedProperty("SlatwallAttributeSet", "skus", "left");
			
			var wc = "(";
			wc &= " aslatwallattributeset.globalFlag = 1";
			wc &= " OR aslatwallproducttype.productTypeID IN ('#replace(getProduct().getProductType().getProductTypeIDPath(),",","','","all")#')";
			wc &= " OR aslatwallproduct.productID = '#getProduct().getProductID()#'";
			if(!isNull(getProduct().getBrand())) {
				wc &= " OR aslatwallbrand.brandID = '#getProduct().getBrand().getBrandID()#'";	
			}
			wc &= " OR aslatwallsku.skuID = '#getSkuID()#'";
			wc &= ")";
			
			variables.assignedAttributeSetSmartList.addWhereCondition( wc );
		}
		
		return variables.assignedAttributeSetSmartList;
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
	
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// @hint: USE skuDefinition()
	public string function displayOptions(delimiter=" ") {
    	var dspOptions = "";
    	for(var i=1;i<=arrayLen(getOptions());i++) {
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

