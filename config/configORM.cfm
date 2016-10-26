<cfparam name="this.datasource.username" default="" />
<cfparam name="this.datasource.password" default="" />

<cfset arrayAppend(this.ormsettings.cfclocation, "/Slatwall/integrationServices") />
<cftry>
	<cfdbinfo datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#" type="Version" name="dbVersion">
	<cfcatch>
		<cfinclude template="#variables.framework.baseURL#/admin/views/main/nodatasource.cfm" />
		<cfabort />
	</cfcatch>
</cftry>
<cfif findNoCase("MySQL", dbVersion.DATABASE_PRODUCTNAME)>
	<cfset this.ormSettings.dialect = "MySQL" />
<cfelseif findNoCase("Microsoft", dbVersion.DATABASE_PRODUCTNAME)>
	<cfset this.ormSettings.dialect = "MicrosoftSQLServer" />
<cfelseif findNoCase("Oracle", dbVersion.DATABASE_PRODUCTNAME)>
	<cfset this.ormSettings.dialect = "Oracle10g" />
</cfif>
