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
component displayname="Collection" entityname="SlatwallCollection" table="SwCollection" persistent="true" accessors="true" extends="HibachiEntity" hb_serviceName="collectionService" {
	
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
	
	//property name="entityNameOptions" persistent="false" hint="an array of name/value structs for the entity's metaData";
	property name="collectionObjectOptions" persistent="false";
	
	// ============ START: Non-Persistent Property Methods =================
	
	//returns an array of name/value structs for 
	public array function getCollectionObjectOptions() {
		if(!structKeyExists(variables, "collectionObjectOptions")) {
			var entitiesMetaData = getService("hibachiService").getEntitiesMetaData();
			var entitiesMetaDataArray = listToArray(structKeyList(entitiesMetaData));
			arraySort(entitiesMetaDataArray,"text");
			variables.collectionObjectOptions = [];
			for(var i=1; i<=arrayLen(entitiesMetaDataArray); i++) {
				arrayAppend(variables.collectionObjectOptions, {name=rbKey('entity.#entitiesMetaDataArray[i]#'), value=entitiesMetaDataArray[i]});
			}
		}
		return variables.collectionObjectOptions;
	}
	
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
		variables.collectionConfig = '{}';
		variables.processObjects = [];
	}
	
	public void function setCollectionObject(required string collectionObject, boolean addDefaultColumns=true){
		var slatwallBaseEntity = "";
		if(find('Slatwall',arguments.collectionObject)){
			slatwallBaseEntity = arguments.collectionObject;
		}else{
			slatwallBaseEntity = getService('hibachiService').getProperlyCasedFullEntityName(arguments.collectionObject);
		}
		
		variables.collectionObject = arguments.collectionObject;
		if(variables.collectionConfig eq '{}' ){
			//get default columns
			var newEntity = getService("hibachiService").getServiceByEntityName(arguments.collectionObject).invokeMethod("new#arguments.collectionObject#");
			var defaultProperties = newEntity.getDefaultCollectionProperties();
			
			var columnsArray = [];
			//check to see if we are supposed to add default columns 
			if(addDefaultColumns){
				//loop through all defaultProperties
				for(defaultProperty in defaultProperties){
					var columnStruct = {};
					columnStruct['propertyIdentifier'] = '_' & lcase(getService('hibachiService').getProperlyCasedShortEntityName(arguments.collectionObject)) & '.' & defaultProperty.name;
					columnStruct['title'] = newEntity.getPropertyTitle(defaultProperty.name);
					//if property is a primary id, hide it and make it so it can't be deleted
					if(structKeyExists(defaultProperty,"fieldtype") && defaultProperty.fieldtype == 'id'){
						columnStruct['isDeletable'] = false;
						columnStruct['isVisible'] = false;
					//if property is a config of json hide it
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
					
					arrayAppend(columnsArray,columnStruct);
				}
			}
			
			var columnsJson = serializeJson(columnsArray);
			variables.collectionConfig = '{
				"baseEntityName":"#slatwallBaseEntity#",
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
		for(key in arguments.collectionHQLParams){
			addHQLParam(key,arguments.collectionHQLParams[key]);
		}
	}
	
	//join introspects on itself for nested joins to ensure that all joins are added in the correct order
	private string function addJoinHQL(required string parentAlias, required any join){
		var fullJoinName = "#parentAlias#.#arguments.join.associationName#";
		addHQLAlias(fullJoinName,arguments.join.alias);
		var joinHQL = ' left join #fullJoinName# as #arguments.join.alias# ';
		if(!isnull(arguments.join.joins)){
			for(childJoin in arguments.join.joins){
				joinHQL &= addJoinHQL(join.alias,childJoin);
			}
		}
		
		return joinHQL;
	}
	
	private string function addJoin(required any join){
		if(!structKeyExists(getCollectionConfigStruct(),'joins')){
			getCollectionConfigStruct().joins = [];
		}
		var joinFound = false;
		for(configJoin in getCollectionConfigStruct().joins){
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
		return " #aggregateFunction#(#arguments.propertyIdentifier#) as #arguments.aggregate.aggregateAlias#";
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
			case "All":
				return "";
			break;
			case "One":
				return "EXISTS";
			break;
			case "None":
				return "NOT EXISTS";
			break;
		}
	}
	
	public array function getFilterGroupArrayFromAncestors(required any collectionEntity){
		var collectionConfig = arguments.collectionEntity.getCollectionConfigStruct();
		var filterGroupArray = [];
		if(!isnull(collectionConfig.filterGroups) && arraylen(collectionConfig.filterGroups)){
			filterGroupArray = collectionConfig.filterGroups;
		}
		
		if(!isnull(arguments.collectionEntity.getParentCollection())){
			
			var parentFilterGroupArray = getFilterGroupArrayFromAncestors(arguments.collectionEntity.getParentCollection());
			
			for(parentFilterGroup in parentFilterGroupArray){
				if(!arrayFind(filterGroupArray,parentFilterGroup)){
					if(!structKeyExists(parentFilterGroup,"logicalOperator")){
						parentFilterGroup.logicalOperator = ' AND ';
					}
					ArrayAppend(filterGroupArray,parentFilterGroup);
				}
			}
		}
		
		return filterGroupArray;
	}
	
	private string function getFilterGroupHQL(required array filterGroup){
		var filterGroupHQL = '';
		for(filter in arguments.filterGroup){
			//add property and value to HQLParams
			//if using a like parameter we need to add % to the value using angular
			var logicalOperator = '';
			if(structKeyExists(filter,"logicalOperator")){
				logicalOperator = filter.logicalOperator;
			}
			if(!isnull(filter.collectionID)){
				filterGroupHQL &=  " #logicalOperator# #getHQLForCollectionFilter(filter)# ";;
			}else{
				
				//check filter is a nested filterGroup or a filter itself
				if(structKeyExists(filter,"filterGroup")){
					
					filterGroupHQL &= getFilterGroupsHQL([filter]);
				}else{
					var comparisonOperator = getComparisonOperator(filter.comparisonOperator);
				
					var predicate = getPredicate(filter);
					
					if(isnull(filter.attributeID)){
						filterGroupHQL &= " #logicalOperator# #filter.propertyIdentifier# #comparisonOperator# #predicate# ";
					}else{
						var attributeHQL = getFilterAttributeHQL(filter);
						filterGroupHQL &= " #logicalOperator# #attributeHQL# #comparisonOperator# #predicate# ";
					}
				}
				
			}
		}
		
		return filterGroupHQL;
	}
	
	private string function getFilterAttributeHQL(required any filter){
		var attributeIdentifier = listDeleteAt(filter.propertyIdentifier,ListLen(filter.propertyIdentifier,'.'),'.');
		
		var HQL = "(SELECT attributeValue 
					FROM SlatwallAttributeValue 
					WHERE attributeID = '#filter.attributeID#' 
					AND #filter.attributeSetObject#.#filter.attributeSetObject#ID = #attributeIdentifier#.#filter.attributeSetObject#ID)";
		return HQL;
	}
	
	private string function getFilterGroupsHQL(required array filterGroups){
		var filterGroupsHQL = '';
		for(filterGroup in arguments.FilterGroups){
			var logicalOperator = '';
			
			if(structKeyExists(filterGroup,'logicalOperator')){
				logicalOperator = getLogicalOperator(filterGroup.logicalOperator);
			}
			//constuct HQL to be used in filterGroup
			var filterGroupHQL = getFilterGroupHQL(filterGroup.filterGroup);
			if(len(filterGroupHQL)){
				if(logicalOperator == "AND"){
					filterGroupsHQL &= ") #logicalOperator# ((#filterGroupHQL#)";
				} else {
					filterGroupsHQL &= " #logicalOperator# (#filterGroupHQL#)";
				}
				
				
			}
		}
		return filterGroupsHQL;
	}
	
	private string function getFilterHQL(required array filterGroups){
		//make the item without a logical operator first
		filterHQL = '';
		
		var filterGroupsHQL = getFilterGroupsHQL(arguments.filterGroups);
		if(len(filterGroupsHQL)){
			filterHQL &= ' where ';
			filterHQL &= filterGroupsHQL;
		}
		return filterHQL;
	}
	
	private string function getFromHQL(required string baseEntityName, required string baseEntityAlias, required any joins){
		var fromHQL = ' FROM #arguments.baseEntityName# as #arguments.baseEntityAlias#';
		addHQLAlias(arguments.baseEntityName,arguments.baseEntityAlias);
		for(join in arguments.joins){
			fromHQL &= addJoinHQL(arguments.baseEntityAlias,join);
		}
		
		return fromHQL;
	}
	
	public string function getHQL(boolean excludeSelectAndOrderBy = false){
		var collectionConfig = getCollectionConfigStruct();
		variables.HQLParams = {};
		variables.postFilterGroups = [];
		variables.postOrderBys = [];
		HQL = createHQLFromCollectionObject(this,arguments.excludeSelectAndOrderBy);
		return HQL;
	}
	
	private string function getHQLForCollectionFilter(required struct filter){
		var collectionFilterHQL = '';
		var filterCriteria = getfilterCriteria(arguments.filter.criteria);
		collectionFilterHQL &= ' #filterCriteria# (';
		
		var collectionEntity = getService('collectionService').getCollectionByCollectionID(arguments.filter.collectionID);
		var mainCollectionAlias = listFirst(arguments.filter.propertyIdentifier,'.');
		var mainCollectionObject = replace(listFirst(arguments.filter.propertyIdentifier,'.'),'_','');
		var collectionProperty = '';
		if(mainCollectionObject != collectionEntity.getCollectionObject()){
			collectionProperty = getService('HibachiService').getPropertyByEntityNameAndPropertyName(collectionEntity.getCollectionObject(),mainCollectionObject).name;
		}else{
			collectionProperty = mainCollectionObject;
		}
		
		//None,One,All
		/*withaliases
		if(arguments.filter.criteria eq 'None' || arguments.filter.criteria eq 'One'){
			collectionFilterHQL &= ' #collectionEntity.getHQL()# AND #maincollectionAlias# = #collectionEntity.getHQLAliases()['#collectionEntity.getCollectionObject()#']#.#collectionProperty# ';
		}else{
			var fullEntityName = getService('hibachiService').getProperlyCasedFullEntityName(collectionEntity.getCollectionObject());
			
			collectionFilterHQL &= ' (SELECT count(#collectionEntity.getCollectionObject()#) FROM #fullEntityName# as #collectionEntity.getCollectionObject()# WHERE #collectionEntity.getCollectionObject()#.#collectionProperty# = #mainCollectionAlias#) 
			= (SELECT count(#collectionEntity.getCollectionObject()#) #collectionEntity.getHQL(true)# AND #collectionEntity.getHQLAliases()['#collectionEntity.getCollectionObject()#']#.#collectionProperty# = #mainCollectionAlias#) ';
		}
		*/
		
		if(arguments.filter.criteria eq 'None' || arguments.filter.criteria eq 'One'){
			var collectionHQL = collectionEntity.getHQL(true);
			var hasWhereClause = Find('where',collectionHQL);
			
			var predicate = 'AND';
			if(!hasWhereClause){
				predicate = 'WHERE';
			}
			var comparator = '';
			if(mainCollectionObject != collectionEntity.getCollectionObject()){
				comparator = replace(collectionEntity.getCollectionConfigStruct().baseEntityAlias&'.'&collectionProperty,'_','__','ALL');
			}else{
				comparator = replace(collectionEntity.getCollectionConfigStruct().baseEntityAlias,'_','__','ALL');
			}
			
			collectionFilterHQL &= ' #replace(collectionEntity.getHQL(true),'_','__','ALL')# #predicate# #maincollectionAlias# = #comparator# ';
		}else{
			var fullEntityName = getService('hibachiService').getProperlyCasedFullEntityName(collectionEntity.getCollectionObject());
			
			var collectionHQL = collectionEntity.getHQL(true);
			var hasWhereClause = Find('where',collectionHQL);
			
			var predicate = 'AND';
			if(!hasWhereClause){
				predicate = 'WHERE';
			}
			
			var comparator = '';
			if(mainCollectionObject != collectionEntity.getCollectionObject()){
				comparator = '#collectionEntity.getCollectionConfigStruct().baseEntityAlias#.#collectionProperty#';
			}else{
				comparator = '#collectionEntity.getCollectionConfigStruct().baseEntityAlias#';
			}
			var innerComparator = '';
			if(collectionEntity.getCollectionObject() == collectionProperty){
				innerComparator = '#collectionEntity.getCollectionObject()#';
			}else{
				innerComparator = '#collectionEntity.getCollectionObject()#.#collectionProperty#';
			}
			
			collectionFilterHQL &= ' (SELECT count(#collectionEntity.getCollectionObject()#) FROM #fullEntityName# as #collectionEntity.getCollectionObject()# WHERE #innerComparator# = #mainCollectionAlias#) = (SELECT count(#collectionEntity.getCollectionConfigStruct().baseEntityAlias#) #collectionHQL# #predicate# #comparator# = #mainCollectionAlias#) ';
		}
		
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
	
	private string function getOrderByHQL(array orderBy=[]){
		var orderByHQL = ' ORDER BY ';
				
		var orderByCount = arraylen(arguments.orderBy);
		//if order by count is 0, then use the default order by
		if(orderByCount == 0){
			var baseEntityObject = getService('hibachiService').getEntityObject( getCollectionObject() );
			//is default order by based on hb_defaultOrderProperty
			if(structKeyExists(baseEntityObject.getThisMetaData(), "hb_defaultOrderProperty")) {
				var orderByStruct={
					propertyIdentifier='_' & lcase(getService('hibachiService').getProperlyCasedShortEntityName(getCollectionObject())) & '.' & baseEntityObject.getThisMetaData()["hb_defaultOrderProperty"],
					direction="asc"
				};	
				arrayAppend(arguments.orderby,orderByStruct);
				orderByCount++;
			//if not then does it have a createdDateTime
			} else if ( baseEntityObject.hasProperty( "createdDateTime" ) ) {
				var orderByStruct={
					propertyIdentifier='_' & lcase(getService('hibachiService').getProperlyCasedShortEntityName(getCollectionObject())) & '.' & "createdDateTime",
					direction="desc"
				};	
				arrayAppend(arguments.orderby,orderByStruct);
				orderByCount++;
			//if still not then order by primary id
			} else {
				var orderByStruct={
					propertyIdentifier='_' & lcase(getService('hibachiService').getProperlyCasedShortEntityName(getCollectionObject())) & '.' & baseEntityObject.getPrimaryIDPropertyName(),
					direction="asc"
				};	
				arrayAppend(arguments.orderby,orderByStruct);
				orderByCount++;
			}
			
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
	public array function getPageRecords(boolean refresh=false) {
		try{
			
			if( !structKeyExists(variables, "pageRecords") || arguments.refresh eq true) {
				saveState();
				if(this.getNonPersistentColumn() || (!isNull(this.getProcessContext()) && len(this.getProcessContext()))){
					//prepare page records and possible process objects
					variables.pageRecords = [];
					variables.processObjects = [];
					var entities = ormExecuteQuery(getHQL(), getHQLParams(), false, {offset=getPageRecordsStart()-1, maxresults=getPageRecordsShow(), ignoreCase="true", cacheable=getCacheable(), cachename="pageRecords-#getCacheName()#"});
					var columns = getCollectionConfigStruct().columns;
					
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
					variables.pageRecords = ormExecuteQuery(getHQL(), getHQLParams(), false, {offset=getPageRecordsStart()-1, maxresults=getPageRecordsShow(), ignoreCase="true", cacheable=getCacheable(), cachename="pageRecords-#getCacheName()#"});
				}
			}
		}
		catch(any e){
			variables.pageRecords = [{'failedCollection'='failedCollection'}];
		}
		
		return variables.pageRecords;
	}
	
	public void function clearRecordsCount() {
		structDelete(variables, "recordsCount");
	}
	
	public any function getSettingValueFormattedByPropertyIdentifier(required string propertyIdentifier, required any entity){
		if(listLen(arguments.propertyIdentifier) == 1){
			return entity.getSettingValueFormatted(arguments.propertyIdentifier);
		}else{
			var settingName = listLast(arguments.propertyIdentifier);
			var arguments.propertyIdentifier = listDeleteAt(arguments.propertyIdentifier,listLen(arguments.propertyIdentifier));
			var relatedObject = entity.getValueByPropertyIdentifier(arguments.propertyIdentifier);
			return relatedObject.getSettingValueFormatted(settingName);
		}
	}
	
	public array function getRecords(boolean refresh=false) {
		//try{
			if( !structKeyExists(variables, "records") || arguments.refresh == true) {
				if(this.getNonPersistentColumn()){
					variables.records = [];
					var entities = ormExecuteQuery(getHQL(), getHQLParams(), false, {ignoreCase="true", cacheable=getCacheable(), cachename="records-#getCacheName()#"});
					var columns = getCollectionConfigStruct().columns;
					for(var entity in entities){
						var record = {};
						
						for(var column in columns){
							var listRest = ListRest(column.propertyIdentifier,'.');
							if(structKeyExists(column,'setting') && column.setting == true){
								var listRest = ListRest(column.propertyIdentifier,'.');
								record[Replace(listRest(column.propertyIdentifier,'.'),'.','_','all')] = getSettingValueFormattedByPropertyIdentifier(listRest,entity);
							}else{
								record[Replace(listRest(column.propertyIdentifier,'.'),'.','_','all')] = entity.getValueByPropertyIdentifier(listRest);
							}
						}
						arrayAppend(variables.records,record);
					} 
				}else{
					variables.records = ormExecuteQuery(getHQL(), getHQLParams(), false, {ignoreCase="true", cacheable=getCacheable(), cachename="records-#getCacheName()#"});
				}
			}
//		}
//		catch(any e){
//			variables.records = [{'failedCollection'='failedCollection'}];
//		}
		
		return variables.records;
	}
	
	public any function getRecordsCount() {
		if(!structKeyExists(variables, "recordsCount")) {
			if(getCacheable() && structKeyExists(application.entityCollection, getCacheName()) && structKeyExists(application.entityCollection[getCacheName()], "recordsCount")) {
				variables.recordsCount = application.entityCollection[ getCacheName() ].recordsCount;
			} else {
				if(!structKeyExists(variables,"records")) {
					variables.recordsCount = arrayLen(getRecords());
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
				if(listLen(arguments.filter.value,'-') > 1){
					//convert unix timestamp
					var fromDate = DateAdd("s", listFirst(arguments.filter.value,'-')/1000, "January 1 1970 00:00:00");
					var fromValue = dateFormat(fromDate,"yyyy-mm-dd") & " " & timeFormat(fromDate, "HH:MM:SS");
					var toDate = DateAdd("s", listLast(arguments.filter.value,'-')/1000, "January 1 1970 00:00:00");
					var toValue = dateFormat(toDate,"yyyy-mm-dd") & " " & timeFormat(toDate, "HH:MM:SS");
					var fromParamID = getParamID();
					addHQLParam(fromParamID,fromValue);
					var toParamID = getParamID();
					addHQLParam(toParamID,toValue);
					
					predicate = ":#fromParamID# AND :#toParamID#";	
				}else{
					//if list length is 1 then we treat it as a date range From Now() - Days to Now()
					var fromValue = DateAdd("d",-arguments.filter.value,Now());
					var toValue = Now();
					
					var fromParamID = getParamID();
					addHQLParam(fromParamID,fromValue);
					var toParamID = getParamID();
					addHQLParam(toParamID,toValue);
					
					predicate = ":#fromParamID# AND :#toParamID#";	
				}
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
		
		var attributeIdentifier = listDeleteAt(column.propertyIdentifier,ListLen(column.propertyIdentifier,'.'),'.');
		
		var HQL	=  "(SELECT attributeValue 
					FROM SlatwallAttributeValue
					WHERE attribute.attributeID = '"
					& column.attributeID & 
					"' AND #column.attributeSetObject#.#column.attributeSetObject#ID = #attributeIdentifier#.#column.attributeSetObject#ID) as #listLast(column.propertyIdentifier,'.')#";
		
		return HQL;	
	}
	
	private any function getSelectionsHQL(required array columns, boolean isDistinct=false){
		var isDistinctValue = '';
		if(arguments.isDistinct){
			isDistinctValue = "DISTINCT";
		}
		
		var HQL = 'SELECT #isDistinctValue#';
		var columnCount = arraylen(arguments.columns);
		HQL &= ' new Map(';
		for(var i = 1; i <= columnCount; i++){
			var column = arguments.columns[i];
			
			var currentAlias = '';
			var currentAliasStepped = '';
			var columnPropertyIdentiferArray = listToArray(column.propertyIdentifier,'.');
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
						column.propertyIdentifier = currentAlias&'.'&columnPropertyIdentiferArray[j];
					}
				}
				if(!len(currentAlias)){
					currentAlias = columnPropertyIdentiferArray[1];
				};
				
			}
			
			
			if(structKeyExists(column,'attributeID')){
				HQL &= getColumnAttributeHQL(column);
				
			}else{
				//check if we have an aggregate
				if(!isnull(column.aggregate))
				{
					//if we have an aggregate then put wrap the identifier
					HQL &= getAggregateHQL(column.aggregate,column.propertyIdentifier);
					
				}else{
					var columnAlias = Replace(Replace(column.propertyIdentifier,'.','_','all'),'_'&lcase(Replace(getCollectionObject(),'Slatwall',''))&'_','');
					
					HQL &= ' #column.propertyIdentifier# as #columnAlias#';
				}
			}
			
			//check whether a comma is needed
			if(i != columnCount){
				HQL &= ',';
			}
		}
		
		HQL &= ')';
		
		return HQL;
	}
	
	public any function createHQLFromCollectionObject(required any collectionObject, boolean excludeSelectAndOrderBy=false){
		var HQL = "";
		var collectionConfig = arguments.collectionObject.getCollectionConfigStruct();
		
		if(!isNull(collectionConfig.baseEntityName)){
			var selectHQL = "";
			var fromHQL = "";
			var filterHQL = "";
			var postFilterHQL = "";
			var orderByHQL = "";
			
			//build select
			if(!isNull(collectionConfig.columns) && arrayLen(collectionConfig.columns) && arguments.excludeSelectAndOrderBy eq false){
				var isDistinct = false;
				if(!isNull(collectionConfig.isDistinct)){
					isDistinct = collectionConfig.isDistinct;
				}
				//get select columns if we don't have a non-persistent column and a processContext was not supplied
				if(!this.getNonPersistentColumn() && !len(this.getProcessContext())){
					selectHQL &= getSelectionsHQL(collectionConfig.columns,isDistinct);
				}
				
				if(!isnull(getPostOrderBys()) && arraylen(getPostOrderBys())){
					orderByHQL &= getOrderByHQL(getPostOrderBys());
				}else if(!isNull(collectionConfig.orderBy) && arrayLen(collectionConfig.orderBy)){
					//build Order By
					orderByHQL &= getOrderByHQL(collectionConfig.orderBy);
				}else{
					orderByHQL &= getOrderByHQL();
				}
			}
			
			//where clauses are actually the collection of all parent/child where clauses
			var filterGroupArray = getFilterGroupArrayFromAncestors(this);
			if(arraylen(filterGroupArray)){
				filterHQL &= getFilterHQL(filterGroupArray);
			}
			
			addPostFiltersFromKeywords(collectionConfig,len(filterHQL));
			
			//check if the user has applied any filters from the ui list view
			if(arraylen(getPostFilterGroups())){
				if(len(filterHQL) eq 0){
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
			
			fromHQL &= getFromHQL(collectionConfig.baseEntityName, collectionConfig.baseEntityAlias, joins);
			
			HQL = SelectHQL & FromHQL & filterHQL  & postFilterHQL  & orderByHQL;
		}
		return HQL;
	}
	
	public void function addPostFiltersFromKeywords(required any collectionConfig, numeric hasFilterHQL){
		var keywordCount = 0;
		
		//if our collection config has columns then check if any of them are searchable
		if(structKeyExists(arguments.collectionConfig,'columns') && arrayLen(arguments.collectionConfig.columns)){
			
			for(keyword in getKeywordArray()){
				var columnCount = 0;
				for(column in arguments.collectionConfig.columns){
					
					//which ones have been flagged as searchable
					if(structKeyExists(column,'isSearchable') && column.isSearchable){
						//use keywords to create some post filters
						
						if(structKeyExists(column,'ormtype') 
						&& column.ormtype neq 'boolean' 
						&& column.ormtype neq 'timestamp'
						
						){
						
							if(column.ormtype eq 'big_decimal'
							|| column.ormtype eq 'integer'){
								var postFilterGroup = {
									filterGroup = [
										{
											propertyIdentifier = 'STR(#column.propertyIdentifier#)',
											comparisonOperator = "like",
											value="%#keyword#%"
										}
									]
								};
							}else{
								
								var postFilterGroup = {
									filterGroup = [
										{
											propertyIdentifier = 'LOWER(#column.propertyIdentifier#)',
											comparisonOperator = "like",
											value="%#keyword#%"
										}
									]
								};
							}
							
							if (columnCount != 0 && columnCount < arrayLen(arguments.collectionConfig.columns)+1){
								postFilterGroup.logicalOperator = "OR";
							}else if(keywordCount != 0 && keywordCount < arrayLen(getKeywordArray())){
								postFilterGroup.logicalOperator = "AND";
							}else{
								arguments.hasFilterHQL = 1;
							}
							//add post filter per column that is searchable
							addPostFilterGroup(postFilterGroup);
							
						}
						columnCount++;
					}
					if(structKeyExists(column,'attributeID')){
						for(keyword in getKeywordArray()){
							
							var postFilterGroup = {
								filterGroup = [
									{
										propertyIdentifier = column.propertyIdentifier,
										attributeID = column.attributeID,
					               		attributeSetObject = column.attributeSetObject,
										comparisonOperator = "like",
										value="%#keyword#%"
									}
								] 
							};
							
							if(keywordCount != 0){
								postFilterGroup.logicalOperator = "OR";
							}else{
								arguments.hasFilterHQL = 1;
							}
							
							//add post filter per column that is searchable
							addPostFilterGroup(postFilterGroup);
							keywordCount++;
						}
						keywordCount++;
					}
					
				}
				keywordCount++;
			}
		}else{
			//if we don't have columns then we need default properties searching
			var defaultPropertiesWithAttributes = getService('HibachiService').getPropertiesWithAttributesByEntityName(arguments.collectionConfig.baseEntityName);
			for(propertyItem in defaultPropertiesWithAttributes){
				if(structKeyExists(propertyItem,'ormtype') 
					&& propertyItem.ormtype neq 'boolean' 
					&& propertyItem.ormtype neq 'timestamp' 
					&& !structKeyExists(propertyItem,'attributeID') ){
					for(keyword in getKeywordArray()){
						if(column.ormtype eq 'big_decimal'
						|| column.ormtype eq 'integer'){
							var postFilterGroup = {
								filterGroup = [
									{
										propertyIdentifier = 'STR(#column.propertyIdentifier#)',
										comparisonOperator = "like",
										value="%#keyword#%"
									}
								]
							};
						}else{
							var postFilterGroup = {
								filterGroup = [
									{
										propertyIdentifier = 'LOWER(#arguments.collectionConfig.baseEntityAlias#.#propertyItem.name#)',
										comparisonOperator = "like",
										value="%#keyword#%"
									}
								]
							};
						}
						if(keywordCount != 0){
							postFilterGroup.logicalOperator = "OR";
						}else{
							arguments.hasFilterHQL = 1;
						}
						//add post filter per column that is searchable
						addPostFilterGroup(postFilterGroup);
						keywordCount++;
					}
				}
				if(structKeyExists(propertyItem,'attributeID')){
					for(keyword in getKeywordArray()){
						var postFilterGroup = {
							filterGroup = [
								{
									propertyIdentifier = '#arguments.collectionConfig.baseEntityAlias#.#propertyItem.name#',
									attributeID = propertyItem.attributeID,
				               		attributeSetObject = propertyItem.attributeSetObject,
									comparisonOperator = "like",
									value="%#keyword#%"
								}
							] 
						};
						if(keywordCount != 0){
							postFilterGroup.logicalOperator = "OR";
						}else{
							arguments.hasFilterHQL = 1;
						}
						//add post filter per propertyItem that is searchable
						addPostFilterGroup(postFilterGroup);
						keywordCount++;
					}
					keywordCount++;
				}
				
			}
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
		if(hasSessionValue('collectionSavedState')) {
			savedStates = getSessionValue('collectionSavedState');	
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
		if(!hasSessionValue('collectionSavedState')) {
			setSessionValue('collectionSavedState', []);
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
			var states = getSessionValue('collectionSavedState');
			
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
			
			setSessionValue('collectionSavedState', states);
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
		/*stateStruct.baseEntityName = duplicate(variables.baseEntityName);
		stateStruct.entities = duplicate(variables.entities);
		stateStruct.whereGroups = duplicate(variables.whereGroups);
		stateStruct.whereConditions = duplicate(variables.whereConditions);
		stateStruct.orders = duplicate(variables.orders);
		stateStruct.keywords = duplicate(variables.keywords);
		stateStruct.keywordProperties = duplicate(variables.keywordProperties);
		stateStruct.attributeKeywordProperties = duplicate(variables.attributeKeywordProperties);
		stateStruct.pageRecordsShow = duplicate(variables.pageRecordsShow);
		stateStruct.entityJoinOrder = duplicate(variables.entityJoinOrder);
		stateStruct.selectDistinctFlag = duplicate(variables.selectDistinctFlag);*/
		
		return stateStruct;
	}
	
	//Utility Functions may even belong in another service altogether based on how universally appliable they are
	
	private string function removeCharacters(required string javaUUIDString){
		return replace(javaUUIDString,'-','','all');
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
				variables.configStructure['baseEntitytName'] = getCollectionObject();
			}
		}
		return variables.configStructure;
	}
	
	public any function updateCollectionConfig() {
		setCollectionConfig( serializeJSON(getConfigStructure()) );
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
