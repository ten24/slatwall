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
			columns:'=',
			propertiesList:"=",
			saveCollection:"&"
		},
		templateUrl:partialsPath+"displayoptions.html",
		controller: function($scope,$element,$attrs){
			this.removeColumn = function(columnIndex){
				$log.debug('parent remove column');
				$log.debug($scope.columns);
				if($scope.columns.length){
					$scope.columns.splice(columnIndex, 1);
				}
				
			};
			
			this.getPropertiesList = function(){
				return $scope.propertiesList;
			};
			
			$scope.addColumn = function(selectedProperty){
				$log.debug('add column');
				$log.debug(selectedProperty);
				$log.debug($scope.columns);
				if(angular.isDefined(selectedProperty)){
					var column = {};
					column.title = selectedProperty.displayPropertyIdentifier;
					column.propertyIdentifier = selectedProperty.propertyIdentifier;
					column.isVisible = true;
					$scope.columns.push(column);
					$scope.saveCollection();
				}
				
			};
		}
	};
}]);


	
	
