<cfcomponent accessors="true" extends="Slatwall.integrationServices.BaseIntegration" implements="Slatwall.integrationServices.IntegrationInterface">

<cffunction name="init" returnType="any" access="public">
	<cfreturn this />
</cffunction>


<cffunction name="getIntegrationTypes" returnType="string" access="public">
	<cfreturn 'payment' />
</cffunction>


<cffunction name="getDisplayName" returnType="string" access="public">
	<cfreturn 'SOFORT Überweisung' />
</cffunction>


<cffunction name="getSettings" returnType="struct" access="public">
	<cfreturn {
			apiKey								= { fieldType='text', displayName='API Key' },
			projectId							= { fieldType='text', displayName='Project ID' },
			customerId						= { fieldType='text', displayName='Customer ID' },
			language							= { fieldType='text', displayName='Language (ISO 639-1)', defaultValue='en' },
			currency							= { fieldType='text', displayName='Currency (ISO 4217)', defaultValue='EUR' },
			transferProductNames	= { fieldType='yesno', displayName='Transfer product names to SOFORT', defaultValue=true }
		} />
</cffunction>

</cfcomponent>