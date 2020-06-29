<cfsetting requesttimeout="1200" />

<cfset local.scriptHasErrors = false />


<cftry>
	<cfif ListFind(getApplicationValue("databaseType"), 'MySQL')>
		<cfdbinfo datasource="#getApplicationValue("datasource")#" username="#getApplicationValue("datasourceUsername")#" password="#getApplicationValue("datasourcePassword")#" type="tables" name="currenttables" pattern="swordertemplatenumber" />
		
		<cfif !currenttables.recordCount>
			<cfquery  name="createSwOrderTemplateNumber">
				CREATE TABLE swordertemplatenumber(
					orderTemplateNumber INT NOT NULL auto_increment PRIMARY KEY,
					orderTemplateID VARCHAR(32),
					createdDateTime TIMESTAMP
				);
			</cfquery>
		</cfif>
		
	</cfif>
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - v5_1_9">
		<cfset local.scriptHasErrors = true />
		<cflog file="application" text="General Log - #cfcatch.message#">
	</cfcatch>

</cftry>

<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script v5_1_9 had errors when running">
	<cfthrow detail="Part of Script v5_1_9 had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script v5_1_9 has run with no errors">
</cfif>

