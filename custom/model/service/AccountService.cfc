component extends="Slatwall.model.service.AccountService" accessors="true" output="false" {
	public string function getCustomAvailableProperties() {
		return 'priceGroups.priceGroupCode,profileImage,createdDateTime,canCreateFlexshipFlag,accountCode,accountNumber,accountType,subscribedToMailchimp';
	}
	
	public any function processAccountLoyalty_referAFriend(required any accountLoyalty, required struct data) {

		if (arguments.accountLoyalty.getLoyalty().getReferAFriendFlag()) {
			
			// If order status is closed
			if ( listFindNoCase("ostClosed",arguments.data.order.getorderStatusType().getSystemCode()) ){

				// Create a new transaction
				var accountLoyaltyTransaction = this.newAccountLoyaltyTransaction();

				// Setup the transaction data
				var transactionData = {
					accruementEvent = "orderClosed",
					accountLoyalty = arguments.accountLoyalty,
					loyaltyAccruement = arguments.data.loyaltyAccruement,
					order = arguments.data.order,
					pointAdjustmentType = "pointsIn"
				};

				// Process the transaction
				accountLoyaltyTransaction = this.processAccountLoyaltyTransaction(accountLoyaltyTransaction, transactionData,'create');

			}
		}
		return arguments.accountLoyalty;
	} 
	
	
	public string function getSimpleRepresentation(required any account){
		var accountType = arguments.account.getAccountType();
		if(isNull(accountType)){
			accountType = '';
		}
		var typeReps = {
			'marketPartner':'MP',
			'vip':'VIP',
			'customer':'Retail'
		}
		if(structKeyExists(typeReps,accountType)){
			accountType = typeReps[accountType];
		}
		return arguments.account.getFullName() & ' ( ' & arguments.account.getAccountNumber() & ' - ' & accountType & ' )';
	}
	
	public any function getAllOrdersOnAccount(struct data={}) {
        param name="arguments.data.currentPage" default=1;
        param name="arguments.data.pageRecordsShow" default=5;
        param name="arguments.data.accountID" default= getHibachiSCope().getAccount().getAccountID();
        param name="arguments.data.orderID" default= false;
        
		var ordersList = getHibachiSCope().getAccount().getOrdersCollectionList();

		ordersList.addOrderBy('orderOpenDateTime|DESC');
		ordersList.setDisplayProperties('
			orderID,
			calculatedTotalItemQuantity,
			orderNumber,
			orderStatusType.typeName,
			orderFulfillments.shippingAddress.streetAddress,
			orderFulfillments.shippingAddress.street2Address,
			orderFulfillments.shippingAddress.city,
			orderFulfillments.shippingAddress.stateCode,
			orderFulfillments.shippingAddress.postalCode,
			orderDeliveries.trackingUrl
		');
		
		ordersList.addFilter( 'account.accountID', arguments.data.accountID, '=');
		ordersList.addFilter( 'orderStatusType.systemCode', 'ostNotPlaced', '!=');
		
		if(arguments.data.orderID != false){
		    ordersList.addFilter( 'orderID', arguments.data.orderID, '=' );
		}
		
		ordersList.setPageRecordsShow(arguments.data.pageRecordsShow);
		ordersList.setCurrentPageDeclaration(arguments.data.currentPage); 
		
		return { "ordersOnAccount":  ordersList.getPageRecords(), "records": ordersList.getRecordsCount()}
	}
	
	/**
	 * Function to get All Parents on Account
	 * */
	public any function getAllParentsOnAccount(struct data={}) {
		param name="arguments.data.accountID" default= getHibachiSCope().getAccount().getAccountID();
		
		var parentAccountCollectionList = this.getAccountRelationshipCollectionList();
		parentAccountCollectionList.setDisplayProperties('accountRelationshipID, 
												parentAccount.emailAddress, 
												parentAccount.firstName, 
												parentAccount.lastName, 
												parentAccount.username, 
												parentAccount.accountID');
		parentAccountCollectionList.addFilter( 'childAccount.accountID', arguments.data.accountID, '=');
		parentAccountCollectionList.addFilter( 'activeFlag', 1, '=');
		return parentAccountCollectionList.getRecords(formatRecord = false);
	}
	
	/**
	 * Function to get All Childs on Account
	 * */
	public any function getAllChildsOnAccount(struct data={}) {
		param name="arguments.data.accountID" default= getHibachiSCope().getAccount().getAccountID();
		
		var childAccountCollectionList = this.getAccountRelationshipCollectionList();
		childAccountCollectionList.setDisplayProperties('accountRelationshipID, 
												childAccount.emailAddress, 
												childAccount.firstName, 
												childAccount.lastName, 
												childAccount.username, 
												childAccount.accountID');
		childAccountCollectionList.addFilter( 'parentAccount.accountID', arguments.data.accountID, '=');
		childAccountCollectionList.addFilter( 'activeFlag', 1, '=');
		return childAccountCollectionList.getRecords(formatRecord = false);
	}
	
	//custom validation methods
	
	public boolean function restrictRenewalDateToOneYearFromNow( required any renewalDate) {
		var oneYearFromNow = DateAdd('yyyy', 1, Now());
		return  DateCompare(oneYearFromNow, ParseDateTime(arguments.renewalDate) ) >= 0; 
	}
	
	/**
	 * Function to check card status on Nexio and Update if needed
	 * This function will be called from WorkFlow
	 * */
	public any function processAccountPaymentMethod_cardStatus(required any accountPaymentMethod, required any processObject) {
		
		var requestBean = getHibachiScope().getTransient('CreditCardTransactionRequestBean');
	    requestBean.setProviderToken(arguments.accountPaymentMethod.getProviderToken());
	    
		var responseData = getService('integrationService').getIntegrationByIntegrationPackage('nexio').getIntegrationCFC("Payment").getCardStatus(requestBean);
		
        if( !StructIsEmpty(responseData ) )
        {
        	if(responseData.card.expirationMonth != arguments.accountPaymentMethod.expirationMonth) {
        		arguments.accountPaymentMethod.setExpirationMonth(responseData.card.expirationMonth);
        	}
        	
        	if(responseData.card.expirationYear != arguments.accountPaymentMethod.expirationYear) {
        		arguments.accountPaymentMethod.setExpirationYear(responseData.card.expirationYear);
        	}
        	
        	arguments.accountPaymentMethod = this.saveAccountPaymentMethod(arguments.accountPaymentMethod);
        }
        
        return arguments.accountPaymentMethod;
	}
}
