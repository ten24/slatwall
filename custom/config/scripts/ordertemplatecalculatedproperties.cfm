<cfset local.scriptHasErrors = false />

<cftry>
	<cfquery name="local.addColumnsToOrderTemplate">
		ALTER TABLE swOrderTemplate
		LOCK = NONE,
        ALGORITHM = INPLACE,
		ADD COLUMN calculatedCommissionableVolumeTotal INTEGER,
		ADD COLUMN calculatedPersonalVolumeTotal INTEGER;
	</cfquery>

	<cfquery name="local.addColumnsToOrderTemplateItem">
		ALTER TABLE swOrderTemplateItem
		LOCK = NONE,
        ALGORITHM = INPLACE,
		ADD COLUMN calculatedCommissionableVolumeTotal INTEGER,
		ADD COLUMN calculatedPersonalVolumeTotal INTEGER,
		ADD COLUMN calculatedTotal DECIMAL(19,2);
	</cfquery>	

	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Add Order Template calculated properties">
    	<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script Add Order Template calculated properties had errors when running">
	<cfthrow detail="Part of Script Add Order Template calculated properties had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script has run with no errors">
</cfif>
