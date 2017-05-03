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
component accessors="true" output="false" {

	property name="fw" type="any";

	property name="orderService" type="any";
	property name="paymentService" type="any";
	
	this.publicMethods='';
	this.publicMethods=listAppend(this.publicMethods, 'initiatePayment');
	this.publicMethods=listAppend(this.publicMethods, 'processResponse');
	
	this.anyAdminMethods='';
	
	this.secureMethods='';
	this.secureMethods=listAppend(this.secureMethods, 'main');
	
	public void function init( required any fw ) {
		setFW( arguments.fw );
	}
	
	public void function before() {
		getFW().setView("paypalexpress:main.blank");
	}
	
	public void function initiatePayment( required struct rc ) {
		param name="arguments.rc.paymentMethodID" default=""; 
		
		var paymentMethod = getPaymentService().getPaymentMethod(rc.paymentMethodID);
		
		if(!isNull(paymentMethod) && paymentMethod.getIntegration().getIntegrationPackage() eq "paypalexpress") {
			var paymentCFC = paymentMethod.getIntegration().getIntegrationCFC( 'payment' );
			
			var responseData = paymentCFC.getInitiatePaymentData( paymentMethod=paymentMethod, order=request.slatwallScope.getCart() );
			
			if(structKeyExists(responseData, "ack") && responseData.ack == "Success" && structKeyExists(responseData, "token")) {
				if(paymentMethod.getIntegration().setting('paypalAccountSandboxFlag') eq true) {
					location("https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=#responseData.token#", false);
				} else {
					location("https://www.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=#responseData.token#", false);	
				}
			} else if (structKeyExists(responseData, "ack") && responseData.ack == "Failure") {
				rc.$.slatwall.cart().addError('Payment',responseData["L_SHORTMESSAGE0"]);
				rc.$.slatwall.cart().addError('PaypalExpressErrorDetail',responseData);
			}
		}
	}
	
	public void function processResponse( required struct rc ) {
		param name="rc.paymentMethodID" default="";
		param name="rc.token" default="";
		
		var paymentMethod = getPaymentService().getPaymentMethod( rc.paymentMethodID );

		arguments.rc.$.slatwall.setPublicPopulateFlag( true );
		
		if(!isNull(paymentMethod) && paymentMethod.getIntegration().getIntegrationPackage() eq "paypalexpress") {
			
			var paymentCFC = paymentMethod.getIntegration().getIntegrationCFC( 'payment' );
			
			var responseData = paymentCFC.getPaymentResponseData( paymentMethod=paymentMethod, token=rc.token );
			
			if(structKeyExists(responseData, "ack") && responseData.ack == "Success") {
				
				// Setup newOrderPayment
				var paymentData = {};
				paymentData.newOrderPayment = {};
				paymentData.newOrderPayment.accountPaymentMethodID = '';
				paymentData.newOrderPayment.orderPaymentID = '';
				paymentData.newOrderPayment.amount = responseData.PAYMENTREQUEST_0_AMT;
				paymentData.newOrderPayment.paymentMethod.paymentMethodID = paymentMethod.getPaymentMethodID();
				paymentData.newOrderPayment.order.orderID = rc.$.slatwall.cart().getOrderID();
				paymentData.newOrderPayment.orderPaymentType.typeID = '8aac86674079189801407a81b456000a';
				
				// Manually set the providerToken value because it can't be populated
				var addOrderPaymentProcessObject = rc.$.slatwall.cart().getProcessObject('addOrderPayment');
				addOrderPaymentProcessObject.getNewOrderPayment().setProviderToken(responseData.token & '~' & responseData.payerID);
				addOrderPaymentProcessObject.setCopyFromType('');
				var order = getOrderService().processOrder( rc.$.slatwall.cart(), paymentData, 'addOrderPayment');
				
				arguments.rc.$.slatwall.addActionResult( "public:cart.addOrderPayment", order.hasErrors() );
			}
		}
		
	}
	
	
}