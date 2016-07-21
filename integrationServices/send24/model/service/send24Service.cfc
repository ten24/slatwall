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
component extends="Slatwall.model.service.HibachiService" accessors="true" output="false" {

	property any integration;

	public any function init(){
		variables.integration = getService("integrationService").getIntegrationByIntegrationPackage("send24");
	}

	private string function getSend24Auth(){
		return 'Basic '&ToBase64(integration.setting('basicAuthUser') & ":" & integration.setting('basicAuthPassword'));
	}

	private string function buildSend24URL(required string endpoint){

		var url ='http://' & integration.setting('companyName');

		// remove starting slash if it exists to prevent double slashes
		endpoint = REReplace(endpoint, "^\/", "");
		if(integration.setting('testingFlag')){
			url = url & '.send24dev.com/index.cfm/api/' & endpoint & '?apiKey=' & integration.setting('apikeyDev') &  '&throw=1';
		}else{
			url = url & '.send24web.com/index.cfm/api/'& endpoint & '?apiKey=' & integration.setting('apikeyProd');
		}
		return url;
	}

	public any function send24Request(required string method, required string endpoint, any data){
		var httpService = new http();
		httpService.setMethod(arguments.method);
		httpService.setCharset("utf-8");
		httpService.setUrl(buildSend24URL(arguments.endpoint));
		if(structKeyExists(arguments,'data')){
			httpService.addParam(type="header",name="content-type",value="application/json");
			httpService.addParam(type="body",value=serializeJSON(data));
		}
		if(len(integration.setting('basicAuthUser')) && len(integration.setting('basicAuthPassword'))){
			httpService.addParam(type="header",name="Authorization",value=getSend24Auth());
		}
		return httpService.send().GetPrefix();
	}


	public any function createEmail(required struct emailConfig){

		var result = send24Request('post','email', emailConfig);
		if(!result.statuscode contains "201") {
			throw("Bad status code creating Email");
		}
		return result.Filecontent;
	}

	public any function updateEmail(required string emailID, required struct emailConfig){

		var result = send24Request('put','email/'&emailID, emailConfig);
		if(!result.statuscode contains "200") {
			throw("Bad status code updating Email");
		}
		return result.Filecontent;
	}

	public any function createMailingList(required string name, required string description){

		var result =  send24Request('post','mailinglist', {
			'name' = arguments.name,
			'description' = arguments.description
		});
		if(!result.statuscode contains "201") {
			throw("Bad status code creating mailinglist");
		}
		return result.Filecontent;
	}

	public boolean function addSubscribers(required string mailingListID, required any subscribers, required string columnNames, required string administratorID){
		var body ={};
		body['subscribersList'] = arguments.subscribers;
		body['columnNames'] = arguments.columnNames;
		body['mailingListIDs'] = arguments.mailingListID;
		body['importAction'] = "subscribe";
		body['administratorID'] = arguments.administratorID;
		body['async'] = false;

		var result = send24Request('post','subscriberList', body);
		if(!result.statuscode contains "200") {
			throw("Bad status code importing subscriberList");
		}
		return true;
	}

	public any function sendEmail(required string emailID, required string mailingListID){

		var result = send24Request('post','broadcast', {
			'emailID' = arguments.emailID,
			'mailingListID' = arguments.mailingListID
		});

		if(!result.statuscode contains "201") {
			throw("Bad status code sending Email");
		}
		return result.Filecontent;
	}

	public any function sendTestEmail(required string emailID, required string testEmailAddress){

		var result = send24Request('post','broadcast', {
			'emailID' = arguments.emailID,
			'testBroadcastFlag' = true,
			'testBroadcastEmailAddresses' = arguments.testEmailAddress
		});

		if(!result.statuscode contains "201") {
			throw(result.Filecontent);
		}
		return result.Filecontent;
	}

	public any function getLatestBroadcasts(any fromDatetime){
		try{
			arguments.fromDatetime = dateTimeFormat(DateAdd('d', -1, arguments.fromDatetime), 'yyyyMMddHHnnss');
		}catch(any e){
			throw(e);
		}

		var result = send24Request('get','broadcasts/#fromDatetime#');

		if(!result.statuscode contains "200"){
			throw("Bad status code getting Broadcasts");
		}

		if(isJSON(result.Filecontent)){
			return deserializeJSON(result.Filecontent);
		}else{
			return [];
		}
	}

	public any function getTempates(){
		var result = send24Request('get','emailTemplate');

		if(!result.statuscode contains "200"){
			throw("Bad status code getting Templates");
		}

		if(isJSON(result.Filecontent)){
			return deserializeJSON(result.Filecontent);
		}else{
			return [];
		}
	}
}