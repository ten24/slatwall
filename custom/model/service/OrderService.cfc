component extends="Slatwall.model.service.OrderService" {
    
    public any function processOrder_addOrderItem(required any order, required any processObject){
        var customPriceFields = 'personalVolume,taxableAmount,commissionableVolume,sponsorVolume,productPackVolume,retailValueVolume';
        writeDump('my d00d?');
        arguments.order = super.processOrder_addOrderItem(argumentCollection=arguments);
        var orderItems = arguments.order.getOrderItems();
        writeDump('my d00d');
        for(var orderItem in orderItems){
            writeDump('my d000d!');
            var sku = orderItem.getSku();
            for(var priceField in customPriceFields){
                if(isNull(orderItem.invokeMethod('get#priceField#'))){
                    orderItem.invokeMethod('set#priceField#',{1=sku.getCustomPriceByCurrencyCode( priceField, arguments.order.getCurrencyCode() )});
                }
            }
        }
        writeDump('my d00d?');
        return order;
    }
    
}