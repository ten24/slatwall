<cfset local.scriptHasErrors = false />

<cftry>
    <cfquery name="local.workflowUpdates">
        
        ALTER TABLE swworkflowtrigger 
            LOCK=NONE,
            ALGORITHM=INPLACE,
            ADD COLUMN `maxTryCount` int(11) DEFAULT NULL;
        
	</cfquery>
    <cfcatch >
        <cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Workflow Max Try Count Field (#cfcatch.detail#)">
    	<cfset local.scriptHasErrors = true />
    </cfcatch>
</cftry>

<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script workflowtaskmaxtrycount had errors when running">
	<cfthrow detail="Part of Script workflowtaskmaxtrycount had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script workflowtaskmaxtrycount has run with no errors">
</cfif>
