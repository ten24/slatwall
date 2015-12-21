
class SWDetailTabs{
	public static Factory(){
		var directive = (
			$location,
			$log,
			$slatwall,
			coreEntityPartialsPath,
			pathBuilderConfig
		)=> new SWDetailTabs(
			$location,
			$log,
			$slatwall,
			coreEntityPartialsPath,
			pathBuilderConfig
		);
		directive.$inject = [
			'$location',
			'$log',
			'$slatwall',
			'coreEntityPartialsPath',
			'pathBuilderConfig'
		];
		return directive;
	}
	constructor(
		$location,
		$log,
		$slatwall,
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