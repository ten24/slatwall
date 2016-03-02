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

globalOrderNumberGeneration
globalEncryptionKeySize


*/
component extends="HibachiService" output="false" accessors="true" {

	property name="settingDAO" type="any";

	property name="contentService" type="any";
	property name="currencyService" type="any";
	property name="emailService" type="any";
	property name="fulfillmentService" type="any";
	property name="integrationService" type="any";
	property name="locationService" type="any";
	property name="measurementService" type="any";
	property name="paymentService" type="any";
	property name="siteService" type="any";
	property name="taskService" type="any";
	property name="taxService" type="any";
	property name="typeService" type="any";
	property name="hibachiUtilityService" type="any";

	// ====================== START: NEW JSON FUNCTION ==========================

	public struct function getAllCoreSettingMetaData(){
		return this.inspectFolderForSettingsFiles(expandPath("/#getApplicationValue('applicationKey')#/config/settings"));
	}

	public struct function getAllCustomSettingMetaData(){
		return this.inspectFolderForSettingsFiles(expandPath("/#getApplicationValue('applicationKey')#/custom/config/settings"));
	}

	public struct function inspectFolderForSettingsFiles(required string folderPath){
		var allSettingMetaData = {};
		var folderPathsList = directoryList(arguments.folderPath);

		for(var i=1; i<= arrayLen(folderPathsList); i++) {
			if(fileExists( folderPathsList[i] )) {
				var rawCoreJSON = fileRead( folderPathsList[i] );
				if(isJSON( rawCoreJSON )) {
					structAppend(allSettingMetaData, getHibachiUtilityService().evaluateColdfusionInStruct(deserializeJSON( rawCoreJSON )), false);
				} else {
					throw("The Setting File: #folderPathsList[i]# is not a valid JSON object");
				}
			}
		}

		return allSettingMetaData;
	}

	public struct function getSettingsConfig(){
		var settingsConfigPath = expandPath("/#getApplicationValue('applicationKey')#/config/settings.config.json");
		var settingsConfigJson = fileRead( settingsConfigPath );
		if(!isJSON( settingsConfigJson )) {
			throw("The Setting File: #folderPathsList[i]# is not a valid JSON object");
		}
		return deserializeJSON( settingsConfigJson );
	}

	// ====================== START: META DATA SETUP ============================

	public array function getSettingPrefixInOrder() {
		return getSettingsConfig()["PrefixOrder"];
	}

	public struct function getSettingLookupOrder() {
		return getSettingsConfig()["LookupOrder"];
	}

	public struct function getAllSettingMetaData() {

		var allSettingMetaData = {};

		structAppend(allSettingMetaData, getAllCoreSettingMetaData(), false);
		structAppend(allSettingMetaData, getAllCustomSettingMetaData(), false);
		structAppend(allSettingMetaData, getIntegrationService().getAllSettingMetaData(), false);

		return allSettingMetaData;
	}

	public array function getSettingOptions(required string settingName, any settingObject) {
		switch(arguments.settingName) {
			case "contentTemplateFile":
				if(structKeyExists(arguments, "settingObject")) {
					return getService('contentService').getCMSTemplateOptions(arguments.settingObject.getContent());
				}
				return [];
			case "accountPaymentTerm" :
				var optionSL = getPaymentService().getPaymentTermSmartList();
				optionSL.addFilter('activeFlag', 1);
				optionSL.addSelect('paymentTermName', 'name');
				optionSL.addSelect('paymentTermID', 'value');
				return optionSL.getRecords();
			case "brandDisplayTemplate":
				if(structKeyExists(arguments, "settingObject")) {
					return getContentService().getDisplayTemplateOptions( "Brand", arguments.settingObject.getSite().getSiteID() );
				}
				return getContentService().getDisplayTemplateOptions( "brand" );
			case "contentFileTemplate":
				return getContentService().getDisplayTemplateOptions( "brand" );
			case "productDisplayTemplate":
				if(structKeyExists(arguments, "settingObject")) {
					return getContentService().getDisplayTemplateOptions( "Product", arguments.settingObject.getSite().getSiteID() );
				}
				return getContentService().getDisplayTemplateOptions( "product" );
			case "productTypeDisplayTemplate":
				if(structKeyExists(arguments, "settingObject")) {
					return getContentService().getDisplayTemplateOptions( "ProductType", arguments.settingObject.getSite().getSiteID() );
				}
				return getContentService().getDisplayTemplateOptions( "productType" );
			case "contentRestrictedContentDisplayTemplate":
				if(structKeyExists(arguments, "settingObject")) {
					return getContentService().getDisplayTemplateOptions( "BarrierPage", arguments.settingObject.getContent().getSite().getSiteID() );
				}
				return getContentService().getDisplayTemplateOptions( "barrierPage" );
			case "fulfillmentMethodAutoLocation" :
				return getLocationService().getLocationOptions();
			case "fulfillmentMethodShippingOptionSortType" :
				return [{name=rbKey('define.sortOrder'), value='sortOrder'},{name=rbKey('define.price'), value='price'}];
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
				return ['AES'];
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
				return getEmailService().getEmailTemplateOptions( "Account" );
			case "siteVerifyAccountEmailAddressEmailTemplate":
				return getEmailService().getEmailTemplateOptions( "AccountEmailAddress" );
			case "siteOrderOrigin":
				var optionSL = getService('HibachiService').getOrderOriginSmartList();
				optionSL.addSelect('orderOriginName', 'name');
				optionSL.addSelect('orderOriginID', 'value');
				return optionSL.getRecords();
			case "shippingMethodQualifiedRateSelection" :
				return [{name='Sort Order', value='sortOrder'}, {name='Lowest Rate', value='lowest'}, {name='Highest Rate', value='highest'}];
			case "shippingMethodRateAdjustmentType" :
				return [{name='Increase Percentage', value='increasePercentage'}, {name='Decrease Percentage', value='decreasePercentage'}, {name='Increase Amount', value='increaseAmount'}, {name='Decrease Amount', value='decreaseAmount'}];
			case "skuCurrency" :
				return getCurrencyService().getCurrencyOptions();
			case "skuEmailFulfillmentTemplate" :
				return getEmailService().getEmailTemplateOptions("sku");
			case "skuGiftCardEmailFulfillmentTemplate":
				return getEmailService().getEmailTemplateOptions("giftCard");
			case "skuTaxCategory":
				var optionSL = getTaxService().getTaxCategorySmartList();
				optionSL.addFilter('activeFlag', 1);
				optionSL.addSelect('taxCategoryName', 'name');
				optionSL.addSelect('taxCategoryID', 'value');
				return optionSL.getRecords();
			case "subscriptionUsageRenewalReminderEmailTemplate":
				return getEmailService().getEmailTemplateOptions( "SubscriptionUsage" );
			case "taskFailureEmailTemplate":
				return getEmailService().getEmailTemplateOptions( "Task" );
			case "taskSuccessEmailTemplate":
				return getEmailService().getEmailTemplateOptions( "Task" );

		}

		if(structKeyExists(getSettingMetaData(arguments.settingName), "valueOptions")) {
			return getSettingMetaData(arguments.settingName).valueOptions;
		}

		throw("The setting '#arguments.settingName#' doesn't have any valueOptions configured.  Either add them in the setting metadata or in the SettingService.cfc")
	}

	public any function getSettingOptionsSmartList(required string settingName) {
		return getServiceByEntityName( getSettingMetaData(arguments.settingName).listingMultiselectEntityName ).invokeMethod("get#getSettingMetaData(arguments.settingName).listingMultiselectEntityName#SmartList");
	}

	public array function getCustomIntegrationOptions() {
		var integrationSmartlist = this.getIntegrationSmartList();
		integrationSmartlist.addFilter('activeFlag', '1');
		integrationSmartlist.addFilter('installedFlag', '1');
		integrationSmartlist.addLikeFilter('integrationTypeList', '%custom%');
		integrationSmartlist.addSelect('integrationName', 'name');
		integrationSmartlist.addSelect('integrationPackage', 'value');
		var options = integrationSmartlist.getRecords();
		return options;
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

	// =====================  END: META DATA SETUP ============================

	// ===================== START: Logical Methods ===========================

	public void function removeAllEntityRelatedSettings(required any entity) {

		var settingsRemoved = 0;

		if( listFindNoCase("brandID,contentID,emailID,emailTemplateID,productTypeID,skuID,shippingMethodRateID,paymentMethodID,siteID", arguments.entity.getPrimaryIDPropertyName()) ){

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
	}

	public query function getSettingRecordBySettingRelationships( required string settingName, struct settingRelationships={}) {
		var rs = getSettingDAO().getSettingRecordBySettingRelationships(argumentCollection=arguments);

		if(rs.recordCount) {
			var metaData = getSettingMetaData( arguments.settingName );
			if(structKeyExists(metaData, "encryptValue") && metaData.encryptValue) {
				rs.settingValue = decryptValue( rs.settingValue, rs.settingValueEncryptGen );
			}
		}

		return rs;
	}

	public void function setupDefaultValues( required struct data ) {

		// Default Values Based on Email Address
		if(structKeyExists(arguments.data, "emailAddress")) {

			// SETUP - emailFromAddress
			var fromEmailSL = this.getSettingSmartList();
			fromEmailSL.addFilter( 'settingName', 'emailFromAddress' );
			if(!fromEmailSL.getRecordsCount()) {
				var setting = this.newSetting();
				setting.setSettingName( 'emailFromAddress' );
				setting.setSettingValue( arguments.data.emailAddress );
				this.saveSetting( setting );
			}

			// SETUP - emailToAddress
			var toEmailSL = this.getSettingSmartList();
			toEmailSL.addFilter( 'settingName', 'emailToAddress' );
			if(!toEmailSL.getRecordsCount()) {
				var setting = this.newSetting();
				setting.setSettingName( 'emailToAddress' );
				setting.setSettingValue( arguments.data.emailAddress );
				this.saveSetting( setting );
			}

		}

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

	public any function getSettingMetaData(required string settingName) {
		var allSettingMetaData = getHibachiCacheService().getOrCacheFunctionValue("settingService_allSettingMetaData", this, "getAllSettingMetaData");

		if(structKeyExists(allSettingMetaData, arguments.settingName)) {
			return allSettingMetaData[ arguments.settingName ];
		}

		throw("You have asked for a setting '#arguments.settingName#' which has no meta information. Make sure that you either add this setting to the settingService or your integration.");
	}

	public any function getSettingValue(required string settingName, any object, array filterEntities=[], formatValue=false) {
		var settingDetails = getSettingDetails( argumentcollection=arguments );

		// If the value is supposed to be formatted we do that here
		if(arguments.formatValue) {
			return settingDetails.settingValueFormatted;
		}

		// Otherwise just return the details
		return settingDetails.settingValue;
	}

	public any function getSettingValueFormatted(required string settingName, any object, array filterEntities=[]) {
		var settingDetails = getSettingDetails( argumentcollection=arguments );

		return settingDetails.settingValueFormatted;
	}

	public any function getSettingDetails(required string settingName, any object, array filterEntities=[], boolean disableFormatting=false) {
		// Build out the cached key
		var cacheKey = "setting_#arguments.settingName#";
		if(structKeyExists(arguments, "object") && arguments.object.isPersistent()) {
			cacheKey &= "_#arguments.object.getPrimaryIDValue()#";
		}
		if(structKeyExists(arguments, "filterEntities")) {
			for(var entity in arguments.filterEntities) {
				cacheKey &= "_#entity.getPrimaryIDValue()#";
			}
		}

		// Get the setting details using the cacheKey to try and get it from cache first
		return getHibachiCacheService().getOrCacheFunctionValue(cacheKey, this, "getSettingDetailsFromDatabase", arguments);
	}

	public string function getSettingPrefix(required string settingName){
		var settingPrefix = "";

		for(var i=1; i<=arrayLen(getSettingPrefixInOrder()); i++) {
			if(left(arguments.settingName, len(getSettingPrefixInOrder()[i])) == getSettingPrefixInOrder()[i]) {
				settingPrefix = getSettingPrefixInOrder()[i];
				break;
			}
		}
		return settingPrefix;
	}

	public boolean function isGlobalSetting(required string settingName){
		return left(arguments.settingName, 6) == "global" || left(arguments.settingName, 11) == "integration";
	}

	public any function getSettingDetailsFromDatabase(required string settingName, any object, array filterEntities=[], boolean disableFormatting=false) {

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
		var settingMetaData = getSettingMetaData(arguments.settingName);

		//if we have a default value initialize it
		if(structKeyExists(settingMetaData, "defaultValue")) {
			settingDetails.settingValue = settingMetaData.defaultValue;

			if(structKeyExists(arguments, "object") && arguments.object.isPersistent()) {
				settingDetails.settingInherited = true;
			}
		}

		// If this is a global setting there isn't much we need to do because we already know there aren't any relationships
		if(isGlobalSetting(arguments.settingName)) {
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
			var settingPrefix = getSettingPrefix(arguments.settingName);

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
			if( structKeyExists(settingMetaData, "formatType") ) {
				settingDetails.settingValueFormatted = getHibachiUtilityService().formatValue(settingDetails.settingValue, settingMetaData.formatType);
			// Now we are looking at different fieldTypes
			} else if( structKeyExists(settingMetaData, "fieldType") ) {
				// Listing Multiselect
				if(settingMetaData.fieldType == "listingMultiselect") {
					settingDetails.settingValueFormatted = "";
					for(var i=1; i<=listLen(settingDetails.settingValue); i++) {
						var thisID = listGetAt(settingDetails.settingValue, i);
						var thisEntity = getServiceByEntityName( settingMetaData.listingMultiselectEntityName ).invokeMethod("get#settingMetaData.listingMultiselectEntityName#", {1=thisID});
						if(!isNull(thisEntity)) {
							settingDetails.settingValueFormatted = listAppend(settingDetails.settingValueFormatted, " " & thisEntity.getSimpleRepresentation());
						}
					}
				// Select
				} else if (settingMetaData.fieldType == "select") {
					var options = getSettingOptions(arguments.settingName);

					if(!arrayLen(options)){
						settingDetails.settingValueFormatted = settingDetails.settingValue;
					}
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
				} else if (settingMetaData.fieldType == "password") {
					if(len(settingDetails.settingValue)) {
						settingDetails.settingValueFormatted = "********";
					} else {
						settingDetails.settingValueFormatted = "";
					}
				} else {
					settingDetails.settingValueFormatted = getHibachiUtilityService().formatValue(settingDetails.settingValue, settingMetaData.fieldType);
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

	// =====================  END: Logical Methods ============================

	// ===================== START: DAO Passthrough ===========================

	public boolean function getSettingRecordExistsFlag(required string settingName, string settingValue) {
		return getSettingDAO().getSettingRecordExistsFlag( argumentcollection=arguments );
	}

	public numeric function updateAllSettingValuesToRemoveSpecificID( required string primaryIDValue ) {
		return getSettingDAO().updateAllSettingValuesToRemoveSpecificID( argumentcollection=arguments );
	}

	// ===================== START: DAO Passthrough ===========================

	// ===================== START: Process Methods ===========================

	// =====================  END: Process Methods ============================

	// ===================== START: Delete Overrides ==========================

	public boolean function deleteSetting(required any entity) {

		// Check to see if we are going to need to update the
		var calculateStockNeeded = false;
		if(listFindNoCase("skuAllowBackorderFlag,skuAllowPreorderFlag,skuQATSIncludesQNROROFlag,skuQATSIncludesQNROVOFlag,skuQATSIncludesQNROSAFlag,skuTrackInventoryFlag", arguments.entity.getSettingName())) {
			calculateStockNeeded = true;
		}
		var settingName = arguments.entity.getSettingName();

		var deleteResult = super.delete(argumentcollection=arguments);

		// If there aren't any errors then flush, and clear cache
		if(deleteResult && !getHibachiScope().getORMHasErrors()) {

			getHibachiDAO().flushORMSession();

			getHibachiCacheService().resetCachedKeyByPrefix('setting_#settingName#');

			// If calculation is needed, then we should do it
			if(calculateStockNeeded) {
				updateStockCalculated();
			}
		}

		return deleteResult;
	}

	// =====================  END: Delete Overrides ===========================

	// ====================== START: Save Overrides ===========================

	public any function saveSetting(required any entity, struct data={}) {
		// Call the default save logic
		arguments.entity = super.save(argumentcollection=arguments);

		// If there aren't any errors then flush, and clear cache
		if(!getHibachiScope().getORMHasErrors()) {

			getHibachiDAO().flushORMSession();

			getHibachiCacheService().resetCachedKeyByPrefix('setting_#arguments.entity.getSettingName()#');

			// If calculation is needed, then we should do it
			if(listFindNoCase("skuAllowBackorderFlag,skuAllowPreorderFlag,skuQATSIncludesQNROROFlag,skuQATSIncludesQNROVOFlag,skuQATSIncludesQNROSAFlag,skuTrackInventoryFlag", arguments.entity.getSettingName())) {
				updateStockCalculated();
			}
		}

		return arguments.entity;
	}

	// ======================  END: Save Overrides ============================

	// ==================== START: Smart List Overrides =======================

	// ====================  END: Smart List Overrides ========================

	// ====================== START: Get Overrides ============================

	// ======================  END: Get Overrides =============================

	// ===================== START: Delete Overrides ==========================

	// =====================  END: Delete Overrides ===========================

	// ================== START: Private Helper Functions =====================

	// ==================  END:  Private Helper Functions =====================

	// =================== START: Deprecated Functions ========================

	public any function getType() {
		return getTypeService().getType(argumentCollection=arguments);
	}

	public any function getTypeBySystemCode() {
		return getTypeService().getTypeBySystemCode(argumentCollection=arguments);
	}

	// ===================  END: Deprecated Functions =========================

}
