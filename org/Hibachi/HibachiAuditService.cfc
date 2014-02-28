component accessors="true" output="false" extends="HibachiService" {
	
	public any function logEntityAuditData(any entity, struct oldData) {
		if (arguments.entity.getAuditableFlag()) {
			var audit = this.newAudit();
			audit.setBaseID(entity.getPrimaryIDValue());
			audit.setBaseObject(entity.getClassName());
			
			// Audit type is create when no old data passed in or no previous audit data exists
			// TODO check if no entry in audit history
			if (isNull(arguments.oldData) || !arraylen(arguments.entity.getAuditHistory())) {
				audit.setAuditType("createEntity");
				// add all auditable properties
				//entity.getAuditableProperties();
			// Audit type is update
			} else {
				audit.setAuditType("updateEntity");
				// determine the auditable property changes comparing against the old data
			}
			
			this.saveAudit(audit);
		}
	}
	
	public array function getAuditHistoryForEntity( required string baseID ) {
		// Find file relationships for base object entity
		return this.listAudit(arguments);
	}
	
}