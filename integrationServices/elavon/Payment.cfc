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

component accessors="true" output="false" displayname="Elavon" implements="Slatwall.integrationServices.PaymentInterface" extends="Slatwall.integrationServices.BasePayment" {
	
	//Global variables
	variables.timeout = 45;
	variables.responseDelimiter = chr(13) & chr(10);
	variables.transactionCodes = {};

	public any function init(){
		// Set Defaults
		variables.transactionCodes = {
			authorize="ccauthonly",
			authorizeAndCharge="ccsale",
			chargePreAuthorization="ccforce",
			credit="cccredit",
			void="ccvoid",
			inquiry="ccverify",
			generateToken="ccgettoken"
		};
		
		return this;
	}
	
	public string function getPaymentMethodTypes() {
		return "creditCard";
	}
	
	public any function processCreditCard(required any requestBean){
		var requestData = getRequestData(requestBean);
		var rawResponse = postRequest(requestData);
		if(arguments.requestBean.getTransactionType() eq "void"){
			response = postRequest(requestData, "PUT");
		}
		return getResponseBean(rawResponse, requestData, requestBean);
	}
	
	private struct function getRequestData(required any requestBean){
		var requestData = {};
		requestData["ssl_show_form"] = "false";
		requestData["ssl_result_format"] = "ASCII";
		requestData["ssl_transaction_type"] = variables.transactionCodes[arguments.requestBean.getTransactionType()];
		requestData["ssl_merchant_id"] = setting('merchantID');
		requestData["ssl_user_id"] = setting('userID');
		requestData["ssl_pin"] = getPin(requestBean);
		
		if (!isNull(requestBean.getOrder())){
			requestData["ssl_invoice_number"] = requestBean.getOrder().getShortReferenceID( true );
 		}
		
		if(len(requestBean.getCreditCardNumber())) {
			requestData["ssl_card_number"] = requestBean.getCreditCardNumber();
			requestData["ssl_exp_date"] = "#numberFormat(Left(requestBean.getExpirationMonth(),2),'00')##Right(requestBean.getExpirationYear(),2)#";
			requestData["ssl_add_token"] = "Y";
		// If there was no creditCardNumber passed, then use the providerToken
		} else if(!isNull(requestBean.getProviderToken()) && len(requestBean.getProviderToken())) {
			requestData["ssl_token"] = requestBean.getProviderToken();
		}
		
		// If this is a credit, then we want to use the originalAuthorizationID
		if(arguments.requestBean.getTransactionType() eq "credit" || arguments.requestBean.getTransactionType() eq "void") {
			requestData["ssl_txn_id"] = requestBean.getOriginalProviderTransactionID();
			
		// If this is a delayed capture we want to use the preAuthorizationTransactionID, or originalChargeProviderTransactionID
		} else if (arguments.requestBean.getTransactionType() eq "chargePreAuthorization") {
		
			// Look for an explicit preAuthorizationProviderTransactionID
			if(len(requestBean.getPreAuthorizationCode())) {
				requestData["ssl_approval_code"] = requestBean.getPreAuthorizationCode();
				
			// Default to the 'original'
			} else if (len(requestBean.getOriginalAuthorizationCode())) {
				requestData["ssl_approval_code"] = requestBean.getOriginalAuthorizationCode();
			}
		}

		// Always add a CVV2 in case one was passed in
		if(!isNull(requestBean.getSecurityCode())) {
			requestData["ssl_cvv2cvc2_indicator"] = '1';
			requestData["ssl_cvv2cvc2"] = requestBean.getSecurityCode();
		} else {
			requestData["ssl_cvv2cvc2_indicator"] = '0';
		}
			
		// As long as this is the correct type of transaction, then we will add an amount
		if(!listFindNoCase("generateToken,inquiry,void", arguments.requestBean.getTransactionType())) {
			requestData["ssl_amount"] = requestBean.getTransactionAmount();
		}		
		
		requestData["ssl_first_name"] = requestBean.getAccountFirstName();
		requestData["ssl_last_name"] = requestBean.getAccountLastName();
		requestData["ssl_avs_address"] = requestBean.getBillingStreetAddress();
		requestData["ssl_city"] = requestBean.getBillingCity();
		requestData["ssl_state"] = requestBean.getBillingStateCode();
		requestData["ssl_avs_zip"] = requestBean.getBillingPostalCode();
		requestData["ssl_country"] = requestBean.getBillingCountryCode();
		if(!isNull(requestBean.getAccountPrimaryEmailAddress())) {
			requestData["ssl_email"] = requestBean.getAccountPrimaryEmailAddress();
		}
		if(!isNull(requestBean.getAccountPrimaryPhoneNumber())) {
			requestData["ssl_phone"] = requestBean.getAccountPrimaryPhoneNumber();
		}		
		return requestData;
	}

	private string function getPin(required any requestBean){
		var pin = "";
		if(len(setting('pinTemplate')) && !isNull(requestBean.getOrder())){
			var pin = requestBean.getOrder().stringReplace(setting('pinTemplate'));
		}
		if(isNull(pin) || !len(pin)){
			pin = setting('pin');
		}
		return pin;
	}
	
	private any function postRequest(required struct requestData, string method="POST"){
		
		var httpRequest = new http();
		httpRequest.setMethod(arguments.method);
		if( setting('liveModeFlag') ) {
			httpRequest.setUrl( setting("liveGatewayURL") );
		} else {
			httpRequest.setUrl( setting("testGatewayURL") );
		}
		httpRequest.setTimeout(variables.timeout);
		httpRequest.setResolveurl(false);
		
		for(var key in requestData){
			if(structKeyExists(requestData,key)){
				httpRequest.addParam(type="formfield",name="#key#",value="#requestData[key]#");
			}
		}
		var response = httpRequest.send().getPrefix();
		return response;
	}
	
	private any function getResponseBean(required struct rawResponse, required any requestData, required any requestBean){
		var response = new Slatwall.model.transient.payment.CreditCardTransactionResponseBean();
		var responseDataArray = listToArray(rawResponse.fileContent, variables.responseDelimiter, true);
		var responseData = {ssl_result="",ssl_result_message="",ssl_approval_code="",ssl_txn_id="",ssl_token="",ssl_avs_response="",ssl_cvv2_response ="",errorCode="",errorMessage=""};
		
		for(var item in responseDataArray){
			responseData[listFirst(item,"=")] = listRest(item,"=");
		}
		
		// Populate the data with the raw response & request
		var data = {
			responseData = arguments.rawResponse,
			responseDataStruct = responseData,
			requestData = arguments.requestData
		};
		
		response.setData(data);
		
		// Add message for what happened if these values populated.
		if (len(responseData["ssl_result"]) && len(responseData["ssl_result_message"])){
			response.addMessage(responseData["ssl_result"], responseData["ssl_result_message"]);
		}
		
		if( setting('debugModeFlag') ) {
			structDelete(requestData,"ssl_card_number");
			response.addMessage("Request", serializeJSON(requestData));
			response.addMessage("Response", serializeJSON(rawResponse));
		}
		
		// Set the status Code
		response.setStatusCode(responseData["ssl_result"]);
		
		// Check to see if it was successful
		if(responseData["ssl_result"] != "0") {
			// Transaction did not go through
			if (len(responseData["errorCode"]) && len(responseData["errorMessage"])){
				response.setStatusCode(responseData["errorCode"]);
				response.addMessage(responseData["errorCode"], responseData["errorMessage"]);
				response.addError(responseData["errorCode"], responseData["errorMessage"]);
			}else if (structKeyExists(responseData, "Connection Failure")){
				response.setStatusCode("1");
				response.addMessage("1", "Connection Failure");
				response.addError("1", "Connection Failure");
			}else {
				response.setStatusCode("1");
				response.addMessage("1", "There was an unknown error processing this transaction.");
				response.addError("1", "There was an unknown error processing this transaction.");
			}
		} else {
			if(requestBean.getTransactionType() == "authorize") {
				response.setAmountAuthorized(requestBean.getTransactionAmount());
			} else if(requestBean.getTransactionType() == "authorizeAndCharge") {
				response.setAmountAuthorized(requestBean.getTransactionAmount());
				response.setAmountCharged(requestBean.getTransactionAmount());
			} else if(requestBean.getTransactionType() == "chargePreAuthorization") {
				response.setAmountCharged(requestBean.getTransactionAmount());
			} else if(requestBean.getTransactionType() == "credit") {
				response.setAmountCredited(requestBean.getTransactionAmount());
			}
		}
		
		// set provider token
		if(structKeyExists(responseData,"ssl_token")){
			response.setProviderToken(responseData["ssl_token"]);
		}
		
		response.setProviderTransactionID(responseData["ssl_txn_id"]);
		response.setAuthorizationCode(responseData["ssl_approval_code"]);
		if(structKeyExists(response.getAVSCodes(), responseData["ssl_avs_response"])){
			response.setAVSCode(responseData["ssl_avs_response"]);
		} else {
			response.setAVSCode("E");
		}
		
		if(responseData["ssl_cvv2_response"] == 'M') {
			response.setSecurityCodeMatch(true);
		} else {
			response.setSecurityCodeMatch(false);
		}
		
		return response;
	}
	
	public any function testIntegration() {
		var requestBean = new Slatwall.model.transient.payment.CreditCardTransactionRequestBean();
		var testAccount = getHibachiScope().getAccount();
		
		requestBean.setTransactionType('authorize');
		requestBean.setOrderID('1');
		requestBean.setCreditCardNumber('4111111111111111');
		requestBean.setSecurityCode('123');
		requestBean.setExpirationMonth('01');
		requestBean.setExpirationYear(year(now())+1);
		requestBean.setTransactionAmount('1');
		requestBean.setAccountFirstName(testAccount.getFirstName());
		requestBean.setAccountLastName(testAccount.getLastName());
		
		var response = processCreditCard(requestBean); 
		structDelete(response.getData(),"requestData");
		return response;
	}

}
