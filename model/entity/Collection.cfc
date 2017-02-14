/*

    Slatwall - An e-commerce plugin for Mura CMS
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
component displayname="Collection" entityname="SlatwallCollection" table="SwCollection" persistent="true" hb_permission="this" accessors="true" extends="HibachiEntity" hb_serviceName="hibachiCollectionService" {

	// Persistent Properties
	property name="collectionID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="collectionName" ormtype="string";
	property name="collectionCode" ormtype="string" unique="true" index="PI_COLLECTIONCODE";
	property name="collectionDescription" ormtype="string";
	property name="collectionObject" ormtype="string" hb_formFieldType="select";
	property name="collectionConfig" ormtype="string" length="8000" hb_auditable="false" hb_formFieldType="json" hint="json object used to construct the base collection HQL query";
	// Calculated Properties

	// Related Object Properties (many-to-one)
	property name="parentCollection" cfc="Collection" fieldtype="many-to-one" fkcolumn="parentCollectionID";

	// Related Object Properties (one-to-many)

	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)

	// Remote Properties
	property name="remoteID" ormtype="string";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	// Non-Persistent Properties
	property name="collectionConfigStruct" type="struct" persistent="false";
	property name="hqlParams" type="struct" persistent="false";
	property name="hqlAliases" type="struct" persistent="false";

	property name="records" type="array" persistent="false";
	property name="pageRecords" type="array" persistent="false";

	property name="keywords" type="string" persistent="false";
	property name="keywordArray" type="array" persistent="false";

	property name="aggregateFilters" type="array" persistent="false";
	property name="postFilterGroups" type="array" singularname="postFilterGroup"  persistent="false" hint="where conditions that are added by the user through the UI, applied in addition to the collectionConfig.";
	property name="postOrderBys" type="array" persistent="false" hint="order bys added by the use in the UI, applied/overried the default collectionConfig order bys";

	property name="pageRecordsStart" persistent="false" type="numeric" hint="This represents the first record to display and it is used in paging.";
	property name="pageRecordsShow" persistent="false" type="numeric" hint="This is the total number of entities to display";
	property name="currentURL" persistent="false" type="string";
	property name="currentPageDeclaration" persistent="false" type="string";

	property name="nonPersistentColumn" type="boolean" persistent="false";
	property name="processContext" type="string" persistent="false";
	property name="processObjects" type="array" persistent="false";
	property name="cacheable" type="boolean" persistent="false";
	property name="cacheName" type="string" persistent="false";
	property name="savedStateID" type="string" persistent="false";
	property name="collectionEntityObject" type="any" persistent="false";
	property name="hasDisplayAggregate" type="boolean" persistent="false";
	property name="hasManyRelationFilter" type="boolean" persistent="false";

	property name="groupBys" type="string" persistent="false";

	//property name="entityNameOptions" persistent="false" hint="an array of name/value structs for the entity's metaData";
	property name="collectionObjectOptions" persistent="false";

	// ============ START: Non-Persistent Property Methods =================
	
	public any function init(){
		super.init();

		param name="session.entityCollection" type="struct" default="#structNew()#";
		param name="session.entityCollection.savedStates" type="array" default="#arrayNew(1)#";

		variables.hqlParams = {};
		variables.hqlAliases = {};
		variables.Cacheable = false;
		variables.CacheName = "";
		variables.currentPageDeclaration = 1;
		variables.pageRecordsStart = 1;
		variables.pageRecordsShow = 10;
		variables.keywords = "";
		variables.keywordArray = [];
		variables.postFilterGroups = [];
		variables.postOrderBys = [];
		variables.aggregateFilters = [];
		variables.collectionConfig = '{}';
		variables.processObjects = [];
		variables.hasDisplayAggregate = false;
		variables.hasManyRelationFilter = false;
		variables.filterAliasMaps = {};
		variables.filterGroupAliasMap = {}; 
	}

	public any function getCollectionEntityObject(){
		if(!structKeyExists(variables,'collectionEntityObject')){
			variables.collectionEntityObject = getService('hibachiService').getEntityObject(getCollectionObject());
		}
		return variables.collectionEntityObject;
	}
	
	public string function getFilterAlias(required string propertyIdentifier){
		var filterAlias = "";
		if(structKeyExists(variables.filterAliasMap,arguments.propertyIdentifier)){
			filterAlias = variables.filterAliasMap[arguments.propertyIdentifier];
		}
		return filterAlias;
	}

	public numeric function getFilterGroupIndexByFilterGroupAlias(required string filterGroupAlias, required string filterGroupLogicalOperator){
 		if(!structKeyExists(variables.filterGroupAliasMap, arguments.filterGroupAlias)){
 			variables.filterGroupAliasMap[filterGroupAlias] = addFilterGroupWithAlias(arguments.filterGroupAlias, arguments.filterGroupLogicalOperator);
 		} 
 		return variables.filterGroupAliasMap[filterGroupAlias]; 
 	} 

 	public numeric function addFilterGroupWithAlias(required string filterGroupAlias, required string filterGroupLogicalOperator){
 		var collectionConfig = this.getCollectionConfigStruct();	
 		var newFilterGroup = {"filterGroup"=[]};
 		if(ArrayLen(collectionConfig.filterGroups) >= 1){
 			newFilterGroup["logicalOperator"] = arguments.filterGroupLogicalOperator; 
 		} 
 		ArrayAppend(collectionConfig.filterGroups, newFilterGroup);
 		this.setCollectionConfigStruct(collectionConfig);
 		return ArrayLen(collectionConfig.filterGroups); 
 	}

	//add Filter
	public void function addFilter(
		required string propertyIdentifier,
		required any value,
		string comparisonOperator="=",
		string logicalOperator="AND",
	    string aggregate="",
		string filterGroupAlias="",
 		string filterGroupLogicalOperator="AND"
	){
		var collectionConfig = this.getCollectionConfigStruct();
		var alias = collectionConfig.baseEntityAlias;

		if(!structKeyExists(collectionConfig,'filterGroups')){
			collectionConfig["filterGroups"] = [{"filterGroup"=[]}];
		}

		var _propertyIdentifier = '';
		var propertyIdentifierParts = ListToArray(arguments.propertyIdentifier, '.');
		var current_object = getService('hibachiService').getPropertiesStructByEntityName(getCollectionObject());

		for (var i = 1; i <= arraylen(propertyIdentifierParts); i++) {
			if(structKeyExists(current_object, propertyIdentifierParts[i]) && structKeyExists(current_object[propertyIdentifierParts[i]], 'cfc')){
				if(structKeyExists(current_object[propertyIdentifierParts[i]], 'singularname')){
					//addGroupBy(alias);
					setHasManyRelationFilter(true);
				}
				current_object = getService('hibachiService').getPropertiesStructByEntityName(current_object[propertyIdentifierParts[i]]['cfc']);
				_propertyIdentifier &= '_' & propertyIdentifierParts[i];
				addJoin({
					'associationName' = RemoveChars(rereplace(_propertyIdentifier, '_([^_]+)$', '.\1' ),1,1),
					'alias' = alias & _propertyIdentifier
				});
			}else{
				_propertyIdentifier &= '.' & propertyIdentifierParts[i];
			}
		}

		//create filter Group
		var filter = {
			"propertyIdentifier" = alias & _propertyIdentifier,
			"comparisonOperator" = arguments.comparisonOperator,
			"value" = arguments.value
		};
		variables.filterAliasMap[arguments.propertyIdentifier] = alias & _propertyIdentifier;
		if(len(aggregate)){
			filter["aggregate"] = aggregate;
		}


		//if we already have a filter group then we need a logicalOperator
		if(arraylen(collectionConfig.filterGroups[1].filterGroup)){
			filter["logicalOperator"]=arguments.logicalOperator;
		}
		//check if the propertyKey is an attribute
		var hasAttribute = getService('hibachiService').getHasAttributeByEntityNameAndPropertyIdentifier(
			entityName=getService('hibachiService').getProperlyCasedFullEntityName(getCollectionObject()),
			propertyIdentifier=arguments.propertyIdentifier
		);
		//if so then add attribute details
		if(!getService('hibachiService').getHasPropertyByEntityNameAndPropertyIdentifier(getCollectionObject(),arguments.propertyIdentifier) && hasAttribute){
			filter['attributeID'] = getService("attributeService").getAttributeByAttributeCode( listLast(arguments.propertyIdentifier,'.')).getAttributeID();
			filter['attributeSetObject'] = getService('hibachiService').getLastEntityNameInPropertyIdentifier(
				entityName=getService('hibachiService').getProperlyCasedFullEntityName(getCollectionObject()),
				propertyIdentifier=arguments.propertyIdentifier
			);
		}

		var filterGroupIndex = 1; 
 		if(len(arguments.filterGroupAlias) > 0){
 			filterGroupIndex = this.getFilterGroupIndexByFilterGroupAlias(arguments.filterGroupAlias, arguments.filterGroupLogicalOperator); 
 		} 
 		arrayAppend(getCollectionConfigStruct().filterGroups[filterGroupIndex].filterGroup,filter);
	}

	public void function setDisplayProperties(string displayPropertiesList=""){
		var collectionConfig = this.getCollectionConfigStruct();
		collectionConfig["columns"] = [];
		this.setCollectionConfigStruct(collectionConfig);
		var displayProperties = listToArray(arguments.displayPropertiesList);
		for(var displayProperty in displayProperties){
			addDisplayProperty(displayProperty.trim());
		}
	}

	public void function addGroupBy(required string groupByAlias){
		var collectionConfig = this.getCollectionConfigStruct();
		if(!structKeyExists(collectionConfig,'groupBys')){
			collectionConfig["groupBys"] = arguments.groupByAlias;
		}
		if(ListContains(collectionConfig.groupBys,arguments.groupByAlias) == 0){
		listAppend(collectionConfig.groupBys,arguments.groupByAlias);
		}
		variables.groupBys = collectionConfig.groupBys;
		this.setCollectionConfigStruct(collectionConfig);
	}

	public void function setDistinct(required boolean isDistinct){
		var collectionConfig = this.getCollectionConfigStruct();
		collectionConfig["isDistinct"] = arguments.isDistinct;
		this.setCollectionConfigStruct(collectionConfig);
	}

	public void function addDisplayProperty(required string displayProperty){
		var collectionConfig = this.getCollectionConfigStruct();

		var column = {
			"propertyIdentifier"=arguments.displayProperty
		};
		if(!structKeyExists(collectionConfig,'columns')){
			collectionConfig["columns"] = [];
		}

		//check if the propertyKey is an attribute
		var hasAttribute = getService('hibachiService').getHasAttributeByEntityNameAndPropertyIdentifier(
			entityName=getService('hibachiService').getProperlyCasedFullEntityName(getCollectionObject()),
			propertyIdentifier=arguments.displayProperty
		);
		//if so then add attribute details
		if(!getService('hibachiService').getHasPropertyByEntityNameAndPropertyIdentifier(getCollectionObject(),arguments.displayProperty) && hasAttribute){
			column['attributeID'] = getService("attributeService").getAttributeByAttributeCode( listLast(arguments.displayProperty,'.')).getAttributeID();
			
			var attributeSetObject = getService('hibachiService').getLastEntityNameInPropertyIdentifier(
				entityName=getService('hibachiService').getProperlyCasedShortEntityName(getCollectionObject()),
				propertyIdentifier=arguments.displayProperty
			);
			column['attributeSetObject'] = lcase(left(attributeSetObject,1))&right(attributeSetObject,len(attributeSetObject)-1);
		}else{
			column['propertyIdentifier'] = collectionConfig.baseEntityAlias & '.' & arguments.displayProperty;
		}

		arrayAppend(collectionConfig.columns,column);
		this.setCollectionConfigStruct(collectionConfig);
	}

	public void function addColumn(required column){
		var collectionConfig = this.getCollectionConfigStruct();
		if(!structKeyExists(collectionConfig,'columns')){
			collectionConfig["columns"] = [];
		}
		arrayAppend(collectionConfig.columns,arguments.column);
		this.setCollectionConfigStruct(collectionConfig);
	}

	//add display Aggregate
	public void function addDisplayAggregate(required string propertyIdentifier, required string aggregateFunction, required string aggregateAlias){
		var collectionConfig = this.getCollectionConfigStruct();
		var alias = collectionConfig.baseEntityAlias;
		var join = {};
		var doJoin = false;
		var collection = arguments.propertyIdentifier;
		var propertyKey = '';

		if(arguments.propertyIdentifier.contains('.')){
			collection = Mid(arguments.propertyIdentifier, 1, arguments.propertyIdentifier.lastIndexOf("."));
			propertyKey = "." & ListLast(arguments.propertyIdentifier, '.');
		}

		var column = {
			"propertyIdentifier" = alias & '.' & arguments.propertyIdentifier,
			"aggregate" = {
				"aggregateFunction" = arguments.aggregateFunction,
				"aggregateAlias" = arguments.aggregateAlias
			}
		};

		var isObject= getService('hibachiService').getPropertyIsObjectByEntityNameAndPropertyIdentifier(
			getService('hibachiService').getProperlyCasedFullEntityName(getCollectionObject()),arguments.propertyIdentifier);

		if(isObject){
			//check if count is on a one-to-many
			var lastEntityName = getService('hibachiService').getLastEntityNameInPropertyIdentifier(getCollectionObject(), arguments.propertyIdentifier);
			var isOneToMany = structKeyExists(getService('hibachiService').getPropertiesStructByEntityName(lastEntityName)[listLast(arguments.propertyIdentifier,'.')],'singularname');

			//if is a one-to-many propertyKey then add a groupby
			if(isOneToMany){
				//need to specify all possible non-aggregate selects and orderbys in groupby


			}

			column['propertyIdentifier'] = BuildPropertyIdentifier(alias, arguments.propertyIdentifier);
			join['associationName'] = arguments.propertyIdentifier;
			join['alias'] = column.propertyIdentifier;
			doJoin = true;
		}else if(propertyKey != ''){
			column['propertyIdentifier'] = BuildPropertyIdentifier(alias, collection)  & propertyKey;
			join['associationName'] = collection;
			join['alias'] = BuildPropertyIdentifier(alias, collection);
			doJoin = true;
		}

		//Add columns
		this.addColumn(column);
		//Do Join if Needed
		if(doJoin) addJoin(join);
	}


	//Build correct PropertyIdentifier Alias
	public string function BuildPropertyIdentifier(required string alias, required string pIdentifier, string joinChar = '_'){
		return arguments.alias & arguments.joinChar & Replace(arguments.pIdentifier, '.', '_', 'All');
	}

	public void function setOrderBy(required string orderByList){
		var orderBys = listToArray(arguments.orderByList);
		for(var orderBy in orderBys){
			addOrderBy(orderBy);
		}
	}

	public void function addOrderBy(required string orderByString){
		var collectionConfig = this.getCollectionConfigStruct();
		if(!structKeyExists(collectionConfig, 'orderBy')){
			collectionConfig["orderBy"] = [];
		}

		var propertyIdentifier = listFirst(arguments.orderByString,'|');
		var direction = 'ASC';
		if(listLen(arguments.orderByString,"|") > 1){
			direction = listLast(arguments.orderByString,'|');	
		}
		

		var orderBy = {
			"propertyIdentifier"=propertyIdentifier,
			"direction"=direction
		};

		arrayAppend(collectionConfig.orderBy,orderBy);
		this.setCollectionConfigStruct(collectionConfig);
	}

	//returns an array of name/value structs for
	public array function getCollectionObjectOptions() {
		if(!structKeyExists(variables, "collectionObjectOptions")) {
			var entitiesMetaData = getService("hibachiService").getEntitiesMetaData();
			var entitiesMetaDataArray = listToArray(structKeyList(entitiesMetaData));
			arraySort(entitiesMetaDataArray,"text");
			variables.collectionObjectOptions = [];
			for(var i=1; i<=arrayLen(entitiesMetaDataArray); i++) {
				//only show what you are authenticated to make
				if(getHibachiScope().authenticateEntity('read', entitiesMetaDataArray[i])){
					arrayAppend(variables.collectionObjectOptions, {name=rbKey('entity.#entitiesMetaDataArray[i]#'), value=entitiesMetaDataArray[i]});
				}
			}
		}
		return variables.collectionObjectOptions;
	}

	public any function setup(required string entityName, struct data={}, numeric pageRecordsStart=1,numeric pageRecordsShow=10, string currentUrl=""){
		//set currentURL from the arguments
		setCurrentUrl(arguments.currentUrl);
		//set paging defaults
		setPageRecordsStart(arguments.pageRecordsStart);
		setPageRecordsShow(arguments.pageRecordsShow);

		setCollectionObject(arguments.entityName);

		if(structKeyExists(arguments,'data')){
			applyData(data=arguments.data);
		}
		return this;
	}
	//TODO parse data to seo based collection configuration
	public void function applyData(required any data){

	}

	public void function setCollectionObject(required string collectionObject, boolean addDefaultColumns=true){
		var HibachiBaseEntity = "";
		HibachiBaseEntity = arguments.collectionObject;

		variables.collectionObject = arguments.collectionObject;
		if(variables.collectionConfig eq '{}' ){
			//get default columns
			var newEntity = getService("hibachiService").getServiceByEntityName(arguments.collectionObject).invokeMethod("new#arguments.collectionObject#");
			var defaultProperties = newEntity.getDefaultCollectionProperties();

			var columnsArray = [];
			//check to see if we are supposed to add default columns
			if(addDefaultColumns){
				//loop through all defaultProperties
				for(var defaultProperty in defaultProperties){
					var columnStruct = {};
					columnStruct['propertyIdentifier'] = '_' & lcase(getService('hibachiService').getProperlyCasedShortEntityName(arguments.collectionObject)) & '.' & defaultProperty.name;
					columnStruct['title'] = newEntity.getPropertyTitle(defaultProperty.name);
					//if propertyKey is a primary id, hide it and make it so it can't be deleted
					if(structKeyExists(defaultProperty,"fieldtype") && defaultProperty.fieldtype == 'id'){
						columnStruct['isDeletable'] = false;
						columnStruct['isVisible'] = false;
					//if propertyKey is a config of json hide it
					}else if(structKeyExists(defaultProperty,"hb_formFieldType") && defaultProperty.hb_formFieldType == 'json'){
						columnStruct['isDeletable'] = true;
						columnStruct['isVisible'] = false;
					}else{
						columnStruct['isDeletable'] = true;
						columnStruct['isVisible'] = true;
					}
					columnStruct['isSearchable'] = true;
					columnStruct['isExportable'] = true;
					if(structKeyExists(defaultProperty,"ormtype")){
						columnStruct['ormtype'] = defaultProperty.ormtype;
					}
					if(structKeyExists(defaultProperty,"fieldtype")){
						columnStruct['ormtype'] = defaultProperty.fieldtype;
					}
                    if(structKeyExists(defaultProperty,"hb_formatType")){
                        columnStruct['ormtype'] = defaultProperty.hb_formatType;
                    }

					arrayAppend(columnsArray,columnStruct);
				}
			}

			var columnsJson = serializeJson(columnsArray);
			variables.collectionConfig = '{
				"baseEntityName":"#HibachiBaseEntity#",
				"baseEntityAlias":"_#lcase(getService('hibachiService').getProperlyCasedShortEntityName(arguments.collectionObject))#",
				"columns":#columnsJson#
			}';
		}
	}

	//ADD FUNCTIONS

	public void function addHQLParam(required string paramKey, required any paramValue) {
		variables.hqlParams[ arguments.paramKey ] = arguments.paramValue;
	}

	public void function addHQLAlias(required string aliasKey, required any aliasValue) {
		variables.hqlAliases[arguments.aliasKey] = arguments.aliasValue;
	}

	//this is used when we get params from another collection that we need to apply to this collection
	private void function addHQLParamsFromNestedCollection(required collectionHQLParams){
		for(var key in arguments.collectionHQLParams){
			addHQLParam(key,arguments.collectionHQLParams[key]);
		}
	}

	//join introspects on itself for nested joins to ensure that all joins are added in the correct order
	private string function addJoinHQL(required string parentAlias, required any join){
		var separator = '.';
		if(find('.', arguments.join.associationName) > 0){
			separator = '_';
		}
		//Alias_
		var fullJoinName = "#parentAlias##separator##arguments.join.associationName#";
		addHQLAlias(fullJoinName,arguments.join.alias);
		var joinHQL = ' left join #fullJoinName# as #arguments.join.alias# ';
		if(!isnull(arguments.join.joins)){
			for(var childJoin in arguments.join.joins){
				joinHQL &= addJoinHQL(join.alias,childJoin);
			}
		}

		return joinHQL;
	}

	private string function addJoin(required any join){
		if(!structKeyExists(getCollectionConfigStruct(),'joins')){
				getCollectionConfigStruct()["joins"] = [];
		}
		var joinFound = false;
		for(var configJoin in getCollectionConfigStruct().joins){
			if(configJoin.alias == arguments.join.alias){
				joinFound = true;
			}
		}
		if(!joinFound){
			ArrayAppend(getCollectionConfigStruct().joins,arguments.join);
		}

	}


	//the post functions are most likely to be called after a user posts to the server in order to update the base query with user chosen filters from the UI list view
	public void function addPostFilterGroup(required any postFilterGroup){
		arrayAppend(variables.postFilterGroups, arguments.postFilterGroup);
	}

	public void function addAggregateFilter(required any aggregateFilter ){
		if(!ArrayContains(variables.aggregateFilters, arguments.aggregateFilter)){
			arrayAppend(variables.aggregateFilters, arguments.aggregateFilter);
		}
	}

	public string function getAggregateFilterHQL(){
		var aggregateFilters = getAggregateFilters();

		var aggregateFilterHQL = '';
		for(var filter in aggregateFilters){
			var logicalOperator = '';
			if(structKeyExists(filter,"logicalOperator") && len(aggregateFilterHQL) > 0){
				logicalOperator = filter.logicalOperator;
			}
			var comparisonOperator = getComparisonOperator(filter.comparisonOperator);
			var predicate = getPredicate(filter);
			aggregateFilterHQL &= " #logicalOperator# #formatAggregateFunction(filter.aggregate)#(#filter.propertyIdentifier#) #comparisonOperator# #predicate# ";
		}
		return aggregateFilterHQL;
	}

	private boolean function hasAggregateFilter(){
		return (arraylen(getAggregateFilters()) > 0);
	}

	private string function formatAggregateFunction(aggregate){
		var aggregateFunction = '';
		switch(LCASE(aggregate)){
			case "average":
				aggregateFunction = 'avg';
				break;
			case "min":
			case "max":
			case "avg":
			case "sum":
			case "count":
				aggregateFunction = LCASE(aggregate);
				break;
		}
		return aggregateFunction;
	}


	public array function getKeywordArray(){
		if(!arraylen(variables.keywordArray)){
			variables.keywordArray = ListToArray(getKeywords(),' ');
		}
		return variables.keywordArray;
	}

	public void function addPostOrderBy(required any postOrderBy){
		arrayAppend(variables.postOrderBys, arguments.postOrderBy);
	}

	//GETTER FUNCTIONS
	//limiting return values to prevent ORM injection
	private string function getAggregateHQL(required any aggregate, required string propertyIdentifier){
		setHasDisplayAggregate(true);
		var aggregateFunction = '';
		switch(arguments.aggregate.aggregateFunction){

			case "count":
				aggregateFunction = "COUNT";
			break;
			case "avg":
				aggregateFunction = "AVG";
			break;
			case "sum":
				aggregateFunction = "SUM";
			break;
			case "min":
				aggregateFunction = "MIN";
			break;
			case "max":
				aggregateFunction = "MAX";
			break;
		}

		var distinct = (aggregateFunction == 'COUNT') ? 'DISTINCT':'';
		return " #aggregateFunction#(#distinct# #arguments.propertyIdentifier#) as #arguments.aggregate.aggregateAlias#";

	}

	public any function getCacheName() {
		// Take the stateStruct, serialize it, and turn that list it into a an array
		var valueArray = listToArray(serializeJSON(getStateStruct()));

		// Sort the array so that the values always end up the same
		arraySort(valueArray,"text");

		// Turn the array back into a list, lcase, and hash for the name
		return hash(lcase(arrayToList(valueArray,",")));
	}

	//restrict allowed operators to prevent sql injection
	private string function getComparisonOperator(required string comparisonOperator){

		switch(arguments.comparisonOperator){
			case "=":
				return "=";
			break;
			case "!=":
				return "!=";
			break;
			case "<>":
				return "<>";
			break;
			case ">":
				return ">";
			break;
			case "<":
				return "<";
			break;
			case "<=":
				return "<=";
			break;
			case ">=":
				return ">=";
			break;
			case "like":
				return "LIKE";
			break;
			case "not like":
				return "NOT LIKE";
			break;
			case "in":
				return "IN";
			break;
			case "not in":
				return "NOT IN";
			break;
			case "between":
				return "BETWEEN";
			break;
			case "not between":
				return "NOT BETWEEN";
			break;
			//reserved for is null/is not null where value is null in json
			case "is":
				return "IS";
			break;
			case "is not":
				return "IS NOT";
			break;
		}
		return '';
	}



	private string function getFilterCriteria(required string filterCriteria){
		switch(arguments.filterCriteria){
			case "One":
				return "EXISTS";
			break;
			case "All":
			case "None":
				return "NOT EXISTS";
			break;
		}
	}


	public any function mergeCollectionFilter(required any baseCollection, required any currentCollection) {
		var totalFilterGroups = arrayLen(currentCollection);
		for(var i =1; i <= totalFilterGroups; i++){
			if(!ArrayIsDefined(baseCollection, i)){
				baseCollection[i] = { "filterGroup" = []};
			}
			if(arraylen(baseCollection[i].filterGroup) && arraylen(currentCollection[i].filterGroup)){
				currentCollection[i].filterGroup[1].logicalOperator = 'AND';
			}
			for(var filter in currentCollection[i].filterGroup){
				ArrayAppend(baseCollection[i].filterGroup,filter);	
			}
		}
		return baseCollection;
	}

	public void function mergeJoins(required any baseJoins){
		var currentCollection = getCollectionConfigStruct();
		if(isNull(currentCollection.joins) || !arraylen(currentCollection.joins)){
			currentCollection.joins = baseJoins;
			return;
		}
		for(var i = 1; i <= arraylen(baseJoins); i++) {
			var isFound = false;
			for (var j = 1; j <= arraylen(currentCollection.joins); j++) {
				if (currentCollection.joins[j]['associationName'] == baseJoins[i]['associationName']) {
					isFound = true;
					break;
				}
			}
			if (!isFound) {
				arrayAppend(currentCollection.joins, baseJoins[i]);
			}
		}
	}

	public array function getFilterGroupArrayFromAncestors(required any collectionEntity){
		var collectionConfig = arguments.collectionEntity.getCollectionConfigStruct();
		var filterGroupArray = [];
		if(!isnull(collectionConfig.filterGroups) && arraylen(collectionConfig.filterGroups)){
			filterGroupArray = collectionConfig.filterGroups;
		}

		if(!isnull(arguments.collectionEntity.getParentCollection())){
			var parentCollectionStruct = arguments.collectionEntity.getParentCollection().getCollectionConfigStruct();
			if (!isnull(parentCollectionStruct.filterGroups) && arraylen(parentCollectionStruct.filterGroups)) {
				filterGroupArray = mergeCollectionFilter(parentCollectionStruct.filterGroups, filterGroupArray);
				if(structKeyExists(parentCollectionStruct, 'joins')){
					mergeJoins(parentCollectionStruct.joins);
				}
			}
		}
		return filterGroupArray;
	}
	
	public void function removeFilter(
		string propertyIdentifier,
		any value,
		string comparisonOperator="=",
		string logicalOperator,
		array filterGroup
	) {
		//first do we have filters?
		if(arraylen(collectionConfigStruct.filterGroups)){
			//filterGroupName is used to navigate a filtergroup path. If not specified we can assume there is only the base filterGroup.
			var selectedFilterGroup = [];
			if(!structKeyExists(arguments,'filterGroup')){
				selectedFilterGroup = getCollectionConfigStruct().filterGroups[1].filterGroup;
			}
			var filterGroupCount = arraylen(selectedFilterGroup);
			for(var i=filterGroupCount; i >= 1; i--){
				var filter = selectedFilterGroup[i];
				var isRemovable = true;
				if(structKeyExists(arguments,'propertyIdentifier')){
					
					if(filter.propertyIdentifier != getFilterAlias(arguments.propertyIdentifier)){
						isRemovable = false;
					}
				}				
				if(filter.comparisonOperator != arguments.comparisonOperator){
					isRemovable = false;
				}
				if(structKeyExists(arguments,'logicalOperator')){
					if(filter.logicalOperator != arguments.logicalOperator){
						isRemovable = false;
					}
				}
				if(structKeyExists(arguments,'value')){
					if(filter.value != arguments.value){
						isRemovable = false;
					}
				}
				if(isRemovable){
					arrayDeleteAt(selectedFilterGroup,i);
					if(arrayLen(selectedFilterGroup)){
						if(structKeyExists(selectedFilterGroup[1],'logicalOperator')){
							structDelete(selectedFilterGroup[1],'logicalOperator');	
						}
					}
				}
				if(!structKeyExists(arguments,'filterGroup')){
					getCollectionConfigStruct().filterGroups[1].filterGroup = selectedFilterGroup;
				}
			}
		}
	}
	

	private string function getFilterGroupHQL(required array filterGroup){
		var filterGroupHQL = '';
		var isFirstFilter = true;
		for(var filter in arguments.filterGroup){
			//add propertyKey and value to HQLParams
			//if using a like parameter we need to add % to the value using angular
			var logicalOperator = '';
			if(structKeyExists(filter,"logicalOperator") && len(filter.logicalOperator) && !isFirstFilter){
				logicalOperator = filter.logicalOperator;
			}
			if(!isnull(filter.collectionID) || !isNull(filter.collection)){
				filterGroupHQL &=  " #logicalOperator# #getHQLForCollectionFilter(filter)# ";
			}else {

				//check filter is a nested filterGroup or a filter itself
				if (structKeyExists(filter, "filterGroup")) {

					filterGroupHQL &= getFilterGroupsHQL([filter]);
				} else {
					
					if(structKeyExists(filter,'comparisonOperator') && len(filter.comparisonOperator)){
						var comparisonOperator = getComparisonOperator(filter.comparisonOperator);


						if (structKeyExists(filter, 'aggregate') && isnull(filter.attributeID)){
							addAggregateFilter(filter);
							continue;
						}
	
						var predicate = getPredicate(filter);
						if(isnull(filter.attributeID)){
							if(structKeyExists(filter,'propertyIdentifier') && len(filter.propertyIdentifier)){
								var propertyIdentifier = filter.propertyIdentifier;
								if(ListFind('<>,!=,NOT IN,NOT LIKE',comparisonOperator) > 0){
									propertyIdentifier = "COALESCE(#propertyIdentifier#,'')";
								}
								filterGroupHQL &= " #logicalOperator# #propertyIdentifier# #comparisonOperator# #predicate# ";
							}
						}else{
							var attributeHQL = getFilterAttributeHQL(filter);
							filterGroupHQL &= " #logicalOperator# #attributeHQL# #comparisonOperator# #predicate# ";
						}
					}
					
				}

			}
			isFirstFilter = false;
		}

		return filterGroupHQL;
	}

	private string function getFilterAttributeHQL(required any filter){
		var attributeIdentifier = listDeleteAt(filter.propertyIdentifier,ListLen(filter.propertyIdentifier,'.'),'.');

		var HQL = "COALESCE(
						(SELECT attributeValue
						FROM #getDao('hibachiDAO').getApplicationKey()#AttributeValue
						WHERE attributeID = '#filter.attributeID#'
						AND #filter.attributeSetObject#.#filter.attributeSetObject#ID = #attributeIdentifier#.#filter.attributeSetObject#ID
						),(
							SELECT defaultValue 
							FROM #getDao('hibachiDAO').getApplicationKey()#Attribute 
							WHERE attributeID = '"& filter.attributeID &"'
						)
					)";
		return HQL;
	}

	private string function getFilterGroupsHQL(required array filterGroups){
		var filterGroupsHQL = '';
		for(var filterGroup in arguments.FilterGroups){
			var logicalOperator = '';

			if(structKeyExists(filterGroup,'logicalOperator')){
				logicalOperator = getLogicalOperator(filterGroup.logicalOperator);
			}
			//constuct HQL to be used in filterGroup
			var filterGroupHQL = getFilterGroupHQL(filterGroup.filterGroup);
			if(len(filterGroupHQL)){
				filterGroupsHQL &= " #logicalOperator# (#filterGroupHQL#)";
			}
		}
		return filterGroupsHQL;
	}

	private string function getFilterHQL(required array filterGroups){
		//make the item without a logical operator first
		var filterHQL = '';

		var filterGroupsHQL = getFilterGroupsHQL(arguments.filterGroups);
		if(len(filterGroupsHQL)){
			filterHQL &= ' where ';
			filterHQL &= filterGroupsHQL;
		}
		return filterHQL;
	}

	private string function getFromHQL(required string baseEntityName, required string baseEntityAlias, required any joins){
		var hibachiBaseEntityName = '';
		if(find(getDao('HibachiDao').getApplicationKey(),arguments.baseEntityName)){
			hibachiBaseEntityName = arguments.baseEntityName;
		}else{
			hibachiBaseEntityName = getService('hibachiService').getProperlyCasedFullEntityName(arguments.baseEntityName);
		}

		var fromHQL = ' FROM #hibachiBaseEntityName# as #arguments.baseEntityAlias#';
		addHQLAlias(arguments.baseEntityName,arguments.baseEntityAlias);
		for(var join in arguments.joins){
			fromHQL &= addJoinHQL(arguments.baseEntityAlias,join);
		}

		return fromHQL;
	}

	public string function getHQL(boolean excludeSelectAndOrderBy = false, forExport=false, removeOrderBy = false){
		variables.HQLParams = {};
		variables.postFilterGroups = [];
		variables.postOrderBys = [];
		var HQL = createHQLFromCollectionObject(this, arguments.excludeSelectAndOrderBy, arguments.forExport, arguments.removeOrderBy);
		return HQL;
	}

	public void function addCollectionFilter(
		required string propertyIdentifier,
		required any collectionEntity,
		string criteria="One",
		string logicalOperator="AND"
	){
		var collectionConfig = this.getCollectionConfigStruct();
		var alias = collectionConfig.baseEntityAlias;
		var join = {};
		var doJoin = false;

		if(!structKeyExists(collectionConfig,'filterGroups')){
			collectionConfig["filterGroups"] = [{"filterGroup"=[]}];
		}

		var collection = arguments.propertyIdentifier;
		var propertyKey = '';

		if(arguments.propertyIdentifier.contains('.')){
			collection = Mid(arguments.propertyIdentifier, 1, arguments.propertyIdentifier.lastIndexOf("."));
			propertyKey = "." & ListLast(arguments.propertyIdentifier, '.');
		}


		//create filter Group
		var filterGroup = {
			"propertyIdentifier" = alias & '.' & arguments.propertyIdentifier,
			"criteria" = arguments.criteria,
			"collection" = arguments.collectionEntity
		};

		var isObject= getService('hibachiService').getPropertyIsObjectByEntityNameAndPropertyIdentifier(
				getService('hibachiService').getProperlyCasedFullEntityName(getCollectionObject()),arguments.propertyIdentifier
			);

		if(isObject){
			join['associationName'] = arguments.propertyIdentifier;
			join['alias'] = BuildPropertyIdentifier(alias, arguments.propertyIdentifier);
			doJoin = true;
		}else if(propertyKey != ''){
			join['associationName'] = collection;
			join['alias'] = BuildPropertyIdentifier(alias, collection);
			doJoin = true;
		}


		//if we already have a filter group then we need a logicalOperator
		if(arraylen(collectionConfig.filterGroups[1].filterGroup)){
			filterGroup["logicalOperator"]=arguments.logicalOperator;
		}

		arrayAppend(collectionConfig.filterGroups[1].filterGroup,filterGroup);
		if(doJoin) addJoin(join);
	}

	private string function getHQLForCollectionFilter(required struct filter){

		var collectionFilterHQL = '';
		var filterCriteria = getfilterCriteria(arguments.filter.criteria);
		collectionFilterHQL &= ' #filterCriteria# (';
		//check if we have a transient collection
		if(structKeyExists(arguments.filter,'collection')){
			var collectionEntity = arguments.filter.collection;
		}
		//check if we have a persistent collection
		if(structKeyExists(arguments.filter,'collectionID')){
			var collectionEntity = getService('hibachiCollectionService').getCollectionByCollectionID(arguments.filter.collectionID);
		}

		var mainCollectionAlias = arguments.filter.propertyIdentifier;

		//defaults befor processing criteria
		var collectionHQL = collectionEntity.getHQL(true);
		var hasWhereClause = Find('where',collectionHQL);
		var predicate = 'AND';
		if(!hasWhereClause){
			predicate = 'WHERE';
		}
		var logicalComparator = '';
		if(arguments.filter.criteria == 'None' || arguments.filter.criteria == 'One'){
			var logicalComparator = 'IN ';
		}else if(arguments.filter.criteria == 'All'){
			var logicalComparator = 'NOT IN ';
		}

		collectionFilterHQL &= ' #rereplace(collectionEntity.getHQL(true),'\b\_','__',"ALL")# #predicate# #replace(collectionEntity.getCollectionConfigStruct().baseEntityAlias,'_','__','ALL')# #logicalComparator# elements(#maincollectionAlias#) ';

		//add all params from subqueries to parent HQL
		addHQLParamsFromNestedCollection(collectionEntity.getHQLParams());

		collectionFilterHQL &= ')';

		return collectionFilterHQL;
	}

	private string function getLogicalOperator(required string logicalOperator){
		switch(arguments.logicalOperator){
			case "or":
				return "OR";
			break;
			case "and":
				return "AND";
			break;
		}
		return 'AND';
	}

	private string function getGroupByHQL(string groupBys=""){
		var groupByList = '';
		var groupBysArray = listToArray(arguments.groupBys);
		var groupByCount = arrayLen(groupBysArray);
		if(groupByCount){
			var collectionConfig = getCollectionConfigStruct();
			if(structKeyExists(collectionConfig, 'columns') && arraylen(collectionConfig.columns) > 0) {
				for (var i = 1; i <= arraylen(collectionConfig.columns); i++) {
					if (structKeyExists(collectionConfig.columns[i], 'aggregate')
						|| structKeyExists(collectionConfig.columns[i], 'attributeID')
						|| ListFindNoCase(groupByList, collectionConfig.columns[i].propertyIdentifier) > 0
					) continue;

					groupByList = listAppend(groupByList, collectionConfig.columns[i].propertyIdentifier);
				}
			}
			if(structKeyExists(collectionConfig, 'orderBy') && arraylen(collectionConfig.orderBy) > 0){
				for (var j = 1; j <= arraylen(collectionConfig.orderBy); j++) {
					if (ListFindNoCase(groupByList, collectionConfig.orderBy[j].propertyIdentifier) > 0) continue;
					groupByList = listAppend(groupByList, collectionConfig.orderBy[j].propertyIdentifier);
				}
			}else{
				var orderBy = getDefaultOrderBy();
				groupByList = listAppend(groupByList,orderBy.propertyIdentifier);
			}
		}
		variables.groupBys = groupByList;
		return ' GROUP BY ' & groupByList;
	}

	private struct function getDefaultOrderBy(){
		var orderByStruct={};
		var baseEntityObject = getService('hibachiService').getEntityObject( getCollectionObject() );
		//is default order by based on hb_defaultOrderProperty
		if(structKeyExists(baseEntityObject.getThisMetaData(), "hb_defaultOrderProperty")) {
			orderByStruct={
				propertyIdentifier='_' & lcase(getService('hibachiService').getProperlyCasedShortEntityName(getCollectionObject())) & '.' & baseEntityObject.getThisMetaData()["hb_defaultOrderProperty"],
				direction="asc"
			};
		//if not then does it have a createdDateTime
		} else if ( baseEntityObject.hasProperty( "createdDateTime" ) ) {
			var orderByStruct={
				propertyIdentifier='_' & lcase(getService('hibachiService').getProperlyCasedShortEntityName(getCollectionObject())) & '.' & "createdDateTime",
				direction="desc"
			};
		//if still not then order by primary id
		} else {
			var orderByStruct={
				propertyIdentifier='_' & lcase(getService('hibachiService').getProperlyCasedShortEntityName(getCollectionObject())) & '.' & baseEntityObject.getPrimaryIDPropertyName(),
				direction="asc"
			};
		}
		return orderByStruct;
	}

	private string function getOrderByHQL(array orderBy=[]){
		var orderByHQL = ' ORDER BY ';

		var orderByCount = arraylen(arguments.orderBy);
		//if order by count is 0, then use the default order by
		if(orderByCount == 0){
			arrayAppend(arguments.orderby,getDefaultOrderBy());
			orderByCount++;
		}

		for(var i = 1; i <= orderByCount; i++){
			var ordering = arguments.orderBy[i];
			var direction = '';
			if(!isnull(ordering.direction)){
				direction = ordering.direction;
			}

			orderByHQL &= '#ordering.propertyIdentifier# #direction# ';

			//check whether a comma is needed
			if(i != orderByCount){
				orderByHQL &= ',';
			}
		}
		return orderByHQL;
	}

	public any function getNonPersistentColumn(){

		if( !structKeyExists(variables,'nonPersistentColumn') && isNull(variables.nonPersistentColumn)) {
			variables.nonPersistentColumn = false;
			if(structKeyExists(this.getCollectionConfigStruct(),'columns')){
				for(var column in this.getCollectionConfigStruct().columns){
					if(structKeyExists(column,'persistent') && column.persistent == false){
						variables.nonPersistentColumn = true;
						break;
					}
				}
			}
		}
		return variables.nonPersistentColumn;
	}

	// Paging Methods
	public array function getPageRecords(boolean refresh=false, formatRecords=true) {

		if(arguments.formatRecords){
			var formattedRecords = getService('hibachiCollectionService').getAPIResponseForCollection(this,{},false).pageRecords;

			variables.pageRecords =	formattedRecords;
		}else{
			try{
				var HQL = '';
				var HQLParams = {};
				if( !structKeyExists(variables, "pageRecords") || arguments.refresh eq true) {
					saveState();
					if(this.getNonPersistentColumn() || (!isNull(this.getProcessContext()) && len(this.getProcessContext()))){
						//prepare page records and possible process objects
						variables.pageRecords = [];
						variables.processObjects = [];
						HQL = 'SELECT _#lcase(this.getCollectionObject())# ' & getHQL();
						HQLParams = getHQLParams();
						var entities = ormExecuteQuery(HQL, HQLParams, false, {offset=getPageRecordsStart()-1, maxresults=getPageRecordsShow(), ignoreCase="true", cacheable=getCacheable(), cachename="pageRecords-#getCacheName()#"});
						var columns = getCollectionConfigStruct()["columns"];

						for(var entity in entities){
							var pageRecord = {};
							for(var column in columns){
								var listRest = ListRest(column.propertyIdentifier,'.');
								if(structKeyExists(column,'setting') && column.setting == true){
									var listRest = ListRest(column.propertyIdentifier,'.');
									pageRecord[Replace(listRest(column.propertyIdentifier,'.'),'.','_','all')] = getSettingValueFormattedByPropertyIdentifier(listRest,entity);
								}else{
									pageRecord[Replace(listRest(column.propertyIdentifier,'.'),'.','_','all')] = entity.getValueByPropertyIdentifier(listRest);
								}
							}
							arrayAppend(variables.pageRecords,pageRecord);

							if(len(this.getProcessContext()) && entity.hasProcessObject(this.getProcessContext())){
								var processObject = entity.getProcessObject(this.getProcessContext());
								arrayAppend(variables.processObjects,processObject);
							}

						}
					}else{
						HQL = getHQL();
						HQLParams = getHQLParams();
						variables.pageRecords = ormExecuteQuery(HQL, HQLParams, false, {offset=getPageRecordsStart()-1, maxresults=getPageRecordsShow(), ignoreCase="true", cacheable=getCacheable(), cachename="pageRecords-#getCacheName()#"});
					}
				}
			}
			catch(any e){
				variables.pageRecords = [{'failedCollection'='failedCollection'}];
				writelog(file="collection",text="Error:#e.message#");
				writelog(file="collection",text="HQL:#HQL#");
			}

		}
		return variables.pageRecords;
	}

	public void function clearRecordsCount() {
		structDelete(variables, "recordsCount");
	}

	public any function getSettingValueFormattedByPropertyIdentifier(required string propertyIdentifier, required any entity){
		if(listLen(arguments.propertyIdentifier) == 1){
			return entity.getSettingValue(arguments.propertyIdentifier);
		}else{
			var settingName = listLast(arguments.propertyIdentifier);
			var arguments.propertyIdentifier = listDeleteAt(arguments.propertyIdentifier,listLen(arguments.propertyIdentifier));
			var relatedObject = entity.getValueByPropertyIdentifier(arguments.propertyIdentifier);
			return relatedObject.getSettingValue(settingName);
		}
	}

	public array function getRecords(boolean refresh=false, boolean forExport=false, boolean formatRecords=true) {
		if(arguments.formatRecords){
			var formattedRecords = getService('hibachiCollectionService').getAPIResponseForCollection(this,{allRecords=true},false).records;

			variables.records =	formattedRecords;
		}else{
			try{
				//If we are returning only the exportable records, then check and pass through.
				var HQL = '';
				var HQLParams = {};
				if( !structKeyExists(variables, "records") || arguments.refresh == true) {
					if(this.getNonPersistentColumn()){
						variables.records = [];
						HQL =  'SELECT _#lcase(this.getCollectionObject())# ' &  getHQL(forExport=arguments.forExport);
						HQLParams = getHQLParams();
						var entities = ormExecuteQuery(HQL,HQLParams, false, {ignoreCase="true", cacheable=getCacheable(), cachename="records-#getCacheName()#"});
						var columns = getCollectionConfigStruct()["columns"];
						for(var entity in entities){
							var record = {};

							for(var column in columns){

								var listRestValue = ListRest(column.propertyIdentifier,'.');
								if(structKeyExists(column,'setting') && column.setting == true){
									record[Replace(listRestValue,'.','_','all')] = getSettingValueFormattedByPropertyIdentifier(listRestValue,entity);
								}else{
									record[Replace(listRestValue,'.','_','all')] = entity.getValueByPropertyIdentifier(listRestValue);
								}//<--end if

							}//<--end for
							arrayAppend(variables.records,record);
						}//<--end entity
					}else{
						HQL = getHQL(forExport=arguments.forExport);
						HQLParams = getHQLParams();
						variables.records = ormExecuteQuery(HQL,HQLParams, false, {ignoreCase="true", cacheable=getCacheable(), cachename="records-#getCacheName()#"});
						if(!structKeyExists(variables, "recordsCount")) {
							variables.recordsCount = arrayLen(variables.records);
						}
					}
				}
			}
			catch(any e){
				variables.records = [{'failedCollection'='failedCollection'}];
				writelog(file="collection",text="Error:#e.message#");
				writelog(file="collection",text="HQL:#HQL#");
			}
		}

		return variables.records;
	}

	public any function getRecordsCount() {
		if(!structKeyExists(variables, "recordsCount")) {
			if(getCacheable() && structKeyExists(application.entityCollection, getCacheName()) && structKeyExists(application.entityCollection[getCacheName()], "recordsCount")) {
				variables.recordsCount = application.entityCollection[ getCacheName() ].recordsCount;
			} else {
				if(!structKeyExists(variables,"records")) {
					var HQL = '';
					if(hasAggregateFilter() || !isNull(variables.groupBys)){
						HQL = 'SELECT COUNT(DISTINCT tempAlias.id) FROM  #getService('hibachiService').getProperlyCasedFullEntityName(getCollectionObject())# tempAlias WHERE tempAlias.id IN ( SELECT MIN(#getCollectionConfigStruct().baseEntityAlias#.id) #getHQL(true, false, true)# )';
					}else{
						HQL = getSelectionCountHQL() & getHQL(true);
					}
					var recordCount = ormExecuteQuery(HQL, getHQLParams(), true, {ignoreCase="true"});
					if(isNull(recordCount)){
						recordCount = 0;
					}
					variables.recordsCount = recordCount;
					if(getCacheable()) {
						application.entityCollection[ getCacheName() ] = {};
						application.entityCollection[ getCacheName() ].recordsCount = variables.recordsCount;
					}
				} else {
					variables.recordsCount = arrayLen(getRecords());
				}
			}
		}

		return variables.recordsCount;
	}

	public any function getPrimaryIDs(){
		var baseEntityObject = getService('hibachiService').getEntityObject( getCollectionObject() );
		this.getCollectionConfigStruct().columns = [{
			"ormtype" = "id",
			"title" = "id",
			"propertyIdentifier" = "_#lcase(getService('hibachiService').getProperlyCasedShortEntityName(getCollectionObject()))#.#baseEntityObject.getPrimaryIDPropertyName()#"
		}];
		return getRecords(formatRecords=false);
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

	private string function getParamID(){
		var uuidComponent = createobject("java", "java.util.UUID");
		var uuid = removeCharacters(uuidComponent.randomUUID().toString());
		return 'P' & uuid;
	}

	private string function getPredicate(required any filter){
		var predicate = '';
		if(!structKeyExists(filter,"value")){
			filter.value = "";
		}
		//verify we are handling a range value
		if(arguments.filter.comparisonOperator eq 'between' || arguments.filter.comparisonOperator eq 'not between'){
			if(arguments.filter.ormtype eq 'timestamp'){

				if(structKeyExists(arguments.filter, 'measureCriteria') && arguments.filter.measureCriteria == 'exactDate' && structKeyExists(arguments.filter, 'measureType')) {

					switch (arguments.filter.measureType) {
						case 'd':
							var currentdatetime = DateAdd('d', - arguments.filter.criteriaNumberOf, now());
							var fromValue = CreateDateTime(year(currentdatetime), month(currentdatetime), day(currentdatetime), 0, 0, 0);
							var toValue = CreateDateTime(year(currentdatetime), month(currentdatetime), day(currentdatetime), 23, 59, 59);
							break;
						case 'm':
							var currentdatetime = DateAdd('m', - arguments.filter.criteriaNumberOf, now());
							var fromValue = CreateDateTime(year(currentdatetime), month(currentdatetime), 1, 0, 0, 0);
							var toValue = CreateDateTime(year(currentdatetime), month(currentdatetime), DaysInMonth(currentdatetime), 23, 59, 59);
							break;
						case 'y':
							var currentdatetime = DateAdd('yyyy', - arguments.filter.criteriaNumberOf, now());
							var fromValue = CreateDateTime(year(currentdatetime), 1, 1, 0, 0, 0);
							var toValue = CreateDateTime(year(currentdatetime), 12, 31, 23, 59, 59);
							break;
					}

				}else if(listLen(arguments.filter.value,'-') > 1){
					//convert unix timestamp
					var fromDate = DateAdd("s", listFirst(arguments.filter.value,'-')/1000, "January 1 1970 00:00:00");
					var fromValue = dateFormat(fromDate,"yyyy-mm-dd") & " " & timeFormat(fromDate, "HH:MM:SS");
					var toDate = DateAdd("s", listLast(arguments.filter.value,'-')/1000, "January 1 1970 00:00:00");
					var toValue = dateFormat(toDate,"yyyy-mm-dd") & " " & timeFormat(toDate, "HH:MM:SS");
				}else{
					//if list length is 1 then we treat it as a date range From Now() - Days to Now()
					var fromValue = DateAdd("d",-arguments.filter.value,Now());
					var toValue = Now();
				}

				var fromParamID = getParamID();
				addHQLParam(fromParamID, fromValue);
				var toParamID = getParamID();
				addHQLParam(toParamID, toValue);

				predicate = ":#fromParamID# AND :#toParamID#";

			}else if(listFind('integer,float,big_decimal',arguments.filter.ormtype)){
				var fromValue = listFirst(arguments.filter.value,'-');
				var toValue = listLast(arguments.filter.value,'-');
				var fromParamID = getParamID();
				addHQLParam(fromParamID,fromValue);
				var toParamID = getParamID();
				addHQLParam(toParamID,toValue);

				predicate = ":#fromParamID# AND :#toParamID#";
			}


		}else if(arguments.filter.comparisonOperator eq 'is' || arguments.filter.comparisonOperator eq 'is not'){
			predicate = filter.value;
		}else if(arguments.filter.comparisonOperator eq 'in' || arguments.filter.comparisonOperator eq 'not in'){
			if(len(filter.value)){
				predicate = "(" & ListQualify(filter.value,"'") & ")";
			}else{
				predicate = "('')";
			}
		}else if(arguments.filter.comparisonOperator eq 'like' || arguments.filter.comparisonOperator eq 'not like'){
			var paramID = getParamID();

			if(structKeyExists(filter,'pattern')){
				switch(filter.pattern){
					case '%w%':
						filter.value = '%#filter.value#%';
						break;
					case 'w%':
						filter.value = '#filter.value#%';
						break;
					case '%w':
						filter.value = '%#filter.value#';
						break;
				}
			}
			addHQLParam(paramID,arguments.filter.value);
			predicate = ":#paramID#";
		}else{
			var paramID = getParamID();

			addHQLParam(paramID,arguments.filter.value);
			predicate = ":#paramID#";
		}
		return predicate;
	}

	private any function getColumnAttributeHQL(required struct column){
		
		var attributeIdentifier = getCollectionConfigStruct().baseEntityAlias;
		var HQL	=  "COALESCE(
						(SELECT 
							attributeValue
						
						FROM #getDao('hibachiDAO').getApplicationKey()#AttributeValue
						WHERE attribute.attributeID = '"
						& column.attributeID &
						"' AND #column.attributeSetObject#.#column.attributeSetObject#ID = #attributeIdentifier#.#column.attributeSetObject#ID)
						,(
							SELECT defaultValue 
							FROM #getDao('hibachiDAO').getApplicationKey()#Attribute 
							WHERE attributeID = '"& column.attributeID &"'
						)
					) as #listLast(column.propertyIdentifier,'.')#";
		return HQL;
	}

	private any function getColumnCountByExportableColumns(required array columns){
		var count = 0;
		for(var column in arguments.columns){
			if(structKeyExists(column,'isExportable') && column.isExportable){
				count++;
			}
		}
		return count;
	}

	private any function getSelectionCountHQL(){
		return 'SELECT COUNT(DISTINCT #getCollectionConfigStruct().baseEntityAlias#.id) ';
	}

	public string function getColumnAlias(required struct column){
		if(structKeyExists(column,'attributeID')){
			return listLast(column.propertyIdentifier,'.');
		}else{
			if(structKeyExists(column,'aggregate')){
				return arguments.aggregate.aggregateAlias;
			}else{
				var currentAlias = '';
				var currentAliasStepped = '';
				var columnPropertyIdentiferArray = listToArray(arguments.column.propertyIdentifier,'.');
				var columnPropertyIdentiferArrayCount = arrayLen(columnPropertyIdentiferArray);
		
				for(var j = 1; j <= columnPropertyIdentiferArrayCount;j++){
					if(columnPropertyIdentiferArrayCount > 2){
						if(j != 1 && j != columnPropertyIdentiferArrayCount){
							var dotNeeded = '';
							if(j >= 3){
								dotNeeded = '.';
							}
		
							var join = {
									associationName=currentAliasStepped&dotNeeded&columnPropertyIdentiferArray[j],
									alias=currentAlias&'_'&columnPropertyIdentiferArray[j]
							};
		
		
							currentAlias = currentAlias&'_'&columnPropertyIdentiferArray[j];
							currentAliasStepped = currentAliasStepped &dotNeeded& columnPropertyIdentiferArray[j];
		
							addJoin(join);
		
						}
						if(j == columnPropertyIdentiferArrayCount){
							arguments.column.propertyIdentifier = currentAlias&'.'&columnPropertyIdentiferArray[j];
		
						}
					}
					if(!len(currentAlias)){
						currentAlias = columnPropertyIdentiferArray[1];
					}
				}
				return Replace(Replace(arguments.column.propertyIdentifier,'.','_','all'),'_'&lcase(Replace(getCollectionObject(),'#getDao('hibachiDAO').getApplicationKey()#',''))&'_','');
			}
		} 
					
	}

	private any function getSelectionsHQL(required array columns, boolean isDistinct=false, boolean forExport=false){
		var isDistinctValue = '';
		if(arguments.isDistinct){
			isDistinctValue = "DISTINCT";
		}
		var HQL = '';
		var selectHQL = 'SELECT #isDistinctValue#';
		var columnCount = 0;
		if(arguments.forExport){
			columnCount = getColumnCountByExportableColumns(arguments.columns);
		}else{
			columnCount = arraylen(arguments.columns);
		}

 
		var startMapHQL = ' new Map(';
		var columnsHQL = '';
		for(var i = 1; i <= columnCount; i++){
			var column = arguments.columns[i];
			if(!arguments.forExport || (arguments.forExport && structKeyExists(column,'isExportable') && column.isExportable)){
				if(structKeyExists(column,'attributeID')){
					columnsHQL &= getColumnAttributeHQL(column);
				}else{
					//check if we have an aggregate
					if(!isNull(column.aggregate))
					{
						//if we have an aggregate then put wrap the identifier
						if(structKeyExists(column,'propertyIdentifier') && len(column.propertyIdentifier)){
							columnsHQL &= getAggregateHQL(column.aggregate,column.propertyIdentifier);
						}
						if( ( !structKeyExists(variables, "groupByRequired") || !variables.groupByRequired ) &&
							  structKeyExists(column.aggregate, "aggregateFunction") &&
						   ( column.aggregate.aggregateFunction == 'min' ||
							 column.aggregate.aggregateFunction == 'max' )
						){
							variables.groupByRequired = false;
							variables.orderByRequired = false;
						} else {
							variables.groupByRequired = true;
							variables.orderByRequired = true;
						}
					}else{
						variables.groupByRequired = true;
						variables.orderByRequired = true;
						var columnAlias = getColumnAlias(column);
						columnsHQL &= ' #column.propertyIdentifier# as #columnAlias#';
					}
				}

				//check whether a comma is needed
				if(i != columnCount){
					columnsHQL &= ',';
				}//<--end if
			}//<--end exportable
		}//<--end for loop

		if(right(columnsHQL,1) == ','){
			columnsHQL &= left(columnsHQL,len(columnsHQL)-1);
		}
		var endMapHQL = ')';

		if(!len(columnsHQL)){
			columnsHQL = "#getCollectionConfigStruct().baseEntityAlias#.id";
		}
		HQL &= selectHQL & startMapHQL & columnsHQL & endMapHQL;
		return HQL;
	}//<--end function

	public any function createHQLFromCollectionObject(required any collectionObject,
		boolean excludeSelectAndOrderBy=false,
		boolean forExport=false,
	    boolean removeOrderBy=false
	){
		var HQL = "";
		var collectionConfig = arguments.collectionObject.getCollectionConfigStruct();


		if(!isNull(collectionConfig.baseEntityName)){
			var selectHQL = "";
			var fromHQL = "";
			var filterHQL = "";
			var postFilterHQL = "";
			var orderByHQL = "";
			var groupByHQL = "";


			//build select
			if(!isNull(collectionConfig.columns) && arrayLen(collectionConfig.columns) && arguments.excludeSelectAndOrderBy == false){
				var isDistinct = false;
				if(!isNull(collectionConfig.isDistinct)){
					isDistinct = collectionConfig.isDistinct;
				}
				if(!isNull(collectionConfig.hasManyRelationFilter)){
					setHasManyRelationFilter(collectionConfig.hasManyRelationFilter);
				}
				//get select columns if we don't have a non-persistent column and a processContext was not supplied
				if(!this.getNonPersistentColumn() && !len(this.getProcessContext())){
					selectHQL &= getSelectionsHQL(columns=collectionConfig.columns, isDistinct=isDistinct, forExport=arguments.forExport);
				}

				if(!removeOrderBy) {
					if (!isnull(getPostOrderBys()) && arraylen(getPostOrderBys())) {
						orderByHQL &= getOrderByHQL(getPostOrderBys());
					} else
						if (!isNull(collectionConfig.orderBy) && arrayLen(collectionConfig.orderBy)) {
							//build Order By
							orderByHQL &= getOrderByHQL(collectionConfig.orderBy);
						} else {
							orderByHQL &= getOrderByHQL();
						}
				}
			}//<--end if build select
			if(
				(getHasDisplayAggregate() || getHasManyRelationFilter())
				&& (
					!structKeyExists(collectionConfig,'groupBys')
					|| (
						structKeyExists(collectionConfig,'groupBys')
						&& len(collectionConfig.groupBys)
					)
				)
			){
				var groupBys = [];
				//add a group by for all selects that are not aggregates
				for(var column in collectionConfig.columns){
					if(!structKeyExists(column,'aggregate') && !structKeyExists(column,'persistent')){
						arrayAppend(groupBys,column.propertyIdentifier);
					}
				}

				if(!structKeyExists(collectionConfig,'orderBy') || !arrayLen(collectionConfig.orderBy)){
					arrayAppend(groupBys,'_' & lcase(getService('hibachiService').getProperlyCasedShortEntityName(getCollectionObject())) & '.' & "createdDateTime");
				}else{
					//add a group by for all order bys
					for(var orderBy in collectionConfig.orderBy){
						arrayAppend(groupBys,orderBy.propertyIdentifier);
					}
				}
				collectionConfig.groupBys = arrayToList(groupBys);

			}

			//where clauses are actually the collection of all parent/child where clauses
			var filterGroupArray = getFilterGroupArrayFromAncestors(this);
			if(arraylen(filterGroupArray)){
				filterHQL &= getFilterHQL(filterGroupArray);
			}

			var aggregateFilters = getAggregateFilterHQL();

			if(len(aggregateFilters) > 0){
				aggregateFilters =  ' HAVING #aggregateFilters#';
				if(arguments.excludeSelectAndOrderBy == true){
					groupByHQL = "GROUP BY _#lcase(getService('hibachiService').getProperlyCasedShortEntityName(getCollectionObject()))#.id";
				}
			}

			addPostFiltersFromKeywords(collectionConfig);

			//check if the user has applied any filters from the ui list view
			if(arraylen(getPostFilterGroups())){
				if(len(filterHQL) == 0){
					postFilterHQL &= ' where ';
					postFilterHQL &= '(' & getFilterGroupsHQL(postFilterGroups) & ')';
				}else{
					postFilterHQL &= ' AND ' & '(' & getFilterGroupsHQL(postFilterGroups) & ')';
				}
			}



			//build FROM last because we have aquired joins implicitly
			var joins = [];
			if(!isnull(collectionConfig.joins)){
				joins = collectionConfig.joins;
			}

			if(structKeyExists(collectionConfig,'groupBys')){
				groupByHQL = getGroupByHQL(collectionConfig.groupBys);
			}



			fromHQL &= getFromHQL(collectionConfig.baseEntityName, collectionConfig.baseEntityAlias, joins);

			HQL = SelectHQL & FromHQL & filterHQL  & postFilterHQL & groupByHQL & aggregateFilters & orderByHQL;
		}
		return HQL;
	}

	public void function addPostFiltersFromKeywords(required any collectionConfig) {
		var keywordArray = getKeywordArray();
		var keywordCount = arraylen(keywordArray);
		var defaultColumns = false;
		//If columns config is not passed in, use all the columns
		if(structKeyExists(arguments.collectionConfig,'columns') && arrayLen(arguments.collectionConfig.columns)){
			var columns = arguments.collectionConfig.columns;
							}else{
			defaultColumns = true;
			var columns = getService('HibachiService').getPropertiesWithAttributesByEntityName(arguments.collectionConfig.baseEntityName);
										}
		var keywordIndex = 0;
		//loop through keywords
		for(var keyword in keywordArray) {
			var columnIndex = 0;
			//loop through columns
			for(var column in columns) {
				var postFilterGroup = {
					"filterGroup" = [
						{
							"comparisonOperator" = "like",
							"value"="%#keyword#%"
						}
					]
				};
				if ((
					!defaultColumns && ( !structKeyExists(column, 'isSearchable') || !column.isSearchable)
					) || (
					defaultColumns && (
						structKeyExists(column, 'fkcolumn')
					|| (structKeyExists(column, 'persistent') && column.persistent == false)
					|| !structKeyExists(column, 'ormtype')
					))
				) continue;
				//if ormtype is not set, find it
				if(!structKeyExists(column, 'ormtype')){
					var allColumns = getService('HibachiService').getPropertiesWithAttributesByEntityName(arguments.collectionConfig.baseEntityName);
					for(var col in allColumns){
						if(col.name == ListLast(column.propertyIdentifier, '.') && structKeyExists(col, 'ormtype')){
							column.ormtype = col.ormtype;
							break;
						}
					}
				}
				//Only allow search on string, integer or big_decimal (for now)
				if(!structKeyExists(column, 'ormtype') ||
					(column.ormtype neq 'string'
					&& column.ormtype neq 'integer'
					&& column.ormtype neq 'big_decimal')
				) continue;

				var formatter = (column.ormtype eq 'big_decimal' || column.ormtype eq 'integer') ? 'STR' : '';
				if(formatter == '' && getHibachiScope().getApplicationValue('databaseType')=="Oracle10g"){
					formatter = "LOWER";
				}
				//Create a propertyIdentifier for DefaultColumns
				var propertyIdentifier = (!defaultColumns)? column.propertyIdentifier : arguments.collectionConfig.baseEntityAlias&'.'&column.name;
				//If is Attributes
				if (structKeyExists(column, 'attributeID')) {
					postFilterGroup.filterGroup[1].propertyIdentifier = propertyIdentifier;
					postFilterGroup.filterGroup[1].attributeID = column.attributeID;
					postFilterGroup.filterGroup[1].attributeSetObject = column.attributeSetObject;
					if (keywordCount != 0) postFilterGroup.logicalOperator = "OR";
				}else{
					postFilterGroup.filterGroup[1].propertyIdentifier = formatter & '(#propertyIdentifier#)';
					if(keywordCount == 1){
						postFilterGroup.logicalOperator = "OR";
					}else{
						postFilterGroup.logicalOperator = (columnIndex) ? "OR" : "AND";
					}
					//remove AND from the frist filterGroup
					if(columnIndex == 0 && keywordIndex == 0) {
						structDelete(postFilterGroup, "logicalOperator");
					}
				}
				addPostFilterGroup(postFilterGroup);
				columnIndex++;
			}
			keywordIndex++;
		}
	}

	//TODO:write an export/import service so we can share json files of the collectionConfig
	public void function exportCollectionConfigAsJSON(required string filePath,fileName){
		fileWrite("#arguments.filePath##arguments.fileName#.json", getCollectionConfig());
	}

	public void function importCollectionConfigAsJSON(required string filePath, fileName){
		setCollectionConfig(fileRead( "#filePath##filename#.json" ));
	}

	// =============== Saved State Logic ===========================

	public void function loadSavedState(required string savedStateID) {
		var savedStates = [];
		if(getHibachiScope().hasSessionValue('collectionSavedState')) {
			savedStates = getHibachiScope().getSessionValue('collectionSavedState');
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
		if(!getHibachiScope().hasSessionValue('collectionSavedState')) {
			getHibachiScope().setSessionValue('collectionSavedState', []);
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
		lock name="#sessionKey#_#getHibachiInstanceApplicationScopeKey()#_collectionSavedStateUpdateLogic" timeout="10" {

			// Get the saved state struct
			var states = getHibachiScope().getSessionValue('collectionSavedState');

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

			getHibachiScope().setSessionValue('collectionSavedState', states);
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
		//TODO:change what the state variables are, evaluate the value of them
		stateStruct.collectionConfig = duplicate(variables.collectionConfig);
		stateStruct.keywords = duplicate(variables.keywords);
		stateStruct.pageRecordsShow = duplicate(variables.pageRecordsShow);

		return stateStruct;
	}

	//Utility Functions may even belong in another service altogether based on how universally appliable they are

	private string function removeCharacters(required string javaUUIDString){
		return replace(arguments.javaUUIDString,'-','','all');
	}

	public any function getCollectionConfigStruct(){
		if(isNull(variables.collectionConfigStruct)){
			variables.collectionConfigStruct = deserializeCollectionConfig();
		}
		return variables.collectionConfigStruct;
	}

	public any function deserializeCollectionConfig(){
		return deserializeJSON(getCollectionConfig());
	}



	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	public boolean function hasNoAssociatedCollection() {
		var collectionCollection =  getService('hibachiService').getCollectionCollectionList();
		collectionCollection.addFilter('parentCollection.collectionID', variables.collectionID);
		if(collectionCollection.getRecordsCount() == 0){
			return true;
		}else{
			return false;
		}


	}

	// ===============  END: Custom Validation Methods =====================

	// =============== START: Custom Formatting Methods ====================

	// ===============  END: Custom Formatting Methods =====================

	// ============== START: Overridden Implicit Getters ===================

	public any function getDefaultCollectionProperties(){
		return super.getDefaultCollectionProperties();
	}

	// ==============  END: Overridden Implicit Getters ====================

	// ============= START: Overridden Smart List Getters ==================

	// =============  END: Overridden Smart List Getters ===================

	// ================== START: Overridden Methods ========================

	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	// ===================  END:  ORM Event Hooks  =========================

	// ================== START: Deprecated Methods ========================

	// ==================  END:  Deprecated Methods ========================


	public any function getConfigStructure() {
		if(!structKeyExists(variables, "configStructure")) {
			if(!isNull(getCollectionConfig())) {
				variables.configStructure = deserializeJSON(getCollectionConfig());
			} else {
				variables.configStructure = {};
				variables.configStructure['baseEntityName'] = getCollectionObject();
			}
		}
		return variables.configStructure;
	}

	public any function updateCollectionConfig() {
		setCollectionConfig( serializeJSON(getConfigStructure()) );
	}

	//validationMethods
	public any function canSaveCollectionByCollectionObject(){
		return getHibachiScope().authenticateCollection('read', this);
	}

}


/*
	SELECT accountID
	FROM SlatwallAccount
	where exists(
		FROM SlatwallAccount
		where firstName = 'Ryan'

	)

	{
		entityName = '',
		columns = [
			{
				propertyIdentifier = 'primaryIDProperty'
			},
			{
				propertyIdentifier = '',
				function = len(), max(), whatever()
			}
		],
		where = [
			{ see below }
		],
		orderby = [
			{
				propertyIdentifier = '',
				direction = 'ASC' | 'DESC',
				function = len(), max(), whatever()
			}
		],
		groupby = [
			{
				propertyIdentifier = '',
				direction = 'ASC' | 'DESC',
				function = len(), max(), whatever()
			}
		],
		relationships = {
			propertyIdentifier = {
				fetch = true | false,
				join = 'left' | 'inner'
			}
		},
		subqueries = {
			aliase1 = {
				entityName = '',
				joinPropertyIdentifier,
				columns = [],
				where = [],
				orderby = [],
				groupby = [],
				relationships = {},
				subqueries = {}
			},
			aliase2 = {
				collectionID = ''
			}
		}
	}

	===============================================================================
	WHERE (productCode = 'X' AND activeFlag = 1)

	where[1].propertyIdentifier = 'productCode',
	where[1].operator = '=',
	where[1].value = 'X',
	where[2].propertyIdentifier = 'activeFlag',
	where[2].operator = '=',
	where[2].value = 1,

	where = [
		{
			propertyIdentifier = 'productCode',
			operator = '=',
			value = 'X'
		},
		{
			propertyIdentifier = 'activeFlag',
			operator = '=',
			value = 1
		}
	]


	================================================================================
	WHERE ( ( productCode = X AND productName = 'Y' ) OR ( activeFlag = 1 ) )

	where[1].propertyIdentifier = 'productCode'
	where[1].operator = '='
	where[1].value = 'X'
	where[2].propertyIdentifier = 'productName'
	where[2].operator = '='
	where[2].value = 'Y'
	where[3].or[1].propertyIdentifier = "'activeFlag'"
	where[3].or[1].operator = '='
	where[3].or[1].value = 1

	"where" = [
		{
			"propertyIdentifier" = "'productCode'",
			"operator" = '=',
			"value" = 'X'
		},
		{
			"propertyIdentifier" = "'productName'",
			"operator" = '=',
			"value" = 'Y'
		},
		{
			"or" = [
				"propertyIdentifier" = "activeFlag",
				"operator" = '=',
				"value" = 1
			]
		}
	]


	=============================================================================================
	WHERE ( (productCode = X AND productName = Y) AND ( (activeFlag = 1 OR publishedFlag = 1) ) )

	where[1].propertyIdentifier = 'productCode'
	where[1].value = 'X'
	where[1].operator = '='
	where[2].propertyIdentifier = 'productName'
	where[2].value = 'Y'
	where[2].operator = '='
	where[3].and[1].or[1].propertyIdentifier = 'activeFlag'
	where[3].and[1].or[1].operator = '='
	where[3].and[1].or[1].value = 1
	where[3].and[1].or[2].propertyIdentifier = 'publishedFlag'
	where[3].and[1].or[2].operator = '='
	where[3].and[1].or[2].value = 1

	where = [
		{
			propertyIdentifier = 'productCode',
			operator = '=',
			value = 'X'
		},
		{
			propertyIdentifier = 'productName',
			operator = '=',
			value = 'Y'
		},
		{
			and = [
				{
					or = [
						{
							propertyIdentifier = 'activeFlag',
							operator = '=',
							value = 1
						},
						{
							propertyIdentifier = 'publishedFlag',
							operator = '=',
							value = 1
						}
					]
				}

			]
		}
	]

	where (((productCode = X AND productName = Y) AND (activeFlag = 1 OR publishedFlag = 1)) OR (LEN(productDescription) > 10 AND LEN(productDescription) < 100))

	where[1].or[1].and[1].and[1].propertyIdentifier = 'productCode'
	where[1].or[1].and[1].and[1].operator = '='
	where[1].or[1].and[1].and[1].value = 'x'
	where[1].or[1].and[1].and[2].propertyIdentifier = 'productName'
	where[1].or[1].and[1].and[2].operator = '='
	where[1].or[1].and[1].and[2].value = 'Y'
	where[1].or[1].and[1].or[1].propertyIdentifier = 'activeFlag'
	where[1].or[1].and[1].or[1].operator = '='
	where[1].or[1].and[1].or[1].value = 1
	where[1].or[1].and[1].or[2].propertyIdentifier = 'publishedFlag'
	where[1].or[1].and[1].or[2].operator = '='
	where[1].or[1].and[1].or[2].value = 1
	where[1].or[2].and[1].function = 'LEN'
	where[1].or[2].and[1].propertyIdentifier = 'productDescription'
	where[1].or[2].and[1].operator = '>'
	where[1].or[2].and[1].value = 10,
	where[1].or[2].and[1].function = 'LEN'
	where[1].or[2].and[1].propertyIdentifier = 'productDescription'
	where[1].or[2].and[1].operator = '<'
	where[1].or[2].and[1].value = 100,

	where = [
		{
			or = [
				{
					and = [
						{
							and = [
								{
									propertyIdentifier = 'productCode',
									operator = '=',
									value = 'X'
								},
								{
									propertyIdentifier = 'productName',
									operator = '=',
									value = 'Y'
								},
							]
						},
						{
							or = [
								{
									propertyIdentifier = 'activeFlag',
									operator = '=',
									value = 1
								},
								{
									propertyIdentifier = 'publishedFlag',
									operator = '=',
									value = 1
								}
							]
						},
					]
				},
				{
					and = [
						{
							function = 'LEN',
							propertyIdentifier = 'productDescription',
							operator = '>',
							value = 10
						},
						{
							function = 'LEN',
							propertyIdentifier = 'productDescription',
							operator = '<',
							value = 100

						}
					]
				},
			]
		},
	]


	WHERE activeFlag=1 AND EXISTS( SELECT skuID FROM SlatwallSku sqsku WHERE ( sqsku.product.productID = base.productID AND price < 30 ) )

	where[1].propertyIdentifier = 'activeFlag'
	where[1].operator = '='
	where[1].value = 1
	where[2].exists.entityName = 'SlatwallSku'
	where[2].exists.where[1].propertyIdentifier = 'product.productID'
	where[2].exists.where[1].operator = '='
	where[2].exists.where[1].valuePropertyIdentifier = 'base.productID'
	where[2].exists.where[2].propertyIdentifier = 'price'
	where[2].exists.where[2].operator = '<'
	where[2].exists.where[2].value = 30

	where : [
		{
			"propertyIdentifier" : "activeFlag",
			"operator" : "=",
			"value" : 1
		},
		{
			"exists" : {
				"entityName" : "SlatwallSku",
				"where" : [
					{
						"propertyIdentifier" : "product.productID",
						"operator" : ":",
						"valuePropertyIdentifier" : "base.productID"
					},
					{
						"propertyIdentifier" : "price",
						"operator" : "=",
						"value" : 30
					}
				]
			}
		}
	]
	//we can construct aliases on the front end?
	{
		"baseEntity":"Account",
		"Join":[
			{
				"associationName":"admins",
				"alias":"a",
				"Join":{
					"associationName":"",
					"alias":""
				}
			}
		],
		"columns":[
 			"propertyIdentifer":""
 		],
 		"filterGroups":[
			{
				"filterGroup":[
					{
						"propertyIdentifier":"superUserFlag",
						"comparisonOperator":"=",
						"value":"true"
					},
					{
						"logicalOperator":"AND",
						"propertyIdentifier":"superUserFlag",
						"comparisonOperator":"=",
						"value":"false"
					}
				]

			},
			{
				"logicalOperator":"OR",
				"filterGroup":[
					{
					"propertyIdentifier":"superUserFlag",
						"comparisonOperator":"=",
						"value":"true"
					},
					{
						"logicalOperator":"OR",
						"propertyIdentifier":"superUserFlag",
						"comparisonOperator":"=",
						"value":"false"
					}
				]
			}
		]
	}

*/
