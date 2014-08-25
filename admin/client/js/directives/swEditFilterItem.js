angular.module('slatwalladmin')
.directive('swEditFilterItem', 
['$http',
'$compile',
'$templateCache',
'partialsPath',
'$log',
function($http,
$compile,
$templateCache,
partialsPath,
$log){
	return {
		restrict: 'A',
		scope:{
			filterItem:"=",
			filterPropertiesList:"="
		},
		link: function(scope, element,attrs){
			var filterGroupsPartial = partialsPath+"editFilterItem.html";
			var templateLoader = $http.get(filterGroupsPartial,{cache:$templateCache});
			var promise = templateLoader.success(function(html){
				element.html(html);
			}).then(function(response){
				element.replaceWith($compile(element.html())(scope));
			});
		},
		controller: function ($scope, $element, $attrs) {
			//initialize directive
			
			if(angular.isUndefined($scope.filterItem.isClosed)){
				$scope.filterItem.isClosed = true;
			}
			if(angular.isUndefined($scope.filterItem.breadCrumbs)){
				$scope.filterItem.breadCrumbs = "";
			}
			for(i in $scope.filterPropertiesList.DATA){
				var filterProperty = $scope.filterPropertiesList.DATA[i];
				console.log(filterProperty.propertyIdentifier);
				if(filterProperty.propertyIdentifier === $scope.filterItem.propertyIdentifier){
					$scope.selectedFilterProperty = filterProperty;
				}
			}
			
			//public functions
			$scope.selectedFilterPropertyChanged = function(selectedFilterProperty){
				$log.debug('selectedFilterProperty');
				$log.debug(selectedFilterProperty);
				//$scope.selectedFilterProperty.breadCrumbs += 
			};
			
			$scope.saveFilter = function(selectedFilterProperty,filterItem){
				//populate filterItem with selectedFilterProperty values
				filterItem.propertyIdentifier = selectedFilterProperty.propertyIdentifier;
				var propertyAlias = filterItem.propertyIdentifier.split(".").pop();
				filterItem.displayPropertyIdentifier = propertyAlias; 
				
				switch(selectedFilterProperty.ORMTYPE){
					case 'boolean':
	               		filterItem.comparisonOperator = selectedFilterProperty.selectedCriteriaType.comparisonOperator;
	               		filterItem.value = selectedFilterProperty.selectedCriteriaType.value;
	                break;
		            case 'string':
						filterItem.comparisonOperator = selectedFilterProperty.selectedCriteriaType.comparisonOperator;
						
						//retrieving implied value or user input | ex. implied:prop is null, user input:prop = "Name"
						if(angular.isDefined(selectedFilterProperty.selectedCriteriaType.value)){
						
							filterItem.value = selectedFilterProperty.selectedCriteriaType.value;
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
							}else{
								filterItem.value = selectedFilterProperty.criteriaValue;
							}
						}
						
		                break;
		                //TODO:simplify timestamp and big decimal to leverage reusable function for null, range, and value
		            case 'timestamp':
		            	//retrieving implied value or user input | ex. implied:prop is null, user input:prop = "Name"
		            	filterItem.comparisonOperator = selectedFilterProperty.selectedCriteriaType.comparisonOperator;
		            	
						if(angular.isDefined(selectedFilterProperty.selectedCriteriaType.value)){
							filterItem.value = selectedFilterProperty.selectedCriteriaType.value;
						}else{
							
							var dateValueString = selectedFilterProperty.criteriaRangeStart + '-' + selectedFilterProperty.criteriaRangeEnd;
							filterItem.value = dateValueString;
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
				$log.debug(selectedFilterProperty);
				$log.debug(filterItem);
			};
        } 
	};
}]);
	
