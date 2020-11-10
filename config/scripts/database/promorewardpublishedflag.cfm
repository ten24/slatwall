<cfset local.scriptHasErrors = false />
<cftry>
    <cfquery name="local.publishReward">
        
        ALTER TABLE SwPromoReward
            LOCK=NONE,
            ALGORITHM=INPLACE,
            ADD COLUMN publishedFlag boolean;
          
	</cfquery>
	<cfquery name="local.setPublishReward">
        
        UPDATE SwPromoReward
            SET publishedFlag = false
            WHERE publishedFlag IS NULL;
          
	</cfquery>
    <cfcatch >
        <cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Add PromoReward publishedFlag (#cfcatch.detail#)">
    	<cfset local.scriptHasErrors = true />
    </cfcatch>
</cftry>

<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script promorewardpublishedflag had errors when running">
	<cfthrow detail="Part of Script promorewardpublishedflag had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script promorewardpublishedflag has run with no errors">
</cfif>