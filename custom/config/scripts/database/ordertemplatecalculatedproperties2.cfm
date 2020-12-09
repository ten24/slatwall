<cfset local.scriptHasErrors = false />

<cftry>
	<cfquery name="local.addColumnsToOrderTemplate">
		ALTER TABLE swOrderTemplate
		LOCK = NONE,
        ALGORITHM = INPLACE,
		ADD COLUMN calculatedPurchasePlusTotal decimal(19,2),
		ADD COLUMN calculatedOtherDiscountTotal decimal(19,2),
		ADD COLUMN calculatedAppliedPromotionMessagesJson text,
		ADD COLUMN calculatedRecalculationCacheKey varchar(32);
	</cfquery>

	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Add Order Template calculated properties 2 #serializeJson(cfcatch.detail)#">
    	<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script Add Order Template calculated properties 2 had errors when running">
	<cfthrow detail="Part of Script Add Order Template calculated properties 2 had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script has run with no errors">
</cfif>
