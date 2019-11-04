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
	
	/**
	 * Method to set API Header for HTTP call
	 * @params - object paymentMethod
	 * @return http Object
	 **/
	public http function getApiHeader(required any paymentMethod)
	{
		var httpRequest = new http();
		var server_token = ToBase64(arguments.paymentMethod.getIntegration().setting('braintreeAccountToken'));
		httpRequest.setMethod("POST");
		if( arguments.paymentMethod.getIntegration().setting('braintreeAccountSandboxFlag') ) {
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
	 * Method to set client side external HTML
	 * @params - object paymentMethod
	 * @return : HTML (success)
	 * @return : empty string (fail) - Slatwall Log
	 **/
	public string function getExternalPaymentHTML( required any paymentMethod, required any order = request.slatwallScope.cart() ) {
		var returnHTML = "";
		var client_auth_token = "";
		var customerId = arguments.order.getAccount().getAccountID();
		var currency = arguments.order.getCurrencyCode();
		var merchantAccountId = arguments.paymentMethod.getIntegration().setting('braintreeAccountMerchantID');
		if( arguments.paymentMethod.getIntegration().setting('braintreeAccountSandboxFlag') ) {
			var client_payment_mode="sandbox";
		} else {
			var client_payment_mode="production";
		}
		var cart_amount = arguments.order.getTotal();
		
		var httpRequest = getApiHeader(paymentMethod = arguments.paymentMethod);
		var payload = { "query" : "mutation ClientToken($input: CreateClientTokenInput) { createClientToken(input: $input) { clientToken } }",
			"variables" : { "clientToken": { "merchantAccountId": "#merchantAccountId#", "customerId": "#customerId#" } }
		};
		httpRequest.addParam(type="body",value=SerializeJson(payload));
		
		var response = httpRequest.send().getPrefix();
		
		if (IsJSON(response.FileContent))
		{
			var fileContent = DeserializeJSON(response.FileContent);
			if (structKeyExists(fileContent, 'errors')){
				writeLog(fileContent);
				return "";
			}
			else{
				client_auth_token = fileContent.data.createClientToken.clientToken;
			}
		}
		
		savecontent variable="returnHTML" {
			include "views/main/externalpayment.cfm";
		};
		return returnHTML;
	}
	
	/**
	 * Method to authenticate payment token
	 * @params : paymentMethod
	 * @params : string token
	 * @return : custom Object
	 **/
	public any function authorizePayment( required any paymentMethod, required string token) {
		var responseData = {};

		var httpRequest = getApiHeader(paymentMethod = arguments.paymentMethod);
		var payload = { "query" : "mutation VaultWithTypeFragment($input: VaultPaymentMethodInput!) { vaultPaymentMethod(input: $input) {paymentMethod { id usage details {__typename}}verification {status} } }",
			"variables" : { "input": { "paymentMethodId": "#arguments.token#" } }
		};
		httpRequest.addParam(type="body",value=SerializeJson(payload));
		var response = httpRequest.send().getPrefix();
		if (IsJSON(response.FileContent))
		{
			var fileContent = DeserializeJSON(response.FileContent);
			if (structKeyExists(fileContent, 'errors')){
				//to be reviewed
				responseData['status'] = "failure";
				responseData['ERROR'] = fileContent;
			}
			else{
				responseData['status'] = "success";
				responseData['token'] = fileContent.data.vaultPaymentMethod.paymentMethod.id;
			}
		}

		return responseData;
	}
	
	/**
	 * Method to charge Braintree Account / Create Transaction
	 * @params : paymentMethod
	 * @params : order object
	 * @return : custom object
	 **/
	public any function createTransaction(required any paymentMethod, any order = request.slatwallScope.cart() )
	{
		var responseData = {};
		//Create Transaction
		var httpRequest = getApiHeader(paymentMethod = arguments.paymentMethod);
		var item_payload = {};
		var discount = 0;
		
		//Populate line order items
		for( var i=1; i <= arrayLen(arguments.order.getOrderItems()); ++i){
			var orderItem = arguments.order.getOrderItems()[i];
			//don't run this logic for child order items.
			if (isNull(orderItem.getParentOrderItem())){
				
				//if this is a product bundle orderitem, send the product bundle price
				if(!isNull(orderItem.getChildOrderItems()) && arrayLen(orderItem.getChildOrderItems())){
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
		
		//writeDump(item_payload);
		// define discount
		if(arguments.order.getDiscountTotal() > 0){
			discount += arguments.order.getOrderAndItemDiscountAmountTotal();
		}

		var itemSubTotal = arguments.order.getSubTotalAfterItemDiscounts();
		if(arguments.order.getOrderDiscountAmountTotal() > 0){
			itemSubTotal -= arguments.order.getOrderDiscountAmountTotal();
		}

		var total = arguments.order.getTotal(); 
		
		if(arguments.order.hasGiftCardOrderPaymentAmount()){
			discount += arguments.order.getGiftCardOrderPaymentAmount();
			itemSubTotal -= arguments.order.getGiftCardOrderPaymentAmount();
			total -= arguments.order.getGiftCardOrderPaymentAmount(); 
		}	
		
		var client_token = this.getAccountPaymentToken(arguments.order.getAccount(), arguments.paymentMethod);
		
		//Formatting total to be 2 decimal places
		total = NumberFormat(total, "0.00");
		
		//request payload
		var payload = { "query" : "mutation CaptureTransaction($input: ChargePaymentMethodInput!) { chargePaymentMethod(input: $input) { transaction { id status } } }",
			"variables" : { "input": { "paymentMethodId": "#client_token#", "transaction" : { 
				"amount" : '#total#',
				"orderId" : "#arguments.order.getOrderID()#",
				'discountAmount' : '#discount#',
				'shipping' : { 'shippingAmount': '#arguments.order.getfulfillmentChargeAfterDiscountTotal()#' },
				'tax' : { 'taxAmount': '#arguments.order.getTaxTotal()#' },
				'lineItems' : item_payload,
			} } }
		};
		
		httpRequest.addParam(type="body",value=SerializeJson(payload));
		var response = httpRequest.send().getPrefix();
		
		if (IsJSON(response.FileContent))
		{
			var fileContent = DeserializeJSON(response.FileContent);
			if (
				structKeyExists(fileContent, 'data') && 
				structKeyExists(fileContent.data, 'chargePaymentMethod') && 
				structKeyExists(fileContent.data.chargePaymentMethod, 'transaction') && 
				structKeyExists(fileContent.data.chargePaymentMethod.transaction, 'status') 
				&& fileContent.data.chargePaymentMethod.transaction.status == "SETTLING"
				)
			{
				responseData['status'] = "success";
				responseData['transactionID'] = fileContent.data.chargePaymentMethod.transaction.id;
				responseData['amount'] = total;
			}
			else{
				responseData['status'] = "failure";
				responseData['ERROR'] = fileContent;
			}
		}
		
		return responseData;
	}
	
	/**
	 * Method to refund Transaction
	 * @params : paymentMethod
	 * @params : order object
	 * @return : custom object
	 **/
	public any function refundTransaction(required any paymentMethod, required string transactionId )
	{
		var responseData = {};
		
		var httpRequest = getApiHeader(paymentMethod = arguments.paymentMethod);
		
		
		var payload = { "query" : "mutation RefundTransaction($input: RefundTransactionInput!) { refundTransaction(input: $input) { refund { id amount { value } orderId status refundedTransaction { id amount { value } orderId status } } } }",
			"variables" : {"input" : { "transactionId" : "#arguments.transactionId#" } }, };
		
		httpRequest.addParam(type="body",value=SerializeJson(payload));
		var response = httpRequest.send().getPrefix();
		
		if (IsJSON(response.FileContent))
		{
			var fileContent = DeserializeJSON(response.FileContent);
			if (
				structKeyExists(fileContent, 'data') && 
				structKeyExists(fileContent.data, 'refundTransaction') && 
				structKeyExists(fileContent.data.refundTransaction, 'refund') && 
				structKeyExists(fileContent.data.refundTransaction.refund, 'status') 
				&& fileContent.data.refundTransaction.refund.status == "SETTLING"
				)
			{
				responseData['status'] = "success";
				responseData['transactionID'] = fileContent.data.refundTransaction.refund.id;
				responseData['amount'] = fileContent.data.refundTransaction.refund.amount;
			}
			else{
				responseData['status'] = "failure";
				responseData['ERROR'] = fileContent;
			}
		}
		
		return responseData;
	}
	
	/**
	 * Process external
	 **/
	public any function processExternal( required any requestBean ){
		
		// Execute request
		var responseBean = getTransient('ExternalTransactionResponseBean');
		
		if (arguments.requestBean.getTransactionType() == "authorizeAndCharge" || arguments.requestBean.getTransactionType() == "chargePreAuthorization" || arguments.requestBean.getTransactionType() == "receive") { //admin triggers payment or schedule order
			//writeDump(var = arguments.requestBean.getOrderPayment(), top = 3); abort;
			var response = this.createTransaction(arguments.requestBean.getAccountPaymentMethod(), arguments.requestBean.getOrder());
			if(structKeyExists(response, "status") && response.status == "success")
			{
				arguments.responseBean.setProviderTransactionID(response.transactionID);
				arguments.responseBean.setAmountAuthorized(response.amount);
				arguments.responseBean.setAmountReceived(response.amount);
			}
			else{
				responseBean.addError("Processing error", response);
			}
			
		} else if (arguments.requestBean.getTransactionType() == "credit") { //REFUND
			
			var response = this.refundTransaction(arguments.requestBean.getAccountPaymentMethod(), arguments.requestBean.getTransactionID());
			//setup transaction id from refund	
			//setup amount credited
			if(structKeyExists(respose, "status") && respose.status == "success")
			{
				arguments.responseBean.setProviderTransactionID(response.transactionID);
				arguments.responseBean.setAmountCredited(respose.amount);
			}
			else{
				responseBean.addError("Processing error", response);
			}
			
		} else {
			responseBean.addError("Processing error", "Paypal Braintree Payment Integration has not been implemented to handle #arguments.requestBean.getTransactionType()#");
		}
		return responseBean;
	}
	
	/**
	 * Method to assign payment method against customer Account
	 * @params : paymentMethod
	 * @params : string token
	 * @params : account
	 * @return : void
	 **/
	public void function configureAccountPaymentMethod(required any token, required any account, required any paymentMethod)
	{
        var provideToken = arguments.token;
        var query = new Query();
		query.setSQL("SELECT max(accountPaymentMethodID) as storedMethod FROM swaccountpaymentmethod WHERE accountID='#arguments.account.getAccountID()#' AND paymentMethodID='#arguments.paymentMethod.getPaymentMethodID()#'");
		var queryResult = query.execute();
		var check = queryResult.getResult().getRow(1);
		
		//Check if Payment Method already exists
        if( check.storedMethod != '')
        {
        	//Get Existing Method
            var accountPaymentMethod = getService('AccountService').getAccountPaymentMethodByAccountPaymentMethodID(check.storedMethod);
        }
        else{
        	//Create a New One
            var accountPaymentMethod = getService('AccountService').newAccountPaymentMethod();
        }
        
        accountPaymentMethod.setProviderToken(provideToken);
        accountPaymentMethod.setAccount( arguments.account );
        accountPaymentMethod.setAccountPaymentMethodName("Paypal");
        accountPaymentMethod.setPaymentMethod(arguments.paymentMethod);
        //Save method in account.
        getService('AccountService').saveAccountPaymentMethod(accountPaymentMethod);
	}
	
	/**
	 * Method to assign provide token
	 * @params : paymentMethod
	 * @params : account
	 * @return : String
	 **/
	public string function getAccountPaymentToken(required any account, required any paymentMethod)
	{
		var query = new Query();
		query.setSQL("SELECT max(accountPaymentMethodID) as storedMethod FROM swaccountpaymentmethod WHERE accountID='#arguments.account.getAccountID()#' AND paymentMethodID='#arguments.paymentMethod.getPaymentMethodID()#'");
		var queryResult = query.execute();
		var check = queryResult.getResult().getRow(1);
		var token = "";
		//Check if Payment Method already exists
        if( check.storedMethod != '')
        {
        	var accountPaymentMethod = getService('AccountService').getAccountPaymentMethodByAccountPaymentMethodID(check.storedMethod);
        	
        	return accountPaymentMethod.getProviderToken();
        }
        
        return "";
	}
	
}