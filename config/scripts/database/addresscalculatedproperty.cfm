<cfset local.scriptHasErrors = false />

<cftry>
    <cfquery name="local.alterAddress">
        
        ALTER TABLE swaddress
        LOCK=NONE,
        ALGORITHM=INPLACE,
        CHANGE calculatedAddressName addressName varchar(1024);
          
	</cfquery>
    <cfcatch >
        <cflog file="Slatwall" text="ERROR UPDATE SCRIPT - SwAddress Change AddressName (#cfcatch.detail#)">
    	<cfset local.scriptHasErrors = true />
    </cfcatch>
</cftry>

<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script Update Custom Properties SCRIPT had errors when running">
	<cfthrow detail="Part of Script Update Custom Properties had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script Database Columns for Update Custom Properties has run with no errors">
</cfif>
