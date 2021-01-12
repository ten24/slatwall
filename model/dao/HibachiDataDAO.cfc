/*

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

*/
<cfcomponent extends="Slatwall.org.Hibachi.HibachiDataDAO">

    <cffunction name="createApiLog" returntype="any" access="public">
		<cfargument name="requestIdentifier" type="string" required="true" />
		<cfargument name="apiLogType" type="string" required="true" />
		<cfargument name="targetUrl" type="string" required="true" />
		<cfargument name="data" type="string" required="true" />
		<cfargument name="header" type="string" required="true" />
		
		<cfargument name="source" type="string" />
		<cfargument name="response" type="string"/>
		<cfargument name="statusCode" type="numeric" />
		<cfargument name="responseTime" type="numeric" />
		
		<cfset var rs = "" />
		
		<cfquery name="rs" result="local.createApiLog">
			INSERT INTO swApiLog ( 
				apiLogID,
				requestIdentifier, 
				apiLogType, 
				source, 
				targetUrl, 
				data, 
				header, 
				response, 
				statusCode, 
				responseTime,
				accountID,
				createdDateTime
			) 
			VALUES 
			(
				'#createHibachiUUID()#',
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.requestIdentifier#" />, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.apiLogType#" />, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.source#" null="#!structKeyExists(arguments, 'source')#"/>, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.targetUrl#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.data#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.header#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.response#" null="#!structKeyExists(arguments, 'response')#" />,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.statusCode#" null="#!structKeyExists(arguments, 'statusCode')#" />,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.responseTime#" null="#!structKeyExists(arguments, 'responseTime')#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#getHibachiScope().getAccount().getAccountID()#" null="#getHibachiScope().getAccount().getNewFlag()#" />,
			    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#" />
			)
		</cfquery>
	</cffunction>
	
	
	<cffunction name="deleteStaleData" returntype="any" access="public">
		<cfargument name="tableName" type="string" required="true" />
		<cfargument name="olderThanDate" type="datetime" required="true" />

		<cfset var rs = "" />
		<cfquery name="rs" result="local.deleteOldApiLogs">
			DELETE FROM #tableName#  WHERE createdDateTime < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.olderThanDate#" />
		</cfquery>
	</cffunction>
	
</cfcomponent>