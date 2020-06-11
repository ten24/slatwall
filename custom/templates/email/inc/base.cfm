<cfscript>
	function getEmailContent(required string attributeValue, required any emailTemplate){
		try{
		    var emailContentType = getHibachiScope().getService("typeService").getTypeByTypeCode(
		        arguments.attributeValue
			);
			var attributeValue = getHibachiScope().getService("attributeService").getAttributeValueByType(emailContentType)
			return attributeValue.getFormattedValue(propertyName='attributeValue', locale=locale);		
		}catch(e){
			return '';
		}
	}
</cfscript>

<cfsavecontent variable="emailData.emailBodyHTML">
	
	<cfoutput>

	    <cfif emailTemplate.getAttributeValue('useGlobalHeaderAndFooterFlag')> 
			#getEmailContent('#account.getAccountType()##account.getaccountCreatedSite().getRemoteID()#Header', emailTemplate)#
		</cfif>
		
		<cfset local.emailBody = emailTemplate.getFormattedAttributeValue(attribute='#account.getAccountType()##account.getAccountCreatedSite().getRemoteId()#Body', formatType='language', locale=locale) />
	
		<cfif NOT len(Trim(emailBody)) >
		    	<cfset emailBody = emailTemplate.getFormattedValue(propertyName='#account.getAccountType()#Body', locale=locale) />
		 </cfif>
		 
		 #templateObject.stringReplace( emailBody, true )#
		
		<cfif emailTemplate.getAttributeValue('useGlobalHeaderAndFooterFlag') >
		    #getEmailContent('#account.getAccountType()##account.getaccountCreatedSite().getRemoteId()#Footer', emailTemplate)#
		</cfif>
		
	</cfoutput>
</cfsavecontent>

<cfsavecontent variable="emailData.emailBodyText">
	
	<!--- PLAIN TEXT VERSION / TODO: Get the right Body text --->
	<cfoutput>
		#email.getEmailBodyText()#
	</cfoutput>
	
</cfsavecontent>
