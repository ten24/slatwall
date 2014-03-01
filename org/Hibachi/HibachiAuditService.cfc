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
			
			audit.setData(serializeJSON(getEntityPropertyChangeData(argumentCollection=arguments)));
			
			this.saveAudit(audit);
		}
	}
	
	public struct function getEntityPropertyChangeData(any entity, struct oldData) {
		var auditablePropertiesStruct = arguments.entity.getAuditablePropertiesStruct();
		
		var propertyChangeData = {};
		propertyChangeData.newPropertyData = {};
		
		// add all auditable properties initially
		for (var propertyName in auditablePropertiesStruct) {
			var currentProperty = auditablePropertiesStruct[propertyName];
			
			var currentPropertyValue = entity.invokeMethod("get#propertyName#");
			
			// convert null property value to empty string
			if (!isDefined("currentPropertyValue") || isNull(currentPropertyValue)) {
				currentPropertyValue = "";
			}
			
			// simple value properties
			if ((!structKeyExists(currentProperty, "fieldType") || currentProperty.fieldType == "column") && isSimpleValue(currentPropertyValue)) {
				propertyChangeData[propertyName] = currentPropertyValue;
			// complex relationship properties
			} else {
				// encode arrays propertName[1]
				propertyChangeData[propertyName] = "complex object";
			}
		}
		
		// determine the auditable property changes comparing against the old data
		// add only auditable properties that differ from the new property data
		if (!isNull(arguments.oldData)) {
			propertyChangeData.oldPropertyData = {};
		}
		
		return propertyChangeData;
	}
	
	public array function getAuditLogForEntity( required string baseID ) {
		// Find file relationships for base object entity
		return this.listAudit(arguments);
	}
	
}