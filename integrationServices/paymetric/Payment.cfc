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

component accessors="true" output="false" displayname="Paymetric XiPay" implements="Slatwall.integrationServices.PaymentInterface" extends="Slatwall.integrationServices.BasePayment" {

	//Global variables

	public any function init(){
		variables.packetOperations = {
			"generateToken"=1,
			"authorize"=1,
			"authorizeAndCharge"=16,
			"chargePreAuthorization"=17,
			"getTransactionStatus"=4
		};
		
		variables.merchantIDs = {
			"GBP"=setting('GBPmerchantID'),
			"USD"=setting('USDmerchantID'),
			"EUR"=setting('EURmerchantID'),
			"USDWine"=setting('USDWineMerchantID')
		};
		
		return this;
	}
	
	public any function setting(required string settingName, any requestBean) {
		if(!isNull(arguments.requestBean)){
			// Allows settings to be requested in the context of the site where the order was created
			if (!isNull(arguments.requestBean.getOrder()) && !isNull(arguments.requestBean.getOrder().getOrderCreatedSite()) && !arguments.requestBean.getOrder().getOrderCreatedSite().getNewFlag()) {
				arguments.filterEntities = [arguments.requestBean.getOrder().getOrderCreatedSite()];
			} else if (!isNull(arguments.requestBean.getAccount()) && !isNull(arguments.requestBean.getAccount().getAccountCreatedSite())) {
				arguments.filterEntities = [arguments.requestBean.getAccount().getAccountCreatedSite()];
			}
		}
		return super.setting(argumentCollection=arguments);
	}

	public string function getPaymentMethodTypes() {
		return "creditCard,ach";
	}

	public any function processCreditCard(required any requestBean){
		var transactionHeader = getTransactionHeader(arguments.requestBean);
		transactionHeader.populateForCreditCard(arguments.requestBean);
		var transactionResponse = getTransactionResponse(transactionHeader);
		return getResponseBean(transactionResponse, transactionHeader, requestBean);
	}
	
	public any function processACH(required any requestBean){
		var transactionHeader = getTransactionHeader(arguments.requestBean, 'ACH');
		transactionHeader.populateForACH(arguments.requestBean);
		var transactionResponse = getTransactionResponse(transactionHeader);
		return getResponseBean(transactionResponse, transactionHeader, requestBean, 'ACH');
	}
	
	public any function getACHTransactionStatus(required any requestBean){
		return getTransactionStatus(requestBean);
	}
	
	public any function getCreditCardTransactionStatus(required any requestBean){
		return getTransactionStatus(requestBean);
	}
	
	public any function getTransactionStatus(required any requestBean){
		var transactionHeader = getTransactionHeader(arguments.requestBean);
		var transactionResponse = getTransactionResponse(transactionHeader);
	}

	private any function getTransactionHeader(required any requestBean, string paymentMethodType="creditCard"){
		var transactionHeader = getTransient('PaymetricITransactionHeader');
		var currencyCode = arguments.requestBean.getTransactionCurrencyCode();
		if(isNull(currencyCode)){
			currencyCode = 'USD';
		}
		
		transactionHeader.setMerchantID(setting('#currencyCode#MerchantID',arguments.requestBean));
		if(!isNull(arguments.requestBean.getOrderPayment())){
			var order = arguments.requestBean.getOrderPayment().getOrder();
		}else if(!isNull(arguments.requestBean.getOrder())){
			var order = arguments.requestBean.getOrder();
		}
		
		if(structKeyExists(local,'order')){
			if(!isNull(order.getWineAuctionFlag()) && order.getWineAuctionFlag()){
				transactionHeader.setMerchantID(setting('#currencyCode#WineMerchantID',arguments.requestBean))
			}	
		}
		
		transactionHeader.setPacketOperation(variables.packetOperations[requestBean.getTransactionType()]);

		if(requestBean.getTransactionType() == 'chargePreAuthorization'){
			transactionHeader.setTransactionID(arguments.requestBean.getOriginalAuthorizationProviderTransactionID());
			transactionHeader.setBatchID(createHibachiUUID());
			return transactionHeader;
		}
		
		if(requestBean.getTransactionType() == 'getTransactionStatus'){
			transactionHeader.setTransactionID(arguments.requestBean.getOriginalProviderTransactionID());
		}

		if(requestBean.getTransactionType() == 'generateToken'){
			if(arguments.paymentMethodType == 'creditCard'){
				transactionHeader.setPreauthorized('true');
				transactionHeader.setAmount(0);
			}
		}else{
			transactionHeader.setAmount(arguments.requestBean.getTransactionAmount());
		}
		transactionHeader.setCurrencyKey(currencyCode);
		
		return transactionHeader;
	}

	private any function getTransactionResponse(required any transactionHeader){
		var packetsObject = getTransient('PaymetricIPacketsObject');
		packetsObject.addPacket(arguments.transactionHeader);
		var requestBean = getXiPayRequestBean();
		requestBean.setPacketsObj(packetsObject);
		return requestBean.getResponseBean().getData();
	}

	public any function getXiPayRequestBean(){
		if(setting('TestModeFlag')){
			var gateway = setting('testGatewayURL');
		}else{
			var gateway = setting('gatewayURL');
		}

		var requestBean = getTransient('PaymetricXiPayRequestBean');
		requestBean.setUsername(setting('username'));
		requestBean.setPassword(setting('password'));
		requestBean.setUrlString(gateway);

		return requestBean;
	}

	private any function getResponseBean(required any responseData, required any requestData, required any requestBean, string paymentMethodType = 'creditCard'){
		var response = getTransient('#arguments.paymentMethodType#TransactionResponseBean');
		try{
			var responseStruct = xmlParse(arguments.responseData);
		}catch(any e){
			response.addError('createTransaction','No response from payment processor.');
			return response;
		}
		try{
			var transactionResponse = responseStruct['soap:Envelope']['soap:Body']['SoapOpResponse']['SoapOpResult']['packets'][1]['ITransactionHeader'];
		}catch(any e){
			logHibachi('Paymetric Response: #serializeJson(responseStruct)#',true);
			response.addError('createTransaction','No response from payment processor.');
			return response;
		}
		// Populate the data with the raw response & request
		var xmlData = XmlNew(true);
		var data = {
			responseData = arguments.responseData,
			requestData = toString(arguments.requestData.getRequestData(xmlData))
		};

		response.setData(data);

		// Add message for what happened
		if(structKeyExists(transactionResponse, 'ResponseCode')){
			var messageName = transactionResponse['ResponseCode'].XmlText;
		}else{
			var messageName = transactionResponse['StatusCode'].XmlText;
		}
		response.addMessage(messageName=messageName, message=transactionResponse['Message'].XmlText);

		// Set the response Code
		response.setStatusCode( transactionResponse['StatusCode'].XmlText );

		// Check to see if it was successful
		if(left(transactionResponse['StatusCode'].XmlText,1) == '-') {
			// Transaction did not go through
			response.addError(messageName, transactionResponse['Message'].XmlText);
			response.addMessage(messageName, transactionResponse['Message'].XmlText);
		} else {
			if(requestBean.getTransactionType() == "authorize") {
				response.setAmountAuthorized( transactionResponse['Amount'].XmlText );
			} else if(requestBean.getTransactionType() == "authorizeAndCharge") {
				response.setAmountAuthorized(  transactionResponse['Amount'].XmlText );
				response.setAmountReceived(  transactionResponse['SettlementAmount'].XmlText  );
			} else if(requestBean.getTransactionType() == "chargePreAuthorization") {
				response.setAmountReceived(  requestBean.getTransactionAmount()   );
			} else if(requestBean.getTransactionType() == "credit") {
				response.setAmountCredited(  responseData.amount  );
			}
		}

		response.setTransactionID( transactionResponse['TransactionID'].XmlText );
		if(structKeyExists(transactionResponse, 'AuthorizationCode')){
			response.setAuthorizationCode( transactionResponse['AuthorizationCode'].XmlText );
		}
		if(structKeyExists(transactionResponse, 'CardNumber')){
			response.setProviderToken(transactionResponse['CardNumber'].XmlText);
		}
		if(!isNull(requestBean.getBankRoutingNumber())){
			response.setBankRoutingNumber(requestBean.getBankRoutingNumber());
		}
		// if( responseData.avsResponse == "B" || responseData.avsResponse == "P" ) {
		// 	response.setAVSCode( "U" );
		// } else {
		// 	response.setAVSCode( responseData.avsResponse );
		// }

		var csvResult = getCSVResult(transactionResponse);

		if(!isNull(csvResult)){
			if(csvResult == 'M') {
				response.setSecurityCodeMatchFlag(true);
			} else {
				response.setSecurityCodeMatchFlag(false);
			}
		}
		
		return response;
	}
	
	public string function getSupportedSaveOrderPaymentTransactionTypes(){
		return 'authorize,authorizeAndCharge';
	}

	private string function getCSVResult(required any transactionResponse){
		if(structKeyExists(transactionResponse,'InfoItems')){
			for(var i=1; i<=ArrayLen(transactionResponse['InfoItems'].xmlChildren); i++){
				var infoItem = transactionResponse['InfoItems'].xmlChildren[i];
				if(infoItem['Key'].XmlText == 'CSV_RESULT'){
					return infoItem['Value'].XmlText;
				}
			}
		}
	}

}