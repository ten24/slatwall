component displayname="ImporterMapping" entityname="SlatwallImporterMapping" table="SwImporterMapping" persistent="true" hb_permission="this" accessors="true" extends="HibachiEntity" hb_serviceName="importerMappingService" hb_processContexts="" {
    
    // Persistent Properties
	property name="importerMappingID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
    property name="name" ormtype="string";
    property name="mappingCode" ormtype="string";
    property name="description" ormtype="string";
    property name="baseObject" ormtype="string" hb_formFieldType="select";
    property name="mapping" ormtype="string" length="8000" hb_formFieldType="json";
    
    // Audit Properties 
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	property name="baseObjectOptions" persistent="false";
	
	//returns an array of name/value structs for
	public array function getBaseObjectOptions() {
	    if(!structKeyExists(variables, "baseObjectOptions") ){
			
			var entitiesMetaData = this.getService("hibachiService").getEntitiesMetaData();
			var entitiesMetaDataArray = listToArray(structKeyList(entitiesMetaData));
			arraySort(entitiesMetaDataArray,"text");
			
			var baseObjectOptions = [];
			for( var i=1; i<=arrayLen(entitiesMetaDataArray); i++ ){
				//only show what you are authenticated to make
				if( this.getHibachiScope().authenticateEntity('read', entitiesMetaDataArray[i]) ){
					arrayAppend( baseObjectOptions, {name=rbKey('entity.#entitiesMetaDataArray[i]#'), value=entitiesMetaDataArray[i]});
				}
			}
		    variables.baseObjectOptions	= baseObjectOptions;
		}
		
		return variables.baseObjectOptions;
	}
	
	
	public boolean function isValidImporterMapping(){
	    var validation = this.getService('importerMappingService').isValidImporterMappingConfig(this.getMapping());
	    if(!validation.isValid){
	        for(var i=1; i<=validation.errors.len(); i++){
	            this.addError("mapping-error-#i#", validation.errors[i]);
	        }
	    }
	    
	    return validation.isValid;
	}
	
		
	public string function getSimpleRepresentationPropertyName() {
	    return "name";
	}
}