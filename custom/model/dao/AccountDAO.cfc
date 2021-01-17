<cfcomponent extends="Slatwall.model.dao.AccountDAO">

	
	<cffunction name="updateRemoteIDForNewAccount" returntype="void" access="public">
		<cfargument name="accountID" />
		<cfargument name="remoteID" />
		<cfargument name="importRemoteID" />
		<cfset var rs = "" />
		<cfquery name="rs">
			UPDATE 
				swaccount
			SET 
				remoteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.remoteID#"/>,
				importRemoteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.importRemoteID#"/>
			WHERE 
				accountID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.accountID#"/>
		</cfquery>
		
	</cffunction>
	
</cfcomponent>
