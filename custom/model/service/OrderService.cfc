component extends="Slatwall.model.service.OrderService" {
    
    public any function addNewOrderItemSetup(required any newOrderItem, required any processObject) {
        super.addNewOrderItemSetup(argumentCollection=arguments);
        
        var sku = arguments.newOrderItem.getSku();
        var customPriceFields = 'personalVolume,taxableAmount,commissionableVolume,retailCommission,productPackVolume,retailValueVolume';
        for(var priceField in customPriceFields){
            if(isNull(arguments.newOrderItem.invokeMethod('get#priceField#'))){
                arguments.newOrderItem.invokeMethod('set#priceField#',{1=sku.getCustomPriceByCurrencyCode( priceField, arguments.newOrderItem.getOrder().getCurrencyCode() )});
            }
        }
        
        return arguments.newOrderItem;
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

}