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
component entityname="SlatwallAudit" table="SwAudit" persistent="true" accessors="true" extends="HibachiEntity" hb_serviceName="HibachiAuditService" hb_defaultOrderProperty="auditDateTime" hb_auditable="false" {
	
	// Persistent Properties
	property name="auditID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="auditType" ormType="string" hb_formatType="rbKey"; // create, update, delete, rollback, archive, merge, scheduleUpdate, login, logout
	property name="auditDateTime" ormtype="timestamp";
	property name="auditArchiveStartDateTime" ormtype="timestamp";
	property name="auditArchiveEndDateTime" ormtype="timestamp";
	property name="auditArchiveCreatedDateTime" ormtype="timestamp";
	property name="baseObject" ormType="string" index="EI_BASEOBJECT";
	property name="baseID" ormType="string" index="EI_BASEID";
	property name="data" ormType="string" length="8000";
	property name="title" ormType="string" length="1000";
	
	property name="sessionIPAddress" ormType="string";
	property name="sessionAccountID" ormType="string" length="32";
	property name="sessionAccountEmailAddress"ormType="string";
	property name="sessionAccountFullName" ormType="string";
	
	// TODO future scheduled date
	// TODO comment
	
	// Calculated Properties

	// Related Object Properties (many-to-one)
	
	// Related Object Properties (one-to-many)
	
	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)
	
	// Remote Properties
	
	// Audit Properties
	
	// Non-Persistent Properties
	property name="changeDetails" type="any" persistent="false";
	property name="relatedEntity" type="any" persistent="false";
	property name="archiveProcessedFlag" type="boolean" persistent="false";
	
	// Deprecated Properties


	// ==================== START: Logical Methods =========================
	
	// ====================  END: Logical Methods ==========================
	
	// ============ START: Non-Persistent Property Methods =================
	
	public boolean function getArchiveProcessedFlag() {
		if(isNull(variables.archiveProcessedFlag) || !isBoolean(variables.archiveProcessedFlag)) {
			variables.archiveProcessedFlag = false;
		}
		return variables.archiveProcessedFlag;
	}
	
	public function getChangeDetails() {
		if (!structKeyExists(variables, "changeDetails")) {
			if (listFindNoCase("create,update,rollback,archive", getAuditType())) {
				variables.changeDetails = getService("HibachiAuditService").getPropertyChangeDetailsForAudit(this);
			}
		}
		
		if (!isNull(variables.changeDetails)) {
			return variables.changeDetails;
		} else {
			return javacast("null", ""); 
		}
	}
	
	public function getRelatedEntity() {
		if (!structKeyExists(variables, "relatedEntity") && !isNull(getBaseObject()) && len(getBaseObject())) {
			variables.relatedEntity = getService("HibachiAuditService").getRelatedEntityForAudit(this);
		}
		
		if (!isNull(variables.relatedEntity)) {
			return variables.relatedEntity;
		} else {
			return javacast("null", "");
		}
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	
	public boolean function getAuditRollbackValidFlag() {
		var validationResult = !validateAuditRollback().hasErrors();
		
		// If necessary delegate validation to related entity
		if (validationResult && !isNull(getRelatedEntity())) {
			validationResult = getRelatedEntity().getAuditRollbackValidFlag();
		}
		
		return validationResult;
	}
	
	public any function validateAuditRollback(boolean setErrors=false) {
		return getService("hibachiValidationService").validate(object=this, context="rollback", setErrors=arguments.setErrors);
	}
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================
	
	// ============== START: Overridden Implicit Getters ===================
	
	//must use any as return type to handle persistent null situations
	public any function getTitle(){
		if(structKeyExists(variables,'title')){
			return hibachiHtmlEditFormat(variables.title);
		}
	}
	
	// ==============  END: Overridden Implicit Getters ====================
	
	// ============= START: Overridden Smart List Getters ==================
	
	// =============  END: Overridden Smart List Getters ===================

	// ================== START: Overridden Methods ========================
	
	public string function getSimpleRepresentationPropertyName() {
		return "auditID";
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================
	
}
