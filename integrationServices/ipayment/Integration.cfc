<cfcomponent accessors="true" extends="Slatwall.integrationServices.BaseIntegration" implements="Slatwall.integrationServices.IntegrationInterface">

<cffunction name="init" returnType="any" access="public">
	<cfreturn this />
</cffunction>


<cffunction name="getIntegrationTypes" returnType="string" access="public">
	<cfreturn 'payment' />
</cffunction>


<cffunction name="getDisplayName" returnType="string" access="public">
	<cfreturn '1&1 iPayment' />
</cffunction>


<cffunction name="getSettings" returnType="struct" access="public">
	<cfreturn {
		accountId								= { fieldType='text' },
		applicationId						= { fieldType='text' },
		applicationPassword			= { fieldType='text' },
		currency								= { fieldType='text', defaultValue='EUR' },
		transactionSecurityKey	= { fieldType='text' },
		invoiceText							= { fieldType='text' }
	} />
</cffunction>

</cfcomponent>