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

component accessors="true" output="false" displayname="HyperWallet" implements="Slatwall.integrationServices.PaymentInterface" extends="Slatwall.integrationServices.BasePayment" {

	public any function init() {
		return this;
	}

	public string function getPaymentMethodTypes() {
		return "external";
	}
	
	public any function setting(required any requestBean) {
		// Allows settings to be requested in the context of the site where the order was created
		if (!isNull(arguments.requestBean.getOrder()) && !isNull(arguments.requestBean.getOrder().getOrderCreatedSite()) && !arguments.requestBean.getOrder().getOrderCreatedSite().getNewFlag()) {
			arguments.filterEntities = [arguments.requestBean.getOrder().getOrderCreatedSite()];
		} else if (!isNull(arguments.requestBean.getAccount()) && !isNull(arguments.requestBean.getAccount().getAccountCreatedSite())) {
			arguments.filterEntities = [arguments.requestBean.getAccount().getAccountCreatedSite()];
		}
		
		return super.setting(argumentCollection=arguments);
	}
	
	private struct function sendHttpAPIRequest(required any requestBean, required any responseBean, required string body) {
		var apiUrl = setting(settingName='apiUrlTest', requestBean=arguments.requestBean);
		var username = setting(settingName='usernameTest', requestBean=arguments.requestBean);
		var password = setting(settingName='passwordTest', requestBean=arguments.requestBean);
		
		// Set Live Endpoint Url if not testing
		if (!getTestModeFlag(arguments.requestBean, 'testMode')) {
			apiUrl = setting(settingName='apiUrlLive', requestBean=arguments.requestBean);
			username = setting(settingName='usernameLive', requestBean=arguments.requestBean);
			password = setting(settingName='passwordLive', requestBean=arguments.requestBean);
		}
		
		// writedump(var=arguments.body, top=2, abort=true );
		
		// Append appropriate API Resource
		if (arguments.requestBean.getTransactionType() == 'authorize') {
			apiUrl &= '/rest/v3/transfers';
		}
		
		var basicAuthCredentialsBase64 = toBase64('#username#:#password#');
		var httpRequest = new http();
		httpRequest.setUrl(apiUrl);
		httpRequest.setMethod('post');
		httpRequest.setCharset('UTF-8');
		httpRequest.addParam(type="header", name="Authorization", value="Basic #basicAuthCredentialsBase64#");
		httpRequest.addParam(type="header", name="Content-Type", value='application/json');
		httpRequest.addParam(type="header", name="Accept", value='application/json');
		httpRequest.addParam(type="body", value=serializeJSON(arguments.body));
		
		//writeDump(var='#username#:#password#', abort=true);

		// Make HTTP request to endpoint
		var httpResponse = httpRequest.send().getPrefix();
		
		writeDump(var=httpResponse, top=2, abort=true);
		
		var responseData = {};
		
		// Server error handling - Unavailable or Communication Problem
		if (httpResponse.status_code == 0 || left(httpResponse.status_code, 1) == 5 || left(httpResponse.status_code, 1) == 4) {
			arguments.responseBean.setStatusCode("ERROR");

			// Public error message
			arguments.responseBean.addError('serverCommunicationFault', "#rbKey('hyperWallet.error.serverCommunication_public')# #httpResponse.statusCode#");

			// Only for admin purposes
			arguments.responseBean.addMessage('serverCommunicationFault', "#rbKey('hyperWallet.error.serverCommunication_admin')# - #httpResponse.statusCode#. Check the payment transaction for more details.");
			
			// No response from server
			if (httpResponse.status_code == 0) {
				arguments.responseBean.addMessage('serverCommunicationFaultReason', "#httpResponse.statuscode#. #httpResponse.errorDetail#. Verify HyperWallet integration is configured using the proper endpoint URLs. Otherwise HyperWallet may be unavailable.");

			// Error response
			} else {
				arguments.responseBean.setStatusCode(httpResponse.status_code);
				arguments.responseBean.addMessage('errorStatusCode', "#httpResponse.status_code#");

				// Convert JSON response
				responseData = deserializeJSON(httpResponse.fileContent);
				
				// fileWrite('#logPath#/#timeSufix#_response.json',httpResponse.fileContent);
			
				if (structKeyExists(responseData, 'error')) {
					arguments.responseBean.addMessage('errorCode', "#responseData.error#");
				}

				if (structKeyExists(responseData, 'message')) {
					// Add additional instructions for unauthorized error.
					if (httpResponse.status_code == '401') {
						responseData.message &= ". Verify HyperWallet integration is configured using the proper credentials and encryption key/password.";
					}

					arguments.responseBean.addMessage('errorMessage', "#httpResponse.statuscode#. #responseData.message#");
				}
			}

			// Server response successful
		} else {
			arguments.responseBean.setStatusCode(httpResponse.status_code);

			// Convert JSON response
			responseData = deserializeJSON(httpResponse.fileContent);
			
			fileWrite('#logPath#/#timeSufix#_response.json',httpResponse.fileContent);

		}
		
		//writeDump(var=responseData, top=2, abort=true );
		
		return responseData;
	}
	
	public any function processTransfer(required any requestBean) {
		var responseBean = getTransient('ExternalTransactionResponseBean');
		
		//writeDump(var=responseBean, top=2, abort=true );

		// Execute request
		if (arguments.requestBean.getTransactionType() == "authorize") {
			
			var responseBody = '{
				"profileType": "INDIVIDUAL",
				"country": "US",
				"clientUserId": "t-1556733381649",
				"firstName": "Irta",
				"lastName": "John",
				"email": "irta.john@ten24web.com",
				"dateOfBirth": "1990-03-27",
				"addressLine1": "20 Franklin St Suite 400",
				"city": "Worcester",
				"stateProvince": "MA",
				"postalCode": "01608",
				"programToken": "prg-f0bfa8b9-a317-46f1-b330-6697a185541d"
			}';
			
			//responseBean =  sendHttpAPIRequest(arguments.requestBean, responseBean, '{}');
			sendHttpAPIRequest(arguments.requestBean, responseBean, responseBody);
		
		} else {
			throw("HyperWallet Integration has not been implemented to handle #arguments.requestBean.getTransactionType()#");
		}
		
		// if (!responseBean.hasErrors()) {
		// 	requestData = {
		// 		'token' = responseData.token,
		// 		'card' = {
		// 			'encryptedNumber' = toBase64(encryptCardNumber(arguments.requestBean.getCreditCardNumber(), getPublicKey(arguments.requestBean))),
		// 			'expirationMonth' = '1',// TODO: once working use: arguments.requestBean.getExpirationMonth()
		// 			'expirationYear' = '2022', // TODO: once working use: arguments.requestBean.getExpirationYear()
		// 			'cardHolderName' = 'Irta John', // TODO: once working use: arguments.requestBean.getNameOnCreditCard()
		// 			'securityCode' = '123' // TODO: once working use: arguments.requestBean.getSecurityCode()
		// 		},
		// 		'procesingOptions' = {
		// 			'verifyAvs' = '3' // TODO: once working use: setting(settingName='verifyAvsSetting', requestBean=arguments.requestBean),
		// 			// 'verifyCvc' = setting(settingName='verifyCvcFlag', requestBean=arguments.requestBean)
		// 		}
		// 	};
			// if (!responseBean.hasErrors()) {
			// 	// Extract data and set as part of the responseBean
			// 	arguments.responseBean.setProviderToken();
			// 	arguments.responseBean.setAmountReceived();
			// 	arguments.responseBean.setAmountCredited();
			// 	arguments.requestBean.getOriginalProviderTransactionID()
			// }
		// } else {
		// 	throw('ResponseBean Error');
		// }
		
		//writeDump(var=responseBean, top=2, abort=true );
		return responseBean;
		
	}
}
