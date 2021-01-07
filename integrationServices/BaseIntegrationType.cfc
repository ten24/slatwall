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
component extends="Slatwall.org.Hibachi.HibachiObject" {
	
	public any function init() {
		return this;
	}
	
	/**
	 * Helper function to return the value for a Setting by 'settingName'.
	 * 
	 * @settingName name of the setting
 	 */
	public any function setting(required string settingName, array filterEntities=[], formatValue=false) {
		if(structKeyExists(getIntegration().getSettings(), arguments.settingName)) {
			return getService('settingService').getSettingValue(settingName='integration#getPackageName()##arguments.settingName#', object=this, filterEntities=arguments.filterEntities, formatValue=arguments.formatValue);
		}
		return getService('settingService').getSettingValue(settingName=arguments.settingName, object=this, filterEntities=arguments.filterEntities, formatValue=arguments.formatValue);
	}
	
	/**
	 * Helper function to return the associated Integration-entity, for this integration.
	 * 
	 */
	public any function getIntegration() {
		return getService('integrationService').getIntegrationByIntegrationPackage(getPackageName());
	}

	/**
	 * Helper function to return the The Package-name, for this integration.
	 */
	public string function getPackageName() {
		return lcase(listGetAt(getClassFullname(), listLen(getClassFullname(), '.') - 1, '.'));
	}
	
	
	
	/**
	 * Helper function to remove any sensitive data from the API Request before saving to the DB
	 */
	 public string function getBlacklistedKeys(){
		return 'apikey|password|creditcard';
	}
	
	public string function sanitizeForLogs(required string data){
		var protectedValues = getBlacklistedKeys();
		
		//Handle JSON
		var sanitizedValue = reReplaceNoCase(arguments.data, '"(#protectedValues#)":"([^"]+)"', '"\1":"[REDACTED]"', 'ALL');
		
		//Handle QueryStrings/FormPosts
		sanitizedValue = reReplaceNoCase(sanitizedValue, '(#protectedValues#)=([^&]+)', '\1=[REDACTED]', 'ALL');

		return sanitizedValue;
	}

	public struct function request(string url, string method='GET', struct data={}, string dataType = 'html', struct headers={}, numeric timeout = 3, string charset = 'UTF-8'){
		var logRequest = getHibachiScope().setting('globalIntegrationRequestLog');
		
		var logArguments = {
			'source' : getPackageName(),
			'apiLogType' : 'request',
			'requestIdentifier' : createHibachiUUID(),
			'targetUrl' : sanitizeForLogs(arguments.url),
			'method' : arguments.method,
			'data' : sanitizeForLogs(SerializeJSON(arguments.data)),
			'header' : sanitizeForLogs(SerializeJSON(arguments.headers))
		}
		
		var httpService = new http(
			method  = arguments.method,
			url     = arguments.url,
			timeout = arguments.timeout,
			charset = arguments.charset
		);
	
		// Set headers
		for(var headerName in arguments.headers){
			httpService.addParam(type="header", name=headerName, value=arguments.headers[headerName]);
		}
		
		// Set Payload
		if(arguments.dataType == 'json'){
			httpService.addParam(type="body", value=SerializeJSON(arguments.data));
		}else{
			var paramType = arguments.method == 'GET' ? 'URL' : 'formField';
			for(var dataName in arguments.data){
				httpService.addParam(type=paramType, name=dataName, value=arguments.data[dataName]);
			}
		}
		
		if(logRequest){
			getDAO('HibachiDataDAO').createApiLog(argumentCollection=logArguments);
		}
		var requestStartTime = getTickCount();
		
		var response = httpService.send().getPrefix();
		
		var reponseTime = getTickCount() - requestStartTime;
		
		if(logRequest){
			logArguments['responseTime'] = reponseTime;
			logArguments['statusCode'] = response['status_code'];
			logArguments['response'] = sanitizeForLogs(response['filecontent']);
			logArguments['apiLogType'] = 'response';
			getDAO('HibachiDataDAO').createApiLog(argumentCollection=logArguments);
			
			var maxDays = val(getHibachiScope().setting('globalIntegrationRequestLogExpirationDays')) * -1;
			getDAO('HibachiDataDAO').deleteOldApiLogs(olderDate = dateAdd('d', maxDays, now()));
		}
		
		var responseData = response['filecontent'];
		
		if(structKeyExists(response, 'mimetype') && response['mimetype'] == 'application/json'){
			responseData = DeserializeJSON(response['filecontent']);
		}
		
		return { 'response' : responseData, 'status_code' : response['status_code'] };
	}

}