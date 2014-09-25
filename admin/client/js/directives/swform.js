angular.module('slatwalladmin')
.directive('swForm', 
[
'formService',
'partialsPath',
'$log',
function(
formService,
partialsPath,
$log){
	return {
		restrict: 'A',
		transclude:true,
		scope:{
			formName:"="
		},
		templateUrl:partialsPath+'form.html',
		link: function(scope, element,attrs){
			formService.setForm(scope.formName);
			
			this.formName = scope.formName;
			
			/*var isFormValid = function (angularForm){
				$log.debug('validateForm');
				var formValid = true;
			     for (var field in angularForm) {
			         // look at each form input with a name attribute set
			         // checking if it is pristine and not a '$' special field
			         if (field[0] != '$') {
					 	// need to use formValid variable instead of formController.$valid because checkbox dropdown is not an input
						// and somehow formController didn't invalid if checkbox dropdown is invalid
					 	if (angularForm[field].$invalid) {
							formValid = false;
							for(var error in angularForm[field].$error){
								if(error == 'required'){
									$scope.errorMessage[field] = 'This field is required';
								}
							}
							
						}
						if (angularForm[field].$pristine) {
							if (angular.isUndefined(angularForm[field].$viewValue)) { 
								angularForm[field].$setViewValue("");
							}
							else {
								angularForm[field].$setViewValue(angularForm[field].$viewValue);
							}
						}
			         }
			     }
				 return formValid;   
			};*/
		}
	};
}]);
	
