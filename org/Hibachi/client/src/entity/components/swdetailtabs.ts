/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWDetailTabs{
	public static Factory(){
		var directive = (
			$location,
			$log,
			$hibachi,
			coreEntityPartialsPath,
			hibachiPathBuilder
		)=> new SWDetailTabs(
			$location,
			$log,
			$hibachi,
			coreEntityPartialsPath,
			hibachiPathBuilder
		);
		directive.$inject = [
			'$location',
			'$log',
			'$hibachi',
			'coreEntityPartialsPath',
			'hibachiPathBuilder'
		];
		return directive;
	}
	constructor(
		$location,
		$log,
		$hibachi,
		coreEntityPartialsPath,
		hibachiPathBuilder
	){
		return {
	        restrict: 'E',
	        templateUrl:hibachiPathBuilder.buildPartialsPath(coreEntityPartialsPath)+'detailtabs.html',
	        link: function (scope, element, attr) {

	        }
	    };
	}
}
export{
	SWDetailTabs
}