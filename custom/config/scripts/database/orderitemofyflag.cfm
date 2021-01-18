<cfset local.scriptHasErrors = false />

<cftry>
    <cfquery name="local.ofyFlag">
        ALTER TABLE sworderitem
        LOCK=NONE,
        ALGORITHM=INPLACE,
        ADD COLUMN ofyFlag boolean;
	</cfquery>
    <cfcatch>
        <cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Add ofyFlag">
    	<cfset local.scriptHasErrors = true />
    </cfcatch>
</cftry>

<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script ofyFlag had errors when running">
	<cfthrow detail="Part of Script ofyFlag had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script ofyFlag has run with no errors">
</cfif>
