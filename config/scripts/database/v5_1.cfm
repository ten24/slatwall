

<cfsetting requesttimeout="1200" />

<cfset local.scriptHasErrors = false />


<cftry>
	<cfif ListFind(getApplicationValue("databaseType"), 'MySQL')>
		<cfdbinfo datasource="#getApplicationValue("datasource")#" username="#getApplicationValue("datasourceUsername")#" password="#getApplicationValue("datasourcePassword")#" type="tables" name="currenttables" pattern="swordernumber" />
		
		<cfif !currenttables.recordCount>
			<cfdbinfo datasource="#getApplicationValue("datasource")#" username="#getApplicationValue("datasourceUsername")#" password="#getApplicationValue("datasourcePassword")#" type="tables" name="hasOrderTable" pattern="sworder" />
			<cfset lastValue = 1/>
			<cfif hasOrderTable.recordCount>
				<cfquery  name="insertOrderNumbers">
					SELECT max(CAST(orderNumber AS UNSIGNED)) as maximumvalue FROM sworder
				</cfquery>
				<cfif structKeyExists(insertOrderNumbers,'maximumvalue') && isNumeric(insertOrderNumbers.maximumvalue)>
					<cfset lastValue = insertOrderNumbers.maximumvalue/>
				</cfif>
			</cfif>
			<cfquery  name="createSwOrderNumber">
				CREATE TABLE swordernumber(
					orderNumber INT NOT NULL auto_increment PRIMARY KEY,
					orderID VARCHAR(32),
					createdDateTime TIMESTAMP
				);
				
			</cfquery>
			<cfquery  name="setIncrementSwOrderNumber">
				ALTER TABLE swordernumber AUTO_INCREMENT = #lastValue+1#;
			</cfquery>
		</cfif>
		
	</cfif>
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - v5_1">
		<cfset local.scriptHasErrors = true />
		<cflog file="application" text="General Log - #cfcatch.message#">
	</cfcatch>


</cftry>

<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script v5_1 had errors when running">
	<cfthrow detail="Part of Script v5_1 had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script v5_1 has run with no errors">
</cfif>

