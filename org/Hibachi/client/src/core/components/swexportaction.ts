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
