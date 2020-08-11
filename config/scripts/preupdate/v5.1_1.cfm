<cfparam name="this.ormSettings.dialect" />
<cfparam name="this.datasource.name" />
<cfparam name="this.datasource.username" default="" />
<cfparam name="this.datasource.password" default="" />
<cfsetting requesttimeout="1200" />
<cfdbinfo datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#" type="tables" name="currenttables" pattern="SwContent" />

<cfif currenttables.recordCount>
	<cfset local.scriptHasErrors = false />

	<cftry>
		<cfquery name="local.updateContentColumnLengths" datasource="#this.datasource.name#">
			ALTER TABLE swcontent
			MODIFY COLUMN urlTitlePath varchar(255) NULL,
			MODIFY COLUMN urlTitle varchar(255) NULL
		</cfquery>
		
		<cfcatch>
			<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update Content Column Lengths">
			<cfset local.scriptHasErrors = true />
		</cfcatch>
	</cftry>
	
	<cfif local.scriptHasErrors>
		<cflog file="Slatwall" text="General Log - Part of Preupdate Script v5_1_1 had errors when running">
		<cfthrow detail="Part of Script v5_1_1 had errors when running">
	<cfelse>
		<cflog file="Slatwall" text="General Log - Preupdate Script v5_1_1 has run with no errors">
	</cfif>
</cfif>

