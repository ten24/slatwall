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
component entityname="SlatwallPaymentTransaction" table="SwPaymentTransaction" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="paymentService" {

	// Persistent Properties
	property name="paymentTransactionID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="transactionType" ormtype="string";
	property name="transactionStartTickCount" ormtype="string";
	property name="transactionEndTickCount" ormtype="string";
	property name="transactionSuccessFlag" ormtype="boolean";
	property name="providerTransactionID" ormtype="string";
	property name="transactionDateTime" ormtype="timestamp";
	property name="authorizationCode" ormtype="string";
	property name="authorizationCodeUsed" ormtype="string";
	property name="authorizationCodeInvalidFlag" ormtype="boolean";
	property name="amountAuthorized" notnull="true" dbdefault="0" ormtype="big_decimal";
	property name="amountReceived" notnull="true" dbdefault="0" ormtype="big_decimal";
	property name="amountCredited" notnull="true" dbdefault="0" ormtype="big_decimal";
	property name="currencyCode" ormtype="string" length="3";
	property name="securityCodeMatchFlag" ormtype="boolean";
	property name="avsCode" ormtype="string";				// @hint this is whatever the avs code was that got returned
	property name="statusCode" ormtype="string";			// @hint this is the status code that was passed back in the response bean
	property name="message" ormtype="string" length="4000"; // @hint this is a pipe and tilda delimited list of any messages that came back in the response.

	// Related Object Properties (many-to-one)
	property name="accountPayment" cfc="AccountPayment" fieldtype="many-to-one" fkcolumn="accountPaymentID";
	property name="accountPaymentMethod" cfc="AccountPaymentMethod" fieldtype="many-to-one" fkcolumn="accountPaymentMethodID";
	property name="orderPayment" cfc="OrderPayment" fieldtype="many-to-one" fkcolumn="orderPaymentID";

	// Related Object Properties (one-to-many)

	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)

	// Remote Properties
	property name="remoteID" ormtype="string";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	// Deperecated Properties
	property name="amountCharged" notnull="true" dbdefault="0" ormtype="big_decimal";

	// Non-Persistent Properties

	property name="avsDescription" persistent="false";


	public any function init() {
		setAmountAuthorized(0);
		setAmountCharged(0);
		setAmountCredited(0);
		setAmountReceived(0);

		return super.init();
	}

	public any function getPayment() {
		if(!isNull(getOrderPayment())) {
			return getOrderPayment();
		} else if (!isNull(getAccountPayment())) {
			return getAccountPayment();
		} else if (!isNull(getAccountPaymentMethod())) {
			return getAccountPaymentMethod();
		}
	}

	public string function getAVSDescription(){
		if(!isNull(getAvsCode()) && getAvsCode() !=''){
			return rbKey('entity.PaymentTransaction.AVSDescription.' & getAvsCode());
		}else{
			return '';
		}
	}

	// ============ START: Non-Persistent Property Methods =================

	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	// Account Payment Method (many-to-one)
	public void function setAccountPaymentMethod(required any accountPaymentMethod) {
		variables.accountPaymentMethod = arguments.accountPaymentMethod;
		if(isNew() or !arguments.accountPaymentMethod.hasPaymentTransaction( this )) {
			arrayAppend(arguments.accountPaymentMethod.getPaymentTransactions(), this);
		}
	}
	public void function removeAccountPaymentMethod(any accountPaymentMethod) {
		if(!structKeyExists(arguments, "accountPaymentMethod")) {
			arguments.accountPaymentMethod = variables.accountPaymentMethod;
		}
		var index = arrayFind(arguments.accountPaymentMethod.getPaymentTransactions(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.accountPaymentMethod.getPaymentTransactions(), index);
		}
		structDelete(variables, "accountPaymentMethod");
	}

	// Account Payment (many-to-one)
	public void function setAccountPayment(required any accountPayment) {
		variables.accountPayment = arguments.accountPayment;
		if(isNew() or !arguments.accountPayment.hasPaymentTransaction( this )) {
			arrayAppend(arguments.accountPayment.getPaymentTransactions(), this);
		}
	}
	public void function removeAccountPayment(any accountPayment) {
		if(!structKeyExists(arguments, "accountPayment")) {
			arguments.accountPayment = variables.accountPayment;
		}
		var index = arrayFind(arguments.accountPayment.getPaymentTransactions(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.accountPayment.getPaymentTransactions(), index);
		}
		structDelete(variables, "accountPayment");
	}

	// Order Payment (many-to-one)
	public void function setOrderPayment(required any orderPayment) {
		variables.orderPayment = arguments.orderPayment;
		if(isNew() or !arguments.orderPayment.hasPaymentTransaction( this )) {
			arrayAppend(arguments.orderPayment.getPaymentTransactions(), this);
		}
	}
	public void function removeOrderPayment(any orderPayment) {
		if(!structKeyExists(arguments, "orderPayment")) {
			arguments.orderPayment = variables.orderPayment;
		}
		var index = arrayFind(arguments.orderPayment.getPaymentTransactions(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.orderPayment.getPaymentTransactions(), index);
		}
		structDelete(variables, "orderPayment");
	}


	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================

	public boolean function hasOrderPaymentOrAccountPayment() {
		return !isNull(getAccountPayment()) || !isNull(getOrderPayment());
	}

	// ===============  END: Custom Validation Methods =====================

	// =============== START: Custom Formatting Methods ====================

	// ===============  END: Custom Formatting Methods =====================

	// ================== START: Overridden Methods ========================

	public string function getSimpleRepresentationPropertyName() {
		return "paymentTransactionID";
	}

	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	public void function preInsert(){
		super.preInsert();

		// Verify that the transactionDateTime is not null
		if(isNull(getTransactionDateTime()) || !isDate(getTransactionDateTime())) {
			setTransactionDateTime( getCreatedDateTime() );
		}
	}

	public void function preDelete() {
		if(
			( !isNull(getAccountPaymentMethod()) && isNull(getOrderPayment()) && getTransactionType() neq "generateToken" )
		 	||
			( !isNull(getOrderPayment()) && !isNull(getOrderPayment().getOrder()) && getOrderPayment().getOrder().getOrderStatusType().getSystemCode() neq "ostNotPlaced" ) ) {
			throw("Deleting a Payment Transaction is not allowed because this illustrates a fundamental flaw in accounting.");
		}
	}
	// ===================  END:  ORM Event Hooks  =========================

	// ================== START: Deprecated Methods ========================

	public numeric function getAmountCharged() {
		if(!isNull(getAmountReceived())) {
			return getAmountReceived();
		}
	}

	// ==================  END:  Deprecated Methods ========================
}
