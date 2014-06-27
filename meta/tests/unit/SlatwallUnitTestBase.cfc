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
component extends="mxunit.framework.TestCase" output="false" {
	
	variables.debugArray = [];
	variables.persistentEntities = [];

	// BEFORE ALL TESTS IN THIS SUITE
	public void function beforeTests(){
		variables.slatwallFW1Application = createObject("component", "Slatwall.Application");
	}

	// BEFORE EACH TEST
	public void function setUp() {
		variables.slatwallFW1Application.bootstrap();
		
		request.slatwallScope.getAccount().setSuperUserFlag(1);
		
		// Setup a debugging output array
		variables.debugArray = [];
		variables.persistentEntities = [];
	}
	
	// AFTER BEACH TEST
	public void function tearDown() {
		debug(variables.debugArray);
		
		for(var persistentEntity in variables.persistentEntities) {
			entityDelete( persistentEntity );
			ormFlush();
		}
		
		variables.debugArray = [];
		variables.persistentEntities = [];
		
		structDelete(request, 'slatwallScope');
	}
	
	private void function addToDebug( required any output ) {
		arrayAppend(variables.debugArray, arguments.output);
	}
	
	private any function createPersistedTestEntity( required string entityName, struct data={}, boolean persist=true, boolean saveWithService=false ) {
		return createTestEntity(argumentcollection=arguments);
	}
	
	private any function createTestEntity( required string entityName, struct data={}, boolean persist=false, boolean saveWithService=false ) {
		// Create the new Entity
		var newEntity = request.slatwallScope.newEntity( arguments.entityName );
		
		// Save with Service
		if(arguments.saveWithService) {
			
			request.slatwallScope.saveEntity( arguments.entity, arguments.data );
		
		// Save manually
		} else {
			// Populate the data
			newEntity.populate( data );
			
			// Save the entity
			entitySave(newEntity);	
		}
		
		// Persist to the database
		ormFlush();
		
		// Add the entity to the persistentEntities
		arrayAppend(variables.persistentEntities, newEntity);
		
		return newEntity;
	}
	
}
