component displayname="ImporterMapping" entityname="SlatwallImporterMapping" table="SwImporterMapping" persistent="true" hb_permission="this" accessors="true" extends="HibachiEntity" hb_serviceName="hibachiService" hb_processContexts="" {
    
    // Persistent Properties
	property name="importerMappingID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
    property name="name" ormtype="string";
    property name="description" ormtype="string";
    property name="baseObject" ormtype="string" hb_formFieldType="select";
    property name="mapping" ormtype="string" hb_formFieldType="json";
    
    // Audit Properties 
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	property name="baseObjectOptions" persistent="false";
	
	//returns an array of name/value structs for
	public array function getBaseObjectOptions() {
		if(!structKeyExists(variables, "baseObjectOptions")) {
			var entitiesMetaData = getService("hibachiService").getEntitiesMetaData();
			var entitiesMetaDataArray = listToArray(structKeyList(entitiesMetaData));
			arraySort(entitiesMetaDataArray,"text");
			variables.baseObjectOptions = [];
			for(var i=1; i<=arrayLen(entitiesMetaDataArray); i++) {
				//only show what you are authenticated to make
				if(getHibachiScope().authenticateEntity('read', entitiesMetaDataArray[i])){
					arrayAppend(variables.baseObjectOptions, {name=rbKey('entity.#entitiesMetaDataArray[i]#'), value=entitiesMetaDataArray[i]});
				}
			}
		}
		return variables.baseObjectOptions;
	}
}