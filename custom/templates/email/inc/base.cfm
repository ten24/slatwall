<cfscript>
	function getEmailContent(required string attributeValue, required any emailTemplate){
		try{
			var emailContentType = getHibachiScope().getService("typeService").getTypeByTypeCode(arguments.attributeValue);
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
	    <!--- if is headerin setting ---> 
	    <!--- include #accountType##countryCode#Header --->
		
		#getEmailContent('#accountType##countryCode#EmailHeader', emailTemplate)#
		<cfset emailBody = emailTemplate.getFormattedValue(propertyName='#accountType##CountryCode#Body', locale=locale) />
		<cfif NOT len(Trim(emailBody)) >
		    	<cfset emailBody = emailTemplate.getFormattedValue(propertyName='#accountType#Body', locale=locale) />

		 </cfif>
		#templateObject.stringReplace( emailBody, true )#
		    <!--accounttype countr-->
		    <!--- include #accountType##countryCode#Footer --->
		#getEmailContent('#accountType#EmailFooter', emailTemplate)#
	</cfoutput>
</cfsavecontent>

<cfsavecontent variable="emailData.emailBodyText">
	
	<!--- PLAIN TEXT VERSION / TODO: Get the right Body text --->
	<cfoutput>
		#email.getEmailBodyText()#
	</cfoutput>
	
</cfsavecontent>

