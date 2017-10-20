

<cfsetting requesttimeout="1200" />
<cfif ListFind(getApplicationValue("databaseType"), 'MySQL')>
	<cfdbinfo datasource="#getApplicationValue("datasource")#" username="#getApplicationValue("datasourceUsername")#" password="#getApplicationValue("datasourcePassword")#" type="tables" name="currenttables" pattern="SwOrderNumber" />
	
	<cfif !currenttables.recordCount>
		<cfdbinfo datasource="#getApplicationValue("datasource")#" username="#getApplicationValue("datasourceUsername")#" password="#getApplicationValue("datasourcePassword")#" type="tables" name="hasOrderTable" pattern="SwOrder" />
		<cfset lastValue = 1/>
		<cfif hasOrderTable.recordCount>
			<cfquery  name="insertOrderNumbers">
				SELECT max(orderNumber) as maximumvalue FROM swOrder
			</cfquery>
			<cfif isNumeric(insertOrderNumbers.maximumvalue)>
				<cfset lastValue = insertOrderNumbers.maximumvalue/>
			</cfif>
		</cfif>
		<cfquery  name="createSwOrderNumber">
			CREATE TABLE SwOrderNumber(
				orderNumber INT NOT NULL auto_increment PRIMARY KEY,
				orderID VARCHAR(32),
				createdDateTime TIMESTAMP
			);
			
		</cfquery>
		<cfquery  name="setIncrementSwOrderNumber">
			ALTER TABLE swOrderNumber AUTO_INCREMENT = #lastValue+1#;
		</cfquery>
	</cfif>
	
</cfif>

<cflog file="Slatwall" text="General Log - Preupdate Script v5_1 has run with no errors">