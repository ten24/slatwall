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

component accessors="true" output="false" displayname="Stripe" implements="Slatwall.integrationServices.PaymentInterface" extends="Slatwall.integrationServices.BasePayment" {
	
	//Global variables

	public any function init(){
		return this;
	}
	
	public string function getPaymentMethodTypes() {
		return "creditCard";
	}
	
	public any function processCreditCard(required any requestBean){
		var responseBean = new Slatwall.model.transient.payment.CreditCardTransactionResponseBean();
		
		// Notes for future reference
		// inquiry, void, credit, receive, authorize, authorizeAndCharge, chargePreAuthorization, generateToken
		// Retrieve URL "#setting(apiUrl)#/#setting(apiVersion)#/charges/${chargeId}"
		// Retrieve Card Token URL "#setting(apiUrl)#/#setting(apiVersion)#/tokens/${cardTokenId}"
		
		var requestData = {};
		var responseData = {};
		
		// determine which authentication keys to use based on test mode setting
		var activePublicKey = setting("testPublicKey");
		var activeSecretKey = setting("testSecretKey");
		if (!setting("testMode"))
		{
			activePublicKey = setting("livePublicKey");
			activeSecretKey = setting("liveSecretKey");
		}
				
		if (requestBean.getTransactionType() == "generateToken")
		{
			// create charge token for future authorization or authorization and charge
			// two methods using Stripe can achieve functionality
			// either create a persistent Stripe customer with default card information attached or use a short-lived one-time single use token to represent the card
			
			var createTokenRequest = new http();
			createTokenRequest.setMethod("post");
			createTokenRequest.setCharset("utf-8");
			
			if (setting("generateTokenBehavior") == "deferred")
			{
				// automatically creates a Stripe customer and stores default credit card
				// allows card to be authorized at any time (deferred long term)
				createTokenRequest.setUrl("#setting('apiUrl')#/#setting('apiVersion')#/customers");
				createTokenRequest.addParam(type="header", name="authorization", value="bearer #activeSecretKey#");
				createTokenRequest.addParam(type="formfield", name="email", value="#requestBean.getAccountPrimaryEmailAddress()#");
				createTokenRequest.addParam(type="formfield", name="description", value="#generateDescription(requestBean)#");
			}
			else if (setting("generateTokenBehavior") == "immediate")
			{
				// creates a temporary short-lived "one-time use" token to be used for authorization (immediate near term)
				createTokenRequest.setUrl("#setting('apiUrl')#/#setting('apiVersion')#/tokens");
				createTokenRequest.addParam(type="header", name="authorization", value="bearer #activePublicKey#");
			}
			
			// attach card data to request
			populateRequestParamsWithCardInfo(requestBean, createTokenRequest);
			
			responseData = deserializeResponse(createTokenRequest.send().getPrefix());
			
			// populate response
			if (responseData.success)
			{
				responseBean.setProviderToken(responseData.result.id); // will be either tokenId or customerId depending on generateTokenBehavior
				responseBean.addMessage(messageName="stripe.id", message="#responseData.result.id#");
				responseBean.addMessage(messageName="stripe.object", message="#responseData.result.object#");
				responseBean.addMessage(messageName="stripe.livemode", message="#responseData.result.livemode#");
				if (responseData.result.object == "customer")
				{
					responseBean.addMessage(messageName="stripe.defaultcard", message="#responseData.result.default_card#");
				}
			}
			else
			{
				// error occurred
				handleResponseErrors(responseBean, responseData);
			}
		}
		else if (requestBean.getTransactionType() == "authorize" || requestBean.getTransactionType() == "authorizeAndCharge")
		{
			// authorize only or authorize and charge
			
			var authorizeChargeRequest = new http();
			authorizeChargeRequest.setMethod("post");
			authorizeChargeRequest.setCharset("utf-8");
			authorizeChargeRequest.setUrl("#setting('apiUrl')#/#setting('apiVersion')#/charges");
			
			
			if(!isNull(requestBean.getProviderToken())) {
				
				var generateTokenMethodUsed = "";
				
				// need to determine which method the provider token was generated with using either Stripe customer or single-use card token
				// inspect the token id format 
				if(refindNoCase("^cus_\S+", requestBean.getProviderToken()))
				{
					// deferred must populate customer field (default attached card will be used automatically during Stripe processing)
					generateTokenMethodUsed = "deferred";
					authorizeChargeRequest.addParam(type="formfield", name="customer", value="#requestBean.getProviderToken()#");
				}
				else if (refindNoCase("^tok_\S+", requestBean.getProviderToken()))
				{
					// immediate must populate card field
					generateTokenMethodUsed = "immediate";
					authorizeChargeRequest.addParam(type="formfield", name="card", value="#requestBean.getProviderToken()#");
				}
				else
				{
					responseBean.addError(errorName="stripe.error", errorMessage="Using invalid token");
				}	
			}
			else if (!isNull(requestBean.getCreditCardNumber()))
			{
				// attach card data to request
				populateRequestParamsWithCardInfo(requestBean, authorizeChargeRequest);
			}
			
			authorizeChargeRequest.addParam(type="header", name="authorization", value="bearer #activeSecretKey#");
			authorizeChargeRequest.addParam(type="formfield", name="description", value="#generateDescription(requestBean)#");
			authorizeChargeRequest.addParam(type="formfield", name="currency", value="#requestBean.getTransactionCurrency()#");
			authorizeChargeRequest.addParam(type="formfield", name="amount", value="#int(requestBean.getTransactionAmount() * 100)#"); // amount as integer (eg. eliminate cents)
			
			if (requestBean.getTransactionType() == "authorizeAndCharge")
			{
				// authorize and charge
				authorizeChargeRequest.addParam(type="formfield", name="capture", value="true");
			}
			else
			{
				// authorize only
				authorizeChargeRequest.addParam(type="formfield", name="capture", value="false");
			}
			
			responseData = deserializeResponse(authorizeChargeRequest.send().getPrefix());
			
			// populate response
			if (responseData.success)
			{
				responseBean.setProviderToken(requestBean.getProviderToken()); // manually persist
				responseBean.setAuthorizationCode(responseData.result.id);
				responseBean.setAmountAuthorized(responseData.result.amount / 100); // need to convert back to decimal from integer
				
				// additional capture information
				if (requestBean.getTransactionType() == "authorizeAndCharge")
				{
					responseBean.setAmountCharged(responseData.result.amount / 100); // need to convert back to decimal from integer
					responseBean.setAuthorizationCodeInvalidFlag(false);
				}
				
				// add messages to response
				responseBean.addMessage(messageName="stripe.id", message="#responseData.result.id#");
				responseBean.addMessage(messageName="stripe.captured", message="#responseData.result.captured#");
				responseBean.addMessage(messageName="stripe.card", message="#responseData.result.card.id#");
				responseBean.addMessage(messageName="stripe.last4", message="#responseData.result.card.last4#");
				responseBean.addMessage(messageName="stripe.expiration", message="#responseData.result.card.exp_month#-#responseData.result.card.exp_year#");
				responseBean.addMessage(messageName="stripe.fee", message="#responseData.result.fee/100#");
				if (!isNull(responseData.result.customer))
				{
					responseBean.addMessage(messageName="stripe.customer", message="#responseData.result.customer#");
				}
			}
			else
			{
				// error occurred
				handleResponseErrors(responseBean, responseData);
			}
		}
		else if (requestBean.getTransactionType() == "chargePreAuthorization")
		{
			// capture prior authorized charge
			
			var chargeID = requestBean.getPreAuthorizationCode();
			
			var chargeRequest = new http();
			chargeRequest.setMethod("post");
			chargeRequest.setCharset("utf-8");
			chargeRequest.setUrl("#setting('apiUrl')#/#setting('apiVersion')#/charges/#chargeID#/capture");
			chargeRequest.addParam(type="header", name="authorization", value="bearer #activeSecretKey#");
			// api allows for an optional override of authorized transaction amount (amount can be lesser or equal to authorized charge but not greater)
			chargeRequest.addParam(type="formfield", name="amount", value="#int(requestBean.getTransactionAmount() * 100)#"); // amount as integer (eg. eliminate cents)
			responseData = deserializeResponse(chargeRequest.send().getPrefix());
			
			responseBean.setProviderToken(requestBean.getProviderToken()); // manually persist
			
			// populate response
			if (responseData.success)
			{
				responseBean.setAmountCharged(responseData.result.amount / 100); // need to convert back to decimal from integer
				responseBean.setAuthorizationCodeInvalidFlag(false);
				
				// add messages to response
				responseBean.addMessage(messageName="stripe.id", message="#responseData.result.id#");
				responseBean.addMessage(messageName="stripe.card", message="#responseData.result.card.id#");
				responseBean.addMessage(messageName="stripe.last4", message="#responseData.result.card.last4#");
				responseBean.addMessage(messageName="stripe.expiration", message="#responseData.result.card.exp_month#-#responseData.result.card.exp_year#");
				responseBean.addMessage(messageName="stripe.fee", message="#responseData.result.fee / 100#");
				if (!isNull(responseData.result.customer))
				{
					responseBean.addMessage(messageName="stripe.customer", message="#responseData.result.customer#");
				}
			}
			else
			{
				// error occurred
				handleResponseErrors(responseBean, responseData);
			}
		}
		else if (requestBean.getTransactionType() == "credit")
		{
			// refund charge
			
			var refundRequest = new http();
			refundRequest.setMethod("post");
			refundRequest.setCharset("utf-8");
			//refundRequest.setUrl("#setting('apiUrl')#/#setting('apiVersion')#/charges/#chargeID#/refund");
			refundRequest.addParam(type="header", name="authorization", value="bearer #activeSecretKey#");
			// response.setAmountCredited();
		}
		
		return responseBean;
	}
	
	private struct function deserializeResponse(required any httpResponse)
	{
		
		var response = {
			statusCode = arguments.httpResponse.responseheader.status_code,
			success = arguments.httpResponse.responseheader.status_code eq 200
		};
		
		// filecontent may be of type java.io.ByteArrayOutputStream
		if(isSimpleValue(arguments.httpResponse.filecontent)) {
			response.rawResponse = arguments.httpResponse.filecontent;
		}
		else {
			response.rawResponse = arguments.httpResponse.filecontent.toString("UTF-8");
		}
		
		if (response.success)
		{
			response.result = deserializeJSON(response.rawResponse);
		}
		else
		{
			// appending because "error" key is only child struct of the raw response)
			structAppend(response, deserializeJSON(response.rawResponse));
		}
		
		return response;
	}
	
	private void function populateRequestParamsWithCardInfo(required any requestBean, required any httpRequest)
	{
		httpRequest.addParam(type="formfield", name="card[number]", value="#requestBean.getCreditCardNumber()#");
		httpRequest.addParam(type="formfield", name="card[cvc]", value="#requestBean.getSecurityCode()#");
		httpRequest.addParam(type="formfield", name="card[exp_month]", value="#requestBean.getExpirationMonth()#");
		httpRequest.addParam(type="formfield", name="card[exp_year]", value="#requestBean.getExpirationYear()#");
		httpRequest.addParam(type="formfield", name="card[name]", value="#requestBean.getNameOnCreditCard()#");
		httpRequest.addParam(type="formfield", name="card[address_line1]", value="#requestBean.getBillingStreetAddress()#");	
		if(!isNull(requestBean.getBillingStreet2Address())) {
			httpRequest.addParam(type="formfield", name="card[address_line2]", value="#requestBean.getBillingStreet2Address()#");
		}
		httpRequest.addParam(type="formfield", name="card[address_city]", value="#requestBean.getBillingCity()#");
		httpRequest.addParam(type="formfield", name="card[address_state]", value="#requestBean.getBillingStateCode()#");
		httpRequest.addParam(type="formfield", name="card[address_zip]", value="#requestBean.getBillingPostalCode()#");
		httpRequest.addParam(type="formfield", name="card[address_country]", value="#requestBean.getBillingCountryCode()#");
	}
	
	private string function generateDescription(required any requestBean)
	{
		return "Created by Slatwall. AccountID: #requestBean.getAccountID()#, OrderID: #requestBean.getOrderID()#, OrderPaymentID: #requestBean.getOrderPaymentID()#, TransactionID: #requestBean.getTransactionID()#, Account Name: #requestBean.getAccountFirstName()# #requestBean.getAccountLastName()#, Primary Phone: #requestBean.getAccountPrimaryPhoneNumber()#, Primary Email #requestBean.getAccountPrimaryEmailAddress()#, Billing Name: #requestBean.getBillingName()#";
	}
	
	private void function handleResponseErrors(required any responseBean, required any responseData)
	{
		// display error and store error details
		responseBean.addError(errorName="stripe.error", errorMessage="#responseData.error.message#");
		responseBean.addMessage(messageName="stripe.error.message", message="#responseData.error.message#");
		if (!isNull(responseData.error.type))
		{
			responseBean.addMessage(messageName="stripe.error.type", message="#responseData.error.type#");
		}
		if (!isNull(responseData.error.code))
		{
			responseBean.addMessage(messageName="stripe.error.code", message="#responseData.error.code#");
		}
		if(!isNull(responseData.error.param))
		{
			responseBean.addMessage(messageName="stripe.error.param", message="#responseData.error.param#");
		}
	}
	
}

