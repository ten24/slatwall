/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWCriteria{
	public static Factory(){
		var directive = (
			$log,
			$hibachi,
			$filter,
			collectionPartialsPath,
			collectionService,
			metadataService,
			hibachiPathBuilder
		) => new SWCriteria(
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
			scope:{
				filterItem:"=",
		        selectedFilterProperty:"=",
		        filterPropertiesList:"=",
		        selectedFilterPropertyChanged:"&",
		        comparisonType:"=",
                collectionConfig: "="
			},
			templateUrl:hibachiPathBuilder.buildPartialsPath(collectionPartialsPath)+'criteria.html',
			link: function(scope, element, attrs){
			}
		};
	}
}
export{
	SWCriteria
}


