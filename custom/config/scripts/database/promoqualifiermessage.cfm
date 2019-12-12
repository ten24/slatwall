<cfset local.scriptHasErrors = false />

<cftry>
    <cfquery name="local.qualMSg">
        CREATE TABLE swpromoqualmessage(
        	promotionQualifierMessageID varchar(32),
        	message varchar(2000),
        	promotionQualifierID varchar(32),
        	PRIMARY KEY (promotionQualifierMessageID),
        	FOREIGN KEY (promotionQualifierID)
        		REFERENCES swpromoqual(promotionQualifierID)
        )
	</cfquery>
    <cfcatch>
        <cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Create Promo Qualifier Message">
    	<cfset local.scriptHasErrors = true />
    </cfcatch>
</cftry>

<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script promoqualifiermessage had errors when running">
	<cfthrow detail="Part of Script promoqualifiermessage had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script promoqualifiermessage has run with no errors">
</cfif>
