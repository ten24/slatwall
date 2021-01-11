<cfset local.scriptHasErrors = false />
<cftry>
    <cfquery name="local.updateOrder">
        
        ALTER TABLE SwOrder
            LOCK=NONE,
            ALGORITHM=INPLACE,
            ADD COLUMN taxTransactionReferenceNumber varchar(255);
          
	</cfquery>
    <cfcatch >
        <cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update Order tax transaction ref (#cfcatch.detail#)">
    	<cfset local.scriptHasErrors = true />
    </cfcatch>
</cftry>

<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script ordertaxtransref had errors when running">
	<cfthrow detail="Part of Script ordertaxtransref had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script ordertaxtransref has run with no errors">
</cfif>