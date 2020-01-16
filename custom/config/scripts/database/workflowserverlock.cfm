<cfset local.scriptHasErrors = false />

<cftry>
    <cfquery name="local.workflowUpdates">
        
        ALTER TABLE swentityqueue 
            LOCK=NONE,
            ALGORITHM=INPLACE,
            ADD COLUMN serverInstanceKey varchar(36) DEFAULT NULL;
            
            
        ALTER TABLE swworkflowtrigger 
            LOCK=NONE,
            ALGORITHM=INPLACE,
            ADD COLUMN lockLevel varchar(50) DEFAULT NULL;
            
            
        ALTER TABLE swworkflowtriggerhistory 
            LOCK=NONE,
            ALGORITHM=INPLACE,
            ADD COLUMN serverInstanceKey varchar(36) DEFAULT NULL;
        
	</cfquery>
    <cfcatch >
        <cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Workflow Server Lock (#cfcatch.detail#)">
    	<cfset local.scriptHasErrors = true />
    </cfcatch>
</cftry>

<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script promoqualifiermessage had errors when running">
	<cfthrow detail="Part of Script workflowserverlock had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script workflowserverlock has run with no errors">
</cfif>
