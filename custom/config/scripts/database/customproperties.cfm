<cfset local.scriptHasErrors = false />

<cftry>
    <cfquery name="local.updateCalculatedProperties">
        
        ALTER TABLE SwOrderItem 
            LOCK=NONE,
            ALGORITHM=INPLACE,
            ADD COLUMN calculatedQuantityDelivered int(11);
          
	</cfquery>
    <cfcatch >
        <cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update Calculated Properties (#cfcatch.detail#)">
    	<cfset local.scriptHasErrors = true />
    </cfcatch>
</cftry>

<cftry>
    <cfquery name="local.updateAccountGovernmentIdentification">
        
        ALTER TABLE SwAccountGovernmentId
            LOCK=NONE,
            ALGORITHM=INPLACE,
            ADD COLUMN governmentIdNumberHashed string;
          
	</cfquery>
    <cfcatch >
        <cflog file="Slatwall" text="ERROR UPDATE Custom Properties SCRIPT - Update Account-Government-Identification (#cfcatch.detail#)">
    	<cfset local.scriptHasErrors = true />
    </cfcatch>
</cftry>

<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script Update Custom Properties SCRIPT had errors when running">
	<cfthrow detail="Part of Script Update Custom Properties had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script Database Columns for Update Custom Properties has run with no errors">
</cfif>
