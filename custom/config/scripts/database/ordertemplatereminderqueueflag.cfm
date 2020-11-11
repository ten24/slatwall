<cfset local.scriptHasErrors = false />

<cftry>
    <cfquery name="local.processingReminderEmailEntityQueueFlag">
        ALTER TABLE swordertemplate
        LOCK=NONE,
        ALGORITHM=INPLACE,
        ADD COLUMN processingReminderEmailEntityQueueFlag boolean
	</cfquery>
    <cfcatch>
        <cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Add stock loss reason property">
    	<cfset local.scriptHasErrors = true />
    </cfcatch>
</cftry>

<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script processingReminderEmailEntityQueueFlag had errors when running">
	<cfthrow detail="Part of Script processingReminderEmailEntityQueueFlag had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script processingReminderEmailEntityQueueFlag has run with no errors">
</cfif>
