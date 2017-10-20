<cfparam name="this.ormSettings.dialect" />
<cfparam name="this.datasource.name" />
<cfparam name="this.datasource.username" default="" />
<cfparam name="this.datasource.password" default="" />

<cfsetting requesttimeout="1200" />
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
				SELECT max(orderNumber),orderID FROM swOrder
			</cfquery>
		</cfif>
	</cfif>
	<cfdbinfo datasource="#this.datasource.name#" username="#this.datasource.username#" password="#this.datasource.password#" type="columns" table="SwOrderNumber" name="swOrderNumberInfo" pattern="orderNumber" />
	<cfif !swOrderNumberInfo.is_PrimaryKey && !swOrderNumberInfo.is_AutoIncrement> 
		<!--- remove dupes and enforce incrementing going forward--->
		<cfquery datasource="#this.datasource.name#" name="cleardupes">
			ALTER IGNORE TABLE SwOrderNumber MODIFY COLUMN orderNumber INT NOT NULL auto_increment PRIMARY KEY
		</cfquery>
	</cfif>
</cfif>

<cflog file="Slatwall" text="General Log - Preupdate Script v5_1 has run with no errors">