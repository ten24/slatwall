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
	
	<cffunction name="getShortReferenceID" returntype="any" access="public" output="false">
		<cfargument name="referenceObjectID" type="string" required="true" />
		<cfargument name="referenceObject" type="string" required="true" />
		<cfargument name="createNewFlag" type="boolean" default="false" />
		
		<cfset var shortReferenceID = "" />
		
		<!--- If we can't use cftransaction, then use a lock (this will breakdown on multi-server setup with high load) --->
		<cfif getHibachiScope().getOrmHasErrors()>
			<cflock timeout="30" name="#arguments.referenceObject##arguments.referenceObjectID##arguments.createNewFlag#">
				<cfset var shortReferenceID = selectOrGenerateShortReferenceID(argumentcollection=arguments) />	
			</cflock>
			
		<!--- We call the function in a serializable transaction so that a new one can be created one at a time if needed --->
		<cfelse>
			<cftransaction isolation="read_committed">
				<cfset var shortReferenceID = selectOrGenerateShortReferenceID(argumentcollection=arguments) />
			</cftransaction>
		</cfif>
		
		<cfreturn shortReferenceID />
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
	
	
	<!--- PRIVATE HELPER FUNCTIONS --->
	
	<cffunction name="selectOrGenerateShortReferenceID" returntype="any" access="private">
		<cfargument name="referenceObjectID" type="string" required="true" />
		<cfargument name="referenceObject" type="string" required="true" />
		<cfargument name="createNewFlag" type="boolean" default="false" />
		
		<cfset var rs = "" />
		<cfset var rsResult = "" />
		
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
			
			<!--- If we can't use cftransaction, then use a lock (this will breakdown on multi-server setup with high load) --->
			<cfif getHibachiScope().getOrmHasErrors()>
				
				<cflock timeout="30" name="SlatwallShortReferenceAdd">
					<cfset newShortReferenceID = generateShortReferenceID(argumentcollection=arguments) />	
				</cflock>
				
			<!--- No Need for aditional transaction because we are already in one --->
			<cfelse>
			
				<cfset newShortReferenceID = generateShortReferenceID(argumentcollection=arguments) />
				
			</cfif>
			
			<cfreturn newShortReferenceID />
		</cfif>
		
		<cfreturn "" />
	</cffunction>
	
	<cffunction name="generateShortReferenceID" returntype="any" access="private">
		<cfargument name="referenceObjectID" type="string" required="true" />
		<cfargument name="referenceObject" type="string" required="true" />
		
		<cfset var rs = "" />
		<cfset var newShortReferenceID = 1 />
			
		<cfquery name="rs">
			SELECT MAX(shortReferenceID) as shortReferenceID FROM SwShortReference
		</cfquery>
		
		<cfif rs.shortReferenceID neq "" and isNumeric(rs.shortReferenceID)>
			<cfset newShortReferenceID = rs.shortReferenceID + 1 />
		</cfif>
		
		<cfquery name="rs">
			INSERT INTO SwShortReference (shortReferenceID, referenceObjectID, referenceObject) VALUES (<cfqueryparam cfsqltype="cf_sql_integer" value="#newShortReferenceID#" />, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.referenceObjectID#" />, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.referenceObject#" />)
		</cfquery>
		
		<cfreturn newShortReferenceID />
	</cffunction>
	
</cfcomponent>
