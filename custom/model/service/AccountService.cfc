component extends="Slatwall.model.service.AccountService" accessors="true" output="false" {
   	public any function processAccountLoyalty_orderClosed(required any accountLoyalty, required struct data) {

		// Loop over account loyalty accruements
		for(var loyaltyAccruement in arguments.accountLoyalty.getLoyalty().getLoyaltyAccruements()) {

			// If loyaltyAccruement eq 'orderClosed' as the type
			if (loyaltyAccruement.getAccruementEvent() eq 'orderClosed' OR loyaltyAccruement.getLoyalty().getReferAFriendFlag()) {

				// If order status is closed
				if ( listFindNoCase("ostClosed",arguments.data.order.getorderStatusType().getSystemCode()) ){

					// Create a new transaction
					var accountLoyaltyTransaction = this.newAccountLoyaltyTransaction();

					// Setup the transaction data
					var transactionData = {
						accruementEvent = "orderClosed",
						accountLoyalty = arguments.accountLoyalty,
						loyaltyAccruement = loyaltyAccruement,
						order = arguments.data.order,
						pointAdjustmentType = "pointsIn"
					};

					// Process the transaction
					accountLoyaltyTransaction = this.processAccountLoyaltyTransaction(accountLoyaltyTransaction, transactionData,'create');

				}
			}
		}
		return arguments.accountLoyalty;
	} 
}