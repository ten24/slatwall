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
	<cfoutput>
	
		#getEmailContent('#accountType#EmailHeader', emailTemplate)#
		
		<cfswitch expression="#accountType#">
			<cfcase value="retail,customer">
				#templateObject.stringReplace( emailTemplate.getFormattedValue(propertyName='CustomerBody',locale=locale),true )#
			</cfcase>
			<cfcase value="VIP">
				#templateObject.stringReplace( emailTemplate.getFormattedValue(propertyName='VipBody',locale=locale),true )#
			</cfcase>
			<cfdefaultcase>
				<!-----MARKET PARTER TEMPLATE HERE ----->
			</cfdefaultcase>
		</cfswitch>
	
		#getEmailContent('#accountType#EmailFooter', emailTemplate)#
	
	</cfoutput>
</cfsavecontent>
<cfsavecontent variable="emailData.emailBodyText">
	
	<!-- PLAIN TEXT VERSION / TODO: Get the right Body text-->
	<cfoutput>
		#email.getEmailBodyText()#
	</cfoutput>
	
</cfsavecontent>

