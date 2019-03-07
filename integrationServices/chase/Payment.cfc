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

component accessors="true" output="false" displayname="Chase" implements="Slatwall.integrationServices.PaymentInterface" extends="Slatwall.integrationServices.BasePayment" {
	
	//Global variables
	variables.timeout = 45;
	variables.transactionCodes = {};
	variables.currencyCodeMap = {};

	public any function init(){
		// Set Defaults
		variables.transactionCodes = {
			authorize="AU"
		};
		
		variables.currencyCodeMap = {
			"USD"=840,
			"HKD"=344,
			"AUD"=036,
			"GBP"=826,
			"CAD"=124,
			"DKK"=208,
			"EUR"=978,
			"NZD"=554,
			"NOK"=578,
			"ZAR"=710,
			"SEK"=752,
			"CHF"=756
		};
		
		variables.formattedTDNumber = numberFormat(setting('transactionDivisionNumber'),"0000000009");

		return this;
	}
	
	public string function getPaymentMethodTypes() {
		return "creditCard";
	}
	
	public any function processCreditCard(required any requestBean){
		var rawResponse = postRequest(requestBean);
		return getResponseBean(rawResponse, requestBean);
	}
	
	private any function postRequest(required any requestBean){
		
		var httpRequest = new http();
		httpRequest.setMethod("POST");
		if( setting('liveModeFlag') ) {
			httpRequest.setUrl( setting("primaryLiveURL") );
		} else {
			httpRequest.setUrl( setting("primaryTestURL") );
		}
		httpRequest.setTimeout(variables.timeout);
		httpRequest.setResolveurl(false);
		
		var body = "P74V"; //constant
		
		//add order ID
	
		//order identifier field has 22 char
		
		body = body & arguments.requestBean.getOrderShortReferenceID();

		//pad with spaces
		body = body & repeatString(chr(32), 22 - len(arguments.requestBean.getOrderShortReferenceID()));
		
		//MOP - hard-coding visa for now
		
		body = body & "VI" & arguments.requestBean.getCreditCardNumber();
		
		//account/credit card number field has length 19. Let's pad the rest.
		
		body = body & repeatString(chr(32), 19 - len(arguments.requestBean.getCreditCardNumber()));
		
		body = body & arguments.requestBean.getExpirationMonth() & right(arguments.requestBean.getExpirationYear(),2);
		
		//TD number also goes in the body. Because the fact that it goes in the header is not enough.
		body = body & variables.formattedTDNumber;
		
		//transaction amount, padded with zeroes
		body = body & numberFormat(arguments.requestBean.getTransactionAmount() * 100,"000000000009");
		
		//now we need to append the currency code

		body = body & variables.currencyCodeMap[arguments.requestBean.getTransactionCurrencyCode()];
		
		/*next char is "transaction type". Hard-coding 7 that designates a transaction 
			between anaccountholder and a merchant consummated via the Internet where the
			transaction includes the use of transaction encryption such as SSL, but authentication
			was not performed. The accountholder payment data was protected with a form of Internet security,
			such as SSL, but authentication was not performed
		*/
		
		body = body & 7;
		
		// for the next value we'll need to figure out whether we are passing a plain credit card number or token.
		// 203 for plain value, 204 for token
		
		body = body & 203;
		
		// payment indicator - leaving it blank
		
		body = body & repeatString(chr(32),1);
		
		// transaction code
		
		body = body & variables.transactionCodes[arguments.requestBean.getTransactionType()];
		
		// char 84 is reserved and should be left blank
		
		body = body & repeatString(chr(32),1);
		
		httpRequest.addParam(type="body",value=body);
		
		var headers = getHeaders();
		
		for(var key in headers){
			httpRequest.addParam(type="header",name="#key#",value="#trim(headers[key])#");
		}
		
		var response = httpRequest.send().getPrefix();
		return response;
	}
	
	private any function getHeaders(){
		var headers = {};
		headers["Auth-TID"] = setting('authTID');
		headers["Auth-User"] = setting('netConnectUserID');
		headers["Auth-Password"] = setting('netConnectPassword');
		headers["Auth-MID"] = variables.formattedTDNumber;
		headers["Stateless-Transaction"] = true;
		headers["Content-type"] = 'SALEM05210/SLM';
		return headers;
	}
	
	private any function getResponseBean(required struct rawResponse, required any requestBean){
		var response = new Slatwall.model.transient.payment.CreditCardTransactionResponseBean();
		response.setStatusCode(mid(rawResponse.fileContent,27,3));
		response.setAuthorizationCode(mid(rawResponse.fileContent,36,6));
		var amount = LSParseNumber(mid(rawResponse.fileContent,73,12)) / 100;
	}
	
	public any function testIntegration() {
		var requestBean = new Slatwall.model.transient.payment.CreditCardTransactionRequestBean();
		var testAccount = getHibachiScope().getAccount();
		
		requestBean.setTransactionType('authorize');
		requestBean.setTransactionCurrencyCode("USD");
		requestBean.setOrderShortReferenceID('112345');
		requestBean.setCreditCardNumber('4112344112344113');
		requestBean.setSecurityCode('123');
		requestBean.setExpirationMonth('01');
		requestBean.setExpirationYear(year(now())+1);
		requestBean.setTransactionAmount('1');
		requestBean.setAccountFirstName(testAccount.getFirstName());
		requestBean.setAccountLastName(testAccount.getLastName());
		writeDump(var=requestBean,top=1);
		var response = processCreditCard(requestBean); 
		return response;
	}

}
