angular.module('slatwalladmin')
.directive('swDisplayOptions',
['$http',
'$compile',
'$templateCache',
'collectionService',
'partialsPath',
'$log',
function($http,
$compile,
$templateCache,
collectionService,
partialsPath,
$log){
	return {
		restrict: 'A',
		transclude:true,
		scope:{
			columns:'='
		},
		templateUrl:partialsPath+"displayOptions.html",
		controller: function($scope,$element,$attrs){
			/*var Partial = partialsPath+"displayOptions.html";
			var templateLoader = $http.get(Partial,{cache:$templateCache});
			var promise = templateLoader.success(function(html){
				$element.html(html);
			}).then(function(response){
				$element.replaceWith($compile($element.html())($scope));
			});*/
			this.removeColumn = function(columnIndex){
				$log.debug('parent remove column');
				$log.debug($scope.columns);
				if($scope.columns.length){
					$scope.columns.splice(columnIndex, 1);
				}
				
			};
			
		    
		}
	};
}]);


	
	
