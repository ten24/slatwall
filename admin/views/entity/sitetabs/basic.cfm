<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.site" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<cfif !isNull(rc.site.getApp())>
				<hb:HibachiPropertyDisplay object="#rc.site#" property="app" edit="false">
			</cfif>
			<hb:HibachiPropertyDisplay object="#rc.site#" property="siteName" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.site#" property="siteCode" edit="false">
			<cfif !isNull(rc.site.getApp()) && rc.site.getApp().getIntegration().getIntegrationPackage() eq 'slatwallcms'>
				<hb:HibachiPropertyDisplay object="#rc.site#" property="domainNames" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.site#" property="allowAdminAccessFlag" edit="#rc.edit#">
			</cfif>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
	
</cfoutput>