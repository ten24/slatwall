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


component accessors="true" output="false" displayname="Algolia" implements="Slatwall.integrationServices.DataProviderInterface" extends="Slatwall.integrationServices.BaseDataProvider" {
	// Variables Saved in this application scope, but not set by end user
	property name="algoliaService" type="any" persistent="false";
	

	public any function init(){
		setAlgoliaService(getService('AlgoliaService'));
		return this;
	}
	
	

	public any function testIntegration() {
		//search an item
		var index = getService('algoliaService').getAlgoliaClient().initIndex('product');
		var object = index.getObject('2c918082678a9b6d01679de8f8374b6e');
	/*
	
		//add one item
		//creates index if it doesn't exist otherwise uses existing index
		var index = getService('algoliaService').getAlgoliaClient().initIndex('test');
		var members = deserializeJSON(fileRead(expandPath('/Slatwall')&'/integrationServices/algolia/algoliacfc/members.json'));
		//adds items to the index
		index.addObject(members[1],'00001df7b8c04b2aad87de1bf88d300a');
		return index;*/
	
		//uses test json data for batching
		//creates index if it doesn't exist otherwise uses existing index
		var index = getService('algoliaService').getAlgoliaClient().initIndex('test');
		var members = deserializeJSON(fileRead(expandPath('/Slatwall')&'/integrationServices/algolia/algoliacfc/members.json'));
		//adds items to the index
		index.addObjects(members);
		return index;

	}
	
	
	public any function getDataPacketByEntityDataAndEntityMapping(required entityMapping, required entityData){
		return getService('algoliaService').getDataPacketByEntityDataAndEntityMapping(argumentCollection=arguments);
	}
	
	public any function pushDataByEntityDataAndEntityMapping(required struct entityData, required struct entityMapping, required entityQueueDateTime){
		//TODO: add entityQueue work
		//var entityQueueData = hash(serializeJson(arguments.entityMapping),'MD5');
		var entityName = arguments.entityMapping['slatwallEntity'];
		var primaryIDName = getService('hibachiService').getPrimaryIDPropertyNameByEntityName(entityName);
		var indexName = arguments.entityMapping['remoteIndex'];

		var data = getDataPacketByEntityDataAndEntityMapping(arguments.entityMapping, arguments.entityData);
		
		//send data to algolia
		var index = getService('algoliaService').getAlgoliaClient().initIndex(indexName);
		if(arrayLen(data) eq 1){
			index.addObject(data[1],entityData[primaryIDName]);
		}
		
		return index;
	}

	public void function removeEntityQueue(required string baseObject, required string baseID, required string integrationID, required string entityQueueType, required string entityQueueData){

		var removeEntityQueueQuery = new query();
		var removeFromQueueSql = "
			  DELETE FROM SwEntityQueue
			  WHERE baseObject='#arguments.baseObject#'
			  AND baseID='#arguments.baseID#'
			  AND entityQueueType='#arguments.entityQueueType#';
		";
		var removeEntityQueueQueryResult = removeEntityQueueQuery.execute(sql=removeFromQueueSql);
		logHibachi('removeEntityQueueResult:'& serializeJson(removeEntityQueueQueryResult));
		var entityQueueHistoryUuid = createHibachiUUID();
		var addEntityQueueHistoryQuery = new query();
		addEntityQueueHistorySql = "
			INSERT into SwEntityQueueHistory
			(entityQueueHistoryID,baseObject,baseID,integrationID,entityQueueType,entityQueueHistoryDateTime,successFlag,entityQueueData)
			VALUES ('#entityQueueHistoryUuid#','#arguments.baseObject#','#arguments.baseID#','#arguments.integrationID#','#arguments.entityQueueType#',#now()#,1,'#arguments.entityQueueData#')
		;";
		var addEntityQueueHistoryQueryResult = addEntityQueueHistoryQuery.execute(sql=addEntityQueueHistorySql);

	}
	
	public any function pushData(string entityID, string syncByEvent){
		/*
		example of mapping
		{
			"slatwallEntity" : "Account",
			"remoteIndex":"Contact",
			"mapping" : [
				{
					"slatwallPropertyIdentifier" : "firstName"
				}
			]
		}*/
		
		var customMappings = getAlgoliaService().getCustomMappings();

		//for each entity pull data by first getting an array of ids that were changed
		for(var entityMapping in customMappings){
			
			if(
				(!structKeyExists(arguments,'syncByEvent') && !structKeyExists(entityMapping,'syncByEvent'))
				||(
					structKeyExists(arguments,'syncByEvent') && structKeyExists(entityMapping,'syncByEvent')
					&& listFindNoCase(entityMapping['syncByEvent'],arguments.syncByEvent)
				)
			){
				var slatwallEntity = entityMapping['slatwallEntity'];
				//get all items in the entity queue waiting to be pushed
				var entityQueueCollectionList = getService('HibachiEntityQueueService').getEntityQueueCollectionList();
				entityQueueCollectionList.setDisplayProperties('baseID,entityQueueDateTime');
				entityQueueCollectionList.addFilter('entityQueueType','push');
				entityQueueCollectionList.addFilter('baseObject',slatwallEntity);
				entityQueueCollectionList.addFilter('integration.integrationID',getIntegration().getIntegrationID());
				if(structKeyExists(arguments,'entityID')){
					entityQueueCollectionList.addFilter('baseID',arguments.entityID);
				}
				
				var entityIDsArray = [];
				var entityQueueRecords = entityQueueCollectionList.getRecords(refresh=true,formatRecords=false);
				for(var entityQueueRecord in entityQueueRecords){
					arrayAppend(entityIDsArray,entityQueueRecord['baseID']);				
				}
				var entityIDs = ArrayToList(entityIDsArray);
				
				var entityQueueDateTimeHashmap = entityQueueCollectionList.transformRecordsToNVP('baseID','entityQueueDateTime');
				//if we have entity ids then lets get the data from the ids
				
				if(len(entityIDs)){
					var primaryIDName = getService('hibachiService').getPrimaryIDPropertyNameByEntityName(slatwallEntity);
					var entityCollectionList = getService('hibachiService').invokeMethod('get#slatwallEntity#CollectionList');
					if(structKeyExists(entityMapping,'filters')){
						for(var filter in entityMapping.filters){
							entityCollectionList.addFilter(argumentCollection=filter);
						}
					}
					entityCollectionList.addFilter(primaryIDName,entityIDs,'IN');

					var displayPropertiesList = getDisplayPropertiesListByEntityMapping(entityMapping);
					for (var displayProperty in listToArray(displayPropertiesList)){
						
						try{
							entityCollectionList.addDisplayProperty(displayProperty);
						}catch(any e){
							throw(e);
							throw('bad displayPropertyList : #displayPropertiesList#');
						}
 					}
 					
 					entityCollectionList.addDisplayProperty("remoteID");
					
					//loop over syncable data
					var entityUpdates = entityCollectionList.getRecords(refresh=true,formatRecords=false);
					
					for(var entityData in entityUpdates){
						if(structKeyExists(entityQueueDateTimeHashmap,entityData[primaryIDName])){
							var entityQueueDateTime = entityQueueDateTimeHashmap[entityData[primaryIDName]];
							pushDataByEntityDataAndEntityMapping(entityData,entityMapping,entityQueueDateTime);
						}
					}
				}
			}
		}
		//Fire a custom event.
		
	}
	
	public void function pushDataFromQueue(required any entity, any data){
		var customMappings = getAlgoliaService().getCustomMappings();
		for(var entityMapping in customMappings){
			
			if(entityMapping['slatwallEntity'] != arguments.entity.getClassName()){
				continue;
			}
				
			
			var primaryIDName = getService('hibachiService').getPrimaryIDPropertyNameByEntityName(arguments.entity.getClassName());
			var entityCollectionList = getService('hibachiService').invokeMethod('get#entity.getClassName()#CollectionList');
			if(structKeyExists(entityMapping,'filters')){
				for(var filter in entityMapping.filters){
					entityCollectionList.addFilter(argumentCollection=filter);
				}
			}
			entityCollectionList.addFilter(primaryIDName,arguments.entity.getPrimaryIDValue(),'IN');
 			var displayPropertiesList = getDisplayPropertiesListByEntityMapping(entityMapping);
			for (var displayProperty in listToArray(displayPropertiesList)){
				
				try{
					entityCollectionList.addDisplayProperty(displayProperty);
				}catch(any e){
					throw(e);
					throw('bad displayPropertyList : #displayPropertiesList#');
				}
 			}
 			
 			entityCollectionList.addDisplayProperty("remoteID");
			
			//loop over syncable data
			var entityUpdates = entityCollectionList.getRecords(refresh=true,formatRecords=false);
			
			for(var entityData in entityUpdates){
				pushDataByEntityDataAndEntityMapping(entityData,entityMapping,'');
			}
		}
		
	}

	public string function getDisplayPropertiesListByEntityMapping(required entityMapping){
		return getService('algoliaService').getDisplayPropertiesListByEntityMapping(argumentCollection=arguments);
	}


}