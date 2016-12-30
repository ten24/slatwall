<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.emailTemplate" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList divClass="col-md-6">
			<hb:HibachiPropertyDisplay object="#rc.emailTemplate#" property="emailTemplateName" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.emailTemplate#" property="emailTemplateFile" edit="#rc.edit#">
		</hb:HibachiPropertyList>
		<hb:HibachiPropertyList divClass="col-md-6">
			<hb:HibachiPropertyDisplay object="#rc.emailTemplate#" property="logEmailFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.emailTemplate#" property="emailTemplateObject" edit="false">
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>