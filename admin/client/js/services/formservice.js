//collection service is used to maintain the state of the ui

angular.module('slatwalladmin.services')
.factory('formService',['$log',
function($log){
	//properties
	var _forms = {};
	
	return formService = {
		setForm: function(form){
			_forms[form.$name] = form;
		},
		getForm:function(formName){
			return _form[formName];
		}
		
		//private functions
		
	};
}]);
