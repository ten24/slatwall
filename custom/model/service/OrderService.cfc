component extends="Slatwall.model.service.OrderService" {
    
    public any function processOrder_addOrderItem(required any order, required any processObject){
        var customPriceFields = 'personalVolume,taxableAmount,commissionableVolume,sponsorVolume,productPackVolume,retailValueVolume';
        
        arguments.order = super.processOrder_addOrderItem(argumentCollection=arguments);
        var orderItems = arguments.order.getOrderItems();
        for(var orderItem in orderItems){
            var sku = orderItem.getSku();
            for(var priceField in customPriceFields){
                if(isNull(orderItem.invokeMethod('get#priceField#'))){
                    orderItem.invokeMethod('set#priceField#',{1=sku.invokeMethod('get#priceField#')});
                }
            }
        }
        return order;
    }
    
}