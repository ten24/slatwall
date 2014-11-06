angular.module('slatwalladmin')
.directive('swPropertyDisplay', 
[
'$log',
'partialsPath',
'propertyDisplayService',
function(
$log,
partialsPath,
propertyDisplayService
){
	return {
		restrict: 'A',
		scope:{
			object:"=",
			property:"@",
			isEditable:"=",
			editing:"=",
			isHidden:"=",
		},
		templateUrl:partialsPath+"propertydisplay.html",
		link: function(scope, element,attrs){
			
			var propertyDisplay = {
				object:scope.object,
				property:scope.property,
				errors:{},
				editing:scope.editing,
				isEditable:scope.isEditable,
				isHidden:scope.isHidden,
			};
			
			scope.$id = 'propertyDisplay:'+scope.property;
			scope.propertyDisplay = propertyDisplayService.newPropertyDisplay(propertyDisplay);
			$log.debug(scope.propertyDisplay);
						
			
			$log.debug('propertyDisplay');
			$log.debug(scope.propertyDisplay);
		}
	};
}]);
	
