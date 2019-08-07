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
    
    public any function addReturnOrderItemSetup(required any returnOrderItem, required any originalOrderItem, required struct orderItemStruct){
        arguments.returnOrderItem = super.addReturnOrderItemSetup(argumentCollection=arguments);
        var sku = arguments.returnOrderItem.getSku();
        var account = arguments.returnOrderItem.getOrder().getAccount();
        if(isNull(account)){
            account = getService('AccountService').newAccount();
        }
        
        for(var priceField in variables.customPriceFields){
            var price = arguments.originalOrderItem.invokeMethod('get#priceField#');
            if(!isNull(price)){
                price = price * arguments.returnOrderItem.getPrice() / arguments.originalOrderItem.getPrice();
                arguments.returnOrderItem.invokeMethod('set#priceField#',{1=price});
            }
        }
        return arguments.returnOrderItem;
    }

    private void function updateOrderStatusBySystemCode(required any order, required string systemCode) {
        var orderStatusType = "";

        // All new sales and return orders will appear as "Entered"
        if (arguments.systemCode == 'ostNew') {
            arguments.order.setOrderStatusType(getTypeService().getTypeBySystemCode(systemCode=arguments.systemCode, typeCode="1")); // "Entered"

        } else if (arguments.systemCode == 'ostCanceled') {
            arguments.order.setOrderStatusType(getTypeService().getTypeBySystemCode(systemCode=arguments.systemCode, typeCode="9")); // "Deleted"
        // Sales Orders
        } else if (arguments.order.getOrderType().getSystemCode() == 'otSalesOrder') {
            if (arguments.systemCode == 'ostProcessing') {
                // Only advance to Ready to Print if no payment is due
                if (arguments.order.isOrderPaidFor()) {
                    arguments.order.setOrderStatusType(getTypeService().getTypeBySystemCode(systemCode=arguments.systemCode, typeCode="2")); // "Ready to print"
                    
                // Revert back to "Entered"
                } else if (arguments.order.getStatusCode() != 'ostNew') {
                    arguments.order.setOrderStatusType(getTypeService().getTypeBySystemCode(systemCode='ostNew', typeCode="1")); // "Entered"
                }
            } else if (arguments.systemCode == 'ostClosed') {
                arguments.order.setOrderStatusType(getTypeService().getTypeBySystemCode(systemCode=arguments.systemCode, typeCode="5"));
            } else {
                super.updateOrderStatusBySystemCode(argumentCollection=arguments);
            }
        // Return Orders
        } else if (listFindNoCase('otReturnOrder,otExchangeOrder,otReplacementOrder,otRefundOrder', arguments.order.getTypeCode())) {
            if (arguments.systemCode == 'ostProcessing') {
                // Order delivery items have been created but not fulfilled, need to be approved (confirmed) first
                arguments.order.setOrderStatusType(getTypeService().getTypeBySystemCode(systemCode=arguments.systemCode, typeCode="rmaReceived"));

                // If order delivery items have been fulfilled, it was approved
                //arguments.order.setOrderStatusType(getTypeService().getTypeBySystemCode(systemCode=arguments.systemCode, typeCode="rmaApproved"));
            } else if (arguments.systemCode == 'ostClosed') {

                // If order balance amount has all been refunded, it was released
                arguments.order.setOrderStatusType(getTypeService().getTypeBySystemCode(systemCode=arguments.systemCode, typeCode="rmaReleased"));
            }
        }
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

}