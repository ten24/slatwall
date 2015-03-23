'use strict';
angular.module('slatwalladmin')
.directive('swCriteria', [
	'$log',
	'$slatwall',
	'$filter',
	'collectionPartialsPath',
	'collectionService',
	'metadataService',
	function(
		$log,
		$slatwall,
		$filter,
		collectionPartialsPath,
		collectionService,
		metadataService
	){
//	    
//	    var linker = function(scope, element, attrs){
//	    	/*show the user the value without % symbols as these are reserved*/
			
//			
//	    	
//	    };
	    
		return {
			restrict: 'E',
			scope:{
				filterItem:"=",
		        selectedFilterProperty:"=",
		        filterPropertiesList:"=",
		        selectedFilterPropertyChanged:"&"
			},
			templateUrl:collectionPartialsPath+'criteria.html',
			link: function(scope, element, attrs){
//				scope.$watch('selectedFilterProperty', function(selectedFilterProperty) {
//					if(angular.isDefined(selectedFilterProperty)){
//						$log.debug('watchSelectedFilterProperty');
//						$log.debug(scope.selectedFilterProperty);
//						/*prepopulate if we have a comparison operator and value*/
//						if(selectedFilterProperty === null){
//							return;
//						}
//						
//						angular.forEach(scope.conditionOptions, function(conditionOption){
//							
//							if(conditionOption.display == scope.filterItem.conditionDisplay ){
//								scope.selectedFilterProperty.selectedCriteriaType = conditionOption;
//								scope.selectedFilterProperty.criteriaValue = scope.filterItem.value;
//								
//								if(angular.isDefined(scope.selectedFilterProperty.selectedCriteriaType.dateInfo)
//								&& angular.isDefined(scope.filterItem.value)
//								&& scope.filterItem.value.length
//								){
//									var dateRangeArray = scope.filterItem.value.split("-");
//									scope.selectedFilterProperty.criteriaRangeStart = new Date(parseInt(dateRangeArray[0]));
//									scope.selectedFilterProperty.criteriaRangeEnd = new Date(parseInt(dateRangeArray[1]));
//								}
//								
//								if(angular.isDefined(scope.filterItem.criteriaNumberOf)){
//									scope.selectedFilterProperty.criteriaNumberOf = scope.filterItem.criteriaNumberOf;
//								}
//								
//								if(angular.isDefined(scope.selectedConditionChanged)){
//									scope.selectedConditionChanged(scope.selectedFilterProperty);
//								}
//								
//								
//								
//							}
//						});
//				    	
//					}
//		    	}); 
//				
			}
		};
	}
]);
	
