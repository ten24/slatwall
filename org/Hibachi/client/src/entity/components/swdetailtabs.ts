/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWDetailTabs{
	public static Factory(){
		var directive = (
			$location,
			$log,
			$hibachi,
			coreEntityPartialsPath,
			pathBuilderConfig
		)=> new SWDetailTabs(
			$location,
			$log,
			$hibachi,
			coreEntityPartialsPath,
			pathBuilderConfig
		);
		directive.$inject = [
			'$location',
			'$log',
			'$hibachi',
			'coreEntityPartialsPath',
			'pathBuilderConfig'
		];
		return directive;
	}
	constructor(
		$location,
		$log,
		$hibachi,
		coreEntityPartialsPath,
		pathBuilderConfig
	){
		return {
	        restrict: 'E',
	        templateUrl:pathBuilderConfig.buildPartialsPath(coreEntityPartialsPath)+'detailtabs.html',
	        link: function (scope, element, attr) {

	        }
	    };
	}
}
export{
	SWDetailTabs
}