<cfscript>
	function getEmailContent(required string attributeValue, required any emailTemplate){
		try{
			var emailContentType = getHibachiScope().getService("typeService").getTypeByTypeID(arguments.emailTemplate.getAttributeValue(arguments.attributeValue));
			return getHibachiScope().getService("attributeService").getAttributeValueByType(emailContentType).getAttributeValue();		
		}catch(e){
			return '';
		}
	}
</cfscript>

<cfsavecontent variable="emailData.emailBodyHTML">
	<cfif accountType == 'retail'>
	    <cfset accountType = "customer">
	</cfif>
	
	<cfoutput>
		#getEmailContent('#accountType#EmailHeader', emailTemplate)#
		#templateObject.stringReplace( emailTemplate.getFormattedValue(propertyName='#accountType#Body', locale=locale),true )#
		#getEmailContent('#accountType#EmailFooter', emailTemplate)#
	</cfoutput>
</cfsavecontent>

<cfsavecontent variable="emailData.emailBodyText">
	
	<!--- PLAIN TEXT VERSION / TODO: Get the right Body text --->
	<cfoutput>
		#email.getEmailBodyText()#
	</cfoutput>
	
</cfsavecontent>

