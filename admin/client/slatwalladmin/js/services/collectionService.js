//collection service is used to maintain the state of the ui

angular.module('slatwalladmin.services')
.factory('collectionService',[
function(){
	
	return collectionService = {
		//properties
		selectFilterItem: function(filterItem){
			if(filterItem.isClosed){
				
				for(i in filterItem.siblingItems){
					filterItem.siblingItems[i].isClosed = true;
					filterItem.siblingItems[i].disabled = true;
				}
				filterItem.isClosed = false;
				filterItem.disabled = false;
			}else{
				for(i in filterItem.siblingItems){
					filterItem.siblingItems[i].disabled = false;
				}
				filterItem.isClosed = true;
			}	
			//console.log(filterItem);
			filterItem.setItemInUse({booleanValue:!filterItem.isClosed});
		},
		
		selectFilterGroupItem: function(filterGroupItem){
			if(filterGroupItem.isClosed){
				for(i in filterGroupItem.siblingItems){
					filterGroupItem.siblingItems[i].disabled = true;
				}
				filterGroupItem.isClosed = false;
				filterGroupItem.disabled = false;
			}else{
				for(i in filterGroupItem.siblingItems){
					filterGroupItem.siblingItems[i].disabled = false;
				}
				filterGroupItem.isClosed = true;
			}
			filterGroupItem.setItemInUse({booleanValue:!filterGroupItem.isClosed});
		},
		
		newFilterItem: function(filterItemGroup){
			console.log(filterItemGroup);
			filterItem = {
					propertyIdentifier:"empty",
					comparisonOperator:"=",
					value:"",
					disabled:"false",
					isClosed:"true",
					siblingItems:filterItemGroup				
				}
			
			if(filterItemGroup.length !== 0){
				filterItem.logicalOperator = "AND";
				filterItem.setItemInUse = filterItemGroup[filterItemGroup.length-1].setItemInUse;
			}
			filterItemGroup.push(filterItem);
			collectionService.selectFilterItem(filterItem);
		},
		newFilterGroupItem: function(filterItemGroup){
			
			var filterGroupItem = {
				filterGroup:[],
				disabled:"false",
				isClosed:"true",
				siblingItems:filterItemGroup		
			}
			if(filterItemGroup.length !== 0){
				filterGroupItem.logicalOperator = "AND"
				filterGroupItem.setItemInUse = filterItemGroup[filterItemGroup.length-1].setItemInUse;
			}
			filterItemGroup.push(filterGroupItem);
			collectionService.selectFilterGroupItem(filterGroupItem);
		}
		//private functions
		
	};
}]);
