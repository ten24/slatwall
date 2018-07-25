/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWCriteriaNumber{
	public static Factory(){
		var directive = (
			$log,
			collectionPartialsPath,
			hibachiPathBuilder
		)=>new SWCriteriaNumber(
			$log,
			collectionPartialsPath,
			hibachiPathBuilder
		);
		directive.$inject = [
			'$log',
			'collectionPartialsPath',
			'hibachiPathBuilder'
		];
		return directive;
	}
	constructor(
		$log,
		collectionPartialsPath,
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
	    			
	    			
	    		scope.inListArray = [];
    			if(angular.isDefined(scope.filterItem.value)){
    				scope.inListArray = scope.filterItem.value.split(',');
    			}

    			scope.newListItem = '';

			    //declare functions
			    scope.addToValueInListFormat = function(inListItem){
					// Adds item into array
					
					scope.inListArray.push(inListItem);

					//set value field to the user generated list
					scope.filterItem.value = scope.inListArray.toString();
					scope.filterItem.displayValue = scope.inListArray.toString().replace(/,/g, ', ');
					scope.newListItem = '';
				};

				scope.removelistItem = function(argListIndex){
					scope.inListArray.splice(argListIndex,1);
					scope.filterItem.value = scope.inListArray.toString();
					scope.filterItem.displayValue = scope.inListArray.toString().replace(/,/g, ', ');
				};


				scope.clearField = function(){
					scope.newListItem = '';
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
    				
    				if(selectedFilterProperty.selectedCriteriaType.comparisonOperator === 'in' || selectedFilterProperty.selectedCriteriaType.comparisonOperator === 'not in'){
						selectedFilterProperty.showCriteriaValue = false;
						scope.comparisonOperatorInAndNotInFlag = true;
					}else{
						selectedFilterProperty.showCriteriaValue = true;
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
