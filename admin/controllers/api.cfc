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
component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiController" {
	
	property name="hibachiService" type="any";
	
	this.restController = true;
	
	public void function get( required struct rc ) {
		
		// This is the response object that will be serialized and sent back
		rc.response = {};
		
		// Get the correct service for the entity
		var entityService = getHibachiService().getServiceByEntityName( entityName=arguments.rc.entityName );
		
		// Lets figure out the properties that need to be returned
		if(!structKeyExists(rc, "propertyIdentifiers")) {
			rc.propertyIdentifiers = "";
			var entityProperties = getHibachiService().getPropertiesByEntityName( rc.entityName );
			
			for(var i=1; i<=arrayLen(entityProperties); i++) {
				if( (!structKeyExists(entityProperties[i], "fieldtype") || entityProperties[i].fieldtype == "ID") && (!structKeyExists(entityProperties[i], "persistent") || entityProperties[i].persistent)) {
					rc.propertyIdentifiers = listAppend(rc.propertyIdentifiers, entityProperties[i].name);
				} else if(structKeyExists(entityProperties[i], "fieldtype") && entityProperties[i].fieldType == "many-to-one") {
					rc.propertyIdentifiers = listAppend(rc.propertyIdentifiers, "#entityProperties[i].name#.#getHibachiService().getPrimaryIDPropertyNameByEntityName(entityProperties[i].cfc)#" );
				}
			}
		}
		
		// Turn the property identifiers into an array
		var piArray = listToArray( rc.propertyIdentifiers );
		
		// ========================= If there is an entityID
		if(structKeyExists(arguments.rc, "entityID")) {
			var entity = entityService.invokeMethod("get#arguments.rc.entityName#", {1=arguments.rc.entityID});
			
			for(var p=1; p<=arrayLen(piArray); p++) {
				rc.response[ piArray[p] ] = entity.getValueByPropertyIdentifier( propertyIdentifier=piArray[p], formatValue=true );
			}
			
		// ========================= If ther is no entityID then get a smart list
		} else {
			
			// Get the header information
			var smartList = entityService.invokeMethod("get#arguments.rc.entityName#SmartList", {1=arguments.rc});
			
			rc.response[ "recordsCount" ] = smartList.getRecordsCount();
			rc.response[ "pageRecordsCount" ] = arrayLen(smartList.getPageRecords());
			rc.response[ "pageRecordsShow"] = smartList.getPageRecordsShow();
			rc.response[ "pageRecordsStart" ] = smartList.getPageRecordsStart();
			rc.response[ "pageRecordsEnd" ] = smartList.getPageRecordsEnd();
			rc.response[ "currentPage" ] = smartList.getCurrentPage();
			rc.response[ "totalPages" ] = smartList.getTotalPages();
			rc.response[ "savedStateID" ] = smartList.getSavedStateID();
			rc.response[ "hql" ] = smartList.getHQL();
			rc.response[ "pageRecords" ] = [];
			
			var smartListPageRecords = smartList.getPageRecords();
			for(var i=1; i<=arrayLen(smartListPageRecords); i++) {
				var thisRecord = {};
				for(var p=1; p<=arrayLen(piArray); p++) {
					var value = smartListPageRecords[i].getValueByPropertyIdentifier( propertyIdentifier=piArray[p], formatValue=true );
					if((len(value) == 3 and value eq "YES") or (len(value) == 2 and value eq "NO")) {
						thisRecord[ piArray[p] ] = value & " ";
					} else {
						thisRecord[ piArray[p] ] = value;
					}
				}
				arrayAppend(rc.response[ "pageRecords" ], thisRecord);
			}
		}
		
		writeOutput( serializeJSON(rc.response) );
		abort;
	}
	
	public void function post( required struct rc ) {
		rc.response = {};
		
		writeOutput( serializeJSON(rc.response) );
		abort;
	}
	
}
