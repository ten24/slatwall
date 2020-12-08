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
component  accessors="true" output="false" 
{
    property name="accountService" type="any";
    property name="addressService" type="any";
    property name="formService" type="any";
    property name="orderService" type="any";
    property name="userUtility" type="any";
    property name="paymentService" type="any";
    property name="subscriptionService" type="any";
    property name="hibachiCacheService" type="any";
    property name="hibachiSessionService" type="any";
    property name="hibachiUtilityService" type="any";
    property name="productService" type="any";
    property name="hibachiAuditService" type="any";
    property name="validationService" type="any";
    property name="hibachiService" type="any";
    property name="typeService" type="any";
    property name="giftCardService";


    variables.publicContexts = [];
    variables.responseType = "json";
    
    public any function getHibachiScope(){
        return getHibachiService().getHibachiScope();
    }
    
    public any function getDAO(required string daoName){
        return getHibachiService().getDAO(arguments.daoName);
    }
    
    public any function getService(required string serviceName){
        return getHibachiService().getService(arguments.serviceName);
    }
    
    public any function invokeMethod(required string methodName, struct methodArguments={}) {
        
		if(structKeyExists(this, arguments.methodName)) {
			var theMethod = this[ arguments.methodName ];
			return theMethod(argumentCollection = methodArguments);
		}
		
		throw("You have attempted to call the method #arguments.methodName# which does not exist in publicService");
	}
	
	
	/***
	 * Method to return list of bundle groups and sku list for product
	 * 
	 * @param - productID
	 * @param - currentPage
	 * @param - pageRecordsShow
	 * @return - bundleResponse - custom array of keys
	 **/
	public void function getProductBundles( required struct data ) {
	    param name="arguments.data.productID";
	    param name="arguments.data.currentPage" default=1;
        param name="arguments.data.pageRecordsShow" default= getHibachiScope().setting('GLOBALAPIPAGESHOWLIMIT');
        
	    var product = getProductService().getProduct( arguments.data.productID );
        
        if( !isNull(product) && product.getBaseProductType() == "productBundle") {
            //get product bundles
            var bundleProductCollectionList = getProductService().getProductBundleGroupCollectionList();
            bundleProductCollectionList.setDisplayProperties("productBundleGroupID, skuCollectionConfig, minimumQuantity, maximumQuantity, amount, amountType, productBundleGroupType.typeName");
            bundleProductCollectionList.addFilter("productBundleSku.skuID", product.getDefaultSku().getSkuID());
            bundleProductCollectionList.addFilter("activeFlag", 1);
            var bundleProducts = bundleProductCollectionList.getRecords(formatRecords=false);
            
            
            //var bundleProducts = product.getDefaultSku().getProductBundleGroups();
            var bundleResponse = [];
            
            //populate bundle response
            for( var bundle in bundleProducts) {
                //get sku list form collection config
                var skuCollections = getSkuService().getSkuCollectionList();
                skuCollections.setCollectionConfig( bundle['skuCollectionConfig'] );
                skuCollections.setPageRecordsShow(arguments.data.pageRecordsShow);
	            skuCollections.setCurrentPageDeclaration(arguments.data.currentPage); 
                var bundleSkuList = skuCollections.getPageRecords(formatRecords=false);
                
                ArrayAppend(bundleResponse, {
                  'minimumQuantity':  bundle['minimumQuantity'],
                  'maximumQuantity': bundle['maximumQuantity'],
                  'bundleType': bundle['productBundleGroupType_typeName'],
                  'amount': bundle['amount'],
                  'amountType': bundle['amountType'],
                  'skuList': bundleSkuList,
                  'defaultSkuID': product.getDefaultSku().getSkuID(),
                  'productBundleGroupID': bundle['productBundleGroupID'],
                });
            }
            
            arguments.data.ajaxResponse['data'] = bundleResponse;
            getHibachiScope().addActionResult("public:product.getProductBundles",false);
        } else {
            getHibachiScope().addActionResult("public:product.getProductBundles",true);
        }
	}
	
	/**
	 * Method to get existing product bundle builds
	 * @param - skuID (default sku ID for bundle product)
	 * @return bundleBuildResponse - custom array of product bundle builds
	 * */
	public void function getProductBundleBuild( required struct data ) {
	    param name="arguments.data.skuID";
	    
	    var account = getHibachiScope().getAccount();
	    var sku = getProductService().getSku( arguments.data.skuID );
	    
	    if( isNull( sku ) ) {
	        getHibachiScope().addActionResult("public:product.getProductBundleBuilds",true);
	        return;
	    }
	    
	    if( !account.isNew() ) {
	        var productBundleBuild = getProductService().getProductBundleBuildByAccountANDProductBundleSku( [account, sku] );
	    } else {
	        var productBundleBuild = getProductService().getProductBundleBuildByProductBundleSkuANDSession( [sku, getHibachiScope().getSession()] );
	    }
	    
    
        if( isNull( productBundleBuild ) ) {
	        getHibachiScope().addActionResult("public:product.getProductBundleBuilds",true);
	        return;
	    }
    
        var productBundleBuildItemCollectionList = getProductService().getProductBundleBuildItemCollectionList();
        productBundleBuildItemCollectionList.setDisplayProperties("quantity, productBundleBuildItemID, sku.skuID")
        productBundleBuildItemCollectionList.addFilter( "productBundleBuild.productBundleBuildID",  productBundleBuild.getProductBundleBuildID() );
        
        var bundleBuildResponse = {
            "productBundleBuildID" : productBundleBuild.getProductBundleBuildID(),
            "productBundleSkuID" : productBundleBuild.getProductBundleSkuID(),
            "bundleItems" : productBundleBuildItemCollectionList.getRecords( formatRecords = false )
        };
	    
	    arguments.data.ajaxResponse['data'] = bundleBuildResponse;
        getHibachiScope().addActionResult("public:product.getProductBundleBuilds",false);
	}
	
	/**
	 * Method to create product bundle build
	 * 
	 * @param - skuID
	 * @param - default skuID (from bundle product)
	 * @param - quantity
	 * */
	public void function createProductBundleBuild( required struct data ) {
	    param name="arguments.data.skuID";
	    param name="arguments.data.quantity";
	    param name="arguments.data.productBundleGroupID";
	    param name="arguments.data.defaultSkuID";
	    
	    var bundleSku = getProductService().getSku( arguments.data.defaultSkuID );
	    var account = getHibachiScope().getAccount();
	    var sku = getProductService().getSku( arguments.data.skuID );
	    
	    if( isNull( sku ) || isNull( bundleSku ) ) {
	        getHibachiScope().addActionResult("public:product.createProductBundleBuild",true);
	        return;
	    }
	    
	    if( !account.isNew() ) {
	        var productBundleBuild = getProductService().getProductBundleBuildByAccountANDProductBundleSku( [account, bundleSku] );
	    } else {
	        var productBundleBuild = getProductService().getProductBundleBuildBySessionANDProductBundleSku( [ getHibachiScope().getSession(), bundleSku] );
	    }
        
        if( isNull( productBundleBuild ) ) {
            
            productBundleBuild = getProductService().newProductBundleBuild();
            productBundleBuild.setProductBundleSku( bundleSku );
            
            if( !isNull( getHibachiScope().getSession() ) ) {
                productBundleBuild.setSession( getHibachiScope().getSession() );
            }
            
            if( !account.isNew() ) {
                productBundleBuild.setAccount( account );
            }
            
            productBundleBuild = getProductService().saveProductBundleBuild( productBundleBuild );
            
            if( productBundleBuild.hasErrors() ) {
                getHibachiScope().addActionResult("public:product.createProductBundleBuild",true);
	            return;
            }
            
        }
        
        //Check & update bundle items
        var productBundleBuildItem = getProductService().getProductBundleBuildItemBySkuANDProductBundleBuild( [sku, productBundleBuild] );
        
        if( isNull( productBundleBuildItem ) ) {
            productBundleBuildItem = getProductService().newProductBundleBuildItem();
        }
        productBundleBuildItem.setQuantity( arguments.data.quantity );
        productBundleBuildItem.setSku( sku );
        productBundleBuildItem.setProductBundleBuild( productBundleBuild );
        productBundleBuildItem.setProductBundleGroup( getProductService().getProductBundleGroup( arguments.data.productBundleGroupID ) );
        productBundleBuildItem = getProductService().saveProductBundleBuildItem( productBundleBuildItem );
        
        if( productBundleBuildItem.hasErrors() ) {
            getHibachiScope().addActionResult("public:product.createProductBundleBuild",true);
            return;
        }
        
        getHibachiScope().addActionResult("public:product.createProductBundleBuild",false);
	}
	
	 /**
	 * Method to delete product bundle build
	 * 
	 * @param - productBundleBuildID
	 * */
	public void function removeProductBundleBuild( required struct data ) {
	    param name="arguments.data.productBundleBuildID";
	    var account = getHibachiScope().getAccount();
	    
	    var productBundleBuild = getProductService().getProductBundleBuild( arguments.data.productBundleBuildID );
        
        if( isNull( productBundleBuild ) || ( ( !isNull(productBundleBuild.getAccount()) && productBundleBuild.getAccount().getAccountID() != account.getAccountID() ) || ( !isNull(productBundleBuild.getSession()) && productBundleBuild.getSession().getSessionID() != getHibachiScope().getSession().getSessionID() ) ) ) {
            getHibachiScope().addActionResult("public:product.removeProductBundleBuild",true);
            return;
        }
        
        var deleteBundle = getProductService().deleteProductBundleBuild( productBundleBuild );
        getHibachiScope().addActionResult("public:product.removeProductBundleBuild", !deleteBundle );
	}
	
	/**
	 * Method to set product bundle build to cart
	 * @param - productBundleBuildID
	 * */
	 public void function addProductBundleToCart( required struct data ) {
	    param name="arguments.data.productBundleBuildID";
	    var account = getHibachiScope().getAccount();
	    
	    var productBundleBuild = getProductService().getProductBundleBuild( arguments.data.productBundleBuildID );
        
        if( isNull( productBundleBuild ) || productBundleBuild.getAccount().getAccountID() != account.getAccountID() ) {
            getHibachiScope().addActionResult("public:product.addProductBundleToCart",true);
            return;
        }
        
        //set bundle sku id
        arguments.data['skuID'] = productBundleBuild.getProductBundleSku().getSkuID();
        arguments.data['quantity'] = 1;
        arguments.data['parentOrderItem']['orderItemID'] = productBundleBuild.getProductBundleSku().getSkuID();
        arguments.data['productBundleGroups'] = [];
        arguments.data['productBundleGroups'][1]['productBundleGroupID'] = productBundleBuild.getProductBundleSku().getProductBundleGroups()[1].getProductBundleGroupID();
        arguments.data['childOrderItems'] = [];
        //Populate child order items
        var childCount = 0;
        for( var bundleItem in productBundleBuild.getProductBundleBuildItems() ) {
            childCount++;
            arguments.data['childOrderItems'][childCount]['sku']['skuID'] = bundleItem.getSku().getSkuID();
            arguments.data['childOrderItems'][childCount]['quantity'] = bundleItem.getQuantity();
            arguments.data['childOrderItems'][childCount]['parentOrderItem']['orderItemID'] = bundleItem.getSku().getSkuID();
            arguments.data['childOrderItems'][childCount]['productBundleGroup']['productBundleGroupID'] = bundleItem.getProductBundleGroup().getProductBundleGroupID();
        }
        
        //Call Add Order Item
        this.addOrderItem(data= arguments.data);
	 }
	
	
	/**
	 * Get Order Details with Order Invoice
	 * @param orderID
	 * @return none
	 * */
	 public void function getOrderDetails(required struct data) {
	     param name="arguments.data.orderID";
	     
	     var account = getHibachiScope().getAccount();
	     if(!isNull(account) && !isEmpty(account.getAccountID())) {
	         var order = orderService.getOrder(arguments.data.orderID);
	         if(!isNull(order) && (order.getAccount().getAccountID() == account.getAccountID() || account.getSuperUserFlag() == true ) ) {
	             arguments.data.ajaxResponse['orderDetails'] = orderService.getOrderDetails(order.getOrderID(), account.getAccountID());
	             getHibachiScope().addActionResult("public:account.getOrderDetails",false);
	         } else {
	             getHibachiScope().addActionResult("public:account.getOrderDetails",true);
	         }
	     } else {
	         getHibachiScope().addActionResult("public:account.getOrderDetails",true);
	     }
	 }
	
	/**
	 * Function add account phone phone
	 * @param phoneNumber required
	 * @return none
	 * */
	 public void function addAccountPhoneNumber(required struct data) {
	     param name="arguments.data.phoneNumber";
	     
	     var account = getService("AccountService").processAccount(getHibachiScope().getAccount(), arguments.data, 'addAccountPhoneNumber');
        if (account.hasErrors()) {
            addErrors(arguments.data, getHibachiScope().getAccount().getProcessObject('addAccountPhoneNumber').getErrors());
        }
        getHibachiScope().addActionResult("public:account.addAccountPhoneNumber",account.hasErrors());
	 }
	
	/**
	 * Function add account email address
	 * @param emailAddress required
	 * @return none
	 * */
	 public void function addAccountEmailAddress(required struct data) {
	     param name="arguments.data.emailAddress";
	     
	     var account = getService("AccountService").processAccount(getHibachiScope().getAccount(), arguments.data, 'addAccountEmailAddress');
        if (account.hasErrors()) {
            addErrors(arguments.data, getHibachiScope().getAccount().getProcessObject('addAccountEmailAddress').getErrors());
        }
        getHibachiScope().addActionResult("public:account.addAccountEmailAddress",account.hasErrors());
	 }
	
     /**
     * Function to set primary email address
     * @param accountEmailAddressID required
     * @return none
     **/
     public void function setPrimaryEmailAddress(required struct data) {
        param name="arguments.data.accountEmailAddressID";
        var accountEmailAddress = getService('accountService').getAccountEmailAddress(arguments.data.accountEmailAddressID);
        if(!isNull(accountEmailAddress) && getHibachiScope().getAccount().getAccountID() == accountEmailAddress.getAccount().getAccountID() ) {
            getHibachiScope().getAccount().setPrimaryEmailAddress(accountEmailAddress);
            var accountSave = getService('accountService').saveAccount(getHibachiScope().getAccount());
            getHibachiScope().addActionResult( "public:setPrimaryEmailAddress", accountSave.hasErrors() );
        } else {
            getHibachiScope().addActionResult( "public:setPrimaryEmailAddress", true );
        }
        
        if(isNull(accountEmailAddress)){
            addErrors(arguments.data, getHibachiScope().rbKey('validate.setPrimaryEmailAddress.accountEmailAddressID.isRequired')) ;
        }else if(getHibachiScope().getAccount().getAccountID() != accountEmailAddress.getAccount().getAccountID()){
            addErrors(arguments.data, getHibachiScope().rbKey('validate.addAccountEmailAddress.Account_AddAccountEmailAddress.emailAddress.isUniqueEmailToAccount'));
        }
        
        
        
     }
    
    
    /**
     * Function to set primary account address
     * @param accountAddressId required
     * @return none
     **/
     public void function setPrimaryAccountAddress(required struct data) {
        param name="arguments.data.accountAddressID";
        var accountAddress = getService('accountService').getAccountAddress(arguments.data.accountAddressID);
        if(!isNull(accountAddress) && getHibachiScope().getAccount().getAccountID() == accountAddress.getAccount().getAccountID() ) {
            
            getHibachiScope().getAccount().setPrimaryAddress(accountAddress);
            var accountSave = getService('accountService').saveAccount(getHibachiScope().getAccount());
            getHibachiScope().addActionResult( "public:cart.setPrimaryAccountAddress", accountSave.hasErrors() );
        } else {
            getHibachiScope().addActionResult( "public:cart.setPrimaryAccountAddress", true );
        }
     }
	
	
	/**
     * Function to set primary phone number
     * @param accountPhoneNumberID required
     * @return none
     **/
     public void function setPrimaryPhoneNumber(required struct data) {
        param name="arguments.data.accountPhoneNumberID";
        var accountPhoneNumber = getService('accountService').getAccountPhoneNumber(arguments.data.accountPhoneNumberID);
        if(!isNull(accountPhoneNumber) && getHibachiScope().getAccount().getAccountID() == accountPhoneNumber.getAccount().getAccountID() ) {
            
            getHibachiScope().getAccount().setPrimaryPhoneNumber(accountPhoneNumber);
            var accountSave = getService('accountService').saveAccount(getHibachiScope().getAccount());
            getHibachiScope().addActionResult( "public:setPrimaryPhoneNumber", accountSave.hasErrors() );
        } else {
            getHibachiScope().addActionResult( "public:setPrimaryPhoneNumber", true );
        }
     }
     
    
    /**
     * Function to get Types by Type Code
     * It adds typeList as key in ajaxResponse
     * @param typeCode required
     * @return none
    */
    public void function getSystemTypesByTypeCode(required struct data){
        param name="arguments.data.typeCode" default="";
        
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
        param name="arguments.data.skuID" default="";
        param name="arguments.data.locationID" default="";
        
        var stock = getService('stockService').getCurrentStockBySkuAndLocation( arguments.data.skuID, arguments.data.locationID );
        arguments.data.ajaxResponse['stock'] = stock;
    }
    
    /**
     * Function to get Product Reviews
     * It adds productReviews as key in ajaxResponse
     * @param productID
     * @return none
    */
    public void function getProductReviews(required struct data){
        param name="arguments.data.productID" default="";
        
        var productReviews = getService('productService').getAllProductReviews(productID = arguments.data.productID);
        arguments.data.ajaxResponse['productReviews'] = productReviews;
    }
    
    /**
     * Function to get Related Products
     * It adds relatedProducts as key in ajaxResponse
     * @param productID
     * @return none
    */
    public void function getRelatedProducts(required struct data){
        param name="arguments.data.productID" default="";
        var relatedProducts = getService('productService').getAllRelatedProducts(productID = arguments.data.productID);
        //add images
        if(arrayLen(relatedProducts)) {
            relatedProducts = getService('productService').appendImagesToProduct(relatedProducts, "relatedProduct_defaultSku_imageFile");
        }
        arguments.data.ajaxResponse['relatedProducts'] = relatedProducts;
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
        param name="arguments.data.productID" default="";
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
        param name="arguments.data.productID" default="";
        param name="arguments.data.optionGroupID" default="";
        
        arguments.data.ajaxResponse['productOptions'] = getService('optionService').getOptionsByOptionGroup( arguments.data.productID, arguments.data.optionGroupID );
    }
    
    /**
     * Function to get applied payments on order
     * adds appliedPayments in ajaxResponse
     * @param request data
     * @return none
     **/
    public void function getAppliedPayments(required any data) {
        
        arguments.data['ajaxResponse']['appliedPayments'] = getOrderService().getAppliedOrderPayments(getHibachiScope().getCart());
    }
    
    /**
     * Function to get applied promotions on order
     * adds appliedPromotionCodes in ajaxResponse
     * @param request data
     * @return none
     **/
    public void function getAppliedPromotionCodes(required any data) {
        
        arguments.data['ajaxResponse']['appliedPromotionCodes'] = getHibachiScope().getCart().getAllAppliedPromotions();
    }
    
    /**
     * Function to get all eligible account payment methods 
     * adds availableShippingMethods in ajaxResponse
     * @param request data
     * @return none
     **/
    public void function getAvailablePaymentMethods(required any data) {
        
        arguments.account = getHibachiScope().getAccount();
        
        var accountPaymentMethods = getService("accountService").getAvailablePaymentMethods( argumentCollection=arguments );
	    arguments.data['ajaxResponse']['availablePaymentMethods'] = accountPaymentMethods;
    }
    
    /**
     * Function to get all available shipping methods 
     * adds availableShippingMethods in ajaxResponse
     * @param request data
     * @return none
     **/
    public void function getAvailableShippingMethods(required any data) {
        var orderFulfillments = getHibachiScope().getCart().getOrderFulfillments();
        for(var orderFulfillment in orderFulfillments) {
            if(orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() == "shipping") {
                var shippingMethods = getOrderService().getShippingMethodOptions(orderFulfillment);
	            arguments.data['ajaxResponse']['availableShippingMethods'] = shippingMethods;
	            break;
            }
        }
    }
	
	/**
     * Function to get the parent accounts of user account
     **/
    public void function getParentOnAccount(required any data) {
        arguments.data['ajaxResponse']['parentAccount'] = getAccountService().getAllParentsOnAccount(getHibachiScope().getAccount());
    }
    
    /**
     * Function to get the child accounts of user account
     **/
    public void function getChildOnAccount(required any data) {
        arguments.data['ajaxResponse']['childAccount'] = getAccountService().getAllChildsOnAccount(getHibachiScope().getAccount());
    }
	
	/**
     * Function to get list of subscription usage
     * adds subscriptionUsageOnAccount in ajaxResponse
     * @param pageRecordsShow optional
     * @param currentPage optional
     * @return none
     **/
    public void function getSubscriptionsUsageOnAccount(required any data) {
        
        arguments.account = getHibachiScope().getAccount();
        
        var subscriptionUsage = getSubscriptionService().getSubscriptionsUsageOnAccount( argumentCollection=arguments );
        arguments.data['ajaxResponse']['subscriptionUsageOnAccount'] = subscriptionUsage;
    }
	
	/**
     * Function to get list of gift cards for user
     * adds giftCardsOnAccount in ajaxResponse
     * @param pageRecordsShow optional
     * @param currentPage optional
     * @return none
     **/
    public void function getAllGiftCardsOnAccount(required any data) {
        arguments.account = getHibachiScope().getAccount();
        var giftCards = getService('giftCardService').getAllGiftCardsOnAccount( argumentCollection=arguments);
        arguments.data['ajaxResponse']['giftCardsOnAccount'] = giftCards;
    }
	
	/**
     * Function to get all order deliveries for user
     * adds cartsAndQuotesOnAccount in ajaxResponse
     * @param pageRecordsShow optional
     * @param currentPage optional
     * @return none
     **/
    public void function getAllOrderDeliveryOnAccount(required any data) {
        arguments.account = getHibachiScope().getAccount();
        var accountOrders = getOrderService().getAllOrderDeliveryOnAccount( argumentCollection=arguments );
        arguments.data['ajaxResponse']['orderDeliveryOnAccount'] = accountOrders;
    }
	
	/**
     * Function to get all order fulfilments for user
     * adds cartsAndQuotesOnAccount in ajaxResponse
     * @param pageRecordsShow optional
     * @param currentPage optional
     * @return none
     **/
    public void function getAllOrderFulfillmentsOnAccount(required any data) {
        
        arguments.account = getHibachiScope().getAccount();
        
        var accountOrders = getOrderService().getAllOrderFulfillmentsOnAccount( argumentCollection=arguments );
        arguments.data['ajaxResponse']['orderFulFillemntsOnAccount'] = accountOrders;
    }
	
	/**
     * Function to get all carts and quotes for user
     * adds cartsAndQuotesOnAccount in ajaxResponse
     * @param pageRecordsShow optional
     * @param currentPage optional
     * @return none
     **/
    public void function getAllCartsAndQuotesOnAccount(required any data) {
        
        arguments.account = getHibachiScope().getAccount();
        
        var accountOrders = getOrderService().getAllCartsAndQuotesOnAccount( argumentCollection=arguments );
        arguments.data['ajaxResponse']['cartsAndQuotesOnAccount'] = accountOrders;
    }
	
	/**
     * Function to get all orders for user
     * adds ordersOnAccount in ajaxResponse
     * @param pageRecordsShow optional
     * @param currentPage optional
     * @return none
     **/ 
    public void function getAllOrdersOnAccount(required any data){
        
        arguments.account = getHibachiScope().getAccount();
        
        var accountOrders = getAccountService().getAllOrdersOnAccount(
            argumentCollection=arguments );
        arguments.data['ajaxResponse']['ordersOnAccount'] = accountOrders;
    }
	
	
	
	/**
      * Updates an Account address.
      */
    public void function updateAccountAddress(required data){
     	param name="arguments.data.countryCode" default="US";
     	param name="arguments.data.accountAddressID" default="";
     	param name="arguments.data.phoneNumber" default="";

     	var addressID = "";
     	var accountAddress = getHibachiScope().getService("AccountService").getAccountAddress( arguments.data.accountAddressID );
        
        if (!isNull(accountAddress) && getHibachiScope().getAccount().getAccountID() == accountAddress.getAccount().getAccountID() ){
            addressID = accountAddress.getAddressID();
        }

     	var newAddress = getService("AddressService").getAddress(addressID);
     	if ( !isNull(newAddress) && !newAddress.hasErrors() ) {
     	    
     	    newAddress = getService("AddressService").saveAddress(newAddress, arguments.data, "full");
     	    
     	    //save account address
     	    accountAddress = getHibachiScope().getService("AccountService").saveAccountAddress( accountAddress, arguments.data );
     	    
            if(!newAddress.hasErrors() && !accountAddress.hasErrors()) {
  	     	   getHibachiScope().addActionResult( "public:cart.updateAddress", true );
            }else {
                getHibachiScope().addActionResult( "public:cart.updateAddress", (newAddress.hasErrors() || accountAddress.hasErrors() ) ); 
            }
    	}else {
    	    if(isNull(newAddress)) {
                getHibachiScope().addActionResult( "public:cart.updateAddress", false );
    	    } else {
    	        getHibachiScope().addActionResult( "public:cart.updateAddress", newAddress.getErrors() );
    	    }
        }
     }
    
    /**
     * This will return the path to an image based on the skuIDs (sent as a comma seperated list)
     * and a 'profile name' that determines the size of that image.
     * /api/scope/getResizedImageByProfileName&profileName=large&skuIDs=8a8080834721af1a0147220714810083,4028818d4b31a783014b5653ad5d00d2,4028818d4b05b871014b102acb0700d5
     * ...should return three paths.
     */
    public any function getResizedImageByProfileName(required any data) {
        
        var imageHeight = 60;
        var imageWidth  = 60;
        
        if(arguments.data.profileName == "small"){
            imageHeight = getService('SettingService').getSettingValue('productImageSmallHeight');
            imageWidth  = getService('SettingService').getSettingValue('productImageSmallWidth');
            
        }else if (arguments.data.profileName == "medium"){
            imageHeight = getService('SettingService').getSettingValue('productImageMediumHeight');
            imageWidth  = getService('SettingService').getSettingValue('productImageMediumWidth');
        }
        else if (arguments.data.profileName == "large"){
            imageHeight = getService('SettingService').getSettingValue('productImageLargeHeight');
            imageWidth  = getService('SettingService').getSettingValue('productImageLargeWidth');
        }
        else if (arguments.data.profileName == "xlarge"){
            imageHeight = getService('SettingService').getSettingValue('productImageXLargeHeight');
            imageWidth  = getService('SettingService').getSettingValue('productImageXLargeWidth');
        }
        else if (arguments.data.profileName == "listing"){
            imageHeight = getService('SettingService').getSettingValue('productListingImageHeight');
            imageWidth  = getService('SettingService').getSettingValue('productListingImageWidth');
        }
        arguments.data.ajaxResponse['resizedImagePaths'] = {};
        var skus = [];
        
        //smart list to load up sku array
        var skuSmartList = getService('skuService').getSkuSmartList();
        skuSmartList.addInFilter('skuID',data.skuIDs);
        
        for (var skuID in data.skuIDs){
            var sku = getService('SkuService').getSku(skuID);
            if(!isNull(sku)){
                arguments.data.ajaxResponse['resizedImagePaths'][skuID] = sku.getResizedImagePath(width=imageWidth, height=imageHeight);         
            }
        }
        arguments.data.returnJsonObjects = "";
    }
    
    /**
     @method Login <b>Log a user account into Slatwall given the users emailAddress and password</b>
     @http-context <b>Login</b> Use this context in conjunction with the listed http-verb to use this resoudatae.
     @http-verb POST
     @http-return <b>(200)</b> Request Successful, <b>(400)</b> Bad or Missing Input Data
     @param Required Header: emailAddress
     @param Required Header: password
     @description Use this context to log a user into Slatwall. The required email address/password should be sent
                               bundled in a Basic Authorization header with the emailAddress and password 
                               appended together using an colon and then converted to base64.
                                                  
     @example  testuser@slatwalltest.com:Vah7cIxXe would become dGVzdHVzZXJAc2xhdHdhbGx0ZXN0LmNvbTpWYWg3Y0l4WGU=    
     @ProcessMethod Account_Login           
     */
    
    public any function login( required struct data ){
        var accountProcess = getService("AccountService").processAccount( getHibachiScope().getAccount(), arguments.data, 'login' );
        getHibachiScope().addActionResult( "public:account.login", accountProcess.hasErrors() );
        if (accountProcess.hasErrors()){
            if (getHibachiScope().getAccount().hasErrors()){
                acountProcess.$errors = getHibachiScope().getAccount().getErrors();
            }
            addErrors(data, getHibachiScope().getAccount().getProcessObject("login").getErrors());
        }
        return accountProcess;
    }
    
    /** returns the result of a processObject based action including error information. A form submit.
        This is the default behavior for a POST request to process context /api/scope/process/ */    
    public any function doProcess(required struct data){
        
        if (structKeyExists(data, "processObject")){
            try{
                var processObject = this.invokeMethod(data.processObject,{1=data});
                
            }catch(any e){
                arguments.data.ajaxResponse['processObject']['errors'] = "#e#";
            }
        }
        if (!isNull(processObject)){
            arguments.data.ajaxResponse['processObject']                  = processObject.getThisMetaData();
            arguments.data.ajaxResponse['processObject']['validations']   = processObject.getValidations();
            arguments.data.ajaxResponse['processObject']['hasErrors']     = processObject.hasErrors();
            arguments.data.ajaxResponse['processObject']['errors']        = processObject.getErrors();
            arguments.data.ajaxResponse['processObject']['messages']      = processObject.getMessages();    
        }
    }
    
    /** 
     * @method Logout <b>Log a user account outof Slatwall given the users request_token and deviceID</b>
     * @http-context Logout Use this context in conjunction with the listed http-verb to use this resoudatae.
     * @http-verb POST
     * @http-return <b>(200)</b> Request Successful <b>(400)</b> Bad or Missing Input Data
     * @description  Logs a user out of the given device  
     * @param Required request_token
     * @param Required deviceID
     * @example POST to /api/scope/logout with request_token and deviceID in headers
     * @ProcessMethod Account_Logout
     */
    public any function logout( struct data  = {} ){ 
        
        var account = getService("AccountService").processAccount( getHibachiScope().getAccount(), arguments.data, 'logout' );
        getHibachiScope().addActionResult( "public:account.logout", account.hasErrors() );
        if(account.hasErrors()){
            addErrors(data, getHibachiScope().getAccount().getProcessObject("logout").getErrors());
        }
        arguments.data.ajaxResponse['token'] = '';
        return account;
    }   
    
    /** 
     *  @method CreateAccount
     *  @http-context createAccount
     *  @http-verb POST
     *  @description  CreateAccount Creates a new user account.  
     *  @http-return <b>(201)</b> Created Successfully or <b>(400)</b> Bad or Missing Input Data
     *  @param firstName {string}
     *  @param lastName {string}
     *  @param company {string}
     *  @param phone {string}
     *  @param emailAddress {string}
     *  @param emailAddressConfirm {string}
     *  @param createAuthenticationFlag {string}
     *  @param password {string}
     *  @param passwordConfirm {string}
     *  @ProcessMethod Account_Create
     */

    public any function createAccount( required struct data ) {
        param name="arguments.data.createAuthenticationFlag" default="1";
        
        var account = getService("AccountService").processAccount( getHibachiScope().getAccount(), arguments.data, 'create');

        if(account.hasErrors()){
            addErrors(arguments.data, getHibachiScope().getAccount().getProcessObject("create").getErrors());
        }

        getHibachiScope().addActionResult( "public:account.create", account.hasErrors() );
        return account;
    }
    
    public any function updatePrimaryEmailAddress(required struct data) {
        var account = getService("AccountService").processAccount(getHibachiScope().getAccount(), arguments.data, 'updatePrimaryEmailAddress');
        if (account.hasErrors()) {
            addErrors(arguments.data, getHibachiScope().getAccount().getProcessObject('updatePrimaryEmailAddress').getErrors());
        }
        getHibachiScope().addActionResult("public:account.updatePrimaryAccountEmailAddress",account.hasErrors());
    }
    
    public any function updatePassword(requried struct data) {
        var account = getService("AccountService").processAccount(getHibachiScope().getAccount(), arguments.data, 'updatePassword');
        if (account.hasErrors()) {
            addErrors(arguments.data, getHibachiScope().getAccount().getProcessObject('updatePassword').getErrors());
        }
        getHibachiScope().addActionResult("public:account.updatePassword",account.hasErrors());
    }
    
    /**
     * @http-context updateDeviceID
     * @description  Updates the device ID for a user account 
     * @http-return <b>(201)</b> Created Successfully or <b>(400)</b> Bad or Missing Input Data
     */
    public void function updateDeviceID( required struct data ){
        param name="arguments.data.deviceID" default="";
        param name="arguments.data.request_token" default="";

        var sessionEntity = getService("HibachiSessionService").getSessionBySessionCookie('sessionCookieNPSID', arguments.data.request_token, true );
        sessionEntity.setDeviceID(arguments.data.deviceID);
        
        //If this is a request from the api, setup the response header and populate it with data.
        //any onSuccessCode, any onErrorCode, any genericObject, any responseData, any extraData, required struct data
        //handlePublicAPICall(201, 400, sessionEntity, "Device ID Added", "#arguments.data.deviceID#",  arguments.data);  
    }
    
    
    /**
      * @method forgotPassword
      * @http-context ForgotPassword
      * @http-verb POST
      * @description  Sends an email to a user to reset a password.  
      * @htt-return <b>(200)</b> Successfully Sent or <b>(400)</b> Bad or Missing Input Data
      * @param emailAddress {string}
      * @ProcessMethod Account_ForgotPassword
      **/
    public any function forgotPassword( required struct data ) {
        var account = getService("AccountService").processAccount( getHibachiScope().getAccount(), arguments.data, 'forgotPassword');
        //let's hard code the action to always be successful. Indicating failure exposes if the account exists and is a security issue
        getHibachiScope().addActionResult( "public:account.forgotPassword", false );
        return account;
    }
    
    /**
      * @method resetPassword
      * @http-context resetPassword
      * @http-verb POST
      * @description  Sends an email to a user to reset a password.  
      * @http-return <b>(200)</b> Successfully Sent or <b>(400)</b> Bad or Missing Input Data
      * @param accountID {string}
      * @param emailAddress {string}
      * @ProcessMethod Account_ResetPassword
      **/
    public any function resetPassword( required struct data ) {
        param name="data.accountID" default="";
        var account = getAccountService().getAccount( data.accountID );
        if(!isNull(account)) {
            var account = getService("AccountService").processAccount(account, data, "resetPassword");
            getHibachiScope().addActionResult( "public:account.resetPassword", account.hasErrors() );
            // As long as there were no errors resetting the password, then we can set the email address in the form scope so that a chained login action will work
            if(!account.hasErrors() && !structKeyExists(form, "emailAddress") && !structKeyExists(url, "emailAddress")) {
                form.emailAddress = account.getEmailAddress();
            }
        } else {
            getHibachiScope().addActionResult( "public:account.resetPassword", true );
        }
        
        if ( account.getProcessObject( "resetPassword" ).hasErrors() ) {
            this.addErrors( data, account.getProcessObject( "resetPassword" ).getErrors() );
        }
        
        // Populate the current account with this processObject so that any errors are there.
        getHibachiScope().account().setProcessObject( account.getProcessObject( "resetPassword" ) );
        return account.getProcessObject( "resetPassword" );
    }
    
    /**
      * @method changePassword
      * @http-context changePassword
      * @http-verb POST
      * @description  Change a users password.  
      * @http-return <b>(200)</b> Successfully Sent or <b>(400)</b> Bad or Missing Input Data
      * @param emailAddress {string}
      * @ProcessMethod Account_ChangePassword
      **/
    public any function changePassword( required struct data ) {
        
        var account = getService("AccountService").processAccount( getHibachiScope().getAccount(), arguments.data, 'changePassword');
        getHibachiScope().addActionResult( "public:account.changePassword", account.hasErrors() );
        addErrors(arguments.data, account.getProcessObject('changePassword').getErrors());
        return account;
    }
    
    /**
      * @method updateAccount
      * @http-context updateAccount
      * @http-verb POST
      * @description  Update a users account data.  
      * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
      * @param aFieldToUpdate {json key}
      * @param authToken {json key}
      * @ProcessMethod Account_Save
      **/
    public any function updateAccount( required struct data ) {
        param name="arguments.data.context" default="save";
     
        var account = getAccountService().saveAccount( getHibachiScope().getAccount(), arguments.data, arguments.data.context);
        getHibachiScope().addActionResult( "public:account.update", account.hasErrors() );
        if(account.hasErrors()){
            var errorStruct = account.getErrors();
            for(var key in errorStruct){
                var messagesArray = errorStruct[key];
                for(var message in messagesArray){
                    getHibachiScope().showMessage(message,"error");
                }
            }
            
            addErrors(arguments.data, account.getErrors());
        }

        return account;
    }
    
    /**
      * @method deleteAccountEmailAddress
      * @http-context deleteAccountEmailAddress
      * @http-verb POST
      * @description delete a users account email address
      * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
      * @param emailAddress {string}
      * @ProcessMethod AccountEmailAddress_Delete
      **/
    public any function deleteAccountEmailAddress() {
        param name="data.accountEmailAddressID" default="";
        
        var accountEmailAddress = getAccountService().getAccountEmailAddress( data.accountEmailAddressID );
        
        if(!isNull(accountEmailAddress) && accountEmailAddress.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID() ) {
            var deleteOk = getAccountService().deleteAccountEmailAddress( accountEmailAddress );
            getHibachiScope().addActionResult( "public:account.deleteAccountEmailAddress", !deleteOK );
        } else {
            getHibachiScope().addActionResult( "public:account.deleteAccountEmailAddress", true );  
        }
        return accountEmailAddress;
    }
    
    /** 
      * @method sendAccountEmailAddressVerificationEmail
      * @http-context send AccountEmailAddressVerificationEmail
      * @description Account Email Address - Send Verification Email 
      * @param accountEmailAddressID The ID of the email address
      * @http-return <b>(200)</b> Successfully Sent or <b>(400)</b> Bad or Missing Input Data
      * @ProcessMethod AccountEmailAddress_SendVerificationEmail
      */
    public void function sendAccountEmailAddressVerificationEmail() {
        param name="data.accountEmailAddressID" default="";
        
        var accountEmailAddress = getAccountService().getAccountEmailAddress( data.accountEmailAddressID );
        
        if(!isNull(accountEmailAddress) && !isNull(accountEmailAddress.getVerifiedFlag()) && !accountEmailAddress.getVerifiedFlag()) {
            accountEmailAddress = getAccountService().processAccountEmailAddress( accountEmailAddress, data, 'sendVerificationEmail' );
            getHibachiScope().addActionResult( "public:account.sendAccountEmailAddressVerificationEmail", accountEmailAddress.hasErrors() );
        } else {
            getHibachiScope().addActionResult( "public:account.sendAccountEmailAddressVerificationEmail", true );
        }
        
        //return accountEmailAddress;
    }
    
    /** 
     * @method verifyAccountEmailAddress
     * @http-context verifyAccountEmailAddress
     * @http-resoudatae /api/scope/verifyAccountEmailAddress
     * @description Account Email Address - Verify 
     * @http-return <b>(200)</b> Successfully Sent or <b>(400)</b> Bad or Missing Input Data
     * @ProcessMethod AccountEmailAddress_Verify
     */
    public void function verifyAccountEmailAddress() {
        param name="data.accountEmailAddressID" default="";
        
        var accountEmailAddress = getAccountService().getAccountEmailAddress( data.accountEmailAddressID );
        
        if(!isNull(accountEmailAddress)) {
            accountEmailAddress = getAccountService().processAccountEmailAddress( accountEmailAddress, data, 'verify' );
            getHibachiScope().addActionResult( "public:account.verifyAccountEmailAddress", accountEmailAddress.hasErrors() );
        } else {
            getHibachiScope().addActionResult( "public:account.verifyAccountEmailAddress", true );
        }
        //handlePublicAPICall(200, 400, accountEmailAddress, "Email Address Verified", "",  arguments.data);
    }
    
    /** 
     * @http-context deleteAccountPhoneNumber
     * @http-verb Delete
     * @description Deletes an Account Phone Number by an accountID 
     * @http-return <b>(200)</b> Successfully Deleted or <b>(400)</b> Bad or Missing Input Data
     * @ProcessMethod AccountPhoneNumber_Delete
     */
    public void function deleteAccountPhoneNumber() {
        param name="data.accountPhoneNumberID" default="";
        
        var accountPhoneNumber = getAccountService().getAccountPhoneNumber( data.accountPhoneNumberID );
        
        if(!isNull(accountPhoneNumber) && accountPhoneNumber.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID() ) {
            var deleteOk = getAccountService().deleteAccountPhoneNumber( accountPhoneNumber );
            getHibachiScope().addActionResult( "public:account.deleteAccountPhoneNumber", !deleteOK );
        } else {
            getHibachiScope().addActionResult( "public:account.deleteAccountPhoneNumber", true );   
        }
    }
    
    /** 
     * @http-context deleteAccountAddress
     * @description Account Address - Delete 
     * @http-return <b>(200)</b> Successfully Deleted or <b>(400)</b> Bad or Missing Input Data
     * @ProcessMethod AccountAddress_Delete
     */
    public void function deleteAccountAddress() {
        param name="data.accountAddressID" default="";
        
        var accountAddress = getAccountService().getAccountAddress( data.accountAddressID );
        
        if(!isNull(accountAddress) &&
            !IsNull(accountAddress.getAccount()) &&
            getHibachiScope().getLoggedInFlag()  &&
            accountAddress.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID() 
        ) {
            
            var deleteOk = getAccountService().deleteAccountAddress( accountAddress );
            getHibachiScope().addActionResult( "public:account.deleteAccountAddress", !deleteOK );
         
            if(!deleteOk) {
                if(accountAddress.hasErrors()){
                    this.addErrors( arguments.data, accountAddress.getErrors() );
                } else {
                    this.addErrors(  arguments.data, [ 
                        { 'AccountAddress': getHibachiScope().rbKey('validate.define.somethingWentWrong') } 
                    ]);
                }
            }else{
                getDao('AccountAddressDAO').deleteDependentRelationsByAccountAddressID(data.accountAddressID);
            }
            
        } else {
            this.addErrors(arguments.data, [ 
                { 'AccountAddress': getHibachiScope().rbKey('validate.delete.AccountAddress.Invalid') }
            ]);
            getHibachiScope().addActionResult( "public:account.deleteAccountAddress", true );   
        }
    }
    
   public void function verifyAddress(required struct data){
        param name="data.accountAddressID" default="";

        arguments.data['ajaxResponse']['verifyAddress'] = getService("AddressService").verifyAccountAddressByID(arguments.data.accountAddressID);
        getHibachiScope().addActionResult("verifyAddress",false);
    }
    
    public void function addEditAccountAddress(required any data){


        if(structKeyExists(arguments.data,'accountAddressID') && len(arguments.data['accountAddressID'])){
            param name="data.countrycode" default="US";
         	var accountAddress = getService("AccountService").getAccountAddress(data.accountAddressID);
         	if (structKeyExists(data, "accountAddressName")){
         		accountAddress.setAccountAddressName(data.accountAddressName);
         	}
         	var address = accountAddress.getAddress();
         	address = getService("AddressService").saveAddress(address, data, "full");
          	
          	if (!address.hasErrors()){
          		accountAddress.setAddress(address);
          		accountAddress.setAccount(getHibachiScope().getAccount());	
          		var savedAccountAddress = getService("AccountService").saveAccountAddress(accountAddress);
                getHibachiScope().addActionResult("public:account.addNewAccountAddress", savedAccountAddress.hasErrors());
       	     	if (!savedAccountAddress.hasErrors()){
       	     		getDao('hibachiDao').flushOrmSession();
                    arguments.data.accountAddressID = savedAccountAddress.getAccountAddressID();
                    arguments.data['ajaxResponse']['newAccountAddressID'] = arguments.data.accountAddressID;
                    arguments.data['ajaxResponse']['newAccountAddress'] = savedAccountAddress.getStructRepresentation();

                    var addressVerificationStruct = getService('AddressService').verifyAddressByID(savedAccountAddress.getAddress().getAddressID());
                    arguments.data.ajaxResponse['addressVerification'] = addressVerificationStruct;
       	     	}
          	}else{
              this.addErrors(arguments.data, address.getErrors());
              getHibachiScope().addActionResult("public:account.addNewAccountAddress", address.hasErrors());
            }
        }else{
            addNewAccountAddress(argumentCollection=arguments);
        }
    }
    
     /**
      * Adds a new account address.
      */
     public void function addNewAccountAddress(required data){
     	param name="data.countrycode" default="US";
     	
     	var accountAddress = getService("AccountService").newAccountAddress();
     	if (structKeyExists(data, "accountAddressName")){
     		accountAddress.setAccountAddressName(data.accountAddressName);
     	}
     	var newAddress = getService("AddressService").newAddress();
     	newAddress = getService("AddressService").saveAddress(newAddress, data, "full");
      	
      	if (!newAddress.hasErrors()){
      		accountAddress.setAddress(newAddress);
      		if( !getHibachiScope().getAccount().getNewFlag() ){
      		    accountAddress.setAccount(getHibachiScope().getAccount());	
      		}
      		var savedAccountAddress = getService("AccountService").saveAccountAddress(accountAddress);
            getHibachiScope().addActionResult("public:account.addNewAccountAddress", savedAccountAddress.hasErrors());
   	     	if (!savedAccountAddress.hasErrors()){
   	     		getDao('hibachiDao').flushOrmSession();
                arguments.data.accountAddressID = savedAccountAddress.getAccountAddressID();
                arguments.data['ajaxResponse']['newAccountAddressID'] = arguments.data.accountAddressID;
                arguments.data['ajaxResponse']['newAccountAddress'] = savedAccountAddress.getStructRepresentation();

                var addressVerificationStruct = getService('AddressService').verifyAddressByID(savedAccountAddress.getAddress().getAddressID());
                arguments.data.ajaxResponse['addressVerification'] = addressVerificationStruct;
   	     	}
      	}else{
          this.addErrors(data, newAddress.getErrors());
          getHibachiScope().addActionResult("public:account.addNewAccountAddress", newAddress.hasErrors());
        }
     }
     
     /**
      * Updates an address.
      */
    public void function updateAddress(required data){
     	param name="data.countrycode" default="US";
     	param name="data.addressID" default="";
     	param name="data.phoneNumber" default="";
     	
     	var newAddress = getService("AddressService").getAddress(data.addressID, true);
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
     * @http-context deleteAccountAddress
     * @description Account Payment Method - Delete 
     * @http-return <b>(200)</b> Successfully Deleted or <b>(400)</b> Bad or Missing Input Data
     * @ProcessMethod AccountPaymentMethod_Delete
     */
    public void function deleteAccountPaymentMethod(required struct data) {
        param name="data.accountPaymentMethodID" default="";
        
        var accountPaymentMethod = getAccountService().getAccountPaymentMethod( data.accountPaymentMethodID );
        
        if(!isNull(accountPaymentMethod) && accountPaymentMethod.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID() ) {
            var deleteOk = getAccountService().deleteAccountPaymentMethod( accountPaymentMethod );
            getHibachiScope().addActionResult( "public:account.deleteAccountPaymentMethod", !deleteOK );
            if(!deleteOk) {
                ArrayAppend(arguments.data.messages, accountPaymentMethod.getErrors(), true);
            }
        } else {
            getHibachiScope().addActionResult( "public:account.deleteAccountPaymentMethod", true ); 
        }
    }
    
    public any function addOrderShippingAddress(required data){
        param name="data.saveAsAccountAddressFlag" default="0";
        param name="data.saveShippingAsBilling" default="1";
        /** add a shipping address */
        var shippingAddress = {};
        if (!isNull(data)){
            //if we have that data and don't have any suggestions to make, than try to populate the address
            shippingAddress = getService('AddressService').newAddress();   
            //get a new address populated with the data.

            var savedAddress = getService('AddressService').saveAddress(shippingAddress, data, "full");
            if (isObject(savedAddress) && !savedAddress.hasErrors()){
                //save the address at the order level.
                if(structKeyExists(arguments.data, 'orderID')){
                    var order = getOrderService().getOrder(arguments.data.orderID);
                    if(isNull(order) || order.getaccount().getAccountID() != getHibachiScope().getAccount().getAccountID() ){
                        this.addErrors(data, 'Could not find Order');
                        getHibachiScope().addActionResult( "public:cart.addShippingAddress", true);
                        return;
                    }
                }
                var order = getHibachiScope().cart();
                order.setShippingAddress(savedAddress);
                for(var fulfillment in order.getOrderFulfillments()){
                  if(fulfillment.getOrderFulfillmentID() == data.fulfillmentID){
                    var orderFulfillment = fulfillment;
                  }
                }
                if(!isNull(orderFulfillment) && !orderFulfillment.hasErrors()){
                  orderFulfillment.setShippingAddress(savedAddress);
                }
                if (structKeyExists(data, "saveShippingAsBilling") && data.saveShippingAsBilling){
                    order.setBillingAddress(savedAddress);
                }
                
                if (structKeyExists(data, "saveAsAccountAddressFlag") && data.saveAsAccountAddressFlag){
                   
                 	var accountAddress = getService("AccountService").newAccountAddress();
                 	accountAddress.setAddress(shippingAddress);
                 	accountAddress.setAccount(getHibachiScope().getAccount());
                 	var savedAccountAddress = getService("AccountService").saveAccountAddress(accountAddress);
                 	if (!savedAddress.hasErrors()){
                 		getDao('hibachiDao').flushOrmSession();
                 	}
                  
                }
                
                getService("OrderService").saveOrder(order);
                if(structKeyExists(arguments.data,'ajaxResponse')){
                    var addressVerificationStruct = getService('AddressService').verifyAddressByID(savedAddress.getAddressID());
                    arguments.data.ajaxResponse['addressVerification'] = addressVerificationStruct;
                }
                getHibachiScope().addActionResult( "public:cart.addShippingAddress", order.hasErrors());
            }else{
                    
                    this.addErrors(data, savedAddress.getErrors()); //add the basic errors
                    getHibachiScope().addActionResult( "public:cart.addShippingAddress", savedAddress.hasErrors());
            }
        }
    }
    
    /** Adds a shipping address to an order using an account address */
    public void function addShippingAddressUsingAccountAddress(required data){
        if(structKeyExists(data,'accountAddressID')){
          var accountAddressId = data.accountAddressID;
        }else{
            getHibachiScope().addActionResult( "public:cart.addShippingAddressUsingAccountAddress", true);
          return;
        }

        var accountAddress = getService('AddressService').getAccountAddress(accountAddressID);
        if (!isNull(accountAddress) && !accountAddress.hasErrors()){
            //save the address at the order level.
            if(structKeyExists(arguments.data, 'orderID')){
                var order = getOrderService().getOrder(arguments.data.orderID);
                if(isNull(order) || order.getaccount().getAccountID() != getHibachiScope().getAccount().getAccountID() ){
                    this.addErrors(data, 'Could not find Order');
                    getHibachiScope().addActionResult( "public:cart.addShippingAddressUsingAccountAddress", true);
                    return;
                }
            }else{
                var order = getHibachiScope().getCart();
            }
            if(structKeyExists(data,'fulfillmentID')){
                
                var orderFulfillment = getOrderService().getOrderFulfillment(arguments.data.fulfillmentID);
                if(!isNull( orderFulfillment ) && !isNull( orderFulfillment.getOrder() ) && orderFulfillment.getOrder().getOrderID() == order.getOrderID()){
                    orderFulfillment.setShippingAddress(accountAddress.getAddress());
                    orderFulfillment.setAccountAddress(accountAddress);
                }
                
            }else{
                for(var fulfillment in order.getOrderFulfillments()){
                    fulfillment.setShippingAddress(accountAddress.getAddress());
                    fulfillment.setAccountAddress(accountAddress);
                    getService("OrderService").saveOrderFulfillment(orderFulfillment = fulfillment, updateOrderAmounts = false);
                }
            }
            getService("OrderService").saveOrder(order = order, updateOrderAmounts = false);
            getHibachiScope().addActionResult( "public:cart.addShippingAddressUsingAccountAddress", order.hasErrors());
        }else{
            if(!isNull(accountAddress)){
              this.addErrors(arguments.data, accountAddress.getErrors()); //add the basic errors
            }
            getHibachiScope().addActionResult( "public:cart.addShippingAddressUsingAccountAddress", true);
        }
    }

    /** Sets an email address for email fulfillment */
    public void function addEmailFulfillmentAddress(required data){
      var emailAddress = data.emailAddress;
      var order = getHibachiScope().getCart();
      var orderFulfillments = order.getOrderFulfillments();

      for(var fulfillment in orderFulfillments){
        if(fulfillment.getOrderFulfillmentID() == data.fulfillmentID){
          var orderFulfillment = fulfillment;
          break;
        }
      }

      if(!isNull(orderFulfillment)){
        orderFulfillment.setEmailAddress(emailAddress);
        orderFulfillment.validate("save");
        if(!orderFulfillment.hasErrors()){

          getService("OrderService").saveOrder(order);
          getDao('hibachiDao').flushOrmSession();
          getHibachiScope().addActionResult('public:cart.addEmailFulfillmentAddress', order.hasErrors());

        }else{
            this.addErrors(arguments.data, orderFulfillment.getErrors());
            entityReload(orderFulfillment);
            getHibachiScope().addActionResult('public:cart.addEmailFulfillmentAddress', orderFulfillment.hasErrors());
        }
      }else{
          getHibachiScope().addActionResult('public:cart.addEmailFulfillmentAddress', true);
      }
    }

    /** Set store pickup location */
    public void function addPickupFulfillmentLocation(required struct data){
      param name="arguments.data.value" default="";
      
      if(!len(arguments.data.value)){
          getHibachiScope().addActionResult('public:cart.addPickupFulfillmentLocation', true);
          return;
      }
      var location = getService('LocationService').getLocation(arguments.data.value);
      
      if(isNull(location)){
          getHibachiScope().addActionResult('public:cart.addPickupFulfillmentLocation', true);
          return;
      }
      var order = getHibachiScope().getCart();
      var orderFulfillments = order.getOrderFulfillments();

      for(var fulfillment in orderFulfillments){
        if(!isNull(arguments.data.fulfillmentID)){
          if(fulfillment.getOrderFulfillmentID() == arguments.data.fulfillmentID){
            var orderFulfillment = fulfillment;
            break;
          }
        }else if(fulfillment.getFulfillmentMethod().getFulfillmentMethodType() == 'pickup'){
          var orderFulfillment = fulfillment;
          break;
        }
      }

      if(!isNull(orderFulfillment) && !orderFulfillment.hasErrors()){
        orderFulfillment.setPickupLocation(location);
        orderFulfillment = getService("OrderService").saveOrderFulfillment(orderFulfillment);
        getService("OrderService").saveOrder(order);
        getDAO('HibachiDAO').flushOrmSession();
        getHibachiScope().addActionResult('public:cart.addPickupFulfillmentLocation', order.hasErrors());
      }else{
        if(!isNull(orderFulfillment)){
          this.addErrors(arguments.data, orderFulfillment.getErrors());
        }
        getHibachiScope().addActionResult('public:cart.addPickupFulfillmentLocation', true);
      }
    }
    
   /** Sets the shipping method to an order shippingMethodID */
    public void function addShippingMethodUsingShippingMethodID(required struct data){
        param name="arguments.data.shippingMethodID" default="";
        
        if(!len(arguments.data.shippingMethodID)){
            getHibachiScope().addActionResult( "public:cart.addShippingMethodUsingShippingMethodID", true);  
            return;
        }
        
        if(structKeyExists(arguments.data, 'orderFulfillmentWithShippingMethodOptions')){
            arguments.data.orderFulfillmentWithShippingMethodOptions += 1;//from js to cf
        }else{
            arguments.data.orderFulfillmentWithShippingMethodOptions = 1;
        }
        
        var shippingMethod = getService('ShippingService').getShippingMethod(arguments.data.shippingMethodID);
        
        if(isNull(shippingMethod)){
            getHibachiScope().addActionResult( "public:cart.addShippingMethodUsingShippingMethodID", true);
            return;
        }
        
        if (shippingMethod.hasErrors()){
            getHibachiScope().addActionResult( "public:cart.addShippingMethodUsingShippingMethodID", shippingMethod.hasErrors());
            return;
        }
        
        var order = getHibachiScope().cart();
        var orderFulfillments = order.getOrderFulfillments();
        
        if(structKeyExists(arguments.data, 'fulfillmentID')){
            //TODO: Refactor this loop
            for(var fulfillment in orderFulfillments){
                if(fulfillment.getOrderFulfillmentID() == data.fulfillmentID){
                    var orderFulfillment = fulfillment;
                    break;
                }
            }
            orderFulfillment.setShippingMethod(shippingMethod);
            getService("OrderService").saveOrder(order = order, updateOrderAmounts = false); 
            getHibachiScope().flushOrmSession();   
            getHibachiScope().addActionResult( "public:cart.addShippingMethodUsingShippingMethodID", shippingMethod.hasErrors());          
        }else{
             getHibachiScope().addActionResult( "public:cart.addShippingMethodUsingShippingMethodID", true);
            return;
        }
        
        orderFulfillment.setShippingMethod(shippingMethod);
        orderFulfillment = getService("OrderService").saveOrderFulfillment(orderFulfillment = orderFulfillment, updateOrderAmounts = false);
        if(orderFulfillment.hasErrors()){
            getHibachiScope().addActionResult( "public:cart.addShippingMethodUsingShippingMethodID", orderFulfillment.hasErrors());
            return;
        }
        order = getService("OrderService").saveOrder(order = order, updateOrderAmounts = false); 
        if(!order.hasErrors()){
			getDao('hibachiDao').flushOrmSession();
        }
		getHibachiScope().addActionResult( "public:cart.addShippingMethodUsingShippingMethodID", order.hasErrors());          
    }
    
    public any function addBillingAddressUsingAccountAddress(required data){
        var accountAddress = getService('addressService').getAccountAddress(data.accountAddressID);
        
        if(!isNull(accountAddress)){
            getHibachiScope().getCart().setBillingAccountAddress(accountAddress);
            var addressData = {
                address=accountAddress.getAddress()  
            };
        }
        
        return addBillingAddress(addressData);
    }
    
    /** adds a billing address to an order. 
    @ProcessMethod Address_Save
    */
    public any function addBillingAddress(required data){
        param name="data.saveAsAccountAddressFlag" default="0"; 
        
        //if we have that data and don't have any suggestions to make, than try to populate the address
        billingAddress = getService('AddressService').newAddress();    
        
        //if we have an address then copy it and validate it
        if(structKeyExists(data,'address')){
            var savedAddress = getService('AddressService').copyAddress(data.address);
            savedAddress = getService('AddressService').saveAddress(savedAddress, {}, "full");    
        
        }else if(!isNull(data.addressID)){
            var savedAddress = getService('AddressService').getAddress(data.addressID);
        }//get a new address populated with the data.    
        else{
            var savedAddress = getService('AddressService').saveAddress(billingAddress, arguments.data, "full");    
        }
        
        if (!isNull(savedAddress) && !savedAddress.hasErrors()){
            //save the address at the order level.
            var order = getHibachiScope().cart();
            order.setBillingAddress(savedAddress);
            
            var orderPayments = order.getOrderPayments();
            if(arrayLen(orderPayments)){
               orderPayments[1].setBillingAddress(savedAddress); 
            }
            
            getService("OrderService").saveOrder(order);
            getHibachiScope().addActionResult( "public:cart.addBillingAddress", false);
        }
        
        if(isNull(savedAddress)){
            getHibachiScope().addActionResult( "public:cart.addBillingAddress", true);
            return;
        }
        
        if(savedAddress.hasErrors()){
            this.addErrors(arguments.data, savedAddress.getErrors()); //add the basic errors
    	    getHibachiScope().addActionResult( "public:cart.addBillingAddress", true);
        }
        return savedAddress;
    }
    
    /** 
     * @http-context addAccountPaymentMethod
     * @description Account Payment Method - Add 
     * @http-return <b>(200)</b> Successfully Deleted or <b>(400)</b> Bad or Missing Input Data
     * @ProcessMethod AccountPaymentMethod_Save
     */
    public void function addAccountPaymentMethod(required any data) {
        
        if (!isNull(data) && !structKeyExists(data, 'accountPaymentMethod') && structKeyExists(data, "selectedPaymentMethod")){
        	data['accountPaymentMethod'] = {};
        	data['accountPaymentMethod']['accountPaymentMethodID']  = data.selectedPaymentMethod;
        }
        if (!isNull(data) && !structKeyExists(data, 'paymentMethod')){
         	data['paymentMethod'] = {};
         	data['paymentMethod'].paymentMethodID = '444df303dedc6dab69dd7ebcc9b8036a';
        }
        if (!isNull(data) && structKeyExists(data, 'newOrderPayment')){
         	data['accountPaymentMethod'] = data;
         	data['accountPaymentMethod']['billingAddress'] = data.newOrderPayment;
        }
        
        if(getHibachiScope().getLoggedInFlag()) {
            
            // Fodatae the payment method to be added to the current account
           if (structKeyExists(data, "selectedPaymentMethod")){
                var accountPaymentMethod = getHibachiScope().getService("AccountService").getAccountPaymentMethod( data.selectedPaymentMethod );
            }else{
                var accountPaymentMethod = getHibachiScope().getService("AccountService").newAccountPaymentMethod(  );	
                accountPaymentMethod.setAccount( getHibachiScope().getAccount() );
            }
            
            accountPaymentMethod = getAccountService().saveAccountPaymentMethod( accountPaymentMethod, arguments.data );
            
            getHibachiScope().addActionResult( "public:account.addAccountPaymentMethod", accountPaymentMethod.hasErrors() );
            data['ajaxResponse']['errors'] = accountPaymentMethod.getErrors();
            // If there were no errors then we can clear out the
            
        } else {
            
            getHibachiScope().addActionResult( "public:account.addAccountPaymentMethod", true );
                
        }
        
    }
    
    /** 
     * @http-context guestAccount
     * @description Logs in a user with a guest account 
     * @http-return <b>(200)</b> Successfully Deleted or <b>(400)</b> Bad or Missing Input Data
     * @ProcessMethod Account_Create
     */
    public void function guestAccount(required any data) {
        param name="arguments.data.createAuthenticationFlag" default="0";
        
        var account = getAccountService().processAccount( getHibachiScope().getAccount(), arguments.data, 'create');
        
        if( !account.hasErrors() ) {
            if( !isNull(getHibachiScope().getCart().getAccount())) {
                var newCart = getService("OrderService").duplicateOrderWithNewAccount( getHibachiScope().getCart(), account );
                getHibachiScope().getSession().setOrder( newCart );
            } else {
                getHibachiScope().getCart().setAccount( account );    
            }
            getHibachiScope().addActionResult( "public:cart.guestCheckout", false );
        } else {
            getHibachiScope().addActionResult( "public:cart.guestCheckout", true ); 
        }
        
    }
    
    /** 
     * @http-context guestAccountCreatePassword
     * @description Save Guest Account
     * @http-return <b>(200)</b> Successfully Created Password or <b>(400)</b> Bad or Missing Input Data
     * @ProcessMethod Account_CreatePassword
     */
    public void function guestAccountCreatePassword( required struct data ) {
        param name="arguments.data.orderID" default="";
        param name="arguments.data.accountID" default="";

        var order = getService("OrderService").getOrder( arguments.data.orderID );
        
        // verify that the orderID passed in was in fact the lastPlacedOrderID from the session, that the order & account match up, and that the account is in fact a guest account right now
        if(!isNull(order) && arguments.data.orderID == getHibachiScope().getSession().getLastPlacedOrderID() && order.getAccount().getAccountID() == arguments.data.accountID && order.getAccount().getGuestAccountFlag()) {
            
            var account = getAccountService().processAccount( order.getAccount(), arguments.data, "createPassword" );
            getHibachiScope().addActionResult( "public:cart.guestAccountCreatePassword", account.hasErrors() );
            return account;
        } else {
            
            getHibachiScope().addActionResult( "public:cart.guestAccountCreatePassword", true );
        }
        
    }
    /** 
     * @http-context updateSubscriptionUsage
     * @description Subscription Usage - Update
     * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     @ProcessMethod SubscriptionUsage_Save
     */
    public void function updateSubscriptionUsage() {
        param name="data.subscriptionUsageID" default="";
        
        var subscriptionUsage = getSubscriptionService().getSubscriptionUsage( data.subscriptionUsageID );
        
        if(!isNull(subscriptionUsage) && subscriptionUsage.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID() ) {
            var subscriptionUsage = getSubscriptionService().saveSubscriptionUsage( subscriptionUsage, arguments.data );
            if(subscriptionUsage.hasErrors()){
                addErrors(arguments.data,subscriptionUsage.getErrors());
            }
            getHibachiScope().addActionResult( "public:account.updateSubscriptionUsage", subscriptionUsage.hasErrors() );
        } else {
            getHibachiScope().addActionResult( "public:account.updateSubscriptionUsage", true );
        }
        
    }
    
    /** 
     * @http-context renewSubscriptionUsage
     * @description Subscription Usage - Renew
     * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     @ProcessMethod SubscriptionUsage_Renew
     */
    public void function renewSubscriptionUsage() {
        param name="data.subscriptionUsageID" default="";
        
        var subscriptionUsage = getSubscriptionService().getSubscriptionUsage( data.subscriptionUsageID );
        
        if(!isNull(subscriptionUsage) && subscriptionUsage.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID() ) {
            var subscriptionUsage = getSubscriptionService().processSubscriptionUsage( subscriptionUsage, arguments.data, 'renew' );
            if(subscriptionUsage.hasErrors()){
                addErrors(arguments.data,subscriptionUsage.getErrors());
            }
            getHibachiScope().addActionResult( "public:account.updateSubscriptionUsage", subscriptionUsage.hasErrors() );
        } else {
            getHibachiScope().addActionResult( "public:account.updateSubscriptionUsage", true );
        }
    }
    
    /** 
     * @http-context cancelSubscriptionUsage
     * @description Subscription Usage - Cancel
     * @http-return <b>(200)</b> Successfully Cancelled or <b>(400)</b> Bad or Missing Input Data
     @ProcessMethod SubscriptionUsage_Cancel
     */
    public void function cancelSubscriptionUsage(required struct data) {
        param name="arguments.data.subscriptionUsageID" default="";
        
        var subscriptionUsage = getSubscriptionService().getSubscriptionUsage( arguments.data.subscriptionUsageID );
        
        if(!structKeyExists(arguments.data,'effectiveDateTime')){
            arguments.data.effectiveDateTime = subscriptionUsage.getExpirationDate();
        }
        
        if(!isNull(subscriptionUsage) && subscriptionUsage.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID() ) {
            var subscriptionUsage = getSubscriptionService().processSubscriptionUsage( subscriptionUsage, arguments.data, 'cancel' );
            if(subscriptionUsage.hasErrors()){
                addErrors(arguments.data,subscriptionUsage.getErrors());
            }
            getHibachiScope().addActionResult( "public:account.cancelSubscriptionUsage", subscriptionUsage.hasErrors() );
        } else {
            getHibachiScope().addActionResult( "public:account.cancelSubscriptionUsage", true );
        }
    }
    
    /** exposes the cart and account */
    public void function getCartData(any data) {
        if(!structKeyExists(arguments.data,'cartDataOptions') || !len(arguments.data['cartDataOptions'])){
            arguments.data['cartDataOptions']='full';
        }
        
        var updateOrderAmounts = structKeyExists( arguments.data, 'updateOrderAmounts' ) && arguments.data.updateOrderAmounts;
    
        arguments.data.ajaxResponse = {'cart':getHibachiScope().getCartData(cartDataOptions=arguments.data['cartDataOptions'], updateOrderAmounts = updateOrderAmounts)};
    }
    
    public void function getAccountData(any data) {
        arguments.data.ajaxResponse = {'account':getHibachiScope().getAccountData()};
    }
    
    /** 
     * @http-context duplicateOrder
     * @description Duplicate - Order
     * @http-return <b>(200)</b> Successfully Created Duplicate Order or <b>(400)</b> Bad or Missing Input Data
     @ProcessMethod Order_DuplicateOrder
     */
    public void function duplicateOrder() {
        param name="arguments.data.orderID" default="";
        param name="arguments.data.setAsCartFlag" default="0";
        
        var order = getService("OrderService").getOrder( arguments.data.orderID );
        if(!isNull(order) && order.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID()) {
            
            var data = {
                saveNewFlag=true, 
                copyPersonalDataFlag=true
            };
            
            var duplicateOrder = getService("OrderService").processOrder(order,data,"duplicateOrder" );
            
            if(isBoolean(arguments.data.setAsCartFlag) && arguments.data.setAsCartFlag) {
                getHibachiScope().getSession().setOrder( duplicateOrder );
            }
            
            //create new token with cart information
            if( getHibachiScope().getLoggedInFlag()  && !isNull(getHibachiScope().getAccount()) && trim( getHibachiScope().getAccount().getAccountID()) != "")  {
                arguments.data.ajaxResponse['token'] = getService('HibachiJWTService').createToken();
            }
            
            getHibachiScope().addActionResult( "public:account.duplicateOrder", false );
        } else {
            getHibachiScope().addActionResult( "public:account.duplicateOrder", true );
        }
    }
    
    /** 
     * @http-context updateOrder
     * @description  Update Order Data
     * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     @ProcessMethod Order_ForceItemQuantityUpdate
     */
    public void function updateOrder( required struct data ) {

        var cart = getService("OrderService").saveOrder( getHibachiScope().cart(), arguments.data );
        
        // Insure that all items in the cart are within their max constraint
        if(!cart.hasItemsQuantityWithinMaxOrderQuantity()) {
            cart = getService("OrderService").processOrder(cart, 'forceItemQuantityUpdate');
        }
        
        getHibachiScope().addActionResult( "public:cart.update", cart.hasErrors() );
    }
    
    /** 
     * @http-context clearOrder
     * @description  Clear the order data
     * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     @ProcessMethod Order_Clear
     */
    public void function clearOrder( required struct data ) {
        var cart = getService("OrderService").processOrder( getHibachiScope().cart(), arguments.data, 'clear');
        
        getHibachiScope().addActionResult( "public:cart.clear", cart.hasErrors() );
    }
    
    /** 
     * @http-context changeOrder
     * @description Change Order
     * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     */
    public void function changeOrder( required struct data ){
        param name="arguments.data.orderID" default="";
        
        var order = getService("OrderService").getOrder( arguments.data.orderID );
        if(!isNull(order) && order.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID()) {
            getHibachiScope().getSession().setOrder( order );
            getHibachiScope().addActionResult( "public:cart.change", false );
        } else {
            getHibachiScope().addActionResult( "public:cart.change", true );
        }
    }
    
    /** 
     * @http-context deleteOrder
     * @description Delete an Order
     * @http-return <b>(200)</b> Successfully Deleted or <b>(400)</b> Bad or Missing Input Data
     @ProcessMethod Order_Delete
     */
    public void function deleteOrder( required struct data ) {
        param name="arguments.data.orderID" default="";
        
        var order = getService("OrderService").getOrder( arguments.data.orderID );
        if(!isNull(order) && order.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID()) {
            var deleteOk = getService("OrderService").deleteOrder(order);
            getHibachiScope().addActionResult( "public:cart.delete", !deleteOK );
        } else {
            getHibachiScope().addActionResult( "public:cart.delete", true );
        }
    }
    
    /**
     * Will add multiple orderItems at once given a list of skuIDs or skuCodes.
     */
    public void function addOrderItems(required any data){
    	param name="data.skuIds" default="";
    	param name="data.skuCodes" default="";
    	param name="data.quantities" default="";
    	
    	//add skuids
		var index = 1;
		var hasSkuCodes = false;
		
		//get the quantities being added
		if (structKeyExists(data, "quantities") && len(data.quantities)){
			var quantities = listToArray(data.quantities);
		}
		
		//get the skus being added
		if (structKeyExists(data, "skuIds") && len(data.skuIds)){
			var skus = listToArray(data.skuIds);
		}
		
		//get the skuCodes if they exist.
		if (structKeyExists(data, "skuCodes") && len(data.skuCodes)){
			var skus = listToArray(data.skuCodes);
			hasSkuCodes = true;
		}
		
		//if we have both skus and quantities, add them.
		if (!isNull(skus) && !isNull(quantities) && arrayLen(skus) && arrayLen(quantities)){
			if (arrayLen(skus) == arrayLen(quantities)){
				//we have a quantity fo each sku.
				for (var sku in skus){
					//send that sku and that quantity.
					if (hasSkuCodes == true){
						data["skuCode"]=sku; 
					}else{
						data["skuID"]=sku; 	
					}
	    			
	    			data["quantity"]=quantities[index];
	    			addOrderItem(data=data);
	    			index++;
	    		}
			}
		
		//If they did not pass in quantities, but we have skus, assume 1 for each quantity.
		}else if(!isNull(skus)){
    		for (var sku in skus){
    			if (hasSkuCodes == true){
					data["skuCode"]=sku; 
				}else{
					data["skuID"]=sku; 	
				}
    			data["quantity"]=1;
    			addOrderItem(data=data);
    		}
		}
    }
    
    /** 
     * @http-context addOrderItem
     * @description Add Order Item to an Order
     * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     * @ProcessMethod Order_addOrderItem
     */
    public any function addOrderItem(required any data) {
        // Setup the frontend defaults
        param name="data.preProcessDisplayedFlag" default="true";
        param name="data.saveShippingAccountAddressFlag" default="false";
        
        var cart = getHibachiScope().cart();

        // Check to see if we can attach the current account to this order, required to apply price group details
        if( isNull(cart.getAccount()) && getHibachiScope().getLoggedInFlag() ) {
            cart.setAccount( getHibachiScope().getAccount() );
        }
        
        cart = getService("OrderService").processOrder( cart, arguments.data, 'addOrderItem');
        
        getHibachiScope().addActionResult( "public:cart.addOrderItem", cart.hasErrors() );
        
        if(!cart.hasErrors()) {
            // If the cart doesn't have errors then clear the process object
            cart.clearProcessObject("addOrderItem");
            
            // Also make sure that this cart gets set in the session as the order
            getHibachiScope().getSession().setOrder( cart );
            
            // Make sure that the session is persisted
            getHibachiSessionService().persistSession(true);
            
        }else{
            addErrors(data, cart.getProcessObject("addOrderItem").getErrors());
            addErrors(data, cart.getErrors());
        }
        
        return cart;
    }
    
    /* @http-context updateOrderNotes
     * @description Set shipping instructions for order
     * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     */
    public void function updateOrderNotes(required any data) {
        param name="arguments.data.orderNotes" default="";
        var cart = getHibachiScope().getCart();
        cart.setOrderNotes(arguments.data.orderNotes);
        getHibachiScope().addActionResult( "public:cart.updateOrderNotes", cart.hasErrors() );
    }
    
    /** 
     * @http-context updateOrderItemQuantity
     * @description Update Order Item on an Order
     * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     @ProcessMethod Order_Save
     */
    public void function updateOrderItemQuantity(required any data) {
        
        var cart = getHibachiScope().cart();

        // Check to see if we can attach the current account to this order, required to apply price group details
        if( isNull(cart.getAccount()) && getHibachiScope().getLoggedInFlag() ) {
            cart.setAccount( getHibachiScope().getAccount() );
        }
        
        if (structKeyExists(data, "orderItem") && structKeyExists(data.orderItem, "orderItemID") && structKeyExists(data.orderItem, "quantity")){
            for (var orderItem in cart.getOrderItems()){
                if (orderItem.getOrderItemID() == data.orderItem.orderItemID){
                    var oldQuantity = orderItem.getQuantity();
                    orderItem.setQuantity(data.orderItem.quantity);
                    getService("HibachiValidationService").validate(cart,'save');
                    if(cart.hasErrors()){
                        orderItem.setQuantity(oldQuantity);
                        orderItem.clearVariablesKey('extendedPrice');
                    }
                }
            }
		}else if (structKeyExists(data, "orderItem") && structKeyExists(data.orderItem, "sku") && structKeyExists(data.orderItem.sku, "skuID") && structKeyExists(data.orderItem, "qty") ){
            for (var orderItem in cart.getOrderItems()){
                if (orderItem.getSku().getSkuID() == data.orderItem.sku.skuID){
                    var oldQuantity = orderItem.getQuantity();
                    orderItem.setQuantity(data.orderItem.qty);
                    
                    getService("HibachiValidationService").validate(cart,'save');
                    if(cart.hasErrors()){
                        orderItem.setQuantity(oldQuantity);
                        orderItem.clearVariablesKey('extendedPrice');
                    }
                }
            }
        }
        
        
        if(!cart.hasErrors()) {
            getService("OrderService").saveOrder(cart);
            // Insure that all items in the cart are within their max constraint
     	    	if(!cart.hasItemsQuantityWithinMaxOrderQuantity()) {
    	 	        cart = getService("OrderService").processOrder(cart, 'forceItemQuantityUpdate');
    	 	        if(!cart.hasErrors()) {
                      getService("OrderService").saveOrder(cart);
                    }
    	 	    } 
    	 	    
            // Also make sure that this cart gets set in the session as the order
            getHibachiScope().getSession().setOrder( cart );
            
            // Make sure that the session is persisted
            getHibachiSessionService().persistSession();
        }
        
        getHibachiScope().addActionResult( "public:cart.updateOrderItem", cart.hasErrors() );
    }
    /** 
     * @http-context removeOrderItem
     * @description Remove Order Item from an Order
     * @http-return <b>(200)</b> Successfully Removed or <b>(400)</b> Bad or Missing Input Data
     @ProcessMethod Order_RemoveOrderItem
     */
    public void function removeOrderItem(required any data) {
        var cart = getService("OrderService").processOrder( getHibachiScope().cart(), arguments.data, 'removeOrderItem');
        if(!arraylen(cart.getOrderItems())){
            clearOrder(arguments.data);
        }
        getHibachiScope().addActionResult( "public:cart.removeOrderItem", cart.hasErrors() );
    }
    
    /** 
     * @http-context updateOrderFulfillment
     * @description Update Order Fulfillment 
      * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
      @ProcessMethod Order_UpdateOrderFulfillment
     */
    public void function updateOrderFulfillment(required any data) {
        param name="orderID" default="#getHibachiScope().getCart().getOrderID()#";
        var cart = getService("OrderService").processOrder( getHibachiScope().cart(), arguments.data, 'updateOrderFulfillment');
        
        getHibachiScope().addActionResult( "public:cart.updateOrderFulfillment", cart.hasErrors() );
    }


    /** 
     * @http-context updateOrderFulfillmentAddressZone
     * @description Update Order Fulfillment Address Zone
     * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     * @ProcessMethod Order_UpdateOrderFulfillmentAddressZone
     */
    public any function updateOrderFulfillmentAddressZone(required any data) {
        
        var orderFulfillments = getHibachiScope().cart().getOrderFulfillments();
        //Find a shipping fulfillment.    
        for (var of in orderFulfillments){
            if (of.getFulfillmentMethodType() == "shipping"){
                var orderFulfillment = of; break;
            }
        }  
        
        if (structKeyExists(data, "addressZoneCode")){
            var addressZone = getService("AddressService").getAddressZoneByAddressZoneCode(data.addressZoneCode);
        }     
        
        if (!isNull(orderFulfillment) && !isNull(addressZone)){
            orderFulfillment.setAddressZone(addressZone);
            orderFulfillment = getService("OrderService").saveOrderFulfillment(orderFulfillment);
            getService("ShippingService").updateOrderFulfillmentShippingMethodOptions(orderFulfillment);
            getHibachiScope().addActionResult( "public:cart.updateOrderFulfillmentAddressZone", false);
        } else {  
			getHibachiScope().addActionResult( "public:cart.updateOrderFulfillmentAddressZone", true);
        }
    }

    /** 
     * @http-context addPromotionCode
     * @description Add Promotion Code
     * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     @ProcessMethod Order_addPromotionCode
     */
    public void function addPromotionCode(required any data) {
        var cart = getService("OrderService").processOrder( getHibachiScope().cart(), arguments.data, 'addPromotionCode');
        
        getHibachiScope().addActionResult( "public:cart.addPromotionCode", cart.hasErrors() );
        
        if(!cart.hasErrors()) {
            cart.clearProcessObject("addPromotionCode");
        }else{
            var processObject = cart.getProcessObject("AddPromotionCode");
            if(processObject.hasErrors()){
                addErrors(data, cart.getProcessObject("AddPromotionCode").getErrors());
            }else{
                addErrors(data,cart.getErrors());
            }
        }
    }
    
    /** 
     * @http-context removePromotionCode
     * @description Remove Promotion Code
     @ProcessMethod Order_RemovePromotionCode
     */
    public void function removePromotionCode(required any data) {
        var cart = getService("OrderService").processOrder( getHibachiScope().cart(), arguments.data, 'removePromotionCode');
        
        getHibachiScope().addActionResult( "public:cart.removePromotionCode", cart.hasErrors() );
    }

    /** 
     * @http-context addGiftCardOrderPayment
     * @description Add Gift Card to Order
     @ProcessMethod Order_AddOrderPayment
     */
    public void function addGiftCardOrderPayment(required any data) {
        param name="data.newOrderPayment.paymentMethod.paymentMethodID" default="50d8cd61009931554764385482347f3a";
        param name="data.newOrderPayment.redeemGiftCardToAccount" default=true;
        param name="data.copyFromType" default="";
        param name="data.newOrderPayment.requireBillingAddress" default="0";
        var addOrderPayment = addOrderPayment(data, true);
        if(addOrderPayment.hasErrors()){
          addErrors(data, addOrderPayment.getProcessObject('addOrderPayment').getErrors());
        }
        getHibachiScope().addActionResult('public:cart.addGiftCardOrderPayment', addOrderPayment.hasErrors());
    }
    
    /** 
     * @http-context addOrderPayment
     * @description Add Order Payment
     @ProcessMethod Order_AddOrderPayment
     */
    public any function addOrderPayment(required any data, boolean giftCard = false) {
        param name = "data.newOrderPayment" default = "#structNew()#";
        param name = "data.newOrderPayment.orderPaymentID" default = "";
        param name = "data.newOrderPayment.requireBillingAddress" default = "1";
        param name = "data.newOrderPayment.saveShippingAsBilling" default = "0";
        param name = "data.accountAddressID" default = "";
        param name = "data.accountPaymentMethodID" default = "";
        param name = "data.newOrderPayment.paymentMethod.paymentMethodID" default = "444df303dedc6dab69dd7ebcc9b8036a";
        param name = "data.orderID" default = "";

        //Make sure orderID passed in belongs to logged in account
        var accountID = getHibachiScope().getAccount().getAccountID();
        if (len(data.orderID)) {
            if (isNull(accountID) || !len(accountID) || accountID != getOrderService().getOrder(data.orderID).getAccount().getAccountID()) {
                data.orderID = '';
            }
        }
        
        if (len(data.orderID)) {
            var order = getOrderService().getOrder(data.orderID);
        }
        else {
            var order = getHibachiScope().getCart();
        }

        if (structKeyExists(data, 'accountAddressID') && len(data.accountAddressID)) {
            var paymentMethod = getPaymentService().getPaymentMethod(data.newOrderPayment.paymentMethod.paymentMethodID);
            if(!isNull(paymentMethod) && paymentMethod.getPaymentMethodType() == 'termPayment'){
                data.newOrderPayment.termPaymentAccount.accountID = getHibachiScope().getAccount().getAccountID();
            }
            var accountAddress = getService('addressService').getAccountAddress(data.accountAddressID);
            var addOrderPayment = getService('OrderService').processOrder(order, arguments.data, 'addOrderPayment');
            for (var payment in addOrderPayment.getOrderPayments()) {
                addErrors(data, payment.getErrors());
            }
            getHibachiScope().addActionResult("public:cart.addOrderPayment", addOrderPayment.hasErrors());
            return addOrderPayment;
        }

        if (structKeyExists(data.newOrderPayment, 'billingAddress') && structKeyExists(data.newOrderPayment.billingAddress, 'accountAddressID')) {
            data.accountAddressID = data.newOrderPayment.billingAddress.accountAddressID;
        }


        // Make sure that someone isn't trying to pass in another users orderPaymentID
        if (len(data.newOrderPayment.orderPaymentID)) {
            var orderPayment = getService("OrderService").getOrderPayment(data.newOrderPayment.orderPaymentID);
            if (orderPayment.getOrder().getOrderID() != getHibachiScope().cart().getOrderID()) {
                data.newOrderPayment.orderPaymentID = "";
            }
        }

        
        if (data.newOrderPayment.requireBillingAddress || data.newOrderPayment.saveShippingAsBilling) {
            // Only create a new billing address here if its not being created later using the account payment method.
            if (!structKeyExists(data.newOrderPayment, 'billingAddress') 
                && (!structKeyExists(data, "accountPaymentMethodID") 
                && len(data.accountPaymentMethodID))) {

                var orderPayment = getPaymentService().newOrderPayment();
                orderPayment.populate(data.newOrderPayment);
                orderPayment.setOrder(getHibachiScope().getCart());
                if (orderPayment.getPaymentMethod().getPaymentMethodType() == 'termPayment') {
                    orderPayment.setTermPaymentAccount(getHibachiScope().getAccount());
                }
                //Add billing address error
                orderPayment.addError('addBillingAddress', getHibachiScope().rbKey('validate.processOrder_addOrderPayment.billingAddress'));
                //Validate to get all errors
                orderPayment.validate('save');

                this.addErrors(data, orderPayment.getErrors());

                getHibachiScope().addActionResult("public:cart.addOrderPayment", true);
                return;
            }
            
            if (structKeyExists(data, "accountPaymentMethodID") && len(data.accountPaymentMethodID)){
                //use this billing information
                var paymentMethod = getService('accountService').getAccountPaymentMethod(data.accountPaymentMethodID);
                if(!isNull(paymentMethod)){
                    if(!isNull(paymentMethod.getBillingAccountAddress())){
                        var address = paymentMethod.getBillingAccountAddress().getAccountAddressID();
                        var newBillingAddress = this.addBillingAddressUsingAccountAddress({accountAddressID:  paymentMethod.getBillingAccountAddress().getAccountAddressID()});
                    }else if(!isNull(paymentMethod.getBillingAddress())){
                        var address= paymentMethod.getBillingAddress() //pass the object rather than ID
                        var newBillingAddress = this.addBillingAddress({address:  address});
                    }else{
                        getHibachiScope().addActionResult("public:cart.addOrderPayment", true);
                        return;
                    }
                  
                }else{
                    getHibachiScope().addActionResult("public:cart.addOrderPayment", true);
                    return;
                }
            }
        }

        if (!isNull(newBillingAddress) && newBillingAddress.hasErrors()) {
            if(!isNull(paymentMethod)){
                paymentMethod.addError('addOrderPayment',getHibachiScope().rbKey('validate.processOrder_AddOrderPayment.invalidBillingAddress'),true);
                this.addErrors(arguments.data, paymentMethod.getErrors());
                getDAO('AccountDAO').setAccountPaymentMethodInactive(paymentMethod.getAccountPaymentMethodID());
            }else{
                this.addErrors(arguments.data, newBillingAddress.getErrors());
            }
            return;
        }

        var addOrderPayment = getService('OrderService').processOrder(order, arguments.data, 'addOrderPayment');

        if (!giftCard) {
            for (var payment in addOrderPayment.getOrderPayments()) {
                addErrors(data, payment.getErrors());
            }
            getHibachiScope().addActionResult("public:cart.addOrderPayment", addOrderPayment.hasErrors());
        }

        return addOrderPayment;
    }


	/**
     Adds an order payment and then calls place order.
    */
    public void function addOrderPaymentAndPlaceOrder(required any data) {
        addOrderPayment(arguments.data);
        if (!getHibachiScope().cart().hasErrors()){
            placeOrder(arguments.data);
        }
        
    }

    /** 
     * @http-context removeOrderPayment
     * @description Remove Order Payment 
     */
    public void function removeOrderPayment(required any data) {
        var cart = getHibachiScope().getCart();
        cart = getService("OrderService").processOrder( cart, arguments.data, 'removeOrderPayment');
        
        getHibachiScope().addActionResult( "public:cart.removeOrderPayment", cart.hasErrors() );
    }
    
    /** 
     * @http-context placeOrder
     * @description Place Order
     @ProcessMethod Order_PlaceOrder
     */
    public void function placeOrder(required any data) {

        // Insure that all items in the cart are within their max constraint
        if(!getHibachiScope().cart().hasItemsQuantityWithinMaxOrderQuantity()) {
            getService("OrderService").processOrder(getHibachiScope().cart(), 'forceItemQuantityUpdate');
            getHibachiScope().addActionResult( "public:cart.placeOrder", true );
        } else {
            // Setup newOrderPayment requirements
            if(structKeyExists(data, "newOrderPayment")) {
                param name="data.newOrderPayment.orderPaymentID" default="";
                param name="data.accountAddressID" default="";
                param name="data.accountPaymentMethodID" default="";

                // Make sure that someone isn't trying to pass in another users orderPaymentID
                if(len(data.newOrderPayment.orderPaymentID)) {
                    var orderPayment = getService("OrderService").getOrderPayment(data.newOrderPayment.orderPaymentID);
                    if(orderPayment.getOrder().getOrderID() != getHibachiScope().cart().getOrderID()) {
                        data.newOrderPayment.orderPaymentID = "";
                    }
                }
                
                data.newOrderPayment.order.orderID = getHibachiScope().cart().getOrderID();
                data.newOrderPayment.orderPaymentType.typeID = '444df2f0fed139ff94191de8fcd1f61b';
            }
            
            var order = getService("OrderService").processOrder( getHibachiScope().cart(), arguments.data, 'placeOrder');

            getHibachiScope().addActionResult( "public:cart.placeOrder", order.hasErrors() );
            
            if(!order.hasErrors()) {
                getHibachiScope().setSessionValue('confirmationOrderID', order.getOrderID());
                getHibachiScope().getSession().setLastPlacedOrderID( order.getOrderID() );
            }else{
              this.addErrors(data,order.getErrors());
            }
            if(getHibachiScope().getAccount().getGuestAccountFlag()){
                getHibachiScope().getSession().removeAccount();
            }
        }

    
    }
    
    /** 
     * @http-context addProductReview
     *  @description Add Product Review
     @ProcessMethod Order_addProductReview
     */
    public void function addProductReview(required any data) {
        param name="data.newProductReview.product.productID" default="";
        
        var product = getProductService().getProduct( data.newProductReview.product.productID );
        
        if( !isNull(product) ) {
            product = getProductService().processProduct( product, arguments.data, 'addProductReview');
            
            getHibachiScope().addActionResult( "public:product.addProductReview", product.hasErrors() );
            
            if(!product.hasErrors()) {
                product.clearProcessObject("addProductReview");
            }
        } else {
            getHibachiScope().addActionResult( "public:product.addProductReview", true );
        }
    }
    
    public any function addErrors( required struct data , errors){

        if (!structKeyExists(arguments.data, "ajaxResponse")){
            arguments.data["ajaxResponse"] = {};
        }
        
        if (!structKeyExists(arguments.data.ajaxResponse, "errors")){
            arguments.data.ajaxResponse["errors"] = {};
        }
        arguments.data.ajaxResponse["errors"] = errors;
    }
    
    public any function addMessages( required struct data , messages){

        if (!structKeyExists(arguments.data, "ajaxResponse")){
            arguments.data["ajaxResponse"] = {};
        }
        
        if (!structKeyExists(arguments.data.ajaxResponse, "messages")){
            arguments.data.ajaxResponse["messages"] = {};
        }
        arguments.data.ajaxResponse["messages"] = messages;
    } 
    
    /** returns a list of state code options either for us (default) or by the passed in countryCode */
    public void function getStateCodeOptionsByCountryCode( required struct data ) {
        param name="data.countryCode" type="string" default="US";
        var cacheKey = "PublicService.getStateCodeOptionsByCountryCode#arguments.data.countryCode#";
        var stateCodeOptions = [];
        if(getHibachiCacheService().hasCachedValue(cacheKey)){
        	stateCodeOptions = getHibachiCacheService().getCachedValue(cacheKey);
        }else{
        	var country = getAddressService().getCountry(data.countryCode);
        	stateCodeOptions = country.getStateCodeOptions();
        	getHibachiCacheService().setCachedValue(cacheKey,stateCodeOptions);
        }
         arguments.data.ajaxResponse["stateCodeOptions"] = stateCodeOptions;
        //get the address options.
        if (!isNull(arguments.data.countryCode)){
          getAddressOptionsByCountryCode(arguments.data);
        }
    }
    
    public void function getStateCodeOptionsByAddressZoneCode( required struct data ) {
        if(!structKeyExists(data,addressZoneCode) || data.addressZoneCode == 'undefined'){
            data.addressZoneCode = 'US';
        }
        var addressZoneLocations = getAddressService().getAddressZoneByAddressZoneCode('US').getAddressZoneLocations();
        cacheKey = "PublicService.getStateCodeOptionsByAddressZoneCode#arguments.data.addressZoneCode#";
        stateCodeOptions = "";
        if(getHibachiCacheService().hasCachedValue(cacheKey)){
            stateCodeOptions = getHibachiCacheService().getCachedValue(cacheKey);
        }else{
            for(var addressZoneLocation in addressZoneLocations){
                stateCodeOptions = listAppend(stateCodeOptions,addressZoneLocation.getStateCode());
            }
            getHibachiCacheService().setCachedValue(cacheKey,stateCodeOptions);
        }
          arguments.data.ajaxResponse["stateCodeOptions"] = listSort(stateCodeOptions,'text');
    }
    
    /** Given a country - this returns all of the address options for that country */
    public void function getAddressOptionsByCountryCode( required data ) {
        param name="data.countryCode" type="string" default="US";
        
        var addressOptions = {};
        var cacheKey = 'PublicService.getAddressOptionsByCountryCode#arguments.data.countryCode#';
        if(getHibachiCacheService().hasCachedValue(cacheKey)){
          addressOptions = getHibachiCacheService().getCachedValue(cacheKey);
        }else{
          var country = getAddressService().getCountry(data.countryCode);
          addressOptions = {
            
              'streetAddressLabel' =  country.getStreetAddressLabel(),
              'streetAddressShowFlag' =  country.getStreetAddressShowFlag(),
              'streetAddressRequiredFlag' =  country.getStreetAddressRequiredFlag(),
              
              'street2AddressLabel' =  country.getStreet2AddressLabel(),
              'street2AddressShowFlag' =  country.getStreet2AddressShowFlag(),
              'street2AddressRequiredFlag' =  country.getStreet2AddressRequiredFlag(),
              
              'cityLabel' =  country.getCityLabel(),
              'cityShowFlag' =  country.getCityShowFlag(),
              'cityRequiredFlag' =  country.getCityRequiredFlag(),
              
              'localityLabel' =  country.getLocalityLabel(),
              'localityShowFlag' =  country.getLocalityShowFlag(),
              'localityRequiredFlag' =  country.getLocalityRequiredFlag(),
              
              'stateCodeLabel' =  country.getStateCodeLabel(),
              'stateCodeShowFlag' =  country.getStateCodeShowFlag(),
              'stateCodeRequiredFlag' =  country.getStateCodeRequiredFlag(),
              
              'postalCodeLabel' =  country.getPostalCodeLabel(),
              'postalCodeShowFlag' =  country.getPostalCodeShowFlag(),
              'postalCodeRequiredFlag' =  country.getPostalCodeRequiredFlag()
              
          };
          getHibachiCacheService().setCachedValue(cacheKey,addressOptions);
        }
        arguments.data.ajaxResponse["addressOptions"] = addressOptions;
        
    }
    
    public void function getAccountWishlistsOptions(required struct data){
        var options = getOrderService().getAccountWishlistsOptions(getHibachiScope().getAccount().getAccountID());
        arguments.data.ajaxResponse["accountWishlistOptions"] = options;
    }
    
    /** returns the list of country code options */
     public void function getCountries( required struct data ) {
        arguments.data.ajaxResponse['countryCodeOptions'] = getService('HibachiCacheService').getOrCacheFunctionValue('PublicService.getCountries',getAddressService(),'getCountryCodeOptions');
    }
    
    /** Given a skuCode, returns the estimated shipping rates for that sku. */
    public any function getEstimatedShippingCostBySkuCode(any data){
    	if (!isNull(data.skuCode)){
    		
    		//data setup.
    		var orderFulfillment = getService("OrderService").newOrderFulfillment();
    		var orderItem = getService("OrderService").newOrderItem();
    		var sku = getService("SkuService").getSkuBySkuCode(data.skuCode);
    		
    		//set the sku so we have data for the rates.
    		orderItem.setSku(sku);
    		var shippingMethodOptions = [];
    		
    		//set the order so it doesn't stall when updating options.
    		orderFulfillment.setOrder(getHibachiScope().getCart());
    		
    		var eligibleFulfillmentMethods = listToArray(sku.setting("skuEligibleFulfillmentMethods"));
    		
    		var options = {};
    		
    		//iterate through getting the options.
    		for (var eligibleFulfillmentMethod in eligibleFulfillmentMethods){
    			//get the fulfillment methods for this item.
    			var fulfillmentMethod = getService("FulfillmentService").getFulfillmentMethod(eligibleFulfillmentMethod);
    			if (!isNull(fulfillmentMethod) &&!isNull(fulfillmentMethod.getFulfillmentMethodType()) &&  fulfillmentMethod.getFulfillmentMethodType() == "shipping"){
    				
    				//set the method so we can update with the options.
    				orderFulfillment.setFulfillmentMethod(fulfillmentMethod);
    				getService("ShippingService").updateOrderFulfillmentShippingMethodOptions(orderFulfillment);
    				if (!isNull(orderFulfillment.getShippingMethodOptions())){
    					for (var rate in orderFulfillment.getShippingMethodOptions()){
    						options['#rate.shippingMethodCode#'] = rate;
    					}
    				}
    			}
    		}
    		
    		//remove the orderfulfillment that we used to get the rates because it will disrupt other entities saving.
    		getService("OrderService").deleteOrderFulfillment(orderFulfillment);
    		arguments.data['ajaxResponse']['estimatedShippingRates'] = options;
    	}
    }
    
    public void function getSkuPriceByQuantity(required any data){
        if(isNull(arguments.data.skuID)){
            addErrors(arguments.data, [{'skuID':"Error retrieving price; skuID is required."}]);
        }
        if(isNull(arguments.data.quantity) || !isNumeric(arguments.data.quantity)){
            arguments.data.quantity = 1;
        }
        if(isNull(arguments.data.currencyCode)){
            arguments.data.currencyCode = 'USD';
        }
        
        var sku = getSkuService().getSku(arguments.data.skuID);
        arguments.data['ajaxResponse']['price'] = sku.getPriceByCurrencyCode(arguments.data.currencyCode, arguments.data.quantity);
    }
    
    public void function getAccountAddresses(required struct data){
        
        var account = getHibachiScope().getAccount();
        
        arguments.data['ajaxResponse']['accountAddresses'] = account.getAccountAddressesCollectionList().getRecords(); 
        
        if(account.hasPrimaryAddress()) {
            arguments.data['ajaxResponse']['primaryAccountAddressID'] = account.getPrimaryAddress().getAccountAddressID(); 
        }
        
        if(account.hasPrimaryBillingAddress()) {
            arguments.data['ajaxResponse']['primaryBillingAddressID'] = account.getPrimaryBillingAddress().getAccountAddressID(); 
        }
        
        if(account.hasPrimaryShippingAddress()) {
            arguments.data['ajaxResponse']['primaryShippingAddressID'] = account.getPrimaryShippingAddress().getAccountAddressID(); 
        }
    }
    
    public void function getAccountPaymentMethods(required struct data){
	
		var account = getHibachiScope().getAccount();
	
		arguments.data['ajaxResponse']['accountPaymentMethods'] = account.getAccountPaymentMethodsCollectionList().getRecords();  
		
		if(account.hasPrimaryPaymentMethod()){
            arguments.data['ajaxResponse']['primaryPaymentMethodID'] = account.getPrimaryPaymentMethod().getAccountPaymentMethodID(); 
        }
    }
   
	public void function getOrderTemplates(required any data){ 
        param name="arguments.data.pageRecordsShow" default=5;
        param name="arguments.data.currentPage" default=1;
        param name="arguments.data.orderTemplateID" default="";
		param name="arguments.data.orderTemplateTypeID" default="2c948084697d51bd01697d5725650006"; 
		param name="arguments.data.optionalProperties" default="";

		arguments.data['ajaxResponse']['orderTemplates'] = getOrderService().getOrderTemplatesForAccount(arguments.data); 
	}
	
	public void function getOrderTemplateItems(required any data){
        param name="arguments.data.pageRecordsShow" default=5;
        param name="arguments.data.currentPage" default=1;
        param name="arguments.data.orderTemplateID" default="";
		param name="arguments.data.orderTemplateTypeID" default="2c948084697d51bd01697d5725650006"; // defaults to - "ottSchedule", we should use system-code

		arguments.data['ajaxResponse']['orderTemplateItems'] = getOrderService().getOrderTemplateItemsForAccount(arguments.data);  
	} 
	
	
	public void function getOrderTemplateDetails(required any data){
        param name="arguments.data.pageRecordsShow" default=5;
        param name="arguments.data.currentPage" default=1;
        param name="arguments.data.orderTemplateId" default="";
		param name="arguments.data.orderTemplateTypeID" default="2c948084697d51bd01697d5725650006"; 
		param name="arguments.data.optionalProperties" type="string" default="";  //putting here for documentation purpous only
				
		arguments.data['ajaxResponse']['orderTemplate'] = getOrderService().getOrderTemplateDetailsForAccount(arguments.data);  
	}
	
	private void function setOrderTemplateAjaxResponse(required any data) {
	    
		var orderTemplateCollection = getOrderService().getOrderTemplatesCollectionForAccount(argumentCollection = arguments); 
	    orderTemplateCollection.addFilter("orderTemplateID", arguments.data.orderTemplateID); // limit to our order-template
	    var orderTemplates = orderTemplateCollection.getPageRecords(); 
 		arguments.data['ajaxResponse']['orderTemplate'] = arrayLen(orderTemplates) ? orderTemplates[1] : []; // there should be only one record;  
	}
	
	
	
	public void function updateOrderTemplateShippingAndBilling(required any data){
	    param name="arguments.data.orderTemplateID" default="";
	
     	var orderTemplate = getOrderService().getOrderTemplateAndEnforceOwnerAccount(argumentCollection = arguments);
		if( isNull(orderTemplate) ) {
			return; 
		}
		
		orderTemplate = getOrderService().processOrderTemplate(orderTemplate, arguments.data, 'updateShipping'); 
        var processObject = orderTemplate.getProcessObject('UpdateShipping');
        orderTemplate.addErrors( processObject.getErrors() );
        getHibachiScope().addActionResult( "public:updateOrderTemplateShipping", orderTemplate.hasErrors() );
        
        if(!orderTemplate.hasErrors() && !getHibachiScope().getORMHasErrors() && !processObject.hasErrors() ) {
            getHibachiScope().flushORMSession(); //flushing to make new data availble
        }
        
		orderTemplate = getOrderService().processOrderTemplate(orderTemplate, arguments.data, 'updateBilling'); 
        processObject = orderTemplate.getProcessObject('UpdateBilling');
        orderTemplate.addErrors( processObject.getErrors() );
        getHibachiScope().addActionResult( "public:updateOrderTemplateBilling", orderTemplate.hasErrors() );

        if(!orderTemplate.hasErrors() && !getHibachiScope().getORMHasErrors() && !processObject.hasErrors() ) {
    		getHibachiScope().flushORMSession(); //flushing to make new data availble
        }
        
        getService('OrderService').getOrderTemplateOrderDetails(orderTemplate);

        getOrderTemplateDetails(argumentCollection=arguments);
        addErrors(arguments.data, orderTemplate.getErrors());
        
	}


 	public void function updateOrderTemplateShipping(required any data){ 
        param name="arguments.data.orderTemplateID" default="";
	
     	var orderTemplate = getOrderService().getOrderTemplateAndEnforceOwnerAccount(argumentCollection = arguments);
		if( isNull(orderTemplate) ) {
			return; 
		}
	    
 		orderTemplate = getOrderService().processOrderTemplate(orderTemplate, arguments.data, 'updateShipping'); 
        getHibachiScope().addActionResult( "public:orderTemplate.updateShipping", orderTemplate.hasErrors() );
            
        if(!orderTemplate.hasErrors() && !getHibachiScope().getORMHasErrors()) {
            
            orderTemplate.clearProcessObject("updateShipping");
            getHibachiScope().flushORMSession(); //flushing to make new data availble
    		
    		setOrderTemplateAjaxResponse(argumentCollection = arguments);
     		
     		//if there's a new account address
     		if(StructKeyExists(arguments.data, "newAccountAddress")) {
     		    arguments.data['ajaxResponse']['newAccountAddress'] = orderTemplate.getShippingAccountAddress().getStructRepresentation();
     		}
     		
        } else {
            var processObject = orderTemplate.getProcessObject('UpdateShipping');
            if(processObject.hasErrors()){
                addErrors(arguments.data, processObject.getErrors());
            }else{
                addErrors(arguments.data, orderTemplate.getErrors());
            }
        }
 	}   
 	
 	
 	public void function updateOrderTemplateBilling(required any data){ 
        param name="arguments.data.orderTemplateID" default="";
	
     	var orderTemplate = getOrderService().getOrderTemplateAndEnforceOwnerAccount(argumentCollection = arguments);
		if( isNull(orderTemplate) ) {
			return; 
		}
	    
 		orderTemplate = getOrderService().processOrderTemplate(orderTemplate, arguments.data, 'updateBilling'); 
        getHibachiScope().addActionResult( "public:orderTemplate.updateBilling", orderTemplate.hasErrors() );
            
        if(!orderTemplate.hasErrors() && !getHibachiScope().getORMHasErrors()) {
            
            orderTemplate.clearProcessObject("updateBilling");
            getHibachiScope().flushORMSession(); //flushing to make new data availble
    		
    		setOrderTemplateAjaxResponse(argumentCollection = arguments);
     		
     		//if there's a new account address
     		if(StructKeyExists(arguments.data, "newAccountAddress")) {
     		    arguments.data['ajaxResponse']['newAccountAddress'] = orderTemplate.getBillingAccountAddress().getStructRepresentation();
     		}
     		
     			//if there's a new account address
     		if(StructKeyExists(arguments.data, "newAccountPaymentMethod")) {
     		    arguments.data['ajaxResponse']['newAccountPaymentMethod'] = orderTemplate.getAccountPaymentMethod().getStructRepresentation();
     		}
     		
        } else {
            ArrayAppend(arguments.data.messages, orderTemplate.getErrors(), true);
        }
 	}   

 	
 	public void function activateOrderTemplate(required any data) { 
        param name="arguments.data.orderTemplateID" default="";
	
     	var orderTemplate = getOrderService().getOrderTemplateAndEnforceOwnerAccount(argumentCollection = arguments);
		if( isNull(orderTemplate) ) {
			return;
		}
		
 		orderTemplate = getOrderService().processOrderTemplate(orderTemplate, arguments.data, 'activate'); 
        getHibachiScope().addActionResult( "public:orderTemplate.activate", orderTemplate.hasErrors() );
            
        if(!orderTemplate.hasErrors() && !getHibachiScope().getORMHasErrors()) {
            
            orderTemplate.clearProcessObject("activate");
            getHibachiScope().flushORMSession(); //TODO.......check?  flushing to make new data availble
            setOrderTemplateAjaxResponse(argumentCollection = arguments);
            
        } else {
            ArrayAppend(arguments.data.messages, orderTemplate.getErrors(), true);
        }
 	} 
 	

 	public void function cancelOrderTemplate(required any data) { 
        param name="arguments.data.orderTemplateID" default="";
	
     	var orderTemplate = getOrderService().getOrderTemplateAndEnforceOwnerAccount(argumentCollection = arguments);
		if( isNull(orderTemplate) ) {
			return;
		}
	    
 		orderTemplate = getOrderService().processOrderTemplate(orderTemplate, arguments.data, 'cancel'); 
        getHibachiScope().addActionResult( "public:orderTemplate.cancel", orderTemplate.hasErrors() );
        
        if(!orderTemplate.hasErrors() && !getHibachiScope().getORMHasErrors()) {
            
            orderTemplate.clearProcessObject("cancel");
            getHibachiScope().flushORMSession(); //flushing to make new data availble
    		setOrderTemplateAjaxResponse(argumentCollection = arguments);
        
        } else {
            ArrayAppend(arguments.data.messages, orderTemplate.getErrors(), true);
        }
 	}   
 	
 	
 	public any function updateOrderTemplateSchedule( required any data ){
        param name="arguments.data.orderTemplateID" default="";
	
     	var orderTemplate = getOrderService().getOrderTemplateAndEnforceOwnerAccount(argumentCollection = arguments);
		if( isNull(orderTemplate) ) {
			return;
		}
	    
 		orderTemplate = getOrderService().processOrderTemplate(orderTemplate, arguments.data, 'updateSchedule'); 
        getHibachiScope().addActionResult( "public:orderTemplate.updateSchedule", orderTemplate.hasErrors() );
            
        if(!orderTemplate.hasErrors() && !getHibachiScope().getORMHasErrors()) {
            
            orderTemplate.clearProcessObject("updateSchedule");
            getHibachiScope().flushORMSession(); //flushing to make new data availble
    		setOrderTemplateAjaxResponse(argumentCollection = arguments);
        
        } else {
            ArrayAppend(arguments.data.messages, orderTemplate.getErrors(), true);
        }
 	} 
	
	
	public any function updateOrderTemplateFrequency( required any data ){
        param name="arguments.data.orderTemplateID" default="";
	
     	var orderTemplate = getOrderService().getOrderTemplateAndEnforceOwnerAccount(argumentCollection = arguments);
		if( isNull(orderTemplate) ) {
			return;
		}
	    
 		orderTemplate = getOrderService().processOrderTemplate(orderTemplate, arguments.data, 'updateFrequency'); 
        getHibachiScope().addActionResult( "public:orderTemplate.updateFrequency", orderTemplate.hasErrors() );
            
        if(orderTemplate.hasErrors() && getHibachiScope().getORMHasErrors()) {
            ArrayAppend(arguments.data.messages, orderTemplate.getErrors(), true);
            return;
        }
        orderTemplate.clearProcessObject("updateFrequency");
     
	} 
	
	public any function getAccountGiftCards( required struct data) {
        param name="arguments.data.pageRecordsShow" default=5;
        param name="arguments.data.currentPage" default=1;
        
        var giftCardCollectionList = getGiftCardService().getGiftCardCollectionList();    
        
        giftCardCollectionList.setPageRecordsShow(arguments.data.pageRecordsShow);
		giftCardCollectionList.setCurrentPageDeclaration(arguments.data.currentPage); 
		giftCardCollectionList.addFilter('ownerAccount.accountID', getHibachiScope().getAccount().getAccountID());
	

		arguments.data['ajaxResponse']['giftCards'] = giftCardCollectionList.getPageRecords();  
	
	}
	
	public any function applyGiftCardToOrderTemplate( required struct data ){
        param name="arguments.data.orderTemplateID" default="";
	
     	var orderTemplate = getOrderService().getOrderTemplateAndEnforceOwnerAccount(argumentCollection = arguments);
		if( isNull(orderTemplate) ) {
			return;
		}
	    
 		orderTemplate = getOrderService().processOrderTemplate(orderTemplate, arguments.data, 'applyGiftCard'); 
        getHibachiScope().addActionResult( "public:orderTemplate.applyGiftCard", orderTemplate.hasErrors() );
        
        var processObject = orderTemplate.getProcessObjects()['applyGiftCard'];
        if( processObject.hasErrors() ){
            ArrayAppend(arguments.data.messages, processObject.getErrors(), true);
            return;
        }
        
        if( orderTemplate.hasErrors() ){
            ArrayAppend(arguments.data.messages, orderTemplate.getErrors(), true);
            return;
        }    
            
        if( !getHibachiScope().getORMHasErrors()) {
            
            orderTemplate.clearProcessObject("applyGiftCard");
            getHibachiScope().flushORMSession(); //flushing to make new data availble
        	setOrderTemplateAjaxResponse(argumentCollection = arguments);
        }
	}
	
	public any function getOrderTemplatePromotionSkuCollectionConfig( required any data ){
        param name="arguments.data.orderTemplateID" default="";
	
     	var orderTemplate = getOrderService().getOrderTemplateAndEnforceOwnerAccount(argumentCollection = arguments);
		if( isNull(orderTemplate) ) {
			return;
		}
		
        arguments.data['ajaxResponse']['orderTemplatePromotionSkuCollectionConfig'] = orderTemplate.getPromotionalRewardSkuCollectionConfig();
	}
	
	public any function getOrderTemplatePromotionSkus( required any data ){
        param name="arguments.data.orderTemplateID" default="";
        param name="arguments.data.pageRecordsShow" default=10;
        param name="arguments.data.currentPage" default=1;
        
     	var orderTemplate = getOrderService().getOrderTemplateAndEnforceOwnerAccount(argumentCollection = arguments);
		if( isNull(orderTemplate) ) {
			return;
		}
		
		if(!StructKeyExists(arguments.data, 'orderTemplatePromotionSkuCollectionConfig')){
	        var promotionsCollectionConfig =  orderTemplate.getPromotionalFreeRewardSkuCollectionConfig();
	        promotionsCollectionConfig['pageRecordsShow'] = arguments.data.pageRecordsShow;
	        promotionsCollectionConfig['currentPage'] = arguments.data.currentPage;
	        arguments.data.orderTemplatePromotionSkuCollectionConfig = promotionsCollectionConfig;
		}
	    
	    var promotionsCollectionList = getService("SkuService").getSkuCollectionList();
	    promotionsCollectionList.setCollectionConfigStruct(arguments.data.orderTemplatePromotionSkuCollectionConfig);
        
        arguments.data['ajaxResponse']['orderTemplatePromotionSkus'] = promotionsCollectionList.getPageRecords(); 
	}
	
	private void function setOrderTemplateItemAjaxResponse(required any data) {
	    
		var orderTemplateItemCollection = getOrderService().getOrderTemplateItemCollectionForAccount(argumentCollection = arguments); 
	    orderTemplateItemCollection.addFilter("orderTemplateItemID", arguments.data.orderTemplateItemID); // filter with our-order-template-item
	    
 		arguments.data['ajaxResponse']['orderTemplateItem'] = orderTemplateItemCollection.getPageRecords()[1]; // there should be only one record;  
	}
	
	public void function addWishlistItem(required any data) {
        param name="data.orderTemplateID" default="";
        param name="data.skuID" default="";

        var orderTemplate = getOrderService().getOrderTemplateAndEnforceOwnerAccount(argumentCollection = arguments);
		if( isNull(orderTemplate) ) {
			return;
		}
	    
 		orderTemplate = getOrderService().processOrderTemplate(orderTemplate, arguments.data, 'addWishlistItem'); 
        getHibachiScope().addActionResult( "public:orderTemplate.addWishlistItem", orderTemplate.hasErrors() );
            
        if(orderTemplate.hasErrors()) {
            ArrayAppend(arguments.data.messages, orderTemplate.getErrors(), true);
        }
    }
	
	public void function addOrderTemplateItem(required any data) {
        param name="data.orderTemplateID" default="";
        param name="data.skuID" default="";
        param name="data.quantity" default=1;
        
        var orderTemplate = getOrderService().getOrderTemplateAndEnforceOwnerAccount(argumentCollection = arguments);
		if( isNull(orderTemplate) ) {
			return;
		}
	    
 		orderTemplate = getOrderService().processOrderTemplate(orderTemplate, arguments.data, 'addOrderTemplateItem'); 
 		orderTemplate = getOrderService().saveOrderTemplate(orderTemplate);
        getHibachiScope().addActionResult( "public:order.addOrderTemplateItem", orderTemplate.hasErrors() );
            
        if(orderTemplate.hasErrors()) {
            ArrayAppend(arguments.data.messages, orderTemplate.getErrors(), true);
        }else if(!orderTemplate.hasErrors() && !getHibachiScope().getORMHasErrors()) {
            getHibachiScope().flushORMSession(); 
        }
        
    }
    
    
    public void function editOrderTemplateItem(required any data) {
        param name="data.orderTemplateItemID" default="";
        param name="data.quantity" default=1;
        
        var orderTemplateItem = getOrderService().getOrderTemplateItemForAccount( argumentCollection=arguments );
        if( isNull(orderTemplateItem) ) {
			return;
		}
		
		orderTemplateItem.setQuantity(arguments.data.quantity); 
        var orderTemplateItem = getOrderService().saveOrderTemplateItem( orderTemplateItem, arguments.data );
        orderTemplateItem.getOrderTemplate().updateCalculatedProperties();

        getHibachiScope().addActionResult( "public:order.editOrderTemplateItem", orderTemplateItem.hasErrors() );
            
        if(orderTemplateItem.hasErrors()) {
            ArrayAppend(arguments.data.messages, orderTemplateItem.getErrors(), true);
        }
    }


	public void function removeOrderTemplateItem(required any data) {
        param name="data.orderTemplateItemID" default="";
        
        var orderTemplateItem = getOrderService().getOrderTemplateItemForAccount( argumentCollection=arguments );
        if( isNull(orderTemplateItem) ) {
			return;
		}
	    
 		orderTemplate = getOrderService().processOrderTemplate(orderTemplateItem.getOrderTemplate(), arguments.data, 'removeOrderTemplateItem'); 
        orderTemplate.updateCalculatedProperties();
        getHibachiScope().addActionResult( "public:order.removeOrderTemplateItem", orderTemplate.hasErrors() );
            
        if(orderTemplate.hasErrors()) {
            ArrayAppend(arguments.data.messages, orderTemplate.getErrors(), true);
        }
    }

	
	public void function deleteOrderTemplateItem(required any data) {
        param name="data.orderTemplateItemID" default="";
        
        var orderTemplateItem = getOrderService().getOrderTemplateItem( arguments.data.orderTemplateItemID );
        
        if(!isNull(orderTemplateItem) && orderTemplateItem.getOrderTemplate().getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID() ) {
            var deleteOk = getOrderService().deleteOrderTemplateItem( orderTemplateItem );
            getHibachiScope().addActionResult( "public:order.deleteOrderTemplateItem", !deleteOK );
            return;
        }
        
        getHibachiScope().addActionResult( "public:order.deleteOrderTemplateItem", true );  
    }
    
    public void function editOrderTemplate(required any data){
        param name="data.orderTemplateID" default="";
        param name="data.orderTemplateName" default="";
        
        var orderTemplate = getOrderService().getOrderTemplateAndEnforceOwnerAccount(argumentCollection = arguments);
		if( isNull(orderTemplate) ) {
			return;
		}
	    
	    if(len(arguments.data.orderTemplateName)) {
 		    orderTemplate.setOrderTemplateName(arguments.data.orderTemplateName);
	    }
	    
	    orderTemplate = getOrderService().saveOrderTemplate(orderTemplate);
        getHibachiScope().addActionResult( "public:orderTemplate.edit", orderTemplate.hasErrors() );

        if(!orderTemplate.hasErrors() && !getHibachiScope().getORMHasErrors()) {
            
            getHibachiScope().flushORMSession(); 
            //flushing to make new data availble
    		setOrderTemplateAjaxResponse(argumentCollection = arguments);
        
        } else {
            ArrayAppend(arguments.data.messages, orderTemplate.getErrors(), true);
        }
    }
    
    public void function deleteOrderTemplate(required any data){
        param name="data.orderTemplateItemID" default="";

        var orderTemplate = getOrderService().getOrderTemplate( arguments.data.orderTemplateID );
        
        if(!isNull(orderTemplate) && orderTemplate.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID() ) {
            var deleteOK = getOrderService().deleteOrderTemplate(orderTemplate);
            getHibachiScope().addActionResult( "public:order.deleteOrderTemplate", !deleteOK);
            if(!deleteOK){
                ArrayAppend(arguments.data.messages, orderTemplate.getErrors(), true);
            }
            return;
        }
        
        getHibachiScope().addActionResult( "public:order.deleteOrderTemplate", true );  
        
    }
    
    
    ///    ############### .  getXXXOptions();  .  ###############   
    
    /**
     *  data.optionsList = "frequencyTermOptions,siteOrderTemplateShippingMethodOptions,cancellationReasonTypeOptions....."; 
    */ 
    public void function getOptions(required any data){
        param name="data.optionsList" default="" pattern="^[\w,]+$"; //option-name-list
        
        for(var optionName in arguments.data.optionsList) {
            if(right(optionName,7) == 'Options'){
                this.invokeMethod("get#optionName#", {'data' = arguments.data});
            }
        }
    }
    
    public void function getFrequencyTermOptions(required any data) {
		arguments.data['ajaxResponse']['frequencyTermOptions'] = getOrderService().getOrderTemplateFrequencyTermOptions();
    }
    
    public void function getFrequencyDateOptions(required any data) {
		arguments.data['ajaxResponse']['frequencyDateOptions'] = getOrderService().getOrderTemplateFrequencyDateOptions();
    }
    
    public void function getSiteOrderTemplateShippingMethodOptions(required any data) {
        var orderTemplate = getOrderService().getOrderTemplate(arguments.data.orderTemplateID);
        if(isNull(orderTemplate)){
            return arguments.data['ajaxResponse']['siteOrderTemplateShippingMethodOptions'] = {};   
        }
        
		arguments.data['ajaxResponse']['siteOrderTemplateShippingMethodOptions'] = orderTemplate.getShippingMethodOptions();
    }
    
    public void function getCancellationReasonTypeOptions(required any data) {
        var tmpOrderTemplate = getOrderService().newOrderTemplate();
		arguments.data['ajaxResponse']['cancellationReasonTypeOptions'] = tmpOrderTemplate.getOrderTemplateCancellationReasonTypeOptions();
    }
    
    public void function getScheduleDateChangeReasonTypeOptions(required any data) {
        var tmpOrderTemplate = getOrderService().newOrderTemplate();
		arguments.data['ajaxResponse']['scheduleDateChangeReasonTypeOptions'] = tmpOrderTemplate.getOrderTemplateScheduleDateChangeReasonTypeOptions();
    }
    
    public void function getExpirationMonthOptions(required any data) {
       	var tmpAccountPaymentMethod = getAccountService().newAccountPaymentMethod();
		arguments.data['ajaxResponse']['expirationMonthOptions'] = tmpAccountPaymentMethod.getExpirationMonthOptions();
    }
    
     public void function getExpirationYearOptions(required any data) {
       	var tmpAccountPaymentMethod = getAccountService().newAccountPaymentMethod();
		arguments.data['ajaxResponse']['expirationYearOptions'] = tmpAccountPaymentMethod.getExpirationYearOptions();
    }
    
}
