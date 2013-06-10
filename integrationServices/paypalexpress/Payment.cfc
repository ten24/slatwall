/*

    Slatwall - An Open Source eCommerce Platform
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

component accessors="true" output="false" implements="Slatwall.integrationServices.PaymentInterface" extends="Slatwall.integrationServices.BasePayment" {
	
	variables.sandboxURL = "https://api-3t.sandbox.paypal.com/nvp";
	variables.productionURL = "https://api-3t.paypal.com/nvp";
	
	public string function getPaymentMethodTypes() {
		return "external";
	}
	
	public string function getExternalPaymentHTML( required any paymentMethod ) {
		var returnHTML = "";
		
		savecontent variable="returnHTML" {
			include "views/main/externalpayment.cfm";
		}
		
		return returnHTML; 
	}
	
	public any function processExternal( required any requestBean ){
		
		var orderPayment = getService("orderService").getOrderPayment( requestBean.getOrderPaymentID() );
		var paymentMethod = orderPaymentID.getPaymentMethod();
		
		var responseData = {};
		
		var httpRequest = new http();
		httpRequest.setMethod("POST");
		if( paymentMethod.getIntegration().setting('paypalAccountSandboxFlag') ) {
			httpRequest.setUrl( variables.sandboxURL );
		} else {
			httpRequest.setUrl( variables.productionURL );
		}
		httpRequest.setPort( 443 );
		httpRequest.setTimeout( 120 );
		httpRequest.setResolveurl(false);
		
		httpRequest.addParam(type="formfield", name="method", value="doExpressCheckoutPayment");
		httpRequest.addParam(type="formfield", name="user", value=paymentMethod.getIntegration().setting('paypalAccountUser'));
		httpRequest.addParam(type="formfield", name="pwd", value=paymentMethod.getIntegration().setting('paypalAccountPassword'));
		httpRequest.addParam(type="formfield", name="signature", value=paymentMethod.getIntegration().setting('paypalAccountSignature'));									// Dynamic
		httpRequest.addParam(type="formfield", name="version", value="98.0");
		httpRequest.addParam(type="formfield", name="PAYMENTREQUEST_0_PAYMENTACTION", value="Authorization");
		httpRequest.addParam(type="formfield", name="PAYMENTREQUEST_0_AMT", value="#requestBean.getAmount()#");
		httpRequest.addParam(type="formfield", name="PAYERID", value="#listLast(orderPayment.getProviderToken(), "~")#");
		httpRequest.addParam(type="formfield", name="token", value="#listFirst(orderPayment.getProviderToken(), "~")#");
		
		var response = httpRequest.send().getPrefix();
		
		if(structKeyExists(response, "filecontent") && len(response.fileContent)) {
			var responseDataArray = listToArray(urlDecode(response.fileContent),"&");
			
			for(var item in responseDataArray){
				responseData[listFirst(item,"=")] = listRest(item,"=");
			}
		}
		
		var response = getTransient("externalTransactionResponseBean");
	
		// Set the response Code
		response.setStatusCode( responseData.ack );
		
		// Check to see if it was successful
		if(responseData.ack != "Success") {
			// Transaction did not go through
			response.addError(responseData.reasonCode, responseData.reasonCode);
		} else {
			response.setAmountReceived( responseData.PAYMENTREQUEST_0_AMT );
		}
		
		response.setTransactionID( responseData.CORRELATIONID );
		response.setAuthorizationCode( responseData.TOKEN );
		response.setSecurityCodeMatch( true );
		response.setAVSCode( "Y" );
		
		return response;
	}
	
	public struct function getInitiatePaymentData( required any paymentMethod, required any order ) {
		
		var responseData = {};
		
		var httpRequest = new http();
		httpRequest.setMethod("POST");
		if( arguments.paymentMethod.getIntegration().setting('paypalAccountSandboxFlag') ) {
			httpRequest.setUrl( variables.sandboxURL );
		} else {
			httpRequest.setUrl( variables.productionURL );
		}
		httpRequest.setPort( 443 );
		httpRequest.setTimeout( 120 );
		httpRequest.setResolveurl( false );
		
		httpRequest.addParam(type="formfield", name="method", value="setExpressCheckout");
		httpRequest.addParam(type="formfield", name="paymentAction", value="sale");
		httpRequest.addParam(type="formfield", name="user", value=arguments.paymentMethod.getIntegration().setting('paypalAccountUser'));
		httpRequest.addParam(type="formfield", name="pwd", value=arguments.paymentMethod.getIntegration().setting('paypalAccountPassword'));
		httpRequest.addParam(type="formfield", name="signature", value=arguments.paymentMethod.getIntegration().setting('paypalAccountSignature'));
		httpRequest.addParam(type="formfield", name="version", value="98.0");
		httpRequest.addParam(type="formfield", name="paymentRequest_0_amt", value="#arguments.order.getTotal()#");
		httpRequest.addParam(type="formfield", name="paymentRequest_0_currencyCode", value="#arguments.order.getCurrencyCode()#");
		httpRequest.addParam(type="formfield", name="noShipping", value="0");																							// Dynamic
		httpRequest.addParam(type="formfield", name="allowNote", value="0");																							// Dynamic
		//httpRequest.addParam(type="formfield", name="hdrImg", value="");
		httpRequest.addParam(type="formfield", name="email", value=arguments.paymentMethod.getIntegration().setting('paypalAccountEmail'));
		httpRequest.addParam(type="formfield", name="returnURL", value="http://cf9.muracms/default/index.cfm/checkout/?slatAction=paypalexpress:main.processResponse&paymentMethodID=#arguments.paymentMethod.getPaymentMethodID()#");		// Dynamic
		httpRequest.addParam(type="formfield", name="cancelURL", value=paymentMethod.getIntegration().setting('cancelURL'));
		
		var response = httpRequest.send().getPrefix();
		
		if(structKeyExists(response, "filecontent") && len(response.fileContent)) {
			var responseDataArray = listToArray(urlDecode(response.fileContent),"&");
			
			for(var item in responseDataArray){
				responseData[listFirst(item,"=")] = listRest(item,"=");
			}
		}
		
		return responseData;
	}
	
	public struct function getPaymentResponseData( required any paymentMethod, required string token ) {
		var responseData = {};
		
		var httpRequest = new http();
		httpRequest.setMethod("POST");
		if( arguments.paymentMethod.getIntegration().setting('paypalAccountSandboxFlag') ) {
			httpRequest.setUrl( variables.sandboxURL );
		} else {
			httpRequest.setUrl( variables.productionURL );
		}
		httpRequest.setPort( 443 );
		httpRequest.setTimeout( 120 );
		httpRequest.setResolveurl(false);
		
		httpRequest.addParam(type="formfield", name="method", value="getExpressCheckoutDetails");
		httpRequest.addParam(type="formfield", name="user", value=arguments.paymentMethod.getIntegration().setting('paypalAccountUser'));
		httpRequest.addParam(type="formfield", name="pwd", value=arguments.paymentMethod.getIntegration().setting('paypalAccountPassword'));
		httpRequest.addParam(type="formfield", name="signature", value=arguments.paymentMethod.getIntegration().setting('paypalAccountSignature'));									// Dynamic
		httpRequest.addParam(type="formfield", name="version", value="98.0");
		httpRequest.addParam(type="formfield", name="token", value="#arguments.token#");
		
		var response = httpRequest.send().getPrefix();
		
		if(structKeyExists(response, "filecontent") && len(response.fileContent)) {
			var responseDataArray = listToArray(urlDecode(response.fileContent),"&");
			
			for(var item in responseDataArray){
				responseData[listFirst(item,"=")] = listRest(item,"=");
			}
		}
		
		return responseData;
	}
	
}