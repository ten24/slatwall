<cfcomponent extends="hibachiDAO">

	<cffunction name="updateCalculatedImagePath" access="public" returntype="void"> 
		<cfargument name="oldPath" type="string" required="true">
		<cfargument name="newPath" type="string" required="true">
	
		<cfquery name="local.updateCalculatedImagePath"> 
			update swimage set calculatedImagePath=replace(calculatedImagePath, <cfqueryparam value="#arguments.oldPath#" cfsqltype="CF_SQL_VARCHAR" />, <cfqueryparam value="#arguments.newPath#" cfsqltype="CF_SQL_VARCHAR" />)
		</cfquery> 
	
	</cffunction> 
</cfcomponent> 
