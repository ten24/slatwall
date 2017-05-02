/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWCriteriaBoolean{
	public static Factory(){
		var directive = (
			collectionPartialsPath,
			hibachiPathBuilder
		)=> new SWCriteriaBoolean(
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
			templateUrl:hibachiPathBuilder.buildPartialsPath(collectionPartialsPath)+'criteriaboolean.html',
			link: function(scope, element, attrs){
				 var getBooleanOptions = function(type){
				 	if(angular.isUndefined(type)){
				 		type = 'filter'
				 	}
				 	var booleanOptions = [];
				 	if(type==='filter'){
				    	booleanOptions = [
				    		{
				    			display:"True",
				    			comparisonOperator:"=",
				    			value:"True"
				    		},
				    		{
				    			display:"False",
				    			comparisonOperator:"=",
				    			value:"False"
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
				 		booleanOptions = [
				 			{
				    			display:"True",
				    			comparisonOperator:"eq",
				    			value:"True"
				    		},
				    		{
				    			display:"False",
				    			comparisonOperator:"eq",
				    			value:"False"
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
			    	return booleanOptions;
			    };

			    scope.conditionOptions = getBooleanOptions(scope.comparisonType);

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
		};
	}
}
export{
	SWCriteriaBoolean
}
