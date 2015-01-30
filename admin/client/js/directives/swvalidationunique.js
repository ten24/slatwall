/**
 * Validates true if the given object is 'unique' and false otherwise.
 */
angular.module('slatwalladmin').directive("swvalidationunique", function() {
	return {
		restrict : "A",
		require : "ngModel",
		link : function(scope, element, attributes, ngModel) {
			var value = modelValue || viewValue;
			// Lookup user by object
			console.log(scope.propertyDisplay.object.metaData.$$className);
			//Get the object that we need to check for uniqueness.
			return $http.get('/index.cfm?slatAction=api:main.getValidationUniquePropertyStatus&Object=' + attributes.swvalidationunique)
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
	};
});