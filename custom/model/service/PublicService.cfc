component extends="Slatwall.model.service.PublicService" {
    
        
     public void function productAvailableSkuOptions( required struct data ) {
		param name="arguments.data.productID" type="string" default="";
		param name="arguments.data.selectedOptionIDList" type="string" default="";

		var product = getProductService().getProduct( arguments.data.productID );

		if(!isNull(product) && product.getActiveFlag() && product.getPublishedFlag()) {
			arguments.data.ajaxResponse["availableSkuOptions"] = product.getAvailableSkuOptions( arguments.data.selectedOptionIDList );
		}
	}

	public void function productSkuSelected(required struct data){
		param name="arguments.data.productID" type="string" default="";
		param name="arguments.data.selectedOptionIDList" type="string" default="";
		var product = getProductService().getProduct( arguments.data.productID );
		try{
			var sku = product.getSkuBySelectedOptions(arguments.data.selectedOptionIDList);
			arguments.data.ajaxResponse['skuID'] = sku.getSkuID();
		}catch(any e){
			arguments.data.ajaxResponse['skuID'] = '';
		}
	}
	
	public void function getSkuOptionDetails(required struct data){
		param name="arguments.data.productID" type="string" default="";
		param name="arguments.data.selectedOptionIDList" type="string" default="";
		var product = getProductService().getProduct( arguments.data.productID );
		try{
			var skuOptionDetails = product.getSkuOptionDetails(arguments.data.selectedOptionIDList);
			arguments.data.ajaxResponse['skuOptionDetails'] = skuOptionDetails;
		}catch(any e){
			arguments.data.ajaxResponse['skuOptionDetails'] = '';
		}
	}
	
	
	
     
     public void function getProductSkus( required struct data ) {
	    param name="arguments.data.productID";
	    param name="arguments.data.currentPage" default=1;
        param name="arguments.data.pageRecordsShow" default= getHibachiScope().setting('GLOBALAPIPAGESHOWLIMIT');
        var optsList = [];
        var defaultSelectedOptions = '';
        var product = getService("productService").getProduct( arguments.data.productID )
        var optionGroupsArr = product.getOptionGroups()
        var skuOptionDetails = product.getSkuOptionDetails()
        var defaultSku = product.getDefaultSku()
        if(!isNull(defaultSku)){
        defaultSelectedOptions = defaultSku.getOptionsIDList()
            for(var optionGroup in optionGroupsArr) {
                var options = product.getOptionsByOptionGroup( optionGroup.getOptionGroupID() )
                var group = []
                for(var option in options) {
                    ArrayAppend(group,{"optionID": option.getOptionID()
                    ,"optionName": option.getOptionName()})
                }
                ArrayAppend(optsList, {
                    "optionGroupName": optionGroup.getOptionGroupName(),
                    "optionGroupID": optionGroup.getOptionGroupID(),
                    "optionGroupCode": optionGroup.getOptionGroupCode(),
                    "options": group })
            }
        }
 
        
      var skuCollectionList = getService('SkuService').getSkuCollectionList();
	    skuCollectionList.setDisplayProperties( "skuID,skuCode,product.productName,product.productCode,product.productType.productTypeName,product.brand.brandName,listPrice,price,renewalPrice,calculatedSkuDefinition,activeFlag,publishedFlag,calculatedQATS");
         skuCollectionList.addFilter('product.productID',trim(arguments.data.productID));
		 skuCollectionList.setPageRecordsShow(arguments.data.pageRecordsShow);
		var results = skuCollectionList.getRecords()
    
        getHibachiScope().addActionResult("public:getProductSkus");

        arguments.data['ajaxResponse']['skus'] = results;
        arguments.data['ajaxResponse']['options'] = optsList;
                arguments.data['ajaxResponse']['defaultSelectedOptions'] = defaultSelectedOptions;
     
     }
     
public void function getConfiguration( required struct data ) {
        param name="arguments.data.siteCode" default="";
        var siteLookup = getService('siteService').getSiteBySiteCode(arguments.data.siteCode);
        getHibachiScope().setSite(siteLookup);
        
            var site = {};
            site["siteID"] = siteLookup.getSiteID();
            site["siteCode"] = siteLookup.getSiteCode();
            site["siteName"] = siteLookup.getSiteName();
            site["hibachiInstanceApplicationScopeKey"] = siteLookup.getHibachiInstanceApplicationScopeKey();
            site["hibachiConfig"] = getHibachiScope().getHibachiConfig();
            arguments.data['ajaxResponse']['config']['site'] = site;
        


        var router = []
        ArrayAppend(router , {"URLKey": getHibachiScope().setting('globalURLKeyProduct'),"URLKeyType": 'Product' });
        ArrayAppend(router , {"URLKey": getHibachiScope().setting('globalURLKeyProductType'),"URLKeyType": 'ProductType' });
        ArrayAppend(router , {"URLKey": getHibachiScope().setting('globalURLKeyCategory'),"URLKeyType": 'Category' });
        ArrayAppend(router , {"URLKey": getHibachiScope().setting('globalURLKeyBrand'),"URLKeyType": 'Brand' });
        ArrayAppend(router , {"URLKey": getHibachiScope().setting('globalURLKeyAccount'),"URLKeyType": 'Account' });
        ArrayAppend(router , {"URLKey": getHibachiScope().setting('globalURLKeyAddress'),"URLKeyType": 'Address' });
        ArrayAppend(router , {"URLKey": getHibachiScope().setting('globalURLKeyAttribute'),"URLKeyType": 'Attribute' });
        
        arguments.data['ajaxResponse']['config']['theme'] = {
            "dateFormat": UCase(getHibachiScope().setting('globalDateFormat')),
            "timeFormat": Replace(UCase(getHibachiScope().setting('globalTimeFormat')), 'TT', 'ss', 'all')};

        getHibachiScope().addActionResult("public:getConfiguration");

        arguments.data['ajaxResponse']['config']['router'] = router;
        return 
         
     }
     
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
    public any function getPickupLocations() {
		arguments.data.ajaxResponse['locations'] = getService('LocationService').getLocationParentOptions(false)
    }
    public any function setPickupDate(required any data) {
        param name="data.pickupDate" default="";
		param name="data.orderFulfillmentID" default="";
        if( getHibachiScope().getLoggedInFlag() ) {
            var cart = getHibachiScope().cart();

            if(!len(arguments.data.orderFulfillmentID)){
    			var orderFulfillment = cart.getOrderFulfillments()[1];
    		}else{
    			var orderFulfillment = getService("OrderService").getOrderFulfillment(arguments.data.orderFulfillmentID);
    		}
		    orderFulfillment.setEstimatedShippingDate(arguments.data.pickupDate);
		    orderFulfillment.setPickupDate(arguments.data.pickupDate);

		    getService("OrderService").saveOrderFulfillment(orderFulfillment);
		    

    		if(orderFulfillment.hasErrors()){
			 getHibachiScope().addActionResult( "public:cart.setPickupDate", true);
               arguments.data.ajaxResponse['errors'] = orderFulfillment.getErrors();
		    }else{
		        getHibachiScope().addActionResult( "public:cart.setPickupDate", false);
		    }
    
    		return cart;
		}
    } 

    public any function getEligibleFulfillmentMethods() {
        
        if( getHibachiScope().getLoggedInFlag() ) {
            var cart = getHibachiScope().cart();
            var orderItems = cart.getOrderItems();


            var sl = getService("fulfillmentService").getFulfillmentMethodSmartList();
			sl.addFilter('activeFlag', 1);
			sl.addSelect('fulfillmentMethodName', 'name');
			sl.addSelect('fulfillmentMethodID', 'value');
			sl.addSelect('fulfillmentMethodType', 'fulfillmentMethodType');
			
			var eligibleFulfillmentMethods = '';
			for(var orderItem in orderItems){
				var sku = orderItem.getSku();
				if(!isNull(sku)) {
					if(!len(eligibleFulfillmentMethods)){
						eligibleFulfillmentMethods = sku.setting('skuEligibleFulfillmentMethods');
					}else{
						for(var fulfillmentMethod in eligibleFulfillmentMethods){
							if(!listFind(sku.setting('skuEligibleFulfillmentMethods'), fulfillmentMethod)){
								eligibleFulfillmentMethods = listDeleteAt(eligibleFulfillmentMethods, listFind(eligibleFulfillmentMethods,fulfillmentMethod));
							}
						}
					}
				}
			}
			
			sl.addInFilter('fulfillmentMethodID', eligibleFulfillmentMethods);
			arguments.data.ajaxResponse['eligibleFulfillmentMethods'] = sl.getRecords();
        }
    }
}
