//collection service is used to maintain the state of the ui

angular.module('slatwalladmin.services')
.factory('collectionService',['$log',
function($log){
	//properties
	var _collection = null;
	var _collectionConfig = null;
	var _filterPropertiesList = null;
	var _filterCount = 0;
	
	return collectionService = {
		incrementFilterCount: function(number){
			$log.debug('incrementFilterCount');
			_filterCount += number;
		},
		getFilterCount: function(){
			return _filterCount;
		},
			
		getCollection: function(){
			return _collection;
		},
		setCollection: function(collection){
			_collection = collection;
		},
		getCollectionConfigJson: function(){
			return _collection.collectionConfig;
		},
		getCollectionConfig: function(){
			if(!angular.isObject(_collectionConfig)){
				_collectionConfig = angular.fromJson(_collection.collectionConfig);
			}
			return _collectionConfig;
		},
		setCollectionConfig: function(collectionConfig){
			_collection.collectionConfig = collectionConfig;
		},
		
		getRootFilterGroup: function(){
			var collectionConfig = this.getCollectionConfig();
			if(angular.isUndefined(collectionConfig.filterGroups)){
				collectionConfig.filterGroups = [
					{
						filterGroup:[
							
						]
					}
				];
			}
			return collectionConfig.filterGroups;
		},
		
		getColumns:function(){
			return _collection.collectionConfig.columns;
		},
		
		getFilterPropertiesList: function(){
			return _filterPropertiesList;
		},
		setFilterPropertiesList: function(filterPropertiesList){
			_filterPropertiesList = filterPropertiesList;
		},
			
		stringifyJSON: function(jsonObject){
			var jsonString = angular.toJson(jsonObject);
			return jsonString;
		},
		removeFilterItem: function(filterItem,filterGroup){
			filterGroup.pop(filterGroup.indexOf(filterItem));
		},
		selectFilterItem: function(filterItem){
			if(filterItem.$$isClosed){
				for(i in filterItem.$$siblingItems){
					filterItem.$$siblingItems[i].$$isClosed = true;
					filterItem.$$siblingItems[i].$$disabled = true;
				}
				filterItem.$$isClosed = false;
				filterItem.$$disabled = false;
				filterItem.setItemInUse(true);
			}else{
				for(i in filterItem.$$siblingItems){
					filterItem.$$siblingItems[i].$$disabled = false;
				}
				filterItem.$$isClosed = true;
				filterItem.setItemInUse(false);
			}	
			
		},
		selectFilterGroupItem: function(filterGroupItem){
			if(filterGroupItem.$$isClosed){
				for(i in filterGroupItem.$$siblingItems){
					filterGroupItem.$$siblingItems[i].$$disabled = true;
				}
				filterGroupItem.$$isClosed = false;
				filterGroupItem.$$disabled = false;
			}else{
				for(i in filterGroupItem.$$siblingItems){
					filterGroupItem.$$siblingItems[i].$$disabled = false;
				}
				filterGroupItem.$$isClosed = true;
			}
			filterGroupItem.setItemInUse(!filterGroupItem.$$isClosed);
		},
		newFilterItem: function(filterItemGroup,setItemInUse,prepareForFilterGroup){
			if(angular.isUndefined(prepareForFilterGroup)){
				prepareForFilterGroup = false;
			}
			filterItem = {
					displayPropertyIdentifier:"",
					propertyIdentifier:"",
					comparisonOperator:"=",
					value:"",
					$$disabled:false,
					$$isClosed:true,
					$$isNew:true,
					$$siblingItems:filterItemGroup,
					setItemInUse:setItemInUse				
				};
			if(filterItemGroup.length !== 0){
				filterItem.logicalOperator = "AND";
			}
			
			if(prepareForFilterGroup === true){
				filterItem.$$prepareForFilterGroup = true;
			}
			
			filterItemGroup.push(filterItem);
			
			
			collectionService.selectFilterItem(filterItem);
			
			
		},
		newFilterGroupItem: function(filterItemGroup,setItemInUse){
			var filterGroupItem = {
				filterGroup:[],
				$$disabled:"false",
				$$isClosed:"true",
				$$siblingItems:filterItemGroup,
				$$isNew:"true",
				setItemInUse:setItemInUse	
			};
			if(filterItemGroup.length !== 0){
				filterGroupItem.logicalOperator = "AND";
			};
			filterItemGroup.push(filterGroupItem);
			collectionService.selectFilterGroupItem(filterGroupItem);
			
			this.newFilterItem(filterGroupItem.filterGroup,setItemInUse);
		},
		transplantFilterItemIntoFilterGroup: function(filterGroup,filterItem){
			var filterGroupItem = {
				filterGroup:[],
				$$disabled:"false",
				$$isClosed:"true",
				$$isNew:"true"
			};
			if(angular.isDefined(filterItem.logicalOperator)){
				filterGroupItem.logicalOperator = filterItem.logicalOperator;
				delete filterItem.logicalOperator;
			}
			filterGroupItem.setItemInUse = filterItem.setItemInUse;
			filterGroupItem.$$siblingItems = filterItem.$$siblingItems;
			filterItem.$$siblingItems = [];
			
			
			filterGroup.pop(filterGroup.indexOf(filterItem));
			filterItem.$$prepareForFilterGroup = false;
			filterGroupItem.filterGroup.push(filterItem);
			filterGroup.push(filterGroupItem);
		},
		
		formatFilterPropertiesList: function(filterPropertiesList){
			for(i in filterPropertiesList.data){
				filterPropertiesList.data[i].propertyIdentifier = filterPropertiesList.entityName + '.' +filterPropertiesList.data[i].name;
			}
		}
		
		//private functions
		
	};
}]);
