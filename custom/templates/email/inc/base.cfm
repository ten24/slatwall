<cfscript>
	function getEmailContent(required string attributeValue, required any emailTemplate, required string locale){
		try{
		    var emailContentType = getHibachiScope().getService("typeService").getTypeByTypeCode(
		        arguments.attributeValue
			);
			var attributeValue = getHibachiScope().getService("attributeService").getAttributeValueByType(emailContentType)
			return attributeValue.getFormattedValue(propertyName='attributeValue', locale=arguments.locale);		
		}catch(e){
			return '';
		}
	}
</cfscript>
<cfif NOT isNull(account) >
	<cfset local.accountType = account.getAccountType() /> 
<cfelse>
	<cfset local.accountType = 'customer' />
</cfif>

<cfif isNull(local.accountType) OR local.accountType EQ 'Unassigned' OR local.accountType EQ 'retail'>
	<cfset local.accountType = 'customer' />
</cfif>

<cfset local.site = account.getAccountCreatedSite() />
<cfif isNull(local.site) >
	<cfset local.site = getHibachiScope().getCurrentRequestSite() />
</cfif>

<cfsavecontent variable="emailData.emailBodyHTML">
	
	<cfoutput>

	    <cfif emailTemplate.getAttributeValue('useGlobalHeaderAndFooterFlag')> 
			#getEmailContent(attributeValue='#local.accountType##local.site.getRemoteID()#Header', emailTemplate=emailTemplate, locale=locale)#
		</cfif>
		
		<cfset local.emailBody = emailTemplate.getFormattedAttributeValue(attribute='#local.accountType##local.site.getRemoteId()#Body', formatType='language', locale=locale) />
	
		<cfif NOT len(Trim(emailBody)) >
		    	<cfset emailBody = emailTemplate.getFormattedValue(propertyName='#local.accountType#Body', locale=locale) />
		 </cfif>
		 
		 #templateObject.stringReplace( emailBody, true )#
		
		<cfif emailTemplate.getAttributeValue('useGlobalHeaderAndFooterFlag') >
		    #getEmailContent(attributeValue='#local.accountType##local.site.getRemoteId()#Footer', emailTemplate=emailTemplate, locale=locale)#
		</cfif>
		
	</cfoutput>
</cfsavecontent>

<cfsavecontent variable="emailData.emailBodyText">
	
	<!--- PLAIN TEXT VERSION / TODO: Get the right Body text --->
	<cfoutput>
		#email.getEmailBodyText()#
	</cfoutput>
	
</cfsavecontent>
