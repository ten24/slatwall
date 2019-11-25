component extends="Slatwall.model.service.HibachiService" accessors="true" output="false"{
	// G2 Crowd Source ID '360048' 
	// Get Started Form '363428'
			
    public any function sendRequestToMailChimp(required string apiRoute, required method ,any jsonData=''){
       
		var list_id = getHibachiScope().setting('integrationmailchimpmailChimpListID');
		var dataCenter = getHibachiScope().setting('integrationmailchimpmailChimpDataCenter');
		var apiPath = 'https://#dataCenter#.api.mailchimp.com/3.0/lists/#list_id#/#arguments.apiRoute#';

        var httpRequest = new http();
        httpRequest.setMethod(arguments.method);
		httpRequest.setUrl(apiPath);
		httpRequest.addParam(type="header", name="Content-type", value="application/json");
		httpRequest.addParam(type="header", name="Authorization", value="apikey #getHibachiScope().setting('integrationmailchimpmailChimpAPIKey')#");
		
		if (len(arguments.jsonData)){
			httpRequest.addParam(type="body", value=jsonData);
		}
		
		var chimpResponseData = httpRequest.send().getPrefix();
			
		chimpResponseData = deserializeJson(chimpResponseData.FileContent);
		
		return chimpResponseData;
    }

    public any function postLeadToProsperWork(required any data){
        
        var httpRequest = new http();
        httpRequest.setMethod("POST");
		httpRequest.setUrl('https://api.prosperworks.com/developer_api/v1/leads');
		httpRequest.addParam(type="header", name="Content-type", value="application/json");
		httpRequest.addParam(type="header", name="X-PW-AccessToken", value="#getHibachiScope().setting('mailchimpapiprosperworksAPIKey')#");
		httpRequest.addParam(type="header", name="X-PW-Application", value="developer_api");
		httpRequest.addParam(type="header", name="X-PW-UserEmail", value="#getHibachiScope().setting('mailchimpapiprosperworksAPIEmail')#");
		
		httpRequest.addParam(type="body", value=data);
		
		//Ignoring the actual response for now, may use results to display messages in the future
		var prospResponseData = httpRequest.send().getPrefix();
		
		return prospResponseData;
        
    }
    
    public any function getLeadsFromProsperWork(required any data){
    	var httpRequest = new http();
        httpRequest.setMethod("POST");
		httpRequest.setUrl('https://api.prosperworks.com/developer_api/v1/leads/search');
		httpRequest.addParam(type="header", name="Content-type", value="application/json");
		httpRequest.addParam(type="header", name="X-PW-AccessToken", value="#getHibachiScope().setting('mailchimpapiprosperworksAPIKey')#");
		httpRequest.addParam(type="header", name="X-PW-Application", value="developer_api");
		httpRequest.addParam(type="header", name="X-PW-UserEmail", value="#getHibachiScope().setting('mailchimpapiprosperworksAPIEmail')#");
		
		httpRequest.addParam(type="body", value=data);
		
		//Ignoring the actual response for now, may use results to display messages in the future
		var prospResponseData = httpRequest.send().getPrefix();
		
		return prospResponseData;
    }
    
    public any function updateProsperWorkLeads(required any data, required string leadID){
    	var httpRequest = new http();
        httpRequest.setMethod("PUT");
		httpRequest.setUrl('https://api.prosperworks.com/developer_api/v1/leads/#arguments.leadID#');
		httpRequest.addParam(type="header", name="Content-type", value="application/json");
		httpRequest.addParam(type="header", name="X-PW-AccessToken", value="#getHibachiScope().setting('mailchimpapiprosperworksAPIKey')#");
		httpRequest.addParam(type="header", name="X-PW-Application", value="developer_api");
		httpRequest.addParam(type="header", name="X-PW-UserEmail", value="#getHibachiScope().setting('mailchimpapiprosperworksAPIEmail')#");
		
		httpRequest.addParam(type="body", value=data);
		
		//Ignoring the actual response for now, may use results to display messages in the future
		var prospResponseData = httpRequest.send().getPrefix();
		
		return prospResponseData;
    }
    
    public any function getMailChimpInterestDataStruct(){
    	
    	var interestDataStruct = {};
    	
    	/** Returns an array of structs that contain all the groups in mailchip
    	*	Will use the returned data to get the invidual intrests and add them to our struct
    	**/
   
	var interestGroups = sendRequestToMailChimp(apiRoute='interest-categories', method='GET');

	if( structKeyExists(interestGroups, 'categories') ){
		for(var interestGroup in interestGroups.categories){
			var groupInterests =  sendRequestToMailChimp(apiRoute='interest-categories/#interestGroup.id#/interests?count=25', method='GET');
			for (var interest in groupInterests.interests){
				StructInsert(interestDataStruct, interest.id, false);
			}
		}
	}
	
	return interestDataStruct;    	
    	
    }
    
}
