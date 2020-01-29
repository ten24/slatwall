<cfparam name="email" type="any" />	
<cfparam name="emailData" type="struct" default="#structNew()#" />
<cfparam name="account" type="any" />
<cfscript>
	var accountType = account.getAccountType() ?: 'Retail';
	var emailBody = email.getAttributeValue('body'&accountType);
	var emailTemplate = getHibachiScope().getService("emailService").getEmailTemplateByEmailTemplateName('Welcome New VIP Sponsor Email');
</cfscript>
<cfsavecontent variable="emailData.emailBodyHTML">
	<cfoutput>

	<cfif accountType == "retail" OR accountType == "customer">
		<cfinclude template="../inc/retail-header.cfm" />
			#emailTemplate.getCustomerBody()#
		<cfinclude template="../inc/retail-footer.cfm" />
	<cfelseif account.getAccountType() == 'VIP'>
		<cfinclude template="../inc/vip-header.cfm" />
			#emailTemplate.getVipBody()#
		<cfinclude template="../inc/vip-footer.cfm" />
	<cfelse>
	
					<!-----MARKET PARTER TEMPLATE HERE ----->
					
	</cfif>
	
	
	</cfoutput>
</cfsavecontent>
<cfsavecontent variable="emailData.emailBodyText">
	
	<!-- PLAIN TEXT VERSION -->
	<cfoutput>
		Welcome!
		
		You have finished setting up your new account
		
		<a href="/my-account/" target="_blank">My Account</a>
	</cfoutput>
	
</cfsavecontent>

