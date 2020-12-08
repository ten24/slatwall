<cfset local.scriptHasErrors = false />

<cftry>
    <cfquery name="local.taxCommitResponse">
        ALTER TABLE sworder
        LOCK=NONE,
        ALGORITHM=INPLACE,
        ADD COLUMN taxCommitResponse varchar(255)
	</cfquery>
    <cfcatch>
        <cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Add tax commit response property">
    	<cfset local.scriptHasErrors = true />
    </cfcatch>
</cftry>

<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script taxCommitResponse had errors when running">
	<cfthrow detail="Part of Script taxCommitResponse had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script taxCommitResponse has run with no errors">
</cfif>
