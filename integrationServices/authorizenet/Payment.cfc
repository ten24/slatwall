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

component accessors="true" output="false" displayname="Authorize.net" implements="Slatwall.integrationServices.PaymentInterface" extends="Slatwall.integrationServices.BasePayment" {

	//Global variables
	variables.version = "3.1";
	variables.timeout = "45";
	variables.responseDelimiter = "|";
	variables.transactionCodes = {};

	public any function init(){
		variables.transactionCodes = {
			authorize="authOnlyTransaction",
			authorizeAndCharge="authCaptureTransaction",
			chargePreAuthorization="priorAuthCaptureTransaction",
			credit="refundTransaction",
			void="voidTransaction",
			generateToken="generateToken"
		};

		return this;
	}

	public string function getPaymentMethodTypes() {
		return "creditCard";
	}

	public any function processCreditCard(required any requestBean){
		if(requestBean.getTransactionType() == variables.transactionCodes.generateToken){
			return getCustomerProfile(requestBean);
		}

		var requestData = getRequestData(requestBean);
		var rawResponse = postRequest(requestData);
		return getResponseBean(rawResponse, requestData, requestBean);
	}

	private string function getRequestData(required any requestBean){
		var requestData = getTransient('AuthorizeNetTransactionRequest');
		requestData.addSetting('duplicateWindow', true);
		requestData.setTransactionType(variables.transactionCodes[requestBean.getTransactionType()]);
		requestData.setAmount(requestBean.getTransactionAmount());

		if(!isNull(requestBean.getCreditCardNumber())) {
			requestData.setCardNumber(requestBean.getCreditCardNumber());
		} else {
 			requestData.setCardNumber(requestBean.getCreditCardLastFour());
  		}

  		requestData.setProviderToken(requestBean.getProviderToken());

  		if(!isNull(requestBean.getSecurityCode())) {
			requestData.setCardCode(requestBean.getSecurityCode());
		}

		if(!isNull(requestBean.getExpirationMonth()) && !isNull(requestBean.getExpirationYear())) {
			requestData.setExpirationDate(left(requestBean.getExpirationMonth(),2) & "" & right(requestBean.getExpirationYear(),2));
			if(len(requestData.getExpirationDate()) == 3){
				requestData.setExpirationDate('0' & requestData.getExpirationDate());
			}
		}

		if(listLen(setting('invoiceUserFileOneTemplate'), ' ') == 2){
			requestData.addUserField(listFirst(setting('invoiceUserFileOneTemplate'), ' '), getService('HibachiUtilityService').replaceStringTemplate(listLast(setting('invoiceUserFileOneTemplate'), ' '), requestBean.getOrder()));
		}
		if(listLen(setting('invoiceUserFileTwoTemplate'), ' ') == 2){
			requestData.addUserField(listFirst(setting('invoiceUserFileTwoTemplate'), ' '), getService('HibachiUtilityService').replaceStringTemplate(listLast(setting('invoiceUserFileTwoTemplate'), ' '), requestBean.getOrder()));
		}
		if(listLen(setting('invoiceUserFileThreeTemplate'), ' ') == 2){
			requestData.addUserField(listFirst(setting('invoiceUserFileThreeTemplate'), ' '), getService('HibachiUtilityService').replaceStringTemplate(listLast(setting('invoiceUserFileThreeTemplate'), ' '), requestBean.getOrder()));
		}

		requestData.setInvoiceNumber(requestBean.getOrder().getShortReferenceID( true ));

		requestData.setCustomerId(getService('AccountService').getAccount(requestBean.getAccountID()).getShortReferenceID(true));

		if(len(requestBean.getAccountFirstName())){
			requestData.setFirstName(requestBean.getAccountFirstName());
		}else{
			requestData.setFirstName(listFirst(requestBean.getOrderPayment().getNameOnCreditCard(), ' '));
		}

		if(len(requestBean.getAccountLastName())){
			requestData.setLastName(requestBean.getAccountLastName());
		}else if(listLen(requestBean.getOrderPayment().getNameOnCreditCard(), ' ') > 1){
			requestData.setLastName(listLast(requestBean.getOrderPayment().getNameOnCreditCard(), ' '));
		}else{
			requestData.setLastName("");
		}

		requestData.setAddress(isNull(requestBean.getBillingStreetAddress()) ? "":requestBean.getBillingStreetAddress());
		requestData.setCity(isNull(requestBean.getBillingCity()) ? "":requestBean.getBillingCity());
		requestData.setState(isNull(requestBean.getBillingStateCode()) ? "":requestBean.getBillingStateCode());
		requestData.setZip(isNull(requestBean.getBillingPostalCode()) ? "":requestBean.getBillingPostalCode());

		if(!isNull(requestBean.getAccountPrimaryPhoneNumber())) {
			requestData.setPhoneNumber(requestBean.getAccountPrimaryPhoneNumber());
		}

		if(!isNull(requestBean.getAccountPrimaryEmailAddress())) {
			requestData.setEmail(requestBean.getAccountPrimaryEmailAddress());
		}

		requestData.setCustomerIP(CGI.REMOTE_ADDR);
		if(!isNull(requestBean.getOriginalProviderTransactionID()) && len(requestBean.getOriginalProviderTransactionID())) {
			requestData.setRefTransID(requestBean.getOriginalProviderTransactionID());
		}

		var createTransactionRequest = getTransient('AuthorizeNetCreateTransactionRequest', {loginID=setting('loginID'), transKey=setting('transKey')});
		createTransactionRequest.setTransactionRequest(requestData);
		return createTransactionRequest.getData();
	}

	private any function postRequest(required string requestData){
		var httpRequest = new http();
		httpRequest.setMethod("POST");
		if( setting('testServerFlag') ) {
			httpRequest.setUrl( setting("testGatewayURL") );
		} else {
			httpRequest.setUrl( setting("gatewayURL") );
		}
		httpRequest.setTimeout(variables.timeout);
		httpRequest.setResolveurl(false);
		httpRequest.addParam(type="header", name="Content-Type", value="application/json");
		httpRequest.addParam(type="body",value=requestData);

		var response = httpRequest.send().getPrefix();

		return response;
	}

	private any function getResponseBean(required struct rawResponse, required any requestData, required any requestBean){

		var response = getTransient('CreditCardTransactionResponseBean');
		arguments.requestData = deserializeJSON(arguments.requestData);

		var responseData = deserializeJSON(arguments.rawResponse.fileContent).transactionResponse;


		// Populate the data with the raw response & request
		var data = {
			responseData = arguments.rawResponse,
			requestData = arguments.requestData
		};

		response.setData(data);

		// Set the response Code

		if(structKeyExists(responseData, 'responseCode')){
			response.setStatusCode(responseData.responseCode);
		}
		// Check to see if it was successful
		if(response.getStatusCode() != 1) {
			// Transaction did not go through
			if(structKeyExists(responseData, 'errors')){
				response.addError(responseData.errors[1].errorCode, responseData.errors[1].errorText);
			}else if (structKeyExists(responseData, 'messages')){
				response.addError(responseData.messages.message[1].code, responseData.messages.message[1].text);
			}else{
				var allresponse = deserializeJSON(arguments.rawResponse.fileContent);
				if(structKeyExists(allresponse, 'messages')) {
					response.addError(allresponse.messages.message[1].code, allresponse.messages.message[1].text);
				}else{
					response.addError('000', 'Internal Error');
				}
			}
		} else {
			// Add message for what happened
			response.addMessage(messageName=responseData.messages[1].code, message=responseData.messages[1].description);

			if(requestBean.getTransactionType() == "authorize") {
				response.setAmountAuthorized( requestData.createTransactionRequest.transactionRequest.amount );
			} else if(requestBean.getTransactionType() == "authorizeAndCharge") {
				response.setAmountAuthorized(  requestData.createTransactionRequest.transactionRequest.amount );
				response.setAmountCharged(  requestData.createTransactionRequest.transactionRequest.amount  );
			} else if(requestBean.getTransactionType() == "chargePreAuthorization") {
				response.setAmountCharged(  requestData.createTransactionRequest.transactionRequest.amount  );
			} else if(requestBean.getTransactionType() == "credit") {
				response.setAmountCredited(  requestData.createTransactionRequest.transactionRequest.amount  );
			}
		}

		response.setTransactionID( responseData.transID );
		response.setAuthorizationCode( responseData.authCode );

		if( responseData.avsResultCode == "B" || responseData.avsResultCode == "P" ) {
			response.setAVSCode( "U" );
		} else {
			response.setAVSCode( responseData.avsResultCode );
		}

		if( responseData.cvvResultCode == 'M') {
			response.setSecurityCodeMatch(true);
		} else {
			response.setSecurityCodeMatch(false);
		}

		return response;
	}

	public any function getCustomerProfile(required any requestBean){
		var rawResponse = "";
		var requestData = getProfileRequestData(requestBean);
		rawResponse = postRequest(requestData);
		return getProfileResponseBean(rawResponse, requestData, requestBean);
	}

	public string function getProfileRequestData(required any requestBean){
		var requestData = getTransient('AuthorizeNetCustomerProfile');
		
		if(!isNull(requestBean.getOrderPayment())){
			requestData.setMerchantCustomerID(requestBean.getOrderPayment().getShortReferenceID(true));
		} else {
			requestData.setMerchantCustomerID(requestBean.getAccountPaymentMethod().getShortReferenceID(true));
		}		
		requestData.setCardNumber(requestBean.getCreditCardNumber());

  		if(!isNull(requestBean.getSecurityCode())) {
			requestData.setCardCode(requestBean.getSecurityCode());
		}else{
			requestData.setCardCode('444');
		}

		if(!isNull(requestBean.getExpirationMonth()) && !isNull(requestBean.getExpirationYear())) {
			requestData.setExpirationDate(left(requestBean.getExpirationMonth(),2) & "" & right(requestBean.getExpirationYear(),2));
			if(len(requestData.getExpirationDate()) == 3){
				requestData.setExpirationDate('0' & requestData.getExpirationDate());
			}
		}

		requestData.setFirstName(requestBean.getAccountFirstName());
		requestData.setLastName(requestBean.getAccountLastName());
		requestData.setAddress(isNull(requestBean.getBillingStreetAddress()) ? "":requestBean.getBillingStreetAddress());
		requestData.setCity(isNull(requestBean.getBillingCity()) ? "":requestBean.getBillingCity());
		requestData.setState(isNull(requestBean.getBillingStateCode()) ? "":requestBean.getBillingStateCode());
		requestData.setZip(isNull(requestBean.getBillingPostalCode()) ? "":requestBean.getBillingPostalCode());

		if(!isNull(requestBean.getAccountPrimaryPhoneNumber())) {
			requestData.setPhoneNumber(requestBean.getAccountPrimaryPhoneNumber());
		}

		if(!isNull(requestBean.getAccountPrimaryEmailAddress())) {
			requestData.setEmail(requestBean.getAccountPrimaryEmailAddress());
		}

		var createCustomerProfileRequest = getTransient('AuthorizeNetCreateCustomerProfileRequest', {loginID=setting('loginID'), transKey=setting('transKey')});
		createCustomerProfileRequest.setCustomerProfile(requestData);

		return createCustomerProfileRequest.getData();

	}

	private any function getProfileResponseBean(required struct rawResponse, required any requestData, required any requestBean){

		var response = getTransient('CreditCardTransactionResponseBean');
		requestData = deserializeJSON(requestData);

		var responseData = deserializeJSON(rawResponse.fileContent);

		// Populate the data with the raw response & request
		var data = {
			responseData = arguments.rawResponse,
			requestData = arguments.requestData
		};

		response.setData(data);

		// Set the response Code
		response.setStatusCode(responseData.messages.message[1].code);

		// Check to see if it was successful
		if(right(response.getStatusCode(),1) != 1) {
			// Transaction did not go through
			if(structKeyExists(responseData,'errors')){
				response.addError(responseData.errors.error[1].errorCode, responseData.errors.error[1].errorText);
			}else{
				try{
					response.addError(responseData.messages.message[1].code, responseData.messages.message[1].description);
				}catch(any e){
					response.addError(responseData.messages.message[1].code, responseData.messages.message[1].text);
				}
			}
		} else {
			// Add message for what happened
			
			response.addMessage(messageName=responseData.messages.message[1].code, message=responseData.messages.message[1].text);
			if(structKeyExists(responseData, 'customerProfileId') && structKeyExists(responseData, 'customerPaymentProfileIdList')){
				response.setProviderToken(responseData.customerProfileId & '|' & responseData.customerPaymentProfileIdList[1]);
			}

		}

		return response;
	}

}

