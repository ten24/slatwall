<cfset local.scriptHasErrors = false />

<cftry>
    <cfquery name="local.updateAccountPaymentMethod">
        
        ALTER TABLE SwAccountPaymentMethod 
            LOCK=NONE,
            ALGORITHM=INPLACE,
            ADD COLUMN lastExpirationUpdateAttemptDateTime datetime;
          
	</cfquery>
    <cfcatch >
        <cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update Account Payment Method Component (#cfcatch.detail#)">
    	<cfset local.scriptHasErrors = true />
    </cfcatch>
</cftry>

<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script Update Account Payment Method had errors when running">
	<cfthrow detail="Part of Script Update Account Payment Method had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script Database Columns for Account Payment Method has run with no errors">
</cfif>