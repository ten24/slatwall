/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC

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

    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.

    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms
    of your choice, provided that you follow these specific guidelines:

	- You also meet the terms and conditions of the license of each
	  independent module
	- You must not alter the default display of the Slatwall name or logo from
	  any part of the application
	- Your custom code must not alter or create any files inside Slatwall,
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets
	the above guidelines as a combined work under the terms of GPL for this program,
	provided that you include the source code of that other code when and as the
	GNU GPL requires distribution of source code.

    If you modify this program, you may extend this exception to your version
    of the program, but you are not obligated to do so.

Notes:

*/
component accessors="true" persistent="false" output="false" extends="Slatwall.org.Hibachi.HibachiSmartList" {

	property name="attributeKeywordProperties" type="struct" hint="This struct holds the custom attributes that searches reference and their relative weight";


	//Override for Attribute Functionality
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
		setAttributeKeywordProperties({});
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

	//Override for Attribute Functionality
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

	//Override for Attribute Functionality
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

		for(var i=1; i<listLen(arguments.propertyIdentifier, variables.subEntityDelimiters); i++) {
			var thisProperty = listGetAt(arguments.propertyIdentifier, i, variables.subEntityDelimiters);
			if(structKeyExists(arguments,"fetch")){
				entityName = joinRelatedProperty(parentEntityName=entityName, relatedProperty=thisProperty,fetch=arguments.fetch,isAttribute=false);
			} else {
				entityName = joinRelatedProperty(parentEntityName=entityName, relatedProperty=thisProperty,isAttribute=false);
			}
		}

		if(propertyIsAttribute) {
			if(structKeyExists(arguments,"fetch")){
				entityName = joinRelatedProperty(parentEntityName=entityName, relatedProperty=listLast(arguments.propertyIdentifier, variables.subEntityDelimiters),fetch=arguments.fetch,isAttribute=true);
			} else {
				entityName = joinRelatedProperty(parentEntityName=entityName, relatedProperty=listLast(arguments.propertyIdentifier, variables.subEntityDelimiters),isAttribute=true);
			}
		}

		entityAlias = variables.entities[entityName].entityAlias;

		if(propertyIsAttribute) {
			return "#entityAlias#.attributeValue";
		}
		return "#entityAlias#.#variables.entities[entityName].entityProperties[listLast(propertyIdentifier, variables.subEntityDelimiters)].name#";
	}

	//Override for Attribute Functionality
	public void function addKeywordProperty(required string propertyIdentifier, required numeric weight) {
		var entityName = getBaseEntityName();
		var propertyIsAttribute = getService("hibachiService").getHasAttributeByEntityNameAndPropertyIdentifier(entityName=entityName, propertyIdentifier=arguments.propertyIdentifier);

		if(propertyIsAttribute) {

			var lastEntityName = getService("hibachiService").getLastEntityNameInPropertyIdentifier( getBaseEntityName() , arguments.propertyIdentifier );
			var entitiyID = getService("hibachiService").getPrimaryIDPropertyNameByEntityName( lastEntityName );

			var idPropertyIdentifier = replace(arguments.propertyIdentifier, listLast(arguments.propertyIdentifier, '.'), entitiyID);
			var aliasedProperty = getAliasedProperty(propertyIdentifier=idPropertyIdentifier);

			variables.attributeKeywordProperties[ aliasedProperty & ":" & listLast(arguments.propertyIdentifier, '.') ] = arguments.weight;
		} else {
			var aliasedProperty = getAliasedProperty(propertyIdentifier=propertyIdentifier);
			if(len(aliasedProperty)) {
				variables.keywordProperties[aliasedProperty] = arguments.weight;
			}
		}
	}

	//Override for Attribute Functionality
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
							addHQLParam(paramID, lcase(listGetAt(variables.whereGroups[i].likeFilters[likeFilter], ii, variables.valueDelimiter)));
							hqlWhere &= " LOWER(#likeFilter#) LIKE :#paramID# OR";
						}
						hqlWhere = left(hqlWhere, len(hqlWhere)-2) & ") AND";
					} else {
						var paramID = "LF#replace(likeFilter, ".", "", "all")##i#";
						addHQLParam(paramID, lcase(variables.whereGroups[i].likeFilters[likeFilter]));
						hqlWhere &= " LOWER(#likeFilter#) LIKE :#paramID# AND";
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
		if( arrayLen(variables.Keywords) && (structCount(variables.keywordProperties) || structCount(variables.attributeKeywordProperties)) ) {
			if(len(hqlWhere) == 0) {
				if(!arguments.suppressWhere) {
					hqlWhere &= " WHERE";
				}
			} else {
				hqlWhere &= " AND";
			}

			for(var ii=1; ii<=arrayLen(variables.Keywords); ii++) {
				var paramID = "keyword#ii#";
				addHQLParam(paramID, "%#lcase(variables.Keywords[ii])#%");
				hqlWhere &= " (";
				for(var keywordProperty in variables.keywordProperties) {

					hqlWhere &= " LOWER(#keywordProperty#) LIKE :#paramID# OR";
				}

				//Loop over all attributes and find any matches
				for(var attributeProperty in variables.attributeKeywordProperties) {
					var idProperty = listLast(listFirst(attributeProperty,':'), '.');
					var fullIDMap = left(idProperty, len(idProperty)-2) & '.' & idProperty;
					hqlWhere &= " EXISTS(SELECT sav.attributeValue FROM #getDao('HibachiDao').getApplicationKey()#AttributeValue as sav WHERE sav.#fullIDMap# = #listFirst(attributeProperty, ":")# AND sav.attribute.attributeCode = '#listLast(attributeProperty,':')#' AND sav.attributeValue LIKE :#paramID# ) OR";
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

	//Override for attribute Functionality
	public struct function getStateStruct() {
		var stateStruct = {};

		stateStruct.baseEntityName = duplicate(variables.baseEntityName);
		stateStruct.entities = duplicate(variables.entities);
		stateStruct.whereGroups = duplicate(variables.whereGroups);
		stateStruct.whereConditions = duplicate(variables.whereConditions);
		stateStruct.orders = duplicate(variables.orders);
		stateStruct.keywords = duplicate(variables.keywords);
		stateStruct.keywordProperties = duplicate(variables.keywordProperties);
		stateStruct.attributeKeywordProperties = duplicate(variables.attributeKeywordProperties);
		stateStruct.pageRecordsShow = duplicate(variables.pageRecordsShow);
		stateStruct.entityJoinOrder = duplicate(variables.entityJoinOrder);
		stateStruct.selectDistinctFlag = duplicate(variables.selectDistinctFlag);

		return stateStruct;
	}

}
