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
	property name='sessionTokenCreated' type='timestamp' persistent='false' default='#now()#';

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
		
		// if(structKeyExists(arguments, 'jsessionid')){
		// 	writedump(requestData); 
		// 	writedump(response); abort;
		// }
		
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
			// Handle logout
			if(response['DETAIL'] == 'Not Authorized to run this service'){
				structDelete(variables, 'sessionToken');
			}
			throw(response['MESSAGE'] & ' - ' & response['DETAIL']);
		}
		
		return response;
	}
	
	public string function getSessionToken(){
		// Generate token again after 1 hour
		if( !structKeyExists(variables, 'sessionToken') || DateDiff('h', variables.sessionTokenCreated, now()) >= 1 ){
			var response = postRequest('Session.login',{
				'dtsuserid' = setting('username'),
				'password' = setting('password'),
			});
		
			variables.sessionToken = response['SESSION'];
			variables.sessionTokenCreated = now();
		}
		
		return variables.sessionToken;
	}
	
	public void function pushData(required any entity, struct data ={}){
		
		
		
		var iceResponse = {};
		var relatedToAccount = false;
		
		switch ( arguments.data.event ) {
			
			case 'afterAccountAddressSaveSuccess':
			case 'afterAccountPhoneNumberSaveSuccess':
			case 'afterAccountGovernmentIdentificationCreateSuccess':
			case 'afterAccountGovernmentIdentificationSaveSuccess':
				relatedToAccount = true;
				if(isNull(arguments.entity.getAccount().getLastSyncedDateTime())){
					iceResponse = createDistributor(arguments.data.DTSArguments);
				}else{
					iceResponse = updateDistributor(arguments.data.DTSArguments);
				}
				break;
			case 'afterAccountEnrollSuccess':
			case 'afterAccountSaveSuccess':
				if(isNull(arguments.entity.getLastSyncedDateTime())){
					iceResponse = createDistributor(arguments.data.DTSArguments);
				}else{
					iceResponse = updateDistributor(arguments.data.DTSArguments);
				}
				break;
				
			case 'afterOrderProcess_placeorderSuccess':
			case 'afterOrderProcess_updateOrderAmountsSuccess':
			case 'afterOrderSaveSuccess':
				if(arguments.entity.getOrderStatusType().getSystemCode() == 'ostCanceled'){
					if(len(arguments.entity.getIceRecordNumber())){
						iceResponse = deleteTransaction(arguments.data.DTSArguments);
					}
				}else if(!len(arguments.entity.getIceRecordNumber()) || isNull(arguments.entity.getLastSyncedDateTime())){
					iceResponse = createTransaction(arguments.data.DTSArguments);
				}else{
					iceResponse = updateTransaction(arguments.data.DTSArguments);
				}
				break;
				
			case 'afterOrderProcess_cancelOrderSuccess':
				if(len(arguments.entity.getIceRecordNumber())){
					iceResponse = deleteTransaction(arguments.data.DTSArguments);
				}
				break;
			case 'afterOrderTemplateProcess_activateSuccess':
			case 'afterOrderTemplateSaveSuccess':
				if(isNull(arguments.entity.getLastSyncedDateTime())){
					iceResponse = createAutoship(arguments.data.DTSArguments);
				}else{
					iceResponse = updateAutoship(arguments.data.DTSArguments);
				}
				break;
				
			case 'afterOrderTemplateProcess_cancelSuccess':
				iceResponse = deleteAutoship(arguments.data.DTSArguments);
				break;
				
			default:
				return;
		}
		
		
		
		if(structKeyExists(iceResponse, 'returnserialnumber')){
			
			logHibachi("InfoTrax - returnserialnumber: #iceResponse.returnserialnumber#", true);
			
			if(relatedToAccount){
				if(isNull(arguments.entity.getAccount().getLastSyncedDateTime())){
					getService('HibachiEventService').announceEvent("afterInfotraxAccountCreateSuccess",{ entity : arguments.entity.getAccount() });
				}
				arguments.entity.getAccount().setLastSyncedDateTime(now());
			}else{
				if(arguments.entity.getClassName() == 'Account' && isNull(arguments.entity.getLastSyncedDateTime())){
					getService('HibachiEventService').announceEvent("afterInfotraxAccountCreateSuccess", { entity : arguments.entity });
				}
				arguments.entity.setLastSyncedDateTime(now());
			}
			
		}
		
		if(structKeyExists(iceResponse, 'recordNumber')){
			arguments.entity.setIceRecordNumber(iceResponse['recordNumber']);
		}
		
	}
	
	public struct function createDistributor(required struct DTSArguments){
		return postRequest('ICEDistributor.create', arguments.DTSArguments, getSessionToken());
	}
	
	public struct function updateDistributor(required struct DTSArguments){
		structDelete(arguments.DTSArguments, 'referralId');
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
	
	public struct function createAutoship(required struct DTSArguments){
		return postRequest('ICEAutoship.create', arguments.DTSArguments, getSessionToken());
	}
	
	public struct function updateAutoship(required struct DTSArguments){
		return postRequest('ICEAutoship.update', arguments.DTSArguments, getSessionToken());
	}
	
	public struct function deleteAutoship(required struct DTSArguments){
		return postRequest('ICEAutoship.delete', arguments.DTSArguments, getSessionToken());
	}
	
	public any function retrySyncPendingOrders(required any order, any processObject, required struct data={}){
		if(structKeyExists(arguments.data, 'collectionData')){
			this.retryBatch('order', arguments.data.collectionData)
		} 
		return arguments.order;
	}
	
	public any function retrySyncPendingAccounts(required any account, any processObject, required struct data={}){
		if(structKeyExists(arguments.data, 'collectionData')){
			this.retryBatch('account', arguments.data.collectionData)
		} 
		return arguments.account;
	}
	
	public void function retryBatch(required string baseObject, required array data){
		for(var item in arguments.data){
			if ( !getService('infoTraxService').isEntityQualified(arguments.baseObject, item['#baseObject#ID'], 'after#baseObject#SaveSuccess') ) {
				continue;
			}
			getService('hibachiService').invokeMethod('get#baseObject#', { 1 : item['#baseObject#ID'] });
		}
	}

}