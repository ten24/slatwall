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

<cftry>
    <cfquery name="local.updateOrderItem">
        
        ALTER TABLE SwOrderItem 
            LOCK=NONE,
            ALGORITHM=INPLACE,
            ADD COLUMN userDefinedPriceFlag BIT;
          
	</cfquery>
    <cfcatch >
        <cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update OrderItem Component (#cfcatch.detail#)">
    	<cfset local.scriptHasErrors = true />
    </cfcatch>
</cftry>

<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script AddNewCoreProperties had errors when running">
	<cfthrow detail="Part of Script AddNewCoreProperties had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script AddNewCoreProperties has run with no errors">
</cfif>