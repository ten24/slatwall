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
				var integration = getService("IntegrationService").getIntegrationByIntegrationPackage('monat').getIntegrationCFC();
				var creditExpirationTerm = integration.setting("RafCreditExpirationTerm");
				if(!isNull(creditExpirationTerm)){
					transactionData.creditExpirationTerm = getService('SettingService').getTerm(creditExpirationTerm);
				}

				// Process the transaction
				accountLoyaltyTransaction = this.processAccountLoyaltyTransaction(accountLoyaltyTransaction, transactionData,'create');

			}
		}
		return arguments.accountLoyalty;
	} 

	public array function getAccountEventOptions(){
		var eventOptions = super.getAccountEventOptions(); 

		var customEvents = [
			{
				'name': 'Account - After Account Enrollment Success | afterAccountEnrollmentSuccess',
				'value': 'afterAccountEnrollmentSuccess',
				'entityName': 'Account' 
			},
			{
				'name': 'Account - After Account Sponsor Account Enrollment Success | afterAccountSponsorEnrollmentSuccess',
				'value': 'afterAccountSponsorEnrollmentSuccess',
				'entityName': 'Account'
			},
			{
				'name': 'Account - After Account Upgrade Success | afterAccountUpgradeSuccess',
				'value': 'afterAccountUpgradeSuccess',
				'entityName': 'Account'
			}, 
			{
				'name': 'Account - After Account Sponsor Account Upgrade Success | afterAccountSponsorUpgradeSuccess',
				'value': 'afterAccountSponsorUpgradeSuccess',
				'entityName': 'Account'
			} 
		]

		arrayAppend(eventOptions, customEvents, true); 

		return eventOptions;  
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
	
	public any function getAllOrdersOnAccount(required any account, struct data={}) {
        param name="arguments.data.currentPage" default=1;
        param name="arguments.data.pageRecordsShow" default=getHibachiScope().setting('GLOBALAPIPAGESHOWLIMIT');;
        param name="arguments.data.orderID" default="";
        
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
		
		ordersList.addFilter( 'account.accountID', arguments.account.getAccountID());
		ordersList.addFilter( 'orderStatusType.systemCode', 'ostNotPlaced', '!=');
		
		if( len(arguments.data.orderID) ){
		    ordersList.addFilter( 'orderID', arguments.data.orderID );
		}
		ordersList.addGroupBy('orderID');
		ordersList.setPageRecordsShow(arguments.data.pageRecordsShow);
		ordersList.setCurrentPageDeclaration(arguments.data.currentPage); 
		
		return { "ordersOnAccount":  ordersList.getPageRecords(), "records": ordersList.getRecordsCount()}
	}
	
	/**
	 * Function to get All Parents on Account
	 * */
	public any function getAllParentsOnAccount(required any account) {
		var parentAccountCollectionList = this.getAccountRelationshipCollectionList();
		parentAccountCollectionList.setDisplayProperties('accountRelationshipID, 
												parentAccount.emailAddress, 
												parentAccount.firstName, 
												parentAccount.lastName, 
												parentAccount.username, 
												parentAccount.accountID');
		parentAccountCollectionList.addFilter( 'childAccount.accountID', arguments.account.getAccountID() );
		parentAccountCollectionList.addFilter( 'activeFlag', 1);
		return parentAccountCollectionList.getRecords(formatRecord = false);
	}
	
	/**
	 * Function to get All Childs on Account
	 * */
	public any function getAllChildsOnAccount(required any account) {

		var childAccountCollectionList = this.getAccountRelationshipCollectionList();
		childAccountCollectionList.setDisplayProperties('accountRelationshipID, 
												childAccount.emailAddress, 
												childAccount.firstName, 
												childAccount.lastName, 
												childAccount.username, 
												childAccount.accountID');
		childAccountCollectionList.addFilter( 'parentAccount.accountID', arguments.account.getAccountID() );
		childAccountCollectionList.addFilter( 'activeFlag', 1 );
		return childAccountCollectionList.getRecords(formatRecord = false);
	}
	
	//custom validation methods
	
	public boolean function restrictRenewalDateToOneYearOut( required any renewalDate) {
		var dateLimit = DateAdd('yyyy', 1, Now());
		//Add buffer time for renewals taking place during the renewal window
		dateLimit = DateAdd('d', getService('settingService').getSettingValue('integrationmonatOrderMinimumDaysToRenewMP'),dateLimit);
		return  DateCompare(dateLimit, ParseDateTime(arguments.renewalDate) ) >= 0; 
	}
	
	/**
	 * Function to check card status on Nexio and Update if needed
	 * This function will be called from WorkFlow
	 * 
	 * TODO: make a default-card-updater-integration setting and move this into core
	 * */
	public any function processAccountPaymentMethod_cardStatus(required any accountPaymentMethod, required struct data) {
		
		//Checking if provider token exists and not empty
		if(!IsNull(arguments.accountPaymentMethod.getProviderToken()) && len( arguments.accountPaymentMethod.getProviderToken() )) {
			var requestBean = getHibachiScope().getTransient('CreditCardTransactionRequestBean');
		    requestBean.setProviderToken(arguments.accountPaymentMethod.getProviderToken());
		    
			var integrationEntity = getService('integrationService').getIntegrationByIntegrationPackage('nexio');
			var paymentIntegration = getService('integrationService').getPaymentIntegrationCFC(integrationEntity);
			
			var responseData = paymentIntegration.getCardStatus(requestBean);
			
	        if( !StructIsEmpty(responseData ) ) {
	        	if(responseData.card.expirationMonth != arguments.accountPaymentMethod.getExpirationMonth()) {
	        		arguments.accountPaymentMethod.setExpirationMonth(responseData.card.expirationMonth);
	        	}
	        	
	        	if(responseData.card.expirationYear != arguments.accountPaymentMethod.getExpirationYear()) {
	        		arguments.accountPaymentMethod.setExpirationYear(responseData.card.expirationYear);
	        	}
	        	
	        	if(responseData.card.cardHolderName != arguments.accountPaymentMethod.getNameOnCreditCard()) {
	        		arguments.accountPaymentMethod.setExpirationYear(responseData.card.expirationYear);
	        	}
	        }
		}
		
		//marking the card for the attempt, so that we can prevent the workflow from picking it again, ofcourse for a definate period of time (TODO: this can be a setting as well)
        arguments.accountPaymentMethod.setLastExpirationUpdateAttemptDateTime(now());
        arguments.accountPaymentMethod = this.saveAccountPaymentMethod(arguments.accountPaymentMethod);
        
        
        return arguments.accountPaymentMethod;
	}

	public any function saveAccount(required any account, struct data={}, string context="save"){
	
		var originalAccountType = arguments.account.getAccountType(); 

		arguments.account = super.saveAccount(argumentCollection=arguments);

		var newAccountType = arguments.account.getAccountType();

		if( (isNull(newAccountType) && isNull(originalAccountType)) ||
			(!isNull(newAccountType) && !isNull(originalAccountType) && newAccountType == originalAccountType)
		){
			this.logHibachi('account not changed, not updated order template properties')
			return arguments.account; 
		} 

		var orderTemplates = arguments.account.getOrderTemplates();

		for(var orderTemplate in orderTemplates){
			this.logHibachi('updatingOrderTemplateCalculatedPropertiesForAccount #orderTemplate.getOrderTemplateID()#');
			getOrderService().processOrderTemplate(orderTemplate, {}, 'updateCalculatedProperties');
		}

		return arguments.account; 
	}
	
	public any function addOrderToAccount(required any account, required any order){
		
		arguments.order = super.addOrderToAccount(argumentCollection = arguments);

		if(arguments.account.hasPriceGroup() && isNull(arguments.order.getPriceGroup())){
			arguments.order.setPriceGroup(arguments.account.getPriceGroups()[1]);
		}
		
		return arguments.order;
	}
	
	public void function updateGovernmentIdentificationNumberProperties(required any governmentIdentification, required string governmentIdentificationNumber=""){
		
		if(len(arguments.governmentIdentificationNumber)) {
			arguments.governmentIdentification.setGovernmentIdentificationNumberHashed ( hash(arguments.governmentIdentificationNumber, "SHA-256", "UTF-8") );
		} else {
			arguments.governmentIdentification.setGovernmentIdentificationNumberHashed(javaCast("null", ""));
		}
		
		super.updateGovernmentIdentificationNumberProperties(argumentCollection=arguments);
	}
	
	public any function processAccount_create(required any account, required any processObject, struct data={}) {

		if(arguments.account.getNewFlag()){
			arguments.account.setAccountCreateIPAddress( getRemoteAddress() );
			// Populate the account with the correct values that have been previously validated
			arguments.account.setFirstName( processObject.getFirstName() );
			arguments.account.setLastName( processObject.getLastName() );
			arguments.account.setUsername( processObject.getUsername() );
			
			if(!isNull(arguments.processObject.getOrganizationFlag())){
				arguments.account.setOrganizationFlag(arguments.processObject.getOrganizationFlag());
			}
			if(!structKeyExists(arguments.data,'skipAccountRelationship')){
				if(!isNull(arguments.processObject.getParentAccount())){
				
					var parentAccountRelationship = this.newAccountRelationship();
					parentAccountRelationship.setChildAccount(arguments.account);
					parentAccountRelationship.setParentAccount(arguments.processObject.getParentAccount());
					
					arguments.account.setOwnerAccount(arguments.processObject.getParentAccount());
					this.saveAccount(arguments.processObject.getParentAccount());
					this.saveAccountRelationship(parentAccountRelationship);
				}
				
				//if we went through the ui of the parent account tab it will submit a childAccount as we are adding a parent to the existing account
				if(!isNull(arguments.processObject.getChildAccount())){
					//make relationship for new account that will have a child
					var childAccountRelationship = this.newAccountRelationship();
					childAccountRelationship.setParentAccount(arguments.account);
					if(!isNull(childAccountRelationship.getChildAccount())){
						childAccountRelationship.getChildAccount().setOwnerAccount(arguments.account);
					}
					this.saveAccount(arguments.processObject.getChildAccount());
					this.saveAccountRelationship(childAccountRelationship);
				}
			}
			/** START CHANGES FOR MONAT 
			 * 
			 * Comment out logic to assing own account as accountOwner
			**/
			
			// if(isNull(arguments.account.getOwnerAccount())){
			// 	arguments.account.setOwnerAccount(getHibachiScope().getAccount());
			// }
			
			/** END CHANGES FOR MONAT **/
			
			// If company was passed in then set that up
			if(!isNull(processObject.getCompany())) {
				arguments.account.setCompany( processObject.getCompany() );
			}
	
			// If phone number was passed in the add a primary phone number
			if(!isNull(processObject.getPhoneNumber())) {
				var accountPhoneNumber = this.newAccountPhoneNumber();
				accountPhoneNumber.setAccount( arguments.account );
				accountPhoneNumber.setPhoneNumber( processObject.getPhoneNumber() );
			}
	
			// If email address was passed in then add a primary email address
			if(!isNull(processObject.getEmailAddress())) {
				var accountEmailAddress = this.newAccountEmailAddress();
				accountEmailAddress.setAccount( arguments.account );
				accountEmailAddress.setEmailAddress( processObject.getEmailAddress() );
	
				arguments.account.setPrimaryEmailAddress( accountEmailAddress );
			}
			
			if(!arguments.account.hasErrors() && !isNull(processObject.getAccessID())) {
				var subscriptionUsageBenefitAccountCreated = false;
				var access = getService("accessService").getAccess(processObject.getAccessID());
			
				if(isNull(access)) {
					//return access code error
					arguments.account.addError("accessID", rbKey('validate.account.accessID'));
				}
			}
			
			var currentSite = getHibachiScope().getCurrentRequestSite();
			if(!isNull(currentSite)){
				arguments.account.setAccountCreatedSite(currentSite);
			}
			
			// Save & Populate the account so that custom attributes get set
			arguments.account = this.saveAccount(arguments.account, arguments.data);
			
			// If the createAuthenticationFlag was set to true, the add the authentication
			if(!arguments.account.hasErrors() && processObject.getCreateAuthenticationFlag()) {
				var accountAuthentication = this.newAccountAuthentication();
				accountAuthentication.setAccount( arguments.account );
	
				// Put the accountAuthentication into the hibernate scope so that it has an id which will allow the hash / salting below to work
				getHibachiDAO().save(accountAuthentication);
	
				// Set the password
				accountAuthentication.setPassword( getHashedAndSaltedPassword(arguments.processObject.getPassword(), accountAuthentication.getAccountAuthenticationID()) );
			}
	
			// Call save on the account now that it is all setup
			if(!arguments.account.hasErrors()){
				arguments.account = this.saveAccount(arguments.account);
			}
			
			// if all validation passed and setup accounts subscription benefits based on access 
			if(!arguments.account.hasErrors() && !isNull(access)) {
				subscriptionUsageBenefitAccountCreated = getService("subscriptionService").createSubscriptionUsageBenefitAccountByAccess(access, arguments.account);
			}
		}
		return arguments.account;
	}
}
