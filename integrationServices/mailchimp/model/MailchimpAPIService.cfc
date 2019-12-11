component extends="Slatwall.model.service.HibachiService" accessors="true" output="false" {
	
	public struct function addMemberToListByAccount( required struct account ) {
		
		var currentSiteCode = siteService.getSlatwallSiteCodeByCurrentSite();

		// If slatwall site is default, change to us
		currentSiteCode = ( 'DEFAULT' == currentSiteCode ) ? 'US' : currentSiteCode;
		
		return this.addMemberToList( 
			arguments.account.getPrimaryEmailAddress().getEmailAddress(),
			{
				FNAME: arguments.account.getFirstName(),
				LNAME: arguments.account.getLastName(),
				PHONE: arguments.account.getPhoneNumber(),
				ATYPE: arguments.account.getAccountType(),
				LPREF: arguments.account.getLanguagePreference(),
				SITE: currentSiteCode,
			}
		);
	}

	/**
	 * Add user to mailchimp using the stored api key, data center, and list ID.
	 * 
	 * @param {struct} account - Account entity.
	 * @return {struct} Response form Mailchimps's API.
	 */
	public struct function addMemberToList( required string emailAddress, required struct mergeFields ) {
		
		var mailChimpData = {
			'email_address': arguments.emailAddress,
			'status': 'subscribed',
			'merge_fields': arguments.mergeFields,
		};
       
		var list_id = getHibachiScope().setting('integrationmailchimpmailChimpListID');
		var dataCenter = getHibachiScope().setting('integrationmailchimpmailChimpDataCenter');
		var apiPath = 'https://#dataCenter#.api.mailchimp.com/3.0/lists/#list_id#/members';

		var response = this.sendRequestToMailChimp( 
			apiPath = apiPath, 
			method = 'POST', 
			jsonData = serializeJson( mailChimpData ) 
		);
		
		return response;
	}
			
    public any function sendRequestToMailChimp( required string apiPath, required method ,any jsonData='' ) {

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
    
}
