component output="false" accessors="true" persistent="false" extends="HibachiTransient" {

	property name="newFlag" type="boolean" persistent="false";
	property name="rollbackProcessedFlag" type="boolean" persistent="false";
	property name="encryptedPropertiesExistFlag" type="boolean" persistent="false";
	property name="printTemplates" type="struct" persistent="false";
	property name="emailTemplates" type="struct" persistent="false";
	property name="simpleRepresentation" type="string" persistent="false";
	property name="persistableErrors" type="array" persistent="false";
	property name="processObjects" type="struct" persistent="false";
	property name="auditSmartList" type="any" persistent="false";

	// Audit Properties
	property name="createdByAccount" persistent="false";
	property name="modifiedByAccount" persistent="false";

	public void function postLoad(){
		if( !setting("globalDisableRecordLevelPermissions")
			&& !this.getNewFlag() 
			&& getService('HibachiAuthenticationService').hasPermissionRecordRestriction(getClassName())
			&& !getHibachiScope().getAccount().getSuperUserFlag()
		){
			try{
				var entityCollectionList = getService('HibachiCollectionService').invokeMethod('get#this.getClassName()#CollectionList');
				var entityService = this.getEntityService();
				var primaryIDName = getService('HibachiService').getPrimaryIDPropertyNameByEntityName(getClassName());
				entityCollectionList.setDisplayProperties(primaryIDName);
				entityCollectionList.addFilter(primaryIDName,getPrimaryIDValue());
				entityCollectionList.setCheckDORPermissions(true);

				var entityCollectionRecordsCount = entityCollectionList.getRecordsCount();
				//if the collection returns a record then 
				if(!entityCollectionRecordsCount){
					throwNoAccess();				
				}
			}catch(any e){
				writedump(var=e);abort;
 			}
		}
	}
	
	private void function throwNoAccess(){
		var context = getPageContext();
		status = 403;
		context.getResponse().setStatus(status, "no access");
		throw(type="Application",message='no access to #getClassName()#');
	}
	
	// @hint global constructor arguments.  All Extended entities should call super.init() so that this gets called
	public any function init() {
		variables.processObjects = {};
		
		if(getHibachiScope().hasApplicationValue("initialized") && getHibachiScope().getApplicationValue("initialized")){
			var properties = getService('HibachiService').getToManyPropertiesByEntityName(getClassName());
			var propertyCount = arrayLen(properties);
			// Set any one-to-many or many-to-many properties with a blank array as the default value
			for(var i=1; i<=propertyCount; i++) {
				variables[ properties[i] ] = [];
			}
		}else{
			var properties = getProperties();
			var propertyCount = arrayLen(properties);
			// Loop over all properties
			for(var i=1; i<=propertyCount; i++) {
				// Set any one-to-many or many-to-many properties with a blank array as the default value
				if(structKeyExists(properties[i], "fieldtype") && listFindNoCase("many-to-many,one-to-many", properties[i].fieldtype) && !structKeyExists(variables, properties[i].name) ) {
					variables[ properties[i].name ] = [];
				}
			}
		}
		if(structKeyExists(this,'getActiveFlag') && isNull(getActiveFlag())){
			setActiveFlag(1);
		}

		return super.init();
	}

	public any function getEntityService(){ 
		return getService('HibachiService').getServiceByEntityName( entityName=getClassName() ); 
	} 

	public struct function getStructRepresentation(){
		return getEntityService().invokeMethod('get#getClassName()#Struct',{1=this.getPrimaryIDValue()});
	}

	public string function getJsonRepresentation(){
		return serializeJson(this.getStructRepresentation()); 
	} 

	public string function getEncodedJsonRepresentation(){ 
		return encodeForHTML(this.getJsonRepresentation()); 
	} 

	public string function getTableName(){
		return getService('hibachiService').getTableNameByEntityName(getClassName());
	}

	public void function genericPropertyRemove(required string propertyName){
		evaluate("set#arguments.propertyName#(javacast('null',''))");
	}

	public string function getUploadDirectoryByPropertyName(required string propertyName){
		var uploadDirectory = setting('globalAssetsFileFolderPath') & "/";

		uploadDirectory &= "#lcase(arguments.propertyName)#/";

		return uploadDirectory;
	}

	public string function getFileUrlByPropertyName(required string propertyName){
		return getURLFromPath(invokeMethod('get#arguments.propertyName#UploadDirectory')) & invokeMethod('get#arguments.propertyName#');
	}
	
	public boolean function getCalculatedUpdateRunFlag(){
		if(structKeyExists(variables,'calculatedUpdateRunFlag')){
			return variables.calculatedUpdateRunFlag;	
		}
		return false;
	}
	
	public void function setCalculatedUpdateRunFlag(boolean calculatedUpdateRunFlagValue){
		variables.calculatedUpdateRunFlag = arguments.calculatedUpdateRunFlagValue;
	}
	
	/** runs a update calculated properties only once per request unless explicitly set to false before calling. */
	public void function updateCalculatedProperties(boolean runAgain=false) {
        if(!structKeyExists(variables, "calculatedUpdateRunFlag") || runAgain) {
            // Set calculated to true so that this only runs 1 time per request unless explicitly told to run again.
            variables.calculatedUpdateRunFlag = true;
            // Loop over all properties
            for(var property in getProperties()) {

                // Look for any that start with the calculatedXXX naming convention
                if(left(property.name, 10) == "calculated" && (!structKeyExists(property, "persistent") || property.persistent == "true")) {
					//prior to invoking we should remove any first level caching that would cause a stale calculation
					var nonPersistentProperty = right(property.name, len(property.name)-10);
					if(listFindNoCase('Product,Sku,Stock,SkuLocationQuantity',this.getClassName())){
						var inventoryProperties = listToArray('QOH,QOSH,QNDOO,QNDORVO,QNDOSA,QNRORO,QNROVO,QNROSA,QC,QE,QNC,QATS,QIATS');
						for(var inventoryProperty in inventoryProperties){
							if(structKeyExists(variables,inventoryProperty)){
								structDelete(variables,inventoryProperty);
							}
						}
					}

                    var value = this.invokeMethod("get#nonPersistentProperty#");

                    if(!isNull(value)) {
                        variables[ property.name ] = value;
                    }

                } else if (structKeyExists(property, "hb_cascadeCalculate") && property.hb_cascadeCalculate && structKeyExists(variables, property.name) && isObject( variables[ property.name ] ) ) {

                    variables[ property.name ].updateCalculatedProperties();

                }
            }

        }
    }

    public string function getParentPropertyName(){
    	return getService('hibachiService').getParentPropertyByEntityName(getClassName());
    }


	// @hint return a simple representation of this entity
	public string function getSimpleRepresentation() {

		// Try to get the actual value of that property
		var representation = this.invokeMethod("get#getSimpleRepresentationPropertyName()#");

		// If the value isn't null, and it is simple, then return it.
		if(!isNull(representation) && isSimpleValue(representation)) {
			return representation;
		}

		// Default case is to return a blank value
		return "";
	}

	// @hint returns the propety who's value is a simple representation of this entity.  This can be overridden when necessary
	public string function getSimpleRepresentationPropertyName() {

		// Look for a property that's last 4 is "name"
		for(var thisProperty in getProperties()) {
			if((!structKeyExists(thisProperty, "persistent") || thisProperty.persistent) && thisProperty.name == "#getClassName()#name") {
				return thisProperty.name;
			}
		}

		// If no properties could be identified as a simpleRepresentaition
		return getPrimaryIDPropertyName();
	}

	// @hint checks a one-to-many property for the first entity with errors, if one isn't found then it returns a new one
	public any function getNewPropertyEntity( required string propertyName ) {
		if(!structKeyExists(variables, "requestNewPropertyEntity#arguments.propertyName#")) {

			// Get Property Value
			var propertyValue = this.invokeMethod("get#arguments.propertyName#");

			// Find in an array
			if(isArray(propertyValue)) {
				for(var entity in propertyValue) {
					if(entity.hasErrors() && entity.getNewFlag()) {
						variables[ "requestNewPropertyEntity#arguments.propertyName#" ] = entity;
						break;
					}
				}
			// Property is Object
			} else if (isObject(propertyValue) && propertyValue.hasErrors() && propertyValue.getNewFlag()) {
				variables[ "requestNewPropertyEntity#arguments.propertyName#" ] = entity;
			}

			if(!structKeyExists(variables, "requestNewPropertyEntity#arguments.propertyName#")) {
				var entityName =  getPropertyMetaData(arguments.propertyName).cfc;
				variables[ "requestNewPropertyEntity#arguments.propertyName#" ] = getService("hibachiService").getServiceByEntityName( entityName ).invokeMethod("new#entityName#");
			}
		}

		return variables[ "requestNewPropertyEntity#arguments.propertyName#" ];
	}

	public any function duplicate(boolean onlyPersistent=false) {
		var newEntity = getService("hibachiService").getServiceByEntityName(getEntityName()).invokeMethod("new#replace(getEntityName(),getApplicationValue('applicationKey'),'')#");
		var properties = getProperties();
		var propertyIsPersistent = true;

		for(var p=1; p<=arrayLen(properties); p++) {
			if(
				arguments.onlyPersistent
				&& structKeyExists(properties[p],'persistent')
			){
				propertyIsPersistent = properties[p].persistent;
			}else{
				propertyIsPersistent = true;
			}

			if(
				(
					!arguments.onlyPersistent
					|| (
						arguments.onlyPersistent
						&& propertyIsPersistent
					)
				)
				&& properties[p].name != getPrimaryIDPropertyName()
				&& (
					!structKeyExists(properties[p], "fieldType")
					|| ( properties[p].fieldType != "one-to-many" && properties[p].fieldType != "many-to-many")
				)
				&&(
					structKeyExists(this,'set#properties[p].name#')
				)
			) {
				var value = invokeMethod('get#properties[p].name#');
				if(!isNull(value)) {
					newEntity.invokeMethod("set#properties[p].name#", {1=value});
				}
			}
		}
		return newEntity;
	}

	// @hint we override this to add error keys check the errors in process objects
	public struct function getErrors() {

		// Get the current struct of errors that this object has
		var originalErrors = super.getErrors();

		// Inject a generic error for any processObjects that have errors
		for(var key in variables.processObjects) {
			if(variables.processObjects[key].hasErrors() && ( !structKeyExists(originalErrors, "processObjects") || !arrayFindNoCase(originalErrors.processObjects, key) ) ) {
				addError('processObjects', key, true);
			}
		}

		// Now that any processObject errors have been added we can recall the super.getErrors() method to give all errors
		return super.getErrors();
	}

	// @hint overriding the addError method to allow for saying that the error doesn't effect persistance
	public void function addError( required string errorName, required any errorMessage, boolean persistableError=false ) {
		if(persistableError) {
			addPersistableError(arguments.errorName);
		}
		super.addError(argumentCollection=arguments);
	}

	// @hint this allows you to add error names to the persistableErrors property, later used by the 'isPersistable' method
	public void function addPersistableError(required string errorName) {
		arrayAppend(getPersistableErrors(), arguments.errorName);
	}

	// @hint Returns the persistableErrors array, if one hasn't been setup yet it returns a new one
	public array function getPersistableErrors() {
		if(!structKeyExists(variables, "persistableErrors")) {
			variables.persistableErrors = [];
		}
		return variables.persistableErrors;
	}

	// @hint this method is defined so that it can be overriden in entities and a different validation context can be applied based on what this entity knows about itself
	public any function getProcessObject(required string context, struct injectValues={}) {
		if(!structKeyExists(variables.processObjects, arguments.context)) {
			variables.processObjects[ arguments.context ] = getTransient("#getClassName()#_#arguments.context#");
			variables.processObjects[ arguments.context ].invokeMethod("set#getClassName()#", {1=this});
			for(var key in arguments.injectValues) {
				variables.processObjects[ arguments.context ].invokeMethod("set#key#", {1=arguments.injectValues[key]});
			}
			variables.processObjects[ arguments.context ].setupDefaults();
		}
		return variables.processObjects[ arguments.context ];
	}

	// @hint this method is defined so that it can be overriden in entities and a different validation context can be applied based on what this entity knows about itself
	public void function setProcessObject( required any processObject ) {
		arguments.processObject.invokeMethod("set#this.getClassName()#", {1=this});
		variables.processObjects[ listLast(arguments.processObject.getClassName(), "_") ] = arguments.processObject;
	}

	// @hint this method checks to see if there is a process object for a particular context
	public boolean function hasProcessObject(required string context) {
		if(getBeanFactory().containsBean("#getClassName()#_#arguments.context#")) {
			return true;
		}
		return false;
	}

	// @hint allows for processObjects to be cleared out of the variables scope so that a new one will be added in
	public void function clearProcessObject( required string context ) {
		structDelete(variables.processObjects, arguments.context);
	}

	// @hint public method to determine if this entity can be deleted
	public boolean function isDeletable() {
		return !getService("hibachiValidationService").validate(object=this, context="delete", setErrors=false).hasErrors();
	}

	// @hint public helper method that delegates to isDeletable
	public boolean function isNotDeletable() {
		return !isDeletable();
	}

	// @hint public method to determine if this entity can be deleted
	public boolean function isEditable() {
		return !getService("hibachiValidationService").validate(object=this, context="edit", setErrors=false).hasErrors();
	}

	// @hint public helper method that delegates to isDeletable
	public boolean function isNotEditable() {
		return !isEditable();
	}

	// @hint public method to determine if this entity can be 'processed', by default it returns true by you can override on an entity by entity basis
	public boolean function isProcessable( string context="process" ) {
		return !getService("hibachiValidationService").validate(object=this, context=arguments.context, setErrors=false).hasErrors();
	}

	// @hint public helper method that delegates to isProcessable
	public boolean function isNotProcessable( string context="process" ) {
		return !isProcessable( context=arguments.context );
	}

	// @hint this will tell us if any of the errors in VTResult or ErrorBean, do not have corispoding key in the persistanceOKList
	public boolean function isPersistable() {
		for(var errorName in getErrors()) {
			if(!arrayFind(getPersistableErrors(), errorName)) {
				return false;
			}
		}
		return true;
	}

	public boolean function getAuditRollbackValidFlag() {
		return !validateAuditRollback().hasErrors();
	}

	public any function validateAuditRollback(boolean setErrors=false) {
		return getService("hibachiValidationService").validate(object=this, context="auditRollback", setErrors=arguments.setErrors);
	}

	// @hint public method to determine if this entity is audited
	public any function getAuditableFlag() {
		var metaData = getThisMetaData();
		if(isPersistent() && (setting('globalAuditAutoArchiveVersionLimit') > 0) && (!structKeyExists(metaData, "hb_auditable") || (structKeyExists(metaData, "hb_auditable") && metaData.hb_auditable))) {
			return true;
		}
		return false;
	}

	// @hint Returns a smart list of audits related to this entity
	public any function getAuditSmartList() {
		if(!structKeyExists(variables, "auditSmartList")) {
			variables.auditSmartList = getService("hibachiAuditService").getAuditSmartListForEntity(entity=this);
			variables.auditSmartList.addOrder("auditDateTime|DESC");
		}

		return variables.auditSmartList;
	}

	// @hint public method that returns the value from the primary ID of this entity
	public string function getPrimaryIDValue() {
		return this.invokeMethod("get#getPrimaryIDPropertyName()#");
	}

	// @hint public method that returns the primary identifier column.  If there is no primary identifier column it throws an error
	public string function getPrimaryIDPropertyName() {
		return getService("hibachiService").getPrimaryIDPropertyNameByEntityName( getEntityName() );
	}

	// @hint public method that returns and array of ID columns
	public any function getIdentifierColumnNames() {
		return getService("hibachiService").getIdentifierColumnNamesByEntityName( getEntityName() );
	}

	// @hint public method that return the ID of the
	public any function getIdentifierValue() {
		var identifierColumns = getIdentifierColumnNames();
		var idValue = "";
		for(var i=1; i <= arrayLen(identifierColumns); i++){
			if(structKeyExists(variables, identifierColumns[i])) {
				idValue &= variables[identifierColumns[i]];
			}
		}
		return idValue;
	}

	// @hint this public method is called right before deleting an entity to make sure that all of the many-to-many relationships are removed so that it doesn't violate fkconstrint
	public any function removeAllManyToManyRelationships() {

		// Loop over all properties
		for(var i=1; i<=arrayLen(getProperties()); i++) {
			// Set any one-to-many or many-to-many properties with a blank array as the default value
			if(structKeyExists(getProperties()[i], "fieldtype") && getProperties()[i].fieldtype == "many-to-many" && ( !structKeyExists(getProperties()[i], "cascade") || !listFindNoCase("all-delete-orphan,delete,delete-orphan", getProperties()[i].cascade) ) ) {
				var relatedEntities = variables[ getProperties()[i].name ];
				if (!isNull(relatedEntities) && isArray(relatedEntities) && arrayLen(relatedEntities)){
 					for(var e = arrayLen(relatedEntities); e >= 1; e--) {
 						 this.invokeMethod("remove#getProperties()[i].singularname#", {1=relatedEntities[e]});
 					}
  				}
			}
		}
	}

	// @hint public method that returns the full entityName
	public string function getEntityName(){
		return getMetaData(this).entityname;
	}

	// @hint public method that overrides the standard getter so that null values won't be an issue
	public any function getCreatedDateTime() {
		if(isNull(variables.createdDateTime)) {
			return "";
		}
		return variables.createdDateTime;
	}

	// @hint public method that overrides the standard getter so that null values won't be an issue
	public any function getModifiedDateTime() {
		if(isNull(variables.modifiedDateTime)) {
			return "";
		}
		return variables.modifiedDateTime;
	}

	// @hint private method to help build IDPath lists based on parent properties
	public string function buildIDPathList(required string parentPropertyName) {
		var idPathList = "";

		var thisEntity = this;
		var hasParent = true;

		do {
			idPathList = listPrepend(idPathList, thisEntity.getPrimaryIDValue());
			if( isNull( evaluate("thisEntity.get#arguments.parentPropertyName#()") ) ) {
				hasParent = false;
			} else {
				thisEntity = evaluate("thisEntity.get#arguments.parentPropertyName#()");
			}
		} while( hasParent );

		return idPathList;
	}


	// @hint returns true the passed in property has value that is unique, and false if the value for the property is already in the DB
	public boolean function hasUniqueProperty( required string propertyName ) {
		return getBean("hibachiDAO").isUniqueProperty(propertyName=propertyName, entity=this);
	}

	public boolean function hasUniqueOrNullProperty( required string propertyName ) {
		if(!structKeyExists(variables, arguments.propertyName) || isNull(variables[arguments.propertyName])) {
			return true;
		}
		return getBean("hibachiDAO").isUniqueProperty(propertyName=propertyName, entity=this);
	}

	// @hint returns true if given property contains any of the entities passed into the entityArray argument.
	public boolean function hasAnyInProperty( required string propertyName, array entityArray ) {

		for(var entity in arguments.entityArray) {
			// evaluate is used instead of invokeMethod() because hasXXX() is an implicit orm function
			if( evaluate("has#propertyName#( entity )") ){
				return true;
			}
		}
		return false;

	}

	public string function getPropertyAssignedIDList( required string propertyName ) {
		var cacheKey = "#arguments.propertyName#AssignedIDList";

		if(!structKeyExists(variables, cacheKey)) {
			variables[ cacheKey ] = '';
			var smartList = this.getPropertySmartList(arguments.propertyName);
			smartList.addSelect(propertyIdentifier=getService("hibachiService").getPrimaryIDPropertyNameByEntityName(listLast(getPropertyMetaData( arguments.propertyName ).cfc,'.')), alias="value");
			//Set array to string
			for(var i=1; i<=arrayLen(smartList.getRecords()); i++) {

				variables[ cacheKey ] = listAppend(variables[ cacheKey ], smartList.getRecords()[i]['value'] );
			}
		}
		return variables[ cacheKey ];
	}

	public string function getPropertyPrimaryID( required string propertyName ) {
		var propertyValue = invokeMethod("get#arguments.propertyName#");
		if(!isNull(propertyValue) && isObject(propertyValue) && propertyValue.isPersistent()) {
			return propertyValue.getPrimaryIDValue();
		}

		return "";
	}


	// @hint returns an array of name/value pairs that can function as options for a many-to-one property
	public array function getPropertyOptions( required string propertyName ) {

		var cacheKey = "#arguments.propertyName#Options";

		if(!structKeyExists(variables, cacheKey)) {
			variables[ cacheKey ] = [];

			var collectionList = getPropertyOptionsCollectionList( arguments.propertyName );

			var propertyMeta = getPropertyMetaData( propertyName );

			if(structKeyExists(propertyMeta, "hb_optionsNameProperty")) {
				collectionList.addDisplayProperty("#propertyMeta.hb_optionsNameProperty#|value");
			} else {
				var exampleEntity = entityNew("#getApplicationValue('applicationKey')##listLast(getPropertyMetaData( arguments.propertyName ).cfc,'.')#");
				collectionList.addDisplayProperty("#exampleEntity.getSimpleRepresentationPropertyName()#|name");
			}
			if(structKeyExists(propertyMeta, "hb_optionsValueProperty")) {
				collectionList.addDisplayProperty("#propertyMeta.hb_optionsValueProperty#|value");
			} else {
				collectionList.addDisplayProperty("#getService("hibachiService").getPrimaryIDPropertyNameByEntityName(listLast(getPropertyMetaData( arguments.propertyName ).cfc,'.'))#|value");
			}

			if(structKeyExists(propertyMeta, "hb_optionsAdditionalProperties")) {
				var additionalPropertiesArray = listToArray(propertyMeta.hb_optionsAdditionalProperties);
				for(var p=1; p<=arrayLen(additionalPropertiesArray); p++) {
					collectionList.addDisplayProperty("#additionalPropertiesArray[p]#|#replace(additionalPropertiesArray[p],'.','_','all')#");
				}
			}

			variables[ cacheKey ] = collectionList.getRecords();

			// If this is a many-to-one related property, then add a 'select' to the top of the list
			if(getPropertyMetaData( propertyName ).fieldType == "many-to-one" && structKeyExists(getPropertyMetaData( propertyName ), "hb_optionsNullRBKey")) {
				var recordsStruct = {};
				recordsStruct['value'] = "";
				recordsStruct['name'] = rbKey(getPropertyMetaData( propertyName ).hb_optionsNullRBKey);
				arrayPrepend(variables[ cacheKey ], recordsStruct);
			}
		}

		return variables[ cacheKey ];

	}

	// @hint returns a smart list or records that can be used as options for a many-to-one property
	public any function getPropertyOptionsSmartList( required string propertyName ) {
		var cacheKey = "#arguments.propertyName#OptionsSmartList";

		if(!structKeyExists(variables, cacheKey)) {

			var propertyMeta = getPropertyMetaData( arguments.propertyName );
			var entityService = getService("hibachiService").getServiceByEntityName( listLast(propertyMeta.cfc,'.') );

			variables[ cacheKey ] = entityService.invokeMethod("get#listLast(propertyMeta.cfc,'.')#SmartList");

			// If there was an hb_optionsSmartListData defined, then we can now apply that data to this smart list
			if(structKeyExists(propertyMeta, "hb_optionsSmartListData")) {
				variables[ cacheKey ].applyData( propertyMeta.hb_optionsSmartListData );
			}

			if( getService("hibachiService").getEntityHasPropertyByEntityName(listLast(propertyMeta.cfc,'.'), 'activeFlag') ) {
				variables[ cacheKey ].addFilter( 'activeFlag', 1 );
			}
		}

		return variables[ cacheKey ];
	}


	// @hint returns a collection list or records that can be used as options for a many-to-one property
	public any function getPropertyOptionsCollectionList( required string propertyName ) {
		var cacheKey = "#arguments.propertyName#OptionsCollectionList";

		if(!structKeyExists(variables, cacheKey)) {

			var propertyMeta = getPropertyMetaData( arguments.propertyName );
			var entityService = getService("hibachiService").getServiceByEntityName( listLast(propertyMeta.cfc,'.') );

			variables[ cacheKey ] = entityService.invokeMethod("get#listLast(propertyMeta.cfc,'.')#CollectionList");

			// If there was an hb_optionsCollectionListData defined, then we can now apply that data to this smart list
			if(structKeyExists(propertyMeta, "hb_optionsSmartListData")) {
				variables[ cacheKey ].applyData( propertyMeta.hb_optionsSmartListData );
			}else if(structKeyExists(propertyMeta, "hb_optionsCollectionListData")) {
				variables[ cacheKey ].applyData( propertyMeta.hb_optionsCollectionListData );
			}

			if( getService("hibachiService").getEntityHasPropertyByEntityName(listLast(propertyMeta.cfc,'.'), 'activeFlag') ) {
				variables[ cacheKey ].addFilter( 'activeFlag', 1 );
			}
		}

		return variables[ cacheKey ];
	}

	// @hint returns a smart list of the current values for a given one-to-many or many-to-many property
	public any function getPropertySmartList( required string propertyName ) {
		var cacheKey = "#arguments.propertyName#SmartList";

		if(!structKeyExists(variables, cacheKey)) {

			var entityService = getService("hibachiService").getServiceByEntityName( listLast(getPropertyMetaData( arguments.propertyName ).cfc,'.') );
			var smartList = entityService.invokeMethod("get#listLast(getPropertyMetaData( arguments.propertyName ).cfc,'.')#SmartList");

			// Create an example entity so that we can read the meta data
			var exampleEntity = entityNew("#getApplicationValue('applicationKey')##listLast(getPropertyMetaData( arguments.propertyName ).cfc,'.')#");

			// If its a one-to-many, then add filter
			if(getPropertyMetaData( arguments.propertyName ).fieldtype == "one-to-many") {
				// Loop over the properties in the example entity to
				for(var i=1; i<=arrayLen(exampleEntity.getProperties()); i++) {
					if( structKeyExists(exampleEntity.getProperties()[i], "fkcolumn") && exampleEntity.getProperties()[i].fkcolumn == getPropertyMetaData( arguments.propertyName ).fkcolumn ) {
						smartList.addFilter("#exampleEntity.getProperties()[i].name#.#getPrimaryIDPropertyName()#", getPrimaryIDValue());
					}
				}

			// Otherwise add a where clause for many to many
			} else if (getPropertyMetaData( arguments.propertyName ).fieldtype == "many-to-many") {

				smartList.addWhereCondition("EXISTS (SELECT r FROM #getEntityName()# t INNER JOIN t.#getPropertyMetaData( arguments.propertyName ).name# r WHERE r.id = a#lcase(exampleEntity.getEntityName())#.id AND t.id = '#getPrimaryIDValue()#')");

			}

			variables[ cacheKey ] = smartList;
		}

		return variables[ cacheKey ];
	}

	// @hint returns a collection list of the current values for a given one-to-many or many-to-many property
	public any function getPropertyCollectionList( required string propertyName, boolean isNew=false ) {
		var cacheKey = "#arguments.propertyName#CollectionList";

		if(!structKeyExists(variables, cacheKey) || ((structKeyExists(arguments, 'isNew') && !isNull(arguments.isNew) && arguments.isNew))) {
			var propertyMetaData = getPropertyMetaData(arguments.propertyName); 

			var entityService = getService("hibachiService").getServiceByEntityName( listLast(getPropertyMetaData( arguments.propertyName ).cfc,'.') );
			var collectionList = entityService.invokeMethod("get#listLast(getPropertyMetaData( arguments.propertyName ).cfc,'.')#CollectionList");

			// Create an example entity so that we can read the meta data
			var exampleEntity = entityNew("#getApplicationValue('applicationKey')##listLast(getPropertyMetaData( arguments.propertyName ).cfc,'.')#");

			// If its a one-to-many, then add filter
			if(propertyMetaData.fieldtype == "one-to-many") {
				// Loop over the properties in the example entity to
				for(var i=1; i<=arrayLen(exampleEntity.getProperties()); i++) {
					if( structKeyExists(exampleEntity.getProperties()[i], "fkcolumn") && exampleEntity.getProperties()[i].fieldType == 'many-to-one' && exampleEntity.getProperties()[i].fkcolumn == propertyMetaData.fkcolumn ) {
						collectionList.addFilter("#exampleEntity.getProperties()[i].name#.#getPrimaryIDPropertyName()#", getPrimaryIDValue());
						break; 
					}
 				}	
 			} else if(propertyMetaData.fieldtype == "many-to-many"){
 				for(var i=1; i<=arrayLen(exampleEntity.getProperties()); i++) {
 					if( structKeyExists(exampleEntity.getProperties()[i], "inversejoincolumn") && exampleEntity.getProperties()[i].inversejoincolumn == propertyMetaData.fkcolumn ) {
 						collectionList.addFilter("#exampleEntity.getProperties()[i].name#.#getPrimaryIDPropertyName()#", getPrimaryIDValue());
 						break; 
 					}
 				}
 			}


			variables[ cacheKey ] = collectionList;
		}

		return variables[ cacheKey ];
	}

	// @hint returns a struct of the current entities in a given property.  The struck is key'd based on the primaryID of the entities
	public struct function getPropertyStruct( required string propertyName ) {
		var cacheKey = "#arguments.propertyName#Struct";

		if(!structKeyExists(variables, cacheKey)) {
			variables[ cacheKey ] = {};

			var values = variables[ arguments.propertyName ];

			for(var i=1; i<=arrayLen(values); i++) {
				variables[cacheKey][ values[i].getPrimaryIDValue() ] = values[i];
			}
		}

		return variables[ cacheKey ];

	}

	// @hint returns the count of a given property
	public numeric function getPropertyCount( required string propertyName ) {
		
		if(isNew()){
			return 0;
		}
		var propertyCountName = '#arguments.propertyName#Count';
		
		var propertyCollection = getPropertyCountCollectionList(arguments.propertyName, propertyCountName);
		var records = propertyCollection.getRecords();
		if(arraylen(records)){
			return records[1][propertyCountName];
		}else{
			return 0;
		}
	}
	
	public any function getPropertyCountCollectionList(required string propertyName, string propertyCountName){
	
		arguments.propertyName = getPropertiesStruct()[arguments.propertyName].name;
		var propertyCollection = getService("hibachiService").getCollectionList(getClassName());
		propertyCollection.addFilter(getPrimaryIDPropertyName(),getPrimaryIDValue());
		propertyCollection.setDisplayProperties(getPrimaryIDPropertyName());
		propertyCollection.addDisplayAggregate(arguments.propertyName,'COUNT',arguments.propertyCountName);
		return propertyCollection;
	}

	// @hint handles encrypting a property based on conventions
	public void function encryptProperty(required string propertyName) {
		var generatorValue = createHibachiUUID();
		var value = this.invokeMethod('get#arguments.propertyName#');

		if(!isNull(value) && len(value) && value != '********') {
			var encryptedPropertyValue = encryptValue(value, generatorValue);

			// Set encrypted generator
			if(this.hasProperty('#arguments.propertyName#EncryptedGenerator')) {
				this.invokeMethod("set#arguments.propertyName#EncryptedGenerator", {'1'=generatorValue});
			// Enforce that every encrypted property has a corresponding generator when the encryption takes place
			} else {
				throw("Entity '#getClassName()#' is missing the '#arguments.propertyName#EncryptedGenerator' property. Encrypting '#arguments.propertyName#' property value without a corresponding '#arguments.propertyName#EncryptedGenerator' property is not allowed.");
			}

			// Set encrypted datetime stamp
			if(this.hasProperty('#arguments.propertyName#EncryptedDateTime')) {
				this.invokeMethod("set#arguments.propertyName#EncryptedDateTime", {'1'=now()});
			// Enforce that every encrypted property has the timestamp when the encryption takes place
			} else {
				throw("Entity '#getClassName()#' is missing the '#arguments.propertyName#EncryptedDateTime' property. Encrypting '#arguments.propertyName#' property value without a corresponding '#arguments.propertyName#EncryptedDateTime' property is not allowed.");
			}

			// Determine the appropiate property of the entity where to set the encrypted value
			if(this.hasProperty('#arguments.propertyName#Encrypted')) {
				// Set corresponding property that should store the newly encrypted value and remove the unencrypted value from the corresponding unencrypted property (necessary if persistent)
				this.invokeMethod("set#arguments.propertyName#Encrypted", {'1'=encryptedPropertyValue});

				var unencryptedProperty = this.getPropertiesStruct()['#arguments.propertyName#'];

				// Unencrypted property is persistent, remove the value from variables scope so it is not persisted as plaintext
				if (!structKeyExists(unencryptedProperty, "persistent") || (structKeyExists(unencryptedProperty, "persistent") && unencryptedProperty.persistent)) {
					structDelete(variables, arguments.propertyName);
				}
			} else {
				// Overwrite property's unencrypted value directly with the newly encrypted value, bypass the setter because could trigger a recursive loop on this method
				variables['#arguments.propertyName#'] = encryptedPropertyValue;
			}
		}
	}

	// @hint handles decrypting a property based on conventions
	public string function decryptProperty(required string propertyName) {
		var encryptedPropertyValue = "";

		var isAttributeProperty = getService('hibachiService').getHasAttributeByEntityNameAndPropertyIdentifier(getClassName(),arguments.propertyName);

		var generatorName = "";
		var entity = this;
		if(isAttributeProperty){
			generatorName = "AttributeValue";
			entity = this.getAttributeValue(arguments.propertyName,true);
		}else{
			generatorName = arguments.propertyName;
		}
		var generatorValue = entity.invokeMethod("get#generatorName#EncryptedGenerator");;
		param name="generatorValue" default="";

		// Determine the appropriate property to retrieve the encrytped value from
		if (entity.hasProperty("#generatorName#Encrypted")) {
			encryptedPropertyValue = entity.invokeMethod("get#generatorName#Encrypted");
		} else {
			encryptedPropertyValue = variables['#arguments.propertyName#'];
		}
		return decryptValue(encryptedPropertyValue, generatorValue);
	}

	public string function getAuditablePropertyExclusionList() {
		return "createdByAccount,createdByAccountID,createdDateTime,modifiedByAccount,modifiedByAccountID,modifiedDateTime,remoteID,remoteEmployeeID,remoteCustomerID,remoteContactID";
	}

	public array function getAuditableProperties() {
		if( !getHibachiScope().hasApplicationValue("classAuditablePropertyCache_#getClassFullname()#") ) {
			var properties = getProperties();
			var auditableProperties = [];
			for (var property in properties) {
				var propertyExclusionList = getAuditablePropertyExclusionList();

				// The property must be persistent, auditable, not in property exclusion list, not a calculated property, must be a column or one-to-many, and field not inverse
				if ((!structKeyExists(property, "persistent") || (structKeyExists(property, "persistent") && property.persistent)) && (!structKeyExists(property, "hb_auditable") || (structKeyExists(property, "hb_auditable") && property.hb_auditable)) && !listFindNoCase(propertyExclusionList, property.name) && (left(property.name, 10) != "calculated") && (!structKeyExists(property, "fieldType") || property.fieldType == "column" || property.fieldType == "many-to-one") && (!structKeyExists(property, "inverse") || (structKeyExists(property, "inverse") && !property.inverse))) {
					arrayAppend(auditableProperties, property);
				}
			}

			setApplicationValue("classAuditablePropertyCache_#getClassFullname()#", auditableProperties);
		}

		return getApplicationValue("classAuditablePropertyCache_#getClassFullname()#");
	}

	public struct function getAuditablePropertiesStruct() {
		if( !getHibachiScope().hasApplicationValue("classAuditablePropertyStructCache_#getClassFullname()#") ) {
			var auditablePropertiesStruct = {};
			var auditableProperties = getAuditableProperties();

			for(var i=1; i<=arrayLen(auditableProperties); i++) {
				auditablePropertiesStruct[ auditableProperties[i].name ] = auditableProperties[ i ];
			}
			setApplicationValue("classAuditablePropertyStructCache_#getClassFullname()#", auditablePropertiesStruct);
		}

		return getApplicationValue("classAuditablePropertyStructCache_#getClassFullname()#");
	}



	// @hint Generic abstract dynamic ORM methods by convention via onMissingMethod.
	public any function onMissingMethod(required string missingMethodName, required struct missingMethodArguments) {
		// hasUniqueOrNullXXX() 		Where XXX is a property to check if that property value is currenly unique in the DB
		if( left(arguments.missingMethodName, 15) == "hasUniqueOrNull") {

			return hasUniqueOrNullProperty( right(arguments.missingMethodName, len(arguments.missingMethodName) - 15) );

		// hasUniqueXXX() 		Where XXX is a property to check if that property value is currenly unique in the DB
		} else if( left(arguments.missingMethodName, 9) == "hasUnique") {

			return hasUniqueProperty( right(arguments.missingMethodName, len(arguments.missingMethodName) - 9) );

		// hasAnyXXX() 			Where XXX is one-to-many or many-to-many property and we want to see if it has any of an array of entities
		} else if( left(arguments.missingMethodName, 6) == "hasAny") {

			return hasAnyInProperty(propertyName=right(arguments.missingMethodName, len(arguments.missingMethodName) - 6), entityArray=arguments.missingMethodArguments[1]);

		// getXXXAssignedIDList()		Where XXX is a one-to-many or many-to-many property that we need an array of valid options returned
		}

		if ( left(arguments.missingMethodName, 3) == "get"){
			var propertyName="";
			if(right(arguments.missingMethodName, 14) == "AssignedIDList") {
				propertyName=left(right(arguments.missingMethodName, len(arguments.missingMethodName)-3), len(arguments.missingMethodName)-17);
				if(hasProperty(propertyName)){
					return getPropertyAssignedIDList( propertyName=propertyName );
				}
			}
			// getXXXOptions()		Where XXX is a one-to-many or many-to-many property that we need an array of valid options returned
			if ( right(arguments.missingMethodName, 7) == "Options") {
				propertyName=left(right(arguments.missingMethodName, len(arguments.missingMethodName)-3), len(arguments.missingMethodName)-10);
				if(hasProperty(propertyName)){
					return getPropertyOptions( propertyName=propertyName);
				}
			}
			// getXXXOptionsSmartList()		Where XXX is a one-to-many or many-to-many property that we need an array of valid options returned
			if ( right(arguments.missingMethodName, 16) == "OptionsSmartList") {
				propertyName=left(right(arguments.missingMethodName, len(arguments.missingMethodName)-3), len(arguments.missingMethodName)-19);
				if(hasProperty(propertyName)){
					return getPropertyOptionsSmartList( propertyName=propertyName );
				}
			}
			// getXXXSmartList()	Where XXX is a one-to-many or many-to-many property where we to return a smartList instead of just an array
			if ( right(arguments.missingMethodName, 9) == "SmartList") {
				propertyName=left(right(arguments.missingMethodName, len(arguments.missingMethodName)-3), len(arguments.missingMethodName)-12);
				if(hasProperty(propertyName)){
					return getPropertySmartList( propertyName=propertyName );
				}
			}
			// getXXXStruct()		Where XXX is a one-to-many or many-to-many property where we want a key delimited struct
			if ( right(arguments.missingMethodName, 14) == "CollectionList") {
				propertyName=left(right(arguments.missingMethodName, len(arguments.missingMethodName)-3), len(arguments.missingMethodName)-17);
				if(hasProperty(propertyName)){
					//condition to choose between new and cached collectionList
					if( structKeyExists(arguments.missingMethodArguments, 'isNew') && arguments.missingMethodArguments["isNew"]){
						return getPropertyCollectionList( propertyName=propertyName, isNew=true);
					}else{
					return getPropertyCollectionList( propertyName=propertyName );
					}
				}
			}
			// getXXXStruct()		Where XXX is a one-to-many or many-to-many property where we want a key delimited struct
			if ( right(arguments.missingMethodName, 6) == "Struct") {
				propertyName=left(right(arguments.missingMethodName, len(arguments.missingMethodName)-3), len(arguments.missingMethodName)-9);
				if(hasProperty(propertyName)){
					return getPropertyStruct( propertyName=propertyName );
				}
			}
			// getXXXCount()		Where XXX is a one-to-many or many-to-many property where we want to get the count of that property
			if ( right(arguments.missingMethodName, 5) == "Count") {
				propertyName=left(right(arguments.missingMethodName, len(arguments.missingMethodName)-3), len(arguments.missingMethodName)-8);
				if(hasProperty(propertyName)){
					return getPropertyCount( propertyName=propertyName );
				}
			}
			// getXXX() 			Where XXX is either and attributeID or attributeCode
			if (structKeyExists(variables, "getAttributeValue") && hasProperty("attributeValues") && hasAttributeCode(right(arguments.missingMethodName, len(arguments.missingMethodName)-3)) ) {
				return getAttributeValue(right(arguments.missingMethodName, len(arguments.missingMethodName)-3));
			}
			// getXXXID()		Where XXX is a many-to-one property that we want to get the primaryIDValue of that property
			if ( right(arguments.missingMethodName, 2) == "ID") {
				propertyName=left(right(arguments.missingMethodName, len(arguments.missingMethodName)-3), len(arguments.missingMethodName)-5);
				if(hasProperty(propertyName)){
					return getPropertyPrimaryID( propertyName=propertyName );
				}
			}
			//getXXXUploadDirectory()
			if ( right(arguments.missingMethodName, 15) == "UploadDirectory") {
				var propertyName = mid(arguments.missingMethodName,4,len(arguments.missingMethodName)-18);
				if(getPropertyFieldType(propertyName) == 'file'){
					return getUploadDirectoryByPropertyName(propertyName);
				}
			}
			//getXXXFileURL()
			if ( right(arguments.missingMethodName, 7) == "FileUrl") {
				var propertyName = mid(arguments.missingMethodName,4,len(arguments.missingMethodName)-10);

				if(getPropertyFieldType(propertyName) == 'file'){
					return getFileUrlByPropertyName(propertyName);
				}
			}
		}
		//removeXXX() only for files
		if ( left(arguments.missingMethodName, 6) == "remove") {
			var propertyName =right(arguments.missingMethodName,len(arguments.missingMethodName)-6);
			if(getPropertyFieldType(propertyName) == 'file'){
				return genericPropertyRemove(propertyName);
			}
		}
		throw('You have called a method #arguments.missingMethodName#() which does not exists in the #getClassName()# entity.');
	}

	// ============ START: Non-Persistent Property Methods =================

	// @hint public method that returns if this entity has had entitySave() called on it yet or not.
	public boolean function getNewFlag() {
		if(getPrimaryIDValue() == "") {
			return true;
		}
		return false;
	}

	public boolean function getEncryptedPropertiesExistFlag() {
		return structCount(getEncryptedPropertiesStruct()) > 0;
	}

	public struct function getEncryptedPropertiesStruct() {
		var encryptedProperties = {};
		for(var propertyName in getPropertiesStruct()) {
			if ((right(propertyName, 9) == "encrypted") && structKeyExists(getPropertiesStruct(), '#propertyName#DateTime') && structKeyExists(getPropertiesStruct(), '#propertyName#Generator')) {
				encryptedProperties['#propertyName#'] = getPropertiesStruct()[propertyName];
			}
		}

		return encryptedProperties;
	}

	public boolean function getRollbackProcessedFlag() {
		if(isNull(variables.rollbackProcessedFlag) || !isBoolean(variables.rollbackProcessedFlag)) {
			variables.rollbackProcessedFlag = false;
		}
		return variables.rollbackProcessedFlag;
	}

	public array function getPrintTemplates() {
		return [];
	}

	public array function getEmailTemplates() {
		return [];
	}

	public any function getCreatedByAccount() {
		if(structKeyExists(this, "getCreatedByAccountID")) {
			var accountID = this.getCreatedByAccountID();
			if(!isNull(accountID)) {
				return getService('accountService').getAccount( accountID );
			}
		}
	}

	public any function getModifiedByAccount() {
		if(structKeyExists(this, "getModifiedByAccountID")) {
			var accountID = this.getModifiedByAccountID();
			if(!isNull(accountID)) {
				return getService('accountService').getAccount( accountID );
			}
		}
	}

	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================

	public void function afterPopulate() {
		// Handle encrypted properties
		if (structKeyExists(this, 'setupEncryptedProperties')) {
			this.invokeMethod('setupEncryptedProperties');
		}
	}

	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	public void function preInsert(){
		if(!this.isPersistable()) {
			for(var errorName in getErrors()) {
				for(var i=1; i<=arrayLen(getErrors()[errorName]); i++) {
					logHibachi("an ormFlush() failed for an Entity Insert of #getEntityName()# with an errorName: #errorName# and errorMessage: #getErrors()[errorName][i]#", true);
				}
			}
			throw("An ormFlush has been called on the hibernate session, however there is a #getEntityName()# entity in the hibernate session with errors.  The specific errors will be shown in the Slatwall log.");
		}

		var timestamp = now();

		// Setup The First Created Date Time
		if(structKeyExists(this,"setCreatedDateTime")){
			this.setCreatedDateTime(timestamp);
		}

		// Setup The First Modified Date Time
		if(structKeyExists(this,"setModifiedDateTime")){
			this.setModifiedDateTime(timestamp);
		}

		// These are more complicated options that should not be called during application setup
		if(getHibachiScope().hasApplicationValue("initialized") && getHibachiScope().getApplicationValue("initialized")) {

			// Setup the first sortOrder
			if(structKeyExists(this,"setSortOrder")) {
				var metaData = getPropertyMetaData("sortOrder");
				var topSortOrder = 0;
				if(structKeyExists(metaData, "sortContext") && structKeyExists(variables, metaData.sortContext)) {
					topSortOrder =  getService("hibachiService").getTableTopSortOrder( tableName=getMetaData(this).table, contextIDColumn=variables[ metaData.sortContext ].getPrimaryIDPropertyName(), contextIDValue=variables[ metaData.sortContext ].getPrimaryIDValue() );
				} else {
					topSortOrder =  getService("hibachiService").getTableTopSortOrder( tableName=getMetaData(this).table );
				}
				setSortOrder( topSortOrder + 1 );
			}

			// Set createdByAccount
			if(structKeyExists(this,"setCreatedByAccountID") && !getHibachiScope().getAccount().isNew() ){
				setCreatedByAccountID( getHibachiScope().getAccount().getAccountID() );
			}

			// Set modifiedByAccount
			if(structKeyExists(this,"setModifiedByAccountID") && !getHibachiScope().getAccount().isNew() ){
				setModifiedByAccountID( getHibachiScope().getAccount().getAccountID() );
			}

			// Log audit only if admin user
			if(!getHibachiScope().getAccount().isNew() && getHibachiScope().getAccount().getAdminAccountFlag() ) {
				getService("hibachiAuditService").logEntityModify(entity=this);
			}

			// Add to the modifiedEntities
			getHibachiScope().addModifiedEntity( this );
		}

	}
	
		
	public void function runCalculatedProperties(){
		getService("hibachiService").updateCalculatedPropertiesByEntityName(this);
	}
	
	public boolean function hasCalculatedProperties(){
		return getService("hibachiService").getEntityHasCalculatedPropertiesByEntityName(this.getEntityName());
	}

	public void function preUpdate(struct oldData){
		if(!this.isPersistable()) {
			for(var errorName in getErrors()) {
				for(var i=1; i<=arrayLen(getErrors()[errorName]); i++) {
					logHibachi("an ormFlush() failed for an Entity Update of #getEntityName()# with an errorName: #errorName# and errorMessage: #getErrors()[errorName][i]#", true);
				}
			}
			throw("An ormFlush has been called on the hibernate session, however there is a #getEntityName()# entity in the hibernate session with errors - #serializeJSON(getErrors())#");
		}

		var timestamp = now();

		// Update the Modified datetime if one exists
		if(structKeyExists(this,"setModifiedDateTime")){
			this.setModifiedDateTime(timestamp);
		}

		// These are more complicated options that should not be called during application setup
		if(getHibachiScope().hasApplicationValue("initialized") && getHibachiScope().getApplicationValue("initialized")) {

			// Set modifiedByAccount
			if(structKeyExists(this,"setModifiedByAccountID") && !getHibachiScope().getAccount().isNew() ){
				setModifiedByAccountID(getHibachiScope().getAccount().getAccountID());
			}

			// Log audit only if admin user or there are prevous audit recods
			if(getService("hibachiAuditService").getAuditSmartListForEntity(entity=this).getRecordsCount() != 0 || !getHibachiScope().getAccount().isNew() && getHibachiScope().getAccount().getAdminAccountFlag() ) {

				getService("hibachiAuditService").logEntityModify(entity=this, oldData=arguments.oldData);
			}

			// Add to the modifiedEntities
			getHibachiScope().addModifiedEntity( this );
		}

	}
	
	//can be overridden at the entity level in case we need to always return a relationship entity otherwise the default is only non-relationship and non-persistent
	public any function getDefaultCollectionProperties(string includesList = "", string excludesList="modifiedByAccountID,createdByAccountID,modifiedDateTime,createdDateTime,remoteID,remoteEmployeeID,remoteCustomerID,remoteContactID,cmsAccountID,cmsContentID,cmsSiteID"){
		var cacheKey = 'getDefaultCollectionProperties#hash(this.getClassName()&arguments.includesList&arguments.excludesList,'md5')#';
		if(!getService('hibachiCacheService').hasCachedValue(cacheKey)){
			var properties = getProperties();

			var defaultProperties = [];
	
			//Check if there is any include column
			if(len(arguments.includesList)){
				var includesArray = ListToArray(arguments.includesList);
				for(var i = 1; i <= arraylen(includesArray); i++) {
					//Loop through IncludeList looking for relational
					includesArray[i] = trim(includesArray[i]);
					if(Find('.', includesArray[i]) != 0){
						var parts = listToArray(includesArray[i], '.');
	
						var current_object = this.getClassName();
						var current_properties = getService('hibachiService').getPropertiesStructByEntityName(this.getClassName());
						for(var p = 1; p <= arraylen(parts); p++ ){
							if(structKeyExists(current_properties, parts[p]) && structKeyExists(current_properties[parts[p]], 'cfc')){
								current_object = current_properties[parts[p]]['cfc'];
								current_properties = getService('hibachiService').getPropertiesStructByEntityName(current_properties[parts[p]]['cfc']);
							}else{
								var newProperty = {};
								structAppend(newProperty,current_properties[parts[p]]);
								newProperty["name"] = includesArray[i];
								newProperty["title"] = rbKey('entity.#current_object#.#listLast(includesArray[i],'.')#');
								//append the Column struct with relational name.
								arrayAppend(defaultProperties, newProperty);
	
							}
						}
	
					}else{
						//If its not relational, just use the current entity struct
						for(var x = 1; x <= arraylen(properties); x++){
							if(properties[x].name == includesArray[i]){
								arrayAppend(defaultProperties, properties[x]);
							}
						}
					}
				}
			}else{
				//Remove all non Persistent, Relational and Excluded columns
				for(var x = 1; x <= arraylen(properties); x++){
					if(!ListContains(excludesList, properties[x].name) && !structKeyExists(properties[x],'FKColumn') &&
					(!structKeyExists(properties[x], "persistent") || properties[x].persistent)){
						arrayAppend(defaultProperties, properties[x]);
					}
				}
			}
			getService('hibachiCacheService').setCachedValue(cacheKey,defaultProperties);
		}

		return getService('hibachiCacheService').getCachedValue(cacheKey);
	}
	//can be overridden at the entity level in case we need to always return a relationship entity otherwise the default is only non-relationship and non-persistent
	public any function getDefaultCollectionReportProperties(string includesList = "", string excludesList="modifiedByAccountID,createdByAccountID,modifiedDateTime,createdDateTime,remoteID,remoteEmployeeID,remoteCustomerID,remoteContactID,cmsAccountID,cmsContentID,cmsSiteID"){
		arguments.includesList = "#getSimpleRepresentationPropertyName()#";
		var defaultProperties = getDefaultCollectionProperties(argumentCollection=arguments);
		return defaultProperties;
	}

	public any function getFilterProperties(string includesList = "", string excludesList = "", includeNonPersistent = false){
		var properties = getProperties();
		var defaultProperties = [];

		for(var p=1; p<=arrayLen(properties); p++) {
			if((len(includesList) && ListFind(arguments.includesList,properties[p].name) && !ListFind(arguments.excludesList,properties[p].name))
				||
				(
					(!structKeyExists(properties[p], "persistent") || properties[p].persistent)
					||
					(includeNonPersistent == true && structKeyExists(properties[p], "persistent") && properties[p].persistent == false && structKeyExists(properties[p], "ormtype"))
				)
			){
				properties[p]['displayPropertyIdentifier'] = getPropertyTitle(properties[p].name);
				arrayAppend(defaultProperties,properties[p]);
			}
		}
		return defaultProperties;
	}

	public void function preDelete(any entity){
		// Loop over all properties
        for(var property in getProperties()) {
            if (structKeyExists(property, "hb_cascadeCalculate") && property.hb_cascadeCalculate && structKeyExists(variables, property.name) && isObject( variables[ property.name ] ) ) {
                getHibachiScope().addModifiedEntity(variables[ property.name ]);
            }
        }
	}

	/*

	public void function preLoad(any entity){
	}

	public void function postInsert(any entity){
	}

	public void function postUpdate(any entity){
	}

	public void function postDelete(any entity){
	}

	public void function postLoad(any entity){
	}
	*/

	// ===================  END:  ORM Event Hooks  =========================

	// ================== START: Deprecated Methods ========================

	// @hint public method that returns if this entity has persisted to the database yet or not.
	public boolean function isNew() {
		return getNewFlag();
	}

	// ==================  END:  Deprecated Methods ========================
}
