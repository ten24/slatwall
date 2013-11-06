<cfcomponent extends="Slatwall.integrationServices.BaseIntegration" implements="Slatwall.integrationServices.IntegrationInterface" output="false" hint="Click & Buy Slatwall v3 Integration">

<cffunction name="getIntegrationTypes" returnType="string" access="public">
	<cfreturn 'payment' />
</cffunction>


<cffunction name="getDisplayName" returnType="string" access="public">
	<cfreturn 'Click & Buy' />
</cffunction>


<cffunction name="getSettings" returnType="struct" access="public">
	<cfreturn {
		merchantId						= { fieldType='text' },
		projectId							= { fieldType='text' },
		projectDescription		= { fieldType='text' },
		consumerLanguage			= { fieldType='text', defaultValue='en' },
		secretKey							= { fieldType='text' },
		currency							= { fieldType='text', defaultValue='EUR' },
		sandBoxIsActive				= { fieldType='yesno', defaultValue=true }
	} />
</cffunction>

</cfcomponent>