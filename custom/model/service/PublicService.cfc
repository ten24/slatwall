/**
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
component extends="Slatwall.model.service.PublicService" accessors="true" output="false" {
    
    /**
      * Updates an Account address.
      */
    public void function updateAccountAddress(required data){
     	param name="data.countryCode" default="US";
     	param name="data.accountAddressID" default="";
     	param name="data.phoneNumber" default="";

     	var addressID = "";
     	var accountAddress = getHibachiScope().getService("AccountService").getAccountAddress(data.accountAddressID);
        if (!isNull(accountAddress)){
            addressID = accountAddress.getAddressID();
        }

     	var newAddress = getService("AddressService").getAddress(addressID, true);
     	if (!isNull(newAddress) && !newAddress.hasErrors()){
     	    newAddress = getService("AddressService").saveAddress(newAddress, data, "full");
      		//save the order.
          if(!newAddress.hasErrors()){
  	     	   getService("OrderService").saveOrder(getHibachiScope().getCart());
           }else{
            this.addErrors(data, newAddress.getErrors());
           }
  	     	getHibachiScope().addActionResult( "public:cart.updateAddress", newAddress.hasErrors() ); 
    	}else{
            getHibachiScope().addActionResult( "public:cart.updateAddress", true );
        }
     }
     
    /**
     * Function to delete Account
     * @return none
    */
    public void function deleteJmeterAccount() {
        param name="data.accountID" default="";
        
        var account = getAccountService().getAccount( data.accountID );
        
        if(!isNull(account) && account.getAccountID() == getHibachiScope().getAccount().getAccountID() ) {
            var deleteOk = getAccountService().deleteAccount( account );
            getHibachiScope().addActionResult( "public:account.deleteAccount", !deleteOK );
        } else {
            getHibachiScope().addActionResult( "public:account.deleteAccount", true );   
        }
    }
    
    /**
     * Function to get Types by Type Code
     * It adds typeList as key in ajaxResponse
     * @param typeCode required
     * @return none
    */
    public void function getSystemTypesByTypeCode(required struct data){
        param name="arguments.data.typeCode";
        
        var typeList = getService('TypeService').getTypeByTypeCode(arguments.data.typeCode);
        arguments.data.ajaxResponse['typeList'] = typeList;
    }
    
    /**
     * Function to get Sku Stock
     * It adds stock as key in ajaxResponse
     * @param skuID required
     * @param locationID required
     * @return none
    */
    public void function getSkuStock(required struct data){
        param name="arguments.data.skuID";
        param name="arguments.data.locationID";
        
        var sku = getService('skuService').getSku(arguments.data.skuID);
        var location = getService('locationService').getLocation(arguments.data.locationID);
        if(!isNull(sku) && !isNull(location)) {
            var stock = getService('stockService').getCurrentStockBySkuAndLocation( arguments.data.skuID, arguments.data.locationID );
            arguments.data.ajaxResponse['stock'] = stock;
        }
    }
    
    /**
     * Function to get Product Reviews
     * It adds relatedProducts as key in ajaxResponse
     * @param productID
     * @return none
    */
    public void function getProductReviews(required struct data){
        param name="arguments.data.productID";
        
        var product = getService('productService').getProduct(arguments.data.productID);
        if(!isNull(product)) {
            var productReviews = product.getAllProductReviews();
            arguments.data.ajaxResponse['productReviews'] = productReviews;
        }
    }
    
    /**
     * Function to get Related Products
     * It adds relatedProducts as key in ajaxResponse
     * @param productID
     * @return none
    */
    public void function getRelatedProducts(required struct data){
        param name="arguments.data.productID";
        
        var product = getService('productService').getProduct(arguments.data.productID);
        if(!isNull(product)) {
            var relatedProducts = product.getAllRelatedProducts();
            arguments.data.ajaxResponse['relatedProducts'] = relatedProducts;
        }
    }
    
    /**
     * Function get Images assigned to product
     * It adds Images array as key in ajaxResponse
     * @param productID
     * @param defaultSkuOnlyFlag
     * @param resizeSizes ('s,m,l') optional
     * @return none
    */
    public void function getProductImageGallery(required struct data){
        param name="arguments.data.productID";
        param name="arguments.data.defaultSkuOnlyFlag" default="false";
        
        var product = getService('productService').getProduct(arguments.data.productID);
        if(structKeyExists(arguments.data,'resizeSizes')){
            var sizeArray = [];
            for(var size in arguments.data.resizeSizes){
                arrayAppend(sizeArray,{"size"=size});
            }
            arguments.data.resizeSizes = sizeArray;
        }
        arguments.data.ajaxResponse['images'] = product.getImageGalleryArray(argumentCollection=arguments.data);
    }
    
     /**
     * Function get Product Options By Option Group
     * It adds productOptions as key in ajaxResponse
     * @param productID
     * @param optionGroupID
     * @return none
    */
    public void function getProductOptionsByOptionGroup(required struct data){
        param name="arguments.data.productID";
        param name="arguments.data.optionGroupID";
        
        var product = getService('productService').getProduct(arguments.data.productID);
        if(!isNull(product)) {
            arguments.data.ajaxResponse['productOptions'] = product.getOptionsByOptionGroup(arguments.data.optionGroupID);
        }
    }
    
    /**
     * Function to get applied payments on order
     * adds appliedPayments in ajaxResponse
     * @param request data
     * @return none
     **/
    public void function getAppliedPayments(required any data) {
        var appliedPayments = getHibachiScope().getCart().getOrderPayments();
        if(arrayLen(appliedPayments)) {
            var appliedPaymentMethods = getOrderService().getAppliedOrderPayments();
            arguments.data['ajaxResponse']['appliedPayments'] = appliedPaymentMethods;
        }
    }
    
    /**
     * Function to get applied promotions on order
     * adds appliedPromotionCodes in ajaxResponse
     * @param request data
     * @return none
     **/
    public void function getAppliedPromotionCodes(required any data) {
        var promotionCodes = getHibachiScope().getCart().getAllAppliedPromotions();
        if(arrayLen(promotionCodes)) {
		    arguments.data['ajaxResponse']['appliedPromotionCodes'] = promotionCodes;
        }
    }
    
    /**
     * Function to get all eligible account payment methods 
     * adds availableShippingMethods in ajaxResponse
     * @param request data
     * @return none
     **/
    public void function getAvailablePaymentMethods(required any data) {
        var paymentMethods = getHibachiScope().getCart().getEligiblePaymentMethodDetails();
        if(arrayLen(paymentMethods)) {
            var accountPaymentMethods = [];
            accountPaymentMethods = getService("accountService").getAvailablePaymentMethods();
		    arguments.data['ajaxResponse']['availablePaymentMethods'] = accountPaymentMethods;
        }
    }
    
    /**
     * Function to get all available shipping methods 
     * adds availableShippingMethods in ajaxResponse
     * @param request data
     * @return none
     **/
    public void function getAvailableShippingMethods(required any data) {
        var order = getHibachiScope().getCart().getOrderFulfillments();
        if(arrayLen(order)) {
            var shippingMethods = getOrderService().getShippingMethodOptions(order[1]);
		    arguments.data['ajaxResponse']['availableShippingMethods'] = shippingMethods;
        }
    }
    
    /**
     * Function to get the parent accounts of user account
     **/
    public void function getParentOnAccount(required any data) {
        var account = getHibachiScope().getAccount();
        if(account.hasChildAccountRelationship()) {
            var parentAccounts = getAccountService().getAllParentsOnAccount();
            
            arguments.data['ajaxResponse']['parentAccount'] = parentAccounts;
        }
    }
    
    /**
     * Function to get the child accounts of user account
     **/
    public void function getChildOnAccount(required any data) {
        var account = getHibachiScope().getAccount();
        if(account.hasChildAccountRelationship()) {
            var parentAccounts = getAccountService().getAllChildsOnAccount();
            
            arguments.data['ajaxResponse']['childAccount'] = parentAccounts;
        }
    }
    
    /**
     * Function to get list of subscription usage
     * adds subscriptionUsageOnAccount in ajaxResponse
     * @param accountID required
     * @param pageRecordsShow optional
     * @param currentPage optional
     * @return none
     **/
    public void function getSubscriptionsUsageOnAccount(required any data) {
        var subscriptionUsage = getSubscriptionService().getSubscriptionsUsageOnAccount({accountID: arguments.data.accountID, pageRecordsShow: arguments.data.pageRecordsShow, currentPage: arguments.data.currentPage });
        arguments.data['ajaxResponse']['subscriptionUsageOnAccount'] = subscriptionUsage;
    }
    
    /**
     * Function to get list of gift cards for user
     * adds giftCardsOnAccount in ajaxResponse
     * @param accountID required
     * @param pageRecordsShow optional
     * @param currentPage optional
     * @return none
     **/
    public void function getAllGiftCardsOnAccount(required any data) {
        var giftCards = getGiftCardService().getAllGiftCardsOnAccount({accountID: arguments.data.accountID, pageRecordsShow: arguments.data.pageRecordsShow, currentPage: arguments.data.currentPage });
        arguments.data['ajaxResponse']['giftCardsOnAccount'] = giftCards;
    }
    
    /**
     * Function to get all carts and quotes for user
     * adds cartsAndQuotesOnAccount in ajaxResponse
     * @param accountID required
     * @param pageRecordsShow optional
     * @param currentPage optional
     * @return none
     **/
    public void function getAllCartsAndQuotesOnAccount(required any data) {
        var accountOrders = getOrderService().getAllCartsAndQuotesOnAccount({accountID: arguments.data.accountID, pageRecordsShow: arguments.data.pageRecordsShow, currentPage: arguments.data.currentPage });
        arguments.data['ajaxResponse']['cartsAndQuotesOnAccount'] = accountOrders;
    }
    
    /**
     * Function to get all order fulfilments for user
     * adds cartsAndQuotesOnAccount in ajaxResponse
     * @param accountID required
     * @param pageRecordsShow optional
     * @param currentPage optional
     * @return none
     **/
    public void function getAllOrderFulfillemntsOnAccount(required any data) {
        var accountOrders = getOrderService().getAllOrderFulfillemntsOnAccount({accountID: arguments.data.accountID, pageRecordsShow: arguments.data.pageRecordsShow, currentPage: arguments.data.currentPage });
        arguments.data['ajaxResponse']['orderFulFillemntsOnAccount'] = accountOrders;
    }
    
    /**
     * Function to get all order deliveries for user
     * adds cartsAndQuotesOnAccount in ajaxResponse
     * @param accountID required
     * @param pageRecordsShow optional
     * @param currentPage optional
     * @return none
     **/
    public void function getAllOrderDeliveryOnAccount(required any data) {
        var accountOrders = getOrderService().getAllOrderDeliveryOnAccount({accountID: arguments.data.accountID, pageRecordsShow: arguments.data.pageRecordsShow, currentPage: arguments.data.currentPage });
        arguments.data['ajaxResponse']['orderDeliveryOnAccount'] = accountOrders;
    }
    
    /**
     * Function check and return HyperWallet method
     * adds hyperWalletPaymentMethod in ajaxResponse
     * @param request data
     * @return none
     * */
    public any function configExternalHyperWallet(required struct data) {
        var accountPaymentMethods = getHibachiScope().getAccount().getAccountPaymentMethods();
        
        for(var paymentMethod in accountPaymentMethods) {
            if(paymentMethod.getMoMoneyWallet() === true) {
                if(getHibachiScope().cart().getCalculatedPaymentAmountDue() <= paymentMethod.getMoMoneyBalance()) { //Sufficient Balance
                    arguments.data['ajaxResponse']['hyperWalletPaymentMethod']= paymentMethod.getAccountPaymentMethodID();
                }
                else{
                    this.addErrors(arguments.data, "Insufficient Balance");
                }
            }
        }
        
        if(!structKeyExists(arguments.data['ajaxResponse'],'hyperWalletPaymentMethod')) {
            this.addErrors(arguments.data, "Hyperwallet is not configured for your account.");
        }
        
    }
    
    /**
     * Function to cnfigure client side Paypal method
     * adds paypalClientConfig in ajaxResponse
     * @param request data
     * @return none
     * */
    public any function configExternalPayPal(required struct data) {
        //Configure PayPal
        var requestBean = getHibachiScope().getTransient('externalTransactionRequestBean');
	    requestBean.setTransactionType('authorizeAccount');
	    var account = getHibachiScope().getAccount();
	    requestBean.setAccount(account);
	    
	    var responseBean = getHibachiScope().getService('integrationService').getIntegrationByIntegrationPackage('braintree').getIntegrationCFC("Payment").processExternal(requestBean);
	    
	    //Populate shipping address
	    var orderFulfillment = getHibachiScope().getCart().getOrderFulfillments();
	    var shippingAddress = {};
	    if(arrayLen(orderFulfillment) && !isNull(orderFulfillment[1])) {
	        var cartShippingAddress = orderFulfillment[1].getShippingAddress();
	        if(!isNull(cartShippingAddress)) {
	            shippingAddress = {
    	            "postalCode" : cartShippingAddress.getPostalCode(),
    	            "countryCode" : cartShippingAddress.getCountryCode(),
    	            "line1" : cartShippingAddress.getStreetAddress(),
    	            "recipientName" : cartShippingAddress.getName(),
    	            "city" : cartShippingAddress.getCity(),
    	            "line2" : cartShippingAddress.getStreet2Address(),
    	            "state" : cartShippingAddress.getStateCode(),
    	        };
	        }
	        
	    }
	    
		if(responseBean.hasErrors()) {
		    this.addErrors(data, responseBean.getErrors());
		}
		else {
		    var requestPayload = {
	    	    'currencyCode' : "#getHibachiScope().cart().getCurrencyCode()#",
    			'amount' : getHibachiScope().cart().getCalculatedPaymentAmountDue(),
    			'clientAuthToken' : responseBean.getAuthorizationCode(),
    			'paymentMode' : getService('integrationService').getIntegrationByIntegrationPackage('braintree').setting(settingName='braintreeAccountSandboxFlag') ? 'sandbox' : 'production',
    			'shippingAddress': shippingAddress,
	    	}
	    	
	    	arguments.data['ajaxResponse']['paypalClientConfig'] = requestPayload;
		}
		
    }
    
    /**
     * Function to authorize client account for paypal & Add New Payment Method
     * authorize paypal amd add is as new payment method
     * @param request data
     * @return none
     * */
    public any function authorizePayPal(required struct data) {
        var paymentIntegration = getService('integrationService').getIntegrationByIntegrationPackage('braintree');
		var paymentMethod = getService('paymentService').getPaymentMethodByPaymentIntegration(paymentIntegration);

		var requestBean = getHibachiScope().getTransient('externalTransactionRequestBean');
    	requestBean.setProviderToken(data.paymentToken);
 		requestBean.setTransactionType('authorizePayment');
		var responseBean = paymentIntegration.getIntegrationCFC("Payment").processExternal(requestBean);

		if(responseBean.hasErrors()) {
		    this.addErrors(data, responseBean.getErrors());
		}
		else {
		    //Create a New accountPaymentMethod
            var accountPaymentMethod = getService('accountService').newAccountPaymentMethod();
            accountPaymentMethod.setAccountPaymentMethodName("PayPal - Braintree");
            accountPaymentMethod.setAccount( getHibachiScope().getAccount() );
            accountPaymentMethod.setPaymentMethod( paymentMethod );
            accountPaymentMethod.setProviderToken( responseBean.getProviderToken() );
            accountPaymentMethod.setBillingAccountAddress(getHibachiScope().getCart().getBillingAccountAddress());
            accountPaymentMethod.setBillingAddress(getHibachiScope().getCart().getBillingAddress());
            accountPaymentMethod = getService('AccountService').saveAccountPaymentMethod(accountPaymentMethod);

            arguments.data['ajaxResponse']['newPayPalPaymentMethod'] = accountPaymentMethod.getAccountPaymentMethodID();
            arguments.data['ajaxResponse']['paymentMethodID'] = paymentMethod.getPaymentMethodID();
		}

    }

    /**
     * Function to override addOrderPayment 
     * populate orderPayment paymentMthodID
     * and make orderPayment billingAddress optional
     * */
    public any function addOrderPayment(required any data, boolean giftCard = false) {

        if(StructKeyExists(arguments.data,'accountPaymentMethodID')) {
            var accountPaymentMethod = "";
            accountPaymentMethod = getAccountService().getAccountPaymentMethod( arguments.data.accountPaymentMethodID );
            if(!isNull(accountPaymentMethod))
            {
                arguments.data.newOrderPayment.paymentMethod.paymentMethodID = accountPaymentMethod.getPaymentMethodID();
                arguments.data.newOrderPayment.requireBillingAddress = 0;
            }
        }

        super.addOrderPayment(argumentCollection = arguments);
    }
    
    public any function createWishlist( required struct data ) {
        param name="arguments.data.orderTemplateName";
        param name="arguments.data.siteID" default="#getHibachiScope().getSite().getSiteID()#";
        
        if(getHibachiScope().getAccount().isNew()){
            return;
        }
        
        var orderTemplate = getOrderService().newOrderTemplate();
        var processObject = orderTemplate.getProcessObject("createWishlist");
        var wishlistTypeID = getTypeService().getTypeBySystemCode('ottWishList').getTypeID();
        var currencyCode = getService('SiteService').getSiteByCmsSiteID(arguments.data.cmsSiteID).setting('skuCurrency');

        processObject.setOrderTemplateName(arguments.data.orderTemplateName);
        processObject.setSiteID(arguments.data.siteID);
        processObject.setCurrencyCode(currencyCode);
        processObject.setOrderTemplateTypeID(wishlistTypeID);
        
        orderTemplate = getOrderService().processOrderTemplate(orderTemplate,processObject,"createWishlist");
        
        getHibachiScope().addActionResult( "public:order.createWishlist", orderTemplate.hasErrors() );
        
        return orderTemplate;
    }
    
    public any function createOrderTemplate( required struct data ) {

        param name="arguments.data.orderTemplateSystemCode" default="ottSchedule";
        param name="arguments.data.frequencyTermID" default="23c6a8c4e605d0586869d7f3a8b36ba7";
        param name="arguments.data.scheduleOrderNextPlaceDateTime" default= "#dateAdd('m',1,dateFormat(now()))#";
        param name="arguments.data.siteID" default="#getHibachiScope().getSite().getSiteID()#";
        
        if(getHibachiScope().getAccount().isNew() || isNull(arguments.data.orderTemplateSystemCode)){
            return;
        }
        
        var orderTemplate = getOrderService().newOrderTemplate();
        var processObject = orderTemplate.getProcessObject("create");
        var orderTypeID = getTypeService().getTypeBySystemCode(arguments.data.orderTemplateSystemCode).getTypeID();
        
        processObject.setSiteID(arguments.data.siteID);
        
        if( StructKeyExists(arguments.data, 'cmsSiteID') ){
            processObject.setCmsSiteID(arguments.data.cmsSiteID);
        }
        
        if( StructKeyExists(arguments.data, 'siteCode') ){
            processObject.setSiteCode(arguments.data.siteCode);
        }
        
        processObject.setOrderTemplateTypeID(orderTypeID);
        processObject.setFrequencyTermID(arguments.data.frequencyTermID);
        processObject.setAccountID(getHibachiScope().getAccount().getAccountID());
        
        if(arguments.data.orderTemplateSystemCode == 'ottSchedule'){
            processObject.setScheduleOrderNextPlaceDateTime(arguments.data.scheduleOrderNextPlaceDateTime);  
        }
        
        orderTemplate = getOrderService().processOrderTemplate(orderTemplate,processObject,"create");
        
        getHibachiScope().addActionResult( "public:order.create", orderTemplate.hasErrors() );
        
        arguments.data['ajaxResponse']['orderTemplate'] = orderTemplate.getOrderTemplateID();
    }
    
    public any function addItemAndCreateWishlist( required struct data ) {
        var orderTemplate = this.createWishlist(argumentCollection=arguments);
        var orderTemplateItem = getService("OrderService").newOrderTemplateItem();
        orderTemplateItem.setOrderTemplate(orderTemplate);
        var sku = getService("SkuService").getSku(arguments.data['skuID']);
        orderTemplateItem.setSku(sku);
        orderTemplateItem.setQuantity(arguments.data['quantity']);
        //add item to template
        
    }
    
    public any function setAsCurrentFlexship(required any data) {
        param name="data.orderTemplateID" default="";
        
        var orderTemplate = getOrderService().getOrderTemplateForAccount(argumentCollection = arguments);
		if( isNull(orderTemplate) ) {
			return;
		}
		
	    getHibachiScope().getSession().setCurrentFlexship(orderTemplate);
	    var failure = isNull(getHibachiScope().getSession().getCurrentFlexship());
	    getHibachiScope().addActionResult( "public:setAsCurrentFlexship", failure );

	}

    public void function updatePrimaryPaymentMethod(required any data){
        param name="data.paymentMethodID" default="";

        var account = getHibachiScope().getAccount();
        var paymentMethod = getAccountService().getAccountPaymentMethod(arguments.data.paymentMethodID);

        account.setPrimaryPaymentMethod(paymentMethod);
        account = getAccountService().saveAccount(account);
        getHibachiScope().addActionResult( "public:account.updatePrimaryPaymentMethod", account.hasErrors());
    }
    
    public any function updateProfile( required struct data ) {
        var account = getHibachiScope().getAccount();
        if (structKeyExists(data, "firstName") && len(data.firstName)){
            account.setFirstName(data.firstName);
        }
        
        if (structKeyExists(data, "lastName") && len(data.lastName)){
            account.setLastName(data.lastName);
        }
        
        if (structKeyExists(data, "userName") && len(data.userName)){
            account.setUserName(data.userName);
        }
        
        if (structKeyExists(data, "phoneNumber") && len(data.phoneNumber)){
            var primaryPhone = account.getPrimaryPhoneNumber();
            primaryPhone.setPhoneNumber( data.phoneNumber );
        }
        
        if (structKeyExists(data, "emailAddress") && len(data.emailAddress)){
            var primaryEmail = account.getPrimaryEmailAddress();
            primaryEmail.setEmailAddress( data.emailAddress );
        }
        
        if (structKeyExists(data, "allowUplineEmails") && len(data.allowUplineEmails)){
            account.setAllowUplineEmails(data.allowUplineEmails);
        }
        
        account = getAccountService().saveAccount(account);
        
        getHibachiScope().addActionResult( "public:order.updateProfile", account.hasErrors() );
    }
    
    public void function updatePrimaryAccountShippingAddress(required any data){
        param name="data.accountAddressID" default="";
        
        var account = getHibachiScope().getAccount();
        var shippingAddress = getAccountService().getAccountAddress(arguments.data.accountAddressID);
        
        account.setPrimaryShippingAddress(shippingAddress);
        account = getAccountService().saveAccount(account);
        getHibachiScope().addActionResult( "public:account.updatePrimaryAccountShippingAddress", account.hasErrors());
    }
    
	public void function getProducts(required any data){
        param name="arguments.data.pageRecordsShow" default=5;
        param name="arguments.data.currentPage" default=1;
        
        var currencyCode = getHibachiScope().getAccount().getSiteCurrencyCode();
        var utilityService = getHibachiScope().getService('hibachiUtilityService');

		arguments.data['ajaxResponse']['productList'] = [];
		
		var scrollableSmartList = getHibachiService().getSkuPriceSmartList();
        
	    scrollableSmartList.addFilter('sku.activeFlag', true);
	    scrollableSmartList.addFilter('sku.publishedFlag', true);
	    scrollableSmartList.addFilter('maxQuantity', 'NULL');
	    scrollableSmartList.addFilter('minQuantity', 'NULL');
	    scrollableSmartList.addFilter('priceGroup.priceGroupCode', '1');

	    scrollableSmartList.addFilter('currencyCode', currencyCode);

	    scrollableSmartList.addWhereCondition("aslatwallsku.price <> 0.00");
	    scrollableSmartList.addWhereCondition("aslatwallsku.price != NULL");
	    scrollableSmartList.addWhereCondition("aslatwallskuprice.personalVolume <> 0.00");
	    scrollableSmartList.addWhereCondition("aslatwallskuprice.personalVolume != NULL");
	    
        var recordsCount = scrollableSmartList.getRecordsCount();
        
        scrollableSmartList.setPageRecordsShow(arguments.data.pageRecordsShow);
        scrollableSmartList.setCurrentPageDeclaration(arguments.data.currentPage);

		var scrollableSession = ormGetSessionFactory().openSession();
		var productList = scrollableSmartList.getScrollableRecords(refresh=true, readOnlyMode=true, ormSession=scrollableSession);
		
		//now iterate over all the objects
		
		try{
		    while(productList.next()){
		        
			    var product = productList.get(0);
			    var sku = product.getSku();

			    var productStruct={
			      "personalVolume"              :       utilityService.formatValue_currency(product.getPersonalVolume(), {currencyCode:currencyCode})?:"",
			      "skuImagePath"                :       product.getSkuImagePath()?:"",
  			      "marketPartnerPrice"          :       utilityService.formatValue_currency(product.getPrice(), {currencyCode:currencyCode})?:"",
			      "skuProductURL"               :       product.getSkuProductURL()?:"",
			      "productName"                 :       sku.getSkuName()?:"",
			      "skuID"                       :       sku.getSkuID()?:"",
  			      "skuCode"                     :       sku.getSkuCode()?:""
			    };

			    arrayAppend(arguments.data['ajaxResponse']['productList'], productStruct);
		    }
		    
		    arguments.data['ajaxResponse']['recordsCount'] = recordsCount;
		    
		}catch (e){
            throw(e)
		}finally{
			if (scrollableSession.isOpen()){
				scrollableSession.close();
			}
		}
	} 

    public void function setOwnerAccountOnAccount(required struct data){
        param name="arguments.data.ownerAccountID" default="";
        /** TODO: Once miguel's account type work goes add if statement to only run this if account type enrollment **/
        var account = getHibachiScope().getAccount();
        var ownerAccount = getAccountService().getAccount(arguments.data.ownerAccountID);
        account.setOwnerAccount(ownerAccount);
        account = getAccountService().saveAccount(account);
        getHibachiScope().addActionResult( "public:account.setOwnerAccountOnAccount", account.hasErrors());
    }
    
    public void function getStarterPackBundleStruct( required any data ) {
        param name="arguments.data.contentID" default="";
        
        if ( ! len( arguments.data.contentID ) ) {
            return;
        }

        var baseImageUrl = getHibachiScope().getBaseImageURL() & '/product/default/';
		
		var bundlePersistentCollectionList = getService('HibachiService').getSkuBundleCollectionList();
		bundlePersistentCollectionList.addFilter( 'sku.product.listingPages.content.contentID', arguments.data.contentID );
		bundlePersistentCollectionList.addFilter( 'bundledSku.product.activeFlag', true );
		bundlePersistentCollectionList.addFilter( 'bundledSku.product.publishedFlag', true );
		bundlePersistentCollectionList.addOrderBy( 'createdDateTime|DESC');
		
		if(!isNull(getHibachiScope().getCurrentRequestSite())){
		    bundlePersistentCollectionList.addFilter('sku.product.sites.siteID',getHibachiScope().getCurrentRequestSite().getSiteID());
		}
		
		bundlePersistentCollectionList.setDisplayProperties('
			skuBundleID,
			bundledSku.product.productName,
			bundledSku.product.defaultSku.imageFile,
			bundledSku.product.productType.productTypeID,
			bundledSku.product.productType.productTypeName,
			sku.skuPrices.personalVolume,
			sku.product.defaultSku.skuID,
			sku.product.productName,
			sku.product.productDescription,
			sku.product.defaultSku.imageFile
		');

		
		var bundleNonPersistentCollectionList = getService('HibachiService').getSkuBundleCollectionList();
		bundleNonPersistentCollectionList.setDisplayProperties('skuBundleID'); 	
		bundleNonPersistentCollectionList.addFilter( 'sku.product.listingPages.content.contentID', arguments.data.contentID );
		bundleNonPersistentCollectionList.addFilter( 'bundledSku.product.activeFlag', true );
		bundleNonPersistentCollectionList.addFilter( 'bundledSku.product.publishedFlag', true );
		
		if(!isNull(getHibachiScope().getCurrentRequestSite())){
		    bundleNonPersistentCollectionList.addFilter('sku.product.sites.siteID',getHibachiScope().getCurrentRequestSite().getSiteID());
		}
		
		bundleNonPersistentCollectionList.addOrderBy( 'createdDateTime|DESC');

		var visibleColumnConfigWithArguments = {
			"isVisible":true,
			"isDeletable":false,
			"isSearchable":false,
			"arguments":{
			}
		};
		
		if(!isNull(getHibachiScope().getAccount())){
			visibleColumnConfigWithArguments["arguments"]["currencyCode"] = getHibachiScope().getAccount().getSiteCurrencyCode();
			visibleColumnConfigWithArguments["arguments"]["accountID"] = getHibachiScope().getAccount().getAccountID();
		}

		//todo handle case where user is not logged in 
	
		bundleNonPersistentCollectionList.addDisplayProperty('bundledSku.priceByCurrencyCode', '', visibleColumnConfigWithArguments);
		bundleNonPersistentCollectionList.addDisplayProperty('sku.priceByCurrencyCode', '', visibleColumnConfigWithArguments);
	
		var skuBundles = bundlePersistentCollectionList.getRecords();
		var skuBundlesNonPersistentRecords = bundleNonPersistentCollectionList.getRecords();  

			
	
		// Build out bundles struct
		var bundles = {};
		var skuBundleCount = arrayLen(skuBundles);
		for ( var i=1; i<=skuBundleCount; i++ ){
		
			var skuBundle = skuBundles[i]; 
			structAppend(skuBundle, skuBundlesNonPersistentRecords[i]);
		
			var skuID = skuBundle.sku_product_defaultSku_skuID;
			var subProductTypeID = skuBundle.bundledSku_product_productType_productTypeID;
		
			// If this is the first time the parent product is looped over, setup the product.
			if ( ! structKeyExists( bundles, skuID ) ) {
				bundles[ skuID ] = {
					'ID': skuID,
					'name': skuBundle.sku_product_productName,
					'price': skuBundle.sku_priceByCurrencyCode,
					'description': skuBundle.sku_product_productDescription,
					'image': baseImageUrl & skuBundle.sku_product_defaultSku_imageFile,
					'personalVolume': skuBundle.sku_skuPrices_personalVolume,
					'productTypes': {}
				};
			}
			
			// If this is the first product type of it's kind, setup the product type.
			if ( ! structKeyExists( bundles[ skuID ].productTypes, subProductTypeID ) ) {
				bundles[ skuID ].productTypes[ subProductTypeID ] = {
					'name': skuBundle.bundledSku_product_productType_productTypeName,
					'products': []
				};
			}
		
			// Add sub product to the struct.
			arrayAppend( bundles[ skuID ].productTypes[ subProductTypeID ].products, {
				'name': skuBundle.bundledSku_product_productName,
				'price': skuBundle.bundledSku_priceByCurrencyCode,
				'image': baseImageUrl & skuBundle.bundledSku_product_defaultSku_imageFile
			});
		}
		
		arguments.data['ajaxResponse']['bundles'] = bundles;
    }
        
    public any function selectStarterPackBundle(required struct data){
        var cart = getHibachiScope().cart();
        
        //remove previously-selected StarterPackBundle
        if( StructKeyExists(arguments.data, 'previouslySelectedStarterPackBundleSkuID') ) {
            for( orderItem in cart.getOrderItems() ) {
                if( orderItem.getSku().getSkuID() == arguments.data['previouslySelectedStarterPackBundleSkuID'] ) {
                    arguments.data['orderItemID'] = orderItem.getOrderItemID();
                    getService("OrderService").processOrder( cart, arguments.data, 'removeOrderItem');
                    StructDelete(arguments.data, 'orderItemID');
                    break;
                }
            }
        }
        
        this.addOrderItem(argumentCollection = arguments);
    }

    
    private any function enrollUser(required struct data, required string accountType){
        var accountTypeInfo = {
            'VIP':{
                'priceGroupCode':'3',
                'statusSystemCode':'astEnrollmentPending',
                'activeFlag':false
            },
            'customer':{
                'priceGroupCode':'2',
                'statusSystemCode':'astGoodStanding',
                'activeFlag':true
            },
            'marketPartner':{
                'priceGroupCode':'1',
                'statusSystemCode':'astEnrollmentPending',
                'activeFlag':false
            }
        }
        
        if(getHibachiScope().getLoggedInFlag()){
            super.logout();
        }
        
        var account = super.createAccount(arguments.data);
        
        if(account.hasErrors()){
            addErrors(arguments.data, account.getProcessObject("create").getErrors());
            getHibachiScope().addActionResult('public:account.create',false);
            return account;
        }
        
        account.setAccountType(arguments.accountType);
        account.setActiveFlag(accountTypeInfo[arguments.accountType].activeFlag);
        
        var priceGroup = getService('PriceGroupService').getPriceGroupByPriceGroupCode(accountTypeInfo[arguments.accountType].priceGroupCode);
        
        if(!isNull(priceGroup)){
            account.addPriceGroup(priceGroup);
        }
        
        var accountStatusType = getService('TypeService').getTypeBySystemCodeOnly(accountTypeInfo[arguments.accountType].statusSystemCode);
        
        account.setAccountStatusType(accountStatusType);

        if(!isNull(getHibachiScope().getCurrentRequestSite())){
            account.setAccountCreatedSite(getHibachiScope().getCurrentRequestSite());
        }
        
        account = getAccountService().saveAccount(account);

        if(account.hasErrors()){
            addErrors(arguments.data, account.getErrors());
            getHibachiScope().addActionResult('public:account.create',false);
        }
        
        if(arguments.accountType == 'customer'){
            account.getAccountNumber();
        }
        
        getDAO('HibachiDAO').flushORMSession();
        
        var accountAuthentication = getDAO('AccountDAO').getActivePasswordByAccountID(accountID=account.getAccountID());
        getHibachiSessionService().loginAccount(account, accountAuthentication); 
        
        if(!getHibachiScope().getLoggedInFlag()){
             getHibachiScope().addActionResult('public:account.create',false);
        }
        
        return account;
    }
    
    public any function createMarketPartnerEnrollment(required struct data){
        return enrollUser(arguments.data, 'marketPartner');
    }
    
    public any function createRetailEnrollment(required struct data){
                
        if(isNull(arguments.data.sponsorID) || !len(arguments.data.sponsorID)){
    	    getHibachiScope().addActionResult( "public:account.create", true );
            addErrors(arguments.data, getHibachiScope().rbKey('frontend.validate.ownerRequired')); 
            arguments.data['ajaxResponse']['createAccount'] = getHibachiScope().rbKey('frontend.validate.ownerRequired');
            return;
        }
        
        return enrollUser(arguments.data, 'customer');
    }
    
    public any function createVIPEnrollment(required struct data){
       return enrollUser(arguments.data, 'VIP');
    }
    
    public any function updateAccount(required struct data){
        var account = super.updateAccount(arguments.data);
        if(!account.hasErrors()){
            if(!isNull(arguments.data['governmentIDNumber'])){
                var accountGovernmentIdentification = getService('AccountService').newAccountGovernmentIdentification();
                accountGovernmentIdentification.setGovernmentIdentificationNumber(arguments.data['governmentIDNumber']);
                accountGovernmentIdentification.setAccount(account);
                accountGovernmentIdentification = getService('AccountService').saveAccountGovernmentIdentification(accountGovernmentIdentification);
                if(accountGovernmentIdentification.hasErrors()){
                    addErrors(arguments.data,accountGovernmentIdentification.getErrors());
                }
                getHibachiScope().addActionResult('public:account.addGovernmentIdentification',accountGovernmentIdentification.hasErrors());
            }
            if ( 
                !isNull( arguments.data['month'] )
                && !isNull( arguments.data['year'] )
                && !isNull( arguments.data['day'] )
            ) {
                account.setBirthDate( arguments.data.month & '/' & arguments.data.day & '/' & arguments.data.year );
                getAccountService().saveAccount( account );
            }
        }
        return account;
    }
    
    public any function getDaysToEditOrderTemplateSetting(){
		arguments.data['ajaxResponse']['orderTemplateSettings'] = getService('SettingService').getSettingValue('orderTemplateDaysAllowedToEditNextOrderTemplate');
    }
    
    public void function submitSponsor(required struct data){
        param name="arguments.data.sponsorID" default="";


        var sponsorAccount = getService('accountService').getAccount(arguments.data.sponsorID);
        
        if(isNull(sponsorAccount)){
            getHibachiScope().addActionResult('public:account.submitSponsor',true);
            return;
        }
        
        var account = getHibachiScope().getAccount();
        if(account.getNewFlag()){
            getHibachiScope().addActionResult('public:account.submitSponsor',true);
            return;
        }
        if(account.hasParentAccountRelationship()){
            for(var accountRelationship in account.getParentAccountRelationships()){
                if(accountRelationship.getParentAccountID() != arguments.data.sponsorID){
                    getService('accountService').deleteAccountRelationship(accountRelationship);
                }
            }
        }
        
        if(!account.hasParentAccountRelationship()){
            var accountRelationship = getService('accountService').newAccountRelationship();
            accountRelationship.setParentAccount(sponsorAccount);
            accountRelationship.setChildAccount(getHibachiScope().getAccount());
            accountRelationship = getService('accountService').saveAccountRelationship(accountRelationship);
        }
        
        getHibachiScope().getAccount().setOwnerAccount(sponsorAccount);
        
        if(accountRelationship.hasErrors()){
            addErrors(arguments.data,accountRelationship.getErrors());
        }
        getHibachiScope().addActionResult('public:account.submitSponsor',accountRelationship.hasErrors());
        
    }

    public any function getAccountOrderTemplateNamesAndIDs(required struct data){
        param name="arguments.data.ordertemplateTypeID" default="2c9280846b712d47016b75464e800014"; //default to wishlist

        var accountID = getHibachiScope().getAccount().getAccountID();
		var orderTemplateCollectionList = getService('orderService').getOrderTemplateCollectionList();
		orderTemplateCollectionList.setDisplayProperties('orderTemplateID,orderTemplateName');
		orderTemplateCollectionList.addFilter('account.accountID', accountID);
		orderTemplateCollectionList.addFilter('ordertemplateType.typeID', arguments.data.ordertemplateTypeID);

		arguments.data['ajaxResponse']['orderTemplates'] = orderTemplateCollectionList.getPageRecords();
    }
    

    public any function addOrderItem(required struct data){
        var cart = super.addOrderItem(arguments.data);
        if(!cart.hasErrors() 
        && !isNull(cart.getAccount()) 
        && !isNull(cart.getAccount().getAccountStatusType()) 
        && cart.getAccount().getAccountStatusType().getSystemCode() == 'astEnrollmentPending'
        && isNull(cart.getMonatOrderType())){
            if(cart.getAccount().getAccountType() == 'marketPartner' ){
                cart.setMonatOrderType(getService('TypeService').getTypeByTypeCode('motMpEnrollment'));
            }else if(cart.getAccount().getAccountType() == 'vip'){
                cart.setMonatOrderType(getService('TypeService').getTypeByTypeCode('motVipEnrollment'));
            }
            
        }
        return cart;
    }

    public any function getMostRecentOrderTemplate (required any data){
        param name="arguments.data.accountID" default="getHibachiScope().getAccount().getAccountID()";
        param name="arguments.data.orderTemplateTypeID" default="2c948084697d51bd01697d5725650006"; //default to flexship
        
        var daysToEditFlexship = getService('SettingService').getSettingValue('orderTemplateDaysAllowedToEditNextOrderTemplate');
        
		var orderTemplateCollectionList = getService('OrderService').getOrderTemplateCollectionList();
		orderTemplateCollectionList.setDisplayProperties('scheduleOrderNextPlaceDateTime');
		orderTemplateCollectionList.setOrderBy('scheduleOrderNextPlaceDateTime|DESC');
		orderTemplateCollectionList.setOrderBy('createdDateTime|DESC');
		orderTemplateCollectionList.addFilter('account.accountID', arguments.data.accountID, '=');
		orderTemplateCollectionList.addFilter('orderTemplateType.typeID', arguments.data.orderTemplateTypeID, '=');
		orderTemplateCollectionList.setPageRecordsShow(1);
		collectionList = orderTemplateCollectionList.getPageRecords();
		arguments.data['ajaxResponse']['mostRecentOrderTemplate'] = collectionList;
		arguments.data['ajaxResponse']['daysToEditFlexship'] = daysToEditFlexship;
    }
    
    public any function getBaseProductCollectionList(required any data){
        var account = getHibachiScope().getAccount();
        var accountType = account.getAccountType();
        var holdingPriceGroups = account.getPriceGroups();
        var priceGroupCode = arrayLen(holdingPriceGroups) ? holdingPriceGroups[1].getPriceGroupCode() : 2;
        var currencyCode = getService('SiteService').getSiteByCmsSiteID(arguments.data.cmsSiteID).setting('skuCurrency');

        //TODO: Consider starting from skuPrice table for less joins
        var productCollectionList = getProductService().getProductCollectionList();
        productCollectionList.addDisplayProperties('productName');
        productCollectionList.addDisplayProperty('defaultSku.skuID');
        productCollectionList.addDisplayProperty('defaultSku.skuPrices.personalVolume');
        productCollectionList.addDisplayProperty('defaultSku.skuPrices.price');
        productCollectionList.addDisplayProperty('urlTitle');
        productCollectionList.addDisplayProperty('defaultSku.imageFile');
        
        var currentRequestSite = getHibachiScope().getCurrentRequestSite();
        if(!isNull(currentRequestSite) && currentRequestSite.hasLocation()){
            productCollectionList.addDisplayProperty('defaultSku.stocks.calculatedQATS','calculatedQATS');
            productCollectionList.addFilter('defaultSku.stocks.location.locationID',currentRequestSite.getLocations()[1].getLocationID());
        }

        productCollectionList.addFilter('activeFlag',1);
        productCollectionList.addFilter('publishedFlag',1);
        productCollectionList.addFilter(propertyIdentifier = 'publishedStartDateTime',value=now(), comparisonOperator="<=", filterGroupAlias = 'publishedStartDateTimeFilter');
        productCollectionList.addFilter(propertyIdentifier = 'publishedStartDateTime',value='NULL', comparisonOperator="IS", logicalOperator="OR", filterGroupAlias = 'publishedStartDateTimeFilter');
        productCollectionList.addFilter(propertyIdentifier = 'publishedEndDateTime',value=now(), comparisonOperator=">", filterGroupAlias = 'publishedEndDateTimeFilter');
        productCollectionList.addFilter(propertyIdentifier = 'publishedEndDateTime',value='NULL', comparisonOperator="IS", logicalOperator="OR", filterGroupAlias = 'publishedEndDateTimeFilter');
        productCollectionList.addFilter('skus.activeFlag',1);
        productCollectionList.addFilter('skus.publishedFlag',1);
        productCollectionList.addFilter('defaultSku.skuPrices.price', 0.00, '!=');
        productCollectionList.addFilter('defaultSku.skuPrices.currencyCode',currencyCode);
        productCollectionList.addFilter('defaultSku.skuPrices.priceGroup.priceGroupCode',priceGroupCode);

        if(isNull(accountType) || accountType == 'retail'){
           productCollectionList.addFilter('skus.retailFlag', 1);
        }else if(accountType == 'marketPartner'){
            productCollectionList.addFilter('skus.mpFlag', 1);
        }else{
            productCollectionList.addFilter('skus.vipFlag', 1);
        }

        return { productCollectionList: productCollectionList, priceGroupCode: priceGroupCode, currencyCode: currencyCode };
    }
    
    public any function getProductsByKeyword(required any data) {
        param name="arguments.data.keyword" default="";
        param name="arguments.data.currentPage" default="1";
        param name="arguments.data.pageRecordsShow" default="12";
        
        var returnObject = getBaseProductCollectionList(arguments.data);
        var productCollectionList = returnObject.productCollectionList;
        var priceGroupCode = returnObject.priceGroupCode;
        var currencyCode = returnObject.currencyCode;
       
        if ( len( arguments.data.keyword ) ) {
            productCollectionList.addFilter('productName', '%#arguments.data.keyword#%', 'LIKE');
        }
        
        var recordsCount = productCollectionList.getRecordsCount();
        productCollectionList.setPageRecordsShow(arguments.data.pageRecordsShow);
        productCollectionList.setCurrentPageDeclaration(arguments.data.currentPage);
        
        var pageRecords = productCollectionList.getPageRecords();
        if ( len( pageRecords ) ) {
            var nonPersistentRecords = getCommonNonPersistentProductProperties(pageRecords,priceGroupCode,currencyCode);
            arguments.data['ajaxResponse']['productList'] = nonPersistentRecords;
        } else {
            arguments.data['ajaxResponse']['productList'] = [];
        }
        arguments.data['ajaxResponse']['recordsCount'] = recordsCount;

    }

    public any function getProductsByCategoryOrContentID(required any data){
        param name="arguments.data.currentPage" default="1";
        param name="arguments.data.pageRecordsShow" default="12";
        param name="arguments.data.cmsContentFilterFlag" default= false; //Filter based off cms category for uses like content modules
        param name="arguments.data.contentFilterFlag" default= false; //Filter based off slatwall content ID for listing pages
        param name="arguments.data.cmsCategoryFilterFlag" default= false; //Filter based off page categories

        var returnObject = getBaseProductCollectionList(arguments.data);
        var productCollectionList = returnObject.productCollectionList;
        var priceGroupCode = returnObject.priceGroupCode;
        var currencyCode = returnObject.currencyCode;
  
        if( arguments.data.contentFilterFlag && !isNull(arguments.data.contentID) && len(arguments.data.contentID)) productCollectionList.addFilter('listingPages.content.contentID',arguments.data.contentID,"=" );
        if( arguments.data.cmsCategoryFilterFlag && !isNull(arguments.data.cmsCategoryID) && len(arguments.data.cmsCategoryID)) productCollectionList.addFilter('categories.cmsCategoryID', arguments.data.cmsCategoryID, "=" );
        if( arguments.data.cmsContentFilterFlag && !isNull(arguments.data.cmsContentID) && len(arguments.data.cmsContentID)) productCollectionList.addFilter('listingPages.content.cmsContentID',arguments.data.cmsContentID,"=" ); 
        
        
        getHibachiScope().logHibachi("getProductsByCategoryOrContentID: #productCollectionList.getHQL()#", true);
        var recordsCount = productCollectionList.getRecordsCount();
        productCollectionList.setPageRecordsShow(arguments.data.pageRecordsShow);
        productCollectionList.setCurrentPageDeclaration(arguments.data.currentPage);

        var nonPersistentRecords = getCommonNonPersistentProductProperties(productCollectionList.getPageRecords(), priceGroupCode, currencyCode);
		arguments.data['ajaxResponse']['productList'] = nonPersistentRecords;
        arguments.data['ajaxResponse']['recordsCount'] = recordsCount;
    }
    
    public any function getCommonNonPersistentProductProperties(required array records, required string priceGroupCode, required string currencyCode){
        
        var productService = getProductService();
        var productMap = {};
        var skuIDsToQuery = "";
        var index = 1;
        var skuCurrencyCode = arguments.currencyCode; 
    	var imageService = getService('ImageService');

        if(isNull(arguments.records) || !arrayLen(arguments.records)){
            return [];
        } 
        
        if(arguments.priceGroupCode == 3 || arguments.priceGroupCode == 1){
            var upgradedPriceGroupCode = 2;
            var upgradedPriceGroupID = "c540802645814b36b42d012c5d113745";
        } else{
            var upgradedPriceGroupCode = 3;
            var upgradedPriceGroupID = "84a7a5c187b04705a614eb1b074959d4";
        }
        
        //Looping over the collection list and using helper method to get non persistent properties
        for(var record in arguments.records){
            productMap[record.defaultSku_skuID] = {
                'skuID': record.defaultSku_skuID,
                'personalVolume': record.defaultSku_skuPrices_personalVolume,
                'price': record.defaultSku_skuPrices_price,
                'productName': record.productName,
                'skuImagePath': imageService.getResizedImageByProfileName(record.defaultSku_skuID,'medium'), //TODO: Find a faster method
                'skuProductURL': productService.getProductUrlByUrlTitle(record.urlTitle),
                'priceGroupCode': arguments.priceGroupCode,
                'upgradedPricing': '',
                'upgradedPriceGroupCode': upgradedPriceGroupCode,
                'qats': record.calculatedQATS
            };
            //add skuID's to skuID array for query below
            skuIDsToQuery = listAppend(skuIDsToQuery, record.defaultSku_skuID);
        }
        
        //Query skuPrice table to get upgraded skuPrices for skus in above collection list
         var upgradedSkuPrices = QueryExecute("SELECT price, skuID FROM swskuprice WHERE skuID IN(:skuIDs) AND priceGroupID =:upgradedPriceGroup AND currencyCode =:currencyCode AND activeFlag = 1",{
            skuIDs = {value=skuIDsToQuery, list=true, cfsqltype="cf_sql_varchar"}, 
            upgradedPriceGroup = {value=upgradedPriceGroupID, cfsqltype="cf_sql_varchar"},
            currencyCode = {value=skuCurrencyCode, cfsqltype="cf_sql_varchar"},
        });     

        //Add upgraded sku prices into the collection list 
        for(price in upgradedSkuPrices){
            var skuID = price['skuID'];
            var product = productMap[skuID];
            product.upgradedPricing = price;
        }
        return productMap;
    }
    
    public any function addEnrollmentFee(){
        var account = getHibachiScope().getAccount();
        
        if(account.getAccountStatusType().getSystemCode() == 'astEnrollmentPending'){
            if(account.getAccountType() == 'VIP'){
                var VIPSkuID = getService('SettingService').getSettingValue('integrationmonatGlobalVIPEnrollmentFeeSkuID');
                return addOrderItem({skuID:VIPSkuID, quantity: 1});
            }else if(account.getAccountType() == 'marketPartner'){
                var MPSkuID = getService('SettingService').getSettingValue('integrationmonatGlobalMPEnrollmentFeeSkuID');
                return addOrderItem({skuID:MPSkuID, quantity: 1});
            }
            
        }
    }
    
    public any function getMoMoneyBalance(){
        var account = getHibachiScope().getAccount();
        var paymentMethods = account.getAccountPaymentMethods();
        var balance = 0;
        
        for(method in paymentMethods){
            balance += method.getMoMoneyBalance();
        }
        arguments.data['ajaxResponse']['moMoneyBalance'] = balance;
    }
    

    
	public void function uploadProfileImage(required any data) {
		
		try{
		    getFileInfo(arguments.data.uploadFile);
		}catch(any e){
		    return;
		}
		
        account = getHibachiScope().getAccount();

		// Get the upload directory for the current property
		var strPath = getDirectoryFromPath( expandPath( "./" ));

		if (findNoCase("Slatwall", strPath)){
			var uploadDirectory = "#strPath#custom/assets/images/profileImage/";
		}else{
			var uploadDirectory = "#strPath#Slatwall/custom/assets/images/profileImage/";
		}
		var fileName = '#arguments.data.imageFile#';
		
		var fullFilePath = "#uploadDirectory##arguments.data.imageFile#";
			
		// If the directory where this file is going doesn't exists, then create it
		if(!directoryExists(uploadDirectory)) {
			directoryCreate(uploadDirectory);
		}
		
		//delete the last profile image
		if(!isNull(account.getProfileImage()) && fileExists('/#getHibachiScope().getBaseImageURL()#/profileImage/#account.getProfileImage()#')){
		    fileDelete('/#getHibachiScope().getBaseImageURL()#/profileImage/#account.getProfileImage()#')
		}
		
		if (arguments.data.uploadFile != '' && listFindNoCase("jpg,png", right(fileName, 3))){
			fileMove("#arguments.data.uploadFile#", "#fullFilePath#");
		}else{
			getHibachiScope().addActionResult( "uploadProfileImage", false );
		}
		//check if the file exists.
		if (fileExists("#fullFilePath#")){
			if (!isNull(account)){
				data.imageFile = "";
				account.setProfileImage(fileName);
				this.getAccountService().saveAccount(account);
				getHibachiScope().addActionResult( "uploadProfileImage", false );
			}else{
				getHibachiScope().addActionResult( "uploadProfileImage", true );
			}
			
		}else{
			getHibachiScope().addActionResult( "uploadProfileImage", true );
		}
	}
	
	public any function getAccountProfileImage(){
        param name="arguments.data.identifierType" default= ''; 
        param name="arguments.data.identifier" default= ''; 
        param name="arguments.data.height" default= 250; 
        param name="arguments.data.width" default= 250; 
        
        //if the identifiers are not passed in get the account on scope
        if(!len(arguments.data.identifier) || !len(arguments.data.identifierType)) {
            account = getHibachiScope().getAccount();
            arguments.data['ajaxResponse']['accountProfileImage'] = getService('imageService').getResizedImagePath('#getHibachiScope().getBaseImageURL()#/profileImage/#account.getProfileImage()#', arguments.data.width, arguments.data.height) ?:''; // find the best wa
        }else if(len(arguments.data.identifier) && len(arguments.data.identifierType)){
            //if identifiers are passed in, try to get the account using them
            try{
                var method = 'getAccountBy#toString(arguments.data.identifierType)#';
                var account = invoke(accountService, method, [arguments.data.identifier]);   
                arguments.data['ajaxResponse']['accountProfileImage'] = getService('imageService').getResizedImagePath('#getHibachiScope().getBaseImageURL()#/profileImage/#account.getProfileImage()#', arguments.data.width, arguments.data.height) ?:'';
            }catch(any e){
                arguments.data['ajaxResponse']['accountProfileImage'] = ''
            }
        }else{
            // if someone passes empty strings as an argument, return an empty string
            arguments.data['ajaxResponse']['accountProfileImage'] = ''
        }

	}

    public any function getSiteOwnerAccount(required struct data){
        param name="arguments.data.height" default= 250; 
        param name="arguments.data.width" default= 250; 
        param name="arguments.data.siteOwner" default= ''; 

        var account = getAccountService().getAccountByAccountNumber(arguments.data.siteOwner);
        var returnAccount = {};
        
        if(!isNull(account)){
            returnAccount['firstName'] =  account.getFirstName();
            returnAccount['lastName'] = account.getLastName();
            returnAccount['accountImage'] = getService('imageService').getResizedImagePath('#getHibachiScope().getBaseImageURL()#/profileImage/#account.getProfileImage()#', arguments.data.width, arguments.data.height) ?:'';
            returnAccount['calculatedFullName'] = account.getCalculatedFullName();
            arguments.data['ajaxResponse']['ownerAccount'] = returnAccount;
        }else{
            arguments.data['ajaxResponse']['ownerAccount'] = 'There is no owner account for this site';
        }
    }


}
