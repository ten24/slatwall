component extends="Slatwall.model.service.OrderService" {
    variables.customPriceFields = 'personalVolume,taxableAmount,commissionableVolume,retailCommission,productPackVolume,retailValueVolume';
    public string function getCustomAvailableProperties() {
        return 'orderItems.personalVolume,orderItems.calculatedExtendedPersonalVolume,calculatedPersonalVolumeSubtotal,currencyCode,orderItems.skuProductURL,billingAddress,appliedPromotionMessages.message,appliedPromotionMessages.qualifierProgress,appliedPromotionMessages.promotionName,appliedPromotionMessages.promotionRewards.amount,appliedPromotionMessages.promotionRewards.amountType,appliedPromotionMessages.promotionRewards.rewardType';
    }
    
    /**
     * Function to get all carts and quotes for user
     * @param accountID required
     * @param pageRecordsShow optional
     * @param currentPage optional
     * return struct of orders and total count
     **/
	public any function getAllCartsAndQuotesOnAccount(struct data={}) {
        param name="arguments.data.currentPage" default=1;
        param name="arguments.data.pageRecordsShow" default=5;
        param name="arguments.data.accountID" default= getHibachiSCope().getAccount().getAccountID();
        
		var ordersList = this.getOrderCollectionList();

		ordersList.addOrderBy('orderOpenDateTime|DESC');
		ordersList.setDisplayProperties('
			orderID,
			calculatedTotalItemQuantity,
			orderNumber,
			orderStatusType.typeName
		');
		
		ordersList.addFilter( 'account.accountID', arguments.data.accountID, '=');
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
	public any function getAllOrderFulfillmentsOnAccount(struct data={}) {
        param name="arguments.data.currentPage" default=1;
        param name="arguments.data.pageRecordsShow" default=5;
        param name="arguments.data.accountID" default= getHibachiSCope().getAccount().getAccountID();
        
		var ordersList = this.getOrderFulfillmentCollectionList();
		ordersList.setDisplayProperties(' orderFulfillmentID, estimatedShippingDate, pickupDate, order.orderID, order.calculatedTotalItemQuantity, order.orderNumber, orderFulfillmentStatusType.typeName');
		ordersList.addFilter( 'order.account.accountID', arguments.data.accountID, '=');
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
	public any function getAllOrderDeliveryOnAccount(struct data={}) {
        param name="arguments.data.currentPage" default=1;
        param name="arguments.data.pageRecordsShow" default=5;
        param name="arguments.data.accountID" default= getHibachiSCope().getAccount().getAccountID();
        
		var ordersList = this.getOrderDeliveryCollectionList();
		ordersList.setDisplayProperties(' orderDeliveryID, invoiceNumber, trackingNumber, order.orderID, order.calculatedTotalItemQuantity, order.orderNumber, orderDeliveryStatusType.typeName');
		ordersList.addFilter( 'order.account.accountID', arguments.data.accountID, '=');
		ordersList.addFilter( 'order.orderStatusType.systemCode', 'ostNotPlaced', '!=');
		ordersList.setPageRecordsShow(arguments.data.pageRecordsShow);
		ordersList.setCurrentPageDeclaration(arguments.data.currentPage); 
		
		return { "ordersOnAccount":  ordersList.getPageRecords(formatRecords=false), "recordsCount": ordersList.getRecordsCount()}
	}
    
    public any function addNewOrderItemSetup(required any newOrderItem, required any processObject) {
        super.addNewOrderItemSetup(argumentCollection=arguments);
        
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
		} else if(!isNull(processObject.getAccount())){
			var account = processObject.getAccount();
		} else {
			var account = getHibachiScope().getAccount();
		}
		
		if( !account.getCanCreateFlexshipFlag() && arguments.context != "upgradeFlow") {
			arguments.orderTemplate.addError('canCreateFlexshipFlag', rbKey("validate.create.OrderTemplate_Create.canCreateFlexshipFlag") );
			return arguments.orderTemplate;
		}
		
		if(isNull(arguments.processObject.getScheduleOrderNextPlaceDateTime())){
			arguments.orderTemplate.addError('scheduleOrderNextPlaceDateTime', 'Order Next Place Date Time is required');
			return arguments.orderTemplate; 
		}
		
        if(isNull(arguments.data.orderTemplateName)  || !len(trim(arguments.data.orderTemplateName)) ) {
			arguments.data.orderTemplateName = "My Flexship, Created on " & dateFormat(now(), "long");
        }
		
		//grab and set shipping-account-address from account
		if(account.hasPrimaryShippingAddress()){
		    arguments.orderTemplate.setShippingAccountAddress(account.getPrimaryShippingAddress());
		} else if( account.hasPrimaryAddress()){
		    arguments.orderTemplate.setShippingAccountAddress(account.getPrimaryAddress());
		}
		
		//NOTE: there's only one shipping method allowed for flexship
		var shippingMethod = getService('ShippingService').getShippingMethod( 
		            ListFirst( arguments.orderTemplate.setting('orderTemplateEligibleShippingMethods') )
			    );
		orderTemplate.setShippingMethod(shippingMethod);
		
		//grab and set account-payment-method from account to ordertemplate
 		if(account.hasPrimaryPaymentMethod()){
		    arguments.orderTemplate.setAccountPaymentMethod(account.getPrimaryPaymentMethod());
	        
		    if( account.getPrimaryPaymentMethod().hasBillingAccountAddress()){
		        arguments.orderTemplate.setBillingAccountAddress(account.getPrimaryPaymentMethod().getBillingAccountAddress());
		    }
		}
		

		//grab and get billing-account-address from account
		if(!arguments.orderTemplate.hasBillingAccountAddress() ) {
		 	if(account.hasPrimaryBillingAddress()) {
    		    arguments.orderTemplate.setBillingAccountAddress(account.getPrimaryBillingAddress());
    		} else if( account.hasPrimaryAddress() ) {
    		    arguments.orderTemplate.setBillingAccountAddress(account.getPrimaryAddress());
    		}
		}
		
		if( arguments.context != "upgradeFlow"){
			arguments.orderTemplate.setAccount(account);
		}else if(!isNull(arguments.processObject.getPriceGroup())){
			arguments.orderTemplate.setPriceGroup(arguments.processObject.getPriceGroup());
		}
	
		arguments.orderTemplate.setSite( arguments.processObject.getSite() );
		arguments.orderTemplate.setCurrencyCode( arguments.processObject.getCurrencyCode() );
		arguments.orderTemplate.setOrderTemplateStatusType(getTypeService().getTypeBySystemCode('otstDraft'));
		arguments.orderTemplate.setOrderTemplateType(getTypeService().getType(arguments.processObject.getOrderTemplateTypeID()));
		arguments.orderTemplate.setScheduleOrderDayOfTheMonth(day(arguments.processObject.getScheduleOrderNextPlaceDateTime()));
		arguments.orderTemplate.setScheduleOrderNextPlaceDateTime(arguments.processObject.getScheduleOrderNextPlaceDateTime());
		arguments.orderTemplate.setFrequencyTerm( getSettingService().getTerm(arguments.processObject.getFrequencyTermID()) );
		arguments.orderTemplate = this.saveOrderTemplate(arguments.orderTemplate, arguments.data, arguments.context); 
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
	                price = price * returnOrderItem.getPrice() / arguments.originalOrderItem.getExtendedPriceAfterDiscount();
	                returnOrderItem.invokeMethod('set#priceField#',{1=price});
	            } 
	        }
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
                price = price * replacementOrderItem.getPrice() / arguments.originalOrderItem.getExtendedPriceAfterDiscount();
                replacementOrderItem.invokeMethod('set#priceField#',{1=price});
            }
        }
        return replacementOrderItem;
    }
    
    public any function updateReturnOrderWithAllocatedDiscounts(required any order, required any returnOrder, required any processObject){
		var allocatedOrderDiscountAmount = arguments.processObject.getAllocatedOrderDiscountAmountTotal();
		var allocatedOrderPVDiscountAmount = arguments.processObject.getAllocatedOrderPVDiscountAmountTotal();
		var allocatedOrderCVDiscountAmount = arguments.processObject.getAllocatedOrderCVDiscountAmountTotal();
		
		if(!isNull(allocatedOrderDiscountAmount) && allocatedOrderDiscountAmount > 0){
			var promotionApplied = getService('PromotionService').newPromotionApplied();
			promotionApplied.setOrder(returnOrder);
			if(arguments.order.hasAppliedPromotion()){
				promotionApplied.setPromotion(arguments.order.getAppliedPromotions()[1].getPromotion());
			}
			promotionApplied.setDiscountAmount(allocatedOrderDiscountAmount * -1);
			promotionApplied.setPersonalVolumeDiscountAmount(allocatedOrderPVDiscountAmount * -1);
			promotionApplied.setCommissionableVolumeDiscountAmount(allocatedOrderCVDiscountAmount * -1);
			
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
	private struct function getOrderTemplateOrderDetails(required any orderTemplate){	
		var orderTemplateOrderDetailsKey = "orderTemplateOrderDetails#arguments.orderTemplate.getOrderTemplateID()#"

		if(structKeyExists(request, orderTemplateOrderDetailsKey)){
			return request[orderTemplateOrderDetailsKey];
		} 
		
		request[orderTemplateOrderDetailsKey] = {}; 
		request[orderTemplateOrderDetailsKey]['fulfillmentTotal'] = 0;
		request[orderTemplateOrderDetailsKey]['fulfillmentDiscount'] = 0;
		request[orderTemplateOrderDetailsKey]['total'] = 0;
		request[orderTemplateOrderDetailsKey]['subtotal'] = 0;
		request[orderTemplateOrderDetailsKey]['personalVolumeTotal'] = 0;
		request[orderTemplateOrderDetailsKey]['commissionableVolumeTotal'] = 0;
		request[orderTemplateOrderDetailsKey]['canPlaceOrder'] = false;
		
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

			var transientOrder = getService('OrderService').newTransientOrderFromOrderTemplate( currentOrderTemplate, false );  
			//only update amounts if we can
			transientOrder = this.saveOrder( order=transientOrder, updateOrderAmounts=hasInfoForFulfillment );
			transientOrderItems = transientOrder.getOrderItems();
			for(var orderItem in transientOrderItems){
				orderItem.updateCalculatedProperties(); 
			}
			transientOrder.updateCalculatedProperties(); 	
			getHibachiDAO().flushORMSession();
		
			if(hasInfoForFulfillment){	
				request[orderTemplateOrderDetailsKey]['fulfillmentTotal'] = transientOrder.getFulfillmentTotal(); 
				request[orderTemplateOrderDetailsKey]['fulfillmentDiscount'] = transientOrder.getFulfillmentDiscountAmountTotal(); 
			}
	
			request[orderTemplateOrderDetailsKey]['subtotal'] = transientOrder.getCalculatedSubtotal();
			request[orderTemplateOrderDetailsKey]['total'] = transientOrder.getCalculatedTotal();
			request[orderTemplateOrderDetailsKey]['personalVolumeTotal'] = transientOrder.getPersonalVolumeSubtotal();
			request[orderTemplateOrderDetailsKey]['commissionableVolumeTotal'] = transientOrder.getCommissionableVolumeSubtotal(); 

			var freeRewardSkuCollection = getSkuService().getSkuCollectionList();
			var freeRewardSkuIDs = getPromotionService().getQualifiedFreePromotionRewardSkuIDs(transientOrder);
			freeRewardSkuCollection.addFilter('skuID', freeRewardSkuIDs, 'in');
			request[orderTemplateOrderDetailsKey]['promotionalFreeRewardSkuCollectionConfig'] = freeRewardSkuCollection.getCollectionConfigStruct(); 	

			request[orderTemplateOrderDetailsKey]['skuCollection'].setCollectionConfigStruct( getPromotionService().getQualifiedPromotionRewardSkuCollectionConfigForOrder(transientOrder) );
			request[orderTemplateOrderDetailsKey]['skuCollection'].addFilter('skuID', freeRewardSkuIDs, 'not in');
			request[orderTemplateOrderDetailsKey]['promotionalRewardSkuCollectionConfig'] = request[orderTemplateOrderDetailsKey]['skuCollection'].getCollectionConfigStruct();
			
			request[orderTemplateOrderDetailsKey]['canPlaceOrderDetails'] = getPromotionService().getOrderQualifierDetailsForCanPlaceOrderReward(transientOrder); 
			request[orderTemplateOrderDetailsKey]['canPlaceOrder'] = request[orderTemplateOrderDetailsKey]['canPlaceOrderDetails']['canPlaceOrder']; 

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

	public numeric function getPersonalVolumeTotalForOrderTemplate(required any orderTemplate){
		return getOrderTemplateOrderDetails(argumentCollection=arguments)['personalVolumeTotal'];	
	}
	
	public numeric function getComissionableVolumeTotalForOrderTemplate(required any orderTemplate){
		return getOrderTemplateOrderDetails(argumentCollection=arguments)['commissionableVolumeTotal'];	
	}
	
	public any function getOrderTemplateItemCollectionForAccount(required struct data, any account=getHibachiScope().getAccount()){
        param name="arguments.data.pageRecordsShow" default=5;
        param name="arguments.data.currentPage" default=1;
        param name="arguments.data.orderTemplateID" default="";
		param name="arguments.data.orderTemplateTypeID" default="2c948084697d51bd01697d5725650006"; 
		
		var orderTemplateItemCollection = this.getOrderTemplateItemCollectionList();
		
		var displayProperties = 'total,orderTemplateItemID,skuProductURL,quantity,sku.skuCode,sku.imagePath,sku.product.productName,sku.skuDefinition,orderTemplate.currencyCode';  
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
    
    private void function updateOrderStatusBySystemCode(required any order, required string systemCode) {
        var orderStatusType = "";
        var orderStatusHistory = {};
        
        if (arguments.systemCode != "ostNotPlaced"){
            // create status change history.
            orderStatusHistory = this.newOrderStatusHistory();
            orderStatusHistory.setOrder(arguments.order);
            orderStatusHistory.setChangeDateTime(now());
        }
        
        // All new sales and return orders will appear as "Entered"
        if (arguments.systemCode == 'ostCanceled') {
            arguments.order.setOrderStatusType(getTypeService().getTypeBySystemCode(systemCode=arguments.systemCode, typeCode="9")); // "Deleted"
            orderStatusHistory.setOrderStatusHistoryType(getTypeService().getTypeBySystemCode(systemCode=arguments.systemCode, typeCode="9"));
       
        // Sales Orders
        } else if (arguments.order.getOrderType().getSystemCode() == 'otSalesOrder') {
            if (arguments.systemCode == 'ostNew') {
			

				//if the order is paid don't set to new, otherwise set to new (case of flexship)	
				if ( !isNull(arguments.order.getOrderTemplate()) ||  
					 ( arguments.order.getPaymentAmountDue() <= 0 && arguments.order.getQuantityUndelivered() > 0 )
				){
                    //the order is paid but not shipped
                    var type = getTypeService().getTypeByTypeCode( typeCode="paid");
				} 	

				if(!isNull(type)){	
					arguments.order.setOrderStatusType(type); 
					orderStatusHistory.setOrderStatusHistoryType(type);
				}	

				
			}else if (arguments.systemCode == 'ostProcessing') {
			
				//Set to processing status
                arguments.order.setOrderStatusType(getTypeService().getTypeBySystemCode(systemCode=arguments.systemCode, typeCode="2"));
                orderStatusHistory.setOrderStatusHistoryType(getTypeService().getTypeBySystemCode(systemCode=arguments.systemCode, typeCode="2"));
					
			}else if (arguments.systemCode == 'ostPaid') {

            	//If its paid and its shipped, set it to shipped.
            	if (arguments.order.getPaymentAmountDue() <= 0 && arguments.order.getQuantityUndelivered() == 0){
                	arguments.order.setOrderStatusType(getTypeService().getTypeBySystemCode(systemCode=arguments.systemCode, typeCode="5"));
                	orderStatusHistory.setOrderStatusHistoryType(getTypeService().getTypeBySystemCode(systemCode=arguments.systemCode, typeCode="5"));
            	}
            
            	
            }else if (arguments.systemCode == 'ostClosed') {
            	//If its paid and its shipped, make sure its shipped.
                arguments.order.setOrderStatusType(getTypeService().getTypeBySystemCode(systemCode=arguments.systemCode, typeCode="5"));
                orderStatusHistory.setOrderStatusHistoryType(getTypeService().getTypeBySystemCode(systemCode=arguments.systemCode, typeCode="5"));
            } else {
                super.updateOrderStatusBySystemCode(argumentCollection=arguments);
            }
        // Return Orders
        } else if (listFindNoCase('otReturnOrder,otExchangeOrder,otReplacementOrder,otRefundOrder', arguments.order.getTypeCode())) {
            if (arguments.systemCode == 'ostNew') {
		
				var type = getTypeService().getTypeBySystemCode( systemCode=arguments.systemCode, typeCode="1");
				if(!isNull(type)){	
					arguments.order.setOrderStatusType(type); 
					orderStatusHistory.setOrderStatusHistoryType(type);
				}	
				
			} else if (arguments.systemCode == 'ostProcessing') {
                // Order delivery items have been created but not fulfilled, need to be approved (confirmed) first
                arguments.order.setOrderStatusType(getTypeService().getTypeBySystemCode(systemCode=arguments.systemCode, typeCode="rmaReceived"));
                orderStatusHistory.setOrderStatusHistoryType(getTypeService().getTypeBySystemCode(systemCode=arguments.systemCode, typeCode="rmaReceived"));

                // If order delivery items have been fulfilled, it was approved
                //arguments.order.setOrderStatusType(getTypeService().getTypeBySystemCode(systemCode=arguments.systemCode, typeCode="rmaApproved"));
            } else if (arguments.systemCode == 'ostClosed') {

                // If order balance amount has all been refunded, it was released
                arguments.order.setOrderStatusType(getTypeService().getTypeBySystemCode(systemCode=arguments.systemCode, typeCode="rmaReleased"));
                orderStatusHistory.setOrderStatusHistoryType(getTypeService().getTypeBySystemCode(systemCode=arguments.systemCode, typeCode="rmaReleased"));
            }
        }
        
        //now save the order status history changes.
        if (!isStruct(orderStatusHistory) && !orderStatusHistory.hasErrors()){
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
		ordersItemsList.setDisplayProperties('quantity,price,sku.product.productName,sku.product.productID,sku.skuID,skuProductURL,skuImagePath,orderFulfillment.shippingAddress.streetAddress,orderFulfillment.shippingAddress.street2Address,orderFulfillment.shippingAddress.city,orderFulfillment.shippingAddress.stateCode,orderFulfillment.shippingAddress.postalCode,orderFulfillment.shippingAddress.name,orderFulfillment.shippingAddress.countryCode,orderFulfillment.shippingMethod.shippingMethodName');
		ordersItemsList.addFilter( 'order.orderID', arguments.data.orderID, '=');
		ordersItemsList.addFilter( 'order.account.accountID', arguments.data.accountID, '=');
		ordersItemsList.setPageRecordsShow(arguments.data.pageRecordsShow);
		ordersItemsList.setCurrentPageDeclaration(arguments.data.currentPage); 
		
		//Order payment data
		var orderPaymentList = this.getOrderPaymentCollectionList();
		orderPaymentList.setDisplayProperties('billingAddress.streetAddress,billingAddress.street2Address,billingAddress.city,billingAddress.stateCode,billingAddress.postalCode,billingAddress.name,billingAddress.countryCode,expirationMonth,expirationYear,order.calculatedFulfillmentTotal,order.calculatedSubTotal,order.calculatedTaxTotal,order.calculatedDiscountTotal,order.calculatedTotal,order.orderCountryCode,order.orderNumber,order.orderStatusType.typeName,order.calculatedPersonalVolumeTotal,creditCardLastFour,order.orderType.typeName');
		orderPaymentList.addFilter( 'order.orderID', arguments.data.orderID, '=');
		orderPaymentList.addFilter( 'order.account.accountID', arguments.data.accountID, '=');
		orderPaymentList.setPageRecordsShow(arguments.data.pageRecordsShow);
		orderPaymentList.setCurrentPageDeclaration(arguments.data.currentPage); 	
		
		//Order promotion data
		var orderPromotionList = getHibachiScope().getService('promotionService').getPromotionAppliedCollectionList();
		orderPromotionList.addDisplayProperties('discountAmount,currencyCode,promotion.promotionName')
		orderPromotionList.addFilter( 'order.orderID', arguments.data.orderID, '=');
		
		//Tracking info
		var orderDeliveriesList = this.getOrderDeliveryCollectionList();
		orderDeliveriesList.setDisplayProperties('trackingUrl')
		orderDeliveriesList.addFilter( 'order.orderID', arguments.data.orderID, '=');
		
		var orderPayments = orderPaymentList.getPageRecords();
		var orderItems = ordersItemsList.getPageRecords();
		var orderPromtions = orderPromotionList.getPageRecords();
		var orderDeliveries = orderDeliveriesList.getPageRecords();
		var orderItemData = {};
		
		orderItemData['orderPayments'] = orderPayments;
		orderItemData['orderItems'] = orderItems;
		orderItemData['orderPromtions'] = orderPromtions;
		orderItemData['orderRefundTotal'] = orderRefundTotal;
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
		
		logHibachi("updateOrderItemsWithAllocatedOrderDiscountAmount: END",true);
		
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
	    order.setOrderStatusType(getService('TypeService').getTypeByTypeCode('rmaApproved'));

	    return order;
	}

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
		var flexshipTypeID = getService('TypeService').getTypeBySystemCode('ottSchedule').getTypeID();
		
		if(arguments.orderTemplate.getOrderTemplateType().getTypeID() == flexshipTypeID){
			getHibachiScope().getSession().setCurrentFlexship( javaCast("null", "") );
			ORMExecuteQuery("UPDATE SlatwallSession s SET s.currentFlexship = NULL WHERE s.currentFlexship.orderTemplateID =:orderTemplateID", {orderTemplateID = arguments.orderTemplate.getOrderTemplateID()});
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

		// Setup a boolean to see if we were able to just add this order item to an existing one
		var foundItem = false;

		// Make sure that the currencyCode gets set for this order
		if(isNull(arguments.order.getCurrencyCode())) {
			arguments.order.setCurrencyCode( arguments.processObject.getCurrencyCode() );
		}

		// If this is a Sale Order Item then we need to setup the fulfillment
		if(listFindNoCase("oitSale,oitDeposit",arguments.processObject.getOrderItemTypeSystemCode())) {

			// First See if we can use an existing order fulfillment
			var orderFulfillment = processObject.getOrderFulfillment();
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
							fullAddressErrors = getHibachiValidationService().validate( arguments.processObject.getShippingAddress(), 'full', false );

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
					orderFulfillment = this.saveOrderFulfillment( orderFulfillment=orderFulfillment, updateOrderAmount=false );
                    //check the fulfillment and display errors if needed.
                    if (orderFulfillment.hasErrors()){
                        arguments.order.addError('addOrderItem', orderFulfillment.getErrors());
                    }

				} else {

					arguments.processObject.addError('fulfillmentMethodID', rbKey('validate.processOrder_addOrderitem.orderFulfillmentID.noValidFulfillmentMethod'));

				}

			}
			
			// Set Stock reference, check the fullfillment for a pickup location
			if (!isNull(orderFulfillment.getPickupLocation())){
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
			// Setup the Sku / Quantity / Price details
			addNewOrderItemSetup(newOrderItem, arguments.processObject);

			// If the sku is allowed to have a user defined price OR the current account has permissions to edit price
			if(
				(
					(!isNull(newOrderItem.getSku().getUserDefinedPriceFlag()) && newOrderItem.getSku().getUserDefinedPriceFlag())
					  ||
					(getHibachiScope().getLoggedInAsAdminFlag() && getHibachiAuthenticationService().authenticateEntityPropertyCrudByAccount(crudType='update', entityName='orderItem', propertyName='price', account=getHibachiScope().getAccount()))
				) && isNumeric(arguments.processObject.getPrice()) ) {
				newOrderItem.setPrice( arguments.processObject.getPrice() );
			} else {
				
				/******* CUSTOM CODE FOR MONAT *******/
				var priceByCurrencyCodeArgs = {
					'currencyCode' : arguments.order.getCurrencyCode(),
					'quantity' : arguments.processObject.getQuantity()
				};
				if(!isNull(	newOrderItem.getAppliedPriceGroup()) ){
					priceByCurrencyCodeArgs['priceGroups'] = [];
					arrayAppend(priceByCurrencyCodeArgs['priceGroups'], newOrderItem.getAppliedPriceGroup());
				}
				
				if(!isNull(	newOrderItem.getOrder().getAccount() ) && !newOrderItem.getOrder().getAccount().getNewFlag()){
					priceByCurrencyCodeArgs['accountID'] = newOrderItem.getOrder().getAccount().getAccountID();
				}
				newOrderItem.setPrice( arguments.processObject.getSku().getPriceByCurrencyCode( argumentCollection = priceByCurrencyCodeArgs ) );
				/******* END CUSTOM CODE FOR MONAT *******/
			}

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
				this.saveOrder(order=arguments.order, updateOrderAmount=arguments.processObject.getUpdateOrderAmountFlag());
			}

			// Save the new order items don't update order amounts we'll do it at the end of this process
			newOrderItem = this.saveOrderItem( orderItem=newOrderItem, updateOrderAmounts=false , updateCalculatedProperties=true);

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
						addOrderItemGiftRecipientProcessObject = arguments.order.getProcessObject('addOrderItemGiftRecipient', {
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
		arguments.order = this.saveOrder( order=arguments.order, updateOrderAmount=arguments.processObject.getUpdateOrderAmountFlag() );

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
		orderTemplateItemCollection.setDisplayProperties('orderTemplateItemID,sku.skuID,quantity,temporaryFlag'); 
		orderTemplateItemCollection.addFilter('orderTemplate.orderTemplateID', arguments.orderTemplate.getOrderTemplateID()); 

		var orderTemplateItems = orderTemplateItemCollection.getRecords();
		var temporaryItemFound = false;
		
		for(var orderTemplateItem in orderTemplateItems){ 

			if(!isNull(orderTemplateItem.temporaryFlag) && orderTemplateItem.temporaryFlag == true){
				temporaryItemFound = true;
			}
			var args = {
				'order'=arguments.order,
				'orderTemplateItemStruct'=orderTemplateItem,
				'orderTemplate'=arguments.orderTemplate
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

				orderFulfillment = this.saveOrderFulfillment(orderFulfillment);

				if (orderFulfillment.hasErrors()){
					//propegate to parent, because we couldn't create the fulfillment this order is not going to be placed
					arguments.order.addErrors(orderFulfillment.getErrors());	
					return arguments.order; 
				}	
			}	

			if(arguments.order.hasErrors()){
				this.logHibachi('OrderTemplate #arguments.orderTemplate.getOrderTemplateID()# has errors #serializeJson(arguments.order.getErrors())# when adding order item skuID: #orderTemplateItem['sku_skuID']#', true);
				arguments.order.clearHibachiErrors();
				arguments.orderTemplate.clearHibachiErrors();
				//try to place as much of the order as possible should only fail in OFY case
				continue;
			}
		}
		
		if(!temporaryItemFound){
			arguments.order = addDefaultOFYSkuIfEligible(arguments.order,arguments.orderTemplate,orderFulfillment);
		}
		
		return arguments.order;
	}
	
	public any function addDefaultOFYSkuIfEligible(required any order, required any orderTemplate, required any orderFulfillment){
		var defaultOFYSkuCode = arguments.orderTemplate.getAccount().getAccountCreatedSite().setting('siteDefaultOFYSkuCode');
		var skuCollection = getService('HibachiCollectionService').getSkuCollectionList();
		skuCollection.setCollectionConfigStruct(arguments.orderTemplate.getPromotionalFreeRewardSkuCollectionConfig());
		skuCollection.addFilter('skuCode',defaultOFYSkuCode);
		skuCollection.setDisplayProperties('skuID,skuCode');
		var result = skuCollection.getRecords();
		
		if(arrayLen(result)){
			var skuID = result[1].skuID;
			
			var orderTemplateItem = this.newOrderTemplateItem();
			orderTemplateItem.setTemporaryFlag(true);
			orderTemplateItem.setSku(getSkuService().getSku(skuID));
			orderTemplateItem.setQuantity(1);
			orderTemplateItem = this.saveOrderTemplateItem(orderTemplateItem);
			
			var orderTemplateItemStruct = {
				'sku_skuID'=skuID,
				'quantity'=1,
				'orderTemplateItemID'=orderTemplateItem.getOrderTemplateItemID(),
				'price'=0
			};
			
			arguments.order = this.addOrderItemFromTemplateItem(arguments.order, orderTemplateItemStruct, arguments.orderTemplate, arguments.orderFulfillment);
			arguments.order = this.saveOrder(arguments.order);
		}
		
		return arguments.order;
	}
	
	public any function getMarketPartnerEnrollmentOrderDateTime(required any account){
		var orderItemCollectionList = this.getOrderItemCollectionList();
		orderItemCollectionList.addFilter("order.orderStatusType.systemCode", "ostNotPlaced", "!=");
		orderItemCollectionList.addFilter("order.account.accountID", arguments.account.getAccountID());
		orderItemCollectionList.addFilter("order.monatOrderType.typeCode","motMPEnrollment");
		orderItemCollectionList.setDisplayProperties("order.orderOpenDateTime");// Date placed 
		orderItemCollectionList.setPageRecordsShow(1);
		var records = orderItemCollectionList.getRecords();
		
		if (arrayLen(records)){
		    return records[1]['order_orderOpenDateTime'];
		}
	}
	
	

	
}
