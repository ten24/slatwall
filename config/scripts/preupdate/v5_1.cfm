<cfparam name="this.ormSettings.dialect" />
<cfparam name="this.datasource.name" />
<cfparam name="this.datasource.username" default="" />
<cfparam name="this.datasource.password" default="" />
<cfsetting requesttimeout="1200" />
<cfdbinfo datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#" type="tables" name="currenttables" pattern="SwAttribute" />

<cfif currenttables.recordCount>
	<cfdbinfo datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#" type="columns" name="attributecolumns" table="SwAttribute" />
	<cfset local.found = false />
	<cfloop query="#attributecolumns#">
		<cfif Column_Name eq 'customPropertyFlag'>
			<cfset local.found = true />
		</cfif>
		<cfif local.found>
			<cfbreak>
		</cfif>
	</cfloop>
	<cfif !local.found>
		<cfquery name="local.addCustomPropertyFlag" datasource="#this.datasource.name#">
			ALTER TABLE SwAttribute ADD customPropertyFlag tinyint(1)
		</cfquery>
	</cfif>
	<cflog file="Slatwall" text="General Log - Preupdate Script v5_1 has run with no errors">
</cfif>