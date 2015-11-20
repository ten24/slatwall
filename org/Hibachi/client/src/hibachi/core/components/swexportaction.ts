class SWExportAction{
	public static Factory(){
		var directive = (
			$log,
			partialsPath
		)=>new SWExportAction(
			$log,
			partialsPath
		);
		directive.$inject=[
			'$log',
			'partialsPath'
		];
		return directive;
	}
	constructor(
		$log,
		partialsPath
	){
		return {
			restrict:'A',
			templateUrl: partialsPath+'exportaction.html',
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
