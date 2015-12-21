/// <reference path='../../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />

class SWCriteria{
	public static Factory(){
		var directive = (
			$log,
			$slatwall,
			$filter,
			collectionPartialsPath,
			collectionService,
			metadataService,
			pathBuilderConfig
		) => new SWCriteria(
			$log,
			$slatwall,
			$filter,
			collectionPartialsPath,
			collectionService,
			metadataService,
			pathBuilderConfig
		);
		directive.$inject = [
			'$log',
			'$slatwall',
			'$filter',
			'collectionPartialsPath',
			'collectionService',
			'metadataService',
			'pathBuilderConfig'
		];
		return directive;
	}
	constructor(
		$log,
		$slatwall,
		$filter,
		collectionPartialsPath,
		collectionService,
		metadataService,
		pathBuilderConfig
	){
		return {
			restrict: 'E',
			scope:{
				filterItem:"=",
		        selectedFilterProperty:"=",
		        filterPropertiesList:"=",
		        selectedFilterPropertyChanged:"&",
		        comparisonType:"="
			},
			templateUrl:pathBuilderConfig.buildPartialsPath(collectionPartialsPath)+'criteria.html',
			link: function(scope, element, attrs){
			}
		};
	}
}
export{
	SWCriteria
}

	
