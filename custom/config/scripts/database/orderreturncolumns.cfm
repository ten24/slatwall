

<cfset local.scriptHasErrors = false />

<cftry>
    <cfquery name="local.addColumns">
        Alter table sworderreturn
        LOCK=NONE,
        ALGORITHM=INPLACE,
        ADD COLUMN fulfillmentRefundPreTax decimal(19,2),
        ADD COLUMN fulfillmentTaxRefund decimal(19,2);
	</cfquery>
    <cfcatch>
        <cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Add Order Return columns">
    	<cfset local.scriptHasErrors = true />
    </cfcatch>
</cftry>

<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script Add Order Return columns had errors when running">
	<cfthrow detail="Part of Script Add Order Return columns had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script Add Order Return columns has run with no errors">
</cfif>
