<cfcomponent accessors="true" extends="Slatwall.org.Hibachi.HibachiController" output="false">

<cfproperty name="integrationS3RequestService" />


<cffunction name="before" returntype="struct" access="public" output="false">
	<cfargument name="rc" type="struct" required="true" hint="Request-Context" />

	<cfset getFW().setView('s3:main.blank') />

	<cfreturn rc />
</cffunction>


<cffunction name="get" returntype="struct" access="public" output="false">
	<cfargument name="rc" type="struct" required="true" hint="Request-Context" />

	<cfparam name="rc.id" type="string" default="" />

	<cfset local.orderDeliveryItem = getIntegrationS3RequestService().getOrderDeliveryItem(rc.id) />

	<cfif NOT isNull(local.orderDeliveryItem)>
		<cfset rc.integrationS3Request = getIntegrationS3RequestService().newIntegrationS3RequestFromOrderDeliveryItem(local.orderDeliveryItem) />

		<cfif NOT isNull(rc.integrationS3Request)>
			<cfset getFW().setView('s3:public.get') />
		</cfif>
	</cfif>

	<cfset getIntegrationS3RequestService().cleanTempDirectory() />

	<cfreturn rc />
</cffunction>

</cfcomponent>