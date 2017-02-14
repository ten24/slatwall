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
component extends="HibachiService" accessors="true" output="false" {

	property name="accountDAO" type="any";

	property name="emailService" type="any";
	property name="eventRegistrationService" type="any";
	property name="hibachiAuditService" type="any";
	property name="loyaltyService" type="any";
	property name="orderService" type="any";
	property name="paymentService" type="any";
	property name="permissionService" type="any";
	property name="priceGroupService" type="any";
	property name="settingService" type="any";
	property name="siteService" type="any";
	property name="typeService" type="any";
	property name="validationService" type="any";

	public string function getHashedAndSaltedPassword(required string password, required string salt) {
		return hash(arguments.password & arguments.salt, 'SHA-512');
	}

	public string function getPasswordResetID(required any account) {
		var passwordResetID = "";
		var accountAuthentication = getAccountDAO().getPasswordResetAccountAuthentication(accountID=arguments.account.getAccountID());

		if(isNull(accountAuthentication)) {
			var accountAuthentication = this.newAccountAuthentication();
			accountAuthentication.setExpirationDateTime(now() + 7);
			accountAuthentication.setAccount( arguments.account );

			accountAuthentication = this.saveAccountAuthentication( accountAuthentication );
		}

		return lcase("#arguments.account.getAccountID()##hash(accountAuthentication.getAccountAuthenticationID() & arguments.account.getAccountID())#");
	}

	// ===================== START: Logical Methods ===========================

	// =====================  END: Logical Methods ============================

	// ===================== START: DAO Passthrough ===========================

	public boolean function getPrimaryEmailAddressNotInUseFlag( required string emailAddress, string accountID ) {
		return getAccountDAO().getPrimaryEmailAddressNotInUseFlag(argumentcollection=arguments);
	}

	public any function getInternalAccountAuthenticationsByEmailAddress(required string emailAddress) {
		return getAccountDAO().getInternalAccountAuthenticationsByEmailAddress(argumentcollection=arguments);
	}

	public boolean function getAccountAuthenticationExists() {
		return getAccountDAO().getAccountAuthenticationExists();
	}

	public boolean function getAccountExists(){
		return getAccountDAO().getAccountExists();
	}

	public any function getAccountWithAuthenticationByEmailAddress( required string emailAddress ) {
		return getAccountDAO().getAccountWithAuthenticationByEmailAddress( argumentcollection=arguments );
	}

	public any function getAccountByAccessKeyAndSecret( required string accessKey, required string accessKeySecret ) {

		// Try to find the accountAuthentication
		var accountAuthentication = this.getAccountAuthenticationByAccessKey( arguments.accessKey );

		if(!isNull(accountAuthentication)) {
			var hashedSaltedPassword = getHashedAndSaltedPassword( accessKeySecret, accountAuthentication.getAccountAuthenticationID() );

			// If the accessKeySecret passed in hashes to what's in the DB, then we can return the account
			if(hashedSaltedPassword == accountAuthentication.getAccessKeyPassword()) {
				return accountAuthentication.getAccount();
			}
		}

	}

	public any function getNewAccountLoyaltyNumber( required string loyaltyID ) {
		return getAccountDAO().getNewAccountLoyaltyNumber( argumentcollection=arguments );
	}

	// =====================  END: DAO Passthrough ============================

	// ===================== START: Process Methods ===========================

	// Account
	public any function processAccount_addAccountPayment(required any account, required any processObject) {

		// Get the populated newAccountPayment out of the processObject
		var newAccountPayment = processObject.getNewAccountPayment();

		// Make sure that this new accountPayment gets attached to the order
		if(isNull(newAccountPayment.getAccount())) {
			newAccountPayment.setAccount( arguments.account );
		}

		// If this is an existing account payment method, then we can pull the data from there
		if( len(arguments.processObject.getAccountPaymentMethodID()) ) {

			// Setup the newAccountPayment from the existing payment method
			var accountPaymentMethod = this.getAccountPaymentMethod( arguments.processObject.getAccountPaymentMethodID() );
			newAccountPayment.copyFromAccountPaymentMethod( accountPaymentMethod );

		// This is a new payment, so we need to setup the billing address and see if there is a need to save it against the account
		} else {

			// Setup the billing address as an accountAddress if it existed, otherwise the billing address will have most likely just been populated already
			if(!isNull(arguments.processObject.getAccountAddressID()) && len(arguments.processObject.getAccountAddressID())) {
				var accountAddress = this.getAccountAddress( arguments.processObject.getAccountAddressID() );

				if(!isNull(accountAddress)) {
					newAccountPayment.setBillingAddress( accountAddress.getAddress().copyAddress( true ) );
				}
			}

			// If saveAccountPaymentMethodFlag is set to true, then we need to save this object
			if(arguments.processObject.getSaveAccountPaymentMethodFlag()) {
				var newAccountPaymentMethod = this.newAccountPaymentMethod();
				newAccountPaymentMethod.copyFromAccountPayment( newAccountPayment );
				newAccountPaymentMethod.setAccountPaymentMethodName(arguments.processObject.getSaveAccountPaymentMethodName());
				newAccountPaymentMethod.setAccount( arguments.account );

				newAccountPaymentMethod = this.saveAccountPaymentMethod(newAccountPaymentMethod);
			}

		}
		
		
		if(!newAccountPayment.hasErrors()) {
			// Loop over all account payments and link them to the AccountPaymentApplied object
			for (var appliedOrderPayment in processObject.getAppliedOrderPayments()) {
				if(IsNumeric(appliedOrderPayment.amount) && appliedOrderPayment.amount > 0) {
					var orderPayment = getOrderService().getOrderPayment( appliedOrderPayment.orderPaymentID );
	
					var newAccountPaymentApplied = this.newAccountPaymentApplied();
					newAccountPaymentApplied.setAccountPayment( newAccountPayment );
	
					newAccountPaymentApplied.setAmount( appliedOrderPayment.amount );
	
					// Link to the order payment if the payment is assigned to a term order. Also set the payment type
					if(!isNull(orderPayment)) {
						newAccountPaymentApplied.setOrderPayment( orderPayment );
						newAccountPaymentApplied.setAccountPaymentType( getTypeService().getType( appliedOrderPayment.paymentTypeID  ) );
					}
	
					// Save the account payment applied
					newAccountPaymentApplied = this.saveAccountPaymentApplied( newAccountPaymentApplied );
				}
			}
		}
		
		// Save the newAccountPayment
		newAccountPayment = this.saveAccountPayment( newAccountPayment );
		
		// If there are errors in the newAccountPayment after save, then add them to the account
		if(newAccountPayment.hasErrors()) {
			
			arguments.account.addError('accountPayment', rbKey('admin.entity.order.addAccountPayment_error'));
		// If no errors, then we can process a transaction
		} else {
			var transactionData = {
				amount = newAccountPayment.getAmount()
			};

			if(newAccountPayment.getAccountPaymentType().getSystemCode() eq "aptCharge") {
				if(newAccountPayment.getPaymentMethod().getPaymentMethodType() eq "creditCard") {
					if(!isNull(newAccountPayment.getPaymentMethod().getIntegration())) {
						transactionData.transactionType = 'authorizeAndCharge';	
					} else {
						transactionData.transactionType = 'receiveOffline';	
					}
				} else {
					transactionData.transactionType = 'receive';
				}
			} else {
				transactionData.transactionType = 'credit';
			}

			newAccountPayment = this.processAccountPayment(newAccountPayment, transactionData, 'createTransaction');
			//Loop over the newaccountpayment.getAppliedPayments
			if(newAccountPayment.hasErrors()){
				for(var errorKey in newAccountPayment.getErrors()){
					arguments.account.addError(errorKey, newAccountPayment.getErrors()[errorKey]);	
				}
				
			}else{
				for (var appliedAccountPayment in newAccountPayment.getAppliedAccountPayments()) {
					if(!IsNull(appliedAccountPayment.getOrderPayment())) {
						transactionData = {
							amount = appliedAccountPayment.getAmount()
						};
	
						if(newAccountPayment.getAccountPaymentType().getSystemCode() eq "aptCharge") {
							if(newAccountPayment.getPaymentMethod().getPaymentMethodType() eq "creditCard") {
								if(!isNull(newAccountPayment.getPaymentMethod().getIntegration())) {
									transactionData.transactionType = 'authorizeAndCharge';	
								} else {
									transactionData.transactionType = 'receiveOffline';	
								}
							} else {
								transactionData.transactionType = 'receive';
							}
						} else {
							transactionData.transactionType = 'credit';
						}
	
						getOrderService().processOrderPayment(appliedAccountPayment.getOrderPayment(), transactionData, 'createTransaction');
					}
				}
			}
		}

		return arguments.account;
	}

	public any function processAccount_changePassword(required any account, required any processObject) {
		//change password and create password functions should be combined at some point. Work needed to do this still needs to be scoped out.
		//For now they are just calling this function that handles the actual work.
		arguments.account = createNewAccountPassword(arguments.account, arguments.processObject);

		return arguments.account;
	}

	public any function processAccount_create(required any account, required any processObject, struct data={}) {

		if(arguments.account.getNewFlag()){
		
			// Populate the account with the correct values that have been previously validated
			arguments.account.setFirstName( processObject.getFirstName() );
			arguments.account.setLastName( processObject.getLastName() );
	
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
			arguments.account = this.saveAccount(arguments.account);
			
			// if all validation passed and setup accounts subscription benefits based on access 
			if(!arguments.account.hasErrors() && !isNull(access)) {
				subscriptionUsageBenefitAccountCreated = getService("subscriptionService").createSubscriptionUsageBenefitAccountByAccess(access, arguments.account);
			}
		}
		return arguments.account;
	}

	public any function processAccount_createPassword(required any account, required any processObject) {
		//change password and create password functions should be combined at some point. Work needed to do this still needs to be scoped out.
		//For now they are just calling this function that handles the actual work.
		arguments.account = createNewAccountPassword(arguments.account, arguments.processObject);

		return account;
	}

	public any function processAccount_generateAPIAccessKey(required any account, required any processObject){

		// If the account logged in is a super user, or they are not but they are creating for themselves, then we are OK, otherwise toss an error.
		if (getHibachiScope().getAccount().getSuperUserFlag() || getHibachiScope().getAccount().getAccountID() == arguments.account.getAccountID()){

			// Generate a random accessKey
			var accessKey = hash(createUUID(),"sha");

			// Check to see if that random key is already in the DB
			var existingAccessKey = this.getAccountAuthenticationByAccessKey( accessKey );

			// If the random key is, generate new ones until they are not
			while (!isNull(existingAccessKey)) {
				accessKey = hash(createUUID(),"sha");
				existingAccessKey = this.getAccountAuthenticationByAccessKey( accessKey );
			}

			// Generate a Access-Key-Secret
			var accessKeySecret = toBase64(hash(createUUID(),"sha"));

			// Create an account authentication
			var accountAuthentication = this.newAccountAuthentication();

			// Place the accountAuthentication in the hibernate scope so that an ID is generated (this does NOT persist yet)
			getHibachiDAO().save( accountAuthentication );

			// Generate the password based on the accessKeySecret
			var hashedAndSaltedPassword = getHashedAndSaltedPassword(accessKeySecret, accountAuthentication.getAccountAuthenticationID());

			accountAuthentication.setAccessKey( accessKey );
			accountAuthentication.setAccessKeyPassword( hashedAndSaltedPassword );
			accountAuthentication.setAuthenticationDescription( arguments.processObject.getAuthenticationDescription() );
			accountAuthentication.setAccount( arguments.account );

			// Display the generated keys to the user
			arguments.account.addMessage(
				messagename="AccessKeyInfo",
				message=getHibachiUtilityService().replaceStringTemplate(rbKey('entity.account.generateAPIAccessKey.accessKeyInfo'), {accessKey=accessKey,accessKeySecret=accessKeySecret})
			);
		} else {
			arguments.account.addError(errorName="generateAPIAccessKey", errorMessage=rbKey('entity.account.generateAPIAccessKey.nonValidAccount'));
		}

		return arguments.account;
	}

	public any function processAccount_login(required any account, required any processObject) {
		// Take the email address and get all of the user accounts by primary e-mail address
		var accountAuthentication = getAccountDAO().getActivePasswordByEmailAddress( emailAddress=arguments.processObject.getEmailAddress() );
		var invalidLoginData = {emailAddress=arguments.processObject.getEmailAddress()};

		if(!isNull(accountAuthentication)) {
			//Make sure that the account is not locked
			if(isNull(accountAuthentication.getAccount().getLoginLockExpiresDateTime()) || DateCompare(Now(), accountAuthentication.getAccount().getLoginLockExpiresDateTime()) == 1 ){
				// If the password matches what it should be, then set the account in the session and
				if(!isNull(accountAuthentication.getPassword()) && len(accountAuthentication.getPassword()) && accountAuthentication.getPassword() == getHashedAndSaltedPassword(password=arguments.processObject.getPassword(), salt=accountAuthentication.getAccountAuthenticationID())) {

					//Check to see if a password reset is required
					if(checkPasswordResetRequired(accountAuthentication, arguments.processObject)){
						arguments.processObject.addError('passwordUpdateRequired',  rbKey('validate.newPassword.duplicatePassword'));
					}else{
						getHibachiSessionService().loginAccount( accountAuthentication.getAccount(), accountAuthentication);
					}

					accountAuthentication.getAccount().setFailedLoginAttemptCount(0);
					accountAuthentication.getAccount().setLoginLockExpiresDateTime(javacast("null",""));

					return arguments.account;
				}

				arguments.processObject.addError('emailAddress', rbKey('validation.account_authorizeAccount.failure'));
				invalidLoginData.account = accountAuthentication.getAccount();


				//Log the failed attempt to account.failedLoginAttemptCount
				var failedLogins = nullReplace(invalidLoginData.account.getFailedLoginAttemptCount(), 0) + 1;
				invalidLoginData.account.setFailedLoginAttemptCount(failedLogins);

				//Get the max number of failed attempts before the account is locked based on account type
				if(accountAuthentication.getAccount().getAdminAccountFlag()){
					var maxLoginAttempts = arguments.account.setting('accountFailedAdminLoginAttemptCount');
				}else{
					var maxLoginAttempts = arguments.account.setting('accountFailedPublicLoginAttemptCount');
				}

				//If the log attempt is greater than the failedLoginSetting, call function to lockAccount
				if (!isNull(maxLoginAttempts) && maxLoginAttempts > 0 && failedLogins >= maxLoginAttempts){
					this.processAccount(invalidLoginData.account, 'lock');
				}

			} else{
				arguments.processObject.addError('password',rbKey('validate.account.loginblocked'));
			}
		} else {
			arguments.processObject.addError('emailAddress', rbKey('validation.account_authorizeAccount.failure'));
		}

		// Login was invalid
		getHibachiAuditService().logAccountActivity('loginInvalid', invalidLoginData);

		return arguments.account;
	}

	public any function processAccount_logout( required any account ) {
		getHibachiSessionService().logoutAccount();

		return arguments.account;
	}

	public any function processAccount_forgotPassword( required any account, required any processObject ) {
		var forgotPasswordAccount = getAccountWithAuthenticationByEmailAddress( processObject.getEmailAddress() );

		if(!isNull(forgotPasswordAccount)) {
			//check to see if the account is locked
			if(isNull(forgotPasswordAccount.getLoginLockExpiresDateTime()) || DateCompare(Now(), forgotPasswordAccount.getLoginLockExpiresDateTime()) == 1 ){

				// Get the site (this will return as a new site if no siteID)
				var site = getSiteService().getSite(arguments.processObject.getSiteID(), true);

				if(len(site.setting('siteForgotPasswordEmailTemplate'))) {

					var email = getEmailService().newEmail();
					var emailData = {
						accountID = forgotPasswordAccount.getAccountID(),
						emailTemplateID = site.setting('siteForgotPasswordEmailTemplate')
					};

					email = getEmailService().processEmail(email, emailData, 'createFromTemplate');

					email.setEmailTo( arguments.processObject.getEmailAddress() );

					email = getEmailService().processEmail(email, {}, 'addToQueue');

				} else {
					throw("No email template could be found.  Please update the site settings to define an 'Forgot Password Email Template'.");
				}
			} else {
				arguments.processObject.addError('emailAddress', rbKey('validate.account_forgotPassword.loginblocked'));
			}

		} else {
			arguments.processObject.addError('emailAddress', rbKey('validate.account_forgotPassword.emailAddress.notfound'));
		}

		return arguments.account;
	}

    public any function processAccount_redeemGiftCard( required any account, required any processObject) {

        if(processObject.hasGiftCard()){
            var redeemToAccountProcessObject = processObject.getGiftCardRedeemToAccountProcessObject();
            redeemToAccountProcessObject.setAccount(arguments.account);
            var giftCard = this.getGiftCardService().process(processObject.getGiftCard(), redeemToAccountProcessObject, "redeemToAccount");
        } else {
            arguments.account.addError("giftCard", rbKey('admin.entity.processaccount.redeemGiftCard_failure'));
        }

        return arguments.account;
    }



	public any function processAccount_resetPassword( required any account, required any processObject ) {

		// If there are no errors
		if(!arguments.account.hasErrors()) {

			arguments.account = createNewAccountPassword(arguments.account, arguments.processObject);

			// Get the temporary accountAuth
			var tempAA = getAccountDAO().getPasswordResetAccountAuthentication(accountID=arguments.account.getAccountID());

			// Delete the temporary auth
			this.deleteAccountAuthentication( tempAA );

			// Then flush the ORM session so that an account can be logged in right away
			getHibachiDAO().flushORMSession();
		}

		return arguments.account;
	}

	public any function processAccount_updatePassword(required any account, required any processObject){
		//This function needs to check and make sure that the old password equals is valid

		var accountAuthentication =getAccountDAO().getActivePasswordByEmailAddress( emailAddress= arguments.processObject.getEmailAddress() );

		if(!isNull(accountAuthentication)) {
			if(!isNull(accountAuthentication.getPassword()) && len(accountAuthentication.getPassword()) && accountAuthentication.getPassword() == getHashedAndSaltedPassword(password=arguments.processObject.getExistingPassword(), salt=accountAuthentication.getAccountAuthenticationID())) {
				//create the new pasword the updated password
				arguments.account = createNewAccountPassword(accountAuthentication.getAccount(), arguments.processObject);
				if(!arguments.processObject.hasErrors()){
					if(isNull(accountAuthentication.getAccount().getLoginLockExpiresDateTime()) || DateCompare(Now(), accountAuthentication.getAccount().getLoginLockExpiresDateTime()) == 1 ){
						getHibachiSessionService().loginAccount( accountAuthentication.getAccount(), accountAuthentication);
					}else{
						arguments.processObject.addError('password',rbKey('validate.account.loginblocked'));
					}


				}

			}else{
				arguments.processObject.addError('existingPassword', rbKey('validate.account_authorizeAccount.password.incorrect'));
			}
		}else{
			arguments.processObject.addError('emailAddress', rbKey('validate.account_authorizeAccount.emailAddress.notfound'));
		}

		return arguments.account;
	}

	public any function processAccount_lock(required any account){
		var expirationDateTime= dateAdd('n', arguments.account.setting('accountLockMinutes'), Now());
		arguments.account.setLoginLockExpiresDateTime(expirationDateTime);
		arguments.account.setFailedLoginAttemptCount(0);

		return arguments.account;
	}

	public any function processAccount_unlock(required any account){
		arguments.account.setLoginLockExpiresDateTime(javacast("null",""));

		return arguments.account;
	}

	public any function processAccount_setupInitialAdmin(required any account, required struct data={}, required any processObject) {
		if(!getAccountExists()){
			// Populate the account with the correct values that have been previously validated
			arguments.account.setFirstName( processObject.getFirstName() );
			arguments.account.setLastName( processObject.getLastName() );
			if(!isNull(processObject.getCompany())) {
				arguments.account.setCompany( processObject.getCompany() );
			}
			arguments.account.setSuperUserFlag( 1 );

			// Setup the email address
			var accountEmailAddress = this.newAccountEmailAddress();
			accountEmailAddress.setAccount(arguments.account);
			accountEmailAddress.setEmailAddress( processObject.getEmailAddress() );

			// Setup the authentication
			var accountAuthentication = this.newAccountAuthentication();
			accountAuthentication.setAccount( arguments.account );

			// Put the accountAuthentication into the hibernate scope so that it has an id
			getHibachiDAO().save(accountAuthentication);

			// Set the password
			accountAuthentication.setPassword( getHashedAndSaltedPassword(arguments.data.password, accountAuthentication.getAccountAuthenticationID()) );

			// Call save on the account now that it is all setup
			arguments.account = this.saveAccount(arguments.account);

			// Setup the Default to & from emails in the system to this users account
			var defaultSetupData = {
				emailAddress = processObject.getEmailAddress()
			};
			getSettingService().setupDefaultValues( defaultSetupData );

			// Login the new account
			if(!arguments.account.hasErrors()) {
				getHibachiSessionService().loginAccount(account=arguments.account, accountAuthentication=accountAuthentication);
			}
		}

		return arguments.account;
	}

	public any function processAccount_addAccountLoyalty(required any account, required any processObject) {

		// Get the populated AccountLoyalty out of the processObject
		var newAccountLoyalty = this.newAccountLoyalty();

		newAccountLoyalty.setAccount( arguments.account );
		newAccountLoyalty.setLoyalty( arguments.processObject.getLoyalty() );
		newAccountLoyalty.setAccountLoyaltyNumber( getNewAccountLoyaltyNumber( arguments.processObject.getLoyaltyID() ));

		newAccountLoyalty = this.saveAccountLoyalty( newAccountLoyalty );

		if(!newAccountLoyalty.hasErrors()) {
			newAccountLoyalty = this.processAccountLoyalty(newAccountLoyalty, {}, 'enrollment');
		}

		return arguments.account;
	}

	// Account Email Address
	public any function processAccountEmailAddress_sendVerificationEmail(required any accountEmailAddress, required any processObject) {

		// Get the site (this will return as a new site if no siteID)
		var site = getSiteService().getSite(arguments.processObject.getSiteID(), true);

		if(len(site.setting('siteVerifyAccountEmailAddressEmailTemplate'))) {

			var email = getEmailService().newEmail();
			var emailData = {
				accountEmailAddressID = arguments.accountEmailAddress.getAccountEmailAddressID(),
				emailTemplateID = site.setting('siteVerifyAccountEmailAddressEmailTemplate')
			};

			email = getEmailService().processEmail(email, emailData, 'createFromTemplate');

			email.setEmailTo( arguments.accountEmailAddress.getEmailAddress() );

			email = getEmailService().processEmail(email, {}, 'addToQueue');

		} else {
			throw("No email template could be found.  Please update the site settings to define a 'Verify Account Email Address Email Template'.");
		}

		return arguments.accountEmailAddress;
	}

	public any function processAccountEmailAddress_verify(required any accountEmailAddress) {
		arguments.accountEmailAddress.setVerifiedFlag( 1 );

		return arguments.accountEmailAddress;
	}

	// Account Loyalty
	public any function processAccountLoyalty_itemFulfilled(required any accountLoyalty, required struct data) {

		// Loop over arguments.accountLoyalty.getLoyaltyAccruements() as 'loyaltyAccruement'
		for(var loyaltyAccruement in arguments.accountLoyalty.getLoyalty().getLoyaltyAccruements()) {

			// If loyaltyAccruement eq 'fulfillItem' as the type, then based on the amount create a new transaction and apply that amount
			if (loyaltyAccruement.getAccruementType() eq 'itemFulfilled') {

				// Loop over the orderDeliveryItems in arguments.data.orderDelivery
				for(var orderDeliveryItem in arguments.data.orderDelivery.getOrderDeliveryItems()) {

					// START: Check Exclusions
					var itemExcluded = false;

					// Check all of the exclusions for an excluded product type
					if(arrayLen(loyaltyAccruement.getExcludedProductTypes())) {
						var excludedProductTypeIDList = "";
						for(var i=1; i<=arrayLen(loyaltyAccruement.getExcludedProductTypes()); i++) {
							excludedProductTypeIDList = listAppend(excludedProductTypeIDList, loyaltyAccruement.getExcludedProductTypes()[i].getProductTypeID());
						}

						for(var ptid=1; ptid<=listLen(orderDeliveryItem.getOrderItem().getSku().getProduct().getProductType().getProductTypeIDPath()); ptid++) {
							if(listFindNoCase(excludedProductTypeIDList, listGetAt(orderDeliveryItem.getOrderItem().getSku().getProduct().getProductType().getProductTypeIDPath(), ptid))) {
								itemExcluded = true;
								break;
							}
						}
					}

					// If anything is excluded then we return false
					if(	itemExcluded
						||
						loyaltyAccruement.hasExcludedProduct( orderDeliveryItem.getOrderItem().getSku().getProduct() )
						||
						loyaltyAccruement.hasExcludedSku( orderDeliveryItem.getOrderItem().getSku() )
						||
						( arrayLen( loyaltyAccruement.getExcludedBrands() ) && ( isNull( orderDeliveryItem.getOrderItem().getSku().getProduct().getBrand() ) || loyaltyAccruement.hasExcludedBrand( orderDeliveryItem.getOrderItem().getSku().getProduct().getBrand() ) ) )
						) {
						itemExcluded = true;
					}


					// START: Check Inclusions
					var itemIncluded = false;

					if(arrayLen(loyaltyAccruement.getProductTypes())) {
						var includedPropertyTypeIDList = "";

						for(var i=1; i<=arrayLen(loyaltyAccruement.getProductTypes()); i++) {
							includedPropertyTypeIDList = listAppend(includedPropertyTypeIDList, loyaltyAccruement.getProductTypes()[i].getProductTypeID());
						}

						for(var ptid=1; ptid<=listLen(orderDeliveryItem.getOrderItem().getSku().getProduct().getProductType().getProductTypeIDPath()); ptid++) {
							if(listFindNoCase(includedPropertyTypeIDList, listGetAt(orderDeliveryItem.getOrderItem().getSku().getProduct().getProductType().getProductTypeIDPath(), ptid))) {
								itemIncluded = true;
								break;
							}
						}
					}

					// Verify that this orderDeliveryItem product is in the products, or skus for the accruement
					if ( itemIncluded
						|| loyaltyAccruement.hasProduct(orderDeliveryItem.getOrderItem().getSku().getProduct())
						|| loyaltyAccruement.hasSku(orderDeliveryItem.getOrderItem().getSku())
						|| (!isNull(orderDeliveryItem.getOrderItem().getSku().getProduct().getBrand()) && loyaltyAccruement.hasBrand(orderDeliveryItem.getOrderItem().getSku().getProduct().getBrand()))
						){

						// Create a new transaction
						var accountLoyaltyTransaction = this.newAccountLoyaltyTransaction();

						// Setup the transaction data
						var transactionData = {
							accruementType = "itemFulfilled",
							accountLoyalty = arguments.accountLoyalty,
							loyaltyAccruement = loyaltyAccruement,
							orderDeliveryItem = orderDeliveryItem,
							order = orderDeliveryItem.getOrderItem().getOrder(),
							orderItem = orderDeliveryItem.getOrderItem(),
							pointAdjustmentType = "pointsIn"
						};

						// Process the transaction
						accountLoyaltyTransaction = this.processAccountLoyaltyTransaction(accountLoyaltyTransaction, transactionData,'create');

					}
				}
			}
		}

		return arguments.accountLoyalty;
	}

	public any function processAccountLoyalty_orderClosed(required any accountLoyalty, required struct data) {

		// Loop over account loyalty accruements
		for(var loyaltyAccruement in arguments.accountLoyalty.getLoyalty().getLoyaltyAccruements()) {

			// If loyaltyAccruement eq 'orderClosed' as the type
			if (loyaltyAccruement.getAccruementType() eq 'orderClosed') {

				// If order satus is closed
				if ( listFindNoCase("ostClosed",arguments.data.order.getorderStatusType().getSystemCode()) ){

					// Create a new transaction
					var accountLoyaltyTransaction = this.newAccountLoyaltyTransaction();

					// Setup the transaction data
					var transactionData = {
						accruementType = "orderClosed",
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

	public any function processAccountLoyalty_fulfillmentMethodUsed(required any accountLoyalty, required struct data) {

		// Loop over loyalty Accruements
		for(var loyaltyAccruement in arguments.accountLoyalty.getLoyalty().getLoyaltyAccruements()) {

			// If loyaltyAccruement eq 'fulfillmentMetodUsed' as the type
			if (loyaltyAccruement.getAccruementType() eq 'fulfillmentMethodUsed') {

				// Create and setup a new transaction
				var accountLoyaltyTransaction = this.newAccountLoyaltyTransaction();

				// Setup the transaction data
				var transactionData = {
					accruementType = "fulfillmentMethodUsed",
					accountLoyalty = arguments.accountLoyalty,
					loyaltyAccruement = loyaltyAccruement,
					orderFulfillment = arguments.data.orderFulfillment,
					pointAdjustmentType = "pointsIn"
				};

				// Process the transaction
				accountLoyaltyTransaction = this.processAccountLoyaltyTransaction(accountLoyaltyTransaction, transactionData,'create');

			}
		}

		return arguments.accountLoyalty;
	}

	public any function processAccountLoyalty_enrollment(required any accountLoyalty) {


		// Loop over arguments.accountLoyalty.getLoyalty().getLoyaltyAccruements() as 'loyaltyAccruement'
		for(var loyaltyAccruement in arguments.accountLoyalty.getLoyalty().getLoyaltyAccruements()) {

			// If loyaltyAccruement eq 'enrollment' as the type
			if (loyaltyAccruement.getAccruementType() eq 'enrollment') {

				var accountLoyaltyTransaction = this.newAccountLoyaltyTransaction();

				// Setup the transaction data
				var transactionData = {
					accruementType = "enrollment",
					accountLoyalty = arguments.accountLoyalty,
					loyaltyAccruement = loyaltyAccruement,
					pointAdjustmentType = "pointsIn"
				};

				// Process the transaction
				accountLoyaltyTransaction = this.processAccountLoyaltyTransaction(accountLoyaltyTransaction, transactionData,'create');

			}
		}

		return arguments.accountLoyalty;
	}

	public any function processAccountLoyalty_orderItemReceived(required any accountLoyalty, required struct data) {

		// Loop over the account loyalty Accruements
		for(var loyaltyAccruement in arguments.accountLoyalty.getLoyalty().getLoyaltyAccruements()) {

			// If loyaltyAccruement is of type 'itemFulfilled'
			if (loyaltyAccruement.getAccruementType() eq 'itemFulfilled') {

				// Loop over the items in the stockReceiver
				for(var orderItemReceived in arguments.data.stockReceiver.getStockReceiverItems()) {

					// START: Check Exclusions
					var itemExcluded = false;

					// Check all of the exclusions for an excluded product type
					if(arrayLen(loyaltyAccruement.getExcludedProductTypes())) {
						var excludedProductTypeIDList = "";
						for(var i=1; i<=arrayLen(loyaltyAccruement.getExcludedProductTypes()); i++) {
							excludedProductTypeIDList = listAppend(excludedProductTypeIDList, loyaltyAccruement.getExcludedProductTypes()[i].getProductTypeID());
						}

						for(var ptid=1; ptid<=listLen(orderItemReceived.getOrderItem().getSku().getProduct().getProductType().getProductTypeIDPath()); ptid++) {
							if(listFindNoCase(excludedProductTypeIDList, listGetAt(orderItemReceived.getOrderItem().getSku().getProduct().getProductType().getProductTypeIDPath(), ptid))) {
								itemExcluded = true;
								break;
							}
						}
					}

					// If anything is excluded then we return false
					if(	itemExcluded
						||
						loyaltyAccruement.hasExcludedProduct( orderItemReceived.getOrderItem().getSku().getProduct() )
						||
						loyaltyAccruement.hasExcludedSku( orderItemReceived.getOrderItem().getSku() )
						||
						( arrayLen( loyaltyAccruement.getExcludedBrands() ) && ( isNull( orderItemReceived.getOrderItem().getSku().getProduct().getBrand() ) || loyaltyAccruement.hasExcludedBrand( orderItemReceived.getOrderItem().getSku().getProduct().getBrand() ) ) )
						) {
						itemExcluded = true;
					}


					// START: Check Inclusions
					var itemIncluded = false;

					if(arrayLen(loyaltyAccruement.getProductTypes())) {
						var includedPropertyTypeIDList = "";

						for(var i=1; i<=arrayLen(loyaltyAccruement.getProductTypes()); i++) {
							includedPropertyTypeIDList = listAppend(includedPropertyTypeIDList, loyaltyAccruement.getProductTypes()[i].getProductTypeID());
						}

						for(var ptid=1; ptid<=listLen(orderItemReceived.getOrderItem().getSku().getProduct().getProductType().getProductTypeIDPath()); ptid++) {
							if(listFindNoCase(includedPropertyTypeIDList, listGetAt(orderItemReceived.getOrderItem().getSku().getProduct().getProductType().getProductTypeIDPath(), ptid))) {
								itemIncluded = true;
								break;
							}
						}
					}

					// Verify that this orderItemReceived product is in the products, or skus for the accruement
					if ( itemIncluded
						|| loyaltyAccruement.hasProduct(orderItemReceived.getOrderItem().getSku().getProduct())
						|| loyaltyAccruement.hasSku(orderItemReceived.getOrderItem().getSku())
						|| (!isNull(orderItemReceived.getOrderItem().getSku().getProduct().getBrand()) && loyaltyAccruement.hasBrand(orderItemReceived.getOrderItem().getSku().getProduct().getBrand()))
						){

						// Create a new accountLoyalty transaction
						var accountLoyaltyTransaction = this.newAccountLoyaltyTransaction();

						// Setup the transaction data
						var transactionData = {
							accruementType = "itemFulfilled",
							accountLoyalty = arguments.accountLoyalty,
							loyaltyAccruement = loyaltyAccruement,
							orderItemReceived = orderItemReceived,
							order = orderItemReceived.getOrderItem().getOrder(),
							orderItem = orderItemReceived.getOrderItem(),
							pointAdjustmentType = "pointsOut"
						};

						// Process the transaction
						accountLoyaltyTransaction = this.processAccountLoyaltyTransaction(accountLoyaltyTransaction, transactionData,'create');

					}
				}
			}
		}

		return arguments.accountLoyalty;
	}

	public any function processAccountLoyalty_manualTransaction(required any accountLoyalty, required any processObject) {

		// Create a new transaction
		var accountLoyaltyTransaction = this.newAccountLoyaltyTransaction();

		accountLoyaltyTransaction.setAccountLoyalty( arguments.accountLoyalty );
		accountLoyaltyTransaction.setAccruementType( processObject.getManualAdjustmentType() );

		if (processObject.getManualAdjustmentType() eq "manualIn"){
			accountLoyaltyTransaction.setPointsIn( processObject.getPoints() );
			if (!isNull(processObject.getExpirationDateTime())) { accountLoyaltyTransaction.setExpirationDateTime( processObject.getExpirationDateTime() ); }
		} else {
			accountLoyaltyTransaction.setPointsOut( processObject.getPoints() );
		}

		return arguments.accountLoyalty;
	}

	// Account Loyalty Transaction
	public any function processAccountLoyaltyTransaction_create(required any accountLoyaltyTransaction, required struct data) {

		// Process only the 'active' loyalty programs
		if ( arguments.data.accountLoyalty.getLoyalty().getActiveFlag() ) {

			// Setup the transaction
			arguments.accountLoyaltyTransaction.setAccruementType( arguments.data.accruementType );
			arguments.accountLoyaltyTransaction.setAccountLoyalty( arguments.data.accountLoyalty );
			arguments.accountLoyaltyTransaction.setLoyaltyAccruement( arguments.data.loyaltyAccruement );

			// Set the order, orderItem and orderFulfillment if they exist
			if(structKeyExists(arguments.data, "order")) {
				arguments.accountLoyaltyTransaction.setOrder( arguments.data.order );
			}

			if(structKeyExists(arguments.data, "orderItem")) {
				arguments.accountLoyaltyTransaction.setOrderItem( arguments.data.orderItem );
			}

			if(structKeyExists(arguments.data, "orderFulfillment")) {
				arguments.accountLoyaltyTransaction.setOrderFulfillment( arguments.data.orderFulfillment );
			}

			// Set up loyalty program expiration date / time based upon the expiration term
			if( !isNull(arguments.data.loyaltyAccruement.getExpirationTerm()) ){
			    arguments.accountLoyaltyTransaction.setExpirationDateTime( arguments.data.loyaltyAccruement.getExpirationTerm().getEndDate() );
			}


			if ( arguments.data.pointAdjustmentType eq "pointsIn" ) {

				if ( arguments.data.loyaltyAccruement.getPointType() eq 'fixed' ){
					arguments.accountLoyaltyTransaction.setPointsIn( arguments.data.loyaltyAccruement.getPointQuantity() );
				}
				else if ( arguments.data.loyaltyAccruement.getPointType() eq 'pointPerDollar' ) {

					if (arguments.data.accruementType eq 'itemFulfilled') {
						arguments.accountLoyaltyTransaction.setPointsIn( arguments.data.loyaltyAccruement.getPointQuantity() * (arguments.data.orderDeliveryItem.getQuantity() * arguments.data.orderDeliveryItem.getOrderItem().getPrice()) );
					} else if (arguments.data.accruementType eq 'orderClosed') {
						arguments.accountLoyaltyTransaction.setPointsIn( arguments.data.loyaltyAccruement.getPointQuantity() * arguments.data.order.getTotal() );
					} else if (arguments.data.accruementType eq 'fulfillmentMethodUsed') {
						arguments.accountLoyaltyTransaction.setPointsIn( arguments.data.loyaltyAccruement.getPointQuantity() * arguments.data.orderFulfillment.getFulFillmentCharge() );
					}
				}

			} else {
				if ( arguments.data.loyaltyAccruement.getPointType() eq 'fixed' ){
					arguments.accountLoyaltyTransaction.setPointsOut( arguments.data.loyaltyAccruement.getPointQuantity() );
				}
				else if ( arguments.data.loyaltyAccruement.getPointType() eq 'pointPerDollar' ) {
					arguments.accountLoyaltyTransaction.setPointsOut( arguments.data.loyaltyAccruement.getPointQuantity() * (arguments.data.orderItemReceived.getQuantity() * arguments.data.orderItemReceived.getOrderItem().getPrice()) );
				}
			}

			// Loop over account loyalty redemptions
			for(var loyaltyRedemption in arguments.data.accountLoyalty.getLoyalty().getLoyaltyRedemptions()) {

				// If loyalty auto redemption eq 'pointsAdjusted' as the type
				if (loyaltyRedemption.getAutoRedemptionType() eq 'pointsAdjusted') {

					redemptionData = {
						account = arguments.data.accountLoyalty.getAccount(),
						accountLoyalty = arguments.data.accountLoyalty
					};

					loyaltyRedemption = getLoyaltyService().processLoyaltyRedemption( loyaltyRedemption, redemptionData, 'redeem' );
				}
			}

		}
		return arguments.accountLoyaltyTransaction;
	}

	// Account Payment
	public any function processAccountPayment_createTransaction(required any accountPayment, required any processObject) {

		var uncapturedAuthorizations = getPaymentService().getUncapturedPreAuthorizations( arguments.accountPayment );

		// If we are trying to charge multiple pre-authorizations at once we may need to run multiple transacitons
		if(arguments.processObject.getTransactionType() eq "chargePreAuthorization" && arrayLen(uncapturedAuthorizations) gt 1 && arguments.processObject.getAmount() gt uncapturedAuthorizations[1].chargeableAmount) {
			var totalAmountCharged = 0;

			for(var a=1; a<=arrayLen(uncapturedAuthorizations); a++) {

				var thisToCharge = getService('HibachiUtilityService').precisionCalculate(arguments.processObject.getAmount() - totalAmountCharged);

				if(thisToCharge gt uncapturedAuthorizations[a].chargeableAmount) {
					thisToCharge = uncapturedAuthorizations[a].chargeableAmount;
				}

				// Create a new payment transaction
				var paymentTransaction = getPaymentService().newPaymentTransaction();

				// Setup the accountPayment in the transaction to be used by the 'runTransaction'
				paymentTransaction.setAccountPayment( arguments.accountPayment );

				// Setup the transaction data
				transactionData = {
					transactionType = arguments.processObject.getTransactionType(),
					amount = thisToCharge,
					preAuthorizationCode = uncapturedAuthorizations[a].authorizationCode,
					preAuthorizationProviderTransactionID = uncapturedAuthorizations[a].providerTransactionID
				};

				// Run the transaction
				paymentTransaction = getPaymentService().processPaymentTransaction(paymentTransaction, transactionData, 'runTransaction');

				// If the paymentTransaction has errors, then add those errors to the accountPayment itself
				if(paymentTransaction.hasError('runTransaction')) {
					arguments.accountPayment.addError('createTransaction', paymentTransaction.getError('runTransaction'), true);
				} else {
					getService('HibachiUtilityService').precisionCalculate(totalAmountCharged + paymentTransaction.getAmountReceived());
				}

			}
		} else {
			// Create a new payment transaction
			var paymentTransaction = getPaymentService().newPaymentTransaction();

			// Setup the accountPayment in the transaction to be used by the 'runTransaction'
			paymentTransaction.setAccountPayment( arguments.accountPayment );

			// Setup the transaction data
			transactionData = {
				transactionType = arguments.processObject.getTransactionType(),
				amount = arguments.processObject.getAmount()
			};

			if(arguments.processObject.getTransactionType() eq "chargePreAuthorization" && arrayLen(uncapturedAuthorizations)) {
				transactionData.preAuthorizationCode = uncapturedAuthorizations[1].authorizationCode;
				preAuthorizationProviderTransactionID = uncapturedAuthorizations[1].providerTransactionID;
			}

			// Run the transaction
			paymentTransaction = getPaymentService().processPaymentTransaction(paymentTransaction, transactionData, 'runTransaction');

			// If the paymentTransaction has errors, then add those errors to the accountPayment itself
			if(paymentTransaction.hasError('runTransaction')) {
				arguments.accountPayment.addError('createTransaction', paymentTransaction.getError('runTransaction'), true);
			}
		}

		return arguments.accountPayment;

	}

	// Account Payment Method
	public any function processAccountPaymentMethod_createTransaction(required any accountPaymentMethod, required any processObject) {

		// Create a new payment transaction
		var paymentTransaction = getPaymentService().newPaymentTransaction();

		// Setup the accountPayment in the transaction to be used by the 'runTransaction'
		paymentTransaction.setAccountPaymentMethod( arguments.accountPaymentMethod );

		// Setup the transaction data
		transactionData = {
			transactionType = processObject.getTransactionType(),
			amount = processObject.getAmount()
		};

		// Run the transaction
		paymentTransaction = getPaymentService().processPaymentTransaction(paymentTransaction, transactionData, 'runTransaction');

		// If the paymentTransaction has errors, then add those errors to the accountPayment itself
		if(paymentTransaction.hasError('runTransaction')) {
			arguments.accountPaymentMethod.addError('createTransaction', paymentTransaction.getError('runTransaction'), true);
		}

		return arguments.accountPaymentMethod;
	}

	// =====================  END: Process Methods ============================

	// ====================== START: Save Overrides ===========================

	public any function saveAccountPaymentMethod(required any accountPaymentMethod, struct data={}, string context="save") {
		param name="arguments.data.runSaveAccountPaymentMethodTransactionFlag" default="true";

		// See if the accountPaymentMethod was new
		var wasNew = arguments.accountPaymentMethod.getNewFlag();

		// Call the generic save method to populate and validate
		arguments.accountPaymentMethod = save(arguments.accountPaymentMethod, arguments.data, arguments.context);

		// If the order payment does not have errors, then we can check the payment method for a saveTransaction
		if(wasNew && !arguments.accountPaymentMethod.hasErrors() && arguments.data.runSaveAccountPaymentMethodTransactionFlag && !isNull(arguments.accountPaymentMethod.getPaymentMethod().getSaveAccountPaymentMethodTransactionType()) && len(arguments.accountPaymentMethod.getPaymentMethod().getSaveAccountPaymentMethodTransactionType()) && arguments.accountPaymentMethod.getPaymentMethod().getSaveAccountPaymentMethodTransactionType() neq "none") {

			// Setup transaction data
			var transactionData = {
				amount = 0,
				transactionType = arguments.accountPaymentMethod.getPaymentMethod().getSaveAccountPaymentMethodTransactionType()
			};

			// Clear out any previous 'createTransaction' process objects
			arguments.accountPaymentMethod.clearProcessObject( 'createTransaction' );

			arguments.accountPaymentMethod = this.processAccountPaymentMethod(arguments.accountPaymentMethod, transactionData, 'createTransaction');
		}

		return arguments.accountPaymentMethod;

	}

	public any function savePermissionGroup(required any permissionGroup, struct data={}, string context="save") {

		arguments.permissionGroup.setPermissionGroupName( arguments.data.permissionGroupName );

		// As long as permissions were passed in we can set those up
		if(structKeyExists(arguments.data, "permissions")) {
			// Loop over all of the permissions that were passed in.
			for(var i=1; i<=arrayLen(arguments.data.permissions); i++) {

				var pData = arguments.data.permissions[i];
				var pEntity = this.getPermission(arguments.data.permissions[i].permissionID, true);
				pEntity.populate( pData );

				// Delete this permssion
				if(!pEntity.isNew() && (isNull(pEntity.getAllowCreateFlag()) || !pEntity.getAllowCreateFlag()) && (isNull(pEntity.getAllowReadFlag()) || !pEntity.getAllowReadFlag()) && (isNull(pEntity.getAllowUpdateFlag()) || !pEntity.getAllowUpdateFlag()) && (isNull(pEntity.getAllowDeleteFlag()) || !pEntity.getAllowDeleteFlag()) && (isNull(pEntity.getAllowProcessFlag()) || !pEntity.getAllowProcessFlag()) && (isNull(pEntity.getAllowActionFlag()) || !pEntity.getAllowActionFlag()) ) {
					arguments.permissionGroup.removePermission( pEntity );
					this.deletePermission( pEntity );
				// Otherwise Save This Entity
				} else if ((!isNull(pEntity.getAllowCreateFlag()) && pEntity.getAllowCreateFlag()) || (!isNull(pEntity.getAllowReadFlag()) && pEntity.getAllowReadFlag()) || (!isNull(pEntity.getAllowUpdateFlag()) && pEntity.getAllowUpdateFlag()) || (!isNull(pEntity.getAllowDeleteFlag()) && pEntity.getAllowDeleteFlag()) || (!isNull(pEntity.getAllowProcessFlag()) && pEntity.getAllowProcessFlag()) || (!isNull(pEntity.getAllowActionFlag()) && pEntity.getAllowActionFlag())) {
					getAccountDAO().save( pEntity );
					arguments.permissionGroup.addPermission( pEntity );
				}
			}
		}

		// Validate the permission group
		arguments.permissionGroup.validate(context='save');

		// Setup hibernate session correctly if it has errors or not
		if(!arguments.permissionGroup.hasErrors()) {
			getAccountDAO().save( arguments.permissionGroup );
		}

		return arguments.permissionGroup;
	}

	// ======================  END: Save Overrides ============================

	// ==================== START: Smart List Overrides =======================


	public any function getAccountSmartList(struct data={}, currentURL="") {
		arguments.entityName = "#getDao('hibachiDao').getApplicationKey()#Account";

		var smartList = this.getSmartList(argumentCollection=arguments);

		smartList.joinRelatedProperty("#getDao('hibachiDao').getApplicationKey()#Account", "primaryEmailAddress", "left");
		smartList.joinRelatedProperty("#getDao('hibachiDao').getApplicationKey()#Account", "primaryPhoneNumber", "left");
		smartList.joinRelatedProperty("#getDao('hibachiDao').getApplicationKey()#Account", "primaryAddress", "left");

		smartList.addKeywordProperty(propertyIdentifier="firstName", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="lastName", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="company", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="primaryEmailAddress.emailAddress", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="primaryPhoneNumber.phoneNumber", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="primaryAddress.streetAddress", weight=1);

		return smartList;
	}

	public any function getAccountAuthenticationSmartList(struct data={}){
		arguments.entityName = "#getDao('hibachiDao').getApplicationKey()#AccountAuthentication";

		var smartList = this.getSmartList(argumentCollection=arguments);

		smartList.joinRelatedProperty("#getDao('hibachiDao').getApplicationKey()#AccountAuthentication", "account", "left" );

		smartList.joinRelatedProperty("#getDao('hibachiDao').getApplicationKey()#AccountAuthentication", "integration", "left");

		smartList.addKeywordProperty(propertyIdentifier="account.accountID", weight=1 );

		smartList.addKeywordProperty(propertyIdentifier="integration.integrationID", weight=1 );

		return smartList;
	}

	public any function getAccountEmailAddressSmartList(struct data={}, currentURL="") {
		arguments.entityName = "#getDao('hibachiDao').getApplicationKey()#AccountEmailAddress";

		var smartList = this.getSmartList(argumentCollection=arguments);

		smartList.joinRelatedProperty("#getDao('hibachiDao').getApplicationKey()#AccountEmailAddress", "accountEmailType", "left");

		return smartList;
	}

	public any function getAccountPhoneNumberSmartList(struct data={}, currentURL="") {
		arguments.entityName = "#getDao('hibachiDao').getApplicationKey()#AccountPhoneNumber";

		var smartList = this.getSmartList(argumentCollection=arguments);

		smartList.joinRelatedProperty("#getDao('hibachiDao').getApplicationKey()#AccountPhoneNumber", "accountPhoneType", "left");

		return smartList;
	}


	// ====================  END: Smart List Overrides ========================

	// ====================== START: Get Overrides ============================

	// ======================  END: Get Overrides =============================

	// ===================== START: Delete Overrides ==========================

	public boolean function deleteAccount(required any account) {

		// Check delete validation
		if(arguments.account.isDeletable()) {

			// Remove the primary fields so that we can delete this entity
			arguments.account.setPrimaryEmailAddress(javaCast("null", ""));
			arguments.account.setPrimaryPhoneNumber(javaCast("null", ""));
			arguments.account.setPrimaryAddress(javaCast("null", ""));

			getAccountDAO().removeAccountFromAllSessions( arguments.account.getAccountID() );
			getAccountDAO().removeAccountFromAuditProperties( arguments.account.getAccountID() );

		}

		return delete( arguments.account );
	}

	public boolean function deleteAccountAuthentication(required any accountAuthentication) {
		// Check delete validation
		if(arguments.accountAuthentication.isDeletable()) {
			// Remove the primary fields so that we can delete this entity
			getAccountDAO().removeAccountAuthenticationFromSessions( arguments.accountAuthentication.getAccountAuthenticationID() );
			if(!isNull(arguments.accountAuthentication.getAccount())) {
				arguments.accountAuthentication.removeAccount();
			}
		}

		return delete( arguments.accountAuthentication );
	}

	public boolean function deleteAccountEmailAddress(required any accountEmailAddress) {

		// Check delete validation
		if(arguments.accountEmailAddress.isDeletable()) {

			// If the primary email address is this e-mail address then set the primary to null
			if(arguments.accountEmailAddress.getAccount().getPrimaryEmailAddress().getAccountEmailAddressID() eq arguments.accountEmailAddress.getAccountEmailAddressID()) {
				arguments.accountEmailAddress.getAccount().setPrimaryEmailAddress(javaCast("null",""));
			}

		}

		return delete(arguments.accountEmailAddress);
	}

	public boolean function deleteAccountPhoneNumber(required any accountPhoneNumber) {

		// Check delete validation
		if(arguments.accountPhoneNumber.isDeletable()) {

			// If the primary phone number is this phone number then set the primary to null
			if(arguments.accountPhoneNumber.getAccount().getPrimaryPhoneNumber().getAccountPhoneNumberID() eq arguments.accountPhoneNumber.getAccountPhoneNumberID()) {
				arguments.accountPhoneNumber.getAccount().setPrimaryPhoneNumber(javaCast("null",""));
				arguments.accountPhoneNumber.removeAccount();
			}

		}

		return delete(arguments.accountPhoneNumber);
	}

	public boolean function deleteAccountAddress(required any accountAddress) {

		// Check delete validation
		if(arguments.accountAddress.isDeletable()) {

			// If the primary address is this address then set the primary to null
			if(arguments.accountAddress.getAccount().getPrimaryAddress().getAccountAddressID() eq arguments.accountAddress.getAccountAddressID()) {
				arguments.accountAddress.getAccount().setPrimaryAddress(javaCast("null",""));
			}
			// If the primary address is this address then set the primary to null
			if(!isNull(arguments.accountAddress.getAccount()) && !isNull(arguments.accountAddress.getAccount().getPrimaryShippingAddress())&&!isNull(arguments.accountAddress.getAccount().getPrimaryShippingAddress().getAccountAddressID()) && arguments.accountAddress.getAccount().getPrimaryShippingAddress().getAccountAddressID() eq arguments.accountAddress.getAccountAddressID()) {
				arguments.accountAddress.getAccount().setPrimaryShippingAddress(javaCast("null",""));
			}
			// If the primary address is this address then set the primary to null
			if(!isNull(arguments.accountAddress.getAccount()) && !isNull(arguments.accountAddress.getAccount().getPrimaryBillingAddress()) &&!isNull(arguments.accountAddress.getAccount().getPrimaryBillingAddress().getAccountAddressID()) && arguments.accountAddress.getAccount().getPrimaryBillingAddress().getAccountAddressID() eq arguments.accountAddress.getAccountAddressID()) {
				arguments.accountAddress.getAccount().setPrimaryBillingAddress(javaCast("null",""));
			}

			// Remove from any order objects
			getAccountDAO().removeAccountAddressFromOrderFulfillments( accountAddressID = arguments.accountAddress.getAccountAddressID() );
			getAccountDAO().removeAccountAddressFromOrderPayments( accountAddressID = arguments.accountAddress.getAccountAddressID() );
			getAccountDAO().removeAccountAddressFromOrders( accountAddressID = arguments.accountAddress.getAccountAddressID() );
			getAccountDAO().removeAccountAddressFromSubscriptionUsages( accountAddressID = arguments.accountAddress.getAccountAddressID() );
		   
		    arguments.accountAddress.removeAccount();
            arguments.accountAddress.setAddress(javaCast("null","")); 

		}

		return delete(arguments.accountAddress);
	}

	public boolean function deleteAccountPaymentMethod(required any accountPaymentMethod) {

		// Check delete validation
		if(arguments.accountPaymentMethod.isDeletable()) {

			var account = arguments.accountPaymentMethod.getAccount();

			arguments.accountPaymentMethod.removeAccount();

			// If the primary payment method is this payment method then set the primary to null
			if(account.getPrimaryPaymentMethod().getAccountPaymentMethodID() eq arguments.accountPaymentMethod.getAccountPaymentMethodID()) {
				account.setPrimaryPaymentMethod(javaCast("null",""));
			}

			getAccountDAO().removeAccountPaymentMethodFromOrderPayments( accountPaymentMethodID = arguments.accountPaymentMethod.getAccountPaymentMethodID() );
		}

		return delete(arguments.accountPaymentMethod);
	}


	// =====================  END: Delete Overrides ===========================

	// ===================== START: Private Helper Functions ==================

	private any function createNewAccountPassword (required any account, required any processObject ){

		var existingPasswords = getInternalAccountAuthenticationsByEmailAddress(arguments.account.getPrimaryEmailAddress().getEmailAddress());

		if(arguments.account.getAdminAccountFlag() == true){

			//Check to see if the password is a duplicate
			var duplicatePasswordCount = checkForDuplicatePasswords(arguments.processObject.getPassword(), existingPasswords);

			if(duplicatePasswordCount > 0){
				arguments.processObject.addError('password', rbKey('validate.newPassword.duplicatePassword'));

				return arguments.account;
			}
		}

		//Because we only want to store 5 passwords, this gets old passwords that put the lenth of the limit.
		if (arrayLen(existingPasswords) >= 4){
			deleteAccountPasswords(arguments, 4);
		}

		//Before creating the new password, make sure that all other passwords have an activeFlag of false
		markOldPasswordsInactive(existingPasswords);

		//Save the new password
		var accountAuthentication = this.newAccountAuthentication();
		accountAuthentication.setAccount( arguments.account );

		// Put the accountAuthentication into the hibernate scope so that it has an id which will allow the hash / salting below to work
		getHibachiDAO().save(accountAuthentication);

		// Set the password
		accountAuthentication.setPassword( getHashedAndSaltedPassword(arguments.processObject.getPassword(), accountAuthentication.getAccountAuthenticationID()) );

		return arguments.account;
	}

	private any function checkForDuplicatePasswords(required any newPassword, required array authArray){

		//Initilize variable to store the number of duplicate passwords
		var duplicatePasswordCount = 0;

		//Loop over the existing authentications for this account
		for(authentication in arguments.authArray){
			if(isNull(authentication.getIntegration()) && !isNull(authentication.getPassword())) {
				//Check to see if the password for this authentication is the same as the one being created
				if(authentication.getPassword() == getHashedAndSaltedPassword(arguments.newPassword, authentication.getAccountAuthenticationID())){
					//Because they are the same add 1 to the duplicatePasswordCount
					duplicatePasswordCount++;

				}
			}
		}

		return duplicatePasswordCount;
	}

	private void function markOldPasswordsInactive(required array authArray){
		for(authentication in arguments.authArray){
			if(isNull(authentication.getIntegration()) && !isNull(authentication.getPassword()) && authentication.getActiveFlag() == true) {
				authentication.setActiveFlag(false);
			}
		}
	}

	private void function deleteAccountPasswords(required struct data, required any maxAuthenticationsCount ){

		//First need to get an array of all the accountAuthentications for this account ordered by creationDateTime ASC
		var accountAuthentications = getAccountAuthenticationSmartList(data=data);
		accountAuthentications.addFilter("account.accountID", arguments.data.Account.getAccountID());
		accountAuthentications.addWhereCondition("a#lcase(getDao('hibachiDao').getApplicationKey())#accountauthentication.password IS NOT NULL AND a#lcase(getDao('hibachiDao').getApplicationKey())#integration.integrationID IS NULL");
		accountAuthentications.addOrder("createdDateTime|ASC");

		//Get the actual records from the SmartList and store in an array
		accountAuthenticationsArray = accountAuthentications.getPageRecords();

		//Create a variable to hold the length of the new array
		var numberOfRecordsToBeDeleted = arrayLen(accountAuthenticationsArray) - arguments.maxAuthenticationsCount + 1;

		//Loop through the length of the array until you are under the maxAuthenticationsCount for that Account.
		for(var i=1; i <= numberOfRecordsToBeDeleted; i++){
			//if the password that is going to be deleted is how the user logged in, updated the session to the new active password
			if( !isNull(getHibachiScope().getSession().getAccountAuthentication()) && accountAuthenticationsArray[i].getAccountAuthenticationID() == getHibachiScope().getSession().getAccountAuthentication().getAccountAuthenticationID()){
				var activePassword = getAccountDAO().getActivePasswordByAccountID(arguments.data.Account.getAccountID());
				getHibachiScope().getSession().setAccountAuthentication(activePassword);
			}
			accountAuthenticationsArray[i].removeAccount();
			// remove this authentication from old session
			getAccountDAO().removeAccountAuthenticationFromAllSessions( accountAuthenticationsArray[i].getAccountAuthenticationID() );
			this.deleteAccountAuthentication( accountAuthenticationsArray[i] );
		}

	}

	private boolean function checkPasswordResetRequired(required any accountAuthentication, required any processObject){
		if (accountAuthentication.getUpdatePasswordOnNextLoginFlag() == true
			|| ( accountAuthentication.getAccount().getAdminAccountFlag() &&
					( dateCompare(Now(), dateAdd('d', arguments.accountAuthentication.getAccount().setting('accountAdminForcePasswordResetAfterDays'), accountAuthentication.getCreatedDateTime()))  == 1
					|| !REFind("^.*(?=.{7,})(?=.*[0-9])(?=.*[a-zA-Z]).*$" , arguments.processObject.getPassword())
					|| ( !isNull(accountAuthentication.getCreatedByAccount()) && accountAuthentication.getCreatedByAccount().getAccountID() != accountAuthentication.getAccount().getAccountId())
					)
				)
			)
		{
			return true;
		}

		return false;
	}
	// =====================  END:  Private Helper Functions ==================

}
