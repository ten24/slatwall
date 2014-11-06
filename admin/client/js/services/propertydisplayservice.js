
angular.module('slatwalladmin.services')
.factory('propertyDisplayService',
[
	'$log',
function(
	$log
){
	function _propertyDisplay(propertyDisplay){
		this.object=propertyDisplay.object;
		this.objectName=propertyDisplay.objectName || '';
		this.property=propertyDisplay.property;
		this.meta=propertyDisplay.meta;
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
		this.optionsArguments=propertyDisplay.optionsArguments || {};
		this.eagerLoadOptions=propertyDisplay.eagerLoadOptions || false;
		
	}
	
	_propertyDisplay.prototype = {
			
	};
	
	return propertyDisplayService = {
		newPropertyDisplay:function(propertyDisplay){
			return new _propertyDisplay(propertyDisplay);
		}
	};
}]);
