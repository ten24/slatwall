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

component accessors="true" output="false" displayname="Fiserv Payment" implements="Slatwall.integrationServices.PaymentInterface" extends="Slatwall.integrationServices.BasePayment" {

		public any function init() {
			return this;
		}
	
		public string function getPaymentMethodTypes() {
			return "creditCard";
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
		
		private string function getStoreIDFromTemplate(required any requestBean){
			var storeID = "";
			var storeIDTemplate = setting(settingName='storeIDTemplate', requestBean=arguments.requestBean);
			
			if(!isNull(arguments.requestBean.getOrder()) && len(storeIDTemplate)){
				storeID = requestBean.getOrder().stringReplace(storeIDTemplate);
			}
			
			if(isNull(storeID) || !len(storeID)){
				storeID = "";
			}
			return storeID;
		}
		
		private string function getStoreID(required any requestBean){
			return setting(settingName='storeID', requestBean=arguments.requestBean);
		}
	
		// The main entry point to process credit card (Slatwall convention)
		public any function processCreditCard(required any requestBean) {

			var responseBean = getTransient('CreditCardTransactionResponseBean');
			
			// Set default currency
			if (isNull(arguments.requestBean.getTransactionCurrencyCode()) || !len(arguments.requestBean.getTransactionCurrencyCode())) {
				arguments.requestBean.setTransactionCurrencyCode(setting(settingName='skuCurrency', requestBean=arguments.requestBean));
			}
			
			// Adding currency to transaction message for admin purposes
			responseBean.addMessage('transactionCurrencyCode', arguments.requestBean.getTransactionCurrencyCode());

			// Execute request
			if (arguments.requestBean.getTransactionType() == "generateToken") {
				sendRequestToGenerateToken(arguments.requestBean, responseBean);
			} else if (arguments.requestBean.getTransactionType() == "authorize") {
				sendRequestToAuthorize(arguments.requestBean, responseBean);
			} else if (arguments.requestBean.getTransactionType() == "authorizeAndCharge") {
				sendRequestToAuthorizeAndCharge(arguments.requestBean, responseBean);
			} else if (arguments.requestBean.getTransactionType() == "chargePreAuthorization") {
				sendRequestToChargePreAuthorization(arguments.requestBean, responseBean);
			} else if (arguments.requestBean.getTransactionType() == "credit") {
				sendRequestToCredit(arguments.requestBean, responseBean);
			} else if (arguments.requestBean.getTransactionType() == "void") {
				sendRequestToVoid(arguments.requestBean, responseBean);
			} else {
				throw("Fiserv Intgration has not been implemented to handle #arguments.requestBean.getTransactionType()#");
			}
			
			return responseBean;
		}
		
		private void function sendRequestToGenerateToken(required any requestBean, required any responseBean) {

			// We are expecting there is no provider token yet, however if accountPaymentMethod is used and attempt to generate another token prevent and short circuit
			if (isNull(arguments.requestBean.getProviderToken()) || !len(arguments.requestBean.getProviderToken())) {
				
				var requestData = {
					  "requestType": "PaymentCardPaymentTokenizationRequest",
					  "paymentCard": {
					    "number": arguments.requestBean.getCreditCardNumber(),
					    "expiryDate": {
					      "month": numberFormat(arguments.requestBean.getExpirationMonth(),'09'),
					      "year": "#right(arguments.requestBean.getExpirationYear(),2)#"
					    }
					  },
					  "billingAddress": {
					    "address1": arguments.requestBean.getBillingStreetAddress(),
					    "city": arguments.requestBean.getBillingCity(),
					    "postalCode": arguments.requestBean.getBillingPostalCode(),
					    "country": arguments.requestBean.getBillingCountryCode()
					  },
					  "createToken": {
					    "reusable": true,
					    "declineDuplicates": false
					  },
					  "accountVerification": true,
					  "storeId": this.getStoreID(arguments.requestBean)
					};
					
				if(!isNull(arguments.requestBean.getSecurityCode()) && len(arguments.requestBean.getSecurityCode())) {
					requestData["paymentCard"]["securityCode"] = arguments.requestBean.getSecurityCode();
				}
				var responseData = sendHttpAPIRequest(arguments.requestBean, arguments.responseBean, 'generateToken', requestData);

				// Extract data and set as part of the responseBean
				if (!responseBean.hasErrors()) {
					arguments.responseBean.setProviderToken(responseData.paymentToken.value);
					arguments.responseBean.setProviderTransactionID(responseData.processor.referenceNumber);
				}
			} else {
				throw('Attempting to generate token. The payment method used already had a valid token');

				// Uneccessary to make API request because same token generated during accountPaymentMethod create is valid for subsequent authorization requests
				arguments.responseBean.setProviderToken(requestBean.getProviderToken());
				arguments.responseBean.setProviderTransactionID(requestBean.getOriginalProviderTransactionID());
			}
		}
		
		private void function sendRequestToAuthorize(required any requestBean, required any responseBean) {
			
			// currently ony support auth using token and not using CC
			var requestData = {
				  "transactionAmount": {
				    "total": LSParseNumber(arguments.requestBean.getTransactionAmount()),
				    "currency": arguments.requestBean.getTransactionCurrencyCode()
				  },
				  "requestType": "PaymentTokenPreAuthTransaction",
				  "paymentMethod": {
				    "paymentToken": {
				      "value": arguments.requestBean.getProviderToken(),
					   "expiryDate": {
					     "month": numberFormat(arguments.requestBean.getExpirationMonth(),'09'),
					     "year": "#right(arguments.requestBean.getExpirationYear(),2)#"
					   }
				    }
				  },
				  "storeId": this.getStoreIDFromTemplate(arguments.requestBean),
				  "order": {
				  	"orderId": "#requestBean.getTransactionID()#",
				  	"additionalDetails": {
				  		"invoiceNumber": "#requestBean.getOrder().getOrderID()#"
				  	},
				  	"billing": {
				  		"customerId": "#arguments.requestBean.getOrder().getAccount().getAccountID()#",
				  		"name": "#arguments.requestBean.getOrder().getAccount().getFirstName()# #arguments.requestBean.getOrder().getAccount().getLastName()#",
				  		"address": {
						    "address1": arguments.requestBean.getBillingStreetAddress(),
						    "city": arguments.requestBean.getBillingCity(),
						    "postalCode": arguments.requestBean.getBillingPostalCode(),
						    "country": arguments.requestBean.getBillingCountryCode()
						  }
				  	}
				  }
				};
			
			if(!isNull(arguments.requestBean.getSecurityCode()) && len(arguments.requestBean.getSecurityCode())) {
				requestData["paymentMethod"]["paymentToken"]["securityCode"] = arguments.requestBean.getSecurityCode();
			}
			
			var responseData = sendHttpAPIRequest(arguments.requestBean, arguments.responseBean, 'authorize', requestData);

			// Response Data
			if (!responseBean.hasErrors()) {
				arguments.responseBean.setProviderTransactionID(responseData.processor.referenceNumber);
				arguments.responseBean.setAmountAuthorized(responseData.approvedAmount.total);
			}
		}
		
		private void function sendRequestToAuthorizeAndCharge(required any requestBean, required any responseBean) {
			
			// currently ony support sale using token and not using CC
			var requestData = {
				  "transactionAmount": {
				    "total": LSParseNumber(arguments.requestBean.getTransactionAmount()),
				    "currency": arguments.requestBean.getTransactionCurrencyCode()
				  },
				  "requestType": "PaymentTokenSaleTransaction",
				  "paymentMethod": {
				    "paymentToken": {
				      "value": arguments.requestBean.getProviderToken(),
					   "expiryDate": {
					     "month": numberFormat(arguments.requestBean.getExpirationMonth(),'09'),
					     "year": "#right(arguments.requestBean.getExpirationYear(),2)#"
					   }
				    }
				  },
				  "storeId": this.getStoreIDFromTemplate(arguments.requestBean),
				  "order": {
				  	"orderId": "#requestBean.getTransactionID()#",
				  	"additionalDetails": {
				  		"invoiceNumber": "#requestBean.getOrder().getOrderID()#"
				  	},
				  	"billing": {
				  		"customerId": "#arguments.requestBean.getOrder().getAccount().getAccountID()#",
				  		"name": "#arguments.requestBean.getOrder().getAccount().getFirstName()# #arguments.requestBean.getOrder().getAccount().getLastName()#",
				  		"address": {
						    "address1": arguments.requestBean.getBillingStreetAddress(),
						    "city": arguments.requestBean.getBillingCity(),
						    "postalCode": arguments.requestBean.getBillingPostalCode(),
						    "country": arguments.requestBean.getBillingCountryCode()
						  }
				  	}
				  }
				};
				
			var responseData = sendHttpAPIRequest(arguments.requestBean, arguments.responseBean, 'authorizeAndCharge', requestData);
			
			if (!responseBean.hasErrors()) {
				arguments.responseBean.setProviderTransactionID(responseData.processor.referenceNumber);
				arguments.responseBean.setAmountAuthorized(responseData.approvedAmount.total);
				arguments.responseBean.setAmountReceived(responseData.approvedAmount.total);
			}
		}
		
		private void function sendRequestToChargePreAuthorization(required any requestBean, required any responseBean) {
			if (!isNull(arguments.requestBean.getOriginalAuthorizationProviderTransactionID()) && len(arguments.requestBean.getOriginalAuthorizationProviderTransactionID())) {
				
				var requestData = {
					  "requestType": "PostAuthTransaction",
					  "transactionAmount": {
					    "total": LSParseNumber(arguments.requestBean.getTransactionAmount()),
					    "currency": arguments.requestBean.getTransactionCurrencyCode()
					  },
					  "storeId": this.getStoreIDFromTemplate(arguments.requestBean)
					};
					
				var responseData = sendHttpAPIRequest(arguments.requestBean, arguments.responseBean, 'chargePreAuthorization', requestData);

				if (!responseBean.hasErrors()) {
					arguments.responseBean.setProviderTransactionID(responseData.processor.referenceNumber);
					arguments.responseBean.setAmountReceived(responseData.approvedAmount.total);
				}
			} else {
				throw("There is no 'originalAuthorizationProviderTransactionID' in the transactionRequestBean. Expecting the value be the authorization code to reference for the charge/capture.");
			}
		}
		
		private void function sendRequestToCredit(required any requestBean, required any responseBean) {

			var requestData = {
				"transactionAmount": {
					"total": LSParseNumber(arguments.requestBean.getTransactionAmount()),
					"currency": arguments.requestBean.getTransactionCurrencyCode()
				},
				"requestType": "PaymentTokenCreditTransaction",
				"paymentMethod": {
					"paymentToken": {
						"value": arguments.requestBean.getProviderToken(),
						"function": "CREDIT",
						"securityCode": arguments.requestBean.getSecurityCode(),
						"expiryDate": {
					    	"month": numberFormat(arguments.requestBean.getExpirationMonth(),'09'),
					    	"year": "#right(arguments.requestBean.getExpirationYear(),2)#"
						}
					}
				},
				"storeId": this.getStoreIDFromTemplate(arguments.requestBean)
			}
			var responseData = sendHttpAPIRequest(arguments.requestBean, arguments.responseBean, 'credit', requestData);

			if (!responseBean.hasErrors()) {
				arguments.responseBean.setProviderTransactionID(responseData.processor.referenceNumber);
				arguments.responseBean.setAmountCredited(responseData.approvedAmount.total);
			}

		}
		
		private void function sendRequestToVoid(required any requestBean, required any responseBean) {
			if (!isNull(arguments.requestBean.getOriginalProviderTransactionID()) && len(arguments.requestBean.getOriginalProviderTransactionID())) {
				
				var requestData = {
					  "requestType": "VoidTransaction"
					};
					
				var responseData = sendHttpAPIRequest(arguments.requestBean, arguments.responseBean, 'void', requestData);
				
				if (!responseBean.hasErrors()) {
					arguments.responseBean.setProviderTransactionID(responseData.processor.referenceNumber);
				}
			} else {
				throw("There is no 'originalProviderTransactionID' in the transactionRequestBean. Expecting the value be a reference to transactionID for the original charge/capture or credit.");
			}
		}
		
		private any function createAPIRequestData(required any requestBean, any payload = "") {
			var apiRequestData = {};
			var apiSecret = setting(settingName='apiSecret', requestBean=arguments.requestBean);
			
			apiRequestData["apiKey"] = setting(settingName='apiKey', requestBean=arguments.requestBean);
			apiRequestData["clientRequestId"] = createUUID();
			apiRequestData["timeStamp"] = now().getTime();
	
			apiRequestData["payload"] = serializeJSON(arguments.payload);
			
			var message = apiRequestData["apiKey"] & apiRequestData["clientRequestId"] & apiRequestData["timeStamp"] & apiRequestData["payload"];
			
			if (isNull(apiSecret) || !len(apiSecret)) {
				apiRequestData['errors'] = [{
					'key': 'apiSecretKeyInvalid',
					'message': 'api secret key is empty'
				}];
				return apiRequestData;
			}
	
			apiRequestData["signature"] = toBase64(lcase(hmac( message=message, key=apiSecret, algorithm='HMACSHA256' )));
			return apiRequestData;
		}
		
		private any function sendHttpAPIRequest(required any requestBean, required any responseBean, required string transactionName, required struct data) {
			var apiUrl = setting(settingName='apiUrlTest', requestBean=arguments.requestBean);

			// Set Live Endpoint Url if not testing
			if (getLiveModeFlag(arguments.requestBean, 'liveModeFlag')) {
				apiUrl = setting(settingName='apiUrlLive', requestBean=arguments.requestBean);
			}
			
			// Append appropriate API Resource
			if (arguments.transactionName == 'generateToken') {
				apiUrl &= '/payment-tokens';
			} else if (arguments.transactionName == 'authorize') {
				apiUrl &= '/payments';
			} else if (arguments.transactionName == 'authorizeAndCharge') {
				apiUrl &= '/payments';
			} else if (arguments.transactionName == 'chargePreAuthorization') {
				apiUrl &= '/payments/#arguments.requestBean.getOriginalProviderTransactionID()#';
			} else if (arguments.transactionName == 'credit') {
				apiUrl &= '/payments';
			} else if (arguments.transactionName == 'void') {
				apiUrl &= '/payments/#arguments.requestBean.getOriginalProviderTransactionID()#';
			}
			
			var httpRequest = new http();
			httpRequest.setUrl(apiUrl);
			httpRequest.setMethod('POST');
			httpRequest.setCharset('UTF-8');
	
			var apiRequestData = createAPIRequestData(arguments.requestBean, arguments.data);
			
			if (structKeyExists(apiRequestData, 'errors')) {
				for (var error in apiRequestData['errors']) {
					arguments.responseBean.addError(error['key'], error['message']);
				}
				return arguments.responseBean;
			}
			
			httpRequest.addParam(type="header", name="Content-Type", value="application/json");
			httpRequest.addParam(type="header", name="Api-Key", value="#apiRequestData['apiKey']#");
			httpRequest.addParam(type="header", name="Client-Request-Id", value="#apiRequestData['clientRequestId']#");
			httpRequest.addParam(type="header", name="Timestamp", value="#apiRequestData['Timestamp']#");
			httpRequest.addParam(type="header", name="Message-Signature", value="#apiRequestData['signature']#");
			httpRequest.addParam(type="body", value="#apiRequestData['payload']#");
			
			
			// Make HTTP request to endpoint
			var httpResponse = httpRequest.send().getPrefix();
			var responseCopy = duplicate(httpResponse);
			var responseData = deserializeJSON( httpResponse.filecontent );
			
			if( setting(settingName='debugModeFlag', requestBean=arguments.requestBean ) ) {
				structDelete(responseCopy, 'paymentCard');
				var _regex = '((,|)"(number|securityCode|value)":(("[^"]+.(,|))|(null)))';
				var req = REReplace(apiRequestData['payload'], _regex,"","ALL");
				responseBean.addMessage("Request", req);
				responseBean.addMessage("Response", serializeJSON(responseCopy));
			}
			
			// Server error handling - Unavailable or Communication Problem
			if (httpResponse.status_code == 0 || left(httpResponse.status_code, 1) == 5 || left(httpResponse.status_code, 1) == 4) {
				arguments.responseBean.setStatusCode("ERROR");

				// Public error message
				if ( isStruct( responseData ) && structKeyExists( responseData, 'message' ) ) {
					arguments.responseBean.addError( 'serverCommunicationFault', responseContent.message );
				} else {
					arguments.responseBean.addError( 'serverCommunicationFault', "#rbKey('fiserv.error.serverCommunication_public')# #httpResponse.statusCode#" );
				}
				
				// No response from server
				if (httpResponse.status_code == 0) {
					arguments.responseBean.addMessage('serverCommunicationFaultReason', "#httpResponse.statuscode#. #httpResponse.errorDetail#. #rbKey('fiserv.error.serverCommunicationFaultReason')#");
	
				// Error response
				} else {
					arguments.responseBean.setStatusCode(httpResponse.status_code);
					arguments.responseBean.addMessage('errorStatusCode', "#httpResponse.status_code#");

					if(
						structKeyExists(responseData, 'error') 
						&& structKeyExists(responseData.error, 'details') 
						&& isArray(responseData.error.details) 
						&& arrayLen(responseData.error.details)
					){
						arguments.responseBean.addError(responseData.error.code, responseData['error']['details'][1]['field'] & ' - ' & responseData['error']['details'][1]['message']);	
						arguments.responseBean.addMessage(responseData.error.code, responseData['error']['details'][1]['field'] & ' - ' & responseData['error']['details'][1]['message']);			
					}else if (structKeyExists(responseData, 'error') && structKeyExists(responseData.error, 'message')) {
						arguments.responseBean.addError(responseData.error.code, responseData.error.message);
						arguments.responseBean.addMessage(responseData.error.code, responseData.error.message);
					}else if(
							structKeyExists(responseData, 'processor') 
							&& structKeyExists(responseData['processor'], 'responseMessage')
							&& structKeyExists(responseData, 'responseType') 
							&& responseData['responseType'] == 'EndpointDeclined'
						){
						arguments.responseBean.addError(responseData.processor.responseCode, responseData.processor.responseMessage);
						arguments.responseBean.addMessage(responseData.processor.responseCode, responseData.processor.responseMessage);			
					}
		
				}
	
			// Server response successful
			} else {
				if(structKeyExists(responseData,"processor") && structKeyExists(responseData.processor,"responseCode")){
					arguments.responseBean.setStatusCode(responseData.processor.responseCode);
				}
				
				if(structKeyExists(responseData,"processor") && structKeyExists(responseData.processor,"authorizationCode")){
					arguments.responseBean.setAuthorizationCode(responseData.processor.authorizationCode);
				}

				if(structKeyExists(responseData,"processor") && structKeyExists(responseData.processor,"avsResponse")){
					if(responseData.processor.avsResponse["streetMatch"] == 'Y' && responseData.processor.avsResponse["postalCodeMatch"] == 'Y') {
						arguments.responseBean.setAVSCode("Y");
					} else if(responseData.processor.avsResponse["streetMatch"] == 'N' && responseData.processor.avsResponse["postalCodeMatch"] == 'Y') {
						arguments.responseBean.setAVSCode("Z");
					} else if(responseData.processor.avsResponse["streetMatch"] == 'Y' && responseData.processor.avsResponse["postalCodeMatch"] == 'N') {
						arguments.responseBean.setAVSCode("A");
					} else if(responseData.processor.avsResponse["streetMatch"] == 'N' && responseData.processor.avsResponse["postalCodeMatch"] == 'N') {
						arguments.responseBean.setAVSCode("N");
					}
				} else {
					arguments.responseBean.setAVSCode("E");
				}
				
				if(structKeyExists(responseData,"processor") && structKeyExists(responseData.processor,"securityCodeResponse") && responseData.processor.securityCodeResponse == 'MATCHED') {
					arguments.responseBean.setSecurityCodeMatch(true);
				} else {
					arguments.responseBean.setSecurityCodeMatch(false);
				}
				

			}
			
			// Populate the data with the raw response & request
			var data = {
				httpResponse = httpResponse,
				responseDataStruct = responseData
			};
			
			arguments.responseBean.setData(data);

			return responseData;
		}
	
		public any function testIntegration() {
			var requestBean = new Slatwall.model.transient.payment.CreditCardTransactionRequestBean();

			var testAccount = getHibachiScope().getAccount();
			var testOrder = getService('orderService').newOrder();
			testOrder.setOrderID(getHibachiScope().createHibachiUUID());
			testOrder.setAccount(testAccount);

			requestBean.setOrder(testOrder);
			requestBean.setTransactionType('generateToken');
			requestBean.setTransactionCurrencyCode('USD');
			requestBean.setCreditCardNumber('4484640000000042');
			requestBean.setSecurityCode('123');
			requestBean.setExpirationMonth('12');
			requestBean.setExpirationYear('25');
			requestBean.setTransactionAmount('11.00');
			requestBean.setAccountFirstName(testAccount.getFirstName());
			requestBean.setAccountLastName(testAccount.getLastName());
			
			var responseBean = processCreditCard(requestBean); 
			if( responseBean.getStatusCode() != "00") return responseBean;

			var token = responseBean.getProviderToken();
			
			// now try to authorize
			requestBean.setTransactionID(getHibachiScope().createHibachiUUID());
			requestBean.setTransactionType('authorize');
			requestBean.setProviderToken(token);
			responseBean = processCreditCard(requestBean);
			if( responseBean.getStatusCode() != "00") return responseBean;
			
			// now try to capture
			requestBean.setTransactionType('chargePreAuthorization');
			requestBean.setOriginalProviderTransactionID(responseBean.getProviderTransactionID());
			requestBean.setOriginalAuthorizationProviderTransactionID(responseBean.getProviderTransactionID());
			responseBean = processCreditCard(requestBean);
			if( responseBean.getStatusCode() != "00") return responseBean;
			
			// now try to do sale
			requestBean.setTransactionID(getHibachiScope().createHibachiUUID());
			testOrder.setOrderID(getHibachiScope().createHibachiUUID());
			requestBean.setTransactionType('authorizeAndCharge');
			requestBean.setProviderToken(token);
			responseBean = processCreditCard(requestBean);
			if( responseBean.getStatusCode() != "00") return responseBean;
			
			// now try to do sale again for the same order
			requestBean.setTransactionID(getHibachiScope().createHibachiUUID());
			requestBean.setTransactionType('authorizeAndCharge');
			requestBean.setProviderToken(token);
			responseBean = processCreditCard(requestBean);
			if( responseBean.getStatusCode() != "00") return responseBean;
			
			// now try to credit
			requestBean.setTransactionType('credit');
			requestBean.setOriginalProviderTransactionID(responseBean.getProviderTransactionID());
			requestBean.setOriginalChargeProviderTransactionID(responseBean.getProviderTransactionID());
			responseBean = processCreditCard(requestBean);
			if( responseBean.getStatusCode() != "00") return responseBean;
			
			// and finally void
			requestBean.setTransactionType('void');
			requestBean.setOriginalProviderTransactionID(responseBean.getProviderTransactionID());
			responseBean = processCreditCard(requestBean);
			
			ORMClearSession();
			
			return responseBean;
		}

}