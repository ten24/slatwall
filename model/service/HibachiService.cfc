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
component accessors="true" output="false" extends="Slatwall.org.Hibachi.HibachiService" {
    
    property name="hibachiCacheService";
    
	public any function getSlatwallScope() {
		return getHibachiScope();
	} 
	
	// @hint leverages the getEntityHasAttributeByEntityName() by traverses a propertyIdentifier first using getLastEntityNameInPropertyIdentifier()
	public boolean function getHasAttributeByEntityNameAndPropertyIdentifier( required string entityName, required string propertyIdentifier ) {
		var cacheKey = "HibachiService_getHasAttributeByEntityNameAndPropertyIdentifier_#arguments.entityName##arguments.propertyIdentifier#";
		if(!this.getHibachiCacheService().hasCachedValue(cacheKey) ){
			var result = getEntityHasAttributeByEntityName( 
				entityName=getLastEntityNameInPropertyIdentifier(
					arguments.entityName, 
					arguments.propertyIdentifier
				), 
				attributeCode=listLast(arguments.propertyIdentifier, ".") 
			);
			this.getHibachiCacheService().setCachedValue(cacheKey,result);
		}
		
		return this.getHibachiCacheService().getCachedValue(cacheKey);
	}
	
	// @hint returns true or false based on an entityName, and checks if that entity has an extended attribute with that attributeCode
	public boolean function getEntityHasAttributeByEntityName( required string entityName, required string attributeCode ) {
		var attributeCodesList = this.getHibachiCacheService().getOrCacheFunctionValue("attributeService_getAttributeCodesListByAttributeSetObject_#getProperlyCasedShortEntityName(arguments.entityName)#", "attributeService", "getAttributeCodesListByAttributeSetObject", {1=getProperlyCasedShortEntityName(arguments.entityName)});
		
		if(listFindNoCase(attributeCodesList, arguments.attributeCode)) {
			return true;
		}
		return false; 
	}
	
	public boolean function delete(required any entity){
		
		// Setup delete variable
		var deleteOK = false;
		
		// Do delete validation
		arguments.entity.validate(context="delete");
			
		// If the entity Passes validation
		if(!arguments.entity.hasErrors()) {
			
			// Remove all of the entity settings
			getService("settingService").removeAllEntityRelatedSettings( entity=arguments.entity );
			
			// Remove all of the entity comments and comments related to this entity
			getService("commentService").removeAllEntityRelatedComments( entity=arguments.entity );
			
			// Remove all of the entity files
			getService("fileService").removeAllEntityRelatedFiles( entity=arguments.entity );
			
			deleteOK = super.delete(argumentcollection=arguments);
		}

		return deleteOK;
	}
	
	public any function save(required any entity, struct data={}, string context="save"){
		
		arguments.entity = super.save(argumentcollection=arguments);
		
		// If an entity was saved and the activeFlag is now 0 it needs to be removed from all setting values
		if(!arguments.entity.hasErrors() && arguments.entity.hasProperty('activeFlag') && !isNull(arguments.entity.getActiveFlag())) {
			
			var settingsRemoved = 0;
			if(!arguments.entity.getActiveFlag()) {
				var settingsRemoved = getService("settingService").updateAllSettingValuesToRemoveSpecificID( arguments.entity.getPrimaryIDValue() );	
			}
			
		}
	
		return arguments.entity;
	}
	
	
	
	public string function getAttributeCodeListByEntityName(required string entityName){
		arguments.entityName = getProperlyCasedFullClassNameByEntityName( arguments.entityName );
		var cacheKey = "classAttributeCodeListByEntityNameCache_#arguments.entityName#";
		//first check hibachi cache
		if( this.getHibachiCacheService().hasCachedValue(cacheKey) ) {
			return this.getHibachiCacheService().getCachedValue(cacheKey);
		}
		
		return getEntityObject( arguments.entityName ).getAttributesCodeList();
	}
	
	public array function getAttributesArrayByEntityName(required string entityName){
		arguments.entityName = getProperlyCasedFullClassNameByEntityName( arguments.entityName );
		var cacheKey = "classAttributesArrayByEntityNameCache_#arguments.entityName#";
		
		if( !this.getHibachiCacheService().hasCachedValue(cacheKey) ) {
			this.getHibachiCacheService().setCachedValue(cacheKey, getEntityObject( arguments.entityName ).getAttributesArray() );
		}
		
		return this.getHibachiCacheService().getCachedValue(cacheKey);
	}
	
	public any function getAttributesPropertiesByEntityName(required string entityName){
		arguments.entityName = getProperlyCasedFullClassNameByEntityName( arguments.entityName );
		var cacheKey = "classAttributesPropertiesByEntityNameCache_#arguments.entityName#";
		
		if( !this.getHibachiCacheService().hasCachedValue(cacheKey) ) {
			this.getHibachiCacheService().setCachedValue(cacheKey, getEntityObject( arguments.entityName ).getAttributesProperties() );
		}
		
		return this.getHibachiCacheService().getCachedValue(cacheKey);
	}
	
	public any function getPropertiesWithAttributesByEntityName(required string entityName, boolean includeNonPersistent = false){
		
		var entityObject = getEntityObject( arguments.entityName );
		var properties = entityObject.getFilterProperties("","", includeNonPersistent);
		
		return properties;
	}
	
	public any function getFilterPropertiesByEntityName(required string entityName){
		var cacheKey = "classDefaultFilterablePropertyCache_#getProperlyCasedFullClassNameByEntityName( arguments.entityName )#";
		
		// First Check the application cache
		if( !this.getHibachiCacheService().hasCachedValue(cacheKey) ) {
			this.gethibachiCacheService().setCachedValue(cacheKey, getEntityObject( arguments.entityName ).getFilterProperties() );
		}
		
		return this.getHibachiCacheService().getCachedValue(cacheKey);
	}
	
	
	//used by the rest api to return default property values
	public any function getDefaultPropertyIdentifiersListByEntityName(required string entityName, string includesList, string excludesList){
		// First Check the application cache
		var cacheKey = 'getDefaultPropertyIdentifiersListByEntityName#hash(arguments.entityName&arguments.includesList&arguments.excludesList,'md5')#';
		
		if(!this.getHibachiCacheService().hasCachedValue(cacheKey)) {
			var pidList = getEntityObject( arguments.entityName ).getDefaultPropertyIdentifiersList(argumentsCollection = arguments);
			this.gethibachiCacheService().setCachedValue(cacheKey, pidList);
		}

		return this.getHibachiCacheService().getCachedValue(cacheKey);
	}
	
	/**
	 * Method to return list of public attribute codes
	*/
	public array function getPublicAttributesByEntityName( required string entityName ){
		var cacheKey = "getPublicAttributesByEntityName_#arguments.entityName#";
		
		if(!this.getHibachiCacheService().hasCachedValue(cacheKey) ){
			var attributeCollectionList = getService('attributeService').getAttributeCollectionList();
			attributeCollectionList.setDisplayProperties('attributeCode');
			attributeCollectionList.addFilter('publicPropertyFlag', 1);
			attributeCollectionList.addFilter('attributeSet.attributeSetObject', arguments.entityName);
			
			//XXX: this leads to stack-overflow, while trying to apply permissions
			attributeCollectionList.setPermissionAppliedFlag(true);
			
			var attributeRecords = attributeCollectionList.getRecords(formatRecords = false);
			
			var response = [];
			for( var attribute in attributeRecords) {
				ArrayAppend( response , attribute['attributeCode'] );
			}
			
			this.getHibachiCacheService().setCachedValue(cacheKey, response);
		}
			
		return this.getHibachiCacheService().getCachedValue(cacheKey);
	}
}
