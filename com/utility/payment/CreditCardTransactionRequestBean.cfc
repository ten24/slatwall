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

component displayname="Gateway Request"  accessors="true" output="false" extends="Slatwall.com.utility.RequestBean" {
	
	// Process Info
	property name="transactionID" type="string" ;
	property name="transactionType" type="string" ;
	property name="transactionAmount" ormtype="float";
	property name="transactionCurrency" ormtype="float";
	property name="providerTransactionID" type="string";
	property name="isDuplicateFlag" type="boolean";
	
	// Credit Card Info
	property name="nameOnCreditCard" ormType="string";
	property name="creditCardNumber" type="string"; 
	property name="creditCardType" type="string"; 
	property name="expirationMonth" type="numeric";   
	property name="expirationYear" type="numeric";
	property name="securityCode" type="numeric";
	
	// Account Info
	property name="accountFirstName" type="string";   
	property name="accountLastName" type="string";   
	property name="accountPrimaryPhoneNumber" type="string"; 
	property name="accountPrimaryEmailAddress" type="string";
	
	// Billing Address Info
	property name="billingName" type="string";
	property name="billingCompany" type="string";
	property name="billingStreetAddress" type="string";  
	property name="billingStreet2Address" type="string";
	property name="billingLocality" type="string";
	property name="billingCity" type="string";   
	property name="billingStateCode" type="string";   
	property name="billingPostalCode" type="string";   
	property name="billingCountryCode" type="string";   
	
	// Pertinent Reference Information
	property name="orderPaymentID" type="string" ;
	property name="orderID" type="string" ;
	property name="accountID" type="string";
	
	/*
	Process Types
	-------------
	authorize
	authorizeAndCharge
	chargePreAuthorization
	credit
	void
	inquirey
	
	*/
	
	public void function populatePaymentInfoWithOrderPayment(required Slatwall.com.entity.OrderPaymentCreditCard orderPaymentCreditCard) {
		
		// Populate Credit Card Info
		setNameOnCreditCard(arguments.orderPaymentCreditCard.getNameOnCreditCard());
		setCreditCardNumber(arguments.orderPaymentCreditCard.getCreditCardNumber());
		setCreditCardType(arguments.orderPaymentCreditCard.getCreditCardType());
		setExpirationMonth(arguments.orderPaymentCreditCard.getExpirationMonth());
		setExpirationYear(arguments.orderPaymentCreditCard.getExpirationYear());
		setSecurityCode(arguments.orderPaymentCreditCard.getSecurityCode());
		
		// Populate Account Info
		setAccountFirstName(arguments.orderPaymentCreditCard.getOrder().getAccount().getFirstName());
		setAccountLastName(arguments.orderPaymentCreditCard.getOrder().getAccount().getLastName());
		if(!isNull(arguments.orderPaymentCreditCard.getOrder().getAccount().getPrimaryPhoneNumber())) {
			setAccountPrimaryPhoneNumber(arguments.orderPaymentCreditCard.getOrder().getAccount().getPrimaryPhoneNumber().getPhoneNumber());	
		}
		if(!isNull(arguments.orderPaymentCreditCard.getOrder().getAccount().getPrimaryEmailAddress())) {
			setAccountPrimaryEmailAddress(arguments.orderPaymentCreditCard.getOrder().getAccount().getPrimaryEmailAddress().getEmailAddress());	
		}
		
		// Populate Billing Address Info
		if(!isNull(arguments.orderPaymentCreditCard.getBillingAddress().getName())) {
			setBillingName(arguments.orderPaymentCreditCard.getBillingAddress().getName());
		}
		if(!isNull(arguments.orderPaymentCreditCard.getBillingAddress().getCompany())) {
			setBillingCompany(arguments.orderPaymentCreditCard.getBillingAddress().getCompany());
		}
		if(!isNull(arguments.orderPaymentCreditCard.getBillingAddress().getStreetAddress())) {
			setBillingStreetAddress(arguments.orderPaymentCreditCard.getBillingAddress().getStreetAddress());
		}
		if(!isNull(arguments.orderPaymentCreditCard.getBillingAddress().getStreet2Address())) {
			setBillingStreet2Address(arguments.orderPaymentCreditCard.getBillingAddress().getStreet2Address());
		}
		if(!isNull(arguments.orderPaymentCreditCard.getBillingAddress().getLocality())) {
			setBillingLocality(arguments.orderPaymentCreditCard.getBillingAddress().getLocality());
		}
		if(!isNull(arguments.orderPaymentCreditCard.getBillingAddress().getCity())) {
			setBillingCity(arguments.orderPaymentCreditCard.getBillingAddress().getCity());
		}
		if(!isNull(arguments.orderPaymentCreditCard.getBillingAddress().getStateCode())) {
			setBillingStateCode(arguments.orderPaymentCreditCard.getBillingAddress().getStateCode());
		}
		if(!isNull(arguments.orderPaymentCreditCard.getBillingAddress().getPostalCode())) {
			setBillingPostalCode(arguments.orderPaymentCreditCard.getBillingAddress().getPostalCode());
		}
		if(!isNull(arguments.orderPaymentCreditCard.getBillingAddress().getCountryCode())) {
			setBillingCountryCode(arguments.orderPaymentCreditCard.getBillingAddress().getCountryCode());
		}
		
		// Populate relavent Misc Info
		setOrderPaymentID(arguments.orderPaymentCreditCard.getOrderPaymentID());
		setOrderID(arguments.orderPaymentCreditCard.getOrder().getOrderID());
		setAccountID(arguments.orderPaymentCreditCard.getOrder().getAccount().getAccountID());
	}
	
}