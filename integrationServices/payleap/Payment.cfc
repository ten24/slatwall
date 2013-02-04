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

component accessors="true" output="false" displayname="PayLeap" implements="Slatwall.integrationServices.PaymentInterface" extends="Slatwall.integrationServices.BasePayment" {
	
	//Global variables
	variables.liveGatewayAddress = "secure1.payleap.com/transactservices.svc/ProcessCreditCard";
	variables.testGatewayAddress = "uat.payleap.com/transactservices.svc/ProcessCreditCard";
	variables.verbosity = "MEDIUM";
	variables.timeout = 45;
	variables.transactionCodes = {};

	public any function init(){
		// Set Defaults
		variables.transactionCodes = {
			authorize="Auth",
			authorizeAndCharge="Sale",
			chargePreAuthorization="Capture",
			credit="Return",
			void="Void",
			inquiry=""
		};
		
		return this;
	}
	
	public string function getPaymentMethodTypes() {
		return "creditCard";
	}
	
	public Slatwall.model.transient.payment.CreditCardTransactionResponseBean function processCreditCard(required Slatwall.model.transient.payment.CreditCardTransactionRequestBean requestBean){
		var requestData = getRequestData(requestBean);
		var rawResponse = postRequest(requestData, requestBean.getTransactionID());
		return getResponseBean(rawResponse, requestData, requestBean);
	}
	
	private string function getRequestData(required any requestBean){
		var requestData = "";
		
		requestData = listAppend(requestData,getLoginNVP(),"&");
		requestData = listAppend(requestData,getPaymentNVP(requestBean),"&");
		requestData = listAppend(requestData,getCustomerNVP(requestBean),"&");
		
		if(variables.transactionCodes[arguments.requestBean.getTransactionType()] == "Return" || variables.transactionCodes[arguments.requestBean.getTransactionType()] == "Capture"){
			requestData = listAppend(requestData,"PNRef=#requestBean.getProviderTransactionID()#","&");
		}
		
		return requestData;
	}

	private string function getLoginNVP(){
		var loginData = [];
		arrayAppend(loginData,"UserName=#setting('userName')#");
		arrayAppend(loginData,"Password=#setting('password')#");
		return arrayToList(loginData,"&");
	}
	
	private string function getPaymentNVP(required any requestBean){
		var paymentData = [];
		arrayAppend(paymentData,"CardNum=#requestBean.getCreditCardNumber()#");
		arrayAppend(paymentData,"ExpDate=#numberFormat(Left(requestBean.getExpirationMonth(),2),'00')##Right(requestBean.getExpirationYear(),2)#");
		arrayAppend(paymentData,"CVNum=#requestBean.getSecurityCode()#");
		arrayAppend(paymentData,"TransType=#variables.transactionCodes[requestBean.getTransactionType()]#");
		arrayAppend(paymentData,"Amount=#requestBean.getTransactionAmount()#");
		
		return arrayToList(paymentData,"&");
	}
	
	private string function getCustomerNVP(required any requestBean){
		var customerData = [];
		arrayAppend(customerData,"NameOnCard=#requestBean.getAccountFirstName()#");
		arrayAppend(customerData,"Street=#requestBean.getBillingStreetAddress()#");
		arrayAppend(customerData,"Zip=#requestBean.getBillingPostalCode()#");
		return arrayToList(customerData,"&");
	}
	
	private any function postRequest(required string requestData, required string requestID){
		
		var httpRequest = new http();
		httpRequest.setMethod("POST");
		httpRequest.setUrl(getGatewayURL());
		httpRequest.setPort(getGatewayPort());
		httpRequest.setTimeout(variables.timeout);
		httpRequest.setResolveurl(false);
		
		httpRequest.addParam(type="header",name="Content-Type",VALUE="text/namevalue");
		httpRequest.addParam(type="header",name="Content-Length",VALUE="#Len(requestData)#");
		httpRequest.addParam(type="body",value="#requestData#");
		
		return httpRequest.send().getPrefix();
	}
	
	private string function getGatewayURL(){
		return "https://" & getGatewayAddress();
	}
	
	private numeric function getGatewayPort(){
		return 443;
	}
	
	private string function getGatewayAddress(){
		if(setting('liveModeFlag')){
			return variables.liveGatewayAddress;
		} else {
			return variables.testGatewayAddress;
		}
	}
	
	private any function getResponseBean(required struct rawResponse, required any requestData, required any requestBean){
		var response = new Slatwall.model.transient.payment.CreditCardTransactionResponseBean();
		
		var xmlResponse = XmlParse(REReplace(rawResponse.fileContent, "^[^<]*", "", "one"));
		
		response.setData(xmlResponse);
		
		// Add message for what happened
		response.addMessage("Result", xmlResponse.Response.RespMSG);
		
		// Set the status Code
		response.setStatusCode(xmlResponse.Response.Result.xmlText);
		
		// Check to see if it was successful
		if(xmlResponse.Response.Result.xmlText != 0) {
			// Transaction did not go through
			response.addError("Error", xmlResponse.Response.RespMSG.xmlText);
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
		
		if(structKeyExists(xmlResponse.Response, "PNRef")) {
			response.setTransactionID(xmlResponse.Response.PNRef.xmlText);
		}
		
		if(structKeyExists(xmlResponse.Response, "AuthCode")) {
			response.setAuthorizationCode(xmlResponse.Response.AuthCode.xmlText);
		}
		
		if(structKeyExists(xmlResponse.Response, "GetAVSResult")) {
			if(xmlResponse.Response.GetAVSResult.xmlText == 'Y') {
				response.setAVSCode("Y");
			} else if(xmlResponse.Response.GetAVSResult.xmlText == 'Z') {
				response.setAVSCode("Z");
			} else if(xmlResponse.Response.GetAVSResult.xmlText == 'N') {
				response.setAVSCode("N");
			} else {
				response.setAVSCode("E");
			}
		}
		
		if(structKeyExists(xmlResponse.Response, "GetCVResult")) {
			if(xmlResponse.Response.GetCVResult.xmlText == 'M') {
				response.setSecurityCodeMatch(true);
			} else {
				response.setSecurityCodeMatch(false);
			}
		}
		
		return response;
	}
	
}