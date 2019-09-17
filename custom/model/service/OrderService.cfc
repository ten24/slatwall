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

        // All new sales and return orders will appear as "Entered"
        if (arguments.systemCode == 'ostNew') {
            arguments.order.setOrderStatusType(getTypeService().getTypeBySystemCode(systemCode=arguments.systemCode, typeCode="1")); // "Entered"

        } else if (arguments.systemCode == 'ostCanceled') {
            arguments.order.setOrderStatusType(getTypeService().getTypeBySystemCode(systemCode=arguments.systemCode, typeCode="9")); // "Deleted"
        // Sales Orders
        } else if (arguments.order.getOrderType().getSystemCode() == 'otSalesOrder') {
            if (arguments.systemCode == 'ostProcessing') {
                arguments.order.setOrderStatusType(getTypeService().getTypeBySystemCode(systemCode=arguments.systemCode, typeCode="2"));
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