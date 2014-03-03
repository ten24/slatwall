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
			
			if (entity.getClassName() == "Product") {
				audit.setData(serializeJSON(getEntityPropertyChangeData(argumentCollection=arguments)));
				this.saveAudit(audit);
			}
		}
	}
	
	public struct function getEntityPropertyChangeData(any entity, struct oldData) {
		var auditablePropertiesStruct = arguments.entity.getAuditablePropertiesStruct();
		
		var propertyChangeData = {};
		propertyChangeData.newPropertyData = {};
		
		logHibachi("*** Constructing propery change data for '#arguments.entity.getClassName()#'");
		// Add all auditable properties initially
		for (var propertyName in auditablePropertiesStruct) {
			logHibachi("*** serializing property '#propertyName#'");
			var currentProperty = auditablePropertiesStruct[propertyName];
			propertyChangeData.newPropertyData[propertyName] = getStandardizedPropertyValue(entity.invokeMethod("get#propertyName#"));
		}
		
		// Add all auditable properties initially
		if (!isNull(arguments.oldData)) {
			propertyChangeData.oldPropertyData = {};
			for (var propertyName in auditablePropertiesStruct) {
				if (structKeyExists(arguments.oldData, propertyName)) {
					propertyChangeData.oldPropertyData[propertyName] = getStandardizedPropertyValue(arguments.oldData[propertyName]);
				}
			}
		}
		
		// Clean up new data by removing empty values
		if (!propertyChangeData.oldPropertyData) {
			
		// Do comparison between old data and new data
		} else {
			
		}
		logHibachi("*** Done with change data");
		
		return propertyChangeData;
	}
	
	public any function getStandardizedPropertyValue(any propertyValue) {
		var serializedPropertyValue = "";
		
		// Convert any undefined/null property value to empty string
		if (!isDefined("arguments.propertyValue") || isNull(arguments.propertyValue)) {
			arguments.propertyValue = "";
		}
		
		// Simple Value
		if (isSimpleValue(arguments.propertyValue)) {
			serializedPropertyValue = arguments.propertyValue;
		// Array
		} else if (isArray(arguments.propertyValue)) {
			serializedPropertyValue = [];
			for (var i in arguments.propertyValue) {
				arrayAppend(serializedPropertyValue, getStandardizedPropertyValue(i));
			}
			
			if (arrayIsEmpty(serializedPropertyValue)) {
				serializedPropertyValue = "";
			}
		// Entity
		} else if (isObject(arguments.propertyValue) && structKeyExists(arguments.propertyValue, "getPrimaryIDValue")) {
			serializedPropertyValue = {};
			serializedPropertyValue[arguments.propertyValue.getPrimaryIDPropertyName()] = arguments.propertyValue.getPrimaryIDValue();
		// Struct
		} else if (isStruct(arguments.propertyValue)) {
			serializedPropertyValue = {};
			
			for (var key in arguments.propertyValue) {
				// Check for undefined because null values could have been inserted into struct
				if (!isDefined("arguments.propertyValue.#key#") || isNull(arguments.propertyValue[key])) {
					arguments.propertyValue[key] = "";
				}
				serializedPropertyValue[key] = getStandardizedPropertyValue(arguments.propertyValue[key]);
			}
			
			if (structIsEmpty(serializedPropertyValue)) {
				serializedPropertyValue = "";
			}
		}
		
		return serializedPropertyValue;
	}
	
	public array function getAuditLogForEntity( required string baseID ) {
		// Find file relationships for base object entity
		return this.listAudit(arguments);
	}
	
}