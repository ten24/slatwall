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


<cftry>
  <!--- Get All Existing Event Triggers --->
	<cfquery name="local.eventTriggers">
		SELECT * FROM SwEventTrigger
	</cfquery>
	
  <!--- Loop over the existing Event Triggers --->
  <cfloop query="local.eventTriggers">

    <!--- If old default order confirmation trigger --->
    <cfif local.eventTriggers.eventTriggerID eq "7d4a464cb2e95da8421c15da9bd6f5e8">
      
      <!--- Set Send Order Confirmation When Placed to inactive because we migrated one. This will not happen on fresh installs---> 
      <cfquery name='local.update'>
          UPDATE SwWorkflow 
          SET activeFlag = 0,
          workflowName = CONCAT(workflowName,'- replaced by migrated event trigger')
          WHERE workflowID = 'c74704ef385a4ad1949b554086fcd80b'
      </cfquery>

    <!--- If old default order delivery confirmation trigger --->
    <cfelseif local.eventTriggers.eventTriggerID eq '7d4a464dcd702f7fb37ef7d4b3356c3e'>

      
      <!--- Set Send Order Confirmation When Placed to inactive because we migrated one. This will not happen on fresh installs---> 
      <cfquery name='local.update'>
          UPDATE SwWorkflow 
          SET activeFlag = 0,
          workflowName = CONCAT(workflowName,'- replaced by migrated event trigger')
          WHERE workflowID = '46d8e458b7dd4aa9876ce62b33e9e43f'
      </cfquery>
	</cfif>
	<cfset insertWorkflowByEventTrigger(
      	local.eventTriggers.eventTriggerName,
      	local.eventTriggers.eventTriggerObject,
      	local.eventTriggers.eventName,
      	local.eventTriggers.emailTemplateID,
      	local.eventTriggers.printTemplateID,
      	local.eventTriggers.eventTriggerType
      )/>
  </cfloop>

	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update EventTriggers to be Workflows">
		<cfset local.scriptHasErrors = true />
	</cfcatch>


</cftry>

<cffunction name="insertWorkflowByEventTrigger">
	<cfargument name="eventTriggerName"/>
	<cfargument name="eventTriggerObject"/>
	<cfargument name="eventName"/>
	<cfargument name="emailTemplateID"/>
	<cfargument name="printTemplateID"/>
	<cfargument name="eventTriggerType"/>
	  <cfset local.workflowID = replace(lcase(createUUID()), '-', '', 'all') />
	  <cfset local.workflowTriggerID = replace(lcase(createUUID()), '-', '', 'all') />
	  <cfset local.workflowTaskID = replace(lcase(createUUID()), '-', '', 'all') />
	  <cfset local.workflowTaskActionID = replace(lcase(createUUID()), '-', '', 'all') />
	
	  <!--- Create Workflow --->
	  <cfquery name='local.insert'>
	    INSERT INTO SwWorkflow (workflowID, activeFlag, workflowName, workflowObject) VALUES ('#local.workflowID#', 1, 'Event Trigger - #arguments.eventTriggerName#', '#arguments.eventTriggerObject#')
	  </cfquery>
	
	  <!--- Create Workflow Trigger --->
	  <cfquery name='local.insert'>
	    INSERT INTO SwWorkflowTrigger (workflowTriggerID, triggerType, triggerEvent, startDateTime, workflowID) VALUES ('#local.workflowTriggerID#', 'Event', '#arguments.eventName#', '2016-01-01 12:00:00', '#local.workflowID#')
	  </cfquery>
	
	  <!--- Create Workflow Task --->
	  <cfquery name='local.insert'>
	    INSERT INTO SwWorkflowTask (workflowTaskID, activeFlag, taskName, taskConditionsConfig, workflowID) VALUES ('#local.workflowTaskID#', 1, '#arguments.eventTriggerName#', '{"filterGroups":[{"filterGroup":[]}],"baseEntityAlias":"#arguments.eventTriggerObject#","baseEntityName":"#arguments.eventTriggerObject#"}', '#local.workflowID#')
	  </cfquery>
	
	  <!--- Create Workflow Action --->
	  <cfif arguments.eventTriggerType eq 'email'>
	    <cfquery name='local.insert'>
	      INSERT INTO SwWorkflowTaskAction (workflowTaskActionID, actionType, updateData, emailTemplateID, workflowTaskID) VALUES ('#local.workflowTaskActionID#', 'Email', '{"staticData":{},"dynamicData":{}}', '#arguments.emailTemplateID#', '#local.workflowTaskID#')
	    </cfquery>
	  <cfelseif arguments.eventTriggerType eq 'print'>
	    <cfquery name='local.insert'>
	      INSERT INTO SwWorkflowTaskAction (workflowTaskActionID, actionType, updateData, printTemplateID, workflowTaskID) VALUES ('#local.workflowTaskActionID#', 'Print', '{"staticData":{},"dynamicData":{}}', '#arguments.printTemplateID#', '#local.workflowTaskID#')
	    </cfquery>
	  </cfif>
</cffunction>
<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script v4_6 had errors when running">
	<cfthrow detail="Part of Script v4_6 had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script v4_6 has run with no errors">
</cfif>
