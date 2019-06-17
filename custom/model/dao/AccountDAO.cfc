<cfcomponent extends="Slatwall.model.dao.AccountDAO">

    <cffunction name="removeTokenFromStaleAccountPayments" returntype="void" access="public">
		<cfargument name="accountPaymentMethodID" required="true"  />
 		<cfset var rs = "" />
 		<cfquery name="rs">
 		    UPDATE swAccountPaymentMethod 
            SET providerToken = CONCAT('DELETED-', providerToken)
            WHERE providerToken = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.providerTokenID#" />
        </cfquery>
	</cffunction>
	
</cfcomponent>