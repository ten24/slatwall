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

component accessors="true" output="false" displayname="Authorize.net" implements="Slatwall.integrationServices.PaymentInterface" extends="Slatwall.integrationServices.BasePayment" {
	
	//Global variables
	variables.gatewayURL = "https://secure.authorize.net/gateway/transact.dll";
	variables.testGatewayURL = "https://test.authorize.net/gateway/transact.dll";
	variables.version = "3.1";
	variables.timeout = "45";
	variables.responseDelimiter = "|";
	variables.transactionCodes = {};

	public any function init(){
		variables.transactionCodes = {
			authorize="AUTH_ONLY",
			authorizeAndCharge="AUTH_CAPTURE",
			chargePreAuthorization="PRIOR_AUTH_CAPTURE",
			credit="CREDIT",
			void="VOID",
			inquiry="INQUIRY"
		};
		
		return this;
	}
	
	public string function getPaymentMethodTypes() {
		return "creditCard";
	}
	
	public any function processCreditCard(required any requestBean){
		var rawResponse = "";
		var requestData = getRequestData(requestBean);
		rawResponse = postRequest(requestData);
		return getResponseBean(rawResponse, requestData, requestBean);
	}
	
	private struct function getRequestData(required any requestBean){
		var requestData = {};
		requestData["x_version"] = "3.1";
		requestData["x_login"] = setting('loginID'); 
		requestData["x_tran_key"] = setting('transKey'); 
		requestData["x_test_request"] = setting('testModeFlag'); 
		requestData["x_duplicate_window"] = "600";
		requestData["x_method"] = "CC";
		requestData["x_type"] = variables.transactionCodes[requestBean.getTransactionType()];

		requestData["x_amount"] = requestBean.getTransactionAmount();
		
		if(!isNull(requestBean.getCreditCardNumber())) {
			requestData["x_card_num"] = requestBean.getCreditCardNumber();	
		}
		if(!isNull(requestBean.getSecurityCode())) {
			requestData["x_card_code"] = requestBean.getSecurityCode();	
		}
		if(!isNull(requestBean.getExpirationMonth()) && !isNull(requestBean.getExpirationYear())) {
			requestData["x_exp_date"] = left(requestBean.getExpirationMonth(),2) & "" & right(requestBean.getExpirationYear(),2);	
		}
		requestData["x_invoice_num"] = requestBean.getOrderID(); 
		requestData["x_description"] = ""; 
		
		requestData["x_cust_id"] = requestBean.getAccountID(); 
		requestData["x_first_name"] = requestBean.getAccountFirstName(); 
		requestData["x_last_name"] = requestBean.getAccountLastName(); 
		requestData["x_address"] = isNull(requestBean.getBillingStreetAddress()) ? "":requestBean.getBillingStreetAddress(); 
		requestData["x_city"] = isNull(requestBean.getBillingCity()) ? "":requestBean.getBillingCity(); 
		requestData["x_state"] = isNull(requestBean.getBillingStateCode()) ? "xx":requestBean.getBillingStateCode(); 
		requestData["x_zip"] = isNull(requestBean.getBillingPostalCode()) ? "":requestBean.getBillingPostalCode();
		
		if(!isNull(requestBean.getAccountPrimaryPhoneNumber())) {
			requestData["x_phone"] = requestBean.getAccountPrimaryPhoneNumber();	
		} else {
			requestData["x_phone"] = "";
		}
		
		if(!isNull(requestBean.getAccountPrimaryEmailAddress())) {
			requestData["x_email"] = requestBean.getAccountPrimaryEmailAddress(); 	
		} else {
			requestData["x_email"] = "";
		}
				
		requestData["x_customer_ip"] = CGI.REMOTE_ADDR; 
		if(!isNull(requestBean.getProviderTransactionID())) {
			requestData["x_trans_id"] = requestBean.getProviderTransactionID();	
		}
		requestData["x_delim_data"] = "TRUE"; 
		requestData["x_delim_char"] = variables.responseDelimiter; 
		requestData["x_relay_response"] = "FALSE"; 
		
		return requestData;
	}
	
	private any function postRequest(required struct requestData){
		var httpRequest = new http();
		httpRequest.setMethod("POST");
		if( setting('testServerFlag') ) {
			httpRequest.setUrl( variables.testGatewayURL );
		} else {
			httpRequest.setUrl( variables.gatewayURL );	
		}
		httpRequest.setTimeout(variables.timeout);
		httpRequest.setResolveurl(false);
		for(var key in requestData){
			httpRequest.addParam(type="formfield",name="#key#",value="#requestData[key]#");
		}

		var response = httpRequest.send().getPrefix();
		
		return response;
	}
	
	private any function getResponseBean(required struct rawResponse, required any requestData, required any requestBean){
		var response = new Slatwall.com.utility.payment.CreditCardTransactionResponseBean();
		
		// Parse The Raw Response Data Into a Struct
		var responseDataArray = listToArray(rawResponse.fileContent,variables.responseDelimiter,true);
		
		var responseDate = {};
		responseData.responseCode = responseDataArray[1];
		responseData.responseSubCode = responseDataArray[2];
		responseData.responseReasonCode = responseDataArray[3];
		responseData.responseReasonText = responseDataArray[4];
		responseData.authorizationCode = responseDataArray[5];
		responseData.avsResponse = responseDataArray[6];
		responseData.transactionID = responseDataArray[7];
		responseData.invoiceNumber = responseDataArray[8];
		responseData.description = responseDataArray[9];
		responseData.amount = responseDataArray[10];
		responseData.method = responseDataArray[11];
		responseData.transactionType = responseDataArray[12];
		responseData.customerID = responseDataArray[13];
		responseData.firstName = responseDataArray[14];
		responseData.lastName = responseDataArray[15];
		responseData.company = responseDataArray[16];
		responseData.address = responseDataArray[17];
		responseData.city = responseDataArray[18];
		responseData.state = responseDataArray[19];
		responseData.zipCode = responseDataArray[20];
		responseData.country = responseDataArray[21];
		responseData.phone = responseDataArray[22];
		responseData.fax = responseDataArray[23];
		responseData.emailAddress = responseDataArray[24];
		responseData.shipToFirstName = responseDataArray[25];
		responseData.shipToLastName = responseDataArray[26];
		responseData.shipToCompany = responseDataArray[27];
		responseData.shipToAddress = responseDataArray[28];
		responseData.shipToCity = responseDataArray[29];
		responseData.shipToState = responseDataArray[30];
		responseData.shipToZipCode = responseDataArray[31];
		responseData.shipToCountry = responseDataArray[32];
		responseData.tax = responseDataArray[33];
		responseData.duty = responseDataArray[34];
		responseData.freight = responseDataArray[35];
		responseData.taxExempt = responseDataArray[36];
		responseData.purchaseOrderNumber = responseDataArray[37];
		responseData.md5Hash = responseDataArray[38];
		responseData.cardCodeResponse = responseDataArray[39];
		responseData.cardholderAuthenticationVerification = responseDataArray[40];
		// Gap in array here is intential per Authroize.net Spec... they send back blank values in array
		responseData.response = responseDataArray[51];
		responseData.accountNumber = responseDataArray[52];
		// Again array is actually 68 index's long, but they only use the first 52
				
		// Populate the data with the raw response & request
		var data = {
			responseData = arguments.rawResponse,
			requestData = arguments.requestData
		};
		
		response.setData(data);
		
		// Add message for what happened
		response.addMessage(messageName=responseData.responseReasonCode, message=responseData.responseReasonText);
		
		// Set the response Code
		response.setStatusCode( responseData.responseCode );
		
		// Check to see if it was successful
		if(responseData.responseCode != 1) {
			// Transaction did not go through
			response.addError(responseData.responseReasonCode, responseData.responseReasonText);
		} else {
			if(requestBean.getTransactionType() == "authorize") {
				response.setAmountAuthorized( responseData.amount );
			} else if(requestBean.getTransactionType() == "authorizeAndCharge") {
				response.setAmountAuthorized(  responseData.amount );
				response.setAmountCharged(  responseData.amount  );
			} else if(requestBean.getTransactionType() == "chargePreAuthorization") {
				response.setAmountCharged(  responseData.amount  );
			} else if(requestBean.getTransactionType() == "credit") {
				response.setAmountCredited(  responseData.amount  );
			}
		}
		
		response.setTransactionID( responseData.transactionID );
		response.setAuthorizationCode( responseData.authorizationCode );
		
		if( responseData.avsResponse == "B" || responseData.avsResponse == "P" ) {
			response.setAVSCode( "U" );
		} else {
			response.setAVSCode( responseData.avsResponse );
		}
		
		if( responseData.cardCodeResponse == 'M') {
			response.setSecurityCodeMatch(true);
		} else {
			response.setSecurityCodeMatch(false);
		}
		
		return response;
	}
	
}
