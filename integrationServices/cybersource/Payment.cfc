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

component accessors="true" output="false" displayname="Stripe" implements="Slatwall.integrationServices.PaymentInterface" extends="Slatwall.integrationServices.BasePayment" {

		public any function init() {
			return this;
		}
	
		public string function getPaymentMethodTypes() {
			return "creditCard";
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
	
		public any function processCreditCard(required any requestBean) {
			var responseBean = getTransient('CreditCardTransactionResponseBean');

			// Set default currency, CyberSource SOAP API requires a currency for tokenization
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
				throw("CyberSource Payment Intgration has not been implemented to handle #arguments.requestBean.getTransactionType()#");
			}

			// Output merchantID for admin troubleshooting purposes, masked for better security
			var merchantID = setting(settingName='merchantID', requestBean=arguments.requestBean);
			var maxCharactersToReveal = min(8, len(merchantID));
			responseBean.addMessage('merchantID', "xxxx#mid(merchantID, len(merchantID) - maxCharactersToReveal + 1, maxCharactersToReveal)#");
	
			// Adding testMode flag indicator to message when transaction occurs during test mode for admin purposes
			if (getTestModeFlag(arguments.requestBean, 'testMode')) {
				responseBean.addMessage('testMode', yesNoFormat(getTestModeFlag(arguments.requestBean, 'testMode')));
			}
	
			return responseBean;
		}
	
		private struct function populateRequestMessageDataWithCardInfo(required any requestBean, required any responseBean, struct requestMessageData={}) {
			
			if (!isNull(arguments.requestBean.getNameOnCreditCard()) && len(arguments.requestBean.getNameOnCreditCard())) {
				if (arguments.requestBean.getNameOnCreditCard() contains " ") {
					try{	
						arguments.requestMessageData.lastName = trim(listLast(arguments.requestBean.getNameOnCreditCard(), ' '));
						arguments.requestMessageData.firstName = trim(left(arguments.requestBean.getNameOnCreditCard(), len(arguments.requestBean.getNameOnCreditCard()) - len(arguments.requestMessageData.lastName)));
					}catch(any e){
					    arguments.requestMessageData.lastName = arguments.requestBean.getNameOnCreditCard();
					    arguments.requestMessageData.firstName = arguments.requestBean.getNameOnCreditCard();
					}
				}else{
					arguments.requestMessageData.lastName = trim(arguments.requestBean.getNameOnCreditCard());
					arguments.requestMessageData.firstName = trim(arguments.requestBean.getNameOnCreditCard());
				}
			}

			// Set email if available
			arguments.requestMessageData.email = "no-email@noemail.com";
			if (!isNull(arguments.requestBean.getAccountPrimaryEmailAddress()) && len(arguments.requestBean.getAccountPrimaryEmailAddress())) {
				arguments.requestMessageData.email = arguments.requestBean.getAccountPrimaryEmailAddress();
			}
			
			arguments.requestMessageData.street1 = arguments.requestBean.getBillingStreetAddress();
			arguments.requestMessageData.street2 = arguments.requestBean.getBillingStreet2Address();
			arguments.requestMessageData.city = arguments.requestBean.getBillingCity();
			arguments.requestMessageData.state = arguments.requestBean.getBillingStateCode();
			arguments.requestMessageData.postalCode = arguments.requestBean.getBillingPostalCode();
			arguments.requestMessageData.country = arguments.requestBean.getBillingCountryCode();
			arguments.requestMessageData.currency = arguments.requestBean.getTransactionCurrencyCode();
			arguments.requestMessageData.grandTotalAmount = arguments.requestBean.getTransactionAmount();
			arguments.requestMessageData.cardNumber = arguments.requestBean.getCreditCardNumber();
			arguments.requestMessageData.expirationMonth = arguments.requestBean.getExpirationMonth();
			arguments.requestMessageData.expirationYear = arguments.requestBean.getExpirationYear();
			
			// Flags for dealing with potential credit card type technicalities
			arguments.requestMessageData.verifyCVNumberFlag = false;
			arguments.requestMessageData.cardTypeSupportedFlag = false;
			
			// Only do extra credit card processing for specific transactionTypes not relying on previous tokenization or authentication transactions
			if (
				(isNull(arguments.requestBean.getProviderToken()) && listFindNoCase('generateToken,authorize,authorizeAndCharge', arguments.requestBean.getTransactionType()))
				||
				(isNull(arguments.requestBean.getProviderToken()) && isNull(arguments.requestBean.getOriginalChargeProviderTransactionID()) && listFindNoCase('credit', arguments.requestBean.getTransactionType()))
			) {
				
				// CardType Mappings 
				// Defined by Appendix G of Credit Card Services Documentation
				// Resource: http://apps.cybersource.com/library/documentation/dev_guides/CC_Svcs_SO_API/Credit_Cards_SO_API.pdf#page=410
				// Resource: http://apps.cybersource.com/library/documentation/dev_guides/Payment_Tokenization/SO_API/Payment_Tokenization_SO_API.pdf#page=45
				var cardTypes = {
					'Visa' = {value='001', cvNumberSupported=true, tokenizationAutoAuthSupported=true},
					'MasterCard' = {value='002', cvNumberSupported=true, tokenizationAutoAuthSupported=true},
					'American Express' = {value='003', cvNumberSupported=true, tokenizationAutoAuthSupported=true},
					'Discover' = {value='004', cvNumberSupported=true, tokenizationAutoAuthSupported=true},
					'Diners Club' = {value='005', cvNumberSupported=true, tokenizationAutoAuthSupported=true},
					'JCB' = {value='007', cvNumberSupported=true, tokenizationAutoAuthSupported=true},
					'Maestro' = {value='024', cvNumberSupported=false, tokenizationAutoAuthSupported=true} 
				};

				// Only for admin purposes
				arguments.responseBean.addMessage('configCvNumberVerificationEnabled', yesNoFormat(setting(settingName='verifyCVNumber', requestBean=arguments.requestBean)));
				arguments.responseBean.addMessage('configCardType', arguments.requestBean.getCreditCardType());

				// Configure cardType messageData if credit card type is supported by CyberSource processor
				// And also configure cvNumber messageData if verification is requested and is supported
				if (!isNull(arguments.requestBean.getCreditCardType()) && structKeyExists(cardTypes, arguments.requestBean.getCreditCardType())) {
					// Update flag for template logic
					arguments.requestMessageData.cardTypeSupportedFlag = true;
					arguments.requestMessageData.cardType = cardTypes[arguments.requestBean.getCreditCardType()].value;
					
					// Configure to verify CVN
					if (setting(settingName='verifyCVNumber', requestBean=arguments.requestBean)) {

						// Only if the credit card type supports CVN verification
						if (cardTypes[arguments.requestBean.getCreditCardType()].cvNumberSupported) {
							// Only for admin purposes
							arguments.responseBean.addMessage('configCvNumberCardTypeVerificationSupported', yesNoFormat(true));

							// If a securityCode was provided update flag for template logic
							if (!isNull(arguments.requestBean.getSecurityCode()) && len(arguments.requestBean.getSecurityCode())) {
								arguments.requestMessageData.verifyCVNumberFlag = true;
								arguments.requestMessageData.cvNumber = arguments.requestBean.getSecurityCode();
							}
							
							// Error if we are supposed to verify cvNumber but was not provided and the card type is supported
							if (!arguments.requestMessageData.verifyCVNumberFlag) {
								// Public error message
								arguments.responseBean.addError('cvn', rbKey('cyberSource.error.cvv_invalid'));

								// Only for admin purposes
								arguments.responseBean.addMessage('cvnMatchError', "Security Code Not Provided: #rbKey('cyberSource.error.cvv_invalid')#");
							}
							

						// CNV verification is not support by credit card type, for admin purposes
						} else {
							arguments.responseBean.addMessage('configCvNumberCardTypeVerificationSupported', yesNoFormat(false));
						}
					}
				// Credit card type not supported, so update message to indicate CVN verification not supported either
				} else if (setting(settingName='verifyCVNumber', requestBean=arguments.requestBean)) {
					arguments.responseBean.addMessage('configCvNumberCardTypeVerificationSupported', yesNoFormat(false));
				}
			}

			// Only for admin purposes
			arguments.responseBean.addMessage('apiRequestCVNumberProvided', yesNoFormat(arguments.requestMessageData.verifyCVNumberFlag));
			arguments.responseBean.addMessage('apiRequestCardTypeProvided', yesNoFormat(arguments.requestMessageData.cardTypeSupportedFlag));
	
			return arguments.requestMessageData;
		}
	
		private string function populateSOAPRequestBody(required string requestMessageTemplateFileName, required any requestBean, required struct requestMessageData) {
			var body = "";
	
			// Values made availabe to .cfm templates that assemble the SOAP request body
			local.requestMessageData = {};
			local.requestMessageData['merchantID'] = setting(settingName='merchantID', requestBean=arguments.requestBean);
			local.requestMessageData['requestMessageTemplateFileName'] = arguments.requestMessageTemplateFileName;
			local.requestMessageData['transactionKey'] = setting(settingName='transactionKeyTest', requestBean=arguments.requestBean);
			local.requestMessageData['soapApiVersion'] = setting(settingName='soapApiVersion', requestBean=arguments.requestBean);

			// Must be unique, otherwise CyberSource request results in error response
			if (!isNull( arguments.requestBean.getTransactionID())){
				local.requestMessageData['merchantReferenceCode'] = arguments.requestBean.getTransactionID();
			}else{
				throw("TransactionID does not exist to use as CyberSource merchant reference code.");
			}
			
			// Set Live transactionKey if not testing
			if (!getTestModeFlag(arguments.requestBean, 'testMode')) {
				local.requestMessageData['transactionKey'] = setting(settingName='transactionKeyLive', requestBean=arguments.requestBean);
			}
	
			// Aggregate requestMessageData structs, values defined in arguments override locally defined
			structAppend(local.requestMessageData, arguments.requestMessageData, true);
			
			// Root level SOAP Request template document 
			// SOAP Request for CyberSource Simple Order API
			// Root level template loads an additional child template (determined by requestMessageData.requestMessageTemplateFileName) to format request specific SOAP body
			savecontent variable="body" {
				include "PaymentSOAPRequestTemplate.cfm";
			}
	
			return body;
		}
	
		private struct function sendHttpSOAPRequest(required any requestBean, required any responseBean, required string body) {
			var httpRequest = new http();
			httpRequest.setMethod('post');
			httpRequest.setCharset('UTF-8');
			httpRequest.addParam(type="xml", value=arguments.body);
			httpRequest.setUrl(setting(settingName='endpointUrlTest', requestBean=arguments.requestBean));
	
			// Set Live Endpoint Url if not testing
			if (!getTestModeFlag(arguments.requestBean, 'testMode')) {
				httpRequest.setUrl(setting(settingName='endpointUrlLive', requestBean=arguments.requestBean));
			}
	
			// Make HTTP request to SOAP endpoint
			var httpResponse = httpRequest.send().getPrefix();
	
			var responseData = {};
			// Server error handling - Unavailable or Communication Problem
			if (left(httpResponse.statusCode, 1) == 5 || left(httpResponse.statusCode, 1) == 4) {
				arguments.responseBean.setStatusCode("ERROR");

				var faultString = "";
				try {
					faultString = xmlSearch(xmlParse(httpResponse.fileContent), "//*[local-name() = 'Fault']/*[local-name() = 'faultstring']")[1].xmlText;
				} catch (any e) {}

				// Only for admin purposes
				arguments.responseBean.addMessage('serverCommunicationFault', "#rbKey('cyberSource.error.serverCommunication_admin')# #httpResponse.statusCode#" & (len(faultString) ? ", faultstring: '#trim(faultString)#'" : ""));

				// Public error message
				arguments.responseBean.addError('serverCommunicationFault', "#rbKey('cyberSource.error.serverCommunication_public')#");
				
			// Server response successful, process SOAP body
			} else {
				// Convert raw XML response to xmlObject
				responseData = {
					xml = xmlParse(httpResponse.fileContent)
				};
	
				// Further response processing
				handleResponse(arguments.requestBean, arguments.responseBean, responseData);
			}
	
			return responseData;
		}
	
		private void function handleResponse(required any requestBean, required any responseBean, required any responseData) {
			
			// Set statusCode using 'decision' value. Eg. ACCEPT, REJECT, ERROR, REVIEW
			arguments.responseBean.setStatusCode(xmlSearch(responseData.xml, "//*[local-name() = 'decision']")[1].xmlText);
			
			// Set providerTransactionID with 'requestID' value, requestID is always present whether SOAP response is success or error
			arguments.responseBean.setProviderTransactionID(xmlSearch(responseData.xml, "//*[local-name() = 'requestID']")[1].xmlText);

			// Extract the AVS code if present.
			var avsCodeResult = xmlSearch(responseData.xml, "//*[local-name() = 'ccAuthReply']/*[local-name() = 'avsCode']");
			if (arrayLen(avsCodeResult)) {
				try {
					arguments.responseBean.setAVSCode(avsCodeResult[1].xmlText);
				} catch (any e) {
					// Only for admin purposes
					arguments.responseBean.addMessage('avsCodeUnsupported', avsCodeResult[1].xmlText);
				}
			}
			
			// Extract the CV code if present.
			var cvCodeResult = xmlSearch(responseData.xml, "//*[local-name() = 'ccAuthReply']/*[local-name() = 'cvCode']");
			if (arrayLen(cvCodeResult)) {
				// Resource: http://apps.cybersource.com/library/documentation/dev_guides/CC_Svcs_SO_API/Credit_Cards_SO_API.pdf#page=427
				arguments.responseBean.setSecurityCodeMatchFlag(cvCodeResult[1].xmlText == 'M');

				// Start special handling for cvNumber errors.
				var cvNumberErrorWasSimulatedFlag = false;

				// Test mode only logic for simulating cvNumber error
				// NOTE: During simluation CyberSource test mode will still show a successful transaction in the CyberSource Business Center "Test" backend
				// 		 CyberSource cannot differentiate our intent, we can only control our end of the logic and behavior for simulating an CVN error in this way
				if (getTestModeFlag(arguments.requestBean, 'testMode')) {

					// Setting stores a cvNumber which triggers when to simulate the cvNumber error (eg. "234")
					var simulateErrorCVNumberValue = setting(settingName='simulateErrorCVNumberValue', requestBean=arguments.requestBean);

					// Check if provided securityCode is trying to simulate error
					if (len(simulateErrorCVNumberValue) && !isNull(arguments.requestBean.getSecurityCode()) && len(arguments.requestBean.getSecurityCode()) && arguments.requestBean.getSecurityCode() == simulateErrorCVNumberValue) {
						// Public error message
						arguments.responseBean.addError('cvn', rbKey('cyberSource.error.cvv_invalid'));

						// Only for admin purposes
						arguments.responseBean.addMessage('cvnMatchError', "Simulated error: #rbKey('cyberSource.error.cvv_invalid')#");

						// Flag so we don't stack error messages in addition to the simulated error
						cvNumberErrorWasSimulatedFlag = true;
					}				
				}

				// Setting indicates which modes we want transaction errors to occur if there is CV security code mismatch
				var requireCVNumberMatchMode = setting(settingName='requireCVNumberMatchMode', requestBean=arguments.requestBean);

				// Check the cvNumber match result provided as part of CyberSource response only if integration setting indicates so
				// NOTE: only executes for test mode if setting condition is met AND we haven't already simulated a cvNumber error
				if (
					(getTestModeFlag(arguments.requestBean, 'testMode') && listFindNoCase('both,test', requireCVNumberMatchMode) && !cvNumberErrorWasSimulatedFlag)
					|| (!getTestModeFlag(arguments.requestBean, 'testMode') && listFindNoCase('both,live', requireCVNumberMatchMode))
				) {
					if (isBoolean(arguments.responseBean.getSecurityCodeMatchFlag()) && !arguments.responseBean.getSecurityCodeMatchFlag()) {
						// Public error message
						arguments.responseBean.addError('cvn', rbKey('cyberSource.error.cvv_invalid'));

						// Only for admin purposes
						arguments.responseBean.addMessage('cvnMatchError', rbKey('cyberSource.error.cvv_invalid'));
					}
				}
			}

			// Extract the reference code
			var referenceCodeResult = xmlSearch(responseData.xml, "//*[local-name() = 'merchantReferenceCode']");
			if (arrayLen(referenceCodeResult)) {
				// Only for admin purposes
				arguments.responseBean.addMessage('apiRequestMerchantReferenceNumber', referenceCodeResult[1].xmlText);
			}

			// Handle any defined SOAP API errors
			var reasonCode = xmlSearch(responseData.xml, "//*[local-name() = 'reasonCode']")[1].xmlText;
			if (responseBean.getStatusCode() != "ACCEPT" || reasonCode != "100") {
				var errorMessage = "";

				// Only for admin purposes
				arguments.responseBean.addMessage('reasonCode', "Decision: '#arguments.responseBean.getStatusCode()#' - #reasonCode# - "& rbKey('cyberSource.reasonCode.#reasonCode#'));

				// GlobalPayments CyberSource connectivity testing requires obfuscating reason code error details for certain errors to the public
				if (listFindNoCase('201,203,204,205,208,210,211', reasonCode)) {
					errorMessage = rbKey('cyberSource.reasonCode.2XX.sensitiveErrors');
				} else {
					errorMessage = rbKey('cyberSource.reasonCode.2XX.processingErrors');
				}

				// Only for admin purposes
				arguments.responseBean.addMessage('transactionError', errorMessage);

				// Special CVN error handling might have already added error message
				if (!arguments.responseBean.hasError('cvn')) {
					// Set the public friendly error message
					arguments.responseBean.addError('transactionError', errorMessage);
				}
			}
		}
	
		private void function sendRequestToGenerateToken(required any requestBean, required any responseBean) {
			
			if (isNull(arguments.requestBean.getProviderToken()) || !len(arguments.requestBean.getProviderToken())) {
				var requestMessageData = populateRequestMessageDataWithCardInfo(arguments.requestBean, arguments.responseBean);

				if (!arguments.responseBean.hasErrors()) {
					// cardType is valid cardType is required for tokenization and functionality must be available from CyberSource for specific card type
					if (!structKeyExists(requestMessageData, 'cardType')) {
						// Only for admin purposes
						arguments.responseBean.addMessage('cardType', "No tokenization is available for '#arguments.requestBean.getCreditCardType()#' credit cards.");

						// Public error message
						arguments.responseBean.addError('cardType', "#rbKey('cyberSource.error.cardTypeInvalid')# card type: '#arguments.requestBean.getCreditCardType()#'");
		
					// cardType is valid
					} else {
						// Set autoAuth override the default setting in CyberSource Business Center based on the integration setting
						// CyberSource Business Center > Payment Tokenization > Settings > Perform an automatic pre-authorization before creating profile
						requestMessageData.disableAutoAuth = setting(settingName='disableAutoAuth', requestBean=arguments.requestBean);

						var soapRequestBody = populateSOAPRequestBody("generateTokenTemplate.cfm", requestBean, requestMessageData);
						var responseData = sendHttpSOAPRequest(requestBean=arguments.requestBean, responseBean=arguments.responseBean, body=soapRequestBody);
						
						// Only for admin purposes
						arguments.responseBean.addMessage('apiRequestTokenizationWithAutoAuthEnabled', yesNoFormat(!requestMessageData.disableAutoAuth));

						if (!responseBean.hasErrors()) {
		
							// Extract subscriptionID and set it as part of the responseBean
							var subscriptionID = xmlSearch(responseData.xml, "//*[local-name() = 'paySubscriptionCreateReply']/*[local-name() = 'subscriptionID']")[1].xmlText;
							arguments.responseBean.setProviderToken(subscriptionID);

							// Extract the preAuthorization code
							var autoPreAuthorizatonCodeResult = xmlSearch(responseData.xml, "//*[local-name() = 'ccAuthReply']/*[local-name() = 'authorizationCode']");
							if (arrayLen(autoPreAuthorizatonCodeResult)) {
								arguments.responseBean.setAuthorizationCode(autoPreAuthorizatonCodeResult[1].xmlText);
							}

							// Extract the preAuthorization amount. This should be 0.00 or 1.00, depends on the payment processor and card type.
							// Visa and MasterCard allow zero dollar pre-authorizations
							var autoPreAuthorizationAmountResult = xmlSearch(responseData.xml, "//*[local-name() = 'ccAuthReply']/*[local-name() = 'amount']");
							if (arrayLen(autoPreAuthorizationAmountResult)) {
								arguments.responseBean.setAmountAuthorized(autoPreAuthorizationAmountResult[1].xmlText);
							}
						}
					}
				}

			// Uneccessary to make API request because same token generated during accountPaymentMethod create is valid for subsequent authorization requests
			// Manually populate responseBean with the relevant data
			} else {
				arguments.responseBean.setStatusCode("INTERALTOKENOBTAINED");
				arguments.responseBean.setProviderToken(requestBean.getProviderToken());
				arguments.responseBean.setProviderTransactionID(requestBean.getOriginalProviderTransactionID());

				// Only for admin purposes
				arguments.responseBean.addMessage('internalTokenObtained', rbKey('cyberSource.info.internalTokenObtained'));
			}
		}
	
		private void function sendRequestToAuthorize(required any requestBean, required any responseBean) {
			var requestMessageData = populateRequestMessageDataWithCardInfo(arguments.requestBean, arguments.responseBean);
			if (!arguments.responseBean.hasErrors()) {
				// Determine if we have a subscriptionID
				if (!isNull(arguments.requestBean.getProviderToken()) && len(arguments.requestBean.getProviderToken())) {
					// Only for admin purposes
					arguments.responseBean.addMessage('apiRequestSubscriptionID', arguments.requestBean.getProviderToken());
					requestMessageData['subscriptionID'] = arguments.requestBean.getProviderToken();
				}
		
				var soapRequestBody = populateSOAPRequestBody("authorizeTemplate.cfm", requestBean, requestMessageData);
				var responseData = sendHttpSOAPRequest(requestBean=arguments.requestBean, responseBean=arguments.responseBean, body=soapRequestBody);
		
				if (!responseBean.hasErrors()) {
					// providerTransactionID for authorization automatically set by handleResponse() method
					arguments.responseBean.setAuthorizationCode(xmlSearch(responseData.xml, "//*[local-name() = 'ccAuthReply']/*[local-name() = 'authorizationCode']")[1].xmlText);
					arguments.responseBean.setAmountAuthorized(xmlSearch(responseData.xml, "//*[local-name() = 'ccAuthReply']/*[local-name() = 'amount']")[1].xmlText);
				}
			}
		}
	
		private void function sendRequestToAuthorizeAndCharge(required any requestBean, required any responseBean) {
			var requestMessageData = populateRequestMessageDataWithCardInfo(arguments.requestBean, arguments.responseBean);
			
			if (!arguments.responseBean.hasErrors()) {
				// Determine if we have a subscriptionID
				if (!isNull(arguments.requestBean.getProviderToken()) && len(arguments.requestBean.getProviderToken())) {
					// Only for admin purposes
					arguments.responseBean.addMessage('apiRequestSubscriptionID', arguments.requestBean.getProviderToken());
					requestMessageData['subscriptionID'] = arguments.requestBean.getProviderToken();
				}
		
				var soapRequestBody = populateSOAPRequestBody("authorizeAndChargeTemplate.cfm", requestBean, requestMessageData);
				var responseData = sendHttpSOAPRequest(requestBean=arguments.requestBean, responseBean=arguments.responseBean, body=soapRequestBody);
		
				if (!responseBean.hasErrors()) {
					// providerTransactionID for authorization automatically set by handleResponse() method
					arguments.responseBean.setAuthorizationCode(xmlSearch(responseData.xml, "//*[local-name() = 'ccAuthReply']/*[local-name() = 'authorizationCode']")[1].xmlText);
					arguments.responseBean.setAmountAuthorized(xmlSearch(responseData.xml, "//*[local-name() = 'ccAuthReply']/*[local-name() = 'amount']")[1].xmlText);
					arguments.responseBean.setAmountReceived(xmlSearch(responseData.xml, "//*[local-name() = 'ccCaptureReply']/*[local-name() = 'amount']")[1].xmlText);
				}
			}
		}
	
		private void function sendRequestToChargePreAuthorization(required any requestBean, required any responseBean) {
			var requestMessageData = populateRequestMessageDataWithCardInfo(arguments.requestBean, arguments.responseBean);
			if (!arguments.responseBean.hasErrors()) {
				// Determine if we have a authorization code
				if (!isNull(arguments.requestBean.getOriginalAuthorizationProviderTransactionID()) && len(arguments.requestBean.getOriginalAuthorizationProviderTransactionID())) {
					requestMessageData['authRequestID'] = arguments.requestBean.getOriginalAuthorizationProviderTransactionID();
				} else {
					throw("There is no 'originalAuthorizationProviderTransactionID' in the transactionRequestBean. Expecting the value be the authorization code to reference for the charge/capture.");
				}
		
				var soapRequestBody = populateSOAPRequestBody("chargePreAuthorizationTemplate.cfm", requestBean, requestMessageData);
				var responseData = sendHttpSOAPRequest(requestBean=arguments.requestBean, responseBean=arguments.responseBean, body=soapRequestBody);
		
				if (!responseBean.hasErrors()) {
					// providerTransactionID for charge automatically set by handleResponse() method
					arguments.responseBean.setAmountReceived(xmlSearch(responseData.xml, "//*[local-name() = 'ccCaptureReply']/*[local-name() = 'amount']")[1].xmlText);
				}
			}
		}
	
		private void function sendRequestToCredit(required any requestBean, required any responseBean) {
			var requestMessageData = populateRequestMessageDataWithCardInfo(arguments.requestBean, arguments.responseBean);

			if (!arguments.responseBean.hasErrors()) {
				// creditCaptureRequestID can also be set as the providerTransactionID from the originalAuthorizationProviderTransactionID only if the charge has already been voided
				if (!isNull(arguments.requestBean.getOriginalChargeProviderTransactionID()) && len(arguments.requestBean.getOriginalChargeProviderTransactionID())) {
					logHibachi("CyberSource - Follow-on credit - Using original charge provider transactionID '#arguments.requestBean.getOriginalChargeProviderTransactionID()#' for 'credit'.");
					requestMessageData['creditCaptureRequestID'] = arguments.requestBean.getOriginalChargeProviderTransactionID();
				
				// Determine if we have subscriptionID
				} else if (!isNull(arguments.requestBean.getProviderToken()) && len(arguments.requestBean.getProviderToken())) {
					logHibachi("CyberSource - On-demand credit - Using previously created token (subscriptionID) '#arguments.requestBean.getProviderToken()#' from 'generateToken'.");
					requestMessageData['subscriptionID'] = arguments.requestBean.getProviderToken();
				
				// Stand-alone credit transaction
				} else {
					logHibachi("CyberSource - Stand-alone credit - Expecting direct credit card information.");
				}
		
				var soapRequestBody = populateSOAPRequestBody("creditTemplate.cfm", requestBean, requestMessageData);
				var responseData = sendHttpSOAPRequest(requestBean=arguments.requestBean, responseBean=arguments.responseBean, body=soapRequestBody);
		
				if (!responseBean.hasErrors()) {
					// providerTransactionID for charge automatically set by handleResponse() method
					arguments.responseBean.setAmountCredited(arguments.requestBean.getTransactionAmount());
				}
			}
		}
	
		private void function sendRequestToVoid(required any requestBean, required any responseBean) {
			// Void any captures and credits, and related authorization with either with automatically be reversed when all is voided.
			// But cannot void authorization with no capture or credits to trigger authorization an auto-reversal, must explicitly invoke authorization reversal
			// Error with reason code 246 will occur and then we could try an authorization reversal
	
			var requestMessageData = populateRequestMessageDataWithCardInfo(arguments.requestBean, arguments.responseBean);
			if (!arguments.responseBean.hasErrors()) {
				// voidRequestID can be set to either a chargeID/captureID or creditID
				if (!isNull(arguments.requestBean.getOriginalChargeProviderTransactionID()) && len(arguments.requestBean.getOriginalChargeProviderTransactionID())) {
					requestMessageData['voidRequestID'] = arguments.requestBean.getOriginalChargeProviderTransactionID();
				}
		
				var soapRequestBody = populateSOAPRequestBody("voidTemplate.cfm", requestBean, requestMessageData);
				var responseData = sendHttpSOAPRequest(requestBean=arguments.requestBean, responseBean=arguments.responseBean, body=soapRequestBody);
			}
		}
	}