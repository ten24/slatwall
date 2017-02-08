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
component displayname="Account Payment" entityname="SlatwallAccountPayment" table="SwAccountPayment" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="accountService" hb_permission="account.accountPayment" hb_processContexts="offlineTransaction,process,createTransaction" {
	
	// Persistent Properties
	property name="accountPaymentID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="currencyCode" ormtype="string" length="3";
	property name="bankRoutingNumberEncrypted" ormType="string";
	property name="bankAccountNumberEncrypted" ormType="string";
	property name="checkNumberEncrypted" ormType="string";
	property name="companyPaymentMethodFlag" ormType="boolean";
	property name="creditCardNumberEncrypted" ormType="string";
	property name="creditCardLastFour" ormType="string";
	property name="creditCardType" ormType="string";
	property name="expirationMonth" ormType="string" hb_formfieldType="select";
	property name="expirationYear" ormType="string" hb_formfieldType="select";
	property name="giftCardNumberEncrypted" ormType="string";
	property name="nameOnCreditCard" ormType="string";
	property name="providerToken" ormType="string";
	
	// Related Object Properties (many-to-one)
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID" hb_optionsNullRBKey="define.select";
	property name="accountPaymentMethod" cfc="AccountPaymentMethod" fieldtype="many-to-one" fkcolumn="accountPaymentMethodID" hb_optionsNullRBKey="define.select";
	property name="accountPaymentType" cfc="Type" fieldtype="many-to-one" fkcolumn="accountPaymentTypeID" hb_optionsSmartListData="f:parentType.systemCode=accountPaymentType";
	property name="billingAddress" cfc="Address" fieldtype="many-to-one" fkcolumn="billingAddressID" cascade="all" hb_optionsNullRBKey="define.select";
	property name="paymentMethod" cfc="PaymentMethod" fieldtype="many-to-one" fkcolumn="paymentMethodID" hb_optionsNullRBKey="define.select";
	
	// Related Object Properties (one-to-many)
	property name="attributeValues" singularname="attributeValue" cfc="AttributeValue" type="array" fieldtype="one-to-many" fkcolumn="accountPaymentID" cascade="all-delete-orphan" inverse="true";
	property name="paymentTransactions" singularname="paymentTransaction" cfc="PaymentTransaction" type="array" fieldtype="one-to-many" fkcolumn="accountPaymentID" cascade="all" inverse="true";
	property name="appliedAccountPayments" singularname="appliedAccountPayment" cfc="AccountPaymentApplied" type="array" fieldtype="one-to-many" fkcolumn="accountPaymentID" cascade="all" inverse="true";
	
	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// Non-Persistent Properties
	property name="amount" persistent="false" type="numeric" hb_formatType="currency";
	property name="amountAuthorized" persistent="false" type="numeric" hb_formatType="currency";
	property name="amountCredited" persistent="false" type="numeric" hb_formatType="currency";
	property name="amountReceived" persistent="false" type="numeric" hb_formatType="currency";
	property name="amountUnassigned" persistent="false" type="numeric" hb_formatType="currency";
	property name="amountUnauthorized" persistent="false" hb_formatType="currency";	
	property name="amountUncredited" persistent="false" hb_formatType="currency";
	property name="amountUncaptured" persistent="false" hb_formatType="currency";
	property name="amountUnreceived" persistent="false" hb_formatType="currency";
	property name="bankRoutingNumber" persistent="false";
	property name="bankAccountNumber" persistent="false";
	property name="checkNumber" persistent="false";
	property name="creditCardNumber" persistent="false";
	property name="expirationDate" persistent="false";
	property name="experationMonthOptions" persistent="false";
	property name="expirationYearOptions" persistent="false";
	property name="giftCardNumber" persistent="false";
	property name="originalAuthorizationCode" persistent="false";
	property name="originalAuthorizationProviderTransactionID" persistent="false";
	property name="originalChargeProviderTransactionID" persistent="false";
	property name="originalProviderTransactionID" persistent="false";
	property name="paymentMethodOptions" persistent="false";
	property name="appliedAccountPaymentOptions" persistent="false";
	property name="paymentMethodType" persistent="false";
	property name="securityCode" persistent="false";
	property name="creditCardOrProviderTokenExistsFlag" persistent="false";
	
	public any function init() {
		if(isNull(variables.amount)) {
			variables.amount = 0;
		}
		
		return super.init();
	}
	
	public string function getPaymentMethodType() {
		if(!isNull(getPaymentMethod())) {
			return getPaymentMethod().getPaymentMethodType();	
		}
	}
	public array function getExpirationMonthOptions() {
		return [
			'01',
			'02',
			'03',
			'04',
			'05',
			'06',
			'07',
			'08',
			'09',
			'10',
			'11',
			'12'
		];
	}
	
	public array function getExpirationYearOptions() {
		var yearOptions = [];
		var currentYear = year(now());
		for(var i = 0; i < 20; i++) {
			var thisYear = currentYear + i;
			arrayAppend(yearOptions,{name=thisYear, value=right(thisYear,2)});
		}
		return yearOptions;
	}
	
	public any function getPaymentMethodOptions() {
		if(!structKeyExists(variables, "paymentMethodOptions")) {
			var sl = getService("paymentService").getPaymentMethodSmartList();
			
			var eligiblePaymentMethodIDs = this.setting('accountEligiblePaymentMethods');
			if (!isNull(this.getAccount())) {
				eligiblePaymentMethodIDs = this.getAccount().setting('accountEligiblePaymentMethods');
			}
			
			// Prevent 'termPayment' from displaying as account payment method option
			sl.addInFilter('paymentMethodType', 'cash,check,creditCard,external,giftCard');
			sl.addInFilter('paymentMethodID', eligiblePaymentMethodIDs);
			sl.addFilter('activeFlag', 1);
			sl.addSelect('paymentMethodID', 'value');
			sl.addSelect('paymentMethodName', 'name');
			sl.addSelect('paymentMethodType', 'paymentmethodtype');
			sl.addSelect('allowSaveFlag', 'allowsave');
			
			variables.paymentMethodOptions = sl.getRecords();
		}
		return variables.paymentMethodOptions;
	}
	
	public void function copyFromAccountPaymentMethod(required any accountPaymentMethod) {
		
		// Connect this to the original account payment method
		setAccountPaymentMethod( arguments.accountPaymentMethod );
		
		// Make sure the payment method matches
		setPaymentMethod( arguments.accountPaymentMethod.getPaymentMethod() );
		
		// Company PaymentMethod Flag
		if(!isNull(arguments.accountPaymentMethod.getCompanyPaymentMethodFlag())) {
			setCompanyPaymentMethodFlag( arguments.accountPaymentMethod.getCompanyPaymentMethodFlag() );
		}
		
		// Credit Card
		if(listFindNoCase("creditCard", arguments.accountPaymentMethod.getPaymentMethod().getPaymentMethodType())) {
			if(!isNull(arguments.accountPaymentMethod.getCreditCardNumber())) {
				setCreditCardNumber( arguments.accountPaymentMethod.getCreditCardNumber() );	
			}
			setNameOnCreditCard( arguments.accountPaymentMethod.getNameOnCreditCard() );
			setExpirationMonth( arguments.accountPaymentMethod.getExpirationMonth() );
			setExpirationYear( arguments.accountPaymentMethod.getExpirationYear() );
			setCreditCardLastFour( arguments.accountPaymentMethod.getCreditCardLastFour() );
			setCreditCardType( arguments.accountPaymentMethod.getCreditCardType() );
		}
		
		// Gift Card
		if(listFindNoCase("giftCard", arguments.accountPaymentMethod.getPaymentMethod().getPaymentMethodType())) {
			setGiftCardNumber( arguments.accountPaymentMethod.getGiftCardNumber() );
		}
		
		// Credit Card & Gift Card
		if(listFindNoCase("creditCard,giftCard", arguments.accountPaymentMethod.getPaymentMethod().getPaymentMethodType())) {
			setProviderToken( arguments.accountPaymentMethod.getProviderToken() );
		}
		
		// Credit Card & Term Payment
		if(listFindNoCase("creditCard,termPayment", arguments.accountPaymentMethod.getPaymentMethod().getPaymentMethodType())) {
			setBillingAddress( arguments.accountPaymentMethod.getBillingAddress().copyAddress( true ) );
		}
		
	}	
	
	// ============ START: Non-Persistent Property Methods =================
	
	public numeric function getAmount() {
		var totalAmt = 0;
		
		for(var i=1; i<=arrayLen(getAppliedAccountPayments()); i++) {
			totalAmt = getService('HibachiUtilityService').precisionCalculate(totalAmt + getAppliedAccountPayments()[i].getAmount());
		}
		
		return totalAmt;
	}
	
	public numeric function getAmountReceived() {
		var amountReceived = 0;
		
		// We only show 'received' for charged payments
		if( getAccountPaymentType().getSystemCode() == "aptCharge" ) {
			
			for(var i=1; i<=arrayLen(getPaymentTransactions()); i++) {
				amountReceived = getService('HibachiUtilityService').precisionCalculate(amountReceived + getPaymentTransactions()[i].getAmountReceived());
			}
			
		}
				
		return amountReceived;
	}
	
	public numeric function getAmountCredited() {
		var amountCredited = 0;
		
		// We only show 'credited' for credited payments
		if( getAccountPaymentType().getSystemCode() == "aptCredit" ) {
			
			for(var i=1; i<=arrayLen(getPaymentTransactions()); i++) {
				amountCredited = getService('HibachiUtilityService').precisionCalculate(amountCredited + getPaymentTransactions()[i].getAmountCredited());
			}
			
		}
			
		return amountCredited;
	}
	

	public numeric function getAmountAuthorized() {
		var amountAuthorized = 0;
			
		if( getAccountPaymentType().getSystemCode() == "aptCharge" ) {
			for(var i=1; i<=arrayLen(getPaymentTransactions()); i++) {
				if(isNull(getPaymentTransactions()[i].getAuthorizationCodeInvalidFlag()) || !getPaymentTransactions()[i].getAuthorizationCodeInvalidFlag()) {
					amountAuthorized = getService('HibachiUtilityService').precisionCalculate(amountAuthorized + getPaymentTransactions()[i].getAmountAuthorized());
				}
			}
		}
		
		return amountAuthorized;
	}
	
	public numeric function getAmountUnauthorized() {
		var unauthroized = 0;
		
		if ( getOrderPaymentType().getSystemCode() == "optCharge" ) {
			unauthroized = getService('HibachiUtilityService').precisionCalculate(getAmount() - getAmountReceived() - getAmountAuthorized());
		}
		
		return unauthroized;
	}
	
	public numeric function getAmountUncaptured() {
		var uncaptured = 0;
		
		if ( getOrderPaymentType().getSystemCode() == "optCharge" ) {
			uncaptured = getService('HibachiUtilityService').precisionCalculate(getAmountAuthorized() - getAmountReceived());
		}
		
		return uncaptured;
	}
	
	public numeric function getAmountUnreceived() {
		var unreceived = 0;
		
		if ( getOrderPaymentType().getSystemCode() == "optCharge" ) {
			unreceived = getService('HibachiUtilityService').precisionCalculate(getAmount() - getAmountReceived());
		}
		
		return unreceived;
	}
	
	public numeric function getAmountUncredited() {
		var uncredited = 0;
		
		if ( getOrderPaymentType().getSystemCode() == "optCredit" ) {
			uncredited = getService('HibachiUtilityService').precisionCalculate(getAmount() - getAmountCredited());
		}
		
		return uncredited;
	}
	
	public numeric function getAmountUnassigned() {
		var amountUnassigned = 0;
		
		for(var accountPaymentApplied in getAppliedAccountPayments()) {
			if(isNull(accountPaymentApplied.getOrderPayment())) {
				if(accountPaymentApplied.getAccountPaymentType().getSystemCode() == "aptCharge") {
					if(getAmountReceived()>0){
						amountUnassigned = getService('HibachiUtilityService').precisionCalculate(amountUnassigned + accountPaymentApplied.getAmount());
					}
							
				} else {
					if(getAMountCredited() > 0){
						amountUnassigned = getService('HibachiUtilityService').precisionCalculate(amountUnassigned - accountPaymentApplied.getAmount());	
					}
				}
			}
		}
		
		return amountUnassigned;
	}
	
	public boolean function getCreditCardOrProviderTokenExistsFlag() {
		if((isNull(getCreditCardNumber()) || !len(getCreditCardNumber())) && (isNull(getProviderToken()) || !len(getProviderToken()))) {
			return false;
		}
		return true;
	}
	
	public any function getOriginalAuthorizationCode() {
		if(!structKeyExists(variables,"originalAuthorizationCode")) {
			variables.originalAuthorizationCode = getService( "paymentService" ).getOriginalAuthorizationCode( accountPaymentID=getAccountPaymentID() );
		}
		return variables.originalAuthorizationCode;
	}
	
	
	public any function getOriginalAuthorizationProviderTransactionID() {
		if(!structKeyExists(variables,"originalAuthorizationProviderTransactionID")) {
			variables.originalAuthorizationProviderTransactionID = getService( "paymentService" ).getOriginalAuthorizationProviderTransactionID( accountPaymentID=getAccountPaymentID() );
		}
		return variables.originalAuthorizationProviderTransactionID;
	}
	
	public any function getOriginalChargeProviderTransactionID() {
		if(!structKeyExists(variables,"originalChargeProviderTransactionID")) {
			variables.originalChargeProviderTransactionID = getService( "paymentService" ).getOriginalChargeProviderTransactionID( accountPaymentID=getAccountPaymentID() );
		}
		return variables.originalChargeProviderTransactionID;
	}
	
	public any function getOriginalProviderTransactionID() {
		if(!structKeyExists(variables,"originalProviderTransactionID")) {
			variables.originalProviderTransactionID = getService( "paymentService" ).getOriginalProviderTransactionID( accountPaymentID=getAccountPaymentID() );
		}
		return variables.originalProviderTransactionID;
	}
	
	public array function getAccountPaymentAppliedOptions( ) {
		if(!structKeyExists(variables, "appliedAccountPaymentOptions")) {
			var smartList = getService('typeService').getTypeSmartList();
			smartList.addInFilter('systemCode','aptCredit,aptCharge');
			smartList.addSelect('typeName','name');
			smartList.addSelect('typeID','value');
			variables.appliedAccountPaymentOptions = smartList.getRecords();
		}
		return variables.appliedAccountPaymentOptions;
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Payment Transactions (one-to-many)
	public void function addPaymentTransaction(required any paymentTransaction) {
		arguments.paymentTransaction.setAccountPayment( this );
	}
	public void function removePaymentTransaction(required any paymentTransaction) {
		arguments.paymentTransaction.removeAccountPayment( this );
	}
	
	// Attribute Values (one-to-many)    
	public void function addAttributeValue(required any attributeValue) {    
		arguments.attributeValue.setAccountPayment( this );    
	}    
	public void function removeAttributeValue(required any attributeValue) {    
		arguments.attributeValue.removeAccountPayment( this );    
	}
	
	// Applied Account Payments (one-to-many)    
	public void function addAppliedAccountPayment(required any appliedAccountPayment) {    
		arguments.appliedAccountPayment.setAccountPayment( this );    
	}    
	public void function removeAppliedAccountPayment(required any appliedAccountPayment) {    
		arguments.appliedAccountPayment.removeAccountPayment( this );    
	}
	
	// Account (many-to-one)
	public void function setAccount(required any account) {
		variables.account = arguments.account;
		if(isNew() or !arguments.account.hasAccountPayment( this )) {
			arrayAppend(arguments.account.getAccountPayments(), this);
		}
	}
	public void function removeAccount(any account) {
		if(!structKeyExists(arguments, "account")) {
			arguments.account = variables.account;
		}
		var index = arrayFind(arguments.account.getAccountPayments(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.account.getAccountPayments(), index);
		}
		structDelete(variables, "account");
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================
	
	// ============== START: Overridden Implicet Getters ===================
	
	public any function getBillingAddress() {
		if( !structKeyExists(variables, "billingAddress") ) {
			return getService("addressService").newAddress();
		}
		return variables.billingAddress;
	}
	
	public any function getCurrencyCode() {
		if( !structKeyExists(variables, "currencyCode") ) {
			variables.currencyCode = "USD";
		}
		return variables.currencyCode;
	}
	
	// ==============  END: Overridden Implicet Getters ====================
	
	// ================== START: Overridden Methods ========================
	
	public void function setCreditCardNumber(required string creditCardNumber) {
		if(len(arguments.creditCardNumber)) {
			variables.creditCardNumber = REReplaceNoCase(arguments.creditCardNumber, '[^0-9]', '', 'ALL');
			setCreditCardLastFour( right(arguments.creditCardNumber, 4) );
			setCreditCardType( getService("paymentService").getCreditCardTypeFromNumber(arguments.creditCardNumber) );
		} else {
			structDelete(variables, "creditCardNumber");
			setCreditCardLastFour(javaCast("null", ""));
			setCreditCardType(javaCast("null", ""));
			setCreditCardNumberEncrypted(javaCast("null", ""));
		}
	}
	
	public any function getSimpleRepresentation() {
		if(isNew()) {
			return rbKey('define.new') & ' ' & rbKey('entity.accountPayment');
		}
		
		if(getPaymentMethodType() == "creditCard") {
			return getPaymentMethod().getPaymentMethodName() & " - " & getCreditCardType() & " ***" & getCreditCardLastFour() & ' - ' & getFormattedValue('amount');	
		}
		
		return getPaymentMethod().getPaymentMethodName() & ' - ' & getFormattedValue('amount');
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================
}
