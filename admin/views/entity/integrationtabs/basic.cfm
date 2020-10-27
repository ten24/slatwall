<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.integration" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.integration#" property="integrationPackage" edit="false">
			<hb:HibachiPropertyDisplay object="#rc.integration#" property="activeFlag" edit="#rc.edit#" />
			
			<cfif fileExists("#expandPath('/Slatwall')#/integrationServices/#rc.integration.getIntegrationPackage()#/config/#rc.integration.getIntegrationPackage()#configurationguide.pdf") >
				<a href="#request.slatwallScope.getBaseUrl()#/integrationServices/#rc.integration.getIntegrationPackage()#/config/#rc.integration.getIntegrationPackage()#configurationguide.pdf">Download the Configuration Guide</a>
			</cfif>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>