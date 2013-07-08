component accessors="true" extends="Slatwall.org.Hibachi.HibachiService" {

	public any function getSlatwallScope() {
		return getHibachiScope();
	} 
	
	// @hint leverages the getEntityHasAttributeByEntityName() by traverses a propertyIdentifier first using getLastEntityNameInPropertyIdentifier()
	public boolean function getHasAttributeByEntityNameAndPropertyIdentifier( required string entityName, required string propertyIdentifier ) {
		return getEntityHasAttributeByEntityName( entityName=getLastEntityNameInPropertyIdentifier(arguments.entityName, arguments.propertyIdentifier), attributeCode=listLast(arguments.propertyIdentifier, "._") );
	}
	
	// @hint returns true or false based on an entityName, and checks if that entity has an extended attribute with that attributeCode
	public boolean function getEntityHasAttributeByEntityName( required string entityName, required string attributeCode ) {
		if(listFindNoCase(getAttributeService().getAttributeCodesListByAttributeSetType( "ast#getProperlyCasedShortEntityName(arguments.entityName)#" ), arguments.attributeCode)) {
			return true;
		}
		return false; 
	}
	
	public boolean function delete(required any entity){
		
		var deleteOK = super.delete(argumentcollection=arguments);
			
		// If the entity Passes validation
		if(deleteOK) {
			
			// Remove all of the entity settings
			getService("settingService").removeAllEntityRelatedSettings( entity=arguments.entity );
			
			// Remove all of the entity comments and comments related to this entity
			getService("commentService").removeAllEntityRelatedComments( entity=arguments.entity );
			
		}

		return deleteOK;
	}
	
	public any function save(required any entity, struct data={}, string context="save"){
		
		arguments.entity = super.save(argumentcollection=arguments);
		
		// If an entity was saved and the activeFlag is now 0 it needs to be removed from all setting values
		if(!arguments.entity.hasErrors() && arguments.entity.hasProperty('activeFlag')) {
			
			var settingsRemoved = 0;
			if(!arguments.entity.getActiveFlag()) {
				var settingsRemoved = getService("settingService").updateAllSettingValuesToRemoveSpecificID( arguments.entity.getPrimaryIDValue() );	
			}
			
			if(settingsRemoved gt 0 || listFindNoCase("Currency,FulfillmentMethod,OrderOrigin,PaymentTerm,PaymentMethod", arguments.entity.getClassName())) {
				getService("settingService").clearAllSettingsCache();
			}
		}
	
		return arguments.entity;
	}

}