
angular.module('slatwalladmin.services')
.factory('propertyDisplayService',
[
	'$log',
function(
	$log
){
	function _propertyDisplay(propertyDisplay){
		this.object=propertyDisplay.object;
		this.property=propertyDisplay.property;
		this.meta=propertyDisplay.meta;
		this.errors={};
		this.editing=propertyDisplay.editing || false;
		this.isEditable=propertyDisplay.isEditable || false;
		this.isHidden=propertyDisplay.isHidden || false;
		this.fieldType=propertyDisplay.fieldType || '';
		this.fieldName=propertyDisplay.fieldName || '';
		
	}
	
	_propertyDisplay.prototype = {
			
	};
	
	return propertyDisplayService = {
		newPropertyDisplay:function(propertyDisplay){
			return new _propertyDisplay(propertyDisplay);
		}
	};
}]);
