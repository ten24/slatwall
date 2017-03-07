<cfcomponent>
	<cfif fileExists(expandPath("../varscoper.cfc"))>
		<cfinclude template="../varscoper.cfc">
	<cfelseif fileExists(expandPath("../varscoper/varscoper.cfc"))>
		<cfinclude template="../varscoper/varscoper.cfc">
	</cfif>
</cfcomponent>