component extends="Slatwall.model.service.OrderService" {
    variables.customPriceFields = 'personalVolume,taxableAmount,commissionableVolume,retailCommission,productPackVolume,retailValueVolume';
    public string function getCustomAvailableProperties() {
        return 'orderItems.showInCartFlag,orderItems.personalVolume,orderItems.calculatedExtendedPersonalVolume,calculatedPersonalVolumeSubtotal,currencyCode,orderItems.skuProductURL,billingAddress,appliedPromotionMessages.message,appliedPromotionMessages.qualifierProgress,appliedPromotionMessages.promotionName,appliedPromotionMessages.promotionRewards.amount,appliedPromotionMessages.promotionRewards.amountType,appliedPromotionMessages.promotionRewards.rewardType,monatOrderType.typeCode,calculatedPersonalVolumeTotal';
    }
   
	public array function getOrderEventOptions(){
		var eventOptions = super.getOrderEventOptions(); 

		var customEvents = [
			{
				'name': 'Order - After Order Account Upgrade Success | afterOrderAccountUpgradeSuccess',
				'value': 'afterOrderAccountUpgradeSuccess',
				'entityName': 'Order'
			},
			{
				'name': 'Order - After Order Account MP Upgrade Success | afterOrderMarketPartnerUpgradeSuccess',
				'value': 'afterOrderMarketPartnerUpgradeSuccess',
				'entityName': 'Order'
			}, 
			{
				'name': 'Order - After Order Account VIP Upgrade Success | afterOrderVIPUpgradeSuccess',
				'value': 'afterOrderVIPUpgradeSuccess',
				'entityName': 'Order'
			} 
		]

		arrayAppend(eventOptions, customEvents, true); 

		return eventOptions;  
	} 
    /**
     * Function to get all carts and quotes for user
     * @param accountID required
     * @param pageRecordsShow optional
     * @param currentPage optional
     * return struct of orders and total count
     **/
	public any function getAllCartsAndQuotesOnAccount(required any account, struct data={}) {
        param name="arguments.data.currentPage" default=1;

        param name="arguments.data.pageRecordsShow" default= getHibachiScope().setting('GLOBALAPIPAGESHOWLIMIT');
        param name="arguments.data.accountID" default= getHibachiSCope().getAccount().getAccountID();

		var ordersList = this.getOrderCollectionList();

		ordersList.addOrderBy('orderOpenDateTime|DESC');
		ordersList.setDisplayProperties('
			orderID,
			calculatedTotalItemQuantity,
			orderNumber,
			orderStatusType.typeName
		');

		ordersList.addFilter( 'account.accountID', arguments.account.getAccountID() );
		ordersList.addFilter( 'orderStatusType.systemCode', 'ostNotPlaced');
		ordersList.setPageRecordsShow(arguments.data.pageRecordsShow);
		ordersList.setCurrentPageDeclaration(arguments.data.currentPage); 

		return { "ordersOnAccount":  ordersList.getPageRecords(formatRecords=false), "recordsCount": ordersList.getRecordsCount()}
	}
    
    /**
     * Function to get all order fulfillments for user
     * @param accountID required
     * @param pageRecordsShow optional
     * @param currentPage optional
     * return struct of orders and total count
     **/
	public any function getAllOrderFulfillmentsOnAccount(required any account, struct data={}) {
        param name="arguments.data.currentPage" default=1;
        param name="arguments.data.pageRecordsShow" default= getHibachiScope().setting('GLOBALAPIPAGESHOWLIMIT');

		var ordersList = this.getOrderFulfillmentCollectionList();
		ordersList.setDisplayProperties(' orderFulfillmentID, estimatedShippingDate, pickupDate, order.orderID, order.calculatedTotalItemQuantity, order.orderNumber, orderFulfillmentStatusType.typeName');
		ordersList.addFilter( 'order.account.accountID', arguments.account.getAccountID() );
		ordersList.addFilter( 'order.orderStatusType.systemCode', 'ostNotPlaced', '!=');
		ordersList.setPageRecordsShow(arguments.data.pageRecordsShow);
		ordersList.setCurrentPageDeclaration(arguments.data.currentPage);

		return { "ordersOnAccount":  ordersList.getPageRecords(formatRecords=false), "recordsCount": ordersList.getRecordsCount()}
	}
	
	/**
     * Function to get all order deliveries for user
     * @param accountID required
     * @param pageRecordsShow optional
     * @param currentPage optional
     * return struct of orders and total count
     **/
	public any function getAllOrderDeliveryOnAccount(required any account, struct data={}) {
        param name="arguments.data.currentPage" default=1;
        param name="arguments.data.pageRecordsShow" default=5;
        
		var ordersList = this.getOrderDeliveryCollectionList();
		ordersList.setDisplayProperties(' orderDeliveryID, invoiceNumber, trackingNumber, order.orderID, order.calculatedTotalItemQuantity, order.orderNumber, orderDeliveryStatusType.typeName');
		ordersList.addFilter( 'order.account.accountID', arguments.account.getAccountID() );
		ordersList.addFilter( 'order.orderStatusType.systemCode', 'ostNotPlaced', '!=');
		ordersList.setPageRecordsShow(arguments.data.pageRecordsShow);
		ordersList.setCurrentPageDeclaration(arguments.data.currentPage);

		return { "ordersOnAccount":  ordersList.getPageRecords(formatRecords=false), "recordsCount": ordersList.getRecordsCount()}
	}
    
    
    private numeric function addNewOrderItemSetupGetSkuPrice(required any newOrderItem, required any processObject) {
	
		var priceByCurrencyCodeArgs = {
			'currencyCode' : arguments.newOrderItem.getCurrencyCode(),
			'quantity' : arguments.newOrderItem.getQuantity(),
			'priceGroups': [ arguments.newOrderItem.getAppliedPriceGroup() ?: arguments.processObject.getPriceGroup() ]
		}
		
		return arguments.processObject.getSku()
				.getPriceByCurrencyCode( argumentCollection = priceByCurrencyCodeArgs ) 
	}
    
    public any function addNewOrderItemSetup(required any newOrderItem, required any processObject) {
        arguments.newOrderItem = super.addNewOrderItemSetup(argumentCollection=arguments);
        
		if(isNull(arguments.newOrderItem)){
			return; 
		}

        var sku = arguments.newOrderItem.getSku();
        var account = arguments.newOrderItem.getOrder().getAccount();
        if(isNull(account)){
            account = getService('AccountService').newAccount();
        }
        for(var priceField in variables.customPriceFields){
            
            if(isNull(arguments.newOrderItem.invokeMethod('get#priceField#'))){
            	var customPriceByCurrencyCodeArguments  = {
            		'customPriceField' : priceField, 
            		'currencyCode' : arguments.newOrderItem.getOrder().getCurrencyCode(), 
            		'quantity' : arguments.newOrderItem.getQuantity()
            	};
            	
            	if(!account.getNewFlag()){
            		customPriceByCurrencyCodeArguments['accountID'] = account.getAccountID();
            	}
		        if(!isNull(arguments.newOrderItem.getAppliedPriceGroup())){ 
					customPriceByCurrencyCodeArguments['priceGroups'] = [];
					arrayAppend(customPriceByCurrencyCodeArguments['priceGroups'], arguments.newOrderItem.getAppliedPriceGroup());
				}
                arguments.newOrderItem.invokeMethod('set#priceField#',{1=sku.getCustomPriceByCurrencyCode(argumentCollection=customPriceByCurrencyCodeArguments)});
            }
            
        }
        
        return arguments.newOrderItem;
    }
    
    
    public any function processOrderTemplate_create(required any orderTemplate, required any processObject, required struct data={}, required string context="save") {

		if(arguments.processObject.getNewAccountFlag()) {
			
			var account = getAccountService().processAccount(getAccountService().newAccount(), arguments.data, "create");
			
			if(account.hasErrors()) {
				arguments.orderTemplate.addError('create', account.getErrors());
				return arguments.orderTemplate;
			} 
			
		} else {
			var account = processObject.getAccount() ?: getHibachiScope().getAccount();
		}
		
		if( !account.getCanCreateFlexshipFlag() && arguments.context != "upgradeFlow") {
			arguments.orderTemplate.addError('canCreateFlexshipFlag', rbKey("validate.create.OrderTemplate_Create.canCreateFlexshipFlag") );
			return arguments.orderTemplate;
		}
		
        if(isNull(arguments.data.orderTemplateName)  || !len(trim(arguments.data.orderTemplateName)) ) {
			arguments.data.orderTemplateName = "My Flexship, Created on " & dateFormat(now(), "long");
        }
        
        var site = arguments.processObject.getSite();
        var siteCountryCode = getSiteService().getCountryCodeBySite(site);

		
		//grab and set shipping-account-address from account
		//Add Address only when it belongs to same country as site
		if(account.hasPrimaryShippingAddress() && account.getPrimaryShippingAddress().getAddress().getCountryCode() == siteCountryCode ) {
		    arguments.orderTemplate.setShippingAccountAddress(account.getPrimaryShippingAddress());
		} else if( account.hasPrimaryAddress() && account.getPrimaryAddress().getAddress().getCountryCode() == siteCountryCode){
		    arguments.orderTemplate.setShippingAccountAddress(account.getPrimaryAddress());
		}
		
		//NOTE: there's only one shipping method allowed for flexship
		var shippingMethod = getService('ShippingService').getShippingMethod( 
		            ListFirst( site.setting('siteOrderTemplateEligibleShippingMethods') )
			   );
		orderTemplate.setShippingMethod(shippingMethod);
		
		//grab and set account-payment-method from account to ordertemplate
 		if(account.hasPrimaryPaymentMethod()){
		    arguments.orderTemplate.setAccountPaymentMethod(account.getPrimaryPaymentMethod());
	        
		    if( account.getPrimaryPaymentMethod().hasBillingAccountAddress()){
		        arguments.orderTemplate.setBillingAccountAddress(account.getPrimaryPaymentMethod().getBillingAccountAddress());
		    }
		}
		

		//grab and set billing-account-address from account
		if(!arguments.orderTemplate.hasBillingAccountAddress() ) {
		 	if(account.hasPrimaryBillingAddress()) {
    		    arguments.orderTemplate.setBillingAccountAddress(account.getPrimaryBillingAddress());
    		} else if( account.hasPrimaryAddress() ) {
    		    arguments.orderTemplate.setBillingAccountAddress(account.getPrimaryAddress());
    		}
		}
		
		if( arguments.context != "upgradeFlow"){
			arguments.orderTemplate.setAccount(account);
		} else if(!isNull(arguments.processObject.getPriceGroup())){
			arguments.orderTemplate.setPriceGroup(arguments.processObject.getPriceGroup());
		}
	
		arguments.orderTemplate.setSite( arguments.processObject.getSite() );
		arguments.orderTemplate.setCurrencyCode( arguments.processObject.getCurrencyCode() );
		arguments.orderTemplate.setOrderTemplateStatusType(getTypeService().getTypeBySystemCode('otstDraft'));
		arguments.orderTemplate.setOrderTemplateType(getTypeService().getType(arguments.processObject.getOrderTemplateTypeID()));
		arguments.orderTemplate.setFrequencyTerm( arguments.processObject.getFrequencyTerm() );
		var date = arguments.processObject.getScheduleOrderNextPlaceDateTime() ?: arguments.data.scheduleOrderNextPlaceDateTime;
		arguments.orderTemplate.setScheduleOrderDayOfTheMonth(day(date));
		arguments.orderTemplate.setScheduleOrderNextPlaceDateTime(parseDateTime(date));
		arguments.orderTemplate = this.saveOrderTemplate(arguments.orderTemplate, arguments.data, arguments.context); 
		return arguments.orderTemplate;
    }


	public array function getOrderTemplateEventOptions(){
		var eventOptions = super.getOrderTemplateEventOptions(); 

        // TODO: remove, instead use afterProcessOrderTemplate_addWishlistItemSuccess
		var customEvents = [
			{
				'name': 'WishList - After Wishlist AddItem Success | afterWishlistAddItemSuccess',
				'value': 'afterWishlistAddItemSuccess',
				'entityName': 'OrderTemplate' 
			}
		]

		arrayAppend(eventOptions, customEvents, true); 

		return eventOptions;  
	} 

	public any function processOrderTemplate_addWishlistItem(required any orderTemplate, required any processObject, required struct data={}){
		
		arguments.orderTemplate = super.processOrderTemplate_addWishlistItem(argumentCollection = arguments);
		
		//TODO: remove override, migrate to default event
		
		// if it's a wishlist announce a custom event
		var invokeArguments = {};
		invokeArguments[ "1" ] = arguments.orderTemplate;//compatibility with on missing method
		invokeArguments[ "data" ] = arguments.data;
		invokeArguments[ 'orderTemplate' ] = arguments.orderTemplate;
		invokeArguments[ "processObject" ] = arguments.processObject;
		invokeArguments.entity = arguments.orderTemplate;
			
		if(!arguments.orderTemplate.hasErrors()){
			getHibachiEventService().announceEvent("afterWishlistAddItemSuccess", invokeArguments);
		} 
		else {
			logHibachi("WishList has errors after addOrderItem, #SerializeJson( arguments.orderTemplate.getErrors() )#");
		}
		
		return arguments.orderTemplate;
	}

	public any function processOrderTemplate_shareWishlist(required any orderTemplate, any processObject, struct data={}){

		this.sendEmail(
			emailAddress = arguments.processObject.getReceiverEmailAddress(), 
			emailTemplateID =  arguments.ordertemplate.getSite().setting('siteWishlistShareEmailTemplate'),
			emailTemplateObject = arguments.orderTemplate
		);
		
		return arguments.orderTemplate; 		
	}

	public any function processOrder_create(required any order, required any processObject, required struct data={}) {
	
		arguments.order = super.processOrder_create(argumentCollection=arguments);
		
		if(!isNull(arguments.order.getAccount()) && isNull(arguments.order.getDefaultStockLocation())){
			var site = arguments.order.getAccount().getAccountCreatedSite();
			if(isNull(site)){
				site = arguments.order.getOrderCreatedSite();
			}
			if(!isNull(site) && site.hasLocation()){
				arguments.order.setDefaultStockLocation(site.getLocations()[1]);
			}
		}
		
		return arguments.order;
		
	}
 
    public any function copyToNewOrderItem(required any orderItem){
	    var newOrderItem = super.copyToNewOrderItem(orderItem);
	     for(var priceField in variables.customPriceFields){
            var price = arguments.orderItem.invokeMethod('get#priceField#',{1=priceField});
            if(!isNull(price)){
                newOrderItem.invokeMethod('set#priceField#',{1=price});
            }
        }
        return newOrderItem;
	}
    
    public any function addExchangeOrderItemSetup(required any returnOrder, required any originalOrderItem, required any processObject, required struct orderItemStruct){
			var returnOrderItem = addReturnOrderItemSetup(argumentCollection=arguments);
			var replacementOrderItem = addReplacementOrderItemSetup(argumentCollection=arguments);
			return returnOrderItem;
	}
    
    public any function addReturnOrderItemSetup(required any returnOrder, required any originalOrderItem, required any processObject, required struct orderItemStruct){
        var returnOrderItem = super.addReturnOrderItemSetup(argumentCollection=arguments);
        if(isObject(arguments.originalOrderItem)){
	        for(var priceField in variables.customPriceFields){
	            var price = arguments.originalOrderItem.invokeMethod('getCustomExtendedPriceAfterDiscount',{1=priceField});
	            if(!isNull(price)){
	            	if(arguments.originalOrderItem.getExtendedPriceAfterDiscount() != 0){
	                	price = price * returnOrderItem.getPrice() / arguments.originalOrderItem.getExtendedPriceAfterDiscount();
	            	}else{
	            		price = 0;
	            	}
	                returnOrderItem.invokeMethod('set#priceField#',{1=price});
	            } 
	        }
        }else{
        	returnOrderItem.setTaxableAmount(returnOrderItem.getPrice());
        }
        return returnOrderItem;
    }
    
    public any function addReplacementOrderItemSetup(required any returnOrder, required any originalOrderItem, required any processObject, required struct orderItemStruct){
        var replacementOrderItem = super.addReplacementOrderItemSetup(argumentCollection=arguments);
        var sku = replacementOrderItem.getSku();
        var account = replacementOrderItem.getOrder().getAccount();
        if(isNull(account)){
            account = getService('AccountService').newAccount();
        }
        
        for(var priceField in variables.customPriceFields){
            var price = arguments.originalOrderItem.invokeMethod('getCustomExtendedPriceAfterDiscount',{1=priceField});
            if(!isNull(price)){
            	if(arguments.originalOrderItem.getExtendedPriceAfterDiscount() == 0){
            		price = 0;
            	}else{
                	price = price * replacementOrderItem.getPrice() / arguments.originalOrderItem.getExtendedPriceAfterDiscount();
            	}
                replacementOrderItem.invokeMethod('set#priceField#',{1=price});
            }
        }
        return replacementOrderItem;
    }
    
    public any function updateReturnOrderWithAllocatedDiscounts(required any order, required any returnOrder, required any processObject){
		var discountAmounts = {};
		
		if(arguments.order.getSubtotalAfterItemDiscounts() != 0){
			var subtotalRatio = arguments.returnOrder.getSubtotalAfterItemDiscounts() / arguments.order.getSubtotalAfterItemDiscounts();
			var discount = arguments.order.getOrderDiscountAmountTotal() * subtotalRatio;
			var allocatedOrderDiscountAmount = getService('HibachiUtilityService').precisionCalculate(discount);
			discountAmounts['discountAmount'] = allocatedOrderDiscountAmount;
		}
		
		if(!isNull(allocatedOrderDiscountAmount) && allocatedOrderDiscountAmount < 0){

			var promotionApplied = getService('PromotionService').newPromotionApplied();
			promotionApplied.setOrder(returnOrder);
			
			if( arguments.order.hasAppliedPromotion() ){
				var originalPromo = arguments.order.getAppliedPromotions()[1].getPromotion();
				if( !isNull(originalPromo) ){
					promotionApplied.setPromotion( originalPromo );
				}
			}
			
			for(var priceField in variables.customPriceFields){
				if(arguments.order.getCustomPriceFieldSubtotalAfterItemDiscounts(priceField) > 0){
					var subtotalRatio = arguments.returnOrder.getCustomPriceFieldSubtotalAfterItemDiscounts(priceField) / arguments.order.getCustomPriceFieldSubtotalAfterItemDiscounts(priceField);
					var discount = arguments.order.getOrderCustomDiscountAmountTotal(priceField) * subtotalRatio;
					discountAmounts['#priceField#DiscountAmount'] = getService('HibachiUtilityService').precisionCalculate(discount);
				}
			}
			for(var key in discountAmounts){
				promotionApplied.invokeMethod('set#key#',{1=discountAmounts[key]});
			}
			
			promotionApplied.setManualDiscountAmountFlag(true);
			promotionApplied = getService('PromotionService').savePromotionApplied(promotionApplied);
		}

		return returnOrder;
	}

	//begin order template functionality
	private any function getOrderCreateProcessObjectForOrderTemplate(required any orderTemplate, required any order){
		var processOrderCreate = arguments.order.getProcessObject('create'); 
		processOrderCreate.setNewAccountFlag(false); 
		processOrderCreate.setAccountID(arguments.orderTemplate.getAccount().getAccountID()); 
		processOrderCreate.setCurrencyCode(arguments.orderTemplate.getCurrencyCode());
		processOrderCreate.setOrderCreatedSite(arguments.orderTemplate.getSite()); 
		processOrderCreate.setOrderTypeID('444df2df9f923d6c6fd0942a466e84cc'); //otSalesOrder			
		processOrderCreate.setOrderOriginID('2c9380846e3d64e4016e3d678ae70004'); //flexship		

		return processOrderCreate;
	}

	/**
	 * Note: we'd ctreate a temp-order from the orderTemplate, then we'd try to place it, and then remove it
	 * 
	 * Note: we're using request Scope as it's shared b/w the Request and Thread
	 * 
	 */ 
	public struct function getOrderTemplateOrderDetails(required any orderTemplate){	
		
		var orderTemplateOrderDetailsKey = "orderTemplateOrderDetails#arguments.orderTemplate.getOrderTemplateID()#"

		if(structKeyExists(request, orderTemplateOrderDetailsKey)){
			return request[orderTemplateOrderDetailsKey];
		} 
		
		request[orderTemplateOrderDetailsKey] = {}; 
		request[orderTemplateOrderDetailsKey]['fulfillmentTotal'] = 0;
		request[orderTemplateOrderDetailsKey]['fulfillmentDiscount'] = 0;
		request[orderTemplateOrderDetailsKey]['total'] = 0;
		request[orderTemplateOrderDetailsKey]['subtotal'] = 0;
		request[orderTemplateOrderDetailsKey]['discountTotal'] = 0;
		request[orderTemplateOrderDetailsKey]['taxableAmountTotal'] = 0;
		request[orderTemplateOrderDetailsKey]['personalVolumeTotal'] = 0;
		request[orderTemplateOrderDetailsKey]['commissionableVolumeTotal'] = 0;
		request[orderTemplateOrderDetailsKey]['productPackVolumeTotal'] = 0;
		request[orderTemplateOrderDetailsKey]['retailCommissionTotal'] = 0;
		request[orderTemplateOrderDetailsKey]['canPlaceOrder'] = false;
		request[orderTemplateOrderDetailsKey]['purchasePlusTotal'] = 0;
		request[orderTemplateOrderDetailsKey]['otherDiscountTotal'] = 0;
		
		request[orderTemplateOrderDetailsKey]['orderTemplate'] = arguments.orderTemplate;

		var skuCollection = getSkuService().getSkuCollectionList();
		skuCollection.addFilter('skuID', 'null', 'is'); 
		
		request[orderTemplateOrderDetailsKey]['skuCollection'] = skuCollection;
		request[orderTemplateOrderDetailsKey]['promotionalRewardSkuCollectionConfig'] = skuCollection.getCollectionConfigStruct(); 

		var threadName = "t" & getHibachiUtilityService().generateRandomID(15);	

		thread 
			name="#threadName#" 
			action="run" 
			orderTemplateOrderDetailsKey = "#orderTemplateOrderDetailsKey#" 
		{	
			var currentOrderTemplate = request[orderTemplateOrderDetailsKey]['orderTemplate'];
			var hasInfoForFulfillment = !isNull( currentOrderTemplate.getShippingMethod() ); 

			var transientOrder = getService('OrderService').newTransientOrderFromOrderTemplate( orderTemplate=currentOrderTemplate, evictFromSession=false, updateShippingMethodOptions=false );  
			//only update amounts if we can
			transientOrder = this.saveOrder( order=transientOrder, updateOrderAmounts=hasInfoForFulfillment );
			var transientOrderItems = transientOrder.getOrderItems();
			for(var orderItem in transientOrderItems){
				orderItem.updateCalculatedProperties(); 
			}
			transientOrder.updateCalculatedProperties(); 	
			getHibachiDAO().flushORMSession();

			var transientOrderFulfillments = transientOrder.getOrderFulfillments();
			for(var orderFulfillment in transientOrderFulfillments){
				getService('ShippingService').updateOrderFulfillmentShippingMethodOptions(orderFulfillment, false);
			}
		
			if(hasInfoForFulfillment){	
				request[orderTemplateOrderDetailsKey]['fulfillmentTotal'] = transientOrder.getFulfillmentTotal(); 
				request[orderTemplateOrderDetailsKey]['fulfillmentDiscount'] = transientOrder.getFulfillmentDiscountAmountTotal(); 
			}
	
			request[orderTemplateOrderDetailsKey]['subtotal'] = transientOrder.getSubtotal();
			request[orderTemplateOrderDetailsKey]['discountTotal'] = transientOrder.getDiscountTotal();
			request[orderTemplateOrderDetailsKey]['total'] = transientOrder.getTotal();
			request[orderTemplateOrderDetailsKey]['taxableAmountTotal'] = transientOrder.getTaxableAmountTotal();
			request[orderTemplateOrderDetailsKey]['personalVolumeTotal'] = transientOrder.getPersonalVolumeSubtotal();
			request[orderTemplateOrderDetailsKey]['commissionableVolumeTotal'] = transientOrder.getCommissionableVolumeSubtotal(); 
			request[orderTemplateOrderDetailsKey]['productPackVolumeTotal'] = transientOrder.getProductPackVolumeSubtotal();
			request[orderTemplateOrderDetailsKey]['retailCommissionTotal'] = transientOrder.getRetailCommissionSubtotal();

			var freeRewardSkuCollection = getSkuService().getSkuCollectionList();
			var freeRewardSkuIDs = getPromotionService().getQualifiedFreePromotionRewardSkuIDs(transientOrder);
			freeRewardSkuCollection.addFilter('skuID', freeRewardSkuIDs, 'in');
			request[orderTemplateOrderDetailsKey]['promotionalFreeRewardSkuCollectionConfig'] = freeRewardSkuCollection.getCollectionConfigStruct(); 	

			request[orderTemplateOrderDetailsKey]['skuCollection'].setCollectionConfigStruct( getPromotionService().getQualifiedPromotionRewardSkuCollectionConfigForOrder(transientOrder) );
			request[orderTemplateOrderDetailsKey]['skuCollection'].addFilter('skuID', freeRewardSkuIDs, 'not in');
			request[orderTemplateOrderDetailsKey]['promotionalRewardSkuCollectionConfig'] = request[orderTemplateOrderDetailsKey]['skuCollection'].getCollectionConfigStruct();
			
			request[orderTemplateOrderDetailsKey]['canPlaceOrderDetails'] = getPromotionService().getOrderQualifierDetailsForCanPlaceOrderReward(transientOrder); 
			request[orderTemplateOrderDetailsKey]['canPlaceOrder'] = request[orderTemplateOrderDetailsKey]['canPlaceOrderDetails']['canPlaceOrder']; 
			request[orderTemplateOrderDetailsKey]['purchasePlusTotal'] = transientOrder.getPurchasePlusTotal();
			request[orderTemplateOrderDetailsKey]['otherDiscountTotal'] = transientOrder.getDiscountTotal() - transientOrder.getPurchasePlusTotal();

			request[orderTemplateOrderDetailsKey]['taxTotal'] = transientOrder.getTaxTotal();
			request[orderTemplateOrderDetailsKey]['vatTotal'] = transientOrder.getVatTotal();
			request[orderTemplateOrderDetailsKey]['fulfillmentHandlingFeeTotal'] = transientOrder.getFulfillmentHandlingFeeTotal();
			
			try{
				request[orderTemplateOrderDetailsKey]['appliedPromotionMessagesJson'] = serializeJson(this.getAppliedPromotionMessageData(transientOrder.getOrderID()).getRecords());
			}catch(any e){
				this.logHibachi('there as an error in serializing Promotion Messages at line 397 in custom order service',true);
				request[orderTemplateOrderDetailsKey]['appliedPromotionMessagesJson'] = '[]'; // keeping return value uniform in case of error
			}
			var deleteOk = this.deleteOrder(transientOrder); 
			this.logHibachi('transient order deleted #deleteOk# hasErrors #transientOrder.hasErrors()#',true);
			ormFlush();
			StructDelete(request[orderTemplateOrderDetailsKey], 'orderTemplate'); //we don't need it anymore
			
		}
		
		//join thread so we can return synchronously
		threadJoin(threadName);
		
		//if we have any error we probably don't have the required data for returning the total
		if(structKeyExists(evaluate(threadName), "ERROR")){
			this.logHibachi('encountered error in get Fulfillment Total For Order Template: #arguments.orderTemplate.getOrderTemplateID()# and e: #serializeJson(evaluate(threadName).error)#',true);
		} 

		return request[orderTemplateOrderDetailsKey];
	}
	
	public numeric function getRetailCommissionTotalForOrderTemplate(required any orderTemplate){
		return getOrderTemplateOrderDetails(argumentCollection=arguments)['retailCommissionTotal'];	
	}
	
	public any function getOrderTemplateItemCollectionForAccount(required struct data, any account=getHibachiScope().getAccount()){
        param name="arguments.data.pageRecordsShow" default=5;
        param name="arguments.data.currentPage" default=1;
        param name="arguments.data.orderTemplateID" default="";
		param name="arguments.data.orderTemplateTypeID" default="2c948084697d51bd01697d5725650006"; 
		param name="arguments.data.nullAccountFlag" default=false;
		
		var orderTemplateItemCollection = this.getOrderTemplateItemCollectionList();
		
		var displayProperties = 'calculatedListPrice,total,orderTemplateItemID,skuProductURL,quantity,sku.skuCode,sku.imagePath,sku.product.productName,sku.skuDefinition,orderTemplate.currencyCode,temporaryFlag,sku.skuID';  

		//TODO: These are throwing exception ,skuAdjustedPricing.adjustedPriceForAccount,skuAdjustedPricing.vipPrice

		orderTemplateItemCollection.setDisplayProperties(displayProperties);
		orderTemplateItemCollection.setPageRecordsShow(arguments.data.pageRecordsShow);
		orderTemplateItemCollection.setCurrentPageDeclaration(arguments.data.currentPage); 
		
		orderTemplateItemCollection.addFilter('orderTemplate.orderTemplateType.typeID', arguments.data.orderTemplateTypeID);
		orderTemplateItemCollection.addFilter('orderTemplate.orderTemplateID', arguments.data.orderTemplateID);
		if(arguments.data.nullAccountFlag){
			orderTemplateItemCollection.addFilter('orderTemplate.account', 'NULL', 'IS');
		}else{
			orderTemplateItemCollection.addFilter('orderTemplate.account.accountID', arguments.account.getAccountID());
		}

		return orderTemplateItemCollection;	
	} 
	
	public struct function getAssociatedOFYProductForFlexship(required string orderTemplateID){
		var orderTemplateItemCollectionList = this.getOrderTemplateItemCollectionForAccount(
												data= { 'orderTemplateID'= arguments.orderTemplateID}
											);
		orderTemplateItemCollectionList.addFilter('temporaryFlag', true);
		
		var records = orderTemplateItemCollectionList.getRecords();
		if( ArrayLen(records) ) {  return records[1]; } //there should be only one record at max;  
		return {};
	}

    public void function updateOrderStatusBySystemCode(required any order, required string systemCode, string typeCode='') {

        var orderType        = arguments.order.getOrderType();
        var currentOrderStatusType  = arguments.order.getOrderStatusType();
        
        /** 
         * if order is locked it can go back and forth b/w processsing1 and processing2 status 
         * but if that's not the case, we're checking further
        */ 
        if( 
        	arguments.order.getIsLockedInProcessingFlag() && 
        	( !ListFindNoCase( 'processing1,processing2', arguments.typeCode)  || arguments.systemCode != 'ostProcessing') 
        ) {

	        /** 
	         * Note:
	         * there're validations in place, but added these extra checks, 
	         * to prevent accidental order-status updates, as this's not a process/method
	        */
	        
        	if( arguments.order.getIsLockedInProcessingOneFlag() && arguments.systemCode != 'ostCanceled') {
	        	
	        	 logHibachi("Attempted to update an order's status to #arguments.systemCode# and #arguments.typeCode#, while order is locked in processing-1 ");
	        	 return; // any-order can only go to cancel status, after fulfilling these conditions
	        	 
        	} else if( arguments.order.getIsLockedInProcessingTwoFlag()) {
        		
        		if( arguments.systemCode == 'ostProcessing' && ListFindNoCase('rmaApproved,rmaReceived', arguments.typeCode ) ){
        			
        			logHibachi("Attempted to update an order's status to pstProcessing and #arguments.typeCode#, while order is locked in processing-2 ");
        			return; // rma can only got to approved/received status, after fulfilling these conditions
        		
        		} else if(arguments.systemCode != 'ostClosed') {
        			
        			logHibachi("Attempted to update an order's status to #arguments.systemCode# and #arguments.typeCode#, while order is locked in processing-2 ");
        			return; // or sales-order/rma can only go to close status, after fulfilling these conditions 
     
        		}
        	} 
        	
		}
        
        // All new sales and return orders will appear as "Entered"
       
        if (arguments.systemCode == 'ostNotPlaced' && isNull(currentOrderStatusType)) {

            arguments.order.setOrderStatusType( getTypeService().getTypeBySystemCode(systemCode=arguments.systemCode));
        	
        } else if (arguments.systemCode == 'ostOnHold') {

            arguments.order.setOrderStatusType( getTypeService().getTypeBySystemCode(systemCode=arguments.systemCode));

        } else if (arguments.systemCode == 'ostCanceled') {

            arguments.order.setOrderStatusType( getTypeService().getTypeBySystemCode(systemCode=arguments.systemCode, typeCode="9"));

        } else if (arguments.systemCode == 'ostClosed') {
			
			if(orderType.getSystemCode() == 'otSalesOrder' || orderType.getSystemCode() == 'otReplacementOrder') {
				// closed(shipped) orders
	            arguments.order.setOrderStatusType( getTypeService().getTypeBySystemCode(systemCode=arguments.systemCode, typeCode="5"));
			} else {
				// RMA closed orders
	            arguments.order.setOrderStatusType( getTypeService().getTypeBySystemCode(systemCode=arguments.systemCode, typeCode="rmaReleased"));
			}
			
        	getService("hibachiEventService").announceEvent(eventName="afterOrderProcess_OrderCloseSuccess", eventData={ entity: arguments.order, order: arguments.order, data: {} });
        	
        } else if (arguments.systemCode == 'ostNew') {

			//if the order is paid don't set to new, otherwise set to new
			if (  arguments.order.getPaymentAmountDue() <= 0  && orderType.getSystemCode() == 'otSalesOrder' ){
				//type for PaidOrder  systemCode=ostProcessing, typeCode=2
				arguments.order.setOrderStatusType( getTypeService().getTypeBySystemCode( systemCode='ostProcessing', typeCode="2")); 
			} else {
				// type for newOrder systemCode=ostProcessing, typeCode=1
				arguments.order.setOrderStatusType( getTypeService().getTypeBySystemCode( systemCode=arguments.systemCode, typeCode="1")); 
			}
				
        } else if (arguments.systemCode == 'ostProcessing') {
			
			if (orderType.getSystemCode() == 'otSalesOrder'){
				
				if(currentOrderStatusType.getSystemCode() == 'ostNew' && arguments.order.getPaymentAmountDue() <= 0) {

					arguments.order.setOrderStatusType( getTypeService().getTypeBySystemCode( systemCode=arguments.systemCode, typeCode="2"));
				
				} else {
					
					// we should narrow down the flow of status here
					if (len(arguments.typeCode) ) {
						
						// all processing status allowed when called with a specific typecode
						arguments.order.setOrderStatusType( getTypeService().getTypeBySystemCode( systemCode=arguments.systemCode, typeCode=arguments.typeCode) );
						
					} else if( currentOrderStatusType.getSystemCode() == 'ostClosed') {
						
						//reopening closed-order, which is ostProcessing
	                	arguments.order.setOrderStatusType(getTypeService().getTypeBySystemCode(systemCode='ostProcessing'));
					}
					
	            }
			        // Return Orders
	        } else if (listFindNoCase('otReturnOrder,otExchangeOrder,otReplacementOrder,otRefundOrder', orderType.getSystemCode()) ){
	            
	            if (arguments.typeCode == 'rmaApproved'){
	
	                arguments.order.setOrderStatusType(
    	                    this.getTypeService().getTypeBySystemCode(systemCode='ostProcessing', typeCode="rmaApproved")
    	                );
	               
				} else if( listFindNoCase('otReplacementOrder,otExchangeOrder', orderType.getSystemCode()) ){
	
	            	arguments.order.setOrderStatusType(
    	            	    this.getTypeService().getTypeBySystemCode(systemCode=arguments.systemCode, typeCode=arguments.typeCode)
    	            	);
	            	
	            } else if( currentOrderStatusType.getSystemCode() == 'ostNew' // only if it's a new RMA order it can be received
	                            && ( !len(arguments.typeCode) || arguments.typeCode == 'rmaReceived' ) 
	            ){
	                
	                arguments.order.setOrderStatusType(
    	                    this.getTypeService().getTypeBySystemCode(systemCode=arguments.systemCode, typeCode="rmaReceived")
    	               );
	  
	            }
	        }

        }
        
        if (arguments.systemCode != "ostNotPlaced" && !isNull(currentOrderStatusType) && currentOrderStatusType.getTypeID() != arguments.order.getOrderStatusType().getTypeID()){
            // create status change history.
            var orderStatusHistory = this.newOrderStatusHistory();
            orderStatusHistory.setOrder(arguments.order);
            orderStatusHistory.setChangeDateTime(now());
			orderStatusHistory.setOrderStatusHistoryType(arguments.order.getOrderStatusType());
            this.saveOrderStatusHistory(orderStatusHistory);
        }
    }

	//Return data: order fulfillments, order payments, order items, order 
	public any function getOrderItemsHeavy(struct data={}) {
        param name="arguments.data.orderID" default="";
        param name="arguments.data.accountID" default=getHibachiSCope().getAccount().getAccountID();
        param name="arguments.data.currentPage" default=1;
        param name="arguments.data.pageRecordsShow" default=10;
        
        var order = this.getOrder(arguments.data.orderID);
        
        //order refund data
		if(listFindNoCase('otReturnOrder,otExchangeOrder,otRefundOrder',order.getOrderType().getSystemCode())){
			var orderRefundTotal = precisionEvaluate(order.getPaymentAmountCreditedTotal() - order.getPaymentAmountReceivedTotal());
		}else{
			var orderRefundTotal = ''
		}
		
		///Order Item Data
		var ordersItemsList = this.getOrderItemCollectionList();
		ordersItemsList.setDisplayProperties('quantity,price,calculatedListPrice,calculatedExtendedPriceAfterDiscount,sku.product.productName,sku.product.productID,sku.product.productType.systemCode,sku.skuID,skuProductURL,skuImagePath,orderFulfillment.shippingAddress.streetAddress,orderFulfillment.shippingAddress.street2Address,orderFulfillment.shippingAddress.city,orderFulfillment.shippingAddress.stateCode,orderFulfillment.shippingAddress.postalCode,orderFulfillment.shippingAddress.name,orderFulfillment.shippingAddress.countryCode,orderFulfillment.shippingMethod.shippingMethodName,orderFulfillment.handlingFee,orderFulfillment.fulfillmentCharge');
		ordersItemsList.addFilter( 'order.orderID', arguments.data.orderID, '=');
		ordersItemsList.addFilter( 'order.account.accountID', arguments.data.accountID, '=');
		ordersItemsList.addFilter('showInCartFlag', 0, '!=');
		ordersItemsList.setPageRecordsShow(arguments.data.pageRecordsShow);
		ordersItemsList.setCurrentPageDeclaration(arguments.data.currentPage); 
		
		//Order payment data
		var orderPaymentList = this.getOrderPaymentCollectionList();
		orderPaymentList.setDisplayProperties('paymentMethod.paymentMethodType,paymentMethod.paymentMethodName,currencyCode,billingAddress.streetAddress,billingAddress.street2Address,billingAddress.city,billingAddress.stateCode,billingAddress.postalCode,billingAddress.name,billingAddress.countryCode,expirationMonth,expirationYear,order.calculatedFulfillmentTotal,order.calculatedSubTotal,order.calculatedVATTotal,order.calculatedTaxTotal,order.calculatedDiscountTotal,order.calculatedTotal,order.orderCountryCode,order.orderNumber,order.orderStatusType.typeName,order.calculatedPersonalVolumeTotal,order.calculatedPersonalVolumeSubtotal,creditCardLastFour,order.orderType.typeName');
		orderPaymentList.addFilter( 'order.orderID', arguments.data.orderID, '=');
		orderPaymentList.addFilter( 'order.account.accountID', arguments.data.accountID, '=');
		orderPaymentList.setPageRecordsShow(arguments.data.pageRecordsShow);
		orderPaymentList.setCurrentPageDeclaration(arguments.data.currentPage); 	
		
		//Order promotion data
		var orderPromotionList = getHibachiScope().getService('promotionService').getPromotionAppliedCollectionList();
		orderPromotionList.addDisplayProperties('discountAmount,currencyCode,promotion.promotionName');
		orderPromotionList.addFilter( 'order.orderID', arguments.data.orderID, '=');
		
		//Tracking info
		var orderDeliveriesList = this.getOrderDeliveryCollectionList();
		orderDeliveriesList.setDisplayProperties('trackingUrl');
		orderDeliveriesList.addFilter( 'order.orderID', arguments.data.orderID, '=');
		
		var orderPayments = orderPaymentList.getPageRecords();
		var orderItems = ordersItemsList.getPageRecords();
		var orderPromotions = orderPromotionList.getPageRecords();
		var orderDeliveries = orderDeliveriesList.getPageRecords();
		var orderItemData = {};
		
		orderItemData['orderPayments'] = orderPayments;
		orderItemData['orderItems'] = orderItems;
		orderItemData['orderPromotions'] = orderPromotions;
		orderItemData['orderRefundTotal'] = orderRefundTotal;
		orderItemData['purchasePlusTotal'] = order.getPurchasePlusTotal();
		
		if ( len( orderDeliveries ) ) {
			orderItemData['orderDelivery'] = orderDeliveries[1];
		}
		
		return orderItemData
    }
    
    public void function updateOrderItemsWithAllocatedOrderDiscountAmount(required any order) {
        super.updateOrderItemsWithAllocatedOrderDiscountAmount(arguments.order);
        
        for(var priceField in variables.customPriceFields){
            this.updateOrderItemsWithAllocatedOrderCustomPriceFieldDiscountAmount(arguments.order, priceField);
        }
        
    }
        
    public void function updateOrderItemsWithAllocatedOrderCustomPriceFieldDiscountAmount(required any order, required any priceField) {
		
		/*
		logHibachi("updateOrderItemsWithAllocatedOrderCustomPriceFieldDiscountAmount(#arguments.priceField#): START",true);
		logHibachi("order['orderID']: #arguments.order.getOrderID()#",true);
		logHibachi("order['orderAmounts.#arguments.priceField#SubtotalAfterItemDiscounts']: #arguments.order.getCustomPriceFieldSubtotalAfterItemDiscounts(arguments.priceField)#",true);
		logHibachi("order['orderAmounts.#arguments.priceField#DiscountTotal']: #arguments.order.getOrderCustomDiscountAmountTotal(arguments.priceField)#",true);
		*/
		
		// Allocate the order-level discount amount total in appropriate proportions to all order items and if necessary handle any remainder due to uneven division
		var actualAllocatedAmountTotal = 0;
		var actualAllocatedAmountAsPercentage = 0;
		var orderItemCount = 0;
		for (var orderItem in arguments.order.getOrderItems()) {
		    if(arguments.order.getCustomPriceFieldSubtotalAfterItemDiscounts(arguments.priceField) == 0){
		        orderItem.invokeMethod('setAllocatedOrder#arguments.priceField#DiscountAmount',{1=0});
		        continue;
		    }
			orderItemCount++;
			
			// The percentage of overall order discount that needs to be properly allocated to the order item. This is to perform weighted calculations.
			var currentOrderItemAmountAsPercentage = orderItem.getCustomExtendedPriceAfterDiscount(arguments.priceField) / arguments.order.getCustomPriceFieldSubtotalAfterItemDiscounts(arguments.priceField);
			
			// Approximate amount to allocate (rounded to nearest penny)
		    var currentOrderItemAllocationAmount = round(currentOrderItemAmountAsPercentage * arguments.order.getOrderCustomDiscountAmountTotal(arguments.priceField) * 100) / 100;
		    
		    var actualAllocatedAmountTotalUnadjusted = actualAllocatedAmountTotal + currentOrderItemAllocationAmount;
		    
		    // Recalculated each iteration for maximum precision of how much is expected to have been allocated at current stage in process
		    var expectedAllocatedAmountTotal = (actualAllocatedAmountAsPercentage + currentOrderItemAmountAsPercentage) * arguments.order.getOrderCustomDiscountAmountTotal(arguments.priceField);
			
			// Rather than letting a sum of discrepancies accumulate during each iteration and become a significant adjustment to the final order item, lets handle it immediately and make minor adjustment to order item
			// This allows the discrepancy of no more than a cent to be accumulated, and appropriately allocated to the current order item when it first appears
			// NOTE: If instead we deferred handling the discrepancy the likelihood that a noticeable discrepancy will need to be offset on the final order item increases as the number of order items increases on an order.
		    var currentDiscrepancyAmount =  actualAllocatedAmountTotalUnadjusted - expectedAllocatedAmountTotal;
		    
		    // If there is a discrepancy greater than 1/2 cent let's deal with it now, adjust the allocation amount by rounding up or down to nearest cent
		    if (abs(currentDiscrepancyAmount) >= .005) {
		    	// Need to decrease the allocation amount by a cent to prevent over allocating
		        if (currentDiscrepancyAmount > 0) {
		            currentOrderItemAllocationAmount = (ceiling(currentOrderItemAllocationAmount * 100) - 1) / 100;
		            
		        // Need to increase the allocation by a cent to prevent under allocating 
		        } else if (currentDiscrepancyAmount < 0) {
		            currentOrderItemAllocationAmount = (floor(currentOrderItemAllocationAmount * 100) + 1) / 100;
		        }
		    }
		    
		    // Update the actuals to retain maximum precision
		    actualAllocatedAmountTotal += currentOrderItemAllocationAmount;
		    actualAllocatedAmountAsPercentage += currentOrderItemAmountAsPercentage;
		    
		    // Finally update the order item
		    orderItem.invokeMethod('setAllocatedOrder#arguments.priceField#DiscountAmount',{1=currentOrderItemAllocationAmount});
		    
		    /*
		    // Collect details for debugging/logging
		    logHibachi("orderItem[#orderItemCount#]: Start",true);
		    logHibachi("orderItem[#orderItemCount#]['extended#arguments.priceField#AfterOrderItemDiscount']: #orderItem.getCustomExtendedPriceAfterDiscount(arguments.priceField)#",true);
		    logHibachi("orderItem[#orderItemCount#]['currentOrderItemAmountAsPercentage']: #currentOrderItemAmountAsPercentage * 100#",true);
		    logHibachi("orderItem[#orderItemCount#]['currentOrderItemAllocationAmount']: #round(currentOrderItemAmountAsPercentage * arguments.order.getOrderDiscountAmountTotal() * 100) / 100#",true);
		    logHibachi("orderItem[#orderItemCount#]['currentOrderItemAllocationAmountAdjusted']: #currentOrderItemAllocationAmount#",true);
		    logHibachi("orderItem[#orderItemCount#]['currentDiscrepancy.expectedAllocatedAmountTotal']: #expectedAllocatedAmountTotal#",true);
		    logHibachi("orderItem[#orderItemCount#]['currentDiscrepancy.actualAllocatedAmountTotalUnadjusted']: #actualAllocatedAmountTotalUnadjusted#",true);
		    logHibachi("orderItem[#orderItemCount#]['currentDiscrepancy.actualAllocatedAmountTotal']: #actualAllocatedAmountTotal#",true);
		    logHibachi("orderItem[#orderItemCount#]['currentDiscrepancy.currentDiscrepancyAmount']: #currentDiscrepancyAmount#",true);
		    logHibachi("orderItem[#orderItemCount#]['overallProgress.actualAllocatedAmountAsPercentage']: #actualAllocatedAmountAsPercentage  * 100#",true);
		    logHibachi("orderItem[#orderItemCount#]['overallProgress.actualAllocatedAmountTotal']: #actualAllocatedAmountTotal#",true);
		    */
		}
		
		logHibachi("updateOrderItemsWithAllocatedOrderDiscountAmount: END");
		
		// We are expecting an exact allocation. No discrepancy, if this occurs we need to figure out why
		if (val(actualAllocatedAmountTotal) - val(arguments.order.getOrderCustomDiscountAmountTotal(arguments.priceField)) != 0) {
			logHibachi("ATTN: There was a discrepancy while attempting to allocate the order discount amount to the order items of orderID '#arguments.order.getOrderID()#'. The result of the allocation was '#actualAllocatedAmountTotal#' of the '#arguments.order.getOrderDiscountAmountTotal()#' total order discount amount. Further investigation is needed to correct the calculation issue.", true);
		}

    }
    
    public string function getSimpleRepresentation(required any order){
		if(!isNull(arguments.order.getOrderNumber()) && len(arguments.order.getOrderNumber())) {
			var representation = arguments.order.getOrderNumber();
		} else {
			var representation = rbKey('define.cart');
		}

		if(!isNull(arguments.order.getAccount())) {
			representation &= " - #arguments.order.getAccount().getSimpleRepresentation()#";
		}

		return representation;
	}
	
	public any function processOrder_releaseCredits(required any order, any processObject, struct data){
        if(arguments.processObject.getPersonalVolumeDiscount() < 0 || arguments.processObject.getCommissionableVolumeDiscount() < 0){
            var promotionApplied = getService('PromotionService').newPromotionApplied();
			promotionApplied.setOrder(arguments.order);
			promotionApplied.setPersonalVolumeDiscountAmount(arguments.processObject.getPersonalVolumeDiscount());
			promotionApplied.setCommissionableVolumeDiscountAmount(arguments.processObject.getCommissionableVolumeDiscount());
			promotionApplied.setManualDiscountAmountFlag(true);
			promotionApplied = getService('PromotionService').savePromotionApplied(promotionApplied);
        }
	    
	    arguments.order = super.processOrder_releaseCredits(argumentCollection=arguments);
	    if(!order.hasErrors()){
	    	arguments.order.setOrderStatusType(getService('TypeService').getTypeByTypeCode('rmaReleased'));
	    	getHibachiScope().flushORMSession();
	    }
	    return order;
	}
	
	public any function processOrder_approveReturn(required any order, required struct data){
		
	    if(!isNull(arguments.data.orderItems) &&arrayLen(arguments.data.orderItems)){
	        for(var orderItemStruct in arguments.data.orderItems){
	            var orderItem = this.getOrderItem(orderItemStruct.orderItemID);
	            orderItem.setQuantity(orderItemStruct.quantity);
	        }
	    }
	    this.processOrder(arguments.order,'updateOrderAmounts');
	    this.updateOrderStatusBySystemCode(arguments.order, "ostProcessing", "rmaApproved");

	    return order;
	}

	public any function processOrder_placeInProcessingOne(required any order, struct data) {
		this.updateOrderStatusBySystemCode(arguments.order, "ostProcessing", "processing1");
		return arguments.order;
	}
	
	public any function processOrder_placeInProcessingTwo(required any order, struct data) {
		this.updateOrderStatusBySystemCode(arguments.order, "ostProcessing", "processing2");
		return arguments.order;
	}
	
	
	/**
	 * ***************.BEGIN. Custom Process Methods for Workflows *****************
	*/ 
	public any function processOrder_placeInProcessingTwoAll(required any order, struct data) {
		param name="arguments.data.siteID" default = "";
		
		this.getOrderDAO().placeOrdersInProcessingTwo(data = arguments.data);
		return arguments.order;
	}
	
	public any function processOrder_placeInProcessingTwoUS(required any order, struct data) {
		param name="arguments.data" default = {};
		arguments.data['siteID'] = getSiteService().getSiteBySiteCode('mura-default').getSiteID();
		return this.processOrder_placeInProcessingTwoAll(argumentCollection = arguments);
	}
	
	public any function processOrder_placeInProcessingTwoUK(required any order, struct data) {
		param name="arguments.data" default = {};
		arguments.data['siteID'] = getSiteService().getSiteBySiteCode('mura-uk').getSiteID();
		return this.processOrder_placeInProcessingTwoAll(argumentCollection = arguments);
	}
	
	public any function processOrder_placeInProcessingTwoAU(required any order, struct data) {
		param name="arguments.data" default = {};
		arguments.data['siteID'] = getSiteService().getSiteBySiteCode('mura-au').getSiteID();
		return this.processOrder_placeInProcessingTwoAll(argumentCollection = arguments);
	}
	
	public any function processOrder_placeInProcessingTwoIRE(required any order, struct data) {
		param name="arguments.data" default = {};
		arguments.data['siteID'] = getSiteService().getSiteBySiteCode('mura-ie').getSiteID();
		return this.processOrder_placeInProcessingTwoAll(argumentCollection = arguments);
	}
	
	public any function processOrder_placeInProcessingTwoPOL(required any order, struct data) {
		param name="arguments.data" default = {};
		arguments.data['siteID'] = getSiteService().getSiteBySiteCode('mura-pl').getSiteID();
		return this.processOrder_placeInProcessingTwoAll(argumentCollection = arguments);
	}
	
	public any function processOrder_placeInProcessingTwoCAN(required any order, struct data) {
		param name="arguments.data" default = {};
		arguments.data['siteID'] = getSiteService().getSiteBySiteCode('mura-ca').getSiteID();
		return this.processOrder_placeInProcessingTwoAll(argumentCollection = arguments);
	}
	
	/**
	 * ***************.END. Custom Process Methods for Workflows *****************
	*/ 
	
	// =================== START: Validation Helpers Functions ========================
		
	public boolean function orderCanBeCanceled(required any order){
		
		if(!super.orderCanBeCanceled(arguments.order) || arguments.order.getIsLockedInProcessingTwoFlag()) {
			return false;
		}
		//order can be canceled in processing-1, but not in processing-2
		
		return true;
	}
		
	// =================== END: Validation Helpers Functions ========================

	

	public any function processOrderDelivery_markOrderUndeliverable(required any orderDelivery, struct data={}){ 
		
		var orderDeliveryStatusType = getService("TypeService").getTypeByTypeCode("odstUndeliverable");
		
		if (structKeyExists(data, "undeliverableOrderReason") && !isNull(orderDeliveryStatusType)){
		    arguments.orderDelivery.setUndeliverableOrderReason(data.undeliverableOrderReason);
		    arguments.orderDelivery.setOrderDeliveryStatusType(orderDeliveryStatusType);
		}
		
		arguments.orderDelivery = this.saveOrderDelivery(arguments.orderDelivery);
		getHibachiScope().flushORMSession();
		
		return arguments.orderDelivery;
	}
	
	
	public boolean function orderHasMPRenewalFee(required orderID) {
		var renewalFeeMPProductType = getService('productService').getProductTypeBySystemCode('RenewalFee-MP');
		
		var orderItemCollectionList = this.getOrderItemCollectionList();
		orderItemCollectionList.setDisplayProperties('orderItemID');
		orderItemCollectionList.addFilter('order.orderID', "#arguments.orderID#");
		orderItemCollectionList.addFilter('sku.product.productType.productTypeIDPath','#renewalFeeMPProductType.getProductTypeIDPath()#%','Like');
		
		return orderItemCollectionList.getRecordsCount(true) > 0;
	}
	
	public boolean function orderHasProductPack(required orderID) {

		var productPackProductType = getService('productService').getProductTypeBySystemCode('ProductPack');
		
		var orderItemCollectionList = this.getOrderItemCollectionList();
		orderItemCollectionList.setDisplayProperties('orderItemID');
		orderItemCollectionList.addFilter('order.orderID', "#arguments.orderID#");
		orderItemCollectionList.addFilter('sku.product.productType.productTypeIDPath','#productPackProductType.getProductTypeIDPath()#%','Like');
		
		return orderItemCollectionList.getRecordsCount(true) > 0;
	}
	
	public boolean function orderTemplateQualifiesForOFYProducts(required any orderTemplate) {
		
		if( 
			arguments.orderTemplate.getTypeCode() != 'ottSchedule'  || 
			arguments.orderTemplate.getStatusCode() == 'otstCancelled' 
		){
			return false;
		}
		
		if( arguments.orderTemplate.getSubtotal() < arguments.orderTemplate.getCartTotalThresholdForOFYAndFreeShipping()){
		 	return false;
		}
		 
        var orderTemplateItemCollectionList = this.getOrderTemplateItemCollectionList();
        orderTemplateItemCollectionList.addFilter(
        	'orderTemplate.orderTemplateID', 
        	arguments.orderTemplate.getOrderTemplateID()
        );
        orderTemplateItemCollectionList.addFilter('temporaryFlag', true);
        
		if( orderTemplateItemCollectionList.getRecordsCount( refresh=true ) > 0 ){
			// there's only one Free-item is allowed per order, per flexship, 
			// and that get's removed every time there a new-order-placed for the Flexship
			return false; 
		}
		
		
		//This is an expensive check, so we do it at the last
		var promotionalFreeRewardSkuCollection = getService('SkuService').getSkuCollectionList();
		promotionalFreeRewardSkuCollection.setCollectionConfigStruct(
			arguments.orderTemplate.getPromotionalFreeRewardSkuCollectionConfig()
		);
		
		return promotionalFreeRewardSkuCollection.getRecordsCount( refresh=true ) > 0;
	}
	
	
	public any function deleteOrderTemplate( required any orderTemplate ) {
		
		if( getHibachiSCope().getCurrentFlexshipID() == arguments.orderTemplate.getOrderTemplateID() ){
			getHibachiScope().clearCurrentFlexship();
		}
		return super.delete( arguments.orderTemplate );
	}

	public any function processVolumeRebuildBatch_create(required any volumeRebuildBatch, required any processObject){
		var volumeRebuildBatchOrders = arguments.processObject.getVolumeRebuildBatchOrders();
		
		for(var volumeRebuildBatchOrder in volumeRebuildBatchOrders){
			var order = volumeRebuildBatchOrder.getOrder();
			var orderItems = order.getOrderItems();
			for(var orderItem in orderItems){
				var volumeRebuildBatchOrderItem = this.newVolumeRebuildBatchOrderItem();
				volumeRebuildBatchOrderItem.setOrderItem(orderItem);
				volumeRebuildBatchOrderItem.setSkuCode(orderItem.getSku().getSkuCode());
				volumeRebuildBatchOrderItem.setVolumeRebuildBatchOrder(volumeRebuildBatchOrder);
				volumeRebuildBatchOrderItem.setVolumeRebuildBatch(volumeRebuildBatch);
				for(var customPriceField in variables.customPriceFields){
					volumeRebuildBatchOrderItem.invokeMethod('setOld#customPriceField#',{1=orderItem.invokeMethod('get#customPriceField#')});
				}
				this.saveVolumeRebuildBatchOrderItem(volumeRebuildBatchOrderItem);
			}
			this.saveVolumeRebuildBatchOrder(volumeRebuildBatchOrder);
		}
		arguments.volumeRebuildBatch.setVolumeRebuildBatchStatusType(getService('TypeService').getTypeByTypeCode('vrbstNew'));
		if(!isNull(arguments.processObject.getVolumeRebuildBatchName())){
			arguments.volumeRebuildBatch.setVolumeRebuildBatchName(arguments.processObject.getVolumeRebuildBatchName());
		}
		this.saveVolumeRebuildBatch(arguments.volumeRebuildBatch);
		return arguments.volumeRebuildBatch;
	}
	
	public any function processVolumeRebuildBatch_process(required any volumeRebuildBatch){
		var volumeRebuildBatchOrders = arguments.volumeRebuildBatch.getVolumeRebuildBatchOrders();
		
		for(var volumeRebuildBatchOrder in volumeRebuildBatchOrders){
			var volumeRebuildBatchOrderItems = volumeRebuildBatchOrder.getVolumeRebuildBatchOrderItems();
			for(var volumeRebuildBatchOrderItem in volumeRebuildBatchOrderItems){
				var orderItem = volumeRebuildBatchOrderItem.getOrderItem();
				for(var customPriceField in variables.customPriceFields){
					orderItem.invokeMethod('remove#customPriceField#');
					volumeRebuildBatchOrderItem.invokeMethod('setNew#customPriceField#',{1=orderItem.invokeMethod('get#customPriceField#')});
				}
			}
		}
		arguments.volumeRebuildBatch.setVolumeRebuildBatchStatusType(getService('TypeService').getTypeByTypeCode('vrbstProcessed'));
		return arguments.volumeRebuildBatch;
	}
	
	
		// Process: Order
	public any function processOrder_addOrderItem(required any order, required any processObject){
		getHibachiScope().addExcludedModifiedEntityName('TaxApplied');
		getHibachiScope().addExcludedModifiedEntityName('PromotionApplied');
		// Setup a boolean to see if we were able to just add this order item to an existing one
		var foundItem = false;

		// Make sure that the currencyCode gets set for this order
		if(isNull(arguments.order.getCurrencyCode())) {
			arguments.order.setCurrencyCode( arguments.processObject.getCurrencyCode() );
		}

		// If this is a Sale Order Item then we need to setup the fulfillment
		if(listFindNoCase("oitSale,oitDeposit",arguments.processObject.getOrderItemTypeSystemCode())) {

			// First See if we can use an existing order fulfillment
			var orderFulfillment = arguments.processObject.getOrderFulfillment();
			// Next if orderFulfillment is still null, then we can check the order to see if there is already an orderFulfillment
			if(isNull(orderFulfillment) && ( isNull(processObject.getOrderFulfillmentID()) || processObject.getOrderFulfillmentID() != 'new' ) && arrayLen(arguments.order.getOrderFulfillments())) {
				for(var f=1; f<=arrayLen(arguments.order.getOrderFulfillments()); f++) {
					if(listFindNoCase(arguments.processObject.getSku().setting('skuEligibleFulfillmentMethods'), arguments.order.getOrderFulfillments()[f].getFulfillmentMethod().getFulfillmentMethodID()) ) {
						var orderFulfillment = arguments.order.getOrderFulfillments()[f];
						break;
					}
				}
			}

			// Last if we can't use an existing one, then we need to create a new one
			if(isNull(orderFulfillment) || orderFulfillment.getOrder().getOrderID() != arguments.order.getOrderID()) {

				// get the correct fulfillment method for this new order fulfillment
				var fulfillmentMethod = arguments.processObject.getFulfillmentMethod();

				// If the fulfillmentMethod is still null because the above didn't execute, then we can pull it in from the first ID in the sku settings
				if(isNull(fulfillmentMethod) && listLen(arguments.processObject.getSku().setting('skuEligibleFulfillmentMethods'))) {
					var fulfillmentMethod = getFulfillmentService().getFulfillmentMethod( listFirst(arguments.processObject.getSku().setting('skuEligibleFulfillmentMethods')) );
				}

				if(!isNull(fulfillmentMethod)) {
					// Setup a new order fulfillment
					var orderFulfillment = this.newOrderFulfillment();

					orderFulfillment.setFulfillmentMethod( fulfillmentMethod );
					orderFulfillment.setCurrencyCode( arguments.order.getCurrencyCode() );
					orderFulfillment.setOrder( arguments.order );

					// Setup 'Shipping' Values
					if(orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "shipping") {
						
						
						if(!isNull(arguments.processObject.getThirdPartyShippingAccountIdentifier()) && len(arguments.processObject.getThirdPartyShippingAccountIdentifier())){
							orderFulfillment.setThirdPartyShippingAccountIdentifier(arguments.processObject.getThirdPartyShippingAccountIdentifier());
						} 
						// Check for an accountAddress
						if(len(arguments.processObject.getShippingAccountAddressID())) {

							// Find the correct account address, and set it in the order fulfillment
							var accountAddress = getAccountService().getAccountAddress( arguments.processObject.getShippingAccountAddressID() );
							orderFulfillment.setAccountAddress( accountAddress );
							var address = getAddressService().saveAddress(arguments.processObject.getShippingAddress());
							if(!address.hasErrors()){
								orderFulfillment.setShippingAddress(address);
							}else{
								orderFulfillment.addErrors(address.getErrors());
							}
						// Otherwise try to setup a new shipping address
						} else {

							// Check to see if the new shipping address passes full validation.
							var fullAddressErrors = getHibachiValidationService().validate( arguments.processObject.getShippingAddress(), 'full', false );

							if(!fullAddressErrors.hasErrors()) {
								// First we need to persist the address from the processObject
								getAddressService().saveAddress( arguments.processObject.getShippingAddress() );

								// If we are supposed to save the new address, then we can do that here
								if(arguments.processObject.getSaveShippingAccountAddressFlag() && !isNull(arguments.order.getAccount()) ) {

									var newAccountAddress = getAccountService().newAccountAddress();
									newAccountAddress.setAccount( arguments.order.getAccount() );
									newAccountAddress.setAccountAddressName( arguments.processObject.getSaveShippingAccountAddressName() );
									newAccountAddress.setAddress( arguments.processObject.getShippingAddress() );
									orderFulfillment.setAccountAddress( newAccountAddress );

								// Otherwise just set then new address in the order fulfillment
								} else {

									orderFulfillment.setShippingAddress( arguments.processObject.getShippingAddress() );
								}
							}
						}

					// Set 'Pickup' Values
					} else if (orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "pickup") {

						// Check for a pickupLocationID
						if(!isNull(arguments.processObject.getPickupLocationID()) && len(arguments.processObject.getPickupLocationID())) {

							// Find the pickup location
							var pickupLocation = getLocationService().getLocation(arguments.processObject.getPickupLocationID());

							// if found set in the orderFulfillment
							if(!isNull(pickupLocation)) {
								orderFulfillment.setPickupLocation(pickupLocation);
							}
						}

					// Set 'Email' Value
					} else if (orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "email") {

						// Check for an email address
						if(!isNull(arguments.processObject.getEmailAddress()) && len(arguments.processObject.getEmailAddress())) {
							orderFulfillment.setEmailAddress( arguments.processObject.getEmailAddress() );
						}

					}
					
					//Sets the status type
					orderFulfillment.setOrderFulfillmentInvStatType(orderFulfillment.getOrderFulfillmentInvStatType());
					//we will update order amounts at the end of the process
					orderFulfillment = this.saveOrderFulfillment( orderFulfillment=orderFulfillment, updateOrderAmounts=false, updateShippingMethodOptions=arguments.processObject.getUpdateShippingMethodOptionsFlag() );
                    //check the fulfillment and display errors if needed.
                    if (orderFulfillment.hasErrors()){
                        arguments.order.addError('addOrderItem', orderFulfillment.getErrors());
                    }

				} else {

					arguments.processObject.addError('fulfillmentMethodID', rbKey('validate.processOrder_addOrderitem.orderFulfillmentID.noValidFulfillmentMethod'));

				}

			}
			
			// Set Stock reference, check the fullfillment for a pickup location
			if (!isNull(orderFulfillment) && !isNull(orderFulfillment.getPickupLocation())){
				// The item being added to the cart should have its stockID added based on that location
				var location = orderFulfillment.getPickupLocation();
				var stock = getService("StockService").getStockBySkuAndLocation(sku=arguments.processObject.getSku(), location=location);
				
				//If we found a stock for that location, then set the stock to the process.
				if (!isNull(stock)){
					arguments.processObject.setStock(stock);
				}
			}

			// Check for the sku in the orderFulfillment already, so long that the order doens't have any errors
			if(!arguments.order.hasErrors()) {
				for(var i=arraylen(orderFulfillment.getOrderFulfillmentItems());i>0; i--  ){
				
					var orderItem = orderFulfillment.getOrderFulfillmentItems()[i];
					//evaluate existing stockHold
					if(arraylen(orderItem.getStockHolds())){
						//currently only supporting singular stockholds
						var stockHold = orderItem.getStockHolds()[1];
						if(stockHold.isExpired()){
							getService('stockService').deleteStockHold(stockHold);
							arguments.order.removeOrderItem(orderItem);
							continue;
						}
					}
					// If the sku, price, attributes & stock all match then just increase the quantity if and only if the match parent orderitem is null.
					if(
						arguments.processObject.matchesOrderItem( orderItem ) 
						&& isNull(orderItem.getParentOrderItem())
					){
						foundItem = true;
						var foundOrderItem = orderItem;
						foundOrderItem.setQuantity(orderItem.getQuantity() + arguments.processObject.getQuantity());
						if(!isNull(arguments.processObject.getSellOnBackOrderFlag()) && arguments.processObject.getSellOnBackorderFlag()){
							foundOrderItem.setSellOnBackOrderFlag(arguments.processObject.getSellOnBackorderFlag());
						}
						foundOrderItem.validate(context='save');
						
						if(foundOrderItem.hasErrors()) {
							//String replace the max order qty to give user feedback (with 0 as the minimum)
							var messageReplaceKeys = {
								quantityAvailable =  foundOrderItem.getMaximumOrderQuantity(),
								maxQuantity = foundOrderItem.getSku().setting('skuOrderMaximumQuantity')
							};
							
							for (var error in foundOrderItem.getErrors()){
								for (var errorMessage in foundOrderItem.getErrors()[error]){
									var message = getHibachiUtilityService().replaceStringTemplate( errorMessage , messageReplaceKeys);
									message = foundOrderItem.stringReplace(message);
								
									foundOrderItem.addError('addOrderItem', message, true);
									arguments.order.addError('addOrderItem', message, true);
								}

							}
						}
						break;
					}
				}
			}

		// If this is a return order item, then we need to setup or find the orderReturn
		} else if (listFindNoCase("oitReturn",arguments.processObject.getOrderItemTypeSystemCode())) {

			// First see if we can use an existing order return
			var orderReturn = processObject.getOrderReturn();

			// Next if we can't use an existing one, then we need to create a new one
			if(isNull(orderReturn) || orderReturn.getOrder().getOrderID() neq arguments.order.getOrderID()) {

				// Setup a new order return
				var orderReturn = this.newOrderReturn();
				orderReturn.setOrder( arguments.order );
				orderReturn.setCurrencyCode( arguments.order.getCurrencyCode() );
				orderReturn.setReturnLocation( arguments.processObject.getReturnLocation() );
				if(!isNull(arguments.processObject.getFulfillmentRefundAmount())){
					orderReturn.setFulfillmentRefundAmount( arguments.processObject.getFulfillmentRefundAmount() );
				}
				if(!isNull(arguments.processObject.getFulfillmentRefundPreTax())){
					orderReturn.setFulfillmentRefundPreTax( arguments.processObject.getFulfillmentRefundPreTax() );
				}
				if(!isNull(arguments.processObject.getFulfillmentTaxRefund())){
					orderReturn.setFulfillmentTaxRefund( arguments.processObject.getFulfillmentTaxRefund() );
				}

				orderReturn = this.saveOrderReturn( orderReturn );
			}

		}

		// If we didn't already find the item in an orderFulfillment, then we can add it here.
		if(!foundItem && !arguments.order.hasErrors()) {
			// Create a new Order Item
			var newOrderItem = this.newOrderItem();

			if (!isNull(arguments.processObject.getStock())){
				newOrderItem.setStock(arguments.processObject.getStock());
			}

			if (processObject.getSellOnBackOrderFlag() == true){
				newOrderItem.setSellOnBackOrderFlag(true); //used at the line item level to show it was sold out of stock.
			}
			
			/******* CUSTOM CODE FOR MONAT *******/
			if(!isNull(arguments.order.getUpgradeFlag()) && arguments.order.getUpgradeFlag() && !isNull(arguments.order.getPriceGroup())){
				newOrderItem.setAppliedPriceGroup(arguments.order.getPriceGroup());
			}
			/******* END CUSTOM CODE FOR MONAT *******/
			
			// Set Header Info
			newOrderItem.setOrder( arguments.order );
			newOrderItem.setPublicRemoteID( arguments.processObject.getPublicRemoteID() );
			if(arguments.processObject.getOrderItemTypeSystemCode() eq "oitSale") {
				newOrderItem.setOrderFulfillment( orderFulfillment );
				newOrderItem.setOrderItemType( getTypeService().getTypeBySystemCode('oitSale') );
			} else if (arguments.processObject.getOrderItemTypeSystemCode() eq "oitReturn") {
				newOrderItem.setOrderReturn( orderReturn );
				newOrderItem.setOrderItemType( getTypeService().getTypeBySystemCode('oitReturn') );
			} else if (arguments.processObject.getOrderItemTypeSystemCode() eq "oitDeposit") {
				newOrderItem.setOrderItemType( getTypeService().getTypeBySystemCode('oitDeposit') );
			}

			// Setup child items for a bundle
			//Need to also check child order items for child order items.
			if( arguments.processObject.getSku().getBaseProductType() == 'productBundle' ) {
				if(arraylen(arguments.processObject.getChildOrderItems())){
					for(var childOrderItemData in arguments.processObject.getChildOrderItems()) {
						var childOrderItem = this.newOrderItem();
						populateChildOrderItems(newOrderItem,childOrderItem,childOrderItemData,arguments.order,orderFulfillment);
					}
				}

			}
			
			// Setup the Sku / Quantity / Price/ SKU-Price details
			addNewOrderItemSetup(newOrderItem, arguments.processObject);

			// If a stock was passed in assign it to this new item
			if( !isNull(arguments.processObject.getStock()) ) {
				newOrderItem.setStock( arguments.processObject.getStock() );
			}

			// If attributeValues were passed in set them
			if( !isNull(arguments.processObject.getAttributeValuesByCodeStruct()) ) {
				for(var attributeCode in arguments.processObject.getAttributeValuesByCodeStruct() ) {
					newOrderItem.setAttributeValue( attributeCode, arguments.processObject.getAttributeValuesByCodeStruct()[attributeCode] );
				}
			}

			if(arguments.order.isNew()){
				this.saveOrder(order=arguments.order, updateOrderAmounts=arguments.processObject.getUpdateOrderAmountFlag(), updateShippingMethodOptions=arguments.processObject.getUpdateShippingMethodOptionsFlag());
			}

			// Save the new order items don't update order amounts we'll do it at the end of this process
			newOrderItem = this.saveOrderItem( orderItem=newOrderItem, updateOrderAmounts=false , updateCalculatedProperties=true, updateShippingMethodOptions=arguments.processObject.getUpdateShippingMethodOptionsFlag());

			if(newOrderItem.hasErrors()) {
				//String replace the max order qty to give user feedback with the minimum of 0
				var messageReplaceKeys = {
					quantityAvailable = newOrderItem.getMaximumOrderQuantity(),
					maxQuantity = newOrderItem.getSku().setting('skuOrderMaximumQuantity')
				};
				
 				for (var error in newOrderItem.getErrors()){
					for (var errorMessage in newOrderItem.getErrors()[error]){
						var message = getHibachiUtilityService().replaceStringTemplate( errorMessage , messageReplaceKeys);
						message = newOrderItem.stringReplace(message);
					
						arguments.order.addError('addOrderItem', message, true);
						newOrderItem.addError("addOrderItem", message, true);
					}
				}
			}else{
				//begin stock hold logic
				if(arguments.processObject.getSku().setting('skuStockHold')){
					var stockHold = getService('stockService').newStockHold();
					stockHold.setSku(arguments.processObject.getSku());
					stockHold.setOrderItem(newOrderItem);
					stockHold.setStock(arguments.processObject.getStock());
					stockHold.setStockHoldExpirationDateTime(dateAdd('n',arguments.processObject.getSku().setting('skuStockHoldTime'),now()));
					
					stockHold = getService('stockService').saveStockHold(stockHold);
				}
			}
		}

		// Applies only to order items for gift card skus
		if(arguments.processObject.getSku().isGiftCardSku()){
			
			var orderItem = "";
			if(foundItem){
				orderItem = foundOrderItem;
			} else {
				orderItem = newOrderItem;
			}

			// Additional processing when gift card codes manually provided or gift gard recipient(s) required
			if (!arguments.processObject.getSku().getGiftCardAutoGenerateCodeFlag() || arguments.processObject.getSku().getGiftCardRecipientRequiredFlag()) {

				// Retrieve gift card recipient data from order_addOrderItem process object
				var orderItemGiftCardRecipientData = arguments.processObject.getRecipients();

				if (!isNull(orderItemGiftCardRecipientData)) {

					// Loop over all gift card recipient data.
					for (var data in orderItemGiftCardRecipientData){
						
						// Note: OrderItemGiftRecipient entity is used to handle a couple use cases.
						// A small subset of its properties might used depending on the context, sku settings, order item fulfillment type
						// Entity may contain all recipient detail email/contact or simply for storage of manually provided gift card codes

						// Populate using the orderItemGiftRecipient data provided
						var orderItemGiftRecipient = this.newOrderItemGiftRecipient();
						orderItemGiftRecipient.populate(data);
						orderItemGiftRecipient.setOrderItem(orderItem);

						// Set values using process object
						// This process should really be done using a process like processOrderItem_AddGiftRecipient(..., {orderItemGiftRecipient=...}, 'create') so a new process object for each
						// Because same instance of a process object will be used for entire life of the order object
						// TODO: Refactor later
						var addOrderItemGiftRecipientProcessObject = arguments.order.getProcessObject('addOrderItemGiftRecipient', {
							orderItem = orderItem,
							recipient = orderItemGiftRecipient
						});
						// Allows subproperty validation to occur on these objects
						addOrderItemGiftRecipientProcessObject.addPopulatedSubProperty('orderItem', orderItem);
						addOrderItemGiftRecipientProcessObject.addPopulatedSubProperty('recipient', orderItemGiftRecipient);
						
						// Run process to associate gift recipient with orderItem
						this.processOrder(arguments.order, {}, 'addOrderItemGiftRecipient');

						if (addOrderItemGiftRecipientProcessObject.hasErrors()) {
							if (addOrderItemGiftRecipientProcessObject.getRecipient().hasErrors()) {
								orderItem.addErrors(addOrderItemGiftRecipientProcessObject.getRecipient().getErrors());
								arguments.order.addErrors(addOrderItemGiftRecipientProcessObject.getRecipient().getErrors());
							}
						}
					}
				}
			}
		}


		// If this is an event then we need to attach accounts and registrations to match the quantity of the order item.
		if(arguments.processObject.getSku().getBaseProductType() == "event" && !isNull(arguments.processObject.getRegistrants())) {

			var depositsOnlyFlag = false;
			var salesOnlyFlag = false;
			var orderItemsToCreateCount = 1;
			var salesCount = 0;
			var depositsCount = 0;
			var currentRegistrantCount = arguments.processObject.getSku().getRegistrantCount();
			var hasSaleFlag = false;
			var hasDepositFlag = false;

			// If order item contains both sales orders AND deposits we'll create the sale order item, then we'll create a separate deposit order item.
			for(var registrant in arguments.processObject.getRegistrants()) {
				if(registrant.toWaitlistFlag == "1")	{
					hasDepositFlag = true;
				} else {
					hasSaleFlag = true;
				}
				if(hasDepositFlag && hasSaleFlag) {
					// Setup iterator to make 2 passes, the first for sales only
					orderItemsToCreateCount = 2;
					salesOnlyFlag = true;
					break;
				}
			}

			for( var i=1;i<=orderItemsToCreateCount;i++) {

				if(i==2) {
					// If we're here it means we had to split the order item into two and we're done with the first.

					// Create a separate order Item for deposits
					var depositOrderItem = this.newOrderItem();

					// Set Header Info
					depositOrderItem.setOrder( arguments.order );
					depositOrderItem.setOrderItemType( getTypeService().getTypeBySystemCode('oitDeposit') );

					// Setup the Sku / Quantity / Price details
					depositOrderItem.setSku( arguments.processObject.getSku() );
					depositOrderItem.setCurrencyCode( arguments.order.getCurrencyCode() );
					depositOrderItem.setQuantity( arguments.processObject.getQuantity() );
					depositOrderItem.setPrice( arguments.processObject.getPrice() );
					depositOrderItem.setSkuPrice( arguments.processObject.getSku().getPriceByCurrencyCode( depositOrderItem.getCurrencyCode() ) );

					// Set any customizations
					depositOrderItem.populate( arguments.data );

					// Save the deposit order items
					depositOrderItem = this.saveOrderItem( depositOrderItem );

					if(depositOrderItem.hasErrors()) {
						arguments.order.addError('addOrderItem', depositOrderItem.getErrors());
					}

					// Update the quantities to reflect the sales/deposit split.
					newOrderItem.setQuantity( salesCount );
					depositOrderItem.setQuantity( arguments.processObject.getQuantity() - salesCount );

					// Update the flags that drive sales/deposit related specifics
					salesOnlyFlag = false;
					depositsOnlyFlag = true;
				}

				// ProcessObject should contain account info in registrants array
				for(var registrant in arguments.processObject.getRegistrants()) {

					// Make sure we put the registrants in the right order item
					if( (orderItemsToCreateCount == 1) || (salesOnlyFlag && registrant.toWaitlistFlag == "0") || (depositsOnlyFlag && registrant.toWaitlistFlag == "1") ) {

						// Create new event registration	 record
						var eventRegistration = this.newEventRegistration();

						eventRegistration.setEventRegistrationStatusType(getTypeService().getTypeBySystemCode("erstNotPlaced"));
						eventRegistration.generateAndSetAttendanceCode();

						if(depositsOnlyFlag) {
							eventRegistration.setOrderItem(depositOrderItem);
							eventRegistration.setSku(depositOrderItem.getSku());
						} else {
							eventRegistration.setOrderItem(newOrderItem);
							eventRegistration.setSku(newOrderItem.getSku());
						}

						// If newAccount registrant should contain an accountID otherwise should contain first, last, email, phone
						if(registrant.newAccountFlag == 0) {
							eventRegistration.setAccount( getAccountService().getAccount(registrant.accountID) );
						} else {
							//Create new account to associate with registration
							var newAccount = getAccountService().newAccount();
							if(isDefined("registrant.firstName") && len(registrant.firstName)) {
								newAccount.setFirstName(registrant.firstName);
							}
							if(isDefined("registrant.lastName") && len(registrant.lastName)) {
								newAccount.setLastName(registrant.lastName);
							}
							if(isDefined("registrant.emailAddress") && len(registrant.emailAddress)) {
								var newEmailAddress = getAccountService().newAccountEmailAddress();
								newEmailAddress.setEmailAddress(registrant.emailAddress);
								newAccount.setPrimaryEmailAddress(newEmailAddress);

							}
							if(isDefined("registrant.phoneNumber") && len(registrant.phoneNumber)) {
								var newPhoneNumber = getAccountService().newAccountPhoneNumber();
								newPhoneNumber.setPhoneNumber(registrant.phoneNumber);
								newAccount.setPrimaryPhoneNumber(newPhoneNumber);
							}
							newAccount = getAccountService().saveAccount(newAccount);
							eventRegistration.setAccount(newAccount);

						}

						if( depositsOnlyFlag || registrant.toWaitlistFlag == "1" ) {
							depositsCount++;

						}else {
								if( (arguments.processObject.getSku().getEventCapacity() > (currentRegistrantCount + salesCount) )  ) {
									salesCount++;

								} else {
									// If we have an unexprected waitlister due to event filling before order item was created
									// check to see if there were any sales that went through. If there were then move the registrant
									// to a waitlist/deposit order item. If not then change the order item type to deposit and waitlist registrant.
									if( !salesOnlyFlag && salesCount > 0 ) {
										registrant.toWaitlistFlag = "1";
										orderItemsToCreateCount = 2;
										salesOnlyFlag = true;
									} else {
										newOrderItem.setOrderItemType( getTypeService().getTypeBySystemCode('oitDeposit') );
									}

								}
							}

						eventRegistration = getEventRegistrationService().saveEventRegistration( eventRegistration );

					}


				}


			}

		}

		// Call save order to place in the hibernate session and re-calculate all of the totals
		arguments.order = this.saveOrder( order=arguments.order, updateOrderAmounts=arguments.processObject.getUpdateOrderAmountFlag(), updateShippingMethodOptions=arguments.processObject.getUpdateShippingMethodOptionsFlag() );


		
		if( 
			arguments.order.hasErrors() && arguments.order.hasMonatOrderType() &&
			arguments.order.getMonatOrderType().getTypeCode() == 'motMPEnrollment' 
		){
			
			/**
			 * 1. If orderCreatedSite.SiteCode is UK and order.accountType is MP 
			 * max 200 pound TOTAL including VAT and Shipping Feed on days 1-7 
			 * from ordering the enrollment kit.
			 * This only work if the max orders validation also works because this only checks the current order
			 * for total instead of all orders.
			 **/
			
			logHibachi("Error encountered on order.motMPEnrollment(#arguments.order.getOrderID()#), order-total: #arguments.order.getTotal()#, Errors: #SerializeJson(arguments.order.getErrors())#");
			
			//clear previous errors, and temporarily saving order for calculations
			var oldErrors = StructCopy(arguments.order.getErrors());
			arguments.order.clearHibachiErrors();
			getHibachiScope().setORMHasErrors( false );
			if(!isNull(newOrderItem)){
				newOrderItem.clearHibachiErrors();
			}
			getHibachiScope().flushORMSession(); 

			/**
			 * If We don't reload the ORN throws
			 * Cannot delete or update a parent row: a foreign key constraint fails 
			 * (
			 *		`monat`.`sworderitemskubundle`, CONSTRAINT `FKD0CB5F2244B9A827` FOREIGN KEY 
			 *		(`orderItemID`) REFERENCES `sworderitem` (`orderItemID`)
			 * )
			**/
			entityReload(arguments.order);
			
			
			if( !IsNull(newOrderItem) ) {
				
				logHibachi("Removing newOrderItem(#newOrderItem.getOrderItemID()#) from the order order-total: #arguments.order.getTotal()# ");
				arguments.order = this.processOrder(arguments.order, { 'orderItemID': newOrderItem.getOrderItemID() }, 'removeOrderItem');
				
			} else if( !IsNull(foundOrderItem) ) {
				
				logHibachi("Reverting foundOrderItem(#foundOrderItem.getOrderItemID()#) qty from: #foundOrderItem.getQuantity()# - to: #foundOrderItem.getQuantity() - arguments.processObject.getQuantity()#,  order-total: #arguments.order.getTotal()#");
				foundOrderItem.setQuantity( foundOrderItem.getQuantity() - arguments.processObject.getQuantity() );
				//clear non-persistent properties cache, so calculated properties can be updated with real-values
				foundOrderItem.clearNonPersistentCalculatedPropertiesCache(); 
				//We'll update order amounts at the last step
				foundOrderItem = this.saveOrderItem( orderItem=foundOrderItem, updateOrderAmounts=false , updateCalculatedProperties=true);
			}
			
			//just in case, if remove/update order-item fails
			logHibachi("Errors on Order after reverting changes : #SerializeJson(arguments.order.getErrors())# order-total: #arguments.order.getTotal()#");
			arguments.order = this.saveOrder( order=arguments.order, updateOrderAmounts=true, updateShippingMethodOptions=arguments.processObject.getUpdateShippingMethodOptionsFlag() );
			arguments.order.updateCalculatedProperties(runAgain=true); //re-calculate-everything
			
			logHibachi("Flushing after re-saving the order(#arguments.order.getOrderID()#), order-total: #arguments.order.getTotal()#");
			//we gotta flush here to persist current changes, before putting-back the old errors
			getHibachiScope().flushORMSession();
			
			//return the order with previous errors
			arguments.order.addErrors(oldErrors);
			getHibachiScope().setORMHasErrors( true );
		}
		
		return arguments.order;
	}
	
	
	public boolean function getAccountIsInFlexshipCancellationGracePeriod(required any orderTemplate){
	
		var flexshipsCollectionList = this.getOrderTemplateCollectionList();
		flexshipsCollectionList.setDisplayProperties('orderTemplateID');
		flexshipsCollectionList.addFilter('account.accountID', arguments.orderTemplate.getAccount().getAccountID());
		flexshipsCollectionList.addFilter('orderTemplateType.systemCode', 'ottSchedule');

		var totalFlexshipsCount = flexshipsCollectionList.getRecordsCount( refresh=true );
		
		if(totalFlexshipsCount < 1){
			return false;
		}
		
		flexshipsCollectionList.addFilter('orderTemplateStatusType.systemCode', 'otstCancelled');
		var canceledFlexshipsCount = flexshipsCollectionList.getRecordsCount( refresh=true );
		
		if(canceledFlexshipsCount < totalFlexshipsCount) { 
			return false;
		}	
	
		var flexshipCancellationGracePeriodForMpUsers = arguments.orderTemplate.getSite().setting('integrationmonatSiteFlexshipCancellationGracePeriodForMPUsers'); 
		
		flexshipsCollectionList.setDisplayProperties('orderTemplateID,canceledDateTime');
		flexshipsCollectionList.addOrderBy("canceledDateTime|DESC");
		flexshipsCollectionList.setPageRecordsShow(1);
		
		var lastCanceledFlexship = flexshipsCollectionList.getPageRecords( refresh=true, formatRecords=false )[1]; 

		if( dateDiff('d', lastCanceledFlexship['canceledDateTime'], now() ) < flexshipCancellationGracePeriodForMpUsers ) {
			return true;
		}
		
		return false;
			
	}
	
	public any function createOrderItemsFromOrderTemplateItems(required any order, required any orderTemplate){
		var orderTemplateItemCollection = this.getOrderTemplateItemCollectionList(); 
		orderTemplateItemCollection.setDisplayProperties('orderTemplateItemID,sku.skuID,sku.skuCode,quantity,temporaryFlag'); 
		orderTemplateItemCollection.addFilter('orderTemplate.orderTemplateID', arguments.orderTemplate.getOrderTemplateID()); 
		var foundPromoItems = [];
		var orderTemplateItems = orderTemplateItemCollection.getRecords();
		var orderTemplateItemData = {}; //instantiating here as the OF in the loop is out of scope
		orderTemplateItemData['orderFulfillmentHasErrors'] = false;
		
		orderTemplateItems = this.consolidateOrderTemplateItemsBySku(orderTemplateItems);

		for(var orderTemplateItem in orderTemplateItems){ 
			this.logHibachi('OrderTemplate #arguments.orderTemplate.getOrderTemplateID()#, adding skuCode: #orderTemplateItem['sku_skuCode']#');
			if(!isNull(orderTemplateItem.temporaryFlag) && orderTemplateItem.temporaryFlag == true){
				arrayAppend(foundPromoItems, orderTemplateItem.sku_skuID);
			}
			
			var args = {
				'order'=arguments.order,
				'orderTemplateItemStruct'=orderTemplateItem,
				'orderTemplate'=arguments.orderTemplate,
				'temporaryFlag'= orderTemplateItem.temporaryFlag ?: false
			}
			
			if(!isNull(orderFulfillment)){
				args['orderFulfillment'] = orderFulfillment;
			}
			
			arguments.order = this.addOrderItemFromTemplateItem(argumentCollection=args);
			
			//define order fulfillment for the rest of the loop	
			if( isNull(orderFulfillment) && 
				!arrayIsEmpty(arguments.order.getOrderItems()) && 
				!isNull(arguments.order.getOrderItems()[1].getOrderFulfillment())
			){

				var orderFulfillment = arguments.order.getOrderItems()[1].getOrderFulfillment();

				orderFulfillment.setShippingMethod(arguments.orderTemplate.getShippingMethod());
				orderFulfillment.setFulfillmentMethod(arguments.orderTemplate.getShippingMethod().getFulfillmentMethod());

				orderFulfillment = this.saveOrderFulfillment( orderFulfillment=orderFulfillment, updateOrderAmounts=false, updateShippingMethodOptions=false );
				orderTemplateItemData['orderFulfillment'] = orderFulfillment;
				
				if (orderFulfillment.hasErrors()){
					orderTemplateItemData['orderFulfillmentHasErrors'] = true;
					//propagate to parent, because we couldn't create the fulfillment this order is not going to be placed
					arguments.order.addErrors(orderFulfillment.getErrors());	
					return arguments.order; 
				}	
			}	
		}

		if(!isNull(orderTemplateItemData['orderFulfillment']) && !orderTemplateItemData['orderFulfillmentHasErrors']){

			//if we have the promoItem skuID in the actual order, we can remove from the array
			for(var item in arguments.order.getOrderItems()){
				arrayDelete(foundPromoItems,item.getSku().getSkuID());
			}
			
			//loop over remaining sku's in foundPromoItems, if there are sku's left we can add the default for them
			for(var item in foundPromoItems){
				arguments.order = addDefaultOFYSkuIfEligible(arguments.order,arguments.orderTemplate,orderTemplateItemData['orderFulfillment']);
			}
		}

		return arguments.order;
	}
	
	private array function consolidateOrderTemplateItemsBySku( required array orderTemplateItems ){
		
		var templateItemMap = {};
		var returnArray = [];
		for(var orderTemplateItemStruct in arguments.orderTemplateItems){
			if( !structKeyExists( templateItemMap, orderTemplateItemStruct['sku_skuID'] ) ){
				templateItemMap[ orderTemplateItemStruct['sku_skuID'] ] = orderTemplateItemStruct;
			}else{
				templateItemMap[ orderTemplateItemStruct['sku_skuID'] ].quantity += orderTemplateItemStruct.quantity;
			}
		}
		
		for(var key in templateItemMap){
			returnArray.append( templateItemMap[ key ] );
		}
		return returnArray;
	}
	
	public any function addDefaultOFYSkuIfEligible(required any order, required any orderTemplate, required any orderFulfillment){
		var defaultOFYSkuCode = arguments.orderTemplate.getAccount().getAccountCreatedSite().setting('siteDefaultOFYSkuCode');
		var sku = getService('skuService').getSkuBySkuCode(defaultOFYSkuCode);
		
		if(!isNull(sku) && sku.getActiveFlag() && sku.getPublishedFlag()){
			var orderTemplateItem = this.newOrderTemplateItem();
			orderTemplateItem.setTemporaryFlag(true);
			orderTemplateItem.setSku(sku);
			orderTemplateItem.setQuantity(1);
			orderTemplateItem = this.saveOrderTemplateItem(orderTemplateItem);
			
			var orderTemplateItemStruct = {
				'sku_skuID'=sku.getSkuID(),
				'quantity'=1,
				'orderTemplateItemID'=orderTemplateItem.getOrderTemplateItemID(),
				'price'=0,
				'userDefinedPriceFlag'=true
			};
			arguments.order = this.addOrderItemFromTemplateItem(arguments.order, orderTemplateItemStruct, arguments.orderTemplate, arguments.orderFulfillment);
			arguments.order = this.saveOrder(arguments.order);
		}
		
		return arguments.order;
	}
	
	public any function getOFYProductsForOrder(required any order ){
		var freeRewardSkuCollection = getSkuService().getSkuCollectionList();
		var freeRewardSkuIDs = getPromotionService().getQualifiedFreePromotionRewardSkuIDs(arguments.order);
		freeRewardSkuCollection.addFilter('skuID', freeRewardSkuIDs, 'in');
		freeRewardSkuCollection.addDisplayProperty('product.productDescription');
		return freeRewardSkuCollection.getRecords();
	}
	
	public any function getPurchasePlusInformationForOrderItems(required string orderID=''){
		if(!len(arguments.orderID)) return [];
		var orderItemCL = this.getOrderItemCollectionList();
		orderItemCL.addFilter('order.orderID', arguments.orderID);
		orderItemCL.addDisplayProperty('orderItemID');
		orderItemCL = orderItemCL.getRecords();
		var orderItemIDs = ''
		
		if(isNull(orderItemCL) || !arrayLen(orderItemCL)) return [];
		for(var item in orderItemCL){
			orderItemIDs &= '#item.orderItemID#,';
		}
	
		var ofyPromoCL = getService('promotionService').getPromotionAppliedCollectionList();
		ofyPromoCL.addFilter('orderItem.orderItemID', orderItemIDs, 'IN');
		ofyPromoCL.addFilter('promotion.promotionName', 'Purchase Plus%', 'like');
		ofyPromoCL.addDisplayProperty('discountAmount');
		ofyPromoCL.addDisplayProperty('promotion.promotionName');
		return ofyPromoCL
	}
	
	

	public any function processOrder_retrySyncPendingOrders(required any order, any processObject, required struct data={}) {
		return getHibachiScope().getService('integrationService')
			.getIntegrationByIntegrationPackage('infotrax')
			.getIntegrationCFC("data")
			.retrySyncPendingOrders(argumentCollection=arguments);
	}
	
	public any function processOrderTemplate_retrySyncPendingOrderTemplates(required any orderTemplate, any processObject, required struct data={}) {
		return getHibachiScope().getService('integrationService')
			.getIntegrationByIntegrationPackage('infotrax')
			.getIntegrationCFC("data")
			.retrySyncPendingOrderTemplates(argumentCollection=arguments);
	}
	
	public any function processOrder_placeOrder(required any order, struct data={}) {
		
		if (isNull(arguments.order.getAccount().getOwnerAccount())){
			arguments.order.addError( 'placeOrder', rbKey("validate.processOrder_PlaceOrder.invalidOwnerAccount") );
			return arguments.order;
		}
		
		return super.processOrder_placeOrder(argumentCollection=arguments);
	}
	
	
	public any function processOrder_importOrderUpdates() {
		
		getHibachiScope()
			.getService('integrationService')
			.getIntegrationByIntegrationPackage('monat')
			.getIntegrationCFC("data")
			.importOrderUpdates({});

		return newOrder();
	}
	
	public any function processOrder_importOrderShipments() {
		
		getHibachiScope()
			.getService('integrationService')
			.getIntegrationByIntegrationPackage('monat')
			.getIntegrationCFC("data")
			.importOrderShipments({});

		return newOrder();
	}
	
	public any function processOrder_resyncToAvalara(required any order){
		
		//Only commit the tax document after the order has been closed
		var orderStatusType = arguments.order.getOrderStatusType();
		var orderType = arguments.order.getOrderType();
		

		var orderIsClosed = orderStatusType.getSystemCode() == 'ostClosed';
		var orderIsClosedRMA = orderIsClosed && orderType.getSystemCode() != 'otSalesOrder';
		
		if(orderIsClosed && !orderIsClosedRMA){
			var orderStatusHistory = arguments.order.getOrderStatusHistoryTypeCodeList();
		}
		var orderSkippedProcessingOne = !orderIsClosedRMA && orderIsClosed && !listContains(orderStatusHistory,'processing1');
		
		if ( orderIsClosedRMA || orderSkippedProcessingOne || orderStatusType.getTypeCode() == 'processing1'){
			
			//First get integration and make sure the commit tax document flag is set
			var integration = arguments.slatwallScope.getService('IntegrationService').getIntegrationByIntegrationPackage('avatax');
					
			if (integration.setting('commitTaxDocumentFlag')){
				//Create the request scope for the account
				var taxRatesRequestBean = arguments.slatwallScope.getService('TaxService').generateTaxRatesRequestBeanForIntegration(arguments.order, integration);
				taxRatesRequestBean.setCommitTaxDocFlag(true);
								
				var integrationTaxAPI = integration.getIntegrationCFC("tax");
				
				// Call the API and store the responseBean by integrationID
				try{
					integrationTaxAPI.getTaxRates( taxRatesRequestBean );
				}catch (any e){
					logHibachi('An error occured with the Avatax integration when trying to call commitTaxDocument()', true);
					logHibachiException(e);
				}
			}
		}
		return arguments.order;
	}
	
}
