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

<!--- Update SwContent create materialized paths for title called titlePath based on existing title --->
<cftry>
		
	<cffunction name="getTitleFromParent">
		<cfargument name="titlePath">
		<cfargument name="contentQuery">
		<cfargument name="contentRecord">
		<!--- process title --->
		<cfquery name="local.parentContentRecord" dbtype="query">
			SELECT * FROM arguments.contentQuery where contentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentRecord.parentContentID#">
		</cfquery>
		
		<cfif !isnull(arguments.contentRecord.parentContentID) && len(arguments.contentRecord.parentContentID)>
			<cfset arguments.titlePath = local.parentContentRecord.title & ' > ' & arguments.titlePath />
			<cfset arguments.titlePath = getTitleFromParent(arguments.titlePath,arguments.contentQuery,local.parentContentRecord)>
		</cfif>
		
		<cfreturn arguments.titlePath />
	</cffunction>
		
	<cfquery name="local.getContent">
		SELECT title,parentContentID,contentID FROM SwContent
	</cfquery>
			
	<cfloop query="local.getContent">
		<cfset local.titlePath = title>
		<cfif !isnull(local.getContent.parentContentID) && len(local.getContent.parentContentID)>
			
			<cfset local.record = {
				parentContentID=local.getContent.parentContentID,
				contentID=local.getContent.contentID,
				title=local.getContent.title
			}>
			<cfset local.titlePath = getTitleFromParent(local.titlePath,local.getContent,local.record)>
			
		</cfif>
		<cfquery name="local.updateContent">
			UPDATE SwContent SET titlePath = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.titlePath#"> WHERE contentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.getContent.contentID#">
		</cfquery>
	</cfloop>	

	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update site to set sitecode to siteID">
		<cfset local.scriptHasErrors = true />
	</cfcatch>


</cftry>


<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script v4_1 had errors when running">
	<cfthrow detail="Part of Script v4_1 had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script v4_1 has run with no errors">
</cfif>