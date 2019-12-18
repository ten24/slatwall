<cfcomponent extends="Slatwall.model.dao.TypeDAO">

    <cffunction name="getTypeBySystemCodeOnly" output="false" access="public">
		<cfargument name="systemCode" type="string" required="true" >
		<cfreturn ormExecuteQuery("SELECT atype FROM SlatwallType atype WHERE atype.systemCode = ?", [arguments.systemCode], true, {maxResults=1}) />
	</cffunction>
	
	<cffunction name="getTypeByTypeID" output="false" access="public">
		<cfargument name="typeID" type="string" required="true" >
		
		<cfreturn ormExecuteQuery("SELECT atype FROM SlatwallType atype WHERE atype.typeID = ? ORDER BY sortOrder ASC", [arguments.typeID], true) />
	</cffunction>
	
</cfcomponent>