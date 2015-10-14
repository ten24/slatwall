/*

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

*/
component entityname="SlatwallWorkflowTask" table="SwWorkflowTask" persistent="true" accessors="true" extends="HibachiEntity" hb_serviceName="workflowService" hb_permission="workflow.workflowTasks" {
	
	// Persistent Properties
	property name="workflowTaskID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="activeFlag" ormtype="boolean" hb_formatType="yesno";
	property name="taskName" ormtype="string";
	property name="taskConditionsConfig" ormtype="string" length="8000" hb_auditable="false" hb_formFieldType="json";

	// Calculated Properties

	// Related Object Properties (many-to-one)
	property name="workflow" cfc="Workflow" fieldtype="many-to-one" fkcolumn="workflowID";
	
	// Related Object Properties (one-to-many)
	property name="workflowTaskActions" type="array" cfc="WorkflowTaskAction" singularname="workflowTaskAction" fieldtype="one-to-many" fkcolumn="workflowTaskID" cascade="all-delete-orphan" inverse="true";
	
	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)
	
	// Remote Properties
	property name="remoteID" hb_populateEnabled="false" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// Non-Persistent Properties
	
	property name="taskConditionsConfigStruct" type="struct" persistent="false"; 
	
	// Deprecated Properties



	
	// ============ START: Non-Persistent Property Methods =================
	
	public any function getTaskConditionsConfigStruct(){
		if(isNull(variables.taskConditionsConfigStruct)){
			variables.taskConditionsConfigStruct = deserializeTaskConditionsConfig();
		}
		return variables.taskConditionsConfigStruct;
	}
	
	public any function getTaskConditionsConfig(){
		if(isNull(variables.taskConditionsConfig)){
			variables.taskConditionsConfig = '';
			var defaultTaskConditionsConfig = {};
			defaultTaskConditionsConfig["filterGroups"] = ArrayNew(1);
			var workflowConditionGroupStuct = {};
			workflowConditionGroupStuct["filterGroup"] = ArrayNew(1);
			ArrayAppend(defaultTaskConditionsConfig["filterGroups"],workflowConditionGroupStuct);
			variables.taskConditionsConfig = serializeJson(defaultTaskConditionsConfig);
		}
		return variables.taskConditionsConfig;
	}
	
	public any function deserializeTaskConditionsConfig(){
		return deserializeJSON(getTaskConditionsConfig());
	}
	
	// WorkflowTask (one-to-many)
	public void function addWorkflowTaskAction(required any WorkflowTaskAction) {
		arguments.WorkflowTaskAction.setWorkflowTask( this );
	}
	public void function removeWorkflowTaskAction(required any WorkflowTaskAction) {
		arguments.WorkflowTaskAction.removeWorkflowTask( this );
	}
	
	// Workflow (many-to-one)
	public void function setWorkflow(required any workflow) {
		variables.workflow = arguments.workflow;
		
		if(isNew() or !arguments.workflow.hasWorkflowTask(this)) {
			arrayAppend(arguments.Workflow.getWorkflowTasks(),this);
		}
	}

	public void function removeWorkflow(any workflow) {
		if(!structKeyExists(arguments, 'workflow')) {
			arguments.workflow = variables.workflow;
		}
		var index = arrayFind(arguments.workflow.getWorkflowTasks(),this);
		
		if(index > 0) {
			arrayDeleteAt(arguments.workflow.getWorkflowTasks(),index);
		}
		structDelete(variables, "workflow");
    }
	
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================
	
	// ============== START: Overridden Implicit Getters ===================
	
	// ==============  END: Overridden Implicit Getters ====================
	
	// ============= START: Overridden Smart List Getters ==================
	
	// =============  END: Overridden Smart List Getters ===================

	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================
}