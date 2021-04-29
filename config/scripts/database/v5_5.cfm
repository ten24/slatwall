<cfsetting requesttimeout="1200" />

<cfset local.scriptHasErrors = false />

<cftry>
	<cfif ListFind(getApplicationValue("databaseType"), 'MySQL')>
		<cfquery name="increaseVerificationJsonLength">
			ALTER TABLE swaddress
            MODIFY verificationJson
            varchar(1000)
		</cfquery>
	</cfif>
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - v5_5">
		<cfset local.scriptHasErrors = true />
		<cflog file="application" text="General Log - #cfcatch.message#">
	</cfcatch>


</cftry>


<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script v5_5 had errors when running">
	<cfthrow detail="Part of Script v5_5 had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script v5_5 has run with no errors">
</cfif>