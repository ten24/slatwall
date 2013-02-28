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

component accessors="true" output="false" displayname="PayFlowPro" implements="Slatwall.integrationServices.PaymentInterface" extends="Slatwall.integrationServices.BasePayment" {
	
	//Global variables
	variables.liveGatewayAddress = "payflowpro.paypal.com";
	variables.testGatewayAddress = "pilot-payflowpro.paypal.com";
	variables.verbosity = "MEDIUM";
	variables.timeout = 45;
	variables.transactionCodes = {};

	public any function init(){
		// Set Defaults
		variables.transactionCodes = {
			authorize="A",
			authorizeAndCharge="S",
			chargePreAuthorization="D",
			credit="C",
			void="V",
			inquiry="I"
		};
		
		return this;
	}
	
	public string function getPaymentMethodTypes() {
		return "creditCard";
	}
	
	public Slatwall.com.utility.payment.CreditCardTransactionResponseBean function processCreditCard(required any requestBean){
		var requestData = getRequestData(requestBean);
		var rawResponse = postRequest(requestData, requestBean.getTransactionID());
		return getResponseBean(rawResponse, requestData, requestBean);
	}
	
	private string function getRequestData(required any requestBean){
		var requestData = "";
		requestData = "TENDER=C&VERBOSITY=#variables.verbosity#";
		
		requestData = listAppend(requestData,getLoginNVP(),"&");
		requestData = listAppend(requestData,getPaymentNVP(requestBean),"&");
		requestData = listAppend(requestData,getCustomerNVP(requestBean),"&");
		
		if(variables.transactionCodes[arguments.requestBean.getTransactionType()] == "C" || variables.transactionCodes[arguments.requestBean.getTransactionType()] == "D"){
			requestData = listAppend(requestData,"ORIGID=#requestBean.getProviderTransactionID()#","&");
		}
		
		// This is a bit of a hack because PayFlow Pro doesn't allow for second delay capture on an original authroization code.  So if the transactionType is delayed capture, and we have already captured a partial... then we will need to just recharge
		var forceSale = false;
		if( arguments.requestBean.getTransactionType() eq "chargePreAuthorization" ) {
			var query = new Query();
			query.setSQL("SELECT paymentTransactionID FROM SlatwallPaymentTransaction WHERE orderPaymentID = '#arguments.requestBean.getOrderPaymentID()#' AND transactionType = 'chargePreAuthorization' AND authorizationCode IN (SELECT authorizationCode FROM SlatwallPaymentTransaction WHERE providerTransactionID='#requestBean.getProviderTransactionID()#')"); 
			var qresults = query.Execute().getResult();
			
			if(qresults.recordCount) {
				forceSale = true;
			}
		}
		
		if(forceSale) {
			requestData = listAppend(requestData, "TRXTYPE=S", "&");
		} else {
			requestData = listAppend(requestData, "TRXTYPE=#variables.transactionCodes[arguments.requestBean.getTransactionType()]#", "&");
		}
		// END HACK
		
		return requestData;
	}

	private string function getLoginNVP(){
		var loginData = [];
		arrayAppend(loginData,"USER=#setting('userName')#");
		arrayAppend(loginData,"PARTNER=#setting('partnerID')#");
		arrayAppend(loginData,"VENDOR=#setting('vendorID')#");
		arrayAppend(loginData,"PWD=#setting('password')#");
		return arrayToList(loginData,"&");
	}
	
	private string function getPaymentNVP(required any requestBean){
		var paymentData = [];
		arrayAppend(paymentData,"ACCT[#len(requestBean.getCreditCardNumber())#]=#requestBean.getCreditCardNumber()#");
		arrayAppend(paymentData,"EXPDATE[4]=#numberFormat(Left(requestBean.getExpirationMonth(),2),'00')##Right(requestBean.getExpirationYear(),2)#");
		arrayAppend(paymentData,"CVV2[#len(requestBean.getSecurityCode())#]=#requestBean.getSecurityCode()#");
		arrayAppend(paymentData,"AMT[#len(requestBean.getTransactionAmount())#]=#requestBean.getTransactionAmount()#");
		
		// Try to populate the custom one and two for order payments
		if(!isNull(requestBean.getOrderPaymentID()) && len(requestBean.getOrderPaymentID())) {
			var entity = getService("orderService").getOrderPayment( requestBean.getOrderPaymentID() );
			var template1 = setting('orderPaymentCommentOneTemplate');
			var template2 = setting('orderPaymentCommentTwoTemplate');
		} else if (!isNull(requestBean.getAccountPaymentID()) && len(requestBean.getAccountPaymentID())) {
			var entity = getService("accountService").getAccountPayment( requestBean.getAccountPaymentID() );
			var template1 = setting('accountPaymentCommentOneTemplate');
			var template2 = setting('accountPaymentCommentTwoTemplate');
		}
		
		if(!isNull(entity)) {
			var comment1 = entity.stringReplace(template1);
			var comment2 = entity.stringReplace(template2);
			
			if(len(comment1) gt 128) {
				comment1 = left(comment1, 128);	
			}
			if(len(comment2) gt 128) {
				comment2 = left(comment2, 128);
			}
			
			arrayAppend(paymentData,"COMMENT1[#len(comment1)#]=#comment1#");
			arrayAppend(paymentData,"COMMENT2[#len(comment2)#]=#comment2#");			
		}
		
		return arrayToList(paymentData,"&");
	}
	
	private string function getCustomerNVP(required any requestBean){
		var customerData = [];
		//arrayAppend(customerData,"CUSTREF[#len(requestBean.getOrderID())#]=#requestBean.getOrderID()#");
		arrayAppend(customerData,"CUSTCODE[#len(requestBean.getAccountID())#]=#requestBean.getAccountID()#");
		arrayAppend(customerData,"FIRSTNAME[#len(requestBean.getAccountFirstName())#]=#requestBean.getAccountFirstName()#");
		arrayAppend(customerData,"LASTNAME[#len(requestBean.getAccountLastName())#]=#requestBean.getAccountLastName()#");
		arrayAppend(customerData,"STREET[#len(requestBean.getBillingStreetAddress())#]=#requestBean.getBillingStreetAddress()#");
		arrayAppend(customerData,"CITY[#len(requestBean.getBillingCity())#]=#requestBean.getBillingCity()#");
		arrayAppend(customerData,"STATE[#len(requestBean.getBillingStateCode())#]=#requestBean.getBillingStateCode()#");
		arrayAppend(customerData,"ZIP[#len(requestBean.getBillingPostalCode())#]=#requestBean.getBillingPostalCode()#");
		arrayAppend(customerData,"EMAIL[#len(requestBean.getAccountPrimaryEmailAddress())#]=#requestBean.getAccountPrimaryEmailAddress()#");
		arrayAppend(customerData,"PHONENUM[#len(requestBean.getAccountPrimaryPhoneNumber())#]=#requestBean.getAccountPrimaryPhoneNumber()#");
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
		httpRequest.addParam(type="header",name="Host",value="#getGatewayAddress()#");
		httpRequest.addParam(type="header",name="X-VPS-REQUEST-ID",VALUE="#arguments.requestID#");
		httpRequest.addParam(type="header",name="X-VPS-CLIENT-TIMEOUT",VALUE="#variables.timeout#");
		httpRequest.addParam(type="header",name="X-VPS-VIT-INTEGRATION-PRODUCT",VALUE="Slatwall");
		httpRequest.addParam(type="body",value="#requestData#");
		
		return httpRequest.send().getPrefix();
	}
	
	private string function getGatewayURL(){
		return "https://" & getGatewayAddress() & "/";
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
		var response = new Slatwall.com.utility.payment.CreditCardTransactionResponseBean();
		var responseDataArray = listToArray(rawResponse.fileContent,"&");
		var responseData = {result="",respmsg="",authcode="",pnref="",avsaddr="",avszip="",cvv2match=""};
		for(var item in responseDataArray){
			responseData[listFirst(item,"=")] = listRest(item,"=");
		}
		
		// Populate the data with the raw response & request
		var data = {
			responseData = arguments.rawResponse,
			requestData = arguments.requestData
		};
		response.setData(data);
		
		// Add message for what happened
		response.addMessage(responseData["result"], responseData["respmsg"]);
		
		// Set the status Code
		response.setStatusCode(responseData["result"]);
		
		// Check to see if it was successful
		if(responseData["result"] != 0) {
			// Transaction did not go through
			response.addError(responseData["result"], responseData["respmsg"]);
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
		
		response.setTransactionID(responseData["pnref"]);
		response.setAuthorizationCode(responseData["authcode"]);
		
		if(responseData["avsaddr"] == 'Y' && responseData["avszip"] == 'Y') {
			response.setAVSCode("Y");
		} else if(responseData["avsaddr"] == 'N' && responseData["avszip"] == 'Y') {
			response.setAVSCode("Z");
		} else if(responseData["avsaddr"] == 'N' && responseData["avszip"] == 'N') {
			response.setAVSCode("N");
		} else {
			response.setAVSCode("E");
		}
		
		if(responseData["cvv2match"] == 'Y') {
			response.setSecurityCodeMatch(true);
		} else {
			response.setSecurityCodeMatch(false);
		}
		
		return response;
	}
	
}