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
component displayname="Collection" entityname="SlatwallCollection" table="SwCollection" persistent="true" hb_permission="this" accessors="true" extends="HibachiEntity" hb_serviceName="hibachiCollectionService" hb_processContexts="clone" {

	// Persistent Properties
	property name="collectionID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="collectionName" ormtype="string";
	property name="collectionCode" ormtype="string" index="PI_COLLECTIONCODE";
	property name="collectionDescription" ormtype="string";
	property name="collectionObject" ormtype="string" hb_formFieldType="select";
	property name="collectionConfig" ormtype="string" length="8000" hb_auditable="false" hb_formFieldType="json" hint="json object used to construct the base collection HQL query";
	property name="dirtyReadFlag" ormtype="boolean";
	property name="useElasticSearch" ormtype="boolean" default="0";
	property name="reportFlag" ormtype="boolean" default="0";
	property name="disableAveragesAndSumsFlag" ormtype="boolean" default="0";
	property name="softDeleteFlag" ormtype="boolean" default="0";
	property name="publicFlag" ormtype="boolean" default="0";

	// Calculated Properties

	// Related Object Properties (many-to-one)
	property name="parentCollection" cfc="Collection" fieldtype="many-to-one" fkcolumn="parentCollectionID";
	property name="mergeCollection" cfc="Collection" fieldtype="many-to-one" fkcolumn="mergeCollectionID" hb_formFieldType="select";

	property name="accountOwner" cfc="Account" fieldtype="many-to-one" fkcolumn="accountOwnerID";
	// Related Object Properties (one-to-many)
	property name="accountCollections" hb_populateEnabled="false" singularname="accountCollection" cfc="AccountCollection" type="array" fieldtype="one-to-many" fkcolumn="collectionID" inverse="true" cascade="all-delete-orphan";

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
	property name="hibachiUtilityService" type="any" persistent="false";
	property name="hibachiCollectionService" type="any" persistent="false";
	property name="hibachiService" type="any" persistent="false";
	property name="collectionConfigStruct" type="struct" persistent="false";
	property name="hqlParams" type="struct" persistent="false";
	property name="hqlAliases" type="struct" persistent="false";
	property name="ignorePeriodInterval" type="boolean" persistent="false" default="false";

	property name="records" type="array" persistent="false";
	property name="pageRecords" type="array" persistent="false";

	property name="recordsCountData" persistent="false"; 

	property name="aggregations" type="struct" persistent="false";

	property name="keywords" type="string" persistent="false";
	property name="keywordArray" type="array" persistent="false";
	property name="splitKeywords" type="boolean" persistent="false" default="1";

	property name="aggregateFilters" type="array" persistent="false";
	property name="postFilterGroups" type="array" singularname="postFilterGroup"  persistent="false" hint="where conditions that are added by the user through the UI, applied in addition to the collectionConfig.";
	property name="postOrderBys" type="array" persistent="false" hint="order bys added by the use in the UI, applied/override the default collectionConfig order bys";

	property name="pageRecordsStart" persistent="false" type="numeric" hint="This represents the first record to display and it is used in paging.";
	property name="pageRecordsShow" persistent="false" type="numeric" hint="This is the total number of entities to display";
	property name="currentURL" persistent="false" type="string";
	property name="currentPageDeclaration" persistent="false" type="string";

	property name="nonPersistentColumn" type="boolean" persistent="false";
	property name="processContext" type="string" persistent="false";
	property name="processObjectArray" type="array" persistent="false";
	property name="cacheable" type="boolean" persistent="false";
	property name="cacheName" type="string" persistent="false";
	property name="savedStateID" type="string" persistent="false";
	property name="collectionEntityObject" type="any" persistent="false";
	property name="hasAggregate" type="boolean" persistent="false";
	property name="hasManyRelationFilter" type="boolean" persistent="false";
	property name="enforceAuthorization" type="boolean" persistent="false" default="true";
	property name="authorizedProperties" singularname="authorizedProperty" type="array" persistent="false";
	property name="filterByLeafNodesFlag" type="boolean" persistent="false" default="0";
	property name="filterByNonLeafNodesFlag" type="boolean" persistent="false" default="0";
	property name="filterGroupAliasMap" type="struct" persistent="false";
	property name="excludeOrderBy" type="boolean" persistent="false" default="0";
	property name="permissionAppliedFlag" type="boolean" persistent="false" default="0";
	property name="appliedRelatedFilters" type="struct" persistent="false";
	property name="permissionAliasMap" type="struct" persistent="false";
	property name="checkDORPermissions" type="boolean" persistent="false";
	//used to define who is requesting data
	property name="requestAccount" type="any" persistent="false";
	property name="filterDataApplied" type="boolean" persistent="false" default="0";
	property name="applyOrderBysToGroupBys" type="boolean" persistent="false" default="1";

	property name="parentFilterMerged" type="boolean" persistent="false" default="false";
	property name="groupBys" type="string" persistent="false";

	property name="mergeCollectionOptions" persistent="false";

	//property name="entityNameOptions" persistent="false" hint="an array of name/value structs for the entity's metaData";
	property name="collectionConfigErrorMessageDetail" persistent="false";
	property name="collectionObjectOptions" persistent="false";
	property name="totalAvgAggregates" persistent="false" type="array";
	property name="totalSumAggregates" persistent="false" type="array";

	property name="exportFileName" type="string" persistent="false";
	
	
	

	// ============ START: Non-Persistent Property Methods =================

	public any function init(){
		super.init();

		param name="session.entityCollection" type="struct" default="#structNew()#";
		param name="session.entityCollection.savedStates" type="array" default="#arrayNew(1)#";

		variables.inlistDelimiter = ",";
		variables.totalAvgAggregates = [];
		variables.totalSumAggregates = [];
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
		variables.processObjectArray = [];
		variables.hasAggregate = false;
		variables.hasManyRelationFilter = false;
		variables.aliasMap = {};
		variables.useElasticSearch = false;
		variables.splitKeywords = true;
		variables.dirtyReadFlag = false;
		variables.connection = ormGetSession().connection();
		variables.filterGroupAliasMap = {};
		variables.permissionAliasMap = {};
		variables.checkDORPermissions = false;
		variables.filterDataApplied = false;
		variables.applyOrderBysToGroupBys=true;
		setHibachiCollectionService(getService('hibachiCollectionService'));
		setHibachiService(getService('HibachiService'));
		setHibachiUtilityService(getService('HibachiUtilityService'));

	}
	//if we are public then we can't have an account owner
	public void function setPublicFlag(boolean publicFlagValue){
		if(structKeyExists(arguments,'publicFlagValue')){
			if(arguments.publicFlagValue){
				setAccountOwner(javacast('null',''));
				
			}
			variables.publicFlag = arguments.publicFlagValue;
		}
	}
	//if we have an account owner then we can't be public
	public void function setAccountOwner(any accountOwner){
		if(!structKeyExists(arguments,'accountOwner')){
			structDelete(variables,'accountOwner');
		}else{
			variables.accountOwner = arguments.accountOwner;
			setPublicFlag(false);
		}
	}
	
	
	public void function setInlistDelimiter(delimiter=","){
		variables.inlistDelimiter = arguments.delimiter;
	}
	
	public string function getInlistDelimiter(){
		return variables.inlistDelimiter;
	}
	
	public string function getBaseEntityAlias(){

		if(structKeyExists(variables,'baseEntityAlias')){
			return variables.baseEntityAlias;
		}
		if(!isNull(getCollectionObject())){
			variables.baseEntityAlias = '_'&lcase(getService('hibachiService').getProperlyCasedShortEntityName(getCollectionObject()));
			return variables.baseEntityAlias;
		}
		return "";
	}

	public boolean function isReport(){
		if (isNull(getReportFlag())){
			return false;
		}
		return getReportFlag();
	}
	
	public boolean function getCheckDORPermissions(){
		return variables.checkDORPermissions;
	}

	public void function setCheckDORPermissions(required boolean checkDORPermissionsFlag){
		variables.checkDORPermissions = arguments.checkDORPermissionsFlag;
	}

	public void function setApplyOrderBysToGroupBys(required boolean applyOToGFlag){
		variables.applyOrderBysToGroupBys=arguments.applyOToGFlag;
	}

	public boolean function getApplyOrderBysToGroupBys(){
		return variables.applyOrderBysToGroupBys;
	}

	public void function setFilterByLeafNodesFlag(required boolean value) {
		// Ensures exclusivity so that both types of leaf node filter flags cannot both be true
		if (arguments.value && getFilterByNonLeafNodesFlag()) {
			setFilterByNonLeafNodesFlag(false);
		}
		variables.filterByLeafNodesFlag = arguments.value;
	}

	public void function setFilterByNonLeafNodesFlag(required boolean value) {
		// Ensures exclusivity so that both types of leaf node filter flags cannot both be true
		if (arguments.value && getFilterByLeafNodesFlag()) {
			setFilterByLeafNodesFlag(false);
		}
		variables.filterByNonLeafNodesFlag = arguments.value;
	}

	public void function setFilterDataApplied(required filterDataAppliedflag){
		variables.filterDataApplied = arguments.filterDataAppliedflag;
	}

	public boolean function getFilterDataApplied(){
		return variables.filterDataApplied;
	}

	public boolean function hasFilterDataApplied(){
		return getFilterDataApplied();
	}

	public boolean function getDirtyReadFlag(){
		if(!structKeyExists(variables,'dirtyReadFlag')){
			variables.dirtyReadFlag = false;
		}
	
		if(!hasApplicationValue('databaseType') || getApplicationValue('databaseType') == "Oracle10g"){
			return false;
		}
		return variables.dirtyReadFlag;
	}

	public void function setDirtyReadFlag(required boolean flagValue){
		if(!hasApplicationValue('databaseType') || getApplicationValue('databaseType') == "Oracle10g"){
			variables.dirtyReadFlag = false;
		}else{
			variables.dirtyReadFlag = arguments.flagValue;
		}
	}

	public any function getRequestAccount(){
		if(!structKeyExists(variables,'requestAccount') && !isNull(getHibachiScope().getAccount())){
			variables.requestAccount = getHibachiScope().getAccount();
		}
		return variables.requestAccount;
	}

	public any function duplicateCollection(){
		var duplicateCollection = getService('hibachiService').getCollectionList(getCollectionObject());
		duplicateCollection.setInlistDelimiter(getInlistDelimiter());
		duplicateCollection.setCollectionConfig(getCollectionConfig());
		duplicateCollection.setCollectionConfigStruct(duplicate(getCollectionConfigStruct()));
		duplicateCollection.clearVariablesKey('groupbys');
		structDelete(duplicateCollection.getCollectionConfigStruct(),'groupBys');
		return duplicateCollection;
	}

	public void function setRequestAccount(required any requestAccount){
		variables.requestAccount = arguments.requestAccount;
	}


	public void function setParentCollection(required any parentCollection){
		if(getNewFlag()){
			var parentCollectionConfigStruct = Duplicate(arguments.parentCollection.getCollectionConfigStruct());
			parentCollectionConfigStruct['filterGroups'] = [{}];
			parentCollectionConfigStruct['filterGroups'][1]['filterGroup'] = [];
			setCollectionConfig(serializeJson(parentCollectionConfigStruct));
		}

		variables.parentCollection = arguments.parentCollection;
	}

	public array function getAuthorizedProperties(){
		if(!structKeyExists(variables,'authorizedProperties')){
			variables.authorizedProperties = [];
		}
		return variables.authorizedProperties;
	}

	public void function setAuthorizedProperties(required array authorizedProperties){
		variables.authorizedProperties = arguments.authorizedProperties;
	}

	public void function addAuthorizedProperty(required string authorizedProperty){
		if(listLen(arguments.authorizedProperty,'.') > 1){
			arguments.authorizedProperty = convertPropertyIdentifierToAlias(arguments.authorizedProperty);
		}
		if(!hasAuthorizedProperty(arguments.authorizedProperty)){
			arrayAppend(getAuthorizedProperties(),authorizedProperty);
		}
	}

	public boolean function hasAuthorizedProperty(required string authorizedProperty){
		return arrayFind(getAuthorizedProperties(),authorizedProperty);
	}

	public void function setFilterAggregates(required struct aggregations){
		variables.filterAggregates = arguments.aggregations;
	}

	public struct function getFilterAggregates(){
		if(!structKeyExists(variables,'filterAggregates')){
			if(
				getUseElasticSearch() && hasService('elasticSearchService')
			){

				getService('elasticSearchService').getFilterAggregates(this);
			}
		}
		return variables.filterAggregates;
	}

	public any function getCollectionEntityObject(){
		if(!structKeyExists(variables,'collectionEntityObject')){
			if(!isNull(getCollectionObject())){
				variables.collectionEntityObject = getService('hibachiService').getEntityObject(getCollectionObject());
			}else{
				return;
			}
		}
		return variables.collectionEntityObject;
	}

	public string function getAlias(required string propertyIdentifier){
		var alias = "";

		if(
			structKeyExists(getService('HibachiCollectionService').getAliasMap(),getCollectionObject())
			&& structKeyExists(getService('HibachiCollectionService').getAliasMap()[getCollectionObject()],arguments.propertyIdentifier)
		){
			alias = getService('HibachiCollectionService').getAliasMap()[getCollectionObject()][arguments.propertyIdentifier];
		}
		return alias;
	}

	public numeric function getFilterGroupIndexByFilterGroupAlias(required string filterGroupAlias, required string filterGroupLogicalOperator="AND"){
 		if(!hasFilterGroupByFilterGroupAlias(arguments.filterGroupAlias)){
 			variables.filterGroupAliasMap[filterGroupAlias] = addFilterGroupWithAlias(arguments.filterGroupAlias, arguments.filterGroupLogicalOperator);
 		}
 		return variables.filterGroupAliasMap[filterGroupAlias];
 	}

 	public boolean function hasFilterGroupByFilterGroupAlias(required string filterGroupAlias){
 		//check if it has been mapped
 		if(structKeyExists(variables.filterGroupAliasMap, arguments.filterGroupAlias)){
 			return true;
 		}
 		//if not found right away check manually
 		var filterGroupIndex = 1;
 		for(var filterGroup in getCollectionConfigStruct()['filterGroups']){
 			if(
 				structKeyExists(filterGroup,'filterGroupAlias')
 				&& filterGroup.filterGroupAlias == arguments.filterGroupAlias
 			){
 				variables.filterGroupAliasMap[filterGroupAlias]=filterGroupIndex;
 				return true;
 			}
 			filterGroupIndex++;
 		}
 		return false;
 	}

 	public numeric function addFilterGroupWithAlias(required string filterGroupAlias, required string filterGroupLogicalOperator){
 		var collectionConfig = this.getCollectionConfigStruct();
 		var newFilterGroup = {"filterGroup"=[]};
 		if(ArrayLen(collectionConfig['filterGroups']) >= 1){
 			newFilterGroup["logicalOperator"] = arguments.filterGroupLogicalOperator;
 			newFilterGroup["filterGroupAlias"] = arguments.filterGroupAlias;
 		}
 		ArrayAppend(collectionConfig['filterGroups'], newFilterGroup);
 		this.setCollectionConfigStruct(collectionConfig);
 		return ArrayLen(collectionConfig['filterGroups']);
 	}

 	public string function getPropertyIdentifierAlias(required string propertyIdentifier, aliastype="filter"){
 		if(findNoCase('(',arguments.propertyIdentifier)){
 			return propertyIdentifier;
 		}
 		var cacheKey = 'getPropertyIdentifierAlias'&arguments.propertyIdentifier&arguments.aliastype;
 		//check if the propertyIdentifier has base alias aready and strip it
 		var alias = getBaseEntityAlias();
 		var propertyIdentifierAliasData = getCollectionCacheValue(cacheKey);

 		if(isNull(propertyIdentifierAliasData)){
 			propertyIdentifierAliasData = {
				joins=[],
				hasManyRelationFilter=false,
				'_propertyIdentifier'=""
			};

			arguments.propertyIdentifier = convertAliasToPropertyIdentifier(arguments.propertyIdentifier);

	 		var _propertyIdentifier = '';
			var propertyIdentifierParts = ListToArray(arguments.propertyIdentifier, '.');
			var current_object = getService('hibachiService').getPropertiesStructByEntityName(getCollectionObject());

			for (var i = 1; i <= arraylen(propertyIdentifierParts); i++) {
				if(structKeyExists(current_object, propertyIdentifierParts[i]) && structKeyExists(current_object[propertyIdentifierParts[i]], 'cfc')){
					if(
						(
							arguments.aliastype=='filter'
							&& structKeyExists(current_object[propertyIdentifierParts[i]], 'singularname')
						)
						|| (
							arguments.aliastype=='column'
							&& !getService('HibachiService').getPropertyIsObjectByEntityNameAndPropertyIdentifier(getCollectionObject(),convertAliasToPropertyIdentifier(arguments.propertyIdentifier))
							&& structKeyExists(current_object[propertyIdentifierParts[i]], 'fieldtype')
							&& current_object[propertyIdentifierParts[i]].fieldtype neq 'id'
						)
					){
						//addGroupBy(alias);
						propertyIdentifierAliasData.hasManyRelationFilter=true;
					}
					current_object = getService('hibachiService').getPropertiesStructByEntityName(current_object[propertyIdentifierParts[i]]['cfc']);
					_propertyIdentifier &= '_' & propertyIdentifierParts[i];
					var join = {
						'associationName' = RemoveChars(rereplace(_propertyIdentifier, '_([^_]+)$', '.\1' ),1,1),
						'alias' = alias & _propertyIdentifier
					};
					addJoin(join);
					arrayAppend(propertyIdentifierAliasData.joins,join);
				}else{
					_propertyIdentifier &= '.' & propertyIdentifierParts[i];
				}
			}

			propertyIdentifierAliasData['_propertyIdentifier'] = _propertyIdentifier;
 			setCollectionCacheValue(cacheKey,propertyIdentifierAliasData);
 		}

	    if(isNull(getHasManyRelationFilter()) || !getHasManyRelationFilter()) {
		    setHasManyRelationFilter(propertyIdentifierAliasData.hasManyRelationFilter);
	    }
		for(var join in propertyIdentifierAliasData.joins){
			addJoin(join);
		}

		return alias & propertyIdentifierAliasData._propertyIdentifier;
 	}


	public void function addFilterAggregate(
		required string filterAggregateName,
		required string propertyIdentifier,
		required string value,
		string comparisonOperator="=",
		boolean hidden=true

	){
		var collectionConfigStruct = this.getCollectionConfigStruct();

		var alias = getBaseEntityAlias();

		if(!structKeyExists(collectionConfigStruct,'filterGroups')){
			collectionConfigStruct["filterGroups"] = [{"filterGroup"=[]}];
		}

		var propertyIdentifierAlias = getPropertyIdentifierAlias(arguments.propertyIdentifier);
		var ormtype = getOrmTypeByPropertyIdentifier(arguments.propertyIdentifier);
		//create filter Group
		var filterAggregate = {
			"filterAggregateName" = arguments.filterAggregateName,
			"propertyIdentifier" = propertyIdentifierAlias,
			"comparisonOperator" = arguments.comparisonOperator,
			"value" = arguments.value,
			"hidden"=arguments.hidden
		};
		if(len(ormtype)){
			filter['ormtype']= ormtype;
		}

		if(!structKeyExists(collectionConfigStruct,'filterAggregates')){
			collectionConfigStruct.filterAggregates = [];
		}

		arrayAppend(collectionConfigStruct.filterAggregates,filterAggregate);
	}

	public any function getCollectionCacheValue(required string cacheKey){
		if(!structKeyExists(getService('HibachiCollectionService').getCollectionCache(),getCollectionObject())){
			getService('HibachiCollectionService').getCollectionCache()[getCollectionObject()] = {};
		}
		if(structKeyExists(getService('HibachiCollectionService').getCollectionCache()[getCollectionObject()],cacheKey)){
			return getService('HibachiCollectionService').getCollectionCache()[getCollectionObject()][cacheKey];
		}
	}

	public void function setCollectionCacheValue(required string cacheKey, any value){
		if(!structKeyExists(getService('HibachiCollectionService').getCollectionCache(),getCollectionObject())){
			getService('HibachiCollectionService').getCollectionCache()[getCollectionObject()] = {};
		}

		getService('HibachiCollectionService').getCollectionCache()[getCollectionObject()][cacheKey] = arguments.value;

	}

	//add Filter
	public void function addFilter(
		required string propertyIdentifier,
		required any value,
		string comparisonOperator="=",
		string logicalOperator="AND",
	    string aggregate="",
	    string filterGroupAlias="",
 		string filterGroupLogicalOperator="AND",
 		boolean hidden=true
	){

		var propertyIdentifierAlias = getPropertyIdentifierAlias(arguments.propertyIdentifier);

		var collectionConfig = this.getCollectionConfigStruct();
		if(!structKeyExists(collectionConfig,'filterGroups')){
			collectionConfig["filterGroups"] = [{"filterGroup"=[]}];
		}

		var filterGroupIndex = 1;
 		if(len(arguments.filterGroupAlias) > 0){
 			filterGroupIndex = this.getFilterGroupIndexByFilterGroupAlias(arguments.filterGroupAlias, arguments.filterGroupLogicalOperator);
 		}

		var alias = getBaseEntityAlias();

		var ormtype = getOrmTypeByPropertyIdentifier(arguments.propertyIdentifier);

		//create filter Group
		var filter = {
			"propertyIdentifier" = propertyIdentifierAlias,
			"comparisonOperator" = arguments.comparisonOperator,
			"value" = arguments.value,
			"hidden"=arguments.hidden
		};
		if(len(ormtype)){
			filter['ormtype']= ormtype;
		}


		if(len(aggregate)){
			filter["aggregate"] = aggregate;
			setHasAggregate(true);
		}


		//check if the propertyKey is an attribute
		var hasAttribute = getService('hibachiService').getHasAttributeByEntityNameAndPropertyIdentifier(
			entityName=getService('hibachiService').getProperlyCasedFullEntityName(getCollectionObject()),
			propertyIdentifier=arguments.propertyIdentifier
		);
		//if so then add attribute details
		if(!getService('hibachiService').getHasPropertyByEntityNameAndPropertyIdentifier(getCollectionObject(),arguments.propertyIdentifier) && hasAttribute){
			filter['attributeID'] = getService("attributeService").getAttributeByAttributeCode( listLast(arguments.propertyIdentifier,'.')).getAttributeID();
			filter['attributeSetObject'] = getLastEntityNameInPropertyIdentifier(
				propertyIdentifier=arguments.propertyIdentifier
			);
		}


		//if we already have a filter group then we need a logicalOperator
		if(arraylen(collectionConfig['filterGroups'][filterGroupIndex]['filterGroup'])){
			filter["logicalOperator"]=arguments.logicalOperator;
		}

 		arrayAppend(getCollectionConfigStruct()['filterGroups'][filterGroupIndex]['filterGroup'],filter);


	}

	public void function setDisplayProperties(string displayPropertiesList="", struct columnConfig = {}){


		var collectionConfig = this.getCollectionConfigStruct();
		collectionConfig["columns"] = [];
		this.setCollectionConfigStruct(collectionConfig);


		var displayProperties = listToArray(arguments.displayPropertiesList);
		for(var displayProperty in displayProperties){
			addDisplayProperty(displayProperty=displayProperty.trim(), columnConfig=columnConfig);
		}

	}

	public void function addGroupBy(required string groupByAlias){
		var collectionConfig = this.getCollectionConfigStruct();
		var groupBys = listToArray(arguments.groupByAlias);
		var groupByList = "";
		for(var groupBy in groupBys){
			groupByList = listAppend(groupByList,getPropertyIdentifierAlias(groupBy));
		}
		if(!structKeyExists(collectionConfig,'groupBys') || !len(collectionConfig['groupBys'])){
			collectionConfig["groupBys"] = groupByList;
		}
		if(ListContains(collectionConfig.groupBys,groupByList) == 0){
			listAppend(collectionConfig.groupBys,groupByList);
		}
		this.setCollectionConfigStruct(collectionConfig);
	}

	public void function setDistinct(required boolean isDistinct){
		var collectionConfig = this.getCollectionConfigStruct();
		collectionConfig["isDistinct"] = arguments.isDistinct;
		this.setCollectionConfigStruct(collectionConfig);
	}

	public void function addDisplayProperty(required string displayProperty, string title, struct columnConfig = {}, boolean prepend=false){
		var collectionConfig = this.getCollectionConfigStruct();

		var cacheKey = 'addDisplayProperty'&hash(serializeJson(arguments),'md5');
		var column = getCollectionCacheValue(cacheKey);
		if(isNull(column)){

			column = {};

			if(find('|', arguments.displayProperty)){
				column['alias'] = listLast(arguments.displayProperty, '|');
				arguments.displayProperty = listFirst(arguments.displayProperty, '|');
			}

			column["propertyIdentifier"]=arguments.displayProperty;

			//check if the propertyKey is an attribute
			var hasAttribute = getService('hibachiService').getHasAttributeByEntityNameAndPropertyIdentifier(
				entityName=getService('hibachiService').getProperlyCasedFullEntityName(getCollectionObject()),
				propertyIdentifier=arguments.displayProperty
			);
			//if so then add attribute details
			if(!hasPropertyByPropertyIdentifier(arguments.displayProperty) && hasAttribute){
				column['attributeID'] = getService("attributeService").getAttributeByAttributeCode( listLast(arguments.displayProperty,'.')).getAttributeID();

				var attributeSetObject = getLastEntityNameInPropertyIdentifier(arguments.displayProperty);
				column['attributeSetObject'] = lcase(left(attributeSetObject,1))&right(attributeSetObject,len(attributeSetObject)-1);
			}else{
				column['propertyIdentifier'] = getBaseEntityAlias() & '.' & arguments.displayProperty;
				//if the property non-persistent?
				if(!getService('hibachiService').getPropertyIsPersistentByEntityNameAndPropertyIdentifier(getCollectionObject(),arguments.displayProperty)){
					column['persistent'] = false;
				}
				var ormtype = getCollectionEntityObject().getOrmTypeByPropertyIdentifier(arguments.displayProperty);
				if(len(ormtype)){
					column['ormtype'] = ormtype;
				}

				column['type'] = getCollectionEntityObject().getFormatTypeByPropertyIdentifier(arguments.displayProperty);
			}

			if(structKeyExists(arguments, 'title')){
				column['title'] = arguments.title;
			}else{
				column['title'] = getCollectionEntityObject().getTitleByPropertyIdentifier(arguments.displayProperty);
			}

			column["propertyIdentifier"] =  getHibachiService().getProperlyCasedPropertyIdentifier(getCollectionObject(),column["propertyIdentifier"]);

			setCollectionCacheValue(cacheKey,column);
		}

		addColumn(column,arguments.prepend,arguments.columnConfig);
		//backend should Automatically Authorize
		addAuthorizedProperty(convertPropertyIdentifierToAlias(column['propertyIdentifier']));
	}

	public void function addColumn(required column, boolean prepend=false, struct columnConfig = {}){
		var collectionConfig = this.getCollectionConfigStruct();
		if(!structKeyExists(collectionConfig,'columns')){
			collectionConfig["columns"] = [];
		}

		arguments.column['isDeletable'] = false;
		arguments.column['isVisible'] = false;
		arguments.column['isSearchable'] = false;
		arguments.column['isExportable'] = false;
		if(structKeyExists(arguments.columnConfig, 'isDeletable')){
			arguments.column['isDeletable'] = arguments.columnConfig['isDeletable'];
		}
		if(structKeyExists(arguments.columnConfig, 'isVisible')){
			arguments.column['isVisible'] = arguments.columnConfig['isVisible'];
		}
		if(structKeyExists(arguments.columnConfig, 'isSearchable')){
			arguments.column['isSearchable'] = arguments.columnConfig['isSearchable'];
		}
		if(structKeyExists(arguments.columnConfig, 'isExportable')){
			arguments.column['isExportable'] = arguments.columnConfig['isExportable'];
		}
		if(structKeyExists(arguments.columnConfig, 'tdclass')){
			arguments.column['tdclass'] = arguments.columnConfig['tdclass'];
		}
		//isMetric, isPeriod used if isReport() true
		if(structKeyExists(arguments.columnConfig,'isMetric')){
			arguments.column['isMetric']=arguments.columnConfig['isMetric'];
		}
		if(structKeyExists(arguments.columnConfig,'isPeriod')){
			arguments.column['isPeriod']=arguments.columnConfig['isPeriod'];
		}
		
		if(structKeyExists(arguments.columnConfig,'isDistinct')){
			arguments.column['isDistinct']=arguments.columnConfig['isDistinct'];
		}

		if(arguments.prepend){
			arrayPrepend(collectionConfig.columns,arguments.column);
		}else{
			arrayAppend(collectionConfig.columns,arguments.column);
		}

		this.setCollectionConfigStruct(collectionConfig);
	}

	//add display Aggregate
	public void function addDisplayAggregate(required string propertyIdentifier, required string aggregateFunction, required string aggregateAlias, boolean isDistinct, struct columnConfig = {}){
		var collectionConfig = this.getCollectionConfigStruct();
		var alias = getBaseEntityAlias();
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

		if(structKeyExists(arguments,'isDistinct')){
			column.isDistinct = arguments.isDistinct;
		}

		var isObject= getService('hibachiService').getPropertyIsObjectByEntityNameAndPropertyIdentifier(
			getService('hibachiService').getProperlyCasedFullEntityName(getCollectionObject()),arguments.propertyIdentifier);

		if(isObject){
			//check if count is on a one-to-many
			var lastEntityName = getLastEntityNameInPropertyIdentifier(arguments.propertyIdentifier);
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
		this.addColumn(column=column,columnConfig=arguments.columnConfig);
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
			if (lcase(direction) != "asc" && lcase(direction) != "desc"){
				direction = "ASC"; //Default to ASC if the user is passing in something abnormal.
			}
		}

		var propertyIdentifierAlias = getPropertyIdentifierAlias(propertyIdentifier);
		if(isAggregateFunction(propertyIdentifier)){
			propertyIdentifierAlias = propertyIdentifier;
		}

		var orderByExists=false;// variable used as flag to mark if new propertyIdentifier already exists or not
		//identify duplicates
		for(var orderBy in collectionConfig.orderBy){
			if(	orderBy.propertyIdentifier == propertyIdentifierAlias ){
				orderBy.direction = direction;
				orderByExists = true;
			}
		}
		if(!orderByExists){
			var orderBy = {
				"propertyIdentifier"= propertyIdentifierAlias,
				"direction"=direction
			};
			//Checks that the property identifier being passed in exists.
			if (hasPropertyByPropertyIdentifier(orderBy.propertyIdentifier)){
				arrayAppend(collectionConfig.orderBy,orderBy); //|[{direction={asc},propertyIdentifier={_product.productName}}]
			}else{
				throw("That was an invalid property identifier!");
	
			}

		}
		this.setCollectionConfigStruct(collectionConfig);
	}

	public array function getOrderBys(){
		var collectionConfig = this.getCollectionConfigStruct();
		if(!structKeyExists(collectionConfig, 'orderBy')){
			collectionConfig["orderBy"] = [];
		}
		return collectionConfig.orderBy;
	}

	public void function removeOrderBy(string orderByString){
		var propertyIdentifierArray = ListToArray(orderByString, "|");
		var calculatedPropertyIdentifier = propertyIdentifierArray[1];
		var orderByArray = getCollectionConfigStruct().orderBy;
		var i = 1;

		for (var arrayElement in orderByArray){
		 var propertyIdentifier = arrayElement.propertyIdentifier;
		 var aliasedPropertyIdentifier = convertPropertyIdentifierToAlias(propertyIdentifier);
			if(aliasedPropertyIdentifier == calculatedPropertyIdentifier){
			 arrayDeleteAt(orderByArray, i);
			 getCollectionConfigStruct().orderBy = orderByArray;
			 break;
			}
		i++;
		}
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

//	see hibachicollection service for list of all params
	public string function buildUrl(){
		return getHibachiCollectionService().buildUrl(argumentCollection=arguments);
	}

	/**
		Examples of each type of filter:
		?p:show=50
		?p:current=1
		?r:calculatedsaleprice=20^50
		?r:calculatedSalePrice=^50 (does 0 to 50)
		?r:calculatedSalePrice=50^ (does more than 50 to 10000)
		?f:accountName:eq=someName  - adds the filter.
		?fr:accountName:eq=someName - removes the filter
		?orderby=someKey|direction
		?orderBy=someKey|direction,someOtherKey|direction ...

		Using coldfusion operator versions - gt,lt,gte,lte,eq,neq,like

	*/
	public void function applyData(required any data=url, string excludesList=""){
		getHibachiCollectionService().applyData(this,arguments.data,arguments.excludesList);
	}

	public boolean function getPropertyIdentifierIsPersistent(required string propertyIdentifier){
		return getService('HibachiService').getPropertyIsPersistentByEntityNameAndPropertyIdentifier(getCollectionObject(),arguments.propertyIdentifier);
	}

	public string function getOrmTypeByPropertyIdentifier(required string propertyIdentifier){
		if(!isNull(getCollectionEntityObject())){
			return getCollectionEntityObject().getOrmTypeByPropertyIdentifier(arguments.propertyIdentifier);
		}
		return '';
	}

	public string function getFormatTypeByPropertyIdentifier(required string propertyIdentifier){
		if(!isNull(getCollectionEntityObject())){
			return getCollectionEntityObject().getFormatTypeByPropertyIdentifier(arguments.propertyIdentifier);
		}
		return 'none';
	}

	public void function setCollectionObject(required string collectionObject, boolean addDefaultColumns=true){
		var HibachiBaseEntity = "";
		HibachiBaseEntity = getService("hibachiService").getProperlyCasedShortEntityName(arguments.collectionObject);

		variables.collectionObject = HibachiBaseEntity;
		if(variables.collectionConfig == '{}' ){
			var columnsArray = [];
			
			//check to see if we are supposed to add default columns
			if(addDefaultColumns){
					
				var cacheKey = 'defaultColumns' & arguments.collectionObject & '#getReportFlag()#';
				var cachedColumnsArray = getCollectionCacheValue(cacheKey);
					
				if(isNull(cachedColumnsArray)){
					//get default columns
					var newEntity = getService("hibachiService").getServiceByEntityName(arguments.collectionObject).invokeMethod("new#arguments.collectionObject#");
					var defaultProperties = "";
					if(getReportFlag()){
						defaultProperties  = newEntity.getDefaultCollectionReportProperties();
					}else{
						defaultProperties = newEntity.getDefaultCollectionProperties();
					}
					
					//loop through all defaultProperties
					for(var defaultProperty in defaultProperties){
						var columnStruct = {};
						columnStruct['propertyIdentifier'] = '_' & lcase(getService('hibachiService').getProperlyCasedShortEntityName(arguments.collectionObject)) & '.' & defaultProperty.name;
	
						columnStruct['title'] = newEntity.getTitleByPropertyIdentifier(defaultProperty.name);
						//if propertyKey is a primary id, hide it and make it so it can't be deleted
						if(structKeyExists(defaultProperty,"fieldtype") && defaultProperty.fieldtype == 'id' && !isReport()){
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
							columnStruct['type'] = defaultProperty.fieldtype;
						}
						if(structKeyExists(defaultProperty,"hb_formatType")){
							columnStruct['type'] = defaultProperty.hb_formatType;
						}
						if(structKeyExists(defaultProperty,"hb_displayType")){
							columnStruct['type'] = defaultProperty.hb_displayType;
						}
						if(!structKeyExists(columnStruct,'type')){
							columnStruct['type'] = 'none';
						}

						arrayAppend(columnsArray,columnStruct);
					}
					setCollectionCacheValue(cacheKey,columnsArray);
				}else{
					columnsArray = cachedColumnsArray;
				}
					
			}

			var columnsJson = serializeJson(columnsArray);

			var properlyCasedShortEntityName = lcase(getService('hibachiService').getProperlyCasedShortEntityName(arguments.collectionObject));
			var defaultCollectionConfig = '{
				"baseEntityName":"#HibachiBaseEntity#",
				"baseEntityAlias":"_#properlyCasedShortEntityName#",
				"columns":#columnsJson#,
				"filterGroups":[{"filterGroup":[]}]
			}';
			variables.collectionConfig = defaultCollectionConfig;
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

	public void function addJoin(required any join){


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
			ArrayPrepend(getCollectionConfigStruct().joins,arguments.join);
		}
		getCollectionConfigStruct().joins = getService('hibachiUtilityService').arrayOfStructsSort(getCollectionConfigStruct().joins,'alias','asc');

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
			if (getSplitKeywords() == true) {
				variables.keywordArray = ListToArray(getKeywords(), ' ');
			} else {
				variables.keywordArray = [getKeywords()];
			}
		}
		return variables.keywordArray;
	}

	public void function addPostOrderBy(required any postOrderBy){
		arrayAppend(variables.postOrderBys, arguments.postOrderBy);
	}

	//GETTER FUNCTIONS
	//limiting return values to prevent ORM injection
	private string function getAggregateHQL(required any column){
	
		setHasAggregate(true);
		var aggregateFunction = '';

		switch(lCase(arguments.column.aggregate.aggregateFunction)){

			case "count":
				aggregateFunction = "COUNT";
			break;
			case "avg":
			case "average":
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

		getPropertyIdentifierAlias(arguments.column.propertyIdentifier);
		if(aggregateFunction != 'COUNT'){
			return " #aggregateFunction#(COALESCE(#arguments.column.propertyIdentifier#,0)) as #arguments.column.aggregate.aggregateAlias#";
		}else{

			var distinct = "";
			if(aggregateFunction == 'COUNT'){
				var isObject = getService('hibachiService').getPropertyIsObjectByEntityNameAndPropertyIdentifier(getCollectionObject(),convertAliasToPropertyIdentifier(arguments.column.propertyIdentifier));
				//when doing a count on objects it is important to inlcude that it is Distinct
	//			 however if we are doing a query like
	//			SELECT firstName,count(firstName) FROM swaccount
	//			group by firstName
	//			then distinct doesn't make sense because we want to know how many people of each name by string and not object count
	//			TODO: to support this level of reporting on the colleciton UI we will need to enable removal of id from collections
	//			and hide the show/edit button therefore there will be two types of collections report collection and entity collection

				var isDistinct = isObject;

				if(structKeyExists(column,'isDistinct')){
					isDistinct = column.isDistinct;
				}

				if( isDistinct){
					distinct = 'DISTINCT';
				}else{
					setExcludeOrderBy(false);
				}
			}
			return " #aggregateFunction#(#distinct# #arguments.column.propertyIdentifier#) as #arguments.column.aggregate.aggregateAlias#";
		}


	}

	public any function getCacheName() {
		//If this is cacheable then check if the cachename has been set...
		if (getCacheable()){
			if (!structKeyExists(variables, "cacheName")){

				// Take the stateStruct, serialize it, and turn that list it into a an array
				var valueArray = listToArray(serializeJSON(getStateStruct()));

				// Sort the array so that the values always end up the same
				arraySort(valueArray,"text");

				// Turn the array back into a list, lcase, and hash for the name
				variables.cacheName = hash(lcase(arrayToList(valueArray,",")));
			}
			return variables.cacheName;
		}
		return "";
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
			case "&gt;":
				return ">";
			break;
			case "<":
			case "&lt;":
				return "<";
			break;
			case "<=":
			case "&lt;=":
				return "<=";
			break;
			case ">=":
			case "&gt;=":
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

	public boolean function isAggregateFunction(required string propertyIdentifier){
		return refindNoCase('^(count|sum|avg|min|max)\(', propertyIdentifier);
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
			ArrayAppend(baseCollection[i].filterGroup, currentCollection[i].filterGroup, true);
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

	private void function mergeParentCollectionFilters(){
		if(variables.parentFilterMerged){
			return;
		}
		var parentCollectionStruct = this.getParentCollection().getCollectionConfigStruct();
		if(isnull(parentCollectionStruct['filterGroups']) || !arraylen(parentCollectionStruct['filterGroups'])){
			return;
		}

		var finalFilterGroups = [];
		var filterGroupArray = getFilterGroupArrayFromAncestors(this);

		if(arraylen(parentCollectionStruct['filterGroups']) == 1){
			arrayAppend(finalFilterGroups, { "filterGroup" =  parentCollectionStruct['filterGroups'][1].filterGroup});
		}else{
			arrayAppend(finalFilterGroups, { "filterGroup" =  parentCollectionStruct['filterGroups']});
		}

		if(arraylen(filterGroupArray)){
			if(arraylen(filterGroupArray) == 1){
				arrayAppend(finalFilterGroups, { "filterGroup" =  filterGroupArray[1].filterGroup , "logicalOperator" = "AND"});
			}else{
				arrayAppend(finalFilterGroups, { "filterGroup" =  filterGroupArray, "logicalOperator" = "AND"});
			}
		}

		this.getCollectionConfigStruct()['filterGroups'] = finalFilterGroups;
		if(structKeyExists(parentCollectionStruct, 'joins')){
			this.mergeJoins(parentCollectionStruct.joins);
		}
		variables.parentFilterMerged = true;
	}

	public array function getFilterGroupArrayFromAncestors(required any collectionEntity){
		var collectionConfig = arguments.collectionEntity.getCollectionConfigStruct();
		var filterGroupArray = [];
		if(structKeyExists(collectionConfig,'filterGroups') && !isnull(collectionConfig['filterGroups']) && arraylen(collectionConfig['filterGroups'])){
			filterGroupArray = collectionConfig['filterGroups'];
		}
		return filterGroupArray;
	}

	public void function removeFilter(
		string propertyIdentifier,
		any value,
		string comparisonOperator,
		string logicalOperator,
		array filterGroup,
		numeric filterGroupIndex=1
	) {
		//first do we have filters?
		if(arraylen(collectionConfigStruct['filterGroups'])){
			//filterGroupName is used to navigate a filtergroup path. If not specified we can assume there is only the base filterGroup.
			var selectedFilterGroup = [];

			if(isNull(arguments.filterGroupIndex)){
				arguments.filterGroupIndex=1;
			}

			if(!structKeyExists(arguments,'filterGroup')){
				selectedFilterGroup = getCollectionConfigStruct()['filterGroups'][arguments.filterGroupIndex].filterGroup;
			}

			var filterGroupCount = arraylen(selectedFilterGroup);
			for(var i=filterGroupCount; i >= 1; i--){
				var filter = selectedFilterGroup[i];
				var isRemovable = true;
				if(structKeyExists(arguments,'propertyIdentifier')){

					if(getPropertyIdentifierAlias(filter.propertyIdentifier) != getPropertyIdentifierAlias(arguments.propertyIdentifier)){
						isRemovable = false;
					}
				}

				if(structKeyExists(arguments,'comparisonOperator')){
					if(filter.comparisonOperator != arguments.comparisonOperator){
						isRemovable = false;
					}
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
					getCollectionConfigStruct()['filterGroups'][arguments.filterGroupIndex].filterGroup = selectedFilterGroup;
				}
			}
		}
	}

	public boolean function hasFilterByFilterGroup(required any filter, required array filterGroup){

		for(var thisFilter in arguments.filterGroup){
			if(
				getPropertyIdentifierAlias(thisFilter.propertyIdentifier) == getPropertyIdentifierAlias(arguments.filter.propertyIdentifier)
				&& thisFilter.comparisonOperator == arguments.filter.comparisonOperator
				&& thisFilter.value == arguments.filter.value
			){
				return true;
			}
		}
		return false;
	}


	private string function getFilterGroupHQL(required array filterGroup){
		var filterGroupHQL = '';
		//reverse to preserve logicalOperator ordering when looping  by decrementing
		var reverseFilterGroup = getHibachiUtilityService().arrayReverse(arguments.filterGroup);
		//decrement looping to remove invalid filters in order to identify the which one is first
		for(var i=arraylen(reverseFilterGroup);i > 0;i--){
			var filter = reverseFilterGroup[i];
			//add propertyKey and value to HQLParams
			//if using a like parameter we need to add % to the value using angular
			var logicalOperator = '';
			if(i != arrayLen(reverseFilterGroup)){
				if(structKeyExists(filter,"logicalOperator") && len(filter.logicalOperator)){
					logicalOperator = filter.logicalOperator;
				}else{
					logicalOperator = 'AND';
				}
			}
			if(!isnull(filter.collectionID) || !isNull(filter.collection)){
				filterGroupHQL &=  " #logicalOperator# #getHQLForCollectionFilter(filter)# ";
			}else {

				//check filter is a nested filterGroup or a filter itself
				if (structKeyExists(filter, "filterGroup")) {

					filterGroupHQL &= " #logicalOperator# #getFilterGroupsHQL([filter])#" ;
				} else {

					if(structKeyExists(filter,'comparisonOperator') && len(filter.comparisonOperator)){
						var comparisonOperator = getComparisonOperator(filter.comparisonOperator);


						if (structKeyExists(filter, 'aggregate') && isnull(filter.attributeID)){
							addAggregateFilter(filter);
							arrayDeleteAt(reverseFilterGroup,i);
							continue;
						}

						var predicate = getPredicate(filter);
						if(isnull(filter.attributeID)){
								if(structKeyExists(filter,'propertyIdentifier') && len(filter.propertyIdentifier)){
									var propertyIdentifier = filter.propertyIdentifier;
									getPropertyIdentifierAlias(rereplace(listrest(propertyIdentifier,'_'),'_','.','all'));

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
		var reverseFilterGroup = getHibachiUtilityService().arrayReverse(arguments.filterGroups);
		for(var i=arraylen(reverseFilterGroup);i > 0;i--){
			var filterGroup = reverseFilterGroup[i];
			var logicalOperator = '';
			if(i != arraylen(reverseFilterGroup)){
				if(structKeyExists(filterGroup,'logicalOperator') && len(filterGroup.logicalOperator)){
					logicalOperator = getLogicalOperator(filterGroup.logicalOperator);
				}else{
					logicalOperator = 'AND';
				}
			}
			
			//constuct HQL to be used in filterGroup
			var filterGroupHQL = getFilterGroupHQL(filterGroup.filterGroup);
			if(len(filterGroupHQL)){
				filterGroupsHQL &= " #logicalOperator# (#filterGroupHQL#)";
			}else{
				arrayDeleteAt(reverseFilterGroup,i);
			}
		}

		return filterGroupsHQL;
	}

	private string function getLeafNodeHQL(){
		var leafNodeHQL = "";
		var parentPropertyName = getService('hibachiService').getParentPropertyByEntityName(getCollectionObject());
		var parentTableAlias = "_#parentPropertyName#LeafJoin";
		//TODO: make subquery into othere collection call for elastic search to work better
		var notLeafNodeSubQuery = "
			SELECT #parentTableAlias#.#parentPropertyName#.id
			FROM #getDao('HibachiDao').getApplicationKey()##getCollectionObject()# #parentTableAlias#
			WHERE #parentTableAlias#.#parentPropertyName# IS NOT NULL
		";

		leafNodeHQL = " #getBaseEntityAlias()#.id NOT IN (#trim(notLeafNodeSubQuery)#) ";

		return leafNodeHQL;
	}

	private string function getNonLeafNodeHQL(){
		var notLeafNodeHQL = "";
		var parentPropertyName = getService('hibachiService').getParentPropertyByEntityName(getCollectionObject());
		var parentTableAlias = "_#parentPropertyName#LeafJoin";
		//TODO: make subquery into othere collection call for elastic search to work better
		var notLeafNodeSubQuery = "
			SELECT #parentTableAlias#.#parentPropertyName#.id
			FROM #getDao('HibachiDao').getApplicationKey()##getCollectionObject()# #parentTableAlias#
			WHERE #parentTableAlias#.#parentPropertyName# IS NOT NULL
		";

		notLeafNodeHQL = " #getBaseEntityAlias()#.id IN (#trim(notLeafNodeSubQuery)#) ";

		return notLeafNodeHQL;
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

	private string function getFromHQL(required string baseEntityName){
		var hibachiBaseEntityName = '';
		if(find(getDao('HibachiDao').getApplicationKey(),arguments.baseEntityName)){
			hibachiBaseEntityName = arguments.baseEntityName;
		}else{
			hibachiBaseEntityName = getService('hibachiService').getProperlyCasedFullEntityName(arguments.baseEntityName);
		}

		var fromHQL = ' FROM #hibachiBaseEntityName# as #getBaseEntityAlias()#';
		addHQLAlias(arguments.baseEntityName,getBaseEntityAlias());

		fromHQL &= getJoinHQL();

		return fromHQL;
	}

	public string function getJoinHQL(){
		var joinHQL = '';
		if(structKeyExists(getCollectionConfigStruct(),'joins')){
            var allAliases = getAllAliases();
			for(var join in getCollectionConfigStruct()["joins"]){
                if(listFind(allAliases, join.alias)){
                    joinHQL &= addJoinHQL(getBaseEntityAlias(),join);
                }
			}
		}
		return joinHQL;
	}

    public any function getAllAliases(){
        var aliases = '';

        var collectionConfigStruct = getCollectionConfigStruct();
        aliases = listAppend(aliases, getBaseEntityAlias());


		if(structKeyExists(collectionConfigStruct, 'columns') && arraylen(collectionConfigStruct.columns)){
			var columnCount = arraylen(collectionConfigStruct.columns); 
            for(var i = 1; i <= columnCount; i++){
                aliases = listAppend(aliases, listFirst(collectionConfigStruct.columns[i].propertyIdentifier, '.'));
            }
        }
			

       if(structKeyExists(collectionConfigStruct, 'orderBy') && arraylen(collectionConfigStruct.orderBy)){
			var orderByCount = arraylen(collectionConfigStruct.orderBy);
            for(var i = 1; i <= orderByCount; i++){
                aliases = listAppend(aliases, listFirst(collectionConfigStruct.orderBy[i].propertyIdentifier, '.'));
            }
        } 

		if(structKeyExists(collectionConfigStruct, 'groupBys') && listLen(collectionConfigStruct.groupBys)){
			var groupByArray = listToArray(collectionConfigStruct.groupBys);
			var groupByCount = arraylen(groupByArray); 
            for(var i = 1; i <= groupByCount; i++){
                aliases = listAppend(aliases, listFirst(groupByArray[i], '.'));
            }
        }

        if(structKeyExists(collectionConfigStruct, 'filterGroups') && arraylen(collectionConfigStruct['filterGroups'])){
            aliases = listAppend(aliases, getFilterAliases(collectionConfigStruct['filterGroups']));
        }

        if(structKeyExists(variables, 'postFilterGroups') && arraylen(variables.postFilterGroups)){
            aliases = listAppend(aliases, getFilterAliases(variables.postFilterGroups));
        }

        if(structKeyExists(collectionConfigStruct,'joins')) {
            var joinAliasList = [];
            for(var i = arraylen(collectionConfigStruct.joins); i >= 1; i--){
                for(var o = 1; o <= arraylen(joinAliasList); o++){
                    if(refindNoCase("^#collectionConfigStruct.joins[i].alias#", joinAliasList[o])){
                        aliases = listAppend(aliases, collectionConfigStruct.joins[i].alias);
                        break;
                    }
                }
                arrayAppend(joinAliasList, collectionConfigStruct.joins[i].alias);
            }
        }

        return listremoveduplicates(aliases);
    }

    public any function getFilterAliases(filterGroup){
        var aliasList = '';
        for(var fgIndex = 1; fgIndex <= arrayLen(filterGroup); fgIndex++){
            if(structKeyExists(filterGroup[fgIndex], 'filterGroup')){
                aliasList = listAppend(aliasList,getFilterAliases(filterGroup[fgIndex].filterGroup));
            }else{
                aliasList = listAppend(aliasList, listFirst(filterGroup[fgIndex].propertyIdentifier, '.'));
            }
        }
        return aliasList;
    }

	public string function getHQL(boolean excludeSelectAndOrderBy = false, forExport=false, excludeOrderBy = false, excludeGroupBy=false){
		
		structDelete(variables,'groupBys');
		
		variables.HQLParams = {};
		variables.postFilterGroups = [];
		variables.postOrderBys = [];

		var HQL = createHQLFromCollectionObject(this, arguments.excludeSelectAndOrderBy, arguments.forExport, arguments.excludeOrderBy,arguments.excludeGroupBy);
	
		return HQL;
	}

	public void function clearHQL(){
		structDelete(variables,'HQL');
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
			var collectionEntity = getHibachiCollectionService().getCollectionByCollectionID(arguments.filter.collectionID);
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

		collectionFilterHQL &= ' #rereplace(collectionEntity.getHQL(true),'\b\_','__',"ALL")# #predicate# #replace(collectionEntity.getBaseEntityAlias(),'_','__','ALL')# #logicalComparator# elements(#maincollectionAlias#) ';

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

	private string function getGroupByHQL(){
		var groupByHQL = "";
		var groupByList = '';
		
		getGroupBys();
		//use collectionConfig groupbys if they exist already as an override otherwise use the calculated ones
		if(structKeyExists(getCollectionConfigStruct(),'groupBys') && len(getCollectionConfigStruct()['groupBys']) && !hasPeriodColumn()){
			groupByList = getCollectionConfigStruct()['groupBys'];
		}else if(structKeyExists(variables,'groupBys')){
			groupByList = variables.groupBys;
		}
		

		if(!len(trim(groupByList)) && (!isReport() || !hasPeriodColumn())){
			return '';
		}
		
		var groupByArray = listToArray(groupByList);
		
		for(var i=1;i < arraylen(groupByArray);i++){
			groupByArray[i] = getPropertyIdentifierAlias(groupByArray[i]);
		}
		
		groupByList = arrayToList(groupByArray);
		
		groupByHQL = ' GROUP BY ' & groupByList;

		if(isReport() && hasPeriodColumn() ){
			var periodIntervalFormat = getPeriodIntervalQueryFormat(getCollectionConfigStruct()['periodInterval']);
			if(len(groupByList)){
				groupByHQL &= ",";
			}
			
			groupByHQL &= " DATE_FORMAT(#getPeriodColumn().propertyIdentifier#,'#periodIntervalFormat#')";
		}

		return groupByHQL;
	}
	
	public void function setPeriodInterval(required string periodInterval){
		getCollectionConfigStruct()['periodInterval'] = arguments.periodInterval;
	}

	public boolean function hasPropertyByPropertyIdentifier(required string propertyIdentifier){
		
		var pID = convertAliasToPropertyIdentifier(arguments.propertyIdentifier);
		return getService('hibachiservice').getHasPropertyByEntityNameAndPropertyIdentifier(getCollectionObject(),pID);
	}

	public string function getLastEntityNameInPropertyIdentifier(required string propertyIdentifier){
		var pID = convertAliasToPropertyIdentifier(arguments.propertyIdentifier);
		return getService('hibachiService').getLastEntityNameInPropertyIdentifier(
			entityName=getService('hibachiService').getProperlyCasedFullEntityName(getCollectionObject()),
			propertyIdentifier=pID
		);
	}

	public struct function getDefaultOrderBy(){
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
		if(structKeyExists(variables, 'orderByRequired') && !variables.orderByRequired){
			return '';
		}
		var orderByHQL = ' ORDER BY ';

		var orderByCount = arraylen(arguments.orderBy);
		//if order by count is 0, then use the default order by
		if(orderByCount == 0 && !getHasAggregate()){
			arrayAppend(arguments.orderby,getDefaultOrderBy());
			orderByCount++;
		}

		for(var i = 1; i <= orderByCount; i++){
			var ordering = arguments.orderBy[i];
			var direction = '';
			if(!isnull(ordering.direction)){
				direction = ordering.direction;
			}

			orderByHQL &= '#getPropertyIdentifierAlias(ordering.propertyIdentifier)# #direction# ';

			//check whether a comma is needed
			if(i != orderByCount){
				orderByHQL &= ',';
			}
		}

		// Condition to remove the ORDER BY from query if no orderBy added
		if( orderByHQL == ' ORDER BY '){
			return "";
		}else{
			return orderByHQL;
		}
	}

	public any function getNonPersistentColumn(){

		if( !structKeyExists(variables,'nonPersistentColumn') && isNull(variables.nonPersistentColumn)) {
			variables.nonPersistentColumn = false;
			if(structKeyExists(this.getCollectionConfigStruct(),'columns')){
				for(var column in this.getCollectionConfigStruct().columns){
					if(structKeyExists(column,'persistent') && column.persistent == false){
						variables.nonPersistentColumn = true;
						//limit nonpersistent data
						restrictPageRecords();
						break;
					}
				}
			}
		}

		return variables.nonPersistentColumn;
	}
	
	public any function restrictPageRecords(){
		if(!isNull(getPageRecordsShow()) && getPageRecordsShow() > 25){
			setPageRecordsShow(25);
		}
	}
	//there are two types of alias. One on the collection config in this format _product_defaultSku.skuID
	//and another on the record output formatted like defaultSku_skuID
	public string function convertAliasToPropertyIdentifier(required string propertyIdentifierWithAlias){
		var cacheKey = 'convertAliasToPropertyIdentifier'&arguments.propertyIdentifierWithAlias;

		var convertedAlias = getCollectionCacheValue(cacheKey);
		if(isNull(convertedAlias)){
			//assume collection config format
			if(left(arguments.propertyIdentifierWithAlias,1) == '_'){
	 			arguments.propertyIdentifierWithAlias = rereplace(arguments.propertyIdentifierWithAlias,'_','.','all');
	 			arguments.propertyIdentifierWithAlias = listRest(right(arguments.propertyIdentifierWithAlias,len(arguments.propertyIdentifierWithAlias)-1),'.');
			//assume output format
			}else{
	 			arguments.propertyIdentifierWithAlias = rereplace(arguments.propertyIdentifierWithAlias,'_','.','all');
	 		}
	 		convertedAlias = getHibachiService().getProperlyCasedPropertyIdentifier(getCollectionObject(),arguments.propertyIdentifierWithAlias);
	 		setCollectionCacheValue(cacheKey,convertedAlias);
		}


 		return convertedAlias;
 	}

	public string function convertPropertyIdentifierToAlias(required string propertyIdentifier){
		var cacheKey = 'convertPropertyIdentifierToAlias'&arguments.propertyIdentifier;

		var convertedPropertyIdentifier = getCollectionCacheValue(cacheKey);
		if(isNull(convertedPropertyIdentifier)) {
			arguments.propertyIdentifier = getHibachiService().getProperlyCasedPropertyIdentifier(getCollectionObject(),arguments.propertyIdentifier);
			convertedPropertyIdentifier = Replace(arguments.propertyIdentifier, '.', '_', 'all');
			if (left(convertedPropertyIdentifier, len(getBaseEntityAlias())) == getBaseEntityAlias()) {
				convertedPropertyIdentifier = right(convertedPropertyIdentifier, len(convertedPropertyIdentifier) - len(getBaseEntityAlias()) - 1);
			}
		}
		return convertedPropertyIdentifier;
	}
	// Used to apply filter based on record level permissions of the user
	public void function applyPermissions(){
		//this is used for record level permissions
		if (setting("globalDisableRecordLevelPermissions")){
			setPermissionAppliedFlag(true);
		}else if(!getPermissionAppliedFlag()){

			applyPermissionRecordRestrictions();

			setPermissionAppliedFlag(true);
		}
	}

	public struct function convertRelatedFilter(required string propertyIdentifier, required struct relatedFilter){

		var relatedPropertyIdentifier = convertALiasToPropertyIdentifier(arguments.relatedFilter.propertyIdentifier);

		var filterData = arguments.relatedFilter;

		filterData.propertyIdentifier = convertRelatedPropertyIdentifier(arguments.propertyIdentifier,relatedPropertyIdentifier);
		return filterData;

	}

	public string function convertRelatedPropertyIdentifier(required string propertyIdentifier, required string relatedPropertyIdentifier){
		var pid = convertALiasToPropertyIdentifier(arguments.propertyIdentifier);
		var isObject= getService('hibachiService').getPropertyIsObjectByEntityNameAndPropertyIdentifier(
			getService('hibachiService').getProperlyCasedFullEntityName(getCollectionObject()),pid);

		if(!isObject){
			//remove tail so that it is an object propertyIdentifier
			pid = listDeleteAt(pid,listlen(pid,'.'),'.');
		}

		pid &= '.'&arguments.relatedPropertyIdentifier;
		return getPropertyIdentifierAlias(pid);
	}

	private array function getManyToOnePropertiesToJoin(){
		var properties = getHibachiService().getPropertiesByEntityName(getCollectionObject());
		var manyToOneProperties = [];
		for(var prop in properties){
			if(
				//auto join many to ones if the propery name is the same as the cfc name and not excluded by metadata
				//or if they have hb_permissionRecordRestrictionJoin metadata
				(
					structKeyExists(prop,'fieldtype')
					&& prop.fieldtype == 'many-to-one'

				) && (
					(
						lcase(prop.name) == lcase(prop.cfc)
						&& (!structKeyExists(prop,'hb_permissionRecordRestrictionJoin') || prop.hb_permissionRecordRestrictionJoin == true)

					) || (
						structKeyExists(prop,'hb_permissionRecordRestrictionJoin')
						&& prop.hb_permissionRecordRestrictionJoin == true
					)
				)
			){
				arrayAppend(manyToOneProperties,prop);
			}
		}
		return manyToOneProperties;
	}

	private string function getObjectPermissionList(){
		var objectPermissionsList = getCollectionObject();
		if(setting('globalInspectRestrictionDisplays')) {
			if (structKeyExists(getCollectionConfigStruct(), 'columns')) {
				for (var column in getCollectionConfigStruct().columns) {
					if (hasPropertyByPropertyIdentifier(column.propertyIdentifier)) {
						var lastEntityName = getLastEntityNameInPropertyIdentifier(column.propertyIdentifier);
						if (left(lastEntityName, len(getDao('hibachiDao').getApplicationKey())) == getDao('hibachiDao').getApplicationKey()) {
							lastEntityName = right(lastEntityName, len(lastEntityName) - len(getDao('hibachiDao').getApplicationKey()));
						}
						objectPermissionsList = listAppend(objectPermissionsList, lastEntityName);
						variables.permissionAliasMap[lastEntityName] = column.propertyIdentifier;
					}
				}
			}
		}
		var manyToOneProperties = getManyToOnePropertiesToJoin();
		for(var prop in manyToOneProperties){
			objectPermissionsList = listAppend(objectPermissionsList,prop.cfc);
			var baseEntityObject = getService('hibachiService').getEntityObject( prop.cfc );
			var primaryIDName = baseEntityObject.getPrimaryIDPropertyName();
			variables.permissionAliasMap[prop.cfc] = "#prop.name#.#primaryIDName#";
		}
		return objectPermissionsList;
	}


	private array function getPermissionRecordRestrictions(){
		var objectPermissionsList = getObjectPermissionList();
		var permissionGroupCacheKey = 'getPermissionRecordRestrictions_#objectPermissionsList#'& getHibachiScope().getPermissionGroupCacheKey();

		if(getService('HibachiCacheService').hasCachedValue(permissionGroupCacheKey)){
			return getService('HibachiCacheService').getCachedValue(permissionGroupCacheKey);
		}else{
			var permissionRecordRestrictionCollectionList = getService('HibachiCollectionService').getPermissionRecordRestrictionCollectionList();
			permissionRecordRestrictionCollectionList.setPermissionAppliedFlag(true);
			permissionRecordRestrictionCollectionList.addFilter('permission.allowReadFlag',1);
			permissionRecordRestrictionCollectionList.addFilter('permission.propertyName','NULL','IS');
			permissionRecordRestrictionCollectionList.addFilter('permission.accessType','entity');
			permissionRecordRestrictionCollectionList.addFilter('permission.entityClassName','#objectPermissionsList#','IN');
			permissionRecordRestrictionCollectionList.addFilter('permission.permissionGroup.accounts.accountID',getRequestAccount().getAccountID());
			permissionRecordRestrictionCollectionList.setDisplayProperties('permissionRecordRestrictionID,collectionConfig,permission.entityClassName');
			permissionRecordRestrictionCollectionList.addDisplayProperty('enforceOnDirectObjectReference');

			var permissionRecordRestrictions = permissionRecordRestrictionCollectionList.getRecords();
			getService('HibachiCacheService').setCachedValue(permissionGroupCacheKey,permissionRecordRestrictions);
		}
		return permissionRecordRestrictions;

	}

	//this function probably can be astracted out to the service level for Direct Object Reference Checks
	private void function applyPermissionRecordRestrictions(){

		var excludedEntities = 'Session,PermissionGroup,Permission';

		if(
			getRequestAccount().getNewFlag() ||
			getRequestAccount().getSuperUserFlag() ||
			//TODO: figure out why this prevents record level perms from working
			//!getService('HibachiAuthenticationService').hasPermissionRecordRestriction(getCollectionObject()) ||
			getRequestAccount().getPermissionGroupsCount() == 0 
		){
			return;
		}
		var permissionRecordRestrictions = getPermissionRecordRestrictions();
		for(var permissionRecordRestriction in permissionRecordRestrictions){

			if(
				!getCheckDORPermissions()
				|| (
					getCheckDORPermissions()
					&& structKeyExists(permissionRecordRestriction,'enforceOnDirectObjectReference')
					&& trim(permissionRecordRestriction['enforceOnDirectObjectReference']) == 'Yes'
				)

			){

				var collectionConfig = deserializeJson(permissionRecordRestriction['collectionConfig']);
				if(!structKeyExists(collectionConfig, 'filterGroups')){
					continue;
				}
				
				var recordRestrictionFilterGroups = collectionConfig['filterGroups'];
				if(permissionRecordRestriction['permission_entityClassName'] == getCollectionObject()){
					for(var filterGroup in recordRestrictionFilterGroups){
						if(arraylen(getCollectionConfigStruct()['filterGroups']) && arraylen(getCollectionConfigStruct()['filterGroups'][1].filterGroup)){
							filterGroup['logicalOperator']="AND";
						}

						arrayAppend(getCollectionConfigStruct()['filterGroups'],filterGroup);
					}
				}else{
					var propertyIdentifier = variables.permissionAliasMap[permissionRecordRestriction['permission_entityClassName']];
					applyRelatedFilterGroups(propertyIdentifier,recordRestrictionFilterGroups);
				}
			}
		}
	}

	//this function is used to allow a collection, example:orderitem to absord filters from a related collection such as example: order
	public void function applyRelatedFilterGroups(required string propertyIdentifier, required array relatedFilterGroups){
		var logicalOperator = "";
		
		var hasEmptyBeginningFilterGroup = false;
		
		if(!structKeyExists(getCollectionConfigStruct(),'filterGroups')){
			getCollectionConfigStruct()['filterGroups'] = [];
		}else if(arraylen(getCollectionConfigStruct()['filterGroups'])){
			//if filter group is empty ignore it otherwise make a logicaloperator
			if(structKeyExists(getCollectionConfigStruct()['filterGroups'][1],'filterGroup') && !arrayLen(getCollectionConfigStruct()['filterGroups'][1].filterGroup)){
				hasEmptyBeginningFilterGroup = true;			
			}else{
				logicalOperator = 'AND';
			}
		}


		for(var filterGroup in arguments.relatedFilterGroups){
			if(structKeyExists(filterGroup,'filterGroup')){
				var filterGroupAlias = "";
				if(structKeyExists(filterGroup,'filterGroupAlias')){
					filterGroupAlias = filterGroup.filterGroupAlias;
				}

				if(structKeyExists(filterGroup,'logicalOperator')){
					logicalOperator = filterGroup.logicalOperator;
				}

				filterGroup = {
					'filterGroup'=convertRelatedFilterGroup(arguments.propertyIdentifier,filterGroup.filterGroup)
				};
				if(len(filterGroupAlias)){
					filterGroup['filterGroupAlias'] = filterGroupAlias;
				}
				if(len(logicalOperator)){
					filterGroup['logicalOperator'] = logicalOperator;
				}
				if(!len(filterGroupAlias) || !hasFilterGroupByFilterGroupAlias(filterGroupAlias)){
					if(hasEmptyBeginningFilterGroup){
						getCollectionConfigStruct()['filterGroups'][1] = filterGroup;
						hasEmptyBeginningFilterGroup = false;
					}else{
						
						arrayAppend(getCollectionConfigStruct()['filterGroups'],filterGroup);
					}
				}
			}
		}

	}
	//this function is used to allow a collection, example:orderitem to absord filters from a related collection such as example: order

	public array function convertRelatedFilterGroup(required string propertyIdentifier, required array relatedFilterGroup, string filterGroupAlias){
		var convertedFilterGroup = [];
		for(var filterGroup in arguments.relatedFilterGroup){
			if(structKeyExists(filterGroup,'filterGroup')){
				filterGroup = {
					filterGroup=convertRelatedFilterGroup(arguments.propertyIdentifier,filterGroup.filterGroup)
				};
				arrayAppend(convertedFilterGroup,filterGroup);
			}else{
				var filter = filterGroup;
				filter = convertRelatedFilter(arguments.propertyIdentifier,filter);
				arrayAppend(convertedFilterGroup,filter);
			}
		}
		return convertedFilterGroup;
	}



	private array function getManyToOnePropertiesWhereCFCEqualsName(){
		var properties = getService('HibachiService').getPropertiesByEntityName(getCollectionObject());
		var manyToOneProperties = [];
		for(var prop in properties){
			if(
				structKeyExists(prop,'fieldtype')
				&& prop.fieldtype == 'many-to-one'
				&& lcase(prop.name) == lcase(prop.cfc)
			){
				arrayAppend(manyToOneProperties,prop);
			}
		}

		return manyToOneProperties;
	}
	public void function isReportAndHasNonPersistent(){
		if(isReport() && this.getNonPersistentColumn()){
			throw(rbkey('admin.reports.nonPersistentReport'));
		}
	}
	// Paging Methods
	public array function getPageRecords(boolean refresh=false, formatRecords=true) {
		isReportAndHasNonPersistent();
		
		if(arguments.refresh){
			clearRecordsCache();
		}
		
		applyPermissions();
		if(arguments.formatRecords){
			//If we are caching this (someone set setCacheable(true) on the collectionList)
			if (getCacheable() && !isNull(getCacheName()) && getService("hibachiCacheService").hasCachedValue("pageRecords-#getCacheName()#")){
				variables.pageRecords = getService("hibachiCacheService").getCachedValue("pageRecords-#getCacheName()#");

			} else {

				var formattedRecords = getHibachiCollectionService().getAPIResponseForCollection(this,{},false).pageRecords;
				variables.pageRecords =	formattedRecords;

				//If this is cacheable but we don't have a cached value, then set one.
				if (getCacheable() && !isNull(getCacheName()) && !getService("hibachiCacheService").hasCachedValue("pageRecords-#getCacheName()#")){
					getService("hibachiCacheService").setCachedValue("pageRecords-#getCacheName()#", variables.pageRecords);
				}
			}
		}else{
			try{

				if( !structKeyExists(variables, "pageRecords")) {

					if(getUseElasticSearch() && getHibachiScope().hasService('elasticSearchService')){
						arguments.collectionEntity = this;
						variables.pageRecords = getHibachiScope().getService('elasticSearchService').getPageRecords(argumentCollection=arguments);
					}else{
						var HQL = '';
						var HQLParams = {};
						saveState();
						if(this.getNonPersistentColumn() || (!isNull(this.getProcessContext()) && len(this.getProcessContext()))){
							//prepare page records and possible process objects
							variables.pageRecords = [];
							variables.processObjectArray = [];
							var entityAlias = "_#lcase(this.getCollectionObject())#";
							HQL = 'SELECT DISTINCT(#entityAlias#) ' & getHQL(excludeGroupBy=true);

							HQLParams = getHQLParams();
							var entities = ormExecuteQuery(HQL, HQLParams, false, {offset=getPageRecordsStart()-1, maxresults=getPageRecordsShow(), ignoreCase="true", cacheable=getCacheable(), cachename="pageRecords-#getCacheName()#"});
							var columns = getCollectionConfigStruct()["columns"];

							for(var entity in entities){
								var pageRecord = {};
								for(var column in columns){
									var propertyIdentifier = rereplace(replace(column.propertyIdentifier,entityAlias,''),'_','.','all');
									if(left(propertyIdentifier,1) == '.'){
										propertyIdentifier = right(propertyIdentifier,len(propertyIdentifier)-1);
									}

									if(structKeyExists(column,'setting') && column.setting == true){
										propertyIdentifier = ListRest(column.propertyIdentifier,'.');
										pageRecord[convertPropertyIdentifierToAlias(column.propertyIdentifier)] = getSettingValueFormattedByPropertyIdentifier(propertyIdentifier,entity);
									}else{
										pageRecord[convertPropertyIdentifierToAlias(column.propertyIdentifier)] = entity.getValueByPropertyIdentifier(propertyIdentifier);
									}
								}
								arrayAppend(variables.pageRecords,pageRecord);

								if(len(this.getProcessContext()) && entity.hasProcessObject(this.getProcessContext())){
									var processObject = entity.getProcessObject(this.getProcessContext());
									arrayAppend(variables.processObjectArray,processObject);
								}
							}
						}else{
							HQL = getHQL();
							HQLParams = getHQLParams();
							if( getDirtyReadFlag() ) {
								var currentTransactionIsolation = variables.connection.getTransactionIsolation();
								variables.connection.setTransactionIsolation(Connection.TRANSACTION_READ_UNCOMMITTED);
							}

							//If we are caching this (someone set setCacheable(true) on the collectionList)
							if (getCacheable() && !isNull(getCacheName()) && getService("hibachiCacheService").hasCachedValue(getCacheName())){
								variables.pageRecords = getService("hibachiCacheService").getCachedValue("pageRecords-" & getCacheName());

							} else {
								//Get the pageRecords
								variables.pageRecords = ormExecuteQuery(HQL, HQLParams, false, {offset=getPageRecordsStart()-1, maxresults=getPageRecordsShow(), ignoreCase="true", cacheable=getCacheable(), cachename="pageRecords-#getCacheName()#"});

								//If this is cacheable but we don't have a cached value yet, then set one.
								if (getCacheable() && !isNull(getCacheName()) && !getService("hibachiCacheService").hasCachedValue("pageRecords-" & getCacheName())){
									getService("hibachiCacheService").setCachedValue("pageRecords-" & getCacheName(), variables.pageRecords);
								}
							}
							

							if( getDirtyReadFlag() ) {
								variables.connection.setTransactionIsolation(currentTransactionIsolation);
							}
						}
					}
				}
			}
			catch(any e){
				if(isNull(HQL)){ 
					var HQL = '';
				}

				variables.pageRecords = [{'failedCollection'=e.message & ' HQL: ' & HQL}];
				writelog(file="collection",text="Error:#e.message#");
				writelog(file="collection",text="HQL:#HQL#");
			}

		}

		return variables.pageRecords;
	}

	public void function clearRecordsCount() {
		structDelete(variables, "recordsCount");
	}
	
	public void function clearRecordsCountData() {
		structDelete(variables, "recordsCountData");
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

	public void function clearRecordsCache(){
		structDelete(variables,'records');
		structDelete(variables,'pageRecords');
		structDelete(variables,'recordsCount');
		structDelete(variables,'recordsCountData');

		if (getCacheable()){
			structDelete(variables,'cacheName');
		}

		this.setExcludeOrderBy(false);

	}

	public array function getRecords(boolean refresh=false, boolean forExport=false, boolean formatRecords=true) {
		if(isReport()){
			this.setExcludeOrderBy(true);
			//check cache key
			var reportCacheKey = "";
			if(!this.getNewFlag()){
				reportCacheKey = '_reportCollection_'&getCollectionID()&hash(getCollectionConfig(),'md5');
				reportCacheKey &= getIgnorePeriodInterval();
			}
			
			if(getService('HibachiCacheService').hasCachedValue(reportCacheKey)){
				return getService('HibachiCacheService').getCachedValue(reportCacheKey);
			}
			
			arguments.formatRecords=false;
		}
		
		if(arguments.refresh){
			clearRecordsCache();
		}

		applyPermissions();

		if(arguments.formatRecords){
			var formattedRecords = getHibachiCollectionService().getAPIResponseForCollection(this,{allRecords=true},false).records;

			//If we are caching this (someone set setCacheable(true) on the collectionList)
			if (getCacheable() && !isNull(getCacheName()) && getService("hibachiCacheService").hasCachedValue(getCacheName())){
				variables.records =	getService("hibachiCacheService").hasCachedValue("records-"&getCacheName());
			} else {
				//Get the pageRecords
				variables.records =	formattedRecords;
				//If this is cacheable but we don't have a cached value yet, then set one.
				if (getCacheable() && !isNull(getCacheName()) && !getService("hibachiCacheService").hasCachedValue("records-" & getCacheName())){
					getService("hibachiCacheService").setCachedValue("records-" & getCacheName(), variables.records);
				}
			}
		}else{
			try{
				//If we are returning only the exportable records, then check and pass through.
				if( !structKeyExists(variables, "records")) {
					if(getUseElasticSearch() && getHibachiScope().hasService('elasticSearchService')){
						arguments.collectionEntity = this;
						variables.records = getHibachiScope().getService('elasticSearchService').getRecords(argumentCollection=arguments);
					}else{
						var HQL = '';
						var HQLParams = {};
						//For processing objects because we have a non-persistent column
						if(this.getNonPersistentColumn()){
							variables.records = [];
							HQL =  'SELECT DISTINCT(_#lcase(this.getCollectionObject())#) ' &  getHQL(forExport=arguments.forExport);
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
						//standard Collections HQL
						}else{

							HQL = getHQL(forExport=arguments.forExport);
							
							HQLParams = getHQLParams();
							if( getDirtyReadFlag() ) {
								var currentTransactionIsolation = variables.connection.getTransactionIsolation();
								variables.connection.setTransactionIsolation(Connection.TRANSACTION_READ_UNCOMMITTED);
							}

							//If we are caching this (someone set setCacheable(true) on the collectionList)
							if (getCacheable() && !isNull(getCacheName()) && getService("hibachiCacheService").hasCachedValue(getCacheName())){
								variables.records =	getService("hibachiCacheService").hasCachedValue("records-"&getCacheName());
							} else {
								//Get the Records
								variables.records = ormExecuteQuery(HQL,HQLParams, false, {ignoreCase="true", cacheable=getCacheable(), cachename="records-#getCacheName()#"});
								
								//If this is cacheable but we don't have a cached value yet, then set one.
								if (getCacheable() && !isNull(getCacheName()) && !getService("hibachiCacheService").hasCachedValue("records-" & getCacheName())){
									getService("hibachiCacheService").setCachedValue("records-" & getCacheName(), variables.records);
								} 
							}

							if( getDirtyReadFlag() ) {
								variables.connection.setTransactionIsolation(currentTransactionIsolation);
							}
							if(!structKeyExists(variables, "recordsCount")) {
								variables.recordsCount = arrayLen(variables.records);
							}
						}
					}
				}
			}
			catch(any e){
				variables.records = [{'failedCollection'=e.message & ' HQL: ' & HQL}];
				writelog(file="collection",text="Error:#e.message#");
				writelog(file="collection",text="HQL:#HQL#");
			}
		}
		if(getIgnorePeriodInterval()){
			return variables.records;
		}
		//backfill missing data intervals
		if(isReport() && hasPeriodColumn()){
			
			if(arraylen(variables.records)){
				var pidAlias = convertPropertyIdentifierToAlias(getPeriodColumn().propertyIdentifier,'.');
				var minValue = variables.records[1][pidAlias];
				
				var maxValue = variables.records[arraylen(variables.records)][pidAlias];
				
				var diff = getPeriodIntervalDateDiff(minValue,maxValue);
				
				var dateLookup = {};
				
				for(var i =1; i <= arraylen(variables.records);i++){
					var record = variables.records[i];
					var dateLookupKey = record[pidAlias];
					dateLookup[dateLookupKey] = i;
				}
				
				var reportRecords = [];
				var minValueArray = listToArray(minValue,'-');
				switch(getCollectionConfigStruct()['periodInterval']){
					case 'hour':
						var formattedMinValue = createDateTime(minValueArray[1],minValueArray[2],minValueArray[3],minValueArray[4],0,0);
						break;
					case 'day':
						var formattedMinValue = createDateTime(minValueArray[1],minValueArray[2],minValueArray[3],0,0,0);
						break;
					case 'week':
						var formattedMinValue = getService('scheduleService').getDateByWeek(minValueArray[1],minValueArray[2]);
						break;
					case 'month':
						var formattedMinValue = createDateTime(minValueArray[1],minValueArray[2],1,0,0,0);
						break;
					case 'year':
						var formattedMinValue = createDateTime(minValueArray[1],1,1,0,0,0);
						break;
				}
				
				for(var k = 0; k <= diff;k++){
					var dateValue = DateAdd(getPeriodIntervalDateDiffFormat(),k,formattedMinValue);
					var currentInterval = dateTimeFormat(dateValue,getPeriodIntervalDateFormat());
					if(structKeyExists(dateLookup,currentInterval)){
						arrayAppend(reportRecords,variables.records[dateLookup[currentInterval]]);
					}else{
						var reportRecord = {};
						for(var key in variables.records[1]){
							reportRecord[key] = 0;
						}
						reportRecord[pidAlias] = currentInterval;
						arrayAppend(reportRecords,reportRecord);
					}
				
				}
				if(len(reportCacheKey)){
					//expire tomorrow
					var cacheExpiration = dateAdd('d',1,now());
					getService('HibachiCacheService').setCachedValue(reportCacheKey,reportRecords,cacheExpiration);
				}
				return reportRecords;
			}
			
			
		}

		return variables.records;
	}
	
	public function setReportFlag(required boolean reportFlagValue){
		variables.reportFlag = arguments.reportFlagValue;
	}

	public void function setRecordsCount(required numeric total){
		variables.recordsCount = arguments.total;
	}
	
	public any function getRecordsCountData(){
		if(!structkeyExists(variables,'recordsCountData')){
			getRecordsCount();
			if(!structkeyExists(variables,'recordsCountData')){
				variables.recordsCountData['recordsCount'] = 0;	
			}
		}

		return variables.recordsCountData;
	}

	public any function getRecordsCount(boolean refresh=false) {

		if(arguments.refresh){
			clearRecordsCache();
		}
	

		applyPermissions();
		if(!structKeyExists(variables, "recordsCount") || !structKeyExists(variables,'recordsCountData')) {
			if(getCacheable() && structKeyExists(application.entityCollection, getCacheName()) && structKeyExists(application.entityCollection[getCacheName()], "recordsCount")) {
				variables.recordsCount = application.entityCollection[ getCacheName() ].recordsCount;
			} else {
				if(!structKeyExists(variables,"records")) {
					if(getUseElasticSearch() && getHibachiScope().hasService('elasticSearchService')){
						arguments.collectionEntity = this;
						var recordCount = getHibachiScope().getService('elasticSearchService').getRecordsCount(argumentCollection=arguments);
					}else{
						var HQL = '';
						//if getRecordsCount is called prior to getRecords then groupbys were never populated
						if(!structKeyExists(variables,'records')){
							getHQL(true);
						}
						HQL = getSelectionCountHQL();

						if( getDirtyReadFlag() ) {
							var currentTransactionIsolation = variables.connection.getTransactionIsolation();
							variables.connection.setTransactionIsolation(Connection.TRANSACTION_READ_UNCOMMITTED);
						}
						variables.recordsCountData = ormExecuteQuery(HQL, getHQLParams(), true, {ignoreCase="true",maxresults=1});
						var recordCount = 0;
						
						if(structkeyExists(variables,'recordsCountData') && structkeyExists(variables.recordsCountData,'recordsCount')){
							recordCount = variables.recordsCountData['recordsCount'];
						}
						
						if( getDirtyReadFlag() ) {
							variables.connection.setTransactionIsolation(currentTransactionIsolation);
						}

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

	public array function getPrimaryIDs(numeric recordCount){
		var primaryIDCollectionList = this.duplicateCollection();
		var primaryIDName = getService('hibachiService').getPrimaryIDPropertyNameByEntityName( getCollectionObject() );
		primaryIDCollectionList.setDisplayProperties(primaryIDName);
		if(structKeyExists(arguments,'recordCount')){
			primaryIDCollectionList.setPageRecordsShow(arguments.recordCount);
			return primaryIDCollectionList.getPageRecords(formatRecords=false);
		}else{
			return primaryIDCollectionList.getRecords(formatRecords=false);
		}
	}
	

	public string function getPrimaryIDList(){
		var primaryIDList = "";
		var primaryIDRecords = getPrimaryIDs(this.getRecordsCount());
		var primaryIDName = getService('hibachiService').getPrimaryIDPropertyNameByEntityName( getCollectionObject() );
		for(var primaryIDRecord in primaryIDRecords){
			primaryIDList = listAppend(primaryIDList,primaryIDRecord[primaryIDName]);
		}
		return primaryIDList;
	}

	public array function getPropertyNameValues(required string propertyName, string recordCount){
		var baseEntityObject = getService('hibachiService').getEntityObject( getCollectionObject() );
		var propertyMetaData = baseEntityObject.getPropertyMetaData(arguments.propertyName);
		var backupColumns = this.getCollectionConfigStruct().columns;
		var column = {

		};
		if(structKeyExists(propertyMetaData,'ormtype')){
			column['ormtype'] = propertyMetaData.ormtype;
		}

		if(structKeyExists(propertyMetaData,'ormtype')){
			column['title'] = baseEntityObject.getPropertyTitle(arguments.propertyName);
		}
		column['propertyIdentifier'] = "_#lcase(getService('hibachiService').getProperlyCasedShortEntityName(getCollectionObject()))#.#arguments.propertyName#";
		this.getCollectionConfigStruct().columns = [column];
		var records = [];
		if(structKeyExists(arguments, 'recordCount') && arguments.recordCount > 0){
			setPageRecordsShow(arguments.recordCount);
			records = getPageRecords(formatRecords=false);
		}else{
			records = getRecords(formatRecords=false);
		}
		this.getCollectionConfigStruct().columns = backupColumns;
		clearRecordsCache();
		return records;

	}
	//trasforms [{id:'idvalue',otherproperty;'value'}] into {'idvalue':'value'} via transformRecordsToNVP('id','otherproperty')
	public struct function transformRecordsToNVP(required string keyPropertyValue,required string valuePropertyValue){
		var hashmap = {};
		for(var record in getRecords()){
			hashmap[record[arguments.keyPropertyValue]] = record[arguments.valuePropertyValue];
		}
		return hashmap;
	}

	public string function getPropertyNameValuesList(required string propertyName){
		var propertyNameValues = getPropertyNameValues(arguments.propertyName);
		var propertyNameValuesList = "";
		for(var propertyNameValueStruct in propertyNameValues){
			var propertyNameValue = propertyNameValueStruct[arguments.propertyName];
			propertyNameValuesList = listAppend(propertyNameValuesList,propertyNameValue);
		}
		return propertyNameValuesList;
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

	public string function replaceStringTemplateInFilterValue(required any object, required string filterValue){
		if(getHibachiScope().getService('hibachiUtilityService').isStringTemplate(arguments.filterValue)){
			return  getHibachiScope().getService('hibachiUtilityService').replaceStringTemplate(arguments.filterValue, arguments.object);
		}
		return filterValue;
	}

	private string function getPredicate(required any filter){
		var predicate = '';
		if(!structKeyExists(filter,"value")){
			if(structKeyExists(filter,'ormtype') && filter.ormtype == 'string' && structKeyExists(filter,'displayValue')){
				filter.value = filter.displayValue;
			}else{
				filter.value = "";
			}
		}
		//Session Filters
		filter.value = replaceStringTemplateInFilterValue(getHibachiScope(), filter.value);

		//verify we are handling a range value
		if(arguments.filter.comparisonOperator eq 'between' || arguments.filter.comparisonOperator eq 'not between'){
			if(listfindnocase("between,not between,>,>=,<,<=,gt,gte,lt,lte",arguments.filter.comparisonOperator)){


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
				//regular date format mm/dd/yyyy
				}else if(listLen(arguments.filter.value,'-') > 1 && listLen(arguments.filter.value,'/') > 1){
					//convert unix timestamp

					var tempRangeArr = listToArray(arguments.filter.value, "-");
					var fromTemp = listToArray(tempRangeArr[1], "/");
					var toTemp   = listToArray(tempRangeArr[2], "/");

					var tempDateFrom = CreateDate(fromTemp[3], fromTemp[1], fromTemp[2]);
					var tempDateTo   = CreateDate(toTemp[3], toTemp[1], toTemp[2]);

					var fromValue = dateFormat(tempDateFrom,"yyyy-mm-dd");
					var toValue = dateFormat(tempDateTo,"yyyy-mm-dd");
				//Epoch date format
				}else if(listLen(arguments.filter.value,'-') > 1){
					//convert unix timestamp
					var fromDate = DateAdd("s", listFirst(arguments.filter.value,'-')/1000, "January 1 1970 00:00:00");
					var fromValue = dateFormat(fromDate,"yyyy-mm-dd") & " " & timeFormat(fromDate, "HH:MM:SS");
					var toDate = DateAdd("s", listLast(arguments.filter.value,'-')/1000, "January 1 1970 00:00:00");
					var toValue = dateFormat(toDate,"yyyy-mm-dd") & " " & timeFormat(toDate, "HH:MM:SS");
				}else if(listFindnocase('>=,>,gt,gte', arguments.filter.comparisonOperator)){
					//convert unix timestamp
					if(isNumeric(arguments.filter.value)){
						var fromValue = getService('HibachiUtilityService').getTimeByUtc(arguments.filter.value);
					}else{
						var fromValue = arguments.filter.value;
					}
					
				}else if(listFindnocase('<=,<,lt,lte', arguments.filter.comparisonOperator)){
					if(isNumeric(arguments.filter.value)){
						var toValue = getService('HibachiUtilityService').getTimeByUtc(arguments.filter.value);
					}else{
						var toValue = arguments.filter.value;
					}
				}else{
					//if list length is 1 then we treat it as a date range From Now() - Days to Now()
					var fromValue = DateAdd("d",-arguments.filter.value,Now());
					//make from value start at beginning of of day
					fromValue = createDateTime(Year(fromValue),Month(fromValue),Day(fromValue),0,0,0);
					var toValue = Now();
				}

				if(!isNull(fromValue)){
					var fromParamID = getParamID();
					addHQLParam(fromParamID, fromValue);
				}
				if(!isNull(toValue)){
					var toParamID = getParamID();
					addHQLParam(toParamID, toValue);
				}
				if(!isNull(fromParamID) && !isNull(toParamID)){
					predicate = ":#fromParamID# AND :#toParamID#";
				}else if(!isNull(fromParamID)){
					predicate = ":#fromParamID#";
				}else if(!isNull(toParamID)){
					predicate = ":#toParamID#";
				}


			}else if( listfindnocase("between,not between",arguments.filter.comparisonOperator) && listFind('integer,float,big_decimal,string',arguments.filter.ormtype)){
				var ranges = listToArray(arguments.filter.value,'-');
				if(arraylen(ranges) > 1){
					var fromValue = ranges[1];
 					var toValue = ranges[2];
 					var fromParamID = getParamID();
 					addHQLParam(fromParamID,fromValue);
 					var toParamID = getParamID();
 					addHQLParam(toParamID,toValue);
 
 					predicate = ":#fromParamID# AND :#toParamID#";
 				}else{
 					if(left(arguments.filter.value,1) == '-'){
 						var toValue = ranges[1];
 						var toParamID = getParamID();
 						addHQLParam(toParamID,toValue);
 						var minValueCollection = getService('hibachiCollectionService').invokeMethod('get#getCollectionConfigStruct().baseEntityName#CollectionList');
 
 						minValueCollection.addDisplayAggregate(convertAliasToPropertyIdentifier(arguments.filter.propertyIdentifier),'min','minValue');
 
 						minValueCollection.setPageRecordsShow(1);
 						var minValue = 0;
 						var minValuePageRecords = minValueCollection.getPageRecords();
 						if(arraylen(minValuePageRecords)){
 							minValue = minValuePageRecords[1]['minValue'];
 						}
 						predicate = "#minValue# AND :#toParamID#";
 					}else{
 						var fromValue = ranges[1];
 						var fromParamID = getParamID();
 						addHQLParam(fromParamID,fromValue);
 						var maxValueCollection = getService('hibachiCollectionService').invokeMethod('get#getCollectionConfigStruct().baseEntityName#CollectionList');
 						maxValueCollection.addDisplayAggregate(convertAliasToPropertyIdentifier(arguments.filter.propertyIdentifier),'max','maxValue');
 						maxValueCollection.setPageRecordsShow(1);
 						var maxValue = 0;
 						var maxValuePageRecords = maxValueCollection.getPageRecords();
 						if(arraylen(maxValuePageRecords)){
 							maxValue = maxValueCollection.getPageRecords()[1]['maxValue'];
 						}
 
						predicate = ":#fromParamID# AND #maxValue#";
					}
				}
			}else{
				var paramID = getParamID();
				
				addHQLParam(paramID,arguments.filter.value);
				predicate = ":#paramID#";
			}


		}else if(arguments.filter.comparisonOperator eq 'is' || arguments.filter.comparisonOperator eq 'is not'){
			predicate = filter.value;
		}else if(arguments.filter.comparisonOperator eq 'in' || arguments.filter.comparisonOperator eq 'not in'){
			if(len(filter.value)){
				predicate = "(" & ListQualify(filter.value,"'",variables.inlistDelimiter) & ")";
			}else{
				predicate = "('')";
			}
		}else if(arguments.filter.comparisonOperator eq 'like' || arguments.filter.comparisonOperator eq 'not like'){
			var paramID = getParamID();

			// Return empty string if comparison value is not set
			if(!len(filter.value)){
				return "";
			}

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

		var attributeIdentifier = getBaseEntityAlias();
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

	public any function getSelectionCountHQL(){

		var countHQLSelections = "";
		var countHQLSuffix = "";
		if(
			hasAggregateFilter() 
			|| hasGroupBys()
		){
			var countHQLSelections = "SELECT NEW MAP(COUNT(DISTINCT tempAlias.id) as recordsCount ";
			var countHQLSuffix = ' FROM  #getService('hibachiService').getProperlyCasedFullEntityName(getCollectionObject())# tempAlias WHERE tempAlias.id IN ( SELECT MIN(#getBaseEntityAlias()#.id) #getHQL(true, false, true)# )';
 		}else{
 			var countHQLSelections = 'SELECT NEW MAP(COUNT(DISTINCT #getBaseEntityAlias()#.id) as recordsCount ';
 			var countHQLSuffix = getHQL(true);
		}

		for(var totalAvgAggregate in variables.totalAvgAggregates){
			if(
				hasAggregateFilter() 
				||
				hasGroupBys()
			){
				countHQLSelections &= ", COALESCE(AVG(tempAlias.#convertAliasToPropertyIdentifier(totalAvgAggregate.propertyIdentifier)#),0) as recordsAvg#getColumnAlias(totalAvgAggregate)# ";
			}else{
				countHQLSelections &= ", COALESCE(AVG(#getPropertyIdentifierAlias(totalAvgAggregate.propertyIdentifier)#),0) as recordsAvg#getColumnAlias(totalAvgAggregate)# ";
			}
		}

		for(var totalSumAggregate in variables.totalSumAggregates){
			if(
				hasAggregateFilter() 
				||
				hasGroupBys()
			){
				countHQLSelections &= ", COALESCE(SUM(tempAlias.#convertAliasToPropertyIdentifier(totalSumAggregate.propertyIdentifier)#),0) as recordsSum#getColumnAlias(totalSumAggregate)# ";
			}else{
				countHQLSelections &= ", COALESCE(SUM(#getPropertyIdentifierAlias(totalSumAggregate.propertyIdentifier)#),0) as recordsSum#getColumnAlias(totalSumAggregate)# ";
			}
		}


		HQL = countHQLSelections & ') ' & countHQLSuffix;
		return HQL;
	}

	public array function getTotalAvgAggregates(){
		return variables.totalAvgAggregates;
	}

	public array function getTotalSumAggregates(){
		return variables.totalSumAggregates;
	}
	
	private numeric function getPeriodIntervalDateDiff(required minValue, required maxValue){
		var minDateArray = listToArray(arguments.minValue,'-');
		var maxDateArray = listToArray(arguments.maxValue,'-');
		
		switch(getCollectionConfigStruct()['periodInterval']){
			case 'hour':
				return dateDiff(
					getPeriodIntervalDateDiffFormat(),
					createDateTime(minDateArray[1],minDateArray[2],minDateArray[3],minDateArray[4],0,0),
					createDateTime(maxDateArray[1],maxDateArray[2],maxDateArray[3],maxDateArray[4],59,59)
				);
			case 'day':
				return dateDiff(getPeriodIntervalDateDiffFormat(),arguments.minValue,arguments.maxValue);
			case 'week':
				return dateDiff(
					getPeriodIntervalDateDiffFormat(),
					getService('scheduleService').getDateByWeek(minDateArray[1],minDateArray[2]),
					getService('scheduleService').getDateByWeek(maxDateArray[1],maxDateArray[2])
				);
			case 'month':
				return dateDiff(getPeriodIntervalDateDiffFormat(),arguments.minValue,arguments.maxValue);
			case 'year':
				return arguments.maxValue-arguments.minValue;
		}
	}
	
	private string function getPeriodIntervalDateDiffFormat(){
		switch(getCollectionConfigStruct()['periodInterval']){
			case 'hour':
				return 'h';
			case 'day':
				return 'd';
			case 'week':
				return 'ww';
			case 'month':
				return 'm';
			case 'year':
				return 'yyyy';
		}
	}
	
	private string function getPeriodIntervalDateFormat(){
		switch(getCollectionConfigStruct()['periodInterval']){
			case 'hour':
				return 'yyyy-mm-dd-hh';
			case 'day':
				return 'yyyy-mm-dd';
			case 'week':
				return 'yyyy-ww';
			case 'month':
				return 'yyyy-mm';
			case 'year':
				return 'yyyy';
		}
	}

	private string function getPeriodIntervalQueryFormat(required string periodInterval){
		
		switch(lcase(arguments.periodInterval)){
			case 'hour':
				return '%Y-%m-%d-%H';
			case 'day':
				return '%Y-%m-%d';
			case 'week':
				return '%Y-%u';
			case 'month':
				return '%Y-%m';
			case 'year':
				return '%Y';
		}
	}
	
	public boolean function hasPeriodColumn(){
		return !isNull(getPeriodColumn());
	}

	public any function getPeriodColumn(){
		if(!structKeyExists(variables,'periodColumn')){
			for(var column in getCollectionConfigStruct().columns){
				if(structKeyExists(column,"isPeriod")){
					variables.periodColumn = column;
					break;
				}
			}
		}
		
		if(structKeyExists(variables,'periodColumn')){
			return variables.periodColumn;
		}
	}
	
	private any function getSelectionsHQL(required array columns, boolean isDistinct=false, boolean forExport=false){


		var isDistinctValue = '';
		if(arguments.isDistinct){
			isDistinctValue = "DISTINCT";
		}
		var HQL = '';
		var selectHQL = 'SELECT #isDistinctValue#';
		var columnCount = arraylen(arguments.columns);
		var startMapHQL = ' new Map(';
		var columnsHQL = '';
		
		for(var i = 1; i <= columnCount; i++){
			var column = arguments.columns[i];
			if(isReport() && hasPeriodColumn()){

				getPropertyIdentifierAlias(column.propertyIdentifier,'column');
				var columnAlias = getColumnAlias(column);

				var addingColumn = false;
				if(
					(
						structKeyExists(column,'isMetric') 
						&& column.isMetric
					)
					|| structKeyExists(column,'aggregate')
				){
					if(structKeyExists(column,'isDistinct') && column.isDistinct){
						columnsHQL &= ' COALESCE(#column['aggregate']['aggregateFunction']#(DISTINCT #column.propertyIdentifier#),0) as #columnAlias#';
					}else{
						columnsHQL &= ' COALESCE(#column['aggregate']['aggregateFunction']#(#column.propertyIdentifier#),0) as #columnAlias#';
					}
					addingColumn = true;
				}else if(
					structKeyExists(column,'isPeriod') && column.isPeriod
					&& structKeyExists(getCollectionConfigStruct(),'periodInterval') && len(getCollectionConfigStruct()['periodInterval'])
				){
					variables.periodColumn = column;
					
					var periodIntervalFormat = getPeriodIntervalQueryFormat(getCollectionConfigStruct()['periodInterval']);
					columnsHQL &= " DATE_FORMAT(#column.propertyIdentifier#,'#periodIntervalFormat#') as #columnAlias#";
					addingColumn = true;
					
				}else if(structKeyExists(column,'isVisible') && column['isVisible']){
					columnsHQL &= ' #column.propertyIdentifier# as #columnAlias#';
					addingColumn = true;
				}
				//check whether a comma is needed
				if(i != columnCount && addingColumn){
					columnsHQL &= ',';
				}//<--end if

			}else{
				getPropertyIdentifierAlias(column.propertyIdentifier,'column');
				if(!arguments.forExport || (arguments.forExport && structKeyExists(column,'isExportable') && column.isExportable)){
					if(structKeyExists(column,'attributeID')){
						columnsHQL &= getColumnAttributeHQL(column);
					}else{
						//verify that column is valid, if not remove it
						if(hasPropertyByPropertyIdentifier(column.propertyIdentifier)){
							//if propertyIdentifier is object vs primitive then restrict page count
							
							
							if(getService('HibachiService').getPropertyIsObjectByEntityNameAndPropertyIdentifier(getCollectionObject(),convertAliasToPropertyIdentifier(column.propertyIdentifier))){
								restrictPageRecords();
							}
							//check if we have an aggregate
							
							if(!isNull(column.aggregate))
							{
								//if we have an aggregate then put wrap the identifier
								if(structKeyExists(column,'propertyIdentifier') && len(column.propertyIdentifier)){
									columnsHQL &= getAggregateHQL(column);
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

								if(structKeyExists(column, 'ormtype') &&
									(column.ormtype eq 'big_decimal'
									|| column.ormtype eq 'integer'
									|| column.ormtype eq 'float'
									|| column.ormtype eq 'double'
									) && !getService('HibachiService').hasToManyByEntityNameAndPropertyIdentifier(getCollectionObject(),convertAliasToPropertyIdentifier(column.propertyIdentifier))
								){
									addTotalAvgAggregate(column);
									addTotalSumAggregate(column);
								}

								columnsHQL &= ' #column.propertyIdentifier# as #columnAlias#';
							}
						}else{
							continue;
						}
					}

					//check whether a comma is needed
					if(i != columnCount){
						columnsHQL &= ',';
					}//<--end if
				}//<--end exportable
			}
		}//<--end for loop
		if(right(columnsHQL,1) == ','){
			columnsHQL &= left(columnsHQL,len(columnsHQL)-1);
		}
		var endMapHQL = ')';

		if(!len(columnsHQL)){
			columnsHQL = "#getBaseEntityAlias()#.id";
		}
		HQL &= selectHQL & startMapHQL & columnsHQL & endMapHQL;

		return HQL;
	}//<--end function
	
	
	public boolean function getDisableAveragesAndSumsFlag(){
		if(!structKeyExists(variables,'disableAveragesAndSumsFlag')){
			variables.disableAveragesAndSumsFlag = false;
		}
		return variables.disableAveragesAndSumsFlag;
	}
	
	public void function addTotalAvgAggregate(required struct column){
		var found = false;
		for(var item in variables.totalAvgAggregates){
			if(item.propertyIdentifier == column.propertyIdentifier){
				found = true;
			}
		}

		if(!found){
			arrayAppend(variables.totalAvgAggregates,column);
		}

	}

	public void function addTotalSumAggregate(required struct column){
		var found = false;
		for(var item in variables.totalSumAggregates){
			if(item.propertyIdentifier == column.propertyIdentifier){
				found = true;
			}
		}
		if(!found){
			arrayAppend(variables.totalSumAggregates,column);
		}
	}

	public string function getColumnAlias(required struct column){

		if(structKeyExists(column,'attributeID')){
			return listLast(column.propertyIdentifier,'.');
		}else{
			if(structKeyExists(column,'aggregate')){
				return column.aggregate.aggregateAlias;
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

				if(structKeyExists(column, 'alias')){
					return column.alias;
				}
				return Replace(Replace(arguments.column.propertyIdentifier,'.','_','all'),'_'&lcase(Replace(getCollectionObject(),'#getDao('hibachiDAO').getApplicationKey()#',''))&'_','');
			}
		}

	}
	
	public boolean function hasGroupBys(){
		getGroupBys();
		if (
			structKeyExists(getCollectionConfigStruct(),'groupBys') && len(getCollectionConfigStruct()['groupBys'])
			||
			(structKeyExists(variables,'groupBys') && len(variables['groupBys']))
		){
			return true;
		} else {
			return false;
		}
	}
	
	public any function getGroupBys(){
		if(!structKeyExists(variables,'groupBys')){
			if(isReport()){
				
				var groupBys =[];
				//add a group by for all selects that are not aggregates
				for(var column in getCollectionConfigStruct().columns){
					var propertyIdentifier = convertAliasToPropertyIdentifier(column.propertyIdentifier);
					
					if(
						!structKeyExists(column,'aggregate')
						&& !structKeyExists(column,'persistent')
						&& hasPropertyByPropertyIdentifier(propertyIdentifier)
						&& getService('HibachiService').getPropertyIsPersistentByEntityNameAndPropertyIdentifier(getCollectionObject(),propertyIdentifier)
					){
						if(structKeyExists(column,'isVisible') && column['isVisible']){
							if(
								(
									!structKeyExists(column,'isMetric') || !column['isMetric']
								) 
								&& (
									!structKeyExists(column,'isPeriod') ||!column['isPeriod']
								)
							){
								arrayAppend(groupBys,column.propertyIdentifier);
							}
						}
					}
				}
				
				variables.groupBys = arrayToList(groupBys);
			//standard group by check
			}else if(
				!this.getNonPersistentColumn() &&
				(
					( 
					  structKeyExists(variables, "groupByRequired") &&
					  variables.groupByRequired &&
					  getHasAggregate()
					 )
				   || getHasManyRelationFilter()
				)
				&& (
					!structKeyExists(getCollectionConfigStruct(),'groupBys')
					|| (
						structKeyExists(getCollectionConfigStruct(),'groupBys')
						&& !len(getCollectionConfigStruct().groupBys)
					)
				)
			){
				var groupByList = "";
				var collectionConfig = getCollectionConfigStruct();
				if(structKeyExists(collectionConfig, 'columns') && arraylen(collectionConfig.columns) > 0) {
					for (var i = 1; i <= arraylen(collectionConfig.columns); i++) {
						var column = collectionConfig.columns[i];
						var propertyIdentifier = rereplace(column.propertyIdentifier,'_','.','all');
						var aliasLength = 1+len(lcase(getCollectionObject()));
						if(lcase(left(propertyIdentifier,aliasLength))=='.'&lcase(getCollectionObject())){
							propertyIdentifier = right(propertyIdentifier,len(propertyIdentifier)-aliasLength-1);
						}
	
						if (structKeyExists(column, 'aggregate')
							|| structKeyExists(column, 'attributeID')
							|| ListFindNoCase(groupByList, column.propertyIdentifier) > 0
							|| !hasPropertyByPropertyIdentifier(propertyIdentifier)
							|| !getPropertyIdentifierIsPersistent(propertyIdentifier)
						) continue;
						
						if(getService('HibachiService').getPrimaryIDPropertyNameByEntityName(getCollectionObject()) == convertALiasToPropertyIdentifier(column.propertyIdentifier)){
							//if we have the collection objects primary id property as a column exclude all others group bys for better performance
							variables.groupBys = column.propertyIdentifier;
							return variables.groupBys; 							
						}else{
							groupByList = listAppend(groupByList, column.propertyIdentifier);
						}
					}
				}
	
				if(structKeyExists(collectionConfig, 'orderBy') && arraylen(collectionConfig.orderBy) > 0){
					if(getApplyOrderBysToGroupBys()){
						for (var j = 1; j <= arraylen(collectionConfig.orderBy); j++) {
							if (ListFindNoCase(groupByList, collectionConfig.orderBy[j].propertyIdentifier) > 0 || isAggregateFunction(collectionConfig.orderBy[j].propertyIdentifier)) continue;
							groupByList = listAppend(groupByList, collectionConfig.orderBy[j].propertyIdentifier);
						}
					}
				}else{
					if(!getExcludeOrderBy()){
						var orderBy = getDefaultOrderBy();
						if(!getHasAggregate()){
							groupByList = listAppend(groupByList,orderBy.propertyIdentifier);
						}
					}
				}
				variables.groupBys = groupByList;
			}
		} 
		if(structKeyExists(variables,'groupBys')){
			return variables.groupBys;
		}
	}

	public any function createHQLFromCollectionObject(required any collectionObject,
		boolean excludeSelectAndOrderBy=false,
		boolean forExport=false,
	    boolean excludeOrderBy=false,
	    boolean excludeGroupBy=false
	){


		var HQL = "";
		var collectionConfig = arguments.collectionObject.getCollectionConfigStruct();

		if(arguments.excludeOrderBy){
			this.setExcludeOrderBy(true);
		}

		if(!isNull(collectionConfig.baseEntityName)){
			var selectHQL = "";
			var fromHQL = "";
			var filterHQL = "";
			var postFilterHQL = "";
			var orderByHQL = "";
			var groupByHQL = "";

			if(!isnull(this.getParentCollection())){
				mergeParentCollectionFilters();
			}

			//build select
			if(!isNull(collectionConfig.columns) && arrayLen(collectionConfig.columns)){
				var isDistinct = false;
				if(!isNull(collectionConfig.isDistinct)){
					isDistinct = collectionConfig.isDistinct;
				}
				if(!isNull(collectionConfig.hasManyRelationFilter)){
					setHasManyRelationFilter(collectionConfig.hasManyRelationFilter);
				}
				//get select columns if we don't have a non-persistent column and a processContext was not supplied
				if(!len(this.getProcessContext())){

					if(this.getNonPersistentColumn() || arguments.excludeSelectAndOrderBy){
						getSelectionsHQL(columns=collectionConfig.columns, isDistinct=isDistinct, forExport=arguments.forExport);
					}else{
						selectHQL &= getSelectionsHQL(columns=collectionConfig.columns, isDistinct=isDistinct, forExport=arguments.forExport);
					}

				}

				if(!this.getExcludeOrderBy() && !arguments.excludeSelectAndOrderBy){
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


			//where clauses are actually the collection of all parent/child where clauses

			var filterGroupArray = getFilterGroupArrayFromAncestors(this);


			if(arraylen(filterGroupArray)){
				filterHQL &= getFilterHQL(filterGroupArray);
			}

			//add leaf node filters as private filter group
			if(getFilterByLeafNodesFlag()){
				var logicalOperator = '';
				if(len(filterHQL)){
					logicalOperator = 'AND';
				}else{
					filterHQL &= ' where ';
				}
				var leafNodeHQL = getLeafNodeHQL();

				if(len(leafNodeHQL)){
					filterHQL &= " #logicalOperator# (#leafNodeHQL#)";
				}
			}

			if(getFilterByNonLeafNodesFlag()){
				var logicalOperator = '';
				if(len(filterHQL)){
					logicalOperator = 'AND';
				}else{
					filterHQL &= ' where ';
				}
				var nonLeafNodeHQL = getNonLeafNodeHQL();

				if(len(nonLeafNodeHQL)){
					filterHQL &= " #logicalOperator# (#nonLeafNodeHQL#)";
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


			if(!arguments.excludeGroupBy){
				groupByHQL = getGroupByHQL();
			}

			var aggregateFilters = getAggregateFilterHQL();

			if(len(aggregateFilters) > 0){
				if(!len(groupByHQL)){
					throw('You cannot have aggregate filters without group by');
				}
				aggregateFilters =  ' HAVING #aggregateFilters#';

			}

			fromHQL &= getFromHQL(collectionConfig.baseEntityName);

			HQL = SelectHQL & FromHQL & filterHQL  & postFilterHQL & groupByHQL & aggregateFilters & orderByHQL;

		}

		return HQL;
	}

	public void function addPostFiltersFromKeywords(required any collectionConfig) {
		var keywordArray = getKeywordArray();
		var keywordCount = arraylen(keywordArray);
		if(keywordCount == 0){
			return;
		}
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
			var postFilterGroup = {
			    "filterGroup" = [],
				"logicalOperator" = "AND"
		    };
			//loop through columns
			for(var column in columns) {


				var currentFilter = {
					"comparisonOperator" = "like",
					"value"="%#keyword#%"
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

				var formatter = (column.ormtype eq 'big_decimal' || column.ormtype eq 'integer' || structKeyExists(column, 'aggregate') ) ? 'STR' : '';
				if(formatter == '' && getHibachiScope().getApplicationValue('databaseType')=="Oracle10g"){
					formatter = "LOWER";
				}
				//Create a propertyIdentifier for DefaultColumns
				var propertyIdentifier = (!defaultColumns)? getPropertyIdentifierAlias(column.propertyIdentifier) : getPropertyIdentifierAlias(column.name);
				//If is Attributes
				if (structKeyExists(column, 'attributeID')) {
					currentFilter['propertyIdentifier'] = propertyIdentifier;
					currentFilter['attributeID'] = column.attributeID;
					currentFilter['attributeSetObject'] = column.attributeSetObject;
					if (keywordCount != 0) currentFilter['logicalOperator'] = "OR";
				}else{
					if(len(formatter)){
						currentFilter['propertyIdentifier'] = formatter & '(#propertyIdentifier#)';
					}else{
						currentFilter['propertyIdentifier'] = propertyIdentifier;
					}
					currentFilter['logicalOperator'] = "OR";

					//remove AND from the frist filterGroup
					if(columnIndex == 0) {
						structDelete(currentFilter, "logicalOperator");
					}
				}

				arrayAppend(postFilterGroup['filterGroup'],currentFilter);

				columnIndex++;
			}
			if(keywordIndex == 0) {
				structDelete(postFilterGroup, "logicalOperator");
			}
			if(arraylen(postFilterGroup.filterGroup)){
				addPostFilterGroup(postFilterGroup);
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
		if(!structKeyExists(variables,'collectionConfigStruct')){
			variables.collectionConfigStruct = getCollectionConfigStruct();
		}
		stateStruct.collectionConfig = duplicate(variables.collectionConfigStruct);
		if(!structKeyExists(variables,'keywords')){
			stateStruct.keywords = duplicate(variables.keywords);
		}

		stateStruct.pageRecordsShow = duplicate(variables.pageRecordsShow);

		return stateStruct;
	}

	//Utility Functions may even belong in another service altogether based on how universally appliable they are

	private string function removeCharacters(required string javaUUIDString){
		return replace(arguments.javaUUIDString,'-','','all');
	}

	public void function setCollectionConfig(required string collectionConfig){
		variables.collectionConfig = trim(arguments.collectionConfig);
		//reinflate collectionConfigStruct if the collectionConfig is modified directly
		variables.collectionConfigStruct = deserializeCollectionConfig();
		if(!isReport()){
			structDelete(variables.collectionConfigStruct,'groupBys');
		}
	}

	public string function getCollectionConfig(){
		return variables.collectionConfig;
	}

	public any function getCollectionConfigStruct(){
		if(!structKeyExists(variables,'collectionConfigStruct')){
			variables.collectionConfigStruct = deserializeCollectionConfig();
			
			if(!isReport()){
				structDelete(variables.collectionConfigStruct,'groupBys');
			}
		}
		if(!structKeyExists(variables,'collectionConfigStruct')){
			variables.collectionConfigStruct = {};
		}
		if(structKeyExists(variables.collectionConfigStruct,'periodInterval')){
			variables.collectionConfigStruct['reportFlag']=1;
		}else{
			variables.collectionConfigStruct['reportFlag']=isReport();
		}
			
		
		return variables.collectionConfigStruct;
	}

	public void function setCollectionConfigStruct(required struct collectionConfigStruct){
		variables.collectionConfigStruct = arguments.collectionConfigStruct;
		if(!isReport()){
			structDelete(variables.collectionConfigStruct,'groupBys');
		}
		if(structKeyExists(variables.collectionConfigStruct,'filterGroups')){
			prepareAliasForFilterGroups(variables.collectionConfigStruct['filterGroups']);
		}
		
	}
	
	public void function prepareAliasForFilterGroups(required array filterGroup){
		for(var filter in arguments.filterGroup){
			if(structKeyExists(filter,'propertyIdentifier')){
				var propertyIdentifierAlias = getPropertyIdentifierAlias(convertAliasToPropertyIdentifier(filter.propertyIdentifier));
			}else if(structKeyExists(filter,'filterGroup')){
				prepareAliasForFilterGroups(filter.filterGroup);
			}
		}
	}

	public any function deserializeCollectionConfig(){
		return deserializeJSON(getCollectionConfig());
	}



	public boolean function isFilterApplied(required string filter, required string value, string filterType='f', string comparisonOperator=""){

		var key = "#arguments.filtertype#:#arguments.filter#";
		if(len(arguments.comparisonOperator)){
			key &= ":#arguments.comparisonOperator#";
		}
		var delimiter = this.getInlistDelimiter();
		if(arguments.comparisonOperator=='like'){
			delimiter = '|';
		}

		return structKeyExists(url,key) && listFindNoCase(url[key],arguments.value,delimiter);
	}

	public boolean function isRangeApplied(required string range, required string value){
		return structKeyExists(url,"R:#arguments.range#") and url["R:#arguments.range#"] eq arguments.value;

	}

	public any function getAggregations(){
		if(isNull(variables.aggregations)){
			variables.aggregations = {};
		}
		return variables.aggregations;
	}

	public void function addAggregation(key, value){
		if(isNull(variables.aggregations)){
			variables.aggregations = {};
		}
		variables.aggregations[key] = value;
	}

	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	public any function getMergeCollectionOptions(){
		if(!structKeyExists(variables, 'mergeCollectionOptions')){
			var mergeCollectionCollection = getHibachiCollectionService().getCollectionCollectionList();
			mergeCollectionCollection.setDisplayProperties('collectionID,collectionName');
			mergeCollectionCollection.addFilter('collectionID', getCollectionID(), '!=');
			mergeCollectionCollection.addFilter('collectionObject', getCollectionObject());
			mergeCollectionCollection.addOrderBy('collectionName');
			variables.mergeCollectionOptions = mergeCollectionCollection.getRecordOptions();
		}
		return variables.mergeCollectionOptions;
	}

	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	public boolean function hasNoAssociatedCollection() {
		if(getNewFlag()){
			return false;
		}
		
		var collectionCollection =  getService('hibachiService').getCollectionCollectionList();
		collectionCollection.addFilter('parentCollection.collectionID', variables.collectionID);
		if(collectionCollection.getRecordsCount() == 0){
			return true;
		}else{
			return false;
		}


	}
	
	// @hint Ensures that the collection config is valid and can be executed successfully
	public boolean function hasValidCollectionConfig() {
		// Attempt to fetch record with the set collectionConfg
		try {
			setPageRecordsShow(1);
			getPageRecords(true);
			
		// Error executing collection
		} catch (any e) {
			
			if(getApplicationValue('errorDisplayFlag')){
				writedump(e);throw();
			}
			var messageDetail = e.message;
			
			// Provide reference to component and line number from stack trace if possible
			if (isArray(e.tagContext) && arrayLen(e.tagContext)) {
				if(structKeyExists(e.tagContext[1],'codePrintPlain')){
					messageDetail = "#messageDetail#. #e.tagContext[1].raw_trace# -- #e.tagContext[1].codePrintPlain#";
				}else{
					messageDetail = e.message;
				}
			}
			
			// Set non-persistent variable so we can relay meaningful error detail with the validation rbKey
			setCollectionConfigErrorMessageDetail(messageDetail);
			return false;
		}
		
		return true;
	}

	// ===============  END: Custom Validation Methods =====================

	// =============== START: Custom Formatting Methods ====================

	public array function getRecordOptions(includeBlankOption=true){
		var optionsArray = [];
		if(includeBlankOption){
			arrayAppend(optionsArray, {'name'='','value'=''});
		}
		var exampleEntity = getHibachiCollectionService().invokeMethod("new#getCollectionObject()#");
		var nameProperty = exampleEntity.getSimpleRepresentationPropertyName();
		var idProperty = exampleEntity.getPrimaryIDPropertyName();

		for(var item in this.getRecords()){
			arrayAppend(optionsArray,{'name'=item[nameProperty], 'value'=item[idProperty]});
		};
		return optionsArray;
	}

	// ===============  END: Custom Formatting Methods =====================

	// ============== START: Overridden Implicit Getters ===================

	public any function getDefaultCollectionProperties(){

		return super.getDefaultCollectionProperties();
	}

	public boolean function getUseElasticSearch(){
		if(!structKeyExists(variables,'useElasticSearch')){
			variables.useElasticSearch = false;
		}
		return variables.useElasticSearch;
	}

	public boolean function getSplitKeywords(){
		if(isNull(variables.splitKeywords)){
			variables.splitKeywords = true;
		}
		return variables.splitKeywords;
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
