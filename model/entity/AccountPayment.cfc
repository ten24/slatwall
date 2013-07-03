/*

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

*/
component displayname="Account Payment" entityname="SlatwallAccountPayment" table="SlatwallAccountPayment" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="accountService" hb_permission="account.accountPayment" hb_processContexts="offlineTransaction,process" {
	
	// Persistent Properties
	property name="accountPaymentID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="amount" ormtype="big_decimal" notnull="true";
	property name="currencyCode" ormtype="string" length="3";
	property name="bankRoutingNumberEncrypted" ormType="string";
	property name="bankAccountNumberEncrypted" ormType="string";
	property name="checkNumberEncrypted" ormType="string";
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
	
	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties
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
	
	public numeric function getAmountReceived() {
		var amountReceived = 0;
		
		// We only show 'received' for charged payments
		if( getAccountPaymentType().getSystemCode() == "aptCharge" ) {
			
			for(var i=1; i<=arrayLen(getPaymentTransactions()); i++) {
				amountReceived = precisionEvaluate(amountReceived + getPaymentTransactions()[i].getAmountReceived());
			}
			
		}
				
		return amountReceived;
	}
	
	public numeric function getAmountCredited() {
		var amountCredited = 0;
		
		// We only show 'credited' for credited payments
		if( getAccountPaymentType().getSystemCode() == "aptCredit" ) {
			
			for(var i=1; i<=arrayLen(getPaymentTransactions()); i++) {
				amountCredited = precisionEvaluate(amountCredited + getPaymentTransactions()[i].getAmountCredited());
			}
			
		}
			
		return amountCredited;
	}
	

	public numeric function getAmountAuthorized() {
		var amountAuthorized = 0;
			
		if( getAccountPaymentType().getSystemCode() == "aptCharge" ) {
			
			for(var i=1; i<=arrayLen(getPaymentTransactions()); i++) {
				amountAuthorized = precisionEvaluate(amountAuthorized + getPaymentTransactions()[i].getAmountAuthorized());
			}
			
		}
		
		return amountAuthorized;
	}
	
	public numeric function getAmountUnauthorized() {
		var unauthroized = 0;
		
		if ( getOrderPaymentType().getSystemCode() == "optCharge" ) {
			unauthroized = precisionEvaluate(getAmount() - getAmountReceived() - getAmountAuthorized());
		}
		
		return unauthroized;
	}
	
	public numeric function getAmountUncaptured() {
		var uncaptured = 0;
		
		if ( getOrderPaymentType().getSystemCode() == "optCharge" ) {
			uncaptured = precisionEvaluate(getAmountAuthorized() - getAmountReceived());
		}
		
		return uncaptured;
	}
	
	public numeric function getAmountUnreceived() {
		var unreceived = 0;
		
		if ( getOrderPaymentType().getSystemCode() == "optCharge" ) {
			unreceived = precisionEvaluate(getAmount() - getAmountReceived());
		}
		
		return unreceived;
	}
	
	public numeric function getAmountUncredited() {
		var uncredited = 0;
		
		if ( getOrderPaymentType().getSystemCode() == "optCredit" ) {
			uncredited = precisionEvaluate(getAmount() - getAmountCredited());
		}
		
		return uncredited;
	}
	
	public numeric function getAmountUnassigned() {
		// This is temporary until we get the assignment of accountPayments to orderPayments
		return getAmountReceived();
	}
	
	public boolean function getCreditCardOrProviderTokenExistsFlag() {
		if(isNull(getCreditCardNumber()) && isNull(getProviderToken())) {
			return false;
		}
		return true;
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
	
	// ==============  END: Overridden Implicet Getters ====================
	
	// ================== START: Overridden Methods ========================
	
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