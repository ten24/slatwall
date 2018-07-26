/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWCriteriaNumber{
	public static Factory(){
		var directive = (
			collectionPartialsPath,
			hibachiPathBuilder
		)=> new SWCriteriaNumber(
			collectionPartialsPath,
			hibachiPathBuilder
		);
		directive.$inject = [
			'collectionPartialsPath',
			'hibachiPathBuilder'
		];
		return directive;
	}
	constructor(
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
			    //initialize values

			    scope.conditionOptions = getNumberOptions(scope.comparisonType);

			    scope.inListArray = [];
    			if(angular.isDefined(scope.filterItem.value)){
    				scope.inListArray = scope.filterItem.value.toString().split(',');
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
    				//remove percents for like values
		    		if(angular.isDefined(scope.filterItem) && angular.isDefined(scope.filterItem.value)){
		    			scope.filterItem.value = scope.filterItem.value.replace('%','');
		    		}
		    	});

			    scope.$watch('selectedFilterProperty', function(selectedFilterProperty) {
					if(angular.isDefined(selectedFilterProperty)){

		    			angular.forEach(scope.conditionOptions, function(conditionOption){

							if(conditionOption.display == scope.filterItem.conditionDisplay ){
								scope.selectedFilterProperty.selectedCriteriaType = conditionOption;
								scope.selectedFilterProperty.criteriaValue = scope.filterItem.value;

								if(angular.isDefined(scope.selectedConditionChanged)){
									scope.selectedConditionChanged(scope.selectedFilterProperty);
								}

							}
						});
					}
			    });
			}
		};
	}
}
export{
	SWCriteriaNumber
}

