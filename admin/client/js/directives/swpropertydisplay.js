angular.module('slatwalladmin')
.directive('swPropertyDisplay', [
'$log',
'partialsPath',
	function(
	$log,
	partialsPath
	){
		return {
			require:'^form',
			restrict: 'AE',
			scope:{
				object:"=",
				property:"@",
				editable:"=",
				editing:"=",
				isHidden:"=",
				title:"=",
				hint:"=",
				optionsArguments:"=",
				eagerLoadOptions:"=",
				isDirty:"=",
				onChange:"="
			},
			templateUrl:partialsPath+"propertydisplay.html",
			link: function(scope, element,attrs,formController){
				//if the item is new, then all fields at the object level are dirty
				$log.debug('editingproper');
				$log.debug(scope.property);
				$log.debug(scope.editable);
				
				scope.propertyDisplay = {
					object:scope.object,
					property:scope.property,
					errors:{},
					editing:scope.editing,
					editable:scope.editable,
					isHidden:scope.isHidden,
					fieldType:scope.fieldType || scope.object.metaData.$$getPropertyFieldType(scope.property),
					title: scope.title || scope.object.metaData.$$getPropertyTitle(scope.property),
					hint:scope.hint || scope.object.metaData.$$getPropertyHint(scope.property),
					optionsArguments:scope.optionsArguments || {},
					eagerLoadOptions:scope.eagerLoadOptions || true,
					isDirty:scope.isDirty,
					onChange:scope.onChange
				};
				
				if(angular.isUndefined(scope.editable)){
					scope.propertyDisplay.editable = true;
				};
				
				if(angular.isUndefined(scope.editing)){
					scope.propertyDisplay.editing = false;
				};
				
				if(angular.isUndefined(scope.isHidden)){
					scope.propertyDisplay.isHidden = false;
				}
				
				
				scope.$id = 'propertyDisplay:'+scope.property;
				
				/* register form that the propertyDisplay belongs to*/
				scope.propertyDisplay.form = formController;
				
				$log.debug(scope.propertyDisplay);
							
				
				$log.debug('propertyDisplay');
				$log.debug(scope.propertyDisplay);
			}
		};
	}
]);
	
