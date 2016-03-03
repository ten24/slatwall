<cfcomponent extends="Slatwall.integrationServices.BaseIntegration" implements="Slatwall.integrationServices.IntegrationInterface" output="false" hint="Click & Buy Slatwall v3 Integration">

<cffunction name="getIntegrationTypes" returnType="string" access="public">
	<cfreturn 'payment' />
</cffunction>


<cffunction name="getDisplayName" returnType="string" access="public">
	<cfreturn 'Click & Buy' />
</cffunction>

</cfcomponent>