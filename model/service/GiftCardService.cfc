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
		arguments.giftCard.setGiftCardPin(arguments.processObject.getGiftCardPin()); //might be blank
		arguments.giftCard.setExpirationDate(arguments.processObject.getExpirationDate()); 
		
		if(!arguments.giftCard.hasGiftCardExpirationTerm(arguments.processObject.getGiftCardExpirationTerm())){
			arguments.giftCard.setGiftCardExpirationTerm(arguments.processObject.getGiftCardExpirationTerm());
		} 
		
		if(!arguments.giftCard.hasOriginalOrderItem(arguments.processObject.getOriginalOrderItem())){
			arguments.giftCard.setOriginalOrderItem(arguments.processObject.getOriginalOrderItem());
		}
		
		//is it time to credit the card
		if(arguments.processObject.creditGiftCard()){
			var giftCardCreditTransaction = this.createCreditGiftCardTransaction(arguments.giftCard, arguments.processObject.getOrderPayments(), arguments.giftCard.getOriginalOrderItem().getSku().getGiftCardRedemptionAmount());			
		}
		
		if(arguments.processObject.hasOwnerAccount()){ 
			arguments.giftCard.setOwnerAccount(arguments.processObject.getOwnerAccount()); 	
		} else { 
			arguments.giftCard.setOwnerFirstName(arguments.processObject.getOwnerFirstName()); 
			arguments.giftCard.setOwnerLastName(arguments.processObject.getOwnerLastName()); 	
			arguments.giftCard.setOwnerEmailAddress(arguments.processObject.getOwnerEmailAddress()); 
		}
		
		if(!giftCardCreditTransaction.hasErrors()){ 
			arguments.giftCard = this.saveGiftCard(arguments.giftCard); 	
		} else { 
			arguments.giftCard.addErrors(giftCardCreditTransaction.getErrors());
		}
		
		return arguments.giftCard; 
		
	}
	
	public any function processGiftCard_addCredit(required any giftCard, required any processObject){
		
		var giftCardCreditTransaction = this.createCreditGiftCardTransaction(arguments.giftCard, arguments.processObject.getOrderPayments(), arguments.giftCard.getOriginalOrderItem().getSku().getGiftCardRedemptionAmount());
		
		if(!giftCardCreditTransaction.hasErrors()){ 
			arguments.giftCard = this.saveGiftCard(arguments.giftCard); 	
		} else { 
			arguments.giftCard.addErrors(giftCardCreditTransaction.getErrors());
		}
		
		return arguments.giftCard; 
		
	}
	
	public any function processGiftCard_addDebit(required any giftCard, required any processObject){
		
		var giftCardDebitTransaction = this.createDebitGiftCardTransaction(arguments.giftCard, arguments.processObject.getOrderPayments(), arguments.processObject.getOrderItems(), arguments.processObject.getDebitAmount());	
	
		if(!giftCardDebitTransaction.hasErrors()){ 
			arguments.giftCard = this.saveGiftCard(arguments.giftCard); 	
		} else { 
			arguments.giftCard.addErrors(giftCardCreditTransaction.getErrors());
		}
		
		return arguments.giftCard; 
			
	}
	
	private any function createDebitGiftCardTransaction(required any giftCard, required any orderPayments, required any orderItems, required any amountToDebit){ 
		
		var debitGiftTransaction = this.newGiftCardTransaction(); 
		
		debitGiftTransaction.setDebitAmount(amountToDebit); 
		debitGiftTransaction.setGiftCard(giftCard);
		
		for(var payment in orderPayments){ 
			debitGiftTransaction.setOrderPayment(payment); 	
		}
		
		for(var item in orderItems){ 
			debitGiftTransaction.addOrderItem(item); 
		}
		
		return this.saveGiftCardTransaction(debitGiftTransaction); 
				
	}
	
	private any function createCreditGiftCardTransaction(required any giftCard, required any orderPayments, required any amountToCredit){ 
		
		var creditGiftTransaction = this.newGiftCardTransaction(); 
		
		creditGiftTransaction.setCreditAmount(amountToCredit); 
		creditGiftTransaction.setGiftCard(giftCard);
		
		for(var payment in orderPayments){ 
			creditGiftTransaction.setOrderPayment(payment); 	
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
