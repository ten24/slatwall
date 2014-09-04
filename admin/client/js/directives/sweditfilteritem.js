'use strict';
angular.module('slatwalladmin')
.directive('swEditFilterItem', 
['$http',
'$compile',
'$templateCache',
'partialsPath',
'$log',
'slatwallService',
'collectionService',
'$filter',
function($http,
$compile,
$templateCache,
partialsPath,
$log,
slatwallService,
collectionService,
$filter){
	return {
		require:'^swFilterGroups',
		restrict: 'A',
		scope:{
			filterItem:"=",
			filterPropertiesList:"=",
			saveCollection:"&",
			removeFilterItem:"&",
			filterItemIndex:"="
		
		},
		templateUrl:partialsPath+"editfilteritem.html",
		link: function(scope, element,attrs,filterGroupsController){
			
			if(angular.isUndefined(scope.filterItem.$$isClosed)){
				scope.filterItem.$$isClosed = true;
			}
			if(angular.isUndefined(scope.filterItem.breadCrumbs)){
				scope.filterItem.$$breadCrumbs = "";
			}
			for(i in scope.filterPropertiesList.data){
				var filterProperty = scope.filterPropertiesList.data[i];
				if(filterProperty.propertyIdentifier === scope.filterItem.propertyIdentifier){
					//selectItem from drop down
					scope.selectedFilterProperty = filterProperty;
					//decorate with value and comparison Operator so we can use it in the Condition section
					scope.selectedFilterProperty.value = scope.filterItem.value;
					scope.selectedFilterProperty.comparisonOperator = scope.filterItem.comparisonOperator;
				}
			}
			
			scope.filterGroupItem = filterGroupsController.getFilterGroupItem();
			
			scope.togglePrepareForFilterGroup = function(){
				scope.filterItem.$$prepareForFilterGroup = !scope.filterItem.$$prepareForFilterGroup;
			};
			
			//public functions
			scope.selectedFilterPropertyChanged = function(selectedFilterProperty){
				$log.debug('selectedFilterProperty');
				$log.debug(selectedFilterProperty);
				//scope.selectedFilterProperty.breadCrumbs += 
			};
			
			scope.addFilterItem = function(){
				collectionService.newFilterItem(filterGroupsController.getFilterGroupItem(),filterGroupsController.setItemInUse);
			};
			
			scope.cancelFilterItem = function(){
				$log.debug('cancelFilterItem');
				$log.debug(scope.filterItemIndex);
				//scope.deselectItems(scope.filterGroupItem[filterItemIndex]);
				scope.filterItem.setItemInUse(false);
				console.log(scope.filterItem);
				scope.filterItem.$$isClosed = true;
				if(scope.filterItem.$$isNew === true){
					scope.removeFilterItem({filterItemIndex:scope.filterItemIndex});
				}
			};
			
			scope.saveFilter = function(selectedFilterProperty,filterItem,callback){
				if(angular.isDefined(selectedFilterProperty) && angular.isDefined(selectedFilterProperty.selectedCriteriaType)){
					//populate filterItem with selectedFilterProperty values
					filterItem.$$isNew = false;
					filterItem.propertyIdentifier = selectedFilterProperty.propertyIdentifier;
					filterItem.displayPropertyIdentifier = selectedFilterProperty.displayPropertyIdentifier; 
					
					switch(selectedFilterProperty.ormtype){
						case 'boolean':
		               		filterItem.comparisonOperator = selectedFilterProperty.selectedCriteriaType.comparisonOperator;
		               		filterItem.value = selectedFilterProperty.selectedCriteriaType.value;
		                break;
			            case 'string':
							filterItem.comparisonOperator = selectedFilterProperty.selectedCriteriaType.comparisonOperator;
							
							//retrieving implied value or user input | ex. implied:prop is null, user input:prop = "Name"
							if(angular.isDefined(selectedFilterProperty.selectedCriteriaType.value)){
							
								filterItem.value = selectedFilterProperty.selectedCriteriaType.value;
								filterItem.displayValue = filterItem.value;
							}else{
								//if has a pattern then we need to evaluate where to add % for like statement
								if(angular.isDefined(selectedFilterProperty.selectedCriteriaType.pattern)){
									switch(selectedFilterProperty.selectedCriteriaType.pattern){
										case "%w%":
											filterItem.value = '%'+selectedFilterProperty.criteriaValue+'%';
											break;
										case "%w":
											filterItem.value = '%'+selectedFilterProperty.criteriaValue;
											break;
										case "w%":
											filterItem.value = selectedFilterProperty.criteriaValue+'%';
											break;
									}
									
									filterItem.displayValue = selectedFilterProperty.criteriaValue;
								}else{
									filterItem.value = selectedFilterProperty.criteriaValue;
									filterItem.displayValue = selectedFilterProperty.criteriaValue;
								}
							}
							
			                break;
			                //TODO:simplify timestamp and big decimal to leverage reusable function for null, range, and value
			            case 'timestamp':
			            	//retrieving implied value or user input | ex. implied:prop is null, user input:prop = "Name"
			            	filterItem.comparisonOperator = selectedFilterProperty.selectedCriteriaType.comparisonOperator;
			            	//is it null or a range
							if(angular.isDefined(selectedFilterProperty.selectedCriteriaType.value)){
								filterItem.value = selectedFilterProperty.selectedCriteriaType.value;
								filterItem.displayValue = filterItem.value;
							}else{
								var dateValueString = selectedFilterProperty.criteriaRangeStart + '-' + selectedFilterProperty.criteriaRangeEnd;
								filterItem.value = dateValueString;
								var formattedDateValueString = $filter('date')(angular.copy(selectedFilterProperty.criteriaRangeStart),'MM/dd/yyyy @ h:mma') + '-' + $filter('date')(angular.copy(selectedFilterProperty.criteriaRangeEnd),'MM/dd/yyyy @ h:mma');
								filterItem.displayValue = formattedDateValueString;
								if(angular.isDefined(selectedFilterProperty.criteriaNumberOf)){
									filterItem.criteriaNumberOf = selectedFilterProperty.criteriaNumberOf;
								}
							}
							
			                break;	
			            case 'big_decimal':
							filterItem.comparisonOperator = selectedFilterProperty.selectedCriteriaType.comparisonOperator;
							//is null, is not null
							if(angular.isDefined(selectedFilterProperty.selectedCriteriaType.value)){
								filterItem.value = selectedFilterProperty.selectedCriteriaType.value;
							}else{
								if(angular.isUndefined(selectedFilterProperty.selectedCriteriaType.type)){
									filterItem.value = selectedFilterProperty.criteriaValue;
								}else{
									var decimalValueString = selectedFilterProperty.criteriaRangeStart + '-' + selectedFilterProperty.criteriaRangeEnd;
									filterItem.value = decimalValueString;
								}
							}
							break;
					}
					
					if(angular.isUndefined(filterItem.displayValue)){
						filterItem.displayValue = filterItem.value;
					}
					
					if(angular.isDefined(selectedFilterProperty.ormtype)){
						filterItem.ormtype = selectedFilterProperty.ormtype;
					}
					if(angular.isDefined(selectedFilterProperty.fieldtype)){
						filterItem.fieldtype = selectedFilterProperty.fieldtype;
					}
					
					filterItem.conditionDisplay = selectedFilterProperty.selectedCriteriaType.display;
					
					//if the add to New group checkbox has been checked then we need to transplant the filter item into a filter group
					if(filterItem.$$prepareForFilterGroup === true){
						collectionService.transplantFilterItemIntoFilterGroup(filterGroupsController.getFilterGroupItem(),filterItem);
					}
					//persist Config and 
					scope.saveCollection();
					
					$log.debug(selectedFilterProperty);
					$log.debug(filterItem);
					callback();
				}
			};
		},
	};
}]);
	
