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
	    var baseObjectOptions = getService('HibachiService').getEntityNameOptions();
	    return baseObjectOptions;
	}
}