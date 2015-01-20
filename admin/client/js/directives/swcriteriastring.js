'use strict';
angular.module('slatwalladmin')
.directive('swCriteriaString', [
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
	    
		return {
			restrict: 'E',
			templateUrl:collectionPartialsPath+'criteriastring.html',
			link: function(scope, element, attrs){
				var getStringOptions = function(){
			    	var stringOptions = [
						
						{
							display:"Equals",
							comparisonOperator:"="
						},
						{
							display:"Doesn't Equal",
							comparisonOperator:"<>"
						},
						{
							display:"Contains",
							comparisonOperator:"like",
							pattern:"%w%"
						},
						{
							display:"Doesn't Contain",
							comparisonOperator:"not like",
							pattern:"%w%"
						},
						{
							display:"Starts With",
							comparisonOperator:"like",
							pattern:"w%"
						},
						{
							display:"Doesn't Start With",
							comparisonOperator:"not like",
							pattern:"w%"
						},
						{
							display:"Ends With",
							comparisonOperator:"like",
							pattern:"%w"
						},
						{
							display:"Doesn't End With",
							comparisonOperator:"not like",
							pattern:"%w"
						},
						{
							display:"In List",
							comparisonOperator:"in"
						},
						{
							display:"Not In List",
							comparisonOperator:"not in"
						},
						{
							display:"Defined",
							comparisonOperator:"is not",
							value:"null"
						},
						{
							display:"Not Defined",
							comparisonOperator:"is",
							value:"null"
						}
					];
					return stringOptions;
			    };
			    
			    scope.$watch('selectedFilterProperty', function(selectedFilterProperty) {
					if(angular.isDefined(selectedFilterProperty)){
			    
					    scope.conditionOptions = getStringOptions();
		    			
		    			scope.selectedConditionChanged = function(selectedFilterProperty){
		    				//scope.selectedFilterProperty.criteriaValue = '';
		    				if(angular.isDefined(selectedFilterProperty.selectedCriteriaType.value)){
		    					selectedFilterProperty.showCriteriaValue = false;
		    				}else{
		    					if(selectedFilterProperty.selectedCriteriaType.comparisonOperator === 'in' || selectedFilterProperty.selectedCriteriaType.comparisonOperator === 'not in'){
		    						selectedFilterProperty.showCriteriaValue = false;
		    						scope.comparisonOperatorInAndNotInFlag = true;
		    					}else{
		    						selectedFilterProperty.showCriteriaValue = true;
		    					}
		    					
		    				}
		    			};
		    			
		    			scope.$watch('filterItem.value',function(criteriaValue){
		    				console.log(criteriaValue);
		    				
				    		if(angular.isDefined(scope.filterItem) && angular.isDefined(scope.filterItem.value)){
				    			scope.filterItem.value = scope.filterItem.value.replace('%','');
				    		}
				    	});
		    			
		    			angular.forEach(scope.conditionOptions, function(conditionOption){
							
							if(conditionOption.display == scope.filterItem.conditionDisplay ){
								scope.selectedFilterProperty.selectedCriteriaType = conditionOption;
								scope.selectedFilterProperty.criteriaValue = scope.filterItem.value;
								
								if(angular.isDefined(scope.selectedConditionChanged)){
									scope.selectedConditionChanged(scope.selectedFilterProperty);
								}
								
							}
						});
		    			
		    			scope.inListArray = [];
						scope.newListItem = '';
						
						scope.addToValueInListFormat = function(inListItem){
							// Adds item into array
							scope.inListArray.push(inListItem);
						
							//set value field to the user generated list
							scope.filterItem.value = scope.inListArray.toString();
							scope.newListItem = '';
		
						};
						
						scope.removelistItem = function(argListItem){
							
							for(var item = 0; item < scope.inListArray.length; item++){
								if(argListItem === scope.inListArray[item]){
									$log.debug(scope.inListArray);
									delete scope.inListArray[item];
								}
							}
							scope.filterItem.value = scope.inListArray.toString();
						};
						
						scope.clearField = function(){
							scope.newListItem = '';
						}
					}
			    });
			}
		};
	}
]);
	
