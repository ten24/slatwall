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
	
	public any function processExternal(required any requestBean){
		
		var responseBean = getTransient("externalTransactionResponseBean");
		
		// Set default currency
		if (isNull(arguments.requestBean.getTransactionCurrencyCode()) || !len(arguments.requestBean.getTransactionCurrencyCode())) {
			arguments.requestBean.setTransactionCurrencyCode(setting(settingName='skuCurrency', requestBean=arguments.requestBean));
		}
		
		
		switch(arguments.requestBean.getTransactionType()){
			case 'authorize':
				sendRequestToAuthorize(arguments.requestBean, responseBean);
				break;
			case 'receive':
			case 'authorizeAndCharge':
			case 'chargePreAuthorization':
				sendRequestToAuthorizeAndCharge(arguments.requestBean, responseBean);
				break;
			case 'balance':
				getAccountBalance(arguments.requestBean, responseBean);
				break;
			case 'credit':
				sendRequestToCredit(arguments.requestBean, responseBean);
				break;
			case 'vendorBalance':
				getVendorBalance(arguments.requestBean, responseBean);
				break;
			default:
				responseBean.addError("Processing error", "This Integration has not been implemented to handle #arguments.requestBean.getTransactionType()#");
		}
		
		return responseBean;
	}
	
	/**
	 * This function creates transfer request
	 * 
	 * reference : https://portal.hyperwallet.com/content/api/v3/resources/transfers/create
	 * */
	
	private void function sendRequestToAuthorize(required any requestBean, required any responseBean) {
		
		if (isNull(arguments.requestBean.getProviderToken()) || !len(arguments.requestBean.getProviderToken())) {
			arguments.responseBean.addError("Processing error", "Error attempting to authorize. Review providerToken.");
			return;
		}
		
		
		var requestData = {
			'clientTransferId' = arguments.requestBean.getTransactionID(),
			'destinationAmount' = LSParseNumber(arguments.requestBean.getTransactionAmount()),
			'destinationCurrency' = arguments.requestBean.getTransactionCurrencyCode(),
			'notes': "Partial-Balance Transfer", //TODO: Add order information
			'memo': "TransferClientId56387",//TODO: Add order information
			'sourceToken' = arguments.requestBean.getProviderToken(),
			'destinationToken': setting(settingName='vendorAccount', requestBean=arguments.requestBean)
		};
		// Response Data
		var responseData = sendHttpAPIRequest(arguments.requestBean, 'transfers', requestData);
		
		if(structKeyExists(responseData,'status_code') && responseData.status_code == "201" && structKeyExists(responseData,'fileContent') ) {
			
			if(IsJson(responseData.fileContent)) {
				responseData = deserializeJSON(responseData.fileContent);
			}
			
			if( structKeyExists(responseData,'token') && structKeyExists(responseData,'sourceAmount') ) {
				
				arguments.responseBean.setAuthorizationCode(responseData.token);
				arguments.responseBean.setAmountAuthorized(responseData.sourceAmount);
				
			} else {
				arguments.responseBean.addError("Processing error", "Error while attempting to authorize.");
			}
			
		} else {
			arguments.responseBean.addError("Processing error", "Error in attempting to authorize.");
		}
		
	}
	
	/**
	 * This function commits transfer request
	 * 
	 * reference : https://portal.hyperwallet.com/content/api/v3/resources/transfers/commit
	 * */
	private void function sendRequestToAuthorizeAndCharge(required any requestBean, required any responseBean) {
		
		//Create transfer request
		sendRequestToAuthorize(argumentCollection = arguments);
		if(arguments.responseBean.hasErrors()){
			return;
		}
		
		var shortReferenceID = '';
		
		if(!isNull(arguments.requestBean.getOrder())){
			shortReferenceID = arguments.requestBean.getOrder().getShortReferenceID(true);
		}
		
		//request to commit transfer
		var requestData = {
			'transition' = 'SCHEDULED',
			'notes' = shortReferenceID
		};
		

		// Response Data
		var responseData = sendHttpAPIRequest(arguments.requestBean, 'transfers/#arguments.responseBean.getAuthorizationCode()#/status-transitions', requestData);
		
		if(structKeyExists(responseData,'status_code') && responseData.status_code == "201" && structKeyExists(responseData,'fileContent') ) {
			
			if(IsJson(responseData.fileContent)) {
				responseData = deserializeJSON(responseData.fileContent);
			}
			
			if( structKeyExists(responseData,'token') ) {
				arguments.responseBean.setAuthorizationCode(responseData.token);
				arguments.responseBean.setProviderTransactionID(responseBean.getAuthorizationCode());
				arguments.responseBean.setAmountReceived(responseBean.getAmountAuthorized());
			} else {
				arguments.responseBean.addError("Processing error", "Error while attempting to Charge.");
			}
			
		} else {
			arguments.responseBean.addError("Processing error", "Error in attempting to Charge.");
		}
		
	}
	
	/**
	 * This function creates payment refund 
	 * 
	 * reference : https://portal.hyperwallet.com/content/api/v3/resources/payments/create
	 * */
	private void function sendRequestToCredit(required any requestBean, required any responseBean) {
		// Request Data
		if (isNull(arguments.requestBean.getProviderToken()) || !len(arguments.requestBean.getProviderToken())) {
			arguments.responseBean.addError("Processing error", "Error attempting to authorize. Review providerToken.");
			return;
		}

		var shortReferenceID = '';
		
		if(!isNull(arguments.requestBean.getOrder())){
			shortReferenceID = arguments.requestBean.getOrder().getShortReferenceID(true);
		}
		
		var requestData = {
			'amount' = LSParseNumber(arguments.requestBean.getTransactionAmount()),
			'clientPaymentId' = arguments.requestBean.getTransactionID(),
			'currency' = arguments.requestBean.getTransactionCurrencyCode(),
			'destinationToken' = arguments.requestBean.getProviderToken(), //It is customer account payment method token for refund
			'programToken' = setting(settingName='program', requestBean=arguments.requestBean),
			'purpose': 'OTHER',
			'memo': shortReferenceID
		};
		
		
		// Response Data
		var responseData = sendHttpAPIRequest(arguments.requestBean, 'payments', requestData);
		
		if(structKeyExists(responseData,'status_code') && responseData.status_code == "201" && structKeyExists(responseData,'fileContent') ) {
			
			if(IsJson(responseData.fileContent)) {
				responseData = deserializeJSON(responseData.fileContent);
			}
			
			if( structKeyExists(responseData,'token') && structKeyExists(responseData,'amount') ) {
				arguments.responseBean.setProviderTransactionID(responseData.token);
				arguments.responseBean.setAmountAuthorized(responseData.amount);
				arguments.responseBean.setAmountCredited(responseData.amount);
			} else {
				arguments.responseBean.addError("Processing error", "Error while attempting to Credit.");
			}
			
		} else {
			arguments.responseBean.addError("Processing error", "Error in attempting to Credit.");
		}
	}
	
	private void function getAccountBalance(required any requestBean, required any responseBean) {
		if (isNull(arguments.requestBean.getProviderToken()) || !len(arguments.requestBean.getProviderToken())) {
			arguments.responseBean.addError("Processing error", "Error attempting to authorize. Review providerToken.");
			return;
		}
		
		var requestData = {};
		var responseData = sendHttpAPIRequest(arguments.requestBean, 'users/#arguments.requestBean.getProviderToken()#/balances', requestData);
		
		if( structKeyExists(responseData,'status_code') && responseData.status_code == "200" && structKeyExists(responseData,'fileContent') ) {
			
			if(IsJson(responseData.fileContent)) {
				responseData = deserializeJSON(responseData.fileContent);
			}
			
			if( structKeyExists(responseData,'data') && structKeyExists(responseData.data[1],'amount') ) {
				
				arguments.responseBean.setAmountAuthorized(responseData.data[1].amount);
				
			} else {
				arguments.responseBean.addError("Processing error", "Error while fetching account balance.");
			}
			
		} else {
			arguments.responseBean.addError("Processing error", "Error in fetching account balance.");
		}
	}
	
	private void function getVendorBalance(required any requestBean, required any responseBean) {
		
		var programToken = setting(settingName='program', requestBean=arguments.requestBean);
		var vendorAccount = setting(settingName='vendorAccount', requestBean=arguments.requestBean);
		var requestData = {};
		var responseData = sendHttpAPIRequest(arguments.requestBean, 'programs/#programToken#/accounts/#vendorAccount#/balances', requestData);
		
		if(IsJson(responseData.fileContent)) {
			responseData = deserializeJSON(responseData.fileContent);
		}
		
		if(structKeyExists(responseData, 'data')){
			arguments.responseBean.setAmountAuthorized(responseData.data[1].amount);
		}else{
			arguments.responseBean.addError("Processing error", "Error attempting to fetch account balance.");
		}
		
	}
	
	private any function sendHttpAPIRequest(required any requestBean, required string uri, required struct data) {
		var apiUrl = 'https://uat-api.paylution.com/rest/v3/';
		var password = setting(settingName='passwordTest', requestBean=arguments.requestBean);
		var username = setting(settingName='usernameTest', requestBean=arguments.requestBean);
		var requestMethod = "POST";
		
		// Set Live Endpoint Url if not testing
		if (!getTestModeFlag(arguments.requestBean, 'testMode')) {
			apiUrl = 'https://api.paylution.com/rest/v3/';
			password = setting(settingName='passwordLive', requestBean=arguments.requestBean);
			username = setting(settingName='usernameLive', requestBean=arguments.requestBean);
		}
		
		apiUrl &= uri;
		
		if( (find("users",arguments.uri) && find('balances',arguments.uri) )
			|| (find("accounts",arguments.uri) && find('balances',arguments.uri))
			)
		{
			requestMethod = "GET";
		}
		
		var basicAuthCredentialsBase64 = toBase64('#username#:#password#');

		var httpRequest = new http();
		httpRequest.setUrl(apiUrl);
		httpRequest.setMethod('#requestMethod#');
		httpRequest.setCharset('UTF-8');
		httpRequest.addParam(type="header", name="Authorization", value="Basic #basicAuthCredentialsBase64#");
		httpRequest.addParam(type="header", name="Content-Type", value='application/json');
		httpRequest.addParam(type="header", name="Accept", value='application/json');
		if(structIsEmpty(arguments.data))
		{
			arguments.data = "";
		}
		else{
			arguments.data = serializeJSON(arguments.data);
		}
		
		if(requestMethod != 'GET') {
			httpRequest.addParam(type="body", value=arguments.data);
		}
		
		// Make HTTP request to endpoint
		return httpRequest.send().getPrefix();
	}
}