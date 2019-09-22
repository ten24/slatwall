component extends="Slatwall.model.service.OrderService" {

    public string function getCustomAvailableProperties() {
        return 'orderItems.personalVolume,orderItems.calculatedExtendedPersonalVolume,calculatedPersonalVolumeSubtotal';
    }
    
    public any function processOrder_addOrderItem(required any order, required any processObject){
        var customPriceFields = 'personalVolume,taxableAmount,commissionableVolume,retailCommission,productPackVolume,retailValueVolume';
        arguments.order = super.processOrder_addOrderItem(argumentCollection=arguments);
        var orderItems = arguments.order.getOrderItems();
        for(var orderItem in orderItems){
            var sku = orderItem.getSku();
            for(var priceField in customPriceFields){
                if(isNull(orderItem.invokeMethod('get#priceField#'))){
                    orderItem.invokeMethod('set#priceField#',{1=sku.getCustomPriceByCurrencyCode( priceField, arguments.order.getCurrencyCode(), orderItem.getQuantity(), arguments.order.getAccount().getPriceGroups() )});
                }
            }
        }

        return order;
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
    
	public any function getOrdersOnAccount(struct data={}) {
        param name="arguments.data.currentPage" default=1;
        param name="arguments.data.pageRecordsShow" default=5;
        param name="arguments.data.accountID" default="";
        param name="arguments.data.orderID" default= false;
        
		var ordersList = getHibachiSCope().getAccount().getOrdersCollectionList();

		ordersList.addOrderBy('orderOpenDateTime|DESC');
		ordersList.setDisplayProperties('
			orderID,
			orderNumber,
			orderStatusType.typeName,
			orderFulfillments.shippingAddress.streetAddress,
			orderFulfillments.shippingAddress.street2Address,
			orderFulfillments.shippingAddress.city,
			orderFulfillments.shippingAddress.stateCode,
			orderFulfillments.shippingAddress.postalCode
		');
		
		ordersList.addFilter( 'account.accountID', arguments.data.accountID, '=');
		ordersList.addFilter( 'orderStatusType.systemCode', 'ostNotPlaced', '!=');
		ordersList.addFilter( 'orderStatusType.systemCode', 'ostNew,ostProcessing', 'IN' );
		
		if(arguments.data.orderID != false){
		    ordersList.addFilter( 'orderID', arguments.data.orderID, '=' );
		}
		
		ordersList.setPageRecordsShow(arguments.data.pageRecordsShow);
		ordersList.setCurrentPageDeclaration(arguments.data.currentPage); 
		
		return ordersList.getPageRecords();
	}
	
	public any function getOrderItemsByOrderID(struct data={}) {
        param name="arguments.data.orderID" default="";
        param name="arguments.data.currentPage" default=1;
        param name="arguments.data.pageRecordsShow" default=10;
        

		var ordersItemsList = getHibachiScope().getService('OrderService').getOrderItemCollectionList();
		
		ordersItemsList.setDisplayProperties('quantity,price,sku.skuName,skuProductURL,skuImagePath,orderFulfillment.shippingAddress.streetAddress,orderFulfillment.shippingAddress.street2Address,orderFulfillment.shippingAddress.city,orderFulfillment.shippingAddress.stateCode,orderFulfillment.shippingAddress.postalCode,orderFulfillment.shippingAddress.name,orderFulfillment.shippingAddress.countryCode,order.billingAddress.streetAddress,order.billingAddress.street2Address,order.billingAddress.city,order.billingAddress.stateCode,order.billingAddress.postalCode,order.billingAddress.name,order.billingAddress.countryCode,orderFulfillment.shippingMethod.shippingMethodName,order.fulfillmentTotal,order.calculatedSubTotal,order.taxTotal,order.discountTotal,order.total,mainCreditCardOnOrder,MainCreditCardExpirationDate');
		
		ordersItemsList.addFilter( 'order.orderID', arguments.data.orderID, '=');
		ordersItemsList.setPageRecordsShow(arguments.data.pageRecordsShow);
		ordersItemsList.setCurrentPageDeclaration(arguments.data.currentPage); 
		
		return ordersItemsList.getPageRecords();

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
}