<cfparam name="rc.emailTemplate" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.emailTemplate#" edit="#rc.edit#">		
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList divClass="col-md-6">
				<cf_HibachiPropertyDisplay object="#rc.emailTemplate#" property="emailTemplateName" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.emailTemplate#" property="emailTemplateFile" edit="#rc.edit#">
			</cf_HibachiPropertyList>
			<cf_HibachiPropertyList divClass="col-md-6">
				<cf_HibachiPropertyDisplay object="#rc.emailTemplate#" property="emailTemplateObject" edit="false">
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
	</cf_HibachiEntityDetailForm>
</cfoutput>