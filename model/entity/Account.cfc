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
component displayname="Account" entityname="SlatwallAccount" table="SwAccount" persistent="true" output="false" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="accountService" hb_permission="this" hb_processContexts="addAccountLoyalty,addAccountPayment,createPassword,changePassword,clone,create,forgotPassword,lock,login,logout,resetPassword,setupInitialAdmin,unlock,updatePassword,generateAPIAccessKey,updatePrimaryEmailAddress" {

	// Persistent Properties
	property name="accountID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="activeFlag" ormtype="boolean";
	property name="superUserFlag" ormtype="boolean";
	property name="firstName" hb_populateEnabled="public" ormtype="string";
	property name="lastName" hb_populateEnabled="public" ormtype="string";
	property name="company" hb_populateEnabled="public" ormtype="string";
	property name="loginLockExpiresDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="failedLoginAttemptCount" hb_populateEnabled="false" ormtype="integer" hb_auditable="false";
	property name="totpSecretKey" hb_populateEnabled="false" ormtype="string" hb_auditable="false";
	property name="totpSecretKeyCreatedDateTime" hb_populateEnabled="false" ormtype="string" hb_auditable="false";
	property name="taxExemptFlag" ormtype="boolean";
	property name="organizationFlag" ormtype="boolean" default="false";
	property name="testAccountFlag" ormtype="boolean";
	property name="verifiedAccountFlag" ormtype="boolean" default="false";
	property name="accountCode" ormtype="string" hb_populateEnabled="public" index="PI_ACCOUNTCODE";
	property name="urlTitle" ormtype="string"; //allows this entity to be found via a url title.
	property name="accountCreateIPAddress" ormtype="string";
	property name="rank" hb_populateEnabled="public" ormtype="string";
	property name="username" hb_populateEnabled="public" ormtype="string";

	//calucluated property
	property name="calculatedAdminIcon" ormtype="string";
	property name="calculatedFullName" ormtype="string";
	property name="calculatedGuestAccountFlag" ormtype="boolean";
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
	property name="ownerAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="ownerAccountID";


	// Related Object Properties (one-to-many)
	property name="childAccountRelationships" singularname="childAccountRelationship" fieldtype="one-to-many" type="array" fkcolumn="parentAccountID" cfc="AccountRelationship";
	property name="parentAccountRelationships" singularname="parentAccountRelationship" fieldtype="one-to-many" type="array" fkcolumn="childAccountID"   cfc="AccountRelationship";
	property name="accountAddresses" hb_populateEnabled="public" singularname="accountAddress" fieldtype="one-to-many" type="array" fkcolumn="accountID" cfc="AccountAddress" inverse="true" cascade="all-delete-orphan";
	property name="accountAuthentications" singularname="accountAuthentication" cfc="AccountAuthentication" type="array" fieldtype="one-to-many" fkcolumn="accountID" cascade="all-delete-orphan" inverse="true";
	property name="accountContentAccesses" hb_populateEnabled="false" singularname="accountContentAccess" cfc="AccountContentAccess" type="array" fieldtype="one-to-many" fkcolumn="accountID" inverse="true" cascade="all-delete-orphan";
	property name="accountCollections" hb_populateEnabled="false" singularname="accountCollection" cfc="AccountCollection" type="array" fieldtype="one-to-many" fkcolumn="accountID" inverse="true" cascade="all-delete-orphan";
	property name="accountEmailAddresses" hb_populateEnabled="public" singularname="accountEmailAddress" type="array" fieldtype="one-to-many" fkcolumn="accountID" cfc="AccountEmailAddress" cascade="all-delete-orphan" inverse="true";
	property name="accountLoyalties" singularname="accountLoyalty" type="array" fieldtype="one-to-many" fkcolumn="accountID" cfc="AccountLoyalty" cascade="all-delete-orphan" inverse="true";
	property name="accountPaymentMethods" hb_populateEnabled="public" singularname="accountPaymentMethod" cfc="AccountPaymentMethod" type="array" fieldtype="one-to-many" fkcolumn="accountID" inverse="true" cascade="all-delete-orphan";
	property name="accountPayments" singularname="accountPayment" cfc="AccountPayment" type="array" fieldtype="one-to-many" fkcolumn="accountID" cascade="all" inverse="true";
	property name="accountPhoneNumbers" hb_populateEnabled="public" singularname="accountPhoneNumber" type="array" fieldtype="one-to-many" fkcolumn="accountID" cfc="AccountPhoneNumber" cascade="all-delete-orphan" inverse="true";
	property name="accountGovernmentIdentifications" hb_populateEnabled="public" singularname="accountGovernmentIdentifications" type="array" fieldtype="one-to-many" fkcolumn="accountID" cfc="AccountGovernmentIdentification" cascade="all-delete-orphan" inverse="true";
 	property name="attributeValues" singularname="attributeValue" cfc="AttributeValue" fieldtype="one-to-many" type="array" fkcolumn="accountID" cascade="all-delete-orphan" inverse="true";
  	property name="eventRegistrations" singularname="eventRegistration" fieldtype="one-to-many" fkcolumn="accountID" cfc="EventRegistration" inverse="true" cascade="all-delete-orphan";
  	property name="orders" hb_populateEnabled="false" singularname="order" fieldType="one-to-many" type="array" fkColumn="accountID" cfc="Order" inverse="true" orderby="orderOpenDateTime desc";
  	property name="orderTemplates" hb_populateEnabled="false" singularname="orderTemplate" fieldType="one-to-many" type="array" fkColumn="accountID" cfc="OrderTemplate" inverse="true";
	property name="productReviews" hb_populateEnabled="false" singularname="productReview" fieldType="one-to-many" type="array" fkColumn="accountID" cfc="ProductReview" inverse="true";
	property name="subscriptionUsageBenefitAccounts" singularname="subscriptionUsageBenefitAccount" cfc="SubscriptionUsageBenefitAccount" type="array" fieldtype="one-to-many" fkcolumn="accountID" cascade="all-delete-orphan" inverse="true";
	property name="subscriptionUsages" singularname="subscriptionUsage" cfc="SubscriptionUsage" type="array" fieldtype="one-to-many" fkcolumn="accountID" cascade="all-delete-orphan" inverse="true";
	property name="termAccountOrderPayments" singularname="termAccountOrderPayment" cfc="OrderPayment" type="array" fieldtype="one-to-many" fkcolumn="termPaymentAccountID" cascade="all" inverse="true";
	property name="giftCards" singularname="giftCard" cfc="GiftCard" type="array" fieldtype="one-to-many" fkcolumn="ownerAccountID" cascade="all" inverse="true";
	property name="fulfillmentBatches" singularname="fulfillmentBatch" fieldType="one-to-many" type="array" fkColumn="accountID" cfc="FulfillmentBatch" inverse="true";
	property name="pickWaves" singularname="pickWave" fieldType="one-to-many" type="array" fkColumn="accountID" cfc="PickWave" inverse="true";
	property name="apiRequestAudits" singularname="apiRequestAudit" fieldType="one-to-many" type="array" fkColumn="accountID" cfc="ApiRequestAudit" inverse="true";

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
	property name="totalOrderRevenue" persistent="false" hb_formatType="currency";
	property name="totalOrdersCount" persistent="false";
	property name="primaryEmailAddressNotInUseFlag" persistent="false";
	property name="usernameNotInUseFlag" persistent="false";
	property name="activeSubscriptionUsageBenefitsSmartList" persistent="false"; 
	property name="address" persistent="false";
	property name="adminIcon" persistent="false";
	property name="adminAccountFlag" persistent="false" hb_formatType="yesno";
	property name="emailAddress" persistent="false" hb_formatType="email";
	property name="fullName" persistent="false";
	property name="gravatarURL" persistent="false";
	property name="guestAccountFlag" persistent="false" hb_formatType="yesno";
	property name="ordersPlacedSmartList" persistent="false";
	property name="ordersPlacedCollectionList" persistent="false";
	property name="ordersNotPlacedSmartList" persistent="false";
	property name="passwordResetID" persistent="false";
	property name="phoneNumber" persistent="false";
	property name="saveablePaymentMethodsSmartList" persistent="false";
	property name="eligibleAccountPaymentMethodsSmartList" persistent="false";
	property name="nonIntegrationAuthenticationExistsFlag" persistent="false";
	property name="siteCurrencyCode" persistent="false"; 
	property name="termAccountAvailableCredit" persistent="false" hb_formatType="currency";
	property name="termAccountBalance" persistent="false" hb_formatType="currency";
	property name="twoFactorAuthenticationFlag" persistent="false" hb_formatType="yesno";
	property name="unenrolledAccountLoyaltyOptions" persistent="false";
	property name="termOrderPaymentsByDueDateSmartList" persistent="false";
	property name="jwtToken" persistent="false";
	property name="fullNameWithPermissionGroups" persistent="false";
    property name="permissionGroupNameList" persistent="false";
    property name="preferredLocale" persistent="false";
	
	 	//CUSTOM PROPERTIES BEGIN
property name="accountType" ormtype="string" hb_formFieldType="select";
	property name="enrollmentDate" ormtype="timestamp";
	property name="sponsorIDNumber" ormtype="string";
	property name="lastSyncedDateTime" ormtype="timestamp";
	property name="calculatedSuccessfulFlexshipOrdersThisYearCount" ormtype="integer";
	property name="languagePreference" ormtype="string" hb_formFieldType="select";
	property name="lastActivityDateTime" ormtype="timestamp";
	
	property name="successfulFlexshipOrdersThisYearCount" persistent="false"; 
	property name="saveablePaymentMethodsCollectionList" persistent="false";
	property name="canCreateFlexshipFlag" persistent="false";
	property name="subscribedToMailchimp" persistent="false";
	property name="genderFullWord" persistent = "false";
	property name="spouseFirstName" persistent = "false";
	property name="spouseLastName" persistent = "false";
	property name="governmentIdentificationLastFour" persistent = "false";


 property name="allowCorporateEmailsFlag" ormtype="boolean" hb_formatType="yesno";
 property name="productPackPurchasedFlag" ormtype="boolean" hb_formatType="yesno" default="false";
 property name="accountStatusType" cfc="Type" fieldtype="many-to-one" fkcolumn="accountStatusTypeID" hb_optionsSmartListData="f:parentType.typeID=2c9180836dacb117016dad1168c2000d";
 property name="subscriptionType" ormtype="string" hb_formFieldType="select";
 property name="renewalDate" ormtype="timestamp" hb_formatType="date";
 property name="spouseName" ormtype="string";
 property name="spouseBirthday" ormtype="timestamp" hb_formatType="date";
 property name="birthDate" ormtype="timestamp" hb_formatType="date";
 property name="accountType" ormtype="string" hb_formFieldType="select";
 property name="accountStatus" ormtype="string" hb_formFieldType="select";
 property name="complianceStatus" ormtype="string" hb_formFieldType="select";
 property name="businessAccountFlag" ormtype="boolean" hb_formatType="yesno" default="false";
 property name="profileImageTest" hb_fileUpload="true" hb_fileAcceptMIMEType="*/*" ormtype="string" hb_formFieldType="file";
 property name="gender" ormtype="string" hb_formFieldType="select";
 property name="accountNumber" ormtype="string";
 property name="careerTitle" ormtype="string" hb_formFieldType="select";
 property name="rank" ormtype="string";
 property name="uplineMarketPartnerNumber" ormtype="string";
 property name="country" ormtype="string";
 property name="referType" ormtype="string" hb_formFieldType="select";
 property name="profileImage" hb_fileUpload="true" hb_fileAcceptMIMEType="*/*" ormtype="string" hb_formFieldType="file";
 property name="terminationDate" ormtype="timestamp" hb_formatType="date";
 property name="lastAccountStatusDate" ormtype="timestamp" hb_formatType="date";
 property name="languagePreference" ormtype="string" hb_formFieldType="select";//CUSTOM PROPERTIES END
	public any function getDefaultCollectionProperties(string includesList = "", string excludesList="modifiedByAccountID,createdByAccountID,modifiedDateTime,createdDateTime,remoteID"){
			arguments.includesList = 'accountID,calculatedFullName,firstName,lastName,company,organizationFlag,accountCode,urlTitle,primaryEmailAddress.emailAddress,primaryPhoneNumber.phoneNumber';
			return super.getDefaultCollectionProperties(argumentCollection=arguments);
	}

	
	public boolean function isPriceGroupAssigned(required string  priceGroupId) {
		return structKeyExists(this.getPriceGroupsStruct(), arguments.priceGroupID);
	}

	// ============ START: Non-Persistent Property Methods =================
	
	public string function getSiteCurrencyCode(){ 
		if(!isNull(getAccountCreatedSite())){
			return getAccountCreatedSite().setting('skuCurrency'); 
		}
	}

	public string function getPreferredLocale(){
		
		if(structKeyExists(variables, 'languagePreference') && len(this.getCountryCode())){
			return lcase('#variables.languagePreference#_#this.getCountryCode()#');
		}else{
			return '';
		}
	}
	
	public string function getCountryCode() {
		
		if(!StructKeyExists(variables, "countryCode")) {
			
			var site = getAccountCreatedSite() ?: getHibachiScope().getCurrentRequestSite();
		
			if(!isNull(site)){
				variables.countryCode = getService('SiteService').getCountryCodeBySite(site);
			} else {
				variables.countryCode = 'us';
			}
		}
		
		return variables.countryCode;
	}

	public array function getOrderCurrencies(){
		var currencyCollectionList = this.getOrdersCollectionList();
		currencyCollectionList.setDisplayProperties('currencyCode');
		currencyCollectionList.setDistinct(true);
		return currencyCollectionList.getRecords();
	}

	public numeric function getTotalOrderRevenue(string currencyCode){
		if(isNew()){
			return 0;
		}
		var accountCollectionList = getService('accountService').getAccountCollectionList();

		var alias = 'totalOrderRevenue';
		accountCollectionList.addFilter('accountID',this.getAccountID());
		accountCollectionList.setDisplayProperties('accountID');
		accountCollectionList.addFilter('orders.orderStatusType.systemCode','ostNotPlaced,ostCanceled','NOT IN');
		accountCollectionList.addDisplayAggregate('orders.calculatedTotal','SUM',alias);
		//filter by currencyCode if currencyCode specified
		if(structKeyExists(arguments,'currencyCode')){
			accountCollectionList.addFilter('orders.currencyCode',arguments.currencyCode);
		}

		var records = accountCollectionList.getRecords();
		if(arraylen(records)){
			return records[1][alias];
		}else{
			return 0;
		}
	}

	public numeric function getTotalOrdersCount(string currencyCode){
		if(isNew()){
			return 0;
		}

		var propertyCountName = 'orderCount';
		var propertyCollectionList = getPropertyCountCollectionList('orders',propertyCountName);
		propertyCollectionList.addFilter('orders.orderStatusType.systemCode','ostNotPlaced,ostCanceled','NOT IN');

		if(structKeyExists(arguments,'currencyCode')){
			propertyCollectionList.addFilter('orders.currencyCode',arguments.currencyCode);
		}

		var records = propertyCollectionList.getRecords();
		if(arraylen(records)){
			return records[1][propertyCountName];
		}else{
			return 0;
		}
	}



	public boolean function canDeleteByOwner(){
		return isNull(getOwnerAccount())
		|| (
			!isNull(getHibachiScope().getAccount().getSuperUserFlag())
			&& getHibachiScope().getAccount().getSuperUserFlag()
		) || getHibachiScope().getAccount().getAccountID() == this.getOwnerAccount().getAccountID();
	}

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
	
	public any function getUsernameNotInUseFlag() {
		if(!structKeyExists(variables, "usernameNotInUseFlag")) {
			variables.usernameNotInUseFlag = true;
			if(!isNull(getUserName()) && len(getUserName()) && getNewFlag()) {
				variables.usernameNotInUseFlag = getService("accountService").getUsernameNotInUseFlag( username=getUsername() );
			} else if(!isNull(getUserName()) && len(getUserName()) ) {
				variables.usernameNotInUseFlag = getService("accountService").getUsernameNotInUseFlag( username=getUsername(), accountID=getAccountID() );
			}
		}
		return variables.usernameNotInUseFlag;
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
		
		//If Gravatars are NOT disabled...
		if(!getHibachiScope().setting('accountDisableGravatars')){
			return '<img src="#getGravatarURL(55)#" style="width:55px;" />';
		} else {
			return '';
		}
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
		var fullName = "";
		if(!isNull(getFirstName())){
			fullName &= getFirstName();
		}
		if(len(fullName)){
			fullName &= ' ';
		}
		if(!isNull(getLastName())){
			fullName &= getLastName();
		}
		return fullName;
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

	public any function getGiftCardOptions() {
		if(!structKeyExists(variables, "giftCardOptions")) {
			var giftCardOptions = this.getActiveGiftCardCollectionList().getRecords();
			var options = []; 
			for(var giftCardOption in giftCardOptions){
				
				var balance = 0;
				if(isNumeric(giftCardOption['calculatedBalanceAmount'])){
					balance = giftCardOption['calculatedBalanceAmount'];  
				}

				var simpleRepresentation = getService('HibachiUtilityService').formatValue_currency(balance,giftCardOption); 
				simpleRepresentation &= ' - ' & giftCardOption['ownerFirstName'] & ' ' & giftCardOption['ownerLastName']; 
				var optionToAdd = {
					'name': simpleRepresentation,
					'calculatedBalanceAmount': balance,
					'value': giftCardOption['giftCardID']
				};
				arrayAppend(options, optionToAdd); 
			}
			arrayPrepend(options, {'name': '-- #rbKey('entity.giftCard.option.select')#','value':''});
 
			variables.giftCardOptions = options;  
		} 
		return variables.giftCardOptions;  
	} 
	
	public any function getActiveGiftCardCollectionList() {
		if(!structKeyExists(variables, "activeGiftCardCollectionList")) {
			var giftCardCollection = getService('GiftCardService').getGiftCardCollectionList(); 
			giftCardCollection.addFilter("ownerAccount.AccountID", this.getAccountID());
			giftCardCollection.addFilter('activeFlag', true); 
			giftCardCollection.addOrderBy('calculatedBalanceAmount|DESC'); 		

			variables.activeGiftCardCollectionList = giftCardCollection;

		} 
		return variables.activeGiftCardCollectionList;  
	}

	public any function getOrdersPlacedCollectionList() {
		if(!structKeyExists(variables, "ordersPlacedCollectionList")) {
			var ocl = getService("orderService").getOrderCollectionList();
			ocl.addFilter('account.accountID', getAccountID());
			ocl.addFilter('orderStatusType.systemCode', 'ostNew,ostProcessing,ostOnHold,ostClosed,ostCanceled', 'in');
			ocl.addOrderBy("orderOpenDateTime|DESC");

			variables.ordersPlacedCollectionList = ocl;
		}
		return variables.ordersPlacedCollectionList;
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

	public any function getOrdersNotPlacedCollectionList() {
		if(!structKeyExists(variables, "ordersNotPlacedCollectionList")) {
			var ocl = getService("orderService").getOrderCollectionList();
			ocl.addFilter('account.accountID', getAccountID());
			ocl.addFilter('orderStatusType.systemCode', 'ostNotPlaced');
			ocl.addOrderBy("modifiedDateTime|DESC");

			variables.ordersNotPlacedCollectionList = ocl;
		}
		return variables.ordersNotPlacedCollectionList;
	}

	public string function getPasswordResetID() {
		return getService("accountService").getPasswordResetID(account=this);
	}
	
	public string function getPermissionGroupNameList() {
		
		if(getNewFlag()){
			return "";
		}
		if( !structKeyExists(variables,'permissionGroupNameList') ){
			var permissionGroupNameList = "";
			
			var permissionGroupCollectionList = this.getPermissionGroupsCollectionList();
			permissionGroupCollectionList.setDisplayProperties('permissionGroupName,permissionGroupID' );
			permissionGroupCollectionList.addFilter('accounts.accountID', variables.accountID);
			permissionGroupCollectionList.setEnforceAuthorization(false);
			permissionGroupCollectionList.setPermissionAppliedFlag(true);
			var permissionGroupRecords = permissionGroupCollectionList.getRecords(formatRecords=false);
			for(var permissionGroupRecord in permissiongroupRecords){
				permissionGroupNameList =  listAppend(permissionGroupNameList,'<a href="?slatAction=admin:entity.detailpermissiongroup&permissionGroupID=#permissionGroupRecord["permissionGroupID"]#">#permissionGroupRecord["permissionGroupName"]#</a>');
			}
			
			if(len(permissionGroupNameList)){
				permissionGroupNameList = '( #permissionGroupNameList# )';
			}

			variables.permissionGroupNameList = permissionGroupNameList;
		}
		
		return variables.permissionGroupNameList;
	}

	public string function getFullNameWithPermissionGroups() {
		if(!isNull(getFullName()) && !isNull(getPermissionGroupNameList())){
			return hibachiHtmlEditFormat(getFullName()) & getPermissionGroupNameList();
		}
	}
	
	public string function getPermissionGroupCacheKey(){
		if(getNewFlag()){
			return "";
		}
		if(!structKeyExists(variables,'permissionGroupCacheKey')){
			var permissionGroupCacheKey = "";
			var permissionGroupCollectionList = this.getPermissionGroupsCollectionList();
			permissionGroupCollectionList.setDisplayProperties('permissionGroupID');
			permissionGroupCollectionList.addFilter('accounts.accountID', variables.accountID);
			permissionGroupCollectionList.setEnforceAuthorization(false);
			permissionGroupCollectionList.setPermissionAppliedFlag(true);
			var permissionGroupRecords = permissionGroupCollectionList.getRecords(formatRecords=false);
			for(var permissionGroupRecord in permissiongroupRecords){
				permissionGroupCacheKey = listAppend(permissionGroupCacheKey,permissionGroupRecord['permissionGroupID'],'_');
			}
			
			variables.permissionGroupCacheKey = permissionGroupCacheKey;
		}
		return variables.permissionGroupCacheKey;
	}

	public string function getPhoneNumber() {
		return getPrimaryPhoneNumber().getPhoneNumber();
	}

	public boolean function getNonIntegrationAuthenticationExistsFlag() {
		if(!structKeyExists(variables, "nonIntegrationAuthenticationExistsFlag")) {
			variables.nonIntegrationAuthenticationExistsFlag = false;
			var authArray = getAccountAuthentications();
			for(var auth in authArray) {
				if(
					(
						!getService('HibachiService').getHasPropertyByEntityNameAndPropertyIdentifier('AccountAuthentication','integration')
						|| isNull(auth.getIntegration())
					)
					&& !isNull(auth.getPassword())  && !isNull(auth.getActiveFlag()) && auth.getActiveFlag()
				) {
					variables.nonIntegrationAuthenticationExistsFlag = true;
					break;
				}
			}
		}
		return variables.nonIntegrationAuthenticationExistsFlag;
	}

	public void function setSlatwallAuthenticationExistsFlag(required boolean slatwallAuthenticationExistsFlag){
		variables.slatwallAuthenticationExistsFlag = arguments.slatwallAuthenticationExistsFlag;
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

		termAccountAvailableCredit = val(precisionEvaluate(termAccountAvailableCredit - getTermAccountBalance()));

		return termAccountAvailableCredit;
	}

	public string function getTwoFactorAuthenticationFlag() {
		return !isNull(getTotpSecretKey()) && len(getTotpSecretKey());
	}

	public numeric function getOrderPaymentAmount(){
		var orderpayments = this.getTermOrderPaymentsByDueDateSmartList().getRecords();
		var orderPaymentAmount = 0;
		for(var orderPayment in orderPayments){
			orderPaymentAmount += orderPayment.getOrder().getPaymentAmountTotal();
		}
		return orderPaymentAmount;
	}

	public numeric function getOrderPaymentUnRecieved(){
		var orderpayments = this.getTermOrderPaymentsByDueDateSmartList().getRecords();
		var orderPaymentUnReceived=0;
		for(var orderPayment in orderPayments){
			orderPaymentUnReceived += orderPayment.getOrder().getPaymentAmountDue();
		}
		return orderPaymentUnReceived;
	}

	public numeric function getOrderPaymentRecieved(){
		var orderpayments = this.getTermOrderPaymentsByDueDateSmartList().getRecords();
		var orderPaymentReceived=0;
		for(var orderPayment in orderPayments){
			orderPaymentReceived += orderPayment.getOrder().getPaymentAmountReceivedTotal();
		}
		return orderPaymentReceived;
	}


	public numeric function getAmountUnassigned(){
		var amountUnassigned = 0;
		amountUnassigned -= getOrderPaymentRecieved();
		var accountPaymentSmartList = this.getAccountPaymentsSmartList();
		accountPaymentSmartList.addInFilter('appliedAccountPayments.orderPayment.order.orderStatusType.systemCode', "ostProcessing,ostNew,ostOnHold");

		for(var accountPayment in accountPaymentSmartList.getRecords()) {


			for(var paymentTransaction in accountPayment.getPaymentTransactions()){
				amountUnassigned = getService('HibachiUtilityService').precisionCalculate(amountUnassigned + paymentTransaction.getAmountReceived());
				amountUnassigned = getService('HibachiUtilityService').precisionCalculate(amountUnassigned + paymentTransaction.getAmountCredited());
			}


		}
		return amountUnassigned;
	}

	public numeric function getAmountUnreceived(){
		var amountUnreceived = 0;
		for(var termAccountOrderPayment in getTermAccountOrderPayments()) {
			if(!termAccountOrderPayment.getNewFlag()){
				amountUnreceived = getService('HibachiUtilityService').precisionCalculate(amountUnreceived + termAccountOrderPayment.getAmountUnreceived());
			}
		}
		return amountUnreceived;
	}

	public numeric function getAmountCredited(){
		var amountCredited = 0;
		for(var termAccountOrderPayment in getTermAccountOrderPayments()) {
			if(!termAccountOrderPayment.getNewFlag()){
				amountCredited = getService('HibachiUtilityService').precisionCalculate(amountCredited + termAccountOrderPayment.getAmountCredited());
			}
		}
		return amountCredited;
	}

	public numeric function getTermAccountBalance() {
		var termAccountBalance = 0;
		// First look at all the unreceived open order payment

		// Now look for the unassigned payment amount
		termAccountBalance = getService('HibachiUtilityService').precisionCalculate(termAccountBalance - getAmountUnassigned() + getAmountUnreceived());

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

	public any function getAccountAddressOptions() {
		if(!structKeyExists(variables, 'accountAddressOptions')){
			variables.accountAddressOptions = [];	
			
			var accountAddressCollectionList = getService('AccountService').getAccountAddressCollectionList();
			accountAddressCollectionList.setDisplayProperties('accountAddressName,address.streetAddress,address.city,address.stateCode,address.locality,address.countryCode,address.postalCode,accountAddressID|value');

			accountAddressCollectionList.addFilter('account.accountID', getAccountID());
			var accountAddresses = accountAddressCollectionList.getRecords(); 
			for(var accountAddress in accountAddresses){

				var addressName = accountAddress['accountAddressName'] & ' - ' & accountAddress['address_streetAddress'] & ', ' & accountAddress['address_city'] & ', ';  
		
				if(len(trim(accountAddress['address_postalCode']))){
					addressName &= accountAddress['address_postalCode'] & ', ';
				}	
	
				if(len(trim(accountAddress['address_stateCode']))){
					addressName &= accountAddress['address_stateCode'] & ', ';
				}	

				var accountAddressOption = {
					"name":  addressName & accountAddress['address_countryCode'],
					"value": accountAddress['value']  
				};
				arrayAppend(variables.accountAddressOptions, accountAddressOption);
			} 
		}

		return variables.accountAddressOptions; 	
	} 

	public any function getAccountPaymentMethodOptions() {
		if(!structKeyExists(variables, 'accountPaymentMehodOptions')){
			variables.accountPaymentMethodOptions = [];	
			
			var accountPaymentMethodCollectionList = getService('AccountService').getAccountPaymentMethodCollectionList(); 
			accountPaymentMethodCollectionList.setDisplayProperties('accountPaymentMethodName, billingAccountAddress.accountAddressID, creditCardLastFour, creditCardType, accountPaymentMethodID|value');
			accountPaymentMethodCollectionList.addFilter('activeFlag', true);
			accountPaymentMethodCollectionList.addFilter('account.accountID', getAccountID());
			
			var paymentMethods = accountPaymentMethodCollectionList.getRecords();
			for(var paymentMethod in paymentMethods){
				var paymentMethodOption = {
					"name": paymentMethod['accountPaymentMethodName'] & ' - ' & paymentMethod['creditCardType'] & ' *' & paymentMethod['creditCardLastFour'],
					"value": paymentMethod['value'],
					"billingAccountAddress_accountAddressID": paymentMethod['billingAccountAddress_accountAddressID'] 
				};
				arrayAppend(variables.accountPaymentMethodOptions, paymentMethodOption); 
			} 
		}
		return variables.accountPaymentMethodOptions;
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

	public any function getAccountCreatedSiteOptions(){
		var collectionList = getService('SiteService').getCollectionList('Site');
		collectionList.setDisplayProperties('siteID|value,siteName|name');

		var options = [{value ="", name="None"}];

		arrayAppend(options, collectionList.getRecords(), true );

		return options;
	}
	
	public boolean function isPrimaryMethodExpired(){
		return variables.primaryPaymentMethod.getCalculatedExpirationDate() >= now();
	}
	
	public boolean function eighteenPlus(){
		if(isNull(this.getBirthDate())) return false;
    	var globalEighteenYearsAgo = DateConvert('local2Utc', DateAdd('yyyy', -18, now()));
    	var globalDOB = DateConvert('local2Utc', this.getBirthDate());
		return DateCompare(globalEighteenYearsAgo, globalDOB) > -1;
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
	
	// Account Phone Numbers (one-to-many)
	public void function addAccountGovernmentIdentification(required any governmentIdentification) {
		arguments.accountGovernmentIdentification.setAccount( this );
	}
	public void function removeAccountGovernmentIdentification(required any governmentIdentification) {
		arguments.accountGovernmentIdentification.removeAccount( this );
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

	// Orders (one-to-many)
	public void function addOrderTemplate(required any OrderTemplate) {
	   arguments.orderTemplate.setAccount(this);
	}
	public void function removeOrderTemplate(required any OrderTemplate) {
	   arguments.orderTemplate.removeAccount(this);
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

	// Fulfillment Batches (one-to-many)
	public void function addFulfillmentBatch(required any fulfillmentBatch) {
	   arguments.fulfillmentBatch.setAssignedAccount(this);
	}
	public void function removeFulfillmentBatch(required any fulfillmentBatch) {
	   arguments.fulfillmentBatch.removeAssignedAccount(this);
	}

	// Pick Wave (one-to-many)
	public void function addPickWave(required any pickWave) {
	   arguments.pickWave.setAssignedAccount(this);
	}
	public void function removePickWave(required any pickWave) {
	   arguments.pickWave.removeAssignedAccount(this);
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
	
	public numeric function getPermissionGroupsCount(){
		if(this.getNewFlag()){
			return 0;
		}
		if(!structKeyExists(variables, 'permissionGroupsCount')){
			var permissionGroupCollection = getService("accountService").getCollectionList('PermissionGroup');
			permissionGroupCollection.setDisplayProperties('permissionGroupID');
			permissionGroupCollection.addFilter('accounts.accountID', variables.accountID);
			
			//Caution: hacky way to prevent Collection from calling getPermissionGroupsCount();
			permissionGroupCollection.setPermissionAppliedFlag(true); 
			
			variables.permissionGroupsCount = permissionGroupCollection.getRecordsCount();
		}
		
		return variables.permissionGroupsCount;
	}
	
	public any function getPrimaryEmailAddress() {
		if(!isNull(variables.primaryEmailAddress)) {
			return variables.primaryEmailAddress;
		} 
		if (arrayLen(getAccountEmailAddresses())) {
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
		}
		
		if (this.getAccountPhoneNumbersCount()) {
			variables.primaryPhoneNumber = this.getAccountPhoneNumbersSmartlist().getFirstRecord();
			return variables.primaryPhoneNumber;
		}
		
		//check memory
		if(hasAccountPhoneNumber()){
			variables.primaryPhoneNumber = getAccountPhoneNumbers()[1];
			return variables.primaryPhoneNumber;
		}
		return getService("accountService").newAccountPhoneNumber();
		
	}

	public any function getPrimaryAddress() {
		//check for value
		if(!isNull(variables.primaryAddress)) {
			return variables.primaryAddress;
		}
		//check db value
		if (this.getAccountAddressesCount()) {
			variables.primaryAddress = this.getAccountAddressesSmartlist().getFirstRecord();
			return variables.primaryAddress;
		}
		//check for in memory
		if(hasAccountAddress()){
			variables.primaryAddress = getAccountAddresses()[1]; 	
			return variables.primaryAddress;
		}
		//return new one
		return getService("accountService").newAccountAddress();
		
	}

	public any function getPrimaryPaymentMethod() {
		if(!isNull(variables.primaryPaymentMethod)) {
			return variables.primaryPaymentMethod;
		}

		//check for in memory
		if(hasAccountPaymentMethod()){
			variables.primaryPaymentMethod = getAccountPaymentMethods()[1]; 	
			return variables.primaryPaymentMethod;
		}
		
		return getService("accountService").newAccountPaymentMethod();
		
	}

	public boolean function getSuperUserFlag() {
		if(isNull(variables.superUserFlag)) {
			variables.superUserFlag = false;
		}
		return variables.superUserFlag;
	}

	public string function getSimpleRepresentation() {
		return getService("accountService").getSimpleRepresentation(this);
	}

	public string function getSimpleRepresentationPropertyName(){
		return 'calculatedFullName';
	}
	
	public boolean function isRestrictedKeyword(){
		if(structKeyExists(variables, 'accountCode')){
			var retrictedKeywordsCollection = getService('accountService').getReservedKeywordCollectionList();
			retrictedKeywordsCollection.setDisplayProperties('reservedKeywordID');
			retrictedKeywordsCollection.addFilter('keyword', variables.accountCode);
			return retrictedKeywordsCollection.getRecordsCount() == 0;
		}
		return true;
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
	//CUSTOM FUNCTIONS BEGIN

public numeric function getSuccessfulFlexshipOrdersThisYearCount(){
		if(!structKeyExists(variables, 'successfulFlexshipOrdersThisYearCount')){
			var orderCollection = getService('OrderService').getOrderCollectionList(); 
			orderCollection.addFilter('account.accountID', getAccountID());
			orderCollection.addFilter('orderTemplate.orderTemplateID','NULL','is not');
			//not cancelled, using ID because it's a faster query than systemCode
			orderCollection.addFilter('orderStatusType.typeID','444df2b90f62f72711eb5b3c90848e7e','!=');
			orderCollection.addFilter('orderOpenDateTime','1/1/' & year(now()),'>='); 
			orderCollection.addFilter('orderOpenDateTime','12/31/' & year(now()),'<=');
			variables.successfulFlexshipOrdersThisYearCount = orderCollection.getRecordsCount();  
		} 
		return variables.successfulFlexshipOrdersThisYearCount; 
	}

	public any function getSaveablePaymentMethodsCollectionList() {
		if(!structKeyExists(variables, 'saveablePaymentMethodsCollectionList')) {
			variables.saveablePaymentMethodsCollectionList = getService('paymentService').getPaymentMethodCollectionList();
			variables.saveablePaymentMethodsCollectionList.addFilter('activeFlag', 1);
			variables.saveablePaymentMethodsCollectionList.addFilter('allowSaveFlag', 1);
			variables.saveablePaymentMethodsCollectionList.addFilter('paymentMethodType', 'creditCard,giftCard,external,termPayment', 'in');
			if(len(setting('accountEligiblePaymentMethods'))) {
				variables.saveablePaymentMethodsCollectionList.addFilter('paymentMethodID', setting('accountEligiblePaymentMethods'), 'in');
			}
		}
		return variables.saveablePaymentMethodsCollectionList;
	}
	
	public any function getAccountNumber(){
		if(!structKeyExists(variables,'accountNumber') && !isNull(this.getAccountStatusType()) && this.getAccountStatusType().getSystemCode() == 'astGoodStanding'){
			if(!isNull(this.getAccountID())){
				var maxAccountNumberQuery = new query();
				var maxAccountNumberSQL = 'insert into swaccountnumber (accountID,createdDateTime) VALUES (:accountID,:createdDateTime)';
				
				maxAccountNumberQuery.setSQL(maxAccountNumberSQL);
				maxAccountNumberQuery.addParam(name="accountID",value=this.getAccountID());
				maxAccountNumberQuery.addParam(name="createdDateTime",value=now(),cfsqltype="cf_sql_timestamp" );
				var insertedID = maxAccountNumberQuery.execute().getPrefix().generatedKey;
				
				setAccountNumber(insertedID);	
			}
		}
		if(!isNull(variables.accountNumber)){
			return variables.accountNumber;
		}
	}
	
	public string function getLanguagePreferenceLabel(){
		if(!StructKeyExists(variables, "languagePreferenceLabel")) {
			
			var attributeOption = this.getDAO('AttributeDAO').getAttributeOptionByAttributeOptionValueAndAttributeID(
								    attributeOptionValue = this.getLanguagePreference() ?: 'en', 
								    attributeID = this.getService('AttributeService').getAttributeByAttributeCode('languagePreference').getAttributeID()
								);
								
			variables.languagePreferenceLabel = attributeOption.getAttributeOptionLabel();
		}
		
		return variables.languagePreferenceLabel;
	}
	
	public boolean function getCanCreateFlexshipFlag() {
		
		// If the user is not logged in, or retail, return false.
		var priceGroups = this.getPriceGroups();
		if ( ! len( priceGroups ) ) {
			return false;
			
		} else if ( priceGroups[1].getPriceGroupCode() == 2 ) { 
			//Retail price-group
			return false;
		}
		
		if ( isNull( this.getAccountCreatedSite() ) ) {
			return false;
		}
		
		if( this.getAccountType() == 'marketPartner' ){
		
			var daysAfterEnrollment = this.getAccountCreatedSite().setting(
							'integrationmonatSiteDaysAfterMarketPartnerEnrollmentFlexshipCreate'
						);
						
			var enrollmentDate = this.getEnrollmentDate();
			
			if ( !isNull( enrollmentDate ) ) {
				// Add the days after enrollment a user can create flexship to the enrollment date.
				var dateAfterCanCreateFlexship = dateAdd( 'd', daysAfterEnrollment, enrollmentDate );
				
				// If today is a greater date than the date they can create a flexship.
				return ( dateCompare( dateAfterCanCreateFlexship, now() ) == -1 ); // -1, if date1 is earlier than date2
			}	
		}
		
		return true;
	}

	//custom validation methods
		
	public boolean function restrictRenewalDateToOneYearOut() {
		if(!isNull(this.getRenewalDate()) && len(trim(this.getRenewalDate())) ) {
			return getService('accountService').restrictRenewalDateToOneYearOut(this.getRenewalDate());
		}
		return true;
	}
	
	public struct function getListingSearchConfig() {
	    param name = "arguments.wildCardPosition" default = "exact";
	    return super.getListingSearchConfig(argumentCollection = arguments);
	}
	
	public boolean function onlyOnePriceGroup(){
		return arrayLen(this.getPriceGroups()) <= 1;
	}
	
	public boolean function getSubscribedToMailchimp(){
		if(!structKeyExists(variables, 'subscribedToMailchimp')){
			variables.subscribedToMailchimp = false;
			
			if(getHibachiScope().getLoggedInFlag() && getHibachiScope().hasService('MailchimpAPIService')){
				variables.subscribedToMailchimp = getService('MailchimpAPIService').getSubscribedFlagByEmailAddress( getHibachiScope().account().getPrimaryEmailAddress().getEmailAddress() ); 	
			}
		}
		
		return variables.subscribedToMailchimp;
	}
	
	public string function getProfileImageFullPath(numeric width = 250, numeric height = 250){
		return getService('imageService').getResizedImagePath('#getHibachiScope().getBaseImageURL()#/profileImage/#this.getProfileImage()#', arguments.width, arguments.height)
	}
	
	public string function getGenderFullWord(){
	    var genderFullWord = "";
	    var gender = LCase(this.getGender());
		switch (gender) {
			case "f": 
			         genderFullWord = getHibachiScope().getRbKey('define.female'); 
			         break;
			case "m": 
			         genderFullWord =  getHibachiScope().getRbKey('define.male'); 
			         break;
			case "p":
			case "prefernottoSay": 
			         genderFullWord = getHibachiScope().getRbKey('define.prefernottoSay'); 
			         break;
		}
		return genderFullWord;
	}
	
	public string function getSpouseFirstName(){
	    if(!IsNull(this.getSpouseName())){
	       return ListFirst(this.getSpouseName(),", ");
	    }
	}
	
	public string function getSpouseLastName(){
	    if(!IsNull(this.getSpouseName())){
	       return ListRest(this.getSpouseName(),", ");
	    }
	}
	public string function getGovernmentIdentificationLastFour(){
	    if(!IsNull(this.getAccountGovernmentIdentifications()) && ArrayLen(this.getAccountGovernmentIdentifications()) >0){
	        
	       return this.getAccountGovernmentIdentifications()[1].getGovernmentIdentificationLastFour();
	    }
	}
	
	public numeric function getVIPEnrollmentAmountPaid(){
		if(!structKeyExists(variables,'vipEnrollmentAmountPaid')){
			var enrollmentAmountPaid = 0;
			var vipSkuID = getService('SettingService').getSettingValue('integrationmonatGlobalVIPEnrollmentFeeSkuID');
			
			var enrollmentOrderItemCollection = getService('OrderService').getOrderItemCollectionList();
			enrollmentOrderItemCollection.setDisplayProperties('calculatedExtendedPriceAfterDiscount');
			enrollmentOrderItemCollection.addFilter('order.account.accountID',getAccountID());
			enrollmentOrderItemCollection.addFilter('sku.skuID',vipSkuID);
			enrollmentOrderItemCollection.addFilter('order.orderStatusType.systemCode','ostProcessing,ostClosed','IN');
			
			var enrollmentOrderItems = enrollmentOrderItemCollection.getRecords();
			if(arrayLen(enrollmentOrderItems)){
				var enrollmentOrderItem = enrollmentOrderItems[1];
				enrollmentAmountPaid += enrollmentOrderItem.calculatedExtendedPriceAfterDiscount;
			}
			variables.vipEnrollmentAmountPaid = enrollmentAmountPaid;
		}
		return variables.vipEnrollmentAmountPaid;
	}
	
	public boolean function canSponsor(){
		if(structKeyExists(variables, 'canSponsorFlag')){
			return variables.canSponsorFlag;
		}
		
		if(
			(getAccountType() == 'marketPartner' || getAccountType() == 'VIP')
			&&
			structKeyExists(variables,'accountNumber') 
			&&
			len(variables.accountNumber)
			&& 
			!isNull(this.getAccountStatusType()) 
			&& 
			this.getAccountStatusType().getSystemCode() == 'astGoodStanding'
		){
			variables.canSponsorFlag = true;
			return true;
		}
		
		
		return false;
	
	}//CUSTOM FUNCTIONS END
}