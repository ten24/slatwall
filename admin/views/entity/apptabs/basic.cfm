<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.app" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.app#" property="appName" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.app#" property="appCode" edit="false">
			<hb:HibachiPropertyDisplay object="#rc.app#" property="appRootPath" edit="false">
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>