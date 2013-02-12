/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

*/
component displayname="Base Entity" accessors="true" extends="Slatwall.com.utility.BaseObject" {

	property name="simpleRepresentation" type="string" persistent="false";
	property name="persistableErrors" type="array" persistent="false";
	property name="assignedAttributeSetSmartList" type="struct" persistent="false";
	property name="attributeValuesByAttributeIDStruct" type="struct" persistent="false";
	property name="attributeValuesByAttributeCodeStruct" type="struct" persistent="false";
	
	// @hint global constructor arguments.  All Extended entities should call super.init() so that this gets called
	public any function init() {
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
					
					variables[ getProperties()[i].name ] = this.invokeMethod("get#right(getProperties()[i].name, len(getProperties()[i].name)-10)#");
					
				// Then also look for any that have the cascadeCalculate set to true and call updateCalculatedProperties() on that object
				} else if (structKeyExists(getProperties()[i], "cascadeCalculate") && getProperties()[i].cascadeCalculate) {
				
					if( structKeyExists(variables, getProperties()[i].name) && isObject( variables[ getProperties()[i].name ] ) ) {
						variables[ getProperties()[i].name ].updateCalculatedProperties();
					}
				}
			}
		}
	}
	
	// @hint Override the populate method to look for custom attributes
	public any function populate( required struct data={} ) {
		
		// Call the super populate to do all the standard logic
		super.populate(argumentcollection=arguments);
		
		// Get the assigned attributes
		var assignedAttributeSets = getAssignedAttributeSetSmartList().getRecords();
		
		var attributeType = replace(getEntityName(),"Slatwall","");
		attributeType = lcase(left(attributeType, 1)) & right(attributeType, len(attributeType)-1);
					
		// Loop over attribute sets
		for(var ats=1; ats<=arrayLen(assignedAttributeSets); ats++) {
			var attributes = assignedAttributeSets[ats].getAttributes();
			
			for(var at=1; at<=arrayLen(attributes); at++) {
				if(structKeyExists(arguments.data, attributes[at].getAttributeCode())) {
					var av = getAttributeValue(attributes[at].getAttributeCode(), true);
					av.setAttributeValue( data[ attributes[at].getAttributeCode() ]);
					av.setAttribute(attributes[at]);
					av.setAttributeValueType(attributeType);
					av.invokeMethod("set#attributeType#", {1=this});
				}
			}
		}
		
		// Return this object
		return this;
	}
	
	
	// @hint Returns an array of comments related to this entity
	public array function getComments() {
		if(!structKeyExists(variables, "comments")) {
			variables.comments = getService("commentService").getRelatedCommentsForEntity(primaryIDPropertyName=getPrimaryIDPropertyName(), primaryIDValue=getPrimaryIDValue());
		}
		return variables.comments;
	}
	
	public any function duplicate() {
		var newEntity = getService("utilityORMService").getServiceByEntityName(getEntityName()).invokeMethod("new#replace(getEntityName(),'Slatwall','')#");
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
	
	// Attribute Value
	public array function getAttributeValuesForEntity() {
		if(!structKeyExists(variables, "attributeValuesForEntity")) {
			variables.attributeValuesForEntity = [];
			if(hasProperty("attributeValues")) {
				var primaryIDPropertyIdentifier = "#replace(getEntityName(), 'Slatwall', '')#.#getPrimaryIDPropertyName()#";
				primaryIDPropertyIdentifier = lcase(left(primaryIDPropertyIdentifier, 1)) & right(primaryIDPropertyIdentifier, len(primaryIDPropertyIdentifier)-1);
				variables.attributeValuesForEntity = getService("attributeService").getAttributeValuesForEntity(primaryIDPropertyIdentifier=primaryIDPropertyIdentifier, primaryIDValue=getPrimaryIDValue());
			}
		}
		return variables.attributeValuesForEntity;
	}
	
	public any function getAttributeValue(required string attribute, returnEntity=false){
		
		var attributeValueEntity = "";
		
		// If an ID was passed, and that value exists in the ID struct then use it
		if(len(arguments.attribute) eq 32 && structKeyExists(getAttributeValuesByAttributeIDStruct(), arguments.attribute) ) {
			attributeValueEntity = getAttributeValuesByAttributeIDStruct()[arguments.attribute];
			
		// If some other string was passed check the attributeCode struct for it's existance
		} else if( structKeyExists(getAttributeValuesByAttributeCodeStruct(), arguments.attribute) ) {
			attributeValueEntity = getAttributeValuesByAttributeCodeStruct()[arguments.attribute];
			
		}
		
		// Value Entity Found, and we are returning the entire thing
		if( isObject(attributeValueEntity) && arguments.returnEntity) {
			
			return attributeValueEntity;
		
		// Value Entity Found and we are just returning the value (or the default for that attribute)
		} else if ( isObject(attributeValueEntity) ){
			
			if(!isNull(attributeValueEntity.getAttributeValue()) && len(attributeValueEntity.getAttributeValue())) {
				return attributeValueEntity.getAttributeValue();
			} else if (!isNull(attributeValueEntity.getAttribute().getDefaultValue()) && len(attributeValueEntity.getAttribute().getDefaultValue())) {
				return attributeValueEntity.getAttribute().getDefaultValue();
			}
			
		// Attribute was not found, and we wanted an entity back
		} else if(arguments.returnEntity) {
			var newAttributeValue = getService("attributeService").newAttributeValue();
			newAttributeValue.setAttributeValueType( lcase( replace(getEntityName(),'Slatwall','') ) );
			return newAttributeValue;
		
		}
		
		return "";
	}
	
	public any function getAssignedAttributeSetSmartList(){
		if(!structKeyExists(variables, "assignedAttributeSetSmartList")) {
			variables.assignedAttributeSetSmartList = getService("attributeService").getAttributeSetSmartList();
			variables.assignedAttributeSetSmartList.addFilter('activeFlag', 1);
			variables.assignedAttributeSetSmartList.addFilter('globalFlag', 1);
			variables.assignedAttributeSetSmartList.addFilter('attributeSetType.systemCode', 'ast#replace(getEntityName(),'Slatwall','')#');
		}
		
		return variables.assignedAttributeSetSmartList;
	}
	
	public struct function getAttributeValuesByAttributeIDStruct() {
		if(!structKeyExists(variables, "attributeValuesByAttributeIDStruct")) {
			variables.attributeValuesByAttributeIDStruct = {};
			if(hasProperty("attributeValues")) {
				var attributeValues = getAttributeValuesForEntity();
				for(var i=1; i<=arrayLen(attributeValues); i++){
					variables.attributeValuesByAttributeIDStruct[ attributeValues[i].getAttribute().getAttributeID() ] = attributeValues[i];
				}	
			}
		}
		
		return variables.attributeValuesByAttributeIDStruct;
	}
	
	public struct function getAttributeValuesByAttributeCodeStruct() {
		if(!structKeyExists(variables, "attributeValuesByAttributeCodeStruct")) {
			variables.attributeValuesByAttributeCodeStruct = {};
			if(hasProperty("attributeValues")) {
				var attributeValues = getAttributeValuesForEntity();
				for(var i=1; i<=arrayLen(attributeValues); i++){
					variables.attributeValuesByAttributeCodeStruct[ attributeValues[i].getAttribute().getAttributeCode() ] = attributeValues[i];
				}
			}
		}
		
		return variables.attributeValuesByAttributeCodeStruct;
	}
	
	public void function clearAttributeCache() {
		if(structKeyExists(variables, "attributeValuesByAttributeIDStruct")) {
			structDelete(variables, "attributeValuesByAttributeIDStruct");
		}
		if(structKeyExists(variables, "attributeValuesByAttributeCodeStruct")) {
			structDelete(variables, "attributeValuesByAttributeCodeStruct");
		}
	}
	
	// @hint Returns the persistableErrors array, if one hasn't been setup yet it returns a new one
	public array function getPersistableErrors() {
		if(!structKeyExists(variables, "persistableErrors")) {
			variables.persistableErrors = [];
		}
		return variables.persistableErrors; 
	}
	
	// @hint this method is defined so that it can be overriden in entities and a different validation context can be applied based on what this entity knows about itself
	public any function getValidationContext(required string context) {
		return arguments.context;
	}
	
	// @hint public method that returns if this entity has persisted to the database yet or not.
	public boolean function isNew() {
		if(getPrimaryIDValue() == "") {
			return true;
		}
		return false;
	}
	
	// @hint public method to determine if this entity can be deleted
	public boolean function isDeletable() {
		
		var results = getValidateThis().validate(theObject=this, context="delete", injectResultIntoBO="false");
		
		if(results.hasErrors()) {
			return false;	
		}
		
		return true;
	}
	
	// @hint public helper method that delegates to isDeletable
	public boolean function isNotDeletable() {
		return !isDeletable();
	}
	
	// @hint public method to determine if this entity can be deleted
	public boolean function isEditable() {
		var results = getValidateThis().validate(theObject=this, context="edit", injectResultIntoBO="false");
		
		if(results.hasErrors()) {
			return false;	
		}
		
		return true;
	}
	
	// @hint public helper method that delegates to isDeletable
	public boolean function isNotEditable() {
		return !isEditable();
	}
	
	// @hint public method to determine if this entity can be 'processed', by default it returns true by you can override on an entity by entity basis
	public boolean function isProcessable( string context="process" ) {
		
		var results = getValidateThis().validate(theObject=this, context="#arguments.context#", injectResultIntoBO="false");
		
		if(results.hasErrors()) {
			return false;	
		}
		return true;
	}
	
	// @hint public helper method that delegates to isProcessable
	public boolean function isNotProcessable( string context="process" ) {
		return !isProcessable( context=arguments.context );
	}
	
	// hint overriding the addError method to allow for saying that the error doesn't effect persistance
	public void function addError( required string errorName, required string errorMessage, boolean persistableError=false ) {
		if(persistableError) {
			addPersistableError(arguments.errorName);
		}
		super.addError(argumentCollection=arguments);
	}
	
	// @hint this allows you to add error names to the persistableErrors property, later used by the 'isPersistable' method
	public void function addPersistableError(required string errorName) {
		arrayAppend(getPersistableErrors(), arguments.errorName);
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
		return getService("utilityORMService").getPrimaryIDPropertyNameByEntityName( getEntityName() );
	}
	
	// @hint public method that returns and array of ID columns
	public any function getIdentifierColumnNames() {
		return getService("utilityORMService").getIdentifierColumnNamesByEntityName( getEntityName() );
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
	
	// @hint public method that returns the full entityName as "Slatwallxxx"
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
		return getService("dataService").isUniqueProperty(propertyName=propertyName, entity=this);
	}
	
	public boolean function hasUniqueOrNullProperty( required string propertyName ) {
		if(!structKeyExists(variables, arguments.propertyName) || isNull(variables[arguments.propertyName])) {
			return true;
		}
		return getService("dataService").isUniqueProperty(propertyName=propertyName, entity=this);
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
	
	// @hint returns an array of name/value pairs that can function as options for a many-to-one property
	public array function getPropertyOptions( required string propertyName ) {
		
		var cacheKey = "#arguments.propertyName#Options";
			
		if(!structKeyExists(variables, cacheKey)) {
			variables[ cacheKey ] = [];
			
			var smartList = getPropertyOptionsSmartList( arguments.propertyName );
			
			var exampleEntity = entityNew("Slatwall#listLast(getPropertyMetaData( arguments.propertyName ).cfc,'.')#");
			
			smartList.addSelect(propertyIdentifier=exampleEntity.getSimpleRepresentationPropertyName(), alias="name");
			smartList.addSelect(propertyIdentifier=exampleEntity.getPrimaryIDPropertyName(), alias="value"); 
			
			smartList.addOrder("#exampleEntity.getSimpleRepresentationPropertyName()#|ASC");
			
			variables[ cacheKey ] = smartList.getRecords();
			
			// If this is a many-to-one related property, then add a 'select' to the top of the list
			if(getPropertyMetaData( propertyName ).fieldType == "many-to-one" && getPropertyMetaData( propertyName ).cfc != "Type") {
				if( structKeyExists(getPropertyMetaData( propertyName ), "nullRBKey") ) {
					arrayPrepend(variables[ cacheKey ], {value="", name=rbKey(getPropertyMetaData( propertyName ).nullRBKey)});
				} else {
					arrayPrepend(variables[ cacheKey ], {value="", name=rbKey('define.select')});	
				}
			}
		}
		
		return variables[ cacheKey ];
		
	}
	
	// @hint returns a smart list or records that can be used as options for a many-to-one property
	public any function getPropertyOptionsSmartList( required string propertyName ) {
		var cacheKey = "#arguments.propertyName#OptionsSmartList";
		
		if(!structKeyExists(variables, cacheKey)) {
			var entityService = getService("utilityORMService").getServiceByEntityName( listLast(getPropertyMetaData( arguments.propertyName ).cfc,'.') );
			variables[ cacheKey ] = entityService.invokeMethod("get#listLast(getPropertyMetaData( arguments.propertyName ).cfc,'.')#SmartList");
			// If the cfc is "Type" then we should be looking for a parentTypeSystemCode in the metaData
			if(getPropertyMetaData( arguments.propertyName ).cfc == "Type") {
				if(structKeyExists(getPropertyMetaData( arguments.propertyName ), "systemCode")) {
					variables[ cacheKey ].addFilter('parentType.systemCode', getPropertyMetaData( arguments.propertyName ).systemCode);
				} else {
					variables[ cacheKey ].addFilter('parentType.systemCode', arguments.propertyName);
				}
			}
		}
		
		return variables[ cacheKey ];
	}
	
	// @hint returns a smart list of the current values for a given one-to-many or many-to-many property
	public any function getPropertySmartList( required string propertyName ) {
		var cacheKey = "#arguments.propertyName#SmartList";
		
		if(!structKeyExists(variables, cacheKey)) {
			
			var entityService = getService("utilityORMService").getServiceByEntityName( listLast(getPropertyMetaData( arguments.propertyName ).cfc,'.') );
			var smartList = entityService.invokeMethod("get#listLast(getPropertyMetaData( arguments.propertyName ).cfc,'.')#SmartList");
			
			// Create an example entity so that we can read the meta data
			var exampleEntity = entityNew("Slatwall#listLast(getPropertyMetaData( arguments.propertyName ).cfc,'.')#");
			
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
			
			return arrayLen(variables[ left(right(arguments.missingMethodName, len(arguments.missingMethodName)-3), len(arguments.missingMethodName)-8) ]);
			
		// getXXX() 			Where XXX is either and attributeID or attributeCode
		} else if (left(arguments.missingMethodName, 3) == "get" && structKeyExists(variables, "getAttributeValue") && hasProperty("attributeValues")) {
			
			return getAttributeValue(right(arguments.missingMethodName, len(arguments.missingMethodName)-3));	
			
		}
				
		throw( 'No matching method for #missingMethodName#().' );
	}	
	
	// ============ START: Non-Persistent Property Methods =================
	
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
					logSlatwall("an ormFlush() failed for an Entity Insert of #getEntityName()# with an errorName: #errorName# and errorMessage: #getErrors()[errorName][i]#", true);	
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
		if(getSlatwallScope().hasApplicationValue("initialized") && getSlatwallScope().getApplicationValue("initialized")) {
			
			// Call the calculatedProperties update
			updateCalculatedProperties();
			
			// Set createdByAccount
			if(structKeyExists(this,"setCreatedByAccount") && !getSlatwallScope().getCurrentAccount().isNew() && len(getSlatwallScope().getCurrentAccount().getAllPermissions()) ){
				setCreatedByAccount( getSlatwallScope().getCurrentAccount() );	
			}
			
			// Set modifiedByAccount
			if(structKeyExists(this,"setModifiedByAccount") && !getSlatwallScope().getCurrentAccount().isNew() && len(getSlatwallScope().getCurrentAccount().getAllPermissions()) ){
				setModifiedByAccount(getSlatwallScope().getCurrentAccount());
			}
			
			// Setup the first sortOrder
			if(structKeyExists(this,"setSortOrder")) {
				var metaData = getPropertyMetaData("sortOrder");
				var topSortOrder = 0;
				if(structKeyExists(metaData, "sortContext") && structKeyExists(variables, metaData.sortContext)) {
					topSortOrder =  getService("dataService").getTableTopSortOrder( tableName=getMetaData(this).table, contextIDColumn=variables[ metaData.sortContext ].getPrimaryIDPropertyName(), contextIDValue=variables[ metaData.sortContext ].getPrimaryIDValue() );
				} else {
					topSortOrder =  getService("dataService").getTableTopSortOrder( tableName=getMetaData(this).table );
				}
				setSortOrder( topSortOrder + 1 );
			}
		}
	}
	
	public void function preUpdate(struct oldData){
		if(!this.isPersistable()) {
			for(var errorName in getErrors()) {
				for(var i=1; i<=arrayLen(getErrors()[errorName]); i++) {
					logSlatwall("an ormFlush() failed for an Entity Update of #getEntityName()# with an errorName: #errorName# and errorMessage: #getErrors()[errorName][i]#", true);	
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
		if(getSlatwallScope().hasApplicationValue("initialized") && getSlatwallScope().getApplicationValue("initialized")) {
		
			// Call the calculatedProperties update
			updateCalculatedProperties();
		
			// Set modifiedByAccount
			if(structKeyExists(this,"setModifiedByAccount") && !getSlatwallScope().getCurrentAccount().isNew() && len(getSlatwallScope().getCurrentAccount().getAllPermissions()) ){
				setModifiedByAccount(getSlatwallScope().getCurrentAccount());
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
}
