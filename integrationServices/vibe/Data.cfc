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


component accessors='true' output='false' displayname='Vibe' extends='Slatwall.org.Hibachi.HibachiObject' {

	property name='vibeService' type='any' persistent='false';

	public any function init() {
		
		setVibeService( getService('vibeService') );
		
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
	 * Function to call create-vibe-user-API
	 * @requestData struct, required, post-request-payload
	 * @return struct, of successful-response or formated-error-response 
	*/ 
	private struct function upsertVibeUser(required struct requestData, boolean create=false) {
		
		var requestURL = setting('liveModeFlag') ? setting('liveURL') : setting('testURL');
		
		if(arguments.create){
			requestURL &= '/api/v1/etl/createUser';
		}else{
			requestURL &= '/api/v1/etl/updateUser';
		}
		
		var headers = {
			'Content-Type' : 'application/json',
			'auth-token': setting('authToken'),
			'user-name': setting('username')
		}
		
    	arguments.requestData = { "user" : arguments.requestData } ; // payload signature --> { "user": {...payload...}};

		var rawRequest = getService('hibachiUtilityService').hibachiHttp(requestURL, 'POST', serializeJSON(arguments.requestData), headers);
		
		var response = {};
		if( IsJson(rawRequest.fileContent) ) {
			response = DeSerializeJson(rawRequest.fileContent); 
		} 
		else {
			response = { "status": "error",  "message": "Error: response is not valid JSON"  };
		} 
		
		/** Format error:
		 * typical error response: { "status": "error", "message": "Required fields missing: email"};
		 * typical successful response: {"status":"success","message":null,"id":426855,"rows":1,"request_id":null}
		*/
		
		if( !structKeyExists(response,'status') || response.status != 'success') {
			response['content'] = rawRequest.fileContent;
		}
		
		return response;
	}

	
	/**
	 * Function to be create an user account on Vibe, and update Slatwlll-Account on successful response
	 * @entity, @model/Account.cfc, user-account we're processing
	 * @data, struct, containing post request payload
	 * 
	 * Note: in current setup this function will be called from VibeService::push(), which will be called from EntityQueue
	 * 
	*/ 
	public void function pushData(required any entity, struct data ={}, boolean create = false) {
		//push to remote endpoint
		var response = upsertVibeUser(arguments.data.payload, arguments.create);
	
		if( !structKeyExists(response,'status') || response.status != 'success' || 
			!StructKeyExists(response ,'id') || 
			!len( trim(response.id) ) 
		) {
			
			if( !arguments.create && structKeyExists(response, 'message') && FindNoCase('could not be found', response.message) ){
				return pushData(arguments.entity, arguments.data, true);
			}
			//the call was not successful
			throw("Error in Vibe::PushData() #SerializeJson(response)#"); //this will comeup in EntityQueue
		} 
		
	}

}
