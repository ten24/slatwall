<cfparam name="this.ormSettings.dialect" />
<cfparam name="this.datasource.name" />
<cfparam name="this.datasource.username" default="" />
<cfparam name="this.datasource.password" default="" />

<cfsetting requesttimeout="1200" />
<cfset local.scriptHasErrors = false />

<cftry>
	<cfif ListFind(this.ormSettings.dialect, 'MySQL')>
		<cfdbinfo datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#" type="tables" name="currenttables" pattern="SwOrderNumber" />
		
		<cfif !currenttables.recordCount>
			<cfquery datasource="#this.datasource.name#" name="createSwOrderNumber">
				CREATE TABLE SwOrderNumber(
					orderNumber int ,
					orderID VARCHAR(32),
					createdDateTime TIMESTAMP
				);
			</cfquery>
		</cfif>
		
		<cfdbinfo datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#" type="tables" name="currenttables" pattern="SwOrderNumber" />
		<cfif currenttables.recordCount>
			<!--- add all records --->
			<cfdbinfo datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#" type="tables" name="currenttables" pattern="SwOrder" />
			<cfif currenttables.recordCount>
				<cfquery datasource="#this.datasource.name#" name="insertOrderNumbers">
					INSERT INTO SwOrderNumber (orderNumber,orderID)
					SELECT orderNumber,orderID FROM swOrder where orderNumber is not null order by orderNumber ASC
				</cfquery>
			</cfif>
			<!--- remove dupes and enforce incrementing going forward--->
			<cfquery datasource="#this.datasource.name#" name="cleardupes">
				ALTER IGNORE TABLE SwOrderNumber MODIFY COLUMN orderNumber INT NOT NULL auto_increment PRIMARY KEY
			</cfquery>
		</cfif>
		
	</cfif>
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - ">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>
<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Preupdate Script v5_1 has run with no errors">
	<cfthrow detail="Part of Script v5_1 had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script v5_1 has run with no errors">
</cfif>

