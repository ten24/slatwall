    
component extends="Slatwall.org.Hibachi.HibachiEventHandler" {

    public void function afterOrderProcess_updateStatusSuccess(required any slatwallScope, required any order, required any data ={}) {
        
        if(arguments.order.getStatusCode != "osClosed"){
            return;
        }
        
        if(
            !this.order.getAccount().getOwnerAccount().hasAccountType("vip") ||
            !this.order.getAccount().hasAccountType("vip") ||
            this.order.getAccount().getFirstFlexshipOrder().getOrderID() != arguments.order.getOrderID()
        ){
            return;
        }
        
        var referee = this.order.getAccount();
        var referer = referee.getOwnerAccount();
        
        var accrList = arguments.slatwallScope.getService("LoyaltyService").getLoyaltyAccruementCollectionList();
        
        accrList.setDisplayProperties("loyaltyAccruementID");
        accrList.addFilter("loyalty.referAFriendFlag",true);
        accrList.addFilter("loyalty.activeFlag",true);
        accrList.addFilter("activeFlag",true);
        
        var accruements = accrList.getRecords();
        
        for(var accruement in accruements){
            accruement = arguments.slatwallScope.getService("LoyaltyService").getLoyaltyAccruement(accruement['loyaltyAccruementID']);
            var account = referer;
            if(accruement.geRefereeFlag()){
                account = referee;
            }
            
    		var newAccountLoyalty = getService("AccountService").newAccountLoyalty();
    
    		newAccountLoyalty.setAccount( account );
    		newAccountLoyalty.setLoyalty( accruement.getLoyalty() );
    		newAccountLoyalty.setAccountLoyaltyNumber( getService("AccountService").getNewAccountLoyaltyNumber( accruement.getLoyalty().getLoyaltyID() ));
    
    		newAccountLoyalty = getService("AccountService").saveAccountLoyalty( newAccountLoyalty );
    
    		if(!newAccountLoyalty.hasErrors()) {
    			newAccountLoyalty = getService("AccountService").processAccountLoyalty(newAccountLoyalty, {}, 'orderClosed');
    		}
    		
        }
    }
}