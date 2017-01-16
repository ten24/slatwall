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

	// ===================== START: Logical Methods ===========================

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

		if(!isNull(arguments.processObject.getOriginalOrderItem())){
			arguments.giftCard.setOriginalOrderItem(arguments.processObject.getOriginalOrderItem());
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
		    var amountToRedeem = arguments.giftCard.getOriginalOrderItem().getSku().getRedemptionAmount(userDefinedPrice=arguments.giftCard.getOriginalOrderItem().getPrice());
			var giftCardCreditTransaction = createCreditGiftCardTransaction(arguments.giftCard, amountToRedeem, arguments.processObject.getOrderPayments()[1]);
		}

		arguments.giftCard.setIssuedDate(now());

		if(!giftCardCreditTransaction.hasErrors()){
            		arguments.giftCard = this.saveGiftCard(arguments.giftCard);
		} else {
			arguments.giftCard.addErrors(giftCardCreditTransaction.getErrors());
		}


		return arguments.giftCard;

	}

	public any function processGiftCard_addCredit(required any giftCard, required any processObject){

		var giftCardCreditTransaction = createCreditGiftCardTransaction(arguments.giftCard, arguments.processObject.getCreditAmount(), arguments.processObject.getOrderPayment());

		if(!giftCardCreditTransaction.hasErrors()){
			arguments.giftCard.updateCalculatedProperties();
			arguments.giftCard = this.saveGiftCard(arguments.giftCard);
		} else {
			arguments.giftCard.addErrors(giftCardCreditTransaction.getErrors());
		}

		return arguments.giftCard;

	}

	public any function processGiftCard_addDebit(required any giftCard, required any processObject){

		var giftCardDebitTransaction = createDebitGiftCardTransaction(arguments.giftCard, arguments.processObject.getOrderItems(), arguments.processObject.getDebitAmount(), arguments.processObject.getOrderPayment());

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
         		creditAmount=arguments.processObject.getAmount()
         	};

            return this.processGiftCard(arguments.GiftCard, creditData, 'addCredit'); 
       
       } else if (arguments.processObject.getTransactionType() == 'debit'){

            var debitData = {
            	debitAmount=arguments.processObject.getAmount()
            };
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

	public any function processGiftCard_toggleActive(required any giftCard, required any processObject){

		arguments.giftCard.setActiveFlag(processObject.getActiveFlag());

		return this.saveGiftCard(arguments.giftCard);

	}

	public any function processOrder_failedGiftRecipient(required any giftCard, required any processObject){

		//Set the gift card to the orderer's email temporarily
		arguments.giftCard.setOwnerAddress(giftCard.getOrder().getAccount().getPrimaryEmailAddress().getEmailAddress());

		arguments.giftCard = this.saveGiftCard(arguments.giftCard);

		return arguments.giftCard;

	}

	private any function createDebitGiftCardTransaction(required any giftCard, required any orderItems, required any amountToDebit, any orderPayment){

		var debitGiftTransaction = this.newGiftCardTransaction();

        if(arguments.amountToDebit > arguments.giftCard.getBalanceAmount()){
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

		return this.saveGiftCardTransaction(creditGiftTransaction);
	}
	// =====================  END: Process Methods ============================

	// ====================== START: Save Overrides ===========================

	// ======================  END: Save Overrides ============================

	// ==================== START: Smart List Overrides =======================

	// ====================  END: Smart List Overrides ========================

	// ====================== START: Get Overrides ============================

	// ======================  END: Get Overrides =============================

}
