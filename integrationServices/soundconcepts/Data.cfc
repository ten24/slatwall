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


component accessors='true' output='false' displayname='SoundConcepts' extends='Slatwall.org.Hibachi.HibachiObject' {
	
	public any function init() {
		return this;
	}
	
	// @hint helper function to return a Setting
	public any function setting(required string settingName, array filterEntities=[], formatValue=false) {
		if(structKeyExists(getIntegration().getSettings(), arguments.settingName)) {
			return getService('settingService').getSettingValue(settingName='integration#getPackageName()##arguments.settingName#', object=this, filterEntities=arguments.filterEntities, formatValue=arguments.formatValue);
		}
		return getService('settingService').getSettingValue(settingName=arguments.settingName, object=this, filterEntities=arguments.filterEntities, formatValue=arguments.formatValue);
	}
	
	// @hint helper function to return the integration entity that this belongs to
	public any function getIntegration() {
		return getService('integrationService').getIntegrationByIntegrationPackage(getPackageName());
	}

	// @hint helper function to return the packagename of this integration
	public any function getPackageName() {
		return lcase(listGetAt(getClassFullname(), listLen(getClassFullname(), '.') - 1, '.'));
	}
	
	/**
	 * Function to make create-user API-call
	 * @requestData struct, required, post-request-payload
	 * 
	 * @returns struct, of successful-response or formated-error-response 
	*/ 
	private struct function createSoundConceptsUser(required struct requestData) {
		
		var requestURL = setting('liveModeFlag') ? setting('liveURL') : setting('testURL');
		requestURL &= '/remote/users/add.json';
		var httpRequest = new http();
		httpRequest.setMethod('POST');
		httpRequest.setUrl( requestURL );

		//Authentaction details required by SoundConcepts
		arguments.requestData['master_username'] = setting('masterUsername');
		arguments.requestData['master_password'] = setting('masterPassword');
		
    	httpRequest.addParam(type='header', name='Content-Type', value='application/json');
    	httpRequest.addParam(type='body', value="#SerializeJson(arguments.requestData)#");

		var rawRequest = httpRequest.send().getPrefix();
		
		var response = {};
		if( IsJson(rawRequest.fileContent) ) {
			response = DeSerializeJson(rawRequest.fileContent); 
		} 
		else {
			response = {'error': { 'message' : "Error: response s not JSON" } };
		}
		
		/** Format error:
		 * typical error response: { "error" : { "message": "Required fields missing: email"}, "server": {"ip_address": "10.45.48.7","name": "Testing"} }
		 * typical successful response: { "success": { "username": "xyg" }, "server": {} }
		*/
		if( !StructKeyExists(response, 'success') ) {
			response['requestAttributes'] = httpRequest.getAttributes() ;
			response['requestParams'] = httpRequest.getParams();
			response['content'] = rawRequest.fileContent;
		}
		
		return response;
	}
	
	/**
	 * Function to be create user on SoundConceptsApp, and update Slatwlll-Account on successful response
	 * @entity, @modal/Account.cfc, user-account we're processing
	 * @data, struct, cotaining post request payload
	 * 
	 * Note: 
	 * 1. currently we're not updating slatwall-account.
	 * 2. in current setup this function will be called from SoundConceptsService::push(), which will be called from EntityQueue
	 * 
	 */ 
	public void function pushData(required any entity, struct data ={}) {
	
		logHibachi("SoundConcepts - Start pushData", true);
		//push to remote endpoint
		var response = createSoundConceptsUser(arguments.data.payload);

		if( !StructKeyExists( response, 'success') || 
			!StructKeyExists( response.success, 'username') ||  !len( trim( response.success.username ) ) 
		) {
			throw("Error in SoundConcepts::PushData() #SerializeJson(response)#");
		} 
		
		logHibachi("SoundConcepts - End pushData", true);
	}

}