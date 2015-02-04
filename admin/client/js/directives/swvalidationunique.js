/**
 * Validates true if the given object is 'unique' and false otherwise.
 */
angular.module('slatwalladmin').directive("swvalidationunique", ['$http',  function($http) {
	return {
		restrict : "A",
		require : "ngModel",
		link : function(scope, element, attributes, ngModel) {
			var value = ngModel.modelValue || ngModel.viewValue;
			var valObj = scope.propertyDisplay.object.metaData.$$className; 
			if(angular.isUndefined(scope.propertyDisplay[scope.propertyDisplay.property])){
				return false;
			}else{
				return $http.get('/index.cfm?slatAction=api:main.getValidationPropertyStatus&object=' + 
						valObj + "&propertyidentifier=" + 
						scope.propertyDisplay[scope.propertyDisplay.property] + "&false" )
				.then(function resolved() {
					//If this Object name exists, this means validation fails
					console.log("exists");
					return $q.reject('exists');
				}, function rejected() {
					console.log("does not exists, validation passes");
					//Object name does not exist so this validation passes
					return true; 
				});
			}
			
		}
	};
}]);