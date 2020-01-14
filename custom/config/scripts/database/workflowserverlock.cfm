<cfset local.scriptHasErrors = false />

<cftry>
    <cfquery name="local.workflowUpdates">
        SET foreign_key_checks=OFF;
        
        ALTER TABLE swentityqueue 
            LOCK=NONE,
            ALGORITHM=INPLACE,
            ADD COLUMN serverInstanceID varchar(32) DEFAULT NULL;
            
        ALTER TABLE swentityqueue 
            LOCK=NONE,
            ALGORITHM=INPLACE,
            ADD CONSTRAINT FK9718DDCAAF274AC1 FOREIGN KEY (serverInstanceID) REFERENCES swserverinstance (serverInstanceID);
            
        ALTER TABLE swworkflowtrigger 
            LOCK=NONE,
            ALGORITHM=INPLACE,
            ADD COLUMN lockLevel varchar(255) DEFAULT NULL;
            
            
        ALTER TABLE swworkflowtriggerhistory 
            LOCK=NONE,
            ALGORITHM=INPLACE,
            ADD COLUMN serverInstanceID varchar(32) DEFAULT NULL;
            
        ALTER TABLE swworkflowtriggerhistory 
            LOCK=NONE,
            ALGORITHM=INPLACE,
            ADD CONSTRAINT FK70EEACFFAF274AC1 FOREIGN KEY (serverInstanceID) REFERENCES swserverinstance (serverInstanceID);
        
        SET foreign_key_checks=ON;
        
	</cfquery>
    <cfcatch >
        <cfquery name="local.reEnableForeignKeyCheck">
            SET foreign_key_checks=ON;
        </cfquery>
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
