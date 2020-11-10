/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWColumnSorter{
	public static Factory(){
		var directive = (
			observerService,
			corePartialsPath,
			hibachiPathBuilder
		)=> new SWColumnSorter(
			observerService,
			corePartialsPath,
			hibachiPathBuilder
		);
		directive.$inject = [
			'observerService',
			'corePartialsPath',
			'hibachiPathBuilder'
		];
		return directive;
	}
    //@ngInject
	public constructor(
		observerService,
		corePartialsPath,
		hibachiPathBuilder
	){
		return {
			restrict: 'AE',
			scope:{
				column:"=",
			},
			templateUrl:hibachiPathBuilder.buildPartialsPath(corePartialsPath)+"columnsorter.html",
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
