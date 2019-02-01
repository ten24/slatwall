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
component entityname="SlatwallWorkflowTaskAction" table="SwWorkflowTaskAction" persistent="true" accessors="true" extends="HibachiEntity" hb_serviceName="workflowService" hb_permission="workflowTask.workflowTaskActions" {
	
	// Persistent Properties
	property name="workflowTaskActionID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="actionType" ormtype="string" hb_formFieldType="select" hb_formatType="rbKey";
	property name="updateData" ormtype="string" length="8000" hb_auditable="false" hb_formFieldType="json";
	property name="processMethod" ormtype="string";
	
	// Calculated Properties

	// Related Object Properties (many-to-one)
	property name="emailTemplate" cfc="EmailTemplate" fieldtype="many-to-one" fkcolumn="emailTemplateID";
	property name="printTemplate" cfc="PrintTemplate" fieldtype="many-to-one" fkcolumn="printTemplateID";
	property name="workflowTask" cfc="WorkflowTask" fieldtype="many-to-one" fkcolumn="workflowTaskID";
	
	// Related Object Properties (one-to-many)
	
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
	property name="actionTypeOptions" persistent="false"; 
	property name="updateDataStruct" type="struct" persistent="false";
	// Deprecated Properties
	
	// ============ START: Non-Persistent Property Methods =================
	public array function getActionTypeOptions() {
		/*
			Print || Email || Update || Process || Import || Export || Delete
		*/
		var actionTypeOptions = [];
		var valuesList = 'print,email,delete,process';
		var valuesArray = ListToArray(valuesList);
		
		for(var value in valuesArray){
			var optionStruct = {};
			optionStruct['value'] = value;
			optionStruct['name'] = rbKey('entity.workflowtaskaction.#value#');
			arrayAppend(actionTypeOptions,optionStruct);
		}
    	return actionTypeOptions;
    }
    
    public any function getUpdateDataStruct(){
		if(isNull(variables.updateDataStruct)){
			variables.updateDataStruct = deserializeUpdateDataConfig();
		}
		return variables.updateDataStruct;
	}
	
//	variables.taskConditionsConfig = '';
//			var defaultTaskConditionsConfig = {};
//			defaultTaskConditionsConfig["filterGroups"] = ArrayNew(1);
//			var workflowConditionGroupStuct = {};
//			workflowConditionGroupStuct["filterGroup"] = ArrayNew(1);
//			ArrayAppend(defaultTaskConditionsConfig["filterGroups"],workflowConditionGroupStuct);
//			variables.taskConditionsConfig = serializeJson(defaultTaskConditionsConfig);
	
	public any function getUpdateData(){
		if(isNull(variables.updateData)){
			var defaultUpdateData = {};
			defaultUpdateData['staticData'] = {};
			defaultUpdateData['dynamicData'] = {};
			variables.updateData = serializeJson(defaultUpdateData);
		}
		return variables.updateData;
	}
	
	public any function deserializeUpdateData(){
		return deserializeJSON(getUpdateData());
	}
    
    // Workflow (many-to-one)
	public void function setWorkflowTask(required any WorkflowTask) {
		variables.WorkflowTask = arguments.WorkflowTask;
		
		if(isNew() or !arguments.WorkflowTask.hasWorkflowTaskAction(this)) {
			arrayAppend(arguments.WorkflowTask.getWorkflowTaskActions(),this);
		}
	}

	public void function removeWorkflowTask(any WorkflowTask) {
		if(!structKeyExists(arguments, 'WorkflowTask')) {
			arguments.WorkflowTask = variables.WorkflowTask;
		}
		var index = arrayFind(arguments.WorkflowTask.getWorkflowTaskActions(),this);
		
		if(index > 0) {
			arrayDeleteAt(arguments.WorkflowTask.getWorkflowTaskActions(),index);
		}
		structDelete(variables, "WorkflowTask");
    }
	
	public boolean function checkPermission() {
		switch(variables.actionType){
			case 'delete':
			case 'process':
				var crudType = 'delete';
				break;
			case 'print':
			case 'email':
				var crudType = 'read';
				break;
		}
		return getHibachiScope().authenticateEntity(crudType, getWorkflowTask().getWorkflow().getWorkflowObject());
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