/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWCriteriaString{
	public static Factory(){
		var directive = (
			$log,
			$hibachi,
			$filter,
			collectionPartialsPath,
			collectionService,
			metadataService,
			hibachiPathBuilder
		)=> new SWCriteriaString(
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
			templateUrl:hibachiPathBuilder.buildPartialsPath(collectionPartialsPath)+'criteriastring.html',
			link: function(scope, element, attrs){
				var getStringOptions = function(type){
					if(angular.isUndefined(type)){
				 		type = 'filter'
				 	}
				 	var stringOptions = [];
				 	if(type === 'filter'){
				 		stringOptions = [

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
				 	}else if(type === 'condition'){
				 		stringOptions = [
				 			{
								display:"Equals",
								comparisonOperator:"eq"
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

					return stringOptions;
			    };
			    //initialize values

			    scope.conditionOptions = getStringOptions(scope.comparisonType);

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
	SWCriteriaString
}

