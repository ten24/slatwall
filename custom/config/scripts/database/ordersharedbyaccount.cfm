<cfset local.scriptHasErrors = false />

<cftry>
    <cfquery name="local.ordersharedbyaccount">
        ALTER TABLE sworder
        ADD COLUMN sharedByAccountID varchar(32),
        ADD FOREIGN KEY (sharedByAccountID) references swaccount(accountID);
	</cfquery>
    <cfcatch>
        <cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Add Shared By Account property">
    	<cfset local.scriptHasErrors = true />
    </cfcatch>
</cftry>

<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script ordersharedbyaccount had errors when running">
	<cfthrow detail="Part of Script ordersharedbyaccount had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script ordersharedbyaccount has run with no errors">
</cfif>
