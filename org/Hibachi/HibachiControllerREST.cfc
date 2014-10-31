component output="false" accessors="true" extends="HibachiController" {
	
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