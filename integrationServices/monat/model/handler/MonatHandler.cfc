component extends="Slatwall.org.Hibachi.HibachiEventHandler" {
    property name="OrderService";
    property name="AccounService";
    
    public any function afterOrderProcess_placeOrderSuccess(required any slatwallScope, required any order, required any data){
        
        var account = arguments.order.getAccount();

        if(!isNull(account.getAccountStatusType()) && account.getAccountStatusType().getTypeCode() == 'astEnrollmentPending'){
            account.setAccountStatusType(getService('typeService').getTypeByTypeCode('astGoodStanding'));
            account.getAccountNumber();
            account.setRenewalDate(now());
            getAccountService().saveAccount(account);
        }
   
        //set the commissionPeriod - this is wrapped in a try catch so nothing causes a place order to fail.
        try{
            var commissionDate = dateFormat( now(), "mm/yyyy" );
            order.setCommissionPeriod(commissionDate);
            getOrderService().saveOrder(order);
        }catch(any dateError){
            logHibachi("afterOrderProcess_placeOrderSuccess failed @ setCommissionPeriod using #commissionDate#");	
        }
    }
}
