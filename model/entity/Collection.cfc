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
component entityname="SlatwallCollection" table="SwCollection" persistent="true" accessors="true" extends="HibachiEntity" hb_serviceName="collectionService" {
	
	// Persistent Properties
	property name="collectionID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="collectionName" ormtype="string";
	property name="collectionCode" ormtype="string";
	property name="entityName" ormtype="string" hb_formFieldType="select";
	property name="CollectionObject" cfc="collection" ;
	
	property name="collectionConfig" ormtype="string" length="4000" hint="json object";
	
	// Calculated Properties

	// Related Object Properties (many-to-one)
	
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
	property name="hqlParams" type="struct" persistent="false";
	property name="hqlAliases" type="struct" persistent="false";
	property name="pageRecords" persistent="false";
	property name="entityNameOptions" persistent="false" hint="an array of name/value structs for the entities metaData";
	
	
	// ============ START: Non-Persistent Property Methods =================
	
	public any function init(){
		variables.hqlParams = {};
		variables.hqlAliases = {};
	}
	
	//returns an array of name/value structs for 
	public array function getEntityNameOptions() {
		if(!structKeyExists(variables, "EntityNameOptions")) {
			var entitiesMetaData = getService("hibachiService").getEntitiesMetaData();
			var entitiesMetaDataArray = listToArray(structKeyList(entitiesMetaData));
			arraySort(entitiesMetaDataArray,"text");
			variables.EntityNameOptions = [];
			for(var i=1; i<=arrayLen(entitiesMetaDataArray); i++) {
				arrayAppend(variables.EntityNameOptions, {name=rbKey('entity.#entitiesMetaDataArray[i]#'), value=entitiesMetaDataArray[i]});
			}
		}
		return variables.EntityNameOptions;
	}
	
	//TODO: how do we get this function to return the appropriate columns?	
	/*public any function getCollectionConfig() {
		if(!structKeyExists(variables, "collectionConfig")) {
			
			variables.collectionConfig = {};
			variables.collectionConfig['columns'] = [];
			
			if(!isNull(getCollectionObject()) && len(getCollectionObject())) {
				arrayAppend(variables.collectionConfig['columns'], getService('collectionService').getCollectionObjectColumnProperties(getCollectionObject())[2]);
			}
		}
		
		return variables.collectionConfig;
	}*/
	
	/*public any function getPageRecords() {
		if(!structKeyExists(variables, "pageRecords")) {
			variables.pageRecords = [];
			
			if(!isNull(getCollectionObject()) && len(getCollectionObject()) && arrayLen(getCollectionConfig().columns)) {
				var smartList = getHibachiScope().getSmartList(getCollectionObject());
				
				for(var column in getCollectionConfig().columns) {
					smartList.addSelect(column.propertyIdentifier, column.propertyIdentifier);
				}
				variables.pageRecords = smartList.getPageRecords();
			}
		}
		return variables.pageRecords;
	}*/
	
	public any function deserializeCollectionConfig(){
		return deserializeJSON(this.getCollectionConfig());
	}
	
	public any function getHQL(){
		var collectionConfig = deserializeCollectionConfig();
		
		HQL = createHQLFromCollectionObject(this);
		
		return HQL;
	}
	
	public array function getFilterGroupArrayFromAncestors(required any collectionObject){
		var collectionConfig = arguments.collectionObject.deserializeCollectionConfig();
		var filterGroupArray = [];
		if(!isnull(collectionConfig.filterGroups) && arraylen(collectionConfig.filterGroups)){
			filterGroupArray = collectionConfig.filterGroups;
		}
		
		if(!isnull(arguments.collectionObject.getCollectionObject())){
			
			var parentFilterGroupArray = getFilterGroupArrayFromAncestors(arguments.collectionObject.getCollectionObject());
			
			for(parentFilterGroup in parentFilterGroupArray){
				if(!arrayFind(filterGroupArray,parentGroupFilter)){
					if(!structKeyExists(parentGroupFilter,"logicalOperator")){
						parentGroupFilter.logicalOperator = ' AND ';
					}
					ArrayAppend(filterGroupArray,parentGroupFilter);
				}
			}
		}
		
		return filterGroupArray;
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
			case "in":
				return "IN";
			break;
			case "not in":
				return "NOT IN";
			break;
		}
		return '';
	}
	
	private string function getAggregateFunction(required string aggregateFunction){
		switch(arguments.aggregateFunction){
			
			case "count":
				return "COUNT";
			break;
			case "avg":
				return "AVG";
			break;
			case "sum":
				return "SUM";
			break;
			case "min":
				return "MIN";
			break;
			case "max":
				return "MAX";
			break;
		}
	}
	
	private string function getLogicalOperator(required string logicalOperator){
		switch(arguments.logicalOperator){
			case "or":
				return "OR";
			break;
			case "not":
				return "NOT";
			break;
			case "and":
				return "AND";
			break;
		}
		return 'AND';
	}
	
	private string function getParamID(){
		return 'paramID' & (structCount(this.getHQLParams()) + 1);
	}
	
	/*private string function getAliasID(){
		return 'aliasID' & (structCount())
	}*/
	
	private string function getFilterGroupHQL(required array filterGroup){
		var filterGroupHQL = '';
		for(filter in arguments.filterGroup){
			//add property and value to HQLParams
			//TODO: if using a like parameter we need to add % to the value
			var paramID = getParamID();
			addHQLParam(paramID,filter.value);
			
			var comparisonOperator = getComparisonOperator(filter.comparisonOperator);
			var logicalOperator = '';
			if(structKeyExists(filter,"logicalOperator")){
				logicalOperator = filter.logicalOperator;
			}
			filterGroupHQL &= " #logicalOperator# #filter.propertyIdentifier# #comparisonOperator# :#paramID#";
		}
		return filterGroupHQL;
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
			
			filterGroupsHQL &= " #logicalOperator# (#filterGroupHQL#)";
			
		}
		return filterGroupsHQL;
	}
	
	private string function getFilterHQL(required array filterGroups){
		//make the item without a logical operator first
		var filterHQL = ' where ';
		
		var filterGroupsHQL = getFilterGroupsHQL(arguments.filterGroups);
		filterHQL &= filterGroupsHQL;
		
		return filterHQL;
	}
	
	public void function addHQLParam(required string paramKey, required any paramValue) {
		variables.hqlParams[ arguments.paramKey ] = arguments.paramValue;
	}
	
	public void function addHQLAlias(required string aliasKey, required any aliasValue) {
		variables.hqlAliases[arguments.aliasKey] = arguments.aliasValue;
	}
	
	private any function getSelectionsHQL(required array columns){
		//TODO: add distinct logic, aliases
		
		var HQL = 'SELECT';
		var columnCount = arraylen(arguments.columns);
		
		for(var i = 1; i <= columnCount; i++){
			var column = arguments.columns[i];
			
			//check if we have an aggregate
			
			
			
			if(!isnull(coulumn.aggregateFunction))
			{
				//if we have an aggregate then put wrap the identifier
				var aggregateFunction = '';
				aggregateFunction = getAggregateFunction(column.aggregateFunction);
				
				HQL &= " #aggregateFunction#(#column.propertyIdentifier#)";
			}else{
				HQL &= ' #column.propertyIdentifier#';
			}
			
			//check whether a comma is needed
			if(i != columnCount){
				HQL &= ',';
			}
			
		}
		return HQL;
	}
	
	private string function addJoinHQL(required string parentAlias, required any join){
		
		var joinHQL = ' join #parentAlias#.#arguments.join.associationName# as #arguments.join.alias# ';
		if(!isnull(arguments.join.joins)){
			for(childJoin in arguments.join.joins){
				joinHQL &= addJoinHQL(join.alias,childJoin);
			}
		}
		
		return joinHQL;
	}
	
	private string function getFromHQL(required string baseEntityName, required string baseEntityAlias, required any joins){
		var fromHQL = ' FROM #arguments.baseEntityName# as #arguments.baseEntityAlias#';
		for(join in arguments.joins){
			fromHQL &= addJoinHQL(arguments.baseEntityAlias,join);
		}
		
		return fromHQL;
	}
	
	public any function createHQLFromCollectionObject(required any collectionObject){
		var HQL = "";
		var collectionConfig = arguments.collectionObject.deserializeCollectionConfig();
		
		if(!isNull(collectionConfig.baseEntityName)){
			
			//build select
			if(!isNull(collectionConfig.columns) && arrayLen(collectionConfig.columns)){
				HQL &= getSelectionsHQL(collectionConfig.columns);
			}
			//build FROM
			var joins = [];
			if(!isnull(collectionConfig.joins)){
				joins = collectionConfig.joins;
			}
			
			HQL &= getFromHQL(collectionConfig.baseEntityName, collectionConfig.baseEntityAlias, joins);
			
			//where clauses are actually the collection of all parent/child where clauses
			var filterGroupArray = getFilterGroupArrayFromAncestors(this);
			
			if(arraylen(filterGroupArray)){
				HQL &= getFilterHQL(filterGroupArray);
			}
			
			//build Order By
			if(!isNull(collectionConfig.orderBy) && arrayLen(collectionConfig.orderBy)){
				HQL &= ' ORDER BY ';
				
				var orderByCount = arraylen(collectionConfig.orderBy);
				for(var i = 1; i <= orderByCount; i++){
					var ordering = collectionConfig.orderBy[i];
					var direction = '';
					if(!isnull(ordering.direction)){
						direction = ordering.direction;
					}
					
					HQL &= '#ordering.propertyIdentifier# #direction# ';
					
					//check whether a comma is needed
					if(i != orderByCount){
						HQL &= ',';
					}
				}
			}
		}
		return HQL;
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================
	
	// ============== START: Overridden Implicit Getters ===================
	
	// ==============  END: Overridden Implicit Getters ====================
	
	// ============= START: Overridden Smart List Getters ==================
	
	// =============  END: Overridden Smart List Getters ===================

	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================
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
