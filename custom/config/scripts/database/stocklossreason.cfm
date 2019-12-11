<cfset local.scriptHasErrors = false />

<cftry>
    <cfquery name="local.stockLossReason">
        ALTER TABLE sworderitem
        ADD COLUMN stockLossReason varchar(255)
	</cfquery>
    <cfcatch>
        <cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Add stock loss reason property">
    	<cfset local.scriptHasErrors = true />
    </cfcatch>
</cftry>

<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script stockLossReason had errors when running">
	<cfthrow detail="Part of Script stockLossReason had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script stockLossReason has run with no errors">
</cfif>
