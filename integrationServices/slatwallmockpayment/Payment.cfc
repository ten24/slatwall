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

component accessors="true" output="false" displayname="Slatwall Mock Payment" implements="Slatwall.integrationServices.PaymentInterface" extends="Slatwall.integrationServices.BasePayment" {

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
				throw("Slatwall Mock Payment Intgration has not been implemented to handle #arguments.requestBean.getTransactionType()#");
			}
			
			return responseBean;
		}
		
		private void function sendRequestToGenerateToken(required any requestBean, required any responseBean) {

			// We are expecting there is no provider token yet, however if accountPaymentMethod is used and attempt to generate another token prevent and short circuit
			if (isNull(arguments.requestBean.getProviderToken()) || !len(arguments.requestBean.getProviderToken())) {

				var responseData = sendHttpAPIRequest(arguments.requestBean, arguments.responseBean);

				// Extract data and set as part of the responseBean
				if (!responseBean.hasErrors()) {
					arguments.responseBean.setProviderToken(responseData.token);
					arguments.responseBean.setProviderTransactionID(responseData.transactionID);
				}
			} else {
				throw('Attempting to generate token. The payment method used already had a valid token');

				// Uneccessary to make API request because same token generated during accountPaymentMethod create is valid for subsequent authorization requests
				arguments.responseBean.setProviderToken(requestBean.getProviderToken());
				arguments.responseBean.setProviderTransactionID(requestBean.getOriginalProviderTransactionID());
			}
				// writeDump(var=arguments.responseBean.setProviderToken(responseData.token.token));
		}
		
		private void function sendRequestToAuthorize(required any requestBean, required any responseBean) {

			var responseData = sendHttpAPIRequest(arguments.requestBean, arguments.responseBean);

			// Response Data
			if (!responseBean.hasErrors()) {
				arguments.responseBean.setProviderTransactionID(responseData.transactionID);
				arguments.responseBean.setAuthorizationCode(responseData.authorizationCode);
				arguments.responseBean.setAmountAuthorized(responseData.transactionAmount);
			}
		}
		
		private void function sendRequestToAuthorizeAndCharge(required any requestBean, required any responseBean) {
			
			var responseData = sendHttpAPIRequest(arguments.requestBean, arguments.responseBean);
			
			if (!responseBean.hasErrors()) {
				arguments.responseBean.setProviderTransactionID(responseData.transactionID);
				//arguments.responseBean.setAuthorizationCode(responseData.authorizationCode);
				arguments.responseBean.setAmountAuthorized(responseData.transactionAmount);
				arguments.responseBean.setAmountReceived(responseData.transactionAmount);
			}
		}
		
		private void function sendRequestToChargePreAuthorization(required any requestBean, required any responseBean) {
			if (!isNull(arguments.requestBean.getOriginalAuthorizationProviderTransactionID()) && len(arguments.requestBean.getOriginalAuthorizationProviderTransactionID())) {
				
				var responseData = sendHttpAPIRequest(arguments.requestBean, arguments.responseBean);

				if (!responseBean.hasErrors()) {
					arguments.responseBean.setProviderTransactionID(responseData.transactionID);
					arguments.responseBean.setAmountReceived(responseData.transactionAmount);
				}
			} else {
				throw("There is no 'originalAuthorizationProviderTransactionID' in the transactionRequestBean. Expecting the value be the authorization code to reference for the charge/capture.");
			}
		}
		
		private void function sendRequestToCredit(required any requestBean, required any responseBean) {
			
			if (!isNull(arguments.requestBean.getOriginalChargeProviderTransactionID()) && len(arguments.requestBean.getOriginalChargeProviderTransactionID())) {

				var responseData = sendHttpAPIRequest(arguments.requestBean, arguments.responseBean);

				if (!responseBean.hasErrors()) {
					arguments.responseBean.setProviderTransactionID(responseData.transactionID);
					arguments.responseBean.setAmountCredited(responseData.transactionAmount);
				}
			} else {
				throw("There is no 'originalAuthorizationProviderTransactionID' in the transactionRequestBean. Expecting the value be a reference to transactionID for the original charge/capture.");
			}
		}
		
		private void function sendRequestToVoid(required any requestBean, required any responseBean) {
			if (!isNull(arguments.requestBean.getOriginalChargeProviderTransactionID()) && len(arguments.requestBean.getOriginalChargeProviderTransactionID())) {
				
				var responseData = sendHttpAPIRequest(arguments.requestBean, arguments.responseBean);
				
				if (!responseBean.hasErrors()) {
					arguments.responseBean.setProviderTransactionID(responseData.transactionID);
				}
			} else {
				throw("There is no 'originalAuthorizationProviderTransactionID' in the transactionRequestBean. Expecting the value be a reference to transactionID for the original charge/capture or credit.");
			}
		}
		
		// Simulates http API request/response data (success and error can be simulated based on specific inputs)
		private struct function sendHttpAPIRequest(required any requestBean, required any responseBean) {
			
			// If not in testing should throw an error? this is a mock afterall
			if (!getTestModeFlag(arguments.requestBean, 'testMode')) {
			}

			var responseData = {};

			// Simulate latency
			sleep(randRange(30, 90));
			
			// Append appropriate API Resource
			if (arguments.requestBean.getTransactionType() == 'generateToken') {
				responseData.transactionID = "mockTxID_tok_#createHibachiUUID()#";
				responseData.token = 'mockToken_#createHibachiUUID()#';
			} else if (arguments.requestBean.getTransactionType() == 'authorize') {
				responseData.transactionID = "mockTxID_auth_#createHibachiUUID()#";
				responseData.transactionAmount = arguments.requestBean.getTransactionAmount();
				responseData.authorizationCode = "mockAuthCode_#createHibachiUUID()#";
			} else if (arguments.requestBean.getTransactionType() == 'authorizeAndCharge') {
				responseData.transactionID = "mockTxID_auth_capt_#createHibachiUUID()#";
				responseData.transactionAmount = arguments.requestBean.getTransactionAmount();
				//responseData.authorizationCode = "mockAuthCode_#createHibachiUUID()#";
			} else if (arguments.requestBean.getTransactionType() == 'chargePreAuthorization') {
				responseData.transactionID = "mockTxID_capt_#createHibachiUUID()#";
				responseData.transactionAmount = arguments.requestBean.getTransactionAmount();
			} else if (arguments.requestBean.getTransactionType() == 'credit') {
				responseData.transactionID = "mockTxID_cred_#createHibachiUUID()#";
				responseData.transactionAmount = arguments.requestBean.getTransactionAmount();
			} else if (arguments.requestBean.getTransactionType() == 'void') {
				responseData.transactionID = "mockTxID_void_#createHibachiUUID()#";
			}

			return responseData;
		}
	}