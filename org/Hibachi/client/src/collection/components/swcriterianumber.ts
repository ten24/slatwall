/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWCriteriaNumber{
	public static Factory(){
		var directive = (
			$log,
			$hibachi,
			$filter,
			collectionPartialsPath,
			collectionService,
			metadataService,
			hibachiPathBuilder
		)=>new SWCriteriaNumber(
			$log,
			$hibachi,
			$filter,
			collectionPartialsPath,
			collectionService,
			metadataService,
			hibachiPathBuilder
		);
		directive.$inject = [
			'$log',
			'$hibachi',
			'$filter',
			'collectionPartialsPath',
			'collectionService',
			'metadataService',
			'hibachiPathBuilder'
		];
		return directive;
	}
	constructor(
		$log,
		$hibachi,
		$filter,
		collectionPartialsPath,
		collectionService,
		metadataService,
		hibachiPathBuilder
	){
		return {
			restrict: 'E',
			templateUrl:hibachiPathBuilder.buildPartialsPath(collectionPartialsPath)+'criterianumber.html',
			link: function(scope, element, attrs){
				var getNumberOptions = function(type){
					if(angular.isUndefined(type)){
				 		type = 'filter'
				 	}
				 	var numberOptions = [];
				 	if(type === 'filter'){
				    	numberOptions = [
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
				    }else if(type === 'condition'){
				 		numberOptions = [
				 			{
								display:"Equals",
								comparisonOperator:"eq"
							},
                            {
                                display:"Greater Than",
                                comparisonOperator:"gt"
                            },
                            {
                                display:"Greater Than Or Equal",
                                comparisonOperator:"gte"
                            },
                            {
                                display:"Less Than",
                                comparisonOperator:"lt"
                            },
                            {
                                display:"Less Than Or Equal",
                                comparisonOperator:"lte"
                            },
							{
								display:"Doesn't Equal",
								comparisonOperator:"neq"
							},
							{
								display:"Defined",
								comparisonOperator:"null",
								value:"False"
							},
							{
								display:"Not Defined",
								comparisonOperator:"null",
								value:"True"
							}
				 		];
				 	}
			    	return numberOptions;
			    };

    			 scope.$watch('selectedFilterProperty.criteriaValue',function(criteriaValue){
 		    		if(angular.isDefined(criteriaValue)){
 		    			scope.selectedFilterProperty.criteriaValue = criteriaValue;
 		    			$log.debug(scope.selectedFilterProperty);
 		    		}
 		    	});

    				scope.conditionOptions = getNumberOptions(scope.comparisonType);
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
	    				$log.debug('populate');

						if(conditionOption.display == scope.filterItem.conditionDisplay ){
							scope.selectedFilterProperty.selectedCriteriaType = conditionOption;
							$log.debug(scope.filterItem);
		    				if(scope.filterItem.comparisonOperator === 'between' || scope.filterItem.comparisonOperator === 'not between'){
		    					var criteriaRangeArray = scope.filterItem.value.split('-');
		    					$log.debug(criteriaRangeArray);
		    					scope.selectedFilterProperty.criteriaRangeStart = parseInt(criteriaRangeArray[0]);
		    					scope.selectedFilterProperty.criteriaRangeEnd = parseInt(criteriaRangeArray[1]);
		    				}else{
		    					scope.selectedFilterProperty.criteriaValue = scope.filterItem.value;
		    				}


							if(angular.isDefined(scope.filterItem.criteriaNumberOf)){
								scope.selectedFilterProperty.criteriaNumberOf = scope.filterItem.criteriaNumberOf;
							}

							if(angular.isDefined(scope.selectedConditionChanged)){
								scope.selectedConditionChanged(scope.selectedFilterProperty);
							}
						}
					});



			}
		};
	}
}
export{
	SWCriteriaNumber
}
