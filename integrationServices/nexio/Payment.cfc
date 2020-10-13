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

	public boolean function isAdminRequest() {
		return structKeyExists(request,'context') 
			&& structKeyExists(request.context,'fw')
			&& request.context.fw.getSubsystem(request.context[request.context.fw.getAction()]) == 'admin';
	}

	// Override allow site settings
	public any function setting(required any requestBean) {
		
		if(structKeyExists(arguments, 'settingName') && arguments.settingName == 'checkFraud' && isAdminRequest()){
			return false;
		}
		
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
		} else {
			responseBean.addError("Processing error", "Nexio Payment Integration has not been implemented to handle #arguments.requestBean.getTransactionType()#");
			// throw("Nexio Payment Integration has not been implemented to handle #arguments.requestBean.getTransactionType()#");
		}

		return responseBean;
	}
	
	private boolean function getOriginalTransactionHasSettled(required any requestBean){
		if(!isNull(arguments.requestBean.getOriginalChargeProviderTransactionID())){
			var transactionID = arguments.requestBean.getOriginalChargeProviderTransactionID();
		}else if(!isNull(arguments.requestBean.getOriginalAuthorizationProviderTransactionID())){
			var transactionID = arguments.requestBean.getOriginalAuthorizationProviderTransactionID();
		}
		if(!isNull(transactionID)){
			var transactionStatus = getTransactionStatus(transactionID, requestBean);
			if(!isNull(transactionStatus)){
				return transactionStatus == 20;
			}
		}
		return false;
	}
	
	private numeric function getTransactionStatus(required string transactionID, required any requestBean){
		var responseBean = getTransient('DataResponseBean');
		// Request Data
		var requestData = {
			'transactionId' = arguments.transactionID
		}

		var responseData = sendHttpAPIRequest(arguments.requestBean, responseBean, 'transactionStatus', requestData);

		// Response Data
		if (!responseBean.hasErrors()){
			if(structKeyExists(responseData,'rows')){
				responseData = responseData.rows[1];
			}
			if(structKeyExists(responseData,'transactionStatus')) {
				return responseData.transactionStatus;
			}
		}
		return 50;
	}
	

	
	private any function getExtraData(required any requestBean){
		
		var transactionDate = !isNull( arguments.requestBean.getOrderPayment() ) ? arguments.requestBean.getOrderPayment().getCreatedDateTime() : '';

		var data = {
			'paymentMethod' = 'creditCard',
			'amount' = LSParseNumber(arguments.requestBean.getTransactionAmount()),
			'currency' = arguments.requestBean.getTransactionCurrencyCode(),
			'customer' = {
				'firstName' = arguments.requestBean.getAccountFirstName(),
				'lastName' = arguments.requestBean.getAccountLastName(),
				'orderNumber' = '',
				'customerRef' = '',
				'createdAtDate' = '',
				'email' = '',
				'phone' = '',
				'billToAddressOne' = arguments.requestBean.getBillingStreetAddress(),
				'billToAddressTwo' = arguments.requestBean.getBillingStreet2Address() ?: '',
				'billToCity' = arguments.requestBean.getBillingCity(),
				'billToState' = arguments.requestBean.getBillingStateCode(),
				'billToPostal' = arguments.requestBean.getBillingPostalCode(),
				'billToCountry' = arguments.requestBean.getBillingCountryCode()
			},
			'customFields' = {
				'CURRENTRANK' = '' ,
				'SPONSORID' = '',
				'TRANSACTIONDATE' = transactionDate,
				'CARDHOLDER_NAME' = arguments.requestBean.getBillingName(),
				'ACCOUNT_REF' = '',
				'ORDER_REF' = ''
			},
			'cart' = {
				'items' = []
			}
		};
		
		if(!isNull(arguments.requestBean.getAccount())){
			var account = arguments.requestBean.getAccount();
			data['customer']['customerRef'] = account.getAccountNumber();
			data['customer']['createdAtDate'] = account.getCreatedDateTime();
			data['customer']['email'] = account.getEmailAddress();
			data['customer']['phone'] = account.getPhoneNumber();
			
			data['customFields']['ACCOUNT_REF'] = account.getShortReferenceID(true);
			
			if(len(account.getRank())){
				var rankOption = arguments.requestBean.getService('attributeService').getAttributeOptionByAttributeOptionValue(account.getRank());
				if(!isNull(rankOption)){
					data['customFields']['CURRENTRANK'] = rankOption.getAttributeOptionLabel();
				}
			}
			
			if(!isNull(account.getOwnerAccount())){
				data['customFields']['SPONSORID'] = account.getOwnerAccount().getAccountNumber();
			}
			
		}
		
		
		if (!isNull(arguments.requestBean.getOrder())) {
			
			data['customer']['orderNumber'] = arguments.requestBean.getOrder().getOrderNumber();
			data['customFields']['ORDER_REF'] = arguments.requestBean.getOrder().getShortReferenceID(true);
			data['customFields']['SWORDERID'] = arguments.requestBean.getOrder().getOrderID();
			
			
			
			if(!isNull(arguments.requestBean.getOrder().getShippingAddress()) && len(arguments.requestBean.getOrder().getShippingAddress().getStreetAddress())){
				var shippingAddress = arguments.requestBean.getOrder().getShippingAddress();
				data['customer']['shipToAddressOne'] = shippingAddress.getStreetAddress();
				data['customer']['shipToAddressTwo'] = shippingAddress.getStreet2Address() ?: '';
				data['customer']['shipToCity'] = shippingAddress.getCity();
				data['customer']['shipToState'] = shippingAddress.getStateCode();
				data['customer']['shipToPostal'] = shippingAddress.getPostalCode();
				data['customer']['shipToCountry'] = shippingAddress.getCountryCode();
			}
			
			
			var orderItems = arguments.requestBean.getOrder().getOrderItems();
			
			for(var orderItem in orderItems){
				
				//don't run this logic for child order items.
				if (isNull(orderItem.getParentOrderItem())) {
					 data.cart.items.append({
						'item' : '#orderItem.getSku().getSkuCode()#',
						'description' : '#orderItem.getSku().getSkuName()#',
						'quantity' : '#orderItem.getQuantity()#',
						'type' : 'sale',
						"price" : "#orderItem.getItemTotal()#"
					});
				}
			}
		}
		
		return data;
	}

	// Nexio relies on 3rd party TokenEx for tokenization. It uses PKCS #1 v1.5 as cipher algorithm for RSA encryption
	private any function encryptCardNumber(required string cardNumber, required string publicKey) {
		var secureRandom = createObject("java", "java.security.SecureRandom").init();
		var cipher = createObject("java", "javax.crypto.Cipher").getInstance("RSA/ECB/PKCS1Padding", "SunJCE"); // This also is equivalent: getInstance("RSA/None/PKCS1Padding", "BC") for BouncyCastle (org.bouncycastle.jce.provider.BouncyCastleProvider)
		arguments.publicKey = normalizeBase64Length(arguments.publicKey);
		// Convert public key from string to java Key object
		// First need to convert raw string to ByteArray
		var publicKeySpec = createObject('java', 'java.security.spec.X509EncodedKeySpec').init(toBinary(arguments.publicKey));
		var keyFactory = createObject('java', 'java.security.KeyFactory').getInstance('RSA');
		var key = keyFactory.generatePublic(publicKeySpec);
		cipher.init(createObject("java", "javax.crypto.Cipher").ENCRYPT_MODE, key, secureRandom);
		
		return cipher.doFinal(toBinary(toBase64(arguments.cardNumber)));
	}
	
	private string function normalizeBase64Length( required string base64String){
		while(len(arguments.base64String)%4 != 0){
			arguments.base64String &= '=';
		}
		return arguments.base64String;
	}
	
	private void function sendRequestToGenerateToken(required any requestBean, required any responseBean) {
		// We are expecting there is no provider token yet, but if accountPaymentMethod is used & attempt to generate another token prevent & short circuit
		if (isNull(arguments.requestBean.getProviderToken()) || !len(arguments.requestBean.getProviderToken())) {
			
			var publicKey = getPublicKey(arguments.requestBean);
			
			var checkFraud = false;
			
			if(getHibachiScope().hasSessionValue('kount-token')){
				checkFraud = setting(settingName='checkFraud', requestBean=arguments.requestBean) ? true : false;
			}
			
			var publicKey = getPublicKey(arguments.requestBean);

			var requestData = {
				'isAuthOnly'= false,
				'card' = {
					'cardHolderName' = arguments.requestBean.getNameOnCreditCard(), 
					'encryptedNumber' = toBase64(encryptCardNumber(arguments.requestBean.getCreditCardNumber(), getPublicKey(arguments.requestBean))),
					'expirationMonth' = LSParseNumber(arguments.requestBean.getExpirationMonth()),
					'expirationYear' = LSParseNumber(arguments.requestBean.getExpirationYear()), 
					'securityCode' = arguments.requestBean.getSecurityCode()
				},
				'processingOptions' = {
					'checkFraud' = checkFraud,
					'verifyCvc' = setting(settingName='verifyCvcFlag', requestBean=arguments.requestBean) ? true : false,
					'verifyAvs' = LSParseNumber(setting(settingName='verifyAvsSetting', requestBean=arguments.requestBean))
				},
				'data' = this.getExtraData(arguments.requestBean)
			};
			
			if(getHibachiScope().hasSessionValue('kount-token')){
				requestData['token'] = getHibachiScope().getSessionValue('kount-token');
			}else{
				// One Time Use Token (https://github.com/nexiopay/payment-service-example-node/blob/master/ClientSideToken.js#L23)
				var responseData = sendHttpAPIRequest(arguments.requestBean, arguments.responseBean, 'generateOneTimeUseToken', requestData);
				if(responseBean.hasErrors()){
					return responseBean;
				}
				if(!isNull(responseData.token)){
					requestData['token'] = responseData.token;
				}
			}
			
			// Save Card, this is the imortant token we want to persist for Slatwall payment data (https://github.com/nexiopay/payment-service-example-node/blob/master/ClientSideToken.js#L107)
			var responseData = sendHttpAPIRequest(arguments.requestBean, arguments.responseBean, 'generateToken', requestData);

			if(checkFraud && getHibachiScope().hasSessionValue('kount-token')){
				getHibachiScope().clearSessionValue('kount-token');
			}
			// Setting AVS code (https://github.com/ten24/Monat/blob/develop/Slatwall/model/transient/payment/TransactionResponseBean.cfc) off Nexio's response 
			var responseDataAvsCode = "";
			
			if (!isNull(responseData.avsResults)
			&& !isNull(responseData.avsResults.matchAddress) 
			&& !isNull(responseData.avsResults.matchPostal)){
				if (responseData.avsResults.matchAddress==true && responseData.avsResults.matchPostal==true){
					responseDataAvsCode = "D";
				}else if (responseData.avsResults.matchAddress==false && responseData.avsResults.matchPostal==true){
					responseDataAvsCode = "Z";
				}else if (responseData.avsResults.matchAddress==false && responseData.avsResults.matchPostal==false){
					responseDataAvsCode = "C";
				}else if (responseData.avsResults.matchAddress==true && responseData.avsResults.matchPostal==false){
					responseDataAvsCode = "A";
				}
			}else if (!isNull(responseData.avsResults)
			&& !isNull(responseData.avsResults.matchAddress) 
			&& responseData.avsResults.matchAddress==true
			&& isNull(responseData.avsResults.matchPostal)){
				responseDataAvsCode = "B";
			}else if (!isNull(responseData.avsResults)
			&& isNull(responseData.avsResults.matchAddress) 
			&& !isNull(responseData.avsResults.matchPostal)
			&& responseData.avsResults.matchPostal==true){
				responseDataAvsCode = "P";
			}else {
				responseDataAvsCode = "E";
			}

			// Extract data and set as part of the responseBean
			if (!responseBean.hasErrors()) {
				arguments.responseBean.setProviderTransactionID(arguments.requestBean.getOriginalProviderTransactionID());
				arguments.responseBean.setProviderToken(responseData.token.token);
				arguments.responseBean.setAuthorizationCode(arguments.requestBean.getOriginalAuthorizationCode());
				arguments.responseBean.setAvsCode(responseDataAvsCode);
				
				
				if (!isNull(responseData.kountResponse)){
					arguments.responseBean.addMessage(messageName="nexio.kountResponse.status", message="#responseData.kountResponse.status#");
					arguments.responseBean.addMessage(messageName="nexio.kountResponse.rules", message="#responseData.kountResponse.rules#");
				} else {
					arguments.responseBean.addMessage(messageName="nexio.kountResponse", message="kountResponse is undefinied; checkFraud set to 'No'");
				}
				
				if (!isNull(responseData.avsResults)){
					arguments.responseBean.addMessage(messageName="nexio.avsResults.error", message="#responseData.avsResults.error#");
					arguments.responseBean.addMessage(messageName="nexio.avsResults.gatewayMessage.avsresponse", message="#responseData.avsResults.gatewayMessage.avsresponse#");
					arguments.responseBean.addMessage(messageName="nexio.avsResults.gatewayMessage.message", message="#responseData.avsResults.gatewayMessage.message#");
				} else {
					arguments.responseBean.addMessage(messageName="nexio.avsResults", message="avsResults is undefinied; verifyAvsSetting set to 'Do not perform AVS check'");
				}
				
				if (!isNull(responseData.cvcResults)){
					arguments.responseBean.addMessage(messageName="nexio.cvcResults.error", message="#responseData.cvcResults.error#");
					arguments.responseBean.addMessage(messageName="nexio.cvcResults.gatewayMessage.cvvresponse", message="#responseData.cvcResults.gatewayMessage.cvvresponse#");
					arguments.responseBean.addMessage(messageName="nexio.cvcResults.gatewayMessage.message", message="#responseData.cvcResults.gatewayMessage.message#");
				} else {
					arguments.responseBean.addMessage(messageName="nexio.cvcResults", message="cvcResults is undefinied; verifyCvcFlag set to 'No'");
				}
			}
			
		} else {
			responseBean.addError("Processing error", "Attempting to generate token. The payment method used already had a valid token");
			// throw('Attempting to generate token. The payment method used already had a valid token');
		}
	}
	
	public any function sendRequestToDeleteTokens(required array tokens) {
		// Cards registered with the account updater service will take up to 72 hours to be removed.
		var requestBean = getTransient('CreditCardTransactionRequestBean');
		var responseBean = getTransient('CreditCardTransactionResponseBean');
		
		var requestData = {
			'tokens' = arguments.tokens
		}
        
		var responseData = sendHttpAPIRequest(requestBean, responseBean, 'deleteToken', requestData);
		responseBean.setData(responseData);
        
		if (!responseBean.hasErrors()) {
			return responseBean;
		} else {
			responseBean.addError("Processing error", "Attempting to delete token(s). Token array is invalid");
			// throw('Attempting to delete token(s). Token array is invalid.');
		}
	}
	
	private void function sendRequestToAuthorize(required any requestBean, required any responseBean) {
		// Request Data
		if (!arguments.requestBean.hasErrors() && !isNull(arguments.requestBean.getProviderToken()) && len(arguments.requestBean.getProviderToken())) {
			
			var checkFraud = setting(settingName='checkFraud', requestBean=arguments.requestBean);
			
			var requestData = {
				"isAuthOnly" = true,
				"tokenex" = {
					'token' = arguments.requestBean.getProviderToken()
			    },
			    "card" = {
			    	'expirationMonth' = LSParseNumber(arguments.requestBean.getExpirationMonth()),
					'expirationYear' = LSParseNumber(arguments.requestBean.getExpirationYear()), 
			    	"cardHolderName" = arguments.requestBean.getNameOnCreditCard(),
			    	"lastFour" = arguments.requestBean.getCreditCardLastFour(),
			    	"cardType" = arguments.requestBean.getCreditCardType()
			    },
			    'data' = this.getExtraData(arguments.requestBean),
			    "processingOptions" = {
				    "checkFraud" = checkFraud,
				    "verifyAvs" = LSParseNumber(setting(settingName='verifyAvsSetting', requestBean=arguments.requestBean)),
				    "verifyCvc" = (setting(settingName='verifyCvcFlag', requestBean=arguments.requestBean)? true : false)
			    }
			};	
			
			var responseData = sendHttpAPIRequest(arguments.requestBean, arguments.responseBean, 'authorize', requestData);
			
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
				arguments.responseBean.addMessage(messageName="nexio.gatewayResponse.refNumber", message="#responseData.gatewayResponse.refNumber#");
				arguments.responseBean.addMessage(messageName="nexio.gatewayResponse.gatewayName", message="#responseData.gatewayResponse.gatewayName#");
				arguments.responseBean.addMessage(messageName="nexio.cardNumber", message="#responseData.card.cardNumber#");
			}
		} else {
			responseBean.addError("Processing error", "Error attempting to authorize. Review providerToken.");
			// throw('Error attempting to authorize. Review providerToken.');
		}
	}
	
	private void function sendRequestToAuthorizeAndCharge(required any requestBean, required any responseBean) {
		// Request Data
		if (!arguments.requestBean.hasErrors() && !isNull(arguments.requestBean.getProviderToken()) && len(arguments.requestBean.getProviderToken())) {
			var checkFraud = setting(settingName='checkFraud', requestBean=arguments.requestBean);
			
			var requestData = {
				"isAuthOnly" = false,
				"tokenex" = {
					'token' = arguments.requestBean.getProviderToken()
			    },
			    "card" = {
			    	"expirationMonth" = arguments.requestBean.getExpirationMonth(),
			    	"expirationYear" = arguments.requestBean.getExpirationYear(),
			    	"cardHolderName" = arguments.requestBean.getNameOnCreditCard(),
			    	"lastFour" = arguments.requestBean.getCreditCardLastFour(),
			    	"cardType" = arguments.requestBean.getCreditCardType()
			    },
			    'data' = this.getExtraData(arguments.requestBean),
			    "processingOptions" = {
				    "checkFraud" = checkFraud,
				    "verifyAvs" = LSParseNumber(setting(settingName='verifyAvsSetting', requestBean=arguments.requestBean)),
				    "verifyCvc" = (setting(settingName='verifyCvcFlag', requestBean=arguments.requestBean)? true : false)
			    }
			};	
			
			var responseData = sendHttpAPIRequest(arguments.requestBean, arguments.responseBean, 'authorizeAndCharge', requestData);
			
			if(structKeyExists(responseData, 'Error')){
					var getNexioError = arguments.responseBean.getErrors();
					if(structKeyExists(getNexioError, 'serverCommunicationFault')){
						var defaultMessage = getNexioError['serverCommunicationFault']['1'];
					}else{
						var defaultMessage = "Nexio server communication fault";
					}
					var getErroMessage = getHibachiScope().getService('PublicService').getFormattedErrorMessage("Nexio","#responseData['Error']#",defaultMessage);
					arguments.responseBean.clearHibachiErrors();
					arguments.responseBean.addError("Nexio error",getErroMessage);
			}else if (!responseBean.hasErrors()) {
				arguments.responseBean.setProviderToken(requestData.tokenex.token);
				arguments.responseBean.setProviderTransactionID(responseData.id);
				if(structKeyExists(responseData, 'authCode')){
					arguments.responseBean.setAuthorizationCode(responseData.authCode);
				}
				
				arguments.responseBean.setAmountReceived(responseData.amount);
				arguments.responseBean.setAmountAuthorized(responseData.data.amount);
				
				arguments.responseBean.addMessage(messageName="nexio.transactionDate", message="#responseData.transactionDate#");
				arguments.responseBean.addMessage(messageName="nexio.transactionStatus", message="#responseData.transactionStatus#");
				arguments.responseBean.addMessage(messageName="nexio.transactionType", message="#responseData.transactionType#");
				arguments.responseBean.addMessage(messageName="nexio.transactionCurrency", message="#responseData.currency#");

				if( structKeyExists(responseData.gatewayResponse, 'refNumber') ){
					arguments.responseBean.addMessage(messageName="nexio.gatewayResponse.refNumber", message="#responseData.gatewayResponse.refNumber#");
				}
				if( !isNull(responseData.gatewayResponse.gatewayName) ){
					arguments.responseBean.addMessage(messageName="nexio.gatewayResponse.gatewayName", message="#responseData.gatewayResponse.gatewayName#");
				}
				if( !isNull(responseData.card.cardNumber) ){
					arguments.responseBean.addMessage(messageName="nexio.cardNumber", message="#responseData.card.cardNumber#");
				}
			
			
			} 
		} else {
			responseBean.addError("Processing error", "Error attempting to authorize and charge. Review providerToken.");
			// throw('Error attempting to authorize and charge. Review providerToken.');
		}
	}
	
	private void function sendRequestToChargePreAuthorization(required any requestBean, required any responseBean) {
		if (!isNull(arguments.requestBean.getOriginalAuthorizationProviderTransactionID()) && len(arguments.requestBean.getOriginalAuthorizationProviderTransactionID())) {
			// Request Data
			var requestData = {
				"tokenex" = {
					'token' = arguments.requestBean.getProviderToken()
			    },
				'data' = {
					'amount' = LSParseNumber(arguments.requestBean.getTransactionAmount()),
		    	},
		    	'id' = arguments.requestBean.getOriginalAuthorizationProviderTransactionID()
			}

			var responseData = sendHttpAPIRequest(arguments.requestBean, arguments.responseBean, 'chargePreAuthorization', requestData);
			
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
				arguments.responseBean.addMessage(messageName="nexio.gatewayResponse.refNumber", message="#responseData.gatewayResponse.refNumber#");
				arguments.responseBean.addMessage(messageName="nexio.gatewayResponse.gatewayName", message="#responseData.gatewayResponse.gatewayName#");
			}
		} else {
			responseBean.addError("Processing error", "There is no 'originalAuthorizationProviderTransactionID' in the transactionRequestBean. Expecting the value be the authorization code to reference for the charge/capture.");
			// throw("There is no 'originalAuthorizationProviderTransactionID' in the transactionRequestBean. Expecting the value be the authorization code to reference for the charge/capture.");
		}
	}
	
	private void function sendRequestToCredit(required any requestBean, required any responseBean) {
		// NOTE: Nexio does not support "Follow-on" or "Stand-alone" credit transactions. A reference to the original charge transactionID is required.
		// The amount of the credit is allowed to exceed the original charge with proper configuration in the external Nexio admin dashboard
		
		if ( !isNull(arguments.requestBean.getProviderToken()) ) {
			// Request Data
			var requestData = {
				'data' = {
					'amount' = LSParseNumber(arguments.requestBean.getTransactionAmount()),
					'currency': arguments.requestBean.getTransactionCurrencyCode()
		    	},
		    	'tokenex': {
					'token': arguments.requestBean.getProviderToken()
				},
			    "card" = {
			    	"expirationMonth" = arguments.requestBean.getExpirationMonth(),
			    	"expirationYear" = arguments.requestBean.getExpirationYear()
			    }
			}
			
			var responseData = sendHttpAPIRequest(arguments.requestBean, arguments.responseBean, 'credit', requestData);
			
			// Response Data
			if (!responseBean.hasErrors()) {
				arguments.responseBean.setProviderTransactionID(responseData.id);
				arguments.responseBean.setAuthorizationCode(responseData.authCode);
				arguments.responseBean.setAmountCredited(-1 * responseData.amount);
				
				arguments.responseBean.addMessage(messageName="nexio.transactionDate", message="#responseData.transactionDate#");
				arguments.responseBean.addMessage(messageName="nexio.transactionStatus", message="#responseData.transactionStatus#");
				arguments.responseBean.addMessage(messageName="nexio.transactionType", message="#responseData.transactionType#");
				arguments.responseBean.addMessage(messageName="nexio.gatewayResponse.refNumber", message="#responseData.gatewayResponse.refNumber#");
			}
		} else {
			responseBean.addError("Processing error", "There is no token in the transactionRequestBean.");
			// throw("There is no 'originalAuthorizationProviderTransactionID' in the transactionRequestBean. Expecting the value be a reference to transactionID for the original charge/capture.");
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
			
			var responseData = sendHttpAPIRequest(arguments.requestBean, arguments.responseBean, 'void', requestData);
			
			// Response Data
			if (!responseBean.hasErrors()) {
				arguments.responseBean.setProviderTransactionID(responseData.id);
				arguments.responseBean.setAuthorizationCode(responseData.authCode);
				arguments.responseBean.setAmountCredited(responseData.amount);
				
				arguments.responseBean.addMessage(messageName="nexio.transactionDate", message="#responseData.transactionDate#");
				arguments.responseBean.addMessage(messageName="nexio.transactionStatus", message="#responseData.transactionStatus#");
				arguments.responseBean.addMessage(messageName="nexio.transactionType", message="#responseData.transactionType#");
				arguments.responseBean.addMessage(messageName="nexio.gatewayResponse.refNumber", message="#responseData.gatewayResponse.refNumber#");
			}
		} else {
			throw("There is no 'originalChargeProviderTransactionID' or originalAuthorizationProviderTransactionID' in the transactionRequestBean. Expecting the value to be a reference to transactionID for the original charge/capture or credit.");
		}
	}
	
	private any function sendHttpAPIRequest(required any requestBean, required any responseBean, required string transactionName, required struct data) {
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
			apiUrl &= '/pay/v3/credit';
		} else if (arguments.transactionName == 'void') {
			apiUrl &= '/pay/v3/void';
		} else if(arguments.transactionName == 'transactionStatus'){
			apiUrl &= '/transaction/v3?plugin.originalId=#arguments.data.transactionID#&gateway.&customer.';
		} else if(arguments.transactionName == "cardView") {
			apiUrl &= '/pay/v3/vault/card/#arguments.requestBean.getProviderToken()#';
		}
		var basicAuthCredentialsBase64 = toBase64('#username#:#password#');
		var httpRequest = new http();
		httpRequest.setTimeout(10);
		httpRequest.setUrl(apiUrl);
		if(arguments.transactionName == 'transactionStatus' || arguments.transactionName == 'cardView'){
			httpRequest.setMethod('GET');
		}else{
			httpRequest.setMethod('POST');
		}
		httpRequest.setCharset('UTF-8');
		httpRequest.addParam(type="header", name="Authorization", value="Basic #basicAuthCredentialsBase64#"); // (https://github.com/nexiopay/payment-service-example-node/blob/master/ClientSideToken.js#L92)
		if(arguments.transactionName == 'transactionStatus' || arguments.transactionName == 'cardView'){
			httpRequest.addParam(type="header", name="Accept", value="application/json");
		} else {
			httpRequest.addParam(type="header", name="Content-Type", value='application/json');
			httpRequest.addParam(type="body", value=serializeJSON(arguments.data));
		}

		// ---> Comment Out:
		// var logPath = expandPath('/Slatwall/integrationServices/nexio/log');
		// if (!directoryExists(logPath)){
		// 	directoryCreate(logPath);
		// }
		// var timeSufix = getTickCount() & createHibachiUUID(); 
		
		// var httpRequestData = {
		// 	'httpAuthHeader'='Basic #basicAuthCredentialsBase64#',
		// 	'apiUrl'=apiUrl,
		// 	'username' = username,
		// 	'password' = password,
		// 	'httpContentTypeHeader' = 'application/json',
		// 	'publicKey' = getPublicKey(arguments.requestBean),
		// 	'cardEncryptionMethod' = 'toBase64(encrypt(creditCardNumber, publicKey, "rsa" ))'
		// };

		// fileWrite('#logPath#/#timeSufix#_AVS_request.json',serializeJSON({'httpRequestData'=httpRequestData,'httpBody'=arguments.data}));
		// Comment Out: <---
		
		// Make HTTP request to endpoint
		var httpResponse = httpRequest.send().getPrefix();

		if (arguments.transactionName == 'deleteToken') {
			var responseData = {};
			if(isJSON(httpResponse.fileContent)){
				responseData = deserializeJSON(httpResponse.fileContent);
			}else{
				responseData = httpResponse.fileContent;
			}
			return responseData;
		} else {
			var responseData = {};
			// Server error handling - Unavailable or Communication Problem
			if (httpResponse.status_code == 0 || left(httpResponse.status_code, 1) == 5 || left(httpResponse.status_code, 1) == 4) {
				arguments.responseBean.setStatusCode("ERROR");
				
				// Public error message
				if(isJSON(httpResponse.fileContent)){
					responseData = deserializeJSON(httpResponse.fileContent);
				}else{
					responseData = httpResponse.fileContent;
				}
				if ( isStruct( responseData ) && structKeyExists( responseData, 'message' ) ) {
					arguments.responseBean.addError( 'serverCommunicationFault', responseData.message );
				} else {
					arguments.responseBean.addError( 'serverCommunicationFault', "#rbKey('nexio.error.serverCommunication_public')# #httpResponse.statusCode#" );
				}
				
				// Only for admin purposes
				arguments.responseBean.addMessage('serverCommunicationFault', "#rbKey('nexio.error.serverCommunication_admin')# - #httpResponse.statusCode#. Check the payment transaction for more details.");
				
				// No response from server
				if (httpResponse.status_code == 0) {
					arguments.responseBean.addMessage('serverCommunicationFaultReason', "#httpResponse.statuscode#. #httpResponse.errorDetail#. Verify Nexio integration is configured using the proper endpoint URLs. Otherwise Nexio may be unavailable.");
	
				// Error response
				} else {
					arguments.responseBean.setStatusCode(httpResponse.status_code);
					arguments.responseBean.addMessage('errorStatusCode', "#httpResponse.status_code#");
	
					// ---> Comment Out:
					// fileWrite('#logPath#/#timeSufix#_AVS_response.json',httpResponse.fileContent);
					// Comment Out: <---
	
					
					if ( isStruct(responseData) && structKeyExists(responseData, 'error') ) {
						arguments.responseBean.addMessage('errorCode', "#responseData.error#");
					}
	
					if ( isStruct(responseData) && structKeyExists(responseData, 'message') ) {
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
				if(structKeyExists(responseData, 'gatewayResponse') && structKeyExists(responseData['gatewayResponse'], 'refNumber')){
					arguments.responseBean.setReferenceNumber(responseData.gatewayResponse.refNumber)
				}
				
				// ---> Comment Out:
				// fileWrite('#logPath#/#timeSufix#_AVS_response.json',httpResponse.fileContent);
				// Comment Out: <---
			}
			
			return responseData;
		}
	}
	
	public any function getCardStatus(required any requestBean){
		if (isNull(arguments.requestBean.getProviderToken()) || !len(arguments.requestBean.getProviderToken())) {
			return {};
		}
		// Request Data
		var requestData = {};
		var responseBean = getTransient('DataResponseBean');
		var responseData = sendHttpAPIRequest(arguments.requestBean, responseBean, 'cardView', requestData);
		
		if( StructKeyExists(responseData,'card') ) { //Success
			return responseData;
		} else { //Failure
			return {};
		}
		
	}
	
	public any function getFingerprintToken(){
		var requestBean = getTransient('CreditCardTransactionRequestBean');
		var responseBean = getTransient('DataResponseBean');
		
		var responseData = sendHttpAPIRequest(requestBean, responseBean, 'generateOneTimeUseToken', {});
		if(!isStruct(responseData)){
			responseData = {};
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
