<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.integration" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList>
			<cf_HibachiPropertyDisplay object="#rc.integration#" property="integrationPackage" edit="false">
			<cf_HibachiPropertyDisplay object="#rc.integration#" property="activeFlag" edit="#rc.edit#" />
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
</cfoutput>