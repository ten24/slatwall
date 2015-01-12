'use strict';
angular.module('slatwalladmin')
.directive('swCriteriaNumber', [
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
			templateUrl:collectionPartialsPath+'criterianumber.html',
			link: function(scope, element, attrs){
				var getNumberOptions = function(){
			    	var numberOptions = [
			    		{
							display:"Equals",
							comparisonOperator:"="
						},
						{
							display:"Doesn't Equal",
							comparisonOperator:"<>"
						},
						{
			    			display:"In Range",
			    			comparisonOperator:	"between",
			    			type:"range"
			    		},
			    		{
			    			display:"Not In Range",
			    			comparisonOperator:	"not between",
			    			type:"range"
			    		},
			    		{
			    			display:"Greater Than",
			    			comparisonOperator:">"
			    		},
			    		{
			    			display:"Greater Than Or Equal",
			    			comparisonOperator:">="
			    		},
			    		{
			    			display:"Less Than",
			    			comparisonOperator:"<"
			    		},
			    		{
			    			display:"Less Than Or Equal",
			    			comparisonOperator:"<="
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
			    	return numberOptions;
			    };
			    
			    
    			
    			 scope.$watch('selectedFilterProperty.criteriaValue',function(criteriaValue){
 		    		if(angular.isDefined(criteriaValue)){
 		    			scope.selectedFilterProperty.criteriaValue = criteriaValue;
 		    			console.log(scope.selectedFilterProperty);
 		    		}
 		    	});
    			 
    			scope.$watch('selectedFilterProperty', function(selectedFilterProperty) {
    				scope.conditionOptions = getNumberOptions();
	    			scope.criteriaRangeChanged = function(selectedFilterProperty){
					  	var selectedCondition = selectedFilterProperty.selectedCriteriaType;
	    			};
	    			scope.selectedConditionChanged = function(selectedFilterProperty){
	    				selectedFilterProperty.showCriteriaValue = true;
	    				//check whether the type is a range
	    				if(angular.isDefined(selectedFilterProperty.selectedCriteriaType.type)){
	    					selectedFilterProperty.showCriteriaValue = false;
	    					selectedFilterProperty.selectedCriteriaType.showCriteriaStart = true;
	    					selectedFilterProperty.selectedCriteriaType.showCriteriaEnd = true;
	    				}
	    				//is null or is not null
	    				if(angular.isDefined(selectedFilterProperty.selectedCriteriaType.value)){
	    					selectedFilterProperty.showCriteriaValue = false;
	    				}
	    			};
	    			
	    			angular.forEach(scope.conditionOptions, function(conditionOption){
						if(conditionOption.display == scope.filterItem.conditionDisplay ){
							scope.selectedFilterProperty.selectedCriteriaType = conditionOption;
							scope.selectedFilterProperty.criteriaValue = scope.filterItem.value;
							
							if(angular.isDefined(scope.filterItem.criteriaNumberOf)){
								scope.selectedFilterProperty.criteriaNumberOf = scope.filterItem.criteriaNumberOf;
							}
							
							if(angular.isDefined(scope.selectedConditionChanged)){
								scope.selectedConditionChanged(scope.selectedFilterProperty);
							}
						}
					});
    			});
    			
    			
				
			}
		};
	}
]);
	
