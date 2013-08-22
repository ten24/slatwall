component accessors="true" persistent="false" output="false" extends="HibachiObject" {
	
	property name="baseEntityName" type="string";
	property name="cacheable" type="boolean";
	property name="cacheName" type="string";
	property name="savedStateID" type="string";
	
	property name="entities" type="struct";
	property name="entityJoinOrder" type="array";
	
	property name="selects" type="struct" hint="This struct holds any selects that are to be used in creating the records array";
	property name="selectDistinctFlag" type="boolean";
	
	property name="whereGroups" type="array" hint="this holds all filters and ranges";
	property name="whereConditions" type="array";
	property name="orders" type="array" hint="This struct holds the display order specification based on property";
	
	property name="keywords" type="array" hint="This array holds all of the keywords that were searched for";
	property name="keywordPhrases" type="array";
	property name="keywordProperties" type="struct" hint="This struct holds the properties that searches reference and their relative weight";
	
	property name="hqlParams" type="struct";
	property name="pageRecordsStart" type="numeric" hint="This represents the first record to display and it is used in paging.";
	property name="pageRecordsShow" type="numeric" hint="This is the total number of entities to display";
	property name="currentURL" type="string";
	property name="currentPageDeclaration" type="string";
	
	property name="records" type="array";
	property name="pageRecords" type="array";
	
	// Delimiter Settings
	variables.subEntityDelimiters = "._";
	variables.valueDelimiter = ",";
	variables.orderDirectionDelimiter = "|";
	variables.orderPropertyDelimiter = ",";
	variables.rangeDelimiter = "^";
	variables.dataKeyDelimiter = ":";
	
	public any function setup(required string entityName, struct data={}, numeric pageRecordsStart=1, numeric pageRecordsShow=10, string currentURL="") {
		// Make sure that the containers for smart list saved states are in place
		param name="session.entitySmartList" type="struct" default="#structNew()#";
		param name="session.entitySmartList.savedStates" type="array" default="#arrayNew(1)#";
		
		// Set defaults for the main properties
		setEntities({});
		setEntityJoinOrder([]);
		setSelects({});
		setWhereGroups([]);
		setWhereConditions([]);
		setOrders([]);
		setKeywordProperties({});
		setKeywords([]);
		setKeywordPhrases([]);
		setHQLParams({});
		setCurrentURL("");
		setCurrentPageDeclaration(1);
		setCacheable(false);
		setCacheName("");
		setSelectDistinctFlag(0);
		
		// Set currentURL from the arguments
		setCurrentURL(arguments.currentURL);
		
		// Set paging defaults
		setPageRecordsStart(arguments.pageRecordsStart);
		setPageRecordsShow(arguments.pageRecordsShow);
		
		setBaseEntityName( getService("hibachiService").getProperlyCasedFullEntityName( arguments.entityName ) );
		
		addEntity(
			entityName=getBaseEntityName(),
			entityAlias="a#lcase(getBaseEntityName())#",
			entityFullName=getService("hibachiService").getProperlyCasedFullClassNameByEntityName( arguments.entityName ),
			entityProperties=getService("hibachiService").getPropertiesStructByEntityName( arguments.entityName ),
			attributeCount=0
		);
		
		if(structKeyExists(arguments, "data")) {
			applyData(data=arguments.data);	
		}
		
		return this;
	}
	
	public void function applyData(required any data) {
		
		if(!isStruct(arguments.data) && isSimpleValue(arguments.data)) {
			arguments.data = convertNVPStringToStruct(arguments.data);
		}
		
		var currentPage = 1;
		
		if(structKeyExists(arguments.data, "savedStateID")) {
			setSavedStateID(arguments.data.savedStateID);
			loadSavedState(arguments.data.savedStateID);
		}
		
		for(var i in arguments.data) {
			if(structKeyExists(arguments.data, i) && isSimpleValue(arguments.data[i])) {
				if(left(i,2) == "F#variables.dataKeyDelimiter#") {
					addFilter(propertyIdentifier=right(i, len(i)-2), value=arguments.data[i]);
				} else if(left(i,3) == "FR#variables.dataKeyDelimiter#" && isBoolean(arguments.data[i]) && arguments.data[i]) {
					removeFilter(propertyIdentifier=right(i, len(i)-3));
				} else if(left(i,3) == "FI#variables.dataKeyDelimiter#") {
					addInFilter(propertyIdentifier=right(i, len(i)-3), value=arguments.data[i]);
				} else if(left(i,4) == "FIR#variables.dataKeyDelimiter#" && isBoolean(arguments.data[i]) && arguments.data[i]) {
					removeInFilter(propertyIdentifier=right(i, len(i)-4));
				} else if(left(i,3) == "FK#variables.dataKeyDelimiter#") {
					var likeValueList = "";
					for(var x=1; x<=listLen(arguments.data[i], variables.valueDelimiter); x++) {
						likeValueList = listAppend(likeValueList, "%#listGetAt(arguments.data[i], x, variables.valueDelimiter)#%");
					}
					addLikeFilter(propertyIdentifier=right(i, len(i)-3), value=likeValueList);
				} else if(left(i,4) == "FKR#variables.dataKeyDelimiter#" && isBoolean(arguments.data[i]) && arguments.data[i]) {
					removeLikeFilter(propertyIdentifier=right(i, len(i)-4));
				} else if(left(i,2) == "R#variables.dataKeyDelimiter#") {
					addRange(propertyIdentifier=right(i, len(i)-2), value=arguments.data[i]);
				} else if(i == "OrderBy") {
					for(var ii=1; ii <= listLen(arguments.data[i], variables.orderPropertyDelimiter); ii++ ) {
						variables.orders = [];
						addOrder(orderStatement=listGetAt(arguments.data[i], ii, variables.orderPropertyDelimiter));
					}
				} else if(i == "P#variables.dataKeyDelimiter#Show") {
					if(arguments.data[i] == "ALL") {
						setPageRecordsShow(1000000000);
					} else if ( isNumeric(arguments.data[i]) && arguments.data[i] <= 1000000000 && arguments.data[i] > 0 ) {
						setPageRecordsShow(arguments.data[i]);	
					}
				} else if(i == "P#variables.dataKeyDelimiter#Start" && isNumeric(arguments.data[i]) && arguments.data[i] <= 1000000000 && arguments.data[i] > 0) {
					setPageRecordsStart(arguments.data[i]);
				} else if(i == "P#variables.dataKeyDelimiter#Current" && isNumeric(arguments.data[i]) && arguments.data[i] <= 1000000000 && arguments.data[i] > 0) {
					variables.currentPageDeclaration = arguments.data[i];
				}
			}
		}
		// Move data defined as "keyword" to "keywords"
		if(structKeyExists(arguments.data, "keyword")) {
			arguments.data.keywords = arguments.data.keyword;
		}
		
		// Setup the keyword phrases
		if(structKeyExists(arguments.data, "keywords")){
			
			// Parse the list of Keywords in the string
			var keywordList = Replace(arguments.data.Keywords," ",",","all");
			keywordList = Replace(KeywordList,"%20",",","all");
			keywordList = Replace(KeywordList,"+",",","all");
			var keywordArray = listToArray(keywordList);
			
			// Setup the array of keywords in the variables scope
			variables.keywords = keywordArray;
			
			// Setup each Phrase if the keywordsArray is > 1, and add to variables
			if(arrayLen(keywordArray) > 1) {
				for(var ps=1; ps+1<=arrayLen(keywordArray); ps++) {
					for(var i=1; i+ps<= arrayLen(keywordArray); i++) {
						var phrase = "";
						for(var p=i; p<=ps+i; p++){
							phrase = listAppend(phrase, keywordArray[p], " ");
						}
						arrayPrepend(variables.keywordPhrases, phrase);
					}
				}
			}
		}
	}
	
	private struct function convertNVPStringToStruct( required string data ) {
		var returnStruct = {};
		var ampArray = listToArray(arguments.data, "&");
		for(var i=1; i<=arrayLen(ampArray); i++) {
			returnStruct[ listFirst(ampArray[i], "=") ] = listLast(ampArray[i], "=");
		}
		return returnStruct;
	}

	private void function confirmWhereGroup(required numeric whereGroup) {
		for(var i=1; i<=arguments.whereGroup; i++) {
			if(arrayLen(variables.whereGroups) < i) {
				arrayAppend(variables.whereGroups, {filters={},likeFilters={},inFilters={},ranges={}});
			}
		}
	}
	
	private struct function getPropertiesStructFromEntityMeta(required struct meta) {
		var propertyStruct = {};
		var hasExtendedComponent = true;
		var currentEntityMeta = arguments.meta;
		
		do {
			if(structKeyExists(currentEntityMeta, "properties")) {
				for(var i=1; i<=arrayLen(currentEntityMeta.properties); i++) {
					if(!structKeyExists(propertyStruct, currentEntityMeta.properties[i].name)) {
						propertyStruct[currentEntityMeta.properties[i].name] = duplicate(currentEntityMeta.properties[i]);	
					}
				}
			}
			
			hasExtendedComponent = false;
			
			if(structKeyExists(currentEntityMeta, "extends")) {
				currentEntityMeta = currentEntityMeta.extends;
				if(structKeyExists(currentEntityMeta, "persistent") && currentEntityMeta.persistent) {
					hasExtendedComponent = true;	
				}
			}
		} while (hasExtendedComponent);
		
		return propertyStruct;
	}
	
	public string function joinRelatedProperty(required string parentEntityName, required string relatedProperty, string joinType="", boolean fetch=false, boolean isAttribute=false) {
		if(arguments.isAttribute) {
			
			var newEntityMeta = getService("hibachiService").getEntityObject( "AttributeValue" ).getThisMetaData();
			var newEntityName = "#parentEntityName#_#UCASE(arguments.relatedProperty)#";
			var newEntityAlias = "#variables.entities[ arguments.parentEntityName ].entityAlias#_#lcase(arguments.relatedProperty)#";
			
			if(!structKeyExists(variables.entities, newEntityName)) {
				arrayAppend(variables.entityJoinOrder, newEntityName);
				
				confirmWhereGroup(1);
				variables.whereGroups[1].filters["#newEntityAlias#.attribute.attributeCode"] = arguments.relatedProperty;
				
				addEntity(
					entityName=newEntityName,
					entityAlias=newEntityAlias,
					entityFullName="#getApplicationValue('applicationKey')#.model.entity.AttributeValue",
					entityProperties=getPropertiesStructFromEntityMeta(newEntityMeta),
					parentAlias=variables.entities[ arguments.parentEntityName ].entityAlias,
					parentRelatedProperty="attributeValues",
					joinType=arguments.joinType,
					fetch=arguments.fetch
				);
			}
			
			return newEntityName;
		} else {
			var newEntityMeta = getService("hibachiService").getEntityObject( listLast(variables.entities[ arguments.parentEntityName ].entityProperties[ arguments.relatedProperty ].cfc, ".") ).getThisMetaData();
		
			// Figure out the newEntityName
			if(structKeyExists(newEntityMeta, "entityName")) {
				var newEntityName = newEntityMeta.entityName;
			} else {
				var newEntityName = listLast(newEntityMeta.fullName,".");
			}
			
			// Figure out the newEntityAliase
			var aliaseOK = false;
			var aoindex = 1;
			var aolist = "a,b,c,d,e,f,g,h,i,j,k,l";
			var baseAliase = newEntityName;
			do {
				var newEntityAlias = "#listGetAt(aolist,aoindex)##lcase(baseAliase)#";
				if(aoindex > 1) {
					newEntityName = "#lcase(newEntityName)#_#UCASE(listGetAt(aolist,aoindex))#";
				}
				if( (structKeyExists(variables.entities, newEntityName) && variables.entities[newEntityName].entityAlias == newEntityAlias && variables.entities[newEntityName].parentRelatedProperty != relatedProperty) || newEntityAlias == variables.entities[ arguments.parentEntityName ].entityAlias) {
					aoindex++;
				} else {
					aliaseOK = true;
				}
			} while(!aliaseOK);
			
			// Check to see if this is a Self Join, and setup appropriatly.
			if(newEntityAlias == variables.entities[ arguments.parentEntityName ].entityAlias) {
				arguments.fetch = false;
			}
			
			if(!structKeyExists(variables.entities,newEntityName)) {
				arrayAppend(variables.entityJoinOrder, newEntityName);
				
				if(variables.entities[ arguments.parentEntityName ].entityProperties[ arguments.relatedProperty ].fieldtype == "many-to-one" && !structKeyExists(arguments, "fetch") && arguments.parentEntityName == getBaseEntityName()) {
					arguments.fetch = true;
				} else if(variables.entities[ arguments.parentEntityName ].entityProperties[ arguments.relatedProperty ].fieldtype == "one-to-one" && !structKeyExists(arguments, "fetch")) {
					arguments.fetch = true;
				} else if(!structKeyExists(arguments, "fetch")) {
					arguments.fetch = false;
				}
				
				addEntity(
					entityName=newEntityName,
					entityAlias=newEntityAlias,
					entityFullName=newEntityMeta.fullName,
					entityProperties=getPropertiesStructFromEntityMeta(newEntityMeta),
					parentAlias=variables.entities[ arguments.parentEntityName ].entityAlias,
					parentRelatedProperty=variables.entities[ arguments.parentEntityName ].entityProperties[ arguments.relatedProperty ].name,
					joinType=arguments.joinType,
					fetch=arguments.fetch
				);
			} else {
				if(arguments.joinType != "") {
					variables.entities[newEntityName].joinType = arguments.joinType;
				}
				if(structKeyExists(arguments, "fetch")) {
					variables.entities[newEntityName].fetch = arguments.fetch;
				}
			}
			
			return newEntityName;	
		}
	}
	
	private void function addEntity(required string entityName, required string entityAlias, required string entityFullName, required struct entityProperties, string parentAlias="", string parentRelatedProperty="", string joinType="") {
		variables.entities[arguments.entityName] = duplicate(arguments);
	}
	
	private string function getAliasedProperty(required string propertyIdentifier, boolean fetch) {
		var entityName = getBaseEntityName();
		var entityAlias = variables.entities[getBaseEntityName()].entityAlias;
		
		var propertyExists = getService("hibachiService").getHasPropertyByEntityNameAndPropertyIdentifier(entityName=entityName, propertyIdentifier=arguments.propertyIdentifier);
		var propertyIsAttribute = false;
		
		if(!propertyExists) {
			var propertyIsAttribute = getService("hibachiService").getHasAttributeByEntityNameAndPropertyIdentifier(entityName=entityName, propertyIdentifier=arguments.propertyIdentifier);
			if(!propertyIsAttribute) {
				return "";	
			}
		}
		
		if(propertyIsAttribute && listLen(arguments.propertyIdentifier, variables.subEntityDelimiters) eq 1) {
			if(structKeyExists(arguments,"fetch")){
				entityName = joinRelatedProperty(parentEntityName=entityName, relatedProperty=arguments.propertyIdentifier,fetch=arguments.fetch,isAttribute=true);
			} else {
				entityName = joinRelatedProperty(parentEntityName=entityName, relatedProperty=arguments.propertyIdentifier,isAttribute=true);
			}
			entityAlias = variables.entities[entityName].entityAlias;
		} else {
			for(var i=1; i<listLen(arguments.propertyIdentifier, variables.subEntityDelimiters); i++) {
				var thisProperty = listGetAt(arguments.propertyIdentifier, i, variables.subEntityDelimiters);
				var isAttribute = false;
				if(propertyIsAttribute && listLen(arguments.propertyIdentifier, variables.subEntityDelimiters) == i+1) {
					isAttribute = true;
				}
				if(structKeyExists(arguments,"fetch")){
					entityName = joinRelatedProperty(parentEntityName=entityName, relatedProperty=thisProperty,fetch=arguments.fetch,isAttribute=isAttribute);
				} else {
					entityName = joinRelatedProperty(parentEntityName=entityName, relatedProperty=thisProperty,isAttribute=isAttribute);
				}
				entityAlias = variables.entities[entityName].entityAlias;
			}
		}
		
		if(propertyIsAttribute) {
			return "#entityAlias#.attributeValue";	
		}
		return "#entityAlias#.#variables.entities[entityName].entityProperties[listLast(propertyIdentifier, variables.subEntityDelimiters)].name#";
	}
	
	public void function addSelect(required string propertyIdentifier, required string alias) {
		var aliasedProperty = getAliasedProperty(propertyIdentifier=arguments.propertyIdentifier,fetch=false);
		if(len(aliasedProperty)) {
			variables.selects[aliasedProperty] = arguments.alias;	
		} 
	}
	
	public void function addWhereCondition(required string condition, struct conditionParams={}, string conditionOperator="AND") {
		arrayAppend(variables.whereConditions, arguments);
	}
	
	public void function addFilter(required string propertyIdentifier, required string value, numeric whereGroup=1, boolean fetch) {
		confirmWhereGroup(arguments.whereGroup);
		if(structKeyExists(arguments,"fetch")){
			var aliasedProperty = getAliasedProperty(propertyIdentifier=arguments.propertyIdentifier,fetch=arguments.fetch);
		} else {
			var aliasedProperty = getAliasedProperty(propertyIdentifier=arguments.propertyIdentifier);
		}
		if(len(aliasedProperty)) {
			variables.whereGroups[arguments.whereGroup].filters[aliasedProperty] = arguments.value;	
		}
	}
	
	public void function removeFilter(required string propertyIdentifier, numeric whereGroup=1) {
		confirmWhereGroup(arguments.whereGroup);
		var aliasedProperty = getAliasedProperty(propertyIdentifier=arguments.propertyIdentifier);
		if(structKeyExists(variables.whereGroups[arguments.whereGroup].filters, aliasedProperty)){
			structDelete(variables.whereGroups[arguments.whereGroup].filters, aliasedProperty);
		};
	}
	public any function getFilters(string propertyIdentifier, numeric whereGroup=1) {
		confirmWhereGroup(arguments.whereGroup);
		if( structKeyExists(arguments, "propertyIdentifier") ) {
			var aliasedProperty = getAliasedProperty(propertyIdentifier=arguments.propertyIdentifier);
			if(structKeyExists(variables.whereGroups[ arguments.whereGroup ].filters, aliasedProperty)){
				return variables.whereGroups[ arguments.whereGroup ].filters[aliasedProperty];
			}
			return "";
		}
		return variables.whereGroups[ arguments.whereGroup ].filters; 
	}
	
	public void function addLikeFilter(required string propertyIdentifier, required string value, numeric whereGroup=1) {
		confirmWhereGroup(arguments.whereGroup);
		var aliasedProperty = getAliasedProperty(propertyIdentifier=arguments.propertyIdentifier);
		if(len(aliasedProperty)) {
			variables.whereGroups[arguments.whereGroup].likeFilters[aliasedProperty] = arguments.value;	
		}
	}
	public void function removeLikeFilter(required string propertyIdentifier, whereGroup=1) {
		confirmWhereGroup(arguments.whereGroup);
		var aliasedProperty = getAliasedProperty(propertyIdentifier=arguments.propertyIdentifier);
		if(structKeyExists(variables.whereGroups[arguments.whereGroup].likeFilters, aliasedProperty)){
			structDelete(variables.whereGroups[arguments.whereGroup].likeFilters, aliasedProperty);
		};
	}
	public any function getLikeFilters(string propertyIdentifier, numeric whereGroup=1) {
		confirmWhereGroup(arguments.whereGroup);
		if( structKeyExists(arguments, "propertyIdentifier") ) {
			var aliasedProperty = getAliasedProperty(propertyIdentifier=arguments.propertyIdentifier);
			if(structKeyExists(variables.whereGroups[ arguments.whereGroup ].likeFilters, aliasedProperty)){
				return variables.whereGroups[ arguments.whereGroup ].likeFilters[aliasedProperty];
			}
			return "";
		}
		return variables.whereGroups[ arguments.whereGroup ].likeFilters; 
	}
	
	public void function addInFilter(required string propertyIdentifier, required string value, numeric whereGroup=1) {
		confirmWhereGroup(arguments.whereGroup);
		var aliasedProperty = getAliasedProperty(propertyIdentifier=arguments.propertyIdentifier);
		if(len(aliasedProperty)) {
			variables.whereGroups[arguments.whereGroup].inFilters[aliasedProperty] = arguments.value;	
		}
	}
	public void function removeInFilter(required string propertyIdentifier, whereGroup=1) {
		confirmWhereGroup(arguments.whereGroup);
		var aliasedProperty = getAliasedProperty(propertyIdentifier=arguments.propertyIdentifier);
		if(structKeyExists(variables.whereGroups[arguments.whereGroup].inFilters, aliasedProperty)){
			structDelete(variables.whereGroups[arguments.whereGroup].inFilters, aliasedProperty);
		};
	}
	public any function getInFilters(string propertyIdentifier, numeric whereGroup=1) {
		confirmWhereGroup(arguments.whereGroup);
		if( structKeyExists(arguments, "propertyIdentifier") ) {
			var aliasedProperty = getAliasedProperty(propertyIdentifier=arguments.propertyIdentifier);
			if(structKeyExists(variables.whereGroups[ arguments.whereGroup ].inFilters, aliasedProperty)){
				return variables.whereGroups[ arguments.whereGroup ].inFilters[aliasedProperty];
			}
			return "";
		}
		return variables.whereGroups[ arguments.whereGroup ].inFilters; 
	}
	
	public void function addRange(required string propertyIdentifier, required string value, numeric whereGroup=1) {
		if( (left( arguments.value, 1) == variables.rangeDelimiter || isNumeric(listFirst(arguments.value, variables.rangeDelimiter)) || isDate(listLast(arguments.value, variables.rangeDelimiter)) ) && (right( arguments.value, 1) == variables.rangeDelimiter || isNumeric(listLast(arguments.value, variables.rangeDelimiter)) || isDate(listLast(arguments.value, variables.rangeDelimiter)) ) ) {
			confirmWhereGroup(arguments.whereGroup);
			var aliasedProperty = getAliasedProperty(propertyIdentifier=arguments.propertyIdentifier);
			if(len(aliasedProperty)) {
				variables.whereGroups[arguments.whereGroup].ranges[aliasedProperty] = arguments.value;
			}
		}
	}
	public void function removeRange(required string propertyIdentifier, whereGroup=1) {
		confirmWhereGroup(arguments.whereGroup);
		var aliasedProperty = getAliasedProperty(propertyIdentifier=arguments.propertyIdentifier);
		if(structKeyExists(variables.whereGroups[arguments.whereGroup].ranges, aliasedProperty)){
			structDelete(variables.whereGroups[arguments.whereGroup].ranges, aliasedProperty);
		};
	}
	public any function getRanges(string propertyIdentifier, numeric whereGroup=1) {
		confirmWhereGroup(arguments.whereGroup);
		if( structKeyExists(arguments, "propertyIdentifier") ) {
			var aliasedProperty = getAliasedProperty(propertyIdentifier=arguments.propertyIdentifier);
			if(structKeyExists(variables.whereGroups[ arguments.whereGroup ].ranges, aliasedProperty)){
				return variables.whereGroups[ arguments.whereGroup ].ranges[aliasedProperty];
			}
			return "";
		}
		return variables.whereGroups[ arguments.whereGroup ].ranges; 
	}
	
	public void function addOrder(required string orderStatement, numeric position) {
		var propertyIdentifier = listFirst(arguments.orderStatement, variables.orderDirectionDelimiter);
		var orderDirection = "ASC";
		if(listLen(arguments.orderStatement, variables.orderDirectionDelimiter) > 1 && listFindNoCase("D,DESC", listLast(arguments.orderStatement, variables.orderDirectionDelimiter))) {
			orderDirection = "DESC";
		}
		var aliasedProperty = getAliasedProperty(propertyIdentifier=propertyIdentifier);
		if(len(aliasedProperty)) {
			arrayAppend(variables.orders, {property=aliasedProperty, direction=orderDirection});
		}
	}

	public void function addKeywordProperty(required string propertyIdentifier, required numeric weight) {
		var aliasedProperty = getAliasedProperty(propertyIdentifier=propertyIdentifier);
		if(len(aliasedProperty)) {
			variables.keywordProperties[aliasedProperty] = arguments.weight;
		}
	}
	
	public void function addHQLParam(required string paramName, required any paramValue) {
		variables.hqlParams[ arguments.paramName ] = arguments.paramValue;
	}
	
	public struct function getHQLParams() {
		return duplicate(variables.hqlParams);
	}

	public string function getHQLSelect (boolean countOnly=false) {
		var hqlSelect = "";
		
		if(arguments.countOnly) {
			hqlSelect &= "SELECT count(distinct #variables.entities[getBaseEntityName()].entityAlias#.#getService('hibachiService').getPrimaryIDPropertyNameByEntityName(getBaseEntityName())#)";
		} else {
			if(structCount(variables.selects)) {
				hqlSelect = "SELECT";
				if(getSelectDistinctFlag()) {
					hqlSelect &= " DISTINCT";
				}
				hqlSelect &= " new map(";
				for(var select in variables.selects) {
					hqlSelect &= " #select# as #variables.selects[select]#,";
				}
				hqlSelect = left(hqlSelect, len(hqlSelect)-1) & ")";
			} else {
				hqlSelect &= "SELECT";
				if(getSelectDistinctFlag()) {
					hqlSelect &= " DISTINCT";	
				}
				hqlSelect &= " #variables.entities[getBaseEntityName()].entityAlias#";
			}
		}
		return hqlSelect;
	}
	
	public string function getHQLFrom(boolean supressFrom=false, boolean allowFetch=true) {
		var hqlFrom = "";
		if(!arguments.supressFrom) {
			hqlFrom &= " FROM";	
		}
		
		hqlFrom &= " #getBaseEntityName()# as #variables.entities[getBaseEntityName()].entityAlias#";
		

		for(var i in variables.entityJoinOrder) {
			if(i != getBaseEntityName()) {
				var joinType = variables.entities[i].joinType;
				if(!len(joinType)) {
					joinType = "left";
				}
				
				var fetch = "";
				
				if(variables.entities[i].fetch && arguments.allowFetch && !structCount(variables.selects)) {
					fetch = "fetch";
				}
				
				hqlFrom &= " #joinType# join #fetch# #variables.entities[i].parentAlias#.#variables.entities[i].parentRelatedProperty# as #variables.entities[i].entityAlias#";	
				
			}
		}
		return hqlFrom;
	}
	
	public string function getHQLWhere(boolean suppressWhere=false, searchOrder=false) {
		var hqlWhere = "";
		variables.hqlParams = {};
		
		
		// Loop over where groups
		for(var i=1; i<=arrayLen(variables.whereGroups); i++) {
			if( structCount(variables.whereGroups[i].filters) || structCount(variables.whereGroups[i].likeFilters) || structCount(variables.whereGroups[i].inFilters) || structCount(variables.whereGroups[i].ranges) ) {

				if(len(hqlWhere) == 0) {
					if(!arguments.suppressWhere) {
						hqlWhere &= " WHERE";
					}
					hqlWhere &= " (";
				} else {
					hqlWhere &= " OR";
				}
				
				// Open A Where Group
				hqlWhere &= " (";
				
				// Add Where Group Filters
				for(var filter in variables.whereGroups[i].filters) {
					if(listLen(variables.whereGroups[i].filters[filter], variables.valueDelimiter) gt 1) {
						hqlWhere &= " (";
						for(var ii=1; ii<=listLen(variables.whereGroups[i].filters[filter], variables.valueDelimiter); ii++) {
							if(listGetAt(variables.whereGroups[i].filters[filter], ii, variables.valueDelimiter) eq "NULL") {
								hqlWhere &= " #filter# IS NULL OR";	
							} else {
								var paramID = "F#replace(filter, ".", "", "all")##i##ii#";
								addHQLParam(paramID, listGetAt(variables.whereGroups[i].filters[filter], ii, variables.valueDelimiter));
								hqlWhere &= " #filter# = :#paramID# OR";
							}
						}
						hqlWhere = left(hqlWhere, len(hqlWhere)-2) & ") AND";
					} else {
						if(variables.whereGroups[i].filters[filter] == "NULL") {
							hqlWhere &= " #filter# IS NULL AND";
						} else {
							var paramID = "F#replace(filter, ".", "", "all")##i#";
							addHQLParam(paramID, variables.whereGroups[i].filters[filter]);
							hqlWhere &= " #filter# = :#paramID# AND";	
						}
					}
				}
				
				// Add Where Group Like Filters
				for(var likeFilter in variables.whereGroups[i].likeFilters) {
					if(listLen(variables.whereGroups[i].likeFilters[likeFilter], variables.valueDelimiter) gt 1) {
						hqlWhere &= " (";
						for(var ii=1; ii<=listLen(variables.whereGroups[i].likeFilters[likeFilter], variables.valueDelimiter); ii++) {
							var paramID = "LF#replace(likeFilter, ".", "", "all")##i##ii#";
							addHQLParam(paramID, listGetAt(variables.whereGroups[i].likeFilters[likeFilter], ii, variables.valueDelimiter));
							hqlWhere &= " #likeFilter# LIKE :#paramID# OR";
						}
						hqlWhere = left(hqlWhere, len(hqlWhere)-2) & ") AND";
					} else {
						var paramID = "LF#replace(likeFilter, ".", "", "all")##i#";
						addHQLParam(paramID, variables.whereGroups[i].likeFilters[likeFilter]);
						hqlWhere &= " #likeFilter# LIKE :#paramID# AND";
					}
				}
				
				// Add Where Group In Filters
				for(var inFilter in variables.whereGroups[i].inFilters) {
					var paramID = "LF#replace(inFilter, ".", "", "all")##i#";
					var paramValue = variables.whereGroups[i].inFilters[inFilter];
					
					addHQLParam(paramID, listToArray(paramValue));
					
					hqlWhere &= " #inFilter# IN (:#paramID#) AND";
				}
				
				// Add Where Group Ranges
				for(var range in variables.whereGroups[i].ranges) {
					
					if(len(variables.whereGroups[i].ranges[range]) gt 1) {
						
						// Only A Higher
						if(left(variables.whereGroups[i].ranges[range],1) == variables.rangeDelimiter) {
							
							var paramIDupper = "R#replace(range, ".", "", "all")##i#upper";
							addHQLParam(paramIDupper, listLast(variables.whereGroups[i].ranges[range], variables.rangeDelimiter));
							hqlWhere &= " #range# <= :#paramIDupper# AND";
							
						// Only A Lower
						} else if (right(variables.whereGroups[i].ranges[range],1) == variables.rangeDelimiter) {
						
							var paramIDlower = "R#replace(range, ".", "", "all")##i#lower";
							addHQLParam(paramIDlower, listFirst(variables.whereGroups[i].ranges[range], variables.rangeDelimiter));
							hqlWhere &= " #range# >= :#paramIDlower# AND";
						
						// Both
						} else {
						
							var paramIDupper = "R#replace(range, ".", "", "all")##i#upper";
							var paramIDlower = "R#replace(range, ".", "", "all")##i#lower";
							addHQLParam(paramIDlower, listFirst(variables.whereGroups[i].ranges[range], variables.rangeDelimiter));
							addHQLParam(paramIDupper, listLast(variables.whereGroups[i].ranges[range], variables.rangeDelimiter));
							hqlWhere &= " #range# >= :#paramIDlower# AND #range# <= :#paramIDupper# AND";	
							
						}
						
					}
					
				}
				
				// Close Where Group
				hqlWhere = left(hqlWhere, len(hqlWhere)-3)& ")";
				if( i == arrayLen(variables.whereGroups)) {
					hqlWhere &= " )";
				}
			}
		}
		
		// Add Search Filters if keywords exist
		if( arrayLen(variables.Keywords) && structCount(variables.keywordProperties) ) {
			if(len(hqlWhere) == 0) {
				if(!arguments.suppressWhere) {
					hqlWhere &= " WHERE";
				}
			} else {
				hqlWhere &= " AND";
			}
			
			for(var ii=1; ii<=arrayLen(variables.Keywords); ii++) {
				var paramID = "keyword#ii#";
				addHQLParam(paramID, "%#variables.Keywords[ii]#%");
				hqlWhere &= " (";
				for(var keywordProperty in variables.keywordProperties) {
					
					hqlWhere &= " #keywordProperty# LIKE :#paramID# OR";
				}
				hqlWhere = left(hqlWhere, len(hqlWhere)-3 );
				hqlWhere &= " ) AND";
			}
			hqlWhere = left(hqlWhere, len(hqlWhere)-4 );
		}
		
		// Add Where Conditions
		if( arrayLen(getWhereConditions()) ) {
			for(var i=1; i<=arrayLen(getWhereConditions()); i++) {
				if(len(hqlWhere) == 0) {
					if(!arguments.suppressWhere && i==1) {
						hqlWhere &= " WHERE";
					}
				} else {
					hqlWhere &= " #getWhereConditions()[i].conditionOperator#";
				}
				structAppend(variables.hqlParams,getWhereConditions()[i].conditionParams);
				hqlWhere &= " #getWhereConditions()[i].condition#";
			}
		}
		
		return hqlWhere;
	}
	
	public string function getBaseEntityPrimaryAliase() {
		return "#variables.entities[ getBaseEntityName() ].entityAlias#.#getService("hibachiService").getPrimaryIDPropertyNameByEntityName(getBaseEntityName())#";
	}
	
	public string function getHQLOrder(boolean supressOrderBy=false) {
		var hqlOrder = "";
		if(arrayLen(variables.orders)){
			
			if(!arguments.supressOrderBy) {
				hqlOrder &= " ORDER BY";
			}
			
			for(var i=1; i<=arrayLen(variables.orders); i++) {
				hqlOrder &= " #variables.orders[i].property# #variables.orders[i].direction#,";
			}
			hqlOrder = left(hqlOrder, len(hqlOrder)-1);
		} else if (!structCount(variables.selects)) {
			
			var baseEntityObject = getService('hibachiService').getEntityObject( getBaseEntityName() );
			
			if(structKeyExists(baseEntityObject.getThisMetaData(), "hb_defaultOrderProperty")) {
				var obProperty = getAliasedProperty( baseEntityObject.getThisMetaData().hb_defaultOrderProperty );
			} else if ( baseEntityObject.hasProperty( "createdDateTime" ) ) {
				var obProperty = getAliasedProperty( "createdDateTime" );
			} else {
				var obProperty = getAliasedProperty( getService("hibachiService").getPrimaryIDPropertyNameByEntityName( getBaseEntityName() ) );
			}
			
			hqlOrder &= " ORDER BY #obProperty# ASC";
		}
		
		return hqlOrder;
	}
	
	public string function getHQL() {			
		return "#getHQLSelect()##getHQLFrom()##getHQLWhere()##getHQLOrder()#";
	}

	public array function getRecords(boolean refresh=false) {
		if( !structKeyExists(variables, "records") || arguments.refresh == true) {
			variables.records = ormExecuteQuery(getHQL(), getHQLParams(), false, {ignoreCase="true", cacheable=getCacheable(), cachename="records-#getCacheName()#"});
		}
		return variables.records;
	}
	
	// Paging Methods
	public array function getPageRecords(boolean refresh=false) {
		if( !structKeyExists(variables, "pageRecords") || arguments.refresh == true) {
			saveState();
			variables.pageRecords = ormExecuteQuery(getHQL(), getHQLParams(), false, {offset=getPageRecordsStart()-1, maxresults=getPageRecordsShow(), ignoreCase="true", cacheable=getCacheable(), cachename="pageRecords-#getCacheName()#"});
		}
		return variables.pageRecords;
	}
	
	public void function clearRecordsCount() {
		structDelete(variables, "recordsCount");
	}
	
	public numeric function getRecordsCount() {
		if(!structKeyExists(variables, "recordsCount")) {
			if(getCacheable() && structKeyExists(application.entitySmartList, getCacheName()) && structKeyExists(application.entitySmartList[getCacheName()], "recordsCount")) {
				variables.recordsCount = application.entitySmartList[ getCacheName() ].recordsCount;
			} else {
				if(!structKeyExists(variables,"records")) {
					var HQL = "#getHQLSelect(countOnly=true)##getHQLFrom(allowFetch=false)##getHQLWhere()#";
					var recordCount = ormExecuteQuery(HQL, getHQLParams(), true, {ignoreCase="true"});
					variables.recordsCount = recordCount;
					if(getCacheable()) {
						application.entitySmartList[ getCacheName() ] = {};
						application.entitySmartList[ getCacheName() ].recordsCount = variables.recordsCount;
					}
				} else {
					variables.recordsCount = arrayLen(getRecords());	
				}
			}
		}
		return variables.recordsCount;
	}
	
	public numeric function getPageRecordsStart() {
		if(variables.currentPageDeclaration > 1) {
			variables.pageRecordsStart = ((variables.currentPageDeclaration-1)*getPageRecordsShow()) + 1;
		}

		return variables.pageRecordsStart;
	}
	
	public numeric function getPageRecordsEnd() {
		var pageRecordEnd = getPageRecordsStart() + getPageRecordsShow() - 1;
		if(pageRecordEnd > getRecordsCount()) {
			pageRecordEnd = getRecordsCount();
		}
		return pageRecordEnd;
	}
	
	public numeric function getCurrentPage() {
		return ceiling(getPageRecordsStart() / getPageRecordsShow());
	}
	
	public any function getTotalPages() {
		return ceiling(getRecordsCount() / getPageRecordsShow());
	}
	
	public string function buildURL(required string queryAddition, boolean appendValues=true, boolean toggleKeys=true, string currentURL=variables.currentURL) {
		// Generate full URL if one wasn't passed in
		if(arguments.currentURL == "") {
			//arguments.currentURL &= CGI.SCRIPT_NAME;
			if(CGI.PATH_INFO != "" && CGI.PATH_INFO neq CGI.SCRIPT_NAME) {
				arguments.currentURL &= CGI.PATH_INFO;	
			}
			if(len(cgi.query_string)) {
				arguments.currentURL &= "?" & CGI.QUERY_STRING;	
			}
		}

		// Setup the base of the new URL
		var modifiedURL = listFirst(arguments.currentURL, "?") & "?";
		
		// Turn the old query string into a struct
		var oldQueryKeys = {};
		
		if(listLen(arguments.currentURL, "?") == 2) {
			for(var i=1; i<=listLen(listLast(arguments.currentURL, "?"), "&"); i++) {
				var keyValuePair = listGetAt(listLast(arguments.currentURL, "?"), i, "&");
				oldQueryKeys[listFirst(keyValuePair,"=")] = listLast(keyValuePair,"=");
			}
		}
		
		// Turn the added query string to a struct
		var newQueryKeys = {};
		for(var i=1; i<=listLen(arguments.queryAddition, "&"); i++) {
			var keyValuePair = listGetAt(arguments.queryAddition, i, "&");
			newQueryKeys[listFirst(keyValuePair,"=")] = listLast(keyValuePair,"=");
		}
		
		
		// Get all keys and values from the old query string added
		for(var key in oldQueryKeys) {
			if(key != "P#variables.dataKeyDelimiter#Current" && key != "P#variables.dataKeyDelimiter#Start" && key != "P#variables.dataKeyDelimiter#Show") {
				if(!structKeyExists(newQueryKeys, key)) {
					modifiedURL &= "#key#=#oldQueryKeys[key]#&";
				} else {
					if(arguments.toggleKeys && structKeyExists(oldQueryKeys, key) && structKeyExists(newQueryKeys, key) && oldQueryKeys[key] == newQueryKeys[key]) {
						structDelete(newQueryKeys, key);
					} else if(arguments.appendValues) {
						for(var i=1; i<=listLen(newQueryKeys[key], variables.valueDelimiter); i++) {
							var thisVal = listGetAt(newQueryKeys[key], i, variables.valueDelimiter);
							var findCount = listFindNoCase(oldQueryKeys[key], thisVal, variables.valueDelimiter);
							if(findCount) {
								newQueryKeys[key] = listDeleteAt(newQueryKeys[key], i, variables.valueDelimiter);
								if(arguments.toggleKeys) {
									oldQueryKeys[key] = listDeleteAt(oldQueryKeys[key], findCount);
								}
							}
						}
						if(len(oldQueryKeys[key]) && len(newQueryKeys[key])) {
							if(left(key, 1) eq "r") {
								modifiedURL &= "#key#=#newQueryKeys[key]#&";	
							} else {
								modifiedURL &= "#key#=#oldQueryKeys[key]##variables.valueDelimiter##newQueryKeys[key]#&";
							}
						} else if(len(oldQueryKeys[key])) {
							modifiedURL &= "#key#=#oldQueryKeys[key]#&";
						}
						structDelete(newQueryKeys, key);
					}
				}
			}
		}
		
		// Get all keys and values from the additional query string added 
		for(var key in newQueryKeys) {
			if(key != "P#variables.dataKeyDelimiter#Current" && key != "P#variables.dataKeyDelimiter#Start" && key != "P#variables.dataKeyDelimiter#Show") {
				modifiedURL &= "#key#=#newQueryKeys[key]#&";
			}
		}
		
		if(!structKeyExists(newQueryKeys, "P#variables.dataKeyDelimiter#Show") || newQueryKeys["P#variables.dataKeyDelimiter#Show"] == getPageRecordsShow()) {
			// Add the correct page start
			if( structKeyExists(newQueryKeys, "P#variables.dataKeyDelimiter#Start") ) {
				modifiedURL &= "P#variables.dataKeyDelimiter#Start=#newQueryKeys[ 'P#variables.dataKeyDelimiter#Start' ]#&";
			} else if( structKeyExists(newQueryKeys, "P#variables.dataKeyDelimiter#Current") ) {
				modifiedURL &= "P#variables.dataKeyDelimiter#Current=#newQueryKeys[ 'P#variables.dataKeyDelimiter#Current' ]#&";
			}
		}
		
		// Add the correct page show
		if( structKeyExists(newQueryKeys, "P#variables.dataKeyDelimiter#Show") ) {
			modifiedURL &= "P#variables.dataKeyDelimiter#Show=#newQueryKeys[ 'P#variables.dataKeyDelimiter#Show' ]#&";
		} else if( structKeyExists(oldQueryKeys, "P#variables.dataKeyDelimiter#Show") ) {
			modifiedURL &= "P#variables.dataKeyDelimiter#Show=#oldQueryKeys[ 'P#variables.dataKeyDelimiter#Show' ]#&";
		}
		
		if(right(modifiedURL, 1) eq "&" || right(modifiedURL, 1) eq "?") {
			modifiedURL = left(modifiedURL, len(modifiedURL)-1);
		}
		
		// Always return lower case
		return lcase(modifiedURL);
	}
	
	public boolean function isFilterApplied(required string filter, required string value){
		var exists = false;
		if(structKeyExists(url,"F#variables.dataKeyDelimiter##arguments.filter#") && listFindNoCase(url["F#variables.dataKeyDelimiter##arguments.filter#"],arguments.value,variables.valueDelimiter)){
			exists = true;
		}
		return exists;
	}
	
	public boolean function isLikeFilterApplied(required string filter, required string value){
		var exists = false;
		if(structKeyExists(url,"FK#variables.dataKeyDelimiter##arguments.filter#") && listFindNoCase(url["FK#variables.dataKeyDelimiter##arguments.filter#"],arguments.value,variables.valueDelimiter)){
			exists = true;
		}
		return exists;
	}
	
	public boolean function isRangeApplied(required string range, required string value){
		var exists = false;
		if(structKeyExists(url,"R#variables.dataKeyDelimiter##arguments.range#") and url["R#variables.dataKeyDelimiter##arguments.range#"] eq arguments.value){
			exists = true;
		}
		return exists;
	}
	
	public array function getFilterOptions(required string valuePropertyIdentifier, required string namePropertyIdentifier) {
		var nameProperty = getAliasedProperty(propertyIdentifier=arguments.namePropertyIdentifier);
		var valueProperty = getAliasedProperty(propertyIdentifier=arguments.valuePropertyIdentifier);
		
		var originalWhereGroup = duplicate(variables.whereGroups);
		
		for(var i=1; i<=arrayLen(variables.whereGroups); i++) {
			for(var key in variables.whereGroups[i].filters) {
				if(key == valueProperty) {
					structDelete(variables.whereGroups[i].filters, key);
				}
			}
		}
			
		var results = ormExecuteQuery("SELECT NEW MAP(
			#nameProperty# as name,
			#valueProperty# as value,
			count(#nameProperty#) as count
			)
		#getHQLFrom(allowFetch=false)#
		#getHQLWhere()# #IIF(len(getHQLWhere()), DE('AND'), DE('WHERE'))#
				#nameProperty# IS NOT NULL
			AND
				#valueProperty# IS NOT NULL
		GROUP BY
			#nameProperty#,
			#valueProperty#
		ORDER BY
			#nameProperty# ASC", getHQLParams());
		
		variables.whereGroups = originalWhereGroup;
		
		return results;
	}
	
	public struct function getRangeMinMax(required string propertyIdentifier) {
		var rangeProperty = getAliasedProperty(propertyIdentifier=arguments.propertyIdentifier);
		
		var originalWhereGroup = duplicate(variables.whereGroups);
		
		for(var i=1; i<=arrayLen(variables.whereGroups); i++) {
			for(var key in variables.whereGroups[i].ranges) {
				if(key == rangeProperty) {
					structDelete(variables.whereGroups[i].ranges, key);
				}
			}
		}
		
		var results = ormExecuteQuery("SELECT NEW MAP(
			min(#rangeProperty#) as min,
			max(#rangeProperty#) as max
			)
		#getHQLFrom(allowFetch=false)#
		#getHQLWhere()#", getHQLParams(), true);
			
		variables.whereGroups = originalWhereGroup;
		
		return results;
	}
	
	
	// =============== Saved State Logic ===========================
	
	public void function loadSavedState(required string savedStateID) {
		var savedStates = [];
		if(hasSessionValue('smartListSavedState')) {
			savedStates = getSessionValue('smartListSavedState');	
		}
		for(var s=1; s<=arrayLen(savedStates); s++) {
			if(savedStates[s].savedStateID eq arguments.savedStateID) {
				for(var key in savedStates[s]) {
					variables[key] = duplicate(savedStates[s][key]);
				}	
			}
		}
	}
	
	private void function saveState() {
		// Make sure that the saved states structure and array exists
		if(!hasSessionValue('smartListSavedState')) {
			setSessionValue('smartListSavedState', []);
		}
		
		var sessionKey = "";
		if(structKeyExists(COOKIE, "JSESSIONID")) {
			sessionKey = COOKIE.JSESSIONID;
		} else if (structKeyExists(COOKIE, "CFTOKEN")) {
			sessionKey = COOKIE.CFTOKEN;
		} else if (structKeyExists(COOKIE, "CFID")) {
			sessionKey = COOKIE.CFID;
		}
		
		// Lock the session so that we can manipulate based on saved state
		lock name="#sessionKey#_#getHibachiInstanceApplicationScopeKey()#_smartListSavedStateUpdateLogic" timeout="10" {
		
			// Get the saved state struct
			var states = getSessionValue('smartListSavedState');
			
			// Setup the state
			var state = getStateStruct();
			state.savedStateID = getSavedStateID();
			
			// If the savedState already existed, then delete it
			for(var e=1; e<=arrayLen(states); e++) {
				if(states[e].savedStateID eq state.savedStateID) {
					arrayDeleteAt(states, e);
				}
			}
			
			// Add the state to the states array
			arrayPrepend(states, state);
				
			for(var s=arrayLen(states); s>30; s--) {
				arrayDeleteAt(states, s);
			}
			
			setSessionValue('smartListSavedState', states);
		}
	}
	
	public string function getSavedStateID() {
		if(!structKeyExists(variables, "savedStateID")) {
			variables.savedStateID = createUUID();
		}
		
		return variables.savedStateID;
	}
	
	public struct function getStateStruct() {
		var stateStruct = {};
		
		stateStruct.baseEntityName = duplicate(variables.baseEntityName);
		stateStruct.entities = duplicate(variables.entities);
		stateStruct.whereGroups = duplicate(variables.whereGroups);
		stateStruct.whereConditions = duplicate(variables.whereConditions);
		stateStruct.orders = duplicate(variables.orders);
		stateStruct.keywords = duplicate(variables.keywords);
		stateStruct.keywordProperties = duplicate(variables.keywordProperties);
		stateStruct.pageRecordsShow = duplicate(variables.pageRecordsShow);
		stateStruct.entityJoinOrder = duplicate(variables.entityJoinOrder);
		stateStruct.selectDistinctFlag = duplicate(variables.selectDistinctFlag);
		
		return stateStruct;
	}
	
	public any function getCacheName() {
		// Take the stateStruct, serialize it, and turn that list it into a an array
		var valueArray = listToArray(serializeJSON(getStateStruct()));
		
		// Sort the array so that the values always end up the same
		arraySort(valueArray,"text");
		
		// Turn the array back into a list, lcase, and hash for the name
		return hash(lcase(arrayToList(valueArray,",")));
	}
}