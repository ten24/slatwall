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
component displayname="Account" entityname="SlatwallAccount" table="SwAccount" persistent="true" output="false" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="accountService" hb_permission="this" hb_processContexts="addAccountLoyalty,addAccountPayment,createPassword,changePassword,create,forgotPassword,lock,login,logout,resetPassword,setupInitialAdmin,unlock,updatePassword,generateAPIAccessKey" {

	// Persistent Properties
	property name="accountID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="superUserFlag" ormtype="boolean";
	property name="firstName" hb_populateEnabled="public" ormtype="string";
	property name="lastName" hb_populateEnabled="public" ormtype="string";
	property name="company" hb_populateEnabled="public" ormtype="string";
	property name="loginLockExpiresDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="failedLoginAttemptCount" hb_populateEnabled="false" ormtype="integer" hb_auditable="false";
	property name="taxExemptFlag" ormtype="boolean";
	// CMS Properties
	property name="cmsAccountID" ormtype="string" hb_populateEnabled="false" index="RI_CMSACCOUNTID";

	// Related Object Properties (many-to-one)
	property name="primaryBillingAddress" hb_populateEnabled="public" cfc="AccountAddress" fieldtype="many-to-one" fkcolumn="primaryBillingAddressID";
	property name="primaryEmailAddress" hb_populateEnabled="public" cfc="AccountEmailAddress" fieldtype="many-to-one" fkcolumn="primaryEmailAddressID";
	property name="primaryPhoneNumber" hb_populateEnabled="public" cfc="AccountPhoneNumber" fieldtype="many-to-one" fkcolumn="primaryPhoneNumberID";
	property name="primaryAddress" hb_populateEnabled="public" cfc="AccountAddress" fieldtype="many-to-one" fkcolumn="primaryAddressID";
	property name="primaryPaymentMethod" hb_populateEnabled="public" cfc="AccountPaymentMethod" fieldtype="many-to-one" fkcolumn="primaryPaymentMethodID";
	property name="primaryShippingAddress" hb_populateEnabled="public" cfc="AccountAddress" fieldtype="many-to-one" fkcolumn="primaryShippingAddressID";
	property name="accountCreatedSite" hb_populateEnabled="public" cfc="Site" fieldtype="many-to-one" fkcolumn="accountCreatedSiteID";

	// Related Object Properties (one-to-many)
	property name="accountAddresses" hb_populateEnabled="public" singularname="accountAddress" fieldType="one-to-many" type="array" fkColumn="accountID" cfc="AccountAddress" inverse="true" cascade="all-delete-orphan";
	property name="accountAuthentications" singularname="accountAuthentication" cfc="AccountAuthentication" type="array" fieldtype="one-to-many" fkcolumn="accountID" cascade="all-delete-orphan" inverse="true";
	property name="accountContentAccesses" hb_populateEnabled="false" singularname="accountContentAccess" cfc="AccountContentAccess" type="array" fieldtype="one-to-many" fkcolumn="accountID" inverse="true" cascade="all-delete-orphan";
	property name="accountEmailAddresses" hb_populateEnabled="public" singularname="accountEmailAddress" type="array" fieldtype="one-to-many" fkcolumn="accountID" cfc="AccountEmailAddress" cascade="all-delete-orphan" inverse="true";
	property name="accountLoyalties" singularname="accountLoyalty" type="array" fieldtype="one-to-many" fkcolumn="accountID" cfc="AccountLoyalty" cascade="all-delete-orphan" inverse="true";
	property name="accountPaymentMethods" hb_populateEnabled="public" singularname="accountPaymentMethod" cfc="AccountPaymentMethod" type="array" fieldtype="one-to-many" fkcolumn="accountID" inverse="true" cascade="all-delete-orphan";
	property name="accountPayments" singularname="accountPayment" cfc="AccountPayment" type="array" fieldtype="one-to-many" fkcolumn="accountID" cascade="all" inverse="true";
	property name="accountPhoneNumbers" hb_populateEnabled="public" singularname="accountPhoneNumber" type="array" fieldtype="one-to-many" fkcolumn="accountID" cfc="AccountPhoneNumber" cascade="all-delete-orphan" inverse="true";
 	property name="attributeValues" singularname="attributeValue" cfc="AttributeValue" fieldtype="one-to-many" type="array" fkcolumn="accountID" cascade="all-delete-orphan" inverse="true";
  	property name="eventRegistrations" singularname="eventRegistration" fieldtype="one-to-many" fkcolumn="accountID" cfc="EventRegistration" inverse="true" cascade="all-delete-orphan";
  	property name="orders" hb_populateEnabled="false" singularname="order" fieldType="one-to-many" type="array" fkColumn="accountID" cfc="Order" inverse="true" orderby="orderOpenDateTime desc";
	property name="productReviews" hb_populateEnabled="false" singularname="productReview" fieldType="one-to-many" type="array" fkColumn="accountID" cfc="ProductReview" inverse="true";
	property name="subscriptionUsageBenefitAccounts" singularname="subscriptionUsageBenefitAccount" cfc="SubscriptionUsageBenefitAccount" type="array" fieldtype="one-to-many" fkcolumn="accountID" cascade="all-delete-orphan" inverse="true";
	property name="subscriptionUsages" singularname="subscriptionUsage" cfc="SubscriptionUsage" type="array" fieldtype="one-to-many" fkcolumn="accountID" cascade="all-delete-orphan" inverse="true";
	property name="termAccountOrderPayments" singularname="termAccountOrderPayment" cfc="OrderPayment" type="array" fieldtype="one-to-many" fkcolumn="termPaymentAccountID" cascade="all" inverse="true";
	property name="giftCards" singularname="giftCard" cfc="GiftCard" type="array" fieldtype="one-to-many" fkcolumn="ownerAccountID" cascade="all" inverse="true";

	// Related Object Properties (many-to-many - owner)
	property name="priceGroups" singularname="priceGroup" cfc="PriceGroup" fieldtype="many-to-many" linktable="SwAccountPriceGroup" fkcolumn="accountID" inversejoincolumn="priceGroupID";
	property name="permissionGroups" singularname="permissionGroup" cfc="PermissionGroup" fieldtype="many-to-many" linktable="SwAccountPermissionGroup" fkcolumn="accountID" inversejoincolumn="permissionGroupID";

	// Related Object Properties (many-to-many - inverse)
	property name="promotionCodes" hb_populateEnabled="false" singularname="promotionCode" cfc="PromotionCode" type="array" fieldtype="many-to-many" linktable="SwPromotionCodeAccount" fkcolumn="accountID" inversejoincolumn="promotionCodeID" inverse="true";

	// Remote properties
	property name="remoteID" hb_populateEnabled="false" ormtype="string" hint="Only used when integrated with a remote system";
	property name="remoteEmployeeID" hb_populateEnabled="false" ormtype="string" hint="Only used when integrated with a remote system";
	property name="remoteCustomerID" hb_populateEnabled="false" ormtype="string" hint="Only used when integrated with a remote system";
	property name="remoteContactID" hb_populateEnabled="false" ormtype="string" hint="Only used when integrated with a remote system";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	// Non Persistent
	property name="primaryEmailAddressNotInUseFlag" persistent="false";
	property name="activeSubscriptionUsageBenefitsSmartList" persistent="false";
	property name="address" persistent="false";
	property name="adminIcon" persistent="false";
	property name="adminAccountFlag" persistent="false" hb_formatType="yesno";
	property name="emailAddress" persistent="false" hb_formatType="email";
	property name="fullName" persistent="false";
	property name="gravatarURL" persistent="false";
	property name="guestAccountFlag" persistent="false" hb_formatType="yesno";
	property name="ordersPlacedSmartList" persistent="false";
	property name="ordersNotPlacedSmartList" persistent="false";
	property name="passwordResetID" persistent="false";
	property name="phoneNumber" persistent="false";
	property name="saveablePaymentMethodsSmartList" persistent="false";
	property name="eligibleAccountPaymentMethodsSmartList" persistent="false";
	property name="slatwallAuthenticationExistsFlag" persistent="false";
	property name="termAccountAvailableCredit" persistent="false" hb_formatType="currency";
	property name="termAccountBalance" persistent="false" hb_formatType="currency";
	property name="unenrolledAccountLoyaltyOptions" persistent="false";
	property name="termOrderPaymentsByDueDateSmartList" persistent="false";
	property name="jwtToken" persistent="false";
	property name="urlTitle" ormtype="string"; //allows this entity to be found via a url title.
	
	public boolean function isPriceGroupAssigned(required string  priceGroupId) {
		return structKeyExists(this.getPriceGroupsStruct(), arguments.priceGroupID);
	}

	// ============ START: Non-Persistent Property Methods =================

	public any function getPrimaryEmailAddressesNotInUseFlag() {
		if(!structKeyExists(variables, "primaryEmailAddressNotInUseFlag")) {
			variables.primaryEmailAddressNotInUseFlag = true;
			if(len(getEmailAddress())) {
				if(getNewFlag()) {
					variables.primaryEmailAddressNotInUseFlag = getService("accountService").getPrimaryEmailAddressNotInUseFlag( emailAddress=getEmailAddress() );
				} else {
					variables.primaryEmailAddressNotInUseFlag = getService("accountService").getPrimaryEmailAddressNotInUseFlag( emailAddress=getEmailAddress(), accountID=getAccountID() );
				}
			}
		}
		return variables.primaryEmailAddressNotInUseFlag;
	}

	public any function getSaveablePaymentMethodsSmartList() {
		if(!structKeyExists(variables, "saveablePaymentMethodsSmartList")) {
			variables.saveablePaymentMethodsSmartList = getService("paymentService").getPaymentMethodSmartList();
			variables.saveablePaymentMethodsSmartList.addFilter('activeFlag', 1);
			variables.saveablePaymentMethodsSmartList.addFilter('allowSaveFlag', 1);
			variables.saveablePaymentMethodsSmartList.addInFilter('paymentMethodType', 'creditCard,giftCard,external,termPayment');
			if(len(setting('accountEligiblePaymentMethods'))) {
				variables.saveablePaymentMethodsSmartList.addInFilter('paymentMethodID', setting('accountEligiblePaymentMethods'));
			}
		}
		return variables.saveablePaymentMethodsSmartList;
	}

	public any function getEligibleAccountPaymentMethodsSmartList() {		
		// These are the payment methods that are allowed only when adding an account payment
		if(!structKeyExists(variables, "eligibleAccountPaymentMethodsSmartList")) {
			var sl = getService("paymentService").getPaymentMethodSmartList();
			
			// Prevent 'termPayment' from displaying as account payment method option			
			sl.addInFilter('paymentMethodType', 'cash,check,creditCard,external,giftCard');			
			sl.addInFilter('paymentMethodID', setting('accountEligiblePaymentMethods'));
			sl.addFilter('activeFlag', 1);

			variables.eligibleAccountPaymentMethodsSmartList = sl;
		}
		return variables.eligibleAccountPaymentMethodsSmartList;
	}

	public any function getActiveSubscriptionUsageBenefitsSmartList() {
		if(!structKeyExists(variables, "activeSubscriptionUsageBenefitsSmartList")) {
			variables.activeSubscriptionUsageBenefitsSmartList = getService("subscriptionService").getSubscriptionUsageBenefitSmartList();
			variables.activeSubscriptionUsageBenefitsSmartList.addRange('subscriptionUsage.expirationDate', '#now()#^');
			variables.activeSubscriptionUsageBenefitsSmartList.addFilter('subscriptionUsageBenefitAccounts.account.accountID', getAccountID());
			variables.activeSubscriptionUsageBenefitsSmartList.addWhereCondition(" ( aslatwallsubscriptionusagebenefitaccount.endDateTime is null OR aslatwallsubscriptionusagebenefitaccount.endDateTime >= :now ) ", {now=now()});
		}
		return variables.activeSubscriptionUsageBenefitsSmartList;
	}

	public any function getAddress() {
		return getPrimaryAddress().getAddress();
	}

	public string function getAdminIcon() {
		return '<img src="#getGravatarURL(55)#" style="width:55px;" />';
	}

	public boolean function getAdminAccountFlag() {
		if(getSuperUserFlag() || arrayLen(variables.permissionGroups)) {
			return true;
		}
		return false;
	}

	public string function getEmailAddress() {
		return getPrimaryEmailAddress().getEmailAddress();
	}

	public string function getFullName() {
		return "#getFirstName()# #getLastName()#";
	}

	public string function getGravatarURL(numeric size=80) {
		if(cgi.server_port eq 443) {
			return "https://secure.gravatar.com/avatar/#lcase(hash(lcase(getEmailAddress()), "MD5" ))#?s=#arguments.size#";
		} else {
			return "http://www.gravatar.com/avatar/#lcase(hash(lcase(getEmailAddress()), "MD5" ))#?s=#arguments.size#";
		}
	}

	public boolean function getGuestAccountFlag() {
		return !arrayLen(getAccountAuthentications());
	}

	public any function getGiftCardSmartList(){
		var giftCardSmartList = getService("GiftCardService").getGiftCardSmartList();
		giftCardSmartList.joinRelatedProperty("SlatwallGiftCard", "ownerAccount");
		giftCardSmartList.addFilter("ownerAccount.AccountID", this.getAccountID());

		return giftCardSmartList;
	}

	public any function getOrdersPlacedSmartList() {
		if(!structKeyExists(variables, "ordersPlacedSmartList")) {
			var osl = getService("orderService").getOrderSmartList();
			osl.addFilter('account.accountID', getAccountID());
			osl.addInFilter('orderStatusType.systemCode', 'ostNew,ostProcessing,ostOnHold,ostClosed,ostCanceled');
			osl.addOrder("orderOpenDateTime|DESC");

			variables.ordersPlacedSmartList = osl;
		}
		return variables.ordersPlacedSmartList;
	}

	public any function getOrdersNotPlacedSmartList() {//this function never been used
		if(!structKeyExists(variables, "ordersNotPlacedSmartList")) {
			var osl = getService("orderService").getOrderSmartList();
			osl.addFilter('account.accountID', getAccountID());
			osl.addInFilter('orderStatusType.systemCode', 'ostNotPlaced');
			osl.addOrder("modifiedDateTime|DESC");

			variables.ordersNotPlacedSmartList = osl;
		}
		return variables.ordersNotPlacedSmartList;
	}

	public string function getPasswordResetID() {
		return getService("accountService").getPasswordResetID(account=this);
	}

	public string function getPhoneNumber() {
		return getPrimaryPhoneNumber().getPhoneNumber();
	}

	public boolean function getSlatwallAuthenticationExistsFlag() {
		if(!structKeyExists(variables, "slatwallAuthenticationExistsFlag")) {
			variables.slatwallAuthenticationExistsFlag = false;
			var authArray = getAccountAuthentications();
			for(auth in authArray) {
				if(isNull(auth.getIntegration()) && !isNull(auth.getPassword())  && !isNull(auth.getActiveFlag()) && auth.getActiveFlag() ) {
					variables.slatwallAuthenticationExistsFlag = true;
					break;
				}
			}
		}
		return variables.slatwallAuthenticationExistsFlag;
	}


	public any function getPaymentMethodOptionsSmartList() {
		if(!structKeyExists(variables, "paymentMethodOptionsSmartList")) {
			variables.paymentMethodOptionsSmartList = getService("paymentService").getPaymentMethodSmartList();
			variables.paymentMethodOptionsSmartList.addFilter("activeFlag", 1);
			variables.paymentMethodOptionsSmartList.addInFilter("paymentMethodType", "cash,check,creditCard,external,giftCard");
		}
		return variables.paymentMethodOptionsSmartList;
	}

	public numeric function getTermAccountAvailableCredit() {
		var termAccountAvailableCredit = setting('accountTermCreditLimit');

		termAccountAvailableCredit = getService('HibachiUtilityService').precisionCalculate(termAccountAvailableCredit - getTermAccountBalance());

		return termAccountAvailableCredit;
	}

	public numeric function getTermAccountBalance() {
		var termAccountBalance = 0;

		// First look at all the unreceived open order payment
		for(var termAccountOrderPayment in getTermAccountOrderPayments()) {
			if(!termAccountOrderPayment.getNewFlag()){
				termAccountBalance = getService('HibachiUtilityService').precisionCalculate(termAccountBalance + termAccountOrderPayment.getAmountUnreceived());
			}
		}

		// Now look for the unassigned payment amount
		for(var accountPayment in getAccountPayments()) {
			termAccountBalance = getService('HibachiUtilityService').precisionCalculate(termAccountBalance - accountPayment.getAmountUnassigned());
		}

		return termAccountBalance;
	}

	public any function getTermOrderPaymentsByDueDateSmartList() {
		if(!structKeyExists(variables, "termOrderPaymentsByDueDateSmartList")) {
			variables.termOrderPaymentsByDueDateSmartList = getService('orderService').getOrderPaymentSmartList();
			variables.termOrderPaymentsByDueDateSmartList.addFilter('order.account.accountId', this.getAccountID());
			variables.termOrderPaymentsByDueDateSmartList.addInFilter("order.orderStatusType.systemCode", "ostProcessing,ostNew,ostOnHold");
			variables.termOrderPaymentsByDueDateSmartList.addFilter('paymentMethod.paymentMethodType', 'termPayment');
			variables.termOrderPaymentsByDueDateSmartList.addOrder('paymentDueDate|ASC');
		}
		return variables.termOrderPaymentsByDueDateSmartList;
	}

	public any function getUnenrolledAccountLoyaltyOptions() {
		if(!structKeyExists(variables, "unenrolledAccountLoyaltyOptions")) {
			variables.unenrolledAccountLoyaltyOptions = [];

			var smartList = getService("loyaltyService").getLoyaltySmartList();
			smartList.addFilter('activeFlag', 1);
			smartList.addWhereCondition(" NOT EXISTS
				( 
					FROM SlatwallAccountLoyalty al 
					WHERE al.loyalty.loyaltyID = aslatwallloyalty.loyaltyID 
					and al.account.accountID = '#getAccountID()#'
				)
			");
			for(var loyaltyPrograms in smartList.getRecords()) {
				arrayAppend(variables.unenrolledAccountLoyaltyOptions,
								{name=loyaltyPrograms.getLoyaltyName(),
								value=loyaltyPrograms.getLoyaltyID()}
							);
			}
		}

		return variables.unenrolledAccountLoyaltyOptions;
	}

	public any function getActiveAccountAuthentications(){
		var authentications = getAccountAuthentications();

		var activeAuthentications = [];

		for (var i = ArrayLen(authentications); i >= 1; i--){
			var authentication = authentications[i];

			if( 
                !isNull(authentication.getIntegration())
                || isNull(authentication.getPassword())
                || isNull(authentication.getActiveFlag())
                || authentication.getActiveFlag() == true
            ){
				arrayAppend(activeAuthentications, authentication);
			}
		}

		return activeAuthentications;
	}

	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	// Primary Shipping Address (many-to-one | circular)
	public void function setPrimaryBillingAddress( any accountAddress ) {
		if(structKeyExists(arguments, "accountAddress")) {
			variables.primaryBillingAddress = arguments.accountAddress;
			arguments.accountAddress.setAccount( this );
		} else {
			structDelete(variables, "primaryBillingAddress");
		}
	}

	// Primary Email Address (many-to-one | circular)
	public void function setPrimaryEmailAddress( any accountEmailAddress ) {
		if(structKeyExists(arguments, "accountEmailAddress")) {
			variables.primaryEmailAddress = arguments.accountEmailAddress;
			arguments.accountEmailAddress.setAccount( this );
		} else {
			structDelete(variables, "primaryEmailAddress");
		}
	}

	// Primary Phone Number (many-to-one | circular)
	public void function setPrimaryPhoneNumber( any accountPhoneNumber ) {
		if(structKeyExists(arguments, "accountPhoneNumber")) {
			variables.primaryPhoneNumber = arguments.accountPhoneNumber;
			arguments.accountPhoneNumber.setAccount( this );
		} else {
			structDelete(variables, "primaryPhoneNumber");
		}
	}

	// Primary Address (many-to-one | circular)
	public void function setPrimaryAddress( any accountAddress ) {
		if(structKeyExists(arguments, "accountAddress")) {
			variables.primaryAddress = arguments.accountAddress;
			arguments.accountAddress.setAccount( this );
		} else {
			structDelete(variables, "primaryAddress");
		}
	}

	// Primary Account Payment Method (many-to-one | circular)
	public void function setPrimaryAccountPaymentMethod( any accountPaymentMethod ) {
		if(structKeyExists(arguments, "accountPaymentMethod")) {
			variables.primaryPaymentMethod = arguments.accountPaymentMethod;
			arguments.accountPaymentMethod.setAccount( this );
		} else {
			structDelete(variables, "primaryPaymentMethod");
		}
	}

	// Primary Shipping Address (many-to-one | circular)
	public void function setPrimaryShippingAddress( any accountAddress ) {
		if(structKeyExists(arguments, "accountAddress")) {
			variables.primaryShippingAddress = arguments.accountAddress;
			arguments.accountAddress.setAccount( this );
		} else {
			structDelete(variables, "primaryShippingAddress");
		}
	}

	// Account Addresses (one-to-many)
	public void function addAccountAddress(required any accountAddress) {
		arguments.accountAddress.setAccount( this );
	}
	public void function removeAccountAddress(required any accountAddress) {
		arguments.accountAddress.removeAccount( this );
	}

	// Account Authentications (one-to-many)
	public void function addAccountAuthentication(required any accountAuthentication) {
		arguments.accountAuthentication.setAccount( this );
	}
	public void function removeAccountAuthentication(required any accountAuthentication) {
		arguments.accountAuthentication.removeAccount( this );
	}

	// Account Content Accesses (one-to-many)
	public void function addAccountContentAccess(required any accountContentAccess) {
		arguments.accountContentAccess.setAccount( this );
	}
	public void function removeAccountContentAccess(required any accountContentAccess) {
		arguments.accountContentAccess.removeAccount( this );
	}

	// Account Email Addresses (one-to-many)
	public void function addAccountEmailAddress(required any accountEmailAddress) {
		arguments.accountEmailAddress.setAccount( this );
	}
	public void function removeAccountEmailAddress(required any accountEmailAddress) {
		arguments.accountEmailAddress.removeAccount( this );
	}

	// Account Payment Methods (one-to-many)
	public void function addAccountPaymentMethod(required any accountPaymentMethod) {
		arguments.accountPaymentMethod.setAccount( this );
	}
	public void function removeAccountPaymentMethod(required any accountPaymentMethod) {
		arguments.accountPaymentMethod.removeAccount( this );
	}

	// Account Payments (one-to-many)
	public void function addAccountPayment(required any accountPayment) {
		arguments.accountPayment.setAccount( this );
	}
	public void function removeAccountPayment(required any accountPayment) {
		arguments.accountPayment.removeAccount( this );
	}

	// Account Phone Numbers (one-to-many)
	public void function addAccountPhoneNumber(required any accountPhoneNumber) {
		arguments.accountPhoneNumber.setAccount( this );
	}
	public void function removeAccountPhoneNumber(required any accountPhoneNumber) {
		arguments.accountPhoneNumber.removeAccount( this );
	}

	// Account Promotions (one-to-many)
	public void function addAccountPromotion(required any AccountPromotion) {
		arguments.AccountPromotion.setAccount( this );
	}
	public void function removeAccountPromotion(required any AccountPromotion) {
		arguments.AccountPromotion.removeAccount( this );
	}

 	// Event Registrations (one-to-many)
  	public void function addEventRegistration(required any eventRegistration) {
  		arguments.eventRegistration.setAccount( this );
  	}
  	public void function removeEventRegistration(required any eventRegistration) {
  		arguments.eventRegistration.removeAccount( this );
  	}

	// Attribute Values (one-to-many)
	public void function addAttributeValue(required any attributeValue) {
		arguments.attributeValue.setAccount( this );
	}
	public void function removeAttributeValue(required any attributeValue) {
		arguments.attributeValue.removeAccount( this );
	}

	// Orders (one-to-many)
	public void function addOrder(required any Order) {
	   arguments.order.setAccount(this);
	}
	public void function removeOrder(required any Order) {
	   arguments.order.removeAccount(this);
	}

	// Product Reviews (one-to-many)
	public void function addProductReview(required any productReview) {
		arguments.productReview.setAccount(this);
	}
	public void function removeProductReview(required any productReview) {
		arguments.productReview.removeAccount(this);
	}

	// Subscription Usage Benefits (one-to-many)
	public void function addSubscriptionUsageBenefitAccount(required any subscriptionUsageBenefitAccount) {
		arguments.subscriptionUsageBenefitAccount.setAccount( this );
	}
	public void function removeSubscriptionUsageBenefitAccount(required any subscriptionUsageBenefitAccount) {
		arguments.subscriptionUsageBenefitAccount.removeAccount( this );
	}

	// Subscription Usage (one-to-many)
	public void function addSubscriptionUsage(required any subscriptionUsage) {
		arguments.subscriptionUsage.setAccount( this );
	}
	public void function removeSubscriptionUsage(required any subscriptionUsage) {
		arguments.subscriptionUsage.removeAccount( this );
	}

	// Term Account Order Payments (one-to-many)
	public void function addTermAccountOrderPayment(required any termAccountOrderPayment) {
		arguments.termAccountOrderPayment.setTermPaymentAccount( this );
	}
	public void function removeTermAccountOrderPayment(required any termAccountOrderPayment) {
		arguments.termAccountOrderPayment.removeTermPaymentAccount( this );
	}

	// Account Loyalty Programs (one-to-many)
	public void function addAccountLoyalty(required any accountLoyalty) {
		arguments.accountLoyalty.setAccount( this );
	}
	public void function removeAccountLoyalty(required any accountLoyalty) {
		arguments.accountLoyalty.removeAccount( this );
	}

	/// Gift Cards (one-to-many)
	public void function addGiftCard(required any giftCard){
		arguments.giftCard.setOwnerAccount( this );
	}

	public void function removeGiftCard(required any giftCard){
		arguments.giftCard.removeOwnerAccount( this );
	}

	// Price Groups (many-to-many - owner)
	public void function addPriceGroup(required any priceGroup) {
		if(arguments.priceGroup.isNew() or !hasPriceGroup(arguments.priceGroup)) {
			arrayAppend(variables.priceGroups, arguments.priceGroup);
		}
		if(isNew() or !arguments.priceGroup.hasAccount( this )) {
			arrayAppend(arguments.priceGroup.getAccounts(), this);
		}
	}
	public void function removePriceGroup(required any priceGroup) {
		var thisIndex = arrayFind(variables.priceGroups, arguments.priceGroup);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.priceGroups, thisIndex);
		}
		var thatIndex = arrayFind(arguments.priceGroup.getAccounts(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.priceGroup.getAccounts(), thatIndex);
		}
	}

	// Permission Groups (many-to-many - owner)
	public void function addPermissionGroup(required any permissionGroup) {
		if(arguments.permissionGroup.isNew() or !hasPermissionGroup(arguments.permissionGroup)) {
			arrayAppend(variables.permissionGroups, arguments.permissionGroup);
		}
		if(isNew() or !arguments.permissionGroup.hasAccount( this )) {
			arrayAppend(arguments.permissionGroup.getAccounts(), this);
		}
	}
	public void function removePermissionGroup(required any permissionGroup) {
		var thisIndex = arrayFind(variables.permissionGroups, arguments.permissionGroup);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.permissionGroups, thisIndex);
		}
		var thatIndex = arrayFind(arguments.permissionGroup.getAccounts(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.permissionGroup.getAccounts(), thatIndex);
		}
	}

	// Promotion Codes (many-to-many - inverse)
	public void function addPromotionCode(required any promotionCode) {
		arguments.promotionCode.addAccount( this );
	}
	public void function removePromotionCode(required any promotionCode) {
		arguments.promotionCode.removeAccount( this );
	}

	// =============  END:  Bidirectional Helper Methods ===================

	// ============= START: Overridden Smart List Getters ==================

	public any function getAccountContentAccessesSmartList() {
		if(!structKeyExists(variables, "accountContentAccessesSmartList")) {
			variables.accountContentAccessesSmartList = getService("accountService").getAccountContentAccessSmartList();
			variables.accountContentAccessesSmartList.joinRelatedProperty("SlatwallAccountContentAccess", "orderItem", "INNER", true);
			variables.accountContentAccessesSmartList.joinRelatedProperty("SlatwallOrderItem", "order", "INNER", true);
			variables.accountContentAccessesSmartList.joinRelatedProperty("SlatwallAccountContentAccess", "accessContents", "INNER", true);
			variables.accountContentAccessesSmartList.addFilter('account.accountID', getAccountID());
		}
		return variables.accountContentAccessesSmartList;
	}

	// =============  END: Overridden Smart List Getters ===================

	// ================== START: Overridden Methods ========================

	public any function getPrimaryEmailAddress() {
		if(!isNull(variables.primaryEmailAddress)) {
			return variables.primaryEmailAddress;
		} else if (arrayLen(getAccountEmailAddresses())) {
			for(var accountEmailAddress in getAccountEmailAddresses()) {
				if(getService("accountService").getPrimaryEmailAddressNotInUseFlag( emailAddress=accountEmailAddress.getEmailAddress(), accountID=getAccountID() )) {
					variables.primaryEmailAddress = getAccountEmailAddresses()[1];
					return variables.primaryEmailAddress;
				}
			}
		}

		return getService("accountService").newAccountEmailAddress();
	}

	public any function getPrimaryPhoneNumber() {
		if(!isNull(variables.primaryPhoneNumber)) {
			return variables.primaryPhoneNumber;
		} else if (arrayLen(getAccountPhoneNumbers())) {
			variables.primaryPhoneNumber = getAccountPhoneNumbers()[1];
			return variables.primaryPhoneNumber;
		} else {
			return getService("accountService").newAccountPhoneNumber();
		}
	}

	public any function getPrimaryAddress() {
		if(!isNull(variables.primaryAddress)) {
			return variables.primaryAddress;
		} else if (arrayLen(getAccountAddresses())) {
			variables.primaryAddress = getAccountAddresses()[1];
			return variables.primaryAddress;
		} else {
			return getService("accountService").newAccountAddress();
		}
	}

	public any function getPrimaryPaymentMethod() {
		if(!isNull(variables.primaryPaymentMethod)) {
			return variables.primaryPaymentMethod;
		} else if (arrayLen(getAccountPaymentMethods())) {
			variables.primaryPaymentMethod = getAccountPaymentMethods()[1];
			return variables.primaryPaymentMethod;
		} else {
			return getService("accountService").newAccountPaymentMethod();
		}
	}

	public boolean function getSuperUserFlag() {
		if(isNull(variables.superUserFlag)) {
			variables.superUserFlag = false;
		}
		return variables.superUserFlag;
	}

	public string function getSimpleRepresentation() {
		return getFullName();
	}

	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	// ===================  END:  ORM Event Hooks  =========================

	// ================== START: Deprecated Methods ========================

	public array function getAttributeSets(){
		return getAssignedAttributeSetSmartList().getRecords();
	}

	public boolean function isGuestAccount() {
		return getGuestAccountFlag();
	}

	// ==================  END:  Deprecated Methods ========================
	public string function getAccountURL() {
		return "/#setting('globalUrlKeyAccount')#/#getUrlTitle()#/";
	}

	
}
