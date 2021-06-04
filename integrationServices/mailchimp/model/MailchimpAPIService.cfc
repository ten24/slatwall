component extends="Slatwall.model.service.HibachiService" accessors="true" output="false" {
	
	/**
	 * Gets a boolean if the user is subscribed to mailchimp.
	 * 
	 * @param {string} emailAddress - Email address associated with the mailchimp member.
	 * @return {boolean} Is subscribed to mailchimp.
	 */
	public boolean function getSubscribedFlagByEmailAddress( required string emailAddress ) {
		
		var member = this.getMemberByEmailAddress( arguments.emailAddress );
		
		if ( !isStruct( member ) ) {
			return false;
		}
		
		return ( 'subscribed' == member.status );
	}
	
	/**
	 * Get member info by email address
	 *
	 * @param {string} emailAddress - Email address associated with the mailchimp member.
	 * @return {any} A struct of member data from mailchimp or false if the member doesn't exist.
	 */
	public any function getMemberByEmailAddress( required string emailAddress ) {
		
		var response = this.searchMembers( arguments.emailAddress );

		// If the response format isn't what's expected
		if ( !structKeyExists( response, 'exact_matches' ) || !structKeyExists( response.exact_matches, 'members' ) ) {
			return false;
		}
		
		// If there are no members that match our query
		if ( !len( response.exact_matches.members ) ) {
			return false;
		}
		
		// We only care about the first result (there should only be one)
		var member = response.exact_matches.members[1];

		return member;
	}
	
	/**
	 * Update subscription by account.
	 * 
	 * If the member doesn't exist and subscribeFlag is true, we will add them to the list.
	 * If the member does exist, we will update the status based on the subscribe flag
	 * 
	 * @param {struct} account - Account entity.
	 * @param {boolean} subscribeFlag - If the user should be subscribed or unsubscribed.
	 * @return void
	 */
	public void function updateSubscriptionByAccount( required struct account, required boolean subscribeFlag ) {
		
		var member = this.getMemberByEmailAddress( arguments.account.getPrimaryEmailAddress().getEmailAddress() );
		
		if ( !isStruct( member ) ) {
			// If the subscribe flag is set to true, add them to our list.
			if ( arguments.subscribeFlag ) {
				this.addMemberToListByAccount( arguments.account );
			}
			
		} else {
			// Update the subscription status.
			
			var list_id = getHibachiScope().setting('integrationmailchimpmailChimpListID');
			var dataCenter = getHibachiScope().setting('integrationmailchimpmailChimpDataCenter');
			var apiPath = 'https://#dataCenter#.api.mailchimp.com/3.0/lists/#list_id#/members/#member.ID#';
			
			var status = ( arguments.subscribeFlag ) ? 'subscribed' : 'unsubscribed';
			var mailchimpData = {
				'status': status
			};
		
			var response = this.sendRequestToMailchimp( 
				apiPath = apiPath, 
				method = 'PATCH', 
				jsonData = serializeJson( mailchimpData )
			);
		}
	}
	
	/**
	 * Add member to list by account entity.
	 * 
	 * @param {struct} account - Account entity.
	 * @return {struct} Response from Mailchimps API.
	 */
	public struct function addMemberToListByAccount( required struct account ) {
		
		var siteCode = getService('SiteService').getSlatwallSiteCodeBySite(arguments.account.getAccountCreatedSite());

		// If slatwall site is default, change to us
		siteCode = ( 'DEFAULT' == siteCode ) ? 'US' : siteCode;
		
		var response = this.addMemberToList( 
			arguments.account.getPrimaryEmailAddress().getEmailAddress(),
			{
				FNAME: arguments.account.getFirstName(),
				LNAME: arguments.account.getLastName(),
				PHONE: arguments.account.getPhoneNumber(),
				ATYPE: arguments.account.getAccountType(),
				LPREF: arguments.account.getLanguagePreference(),
				SITE: siteCode,
			}
		);
		
		return response;
	}

	/**
	 * Add user to mailchimp using the stored api key, data center, and list ID.
	 * 
	 * @param {struct} account - Account entity.
	 * @return {struct} Response form Mailchimps's API.
	 */
	public struct function addMemberToList( required string emailAddress, required struct mergeFields ) {
		
		var mailchimpData = {
			'email_address': arguments.emailAddress,
			'status': 'subscribed',
			'merge_fields': arguments.mergeFields,
		};
       
		var list_id = getHibachiScope().setting('integrationmailchimpmailChimpListID');
		var dataCenter = getHibachiScope().setting('integrationmailchimpmailChimpDataCenter');
		var apiPath = 'https://#dataCenter#.api.mailchimp.com/3.0/lists/#list_id#/members';

		var response = this.sendRequestToMailchimp( 
			apiPath = apiPath, 
			method = 'POST', 
			jsonData = serializeJson( mailchimpData )
		);
		
		return response;
	}
	
	/**
	 * Search members regardless of the list.
	 *
	 * @param {string} query - Query string for mailchimp. Usually email address
	 * @return {struct} Mailchimp response from /search-members.
	 */
	public struct function searchMembers( required string query ) {
       
		var dataCenter = getHibachiScope().setting('integrationmailchimpmailChimpDataCenter');
		var apiPath = 'https://#dataCenter#.api.mailchimp.com/3.0/search-members';
		apiPath &= '?query=#query#'

		var response = this.sendRequestToMailchimp( 
			apiPath = apiPath, 
			method = 'GET'
		);
		
		return response;
	}
	
	/**
	 * Send request to mailchimp.
	 * 
	 * @param {string} apiPath - URI for our api call.
	 * @param {string} method - eg. POST, GET, PATCH
	 * @param {string} jsonData - Data to send in the body of our request.
	 * @return {struct} Response from Mailchimp's API.
	 */
    public any function sendRequestToMailchimp( required string apiPath, required method, string jsonData = '' ) {

        var httpRequest = new http();
        httpRequest.setMethod( arguments.method );
		httpRequest.setUrl( arguments.apiPath );
		httpRequest.setTimeout(1);
		httpRequest.setThrowonerror(false);
		httpRequest.addParam( 
			type = 'header', 
			name = 'Content-type', 
			value = 'application/json' 
		);
		httpRequest.addParam( 
			type = 'header', 
			name = 'Authorization', 
			value = 'apikey #getHibachiScope().setting('integrationmailchimpmailChimpAPIKey')#'
		);
		
		if ( len( arguments.jsonData ) ) {
			httpRequest.addParam( type = 'body', value = arguments.jsonData );
		}
		
		var response = httpRequest.send().getPrefix();

		if(isJson(response.FileContent)){
			return deserializeJson( response.FileContent );
		}
		return {};
    }
    
}
