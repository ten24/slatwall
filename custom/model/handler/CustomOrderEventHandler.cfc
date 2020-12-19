    
component extends="Slatwall.org.Hibachi.HibachiEventHandler" {

    public void function afterOrderProcess_cancelOrderFailure(required any slatwallScope, required any order, required any data ={}) {
        
        if(arguments.order.getStatusCode() == "ostCanceled"){
            arguments.order.clearHibachiErrors();
        }
        
    }

    public void function afterOrderProcess_placeInProcessingOneFailure(required any slatwallScope, required any order, required any data ={}) {
        
        if(arguments.order.getOrderStatusType().getTypeCode() == "processing1"){
            arguments.order.clearHibachiErrors();
        }
        
    }

    public void function afterOrderProcess_releaseCreditsSuccess(required any slatwallScope, required any order, required any data ={}) {
        
        if(arguments.order.getTypeCode() == "otReturnOrder"){
            this.clawbackReferAFriendBenefits(argumentCollection=arguments);
        }
        
    }

    public void function afterOrderProcess_updateStatusSuccess(required any slatwallScope, required any order, required any data ={}) {
        if(arguments.order.getStatusCode() != "ostClosed"){
            return;
        }
        
        if(arguments.order.getTypeCode() != "otSalesOrder"){
            return;
        }
        
        if(
            !isNull(arguments.order.getAccount()) && 
            !isNull(arguments.order.getAccount().getOwnerAccount()) && 
            !isNull(arguments.order.getAccount().getOwnerAccount().getAccountType()) && 
            arguments.order.getAccount().getOwnerAccount().getAccountType() != "VIP" ||
            !arguments.order.getVipEnrollmentOrderFlag()
        ){
            return;
        }
        
        var referee = arguments.order.getAccount();
        var referer = referee.getOwnerAccount();
        
        var accrList = arguments.slatwallScope.getService("LoyaltyService").getLoyaltyAccruementCollectionList();
        
        accrList.setDisplayProperties("loyaltyAccruementID,");
        accrList.addFilter("loyalty.referAFriendFlag",true);
        accrList.addFilter("loyalty.activeFlag",true);
        accrList.addFilter("activeFlag",true);
        
        accrList.addFilter(propertyIdentifier="accruementCurrencies.currencyCode",value=arguments.order.getCurrencyCode());

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
    			newAccountLoyalty = getService("AccountService").processAccountLoyalty(newAccountLoyalty, {order=arguments.order,loyaltyAccruement=accruement}, 'referAFriend');
    		}
        }
    }
    
    private void function clawbackReferAFriendBenefits(required any slatwallScope, required any order, required any data ={}) {
        if(!arguments.order.getVIPEnrollmentOrderFlag()){
            return;
        }

        var referee = arguments.order.getAccount();
        var referer = referee.getOwnerAccount();
        
        var accountIDList = "";
        accountIDList = listAppend(accountIDList,referee.getAccountID());
        accountIDList = listAppend(accountIDList,referer.getAccountID());
        
        var transactionList = arguments.slatwallScope.getService("LoyaltyService").getAccountLoyaltyTransactionCollectionList();
        
        transactionList.setDisplayProperties("accountLoyaltyTransactionID");
        transactionList.addFilter("order.orderID",arguments.order.getReferencedOrder().getOrderID());
        transactionList.addFilter("accountLoyalty.account.accountID",accountIDList,"IN");
        transactions = transactionList.getRecords();

        for(var transaction in transactions){
            
            transaction = getService("LoyaltyService").getAccountLoyaltyTransaction(transaction['accountLoyaltyTransactionID']);
            
            var promotionCode = transaction.getPromotionCode();
            var giftCard = transaction.getGiftCard();
            
            if(!isNull(promotionCode)){
                promotionCode.setEndDateTime(now());
                promotionCode.setMaximumUseCount(0);
                promotionCode.setMaximumAccountUseCount(0);
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
