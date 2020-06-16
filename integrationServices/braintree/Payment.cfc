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
    
    Braintree Docs : https://graphql.braintreepayments.com/
*/

component accessors="true" output="false" implements="Slatwall.integrationServices.PaymentInterface" extends="Slatwall.integrationServices.BasePayment" {

	variables.sandboxURL = "https://payments.sandbox.braintree-api.com/graphql";
	variables.productionURL = "https://payments.braintree-api.com/graphql";

	/**
	 * Method to set payment method type
	 * @params - none
	 * @return string payment type
	 **/
	public string function getPaymentMethodTypes() {
		return "external";
	}

	// Override allow site settings
	public any function setting(required any requestBean) {
		// Allows settings to be requested in the context of the site where the order was created
		if (!isNull(arguments.requestBean.getOrder()) && !isNull(arguments.requestBean.getOrder().getOrderCreatedSite()) && !arguments.requestBean.getOrder().getOrderCreatedSite().getNewFlag()) {
			arguments.filterEntities = [arguments.requestBean.getOrder().getOrderCreatedSite()];
		} else if (!isNull(arguments.requestBean.getAccount()) && !isNull(arguments.requestBean.getAccount().getAccountCreatedSite())) {
			arguments.filterEntities = [arguments.requestBean.getAccount().getAccountCreatedSite()];
		}

		return super.setting(argumentCollection=arguments);
	}

	/**
	 * Method to set API Header for HTTP call
	 * @params - object paymentMethod
	 * @return http Object
	 **/
	public http function getApiHeader(required any requestBean)
	{
		var httpRequest = new http();
		var server_token = ToBase64(setting(settingName='braintreeAccountToken', requestBean=arguments.requestBean));
		httpRequest.setMethod("POST");
		if( setting(settingName='braintreeAccountSandboxFlag', requestBean=arguments.requestBean) ) {
			httpRequest.setUrl( variables.sandboxURL );
		} else {
			httpRequest.setUrl( variables.productionURL );
		}
		httpRequest.setPort( 443 );
		httpRequest.setTimeout( 120 );
		httpRequest.setResolveurl(false);
		httpRequest.addParam(type="header", name="Content-Type", value="application/json");
		httpRequest.addParam(type="header", name="Authorization", value="Basic #server_token#");
		httpRequest.addParam(type="header", name="Braintree-Version", value="2019-01-01");
		httpRequest.setMethod("POST");

		return httpRequest;
	}


	/**
	 * Process external
	 **/
	public any function processExternal( required any requestBean ){
		// Execute request
		var responseBean = getTransient('ExternalTransactionResponseBean');

		// Set default currency
		 if (isNull(arguments.requestBean.getTransactionCurrencyCode()) || !len(arguments.requestBean.getTransactionCurrencyCode())) {
		 	arguments.requestBean.setTransactionCurrencyCode(setting(settingName='skuCurrency', requestBean=arguments.requestBean));
		 }

		switch(arguments.requestBean.getTransactionType()) {
			case 'authorize':
				sendRequestToAuthorize(arguments.requestBean, responseBean);
				break;
			case 'receive':
			case 'authorizeAndCharge':
			case 'chargePreAuthorization':
				createTransaction(arguments.requestBean, responseBean);
				break;
			case 'authorizeAccount':
				authorizeAccount(arguments.requestBean, responseBean);
				break;
			case 'authorizePayment':
				authorizePayment(arguments.requestBean, responseBean);
				break;
			case 'externalHTML':
				return getExternalPaymentHTML(arguments.requestBean, responseBean);
				break;
			case 'credit':
				refundTransaction(arguments.requestBean, responseBean);
				break;
			default:
				responseBean.addError("Processing error", "This Integration has not been implemented to handle #arguments.requestBean.getTransactionType()#");
		}

		return responseBean;
	}
    
    /**
	 * Method to authorize client account
	 * @params - requestBean
	 * @params - responseBean
	 * @return : none
	 **/
	private any function authorizeAccount(required any requestBean, required any responseBean) {
		var merchantAccountId = setting(settingName='braintreeAccountMerchantID', requestBean=arguments.requestBean);

		var httpRequest = getApiHeader(requestBean = arguments.requestBean);
		var payload = { "query" : "mutation ClientToken($input: CreateClientTokenInput) { createClientToken(input: $input) { clientToken } }",
			"variables" : { "input": { "clientToken": { "merchantAccountId": "#merchantAccountId#" } } }
		};
		
		httpRequest.addParam(type="body",value=SerializeJson(payload));
		var response = httpRequest.send().getPrefix();

		if (!IsJSON(response.FileContent)) {
		    arguments.responseBean.addError("Processing Error","Error in authorizing the Account.");
		}
		else{
		    var fileContent = DeserializeJSON(response.FileContent);
			if (structKeyExists(fileContent, 'errors')) {
				arguments.responseBean.addError("Processing Error","Error in authorizing the Account.");
			}
			else{
				arguments.responseBean.setAuthorizationCode(fileContent.data.createClientToken.clientToken);
			}
		}
	}

	/**
	 * Method to set client side external HTML
	 * @params - requestBean
	 * @params - responseBean
	 * @return : HTML (on success)
	 **/
	private any function getExternalPaymentHTML( required any requestBean, required any responseBean ) {
		authorizeAccount(arguments.requestBean, arguments.responseBean);

		if(arguments.responseBean.hasErrors()) {
			return;
		}

		if (isNull(arguments.responseBean.getAuthorizationCode()) || !len( trim(arguments.responseBean.getAuthorizationCode())) ) {
			arguments.responseBean.addError("Processing error", "Error attempting to authorize. Review Authorization Code.");
			return;
		}

		if ( isNull(arguments.requestBean.getTransactionCurrencyCode()) 
		    || !len(arguments.requestBean.getTransactionCurrencyCode()) 
		        || isNull(arguments.requestBean.getTransactionAmount()) 
		            ||!len(arguments.requestBean.getTransactionAmount()) ) {
			arguments.responseBean.addError("Processing error", "Error in processing Transaction. please check transction request.");
			return;
		}

		var returnHTML = "";
		var clientAuthToken = arguments.responseBean.getAuthorizationCode();
		var currency = arguments.requestBean.getTransactionCurrencyCode();
		var transactionAmount = LSParseNumber(arguments.requestBean.getTransactionAmount());

		if( setting(settingName='braintreeAccountSandboxFlag', requestBean=arguments.requestBean)) {
			var clientPaymentMode="sandbox";
		} else {
			var clientPaymentMode="production";
		}

		savecontent variable="returnHTML" {
			include "views/main/externalpayment.cfm";
		};

		return returnHTML;
	}

	/**
	 * Method to authenticate payment token
	 * @params - requestBean
	 * @params - responseBean
	 * @return : custom Object
	 **/
	public any function authorizePayment( required any requestBean, required any responseBean) {
		if (isNull(arguments.requestBean.getProviderToken()) || !len( trim(arguments.requestBean.getProviderToken())) ) {
			arguments.responseBean.addError("Processing error", "Error attempting to authorize. Review providerToken.");
			return;
		}

		var httpRequest = getApiHeader(requestBean = arguments.requestBean);

		var payload = { "query" : "mutation VaultWithTypeFragment($input: VaultPaymentMethodInput!) { vaultPaymentMethod(input: $input) {paymentMethod { id usage details {__typename}}verification {status} } }",
			"variables" : { "input": { "paymentMethodId": "#arguments.requestBean.getProviderToken()#" } }
		};
		httpRequest.addParam(type="body",value=SerializeJson(payload));
		var response = httpRequest.send().getPrefix();
		if ( !IsJSON(response.FileContent) ) {
		    arguments.responseBean.addError("Processing error", "Error attempting to authorize.");
		}
		else{
			var fileContent = DeserializeJSON(response.FileContent);
			if (structKeyExists(fileContent, 'errors')) {
				arguments.responseBean.addError("Processing error", "Error attempting to authorize.");
			}
			else{
				arguments.responseBean.setProviderToken(fileContent.data.vaultPaymentMethod.paymentMethod.id);
			}
		}
	}

	/**
	 * Method to charge Braintree Account / Create Transaction
	 * @params - requestBean
	 * @params - responseBean
	 * @return : none
	 **/
	public any function createTransaction(required any requestBean, required any responseBean) {
		if(arguments.responseBean.hasErrors()){
			return;
		}

		if (isNull(arguments.requestBean.getProviderToken()) || !len( trim(arguments.requestBean.getProviderToken())) ) {
			arguments.responseBean.addError("Processing error", "Error attempting to authorize. Review providerToken.");
			return;
		}

		var responseData = {};
		//Create Transaction
		var httpRequest = getApiHeader(requestBean = arguments.requestBean);
		var item_payload = [];
		var discount = 0;

		//Populate line order items
		for( var i=1; i <= arrayLen(arguments.requestBean.getOrder().getOrderItems()); ++i) {
			var orderItem = arguments.requestBean.getOrder().getOrderItems()[i];
			//don't run this logic for child order items.
			if (isNull(orderItem.getParentOrderItem())) {

				//if this is a product bundle orderitem, send the product bundle price
				if(!isNull(orderItem.getChildOrderItems()) && arrayLen(orderItem.getChildOrderItems())) {
					var unitAmount = orderItem.getProductBundlePrice();
				//send the regular orderitem price.
				} else {
					var unitAmount = orderItem.getPrice();
				}

				 item_payload.append({
					'name' : '#orderItem.getSku().getProduct().getTitle()#',
					'kind' : 'DEBIT',
					'quantity' : '#orderItem.getQuantity()#',
					'unitAmount' : '#unitAmount#',
					'productCode' : '#orderItem.getSku().getSkuCode()#',
					"totalAmount" : "#(orderItem.getQuantity() * unitAmount)#"
				});

			}
		}

		// define discount
		if(arguments.requestBean.getOrder().getDiscountTotal() > 0) {
			discount += arguments.requestBean.getOrder().getDiscountTotal();
			
			item_payload.append({
					'name' : 'Discount',
					'kind' : 'CREDIT',
					'quantity' : '1',
					'unitAmount' : '#arguments.requestBean.getOrder().getDiscountTotal()#',
					'productCode' : '',
					"totalAmount" : "#arguments.requestBean.getOrder().getDiscountTotal()#"
			});
		}
		
		if(arguments.requestBean.getOrder().hasGiftCardOrderPaymentAmount()) {
			discount += arguments.requestBean.getOrder().getGiftCardOrderPaymentAmount();
			
			item_payload.append({
					'name' : 'Gift Card Payment',
					'kind' : 'CREDIT',
					'quantity' : '1',
					'unitAmount' : '#arguments.requestBean.getOrder().getGiftCardOrderPaymentAmount()#',
					'productCode' : '',
					"totalAmount" : "#arguments.requestBean.getOrder().getGiftCardOrderPaymentAmount()#"
			});
		}

		var total = arguments.requestBean.getOrder().getTotal();

		var client_token = arguments.requestBean.getProviderToken();

		//Formatting total to be 2 decimal places
		total = NumberFormat(total, "0.00");
		
		//Populate shipping address if orderFulFillment exits
		var orderFulfillment = arguments.requestBean.getOrder().getOrderFulfillments();
		var shippingAddress = {};
		
	    if(arrayLen(orderFulfillment) && !isNull(orderFulfillment[1])) {
	        
	        var cartShippingAddress = orderFulfillment[1].getShippingAddress();
	        if(!isNull(cartShippingAddress)) {
	        	//Get 3Digit Country Code
		        var countryCode = getHibachiScope().getService("addressService").getCountry(cartShippingAddress.getCountryCode());
		        if(!isNull(countryCode)) {
		        	countryCode = countryCode.getCountryCode3Digit();
		        }
		        
		        
		        shippingAddress = {
		            "postalCode" : "#cartShippingAddress.getPostalCode()#",
		            "countryCode" : "#countryCode#",
		            "streetAddress" : "#cartShippingAddress.getStreetAddress()#",
		            "firstName" : "#cartShippingAddress.getFirstName()#",
		            "lastName" : "#cartShippingAddress.getLastName()#",
		            "locality" : "#cartShippingAddress.getCity()#",
		            "extendedAddress" : "#cartShippingAddress.getStreet2Address()#",
		            "region" : "#cartShippingAddress.getStateCode()#"
		        };	
	        }
	    }
	    
	    var merchantAccountId = setting(settingName='braintreeAccountMerchantID', requestBean=arguments.requestBean);

		//request payload
		var payload = { "query" : "mutation ChargePaymentMethod($input: ChargePaymentMethodInput!) { chargePaymentMethod(input: $input) { transaction { id status paymentMethodSnapshot {...on PayPalTransactionDetails { authorizationId captureId payer { email payerId firstName lastName } } } } } }",
			"variables" : { "input": { "paymentMethodId": "#client_token#", "transaction" : { 
				"amount" : '#total#',
				"merchantAccountId" : "#merchantAccountId#",
				"orderId" : "#arguments.requestBean.getOrder().getOrderNumber()#",
				'discountAmount' : '#discount#',
				'shipping' : { 
					'shippingAmount': '#arguments.requestBean.getOrder().getFulfillmentChargeTotal()#',
					'shippingAddress' : shippingAddress
				},
				'tax' : { 'taxAmount': '#arguments.requestBean.getOrder().getTaxTotal()#' },
				'lineItems' : item_payload,
			} } }
		};

		httpRequest.addParam(type="body",value=SerializeJson(payload));
		var response = httpRequest.send().getPrefix();
		if ( !IsJSON(response.FileContent)) {
		    responseBean.addError("Processing error", "Not able to process this request. Invalid response.");
		}
		else {
			var fileContent = DeserializeJSON(response.FileContent);
			if (
				structKeyExists(fileContent, 'data') && 
				structKeyExists(fileContent.data, 'chargePaymentMethod') && 
				structKeyExists(fileContent.data.chargePaymentMethod, 'transaction') && 
				structKeyExists(fileContent.data.chargePaymentMethod.transaction, 'status') 
				&& fileContent.data.chargePaymentMethod.transaction.status == "SETTLING"
				) {

				arguments.responseBean.setProviderTransactionID(fileContent.data.chargePaymentMethod.transaction.id);
				arguments.responseBean.setAmountAuthorized(total);
				arguments.responseBean.setAmountReceived(total);
				if(
					structKeyExists(fileContent.data.chargePaymentMethod.transaction, 'paymentMethodSnapshot')
					&& structKeyExists(fileContent.data.chargePaymentMethod.transaction.paymentMethodSnapshot, 'captureId')
				){
					arguments.responseBean.setReferenceNumber(fileContent.data.chargePaymentMethod.transaction.paymentMethodSnapshot.captureId);
				}
			}
			else{
				responseBean.addError("Processing error", "Not able to process this request.");
				//responseBean.addError("Processing error", "Not able to process this request. #SerializeJson(payload)# =====XXXXXX===== #SerializeJson(response)# =====XXXXXX===== #SerializeJson(shippingAddress)#");
			}
		}
	}

	/**
	 * Method to refund Transaction
	 * @params - requestBean
	 * @params - responseBean
	 * @return : none
	 **/
	public any function refundTransaction(required any requestBean, required any responseBean) {
		if(arguments.responseBean.hasErrors()) {
			return;
		}
		
		if (isNull(arguments.requestBean.getOriginalProviderTransactionID()) || !len( trim( arguments.requestBean.getOriginalProviderTransactionID())) ) {
			arguments.responseBean.addError("Processing error", "Not able to process this request. Missing provider transaction ID.");
			return;
		}
	    
		var responseData = {};
		
		var httpRequest = getApiHeader(requestBean = arguments.requestBean);
		var amount = arguments.requestBean.getTransactionAmount();
		var payload = { "query" : "mutation RefundTransaction($input: RefundTransactionInput!) { refundTransaction(input: $input) { refund { id amount { value } orderId status refundedTransaction { id amount { value } orderId status } } } }",
			"variables" : {"input" : { "transactionId" : "#arguments.requestBean.getOriginalProviderTransactionID()#", "refund": { "amount" : "#amount#", "orderId" : "#arguments.requestBean.getOrder().getOrderNumber()#"  } } }, };
		
		
		httpRequest.addParam(type="body",value=SerializeJson(payload));
		var response = httpRequest.send().getPrefix();

		if ( !IsJSON(response.FileContent) ) {
		    
		    responseBean.addError("Processing error", "Not able to process this request. Invalid response.");
		    
		} else {
		    
			var fileContent = DeserializeJSON(response.FileContent);
			if (
				structKeyExists(fileContent, 'data') && 
				structKeyExists(fileContent.data, 'refundTransaction') && 
				structKeyExists(fileContent.data.refundTransaction, 'refund') && 
				structKeyExists(fileContent.data.refundTransaction.refund, 'status') 
				&& fileContent.data.refundTransaction.refund.status == "SETTLING"
				) {
					
				//var amount = fileContent.data.refundTransaction.refund.amount.value;
				arguments.responseBean.setProviderTransactionID(fileContent.data.refundTransaction.refund.id);
				arguments.responseBean.setAmountAuthorized(amount);
				arguments.responseBean.setAmountCredited(amount);
			}
			else{
				responseBean.addError("Processing error", "Not able to process this request.");
				//responseBean.addError("Processing error", "Not able to process this request. #SerializeJson(arguments.requestBean)# ======== #SerializeJson(payload)# ======== #SerializeJson(fileContent)# ");
			}
		}
	}

} 