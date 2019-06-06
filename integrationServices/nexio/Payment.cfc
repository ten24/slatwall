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

component accessors="true" output="false" displayname="Nexio" implements="Slatwall.integrationServices.PaymentInterface" extends="Slatwall.integrationServices.BasePayment" {

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

		// Helper method to get proper public key value
		private string function getPublicKey(required any requestBean) {
			var publicKey = setting(settingName='publicKeyTest', requestBean=arguments.requestBean);
			
			// Set Live Endpoint Url if not testing
			if (!getTestModeFlag(arguments.requestBean, 'testMode')) {
				publicKey = setting(settingName='publicKeyLive', requestBean=arguments.requestBean);
			}

			return publicKey;
		}
		
		// The main entry point to process credit card (Slatwall convention)
		public any function processCreditCard(required any requestBean) {
			verifyServerCompatibility();

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
			} else if (arguments.requestBean.getTransactionType() == "deleteToken") {
				sendRequestToDeleteTokens(arguments.requestBean, responseBean);
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
				throw("Nexio Payment Intgration has not been implemented to handle #arguments.requestBean.getTransactionType()#");
			}
			
			return responseBean;
		}

		// Verifies that server meets Nexio specific minimum Lucee 5.3 requirement (RSA encryption introduced as new feature in Lucee 5.3 https://docs.lucee.org/guides/cookbooks/Encrypt_Decrypt.html)
		public void function verifyServerCompatibility() {
			if (!structKeyExists(variables, 'serverCompatibleFlag')) {
				variables.serverCompatibleFlag = false;

				if (structKeyExists(server,'lucee')) {

					// Convert server version into semver components to verify compatibility
					var semVer = {
						versionLength = listLen(server.lucee.version, '.'),
						fullVersion = server.lucee.version,
						majorVersion = listFirst(server.lucee.version, '.'),
						minorVersion = 0
					}

					if (semVer.versionLength >= 2) {
						semVer.minorVersion = listGetAt(semVer.fullVersion, 2, '.');
					}

					// Verify version is 5.3 or above
					if (semVer.majorVersion > 5 || (semVer.majorVersion == 5 && semVer.minorVersion >= 3)) {
						variables.serverCompatibleFlag = true;
					}
				}
			}

			if (!variables.serverCompatibleFlag) {
				throw('Nexio payment integration: Incompatible server version. Current version does not support the RSA encryption dependency. Upgrade server to at least version 5.3 to resolve issue.');
			}
		}

		// Nexio relies on 3rd party TokenEx for tokenization. It uses PKCS #1 v1.5 as cipher algorithm for RSA encryption
		private any function encryptCardNumber(required string cardNumber, required string publicKey) {
			var secureRandom = createObject("java", "java.security.SecureRandom").init();
			var cipher = createObject("java", "javax.crypto.Cipher").getInstance("RSA/ECB/PKCS1Padding", "SunJCE"); // This also is equivalent: getInstance("RSA/None/PKCS1Padding", "BC") for BouncyCastle (org.bouncycastle.jce.provider.BouncyCastleProvider)

			// Convert public key from string to java Key object
			// First need to convert raw string to ByteArray
			var publicKeySpec = createObject('java', 'java.security.spec.X509EncodedKeySpec').init(toBinary(arguments.publicKey));
			var keyFactory = createObject('java', 'java.security.KeyFactory').getInstance('RSA');
			var key = keyFactory.generatePublic(publicKeySpec);
			cipher.init(createObject("java", "javax.crypto.Cipher").ENCRYPT_MODE, key, secureRandom);
			
			return cipher.doFinal(toBinary(toBase64(arguments.cardNumber)));
		}
		
		private void function sendRequestToGenerateToken(required any requestBean, required any responseBean) {
			// We are expecting there is no provider token yet, however if accountPaymentMethod is used and attempt to generate another token prevent and short circuit
			if (isNull(arguments.requestBean.getProviderToken()) || !len(arguments.requestBean.getProviderToken())) {
				
				if (!isNull(arguments.requestBean.getOrderPayment().getOrderPaymentType().getTypeName() ==="Charge")) {
					var paymentMethod = "creditCard";
				} else {
					var paymentMethod = null;
				}
				
				var publicKey = getPublicKey(arguments.requestBean);
				
				// writeDump(var=arguments.requestBean, abort=true);
				
				var requestData = {
					'isAuthOnly': false,
					'card' = {
						'encryptedNumber' = toBase64(encryptCardNumber(arguments.requestBean.getCreditCardNumber(), getPublicKey(arguments.requestBean))),
						'expirationMonth' = LSParseNumber(arguments.requestBean.getExpirationMonth()),
						'expirationYear' = LSParseNumber(arguments.requestBean.getExpirationYear()), 
						'cardHolderName' = arguments.requestBean.getNameOnCreditCard(), 
						'securityCode' = LSParseNumber(arguments.requestBean.getSecurityCode())
					},
					// 'uiOptions': {
					// 	'hideCvc': false,
					// 	'hideBilling' = false,
					// },
					'processingOptions' = {
						'checkFraud' = (setting(settingName='checkFraud', requestBean=arguments.requestBean)? true : false),
						'verifyCvc' = (setting(settingName='verifyCvcFlag', requestBean=arguments.requestBean)? true : false),
						'verifyAvs' = LSParseNumber(setting(settingName='verifyAvsSetting', requestBean=arguments.requestBean)),
						'verboseResponse' = true
					},
					'data' = {
						'paymentMethod' = paymentMethod,
						'amount' = arguments.requestBean.getTransactionAmount(),
						// 'amount': arguments.requestBean.getOrder().getCalculatedTotal(),
						// 'partialAmount': LSParseNumber(arguments.requestBean.getTransactionAmount()),
						'currency' = arguments.requestBean.getTransactionCurrencyCode(),
						'customer'= {
							'orderNumber' = arguments.requestBean.getOrderID(),
							'firstName' = arguments.requestBean.getAccountFirstName(),
							'lastName' = arguments.requestBean.getAccountLastName(),
							'customerRef' = arguments.requestBean.getAccountID(),
							'billToAddressOne' = arguments.requestBean.getBillingStreetAddress(),
							'billToAddressTwo' = arguments.requestBean.getBillingStreet2Address(),
							'billToCity' = arguments.requestBean.getBillingCity(),
							'billToState' = arguments.requestBean.getBillingStateCode(),
							'billToPostal' = arguments.requestBean.getBillingPostalCode(),
							'billToCountry' = arguments.requestBean.getBillingCountryCode()
						}
					}
					// 'customFields'= {
				       //'orderPaymentID' = arguments.requestBean.getOrderPaymentID()
					// },
				};
				
				// writeDump(var="*** 1st requestData");	
				// writeDump(var=requestData);	
				
				// One Time Use Token (https://github.com/nexiopay/payment-service-example-node/blob/master/ClientSideToken.js#L23)
				responseData = sendHttpAPIRequest(arguments.requestBean, arguments.responseBean, 'generateOneTimeUseToken', requestData);
				
				// writeDump(var="*** 1st responseData");
				// writeDump(var=responseData);
				
				if (!responseBean.hasErrors()) {
					arguments.responseBean.addMessage(messageName="nexio.fraudUrl", message="#responseData.fraudUrl#");
				}
				
				// writeDump(var="*** 1st arguments.responseBean");
				// writeDump(var=arguments.responseBean);
				
				if (!responseBean.hasErrors()) {
					requestData = {
						'token' = responseData.token,
						'card' = {
							'encryptedNumber' = toBase64(encryptCardNumber(arguments.requestBean.getCreditCardNumber(), getPublicKey(arguments.requestBean))),
							'expirationMonth' = LSParseNumber(arguments.requestBean.getExpirationMonth()),
							'expirationYear' = LSParseNumber(arguments.requestBean.getExpirationYear()), 
							'cardHolderName' = arguments.requestBean.getNameOnCreditCard(), 
							'securityCode' = LSParseNumber(arguments.requestBean.getSecurityCode())
						}
						// 'customFields'= {
				           //'orderID' = arguments.requestBean.getOrderID(),
					       //'orderPaymentID' = arguments.requestBean.getOrderPaymentID()
						// },
						// 'customer'= {
						// 	'customerRef' = arguments.requestBean.getAccountID(),
						// 	'billToAddressOne' = arguments.requestBean.getBillingStreetAddress(),
						// 	'billToAddressTwo' = arguments.requestBean.getBillingStreet2Address(),
						// 	'billToCity' = arguments.requestBean.getBillingCity(),
						// 	'billToState' = arguments.requestBean.getBillingStateCode(),
						// 	'billToPostal' = arguments.requestBean.getBillingPostalCode(),
						// 	'billToCountry' = arguments.requestBean.getBillingCountryCode(),
						// },
						// 'processingOptions' = {
						// 	'verifyAvs' = setting(settingName='verifyAvsSetting', requestBean=arguments.requestBean),
						// 	'verifyCvc' = setting(settingName='verifyCvcFlag', requestBean=arguments.requestBean)
						// }
					};

					// Save Card, this is the imortant token we want to persist for Slatwall payment data (https://github.com/nexiopay/payment-service-example-node/blob/master/ClientSideToken.js#L107)
					responseData = sendHttpAPIRequest(arguments.requestBean, arguments.responseBean, 'generateToken', requestData);
				
				// writeDump(var="*** 2nd requestData");
				// writeDump(var=requestData);
				
				// writeDump(var="*** 2nd responseData");
				// writeDump(var=responseData);
				
				
					// Extract data and set as part of the responseBean
					if (!responseBean.hasErrors()) {
						arguments.responseBean.setProviderTransactionID(arguments.requestBean.getOriginalProviderTransactionID());
						arguments.responseBean.setProviderToken(responseData.token.token);
						arguments.responseBean.setAuthorizationCode(arguments.requestBean.getOriginalAuthorizationCode());
						// arguments.responseBean.setAvsCode(responseData.cvcResults.gatewayMessage.cvvresponse);

						arguments.responseBean.addMessage(messageName="nexio.key", message="#responseData.key#");
						arguments.responseBean.addMessage(messageName="nexio.kountResponse.status", message="#responseData.kountResponse.status#");
						arguments.responseBean.addMessage(messageName="nexio.kountResponse.rules", message="#responseData.kountResponse.rules#");
						arguments.responseBean.addMessage(messageName="nexio.avsResults.error", message="#responseData.avsResults.error#");
						arguments.responseBean.addMessage(messageName="nexio.avsResults.gatewayMessage.avsresponse", message="#responseData.avsResults.gatewayMessage.avsresponse#");
						arguments.responseBean.addMessage(messageName="nexio.avsResults.gatewayMessage.message", message="#responseData.avsResults.gatewayMessage.message#");
						arguments.responseBean.addMessage(messageName="nexio.cvcResults.error", message="#responseData.cvcResults.error#");
						arguments.responseBean.addMessage(messageName="nexio.cvcResults.gatewayMessage.cvvresponse", message="#responseData.cvcResults.gatewayMessage.cvvresponse#");
						arguments.responseBean.addMessage(messageName="nexio.cvcResults.gatewayMessage.message", message="#responseData.cvcResults.gatewayMessage.message#");
					
				// writeDump(var="*** arguments.responseBean");
				// writeDump(var=arguments.responseBean);
					}
				}
			} else {
				throw('Attempting to generate token. The payment method used already had a valid token');

				// Uneccessary to make API request because same token generated during accountPaymentMethod create is valid for subsequent authorization requests
				if (!responseBean.hasErrors()) {
					// arguments.responseBean.setProviderToken(responseData.token.token);
					arguments.responseBean.setProviderTransactionID(arguments.requestBean.getOriginalProviderTransactionID());
					arguments.responseBean.setAuthorizationCode(arguments.requestBean.getOriginalAuthorizationCode());
					// arguments.responseBean.setAvsCode(responseData.cvcResults.gatewayMessage.cvvresponse);
					
					arguments.responseBean.addMessage(messageName="nexio.key", message="#responseData.key#");
					arguments.responseBean.addMessage(messageName="nexio.kountResponse.status", message="#responseData.kountResponse.status#");
					arguments.responseBean.addMessage(messageName="nexio.kountResponse.rules", message="#responseData.kountResponse.rules#");
					arguments.responseBean.addMessage(messageName="nexio.avsResults.error", message="#responseData.avsResults.error#");
					arguments.responseBean.addMessage(messageName="nexio.avsResults.gatewayMessage.avsresponse", message="#responseData.avsResults.gatewayMessage.avsresponse#");
					arguments.responseBean.addMessage(messageName="nexio.avsResults.gatewayMessage.message", message="#responseData.avsResults.gatewayMessage.message#");
					arguments.responseBean.addMessage(messageName="nexio.cvcResults.error", message="#responseData.cvcResults.error#");
					arguments.responseBean.addMessage(messageName="nexio.cvcResults.gatewayMessage.cvvresponse", message="#responseData.cvcResults.gatewayMessage.cvvresponse#");
					arguments.responseBean.addMessage(messageName="nexio.cvcResults.gatewayMessage.message", message="#responseData.cvcResults.gatewayMessage.message#");
				}
			}
		}
		
		private void function sendRequestToDeleteTokens(required array tokens) {
			// var requestBean = getTransient('CreditCardTransactionRequestBean');
			// var responseBean = getTransient('CreditCardTransactionResponseBean');
			// var requestData = {};
			
			// requestData.tokens = arguments.tokens;
			
			// sendHttpAPIRequest(requestBean, responseBean, 'deleteToken', requestData);
			
			// return responseBean;
			// Add  any error handling about if a token is bad etc.
		}
		
		private void function sendRequestToAuthorize(required any requestBean, required any responseBean) {
			// Request Data
			if (!arguments.requestBean.hasErrors() && !isNull(arguments.requestBean.getProviderToken()) && len(arguments.requestBean.getProviderToken())) {
				var requestData = {
					"isAuthOnly": true,
					"tokenex":{
						'token' = arguments.requestBean.getProviderToken()
				    },
				    "card":{
				    	"expirationMonth": arguments.requestBean.getExpirationMonth(),
				    	"expirationYear": arguments.requestBean.getExpirationYear(),
				    	"cardHolderName": arguments.requestBean.getNameOnCreditCard(),
				    	"lastFour": arguments.requestBean.getCreditCardLastFour()
				    },
				    "data": {
				      "currency": arguments.requestBean.getTransactionCurrencyCode(),
				      "amount": arguments.requestBean.getTransactionAmount()
				    },
				    "processingOptions":{
					    "checkFraud": setting(settingName='checkFraud', requestBean=arguments.requestBean),
					    "verifyAvs": setting(settingName='verifyAvsSetting', requestBean=arguments.requestBean),
					    "verifyCvc": setting(settingName='verifyCvcFlag', requestBean=arguments.requestBean),
					    'merchantID': setting(settingName='merchantIDTest', requestBean=arguments.requestBean)
				    }
				};	
				responseData = sendHttpAPIRequest(arguments.requestBean, arguments.responseBean, 'authorize', requestData);
				
				// Response Data
				if (!responseBean.hasErrors()) {
					arguments.responseBean.setProviderToken(requestData.tokenex.token);
					arguments.responseBean.setProviderTransactionID(responseData.id);
					arguments.responseBean.setAuthorizationCode(responseData.authCode);
					arguments.responseBean.setAmountAuthorized(responseData.data.amount);
					// arguments.responseBean.setAmountReceived(responseData.amount);
					
					arguments.responseBean.addMessage(messageName="nexio.transactionDate", message="#responseData.transactionDate#");
					arguments.responseBean.addMessage(messageName="nexio.transactionStatus", message="#responseData.transactionStatus#");
					arguments.responseBean.addMessage(messageName="nexio.transactionType", message="#responseData.transactionType#");
					arguments.responseBean.addMessage(messageName="nexio.transactionCurrency", message="#responseData.currency#");
					arguments.responseBean.addMessage(messageName="nexio.gatewayResponse.result", message="#responseData.gatewayResponse.result#");
					arguments.responseBean.addMessage(messageName="nexio.gatewayResponse.batchRef", message="#responseData.gatewayResponse.batchRef#");
					arguments.responseBean.addMessage(messageName="nexio.gatewayResponse.refNumber", message="#responseData.gatewayResponse.refNumber#");
					arguments.responseBean.addMessage(messageName="nexio.gatewayResponse.gatewayName", message="#responseData.gatewayResponse.gatewayName#");
					arguments.responseBean.addMessage(messageName="nexio.cardNumber", message="#responseData.card.cardNumber#");
				}
			} else {
				throw('Error attempting to authorize. Review providerToken.');
			}
		}
		
		private void function sendRequestToAuthorizeAndCharge(required any requestBean, required any responseBean) {
			// Request Data
			if (!arguments.requestBean.hasErrors() && !isNull(arguments.requestBean.getProviderToken()) && len(arguments.requestBean.getProviderToken())) {
				var requestData = {
					"isAuthOnly": false,
					"tokenex":{
						'token' = arguments.requestBean.getProviderToken()
				    },
				    "card":{
				    	"expirationMonth": arguments.requestBean.getExpirationMonth(),
				    	"expirationYear": arguments.requestBean.getExpirationYear(),
				    	"cardHolderName": arguments.requestBean.getNameOnCreditCard(),
				    	"lastFour": arguments.requestBean.getCreditCardLastFour()
				    },
				    "data": {
				      "currency": arguments.requestBean.getTransactionCurrencyCode(),
				      "amount": arguments.requestBean.getTransactionAmount()
				    },
				    "processingOptions":{
					    "checkFraud": setting(settingName='checkFraud', requestBean=arguments.requestBean),
					    "verifyAvs": setting(settingName='verifyAvsSetting', requestBean=arguments.requestBean),
					    "verifyCvc": setting(settingName='verifyCvcFlag', requestBean=arguments.requestBean),
					    'merchantID': setting(settingName='merchantIDTest', requestBean=arguments.requestBean)
				    }
				};	

				responseData = sendHttpAPIRequest(arguments.requestBean, arguments.responseBean, 'authorizeAndCharge', requestData);
				
				// Response Data
				if (!responseBean.hasErrors()) {
					arguments.responseBean.setProviderToken(requestData.tokenex.token);
					arguments.responseBean.setProviderTransactionID(responseData.id);
					arguments.responseBean.setAuthorizationCode(responseData.authCode);
					arguments.responseBean.setAmountReceived(responseData.amount);
					arguments.responseBean.setAmountAuthorized(responseData.data.amount);
					
					arguments.responseBean.addMessage(messageName="nexio.transactionDate", message="#responseData.transactionDate#");
					arguments.responseBean.addMessage(messageName="nexio.transactionStatus", message="#responseData.transactionStatus#");
					arguments.responseBean.addMessage(messageName="nexio.transactionType", message="#responseData.transactionType#");
					arguments.responseBean.addMessage(messageName="nexio.transactionCurrency", message="#responseData.currency#");
					arguments.responseBean.addMessage(messageName="nexio.gatewayResponse.result", message="#responseData.gatewayResponse.result#");
					arguments.responseBean.addMessage(messageName="nexio.gatewayResponse.batchRef", message="#responseData.gatewayResponse.batchRef#");
					arguments.responseBean.addMessage(messageName="nexio.gatewayResponse.refNumber", message="#responseData.gatewayResponse.refNumber#");
					arguments.responseBean.addMessage(messageName="nexio.gatewayResponse.gatewayName", message="#responseData.gatewayResponse.gatewayName#");
					arguments.responseBean.addMessage(messageName="nexio.cardNumber", message="#responseData.card.cardNumber#");
				}
			} else {
				throw('Error attempting to authorize and charge. Review providerToken.');
			}
		}
		
		private void function sendRequestToChargePreAuthorization(required any requestBean, required any responseBean) {
			if (!isNull(arguments.requestBean.getOriginalAuthorizationProviderTransactionID()) && len(arguments.requestBean.getOriginalAuthorizationProviderTransactionID())) {
				// Request Data
				var requestData = {
					"tokenex":{
						'token' = arguments.requestBean.getProviderToken()
				    },
					'data': {
						'amount': arguments.requestBean.getTransactionAmount(),
			    	},
			    	'id': arguments.requestBean.getOriginalAuthorizationProviderTransactionID()
				}
	
				responseData = sendHttpAPIRequest(arguments.requestBean, arguments.responseBean, 'chargePreAuthorization', requestData);
				
				// Response Data
				if (!responseBean.hasErrors()) {
					arguments.responseBean.setProviderTransactionID(responseData.id);
					arguments.responseBean.setProviderToken(requestData.tokenex.token);
					arguments.responseBean.setAuthorizationCode(responseData.authCode);
					// arguments.responseBean.setAmountAuthorized(responseData.data.amount);
					arguments.responseBean.setAmountReceived(responseData.amount);

					arguments.responseBean.addMessage(messageName="nexio.transactionDate", message="#responseData.transactionDate#");
					arguments.responseBean.addMessage(messageName="nexio.transactionStatus", message="#responseData.transactionStatus#");
					arguments.responseBean.addMessage(messageName="nexio.transactionType", message="#responseData.transactionType#");
					arguments.responseBean.addMessage(messageName="nexio.transactionCurrency", message="#responseData.currency#");
					arguments.responseBean.addMessage(messageName="nexio.gatewayResponse.result", message="#responseData.gatewayResponse.result#");
					arguments.responseBean.addMessage(messageName="nexio.gatewayResponse.batchRef", message="#responseData.gatewayResponse.batchRef#");
					arguments.responseBean.addMessage(messageName="nexio.gatewayResponse.refNumber", message="#responseData.gatewayResponse.refNumber#");
					arguments.responseBean.addMessage(messageName="nexio.gatewayResponse.gatewayName", message="#responseData.gatewayResponse.gatewayName#");
				}
			} else {
				throw("There is no 'originalAuthorizationProviderTransactionID' in the transactionRequestBean. Expecting the value be the authorization code to reference for the charge/capture.");
			}
		}
		
		private void function sendRequestToCredit(required any requestBean, required any responseBean) {
			// NOTE: Nexio does not support "Follow-on" or "Stand-alone" credit transactions. A reference to the original charge transactionID is required.
			// The amount of the credit is allowed to exceed the original charge with proper configuration in the external Nexio admin dashboard
			
			if (!isNull(arguments.requestBean.getOriginalChargeProviderTransactionID()) && len(arguments.requestBean.getOriginalChargeProviderTransactionID())) {
				
				// Request Data
				var requestData = {
					'data': {
						'amount': arguments.requestBean.getOrder().getCalculatedTotal(),
						'partialAmount': LSParseNumber(arguments.requestBean.getTransactionAmount())
			    	},
			    	'id': arguments.requestBean.getOriginalChargeProviderTransactionID()
				}

				responseData = sendHttpAPIRequest(arguments.requestBean, arguments.responseBean, 'credit', requestData);

				// Response Data
				if (!responseBean.hasErrors()) {
					arguments.responseBean.setProviderTransactionID(responseData.id);
					arguments.responseBean.setAuthorizationCode(responseData.authCode);
					arguments.responseBean.setAmountCredited(responseData.amount);
					
					arguments.responseBean.addMessage(messageName="nexio.transactionDate", message="#responseData.transactionDate#");
					arguments.responseBean.addMessage(messageName="nexio.transactionStatus", message="#responseData.transactionStatus#");
					arguments.responseBean.addMessage(messageName="nexio.transactionType", message="#responseData.transactionType#");
					arguments.responseBean.addMessage(messageName="nexio.gatewayResponse.result", message="#responseData.gatewayResponse.result#");
					arguments.responseBean.addMessage(messageName="nexio.gatewayResponse.batchRef", message="#responseData.gatewayResponse.batchRef#");
					arguments.responseBean.addMessage(messageName="nexio.gatewayResponse.refNumber", message="#responseData.gatewayResponse.refNumber#");
				}
			} else {
				throw("There is no 'originalAuthorizationProviderTransactionID' in the transactionRequestBean. Expecting the value be a reference to transactionID for the original charge/capture.");
			}
		}
		
		private void function sendRequestToVoid(required any requestBean, required any responseBean) {
			if (!isNull(arguments.requestBean.getOriginalChargeProviderTransactionID()) && len(arguments.requestBean.getOriginalChargeProviderTransactionID())) {
				// Void Authorize & Charge
				var voidRequiredTransactionID = arguments.requestBean.getOriginalChargeProviderTransactionID();
			} else if ((!isNull(arguments.requestBean.getOriginalAuthorizationProviderTransactionID()) && len(arguments.requestBean.getOriginalAuthorizationProviderTransactionID()))) {
				// Void Authorize
				var voidRequiredTransactionID = arguments.requestBean.getOriginalAuthorizationProviderTransactionID();
			}
			 
			if (!isNull(voidRequiredTransactionID) && len(voidRequiredTransactionID)) {
				// Request Data
				var requestData = {
					'data': {
						'amount': LSParseNumber(arguments.requestBean.getTransactionAmount())
			    	},
			    	'id': voidRequiredTransactionID
				}
				
				responseData = sendHttpAPIRequest(arguments.requestBean, arguments.responseBean, 'void', requestData);

				// Response Data
				if (!responseBean.hasErrors()) {
					arguments.responseBean.setProviderTransactionID(responseData.id);
					arguments.responseBean.setAuthorizationCode(responseData.authCode);
					// arguments.responseBean.setAuthorizationCode(arguments.requestBean.getOriginalAuthorizationCode());
					
					arguments.responseBean.addMessage(messageName="nexio.transactionDate", message="#responseData.transactionDate#");
					arguments.responseBean.addMessage(messageName="nexio.transactionStatus", message="#responseData.transactionStatus#");
					arguments.responseBean.addMessage(messageName="nexio.transactionType", message="#responseData.transactionType#");
					arguments.responseBean.addMessage(messageName="nexio.gatewayResponse.batchRef", message="#responseData.gatewayResponse.batchRef#");
					arguments.responseBean.addMessage(messageName="nexio.gatewayResponse.refNumber", message="#responseData.gatewayResponse.refNumber#");
					arguments.responseBean.addMessage(messageName="nexio.gatewayResponse.message", message="#responseData.gatewayResponse.message#");
				}
			} else {
				throw("There is no 'originalChargeProviderTransactionID' or originalAuthorizationProviderTransactionID' in the transactionRequestBean. Expecting the value to be a reference to transactionID for the original charge/capture or credit.");
			}
		}
		
		private struct function sendHttpAPIRequest(required any requestBean, required any responseBean, required string transactionName, required struct data) {
			var apiUrl = setting(settingName='apiUrlTest', requestBean=arguments.requestBean);
			var merchantID = setting(settingName='merchantIDTest', requestBean=arguments.requestBean);
			var password = setting(settingName='passwordTest', requestBean=arguments.requestBean);
			var username = setting(settingName='usernameTest', requestBean=arguments.requestBean);
			
			// Set Live Endpoint Url if not testing
			if (!getTestModeFlag(arguments.requestBean, 'testMode')) {
				apiUrl = setting(settingName='apiUrlLive', requestBean=arguments.requestBean);
				merchantID = setting(settingName='merchantIDLive', requestBean=arguments.requestBean);
				password = setting(settingName='passwordLive', requestBean=arguments.requestBean);
				username = setting(settingName='usernameLive', requestBean=arguments.requestBean);
			}
			
			// Append appropriate API Resource
			if (arguments.transactionName == 'generateOneTimeUseToken') {
				apiUrl &= '/pay/v3/token';
			} else if (arguments.transactionName == 'generateToken') {
				apiUrl &= '/pay/v3/saveCard';
			} else if (arguments.transactionName == 'deleteToken') {
				apiUrl &= '/pay/v3/deleteToken';
			} else if (arguments.transactionName == 'authorize') {
				apiUrl &= '/pay/v3/process';
			} else if (arguments.transactionName == 'authorizeAndCharge') {
				apiUrl &= '/pay/v3/process';
			} else if (arguments.transactionName == 'chargePreAuthorization') {
				apiUrl &= '/pay/v3/capture';
			} else if (arguments.transactionName == 'credit') {
				apiUrl &= '/pay/v3/refund';
			} else if (arguments.transactionName == 'void') {
				apiUrl &= '/pay/v3/void';
			} 
			
			var basicAuthCredentialsBase64 = toBase64('#username#:#password#');
			var httpRequest = new http();
			httpRequest.setUrl(apiUrl);
			httpRequest.setMethod('post');
			httpRequest.setCharset('UTF-8');
			httpRequest.addParam(type="header", name="Authorization", value="Basic #basicAuthCredentialsBase64#"); // (https://github.com/nexiopay/payment-service-example-node/blob/master/ClientSideToken.js#L92)
			httpRequest.addParam(type="header", name="Content-Type", value='application/json');
			httpRequest.addParam(type="body", value=serializeJSON(arguments.data));
		
			// ---> Comment Out:
			var logPath = expandPath('/Slatwall/integrationServices/nexio/log');
			if (!directoryExists(logPath)){
				directoryCreate(logPath);
			}
			var timeSufix = getTickCount() & createHibachiUUID(); 
			
			var httpRequestData = {
				'httpAuthHeader'='Basic #basicAuthCredentialsBase64#',
				'apiUrl'=apiUrl,
				'username' = username,
				'password' = password,
				'httpContentTypeHeader' = 'application/json',
				'publicKey' = getPublicKey(arguments.requestBean),
				'cardEncryptionMethod' = 'toBase64(encrypt(creditCardNumber, publicKey, "rsa" ))'
			};

			fileWrite('#logPath#/#timeSufix#_AVS_request.json',serializeJSON({'httpRequestData'=httpRequestData,'httpBody'=arguments.data}));
			// Comment Out: <---
			
			// Make HTTP request to endpoint
			var httpResponse = httpRequest.send().getPrefix();
			
			var responseData = {};
			// Server error handling - Unavailable or Communication Problem
			if (httpResponse.status_code == 0 || left(httpResponse.status_code, 1) == 5 || left(httpResponse.status_code, 1) == 4) {
				arguments.responseBean.setStatusCode("ERROR");

				// Public error message
				arguments.responseBean.addError('serverCommunicationFault', "#rbKey('nexio.error.serverCommunication_public')# #httpResponse.statusCode#");

				// Only for admin purposes
				arguments.responseBean.addMessage('serverCommunicationFault', "#rbKey('nexio.error.serverCommunication_admin')# - #httpResponse.statusCode#. Check the payment transaction for more details.");
				
				// No response from server
				if (httpResponse.status_code == 0) {
					arguments.responseBean.addMessage('serverCommunicationFaultReason', "#httpResponse.statuscode#. #httpResponse.errorDetail#. Verify Nexio integration is configured using the proper endpoint URLs. Otherwise Nexio may be unavailable.");

				// Error response
				} else {
					arguments.responseBean.setStatusCode(httpResponse.status_code);
					arguments.responseBean.addMessage('errorStatusCode', "#httpResponse.status_code#");

					// Convert JSON response
					responseData = deserializeJSON(httpResponse.fileContent);
					
					// ---> Comment Out:
					fileWrite('#logPath#/#timeSufix#_AVS_response.json',httpResponse.fileContent);
					// Comment Out: <---

					
					if (structKeyExists(responseData, 'error')) {
						arguments.responseBean.addMessage('errorCode', "#responseData.error#");
					}

					if (structKeyExists(responseData, 'message')) {
						// Add additional instructions for unauthorized error.
						if (httpResponse.status_code == '401') {
							responseData.message &= ". Verify Nexio integration is configured using the proper credentials and encryption key/password.";
						}

						arguments.responseBean.addMessage('errorMessage', "#httpResponse.statuscode#. #responseData.message#");
					}
				}

			// Server response successful
			} else {
				arguments.responseBean.setStatusCode(httpResponse.status_code);

				// Convert JSON response
				responseData = deserializeJSON(httpResponse.fileContent);
				
				// ---> Comment Out:
				fileWrite('#logPath#/#timeSufix#_AVS_response.json',httpResponse.fileContent);
				// Comment Out: <---
			}

			return responseData;
		}
		
		public any function testIntegration() {
			var requestBean = new Slatwall.model.transient.payment.CreditCardTransactionRequestBean();
			var testAccount = getHibachiScope().getAccount();
			
			requestBean.setTransactionType('generateToken');
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
			return response;;
		}
		
	}