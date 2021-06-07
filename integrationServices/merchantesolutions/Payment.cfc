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

component accessors="true" output="false" displayname="MerchanteSolutions" implements="Slatwall.integrationServices.PaymentInterface" extends="Slatwall.integrationServices.BasePayment" {

	variables.timeout = 45;
	variables.responseDelimiter = "&";
	variables.transactionCodes = {};

	public any function init() {
		// Set Defaults
		variables.transactionCodes = {
			authorize="P",
			authorizeAndCharge="D",
			chargePreAuthorization="S",
			credit="C",
			void="V",
			inquiry="I",
			generateToken="T"
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

		//Check if test mode is active
		if(setting('testModeFlag')) {
			requestData["profile_id"] = setting("testProfileID");
			requestData["profile_key"] = setting("testProfileKey");
		} else {
			requestData["profile_id"] = setting("profileID");
			requestData["profile_key"] = setting("profileKey");
		}

		requestData["transaction_type"] = variables.transactionCodes[requestBean.getTransactionType()];

		if(requestBean.getTransactionType() == "authorize" || requestBean.getTransactionType() == "authorizeAndCharge" || requestBean.getTransactionType() == "generateToken") {

			if(requestBean.getTransactionType() == "authorize" || requestBean.getTransactionType() == "authorizeAndCharge") {
				requestData["transaction_amount"] = requestBean.getTransactionAmount();
				requestData["invoice_number"] = requestBean.getOrder().getShortReferenceID(true);
			}

			if(!isNull(requestBean.getProviderToken()) && !requestBean.getTransactionType() == "generateToken") {
				requestData["card_id"] = requestBean.getProviderToken();
			} else {
				requestData["card_number"] = requestBean.getCreditCardNumber();
			}
			if(!isNull(requestBean.getSecurityCode())) {
				requestData["cvv2"] = requestBean.getSecurityCode();
			}
			if(!isNull(requestBean.getExpirationMonth()) && !isNull(requestBean.getExpirationYear())) {
				requestData["card_exp_date"] = left(requestBean.getExpirationMonth(),2) & "" & right(requestBean.getExpirationYear(),2);
			}
			requestData["cardholder_first_name"] = requestBean.getAccountFirstName();
			requestData["cardholder_last_name"] = requestBean.getAccountLastName();
			requestData["cardholder_street_address"] = isNull(requestBean.getBillingStreetAddress()) ? "":requestBean.getBillingStreetAddress();
			requestData["cardholder_zip"] = isNull(requestBean.getBillingPostalCode()) ? "":requestBean.getBillingPostalCode();
			if(!isNull(requestBean.getAccountPrimaryPhoneNumber())) {
				requestData["cardholder_phone"] = requestBean.getAccountPrimaryPhoneNumber();
			} else {
				requestData["cardholder_phone"] = "";
			}
			if(!isNull(requestBean.getAccountPrimaryEmailAddress())) {
				requestData["cardholder_email"] = requestBean.getAccountPrimaryEmailAddress();
			} else {
				requestData["cardholder_email"] = "";
			}
			requestData["ip_address"] = getRemoteAddress();

		} else if(requestBean.getTransactionType() == "chargePreAuthorization") {

			requestData["transaction_id"] = requestBean.getOriginalAuthorizationProviderTransactionID();
			requestData["transaction_amount"] = requestBean.getTransactionAmount();
			requestData["invoice_number"] = requestBean.getOrder().getShortReferenceID(true);

		} else if(requestBean.getTransactionType()== "credit") {

			requestData["transaction_amount"] = requestBean.getTransactionAmount();
			if(!isNull(requestBean.getProviderToken())) {
				requestData["card_id"] = requestBean.getProviderToken();
			} else {
				requestData["card_number"] = requestBean.getCreditCardNumber();
			}
			if(!isNull(requestBean.getExpirationMonth()) && !isNull(requestBean.getExpirationYear())) {
				requestData["card_exp_date"] = left(requestBean.getExpirationMonth(),2) & "" & right(requestBean.getExpirationYear(),2);
			}

		}

		return requestData;
	}

	private any function postRequest(required struct requestData){
		var httpRequest = new http();
		httpRequest.setMethod("POST");
		if(setting('testModeFlag')) {
			httpRequest.setUrl(setting("testApiUrl"));
		} else {
			httpRequest.setUrl(setting("apiUrl"));
		}
		httpRequest.setTimeout(variables.timeout);
		httpRequest.setResolveurl(false);
		for(var key in requestData){
			httpRequest.addParam(type="formfield",name="#key#",value="#requestData[key]#");
		}

		var response = httpRequest.send().getPrefix();

		return response;
	}

	private any function getResponseBean(required struct rawResponse, required any requestData, required any requestBean) {
		var response = new Slatwall.model.transient.payment.CreditCardTransactionResponseBean();

		// Convert the raw response data (URL key-value pairs) into an array
		var responseDataArray = listToArray(rawResponse.fileContent,variables.responseDelimiter,true);

		//Convert the array of key-value pairs into a struct
		var responseData = {};
		for(r in responseDataArray) {
			var key = listGetAt(r, 1 ,"=");
			var val = listGetAt(r, 2, "=");
			responseData[key] = val;
		}

		// Populate the data with the raw response & request
		var data = {
			responseData = arguments.rawResponse,
			requestData = arguments.requestData
		};

		response.setData(data);

		// Add message for what happened
		response.addMessage(messageName=responseData.error_code, message=responseData.auth_response_text);

		// Set the response Code
		response.setStatusCode(responseData.error_code);

		// Check to see if it was successful
		if(responseData.error_code != "000") {
			// Transaction did not go through
			response.addError(responseData.error_code, responseData.auth_response_text);
		} else {
			if(requestBean.getTransactionType() == "authorize" || requestBean.getTransactionType() == "authorizeAndCharge") {

				response.setAmountAuthorized(requestBean.getTransactionAmount());
				response.setAuthorizationCode(responseData.auth_code);

				if(responseData.avs_result == "S") {
					response.setAVSCode("U");
				} else {
					response.setAVSCode(responseData.avs_result);
				}

				if(!isNull(responseData.cvv2_result)) {
					if(responseData.cvv2_result == 'M') {
						response.setSecurityCodeMatch(true);
					} else {
						response.setSecurityCodeMatch(false);
					}
				}

				if(requestBean.getTransactionType() == "authorizeAndCharge") {
					response.setAmountCharged(requestBean.getTransactionAmount());
				}

			} else if(requestBean.getTransactionType() == "chargePreAuthorization") {

				response.setAmountCharged(requestBean.getTransactionAmount());

			} else if(requestBean.getTransactionType() == "credit") {

				response.setAmountCredited(requestBean.getTransactionAmount());

			}else if(requestBean.getTransactionType() == "generateToken") {
				response.setProviderToken(responseData.transaction_id);
			}
		}

		response.setTransactionID(responseData.transaction_id);

		return response;
	}

}
