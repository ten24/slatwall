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
	variables.creditCardTypeMap = {};

	public any function init(){
		// Set Defaults
		variables.transactionCodes = {
			authorize="AU",
			generateToken="TN"
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
		
		variables.creditCardTypeMap = {
			"American Express"="AX",
			"Visa"="VI",
			"Diners Club"="DD",
			"Discover"="DI",
			"JCB"="JC",
			"MasterCard"="MC"
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
		
		body &= arguments.requestBean.getOrderShortReferenceID();
		
		//pad with spaces
		body &= repeatString(chr(32), 22 - len(arguments.requestBean.getOrderShortReferenceID()));
		
		//MOP - need to grab from credit card type
		body &= variables.creditCardTypeMap[arguments.requestBean.getCreditCardType()];
		
		var usingTokenFlag = true;

		var accountNumber = arguments.requestBean.getProviderToken();
		if(isNull(accountNumber) || !len(accountNumber)){
			accountNumber = arguments.requestBean.getCreditCardNumber();
			usingTokenFlag = false;
			
		}
		
		body &= accountNumber;
		
		//account/credit card number/token field has length 19. Let's pad the rest.
		
		logHibachi(19 - len(accountNumber),true);
		
		body &= repeatString(chr(32), 19 - len(accountNumber));
		
		body &= arguments.requestBean.getExpirationMonth() & right(arguments.requestBean.getExpirationYear(),2);
		
		//TD number also goes in the body. Because the fact that it goes in the header is not enough.
		body &= variables.formattedTDNumber;
		
		//transaction amount, padded with zeroes
		body &= numberFormat(arguments.requestBean.getTransactionAmount() * 100,"000000000009");
		
		//now we need to append the currency code

		body &= variables.currencyCodeMap[arguments.requestBean.getTransactionCurrencyCode()];
		
		/*next char is "transaction type". Hard-coding 7 that designates a transaction 
			between anaccountholder and a merchant consummated via the Internet where the
			transaction includes the use of transaction encryption such as SSL, but authentication
			was not performed. The accountholder payment data was protected with a form of Internet security,
			such as SSL, but authentication was not performed
		*/
		
		body &= 7;
		
		// for the next value we'll need to figure out whether we are passing a plain credit card number or token.
		// 203 for plain value, 204 for token
		
		body &= usingTokenFlag ? 204 : 203;
		
		// payment indicator - leaving it blank
		
		body &= repeatString(chr(32),1);
		
		// transaction code
		
		body &= variables.transactionCodes[arguments.requestBean.getTransactionType()];
		
		// char 84 is reserved and should be left blank
		
		body &= repeatString(chr(32),1);
		
		//let's add the bill to Address now
		
		//AB is the bill to address format constant
		
		body &= "AB";
		
		if(!isNull(arguments.requestBean.getAccountPrimaryPhoneNumber())) {
			
			// next char indicates what type of phone number it is. Let's just hard code W (work) for simplicity
			body &= "W";
			body &= arguments.requestBean.getAccountPrimaryPhoneNumber();
			
			//telephone numbers have length 14, so we justify that
			body &= repeatString(chr(32), 14 - len(arguments.requestBean.getAccountPrimaryPhoneNumber()));
			
		} else { // 15 white spaces, 1 for the type, 14 for the number
			body &= repeatString(chr(32), 15);
		}
		
		if(!isNull(arguments.requestBean.getAccountFirstName()) && !isNull(arguments.requestBean.getAccountLastName)){
			
			var fullName = arguments.requestBean.getAccountFirstName() & ' ' & arguments.requestBean.getAccountLastName();
			body &= fullName;
			
			//justify for 30 chars
			body &= repeatString(chr(32), 30 - len(fullName));
			
		} else {
			body &= repeatString(chr(32), 30);
		}
		
		//justifyValue method prints the value and correctly prints out the number of spaces necessary
		
		//let's do that for all the address stuff
		
		body &= justifyValue(arguments.requestBean.getBillingStreetAddress(),30);

		body &= justifyValue(arguments.requestBean.getBillingStreet2Address(),28);

		body &= justifyValue(arguments.requestBean.getBillingCountryCode(),2);

		body &= justifyValue(arguments.requestBean.getBillingCity(),20);

		body &= justifyValue(arguments.requestBean.getBillingStateCode(),2);

		body &= justifyValue(arguments.requestBean.getBillingPostalCode(),10);
		
		//Carriage return
		body &= repeatString(chr(13),1);
		
		//all caps
		
		body = uCase(body);
		
		logHibachi(body,true);
		
		httpRequest.addParam(type="body",value=body);
		
		var headers = getHeaders();
		
		for(var key in headers){
			httpRequest.addParam(type="header",name="#key#",value="#trim(headers[key])#");
		}
		
		var response = httpRequest.send().getPrefix();

		return response;
	}
	
	private any function justifyValue(value, len){
		if(!isNull(arguments.value)){
			var lengthToJustify = arguments.len - len(arguments.value);
			//if value is longer than size of field
			if(lengthToJustify < 0){
				//truncate value by that much
				value = right(value,lengthToJustify * - 1);
				lengthToJustify = 0;
			}
			return value & repeatString(chr(32),lengthToJustify);
		} else {
			return repeatString(chr(32), arguments.len);
		}
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
		var response = new Slatwall.integrationServices.chase.model.ChaseTransactionResponseBean();
		var data = rawResponse.fileContent;
		logHibachi(data,true);
		//response reason code
		response.setStatusCode(mid(data,27,3));
		if( left(response.getStatusCode(),1) != "1" ){
			response.addError(response.getStatusCode(),data);
			return response;
		}
		
		//authorization/verification code
		response.setAuthorizationCode(mid(data,36,6));
		response.setAvsCode(mid(data,42,2));
		
		var amount = LSParseNumber(mid(data,73,12)) / 100;
		
		//not sure if we need these
		var paymentAdviceCode = mid(data,70,2);
		var cavvResponseCode = mid(data,72,1);
		
		if(
			(requestBean.getTransactionType() == "authorize" || requestBean.getTransactionType() == "generateToken") 
			&& mid(data,85,2) == "TI"
		){
			response.setProviderToken(trim(mid(data,87,20)));
		}
		
		response.setAmountByTransactionType(requestBean.getTransactionType(),amount);
		
		response.setData(data);
		
		return response;
	}
	
	public any function testIntegration() {
		var requestBean = new Slatwall.model.transient.payment.CreditCardTransactionRequestBean();
		var orderPayment = new Slatwall.model.entity.orderPayment();
		var testAccount = getHibachiScope().getAccount();
		requestBean.setTransactionType('generateToken');
		requestBean.setTransactionCurrencyCode("USD");
		requestBean.setOrderShortReferenceID('112345');
		requestBean.setCreditCardNumber('4112344112344113');
		requestBean.setCreditCardType('Visa');
		requestBean.setSecurityCode('123');
		requestBean.setExpirationMonth('01');
		requestBean.setExpirationYear(year(now())+1);
		requestBean.setTransactionAmount(42.10);
		requestBean.setAccountFirstName(testAccount.getFirstName());
		requestBean.setAccountLastName(testAccount.getLastName());
		requestBean.setBillingCity("Worcester");
		requestBean.setBillingStateCode("MA");
		requestBean.setBillingCountryCode("US");
		requestBean.setBillingStreetAddress("20 Franklin Street");
		requestBean.setBillingPostalCode("01604");
		var integration = new Slatwall.integrationServices.chase.Payment();
		var response = integration.processCreditCard(requestBean);
		orderPayment.setChaseProviderToken(response.getProviderToken());
		return response;
	}
}