component accessors="true" output="false" extends="HibachiService" {
	
	public any function logEntityAuditData(any entity, struct oldData) {
		if (arguments.entity.getAuditableFlag()) {
			var audit = this.newAudit();
			audit.setBaseID(entity.getPrimaryIDValue());
			audit.setBaseObject(entity.getClassName());
			audit.setAuditDateTime(now());
			
			// Audit type is create when no old data available or no previous audit log data available
			if (isNull(arguments.oldData) || !arraylen(arguments.entity.getAuditLog())) {
				audit.setAuditType("createEntity");
			// Audit type is update
			} else {
				audit.setAuditType("updateEntity");
			}
			
			// TODO remove, for testing purposes only
			if (entity.getClassName() == "Product") {
				audit.setData(serializeJSON(generatePropertyChangeDataForEntity(argumentCollection=arguments)));
				this.saveAudit(audit);
			}
		}
	}
	
	public struct function generatePropertyChangeDataForEntity(any entity, struct oldData) {
		var auditablePropertiesStruct = arguments.entity.getAuditablePropertiesStruct();
		
		var propertyChangeData = {};
		propertyChangeData.newPropertyData = {};
		
		logHibachi("*** Constructing propery change data for '#arguments.entity.getClassName()#'");
		var newPropertyValueMappingData = {};
		// Add all new auditable properties initially
		for (var propertyName in auditablePropertiesStruct) {
			logHibachi("*** standardizing new property '#propertyName#'");
			propertyChangeData.newPropertyData[propertyName] = getStandardizedValue(value=entity.invokeMethod("get#propertyName#"), mappingData=newPropertyValueMappingData, mappingPath="propertyName");
		}
		
		var oldPropertyValueMappingData = {};
		// Add all old auditable properties initially
		if (!isNull(arguments.oldData)) {
			propertyChangeData.oldPropertyData = {};
			for (var propertyName in auditablePropertiesStruct) {
				if (structKeyExists(arguments.oldData, propertyName)) {
					logHibachi("*** standardizing old property '#propertyName#'");
					propertyChangeData.oldPropertyData[propertyName] = getStandardizedValue(value=arguments.oldData[propertyName], mappingData=oldPropertyValueMappingData, mappingPath=propertyName);
					// Immediately delete irrelevant empty values
					if (isSimpleValue(propertyChangeData.oldPropertyData[propertyName]) && !len(propertyChangeData.oldPropertyData[propertyName])) {
						logHibachi("*** immediately removing old property '#propertyName#' because it is empty and irrelevant");
						structDelete(propertyChangeData.oldPropertyData, propertyName);
					}
				}
			}
		}
		
		// Any empty arrays, structs, or null values in the property change data should have been converted to empty strings during standardization
		
		// Compare old and new property values flattened in the mapping data
		
		// Filter out empty values in new data when conditions are met
		for (var propertyName in propertyChangeData.newPropertyData) {
			var newPropertyValue = propertyChangeData.newPropertyData[propertyName];
			
			// Keep empty new values only when they differ from their respective non-empty old values
			if (isSimpleValue(newPropertyValue) && !len(newPropertyValue)) {
				// Filter out empty new value when no old data exists
				if (isNull(arguments.oldData)) {
					logHibachi("*** removing new property '#propertyName#' Filter out empty new value when no old data exists");
					structDelete(propertyChangeData.newPropertyData, propertyName);
				// Filter out empty new value when no matching property exists in old property data
				} else if (!structKeyExists(propertyChangeData.oldPropertyData, propertyName)) {
					logHibachi("*** removing new property '#propertyName#' Filter out empty new value when no matching property exists in old property data");
					structDelete(propertyChangeData.newPropertyData, propertyName);
				// Filter out empty new value because it does not differ from the existing empty old value
				} else if (structKeyExists(propertyChangeData.oldPropertyData, propertyName) && isSimpleValue(propertyChangeData.oldPropertyData[propertyName]) && !len(propertyChangeData.oldPropertyData[propertyName])) {
					logHibachi("*** removing new property '#propertyName#' Filter out empty new value because it does not differ from the existing empty old value");
					structDelete(propertyChangeData.newPropertyData, propertyName);
				}
			}
		}
		
		logHibachi("*** Done with change data");
		
		return propertyChangeData;
	}
	
	public any function getStandardizedValue(any propertyValue, struct mappingData, string mappingPath="") {
		var standardizedValue = "";
		
		// Convert undefined or null property value to empty string
		if (!isDefined("arguments.propertyValue") || isNull(arguments.propertyValue)) {
			arguments.propertyValue = "";
		}
		
		// Simple Value
		if (isSimpleValue(arguments.propertyValue)) {
			standardizedValue = arguments.propertyValue;
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
		// Entity
		} else if (isObject(arguments.propertyValue) && structKeyExists(arguments.propertyValue, "getPrimaryIDValue")) {
			standardizedValue = {};
			// Primary ID of entity is only relevant value
			standardizedValue[arguments.propertyValue.getPrimaryIDPropertyName()] = arguments.propertyValue.getPrimaryIDValue();
		// Struct
		} else if (isStruct(arguments.propertyValue)) {
			standardizedValue = {};
			
			for (var key in arguments.propertyValue) {
				// Convert undefined values to empty string because null values could have been inserted into struct
				if (!isDefined("arguments.propertyValue.#key#") || isNull(arguments.propertyValue[key])) {
					arguments.propertyValue[key] = "";
				}
				
				// Standardize all key/value pairs
				standardizedValue[key] = getStandardizedValue(propertyValue=arguments.propertyValue[key], mappingData=arguments.mappingData, mappingPath="#arguments.mappingPath#.#key#");
			}
			
			// Convert empty struct to empty string
			if (structIsEmpty(standardizedValue)) {
				standardizedValue = "";
			}
		}
		
		// updates mapping data using mapping path appended with dot notation
		structInsert(arguments.mappingData, "#arguments.mappingPath#", standardizedValue, true);
		
		return standardizedValue;
	}
	
	public array function getAuditLogForEntity( required string baseID ) {
		// Find file relationships for base object entity
		return this.listAudit(arguments);
	}
	
}