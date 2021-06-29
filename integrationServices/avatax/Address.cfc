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

component accessors='true' output='false' displayname='Avalara-Address' extends="Slatwall.integrationServices.BaseAddress" implements="Slatwall.integrationServices.AddressInterface" {

	property name='avataxService' type='any' persistent='false';

	public any function init() {
		setAvataxService( getService('avataxService') );
		return this;
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
		
		
		var rawResponse = request(
			url = requestURL,
			method = ListFirst(arguments.endpoint, " "),
			data = arguments.payload,
			dataType='json',
			headers = this.getAvataxService().getHttpHeaders(),
			timeout = 5
		);
		
		var response = {};
		if( isStruct(rawResponse.fileContent) ) {
			response = rawResponse.fileContent;
			
		} else {
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
	
	/**
	 * Function to test if we're able to communicate with the Avalara APIs
	 * API Endpoint: "GET /utilities/ping"
	 * 
	 * Example Response:
	 * { "version": "19.11.0", "authenticated": false, "authenticationType": "None" }
	 * 
	*/
	public struct function testIntegration() {
		return this.getAvataxService().makeApiRequest('GET /utilities/ping');
	}

	/**
	 * Function to validate the address with Avalara
	 * @returns Struct of Success/failure response
	*/
	public struct function verifyAddress(required struct address) {
		var response = this.makeApiRequest('POST /addresses/resolve', this.getAvataxService().convertSwAddressToAvalaraAddress(arguments.address) );
		
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
			
			
			formattedResponse['success'] =  this.getAvataxService().compareAddressWithSuggestion(arguments.address, formattedSuggestion);
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
			this.getAvataxService().debugLog(formattedResponse);
		}
		
		return formattedResponse;
	}
	
}
