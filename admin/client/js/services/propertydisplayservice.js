'use strict';
angular.module('slatwalladmin')
.factory('propertyDisplayService', [
	'$log',
	function(
			$log
	){
		function _propertyDisplay(propertyDisplay){
			this.object=propertyDisplay.object;
			this.property=propertyDisplay.property;
			this.errors={};
			this.editing=propertyDisplay.editing || false;
			this.isEditable=propertyDisplay.isEditable || false;
			this.isHidden=propertyDisplay.isHidden || false;
			//this.fieldType=propertyDisplay.fieldType || this.object.metaData.$$getPropertyFieldType(propertyDisplay.property);
			/*this.fieldName=propertyDisplay.fieldName || this.object.metaData.$$getPropertyFieldName(propertyDisplay.property);*/
			this.title = propertyDisplay.title || this.object.metaData.$$getPropertyTitle(propertyDisplay.property);
			//this.title = propertyDisplay.title || this.object.metaData[this.property];
			//this.hint = propertyDisplay.hint || this.object.metaData.$$getPropertyHint(propertyDisplay.property);
			this.optionsArguments=propertyDisplay.optionsArguments || {};
			this.eagerLoadOptions=propertyDisplay.eagerLoadOptions || true;
			this.isDirty = propertyDisplay.isDirty || false;
			this.onChange = propertyDisplay.onChange || function(){};
		}
		
		_propertyDisplay.prototype = {
				
		};
		
		var propertyDisplayService = {
			newPropertyDisplay:function(propertyDisplay){
				return new _propertyDisplay(propertyDisplay);
			}
		};
		
		return propertyDisplayService;
	}
]);
