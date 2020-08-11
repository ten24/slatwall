<cfsetting requesttimeout="1200" />
<cfdbinfo datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#" type="tables" name="currenttables" pattern="SwAttribute" />

<cfif currenttables.recordCount>
	<cfdbinfo datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#" type="columns" name="attributecolumns" table="SwAttribute" />
	<cfset local.isMigratedExists = false />
	<cfloop query="#attributecolumns#">
		<cfif Column_Name eq 'isMigratedFlag'>
			<cfset local.isMigratedExists = true />
		</cfif>
		<cfif local.isMigratedExists>
			<cfbreak>
		</cfif>
	</cfloop>
	<cfif !local.isMigratedExists >
		<cfquery name="local.addIsMigratedFlag" datasource="#this.datasource.name#">
			ALTER TABLE SwAttribute ADD isMigratedFlag tinyint(1)
		</cfquery>
	</cfif>
	<cflog file="Slatwall" text="General Log - Preupdate Script v5_1_3 has run with no errors">
</cfif>