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

		// Setup Components
		variables.slatwallFW1Application = createObject("component", "Slatwall.Application");

		super.beforeTests();
	}

	// BEFORE EACH TEST
	public void function setUp() {
		variables.slatwallFW1Application.bootstrap();

		request.slatwallScope.getAccount().setSuperUserFlag(1);

		// Setup a debugging output array
		variables.debugArray = [];
		variables.persistentEntities = [];
		variables.files = [];
	}

	// AFTER EACH TEST
	public void function tearDown() {
		debug(variables.debugArray);

		variables.debugArray = [];

		var flushRequired = false;


		for(var i=arrayLen(variables.persistentEntities); i>=1; i--) {
			flushRequired = true;
			entityDelete( variables.persistentEntities[i] );
		}
		
		for (var i = arrayLen(variables.files); i >= 1; i--) {
			fileDelete( variables.files[i] );
		}
		
		try{
			if(flushRequired) {
					ormFlush();
			}
		} catch(any e) {
			debug("Could Not Flush: " & e);
		}

		variables.persistentEntities = [];
		variables.files = [];

		ormClearSession();

		structDelete(request, 'slatwallScope');
	}

	private void function addToDebug( required any output ) {
		arrayAppend(variables.debugArray, arguments.output);
	}

	private any function createPersistedTestEntity( required string entityName, struct data={}, boolean createRandomData=false, boolean persist=true, boolean saveWithService=false ) {
		return createTestEntity(argumentcollection=arguments);
	}
	
	private void function createTestFile (required string fileSourceLocalAbsolutePath, required string relativeFileDestination) {

		var absoluteDest = expandPath('/Slatwall') & arguments.relativeFileDestination;
		
		//create the destination directory if necessary
		if (DirectoryExists(GetDirectoryFromPath(absoluteDest))) {
			fileCopy(arguments.fileSourceLocalAbsolutePath, absoluteDest);
		} else {
			DirectoryCreate(GetDirectoryFromPath(absoluteDest));
			fileCopy(arguments.fileSourceLocalAbsolutePath, absoluteDest);
		}
		
		// Add the filePath to the files array
		arrayAppend(variables.files, absoluteDest);
	}

	private void function addEntityForTearDown(any entity){
		arrayAppend(variables.persistentEntities, entity);
	}

	private any function createTestEntity( required string entityName, struct data={}, boolean createRandomData=false, boolean persist=false, boolean saveWithService=false ) {
		// Create the new Entity
		var newEntity = request.slatwallScope.newEntity( arguments.entityName );

		var arguments.data = createTestEntityData( newEntity, arguments.data, arguments.createRandomData );

		// Check to see if it needs to be persisted
		if(arguments.persist) {

			// Save with Service
			if(arguments.saveWithService) {

				request.slatwallScope.saveEntity( newEntity, arguments.data );

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

		} else {

			// Populate the data
			newEntity.populate( data );

		}

		return newEntity;
	}

	private struct function createTestEntityData( required any entity, struct data={}, boolean createRandomData=false) {

		if(arguments.createRandomData) {
			for(var property in entity.getProperties()) {

				if( !structKeyExists(arguments.data, property.name) ) {

					if(property.name eq "activeFlag") {
						arguments.data.activeFlag = 1;

					} else if (propertyIsPersistentColumn(property)) {

						if(propertyIsString(property)) {
							arguments.data[ property.name ] = generateRandomString(1, 100);

						} else if (propertyIsInteger(property)) {
							arguments.data[ property.name ] = generateRandomInteger(0, 1000);

						} else if (propertyIsDate(property)) {
							arguments.data[ property.name ] = generateRandomDate();

						} else if (propertyIsDateTime(property)) {
							arguments.data[ property.name ] = generateRandomDateTime();

						} else if (propertyIsDecimal(property)) {
							arguments.data[ property.name ] = generateRandomDecimal(0, 1000);

						}

					}
				}
			}
		}

		return arguments.data;
	}

	private boolean function propertyIsPersistentColumn(required struct property) {
		if(structKeyExists(arguments.property, "persistent") && !arguments.property.persistent) {
			return false;
		}
		if(structKeyExists(arguments.property, "fieldType") && arguments.property.fieldType != 'column') {
			return false;
		}
		if(listFindNoCase("createdByAccountID,modifiedByAccountID,remoteID", arguments.property.name)) {
			return false;
		}
		return true;
	}

	private boolean function propertyIsString(required struct property) {
		if(!structKeyExists(arguments.property, "ormtype") || arguments.property.ormtype eq "string") {
			return true;
		}
		return false;
	}

	private boolean function propertyIsInteger(required struct property) {
		if(structKeyExists(arguments.property, "ormtype") && arguments.property.ormtype eq "integer") {
			return true;
		}
		return false;
	}

	private boolean function propertyIsDate(required struct property) {
		if(structKeyExists(arguments.property, "ormtype") && arguments.property.ormtype eq "date") {
			return true;
		}
		return false;
	}

	private boolean function propertyIsDateTime(required struct property) {
		if(structKeyExists(arguments.property, "ormtype") && arguments.property.ormtype eq "timestamp") {
			return true;
		}
		return false;
	}

	private boolean function propertyIsDecimal(required struct property) {
		if(structKeyExists(arguments.property, "ormtype") && arguments.property.ormtype eq "big_decimal") {
			return true;
		}
		return false;
	}

	private string function generateRandomString(minLength, maxLength) {
		var chars = "abcdefghijklmnopqrstuvwxyz -_";
		chars &= ucase(chars);
		var upper = arguments.minLength + round(rand()*(arguments.maxLength - arguments.minLength));

		var returnString = "";
		for(var i=1; i<=upper; i++ ) {
			var randIndex = round(len(chars) * rand()) + 1;

			returnString &= right(left(chars, randIndex), 1);
		}

		return returnString;
	}

	private string function generateRandomInteger(minVal, maxVal) {
		if(arguments.maxVal == arguments.minVal) {
			return arguments.minVal;
		}
		//Deal with invalid range
		if(
		   (arguments.maxVal - arguments.minVal < 0 ) 
		   || (
		   		arguments.maxVal - arguments.minVal < 1
		   		&& arguments.minVal*arguments.maxVal >= 0 
		   		&& fix(arguments.minVal) == fix(arguments.maxVal)
		   	  )
		  ) {
			throw ('There is no integer between #arguments.minVal# and #arguments.maxVal#');
		}
		
		var randomInteger = round(arguments.minVal+rand()*(arguments.maxVal - arguments.minVal));
		
		//Deal with rounded number go beyond the range
		if(randomInteger > arguments.maxVal) {
			return randomInteger - 1;
		} else if(randomInteger < arguments.minVal) {
			return randomInteger + 1;
		}
		return randomInteger;
	}

	private string function generateRandomDate() {
		return createDate(2014, 10, 1);
	}

	private string function generateRandomDateTime() {
		return createDateTime(2013, 10, 8, 5, 08, 22);
	}

	private string function generateRandomDecimal(minVal, maxVal) {
		return 3.45;
	}

}
