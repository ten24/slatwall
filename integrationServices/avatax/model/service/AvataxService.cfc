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
component extends='Slatwall.model.service.HibachiService' persistent='false' accessors='true' output='false' {

	// ===================== START: Logical Methods ===========================

	/**
	 * Helper function to return the instance of this integration
	*/
	private any function getIntegration(){

		if( !structKeyExists(variables,'integration') ){
			variables['integration'] = getService('integrationService').getIntegrationByIntegrationPackage( 'avalara' );
		}

		return variables.integration;
	}

	/**
	 * @hint helper function to return the instance of this integration/Data.cfc
	*/
	private any function getAddressIntegrationCFC(){
		
		if( !structKeyExists(variables,'addressIntegrationCFC') ){
			variables['addressIntegrationCFC'] = getService('integrationService').getAddressIntegrationCFC( getIntegration() );
		}

		return variables.dataIntegrationCFC;
	}

	/**
	 *  helper function to return setting value by setting-name( both integrationSetting or SlatwallSetting), 
	*/
	public any function setting(required string settingName, array filterEntities=[], formatValue=false) {
		return getAddressIntegrationCFC().setting(argumentCollection = arguments);
	}


	
	/**
	 * Helper function to populate HTTP headers on the request
	 * @request http-request, 
	 * @requestBody, not required, if passed, it will set the Content-length Header
	*/ 
	public void function setHttpHeaders(required any request, struct requestDataStruct) {
		var base64Auth = toBase64("#setting('accountNo')#:#setting('accessKey')#");
		
		httpRequest.addParam(type="header", name="Content-type", value="application/json");
		httpRequest.addParam(type="header", name="Authorization", value="Basic #base64Auth#");
		httpRequest.addParam(type="header", name="X-Avalara-Client", value="Slatwall;#getApplicationValue('version')#REST;v1;#cgi.servername#");
		
		if( StructKeyExist(arguments, 'requestDataStruct') ) {
			httpRequest.addParam(type="header", name="Content-length", value="#len(serializeJSON(arguments.requestDataStruct))#");
		}
	}


	/**
	 * Function to validate the address with Avalara
	 * API Endpoint: "POST /addresses/resolve"
	 * 
	 * { 
	 *   "success" : boolean, 
	 *   "message": "error message string if any", 
	 *   "suggestedAddress": {...if any....} 
	 * }
	 * 
	*/
	public struct function verifyAddress(required struct address) {

		var response = this.makeApiRequest('POST /addresses/resolve', this.convertSwAddressToAvalaraAddress(arguments.address) );
		//TODO: validate/format response
		return response;
	}

	/**
	 * helper function to create a struct of properties+values from @entity/Address.cfc.
	 *
	 * @address, Struct of @entity/Address.cfc properties+values
	 *
	*/ 
	public any function convertSwAddressToAvalaraAddress(required struct address){
		param name="arguments.address.streetAddress" default="";	
		param name="arguments.address.street2Address" default="";
		param name="arguments.address.city" default="";
		param name="arguments.address.stateCode" default="";
		param name="arguments.address.postalCode" default="";	
		param name="arguments.address.countryCode" default="";		
		param name="arguments.address.addressID" default="";
		
		var avalaraAddress = {};


		//TODO: Avalara has max-length cap on the address lines, consider that
		avalaraAddress['line1'] = arguments.address['streetAddress'];
		avalaraAddress['line2'] = arguments.address['street2Address'];
		avalaraAddress['city'] = arguments.address['city'];
		avalaraAddress['state'] = arguments.address['stateCode'];
		avalaraAddress['zip'] = arguments.address['postalCode'];
		avalaraAddress['country'] = arguments.address['countryCode'];

		return avalaraAddress;		
	}

	
	/**
	 * Function to call avalara-APIs
	 * @endpoint space separated method and api-endpoint, 'GET /abc/pqr', "POST /abc/pqr"
	 * @payload request body
	 * @return An struct of, either successful-response or formated-error-response 
	*/ 
	private struct function makeApiRequest(required string endpoint, struct payload={}) {
		
		//TODO: api url?
		var requestURL = setting('liveModeFlag') ? setting('liveURL') : setting('testURL');
		requestURL &= ListLast(arguments.endpoint, " ");

		var httpRequest = new http();
		httpRequest.setMethod(ListFirst(arguments.endpoint, " "));
		httpRequest.setUrl( requestURL );

    	setHttpHeaders(httpRequest);
    	
    	httpRequest.addParam(type='body', value="#SerializeJson(arguments.payload)#");
		httpRequest.setTimeout(setting(httpTimeOut));

		var rawResponse = httpRequest.send().getPrefix();
		
		var response = {};
		if( IsJson(rawRequest.fileContent) ) {
			response = DeSerializeJson(rawRequest.fileContent); 
		} 
		else {

			response = { 
						"error": { 
								"code": "Api Error",
								"message": "response is not valid JSON", 
								"response": rawRequest.fileContent 
							} 
					};
		} 
		
		/** 
		 * If there's an error, add request data: in the response
		 * NOTE: for a typical error/success responses see at the bottom of this file
		*/
		if( StructKeyExist(response, 'error') ) {
			response['requestAttributes'] = httpRequest.getAttributes() ;
			response['requestParams'] = httpRequest.getParams();
		}
		
		debugLog(response);

		return response;
	}

	private function debugLog( required any input, string type = "Information", boolean abort = false ) {
		cftrace ( 
			text = ( isSimpleValue( arguments.input ) ? arguments.input : "Log" ), 
			var = arguments.input, 
			category = "Avalara", 
			type = arguments.type,
		);
		if(arguments.abort){
			writeDump(var="#arguments.input#", abort=arguments.abort);
		}
	}

	
	// =====================  END: Logical Methods ============================

	// ===================== START: DAO Passthrough ===========================

	// ===================== START: DAO Passthrough ===========================

	// ===================== START: Process Methods ===========================

	// =====================  END: Process Methods ============================

	// ====================== START: Save Overrides ===========================

	// ======================  END: Save Overrides ============================

	// ==================== START: Smart List Overrides =======================

	// ====================  END: Smart List Overrides ========================

	// ====================== START: Get Overrides ============================

	// ======================  END: Get Overrides =============================

}



/** 
 * 
 * 
 * 
 * 			
* typical successful response: 
{
	"address": {
		"textCase": "Upper",
		"line1": "2000 Main Street",
		"city": "Irvine",
		"region": "CA",
		"country": "US"
	},
	"validatedAddresses": [
		{
		"addressType": "StreetOrResidentialAddress",
		"line1": "2000 MAIN ST",
		"line2": "",
		"line3": "",
		"city": "IRVINE",
		"region": "CA",
		"country": "US",
		"postalCode": "92614-7202",
		"latitude": 33.684716,
		"longitude": -117.851489
		}
	],
	"coordinates": {
		"latitude": 33.684716,
		"longitude": -117.851489
	},
	"resolutionQuality": "Intersection",
	"taxAuthorities": [
		{
		"avalaraId": "267",
		"jurisdictionName": "ORANGE",
		"jurisdictionType": "County",
		"signatureCode": "AHXU"
		},
		{
		"avalaraId": "5000531",
		"jurisdictionName": "CALIFORNIA",
		"jurisdictionType": "State",
		"signatureCode": "AGAM"
		},
		{
		"avalaraId": "2001061425",
		"jurisdictionName": "ORANGE COUNTY DISTRICT TAX SP",
		"jurisdictionType": "Special",
		"signatureCode": "EMAZ"
		},
		{
		"avalaraId": "2001061784",
		"jurisdictionName": "ORANGE CO LOCAL TAX SL",
		"jurisdictionType": "Special",
		"signatureCode": "EMTN"
		},
		{
		"avalaraId": "2001067270",
		"jurisdictionName": "IRVINE",
		"jurisdictionType": "City",
		"signatureCode": "MHWX"
		},
		{
		"avalaraId": "2001077261",
		"jurisdictionName": "IRVINE HOTEL IMPROVEMENT DISTRICT",
		"jurisdictionType": "Special",
		"signatureCode": "NQKV"
		}
	]
}

***************************

* typical error response: 
{
	"error": {
		"code": "InvalidAddress",
		"message": "The address value was incomplete.",
		"target": "IncorrectData",
		"details": [
		{
			"code": "InvalidAddress",
			"number": 309,
			"message": "The address value was incomplete.",
			"description": "The address value NULL was incomplete. You must provide either a valid postal code, line1 + city + region, or line1 + postal code.",
			"faultCode": "Client",
			"helpLink": "http://developer.avalara.com/avatax/errors/InvalidAddress",
			"severity": "Error"
		}
		]
	}
}
*/