<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.integration" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.integration#" property="integrationPackage" edit="false">
			<hb:HibachiPropertyDisplay object="#rc.integration#" property="activeFlag" edit="#rc.edit#" />
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>