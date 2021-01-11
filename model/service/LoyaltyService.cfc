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

	property name="accountService" type="any";
	
	// ===================== START: Logical Methods ===========================
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	public any function processLoyaltyAccruement_addGiftCardValueByCurrency(required any loyaltyAccruement, required struct data) {
		
		accruementCurrency = this.newAccruementCurrency();
		
		accruementCurrency.setCurrencyCode(arguments.processObject.getCurrencyCode());
		
		accruementCurrency.setGiftCardValue(arguments.processObject.getGiftCardValue());

		accruementCurrency.setLoyaltyAccruement(arguments.loyaltyAccruement);

		accruementCurrency = this.saveAccruementCurrency(accruementCurrency);
		
		if(accruementCurrency.hasErrors()){
			arguments.loyaltyAccruement.addErrors(accruementCurrency.getErrors());
		}
		
		return arguments.loyaltyAccruement;	
	}
	
	public any function processLoyaltyAccruement_addPromotionEligibleCurrency(required any loyaltyAccruement, required struct data) {
		
		var accruementCurrency = this.newAccruementCurrency();
		
		accruementCurrency.setCurrencyCode(arguments.processObject.getCurrencyCode());
		
		accruementCurrency.setLoyaltyAccruement(arguments.loyaltyAccruement);

		accruementCurrency = this.saveAccruementCurrency(accruementCurrency);
		
		if(accruementCurrency.hasErrors()){
			arguments.loyaltyAccruement.addErrors(accruementCurrency.getErrors());
		}
		
		return arguments.loyaltyAccruement;	
	}
	
	public any function deleteLoyalty(required any loyalty){
		var accruements = loyalty.getLoyaltyAccruements();
		for (var accruement in accruements){
			getDAO("LoyaltyDAO").removeAccruementCurrencies(accruement.getLoyaltyAccruementID());
		}
		return delete(arguments.loyalty);	
	}
	
	public any function processLoyaltyAccruement_addPointsPerCurrencyUnit(required any loyaltyAccruement, required struct data) {
		
		accruementCurrency = this.newAccruementCurrency();
		
		accruementCurrency.setCurrencyCode(arguments.processObject.getCurrencyCode());
		
		accruementCurrency.setPointQuantity(arguments.processObject.getPointQuantity());

		accruementCurrency.setLoyaltyAccruement(arguments.loyaltyAccruement);

		accruementCurrency = this.saveAccruementCurrency(accruementCurrency);
		
		if(accruementCurrency.hasErrors()){
			arguments.loyaltyAccruement.setErrors(accruementCurrency.getErrors());
		}
		
		return arguments.loyaltyAccruement;	
	}
	
	public any function processLoyaltyRedemption_redeem(required any loyaltyRedemption, required struct data) {
		var lifeTimeBalance = arguments.data.accountLoyalty.getLifetimeBalance();

		// If loyalty redemption type eq 'priceGroupAssignment'
		if (arguments.loyaltyRedemption.getRedemptionType() eq 'priceGroupAssignment') {
			
			// If life time balance is gt minimum point quantity on the loyalty redemption and the price group is not already assigned to the account, assign it
			if ( !isnull(lifeTimeBalance) && (lifeTimeBalance gt arguments.loyaltyRedemption.getMinimumPointQuantity()) && !arguments.data.account.hasPriceGroup( arguments.loyaltyRedemption.getPriceGroup() )) {
				
				// Create a new transaction
				var accountLoyaltyTransaction = getAccountService().newAccountLoyaltyTransaction();
				
				// Setup the transaction
				accountLoyaltyTransaction.setRedemptionType( "priceGroupAssignment" );
				accountLoyaltyTransaction.setAccountLoyalty( arguments.data.accountLoyalty );
				accountLoyaltyTransaction.setLoyaltyRedemption( arguments.loyaltyRedemption );	
				
				// Apply the qualifying price group on the account
				arguments.data.account.addPriceGroup( arguments.loyaltyRedemption.getPriceGroup() );		
			}
			
		}
		
		return arguments.loyaltyRedemption;	
	}
	
	public array function getPointTypeOptions() {
		return [
			{name=rbKey('define.select'), value=""},
			{name=rbKey('entity.loyaltyAccruement.pointType.fixed'), value="fixed"},
			{name=rbKey('entity.loyaltyAccruement.pointType.pointsPerCurrencyUnit'), value="pointsPerCurrencyUnit"}
		];
	}
	
	public array function getAccruementEventOptions() {
		return [
			{name=rbKey('define.select'), value=""},
			{name=rbKey('entity.accountLoyaltyAccruement.accruementEvent.itemFulfilled'), value="itemFulfilled"},
			{name=rbKey('entity.accountLoyaltyAccruement.accruementEvent.orderClosed'), value="orderClosed"},
			{name=rbKey('entity.accountLoyaltyAccruement.accruementEvent.fulfillmentMethodUsed'), value="fulfillmentMethodUsed"},
			{name=rbKey('entity.accountLoyaltyAccruement.accruementEvent.enrollment'), value="enrollment"}
		];
	}
	
	public array function getAccruementTypeOptions() {
		return [
			{name=rbKey('define.select'), value=""},
			{name=rbKey('entity.accountLoyaltyAccruement.accruementType.points'), value="points"},
			{name=rbKey('entity.accountLoyaltyAccruement.accruementType.giftCard'), value="giftCard"},
			{name=rbKey('entity.accountLoyaltyAccruement.accruementType.promotion'), value="promotion"}
		];
	}
	
	public array function getRedemptionTypeOptions() {
		return [
			{name=rbKey('entity.accountLoyaltyAccruement.redemptionType.productPurchase'), value="productPurchase"},
			{name=rbKey('entity.accountLoyaltyAccruement.redemptionType.cashCouponCreation'), value="cashCouponCreation"},
			{name=rbKey('entity.accountLoyaltyAccruement.redemptionType.priceGroupAssignment'), value="priceGroupAssignment"}
		];
	}
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Status Methods ===========================
	
	// ======================  END: Status Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
	
	// ===================== START: Delete Overrides ==========================
	
	// =====================  END: Delete Overrides ===========================
	
}
