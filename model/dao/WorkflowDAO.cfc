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
		<cfreturn ORMExecuteQuery('SELECT triggerEvent 
									FROM SlatwallWorkflowTrigger 
									where triggerType = :triggerType'
									,{triggerType="Event"}) 
									/>
	</cffunction>
	
	<cffunction name="getWorkflowTriggersForEvent" returnType="array" access="public">
		<cfargument name="eventName" type="string" required="true" />
		
		<!--- TODO: This needs to query DB and return an array of workflowTrigger objects with workflows and tasks fetched for performance
		but it should only be unique workflows that have a workflowTrigger with the eventName passed in --->
		<cfreturn ORMExecuteQuery('FROM SlatwallWorkflowTrigger where triggerEvent = :triggerEvent',{triggerEvent=arguments.eventName})/>
	</cffunction>
	
</cfcomponent>

