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
<cfcomponent extends="HibachiDAO" accessors="true" output="false">
	
	<!--- This function returns all events that have been configured as workflow triggers --->
	<cffunction name="getWorkflowTriggerEventsArray" returntype="array" access="public">
		
		<!--- TODO: This needs to query DB and return an array of ALL workflow events --->
		<!--- ['onOrderSaveSuccess','onOrderProcess_placeOrderSuccess'] --->
		<cfreturn ORMExecuteQuery("SELECT wt.triggerEvent
									FROM
										SlatwallWorkflowTrigger wt
										LEFT JOIN wt.workflow w
									WHERE
										wt.triggerType = :triggerType
									AND
										w.activeFlag = 1
									GROUP BY 
										wt.triggerEvent
									"
									,{triggerType="Event"}) 
									/>
	</cffunction>
	
	<cffunction name="getWorkflowTriggersForEvent" returnType="array" access="public">
		<cfargument name="eventName" type="string" required="true" />
		
		<!--- TODO: This needs to query DB and return an array of workflowTrigger objects with workflows and tasks fetched for performance
		but it should only be unique workflows that have a workflowTrigger with the eventName passed in --->
		<cfreturn ORMExecuteQuery("
			SELECT wt FROM SlatwallWorkflowTrigger wt 
			LEFT JOIN wt.workflow w  
			WHERE wt.triggerEvent = :triggerEvent
			AND w.activeFlag = 1
			GROUP BY wt"
			,{triggerEvent=arguments.eventName}
		)/>
	</cffunction>

	<cffunction name="getRunningWorkflows" access="public" returntype="array"> 
		
		<cfreturn ORMExecuteQuery('SELECT new map(t.workflowTriggerID as workflowTriggerID, t.timeout as timeout)
								   FROM	SlatwallWorkflowTrigger t 
								   WHERE runningFlag=true') />

	</cffunction> 
	
	<cffunction name="resetExpiredWorkflows">
		<cfset var rs = "" />
		<cfquery name="rs">
			UPDATE swWorkflowTrigger 
			SET runningFlag = 0
			WHERE runningFlag=true AND DATE_ADD(nextRunDateTime, INTERVAL timeout MINUTE) < NOW()
		</cfquery>
	</cffunction>

	<cffunction name="getDueWorkflows" access="public" returntype="array">
		<cfreturn ORMExecuteQuery('FROM
										SlatwallWorkflowTrigger
									WHERE
										workflow.activeFlag = true
									AND
										triggerType = :triggerType
									AND
										(runningFlag is NULL or runningFlag = false)
									AND
										nextRunDateTime <= CURRENT_TIMESTAMP()
								',{triggerType='Schedule'})/>

	</cffunction>

	<cffunction name="updateWorkflowTriggerRunning">
		<cfargument name="workflowTriggerID" required="true" type="string" />
		<cfargument name="runningFlag" required="true" type="boolean" />
		<cfargument name="timeout" required="false" type="numeric" />

		<cfset var rs = "" />
		<cfquery name="rs">
			UPDATE SwWorkflowTrigger 
			SET runningFlag = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.runningFlag#"> 
			WHERE workflowTriggerID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.workflowTriggerID#">
			<cfif structKeyExists(arguments, "timeout")>
				AND nextRunDateTime <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateAdd('n',(-1 * arguments.timeout),now())#"> 
			</cfif> 
		</cfquery>
	</cffunction>
	
</cfcomponent>

