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
<cfcomponent extends="HibachiDAO">
	
	<cffunction name="getShortReferenceID" >
		<cfargument name="referenceObjectID" type="string" required="true" />
		<cfargument name="referenceObject" type="string" required="true" />
		<cfargument name="createNewFlag" type="boolean" default="false" />
		
		<cfset var rs = "" />
		<cfset var rsResult = "" />
		
		<cflock timeout="30" name="#arguments.referenceObject##arguments.referenceObjectID##arguments.createNewFlag#">
			<cfquery name="rs">
				SELECT
					shortReferenceID
				FROM
					SwShortReference
				WHERE
					referenceObjectID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.referenceObjectID#" />
				  AND
					referenceObject = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.referenceObject#" />
			</cfquery>
			
			<!--- If the ID Was found --->
			<cfif rs.recordCount>
				<cfreturn rs.shortReferenceID />
				
			<!--- If no record found but create new is set to yes --->
			<cfelseif arguments.createNewFlag>
				
				<cfset var newShortReferenceID = 1 />
				
				<!--- Lock this again so that only 1 can be created at a time --->
				<cflock timeout="30" name="SlatwallShortReferenceAdd">
					
					<cfquery name="rs">
						SELECT MAX(shortReferenceID) as shortReferenceID FROM SwShortReference
					</cfquery>
					
					<cfif rs.shortReferenceID neq "" and isNumeric(rs.shortReferenceID)>
						<cfset newShortReferenceID = rs.shortReferenceID + 1 />
					</cfif>
					
					<cfquery name="rs" result="rsResult">
						INSERT INTO SwShortReference (shortReferenceID, referenceObjectID, referenceObject) VALUES (<cfqueryparam cfsqltype="cf_sql_integer" value="#newShortReferenceID#" />, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.referenceObjectID#" />, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.referenceObject#" />)
					</cfquery>
					
				</cflock>
				
				<cfreturn newShortReferenceID />
			</cfif>
		</cflock>
		
		<cfreturn "" />
	</cffunction>
	
	<cffunction name="recordUpdate" returntype="void">
		<cfargument name="tableName" required="true" type="string" />
		<cfargument name="idColumns" required="true" type="string" />
		<cfargument name="updateData" required="true" type="struct" />
		<cfargument name="insertData" required="true" type="struct" />
		
		<cfset var keyList = structKeyList(arguments.updateData) />
		<cfset var rs = "" />
		<cfset var sqlResult = "" />
		<cfset var i = 0 />
		
		<cfquery name="rs" result="sqlResult">
			UPDATE
				#arguments.tableName#
			SET
				<cfloop from="1" to="#listLen(keyList)#" index="i">
					<cfif arguments.updateData[ listGetAt(keyList, i) ].value eq "NULL">
						#listGetAt(keyList, i)# = <cfqueryparam cfsqltype="cf_sql_#arguments.updateData[ listGetAt(keyList, i) ].dataType#" value="" null="yes">
					<cfelse>
						#listGetAt(keyList, i)# = <cfqueryparam cfsqltype="cf_sql_#arguments.updateData[ listGetAt(keyList, i) ].dataType#" value="#arguments.updateData[ listGetAt(keyList, i) ].value#">
					</cfif>
					<cfif listLen(keyList) gt i>, </cfif>
				</cfloop>
			WHERE
				<cfloop from="1" to="#listLen(arguments.idColumns)#" index="i">
					#listGetAt(arguments.idColumns, i)# = <cfqueryparam cfsqltype="cf_sql_#arguments.updateData[ listGetAt(arguments.idColumns, i) ].datatype#" value="#arguments.updateData[ listGetAt(arguments.idColumns, i) ].value#">
					<cfif listLen(arguments.idColumns) gt i>AND </cfif>
				</cfloop>
		</cfquery>
		<cfif !sqlResult.recordCount>
			<cfset recordInsert(tableName=arguments.tableName, insertData=arguments.insertData) />
		</cfif>
	</cffunction>
	
	<cffunction name="recordInsert" returntype="void">
		<cfargument name="tableName" required="true" type="string" />
		<cfargument name="insertData" required="true" type="struct" />
		
		<cfset var keyList = structKeyList(arguments.insertData) />
		<cfset var keyListOracle = keyList />
		<cfset var rs = "" />
		<cfset var sqlResult = "" />
		<cfset var i = 0 />
		
		<cfquery name="rs" result="sqlResult"> 
			INSERT INTO	#arguments.tableName# (
				<cfif getApplicationValue("databaseType") eq "Oracle10g" AND listFindNoCase(keyListOracle,'type')>#listSetAt(keyListOracle,listFindNoCase(keyListOracle,'type'),'"type"')#<cfelse>#keyList#</cfif>
			) VALUES (
				<cfloop from="1" to="#listLen(keyList)#" index="i">
					<cfif arguments.insertData[ listGetAt(keyList, i) ].value eq "NULL">
						<cfqueryparam cfsqltype="cf_sql_#arguments.insertData[ listGetAt(keyList, i) ].dataType#" value="" null="yes">
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_#arguments.insertData[ listGetAt(keyList, i) ].dataType#" value="#arguments.insertData[ listGetAt(keyList, i) ].value#">
					</cfif>
					<cfif listLen(keyList) gt i>,</cfif>
				</cfloop>
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="verifyUniqueTableValue" returntype="boolean">
		<cfargument name="tableName" type="string" required="true" />
		<cfargument name="column" type="string" required="true" />
		<cfargument name="value" type="string" required="true" />
		
		<cfset var rs="" />
		
		<cfquery name="rs">
			SELECT #arguments.column# FROM #arguments.tableName# WHERE #arguments.column# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.value#" /> 
		</cfquery>
		
		<cfif rs.recordCount>
			<cfreturn false />
		</cfif>
		
		<cfreturn true />
	</cffunction>
		
	<cffunction name="getInsertedDataFile">
		<cfset var returnFile = "" />
		
		<cfset var filePath = expandPath('/Slatwall/custom/config/') & 'insertedData.txt.cfm' />
		
		<cfif !fileExists(filePath)>
			<cffile action="write" file="#filePath#" output="" addnewline="false" /> 
		</cfif>
		
		<cffile action="read" file="#filePath#" variable="returnFile" >
		
		<cfreturn returnFile />
	</cffunction>
	
	<cffunction name="updateInsertedDataFile">
		<cfargument name="idKey" type="string" required="true" />
		
		<cfset var filePath = expandPath('/Slatwall/custom/config/') & 'insertedData.txt.cfm' />
		
		<cffile action="append" file="#filePath#" output=",#arguments.idKey#" addnewline="false" />
	</cffunction>
	
</cfcomponent>
