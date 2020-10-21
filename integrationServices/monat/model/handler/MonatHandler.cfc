component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiEventHandler" {
    property name="OrderService";
    property name="AccountService";
    property name="HibachiEventService";

    public any function afterAccountProcess_loginFailure(required any slatwallScope, required any account ,required struct data){
        param name="arguments.data.emailAddressOrUsername" default="";
        param name="arguments.data.emailAddress" default="";
        param name="arguments.data.password" default="";
		
        var accountAuthCollection = arguments.slatwallScope.getService('AccountService').getAccountAuthenticationCollectionList();
        accountAuthCollection.setDisplayProperties("accountAuthenticationID,password,account.accountID,account.primaryEmailAddress.emailAddress,legacyPassword,activeFlag");
        
        if( len(arguments.data.emailAddressOrUsername) && REFind("^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$", arguments.data.emailAddressOrUsername) ){
        	accountAuthCollection.addFilter("account.primaryEmailAddress.emailAddress", arguments.data.emailAddressOrUsername);
        } else if( len(arguments.data.emailAddressOrUsername) ){
        	accountAuthCollection.addFilter("account.username", arguments.data.emailAddressOrUsername);
        } else {
        	accountAuthCollection.addFilter("account.primaryEmailAddress.emailAddress", arguments.data.emailAddress);
        }
        
        accountAuthCollection.addFilter("legacyPassword", "NULL", "IS NOT");
        accountAuthCollection.addFilter("activeFlag", "true");
        var accountAuthentications = accountAuthCollection.getRecords();
		
        for (var accountAuthentication in accountAuthentications) {
            var accountAuthEntity = getAccountService().getAccountAuthentication(accountAuthentication['accountAuthenticationID']);
			
            if( !isNull(accountAuthEntity) && 
                len(accountAuthentication['legacyPassword']) > 29 && 
                accountAuthentication['legacyPassword'] == legacyPasswordHashed(arguments.data.password, left(accountAuthentication['legacyPassword'], 29)) && 
                accountAuthEntity.getAccount().getActiveFlag()
                ){
				
                accountAuthEntity.setPassword(getAccountService().getHashedAndSaltedPassword(arguments.data.password, accountAuthentication['accountAuthenticationID']));
                accountAuthEntity.setLegacyPassword(javacast("null", ""));
                accountAuthEntity = getAccountService().saveAccountAuthentication(accountAuthEntity);
            } else {
                continue;
            }
			
            if(!accountAuthEntity.hasErrors()){
                arguments.slatwallScope.getService("hibachiSessionService").loginAccount( accountAuthEntity.getAccount(), accountAuthEntity );
            }
        }
    }

    private string function legacyPasswordHashed(required string password, required string salt){
        var BCrypt = CreateObject( 'java', 'org.mindrot.jbcrypt.BCrypt', '/Slatwall/integrationServices/monat/jBCrypt-0.4.jar' ).init();
        var password = BCrypt.hashpw(arguments.password, arguments.salt);
        return password;
    }
    
    public void function afterInfotraxAccountCreateSuccess(any slatwallScope, any entity, any eventData) {

		//Clear the encrypted govt-id-NUMBER 
		if( arguments.entity.getAccountGovernmentIdentificationsCount() ){
			//in current specs, there can be only one govt-ID per account
			arguments.entity.getAccountGovernmentIdentifications()[1]
				.setGovernmentIdentificationNumberEncrypted(javaCast("null", ""));
		}
	}

	public any function afterOrderProcess_placeOrderSuccess(required any slatwallScope, required any order, required any data){

		var account = arguments.order.getAccount();
		arguments.slatwallScope.clearCurrentFlexship(); //if there was any
		
		var originalAccountType = account.getAccountType() ?: '';
		
        //Commission Date
        arguments.order.setCommissionPeriod(dateFormat( now(), "yyyymm" ));
        
        // Set the Product Pack Purchased Flag
        if( account.getAccountType() == 'marketPartner' && arguments.order.hasProductPack() ) {
			account.setProductPackPurchasedFlag(true);
        }
    	
    	// Set the AccountType and PriceGroup IF this is an upgrade flow.
    	if(arguments.order.getUpgradeFlag() == true){
    		
    		account.setUpgradeSyncFlag(1);
    		
    		//If the order isFirstOrder it is enrollment, if its not its an account type upgrade
    		var isFirstOrder = !isNull(arguments.order.getAccount().getAccountStatusType()) && arguments.order.getAccount().getAccountStatusType().getSystemCode() == 'astEnrollmentPending' ? true : false;
    		
    		arguments.order.setOrderOrigin(getService('orderService').getOrderOriginByOrderOriginName('Web Upgrades'));
    		if(arguments.order.getMonatOrderType().getTypeCode() == 'motVipEnrollment'){
    			account.setAccountType('VIP');
    			account.setPriceGroups([getService('PriceGroupService').getPriceGroupByPriceGroupCode(3)]);
		
				if(!isFirstOrder){
					getHibachiEventService().announceEvent('afterAccountVIPUpgradeSuccess', {'account':account, 'entity':account}); 	
					getHibachiEventService().announceEvent('afterOrderVIPUpgradeSuccess', {'order':arguments.order, 'entity':arguments.order}); 	
					getHibachiEventService().announceEvent('afterAccountSponsorVIPUpgradeSuccess', {'account':account.getOwnerAccount(), 'entity':account.getOwnerAccount()}); 	
				}
    		
			}else if(arguments.order.getMonatOrderType().getTypeCode() == 'motMpEnrollment'){
    			account.setAccountType('marketPartner');
    			account.setCareerTitle('Market Partner');
				account.setRank(1);
				account.setRenewalDate(DateAdd('yyyy', 1, now()));
    			account.setPriceGroups([getService('PriceGroupService').getPriceGroupByPriceGroupCode(1)]);
				
				if(!isFirstOrder){
					getHibachiEventService().announceEvent('afterAccountMarketPartnerUpgradeSuccess', {'account':account, 'entity':account}); 	
					getHibachiEventService().announceEvent('afterOrderMarketPartnerUpgradeSuccess', {'order':arguments.order, 'entity':arguments.order}); 	
					getHibachiEventService().announceEvent('afterAccountSponsorMarketPartnerUpgradeSuccess', {'account':account.getOwnerAccount(), 'entity':account.getOwnerAccount()}); 	
				}
    		}
			
			if(!isFirstOrder){
				getHibachiEventService().announceEvent('afterAccountUpgradeSuccess', {'account':account, 'entity':account}); 
				getHibachiEventService().announceEvent('afterOrderAccountUpgradeSuccess', {'order':arguments.order, 'entity':arguments.order}); 
			}
			
			if(!isNull(account.getOwnerAccount())){
				getHibachiEventService().announceEvent('afterAccountSponsorUpgradeSuccess', {'account':account.getOwnerAccount(), 'entity':account.getOwnerAccount()}); 
			} 
    	}
    	
		// Snapshot the account type to the order. 
		if (!isNull(account)){
			if (!isNull(account.getAccountType())){
				arguments.order.setAccountType(account.getAccountType());
			}else{
				logHibachi("afterOrderProcess_placeOrderSuccess Account Type should NEVER be empty on place order.", true);
			}
		}
	
		// Snapshot the pricegroups on the order.
		if ( !isNull(account) && arrayLen(account.getPriceGroups()) ) {
            arguments.order.setPriceGroup(account.getPriceGroups()[1]);
        }
		
		// Sets the account status type, activeFlag and accountNumber
		if( 
			!isNull(account.getAccountStatusType()) 
			&& ListContains('astEnrollmentPending,astGoodStanding', account.getAccountStatusType().getSystemCode() ) 
		) {
			
			if(account.getAccountStatusType().getSystemCode() == 'astEnrollmentPending') {
	    		arguments.order.setOrderOrigin(getService('orderService').getOrderOriginByOrderOriginName('Web Enrollment'));
				account.setActiveFlag(true);
				account.setAccountStatusType(getService('typeService').getTypeBySystemCodeOnly('astGoodStanding'));
				account.getAccountNumber();
				
				if(isNull(account.getEnrollmentDate())) {
					account.setEnrollmentDate(now());
				}
				
				if( account.getAccountType() == 'marketPartner' ) {
					//set renewal-date to one-year-from-enrolmentdate
					account.setRenewalDate(DateAdd('yyyy', 1, account.getEnrollmentDate()));
					account.setCareerTitle('Market Partner');
					account.setRank(1);
					
				}
				
				getHibachiEventService().announceEvent('afterAccount#account.getAccountType()#EnrollmentSuccess', {'account':account, 'entity':account}); 
				getHibachiEventService().announceEvent('afterAccountEnrollmentSuccess', {'account':account, 'entity':account}); 

				if(!isNull(account.getOwnerAccount())){
					getHibachiEventService().announceEvent('afterAccountSponsorEnrollmentSuccess', {'account':account.getOwnerAccount(), 'entity':account.getOwnerAccount()}); 
				} 
	
			} 
			else if ( 
				account.getAccountStatusType().getSystemCode() == 'astGoodStanding' 
				&& CompareNoCase(account.getAccountType(), 'marketPartner')  == 0 
				&& arguments.order.hasMPRenewalFee()
			) {
				
				//set renewal-date to one year from current renewal date
				var currentRenewalDate = ParseDateTime(arguments.order.getAccount().getRenewalDate());
				var renewalDate = DateAdd('yyyy', 1, currentRenewalDate);
				account.setRenewalDate(renewalDate);
			}
			else if( originalAccountType != account.getAccountType() ){
			    
			    switch ( account.getAccountType() ) {
			        case 'vip':
    			            account.setVipUpgradeDateTime( now() );
			            break;
			        case 'marketPartner':
    			            account.setMpUpgradeDateTime( now() );
			            break;
			    }
				getHibachiEventService().announceEvent('afterAccount#originalAccountType#To#account.getAccountType()#UpgradeSuccess', {'account':account, 'entity':account}); 
			}
			else if(isNull(arguments.order.getOrderOrigin())){
    			arguments.order.setOrderOrigin(getService('orderService').getOrderOriginByOrderOriginName('Internet Order'));
			}
			getAccountService().saveAccount(account);
			
			getDAO('HibachiDAO').flushORMSession();
			
			var integrationID = getService('integrationService').getIntegrationByIntegrationPackage('infotrax').getIntegrationID();

			getDAO('HibachiEntityQueueDAO').insertEntityQueue(
				entityQueueID   = hash("Account_#account.getAccountID()#_push_#integrationID#", 'MD5'), //Custom ID to ignore EntityQueueData
				baseID          = account.getAccountID(),
				baseObject      = 'Account',
				processMethod   = 'push',
				entityQueueData = { 'event' = 'afterAccountSaveSuccess' },
				integrationID   = integrationID
			);
		}
		
		
		//Set the commissionPeriod - this is wrapped in a try catch so nothing causes a place order to fail.
		//Set the initial order flag if needed.
		try{
			
			
			//adding shipping and billing to flexship and activating
			if(!isNull(arguments.data.orderTemplateID)){

				var orderTemplate = getOrderService().getOrderTemplate(arguments.data.orderTemplateID);
				var orderFulFillment = arguments.order.getOrderFulfillments()[1];
				
				//NOTE: there's only one shipping method allowed for flexship
				var shippingMethod = getService('ShippingService').getShippingMethod(
					ListFirst( orderTemplate.getSite().setting('siteOrderTemplateEligibleShippingMethods') )
				);
				
				var accountPaymentMethod = arguments.order.getOrderPayments()[1].getAccountPaymentMethod();
				var orderTemplateStatusType = getService('typeService').getTypeBySystemCode('otstActive');
				
				orderTemplate.setShippingMethod(shippingMethod);
				
				//try to copy shipping-account-address from last used addresses if required
				if(!orderTemplate.hasShippingAccountAddress()) {
					var shippingAccountAddress = orderFulFillment.getAccountAddress() ?: arguments.order.getShippingAccountAddress();
					if( !IsNull(shippingAccountAddress) ) {
						orderTemplate.setShippingAccountAddress( shippingAccountAddress );
						orderTemplate.setShippingAddress( shippingAccountAddress.getAddress().copyAddress() );
					} 
				}
				
				//try to copy shipping-address from last used addresses if required
				if( !orderTemplate.hasShippingAddress() ) {
					var shippingAddress = orderFulFillment.getShippingAddress() ?: arguments.order.getShippingAddress();
					if( !IsNull(shippingAddress) ) {
						orderTemplate.setShippingAddress( shippingAddress.copyAddress() );
					} 
				}
				
				//try to copy billing-account-address from last used addresses if required
				if( !orderTemplate.hasBillingAccountAddress()) {
					//if there's no billing-account-address falling-back to the shipping-account-address
					var billingAccountAddress = arguments.order.getBillingAccountAddress() ?: orderTemplate.getShippingAccountAddress();
					if(!IsNull(billingAccountAddress)){
						orderTemplate.setBillingAccountAddress(billingAccountAddress);
					}
				}
				
				orderTemplate.setAccountPaymentMethod(accountPaymentMethod);
				
				if(isNull(orderTemplate.getAccount())){
					orderTemplate.setAccount(arguments.order.getAccount());
				}
				orderTemplate = getOrderService().processOrderTemplate_activate(orderTemplate, {}, {'context': 'upgradeFlow'});
				
				var integrationID = getService('integrationService').getIntegrationByIntegrationPackage('infotrax').getIntegrationID();
				getDAO('HibachiEntityQueueDAO').insertEntityQueue(
					entityQueueID   = hash("OrderTemplate_#orderTemplate.getOrderTemplateID()#_push_#integrationID#", 'MD5'), //Custom ID to ignore EntityQueueData
					baseID          = orderTemplate.getOrderTemplateID(),
					baseObject      = 'OrderTemplate',
					processMethod   = 'push',
					entityQueueData = { 'event' = 'afterOrderTemplateProcess_activateSuccess' },
					integrationID   = integrationID
				);
		
			}
			
			
			
			//Initial Order Flag
			//Set the Initial Order Flag as needed
			var previousOrdersCollection = getOrderService().getOrderCollectionList();
			//Find if they have any previous Sales Orders that are not this one that just purchased.
			previousOrdersCollection.addFilter("account.accountID", arguments.order.getAccount().getAccountID());
			previousOrdersCollection.addFilter("orderType.systemCode", "otSalesOrder");
			previousOrdersCollection.addFilter("orderID", arguments.order.getOrderID(), "!=");
			
			var previousInitialOrderCount = previousOrdersCollection.getRecordsCount();
			
			if (!previousInitialOrderCount){
				//this is the first order for this account
				arguments.order.setInitialOrderFlag(true);
			}
		}catch(any dateError){
			logHibachi("afterOrderProcess_placeOrderSuccess failed @ set initialOrderFlag #serializeJson(dateError)#");	
		}
		
	}
	
	public any function afterOrderItemCreateSuccess(required any slatwallScope, required any orderItem, required any data){ 
		// Flush so the item is there when we need it. 
		if (!arguments.slatwallScope.ORMHasErrors()){
			arguments.slatwallScope.flushORMSession();
			try{
				this.createOrderItemSkuBundle( arguments.orderItem );
			}catch(bundleError){
				logHibachi("afterOrderItemProcessCreateSuccess failed @ create bundle items for orderitem #orderItem.getOrderItemID()# ");
			}
			// add open orderitem records
			if(!isNull(arguments.orderItem.getOrder().getOrderOpenDatetime())){
				getDAO('InventoryDAO').manageOpenOrderItem(actionType = 'add', orderItemID = arguments.orderItem.getOrderItemID());
			}
		}

	}
	
	public void function afterOrderItemUpdateSuccess(required any slatwallScope, required any orderItem, required any data){
		if (!isNull(arguments.orderItem.getOrder().getOrderOpenDatetime()) && !arguments.slatwallScope.ORMHasErrors()){
			arguments.slatwallScope.flushORMSession();
			var oldData = arguments.orderItem.getPreUpdateData();
			
			if(!isNull(oldData) && structKeyExists(oldData, "quantity") && oldData["quantity"] != arguments.orderItem.getQuantity()){
				getDAO('InventoryDAO').manageOpenOrderItem(actionType = 'updateItemQuantity', orderItemID = arguments.orderItem.getOrderItemID());
			}
		}
	}

	public void function afterOrderProcess_addOrderItemSuccess(required any slatwallScope, required any order, required any data){
		if (!isNull(arguments.order.getOrderOpenDatetime()) && !arguments.slatwallScope.ORMHasErrors()){
			arguments.slatwallScope.flushORMSession();

			if(structKeyExists(arguments.data, "skuID")){
				getDAO('InventoryDAO').manageOpenOrderItem(actionType = 'updateItemQuantity', skuID = arguments.data.skuID);
			}
		}
	}


	
	/**
	 * Adds the calculated bundled order items
	 * For each orderitem, create new orderItemSkuBundles for each sku that is 
	 * a bundle.
	 **/
	 public any function createOrderItemSkuBundle(required any orderItem){
 		//create
 		var insertSQL = "INSERT INTO SwOrderItemSkuBundle (orderItemSkuBundleID, createdDateTime, modifiedDateTime, skuID, orderItemID, quantity) ";
		insertSQL &= "SELECT REPLACE(CAST(UUID() as char character set utf8), '-', ''), #now()#, #now()#, bundledSkuID, '#orderItem.getOrderItemID()#', bundledQuantity FROM SwSkuBundle where skuID = '#arguments.orderItem.getSkuID()#'";
		
 		QueryExecute(insertSQL);
	}
	
	
	public void function onSessionAccountLogin(){
		getService('HibachiTagService').cfcookie(name="accountType", value=getHibachiScope().getAccount().getAccountType(), httpOnly=true);
		
	}
	
	public void function onSessionAccountLogout(){
		getService('HibachiTagService').cfcookie(name="accountType", value='', expires=now(), httpOnly=true);
	}
}
