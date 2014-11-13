<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.printTemplate" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList divClass="col-md-6">
			<cf_HibachiPropertyDisplay object="#rc.printTemplate#" property="printTemplateName" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.printTemplate#" property="printTemplateFile" edit="#rc.edit#">
		</cf_HibachiPropertyList>
		<cf_HibachiPropertyList divClass="col-md-6">
			<cf_HibachiPropertyDisplay object="#rc.printTemplate#" property="printTemplateObject" edit="false">
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
</cfoutput>