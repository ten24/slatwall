<cfif fileExists("../../../config/applicationSettings.cfm")>
	<cfinclude template="../../../config/applicationSettings.cfm" />
	<cfinclude template="../../../config/mappings.cfm" />
<cfelse>
	<cfinclude template="../../../core/appcfc/applicationSettings.cfm" />
</cfif>
<cfinclude template="../../../plugins/mappings.cfm" />
