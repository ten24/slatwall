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

	property name="attributeService";

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

	public void function updateEntityCalculatedProperties(required any entityName, struct smartListData={}, boolean runInThread=false) {
		
		//Check to see if we need to run this in a new thread or not
		if(arguments.runInThread){
			thread action="run" name="updateEntityCalculatedPropertiesThread" threadData="#arguments#" {
				
				// Run inside a try/catch so we can log errors
				try{
					_updateEntityCalculatedProperties(argumentcollection=threadData);
				} catch(any e){	
					
					// Log the error
					logHibachi( "There was an error updating the calculated properties for the entity type: #threadData.entityName#" );
					logHibachiException( e );
				}
				getHibachiDAO().flushORMSession();
			}
		}else{
			_updateEntityCalculatedProperties(argumentcollection=arguments);
		}
		
	}

	private void function _updateEntityCalculatedProperties(required any entityName, struct smartListData={}){
		// Setup a smart list to figure out how many things to update
		var smartList = getServiceByEntityName( arguments.entityName ).invokeMethod( "get#arguments.entityName#SmartList", {1=arguments.smartListData});
		
		// log the job started
		logHibachi("updateEntityCalculatedProperties starting for #arguments.entityName# with #smartList.getRecordsCount()# records");
		
		// create a local variable for the totalPages
		var totalPages = smartList.getTotalPages();
		
		for(var p=1; p <= totalPages; p++) {
			
			// Log to hibachi the current page
			logHibachi("updateEntityCalculatedProperties starting page: #p#");
			
			// Clear the session, so that it doesn't hog primary cache
			ormClearSession();
			
			// Set the correct page
			smartList.setCurrentPageDeclaration( p );
			
			// Get the records for this page, make sure to pass true so that the old records get cleared out
			var records = smartList.getPageRecords( true );
			
			// Figure out the recordCount we need to loop to
			var rc = arrayLen(records);
			
			// Loop over each record in the page and call update / flush
			for(var r=1; r<=rc; r++) {
				records[r].updateCalculatedProperties();
				ormFlush();
			}
		}
		
		// log the job finished
		logHibachi("updateEntityCalculatedProperties for #arguments.entityName# finished");
	}

}
