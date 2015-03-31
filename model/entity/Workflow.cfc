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

component displayname="Workflow" entityname="SlatwallWorkflow" table="SwWorkflow" persistent="true" accessors="true" extends="HibachiEntity" hb_serviceName="workflowService" hb_permission="this" {
	
	// Persistent Properties
	property name="workflowID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="activeFlag" ormtype="boolean" hb_formatType="yesno";
	property name="workflowName" ormtype="string";
	property name="workflowObject" ormtype="string" hb_formfieldType="select";

	// Calculated Properties

	// Related Object Properties (many-to-one)
	
	// Related Object Properties (one-to-many)
	property name="workflowTasks" singularname="workflowTask" cfc="WorkflowTask" type="array" fieldtype="one-to-many" fkcolumn="workflowID" cascade="all-delete-orphan" inverse="true";
	property name="workflowTriggers" singularname="workflowTrigger" cfc="WorkflowTrigger" type="array" fieldtype="one-to-many" fkcolumn="workflowID" cascade="all-delete-orphan" inverse="true";
	
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
	property name="workflowObjectOptions" persistent="false";
	// Deprecated Properties

	// ============ START: Non-Persistent Property Methods =================
	
	public array function getWorkflowObjectOptions(){
		if(!structKeyExists(variables,'workflowObjectOptions')){
			var entitiesMetaData = getService("hibachiService").getEntitiesMetaData();
			var entitiesMetaDataArray = listToArray(structKeyList(entitiesMetaData));
			arraySort(entitiesMetaDataArray,"text");
			variables.workflowObjectOptions = [];
			for(var i=1; i <=arrayLen(entitiesMetaDataArray); i++){
				var entityMetaDataStruct = {};
				entityMetaDataStruct['name'] = rbKey('entity.#entitiesMetaDataArray[i]#');
				entityMetaDataStruct['value'] = entitiesMetaDataArray[i];
				arrayAppend(variables.workflowObjectOptions,entityMetaDataStruct);
			}
		}
		
		return variables.workflowObjectOptions;
	}
	
	// WorkflowTask (one-to-many)
	public void function addWorkflowTask(required any WorkflowTask) {
		arguments.WorkflowTask.setWorkflow( this );
	}
	public void function removeWorkflowTask(required any WorkflowTask) {
		arguments.WorkflowTask.removeWorkflow( this );
	}
	// WorkflowTrigger (one-to-many)
	public void function addWorkflowTrigger(required any WorkflowTrigger) {
		arguments.WorkflowTrigger.setWorkflow( this );
	}
	public void function removeWorkflowTrigger(required any WorkflowTrigger) {
		arguments.WorkflowTrigger.removeWorkflow( this );
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