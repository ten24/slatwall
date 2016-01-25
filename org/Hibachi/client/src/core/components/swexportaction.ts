/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWExportAction{
	public static Factory(){
		var directive = (
			$log,
			corePartialsPath,
			hibachiPathBuilder
		)=>new SWExportAction(
			$log,
			corePartialsPath,
			hibachiPathBuilder
		);
		directive.$inject=[
			'$log',
			'corePartialsPath',
			'hibachiPathBuilder'
		];
		return directive;
	}
    //@ngInject
	constructor(
		$log,
		corePartialsPath,
		hibachiPathBuilder
	){
		return {
			restrict:'A',
			templateUrl: hibachiPathBuilder.buildPartialsPath(corePartialsPath)+'exportaction.html',
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
