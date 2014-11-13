<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.emailTemplate" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList divClass="col-md-6">
			<cf_HibachiPropertyDisplay object="#rc.emailTemplate#" property="emailTemplateName" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.emailTemplate#" property="emailTemplateFile" edit="#rc.edit#">
		</cf_HibachiPropertyList>
		<cf_HibachiPropertyList divClass="col-md-6">
			<cf_HibachiPropertyDisplay object="#rc.emailTemplate#" property="emailTemplateObject" edit="false">
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
</cfoutput>