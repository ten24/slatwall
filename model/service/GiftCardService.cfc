/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.

    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms
    of your choice, provided that you follow these specific guidelines:

	- You also meet the terms and conditions of the license of each
	  independent module
	- You must not alter the default display of the Slatwall name or logo from
	  any part of the application
	- Your custom code must not alter or create any files inside Slatwall,
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets
	the above guidelines as a combined work under the terms of GPL for this program,
	provided that you include the source code of that other code when and as the
	GNU GPL requires distribution of source code.

    If you modify this program, you may extend this exception to your version
    of the program, but you are not obligated to do so.

Notes:

*/
component extends="HibachiService" persistent="false" accessors="true" output="false" {
	property name="settingService" type="any";
	property name="GiftCardDAO";
	// ===================== START: Logical Methods ===========================
	
	/**
     * Function to get list of gift cards for user
     * @param accountID optional
     * @param pageRecordsShow optional
     * @param currentPage optional
     * return struct of giftCards and total count
     **/
	public any function getGiftCardsOnAccount(required any account, struct data={}) {
        param name="arguments.data.currentPage" default=1;
        param name="arguments.data.pageRecordsShow" default= getHibachiScope().setting('GLOBALAPIPAGESHOWLIMIT');
		param name="arguments.data.giftCardCode" default="";
        param name="arguments.data.giftCardID" default="";
		

		var giftCardList = this.getGiftCardCollectionList();
		giftCardList.addFilter( 'ownerAccount.accountID', arguments.account.getAccountID() );

		if (len(arguments.data.giftCardCode)) {
			giftCardList.addFilter("giftCardCode", arguments.data.giftCardCode);
		} else if (len(arguments.data.giftCardID)) {
			giftCardList.addFilter("giftCardID", arguments.data.giftCardID);
		}

		giftCardList.setPageRecordsShow(arguments.data.pageRecordsShow);
		giftCardList.setCurrentPageDeclaration(arguments.data.currentPage); 
		
		return { 
			"giftCardsOnAccount":  giftCardList.getPageRecords(), 
			"recordsCount": giftCardList.getRecordsCount()
		};
	}
	
	// =====================  END: Logical Methods ============================

	// ===================== START: DAO Passthrough ===========================

	// ===================== START: DAO Passthrough ===========================

	// ===================== START: Process Methods ===========================
	public any function processGiftCard_create(required any giftCard, required any processObject){
		if(isNull(arguments.giftCard)){
			arguments.giftCard = this.newGiftCard();
		}

		arguments.giftCard.setGiftCardCode(arguments.processObject.getGiftCardCode());
		arguments.giftCard.setCurrencyCode(arguments.processObject.getCurrencyCode());
		arguments.giftCard.setGiftCardPin(arguments.processObject.getGiftCardPin()); //might be blank

		if(!isNull(arguments.processObject.getGiftCardExpirationTerm())){
			arguments.giftCard.setGiftCardExpirationTerm(arguments.processObject.getGiftCardExpirationTerm());
            if(getService("SettingService").getSettingValue("skuGiftCardEnforceExpirationTerm")){
                arguments.giftCard.setExpirationDate(arguments.processObject.getExpirationDate());
            }
		}
		
		if(!isNull(arguments.processObject.getCreditExpirationTerm())){
			arguments.giftCard.setCreditExpirationTerm(arguments.processObject.getCreditExpirationTerm());
		}

		if(!isNull(arguments.processObject.getOriginalOrderItem())){
			arguments.giftCard.setOriginalOrderItem(arguments.processObject.getOriginalOrderItem());
		}
		
		if(!isNull(arguments.processObject.getOrder())){
			arguments.giftCard.setOrder(arguments.processObject.getOrder());
		}
		
		if( !isNull(arguments.processObject.getSku()) ){
			arguments.giftCard.setSku(arguments.processObject.getSku());
		}

        if(!isNull(arguments.processObject.getOrderItemGiftRecipient())){
            arguments.giftCard.setOrderItemGiftRecipient(arguments.processObject.getOrderItemGiftRecipient());
        }

        if(!isNull(arguments.processObject.getOwnerAccount())){
			arguments.giftCard.setOwnerAccount(arguments.processObject.getOwnerAccount());
            giftCard.setOwnerEmailAddress(arguments.processObject.getOwnerEmailAddress());
		} else {
			if(!getDAO("AccountDAO").getPrimaryEmailAddressNotInUseFlag(arguments.processObject.getOwnerEmailAddress())){
				giftCard.setOwnerAccount(getService("HibachiService").get('Account', getDAO("AccountDAO").getAccountIDByPrimaryEmailAddress(arguments.processObject.getOwnerEmailAddress())));
				giftCard.setOwnerEmailAddress(arguments.processObject.getOwnerEmailAddress());
			} else {
				giftCard.setOwnerEmailAddress(arguments.processObject.getOwnerEmailAddress());
			}
		}

		if(!isNull(arguments.processObject.getOwnerFirstName())){
			arguments.giftCard.setOwnerFirstName(arguments.processObject.getOwnerFirstName());
		}

		if(!isNull(arguments.processObject.getOwnerLastName())){
			arguments.giftCard.setOwnerLastName(arguments.processObject.getOwnerLastName());
		}

		//is it time to credit the card
		if(arguments.processObject.getCreditGiftCardFlag()){
		    var amountToRedeem = arguments.giftCard.getSku().getRedemptionAmount(userDefinedPrice=arguments.giftCard.getPrice());
			var giftCardCreditTransaction = createCreditGiftCardTransaction(arguments.giftCard, amountToRedeem, arguments.processObject.getOrderPayments()[1]);
		
			if(!giftCardCreditTransaction.hasErrors()){
	            arguments.giftCard = this.saveGiftCard(arguments.giftCard);
			} else {
				arguments.giftCard.addErrors(giftCardCreditTransaction.getErrors());
			}
			
		}

		arguments.giftCard.setIssuedDate(now());

		return arguments.giftCard;

	}

	public any function processGiftCard_addCredit(required any giftCard, required any processObject){

		var giftCardCreditTransaction = createCreditGiftCardTransaction(arguments.giftCard, arguments.processObject.getCreditAmount(), arguments.processObject.getOrderPayment());

		if(!isNull(arguments.processObject.getReasonForAdjustment())){
			giftCardCreditTransaction.setReasonForAdjustment(arguments.processObject.getReasonForAdjustment());
			giftCardCreditTransaction.setAdjustedByAccount(getHibachiScope().getAccount());
		}
		
		if(!giftCardCreditTransaction.hasErrors()){
			arguments.giftCard.updateCalculatedProperties();
			arguments.giftCard = this.saveGiftCard(arguments.giftCard);
		} else {
			arguments.giftCard.addErrors(giftCardCreditTransaction.getErrors());
		}

		return arguments.giftCard;

	}

	public any function processGiftCard_addDebit(required any giftCard, required any processObject){

		var giftCardDebitTransaction = createDebitGiftCardTransaction(arguments.giftCard, arguments.processObject.getOrderItems(), arguments.processObject.getDebitAmount(), arguments.processObject.getOrderPayment(),arguments.processObject.getAllowNegativeBalanceFlag());
	
		if(!isNull(arguments.processObject.getReasonForAdjustment())){
			giftCardDebitTransaction.setReasonForAdjustment(arguments.processObject.getReasonForAdjustment());
			giftCardDebitTransaction.setAdjustedByAccount(getHibachiScope().getAccount());
		}
			
		if(!giftCardDebitTransaction.hasErrors()){
			
			if(arguments.giftCard.getBalanceAmount() == 0){
				arguments.giftCard.setActiveFlag(false);//this will trigger updateCalculateProperties to run when gift card is saved
			} else {
			    arguments.giftCard.updateCalculatedProperties();
			}
			arguments.giftCard = this.saveGiftCard(arguments.giftCard);
		} else {
			
			arguments.giftCard.addErrors(giftCardDebitTransaction.getErrors());
		}

		return arguments.giftCard;

	}

	public any function processGiftCard_offlineTransaction(required any giftCard, required any processObject){

       if(arguments.processObject.getTransactionType() == 'credit'){

         	var creditData = {
         		creditAmount=arguments.processObject.getAmount(),
         		reasonForAdjustment=arguments.processObject.getReasonForAdjustment()
         	};

            return this.processGiftCard(arguments.GiftCard, creditData, 'addCredit'); 
       
       } else if (arguments.processObject.getTransactionType() == 'debit'){
	
            var debitData = {
            	debitAmount=arguments.processObject.getAmount(),
            	allowNegativeBalanceFlag=getService("SettingService").getSettingValue("globalGiftCardAllowNegativeBalance"),
         		reasonForAdjustment=arguments.processObject.getReasonForAdjustment()
            };
            
            if(
            	!debitData.allowNegativeBalanceFlag
            	&& debitData.debitAmount > arguments.giftCard.getBalanceAmount()
            ){
				arguments.giftCard.addError("ownerAccount", rbKey('validate.offlineTransaction.GiftCard_OfflineTransaction.amount.lteProperty.giftCardBalanceAmount'));
            }
            
            return this.processGiftCard(arguments.giftCard, debitData, 'addDebit'); 
       
       }
       return arguments.giftCard; 
	} 

	public any function processGiftCard_changeExpirationDate(required any giftCard, required any processObject){

		arguments.giftCard.setExpirationDate(arguments.processObject.getNewExpirationDate());

		if(!giftCard.hasErrors()){
			this.saveGiftCard(arguments.giftCard);
		}

		return arguments.giftCard;
	}

	public any function processGiftCard_updateEmailAddress(required any giftCard, required any processObject){

		if(!getDAO("AccountDAO").getPrimaryEmailAddressNotInUseFlag(processObject.getEmailAddress())){
			arguments.giftCard.setOwnerAccount(getService("HibachiService").get('Account', getDAO("AccountDAO").getAccountIDByPrimaryEmailAddress(arguments.processObject.getEmailAddress())));
			arguments.giftCard.setOwnerEmailAddress(arguments.processObject.getEmailAddress());
		} else {
			arguments.giftCard.setOwnerEmailAddress(arguments.processObject.getEmailAddress());
		}

		arguments.giftCard.getOrderItemGiftRecipient().setEmailAddress(arguments.processObject.getEmailAddress());

		arguments.giftCard = this.save(arguments.giftCard);

		if(!arguments.giftCard.hasErrors()){
			var cardData = {};
			cardData.entity=arguments.giftCard;
			//resend email
			getService("hibachiEventService").announceEvent(eventName="afterGiftCardProcess_createSuccess", eventData=cardData);
		}

		return arguments.giftCard;
	}

	public any function processGiftCard_redeemToAccount(required any giftCard, required any processObject){

		if(!isNull(arguments.processObject.getAccount())){
			arguments.giftCard.setOwnerAccount(arguments.processObject.getAccount());
		} else {
			arguments.giftCard.addError("ownerAccount", rbKey('admin.entity.processgiftcard.redeemToAccount_failure'));
		}

		if(!arguments.giftCard.hasErrors()){
			arguments.giftCard = this.saveGiftCard(arguments.giftCard);
		}

		return arguments.giftCard;

	}

	public any function processGiftCard_toggleActive(required any giftCard, required any processObject,struct data={}){

		arguments.giftCard.setActiveFlag(arguments.data.activeFlag);

		return this.saveGiftCard(arguments.giftCard);

	}

	public any function processOrder_failedGiftRecipient(required any giftCard, required any processObject){

		//Set the gift card to the orderer's email temporarily
		arguments.giftCard.setOwnerAddress(giftCard.getOrder().getAccount().getPrimaryEmailAddress().getEmailAddress());

		arguments.giftCard = this.saveGiftCard(arguments.giftCard);

		return arguments.giftCard;

	}

	private any function createDebitGiftCardTransaction(required any giftCard, required any orderItems, required any amountToDebit, any orderPayment, boolean allowNegativeBalanceFlag){

		var debitGiftTransaction = this.newGiftCardTransaction();

        if(arguments.amountToDebit > arguments.giftCard.getBalanceAmount() && !arguments.allowNegativeBalanceFlag){
            arguments.amountToDebit = arguments.giftcard.getBalanceAmount(); 
        }

		debitGiftTransaction.setDebitAmount(arguments.amountToDebit);
		debitGiftTransaction.setGiftCard(arguments.giftCard);
		debitGiftTransaction.setCurrencyCode(arguments.giftCard.getCurrencyCode());
		
		if(structKeyExists(arguments, "orderPayment") && !isNull(arguments.orderPayment)){
		    debitGiftTransaction.setOrderPayment(arguments.orderPayment);
        }

		for(var item in arguments.orderItems){
			debitGiftTransaction.addOrderItem(item);
		}

		return this.saveGiftCardTransaction(debitGiftTransaction);

	}

	private any function createCreditGiftCardTransaction(required any giftCard, required any amountToCredit, any orderPayment){

		var creditGiftTransaction = this.newGiftCardTransaction();

		creditGiftTransaction.setCreditAmount(arguments.amountToCredit);
		creditGiftTransaction.setGiftCard(arguments.giftCard);
		creditGiftTransaction.setCurrencyCode(arguments.giftCard.getCurrencyCode());

		if(structKeyExists(arguments, "orderPayment") && !isNull(arguments.orderPayment)){
            creditGiftTransaction.setOrderPayment(arguments.orderPayment);
        }
        
        if(arguments.giftCard.hasCreditExpirationTerm()){
        	var endDate = arguments.giftCard.getCreditExpirationTerm().getEndDate();
        	creditGiftTransaction.setExpirationDate(endDate);
        }

		return this.saveGiftCardTransaction(creditGiftTransaction);
	}
	
	public void function processGiftCard_debitExpiredGiftCardCredits(){
		var expiredCreditsList = getGiftCardDAO().getExpiredCreditsList();
		var emptyArray = [];
		
		for(var item in expiredCreditsList){
			var giftCard = this.getGiftCard(item.giftCardID);
			var processObject = giftCard.getProcessObject('addDebit');
			processObject.setGiftCard(giftCard);
			processObject.setDebitAmount(item.netExpiredCredit);
			processObject.setReasonForAdjustment('Expired Credit');
			giftCard = this.processGiftCard(giftCard,processObject,'addDebit');
		}
	}
	
	// =====================  END: Process Methods ============================

	// ====================== START: Save Overrides ===========================

	// ======================  END: Save Overrides ============================

	// ==================== START: Smart List Overrides =======================

	// ====================  END: Smart List Overrides ========================

	// ====================== START: Get Overrides ============================

	// ======================  END: Get Overrides =============================

}
