/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:																		
																			
	The documentation for this integration was found here:					
	http://download.chasepaymentech.com/									
																			
	It impliments the XML version of the API								
																			
*/

component accessors="true" output="false" displayname="PayFlowPro" implements="Slatwall.integrationServices.PaymentInterface" extends="Slatwall.integrationServices.BasePayment" {
	
	//Global variables
	variables.liveGatewayURL = "https://orbital1.paymentech.net/authorize";
	variables.testGatewayURL = "https://orbitalvar1.paymentech.net/authorize";
	variables.version = "5.7";
	variables.timeout = "30";
	variables.transactionCodes = {};

	public any function init(){
		// Set Defaults
		variables.transactionCodes = {
			authorize="A",
			authorizeAndCharge="AC",
			chargePreAuthorization="MFC",
			credit="R",
			void="",
			inquiry="",
			generateToken=""
		};
		
		return this;
	}
	
	public string function getPaymentMethodTypes() {
		return "creditCard";
	}
	
	public any function processCreditCard(required any requestBean){
		
		var requestXML = "";
		var responseBean = getTransient("CreditCardTransactionResponseBean");
		
		if(listFindNoCase("authorize,authorizeAndCharge,credit", arguments.requestBean.getTransactionType())) {
			savecontent variable="requestXML" {
				include "xmltemplates/NewOrderRequest.cfm"; 
			}
		} else if(listFindNoCase("chargePreAuthorization", arguments.requestBean.getTransactionType())) {
			savecontent variable="requestXML" {
				include "xmltemplates/MarkForCapture.cfm"; 
			}
		} else if(listFindNoCase("generateToken", arguments.requestBean.getTransactionType())) {
			savecontent variable="requestXML" {
				include "xmltemplates/ProfileAddRequest.cfm"; 
			}
		}

		// Get the response from Orbital
		try {
			var response = postRequest(requestXML);
			responseBean = getResponseBean(response.fileContent, requestXML, requestBean);
		} catch(any e) {
			/* An unexpected error happened, handled below */
			responseBean.addError("Processing error", e.message);
		}
		
		return responseBean;
	}
	
	private any function postRequest(required string requestXML) {
		var httpRequest = new Http();
		httpRequest.setMethod("POST");
		if( setting('liveModeFlag') ) {
			httpRequest.setUrl( variables.liveGatewayURL );
		} else {
			httpRequest.setUrl( variables.testgatewayURL );	
		}
		httpRequest.setPort("443");
		httpRequest.setTimeout(variables.timeout);
		httpRequest.setResolveurl(false);
		
		httpRequest.addParam(type="header",name="MIME-Version",VALUE="1.0");
		httpRequest.addParam(type="header",name="Content-type",VALUE="application/PTI57");
		httpRequest.addParam(type="header",name="Content-length",VALUE="#Len(trim(requestXML))#");
		httpRequest.addParam(type="header",name="Content-transfer-encoding",VALUE="text");
		httpRequest.addParam(type="header",name="Request-number",VALUE="1");
		httpRequest.addParam(type="header",name="Document-type",VALUE="Request");
		//httpRequest.addParam(type="header",name="Trace-number",VALUE="");
		httpRequest.addParam(type="header",name="Interface-Version",VALUE="Slatwall #getApplicationValue('version')#");
		httpRequest.addParam(type="header",name="Accept",VALUE="application/xml");
		httpRequest.addParam(type="body",value="#trim(requestXML)#");
		
		var response = httpRequest.send().getPrefix();
		
		return response;
	}
	
	private any function getResponseBean(required string rawResponse, required any requestData, required any requestBean) {
		var response = getTransient("CreditCardTransactionResponseBean");
		
		var responseData = {};
		var responseNode = "";
		if(listFindNoCase("authorize,authorizeAndCharge,credit", arguments.requestBean.getTransactionType())) {
			responseNode = "NewOrderResp";
		} else if(listFindNoCase("chargePreAuthorization", arguments.requestBean.getTransactionType())) {
			responseNode = "MarkForCaptureResp";
		} else if(listFindNoCase("generateToken", arguments.requestBean.getTransactionType())) {
			responseNode = "ProfileResp";
		}

		// Parse The Raw Response Data Into a Struct
		// normalize the response first
		var xmlResponse = rawResponse;
		var xmlResponse = replaceNoCase(xmlResponse,"ProfileProcStatus","ProcStatus","all");
		var xmlResponse = replaceNoCase(xmlResponse,"CustomerProfileMessage","StatusMsg","all");
		var xmlResponse = XmlParse(REReplace(xmlResponse, "^[^<]*", "", "one"));
		if(structKeyExists(xmlResponse.response, "QuickResponse")) {
			responseData = xmlResponse.response["QuickResponse"];
		} else if(structKeyExists(xmlResponse.response, "QuickResp")) {
			responseData = xmlResponse.response["QuickResp"];
		} else if(structKeyExists(xmlResponse.response, responseNode)) {
			responseData = xmlResponse.response[responseNode];
		} else {
			responseData["ProcStatus"] = {xmlText="0"};
			responseData["StatusMsg"] = {xmlText="Unknown Response"};
		}
						
		// Populate the data with the raw response & request
		var data = {
			responseData = arguments.rawResponse,
			requestData = arguments.requestData
		};
		
		response.setData(data);
		
		// Add message for what happened
		response.addMessage(messageName=responseData.ProcStatus.xmlText, message=responseData.StatusMsg.xmlText);
		
		// Set the response Code
		response.setStatusCode( responseData.ProcStatus.xmlText );
		
		// Check to see if it was successful
		if(response.getStatusCode() != 0 ) {
			// Transaction did not go through
			response.addError(responseData.ProcStatus.xmlText, responseData.StatusMsg.xmlText);
		} else if(structKeyExists(responseData,"ApprovalStatus") && responseData.ApprovalStatus.xmlText != 1) {
			// Transaction was not approved
			response.addError(responseData.RespCode.xmlText, responseData.StatusMsg.xmlText);
		} else {
			if(requestBean.getTransactionType() == "authorize") {
				response.setAmountAuthorized( requestBean.getTransactionAmount() );
			} else if(requestBean.getTransactionType() == "authorizeAndCharge") {
				response.setAmountAuthorized(  requestBean.getTransactionAmount() );
				response.setAmountCharged(  requestBean.getTransactionAmount()  );
			} else if(requestBean.getTransactionType() == "chargePreAuthorization") {
				response.setAmountCharged(  requestBean.getTransactionAmount()  );
			} else if(requestBean.getTransactionType() == "credit") {
				response.setAmountCredited(  requestBean.getTransactionAmount()  );
			} else if(requestBean.getTransactionType() == "generateToken") {
				response.setProviderToken( responseData.CustomerRefNum.xmlText );
			}
				
			if( structKeyExists(responseData,"AuthCode") ) {
				response.setAuthorizationCode( responseData.AuthCode.xmlText );
			}
			
		}
		
		if( structKeyExists(responseData,"TxRefNum") ) {
			response.setProviderTransactionID( responseData.TxRefNum.xmlText );
		}
		
		// TODO: Add more codes here
		var avsCodeMAP = {
			M2 = "V",
			M4 = "O",
			X  = "D"
		};
		
		if( structKeyExists(responseData,"AVSRespCode") && structKeyExists(avsCodeMAP,responseData.AVSRespCode) ) {
			response.setAVSCode( avsCodeMAP[responseData.AVSRespCode] );
		}
		
		if( structKeyExists(responseData,"CVV2RespCode") && responseData.CVV2RespCode == 'M') {
			response.setSecurityCodeMatch(true);
		} else {
			response.setSecurityCodeMatch(false);
		}
		
		return response;
	}
	
	public string function getMerchantIDByCurrencyCode( required string currencyCode ) {
		if(len(setting('merchantIDByCurrencyCodeList'))) {
			var arr = listToArray(setting('merchantIDByCurrencyCodeList'));
			for(var pair in arr) {
				if(listLen(pair, "=") == 2 && listFirst(pair, "=") == arguments.currencyCode) {
					return listLast(pair, "=");
				}
			}
			
		}
		
		return setting('merchantID');
	}
}