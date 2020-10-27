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

    				// selectedFilterProperty.showCriteriaStart is the default input, if the criteria is not of range type
    			
    				if(angular.isDefined(selectedFilterProperty.selectedCriteriaType.value)){
    					selectedFilterProperty.selectedCriteriaType.showCriteriaStart = false;
    				} else {
    					if(selectedFilterProperty.selectedCriteriaType.comparisonOperator === 'in' || selectedFilterProperty.selectedCriteriaType.comparisonOperator === 'not in'){
    						selectedFilterProperty.selectedCriteriaType.showCriteriaStart = false;
    						scope.comparisonOperatorInAndNotInFlag = true;
    					}else{
    						scope.clearField();
    						scope.comparisonOperatorInAndNotInFlag = false; 
    						selectedFilterProperty.selectedCriteriaType.showCriteriaStart = true;
    					}
    				}
    				
    				if(angular.isDefined(selectedFilterProperty.selectedCriteriaType.type) && selectedFilterProperty.selectedCriteriaType.type === 'range'){
    					//enabling the end-range input 
    					selectedFilterProperty.selectedCriteriaType.showCriteriaEnd = true;
    					scope.selectedFilterProperty.criteriaRangeStart = "";
    					scope.selectedFilterProperty.criteriaRangeEnd = "";

    				}else { 
    					//disabling the end-range input 
    					selectedFilterProperty.selectedCriteriaType.showCriteriaEnd = false;	
    				}
    				
    				scope.calculateCriteriaFilterPropertyValue(selectedFilterProperty);
    				
    			};

    			scope.criteriaRangeChanged = function(selectedFilterProperty) {
    				scope.calculateCriteriaFilterPropertyValue(selectedFilterProperty);
    			}
		    	
		    	scope.calculateCriteriaFilterPropertyValue = function(selectedFilterProperty) {
		    		
		    	    if(angular.isDefined(selectedFilterProperty.selectedCriteriaType.value)) {
		    	    	
						selectedFilterProperty.criteriaValue = selectedFilterProperty.selectedCriteriaType.value;

		    		} else if(angular.isDefined(selectedFilterProperty.selectedCriteriaType.type) && selectedFilterProperty.selectedCriteriaType.type === 'range') {
						
						if( !isNaN(parseInt(selectedFilterProperty.criteriaRangeStart)) && !isNaN(parseInt(selectedFilterProperty.criteriaRangeEnd))) {

							selectedFilterProperty.criteriaValue = selectedFilterProperty.criteriaRangeStart + "-" + selectedFilterProperty.criteriaRangeEnd;
							selectedFilterProperty.selectedCriteriaType.comparisonOperatorCalculated = null;

						} else if(!isNaN(parseInt(selectedFilterProperty.criteriaRangeStart))) {
							
							selectedFilterProperty.criteriaValue = selectedFilterProperty.criteriaRangeStart;
							selectedFilterProperty.selectedCriteriaType.comparisonOperatorCalculated = ">";
							
						} else if(!isNaN(parseInt(selectedFilterProperty.criteriaRangeEnd))) {
							
							selectedFilterProperty.criteriaValue = selectedFilterProperty.criteriaRangeEnd;
							selectedFilterProperty.selectedCriteriaType.comparisonOperatorCalculated = "<";
							
						} else {
							
							selectedFilterProperty.selectedCriteriaType.comparisonOperatorCalculated = null;
							selectedFilterProperty.criteriaValue = "";
						}

		    		} else {
						selectedFilterProperty.criteriaValue = selectedFilterProperty.criteriaRangeStart;
					}
					
					scope.filterItem.value = selectedFilterProperty.criteriaValue;
		    	}


			    scope.$watch('selectedFilterProperty', function(selectedFilterProperty) {
					if(angular.isDefined(selectedFilterProperty)){
						
		    			angular.forEach(scope.conditionOptions, function(conditionOption){
							if(conditionOption.display == scope.filterItem.conditionDisplay ){
								scope.selectedFilterProperty.selectedCriteriaType = conditionOption;
								
								scope.calculateCriteriaFilterPropertyValue(scope.selectedFilterProperty);
								
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

