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
component displayname="Payment Transaction" entityname="SlatwallPaymentTransaction" table="SlatwallPaymentTransaction" persistent="true" accessors="true" extends="BaseEntity" {
	
	// Persistent Properties
	property name="paymentTransactionID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="transactionType" ormtype="string";
	property name="providerTransactionID" ormtype="string";
	property name="transactionDateTime" ormtype="timestamp";
	property name="authorizationCode" ormtype="string";
	property name="amountAuthorized" notnull="true" dbdefault="0" ormtype="big_decimal";
	property name="amountCharged" notnull="true" dbdefault="0" ormtype="big_decimal"; // This property is deprecated DO NOT USE!
	property name="amountReceived" notnull="true" dbdefault="0" ormtype="big_decimal";
	property name="amountCredited" notnull="true" dbdefault="0" ormtype="big_decimal";
	property name="currencyCode" ormtype="string" length="3";
	property name="avsCode" ormtype="string";				// @hint this is whatever the avs code was that got returned
	property name="statusCode" ormtype="string";			// @hint this is the status code that was passed back in the response bean
	property name="message" ormtype="string";  				// @hint this is a pipe and tilda delimited list of any messages that came back in the response.
	
	// Related Object Properties (many-to-one)
	property name="accountPayment" cfc="AccountPayment" fieldtype="many-to-one" fkcolumn="accountPaymentID";
	property name="orderPayment" cfc="OrderPayment" fieldtype="many-to-one" fkcolumn="orderPaymentID";
	
	// Related Object Properties (one-to-many)
	
	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties


	
	public any function init() {
		setAmountAuthorized(0);
		setAmountCharged(0);
		setAmountCredited(0);
		setAmountReceived(0);
		
		return super.init();
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
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
		if(isNull(getOrderPayment()) || ( !isNull(getOrderPayment().getOrder()) && getOrderPayment().getOrder().getOrderStatusType().getSystemCode() neq "ostNotPlaced" ) ) {
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