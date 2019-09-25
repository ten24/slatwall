component extends="Slatwall.model.service.OrderService" {
    variables.customPriceFields = 'personalVolume,taxableAmount,commissionableVolume,retailCommission,productPackVolume,retailValueVolume';
    public string function getCustomAvailableProperties() {
        return 'orderItems.personalVolume,orderItems.calculatedExtendedPersonalVolume,calculatedPersonalVolumeSubtotal';
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
                arguments.newOrderItem.invokeMethod('set#priceField#',{1=sku.getCustomPriceByCurrencyCode( priceField, arguments.newOrderItem.getOrder().getCurrencyCode(), arguments.newOrderItem.getQuantity(), account)});
            }
        }
        
        return arguments.newOrderItem;
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
        var sku = returnOrderItem.getSku();
        var account = returnOrderItem.getOrder().getAccount();
        if(isNull(account)){
            account = getService('AccountService').newAccount();
        }
        
        for(var priceField in variables.customPriceFields){
            var price = arguments.originalOrderItem.invokeMethod('getCustomExtendedPriceAfterDiscount',{1=priceField});
            if(!isNull(price)){
                price = price * returnOrderItem.getPrice() / arguments.originalOrderItem.getExtendedPriceAfterDiscount();
                returnOrderItem.invokeMethod('set#priceField#',{1=price});
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

    private any function getOrderTemplateItemCollectionForAccount(required struct data, any account=getHibachiScope().getAccount()){
        param name="arguments.data.pageRecordsShow" default=5;
        param name="arguments.data.currentPage" default=1;
        param name="arguments.data.orderTemplateID" default="";
		param name="arguments.data.orderTemplateTypeID" default="2c948084697d51bd01697d5725650006"; 
		
		var orderTemplateItemCollection = this.getOrderTemplateItemCollectionList();
		
		var displayProperties = 'orderTemplateItemID,skuProductURL,skuAdjustedPricing.adjustedPriceForAccount,skuAdjustedPricing.vipPrice,quantity,sku.skuCode,sku.imagePath,sku.product.productName,sku.skuDefinition';  
		

		orderTemplateItemCollection.setDisplayProperties(displayProperties);
		orderTemplateItemCollection.setPageRecordsShow(arguments.data.pageRecordsShow);
		orderTemplateItemCollection.setCurrentPageDeclaration(arguments.data.currentPage); 
		
		orderTemplateItemCollection.addFilter('orderTemplate.orderTemplateType.typeID', arguments.data.orderTemplateTypeID);
		orderTemplateItemCollection.addFilter('orderTemplate.orderTemplateID', arguments.data.orderTemplateID);
		orderTemplateItemCollection.addFilter('orderTemplate.account.accountID', arguments.account.getAccountID());

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
        if (arguments.systemCode == 'ostNew') {
            arguments.order.setOrderStatusType(getTypeService().getTypeBySystemCode(systemCode=arguments.systemCode, typeCode="1")); // "Entered"
            orderStatusHistory.setOrderStatusHistoryType(getTypeService().getTypeBySystemCode(systemCode=arguments.systemCode, typeCode="1"));
            
        } else if (arguments.systemCode == 'ostCanceled') {
            arguments.order.setOrderStatusType(getTypeService().getTypeBySystemCode(systemCode=arguments.systemCode, typeCode="9")); // "Deleted"
            orderStatusHistory.setOrderStatusHistoryType(getTypeService().getTypeBySystemCode(systemCode=arguments.systemCode, typeCode="9"));
       
        // Sales Orders
        } else if (arguments.order.getOrderType().getSystemCode() == 'otSalesOrder') {
            if (arguments.systemCode == 'ostProcessing') {
                
                //if the order is paid but not shipped, set to Paid status
                if (arguments.order.getPaymentAmountDue() <= 0 && arguments.order.getQuantityUndelivered() > 0){
                    //the order is paid but not shipped
                    arguments.order.setOrderStatusType(getTypeService().getTypeByTypeCode( typeCode="paid"));
                    orderStatusHistory.setOrderStatusHistoryType(getTypeService().getTypeByTypeCode( typeCode="paid"));
                }else{
                    // set to processing
                    arguments.order.setOrderStatusType(getTypeService().getTypeBySystemCode(systemCode=arguments.systemCode, typeCode="2"));
                    orderStatusHistory.setOrderStatusHistoryType(getTypeService().getTypeBySystemCode(systemCode=arguments.systemCode, typeCode="2"));
                }
                
            } else if (arguments.systemCode == 'ostClosed') {
                arguments.order.setOrderStatusType(getTypeService().getTypeBySystemCode(systemCode=arguments.systemCode, typeCode="5"));
                orderStatusHistory.setOrderStatusHistoryType(getTypeService().getTypeBySystemCode(systemCode=arguments.systemCode, typeCode="5"));
            } else {
                super.updateOrderStatusBySystemCode(argumentCollection=arguments);
            }
        // Return Orders
        } else if (listFindNoCase('otReturnOrder,otExchangeOrder,otReplacementOrder,otRefundOrder', arguments.order.getTypeCode())) {
            if (arguments.systemCode == 'ostProcessing') {
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
	
	public any function getOrderItemsByOrderID(struct data={}) {
        param name="arguments.data.orderID" default="";
        param name="arguments.data.accountID" default=getHibachiSCope().getAccount().getAccountID();
        param name="arguments.data.currentPage" default=1;
        param name="arguments.data.pageRecordsShow" default=10;
        

		var ordersItemsList = getHibachiScope().getService('OrderService').getOrderItemCollectionList();
		
		ordersItemsList.setDisplayProperties('quantity,price,sku.skuName,skuProductURL,skuImagePath,orderFulfillment.shippingAddress.streetAddress,orderFulfillment.shippingAddress.street2Address,orderFulfillment.shippingAddress.city,orderFulfillment.shippingAddress.stateCode,orderFulfillment.shippingAddress.postalCode,orderFulfillment.shippingAddress.name,orderFulfillment.shippingAddress.countryCode,order.billingAddress.streetAddress,order.billingAddress.street2Address,order.billingAddress.city,order.billingAddress.stateCode,order.billingAddress.postalCode,order.billingAddress.name,order.billingAddress.countryCode,orderFulfillment.shippingMethod.shippingMethodName,order.fulfillmentTotal,order.calculatedSubTotal,order.taxTotal,order.discountTotal,order.total,mainCreditCardOnOrder,MainCreditCardExpirationDate,mainPromotionOnOrder,order.orderCountryCode,order.orderNumber,order.orderStatusType.typeName');
		
		ordersItemsList.addFilter( 'order.orderID', arguments.data.orderID, '=');
		ordersItemsList.addFilter( 'order.account.accountID', arguments.data.accountID, '=');
		ordersItemsList.setPageRecordsShow(arguments.data.pageRecordsShow);
		ordersItemsList.setCurrentPageDeclaration(arguments.data.currentPage); 
		
		return ordersItemsList.getPageRecords();

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
	    arguments.order.setOrderStatusType(getService('TypeService').getTypeByTypeCode('rmaReleased'));
	    return order;
	}
	
	public any function processOrder_approveReturn(required any order, any processObject, struct data){
	    
	    if(!isNull(arguments.processObject.getOrderItems()) &&arrayLen(arguments.processObject.getOrderItems())){
	        for(var orderItem in arguments.processObject.getOrderItem()){
	            orderItem = this.getOrderItem(orderItem.orderItemID);
	            orderItem.setQuantity(orderItem.quantity);
	        }
	    }
	    order.setOrderStatusType(getService('TypeService').getTypeByTypeCode('rmaApproved'));
	    return order;
	}

}
