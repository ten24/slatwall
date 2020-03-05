<cfcomponent extends="Slatwall.model.dao.AccountDAO">

    <cffunction name="placeOrdersInProcessingTwo" returntype="void" access="public">
        <cfargument name="data" />
		
 		<cfset var rs = "" />
 		<cfquery name="rs">
 		    UPDATE 
 		        swOrder
            SET 
                orderStatusType = CONCAT('DELETED-', providerToken), 
                activeFlag = 0
            WHERE 
                providerToken IN ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.providerTokens#" list="true" /> )
        </cfquery>
        
        
	</cffunction>
	
</cfcomponent>