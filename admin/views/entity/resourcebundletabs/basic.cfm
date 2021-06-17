<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.resourceBundle" type="any" />
<cfparam name="rc.edit" type="boolean" />
<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.resourceBundle#" property="resourcebundleKey" edit="#rc.edit#" requiredFlag="true">
			<hb:HibachiPropertyDisplay object="#rc.resourceBundle#" property="resourceBundleLocale" edit="#rc.edit#"> 
			<hb:HibachiPropertyDisplay object="#rc.resourceBundle#" property="resourcebundleValue" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.resourceBundle#" property="activeFlag" edit="#rc.edit#">
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput> 