component extends="Slatwall.org.Hibachi.HibachiEventHandler" {
    property name="OrderService";
    
    public any function afterOrderProcess_placeOrderSuccess(required any slatwallScope, required any order, required any data){
   
        //set the commissionPeriod - this is wrapped in a try catch so nothing causes a place order to fail.
        try{
            var commissionDate = dateFormat( now(), "mm/yyyy" );
            order.setCommissionPeriod(commissionDate);
            getOrderService().saveOrder(order);
        }catch(dateError){
            logHibachi("afterOrderProcess_placeOrderSuccess failed @ setCommissionPeriod using #commissionDate#");	
        }
    }
}
