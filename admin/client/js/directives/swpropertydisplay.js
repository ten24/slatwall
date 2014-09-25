angular.module('slatwalladmin')
.directive('swPropertyDisplay', 
[
'partialsPath',
'$log',
function(
partialsPath,
$log){
	return {
		require:"^swForm",
		restrict: 'A',
		scope:{
			object:"=",
			property:"@",
			isEditable:"=",
			isHidden:"="
		},
		templateUrl:partialsPath+"propertydisplay.html",
		link: function(scope, element,attrs,formController){
			$log.debug(scope.object);
			$log.debug(scope.property);
			$log.debug(scope.isEditable);
			
			$scope.propertyDisplay = {
				form:formController.formName,
				errorMessage:{},
				editing:false
			
			};
		}
	};
}]);
	
