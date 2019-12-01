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
	 * @hint helper function to return the instance of this integration
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
	private any function getDataIntegrationCFC(){

		if( !structKeyExists(variables,'dataIntegrationCFC') ){
			variables['dataIntegrationCFC'] = getService('integrationService').getDataIntegrationCFC( getIntegration() );
		}

		return variables.dataIntegrationCFC;
	}

	/**
	 *  helper function to return setting value by setting-name( both integrationSetting or SlatwallSetting), 
	*/
	public any function setting(required string settingName, array filterEntities=[], formatValue=false) {
		return getDataIntegrationCFC().setting(argumentCollection = arguments);
	}



	/**
	 * Function to validate the address with Avalara
	 * API Endpoint: "POST /addresses/resolve"
	 * 
	 */
	public struct function validateAddress(required struct address) {

		return this.makeApiRequest('POST /addresses/resolve', this.convertSwAddressToAvalaraAddress(arguments.address) );
	}

	/**
	 * helper function to create a struct of properties+values from @entity/Address.cfc.
	 *
	 * @address, Struct of @entity/Address.cfc properties+values
	 * 
	 * @returns, Struct of properties+values required by Avalara resolve-address API.
	*/ 
	public any function convertSwAddressToAvalaraAddress(required struct address){
		
		var avalaraAddress = {};

		avalaraAddress['line2'] = arguments.address['streetAddress'];
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
		
		var requestURL = setting('liveModeFlag') ? setting('liveURL') : setting('testURL');
		requestURL &= ListLast(arguments.endpoint, " ");

		var httpRequest = new http();
		httpRequest.setMethod(ListFirst(arguments.endpoint, " "));
		httpRequest.setUrl( requestURL );

    	httpRequest.addParam( type='header', name='Content-Type', value='application/json');
    	httpRequest.addParam( type='header', name='Accept', value='application/json');
		// Authentication headers
    	httpRequest.addParam( type='header', name='Authorization', value= "Basic "&setting('authToken') );
    	
    	
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
