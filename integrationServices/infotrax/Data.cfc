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


component accessors='true' output='false' displayname='InfoTrax' extends='Slatwall.org.Hibachi.HibachiObject' {

	property name='infoTraxService' type='any' persistent='false';
	property name='sessionToken' type='string' persistent='false';

	public any function init() {
		
		setInfoTraxService( getService('InfoTraxService') );
		
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
	
	private struct function postRequest(required string service, required struct requestData, string jsessionid){
		
		var requestURL = setting('liveModeFlag') ? setting('liveURL') : setting('testURL');
		
		if( structKeyExists(arguments, 'jsessionid') ){
			requestURL &= ';jsessionid=' & arguments.jsessionid;
		}
		
		requestURL &= '?format=JSON';
		requestURL &= '&apikey=' & setting('apikey');
		requestURL &= '&service=' & arguments.service;
		
		var httpRequest = new http();
		httpRequest.setMethod('POST');
		httpRequest.setUrl( requestURL );
		
		for(var key in requestData){
			httpRequest.addParam(type='formfield',name='#key#',value='#requestData[key]#');
		}
		
		var rawRequest = httpRequest.send().getPrefix();
		var response = deserializeJson(rawRequest.fileContent);
		
		if( structKeyExists(response, 'errors') && arrayLen(response.errors) ){
			var errorMessages = '';
			for(var error in response.errors){
				errorMessages = listAppend(errorMessages, error['detail']);
			}
			if(len(errorMessages)){
				throw(errorMessages);
			}
		}
		
		
		if( structKeyExists(response, 'ERRORCODE') ){
			throw(response['MESSAGE'] & ' - ' & response['DETAIL']);
		}
		
		return response;
	}
	
	public string function getSessionToken(){
		
		if( !structKeyExists(variables, 'sessionToken') ){
			
			var response = postRequest('Session.login',{
				'dtsuserid' = setting('username'),
				'password' = setting('password'),
			});
		
			variables.sessionToken = response['SESSION'];
		}
		
		return variables.sessionToken;
	}
	
	public void function pushDistributor(required any account, struct data ={}){
	
		var iceResponse = {};
		
		switch ( arguments.data.event ) {
			
			case 'afterAccountEnrollSuccess':
				iceResponse = createDistributor(arguments.data.DTSArguments);
				break;
			
			case 'afterAccountSaveSuccess':
				iceResponse = updateDistributor(arguments.data.DTSArguments);
				break;
				
			default:
				return;
		}
		
		if(structKeyExists(iceResponse, 'returnserialnumber')){
			arguments.account.setLastSyncedDateTime(now());
			arguments.account.setGovernmentIdentificationNumberEncrypted(javaCast('null', ''));
		}
		
	}
	
	public void function pushTransaction(required any order, struct data ={}){
		
		var iceResponse = {};
		
		switch ( arguments.data.event ) {
			
			case 'afterOrderProcess_placeorderSuccess':
				iceResponse = createTransaction(arguments.data.DTSArguments);
				break;
				
			case 'afterOrderSaveSuccess':
				iceResponse = createTransaction(arguments.data.DTSArguments);
				break;
				
			case 'afterOrderProcess_cancelOrderSuccess':
				iceResponse = deleteTransaction(arguments.data.DTSArguments);
				break
			default:
				return;
		}
	}
	
	
	public struct function createDistributor(required struct DTSArguments){
		return postRequest('ICEDistributor.create', arguments.DTSArguments, getSessionToken());
	}
	
	public struct function updateDistributor(required struct DTSArguments){
		structDelete(arguments.DTSArguments, 'referralId')
		return postRequest('ICEDistributor.update', arguments.DTSArguments, getSessionToken());
	}
	
	public struct function getDistributor(required struct DTSArguments){
		return postRequest('ICEDistributor.get', arguments.DTSArguments, getSessionToken());
	}
	
	public struct function createTransaction(required struct DTSArguments){
		return postRequest('ICETransaction.create', arguments.DTSArguments, getSessionToken());
	}
	
	public struct function updateTransaction(required struct DTSArguments){
		return postRequest('ICETransaction.update', arguments.DTSArguments, getSessionToken());
	}
	
	public struct function deleteTransaction(required struct DTSArguments){
		return postRequest('ICETransaction.delete', arguments.DTSArguments, getSessionToken());
	}

}