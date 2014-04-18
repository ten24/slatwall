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

component extends="HibachiService" accessors="true" {
	
	// ===================== START: Logical Methods ===========================
	public any function getRelatedEntityForAudit(any audit) {
		// TODO What if the entity has been deleted? Or perhaps all of the prior related audit logs shouldn't even exist so this would never be a problem?
		return getServiceByEntityName(arguments.audit.getBaseObject()).invokeMethod("get#arguments.audit.getBaseObject()#", {1=arguments.audit.getBaseID()});
	}
	
	public void function addAuditToCommit(any audit) {
		// Group related audits together by the base object's primary ID
		var auditStruct = getHibachiScope().getAuditsToCommitStruct();
		if (len(arguments.audit.getBaseID()) && !structKeyExists(auditStruct, arguments.audit.getBaseID())) {
			structInsert(auditStruct, audit.getBaseID(), {});
		}
		
		var auditType = "";
		if (arguments.audit.getAuditType() == "create") {
			auditType = "create";
		} else if (listFindNoCase("update,rollback,merge", arguments.audit.getAuditType())) {
			auditType = "update";
		} else if (arguments.audit.getAuditType() == "delete") {
			auditType = "delete";
		}
		
		if (len(auditType)) {
			structInsert(auditStruct[audit.getBaseID()], auditType, arguments.audit);
		}
	}
	
	public any function getExistingAuditToCommit(string baseID, string auditType) {
		var auditStruct = getHibachiScope().getAuditsToCommitStruct();
		if (structKeyExists(auditStruct, arguments.baseID) && structKeyExists(auditStruct[arguments.baseID], arguments.auditType)) {
			return auditStruct[arguments.baseID][arguments.auditType];
		}
		
		return javaCast("null", "");
	}
	
	public void function commitAudits() {
		var commitTotal = 0;
		for (var baseID in getHibachiScope().getAuditsToCommitStruct()) {
			for (var auditType in ["create", "update", "delete"]) {
				if (structKeyExists(getHibachiScope().getAuditsToCommitStruct()[baseID], auditType)) {
					this.saveAudit(getHibachiScope().getAuditsToCommitStruct()[baseID][auditType]);
					commitTotal++;
				}
			}
		}
		
		if (!getHibachiScope().getORMHasErrors()) {
			getHibachiDAO().flushORMSession();
		}
		
		getHibachiScope().clearAuditsToCommitStruct();
		
		if (commitTotal) {
			logHibachi("Audits were committed, (#commitTotal#) total");
		}
	}
	
	public any function getChangeDetailsForAudit(any audit) {
		var changeData = deserializeJSON(arguments.audit.getData());
		
		var changeDetails = {};
		changeDetails.properties = [];
		changeDetails.columnList = "new";
		if (listFindNoCase("update,rollback", arguments.audit.getAuditType())) {
			changeDetails.columnList = listAppend(changeDetails.columnList, "old");
		}
		
		var properties = getEntityObject(arguments.audit.getBaseObject()).getAuditableProperties();
		for (var currentProperty in properties) {
			var changeDetail = {};
			changeDetail['propertyName'] = currentProperty.name;
			
			for (var column in listToArray(changeDetails.columnList)) {
				if (structKeyExists(changeData["#column#PropertyData"], currentProperty.name)) {
					var columnValue = "";
					var dataValue = changeData["#column#PropertyData"][currentProperty.name];
					
					// Column/Simple Value
					if (!structKeyExists(currentProperty, "fieldType") || currentProperty.fieldType == "column") {
						if (isBoolean(dataValue) && structKeyExists(currentProperty, "ormtype") && currentProperty.ormtype == "boolean") {
							columnValue = rbKey("define.#yesNoFormat(dataValue)#");
						} else {
							columnValue = dataValue;
						}
					// Entity
					} else if (structKeyExists(currentProperty, "cfc")) {
						if (isStruct(dataValue)) {
							// Get actual reference to entity
							var entityPrimaryIDPropertyName = getPrimaryIDPropertyNameByEntityName(currentProperty.cfc);
							var entityService = getServiceByEntityName(currentProperty.cfc);
							if (structKeyExists(dataValue, entityPrimaryIDPropertyName)) {
								columnValue = entityService.invokeMethod( "get#listLast(currentProperty.cfc,'.')#", {1=dataValue[entityPrimaryIDPropertyName],2=false});
								
								// Use simple representation or primaryID in case that the referenced entity had been deleted and no longer exists
								if (isNull(columnValue)) {
									if (structKeyExists(dataValue, "title")) {
										columnValue = dataValue.title;
									} else {
										columnValue = dataValue[entityPrimaryIDPropertyName];
									}
								}
							}
						}
					}
					
					changeDetail[column] = columnValue;
				}
			}
			
			// Only include the relevant auditable properties
			if (listFindNoCase(structKeyList(changeDetail), "new") || listFindNoCase(structKeyList(changeDetail), "old")) {
				// Make sure matching 'old' key exists when appropriately required
				if (listFindNoCase(changeDetails.columnList, "old") && !structKeyExists(changeDetail, "old")) {
					// Blank when missing
					changeDetail['old'] = "";
				}
				
				// Make sure matching 'new' key exists when appropriately required
				if (listFindNoCase(changeDetails.columnList, "new") && !structKeyExists(changeDetail, "new")) {
					// Blank when missing
					changeDetail['new'] = "";
				}
				
				arrayAppend(changeDetails.properties, changeDetail);
			}
		}
		
		return changeDetails;
	}
	
	public any function newAudit() {
		var audit = this.new('Audit');
		audit.setAuditDateTime(now());
		audit.setSessionIPAddress(CGI.REMOTE_ADDR);
		if(!getHibachiScope().getAccount().isNew() && getHibachiScope().getAccount().getAdminAccountFlag() ){
			audit.setSessionAccountID(getHibachiScope().getAccount().getAccountID());
			audit.setSessionAccountFullName(getHibachiScope().getAccount().getFullName());
			if (!isNull(getHibachiScope().getAccount().getEmailAddress())) {
				audit.setSessionAccountEmailAddress(getHibachiScope().getAccount().getEmailAddress());
			}
		}
		
		return audit;
	}
	
	public void function logAccountActivity(string auditType) {
		if (listFindNoCase("login,logout", arguments.auditType)) {
			var audit = this.newAudit();
			audit.setAuditType(arguments.auditType);
			// Immediately commit audit, no need to defer commit
			this.saveAudit(audit);
		}
	}
	
	public void function logEntityDelete(any entity) {
		var audit = this.newAudit();
		audit.setAuditType("delete");
		audit.setBaseID(arguments.entity.getPrimaryIDValue());
		audit.setBaseObject(arguments.entity.getClassName());
		audit.setTitle(arguments.entity.getSimpleRepresentation());
		// Defer audit commit to end of request
		addAuditToCommit(audit);
	}
	
	public any function logEntityModify(any entity, struct oldData) {
		if (arguments.entity.getAuditableFlag()) {
			
			var auditType = "";
			// Audit type is create when no old data available or no previous audit log data available
			if (isNull(arguments.oldData) || (arguments.entity.getAuditSmartList().getRecordsCount()  == 0)) {
				auditType = "create";
				
				// Remove oldData from arguments if it was provided because it is not applicable for property change data
				if (!isNull(arguments.oldData)) {
					structDelete(arguments, "oldData");
				}
				
			// Audit type is rollback
			} else if (arguments.entity.getRollbackFlag()) {
				auditType = "rollback";
				
			// Audit type is update
			} else {
				auditType = "update";
			}
			
			// An audit may already exist in the request waiting to commit with the same related base object and similar audit type
			// We can just update the existing audit and consolidate rather than create a new audit 
			var audit = getExistingAuditToCommit(baseID=arguments.entity.getPrimaryIDValue(), auditType=auditType);
			var commitPendingFlag = true;
			if (isNull(audit)) {
				audit = this.newAudit();
				audit.setBaseID(arguments.entity.getPrimaryIDValue());
				audit.setBaseObject(arguments.entity.getClassName());
				audit.setAuditType(auditType);
				commitPendingFlag = false;
			}
			
			try {
				audit.setTitle(arguments.entity.getSimpleRepresentation());
			} catch (any e) {
				audit.setTitle(rbKey("entity.audit.nosummary"));
			}
			
			// Determine property change data
			var propertyChangeData = generatePropertyChangeDataForEntity(argumentCollection=arguments);
			
			// If audit commit was already pending, just append new property change data to existing property change data 
			if (!isNull(audit.getData()) && isJSON(audit.getData())) {
				var existingPropertyChangeData = deserializeJSON(audit.getData());
				
				// Append existing to new without overwriting new
				structAppend(propertyChangeData.newPropertyData, existingPropertyChangeData.newPropertyData, false);
				
				// Append existing to new without overwriting new
				if (structKeyExists(propertyChangeData, "oldPropertyData") && structKeyExists(existingPropertyChangeData, "oldPropertyData")) {
					structAppend(propertyChangeData.oldPropertyData, existingPropertyChangeData.oldPropertyData, false);
				// Insert entire struct from existing to new because oldPropertyData not present in new
				} else if (structKeyExists(existingPropertyChangeData, "oldPropertyData")) {
					structInsert(propertyChangeData, "oldPropertyData", existingPropertyChangeData.oldPropertyData);
				}
			}
			
			audit.setData(serializeJSON(propertyChangeData));
			
			// Defer audit commit to end of request if not already pending
			if (!commitPendingFlag) {
				addAuditToCommit(audit);
			}
		}
	}
	
	public struct function generatePropertyChangeDataForEntity(any entity, struct oldData) {		
		// Note: The new and old property value mapping data structs used below effectively allow us to make linear comparisons, each's associated key/values contain simple values only
		// To reduce the complexity of comparing the new and old nested property values, we simplify the process by flattening out the properties of the entity
		// into a single-level struct with matching keys that are used to map the respective simplified property values of new and old data.
		// Then we can determine the relevant "deltas" by performing a linear simple value comparisons using the key/value pairs in the property value mapping data structs
		
		var oldDataExistsFlag = !isNull(arguments.oldData);
		var auditablePropertiesStruct = arguments.entity.getAuditablePropertiesStruct();
		
		// Struct holds the actual property values that will be serialized as JSON when persisted to the database
		var propertyChangeData = {};
		propertyChangeData["newPropertyData"] = {};
		
		// STEP 1. Convert old and new values into a standardized and simplified format that can be easily compared and serialized to JSON
		
		var newPropertyValueMappingData = {};
		// Track all new auditable properties initially
		for (var propertyName in auditablePropertiesStruct) {
			propertyChangeData.newPropertyData[propertyName] = getStandardizedValue(propertyValue=arguments.entity.invokeMethod("get#propertyName#"), propertyMetaData=auditablePropertiesStruct[propertyName], mappingData=newPropertyValueMappingData, mappingPath=propertyName, className=arguments.entity.getClassName());
		}
		
		var oldPropertyValueMappingData = {};
		// Track all old auditable properties initially
		if (oldDataExistsFlag) {
			propertyChangeData["oldPropertyData"] = {};
			for (var propertyName in auditablePropertiesStruct) {
				if (structKeyExists(arguments.oldData, propertyName)) {
					propertyChangeData.oldPropertyData[propertyName] = getStandardizedValue(propertyValue=arguments.oldData[propertyName], propertyMetaData=auditablePropertiesStruct[propertyName], mappingData=oldPropertyValueMappingData, mappingPath=propertyName, className=arguments.entity.getClassName());
					
				// Add empty string to represent old null value
				} else if (!structKeyExists(auditablePropertiesStruct[propertyName], "fieldType") || auditablePropertiesStruct[propertyName].fieldType == "column") {
					propertyChangeData.oldPropertyData[propertyName] = "";
					structInsert(oldPropertyValueMappingData, "#propertyName#", "", true);
					
				// Add empty primaryIDProperyName primaryID key/value paid to represent old null value
				} else if (structKeyExists(auditablePropertiesStruct[propertyName], "cfc")) {
					propertyChangeData.oldPropertyData[propertyName] = {'#getPrimaryIDPropertyNameByEntityName(auditablePropertiesStruct[propertyName].cfc)#'=""};
					structInsert(oldPropertyValueMappingData, "#propertyName#-#getPrimaryIDPropertyNameByEntityName(auditablePropertiesStruct[propertyName].cfc)#", "", true);
				}
			}
		}
		
		// STEP 2. Calculate delta between old and new values by performing simple linear comparisons
		
		var changedPropertyNames = [];
		
		// Note: comparison sets used only for a tidy purpose to simply swap variables to avoid duplicating code
		var comparisonSets = [{source=newPropertyValueMappingData, target=oldPropertyValueMappingData}];
		
		// When oldData present add to comparison set to trigger 2-way cross comparison of both new and old property values
		if (oldDataExistsFlag) {
			arrayAppend(comparisonSets, {source=oldPropertyValueMappingData, target=newPropertyValueMappingData});
		}
		
		// Determine the changed properties when only new values exists or when new values and old values both exist but differ
		for (var comparison in comparisonSets) {
			for (var propertyValueMappingKey in comparison.source) {
				// Derive top level property name based on property value mapping key
				var topLevelPropertyName = listFirst(propertyValueMappingKey, "-");
				
				// If property was already known to differ then skip an unecessary comparison
				if (!arrayContains(changedPropertyNames, topLevelPropertyName)) {
					// Change detected when value only exists in source or when source/target values differ
					if (!structKeyExists(comparison.target, propertyValueMappingKey) || (comparison.source[propertyValueMappingKey] != comparison.target[propertyValueMappingKey])) {
						auditablePropertiesStruct[topLevelPropertyName];
						if (len(comparison.source[propertyValueMappingKey])) {
							arrayAppend(changedPropertyNames, topLevelPropertyName);
						}
					}
				}
			}
		}
		
		// Remove all irrelevant property values from new property change data
		for (var propertyName in propertyChangeData.newPropertyData) {
			if (!arrayContains(changedPropertyNames, propertyName)) {
				structDelete(propertyChangeData.newPropertyData, propertyName);
			}
		}
		
		// Remove all irrelevant property values from old property change data
		if (oldDataExistsFlag) {
			for (var propertyName in propertyChangeData.oldPropertyData) {
				if (!arrayContains(changedPropertyNames, propertyName)) {
					structDelete(propertyChangeData.oldPropertyData, propertyName);
				}
			}
		}
		
		return propertyChangeData;
	}
	
	public any function getStandardizedValue(any propertyValue, struct propertyMetaData, struct mappingData, string mappingPath="", string className) {
		var standardizedValue = "";
		
		// Simple Value
		if (!structKeyExists(arguments.propertyMetaData, "fieldType") || arguments.propertyMetaData.fieldType == "column") {
			// Set only when defined and not null, otherwise leave 'standardizedValue' as empty string
			if (isDefined("arguments.propertyValue") && !isNull(arguments.propertyValue) && isSimpleValue(arguments.propertyValue)) {
				standardizedValue = arguments.propertyValue;
			}
			
			// Updates mapping data
			structInsert(arguments.mappingData, "#arguments.mappingPath#", standardizedValue, true);
		// Entity
		} else if (structKeyExists(arguments.propertyMetaData, "cfc")) {
			var entityPrimaryIDPropertyName = getPrimaryIDPropertyNameByEntityName(arguments.propertyMetaData.cfc);
			
			standardizedValue = {};
			standardizedValue['#entityPrimaryIDPropertyName#'] = "";
			
			if (!isNull(arguments.propertyValue)) {
				standardizedValue["#entityPrimaryIDPropertyName#"] = arguments.propertyValue.getPrimaryIDValue();
				if (structKeyExists(arguments.propertyValue, "getSimpleRepresentation")) {
					try {
						standardizedValue["title"] = arguments.propertyValue.getSimpleRepresentation();
					} catch (any e) {}
				}
			}
			
			// Updates mapping data
			structInsert(arguments.mappingData, "#arguments.mappingPath#-#entityPrimaryIDPropertyName#", standardizedValue["#entityPrimaryIDPropertyName#"], true);
		} else {
			throw(message="#getClassName()# unable to determine standardized value of property '#arguments.className#.#arguments.propertyMetaData.name#'. Additional logic probably needs to be implemented.");
		}
		/*
		// Array
		} else if (isArray(arguments.propertyValue)) {
			// Standardize values of all array items
			standardizedValue = [];
			for (var i = 1; i <= arraylen(arguments.propertyValue); i++) {
				arrayAppend(standardizedValue, getStandardizedValue(propertyValue=arguments.propertyValue[i], mappingData=arguments.mappingData, mappingPath="#arguments.mappingPath#[#i#]"));
			}
			
			// Convert empty array to emtpy string
			if (arrayIsEmpty(standardizedValue)) {
				standardizedValue = "";
			}
		// Struct
		} else if (isStruct(arguments.propertyValue)) {
			standardizedValue = {};
			
			for (var key in arguments.propertyValue) {
				// Convert undefined values to empty string because null values could have been inserted into struct
				if (!isDefined("arguments.propertyValue.#key#") || isNull(arguments.propertyValue[key])) {
					arguments.propertyValue[key] = "";
				}
				
				// Standardize all key/value pairs
				standardizedValue[key] = getStandardizedValue(propertyValue=arguments.propertyValue[key], mappingData=arguments.mappingData, mappingPath="#arguments.mappingPath#[#key#]");
			}
			
			// Convert empty struct to empty string
			if (structIsEmpty(standardizedValue)) {
				standardizedValue = "";
			}
		}
		*/
		
		return standardizedValue;
	}
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	public any function processAudit_rollback(required any audit) {
		var relatedEntity = arguments.audit.getRelatedEntity();
		auditSL = relatedEntity.getAuditSmartList();
		auditSL.addInFilter("auditType", "create,update,rollback");
		
		var audits = auditSL.getRecords();
		
		// Locate rollback index
		var rollbackIndex = 1;
		for (var i=1; i<=arraylen(audits); i++) {
			if (audits[i].getAuditID() == arguments.audit.getAuditID()) {
				rollbackIndex = i;
				break;
			}
		}
		
		// Aggregate property changes by traversing backwards from current state
		var rollbackData = {};
		var propertiesStruct = relatedEntity.getAuditablePropertiesStruct();
		for (var i=1; i<=rollbackIndex; i++) {
			var currentData = deserializeJSON(audits[i].getData());
			
			// Prior to reaching rollback point only the oldPropertyData contains relevant data, if oldPropertyData used at rollback state would be beyond desired rollback point
			if (i != rollbackIndex) {
				structAppend(rollbackData, currentData.oldPropertyData, true);
			
			// Only newPropertyData is relevant when the rollback point is reached
			} else {
				structAppend(rollbackData, currentData.newPropertyData, true);
			}
		}
		
		// Save new version of entity with aggregated rollback changes
		relatedEntity.setRollbackFlag(true);
		getServiceByEntityName(arguments.audit.getBaseObject()).invokeMethod("save#arguments.audit.getBaseObject()#", {1=relatedEntity,2=rollbackData});
		
		return arguments.audit;
	}
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Status Methods ===========================
	
	// ======================  END: Status Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
	
	// ===================== START: Delete Overrides ==========================
	
	// =====================  END: Delete Overrides ===========================
	
}