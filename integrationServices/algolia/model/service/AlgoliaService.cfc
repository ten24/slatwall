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
component extends="Slatwall.integrationServices.BaseDataProviderService" persistent="false" accessors="true" output="false"{
	
	property name="algoliaClient" type="any" persistent="false";
	
	
	// ===================== START: Logical Methods ===========================
	
	public void function init(any integrationService=getService('integrationService'), any settingService=getService('settingService')){
		
		super.init(argumentCollection=arguments);
		
		var algoliaClient = new Slatwall.integrationServices.algolia.algoliacfc.algolia(applicationId=setting('applicationId'),apiKey=setting('apiKey'),apiVersion=setting('apiVersion'));
		setAlgoliaClient(algoliaClient);
	}
	
	public void function syncDataByDataResource(required any dataResource, string startDateTime=now()){
		if(!len(arguments.startDateTime)){
			arguments.startDateTime = now();
		}
		getHibachiScope().addEntityQueueData(arguments.dataResource.getPrimaryIDValue(), arguments.dataResource.getClassName(), 'process#arguments.dataResource.getClassName()#_sync',{},getIntegration().getIntegrationID(),arguments.startDateTime);
		
	}
	
	public void function syncDataFromEntityQueue(required any entity, struct data={}){
		if(structKeyExists(arguments.data,'entityMapping')){		
			var entityData = {};
			var primaryIDPropertyName = getService('HibachiService').getPrimaryIDPropertyNameByEntityName(arguments.entity.getClassName());
			entityData[primaryIDPropertyName] = arguments.entity.getPrimaryIDValue();
			var entityMapping =arguments.data['entityMapping'];
			if(isStruct(entityMapping)){
				syncDataByIndexName(entityMapping['remoteIndex'],entityData);
			}else{
				syncDataByIndexName(deserializeJson(entityMapping)['remoteIndex'],entityData);
			}
		}
	}
	
	public void function syncDataByIndexName(required string indexName, struct entityData={}){
		getService('hibachiTagService').cfsetting(requesttimeout="200");
		var customMapping = getCustomMappingByIndexName(arguments.indexName);
		if(!isNull(customMapping)){
			var primaryIDName = getService('HibachiService').getPrimaryIDPropertyNameByEntityName(customMapping['slatwallEntity']);
		    var entityCollectionList = getService('algoliaService').getCollectionByEntityMappingAndEntityData(customMapping,entityData);
		    
		    if (structKeyExists(customMapping, "filters") && arrayLen(customMapping['filters'])){
				for(var filter in customMapping.filters){
					entityCollectionList.addFilter(argumentCollection=filter);
				}
			}
		    //TODO reset these to 1000 page record show and total pages in for loop
		    entityCollectionList.setPageRecordsShow(1000);
		    var totalPages = entityCollectionList.getTotalPages();

		    //loop over all pages and send batches
		    for( var i =1; i<=totalPages;i++){
		        //send records
		        entityCollectionList.setCurrentPageDeclaration(i);
		        
		        var entityRecords = entityCollectionList.getPageRecords(refresh=true,formatRecords=false);
		        
		        entityRecords = getService('algoliaService').formatRecords(entityRecords,primaryIDName);
		        
		        if(structKeyExists(customMapping,'arrayProperties')){
					for(var arrayProperty in customMapping['arrayProperties']){
						entityRecords = getArrayValuesForCollectionRecords(entityRecords,customMapping,primaryIDName,arrayProperty);
					}
		        }

		        // have a list of the related entities you want to retrieve
		        // loop through records
		        // for each record, make a collection of each related entity
		        // filter on parent enttiy id
		        // get records
		        // save records array as prop on parent record
	            var algoliaClient = getService('algoliaService').getAlgoliaClient();
	            algoliaClient.addObjects(arguments.indexName,entityRecords);
		        
		    }
		}
	}
	
	//Get array of values for properties that the entity collection has a one-to-many relationship with
	public array function getArrayValuesForCollectionRecords(required array entityRecords, required struct customMapping, required string primaryIDName, required struct arrayProperty ){
		

		var primaryIDList = arrayToList(arrayMap(arguments.entityRecords,getRecordPropertyValue(arguments.primaryIDName)));

		var propertyIdentifier = arguments.arrayProperty['propertyIdentifier'];
		var property = listLast(propertyIdentifier,'.');
		var propertyAlias = replace(propertyIdentifier,'.','_','all');
		//Path from entity with property to primaryID for entityRecords
		var pathToPrimaryID = arguments.arrayProperty['pathToPrimaryID'];
		var pathToPrimaryIDAlias = replace(pathToPrimaryID,'.','_','all');
		var propertyCollectionList = getService('HibachiCollectionService').invokeMethod("get#arguments.arrayProperty['entityName']#CollectionList");
		
		var arrayRecordPrimaryID = getService('HibachiService').getPrimaryIDPropertyNameByEntityName(arguments.arrayProperty['entityName']);
		
		propertyCollectionList.setDisplayProperties('#pathToPrimaryID#,#property#,#arrayRecordPrimaryID#');
		propertyCollectionList.addFilter(pathToPrimaryID,primaryIDList,'in');
		var propertyRecords = propertyCollectionList.getRecords(formatRecords=false);
		var propertyRecordStruct = {};
		//Group records into arrays mapped by primaryID for main record
		for(var record in propertyRecords){

			if(!structKeyExists(propertyRecordStruct,record[pathToPrimaryIDAlias])){
				propertyRecordStruct[record[pathToPrimaryIDAlias]] = [];
			}
			if(structKeyExists(record,property) && !isNull(record[property])){
				arrayAppend(propertyRecordStruct[record[pathToPrimaryIDAlias]],record[property]);
			}
		}
		
		//Get arrays for each record in main records
		for(var record in arguments.entityRecords){
			var arrayValue = [];
			if(structKeyExists(propertyRecordStruct,record[arguments.primaryIDName])){
				arrayValue = propertyRecordStruct[record[arguments.primaryIDName]];
			}
			record[propertyAlias] = arrayValue;

		}
		return arguments.entityRecords;
	}
	
	private function getRecordPropertyValue(required string propertyName){
		return function(item){
			return item[propertyName];
		};
	}
	
	public any function getCollectionByEntityMappingAndEntityData(required struct entityMapping, any entityData={}){
		var entityName = arguments.entityMapping.slatwallEntity;
		var primaryIDName = getService('HibachiService').getPrimaryIDPropertyNameByEntityName(entityName);
		var entityCollection = getService('HibachiCollectionService').invokeMethod('get#entityName#CollectionList');
		var displayPropertiesList = getDisplayPropertiesListByEntityMapping(arguments.entityMapping);
		
		entityCollection.setDisplayProperties(displayPropertiesList);
		
		addDisplayAggregatesToCollectionByEntityMapping(entityCollection,arguments.entityMapping);
		
		if(structKeyExists(arguments,'entityData') && structCount(arguments.entityData)){
			entityCollection.addFilter(primaryIDName,arguments.entityData[primaryIDName]);
			entityCollection.setPageRecordsShow(1);
		}
		return entityCollection;
	}
	
	public any function getDataPacketByEntityDataAndEntityMapping(required struct entityMapping, any entityData){
		var data = {};
		
		var entityCollection = getCollectionByEntityMappingAndEntityData(argumentCollection=arguments);
		
		var entityName = arguments.entityMapping['slatwallEntity'];
		var primaryIDName = getService('HibachiService').getPrimaryIDPropertyNameByEntityName(entityName);

		data = entityCollection.getPageRecords(formatRecords=false);
		
		data = formatRecords(data,primaryIDName);
		
		return data;
		
	}
	
	public any function formatRecords(required array records, required string primaryIDName){
		for(var record in arguments.records){
			record['objectID']=record[arguments.primaryIDName];
			if(structKeyExists(record,'vintage') && isNumeric(record['vintage'])){
				record['vintage'] = 0 + record['vintage'];
			}else{
				record['vintage'] = 0;
			}
			if(structKeyExists(record,'createdDateTime')){
				record['createdDateTime'] = record['createdDateTime'].getTime();
			}
		}
		return records;
	}
	
	public any function getDisplayPropertiesListByEntityMapping(required struct entityMapping){
		var primaryIDName = getService('hibachiService').getPrimaryIDPropertyNameByEntityName(arguments.entityMapping['slatwallEntity']);
		var displayPropertiesList = "";
		//create the properties list based on the mapping
		for(var propertyMapping in arguments.entityMapping.mapping){
			if(structKeyExists(propertyMapping,'slatwallPropertyIdentifier')){
				displayPropertiesList = listAppend(displayPropertiesList,propertyMapping['slatwallPropertyIdentifier']);
			}
		}
		displayPropertiesList = listAppend(displayPropertiesList,primaryIDName);
				
		return displayPropertiesList;
	}
	
	public any function addDisplayAggregatesToCollectionByEntityMapping(required any collection, required struct entityMapping){
		//create the properties list based on the mapping
		if(structKeyExists(arguments.entityMapping,'aggregates')){
			for(var aggregate in arguments.entityMapping.aggregates){
				arguments.collection.addDisplayAggregate(argumentCollection=aggregate);
			}
		}
	}
	
	public any function getCustomMappingByIndexName(required string indexName){
		var cacheKey = 'getCustomMappingsByIndexName'& arguments.indexName;
		if(!structKeyExists(variables,cacheKey)){
			for(var customMapping in getCustomMappings()){
				if(customMapping['remoteIndex']==arguments.indexName){
					variables[cacheKey]=customMapping;
					break;
				}
				
			}
		}
		if(structKeyExists(variables,cacheKey)){
			return variables[cacheKey];
		}
	}
	
	
	public any function getIndexOptions(){
		var customMappings = getCustomMappings();
		var entityOptions=[];
		for(var customMapping in customMappings){
			entityOption = {};
			entityOption['name'] = customMapping['remoteIndex'];
			entityOption['value'] = customMapping['remoteIndex'];
			arrayAppend(entityOptions,entityOption);
		}
		return entityOptions;
		
	}
	

	
	public any function hasEntityMapping(required string entityName){
		for(var entityMapping in getCustomMappings()){
			if(lcase(entity['slatwallEntity']) == lcasearguments.entityName){
				return true;
			}
		}
		return false;
	}
	


	// =====================  END: Logical Methods ============================

	// ===================== START: DAO Passthrough ===========================

	// ===================== START: DAO Passthrough ===========================

	// ===================== START: Process Methods ===========================

	// =====================  END: Process Methods ============================

	// ====================== START: Save Overrides ===========================

	// ======================  END: Save Overrides ============================

	// ==================== START: Smart List Overrides =======================

	// ====================  END: Smart List Overrides ========================

	// ====================== START: Get Overrides ============================

	// ======================  END: Get Overrides =============================

}
