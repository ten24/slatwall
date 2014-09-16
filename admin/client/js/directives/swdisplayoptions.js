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
			
			jQuery(function($) {
				
			      var panelList = angular.element($element).children('ul');
			      panelList.sortable({
			          // Only make the .panel-heading child elements support dragging.
			          // Omit this to make then entire <li>...</li> draggable.
			          handle: '.s-pannel-name',
			          update: function(event,ui) {
			        	  var tempColumnsArray = [];
			              $('.s-pannel-name', panelList).each(function(index, elem) {
			            	  var newIndex = $(elem).attr('j-column-index');
			            	  var columnItem = $scope.columns[newIndex];
			            	  tempColumnsArray.push(columnItem);
			              });
			              $scope.$apply(function () {
			            	  $scope.columns = tempColumnsArray;
			              });
			              $scope.saveCollection();
			          }
			      });
			  });
		}
	};
}]);


	
	
