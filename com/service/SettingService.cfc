<!---

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

globalOrderNumberGeneration
globalEncryptionKeySize


--->
<cfcomponent extends="BaseService" output="false" accessors="true">

	<!--- Injected from Coldspring --->
	<cfproperty name="contentService" type="any" />
	<cfproperty name="currencyService" type="any" />
	<cfproperty name="integrationService" type="any" />
	<cfproperty name="measurementUnitService" type="any" />
	<cfproperty name="paymentService" type="any" />
	<cfproperty name="taxService" type="any" />
	<cfproperty name="utilityORMService" type="any" />
	<cfproperty name="locationService" type="any" />
	
	<!--- Used For Caching --->
	<cfproperty name="allSettingsQuery" type="query" />
	<cfproperty name="settingDetailsCache" type="struct" />
	
	<!--- Used As Meta information --->
	<cfproperty name="settingMetaData" type="struct" />
	<cfproperty name="settingLookupOrder" type="struct" />
	<cfproperty name="settingPrefixInOrder" type="array" />
	
	<cfscript>
		variables.settingDetailsCache = {};
		
		variables.settingPrefixInOrder = [
			"shippingMethodRate",
			"fulfillmentMethod",
			"shippingMethod",
			"paymentMethod",
			"productType",
			"product",
			"content",
			"account",
			"brand",
			"email",
			"stock",
			"sku"
		];
		
		variables.settingLookupOrder = {
			stock = ["sku.skuID", "sku.product.productID", "sku.product.productType.productTypeIDPath&sku.product.brand.brandID", "sku.product.productType.productTypeIDPath"],
			sku = ["product.productID", "product.productType.productTypeIDPath&product.brand.brandID", "product.productType.productTypeIDPath"],
			product = ["productType.productTypeIDPath&brand.brandID", "productType.productTypeIDPath"],
			productType = ["productTypeIDPath"],
			content = ["cmsContentID", "contentIDPath", "cmsContentIDPath"],
			email = ["emailTemplate.emailTemplateID"],
			shippingMethodRate = ["shippingMethod.shippingMethodID"]
		};
		
		variables.settingMetaData = {
			// Account
			accountEligiblePaymentTerms = {fieldType="listingMultiselect", listingMultiselectEntityName="PaymentTerm"},
			accountPaymentTerm = {fieldType="select"},
			accountTermCreditLimit = {fieldType="text", formatType="currency"},
			
			// Brand
			brandDisplayTemplate = {fieldType="select"},
			brandHTMLTitleString = {fieldType="text"},
			brandMetaDescriptionString = {fieldType="textarea"},
			brandMetaKeywordsString = {fieldType="textarea"},
			
			// Content
			contentRestrictAccessFlag = {fieldType="yesno"},
			contentRequirePurchaseFlag = {fieldType="yesno"},
			contentRequireSubscriptionFlag = {fieldType="yesno"},
			contentProductListingFlag = {fieldType="yesno"},
			contentDefaultProductsPerPage = {fieldType="text"},
			contentIncludeChildContentProductsFlag = {fieldType="yesno"},
			contentRestrictedContentDisplayTemplate = {fieldType="select"},
			contentHTMLTitleString = {fieldType="text"},
			contentMetaDescriptionString = {fieldType="textarea"},
			contentMetaKeywordsString = {fieldType="textarea"},
			
			// Email
			emailFromAddress = {fieldType="text"},
			emailToAddress = {fieldType="text"},
			emailCCAddress = {fieldType="text"},
			emailBCCAddress = {fieldType="text"},
			emailSubject = {fieldType="text"},
			
			// Fulfillment Method
			fulfillmentMethodEmailFrom = {fieldType="text"},
			fulfillmentMethodEmailCC = {fieldType="text"},
			fulfillmentMethodEmailBCC = {fieldType="text"},
			fulfillmentMethodEmailSubjectString = {fieldType="text"},
			fulfillmentMethodAutoLocation = {fieldType="select"},
			fulfillmentMethodAutoMinReceivedPercentage = {fieldType="text", formatType="percentage"},
			
			// Global
			globalCurrencyLocale = {fieldType="select"},
			globalCurrencyType = {fieldType="select"},
			globalDateFormat = {fieldType="text"},
			globalEncryptionAlgorithm = {fieldType="select"},
			globalEncryptionEncoding = {fieldType="select"},
			globalEncryptionKeyLocation = {fieldType="text"},
			globalEncryptionKeySize = {fieldType="select"},
			globalEncryptionService = {fieldType="select"},
			globalImageExtension = {fieldType="text"},
			globalLogMessages = {fieldType="select"},
			globalMissingImagePath = {fieldType="text"},
			globalOrderPlacedEmailFrom = {fieldType="text"},
			globalOrderPlacedEmailCC = {fieldType="text"},
			globalOrderPlacedEmailBCC = {fieldType="text"},
			globalOrderPlacedEmailSubjectString = {fieldType="text"},
			globalOrderNumberGeneration = {fieldType="select"},
			globalRemoteIDShowFlag = {fieldType="yesno"},
			globalRemoteIDEditFlag = {fieldType="yesno"},
			globalTimeFormat = {fieldType="text"},
			globalURLKeyBrand = {fieldType="text"},
			globalURLKeyProduct = {fieldType="text"},
			globalURLKeyProductType = {fieldType="text"},
			globalWeightUnitCode = {fieldType="select"},
			globalPageShoppingCart = {fieldType="text"},
			globalPageOrderStatus = {fieldType="text"},
			globalPageOrderConfirmation = {fieldType="text"},
			globalPageMyAccount = {fieldType="text"},
			globalPageCreateAccount = {fieldType="text"},
			globalPageCheckout = {fieldType="text"},
			
			// Payment Method
			paymentMethodStoreCreditCardNumberWithOrder = {fieldType="yesno"},
			paymentMethodStoreCreditCardNumberWithAccount = {fieldType="yesno"},
			paymentMethodCheckoutTransactionType = {fieldType="select"},
			
			// Product
			productDisplayTemplate = {fieldType="select"},
			productImageSmallWidth = {fieldType="text", formatType="pixels"},
			productImageSmallHeight = {fieldType="text", formatType="pixels"},
			productImageMediumWidth = {fieldType="text", formatType="pixels"},
			productImageMediumHeight = {fieldType="text", formatType="pixels"},
			productImageLargeWidth = {fieldType="text", formatType="pixels"},
			productImageLargeHeight = {fieldType="text", formatType="pixels"},
			productImageOptionCodeDelimiter = {fieldType="select"},
			productMissingImagePath = {fieldType="text"},
			productTitleString = {fieldType="text"},
			productHTMLTitleString = {fieldType="text"},
			productMetaDescriptionString = {fieldType="textarea"},
			productMetaKeywordsString = {fieldType="textarea"},
			productShowDetailWhenNotPublishedFlag = {fieldType="yesno"},
			
			
			// Product Type
			productTypeDisplayTemplate = {fieldType="select"},
			productTypeHTMLTitleString = {fieldType="text"},
			productTypeMetaDescriptionString = {fieldType="textarea"},
			productTypeMetaKeywordsString = {fieldType="textarea"},
			
			// Sku
			skuAllowBackorderFlag = {fieldType="yesno"},
			skuAllowPreorderFlag = {fieldType="yesno"},
			skuCurrency = {fieldType="select"},
			skuEligibleCurrencies = {fieldType="listingMultiselect", listingMultiselectEntityName="Currency"},
			skuEligibleFulfillmentMethods = {fieldType="listingMultiselect", listingMultiselectEntityName="FulfillmentMethod"},
			skuEligibleOrderOrigins = {fieldType="listingMultiselect", listingMultiselectEntityName="OrderOrigin"},
			skuEligiblePaymentMethods = {fieldType="listingMultiselect", listingMultiselectEntityName="PaymentMethod"},
			skuHoldBackQuantity = {fieldType="text"},
			skuOrderMinimumQuantity = {fieldType="text"},
			skuOrderMaximumQuantity = {fieldType="text"},
			skuQATSIncludesQNROROFlag = {fieldType="yesno"},
			skuQATSIncludesQNROVOFlag = {fieldType="yesno"},
			skuQATSIncludesQNROSAFlag = {fieldType="yesno"},
			skuShippingWeight = {fieldType="text"},
			skuShippingWeightUnitCode = {fieldType="select"},
			skuTaxCategory = {fieldType="select"},
			skuTrackInventoryFlag = {fieldType="yesno"},
			
			// Shipping Method
			shippingMethodQualifiedRateSelection = {fieldType="select"},
			
			// Shipping Method Rate
			shippingMethodRateAdjustmentType = {fieldType="select"},
			shippingMethodRateAdjustmentAmount = {fieldType="text"},
			shippingMethodRateMinimumAmount = {fieldType="text"},
			shippingMethodRateMaximumAmount = {fieldType="text"}
			
			
		};
		
		public array function getSettingOptions(required string settingName) {
			switch(arguments.settingName) {
				case "accountPaymentTerm" :
					var optionSL = getPaymentService().getPaymentTermSmartList();
					optionSL.addFilter('activeFlag', 1);
					optionSL.addSelect('paymentTermName', 'name');
					optionSL.addSelect('paymentTermID', 'value');
					return optionSL.getRecords();
				case "brandDisplayTemplate": case "productDisplayTemplate": case "productTypeDisplayTemplate" : case "contentRestrictedContentDisplayTemplate" :
					return getContentService().getDisplayTemplateOptions();
				case "productImageOptionCodeDelimiter":
					return ['-','_'];
				case "globalCurrencyLocale":
					return ['Chinese (China)','Chinese (Hong Kong)','Chinese (Taiwan)','Dutch (Belgian)','Dutch (Standard)','English (Australian)','English (Canadian)','English (New Zealand)','English (UK)','English (US)','French (Belgian)','French (Canadian)','French (Standard)','French (Swiss)','German (Austrian)','German (Standard)','German (Swiss)','Italian (Standard)', 'Italian (Swiss)','Japanese','Korean','Norwegian (Bokmal)','Norwegian (Nynorsk)','Portuguese (Brazilian)','Portuguese (Standard)','Spanish (Mexican)','Spanish (Modern)','Spanish (Standard)','Swedish'];
				case "globalCurrencyType":
					return ['None','Local','International'];
				case "globalLogMessages":
					return ['None','General','Detail'];
				case "globalEncryptionKeySize":
					return ['128','256','512'];
				case "globalEncryptionAlgorithm":
					return ['AES','DES','DES-EDE','DESX','RC2','RC4','RC5','PBE','MD2','MD5','RIPEMD160','SHA-1','SHA-224','SHA-256','SHA-384','SHA-512','HMAC-MD5','HMAC-RIPEMD160','HMAC-SHA1','HMAC-SHA224','HMAC-SHA256','HMAC-SHA384','HMAC-SHA512','RSA','DSA','Diffie-Hellman','CFMX_COMPAT','BLOWFISH'];
				case "globalEncryptionEncoding":
					return ['Base64','Hex','UU'];
				case "globalEncryptionService":
					var options = getCustomIntegrationOptions();
					arrayPrepend(options, {name='Internal', value='internal'});
					return options;
				case "globalOrderNumberGeneration":
					var options = getCustomIntegrationOptions();
					arrayPrepend(options, {name='Internal', value='internal'});
					return options;
				case "globalWeightUnitCode": case "skuShippingWeightUnitCode":
					var optionSL = getMeasurementUnitService().getMeasurementUnitSmartList();
					optionSL.addFilter('measurementType', 'weight');
					optionSL.addSelect('unitName', 'name');
					optionSL.addSelect('unitCode', 'value');
					return optionSL.getRecords();
				case "shippingMethodQualifiedRateSelection" :
					return [{name='Sort Order', value='sortOrder'}, {name='Lowest Rate', value='lowest'}, {name='Highest Rate', value='highest'}];
				case "shippingMethodRateAdjustmentType" :
					return [{name='Increase Percentage', value='increasePercentage'}, {name='Decrease Percentage', value='decreasePercentage'}, {name='Increase Amount', value='increaseAmount'}, {name='Decrease Amount', value='decreaseAmount'}];
				case "skuCurrency" :
					return getCurrencyService().getCurrencyOptions();
				case "skuTaxCategory":
					var optionSL = getTaxService().getTaxCategorySmartList();
					optionSL.addSelect('taxCategoryName', 'name');
					optionSL.addSelect('taxCategoryID', 'value');
					return optionSL.getRecords();
				case "paymentMethodCheckoutTransactionType" :
					return [{name='None', value='none'}, {name='Authorize Only', value='authorize'}, {name='Authorize And Charge', value='authorizeAndCharge'}];
				case "fulfillmentMethodAutoLocation" :
					return getLocationService().getLocationOptions();
			}
			throw("You have asked for a select list of a setting named '#arguments.settingName#' and the options for that setting have not been setup yet.  Open the SettingService, and configure options for this setting.")
		}
		
		public array function getCustomIntegrationOptions() {
			var options = [];
			
			var integrations = getIntegrationService().listIntegration({customReadyFlag=1});
			
			for(var i=1; i<=arrayLen(integrations); i++) {
				arrayAppend(options, {name=integrations[i].getIntegrationName(), value=integrations[i].getIntegrationPackage()});
			}
			
			return options;
		}
		
		public any function getSettingOptionsSmartList(required string settingName) {
			return getUtilityORMService().getServiceByEntityName( getSettingMetaData(arguments.settingName).listingMultiselectEntityName ).invokeMethod("get#getSettingMetaData(arguments.settingName).listingMultiselectEntityName#SmartList");
		}
		
		public any function getSettingMetaData(required string settingName) {
			if(structKeyExists(variables.settingMetaData, arguments.settingName)) {
				return variables.settingMetaData[ arguments.settingName ];	
			} else if (structKeyExists(getIntegrationService().getAllSettings(), arguments.settingName)) {
				return getIntegrationService().getAllSettings()[ arguments.settingName ];
			}
			
			throw("You have asked for a setting '#arguments.settingName#' which has no meta information. Make sure that you either add this setting to the settingService or your integration.");
		}
		
		public any function getAllSettingsQuery() {
			if(!structKeyExists(variables, "allSettingsQuery")) {
				variables.allSettingsQuery = getDAO().getAllSettingsQuery();
			}
			return variables.allSettingsQuery;
		}
		
		public any function clearAllSettingsQuery() {
			if(structKeyExists(variables, "allSettingsQuery")) {
				structDelete(variables, "allSettingsQuery");
			}
			if(structKeyExists(variables, "settingDetailsCache")) {
				variables.settingDetailsCache = {};
			}
		}
		
		public any function saveSetting(required any entity, struct data={}) {
			if(structKeyExists(arguments.data, "settingName") && structKeyExists(arguments.data, "settingValue")) {
				var metaData = getSettingMetaData(arguments.data.settingName);
				if(structKeyExists(metaData, "encryptValue") && metaData.encryptValue == true) {
					arguments.data.settingValue = encryptValue(arguments.data.settingValue);
				}
			}
			return super.save(argumentcollection=arguments);
		}
		
		public any function getSettingValue(required string settingName, any object, array filterEntities, formatValue=false) {
			
			// Attempt to pull out a cached value first if possible
			var cacheKey = "";
			if( left(arguments.settingName, 6) eq "global" || !arguments.object.isPersistent() ) {
				cacheKey = arguments.settingName;
			} else if( ( !structKeyExists(arguments, "filterEntities") || !arrayLen(arguments.filterEntities) ) ) {
				cacheKey = "#arguments.settingName#_#arguments.object.getPrimaryIDValue()#";
			}
			if( len(cacheKey) ) {
				if(!structKeyExists(variables.settingDetailsCache, cacheKey)) {
					variables.settingDetailsCache[ cacheKey ] = getSettingDetails(argumentCollection=arguments);
				}
				if(arguments.formatValue) {
					return variables.settingDetailsCache[ cacheKey ].settingValueFormatted;	
				}
				return variables.settingDetailsCache[ cacheKey ].settingValue;	
			}
			
			if(arguments.formatValue) {
				return getSettingDetails(argumentCollection=arguments).settingValueFormatted;	
			}
			return getSettingDetails(argumentCollection=arguments).settingValue;
		}
		
		public any function getSettingDetails(required string settingName, any object, array filterEntities, boolean disableFormatting=false) {
			
			// Create some placeholder Var's
			var foundValue = false;
			var settingRecord = "";
			var settingDetails = {
				settingValue = "",
				settingValueFormatted = "",
				settingID = "",
				settingRelationships = {},
				settingInherited = false
			};
			
			if(structKeyExists(getSettingMetaData(arguments.settingName), "defaultValue")) {
				settingDetails.settingValue = getSettingMetaData(arguments.settingName).defaultValue;
			}
			
			// If this is a global setting there isn't much we need to do because we already know there aren't any relationships
			if(left(arguments.settingName, 6) == "global" || left(arguments.settingName, 11) == "integration") {
				settingRecord = getSettingRecordBySettingRelationships(settingName=arguments.settingName);
				if(settingRecord.recordCount) {
					foundValue = true;
					settingDetails.settingValue = settingRecord.settingValue;
					settingDetails.settingID = settingRecord.settingID;
				}
				
			// If this is not a global setting, but one with a prefix, then we need to check the relationships
			} else {
				var settingPrefix = "";
				
				for(var i=1; i<=arrayLen(getSettingPrefixInOrder()); i++) {
					if(left(arguments.settingName, len(getSettingPrefixInOrder()[i])) == getSettingPrefixInOrder()[i]) {
						settingPrefix = getSettingPrefixInOrder()[i];
						break;
					}
				}
				
				if(!len(settingPrefix)) {
					throw("You have asked for a setting with an invalid prefix.  The setting that was asked for was #arguments.settingName#");	
				}
				
				// If an object was passed in, then first we can look for relationships based on that persistent object
				if(structKeyExists(arguments, "object") && arguments.object.isPersistent()) {
					// First Check to see if there is a setting the is explicitly defined to this object
					settingDetails.settingRelationships[ arguments.object.getPrimaryIDPropertyName() ] = arguments.object.getPrimaryIDValue();
					settingRecord = getSettingRecordBySettingRelationships(settingName=arguments.settingName, settingRelationships=settingDetails.settingRelationships);
					if(settingRecord.recordCount) {
						foundValue = true;
						settingDetails.settingValue = settingRecord.settingValue;
						settingDetails.settingID = settingRecord.settingID;
					} else {
						structClear(settingDetails.settingRelationships);
					}
					
					// If we haven't found a value yet, check to see if there is a lookup order
					if(!foundValue && structKeyExists(getSettingLookupOrder(), arguments.object.getClassName()) && structKeyExists(getSettingLookupOrder(), settingPrefix)) {
						
						var hasPathRelationship = false;
						var pathList = "";
						var relationshipKey = "";
						var relationshipValue = "";
						var nextLookupOrderIndex = 1;
						var nextPathListIndex = 0;
						var settingLookupArray = getSettingLookupOrder()[ arguments.object.getClassName() ];
						
						do {
							// If there was an & in the lookupKey then we should split into multiple relationships
							var allRelationships = listToArray(settingLookupArray[nextLookupOrderIndex], "&");
							
							for(var r=1; r<=arrayLen(allRelationships); r++) {
								// If this relationship is a path, then we need to attemptThis multiple times
								if(right(listLast(allRelationships[r], "."), 4) == "path") {
									relationshipKey = left(listLast(allRelationships[r], "."), len(listLast(allRelationships[r], "."))-4);
									if(pathList == "") {
										pathList = arguments.object.getValueByPropertyIdentifier(allRelationships[r]);
										nextPathListIndex = listLen(pathList);
									}
									if(nextPathListIndex gt 0) {
										relationshipValue = listGetAt(pathList, nextPathListIndex);
										nextPathListIndex--;
									} else {
										relationshipValue = "";
									}
								} else {
									relationshipKey = listLast(allRelationships[r], ".");
									relationshipValue = arguments.object.getValueByPropertyIdentifier(allRelationships[r]);
								}
								settingDetails.settingRelationships[ relationshipKey ] = relationshipValue;
							}
							
							settingRecord = getSettingRecordBySettingRelationships(settingName=arguments.settingName, settingRelationships=settingDetails.settingRelationships);
							if(settingRecord.recordCount) {
								foundValue = true;
								settingDetails.settingValue = settingRecord.settingValue;
								settingDetails.settingID = settingRecord.settingID;
								
								// Add custom logic for cmsContentID
								if(structKeyExists(settingDetails.settingRelationships, "cmsContentID") && settingDetails.settingRelationships.cmsContentID == arguments.object.getValueByPropertyIdentifier('cmsContentID')) {
									settingDetails.settingInherited = false;	
								} else {
									settingDetails.settingInherited = true;
								}
							} else {
								structClear(settingDetails.settingRelationships);
							}
							
							if(nextPathListIndex==0) {
								nextLookupOrderIndex ++;
								pathList="";
							}
						} while (!foundValue && nextLookupOrderIndex <= arrayLen(settingLookupArray));
					}
				}
				
				// If we still haven't found a value yet, lets look for this with no relationships
				if(!foundValue) {
					settingRecord = getSettingRecordBySettingRelationships(settingName=arguments.settingName);
					if(settingRecord.recordCount) {
						foundValue = true;
						settingDetails.settingValue = settingRecord.settingValue;
						settingDetails.settingID = settingRecord.settingID;
						if(structKeyExists(arguments, "object") && arguments.object.isPersistent()) {
							settingDetails.settingInherited = true;
						}
					}
				}
			}
			
			if(!disableFormatting) {
				// First we look for a formatType in the meta data
				if( structKeyExists(getSettingMetaData(arguments.settingName), "formatType") ) {
					settingDetails.settingValueFormatted = this.formatValue(settingDetails.settingValue, getSettingMetaData(arguments.settingName).formatType);
				// Now we are looking at different fieldTypes
				} else if( structKeyExists(getSettingMetaData(arguments.settingName), "fieldType") ) {
					// Listing Multiselect
					if(getSettingMetaData(arguments.settingName).fieldType == "listingMultiselect") {
						settingDetails.settingValueFormatted = "";
						for(var i=1; i<=listLen(settingDetails.settingValue); i++) {
							var thisID = listGetAt(settingDetails.settingValue, i);
							var thisEntity =  getUtilityORMService().getServiceByEntityName( getSettingMetaData(arguments.settingName).listingMultiselectEntityName ).invokeMethod("get#getSettingMetaData(arguments.settingName).listingMultiselectEntityName#", {1=thisID});
							if(!isNull(thisEntity)) {
								settingDetails.settingValueFormatted = listAppend(settingDetails.settingValueFormatted, " " & thisEntity.getSimpleRepresentation());	
							}
						}
					// Select
					} else if (getSettingMetaData(arguments.settingName).fieldType == "select") {
						var options = getSettingOptions(arguments.settingName);
						for(var i=1; i<=arrayLen(options); i++) {
							if(isStruct(options[i])) {
								if(options[i]['value'] == settingDetails.settingValue) {
									settingDetails.settingValueFormatted = options[i]['name'];
									break;
								}
							} else {
								settingDetails.settingValueFormatted = settingDetails.settingValue;
								break;
							}
						}
					// Password
					} else if (getSettingMetaData(arguments.settingName).fieldType == "password") {
						if(len(settingDetails.settingValue)) {
							settingDetails.settingValueFormatted = "********";	
						} else {
							settingDetails.settingValueFormatted = "";
						}
					} else {
						settingDetails.settingValueFormatted = this.formatValue(settingDetails.settingValue, getSettingMetaData(arguments.settingName).fieldType);	
					}
				// This is the no deffinition case
				} else {
					settingDetails.settingValueFormatted = settingDetails.settingValue;
				}
			} else {
				settingDetails.settingValueFormatted = settingDetails.settingValue;
			}
			
			return settingDetails;
		}
		
		public void function removeAllEntityRelatedSettings(required any entity) {
			
			if( listFindNoCase("brandID,contentID,emailID,emailTemplateID,productTypeID,skuID,shippingMethodRateID,paymentMethodID", arguments.entity.getPrimaryIDPropertyName()) ){
				
				getDAO().removeAllRelatedSettings(columnName=arguments.entity.getPrimaryIDPropertyName(), columnID=arguments.entity.getPrimaryIDValue());
				
			} else if ( arguments.entity.getPrimaryIDPropertyName() == "fulfillmetnMethodID" ) {
				
				getDAO().removeAllRelatedSettings(columnName="fulfillmetnMethodID", columnID=arguments.entity.getFulfillmentMethodID());
				
				for(var a=1; a<=arrayLen(arguments.entity.getShippingMethods()); a++) {
					getDAO().removeAllRelatedSettings(columnName="shippingMethodID", columnID=arguments.entity.getShippingMethods()[a].getShippingMethodID());
					
					for(var b=1; b<=arrayLen(arguments.entity.getShippingMethods()[a].getShippingMethodRates()); b++) {
						getDAO().removeAllRelatedSettings(columnName="shippingMethodRateID", columnID=arguments.entity.getShippingMethods()[a].getShippingMethodRates()[b].getShippingMethodRateID());
					}
				}
				
			} else if ( arguments.entity.getPrimaryIDPropertyName() == "shippingMethodID" ) {
				
				getDAO().removeAllRelatedSettings(columnName="shippingMethodID", columnID=arguments.entity.getShippingMethodID());
				
				for(var a=1; a<=arrayLen(arguments.entity.getShippingMethodRates()); a++) {
					getDAO().removeAllRelatedSettings(columnName="shippingMethodRateID", columnID=arguments.entity.getShippingMethodRates()[a].getShippingMethodRateID());
				}
			
			} else if ( arguments.entity.getPrimaryIDPropertyName() == "productID" ) {
				
				getDAO().removeAllRelatedSettings(columnName="productID", columnID=arguments.entity.getProductID());
				
				for(var a=1; a<=arrayLen(arguments.entity.getSkus()); a++) {
					getDAO().removeAllRelatedSettings(columnName="skuID", columnID=arguments.entity.getSkus()[a].getSkuID());
				}
				
			}
			
			clearAllSettingsQuery();
		}
		
	</cfscript>
	
	<cffunction name="getSettingRecordCount" output="false">
		<cfargument name="settingName" />
		<cfargument name="settingValue" />
		
		<cfset var allSettings = getAllSettingsQuery() />
		<cfset var rs = "" />
		
		<cfquery name="rs" dbType="query">
			SELECT
				count(*) as settingRecordCount
			FROM
				allSettings
			WHERE
				LOWER(allSettings.settingName) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCASE(arguments.settingName)#">
			  <cfif structKeyExists(arguments, "settingValue")>
			  	  AND
			  	LOWER(allSettings.settingValue) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCASE(arguments.settingValue)#">  
			  </cfif>
		</cfquery> 
		
		<cfreturn val(rs.settingRecordCount) />
	</cffunction>
	
	<cffunction name="getSettingRecordBySettingRelationships" output="false">
		<cfargument name="settingName" type="string" required="true" />
		<cfargument name="settingRelationships" type="struct" default="#structNew()#" />
		
		<cfset var allSettings = getAllSettingsQuery() />
		<cfset var relationship = "">
		<cfset var rs = "">
		<cfset var key = "">
		
		<cfquery name="rs" dbType="query" >
			SELECT
				allSettings.settingID,
				allSettings.settingValue
			FROM
				allSettings
				WHERE
					LOWER(allSettings.settingName) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCASE(arguments.settingName)#">
				  AND
				  	<cfif structKeyExists(settingRelationships, "accountID")>
						LOWER(allSettings.accountID) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCASE(arguments.settingRelationships.accountID)#" > 
					<cfelse>
						allSettings.accountID IS NULL
					</cfif>
				  AND
				  	<cfif structKeyExists(settingRelationships, "contentID")>
						LOWER(allSettings.contentID) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCASE(arguments.settingRelationships.contentID)#" > 
					<cfelse>
						allSettings.contentID IS NULL
					</cfif>
				  AND
					<cfif structKeyExists(settingRelationships, "cmsContentID")>
						LOWER(allSettings.cmsContentID) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCASE(arguments.settingRelationships.cmsContentID)#" > 
					<cfelse>
						allSettings.cmsContentID IS NULL
					</cfif>
				  AND
				  	<cfif structKeyExists(settingRelationships, "paymentMethodID")>
						LOWER(allSettings.paymentMethodID) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCASE(arguments.settingRelationships.paymentMethodID)#" > 
					<cfelse>
						allSettings.paymentMethodID IS NULL
					</cfif>
				  AND
				  	<cfif structKeyExists(settingRelationships, "productTypeID")>
						LOWER(allSettings.productTypeID) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCASE(arguments.settingRelationships.productTypeID)#" > 
					<cfelse>
						allSettings.productTypeID IS NULL
					</cfif>
				  AND
					<cfif structKeyExists(settingRelationships, "productID")>
						LOWER(allSettings.productID) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCASE(arguments.settingRelationships.productID)#" > 
					<cfelse>
						allSettings.productID IS NULL
					</cfif>
				  AND
					<cfif structKeyExists(settingRelationships, "skuID")>
						LOWER(allSettings.skuID) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCASE(arguments.settingRelationships.skuID)#" > 
					<cfelse>
						allSettings.skuID IS NULL
					</cfif>
				  AND
					<cfif structKeyExists(settingRelationships, "brandID")>
						LOWER(allSettings.brandID) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCASE(arguments.settingRelationships.brandID)#" > 
					<cfelse>
						allSettings.brandID IS NULL
					</cfif>
				  AND
					<cfif structKeyExists(settingRelationships, "emailID")>
						LOWER(allSettings.emailID) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCASE(arguments.settingRelationships.emailID)#" > 
					<cfelse>
						allSettings.emailID IS NULL
					</cfif>
				  AND
					<cfif structKeyExists(settingRelationships, "emailTemplateID")>
						LOWER(allSettings.emailTemplateID) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCASE(arguments.settingRelationships.emailTemplateID)#" > 
					<cfelse>
						allSettings.emailTemplateID IS NULL
					</cfif>
				  AND
					<cfif structKeyExists(settingRelationships, "shippingMethodID")>
						LOWER(allSettings.shippingMethodID) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCASE(arguments.settingRelationships.shippingMethodID)#" > 
					<cfelse>
						allSettings.shippingMethodID IS NULL
					</cfif>
				  AND
					<cfif structKeyExists(settingRelationships, "shippingMethodRateID")>
						LOWER(allSettings.shippingMethodRateID) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCASE(arguments.settingRelationships.shippingMethodRateID)#" > 
					<cfelse>
						allSettings.shippingMethodRateID IS NULL
					</cfif>
				  AND
					<cfif structKeyExists(settingRelationships, "fulfillmentMethodID")>
						LOWER(allSettings.fulfillmentMethodID) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCASE(arguments.settingRelationships.fulfillmentMethodID)#" > 
					<cfelse>
						allSettings.fulfillmentMethodID IS NULL
					</cfif>
		</cfquery>
		
		<cfif rs.recordCount>
			<cfset var metaData = getSettingMetaData(arguments.settingName) />
			<cfif structKeyExists(metaData, "encryptValue") && metaData.encryptValue>
				<cfset rs.settingValue = decryptValue(rs.settingValue) />
			</cfif>
		</cfif>
				
		<cfreturn rs />		
	</cffunction>
	
	<!--- ===================== START: Logical Methods =========================== --->
	
	<!--- =====================  END: Logical Methods ============================ --->
	
	<!--- ===================== START: DAO Passthrough =========================== --->
	
	<!--- ===================== START: DAO Passthrough =========================== --->
	
	<!--- ===================== START: Process Methods =========================== --->
	
	<!--- =====================  END: Process Methods ============================ --->
	
	<!--- ====================== START: Status Methods =========================== --->
	
	<!--- ======================  END: Status Methods ============================ --->
	
	<!--- ====================== START: Save Overrides =========================== --->
	
	<!--- ======================  END: Save Overrides ============================ --->
	
	<!--- ==================== START: Smart List Overrides ======================= --->
	
	<!--- ====================  END: Smart List Overrides ======================== --->
	
	<!--- ====================== START: Get Overrides ============================ --->
	
	<!--- ======================  END: Get Overrides ============================= --->

</cfcomponent>
