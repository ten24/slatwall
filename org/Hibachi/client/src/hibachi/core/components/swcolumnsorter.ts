/// <reference path='../../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />
class SWColumnSorter{
	public static Factory(){
		var directive = (
			$log,
			observerService,
			corePartialsPath,
			pathBuilderConfig
		)=> new SWColumnSorter(
			$log,
			observerService,
			corePartialsPath,
			pathBuilderConfig
		);
		directive.$inject = [
			'$log',
			'observerService',
			'corePartialsPath',
			'pathBuilderConfig'
		];
		return directive;
	}
	public constructor(
		$log,
		observerService,
		corePartialsPath,
		pathBuilderConfig
	){
		return {
			restrict: 'AE',
			scope:{
				column:"=",
			},
			templateUrl:pathBuilderConfig.buildPartialsPath(corePartialsPath)+"columnsorter.html",
			link: function(scope, element,attrs){
                var orderBy:any = {
                    "propertyIdentifier":scope.column.propertyIdentifier,
                }
                
                scope.sortAsc = function(){
                    orderBy.direction = 'Asc';
                    this.observerService.notify('sortByColumn',orderBy);
                }
                scope.sortDesc = function(){
                    orderBy.direction = 'Desc';
                    observerService.notify('sortByColumn',orderBy);
                }
                
			}
		};
	}
}
export{
	SWColumnSorter
}
