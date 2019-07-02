component extends="Slatwall.org.Hibachi.HibachiEventHandler" {
    
    public void function beforeOrderProcess_create(any slatwallScope, any order, any data) {
        
        if ( isNull(order.getOrderCreatedSite())){
            order.setOrderCreatedSite(slatwallScope.getService("OrderService").getSiteBySiteCode("mura-default"));
        }
        
        if ( isNull(order.getCurrencyCode())){
            order.setCurrencyCode("USD");
        }
    }
}