/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWExportAction{
	public static Factory(){
		var directive = (
			$log,
			corePartialsPath,
			pathBuilderConfig
		)=>new SWExportAction(
			$log,
			corePartialsPath,
			pathBuilderConfig
		);
		directive.$inject=[
			'$log',
			'corePartialsPath',
			'pathBuilderConfig'
		];
		return directive;
	}
    //@ngInject
	constructor(
		$log,
		corePartialsPath,
		pathBuilderConfig
	){
		return {
			restrict:'A',
			templateUrl: pathBuilderConfig.buildPartialsPath(corePartialsPath)+'exportaction.html',
			scope: {
			},
			link:function(scope,element,attrs){
			}
		};
	}
}
export{
	SWExportAction
}
