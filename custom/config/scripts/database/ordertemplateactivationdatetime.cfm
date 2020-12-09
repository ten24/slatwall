<cfset local.scriptHasErrors = false />

<cftry>
    <cfquery name="local.activationDateTime">
        ALTER TABLE swordertemplate
        LOCK=NONE,
        ALGORITHM=INPLACE,
        ADD COLUMN activationDateTime DATETIME
	</cfquery>
    <cfcatch>
        <cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Add OrderTemplate ActivationDateTime property">
    	<cfset local.scriptHasErrors = true />
    </cfcatch>
</cftry>

<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script OrderTemplateActivationDateTime had errors when running">
	<cfthrow detail="Part of Script OrderTemplateActivationDateTime had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script OrderTemplateActivationDateTime has run with no errors">
</cfif>