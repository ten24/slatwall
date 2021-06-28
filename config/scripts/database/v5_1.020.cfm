

<cfsetting requesttimeout="1200" />

<cfset local.scriptHasErrors = false />

<cftry>
	<cfif ListFind(getApplicationValue("databaseType"), 'MySQL')>
		<cfquery name="createCalculatedOptionsHash">
			UPDATE swSku t2,
			(   
			    SELECT s.skuID,MD5(GROUP_CONCAT(distinct(o.optionID) ORDER BY o.optionID)) as optionsHash FROM swsku s
			    inner join SwSkuOption so on so.skuid = s.skuid
			    inner join swoption o on o.optionID=so.optionID
			    group by s.skuID
			    order by o.optionID
			    
			) t1
			SET t2.calculatedOptionsHash = t1.optionsHash
			WHERE t1.skuID = t2.skuID
		</cfquery>
	</cfif>
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - v5_1.020">
		<cfset local.scriptHasErrors = true />
		<cflog file="application" text="General Log - #cfcatch.message#">
	</cfcatch>


</cftry>


<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script v5_1.020 had errors when running">
	<cfthrow detail="Part of Script v5_1.020 had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script v5_1.020 has run with no errors">
</cfif>

