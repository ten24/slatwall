<cfcomponent extends="Slatwall.integrationServices.BaseIntegration" implements="Slatwall.integrationServices.IntegrationInterface" output="false" hint="SOFORT Überweisung Slatwall v3 Integration">

<cffunction name="getIntegrationTypes" returnType="string" access="public">
	<cfreturn 'payment' />
</cffunction>


<cffunction name="getDisplayName" returnType="string" access="public">
	<cfreturn 'SOFORT Überweisung' />
</cffunction>


<cffunction name="getSettings" returnType="struct" access="public">
	<cfreturn {
		apiKey						= { fieldType='text' },
		customerId					= { fieldType='text' },
		projectId					= { fieldType='text' },
		currency					= { fieldType='text' },
		language					= { fieldType='text' },
		assumeUntraceableAsSuccess	= { fieldType='yesno',defaultValue=0 }
	} />
</cffunction>

</cfcomponent>