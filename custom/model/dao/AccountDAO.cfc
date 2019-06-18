<cfcomponent extends="Slatwall.model.dao.AccountDAO">

    <cffunction name="removeStalePaymentProviderTokens" returntype="void" access="public">
        <cfargument name="providerTokens" />
		
 		<cfset var rs = "" />
 		<cfquery name="rs">
 		    UPDATE 
 		        swAccountPaymentMethod
            SET 
                providerToken = CONCAT('DELETED-', providerToken), 
                activeFlag = 0
            WHERE 
                providerToken IN ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.providerTokens#" list="true" /> )
        </cfquery>
        
        <cfquery name="rs">
            UPDATE 
                swOrderPayment
            SET 
                providerToken = CONCAT('DELETED-', providerToken)
            WHERE 
                providerToken IN ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.providerTokens#" list="true" /> )
        </cfquery>
        
	</cffunction>
	
</cfcomponent>