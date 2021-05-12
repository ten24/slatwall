component extends="Slatwall.model.service.PublicService" {

     
      /**
     * Function to override addOrderPayment 
     * populate orderPayment paymentMthodID
     * and make orderPayment billingAddress optional
     * */
    public any function addOrderPayment(required any data, boolean giftCard = false) {
        param name = "data.orderID" default = "";
        param name = "data.paymentIntegrationType" default="";
        
        if(StructKeyExists(arguments.data,'accountPaymentMethodID') && StructKeyExists(arguments.data, "paymentIntegrationType") && !isEmpty(arguments.data.paymentIntegrationType) ) {
            var accountPaymentMethodCollectionList = getAccountService().getAccountPaymentMethodCollectionList();
            accountPaymentMethodCollectionList.setDisplayProperties('paymentMethod.paymentMethodID');
            accountPaymentMethodCollectionList.addFilter("paymentMethod.paymentIntegration.integrationPackage", arguments.data.paymentIntegrationType);
            accountPaymentMethodCollectionList.addFilter("accountPaymentMethodID", arguments.data.accountPaymentMethodID);
            accountPaymentMethodCollectionList = accountPaymentMethodCollectionList.getRecords(formatRecords=true);
            
            if( arrayLen(accountPaymentMethodCollectionList) ) {
               arguments.data.newOrderPayment.paymentMethod.paymentMethodID = accountPaymentMethodCollectionList[1].paymentMethod_paymentMethodID;
                arguments.data.newOrderPayment.requireBillingAddress = 0;
            }
        }
        
        if (len(arguments.data.orderID)) {
            var order = getOrderService().getOrder(arguments.data.orderID);
        } else {
            var order = getHibachiScope().getCart();
        }
        
        var account = getHibachiScope().getAccount();
        
        //Remove any existing order payments
        //It's to remove default payment from order when adding any new method
        if(!isNull(order) && !isNull(order.getAccount()) && order.getAccount().getAccountID() == account.getAccountID()) {
            for( var orderPayment in order.getOrderPayments() ) {
                if(orderPayment.isDeletable()) {
                    orderPayment.setBillingAddress(javacast('null',''));
    				getService("OrderService").deleteOrderPayment(orderPayment);
    			}
    		}
        }
        
        super.addOrderPayment(argumentCollection = arguments);
    }
    
     
	/**
	 * Get Product List (an alternative to generic entity api call for products)
	 * */
	public void function getProductListing( required struct data ) {
	    param name="arguments.data.includeChildProductType" default= 0;
	    param name="arguments.data.productTypeUrlTitle" default= "";
	    arguments.data.entityName = "Product";
	    arguments.data.restRequestFlag = 1;
	    
	    //Set an In filter for child types
	    if( arguments.data.includeChildProductType && trim( arguments.data.productTypeUrlTitle ) != "" ) {
	        var productType = getService("productService").getProductTypeByUrlTitle(arguments.data.productTypeUrlTitle);

	       //Append filter in URL
	       StructAppend( url, {"f:productType.productTypeIDPath:like" : "%" & productType.getProductTypeID()} );
	    }

	    var result = getService('hibachiCollectionService').getAPIResponseForEntityName( 
	        entityName=arguments.data.entityName, 
	        data=arguments.data, 
	        enforceAuthorization=false
	    );

	    if( StructKeyExists(result, 'pageRecords') && !ArrayIsEmpty(result.pageRecords) ) {
	        result.pageRecords = getService("productService").appendImagesToProducts(result.pageRecords);

	        result.pageRecords = getService("productService").appendCategoriesAndOptionsToProduct(result.pageRecords);
	    }

	    arguments.data.ajaxResponse = result;
	}
	
	
	/**
	 * Get Product List (an alternative to generic entity api call for products)
	 * */
	public void function getProductList( required struct data ) {
	    param name="arguments.data.includeChildProductType" default= 0;
	    param name="arguments.data.productTypeUrlTitle" default= "";
	    arguments.data.entityName = "Product";
	    arguments.data.restRequestFlag = 1;
	    
	    //Set an In filter for child types
	    if( arguments.data.includeChildProductType && trim( arguments.data.productTypeUrlTitle ) != "" ) {
	        var productType = getService("productService").getProductTypeByUrlTitle(arguments.data.productTypeUrlTitle);

	       //Append filter in URL
	       StructAppend( url, {"f:productType.productTypeIDPath:like" : "%" & productType.getProductTypeID()} );
	    }

	    var result = getService('hibachiCollectionService').getAPIResponseForEntityName( 
	        entityName=arguments.data.entityName, 
	        data=arguments.data, 
	        enforceAuthorization=false
	    );

	    if( StructKeyExists(result, 'pageRecords') && !ArrayIsEmpty(result.pageRecords) ) {
	        result.pageRecords = getService("productService").appendImagesToProducts(result.pageRecords);

	        result.pageRecords = getService("productService").appendCategoriesAndOptionsToProduct(result.pageRecords);
	    }

	    arguments.data.ajaxResponse = result;
	}

	/**
	 * Get Sku List (an alternative to generic entity api call for products)
	 * */
	public void function getSkuListing( required struct data ) {
	    arguments.data.entityName = "Sku";
	    arguments.data.restRequestFlag = 1;

	    var result = getService('hibachiCollectionService').getAPIResponseForEntityName( 
	        entityName=arguments.data.entityName, 
	        data=arguments.data, 
	        enforceAuthorization=false
	    );

	    if( StructKeyExists(result, 'pageRecords') && !ArrayIsEmpty(result.pageRecords) ) {
	        result.pageRecords = getService("skuService").appendSettingsAndOptionsToSku(result.pageRecords);
	    }

	    arguments.data.ajaxResponse = result;

	}
	
		/**
	 * Get Sku List (an alternative to generic entity api call for products)
	 * */
	public void function getBrandListing( required struct data ) {
	    arguments.data.entityName = "Brand";
	    arguments.data.restRequestFlag = 1;
    
        var result = getService('hibachiCollectionService').getAPIResponseForEntityName( 
	        entityName=arguments.data.entityName, 
	        data=arguments.data, 
	        enforceAuthorization=false
	    );
	    
	    if( StructKeyExists(result, 'pageRecords') && !ArrayIsEmpty(result.pageRecords) ) {
	        result.pageRecords = getService("brandService").appendSettingsAndOptions(result.pageRecords);
	    }

	    arguments.data.ajaxResponse = result;

	}
	
	
	public void function productDetailData( required struct data ) {
		
		super.productDetailData(argumentCollection=arguments);
		try{
			if(structKeyExists(arguments.data.ajaxResponse, 'sku') && arrayLen(arguments.data.ajaxResponse.sku)){
				// Change prices to ERP One Prices
				getService('erpOneService').getLiveListingPrices(
					data = arguments.data.ajaxResponse.sku,
					skuCodeKey = "skuCode", 
					priceKeys = "listPrice" ,  // We can also pass a list of prices ex:"listPrice,skuPrice"
					customerCode = getHibachiScope().getAccount().getRemoteID()
				);
			}
		}catch(any e){
			getHibachiScope().logHibachi('Error getting live prices', true);
		}
		
	}

	
}
