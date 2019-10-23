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
	
	private struct function postRequest(required struct requestData){
		
		var requestURL = setting('liveModeFlag') ? setting('liveURL') : setting('testURL');
		requestURL &= 'createUser';
		var httpRequest = new http();
		httpRequest.setMethod('POST');
		httpRequest.setUrl( requestURL );

    	httpRequest.addParam(type='header', name='auth-token', value= setting('apikey') );
    	httpRequest.addParam(type='header', name='Content-Type', value='application/x-www-form-urlencoded');
    	
		for(var key in requestData) {
			if( !isNull(requestData[key]) ) {
				httpRequest.addParam(type='formfield',name='#key#',value='#requestData[key]#');
			}
		}
		
		var rawRequest = httpRequest.send().getPrefix();
		
		try {
			var response = DeserializeJson(rawRequest.fileContent);
			if(!IsSimpleValue(response)) {
				if(structKeyExists(response, 'success')) {
					return response; //{"status":"success","message":null,"id":426855,"rows":1,"request_id":null}
				} else if( structKeyExists(response, 'message') ) {
					throw("Message: #response.messages#");
				}
			} else {
				throw("Not Json");	
			} 	
		} catch (var e) {
			throw("Error: #e.message#, #DeserializeJson(httpRequest.getAttributes())#, Params: #DeserializeJson(httpRequest.getParams())#,  Response: #rawRequest.fileContent#");
		}
		throw("Unknown Error Attr: #DeserializeJson(httpRequest.getAttributes())#, Params: #DeserializeJson(httpRequest.getParams())#,  Response: #rawRequest.fileContent#");
	}

	
	public void function pushData(required any entity, struct data ={}) {
		
		try{
			//push to remote endpoint
			var vibeResponse = postRequest(arguments.data.payload);
			dump("Response : #SerializeJson(vibeResponse)#");
			//update the account
			arguments.entity.setVibeUserID(vibeResponse.id);
			
		} catch (var e) {
			dump("Error : #e.message#");
			writelog(file='vibe', text="#e.message#");
		}	

	}

}