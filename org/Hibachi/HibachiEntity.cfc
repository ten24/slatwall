component output="false" accessors="true" persistent="false" extends="HibachiTransient" {

	property name="newFlag" type="boolean" persistent="false";
	property name="printTemplates" type="struct" persistent="false";
	property name="emailTemplates" type="struct" persistent="false";
	property name="simpleRepresentation" type="string" persistent="false";
	property name="persistableErrors" type="array" persistent="false";
	property name="processObjects" type="struct" persistent="false";
	
	// @hint global constructor arguments.  All Extended entities should call super.init() so that this gets called
	public any function init() {
		variables.processObjects = {};
		
		var properties = getProperties();
		
		// Loop over all properties
		for(var i=1; i<=arrayLen(properties); i++) {
			// Set any one-to-many or many-to-many properties with a blank array as the default value
			if(structKeyExists(properties[i], "fieldtype") && listFindNoCase("many-to-many,one-to-many", properties[i].fieldtype) && !structKeyExists(variables, properties[i].name) ) {
				variables[ properties[i].name ] = [];
			}
			// set any activeFlag's to true by default 
			if( properties[i].name == "activeFlag" && isNull(getActiveFlag()) ) {
				variables.activeFlag = 1;
			}
		}
		
		return super.init();
	}
	
	public any function updateCalculatedProperties() {
		if(!structKeyExists(variables, "calculated")) {
			// Set calculated to true so that this only runs 1 time per request
			variables.calculated = true;
			
			// Loop over all properties
			for(var i=1; i<=arrayLen(getProperties()); i++) {
			
				// Look for any that start with the calculatedXXX naming convention
				if(left(getProperties()[i].name, 10) == "calculated") {
					
					var value = this.invokeMethod("get#right(getProperties()[i].name, len(getProperties()[i].name)-10)#");
					if(!isNull(value)) {
						variables[ getProperties()[i].name ] = value;	
					}

				// Then also look for any that have the cascadeCalculate set to true and call updateCalculatedProperties() on that object
				} else if (structKeyExists(getProperties()[i], "hb_cascadeCalculate") && getProperties()[i].hb_cascadeCalculate) {
				
					if( structKeyExists(variables, getProperties()[i].name) && isObject( variables[ getProperties()[i].name ] ) ) {
						variables[ getProperties()[i].name ].updateCalculatedProperties();
					}
				}
			}
		}
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
		
		// Get the meta data for all of the porperties
		var properties = getProperties();
		
		// Look for a property that's last 4 is "name"
		for(var i=1; i<=arrayLen(properties); i++) {
			if(properties[i].name == getClassName() & "name") {
				return properties[i].name;
			}
		}
		
		// If no properties could be identified as a simpleRepresentaition 
		throw("There is no Simple Representation Property Name for #getClassName()#.  You can either override getSimpleRepresentation() or override getSimpleRepresentationPropertyName() in the entity, but be sure to do it at the bottom iside of commented sectin for overrides.");
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
	
	public any function duplicate() {
		var newEntity = getService("hibachiService").getServiceByEntityName(getEntityName()).invokeMethod("new#replace(getEntityName(),getApplicationValue('applicationKey'),'')#");
		var properties = getProperties();
		for(var p=1; p<=arrayLen(properties); p++) {
			if( properties[p].name != getPrimaryIDPropertyName() && (!structKeyExists(properties[p], "fieldType") || ( properties[p].fieldType != "one-to-many" && properties[p].fieldType != "many-to-many")) ) {
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
	public any function getProcessObject(required string context) {
		if(!structKeyExists(variables.processObjects, arguments.context)) {
			variables.processObjects[ arguments.context ] = getTransient("#getClassName()#_#arguments.context#");
			variables.processObjects[ arguments.context ].invokeMethod("set#getClassName()#", {1=this});
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
				for(var e = arrayLen(relatedEntities); e >= 1; e--) {
					this.invokeMethod("remove#getProperties()[i].singularname#", {1=relatedEntities[e]});	
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
			variables[ cacheKey ] = "";
			var arr = this.invokeMethod("get#arguments.propertyName#");
			for(var i=1; i<=arrayLen(arr); i++) {
				variables[ cacheKey ] = listAppend(arr[i].getPrimaryIDValue(), arr[i].getPrimaryIDValue());
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
			
			var smartList = getPropertyOptionsSmartList( arguments.propertyName );
			
			var propertyMeta = getPropertyMetaData( propertyName );
			
			if(structKeyExists(propertyMeta, "hb_optionsNameProperty")) {
				smartList.addSelect(propertyIdentifier=propertyMeta.hb_optionsNameProperty, alias="value");
			} else {
				var exampleEntity = entityNew("#getApplicationValue('applicationKey')##listLast(getPropertyMetaData( arguments.propertyName ).cfc,'.')#");
				smartList.addSelect(propertyIdentifier=exampleEntity.getSimpleRepresentationPropertyName(), alias="name");
			}
			if(structKeyExists(propertyMeta, "hb_optionsValueProperty")) {
				smartList.addSelect(propertyIdentifier=propertyMeta.hb_optionsValueProperty, alias="value");
			} else {
				smartList.addSelect(propertyIdentifier=getService("hibachiService").getPrimaryIDPropertyNameByEntityName(listLast(getPropertyMetaData( arguments.propertyName ).cfc,'.')), alias="value");
			}
			
			if(structKeyExists(propertyMeta, "hb_optionsAdditionalProperties")) {
				var additionalPropertiesArray = listToArray(propertyMeta.hb_optionsAdditionalProperties);
				for(var p=1; p<=arrayLen(additionalPropertiesArray); p++) {
					smartList.addSelect(propertyIdentifier=additionalPropertiesArray[p], alias=replace(additionalPropertiesArray[p],".","_","all"));
				}
			}
			
			variables[ cacheKey ] = smartList.getRecords();
			
			// If this is a many-to-one related property, then add a 'select' to the top of the list
			if(getPropertyMetaData( propertyName ).fieldType == "many-to-one" && structKeyExists(getPropertyMetaData( propertyName ), "hb_optionsNullRBKey")) {
				arrayPrepend(variables[ cacheKey ], {value="", name=rbKey(getPropertyMetaData( propertyName ).hb_optionsNullRBKey)});
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
				
				smartList.addWhereCondition("EXISTS (SELECT r FROM #getEntityName()# t INNER JOIN t.#getPropertyMetaData( arguments.propertyName ).name# r WHERE r.#exampleEntity.getPrimaryIDPropertyName()# = a#lcase(exampleEntity.getEntityName())#.#exampleEntity.getPrimaryIDPropertyName()# AND t.#getPrimaryIDPropertyName()# = '#getPrimaryIDValue()#')");
				
			}
			
			variables[ cacheKey ] = smartList;
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
		var cacheKey = "#arguments.propertyName#Count";
			
		if(!structKeyExists(variables, cacheKey)) {
			variables[ cacheKey ] = arrayLen(variables[ arguments.propertyName ]);
		}
		
		return variables[ cacheKey ];
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
		} else if ( left(arguments.missingMethodName, 3) == "get" && right(arguments.missingMethodName, 14) == "AssignedIDList") {
			
			return getPropertyAssignedIDList( propertyName=left(right(arguments.missingMethodName, len(arguments.missingMethodName)-3), len(arguments.missingMethodName)-17) );
		
		// getXXXID()		Where XXX is a many-to-one property that we want to get the primaryIDValue of that property 		
		} else if ( left(arguments.missingMethodName, 3) == "get" && right(arguments.missingMethodName, 2) == "ID") {
			
			return getPropertyPrimaryID( propertyName=left(right(arguments.missingMethodName, len(arguments.missingMethodName)-3), len(arguments.missingMethodName)-5) );
			
		// getXXXOptions()		Where XXX is a one-to-many or many-to-many property that we need an array of valid options returned 		
		} else if ( left(arguments.missingMethodName, 3) == "get" && right(arguments.missingMethodName, 7) == "Options") {
			
			return getPropertyOptions( propertyName=left(right(arguments.missingMethodName, len(arguments.missingMethodName)-3), len(arguments.missingMethodName)-10) );

		// getXXXOptionsSmartList()		Where XXX is a one-to-many or many-to-many property that we need an array of valid options returned 
		} else if ( left(arguments.missingMethodName, 3) == "get" && right(arguments.missingMethodName, 16) == "OptionsSmartList") {
			
			return getPropertyOptionsSmartList( propertyName=left(right(arguments.missingMethodName, len(arguments.missingMethodName)-3), len(arguments.missingMethodName)-19) );
			
		// getXXXSmartList()	Where XXX is a one-to-many or many-to-many property where we to return a smartList instead of just an array
		} else if ( left(arguments.missingMethodName, 3) == "get" && right(arguments.missingMethodName, 9) == "SmartList") {
			
			return getPropertySmartList( propertyName=left(right(arguments.missingMethodName, len(arguments.missingMethodName)-3), len(arguments.missingMethodName)-12) );
			
		// getXXXStruct()		Where XXX is a one-to-many or many-to-many property where we want a key delimited struct
		} else if ( left(arguments.missingMethodName, 3) == "get" && right(arguments.missingMethodName, 6) == "Struct") {
			
			return getPropertyStruct( propertyName=left(right(arguments.missingMethodName, len(arguments.missingMethodName)-3), len(arguments.missingMethodName)-9) );
			
		// getXXXCount()		Where XXX is a one-to-many or many-to-many property where we want to get the count of that property
		} else if ( left(arguments.missingMethodName, 3) == "get" && right(arguments.missingMethodName, 5) == "Count") {
			
			return getPropertyCount( propertyName=left(right(arguments.missingMethodName, len(arguments.missingMethodName)-3), len(arguments.missingMethodName)-8) );
			
		// getXXX() 			Where XXX is either and attributeID or attributeCode
		} else if (left(arguments.missingMethodName, 3) == "get" && structKeyExists(variables, "getAttributeValue") && hasProperty("attributeValues")) {
			
			return getAttributeValue(right(arguments.missingMethodName, len(arguments.missingMethodName)-3));	
			
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
	
	public array function getPrintTemplates() {
		return [];
	}
	
	public array function getEmailTemplates() {
		return [];
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
		
	// =================== START: ORM Event Hooks  =========================
	
	public void function preInsert(){
		if(!this.isPersistable()) {
			for(var errorName in getErrors()) {
				for(var i=1; i<=arrayLen(getErrors()[errorName]); i++) {
					logHibachi("an ormFlush() failed for an Entity Insert of #getEntityName()# with an errorName: #errorName# and errorMessage: #getErrors()[errorName][i]#", true);	
				}
			}
			writeDump(getErrors());
			throw("An ormFlush has been called on the hibernate session, however there is a #getEntityName()# entity in the hibernate session with errors");
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
			
			// Call the calculatedProperties update
			updateCalculatedProperties();
			
			// Set createdByAccount
			if(structKeyExists(this,"setCreatedByAccount") && !getHibachiScope().getAccount().isNew() && getHibachiScope().getAccount().getAdminAccountFlag() ){
				setCreatedByAccount( getHibachiScope().getAccount() );	
			}
			
			// Set modifiedByAccount
			if(structKeyExists(this,"setModifiedByAccount") && !getHibachiScope().getAccount().isNew() && getHibachiScope().getAccount().getAdminAccountFlag() ){
				setModifiedByAccount(getHibachiScope().getAccount());
			}
			
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
		}
	}
	
	public void function preUpdate(struct oldData){
		if(!this.isPersistable()) {
			for(var errorName in getErrors()) {
				for(var i=1; i<=arrayLen(getErrors()[errorName]); i++) {
					logHibachi("an ormFlush() failed for an Entity Update of #getEntityName()# with an errorName: #errorName# and errorMessage: #getErrors()[errorName][i]#", true);	
				}
			}
			writeDump(getErrors());
			throw("An ormFlush has been called on the hibernate session, however there is a #getEntityName()# entity in the hibernate session with errors");
		}
		
		var timestamp = now();
		
		// Update the Modified datetime if one exists
		if(structKeyExists(this,"setModifiedDateTime")){
			this.setModifiedDateTime(timestamp);
		}
		
		// These are more complicated options that should not be called during application setup
		if(getHibachiScope().hasApplicationValue("initialized") && getHibachiScope().getApplicationValue("initialized")) {
		
			// Call the calculatedProperties update
			updateCalculatedProperties();
		
			// Set modifiedByAccount
			if(structKeyExists(this,"setModifiedByAccount") && !getHibachiScope().getAccount().isNew() && getHibachiScope().getAccount().getAdminAccountFlag() ){
				setModifiedByAccount(getHibachiScope().getAccount());
			}
		}
	}
	
	/*
	public void function preDelete(any entity){
	}
	
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