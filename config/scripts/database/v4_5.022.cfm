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
<cfparam name="this.ormSettings.dialect" default="#getHibachiScope().getApplicationValue('databaseType')#" />

<cftry>
	<cfif this.ormSettings.dialect eq 'MicrosoftSQLServer'>
		<cfquery name="local.updateAddress">
			UPDATE swAddress set calculatedAddressName = STUFF(
			    (
			      SELECT ', ' + v
			      FROM (VALUES (streetAddress), (street2Address), (city), (stateCode), (postalCode), (countryCode)) AS v (v)
			      FOR XML PATH (''), TYPE
			    ).value('.[1]', 'varchar(max)'),
			    1, 2, ''
			  )
		</cfquery>
	<cfelseif ListFind(this.ormSettings.dialect, 'MySQL')>
		<cfquery name="local.updateAddress">
			UPDATE SwAddress set calculatedAddressName = CONCAT_WS(', ',streetAddress,street2Address,city,stateCode,postalCode,countryCode)
		</cfquery>
	<cfelseif this.ormSettings.dialect eq 'Oracle10g'>
		<cfquery name="local.getAddress">
			select addressID,streetAddress,street2Address,city,stateCode,postalCode,countryCode from SwAddress
		</cfquery>
	
		<cfloop query="local.getAddress">
				
			<cfscript>
				local.name = "";
				if( len(local.getAddress.StreetAddress) ) {
					local.name =  listAppend(local.name, " #local.getAddress.StreetAddress#" );
				}
				if( len(local.getAddress.Street2Address) ) {
					local.name = listAppend(local.name, " #local.getAddress.Street2Address#" );
				}
				if( len(local.getAddress.city) ) {
					local.name = listAppend(local.name, " #local.getAddress.city#" );
				}
				if( len(local.getAddress.statecode) ) {
					local.name = listAppend(local.name, " #local.getAddress.StateCode#" );
				}
				if( len(local.getAddress.postalCode) ) {
					local.name = listAppend(local.name, " #local.getAddress.postalCode#" );
				}
				if( len(local.getAddress.countryCode) ) {
					local.name = listAppend(local.name, " #local.getAddress.countryCode#" );
				}
			</cfscript>
			<cfquery name="local.updateAddress">
				update SwAddress
				set calculatedAddressName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.name#" />
				where addressID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.getAddress.addressID#" />
			</cfquery>
				
		</cfloop>
	</cfif>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update Address">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
</cftry>
<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script v4_5.022 had errors when running">
	<cfthrow detail="Part of Script v4_5.022 had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script v4_5.022 has run with no errors">
</cfif>
