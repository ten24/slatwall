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
		var paymentMethod = orderPayment.getPaymentMethod();		
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

		// order params
		httpRequest.addParam(type="formfield", name="PAYMENTREQUEST_0_PAYMENTACTION", value="SALE");
		httpRequest.addParam(type="formfield", name="PAYMENTREQUEST_0_AMT", value="#orderPayment.getAmount()#");
		httpRequest.addParam(type="formfield", name="PAYMENTREQUEST_0_CURRENCYCODE", value="#orderPayment.getCurrencyCode()#");
		httpRequest.addParam(type="formfield", name="PAYERID", value="#listLast(orderPayment.getProviderToken(), "~")#");
		httpRequest.addParam(type="formfield", name="token", value="#listFirst(orderPayment.getProviderToken(), "~")#");
		
		httpRequest.addParam(type="formfield", name="BUTTONSOURCE", value="SlatWall_SP");
		
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

		// Check to see if it was successful (Success or SuccessWithWarning)
		if( !findNoCase("success",responseData.ack) ) {
			// Transaction did not go through
			response.addError(responseData.L_ERRORCODE0, responseData.L_LONGMESSAGE0);
		} else {
			response.setAmountReceived( responseData.PAYMENTINFO_0_AMT );
			response.setTransactionID( responseData.CORRELATIONID );
			response.setAuthorizationCode( responseData.TOKEN );
			response.setSecurityCodeMatchFlag( true );
			response.setAVSCode( "Y" );
		}
		
		return response;
	}
	
	public struct function getInitiatePaymentData( required any paymentMethod, required any order ) {
		var responseData = {};
		var returnURL = paymentMethod.getIntegration().setting('externalPaymentReturnURL');
		
		if(findNoCase("?", returnURL)) {
			var returnURL &= "&slatAction=paypalexpress:main.processResponse";	
		} else {
			var returnURL &= "?slatAction=paypalexpress:main.processResponse";
		}
		var returnURL &= "&paymentMethodID=#arguments.paymentMethod.getPaymentMethodID()#";
		
		
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
		httpRequest.addParam(type="formfield", name="user", value=arguments.paymentMethod.getIntegration().setting('paypalAccountUser'));
		httpRequest.addParam(type="formfield", name="pwd", value=arguments.paymentMethod.getIntegration().setting('paypalAccountPassword'));
		httpRequest.addParam(type="formfield", name="signature", value=arguments.paymentMethod.getIntegration().setting('paypalAccountSignature'));
		httpRequest.addParam(type="formfield", name="version", value="98.0");

		// line items - don't send child orderitems as lineitems because the sum amount of line items will not match the order total.
		for( var i=1; i <= arrayLen(arguments.order.getOrderItems()); ++i){
			var orderItem = arguments.order.getOrderItems()[i];
			
			//don't run this logic for child order items.
			if (isNull(orderItem.getParentOrderItem())){
					
				httpRequest.addParam(type="formfield", name="L_PAYMENTREQUEST_0_NAME#i-1#", value="#orderItem.getSku().getProduct().getTitle()#");
				httpRequest.addParam(type="formfield", name="L_PAYMENTREQUEST_0_NUMBER#i-1#", value="#orderItem.getSku().getSkuCode()#");
				
				//if this is a product bundle orderitem, send the product bundle price
				if(!isNull(orderItem.getChildOrderItems()) && arrayLen(orderItem.getChildOrderItems())){
					httpRequest.addParam(type="formfield", name="L_PAYMENTREQUEST_0_AMT#i-1#", value="#orderItem.getProductBundlePrice()#");
				//send the regular orderitem price.
				} else {
					httpRequest.addParam(type="formfield", name="L_PAYMENTREQUEST_0_AMT#i-1#", value="#orderItem.getPrice()#");
				}
				httpRequest.addParam(type="formfield", name="L_PAYMENTREQUEST_0_QTY#i-1#", value="#orderItem.getQuantity()#");
			}
		}
		
		// add a line item for discount
		if(arguments.order.getDiscountTotal() > 0){
			httpRequest.addParam(type="formfield", name="L_PAYMENTREQUEST_0_NAME#i#", value="Discount");
			httpRequest.addParam(type="formfield", name="L_PAYMENTREQUEST_0_NUMBER#i#", value="DISCOUNT");
			httpRequest.addParam(type="formfield", name="L_PAYMENTREQUEST_0_AMT#i#", value="-#arguments.order.getDiscountTotal()#");
			httpRequest.addParam(type="formfield", name="L_PAYMENTREQUEST_0_QTY#i#", value="1");
		}

		var itemSubTotal = arguments.order.getSubTotalAfterItemDiscounts();
		if(arguments.order.getOrderDiscountAmountTotal() > 0){
			itemSubTotal -= arguments.order.getOrderDiscountAmountTotal();
		} 

		var total = arguments.order.getTotal(); 
		
		if(arguments.order.hasGiftCardOrderPaymentAmount()){
			i++; 
			httpRequest.addParam(type="formfield", name="L_PAYMENTREQUEST_0_NAME#i#", value="Gift Card Payment");
			httpRequest.addParam(type="formfield", name="L_PAYMENTREQUEST_0_NUMBER#i#", value="DISCOUNT");
			httpRequest.addParam(type="formfield", name="L_PAYMENTREQUEST_0_AMT#i#", value="-#arguments.order.getGiftCardOrderPaymentAmount()#");
			httpRequest.addParam(type="formfield", name="L_PAYMENTREQUEST_0_QTY#i#", value="1");
			itemSubTotal -= arguments.order.getGiftCardOrderPaymentAmount();
			total -= arguments.order.getGiftCardOrderPaymentAmount(); 
		}	
		
		// cart totals
		httpRequest.addParam(type="formfield", name="PAYMENTREQUEST_0_PAYMENTACTION", value="SALE");
		httpRequest.addParam(type="formfield", name="PAYMENTREQUEST_0_ITEMAMT", value="#itemSubTotal#");
		httpRequest.addParam(type="formfield", name="PAYMENTREQUEST_0_TAXAMT", value="#arguments.order.getTaxTotal()#");
		httpRequest.addParam(type="formfield", name="PAYMENTREQUEST_0_SHIPPINGAMT", value="#arguments.order.getfulfillmentChargeAfterDiscountTotal()#");
		httpRequest.addParam(type="formfield", name="PAYMENTREQUEST_0_AMT", value="#total#");
		httpRequest.addParam(type="formfield", name="PAYMENTREQUEST_0_CURRENCYCODE", value="#arguments.order.getCurrencyCode()#");
		
		//httpRequest.addParam(type="formfield", name="noShipping", value="0");
		httpRequest.addParam(type="formfield", name="allowNote", value="0");
		httpRequest.addParam(type="formfield", name="hdrImg", value=arguments.paymentMethod.getIntegration().setting('paypalHeaderImage'));
		
		if (!isNull(arguments.order) && !isNull(arguments.order.getAccount()) && !isNull(arguments.order.getAccount().getEmailAddress())){
 			httpRequest.addParam(type="formfield", name="email", value=arguments.order.getAccount().getEmailAddress());
 		}
		
		httpRequest.addParam(type="formfield", name="returnURL", value="#returnURL#");
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