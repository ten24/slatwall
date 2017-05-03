<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC
	
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
	
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
	
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
	
    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your 
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms 
    of your choice, provided that you follow these specific guidelines: 

	- You also meet the terms and conditions of the license of each 
	  independent module 
	- You must not alter the default display of the Slatwall name or logo from  
	  any part of the application 
	- Your custom code must not alter or create any files inside Slatwall, 
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets 
	the above guidelines as a combined work under the terms of GPL for this program, 
	provided that you include the source code of that other code when and as the 
	GNU GPL requires distribution of source code.
    
    If you modify this program, you may extend this exception to your version 
    of the program, but you are not obligated to do so.

Notes:

--->

<cfset local.scriptHasErrors = false />

<!--- Foreign Key Index Creation --->
<cftry>
	<cfif getHibachiScope().getApplicationValue('databaseType') EQ "MicrosoftSQLServer">
		<cfset local.qrs = "" />
		<cfset local.infoTables = "" />
		<cfset local.infoColumns = "" />
		<cfset local.infoIndexes = "" />

		<cfdbinfo datasource="#getApplicationValue("datasource")#" username="#getApplicationValue("datasourceUsername")#" password="#getApplicationValue("datasourcePassword")#" type="tables" name="infoTables" pattern="Sw%" />
		<cfloop query="infoTables">
			<cfdbinfo datasource="#getApplicationValue("datasource")#" username="#getApplicationValue("datasourceUsername")#" password="#getApplicationValue("datasourcePassword")#" type="Columns" table="#infoTables.table_name#" name="infoColumns" />
			<cfdbinfo datasource="#getApplicationValue("datasource")#" username="#getApplicationValue("datasourceUsername")#" password="#getApplicationValue("datasourcePassword")#" type="Index" table="#infoTables.table_name#" name="infoIndexes" />

			<cfloop query="infoColumns">
				<cfif infoColumns.is_foreignkey>
					<cfquery name="qrs" dbtype="query">
						SELECT
							infoIndexes.column_name
						FROM
							infoIndexes
						WHERE
							LOWER(infoIndexes.column_name) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCASE(infoColumns.column_name)#">
					</cfquery>
					<cfif not qrs.recordCount>
						<cfquery name="createIndex">
							CREATE INDEX FK_#UCASE(right(hash(infoTables.table_name & infoColumns.column_name), 27))# ON #infoTables.table_name# ( #infoColumns.column_name# )
						</cfquery>
					</cfif>
				</cfif>
			</cfloop>
		</cfloop>
	</cfif>
	<cfcatch>
		<cflog file="Slatwall" text="ERROR in Foreign Key index creation : #cfcatch.Detail#">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>


<!--- INDEX to inforce SlatwallStock has unique Sku & Location combo --->
<cftry>
	<cfdbinfo type="Index" name="dbiSkuLocation" table="SwStock">
	<cfquery name="indexExists" dbtype="query">
		SELECT
			*
		FROM
			dbiSkuLocation
		WHERE
			INDEX_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SkuLocation">
	</cfquery>
	
	<cfif not indexExists.recordcount>
		<cfquery name="createIndex">
			CREATE UNIQUE INDEX SkuLocation ON SwStock (locationID,skuID)
		</cfquery>
	</cfif>
	<cfcatch>
		<cflog file="Slatwall" text="ERROR in SkuLocation Unique index creation">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>

<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of index creation script had errors when running">
	<cfthrow detail="Part of Script v3_0 had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Index creation script ran with no errors">
</cfif>



