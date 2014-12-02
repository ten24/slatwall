angular.module('slatwalladmin')
.directive('swPropertyDisplay', [
'$log',
'partialsPath',
'propertyDisplayService',
	function(
	$log,
	partialsPath,
	propertyDisplayService
	){
		return {
			require:'^form',
			restrict: 'AE',
			scope:{
				object:"=",
				property:"@",
				isEditable:"=",
				editing:"=",
				isHidden:"=",
				optionsArguments:"=",
				eagerLoadOptions:"=",
				isDirty:"=",
				onChange:"="
			},
			templateUrl:partialsPath+"propertydisplay.html",
			link: function(scope, element,attrs,formController){
				//if the item is new, then all fields at the object level are dirty

				var propertyDisplay = {
					object:scope.object,
					property:scope.property,
					errors:{},
					editing:scope.editing,
					isEditable:scope.isEditable,
					isHidden:scope.isHidden,
					optionsArguments:scope.optionsArguments,
					eagerLoadOptions:scope.eagerLoadOptions,
					isDirty:scope.isDirty,
					onChange:scope.onChange
				};
				
				scope.$id = 'propertyDisplay:'+scope.property;
				

				
				scope.propertyDisplay = propertyDisplayService.newPropertyDisplay(propertyDisplay);
				
				/* register form that the propertyDisplay belongs to*/
				scope.propertyDisplay.form = formController;
				
				$log.debug(scope.propertyDisplay);
							
				
				$log.debug('propertyDisplay');
				$log.debug(scope.propertyDisplay);
			}
		};
	}
]);
	
