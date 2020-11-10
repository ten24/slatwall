<cfset local.scriptHasErrors = false />
<cftry>
    <cfquery name="local.promoReward">
        
       ALTER TABLE swpromoreward
        LOCK=NONE,
        ALGORITHM=INPLACE,
        ADD COLUMN title varchar(255),
        ADD COLUMN rewardHeader varchar(255),
        ADD COLUMN description varchar(1000);
          
	</cfquery>
    <cfcatch >
        <cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update Promo Reward Fields (#cfcatch.detail#)">
    	<cfset local.scriptHasErrors = true />
    </cfcatch>
</cftry>

<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script promorewardextrafields had errors when running">
	<cfthrow detail="Part of Script promorewardextrafields had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script promorewardextrafields has run with no errors">
</cfif>