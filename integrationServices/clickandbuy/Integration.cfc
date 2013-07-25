<cfcomponent accessors="true" extends="Slatwall.integrationServices.BaseIntegration" implements="Slatwall.integrationServices.IntegrationInterface">

<cffunction name="init" returnType="any" access="public">
	<cfreturn this />
</cffunction>


<cffunction name="getIntegrationTypes" returnType="string" access="public">
	<cfreturn 'payment' />
</cffunction>


<cffunction name="getDisplayName" returnType="string" access="public">
	<cfreturn 'ClickandBuy' />
</cffunction>


<cffunction name="getSettings" returnType="struct" access="public">
	<cfreturn {
			merchantId						= { fieldType='text', displayName='Merchant ID' },
			projectId							= { fieldType='text', displayName='Project ID' },
			projectDescription		= { fieldType='text', displayName='Project description' },
			consumerLanguage			= { fieldType='text', displayName='Consumer language (ISO 639-1)', defaultValue='en' },
			transferProductNames	= { fieldType='yesno', displayName='Transfer product names to ClickandBuy', defaultValue=true  },
			secretKey							= { fieldType='text', displayName='Secret Key' },
			currency							= { fieldType='text', displayName='Currency (ISO 4217)', defaultValue='EUR' },
			sandBox								= { fieldType='yesno', displayName='Sandbox active', defaultValue=true }
		} />
</cffunction>

</cfcomponent>