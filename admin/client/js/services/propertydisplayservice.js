//collection service is used to maintain the state of the ui

angular.module('slatwalladmin.services')
.factory('propertyDisplayService',
[
	'$log',
function(
	$log
){
	//properties
	function _propertyDisplay(propertyDisplay){
		this.object=propertyDisplay.object;
		this.property=propertyDisplay.property;
		this.errors={};
		this.editing=propertyDisplay.editing || false;
		this.isEditable=propertyDisplay.isEditable || false;
		this.isHidden=propertyDisplay.isHidden || false;
		this.hint=propertyDisplay.hint || '';
		this.fieldType=propertyDisplay.fieldType || '';
		this.value=propertyDisplay.value || '';
		this.valueOptions=propertyDisplay.valueOptions || [];
		this.fieldName=propertyDisplay.fieldName || '';
		this.title=propertyDisplay.title || '';
	}
	
	_propertyDisplay.prototype = {
			
	};
	
	return propertyDisplayService = {
		newPropertyDisplay:function(propertyDisplay){
			return new _propertyDisplay(propertyDisplay);
		}
	};
}]);
