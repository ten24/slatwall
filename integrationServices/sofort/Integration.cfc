<cfcomponent extends="Slatwall.integrationServices.BaseIntegration" implements="Slatwall.integrationServices.IntegrationInterface" output="false" hint="SOFORT Überweisung Slatwall v3 Integration">

<cffunction name="getIntegrationTypes" returnType="string" access="public">
	<cfreturn 'payment' />
</cffunction>


<cffunction name="getDisplayName" returnType="string" access="public">
	<cfreturn 'SOFORT Überweisung' />
</cffunction>

</cfcomponent>