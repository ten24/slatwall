    
component extends="Slatwall.org.Hibachi.HibachiEventHandler" {

    public void function afterOrderProcess_updateStatusSuccess(required any slatwallScope, required any order, required any data ={}) {

        if(arguments.order.getStatusCode() != "osClosed"){
            return;
        }
        
        if(
            !arguments.order.getAccount().getOwnerAccount().hasAccountType("vip") ||
            !arguments.order.getAccount().hasAccountType("vip") ||
            arguments.order.getAccount().getFirstFlexshipOrder().getOrderID() != arguments.order.getOrderID()
        ){
            return;
        }
        
        var referee = arguments.order.getAccount();
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
            if(accruement.getRefereeFlag()){
                account = referee;
            }
            
    		var newAccountLoyalty = getService("AccountService").newAccountLoyalty();
    
    		newAccountLoyalty.setAccount( account );
    		newAccountLoyalty.setLoyalty( accruement.getLoyalty() );
    		newAccountLoyalty.setAccountLoyaltyNumber( getService("AccountService").getNewAccountLoyaltyNumber( accruement.getLoyalty().getLoyaltyID() ));
    
    		newAccountLoyalty = getService("AccountService").saveAccountLoyalty( newAccountLoyalty );
    
    		if(!newAccountLoyalty.hasErrors()) {
    			newAccountLoyalty = getService("AccountService").processAccountLoyalty(newAccountLoyalty, {order=arguments.order}, 'orderClosed');
    		}
    		
        }
    }
    public void function afterOrderProcess_createReturnSuccess(required any slatwallScope, required any order, required any data ={}) {
        
        if(arguments.order.getAccount().getFirstFlexshipOrder().getOrderID() != arguments.order.getOrderID()){
            return;
        }
        
        var referee = arguments.order.getAccount();
        var referer = referee.getOwnerAccount();
        
        var accountIDList = "";
        accountIDList = listAppend(accountIDList,referee.getAccountID());
        accountIDList = listAppend(accountIDList,referer.getAccountID());
        
        var transactionList = arguments.slatwallScope.getService("LoyaltyService").getAccountLoyaltyTransactionCollectionList();
        
        transactionList.setDisplayProperties("accountLoyaltyTransactionID");
        transactionList.addFilter("order.orderID",arguments.order.getOrderID());
        transactionList.addFilter("accountLoyalty.account.accountID",accountIDList,"IN");
        transactions = transactionList.getRecords();
        for(var transaction in transactions){
            
            transaction = getService("LoyaltyService").getAccountLoyaltyTransaction(transaction['accountLoyaltyTransactionID']);
            
            var promotionCode = transaction.getPromotionCode();
            var giftCard = transaction.getGiftCard();
            
            if(!isNull(promotionCode)){
                promotionCode.setEndDateTime(now());
                getService("promotionService").savePromotionCode(promotionCode);
			    getService("HibachiEventService").announceEvent("ReferAFriend_PromotionCodeRevoked", promotionCode);
            }
                        
            if(!isNull(giftCard)){
                var accruement = transaction.getLoyaltyAccruement();
                var accruementCurrency = accruement.getAccruementCurrency(arguments.order.getCurrencyCode());
    			var debitGiftCardProcessObject = giftCard.getProcessObject('addDebit');
			    debitGiftCardProcessObject.setDebitAmount(accruementCurrency.getGiftCardValue());
			    debitGiftCardProcessObject.setAllowNegativeBalanceFlag(true);
			    giftCard = getService("GiftCardService").processGiftCard_addDebit(giftCard, debitGiftCardProcessObject);
	            getService("giftCardService").saveGiftCard(giftCard);
			    getService("HibachiEventService").announceEvent("ReferAFriend_GiftCardDebiter", giftCard);
            }
        }
    }
}