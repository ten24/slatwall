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
component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiScope" {

	// Slatwall specific request entity properties
	property name="brand" type="any";
	property name="cart" type="any";
	property name="product" type="any";
	property name="productType" type="any";
	property name="address" type="any";
	property name="site" type="any";
	property name="app" type="any";
	property name="category" type="any";
	property name="attribute" type="any";
	property name="attributeOption" type="any";
	
	// Slatwall specific request smartList properties
	property name="productSmartList" type="any";
	// Slatwall specific request collectin properties
	property name="productCollectionList" type="any";
	
	// Slatwall Specific queue properties
	property name="emailQueue" type="array";
	
	// Deprecated Properties
	property name="currentAccount";
	property name="currentBrand";
	property name="currentCart";
	property name="currentContent";
	property name="currentProduct";
	property name="currentProductType";
	property name="currentDomain";
	property name="currentRequestSite";
	property name="currentRequestSitePathType" default="domain"; //enums: domain,sitecode
	property name="currentRequestSiteLocation";
	
	property name="currentProductSmartList";
	
	// ================= Overrides =================================
	
	public any function getCurrentRequestSite() {
		
		if(!structKeyExists(variables,'currentRequestSite')){
			if ( len( getContextRoot() ) ) {
				var cgiScriptName = replace( CGI.SCRIPT_NAME, getContextRoot(), '' );
				var cgiPathInfo = replace( CGI.PATH_INFO, getContextRoot(), '' );
			} else {
				var cgiScriptName = CGI.SCRIPT_NAME;
				var cgiPathInfo = CGI.PATH_INFO;
			}
			var pathInfo = cgiPathInfo;
			 if ( len( pathInfo ) > len( cgiScriptName ) && left( pathInfo, len( cgiScriptName ) ) == cgiScriptName ) {
	            // canonicalize for IIS:
	            pathInfo = right( pathInfo, len( pathInfo ) - len( cgiScriptName ) );
	        } else if ( len( pathInfo ) > 0 && pathInfo == left( cgiScriptName, len( pathInfo ) ) ) {
	            // pathInfo is bogus so ignore it:
	            pathInfo = '';
	        }
	        //take path and  parse it
	        var pathArray = listToArray(pathInfo,'/');
	        var pathArrayLen = arrayLen(pathArray);
    		
    		if(pathArrayLen){
    			
    			variables.currentRequestSite = getService('siteService').getSiteBySiteCode(pathArray[1]);
    		}
        		
			if(isNull(variables.currentRequestSite)){
				var domain = getCurrentDomain();
				variables.currentRequestSite = getDAO('siteDAO').getSiteByDomainName(domain);
				setCurrentRequestSitePathType('domain');	
			}else{
				setCurrentRequestSitePathType('sitecode');
			}
			
			if(isNull(variables.currentRequestSite) && structKeyExists(session,'siteID')){
				variables.currentRequestSite = getService('siteService').getSiteByCMSSiteID(session['siteID']);
				setCurrentRequestSitePathType('cmsSiteID');
			}
			
			if(isNull(variables.currentRequestSite)){
				variables.currentRequestSite = getService('siteService').newSite();
			}
		}
		
		if(variables.currentRequestSite.getNewFlag()){
			return;
		}
		return variables.currentRequestSite;
	}
	
	public string function getCurrentRequestSitePathType(){
		return variables.currentRequestSitePathType;
	}
	
	public any function getCurrentRequestSiteLocation(){
		if(!structKeyExists(variables,'currentRequestSiteLocation')){
			var site = getCurrentRequestSite();
			if ( !isNull(site) ){
				//Though the relationship is a many-to-many we're only dealing with 1 location as of now
				
				if(site.getLocationsCount()){
					var locationsSmartList = site.getLocationsSmartlist();
					variables.currentRequestSiteLocation= locationsSmartList.getFirstRecord();
				}
			}
		}
		
		if(!StructKeyExists(variables, 'currentRequestSiteLocation') || isNull(variables.currentRequestSiteLocation)){
		return;

		}
		return variables.currentRequestSiteLocation;
	}
	
	public void function setCurrentRequestSitePathType(required string currentRequestSitePathType){
		variables.currentRequestSitePathType = arguments.currentRequestSitePathType;
	}

	public any function getCurrentDomain() {
		return listFirst(cgi.HTTP_HOST,':');
	}
	
	public string function renderJSObject() {
		var config = {};
		config[ 'baseURL' ] = getApplicationValue('baseURL');
		config[ 'action' ] = getApplicationValue('action');
		config[ 'dateFormat' ] = setting('globalDateFormat');
		config[ 'timeFormat' ] = setting('globalTimeFormat');
		config[ 'rbLocale' ] = '#getRBLocale()#';
		config[ 'debugFlag' ] = getApplicationValue('debugFlag');
		config[ 'instantiationKey' ] = '#getApplicationValue('instantiationKey')#';
		config[ 'applicationKey' ] = '#getApplicationValue('applicationKey')#';
		config[ 'attributeCacheKey' ] = '#getService('hibachiService').getAttributeCacheKey()#';
		
		var returnHTML = '';
		returnHTML &= '<script type="text/javascript" src="#getApplicationValue('baseURL')#/org/Hibachi/HibachiAssets/js/hibachi-scope.js"></script>';
		returnHTML &= '<script type="text/javascript">(function( $ ){$.#lcase(getApplicationValue('applicationKey'))# = new Hibachi(#serializeJSON(config)#);})( jQuery );</script>';
		
		returnHTML &= getService("integrationService").getJSObjectAdditions();
		
		return returnHTML;
	}
	
	public boolean function getLoggedInFlag() {
		
		if (super.getLoggedInFlag() &&
			!getSession().getAccount().getGuestAccountFlag()){
				return true;
		}
		return false;
	}
	
	// ================= Entity Helper Methods =====================
	//Attribute
	public any function getAttribute() {
		if(!structKeyExists(variables, "attribute")) {
			variables.attribute = getService("AttributeService").newAttribute();
		}
		return variables.attribute;
	}
	//Attribute Option
	public any function getAttributeOption() {
		if(!structKeyExists(variables, "attributeOption")) {
			variables.attributeOption = getService("AttributeService").newAttributeOption();
		}
		return variables.attributeOption;
	}
	// Brand
	public any function getBrand() {
		if(!structKeyExists(variables, "brand")) {
			variables.brand = getService("brandService").newBrand();
		}
		return variables.brand;
	}

	// Cart
	public any function getCart() {
		return getSession().getOrder();
	}

	// Content
	public any function getContent() {
		if(!structKeyExists(variables, "content")) {
			variables.content = getService("contentService").newContent();
		}
		return variables.content;
	}
	
	// Product
	public any function getProduct() {
		if(!structKeyExists(variables, "product")) {
			variables.product = getService("productService").newProduct();
		}
		return variables.product;
	}
	
	// Product Type
	public any function getProductType() {
		if(!structKeyExists(variables, "productType")) {
			variables.productType = getService("productService").newProductType();
		}
		return variables.productType;
	}
	
	// Address
	public any function getAddress() {
		if(!structKeyExists(variables, "address")) {
			variables.address = getService("addressService").newAddress();
		}
		return variables.address;
	}
	
	// Category
	public any function getCategory() {
		if(!structKeyExists(variables, "category")) {
			variables.category = getService("contentService").newCategory();
		}
		return variables.category;
	}
	
	// Display Route Entity
	public any function getRouteEntity(string entityName = ""){
		if (
			len(arguments.entityName)
			&& structKeyExists(variables, "routeEntity") 
			&& structKeyExists(variables.routeEntity,arguments.entityName) 
			&& !isNull(variables.routeEntity[arguments.entityName])
		) {
			arguments.entityName = lcase(arguments.entityName);
			return variables.routeEntity[arguments.entityName];
		}
	}
	
	public any function setRouteEntity(required string entityName, any entity) {
		if (!structKeyExists(variables, "routeEntity")){
			variables.routeEntity = {};
		}
		arguments.entityName = lcase(arguments.entityName);
		if (!structKeyExists(variables.routeEntity, "#arguments.entityName#")) {
			variables.routeEntity[arguments.entityName] = arguments.entity;
			variables[arguments.entityName] = arguments.entity;
		}
	}
	
	// Site
	public any function getSite() {
		if(!structKeyExists(variables, "site")) {
			variables.site = getService("siteService").newSite();
		}
		return variables.site;
	}
	
	// ================= Smart List Helper Methods =====================
	
	// Product Smart List
	public any function getProductSmartList() {
		if(!structKeyExists(variables, "productSmartList")) {
			variables.productSmartList = getService("productService").getProductSmartList(data=url);
			variables.productSmartList.setSelectDistinctFlag( 1 );
			variables.productSmartList.addFilter('activeFlag', 1);
			variables.productSmartList.addFilter('publishedFlag', 1);
			variables.productSmartList.addRange('calculatedQATS', '1^');
			if(isBoolean(getContent().getProductListingPageFlag()) && getContent().getProductListingPageFlag() && isBoolean(getContent().setting('contentIncludeChildContentProductsFlag')) && getContent().setting('contentIncludeChildContentProductsFlag')) {
				variables.productSmartList.addWhereCondition(" EXISTS(SELECT sc.contentID FROM SlatwallContent sc INNER JOIN sc.listingPages slp WHERE sc.contentIDPath LIKE '%#getContent().getContentID()#%' AND slp.product.productID = aslatwallproduct.productID) ");
			} else if(isBoolean(getContent().getProductListingPageFlag()) && getContent().getProductListingPageFlag()) {
				variables.productSmartList.addFilter('listingPages.content.contentID',getContent().getContentID());
			}
		}
		return variables.productSmartList;
	}
	
	// Product Collection List
	public any function getProductCollectionList(boolean isNew=false) {
		if(!structKeyExists(variables,'productCollectionList') || arguments.isNew){
			var productCollectionList = getService("productService").getProductCollectionList(data=url);
			productCollectionList.setDistinct(true);
			productCollectionList.addFilter('activeFlag',1);
			productCollectionList.addFilter('publishedFlag',1);
			if (!isNull(getCurrentRequestSiteLocation())){
				productCollectionList.addFilter("skus.skuLocationQuantities.calculatedQATS","0",">");
				productCollectionList.addFilter("skus.skuLocationQuantities.location.locationID", getCurrentRequestSiteLocation().getLocationID());
			}else{
				productCollectionList.addFilter('calculatedQATS','1','>');
			}
			if(
				isBoolean(getContent().getProductListingPageFlag()) 
				&& getContent().getProductListingPageFlag() 
				&& isBoolean(getContent().setting('contentIncludeChildContentProductsFlag')) 
				&& getContent().setting('contentIncludeChildContentProductsFlag')
			){
				productCollectionList.addFilter('listingPages.content.contentIDPath',getContent().getContentIDPath()&"%",'like');
			}else if(isBoolean(getContent().getProductListingPageFlag()) && getContent().getProductListingPageFlag()){
				productCollectionList.addFilter('listingPages.content.contentID',getContent().getContentID());
			}
			variables.productCollectionList = productCollectionList;
		}
		return variables.productCollectionList;
	}
	
	// ================= Queue Helper Methods =====================
	
	// Email
	public array function getEmailQueue() {
		if(!structKeyExists(variables, "emailQueue")) {
			variables.emailQueue = [];
		}
		return variables.emailQueue;
	}
	
	// Print
	public string function getPrintQueue() {
		if(!structKeyExists(cookie,'printQueue')){
			getService('HibachiTagService').cfCookie('printQueue','');
		}
		return cookie.printQueue;
	}
	
	// Adds a PrintID to the print queue.
	public string function addToPrintQueue(required string printID) {
		var cookieData = getPrintQueue();
		var newPrintQueue = listAppend(cookieData, printID);
		getService('HibachiTagService').cfCookie('printQueue', newPrintQueue);
	}
	
	// Clear Email & Print
	public void function clearPrintQueue() {
		getService('HibachiTagService').cfCookie('printQueue','');
	}
	
	public void function clearEmailAndPrintQueue() {
		variables.emailQueue = [];
		clearPrintQueue();
	}
	
	// =================== JS helper methods  ===========================

	public any function getAvailableAccountPropertyList() {
		return ReReplace("accountID,firstName,lastName,company,remoteID,primaryPhoneNumber.accountPhoneNumberID,primaryPhoneNumber.phoneNumber,primaryEmailAddress.accountEmailAddressID,primaryEmailAddress.emailAddress,
			primaryAddress.accountAddressID,
			accountAddresses.accountAddressName,accountAddresses.accountAddressID,
			accountAddresses.address.addressID,accountAddresses.address.countryCode,accountAddresses.address.firstName,accountAddresses.address.lastName,accountAddresses.address.emailAddress,accountAddresses.accountAddressName,accountAddresses.address.streetAddress,accountAddresses.address.street2Address,accountAddresses.address.city,accountAddresses.address.stateCode,accountAddresses.address.postalCode,accountAddresses.address.countrycode,accountAddresses.address.name,accountAddresses.address.company,accountAddresses.address.phoneNumber,accountPaymentMethods.accountPaymentMethodID,accountPaymentMethods.creditCardLastFour,accountPaymentMethods.creditCardType,accountPaymentMethods.nameOnCreditCard,accountPaymentMethods.expirationMonth,accountPaymentMethods.expirationYear,accountPaymentMethods.accountPaymentMethodName","[[:space:]]","","all");
	}
	
	public any function getAccountData(string propertyList) {
		
		var availablePropertyList = getAvailableAccountPropertyList();

		availablePropertyList = ReReplace(availablePropertyList,"[[:space:]]","","all");

		if(structKeyExists(getService('accountService'), "getCustomAvailableProperties")){
			availablePropertyList = listAppend(availablePropertyList, getService('accountService').getCustomAvailableProperties());
		}

		if(!structKeyExists(arguments,"propertyList") || trim(arguments.propertyList) == "") {
			arguments.propertyList = availablePropertyList;
		}
		
		var data = getService('hibachiUtilityService').buildPropertyIdentifierListDataStruct(getAccount(), arguments.propertyList, availablePropertyList);
		
		// add error messages
		data["hasErrors"] = getAccount().hasErrors();
		data["errors"] = getAccount().getErrors();
		
		// add process object error messages
		data[ 'processObjects' ] = {};
		for(var key in getAccount().getProcessObjects()) {
			data[ 'processObjects' ][ key ] = {};
			data[ 'processObjects' ][ key ][ 'hasErrors' ] = getAccount().getProcessObjects()[ key ].hasErrors();
			data[ 'processObjects' ][ key ][ 'errors' ] = getAccount().getProcessObjects()[ key ].getErrors();
		}
		
		return data;
	}

	public any function getAvailableCartPropertyList() {
		return rereplace("orderID,orderOpenDateTime,calculatedTotal,total,subtotal,taxTotal,fulfillmentTotal,fulfillmentChargeAfterDiscountTotal,promotionCodeList,discountTotal,orderAndItemDiscountAmountTotal, fulfillmentDiscountAmountTotal, orderRequirementsList,orderNotes,
			billingAccountAddress.accountAddressID,
			orderItems.orderItemID,orderItems.price,orderItems.skuPrice,orderItems.currencyCode,orderItems.quantity,orderItems.extendedPrice,orderItems.extendedPriceAfterDiscount,orderItems.extendedUnitPrice,orderItems.extendedUnitPriceAfterDiscount, orderItems.taxAmount,orderItems.taxLiabilityAmount,orderItems.childOrderItems,
			orderItems.orderFulfillment.orderFulfillmentID,
			orderItems.sku.skuID,orderItems.sku.skuCode,orderItems.sku.imagePath,orderItems.sku.imageFile,orderItems.sku.skuDefinition,
			orderItems.sku.product.productID,orderItems.sku.product.productName,orderItems.sku.product.productCode,orderItems.sku.product.urlTitle,orderItems.sku.product.baseProductType,orderItems.sku.listPrice,
			orderItems.sku.product.brand.brandName,
			orderItems.sku.product.productType.productTypeName,
			orderItems.sku.product.productDescription,
			orderFulfillments.accountAddress.accountAddressID,orderFulfillments.orderFulfillmentID,orderFulfillments.fulfillmentCharge,orderFulfillments.currencyCode,
			orderFulfillments.fulfillmentMethod.fulfillmentMethodID,orderFulfillments.fulfillmentMethod.fulfillmentMethodName,orderFulfillments.fulfillmentMethod.fulfillmentMethodType,orderFulfillments.orderFulfillmentItems.sku.skuName,orderFulfillments.orderFulfillmentItems.sku.product.productName,
			orderFulfillments.shippingMethod.shippingMethodID,orderFulfillments.shippingMethod.shippingMethodName,
			orderFulfillments.shippingAddress.addressID,orderFulfillments.shippingAddress.name,orderFulfillments.shippingAddress.streetAddress,orderFulfillments.shippingAddress.street2Address,orderFulfillments.shippingAddress.city,orderFulfillments.shippingAddress.stateCode,orderFulfillments.shippingAddress.postalCode,orderFulfillments.shippingAddress.countrycode,
			orderFulfillments.shippingMethodOptions,orderFulfillments.shippingMethodRate.shippingMethodRateID,
			orderFulfillments.totalShippingWeight,orderFulfillments.taxAmount, orderFulfillments.emailAddress,orderFulfillments.pickupLocation.locationID, orderFulfillments.pickupLocation.locationName, orderFulfillments.pickupLocation.primaryAddress.address.streetAddress, orderFulfillments.pickupLocation.primaryAddress.address.street2Address,
			orderFulfillments.pickupLocation.primaryAddress.address.city, orderFulfillments.pickupLocation.primaryAddress.address.stateCode, orderFulfillments.pickupLocation.primaryAddress.address.postalCode,
			orderPayments.orderPaymentID,orderPayments.amount,orderPayments.currencyCode,orderPayments.creditCardType,orderPayments.expirationMonth,orderPayments.expirationYear,orderPayments.nameOnCreditCard, orderPayments.creditCardLastFour,orderPayments.purchaseOrderNumber,
			orderPayments.billingAccountAddress.accountAddressID,orderPayments.billingAddress.addressID,orderPayments.billingAddress.name,orderPayments.billingAddress.streetAddress,orderPayments.billingAddress.street2Address,orderPayments.billingAddress.city,orderPayments.billingAddress.stateCode,orderPayments.billingAddress.postalCode,orderPayments.billingAddress.countrycode,
			orderPayments.paymentMethod.paymentMethodID,orderPayments.paymentMethod.paymentMethodName, orderPayments.giftCard.balanceAmount, orderPayments.giftCard.giftCardCode, promotionCodes.promotionCode,promotionCodes.promotion.promotionName,eligiblePaymentMethodDetails.paymentMethod.paymentMethodName,eligiblePaymentMethodDetails.paymentMethod.paymentMethodType,eligiblePaymentMethodDetails.paymentMethod.paymentMethodID,eligiblePaymentMethodDetails.maximumAmount,
			orderNotes","[[:space:]]","");
	}
	
	public any function getCartData(string propertyList) {
		
		var availablePropertyList = getAvailableCartPropertyList();
		availablePropertyList = ReReplace(availablePropertyList,"[[:space:]]","","all");
		availablePropertyList = ListAppend(availablePropertyList, getService('OrderService').getOrderAttributePropertyList());

		if(structKeyExists(getService('OrderService'), "getCustomAvailableProperties")){
			availablePropertyList = listAppend(availablePropertyList, getService('OrderService').getCustomAvailableProperties());
		}
		
		if(!structKeyExists(arguments,"propertyList") || trim(arguments.propertyList) == "") {
			arguments.propertyList = availablePropertyList;
		}

		var data = getService('hibachiUtilityService').buildPropertyIdentifierListDataStruct(getCart(), arguments.propertyList, availablePropertyList);

		// add error messages
		data["hasErrors"] = getCart().hasErrors();
		data["errors"] = getCart().getErrors();
		
		// add process object error messages
		data[ 'processObjects' ] = {};
		for(var key in getCart().getProcessObjects()) {
			data[ 'processObjects' ][ key ] = {};
			data[ 'processObjects' ][ key ][ 'hasErrors' ] = getCart().getProcessObjects()[ key ].hasErrors();
			data[ 'processObjects' ][ key ][ 'errors' ] = getCart().getProcessObjects()[ key ].getErrors();
		}
		
		return data;
	}

	public string function getSignedS3URL( required string path, numeric minutesValid = 15) {
 		try{
 			return getService("hibachiUtilityService").getSignedS3ObjectLink(
 				bucketName=setting("globalS3Bucket"),
 				keyName=replace(arguments.path,'s3://',''),
 				awsAccessKeyId=setting("globalS3AccessKey"),
 				awsSecretAccessKey=setting("globalS3SecretAccessKey"),
 				minutesValid=arguments.minutesValid
 			);
 		}catch(any e){
 			return '';
 		}
 	}

	// =================== Image Access ===========================
	
	public string function getBaseImageURL() {
		if(!structKeyExists(variables, 'baseImageURL')){
			var globalAssetsImageFolderPath = setting('globalAssetsImageFolderPath');
			//if is a s3 path, pass it over
			if(left(globalAssetsImageFolderPath, 5) == 's3://'){
				variables.baseImageURL = globalAssetsImageFolderPath;
			}else{
				//otherwise get the url path based on system directory
				variables.baseImageURL = getURLFromPath(globalAssetsImageFolderPath);
			}

		}
		return variables.baseImageURL;

	}
	
	public string function getResizedImage() {
		return getService("imageService").getResizedImage(argumentCollection=arguments);
	}
	
	public string function getResizedImagePath() {
		return getService("imageService").getResizedImagePath(argumentCollection=arguments);
	}
	
	// =================== Setting Access =========================
	
	// @hint helper function to return a Setting
	public any function setting(required string settingName, array filterEntities=[], formatValue=false) {
		//preventing multiple look ups on the external cache look up
		var cacheKey = "#arguments.settingName##arguments.formatValue#";
		for(var filterEntity in arguments.filterEntities){
			cacheKey &= filterEntity.getPrimaryIDValue();
		}
		if(!structKeyExists(variables,cacheKey)){
			variables[cacheKey] = getService("settingService").getSettingValue(settingName=arguments.settingName, object=this, filterEntities=arguments.filterEntities, formatValue=arguments.formatValue);
		}
		
		return variables[cacheKey];
	}

	// @hint helper function to return the details of a setting
	public struct function getSettingDetails(required any settingName, array filterEntities=[]) {
		return getService("settingService").getSettingDetails(settingName=arguments.settingName, object=this, filterEntities=arguments.filterEntities);
	}
	
	// ================== onMissingMethod =========================
	public any function onMissingMethod(required string missingMethodName, required struct missingMethodArguments) {
		
		// xxx() will do getXXX() and then either get a property, set a property, or return the entire object
		if(structKeyExists(variables, "get#arguments.missingMethodName#")) {
			if( structKeyExists(arguments.missingMethodArguments, "1") && structKeyExists(arguments.missingMethodArguments, "2")) {
				return this.invokeMethod("get#arguments.missingMethodName#").invokeMethod("set#arguments.missingMethodArguments.1#", {1=arguments.missingMethodArguments.2});
			} else if ( structKeyExists(arguments.missingMethodArguments, "1") ) {
				return this.invokeMethod("get#arguments.missingMethodName#").invokeMethod("get#arguments.missingMethodArguments.1#");
			} else {
				return this.invokeMethod("get#arguments.missingMethodName#");
			}
		}
		
	}
	
	// ========================== Deprecated ================= * DO NOT UES!!!!!
	
	public any function getCurrentAccount() {
		return getAccount();
	}
	
	public any function getCurrentBrand() {
		return getBrand();
	}
	
	public any function getCurrentContent() {
		return getContent();
	}
	
	public any function getCurrentProduct() {
		return getProduct();
	}
	
	public any function getCurrentProductType() {
		return getProductType();
	}
	
	public any function getCurrentSession() {
		return getSession();
	}
	
	public any function getCurrentCart() {
		return getCart();
	}
	
	public any function getProductList() {
		return getProductSmartList();
	}
	
	public any function getCurrentProductSmartList() {
		return getProductSmartList();
	}
	
	public string function getSlatwallRootDirectory() {
		return expandPath("/Slatwall");
	}
	
	public any function getSlatwallRootURL() {
		return getBaseURL();
	}
	
	public any function getSlatwallRootPath() {
		return getBaseURL();
	}
	
	public any function sessionFacade(string property, string value) {
		if(structKeyExists(arguments, "property") && structKeyExists(arguments, "value")) {
			return setSessionValue(arguments.property, arguments.value);
		} else if (structKeyExists(arguments, "property")) {
			return getSessionValue(arguments.property);
		}
	}
	
	public any function slatProcess(required string slatProcess){
		return getService('sessionService').processSession(getSession(), arguments.slatProcess);
	}
	
	public boolean function onSlatwallCMS(){
		if(!structKeyExists(variables,'isOnSlatwallCMS')){
			variables.isOnSlatwallCMS = !isNull(getHibachiScope().getSite()) && !isNull(getHibachiScope().getSite().getApp());
		}
		return variables.isOnSlatwallCMS;
	}
	
}
