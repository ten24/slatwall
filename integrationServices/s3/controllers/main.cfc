<cfcomponent accessors="true" output="false">

<cfproperty name="framework" />


<cffunction name="init" returnType="any" access="public" output="false">
	<cfargument name="framework" type="any" required="true" />

	<cfset setFramework(arguments.framework) />

	<cfreturn this />
</cffunction>


<cffunction name="before" returntype="struct" access="public" output="false">
	<cfargument name="rc" type="struct" required="true" hint="Request-Context" />

	<cfset getFramework().redirect('s3:admin.listorder') />

	<cfreturn rc />
</cffunction>

</cfcomponent>