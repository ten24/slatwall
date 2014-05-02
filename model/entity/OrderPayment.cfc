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
component entityname="SlatwallOrderPayment" table="SwOrderPayment" persistent="true" output="false" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="orderService" hb_permission="order.orderPayments" hb_processContexts="processTransaction" {
	
	// Persistent Properties
	property name="orderPaymentID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="amount" hb_populateEnabled="public" ormtype="big_decimal";
	property name="currencyCode" ormtype="string" length="3";
	property name="bankRoutingNumberEncrypted" ormType="string";
	property name="bankAccountNumberEncrypted" ormType="string";
	property name="checkNumberEncrypted" ormType="string";
	property name="creditCardNumberEncrypted" ormType="string";
	property name="creditCardLastFour" ormType="string";
	property name="creditCardType" ormType="string";
	property name="expirationMonth" hb_populateEnabled="public" ormType="string" hb_formfieldType="select";
	property name="expirationYear" hb_populateEnabled="public" ormType="string" hb_formfieldType="select";
	property name="giftCardNumberEncrypted" ormType="string";
	property name="nameOnCreditCard" hb_populateEnabled="public" ormType="string";
	property name="providerToken" ormType="string";
	property name="paymentDueDate" hb_populateEnabled="public" ormtype="timestamp";
	
	// Related Object Properties (many-to-one)
	property name="accountPaymentMethod" hb_populateEnabled="public" cfc="AccountPaymentMethod" fieldtype="many-to-one" fkcolumn="accountPaymentMethodID";
	property name="billingAddress" hb_populateEnabled="public" cfc="Address" fieldtype="many-to-one" fkcolumn="billingAddressID" cascade="all";
	property name="order" cfc="Order" fieldtype="many-to-one" fkcolumn="orderID";
	property name="orderPaymentType" cfc="Type" fieldtype="many-to-one" fkcolumn="orderPaymentTypeID" hb_optionsSmartListData="f:parentType.systemCode=orderPaymentType" fetch="join";
	property name="orderPaymentStatusType" hb_populateEnabled="false" cfc="Type" fieldtype="many-to-one" fkcolumn="orderPaymentStatusTypeID" hb_optionsSmartListData="f:parentType.systemCode=orderPaymentStatusType" fetch="join";
	property name="paymentMethod" hb_populateEnabled="public" cfc="PaymentMethod" fieldtype="many-to-one" fkcolumn="paymentMethodID" fetch="join";
	property name="paymentTerm" cfc="PaymentTerm" fieldtype="many-to-one" fkcolumn="paymentTermID" fetch="join";
	property name="referencedOrderPayment" cfc="OrderPayment" fieldtype="many-to-one" fkcolumn="referencedOrderPaymentID";
	property name="termPaymentAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="termPaymentAccountID";
	
	// Related Object Properties (one-to-many)			
	property name="attributeValues" singularname="attributeValue" cfc="AttributeValue" type="array" fieldtype="one-to-many" fkcolumn="orderPaymentID" cascade="all-delete-orphan" inverse="true";
	property name="paymentTransactions" singularname="paymentTransaction" cfc="PaymentTransaction" type="array" fieldtype="one-to-many" fkcolumn="orderPaymentID" cascade="all" inverse="true" orderby="createdDateTime DESC" ;
	property name="referencingOrderPayments" singularname="referencingOrderPayment" cfc="OrderPayment" fieldType="one-to-many" fkcolumn="referencedOrderPaymentID" cascade="all" inverse="true";
	property name="appliedAccountPayments" singularname="appliedAccountPayment" cfc="AccountPaymentApplied" type="array" fieldtype="one-to-many" fkcolumn="orderPaymentID" cascade="all" inverse="true";
	
	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)
	
	// Remote properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties
	property name="amountAuthorized" type="numeric" hb_formatType="currency" persistent="false";
	property name="amountCredited" type="numeric" hb_formatType="currency" persistent="false";
	property name="amountReceived" type="numeric" hb_formatType="currency" persistent="false";
	property name="amountUnauthorized" persistent="false" hb_formatType="currency";	
	property name="amountUncredited" persistent="false" hb_formatType="currency";
	property name="amountUncaptured" persistent="false" hb_formatType="currency";
	property name="amountUnreceived" persistent="false" hb_formatType="currency";
	property name="bankRoutingNumber" persistent="false" hb_populateEnabled="public";
	property name="bankAccountNumber" persistent="false" hb_populateEnabled="public";
	property name="checkNumber" persistent="false" hb_populateEnabled="public";
	property name="creditCardNumber" persistent="false" hb_populateEnabled="public";
	property name="expirationDate" persistent="false";
	property name="experationMonthOptions" persistent="false";
	property name="expirationYearOptions" persistent="false";
	property name="giftCardNumber" persistent="false" hb_populateEnabled="public";
	property name="paymentMethodType" persistent="false";
	property name="paymentMethodOptions" persistent="false";
	property name="orderStatusCode" persistent="false";
	property name="originalAuthorizationCode" persistent="false";
	property name="originalAuthorizationProviderTransactionID" persistent="false";
	property name="originalChargeProviderTransactionID" persistent="false";
	property name="originalProviderTransactionID" persistent="false";
	property name="statusCode" persistent="false";
	property name="securityCode" persistent="false" hb_populateEnabled="public";
	property name="sucessfulPaymentTransactionExistsFlag" persistent="false";
	property name="orderAmountNeeded" persistent="false";
	property name="creditCardOrProviderTokenExistsFlag" persistent="false";
	property name="dynamicAmountFlag" persistent="false" hb_formatType="yesno";
	
	public string function getMostRecentChargeProviderTransactionID() {
		for(var i=1; i<=arrayLen(getPaymentTransactions()); i++) {
			if(!isNull(getPaymentTransactions()[i].getAmountReceived()) && getPaymentTransactions()[i].getAmountReceived() > 0 && !isNull(getPaymentTransactions()[i].getProviderTransactionID()) && len(getPaymentTransactions()[i].getProviderTransactionID())) {
				return getPaymentTransactions()[i].getProviderTransactionID();
			}
		}
		// Check referenced payment, and might have a charge.  This works recursivly
		if(!isNull(getReferencedOrderPayment())) {
			return getReferencedOrderPayment().getMostRecentChargeProviderTransactionID();
		}
		return "";
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
		
		// Term Payment
		if(listFindNoCase("termPayment", arguments.accountPaymentMethod.getPaymentMethod().getPaymentMethodType())) {
			setTermPaymentAccount( arguments.accountPaymentMethod.getAccount() );
			setPaymentTerm( arguments.accountPaymentMethod.getPaymentTerm() );
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
	
	public void function copyFromOrderPayment(required any orderPayment) {
		
		// Make sure the payment method matches
		setPaymentMethod( arguments.orderPayment.getPaymentMethod() );
		
		// Check for a relational Account Payment Method
		if(!isNull(arguments.orderPayment.getAccountPaymentMethod())) {
			setAccountPaymentMethod(arguments.orderPayment.getAccountPaymentMethod());
		}
		
		// Credit Card
		if(listFindNoCase("creditCard", arguments.orderPayment.getPaymentMethod().getPaymentMethodType())) {
			if(!isNull(arguments.orderPayment.getCreditCardNumber())) {
				setCreditCardNumber( arguments.orderPayment.getCreditCardNumber() );
			}
			setNameOnCreditCard( arguments.orderPayment.getNameOnCreditCard() );
			setExpirationMonth( arguments.orderPayment.getExpirationMonth() );
			setExpirationYear( arguments.orderPayment.getExpirationYear() );
			setCreditCardLastFour( arguments.orderPayment.getCreditCardLastFour() );
			setCreditCardType( arguments.orderPayment.getCreditCardType() );
		}
		
		// Gift Card
		if(listFindNoCase("giftCard", arguments.orderPayment.getPaymentMethod().getPaymentMethodType())) {
			setGiftCardNumber( arguments.orderPayment.getGiftCardNumber() );
		}
		
		// Term Payment
		if(listFindNoCase("termPayment", arguments.orderPayment.getPaymentMethod().getPaymentMethodType())) {
			setPaymentTerm( arguments.orderPayment.getPaymentTerm() );
		}
		
		// Credit Card & Gift Card
		if(listFindNoCase("creditCard,giftCard", arguments.orderPayment.getPaymentMethod().getPaymentMethodType())) {
			setProviderToken( arguments.orderPayment.getProviderToken() );
		}
		
		// Credit Card & Term Payment
		if(listFindNoCase("creditCard,termPayment", arguments.orderPayment.getPaymentMethod().getPaymentMethodType())) {
			setBillingAddress( arguments.orderPayment.getBillingAddress().copyAddress( true ) );
		}
		
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	public boolean function getDynamicAmountFlag() {
		if(isNull(variables.amount)) {
			return true;
		}
		return false;
	}
	
	public numeric function getAmountReceived() {
		var amountReceived = 0;
		
		for(var i=1; i<=arrayLen(getPaymentTransactions()); i++) {
			if(!isNull(getPaymentTransactions()[i].getAmountReceived())) {
				amountReceived = precisionEvaluate(amountReceived + getPaymentTransactions()[i].getAmountReceived());	
			}
		}
				
		return amountReceived;
	}
	
	public numeric function getAmountCredited() {
		var amountCredited = 0;
		
		for(var i=1; i<=arrayLen(getPaymentTransactions()); i++) {
			if(!isNull(getPaymentTransactions()[i].getAmountCredited())) {
				amountCredited = precisionEvaluate(amountCredited + getPaymentTransactions()[i].getAmountCredited());	
			}
		}
			
		return amountCredited;
	}
	

	public numeric function getAmountAuthorized() {
		var amountAuthorized = 0;
			
		for(var i=1; i<=arrayLen(getPaymentTransactions()); i++) {
			if(isNull(getPaymentTransactions()[i].getAuthorizationCodeInvalidFlag()) || !getPaymentTransactions()[i].getAuthorizationCodeInvalidFlag()) {
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
			uncredited = precisionEvaluate(getAmount() + getAmountCredited());
		}
		
		return uncredited;
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
	
	public string function getPaymentMethodType() {
		if(!isNull(getPaymentMethod())) {
			return getPaymentMethod().getPaymentMethodType();
		}
		return javaCast("null", "");
	}
	
	public any function getOrderStatusCode() {
		return getOrder().getStatusCode();
	}
	
	public any function getOriginalAuthorizationCode() {
		if(!structKeyExists(variables,"originalAuthorizationCode") || !len(variables.originalAuthorizationCode)) {
			if(!isNull(getReferencedOrderPayment())) {
				variables.originalAuthorizationCode = getService( "paymentService" ).getOriginalAuthorizationCode( orderPaymentID=getOrderPaymentID(), referencedOrderPaymentID=getReferencedOrderPayment().getOrderPaymentID() );
			} else {
				variables.originalAuthorizationCode = getService( "paymentService" ).getOriginalAuthorizationCode( orderPaymentID=getOrderPaymentID() );
			}
		}
		return variables.originalAuthorizationCode;
	}
	
	public any function getOriginalAuthorizationProviderTransactionID() {
		if(!structKeyExists(variables,"originalAuthorizationProviderTransactionID") || !len(variables.originalAuthorizationProviderTransactionID)) {
			if(!isNull(getReferencedOrderPayment())) {
				variables.originalAuthorizationProviderTransactionID = getService( "paymentService" ).getOriginalAuthorizationProviderTransactionID( orderPaymentID=getOrderPaymentID(), referencedOrderPaymentID=getReferencedOrderPayment().getOrderPaymentID() );
			} else {
				variables.originalAuthorizationProviderTransactionID = getService( "paymentService" ).getOriginalAuthorizationProviderTransactionID( orderPaymentID=getOrderPaymentID() );
			}
		}
		return variables.originalAuthorizationProviderTransactionID;
	}
	
	public any function getOriginalChargeProviderTransactionID() {
		if(!structKeyExists(variables,"originalChargeProviderTransactionID") || !len(variables.originalChargeProviderTransactionID)) {
			if(!isNull(getReferencedOrderPayment())) {
				variables.originalChargeProviderTransactionID = getService( "paymentService" ).getOriginalChargeProviderTransactionID( orderPaymentID=getOrderPaymentID(), referencedOrderPaymentID=getReferencedOrderPayment().getOrderPaymentID() );
			} else {
				variables.originalChargeProviderTransactionID = getService( "paymentService" ).getOriginalChargeProviderTransactionID( orderPaymentID=getOrderPaymentID() );
			}
		}
		return variables.originalChargeProviderTransactionID;
	}
	
	public any function getOriginalProviderTransactionID() {
		if(!structKeyExists(variables,"originalProviderTransactionID") || !len(variables.originalProviderTransactionID)) {
			if(!isNull(getReferencedOrderPayment())) {
				variables.originalProviderTransactionID = getService( "paymentService" ).getOriginalProviderTransactionID( orderPaymentID=getOrderPaymentID(), referencedOrderPaymentID=getReferencedOrderPayment().getOrderPaymentID() );	
			} else {
				variables.originalProviderTransactionID = getService( "paymentService" ).getOriginalProviderTransactionID( orderPaymentID=getOrderPaymentID() );	
			}
		}
		return variables.originalProviderTransactionID;
	}
	
	public any function getStatusCode() {
		return getOrderPaymentStatusType().getSystemCode();
	}
	
	public boolean function getSucessfulPaymentTransactionExistsFlag() {
		for(var paymentTransaction in getPaymentTransactions()) {
			if(!isNull(paymentTransaction.getTransactionSuccessFlag()) && paymentTransaction.getTransactionSuccessFlag()) {
				return true;
			}
		}
		return false;
	}
	
	public string function getExpirationDate() {
		if(!structKeyExists(variables,"expirationDate")) {
			variables.expirationDate = nullReplace(getExpirationMonth(),"") & "/" & nullReplace(getExpirationYear(), "");
		}
		return variables.expirationDate;
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
	
	// Important this can be a negative number
	public any function getOrderAmountNeeded() {
		
		if(!structKeyExists(variables, "orderAmountNeeded")) {
			
			var total = getOrder().getTotal();
			var paymentTotal = getService("orderService").getOrderPaymentNonNullAmountTotal(orderID=getOrder().getOrderID());
			
			variables.orderAmountNeeded = precisionEvaluate(total - paymentTotal);
		}
		
		return variables.orderAmountNeeded;
	}
	
	public string function getCreditCardNumber() {
		if(!structKeyExists(variables,"creditCardNumber")) {
			if(nullReplace(getCreditCardNumberEncrypted(), "") NEQ "") {
				return decryptValue(getCreditCardNumberEncrypted());
			}
			return ;
		}
		return variables.creditCardNumber;
	}
	
	public boolean function getCreditCardOrProviderTokenExistsFlag() {
		if((isNull(getCreditCardNumber()) || !len(getCreditCardNumber())) && (isNull(getProviderToken()) || !len(getProviderToken()))) {
			return false;
		}
		return true;
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Order (many-to-one)
	public void function setOrder(required any order) {
		variables.order = arguments.order;
		if(isNew() or !arguments.order.hasOrderPayment( this )) {
			arrayAppend(arguments.order.getOrderPayments(), this);
		}
	}
	public void function removeOrder(any order) {
		if(!structKeyExists(arguments, "order")) {
			arguments.order = variables.order;
		}
		var index = arrayFind(arguments.order.getOrderPayments(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.order.getOrderPayments(), index);
		}
		structDelete(variables, "order");
	}
	
	// Referenced Order Payment (many-to-one)    
	public void function setReferencedOrderPayment(required any referencedOrderPayment) {    
		variables.referencedOrderPayment = arguments.referencedOrderPayment;    
		if(isNew() or !arguments.referencedOrderPayment.hasReferencingOrderPayment( this )) {    
			arrayAppend(arguments.referencedOrderPayment.getReferencingOrderPayments(), this);    
		}    
	}    
	public void function removeReferencedOrderPayment(any referencedOrderPayment) {    
		if(!structKeyExists(arguments, "referencedOrderPayment")) {    
			arguments.referencedOrderPayment = variables.referencedOrderPayment;    
		}    
		var index = arrayFind(arguments.referencedOrderPayment.getReferencingOrderPayments(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.referencedOrderPayment.getReferencingOrderPayments(), index);    
		}    
		structDelete(variables, "referencedOrderPayment");    
	}
	
	// Term Payment Account (many-to-one)    
	public void function setTermPaymentAccount(required any termPaymentAccount) {    
		variables.termPaymentAccount = arguments.termPaymentAccount;    
		if(isNew() or !arguments.termPaymentAccount.hasTermAccountOrderPayment( this )) {    
			arrayAppend(arguments.termPaymentAccount.getTermAccountOrderPayments(), this);    
		}    
	}    
	public void function removeTermPaymentAccount(any termPaymentAccount) {    
		if(!structKeyExists(arguments, "termPaymentAccount")) {    
			arguments.termPaymentAccount = variables.termPaymentAccount;    
		}    
		var index = arrayFind(arguments.termPaymentAccount.getTermAccountOrderPayments(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.termPaymentAccount.getTermAccountOrderPayments(), index);    
		}    
		structDelete(variables, "termPaymentAccount");    
	}
	
	// Payment Term (many-to-one)    
	public void function setPaymentTerm(required any paymentTerm) {    
		variables.paymentTerm = arguments.paymentTerm;    
		if(isNew() or !arguments.paymentTerm.hasOrderPayment( this )) {    
			arrayAppend(arguments.paymentTerm.getOrderPayments(), this);    
		}    
	}    
	public void function removePaymentTerm(any paymentTerm) {    
		if(!structKeyExists(arguments, "paymentTerm")) {    
			arguments.paymentTerm = variables.paymentTerm;    
		}    
		var index = arrayFind(arguments.paymentTerm.getOrderPayments(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.paymentTerm.getOrderPayments(), index);    
		}    
		structDelete(variables, "paymentTerm");    
	}
	
	// AttributeValues (one-to-many)
	public void function addAttributeValue(required any attributeValue) {
		arguments.attributeValue.setOrderPayment( this );
	}
	public void function removeAttributeValue(required any attributeValue) {
		arguments.attributeValue.removeOrderPayment( this );
	}
	
	// Payment Transactions (one-to-many)
	public void function addPaymentTransaction(required any paymentTransaction) {
		arguments.paymentTransaction.setOrderPayment( this );
	}
	public void function removePaymentTransaction(required any paymentTransaction) {
		arguments.paymentTransaction.removeOrderPayment( this );
	}
	
	// Referencing Order Payments (one-to-many)    
	public void function addReferencingOrderPayment(required any referencingOrderPayment) {    
		arguments.referencingOrderPayment.setReferencedOrderPayment( this );    
	}    
	public void function removeReferencingOrderPayment(required any referencingOrderPayment) {    
		arguments.referencingOrderPayment.removeReferencedOrderPayment( this );    
	}
	
	// Applied Account Payments (one-to-many)    
	public void function addAppliedAccountPayment(required any appliedAccountPayment) {    
		arguments.appliedAccountPayment.setOrderPayment( this );    
	}    
	public void function removeAppliedAccountPayment(required any appliedAccountPayment) {    
		arguments.appliedAccountPayment.removeOrderPayment( this );    
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================
	
	// ============== START: Overridden Implicet Getters ===================
	
	public any function getAmount() {
		// If an amount has not been explicity set, then we can return another value if needed
		if( !structKeyExists(variables, "amount") ) {
			if(!isNull(getOrder()) && !isNull(getOrder().getDynamicChargeOrderPayment()) && getOrderPaymentType().getSystemCode() eq 'optCharge' && getOrder().getDynamicChargeOrderPayment().getOrderPaymentID() eq getOrderPaymentID()) {
				return getOrder().getDynamicChargeOrderPaymentAmount();
			} else if (!isNull(getOrder()) && !isNull(getOrder().getDynamicCreditOrderPayment()) && getOrderPaymentType().getSystemCode() eq 'optCredit' && getOrder().getDynamicCreditOrderPayment().getOrderPaymentID() eq getOrderPaymentID()) {
				return getOrder().getDynamicCreditOrderPaymentAmount(); 
			} else if (!isNull(getOrder())) {
				return 0;
			}
			
			// Return null to describe that it hasn't been defined yet, but it will need to.
			return ;
		}
		
		return variables.amount;
	}

	public any function getBillingAddress() {
		if( !structKeyExists(variables, "billingAddress") ) {
			return getService("addressService").newAddress();
		}
		return variables.billingAddress;
	}
	
	public any function getOrderPaymentType() {
		if( !structKeyExists(variables, "orderPaymentType") ) {
			variables.orderPaymentType = getService("settingService").getTypeBySystemCode("optCharge");
		}
		return variables.orderPaymentType;
	}
	
	public any function getOrderPaymentStatusType() {
		if( !structKeyExists(variables, "orderPaymentStatusType") ) {
			variables.orderPaymentStatusType = getService("settingService").getTypeBySystemCode("opstActive");
		}
		return variables.orderPaymentStatusType;
	}
	
	// ==============  END: Overridden Implicet Getters ====================

	// ================== START: Overridden Methods ========================
	
	public any function afterPopulate() {
		if(!isNull(getCreditCardNumber()) && len(getCreditCardNumber()) && getCreditCardType() != "Invalid" && !isNull(getPaymentMethod()) && !isNull(getPaymentMethod().getSaveOrderPaymentEncryptFlag()) && getPaymentMethod().getSaveOrderPaymentEncryptFlag()) {
			setCreditCardNumberEncrypted(encryptValue(getCreditCardNumber()));
		}
	}
	
	public void function setCreditCardNumber(required string creditCardNumber) {
		if(len(arguments.creditCardNumber)) {
			variables.creditCardNumber = REReplaceNoCase(arguments.creditCardNumber, '[^0-9]', '', 'ALL');	
			setCreditCardLastFour( right(variables.creditCardNumber, 4) );
			setCreditCardType( getService("paymentService").getCreditCardTypeFromNumber(variables.creditCardNumber) );
		} else {
			structDelete(variables, "creditCardNumber");
			setCreditCardLastFour(javaCast("null", ""));
			setCreditCardType(javaCast("null", ""));
			setCreditCardNumberEncrypted(javaCast("null", ""));
		}
	}
	
	public any function getSimpleRepresentation() {
		if(this.isNew()) {
			return rbKey('define.new') & ' ' & rbKey('entity.orderPayment');
		}
		
		if(getPaymentMethodType() == "creditCard") {
			return getPaymentMethod().getPaymentMethodName() & " - " & getCreditCardType() & " ***" & getCreditCardLastFour() & ' - ' & getFormattedValue('amount');	
		}
		
		return getPaymentMethod().getPaymentMethodName() & ' - ' & getFormattedValue('amount');
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	public void function preInsert(){
		super.preInsert();
		
		// Verify Defaults are Set
		getOrderPaymentType();
		getOrderPaymentStatusType();
	}
	
	// ===================  END:  ORM Event Hooks  =========================
}

