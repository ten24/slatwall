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

component accessors="true" output="false" extends="Slatwall.model.transient.RequestBean" {
	
	// Process Info
	property name="transactionID" type="string" ;
	property name="transactionType" type="string" ;
	property name="transactionAmount" type="numeric";
	property name="transactionCurrencyCode" type="string";
	property name="transactionCurrencyISONumber" type="string";
	
	// Credit Card Info
	property name="nameOnCreditCard" type="string";
	property name="creditCardLastFour" type="string";
	property name="creditCardNumber" type="string";
	property name="creditCardType" type="string"; 
	property name="expirationMonth" type="numeric";   
	property name="expirationYear" type="numeric";
	property name="securityCode" type="string";
	property name="providerToken" type="string";
	
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
	
	// Pertinent Reference Information (used for accountPayments)
	property name="accountPaymentID" type="string";
	
	// Pertinent Reference Information (used for accountPaymentMethods)
	property name="accountPaymentMethodID" type="string";
	
	// Pertinent Reference Information (used for orderPayments)
	property name="orderPaymentID" type="string";
	property name="orderID" type="string";
	
	// Pertinent Reference Information (used for all above)
	property name="accountID" type="string";
	
	// Reference Objects
	property name="account" type="any";
	property name="accountPayment" type="any";
	property name="accountPaymentMethod" type="any";
	property name="order" type="any";
	property name="orderPayment" type="any";
	
	// Always there if this Account Payment or Order Payment has previously had an authorization done
	property name="originalAuthorizationCode" type="string";
	property name="originalAuthorizationProviderTransactionID" type="string";
	property name="originalChargeProviderTransactionID" type="string";
	property name="originalProviderTransactionID" type="string";
	
	// Only Used for 'chargePreAuthorization'
	property name="preAuthorizationCode" type="string";
	property name="preAuthorizationProviderTransactionID" type="string";
	
	// Deprecated
	property name="transactionCurrency" ormtype="string";
	property name="isDuplicateFlag" type="boolean";
	
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
	
	public void function populatePaymentInfoWithAccountPayment(required any accountPayment) {
		
		// Populate Credit Card Info
		if(!isNull(arguments.accountPayment.getCreditCardLastFour())) {
			setCreditCardLastFour(arguments.accountPayment.getCreditCardLastFour());	
		}
		if(!isNull(arguments.accountPayment.getCreditCardNumber())) {
			setCreditCardNumber(arguments.accountPayment.getCreditCardNumber());	
		}
		if(!isNull(arguments.accountPayment.getSecurityCode())) {
			setSecurityCode(arguments.accountPayment.getSecurityCode());	
		}
		if(!isNull(arguments.accountPayment.getProviderToken())) {
			setProviderToken(arguments.accountPayment.getProviderToken());	
		}
		if(!isNull(arguments.accountPayment.getNameOnCreditCard())) {
			setNameOnCreditCard(arguments.accountPayment.getNameOnCreditCard());	
		}
		if(!isNull(arguments.accountPayment.getCreditCardType())) {
			setCreditCardType(arguments.accountPayment.getCreditCardType());
		}
		if(!isNull(arguments.accountPayment.getExpirationMonth())) {
			setExpirationMonth(arguments.accountPayment.getExpirationMonth());	
		}
		if(!isNull(arguments.accountPayment.getExpirationYear())) {
			setExpirationYear(arguments.accountPayment.getExpirationYear());	
		}
		
		// Populate Account Info
		setAccountFirstName(arguments.accountPayment.getAccount().getFirstName());
		setAccountLastName(arguments.accountPayment.getAccount().getLastName());
		if(!isNull(arguments.accountPayment.getAccount().getPrimaryPhoneNumber())) {
			setAccountPrimaryPhoneNumber(arguments.accountPayment.getAccount().getPrimaryPhoneNumber().getPhoneNumber());	
		}
		if(!isNull(arguments.accountPayment.getAccount().getPrimaryEmailAddress())) {
			setAccountPrimaryEmailAddress(arguments.accountPayment.getAccount().getPrimaryEmailAddress().getEmailAddress());	
		}
		
		// Populate Billing Address Info
		if(!isNull(arguments.accountPayment.getBillingAddress().getName())) {
			setBillingName(arguments.accountPayment.getBillingAddress().getName());
		}
		if(!isNull(arguments.accountPayment.getBillingAddress().getCompany())) {
			setBillingCompany(arguments.accountPayment.getBillingAddress().getCompany());
		}
		if(!isNull(arguments.accountPayment.getBillingAddress().getStreetAddress())) {
			setBillingStreetAddress(arguments.accountPayment.getBillingAddress().getStreetAddress());
		}
		if(!isNull(arguments.accountPayment.getBillingAddress().getStreet2Address())) {
			setBillingStreet2Address(arguments.accountPayment.getBillingAddress().getStreet2Address());
		}
		if(!isNull(arguments.accountPayment.getBillingAddress().getLocality())) {
			setBillingLocality(arguments.accountPayment.getBillingAddress().getLocality());
		}
		if(!isNull(arguments.accountPayment.getBillingAddress().getCity())) {
			setBillingCity(arguments.accountPayment.getBillingAddress().getCity());
		}
		if(!isNull(arguments.accountPayment.getBillingAddress().getStateCode())) {
			setBillingStateCode(arguments.accountPayment.getBillingAddress().getStateCode());
		}
		if(!isNull(arguments.accountPayment.getBillingAddress().getPostalCode())) {
			setBillingPostalCode(arguments.accountPayment.getBillingAddress().getPostalCode());
		}
		if(!isNull(arguments.accountPayment.getBillingAddress().getCountryCode())) {
			setBillingCountryCode(arguments.accountPayment.getBillingAddress().getCountryCode());
		}
		
		// Setup all original transaction details
		if(len(arguments.accountPayment.getOriginalAuthorizationCode())) {
			setOriginalAuthorizationCode(arguments.accountPayment.getOriginalAuthorizationCode());
		}
		if(len(arguments.accountPayment.getOriginalAuthorizationProviderTransactionID())) {
			setOriginalAuthorizationProviderTransactionID(arguments.accountPayment.getOriginalAuthorizationProviderTransactionID());
		}
		if(len(arguments.accountPayment.getOriginalChargeProviderTransactionID())) {
			setOriginalChargeProviderTransactionID(arguments.accountPayment.getOriginalChargeProviderTransactionID());
		}
		if(len(arguments.accountPayment.getOriginalProviderTransactionID())) {
			setOriginalProviderTransactionID(arguments.accountPayment.getOriginalProviderTransactionID());
		}
		
		// Populate relavent Misc Info
		setAccountPaymentID( arguments.accountPayment.getAccountPaymentID() );
		setAccountID( arguments.accountPayment.getAccount().getAccountID() );
		
		setAccountPayment( arguments.accountPayment );
		setAccount( arguments.accountPayment.getAccount() );
		
	}
	
	public void function populatePaymentInfoWithOrderPayment(required any orderPayment) {
		
		// Populate Credit Card Info
		if(!isNull(arguments.orderPayment.getCreditCardLastFour())) {
			setCreditCardLastFour(arguments.orderPayment.getCreditCardLastFour());
		}
		if(!isNull(arguments.orderPayment.getCreditCardNumber())) {
			setCreditCardNumber(arguments.orderPayment.getCreditCardNumber());
		}
		if(!isNull(arguments.orderPayment.getSecurityCode())) {
			setSecurityCode(arguments.orderPayment.getSecurityCode());	
		}
		if(!isNull(arguments.orderPayment.getProviderToken())) {
			setProviderToken(arguments.orderPayment.getProviderToken());	
		}
		if(!isNull(arguments.orderPayment.getNameOnCreditCard())) {
			setNameOnCreditCard(arguments.orderPayment.getNameOnCreditCard());	
		}
		if(!isNull(arguments.orderPayment.getCreditCardType())) {
			setCreditCardType(arguments.orderPayment.getCreditCardType());	
		}
		if(!isNull(arguments.orderPayment.getExpirationMonth())) {
			setExpirationMonth(arguments.orderPayment.getExpirationMonth());	
		}
		if(!isNull(arguments.orderPayment.getExpirationYear())) {
			setExpirationYear(arguments.orderPayment.getExpirationYear());	
		}
		
		// Populate Account Info
		setAccountFirstName(arguments.orderPayment.getOrder().getAccount().getFirstName());
		setAccountLastName(arguments.orderPayment.getOrder().getAccount().getLastName());
		if(!isNull(arguments.orderPayment.getOrder().getAccount().getPrimaryPhoneNumber())) {
			setAccountPrimaryPhoneNumber(arguments.orderPayment.getOrder().getAccount().getPrimaryPhoneNumber().getPhoneNumber());	
		}
		if(!isNull(arguments.orderPayment.getOrder().getAccount().getPrimaryEmailAddress())) {
			setAccountPrimaryEmailAddress(arguments.orderPayment.getOrder().getAccount().getPrimaryEmailAddress().getEmailAddress());	
		}
		
		// Populate Billing Address Info
		if(!isNull(arguments.orderPayment.getBillingAddress())) {
			if(!isNull(arguments.orderPayment.getBillingAddress().getName())) {
				setBillingName(arguments.orderPayment.getBillingAddress().getName());
			}
			if(!isNull(arguments.orderPayment.getBillingAddress().getCompany())) {
				setBillingCompany(arguments.orderPayment.getBillingAddress().getCompany());
			}
			if(!isNull(arguments.orderPayment.getBillingAddress().getStreetAddress())) {
				setBillingStreetAddress(arguments.orderPayment.getBillingAddress().getStreetAddress());
			}
			if(!isNull(arguments.orderPayment.getBillingAddress().getStreet2Address())) {
				setBillingStreet2Address(arguments.orderPayment.getBillingAddress().getStreet2Address());
			}
			if(!isNull(arguments.orderPayment.getBillingAddress().getLocality())) {
				setBillingLocality(arguments.orderPayment.getBillingAddress().getLocality());
			}
			if(!isNull(arguments.orderPayment.getBillingAddress().getCity())) {
				setBillingCity(arguments.orderPayment.getBillingAddress().getCity());
			}
			if(!isNull(arguments.orderPayment.getBillingAddress().getStateCode())) {
				setBillingStateCode(arguments.orderPayment.getBillingAddress().getStateCode());
			}
			if(!isNull(arguments.orderPayment.getBillingAddress().getPostalCode())) {
				setBillingPostalCode(arguments.orderPayment.getBillingAddress().getPostalCode());
			}
			if(!isNull(arguments.orderPayment.getBillingAddress().getCountryCode())) {
				setBillingCountryCode(arguments.orderPayment.getBillingAddress().getCountryCode());
			}
		}
		
		// Setup all original transaction details
		if(len(arguments.orderPayment.getOriginalAuthorizationCode())) {
			setOriginalAuthorizationCode(arguments.orderPayment.getOriginalAuthorizationCode());
		}
		if(len(arguments.orderPayment.getOriginalAuthorizationProviderTransactionID())) {
			setOriginalAuthorizationProviderTransactionID(arguments.orderPayment.getOriginalAuthorizationProviderTransactionID());
		}
		if(len(arguments.orderPayment.getOriginalChargeProviderTransactionID())) {
			setOriginalChargeProviderTransactionID(arguments.orderPayment.getOriginalChargeProviderTransactionID());
		}
		if(len(arguments.orderPayment.getOriginalProviderTransactionID())) {
			setOriginalProviderTransactionID(arguments.orderPayment.getOriginalProviderTransactionID());
		}
		
		// Populate relavent Misc Info
		setOrderPaymentID( arguments.orderPayment.getOrderPaymentID() );
		setOrderID( arguments.orderPayment.getOrder().getOrderID() );
		setAccountID( arguments.orderPayment.getOrder().getAccount().getAccountID() );
		
		setOrderPayment( arguments.orderPayment );
		setOrder( arguments.orderPayment.getOrder() );
		setAccount( arguments.orderPayment.getOrder().getAccount() );
		
	}
	
	public void function populatePaymentInfoWithAccountPaymentMethod(required any accountPaymentMethod) {
		
		// Populate Credit Card Info
		if(!isNull(arguments.accountPaymentMethod.getCreditCardLastFour())) {
			setCreditCardLastFour(arguments.accountPaymentMethod.getCreditCardLastFour());
		}
		if(!isNull(arguments.accountPaymentMethod.getCreditCardNumber())) {
			setCreditCardNumber(arguments.accountPaymentMethod.getCreditCardNumber());
		}
		if(!isNull(arguments.accountPaymentMethod.getSecurityCode())) {
			setSecurityCode(arguments.accountPaymentMethod.getSecurityCode());	
		}
		if(!isNull(arguments.accountPaymentMethod.getProviderToken())) {
			setProviderToken(arguments.accountPaymentMethod.getProviderToken());	
		}
		setNameOnCreditCard(arguments.accountPaymentMethod.getNameOnCreditCard());
		setCreditCardType(arguments.accountPaymentMethod.getCreditCardType());
		setExpirationMonth(arguments.accountPaymentMethod.getExpirationMonth());
		setExpirationYear(arguments.accountPaymentMethod.getExpirationYear());
		
		
		// Populate Account Info
		setAccountFirstName(arguments.accountPaymentMethod.getAccount().getFirstName());
		setAccountLastName(arguments.accountPaymentMethod.getAccount().getLastName());
		if(!isNull(arguments.accountPaymentMethod.getAccount().getPrimaryPhoneNumber())) {
			setAccountPrimaryPhoneNumber(arguments.accountPaymentMethod.getAccount().getPrimaryPhoneNumber().getPhoneNumber());	
		}
		if(!isNull(arguments.accountPaymentMethod.getAccount().getPrimaryEmailAddress())) {
			setAccountPrimaryEmailAddress(arguments.accountPaymentMethod.getAccount().getPrimaryEmailAddress().getEmailAddress());	
		}
		
		// Populate Billing Address Info
		if(!isNull(arguments.accountPaymentMethod.getBillingAddress().getName())) {
			setBillingName(arguments.accountPaymentMethod.getBillingAddress().getName());
		}
		if(!isNull(arguments.accountPaymentMethod.getBillingAddress().getCompany())) {
			setBillingCompany(arguments.accountPaymentMethod.getBillingAddress().getCompany());
		}
		if(!isNull(arguments.accountPaymentMethod.getBillingAddress().getStreetAddress())) {
			setBillingStreetAddress(arguments.accountPaymentMethod.getBillingAddress().getStreetAddress());
		}
		if(!isNull(arguments.accountPaymentMethod.getBillingAddress().getStreet2Address())) {
			setBillingStreet2Address(arguments.accountPaymentMethod.getBillingAddress().getStreet2Address());
		}
		if(!isNull(arguments.accountPaymentMethod.getBillingAddress().getLocality())) {
			setBillingLocality(arguments.accountPaymentMethod.getBillingAddress().getLocality());
		}
		if(!isNull(arguments.accountPaymentMethod.getBillingAddress().getCity())) {
			setBillingCity(arguments.accountPaymentMethod.getBillingAddress().getCity());
		}
		if(!isNull(arguments.accountPaymentMethod.getBillingAddress().getStateCode())) {
			setBillingStateCode(arguments.accountPaymentMethod.getBillingAddress().getStateCode());
		}
		if(!isNull(arguments.accountPaymentMethod.getBillingAddress().getPostalCode())) {
			setBillingPostalCode(arguments.accountPaymentMethod.getBillingAddress().getPostalCode());
		}
		if(!isNull(arguments.accountPaymentMethod.getBillingAddress().getCountryCode())) {
			setBillingCountryCode(arguments.accountPaymentMethod.getBillingAddress().getCountryCode());
		}
		
		// Populate relavent Misc Info
		setAccountPaymentMethodID( arguments.accountPaymentMethod.getAccountPaymentMethodID() );
		setAccountID( arguments.accountPaymentMethod.getAccount().getAccountID() );
		
		setAccountPaymentMethod( arguments.accountPaymentMethod );
		setAccount( arguments.accountPaymentMethod.getAccount() );
		
	}
	
	// Deprecated
	public string function getTransactionCurrency() {
		return getTransactionCurrencyCode();
	}
}
