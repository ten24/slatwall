//collection service is used to maintain the state of the ui

angular.module('slatwalladmin.services')
.factory('formService',['$log',
function($log){
	//properties
	var _forms = {};
	
	function form(name,object,editing){
		this.name = name;
		this.object= object;
		this.editing = editing;
	};
	
	return formService = {
		
			
		setForm: function(form){
			_forms[form.$name] = form;
			
		},
		getForm:function(formName){
			return _forms[formName];
		},
		createForm:function(name,object,editing){
			var _form = new form(
				name,
				object,
				editing
			);
			this.setForm(_form);
			return _form;
		}
		//private functions
		
	};
}]);
