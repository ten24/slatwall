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
<cfcomponent extends="HibachiService" output="false" accessors="true">

	<cfproperty name="settingDAO" type="any" />
	
	<cfproperty name="contentService" type="any" />
	<cfproperty name="currencyService" type="any" />
	<cfproperty name="emailService" type="any" />
	<cfproperty name="fulfillmentService" type="any" />
	<cfproperty name="integrationService" type="any" />
	<cfproperty name="locationService" type="any" />
	<cfproperty name="measurementService" type="any" />
	<cfproperty name="paymentService" type="any" />
	<cfproperty name="siteService" type="any" />
	<cfproperty name="taskService" type="any" />
	<cfproperty name="taxService" type="any" />
	
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
			"accountAuthentication",
			"locationConfiguration",
			"shippingMethodRate",
			"fulfillmentMethod",
			"subscriptionUsage",
			"subscriptionTerm",
			"shippingMethod",
			"paymentMethod",
			"productType",
			"product",
			"content",
			"account",
			"image",
			"brand",
			"email",
			"stock",
			"site",
			"sku"
		];
		
		variables.settingLookupOrder = {
			stock = ["sku.skuID", "sku.product.productID", "sku.product.productType.productTypeIDPath&sku.product.brand.brandID", "sku.product.productType.productTypeIDPath"],
			sku = ["product.productID", "product.productType.productTypeIDPath&product.brand.brandID", "product.productType.productTypeIDPath"],
			product = ["productType.productTypeIDPath&brand.brandID", "productType.productTypeIDPath"],
			productType = ["productTypeIDPath"],
			content = ["cmsContentID", "contentIDPath", "cmsContentIDPath"],
			email = ["emailTemplate.emailTemplateID"],
			shippingMethodRate = ["shippingMethod.shippingMethodID"],
			accountAuthentication = [ "integration.integrationID" ],
			locationConfiguration = ["location.locationID"],
			subscriptionUsage = [ "subscriptionTerm.subscriptionTermID" ]
		};
		
		public any function getSettingMetaData(required string settingName) {
			
			if(!structKeyExists(variables, 'settingMetaData')) {
				var smd = {
					
					// Account
					accountEligiblePaymentMethods = {fieldType="listingMultiselect", listingMultiselectEntityName="PaymentMethod", defaultValue=getPaymentService().getAllActivePaymentMethodIDList()},
					accountEligiblePaymentTerms = {fieldType="listingMultiselect", listingMultiselectEntityName="PaymentTerm", defaultValue=getPaymentService().getAllActivePaymentTermIDList()},
					accountPaymentTerm = {fieldType="select"},
					accountTermCreditLimit = {fieldType="text", formatType="currency",defaultValue=0},
					
					// Account Authentication
					accountAuthenticationAutoLogoutTimespan = {fieldType="text"},
					
					// Brand
					brandDisplayTemplate = {fieldType="select"},
					brandHTMLTitleString = {fieldType="text"},
					brandMetaDescriptionString = {fieldType="textarea"},
					brandMetaKeywordsString = {fieldType="textarea"},
					
					// Content
					contentRestrictAccessFlag = {fieldType="yesno",defaultValue=0},
					contentRequirePurchaseFlag = {fieldType="yesno",defaultValue=0},
					contentRequireSubscriptionFlag = {fieldType="yesno",defaultValue=0},
					contentIncludeChildContentProductsFlag = {fieldType="yesno",defaultValue=1},
					contentRestrictedContentDisplayTemplate = {fieldType="select"},
					contentHTMLTitleString = {fieldType="text"},
					contentMetaDescriptionString = {fieldType="textarea"},
					contentMetaKeywordsString = {fieldType="textarea"},
					
					// Email
					emailFromAddress = {fieldType="text", defaultValue="info@myslatwallStore.com"},
					emailToAddress = {fieldType="text", defaultValue="info@myslatwallStore.com"},
					emailCCAddress = {fieldType="text"},
					emailBCCAddress = {fieldType="text"},
					emailSubject = {fieldType="text", defaultValue="Message From MySlatwallStore"},
					
					// Fulfillment Method
					fulfillmentMethodEmailFrom = {fieldType="text"},
					fulfillmentMethodEmailCC = {fieldType="text"},
					fulfillmentMethodEmailBCC = {fieldType="text"},
					fulfillmentMethodEmailSubjectString = {fieldType="text"},
					fulfillmentMethodAutoLocation = {fieldType="select", defaultValue="88e6d435d3ac2e5947c81ab3da60eba2"},
					fulfillmentMethodAutoMinReceivedPercentage = {fieldType="text", formatType="percentage", defaultValue=100},
					
					// Global
					globalUsageStats = {fieldType="yesno",defaultValue=1},
					globalCurrencyLocale = {fieldType="select",defaultValue="English (US)"},
					globalCurrencyType = {fieldType="select",defaultValue="Local"},
					globalDateFormat = {fieldType="text",defaultValue="mmm dd, yyyy"},
					globalAssetsImageFolderPath = {fieldType="text", defaultValue=getApplicationValue('applicationRootMappingPath') & '/custom/assets/images'},
					globalAssetsFileFolderPath = {fieldType="text", defaultValue=getApplicationValue('applicationRootMappingPath') & '/custom/assets/files'},
					globalEncryptionAlgorithm = {fieldType="select",defaultValue="AES"},
					globalEncryptionEncoding = {fieldType="select",defaultValue="Base64"},
					globalEncryptionKeyLocation = {fieldType="text"},
					globalEncryptionKeySize = {fieldType="select",defaultValue="128"},
					globalEncryptionService = {fieldType="select",defaultValue="internal"},
					globalLogMessages = {fieldType="select",defaultValue="General"},
					globalMissingImagePath = {fieldType="text", defaultValue=getURLFromPath(getApplicationValue('applicationRootMappingPath')) & '/custom/assets/images/missingimage.jpg'},
					globalOrderPlacedEmailFrom = {fieldType="text",defaultValue="info@mySlatwallStore.com"},
					globalOrderPlacedEmailCC = {fieldType="text",defaultValue=""},
					globalOrderPlacedEmailBCC = {fieldType="text",defaultValue=""},
					globalOrderPlacedEmailSubjectString = {fieldType="text",defaultValue="Order Confirmation - Order Number: ${orderNumber}"},
					globalOrderNumberGeneration = {fieldType="select",defaultValue="Internal"},
					globalRemoteIDShowFlag = {fieldType="yesno",defaultValue=0},
					globalRemoteIDEditFlag = {fieldType="yesno",defaultValue=0},
					globalTimeFormat = {fieldType="text",defaultValue="hh:mm tt"},
					globalURLKeyBrand = {fieldType="text",defaultValue="sb"},
					globalURLKeyProduct = {fieldType="text",defaultValue="sp"},
					globalURLKeyProductType = {fieldType="text",defaultValue="spt"},
					globalWeightUnitCode = {fieldType="select",defaultValue="lb"},
					
					// Image
					imageAltString = {fieldType="text",defaultValue=""},
					imageMissingImagePath = {fieldType="text",defaultValue="/assets/images/missingimage.jpg"},
					
					// Location Configuration
					locationConfigurationCapacity = {fieldType="text", defaultValue=0, validate={dataType="numeric"}},
					locationConfigurationAdditionalPreReservationTime = {fieldType="text", defaultValue=0, validate={dataType="numeric"}},
					locationConfigurationAdditionalPostReservationTime = {fieldType="text", defaultValue=0, validate={dataType="numeric"}},
					
					// Payment Method
					paymentMethodMaximumOrderTotalPercentageAmount = {fieldType="text", defaultValue=100, formatType="percentage", validate={dataType="numeric", minValue=0, maxValue=100}},
					
					// Product
					productDisplayTemplate = {fieldType="select"},
					productImageDefaultExtension = {fieldType="text",defaultValue="jpg"},
					productImageOptionCodeDelimiter = {fieldType="select", defaultValue="-"},
					productTitleString = {fieldType="text", defaultValue="${brand.brandName} ${productName}"},
					productHTMLTitleString = {fieldType="text"},
					productMetaDescriptionString = {fieldType="textarea"},
					productMetaKeywordsString = {fieldType="textarea"},
					productShowDetailWhenNotPublishedFlag = {fieldType="yesno", defaultValue=0},
					productAutoApproveReviewsFlag = {fieldType="yesno", defaultValue=0},
					
					// Product Type
					productTypeDisplayTemplate = {fieldType="select"},
					productTypeHTMLTitleString = {fieldType="text"},
					productTypeMetaDescriptionString = {fieldType="textarea"},
					productTypeMetaKeywordsString = {fieldType="textarea"},
					
					// Site
					siteForgotPasswordEmailTemplate = {fieldType="select", defaultValue="dbb327e796334dee73fb9d8fd801df91"},
					
					// Shipping Method
					shippingMethodQualifiedRateSelection = {fieldType="select", defaultValue="lowest"},
					
					// Shipping Method Rate
					shippingMethodRateAdjustmentType = {fieldType="select", defaultValue="increasePercentage"},
					shippingMethodRateAdjustmentAmount = {fieldType="text", defaultValue=0},
					shippingMethodRateMinimumAmount = {fieldType="text", defaultValue=0},
					shippingMethodRateMaximumAmount = {fieldType="text", defaultValue=1000},
					
					// Sku
					skuAllowBackorderFlag = {fieldType="yesno", defaultValue=0},
					skuAllowPreorderFlag = {fieldType="yesno", defaultValue=0},
					skuCurrency = {fieldType="select", defaultValue="USD"},
					skuEligibleCurrencies = {fieldType="listingMultiselect", listingMultiselectEntityName="Currency", defaultValue=getCurrencyService().getAllActiveCurrencyIDList()},
					skuEligibleFulfillmentMethods = {fieldType="listingMultiselect", listingMultiselectEntityName="FulfillmentMethod", defaultValue=getFulfillmentService().getAllActiveFulfillmentMethodIDList()},
					skuEligibleOrderOrigins = {fieldType="listingMultiselect", listingMultiselectEntityName="OrderOrigin", defaultValue=this.getAllActiveOrderOriginIDList()},
					skuEligiblePaymentMethods = {fieldType="listingMultiselect", listingMultiselectEntityName="PaymentMethod", defaultValue=getPaymentService().getAllActivePaymentMethodIDList()},
					skuHoldBackQuantity = {fieldType="text", defaultValue=0},
					skuOrderMinimumQuantity = {fieldType="text", defaultValue=1},
					skuOrderMaximumQuantity = {fieldType="text", defaultValue=1000},
					skuQATSIncludesQNROROFlag = {fieldType="yesno", defaultValue=0},
					skuQATSIncludesQNROVOFlag = {fieldType="yesno", defaultValue=0},
					skuQATSIncludesQNROSAFlag = {fieldType="yesno", defaultValue=0},
					skuShippingWeight = {fieldType="text", defaultValue=1},
					skuShippingWeightUnitCode = {fieldType="select", defaultValue="lb"},
					skuTaxCategory = {fieldType="select", defaultValue="444df2c8cce9f1417627bd164a65f133"},
					skuTrackInventoryFlag = {fieldType="yesno", defaultValue=0},
					
					// Subscription Term
					subscriptionUsageAutoRetryPaymentDays = {fieldType="text", defaultValue=""},
					subscriptionUsageRenewalReminderDays = {fieldType="text", defaultValue=""},
					subscriptionUsageRenewalReminderEmailTemplate = {fieldType="select", defaultValue=""},
					
					// DEPRECATED***
					globalImageExtension = {fieldType="text",defaultValue="jpg"},
					globalPageShoppingCart = {fieldType="text", defaultValue="shopping-cart"},
					globalPageOrderStatus = {fieldType="text", defaultValue="order-status"},
					globalPageOrderConfirmation = {fieldType="text", defaultValue="order-confirmation"},
					globalPageMyAccount = {fieldType="text", defaultValue="my-account"},
					globalPageCreateAccount = {fieldType="text", defaultValue="create-account"},
					globalPageCheckout = {fieldType="text", defaultValue="checkout"},
					paymentMethodStoreCreditCardNumberWithOrder = {fieldType="yesno", defaultValue=0},
					paymentMethodStoreCreditCardNumberWithAccount = {fieldType="yesno", defaultValue=0},
					paymentMethodCheckoutTransactionType = {fieldType="select", defaultValue="none"},
					productImageSmallWidth = {fieldType="text", defaultValue="150", formatType="pixels", validate={dataType="numeric", required=true}},
					productImageSmallHeight = {fieldType="text", defaultValue="150", formatType="pixels", validate={dataType="numeric", required=true}},
					productImageMediumWidth = {fieldType="text", defaultValue="300", formatType="pixels", validate={dataType="numeric", required=true}},
					productImageMediumHeight = {fieldType="text", defaultValue="300", formatType="pixels", validate={dataType="numeric", required=true}},
					productImageLargeWidth = {fieldType="text", defaultValue="600", formatType="pixels", validate={dataType="numeric", required=true}},
					productImageLargeHeight = {fieldType="text", defaultValue="600", formatType="pixels", validate={dataType="numeric", required=true}},
					productMissingImagePath = {fieldType="text", defaultValue="/plugins/Slatwall/assets/images/missingimage.jpg"}
					
				};
				
				variables.settingMetaData = smd;
			}
			
			if(structKeyExists(variables.settingMetaData, arguments.settingName)) {
				return variables.settingMetaData[ arguments.settingName ];	
			} else if (structKeyExists(getIntegrationService().getAllSettings(), arguments.settingName)) {
				return getIntegrationService().getAllSettings()[ arguments.settingName ];
			}
			
			throw("You have asked for a setting '#arguments.settingName#' which has no meta information. Make sure that you either add this setting to the settingService or your integration.");
		}
		
		public array function getSettingOptions(required string settingName, any settingObject) {
			switch(arguments.settingName) {
				case "accountPaymentTerm" :
					var optionSL = getPaymentService().getPaymentTermSmartList();
					optionSL.addFilter('activeFlag', 1);
					optionSL.addSelect('paymentTermName', 'name');
					optionSL.addSelect('paymentTermID', 'value');
					return optionSL.getRecords();
				case "brandDisplayTemplate":
					if(structKeyExists(arguments, "settingObject")) {
						return getContentService().getDisplayTemplateOptions( "brand", arguments.settingObject.getSite().getSiteID() );	
					}
					return getContentService().getDisplayTemplateOptions( "brand" );
				case "productDisplayTemplate":
					if(structKeyExists(arguments, "settingObject")) {
						return getContentService().getDisplayTemplateOptions( "product", arguments.settingObject.getSite().getSiteID() );	
					}
					return getContentService().getDisplayTemplateOptions( "product" );
				case "productTypeDisplayTemplate":
					if(structKeyExists(arguments, "settingObject")) {
						return getContentService().getDisplayTemplateOptions( "productType", arguments.settingObject.getSite().getSiteID() );	
					}
					return getContentService().getDisplayTemplateOptions( "productType" );
				case "contentRestrictedContentDisplayTemplate":
					if(structKeyExists(arguments, "settingObject")) {
						return getContentService().getDisplayTemplateOptions( "barrierPage", arguments.settingObject.getSite().getSiteID() );	
					}
					return getContentService().getDisplayTemplateOptions( "barrierPage" );
				case "fulfillmentMethodAutoLocation" :
					return getLocationService().getLocationOptions();
				case "globalDefaultSite":
					var optionSL = getSiteService().getSiteSmartList();
					optionSL.addSelect('siteName', 'name');
					optionSL.addSelect('siteID', 'value');
					return optionSL.getRecords();
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
					var optionSL = getMeasurementService().getMeasurementUnitSmartList();
					optionSL.addFilter('measurementType', 'weight');
					optionSL.addSelect('unitName', 'name');
					optionSL.addSelect('unitCode', 'value');
					return optionSL.getRecords();
				case "paymentMethodCheckoutTransactionType" :
					return [{name='None', value='none'}, {name='Authorize Only', value='authorize'}, {name='Authorize And Charge', value='authorizeAndCharge'}];
				case "productImageOptionCodeDelimiter":
					return ['-','_'];
				case "siteForgotPasswordEmailTemplate":
					return getEmailService().getEmailTemplateOptions( "account" );
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
				case "subscriptionUsageRenewalReminderEmailTemplate":
					return getEmailService().getEmailTemplateOptions( "subscriptionUsage" );
			}
			
			if(structKeyExists(getSettingMetaData(arguments.settingName), "valueOptions")) {
				return getSettingMetaData(arguments.settingName).valueOptions;
			}
							
			throw("The setting '#arguments.settingName#' doesn't have any valueOptions configured.  Either add them in the setting metadata or in the SettingService.cfc")
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
			return getServiceByEntityName( getSettingMetaData(arguments.settingName).listingMultiselectEntityName ).invokeMethod("get#getSettingMetaData(arguments.settingName).listingMultiselectEntityName#SmartList");
		}
		
		public any function getAllSettingsQuery() {
			if(!structKeyExists(variables, "allSettingsQuery")) {
				variables.allSettingsQuery = getSettingDAO().getAllSettingsQuery();
				logHibachi("The cached value of variables.AllSettingsQuery in SettingService.cfc was set");
			}
			return variables.allSettingsQuery;
		}
		
		public any function clearAllSettingsCache() {
			structDelete(variables, "allSettingsQuery");
			structDelete(variables, "settingMetaData");
			variables.settingDetailsCache = {};
			if(!getHibachiScope().getORMHasErrors()) {
				getHibachiDAO().flushORMSession();
			}
			writeLog(file="Slatwall", text="General Log - All settings cache was cleared");
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
		
		public any function getSettingDetails(required string settingName, any object, array filterEntities=[], boolean disableFormatting=false) {
			
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
				if(structKeyExists(arguments, "object") && arguments.object.isPersistent()) {
					settingDetails.settingInherited = true;
				}
			}
			
			// If this is a global setting there isn't much we need to do because we already know there aren't any relationships
			if(left(arguments.settingName, 6) == "global" || left(arguments.settingName, 11) == "integration") {
				settingRecord = getSettingRecordBySettingRelationships(settingName=arguments.settingName);
				for(var fe=1; fe<=arrayLen(arguments.filterEntities); fe++) {
					settingDetails.settingRelationships[ arguments.filterEntities[fe].getPrimaryIDPropertyName() ] = arguments.filterEntities[fe].getPrimaryIDValue();
				}
				if(settingRecord.recordCount) {
					foundValue = true;
					settingDetails.settingValue = settingRecord.settingValue;
					settingDetails.settingID = settingRecord.settingID;
					settingDetails.settingInherited = false;
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
					for(var fe=1; fe<=arrayLen(arguments.filterEntities); fe++) {
						settingDetails.settingRelationships[ arguments.filterEntities[fe].getPrimaryIDPropertyName() ] = arguments.filterEntities[fe].getPrimaryIDValue();
					}
					settingRecord = getSettingRecordBySettingRelationships(settingName=arguments.settingName, settingRelationships=settingDetails.settingRelationships);
					if(settingRecord.recordCount) {
						foundValue = true;
						settingDetails.settingValue = settingRecord.settingValue;
						settingDetails.settingID = settingRecord.settingID;
						settingDetails.settingInherited = false;
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
							for(var fe=1; fe<=arrayLen(arguments.filterEntities); fe++) {
								settingDetails.settingRelationships[ arguments.filterEntities[fe].getPrimaryIDPropertyName() ] = arguments.filterEntities[fe].getPrimaryIDValue();
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
					settingDetails.settingRelationships = {};
					for(var fe=1; fe<=arrayLen(arguments.filterEntities); fe++) {
						settingDetails.settingRelationships[ arguments.filterEntities[fe].getPrimaryIDPropertyName() ] = arguments.filterEntities[fe].getPrimaryIDValue();
					}
					settingRecord = getSettingRecordBySettingRelationships(settingName=arguments.settingName, settingRelationships=settingDetails.settingRelationships);
					if(settingRecord.recordCount) {
						foundValue = true;
						settingDetails.settingValue = settingRecord.settingValue;
						settingDetails.settingID = settingRecord.settingID;
						if(structKeyExists(arguments, "object") && arguments.object.isPersistent()) {
							settingDetails.settingInherited = true;
						} else {
							settingDetails.settingInherited = false;	
						}
					}
				}
			}
			
			if(!disableFormatting) {
				// First we look for a formatType in the meta data
				if( structKeyExists(getSettingMetaData(arguments.settingName), "formatType") ) {
					settingDetails.settingValueFormatted = getHibachiUtilityService().formatValue(settingDetails.settingValue, getSettingMetaData(arguments.settingName).formatType);
				// Now we are looking at different fieldTypes
				} else if( structKeyExists(getSettingMetaData(arguments.settingName), "fieldType") ) {
					// Listing Multiselect
					if(getSettingMetaData(arguments.settingName).fieldType == "listingMultiselect") {
						settingDetails.settingValueFormatted = "";
						for(var i=1; i<=listLen(settingDetails.settingValue); i++) {
							var thisID = listGetAt(settingDetails.settingValue, i);
							var thisEntity = getServiceByEntityName( getSettingMetaData(arguments.settingName).listingMultiselectEntityName ).invokeMethod("get#getSettingMetaData(arguments.settingName).listingMultiselectEntityName#", {1=thisID});
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
						settingDetails.settingValueFormatted = getHibachiUtilityService().formatValue(settingDetails.settingValue, getSettingMetaData(arguments.settingName).fieldType);	
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
			
			var settingsRemoved = 0;
			
			if( listFindNoCase("brandID,contentID,emailID,emailTemplateID,productTypeID,skuID,shippingMethodRateID,paymentMethodID", arguments.entity.getPrimaryIDPropertyName()) ){
				
				settingsRemoved = getSettingDAO().removeAllRelatedSettings(columnName=arguments.entity.getPrimaryIDPropertyName(), columnID=arguments.entity.getPrimaryIDValue());
				
			} else if ( arguments.entity.getPrimaryIDPropertyName() == "fulfillmetnMethodID" ) {
				
				settingsRemoved = getSettingDAO().removeAllRelatedSettings(columnName="fulfillmetnMethodID", columnID=arguments.entity.getFulfillmentMethodID());
				
				for(var a=1; a<=arrayLen(arguments.entity.getShippingMethods()); a++) {
					settingsRemoved += getSettingDAO().removeAllRelatedSettings(columnName="shippingMethodID", columnID=arguments.entity.getShippingMethods()[a].getShippingMethodID());
					
					for(var b=1; b<=arrayLen(arguments.entity.getShippingMethods()[a].getShippingMethodRates()); b++) {
						settingsRemoved += getSettingDAO().removeAllRelatedSettings(columnName="shippingMethodRateID", columnID=arguments.entity.getShippingMethods()[a].getShippingMethodRates()[b].getShippingMethodRateID());
					}
				}
				
			} else if ( arguments.entity.getPrimaryIDPropertyName() == "shippingMethodID" ) {
				
				settingsRemoved = getSettingDAO().removeAllRelatedSettings(columnName="shippingMethodID", columnID=arguments.entity.getShippingMethodID());
				
				for(var a=1; a<=arrayLen(arguments.entity.getShippingMethodRates()); a++) {
					settingsRemoved &= getSettingDAO().removeAllRelatedSettings(columnName="shippingMethodRateID", columnID=arguments.entity.getShippingMethodRates()[a].getShippingMethodRateID());
				}
			
			} else if ( arguments.entity.getPrimaryIDPropertyName() == "productID" ) {
				
				settingsRemoved = getSettingDAO().removeAllRelatedSettings(columnName="productID", columnID=arguments.entity.getProductID());
				
				for(var a=1; a<=arrayLen(arguments.entity.getSkus()); a++) {
					settingsRemoved += getSettingDAO().removeAllRelatedSettings(columnName="skuID", columnID=arguments.entity.getSkus()[a].getSkuID());
				}
				
			}
			
			settingsRemoved += updateAllSettingValuesToRemoveSpecificID(primaryIDValue=arguments.entity.getPrimaryIDValue());
			
			if(settingsRemoved gt 0) {
				clearAllSettingsCache();
			}
		}
		
		
		public numeric function updateAllSettingValuesToRemoveSpecificID(required string primaryIDValue) {
			return getSettingDAO().updateAllSettingValuesToRemoveSpecificID(primaryIDValue=arguments.primaryIDValue);
		}
		
		public void function updateStockCalculated() {
			
			var updateStockThread = "";
			
			// We do this in a thread so that it doesn't hold anything else up
			thread action="run" name="updateStockThread" {
				setupData = {};
				setupData["p:show"] = 200;
				setupData["f:sku.activeFlag"] = 1;
				setupData["f:sku.product.activeFlag"] = 1;
				getTaskService().updateEntityCalculatedProperties("Stock", setupData);
			} 
		}
		
		public string function getAllActiveOrderOriginIDList() {
			var returnList = "";
			var apmSL = this.getOrderOriginSmartList();
			apmSL.addFilter('activeFlag', 1);
			apmSL.addSelect('orderOriginID', 'orderOriginID');
			var records = apmSL.getRecords();
			for(var i=1; i<=arrayLen(records); i++) {
				returnList = listAppend(returnList, records[i]['orderOriginID']);
			}
			return returnList;
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
				  	<cfif structKeyExists(settingRelationships, "accountID") and structKeyExists(allSettings, "accountID")>
						AND LOWER(allSettings.accountID) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCASE(arguments.settingRelationships.accountID)#" > 
					<cfelseif structKeyExists(allSettings, "accountID")>
						AND allSettings.accountID IS NULL
					</cfif>
					<cfif structKeyExists(settingRelationships, "brandID") and structKeyExists(allSettings, "brandID")>
						AND LOWER(allSettings.brandID) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCASE(arguments.settingRelationships.brandID)#" > 
					<cfelseif structKeyExists(allSettings, "brandID")>
						AND allSettings.brandID IS NULL
					</cfif>
				  	<cfif structKeyExists(settingRelationships, "contentID") and structKeyExists(allSettings, "contentID")>
						AND LOWER(allSettings.contentID) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCASE(arguments.settingRelationships.contentID)#" > 
					<cfelseif structKeyExists(allSettings, "contentID")>
						AND allSettings.contentID IS NULL
					</cfif>
					<cfif structKeyExists(settingRelationships, "cmsContentID") and structKeyExists(allSettings, "cmsContentID")>
						AND LOWER(allSettings.cmsContentID) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCASE(arguments.settingRelationships.cmsContentID)#" > 
					<cfelseif structKeyExists(allSettings, "cmsContentID")>
						AND allSettings.cmsContentID IS NULL
					</cfif>
					<cfif structKeyExists(settingRelationships, "emailID") and structKeyExists(allSettings, "emailID")>
						AND LOWER(allSettings.emailID) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCASE(arguments.settingRelationships.emailID)#" > 
					<cfelseif structKeyExists(allSettings, "emailID")>
						AND allSettings.emailID IS NULL
					</cfif>
					<cfif structKeyExists(settingRelationships, "emailTemplateID") and structKeyExists(allSettings, "emailTemplateID")>
						AND LOWER(allSettings.emailTemplateID) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCASE(arguments.settingRelationships.emailTemplateID)#" > 
					<cfelseif structKeyExists(allSettings, "emailTemplateID")>
						AND allSettings.emailTemplateID IS NULL
					</cfif>
					<cfif structKeyExists(settingRelationships, "fulfillmentMethodID") and structKeyExists(allSettings, "fulfillmentMethodID")>
						AND LOWER(allSettings.fulfillmentMethodID) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCASE(arguments.settingRelationships.fulfillmentMethodID)#" > 
					<cfelseif structKeyExists(allSettings, "fulfillmentMethodID")>
						AND allSettings.fulfillmentMethodID IS NULL
					</cfif>
					<cfif structKeyExists(settingRelationships, "locationID") and structKeyExists(allSettings, "locationID")>
						AND LOWER(allSettings.locationID) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCASE(arguments.settingRelationships.locationID)#" > 
					<cfelseif structKeyExists(allSettings, "locationID")>
						AND allSettings.locationID IS NULL
					</cfif>
					<cfif structKeyExists(settingRelationships, "locationConfigurationID") and structKeyExists(allSettings, "locationConfigurationID")>
						AND LOWER(allSettings.locationConfigurationID) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCASE(arguments.settingRelationships.locationConfigurationID)#" > 
					<cfelseif structKeyExists(allSettings, "locationConfigurationID")>
						AND allSettings.locationConfigurationID IS NULL
					</cfif>
				  	<cfif structKeyExists(settingRelationships, "paymentMethodID") and structKeyExists(allSettings, "paymentMethodID")>
						AND LOWER(allSettings.paymentMethodID) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCASE(arguments.settingRelationships.paymentMethodID)#" > 
					<cfelseif structKeyExists(allSettings, "paymentMethodID")>
						AND allSettings.paymentMethodID IS NULL
					</cfif>
					<cfif structKeyExists(settingRelationships, "productID") and structKeyExists(allSettings, "productID")>
						AND LOWER(allSettings.productID) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCASE(arguments.settingRelationships.productID)#" > 
					<cfelseif structKeyExists(allSettings, "productID")>
						AND allSettings.productID IS NULL
					</cfif>
					<cfif structKeyExists(settingRelationships, "productTypeID") and structKeyExists(allSettings, "productTypeID")>
						AND LOWER(allSettings.productTypeID) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCASE(arguments.settingRelationships.productTypeID)#" > 
					<cfelseif structKeyExists(allSettings, "productTypeID")>
						AND allSettings.productTypeID IS NULL
					</cfif>
					<cfif structKeyExists(settingRelationships, "shippingMethodID") and structKeyExists(allSettings, "shippingMethodID")>
						AND LOWER(allSettings.shippingMethodID) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCASE(arguments.settingRelationships.shippingMethodID)#" > 
					<cfelseif structKeyExists(allSettings, "shippingMethodID")>
						AND allSettings.shippingMethodID IS NULL
					</cfif>
				  	<cfif structKeyExists(settingRelationships, "shippingMethodRateID") and structKeyExists(allSettings, "shippingMethodRateID")>
						AND LOWER(allSettings.shippingMethodRateID) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCASE(arguments.settingRelationships.shippingMethodRateID)#" > 
					<cfelseif structKeyExists(allSettings, "shippingMethodRateID")>
						AND allSettings.shippingMethodRateID IS NULL
					</cfif>
					<cfif structKeyExists(settingRelationships, "siteID") and structKeyExists(allSettings, "siteID")>
						AND LOWER(allSettings.siteID) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCASE(arguments.settingRelationships.siteID)#" > 
					<cfelseif structKeyExists(allSettings, "siteID")>
						AND allSettings.siteID IS NULL
					</cfif>
					<cfif structKeyExists(settingRelationships, "skuID") and structKeyExists(allSettings, "skuID")>
						AND LOWER(allSettings.skuID) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCASE(arguments.settingRelationships.skuID)#" > 
					<cfelseif structKeyExists(allSettings, "skuID")>
						AND allSettings.skuID IS NULL
					</cfif>
					<cfif structKeyExists(settingRelationships, "subscriptionTermID") and structKeyExists(allSettings, "subscriptionTermID")>
						AND LOWER(allSettings.subscriptionTermID) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCASE(arguments.settingRelationships.subscriptionTermID)#" > 
					<cfelseif structKeyExists(allSettings, "subscriptionTermID")>
						AND allSettings.subscriptionTermID IS NULL
					</cfif>
					<cfif structKeyExists(settingRelationships, "subscriptionUsageID") and structKeyExists(allSettings, "subscriptionUsageID")>
						AND LOWER(allSettings.subscriptionUsageID) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCASE(arguments.settingRelationships.subscriptionUsageID)#" > 
					<cfelseif structKeyExists(allSettings, "subscriptionUsageID")>
						AND allSettings.subscriptionUsageID IS NULL
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

	<!--- ===================== START: Delete Overrides ========================== --->
		
	<cfscript>
		public boolean function deleteSetting(required any entity) {
			
			// Check to see if we are going to need to update the 
			var calculateStockNeeded = false;
			if(listFindNoCase("skuAllowBackorderFlag,skuAllowPreorderFlag,skuQATSIncludesQNROROFlag,skuQATSIncludesQNROVOFlag,skuQATSIncludesQNROSAFlag,skuTrackInventoryFlag", arguments.entity.getSettingName())) {
				calculateStockNeeded = true;
			} 
			
			var deleteResult = super.delete(argumentcollection=arguments); 
			
			// If there aren't any errors then flush, and clear cache
			if(deleteResult && !getHibachiScope().getORMHasErrors()) {
				getHibachiDAO().flushORMSession();
				clearAllSettingsCache();
				
				// If calculation is needed, then we should do it
				if(calculateStockNeeded) {
					updateStockCalculated();
				}
			}
			
			
			
			return deleteResult;
		}
	</cfscript>
	
	<!--- =====================  END: Delete Overrides =========================== --->
	
	<!--- ====================== START: Save Overrides =========================== --->
		
	<cfscript>
		public any function saveSetting(required any entity, struct data={}) {
			
			// Check for values that need to be encrypted
			if(structKeyExists(arguments.data, "settingName") && structKeyExists(arguments.data, "settingValue")) {
				var metaData = getSettingMetaData(arguments.data.settingName);
				if(structKeyExists(metaData, "encryptValue") && metaData.encryptValue == true) {
					arguments.data.settingValue = encryptValue(arguments.data.settingValue);
				}
			}
			
			// Call the default save logic
			arguments.entity = super.save(argumentcollection=arguments);
			
			// If there aren't any errors then flush, and clear cache
			if(!getHibachiScope().getORMHasErrors()) {
				
				getHibachiDAO().flushORMSession();
				clearAllSettingsCache();
				
				// If calculation is needed, then we should do it
				if(listFindNoCase("skuAllowBackorderFlag,skuAllowPreorderFlag,skuQATSIncludesQNROROFlag,skuQATSIncludesQNROVOFlag,skuQATSIncludesQNROSAFlag,skuTrackInventoryFlag", arguments.entity.getSettingName())) {
					updateStockCalculated();
				}
			}
			
			return arguments.entity;
		}
	</cfscript>
	
	<!--- ======================  END: Save Overrides ============================ --->
	
	<!--- ==================== START: Smart List Overrides ======================= --->
	
	<!--- ====================  END: Smart List Overrides ======================== --->
	
	<!--- ====================== START: Get Overrides ============================ --->
	
	<!--- ======================  END: Get Overrides ============================= --->

</cfcomponent>
