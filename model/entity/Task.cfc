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
component displayname="Task" hb_auditable="false" entityname="SlatwallTask" table="SwTask" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="taskService" hb_permission="this" hb_processContext="customURL,subscriptionUsageRenew,subscriptionUsageRenewalReminder,updateCalculatedProperties" {
	
	// Persistent Properties
	property name="taskID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="activeFlag" ormtype="boolean" hb_formatType="yesno";
	property name="taskName" ormtype="string";
	property name="taskMethod" ormtype="string" hb_formFieldType="select" hb_formatType="rbKey";
	property name="taskUrl" ormtype="string";
	property name="taskConfig" ormtype="string" length="4000";
	property name="runningFlag" ormtype="boolean" hb_formatType="yesno";
	property name="timeout" ormtype="integer" ;

	// Related Object Properties (many-to-one)
	
	// Related Object Properties (one-to-many)
	property name="taskHistories" singularname="taskHistory" cfc="TaskHistory" type="array" fieldtype="one-to-many" fkcolumn="taskID" cascade="all-delete-orphan" inverse="true";
	property name="taskSchedules" singularname="taskSchedule" cfc="TaskSchedule" type="array" fieldtype="one-to-many" fkcolumn="taskID" cascade="all-delete-orphan" inverse="true";
	
	// Related Object Properties (many-to-many)
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// Non-Persistent Properties
	property name="taskMethodOptions" persistent="false";

	
	// ============ START: Non-Persistent Property Methods =================
	
	public array function getTaskMethodOptions() {
		return [
			{name=rbKey('define.select'), value=""},
			{name="#rbKey('entity.task.taskMethod.customURL')#", value="customURL"},
			{name="#rbKey('entity.task.taskMethod.subscriptionUsageRenew')#", value="subscriptionUsageRenew"},
			{name="#rbKey('entity.task.taskMethod.subscriptionUsageRenewalReminder')#", value="subscriptionUsageRenewalReminder"},
			{name="#rbKey('entity.task.taskMethod.updateCalculatedProperties')#", value="updateCalculatedProperties"},
			{name="#rbKey('entity.task.taskMethod.updateEventWaitlists')#", value="updateEventWaitlists"}
		];
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Task history (one-to-many)    
	public void function addTaskHistory(required any taskHistory) {    
		arguments.taskHistory.settaskHistoryID( this );    
	}    
	public void function removeTaskHistory(required any taskHistory) {    
		arguments.taskHistory.removetaskHistoryID( this );    
	}
    	
	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}
