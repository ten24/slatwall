/// <reference path='../../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />
class SWColumnSorter{
	public static Factory(){
		var directive = (
			$log,
			observerService,
			partialsPath
		)=> new SWColumnSorter(
			$log,
			observerService,
			partialsPath
		);
		directive.$inject = [
			'$log',
			'observerService',
			'partialsPath'
		];
		return directive;
	}
	public constructor(
		$log,
		observerService,
		partialsPath
	){
		return {
			restrict: 'AE',
			scope:{
				column:"=",
			},
			templateUrl:partialsPath+"columnsorter.html",
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
// angular.module('slatwalladmin')
// .directive('swColumnSorter', [
// '$log',
// 'observerService',
// 'partialsPath',
// 	function(
// 	$log,
//     observerService,
// 	partialsPath
// 	){
// 		return {
// 			restrict: 'AE',
// 			scope:{
// 				column:"=",
// 			},
// 			templateUrl:partialsPath+"columnsorter.html",
// 			link: function(scope, element,attrs){
//                 var orderBy = {
//                     "propertyIdentifier":scope.column.propertyIdentifier,
//                 }
                
//                 scope.sortAsc = function(){
//                     orderBy.direction = 'Asc';
//                     observerService.notify('sortByColumn',orderBy);
//                 }
//                 scope.sortDesc = function(){
//                     orderBy.direction = 'Desc';
//                     observerService.notify('sortByColumn',orderBy);
//                 }
                
// 			}
// 		};
// 	}
// ]);
	
