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
    Integration for SagePay VSP Direct using Protocol 2.23 (non 3D-Secured at this time).
    Tested on Adobe ColdFusion 9.01.
*/
component accessors="true" output="false" displayname="SagePay" implements="Slatwall.integrationServices.PaymentInterface" extends="Slatwall.integrationServices.BasePayment" {

	//Global variables
	variables.vspProtocol="2.23";
	variables.txType="PAYMENT";
	variables.timeout="45";

	public any function init() {
		return this;
	}
	
	public string function getPaymentMethodTypes() {
		return "creditCard";
	}
	
	public any function processCreditCard(required any requestBean) {
		var rawResponse="";
		var requestData=getRequestData(requestBean);
		rawResponse=postRequest(requestData);
		return getResponseBean(rawResponse,requestData,requestBean);
	}
	
	private struct function getRequestData(required any requestBean) {
		var requestData={};
		requestData["txType"]=variables.txType;
		requestData["vendor"]=setting('vendorID');
		requestData["vendorTxCode"]=arguments.requestBean.getTransactionID();
		requestData["VPSProtocol"]=variables.vspProtocol;
		requestData["referrerID"]="";
		requestData["currency"]=setting('currency');
		requestData["giftAidPayment"]="0";
		requestData["description"]="Payment From " & #arguments.requestBean.getNameOnCreditCard()#;
		requestData["amount"]=arguments.requestBean.getTransactionAmount();
	
		// Card Details
		requestData["cardHolder"]=arguments.requestBean.getNameOnCreditCard();
		requestData["cardNumber"]=arguments.requestBean.getCreditCardNumber();
		requestData["expiryDate"]=arguments.requestBean.getExpirationMonth() & arguments.requestBean.getExpirationYear();
		requestData["CV2"]=arguments.requestBean.getSecurityCode();
		requestData["cardType"]=UCase(arguments.requestBean.getCreditCardType());
		requestData["customerName"]=arguments.requestBean.getAccountFirstName();
		requestData["customerEmail"]=arguments.requestBean.getAccountPrimaryEmailAddress();
		requestData["clientIPAddress"]=CGI.REMOTE_ADDR;
	
		//Billing & Delivery
		requestData["billingFirstnames"]=arguments.requestBean.getAccountFirstName();
		requestData["billingSurname"]=arguments.requestBean.getAccountLastName();
		requestData["billingAddress1"]=arguments.requestBean.getBillingStreetAddress();
		requestData["billingPostCode"]=arguments.requestBean.getBillingPostalCode();
		requestData["billingCity"]=arguments.requestBean.getBillingCity();
		requestData["billingCountry"]=arguments.requestBean.getBillingCountryCode();
		requestData["deliveryFirstnames"]=arguments.requestBean.getAccountFirstName();
		requestData["deliverySurname"]=arguments.requestBean.getAccountLastName();
		requestData["deliveryAddress1"]=arguments.requestBean.getBillingStreetAddress();
		requestData["deliveryAddress2"]=arguments.requestBean.getBillingStreet2Address();
		requestData["deliveryCity"]=arguments.requestBean.getBillingCity();
		requestData["deliveryCountry"]=arguments.requestBean.getBillingCountryCode();
		requestData["deliveryPostCode"]=arguments.requestBean.getBillingPostalCode();
	
		return requestData;
	}
	
	private any function postRequest(required any requestData) {
		var httpRequest=new http();
		httpRequest.setMethod("POST");
		httpRequest.setUrl(getGatewayURL().PurchaseURL);
		httpRequest.setTimeout(variables.timeout);
		httpRequest.setResolveurl(false);
		//httpRequest.setdelimiter(chr(13));
		for(var key in requestData) {
			httpRequest.addParam(type="formfield",name="#key#",value="#requestData[key]#");
		}
		return httpRequest.send().getPrefix();
	}
	
	private struct function getGatewayURL() {
	
		var gatewaySettings=StructNew();
		if(setting('simulatorMode')) {
			StructInsert(gatewaySettings,"Verify","false");
			StructInsert(gatewaySettings,"PurchaseURL","https://test.sagepay.com/Simulator/VSPDirectGateway.asp");
			StructInsert(gatewaySettings,"RefundURL","https://test.sagepay.com/Simulator/VSPServerGateway.asp?Service=VendorRefundTx");
			StructInsert(gatewaySettings,"ReleaseURL","https://test.sagepay.com/Simulator/VSPServerGateway.asp?Service=VendorReleaseTx");
			StructInsert(gatewaySettings,"RepeatURL","https://test.sagepay.com/Simulator/VSPServerGateway.asp?Service=VendorRepeatTx");
			StructInsert(gatewaySettings,"callbackURL","https://test.sagepay.com/Simulator/VSPDirectCallback.asp");
		} else if(setting('testMode')) {
			StructInsert(gatewaySettings,"Verify","false");
			StructInsert(gatewaySettings,"PurchaseURL","https://test.sagepay.com/gateway/service/vspdirect-register.vsp");
			StructInsert(gatewaySettings,"RefundURL","https://test.sagepay.com/gateway/service/refund.vsp");
			StructInsert(gatewaySettings,"ReleaseURL","https://test.sagepay.com/gateway/service/release.vsp");
			StructInsert(gatewaySettings,"RepeatURL","https://test.sagepay.com/gateway/service/repeat.vsp");
			StructInsert(gatewaySettings,"callbackURL","https://test.sagepay.com/gateway/service/direct3dcallback.vsp");
		} else {
			StructInsert(gatewaySettings,"Verify","false");
			StructInsert(gatewaySettings,"PurchaseURL","https://live.sagepay.com/gateway/service/vspdirect-register.vsp");
			StructInsert(gatewaySettings,"RefundURL","https://live.sagepay.com/gateway/service/refund.vsp");
			StructInsert(gatewaySettings,"ReleaseURL","https://live.sagepay.com/gateway/service/release.vsp");
			StructInsert(gatewaySettings,"RepeatURL","https://live.sagepay.com/gateway/service/repeat.vsp");
			StructInsert(gatewaySettings,"callbackURL","https://live.sagepay.com/gateway/service/direct3dcallback.vsp");
		}
		return gatewaySettings;
	}
	
	private any function getResponseBean(required struct rawResponse,required any requestData,required any requestBean) {
	
		var response=new Slatwall.model.transient.payment.CreditCardTransactionResponseBean();
		var responseDataArray=listToArray(rawResponse.fileContent,"#chr(13)#");
		var responseData={};
		for(var item in responseDataArray) {
			line=Trim(item);
			StructInsert(responseData,Trim(ListFirst(item,"=")),Trim(Mid(item,Find("=",item) + 1,len(item))));
		}
		if(!structkeyexists(responseData,"statusDetail")) {
			responseData.statusDetail=responseData.status & ": No payment has been taken.";
		}
	
		// Populate the data with the raw response & request
		var data={responseData=arguments.rawResponse,requestData=arguments.requestData};
		
		response.setData(data);
	
		// Add message for what happened
		response.addMessage(messageName=responseData.status,message=responseData.statusDetail);
		// Set the status Code
		response.setStatusCode(responseData.status);
	
		switch(responseData.status) {
			case "OK": {
			
				if(requestBean.getTransactionType() == "authorize") {
					response.setAmountAuthorized(requestBean.getTransactionAmount());
				} else if(requestBean.getTransactionType() == "authorizeAndCharge") {
					response.setAmountAuthorized(requestBean.getTransactionAmount());
					response.setAmountCharged(requestBean.getTransactionAmount());
				} else if(requestBean.getTransactionType() == "chargePreAuthorization") {
					response.setAmountCharged(requestBean.getTransactionAmount());
				} else if(requestBean.getTransactionType() == "credit") {
					response.setAmountCredited(requestBean.getTransactionAmount());
				}
				response.setTransactionID(arguments.requestBean.getTransactionID());
				response.setAuthorizationCode(responseData.VPSTxId);
				break;
			}
			default: {
				// Transaction did not go through
				response.addError(responseData.status, responseData.statusDetail);
				break;
			}
		}
		
		return response;
	}
	
}
