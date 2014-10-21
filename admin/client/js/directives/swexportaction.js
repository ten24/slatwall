angular.module('slatwalladmin')
.directive('swExportAction',
['partialsPath', 
'$log',
function(
partialsPath,
$log){
	return {
		restrict:'A',
		templateUrl: partialsPath+'exportaction.html',
		scope: {
		},
		link:function(scope,element,attrs){
		}
	};
}]);
	
