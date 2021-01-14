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
			variables['integration'] = getService('integrationService').getIntegrationByIntegrationPackage( 'avatax' );
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

		return variables.addressIntegrationCFC;
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
	public struct function getHttpHeaders() {
		var base64Auth = toBase64("#setting('accountNo')#:#setting('accessKey')#");

		return {
			'Content-type' : 'application/json',
			'Authorization' : 'Basic #base64Auth#',
			'X-Avalara-Client' : 'Slatwall;#getApplicationValue("version")#REST;v1;#cgi.servername#'
		};
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
		
		var formattedResponse = {};
		formattedResponse['success'] = false;
		formattedResponse['message'] = '';
					
		if( structKeyExists(response, 'validatedAddresses') &&
			IsArray(response.validatedAddresses) &&
			ArrayLen(response.validatedAddresses)
		){
			var suggestion = response.validatedAddresses[1];
			
			var formattedSuggestion = {};
			formattedSuggestion['addressID'] = arguments.address['addressID'];
			
			formattedSuggestion['streetAddress'] = suggestion["line1"];
			formattedSuggestion['street2Address'] = suggestion["line2"];
			formattedSuggestion['city'] = suggestion["city"];
			formattedSuggestion['stateCode'] = suggestion["region"];
			formattedSuggestion['postalCode'] = suggestion["postalCode"];
			formattedSuggestion['countryCode'] = suggestion["country"];
			
			
			formattedResponse['success'] =  compareAddressWithSuggestion(arguments.address, formattedSuggestion);
			formattedResponse['suggestedAddress'] = formattedSuggestion;
			
			if(StructKeyExists(response, 'resolutionQuality')) {
				formattedResponse['message'] = "Resolution quality: #response.resolutionQuality#";
			}
		
		} else if( structKeyExists(response, 'error') ) {
			formattedResponse['message'] = response['error']['code'] &" "& response['error']['message'];
		} else if( structKeyExists(response, 'messages') && isArray(response['messages']) && !arrayIsEmpty(response['messages'])){
			formattedResponse['message'] = '';

			for(var message in response['messages']){

				if(len(formattedResponse['message'])){
					formattedResponse['message'] &= ', ';
				} 

				if(structKeyExists(message, 'summary')){

					if(message['summary'] == 'Country not supported.'){
						formattedResponse['success'] = true; 	
						formattedResponse['suggestedAddress'] = arguments.address;
					} 

					formattedResponse['message'] &= message['summary'];
				}

				if(structKeyExists(message, 'details')){
					formattedResponse['message'] &= ' - ' & message['details']
				}

				if(formattedResponse['success']){
					break; 
				} 
			}  
	
		} else {
			formattedResponse['message'] = "Something went wrong";
		}
		
		if(setting('debugModeFlag')){
			debugLog(formattedResponse);
		}
		
		return formattedResponse;
	}
	
	/**
	 * helper function to compare 2 address-structs
	*/ 
	public boolean function compareAddressWithSuggestion(required struct address, required struct suggestion){ 
		// Comparing most relevant points
		return compareNoCase( arguments.address["streetAddress"], arguments.suggestion["streetAddress"] ) == 0
			&& compareNoCase( arguments.address["city"], arguments.suggestion["city"] ) == 0
			&& compareNoCase( arguments.address["stateCode"], arguments.suggestion["stateCode"] ) == 0
			&& compareNoCase( left(arguments.address["postalCode"],5), left(arguments.suggestion["postalCode"],5) ) == 0;
	}

	/**
	 * helper function to create a struct of properties+values from @entity/Address.cfc.
	 * @address, Struct of @entity/Address.cfc properties+values
	*/ 
	public struct function convertSwAddressToAvalaraAddress(required struct address){
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
		avalaraAddress['region'] = arguments.address['stateCode'];
		avalaraAddress['postalCode'] = arguments.address['postalCode'];
		avalaraAddress['country'] = arguments.address['countryCode'];
		return avalaraAddress;		
	}

	
	/**
	 * Function to call avalara-APIs
	 * @endpoint space separated method and api-endpoint, 'GET /abc/pqr', "POST /abc/pqr"
	 * @payload request body
	 * @return An struct of, either successful-response or formated-error-response 
	*/ 
	public struct function makeApiRequest(required string endpoint, struct payload={}) {
		
		/**
		 * Currently this function is being used for address API's
		 * Hardcoding The URL as Tax integration is still on V1
		 * 
		*/
		var requestURL = 'https://rest.avatax.com/api/v2';
		if(setting('testingFlag')) { 
			requestURL = 'https://sandbox-rest.avatax.com/api/v2';
		}
	
		requestURL &= ListLast(arguments.endpoint, " ");

		var httpRequest = new http();
		httpRequest.setMethod( ListFirst(arguments.endpoint, " ") );
		httpRequest.setUrl( requestURL );

    	setHttpHeaders(httpRequest);
    	
    	httpRequest.addParam(type='body', value="#SerializeJson(arguments.payload)#");
		httpRequest.setTimeout(5);

		var rawResponse = httpRequest.send().getPrefix();
		
		var response = {};
		if( IsJson(rawResponse.fileContent) ) {
			response = DeSerializeJson(rawResponse.fileContent); 
		} 
		else {

			response = { 
						"error": { 
								"code": "ApiError",
								"message": "response is not valid JSON", 
								"response": rawResponse.fileContent 
							} 
					};
		} 
		
		/** 
		 * If there's an error, add request data: in the response
		 * NOTE: for a typical error/success responses see at the bottom of this file
		*/
		if( structKeyExists(response, 'error') && setting('debugModeFlag') ) {
			response['requestAttributes'] = httpRequest.getAttributes() ;
			response['requestParams'] = httpRequest.getParams();
			debugLog(response);
		}

		return response;
	}

	private void function debugLog( required any input, string type = "Information") {
		if(!IsSimpleValue(arguments.input)) {
			arguments.input = SerializeJson(arguments.input);
		}
		cftrace ( text = arguments.input,  type = arguments.type);

		writeLog(type=arguments.type, file="debug", text=arguments.input);
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
