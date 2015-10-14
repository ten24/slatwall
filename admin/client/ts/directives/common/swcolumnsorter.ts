angular.module('slatwalladmin')
.directive('swColumnSorter', [
'$log',
'observerService',
'partialsPath',
	function(
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
                var orderBy = {
                    "propertyIdentifier":scope.column.propertyIdentifier,
                }
                
                scope.sortAsc = function(){
                    orderBy.direction = 'Asc';
                    observerService.notify('sortByColumn',orderBy);
                }
                scope.sortDesc = function(){
                    orderBy.direction = 'Desc';
                    observerService.notify('sortByColumn',orderBy);
                }
                
			}
		};
	}
]);
	
