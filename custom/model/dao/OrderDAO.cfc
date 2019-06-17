<cfcomponent extends="Slatwall.model.dao.OrderDAO">

	<cffunction name="removeTokenFromStaleOrderPayments" returntype="void" access="public">
        <cfargument name="orderPaymentID" required="true"  />
        <cfquery name="rs">
 		    UPDATE swOrderPayment
            SET providerToken = CONCAT('DELETED-', providerToken)
            WHERE providerToken = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.providerTokenID#" />
        </cfquery>
	</cffunction>
	
</cfcomponent>