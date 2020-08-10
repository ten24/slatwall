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

component accessors="true" output="false" displayname="VirtualMerchant" implements="Slatwall.integrationServices.PaymentInterface" extends="Slatwall.integrationServices.BasePayment" {
	
	//Global variables
	variables.liveGatewayAddress = "https://www.myvirtualmerchant.com/VirtualMerchant/process.do";
	variables.testGatewayAddress = "https://demo.myvirtualmerchant.com/VirtualMerchantDemo/process.do";
	variables.transactionCodes = {};

	public any function init(){
		variables.transactionCodes = {
			authorize="ccauthonly",
			authorizeAndCharge="ccsale",
			chargePreAuthorization="ccforce",
			credit="cccredit",
			void="ccvoid",
			inquiry=""
		};
		
		return this;
	}
	
	public string function getPaymentMethodTypes() {
		return "creditCard";
	}
	
	public any function processCreditCard(required any requestBean){
		
		var requestData = getRequestData(requestBean);
		var rawResponse = postRequest(requestData, requestBean.getTransactionID());
		
		return getResponseBean(rawResponse, requestData, requestBean);
		
	}
	
	private string function getRequestData(required any requestBean){
		
		var requestData = "";
		requestData = "ssl_transaction_type=#variables.transactionCodes[arguments.requestBean.getTransactionType()]#&ssl_show_form=false&ssl_result_format=ASCII";
		
		// If this is a ccforce for capturing a pre-authorization, then we need to pass the auth code
		if(arguments.requestBean.getTransactionType() eq "arguments.requestBean.getTransactionType()" && !isNull(requestBean.getProviderTransationID()) && len(requestBean.getProviderTransationID())) {
			if(!isNull(arguments.requestBean.getOriginalAuthorizationCode()) && len(arguments.requestBean.getOriginalAuthorizationCode())) {
				requestData = listAppend(requestData, "ssl_approval_code=#arguments.requestBean.getOriginalAuthorizationCode()#","&");		
			}
		}
		
		requestData = listAppend(requestData, getLoginNVP(),"&");
		requestData = listAppend(requestData, getPaymentNVP(requestBean),"&");
		if(variables.transactionCodes[arguments.requestBean.getTransactionType()] == "C" || variables.transactionCodes[arguments.requestBean.getTransactionType()] == "D"){
			requestData = listAppend(requestData,"ORIGID=#requestBean.getOriginalProviderTransactionID()#","&");
		}
		
		return requestData;
		
	}

	private string function getLoginNVP(){
		
		var loginData = [];
		
		if(setting('testAccountFlag')){
			arrayAppend(loginData,"ssl_merchant_id=#setting('testMerchantID')#");
			arrayAppend(loginData,"ssl_user_id=#setting('testUserID')#");
			arrayAppend(loginData,"ssl_pin=#setting('testPin')#");
		} else {
			arrayAppend(loginData,"ssl_merchant_id=#setting('merchantID')#");
			arrayAppend(loginData,"ssl_user_id=#setting('userID')#");
			arrayAppend(loginData,"ssl_pin=#setting('pin')#");
		}
		
		return arrayToList(loginData,"&");
	}
	
	private string function getPaymentNVP(required any requestBean){
		
		var paymentData = [];
		arrayAppend(paymentData,"ssl_amount=#requestBean.getTransactionAmount()#");
		if(len(requestBean.getCreditCardNumber())) {
			arrayAppend(paymentData,"ssl_card_number=#requestBean.getCreditCardNumber()#");
		}
		arrayAppend(paymentData,"ssl_card_present=N");
		arrayAppend(paymentData,"ssl_exp_date=#Left(requestBean.getExpirationMonth(),2)##Right(requestBean.getExpirationYear(),2)#");
		arrayAppend(paymentData,"ssl_avs_address=#requestBean.getBillingStreetAddress()#");
		arrayAppend(paymentData,"ssl_avs_zip=#requestBean.getBillingPostalCode()#");
		arrayAppend(paymentData,"ssl_cvv2cvc2_indicator=1");
		arrayAppend(paymentData,"ssl_cvv2cvc2=#requestBean.getSecurityCode()#");
		
		return arrayToList(paymentData,"&");
		
	}
	
	private any function postRequest(required string requestData, required string requestID){
		
		var httpRequest = new http();
		httpRequest.setMethod("POST");
		httpRequest.setUrl(getGatewayAddress() & "?" & requestData);
		httpRequest.setPort(443);
		httpRequest.setTimeout(45);
		httpRequest.setResolveurl(false);
		
		httpRequest.addParam(type="header",name="Content-Type",VALUE="text/namevalue");
		httpRequest.addParam(type="header",name="Content-Length",VALUE="#Len(requestData)#");
		httpRequest.addParam(type="body",value="#requestData#");
		
		return httpRequest.send().getPrefix();
	}
	
	private string function getGatewayAddress(){
		if(setting('testAccountFlag')){
			return variables.testGatewayAddress;
		} else {
			return variables.liveGatewayAddress;
		}
	}
	
	private any function getResponseBean(required struct rawResponse, required any requestData, required any requestBean){
		
		var response = new Slatwall.model.transient.payment.CreditCardTransactionResponseBean();
		
		// Populate the data with the raw response & request
		var data = {
			responseData = arguments.rawResponse,
			requestData = arguments.requestData
		};
		response.setData(data);
		
		var responseDataArray = listToArray(rawResponse.fileContent,chr(10));
		var responseData = {};
		
		for(var item in responseDataArray){
			responseData[listFirst(item,"=")] = listRest(item,"=");
		}
		
		if(!structKeyExists(responseData, "ssl_result")) {
			if(structKeyExists(responseData, "errorMessage")) {
				param name="responseData.errorCode" default="";
				param name="responseData.errorName" default="";
				
				response.addError("processing", "#responseData['errorName']# (#responseData['errorCode']#) : #responseData['errorMessage']#");
			}
		} else {
			// Add message for what happened
			response.addMessage(responseData["ssl_result"], responseData["ssl_result_message"]);
			
			// Set the status Code
			response.setStatusCode(responseData["ssl_result"]);
			
			// Set the transaction ID
			response.setTransactionID(responseData["ssl_txn_id"]);
			
			// Check to see if it was successful
			if(responseData["ssl_result"] != 0) {
				// Transaction did not go through
				response.addError("processing", responseData["ssl_result_message"]);
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
				
				response.setAuthorizationCode(responseData["ssl_approval_code"]);
				response.setAVSCode( responseData["ssl_avs_response"] );
				
			}
			
			if(responseData["ssl_cvv2_response"] == 'M') {
				response.setSecurityCodeMatch(true);
			} else {
				response.setSecurityCodeMatch(false);
			}
			
		}
		
		return response;
	}
	
}
