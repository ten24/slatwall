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
			restrict: 'A',
			scope:{
				object:"=",
				property:"@",
				isEditable:"=",
				editing:"=",
				isHidden:"=",
				optionsArguments:"=",
				eagerLoadOptions:"="
			},
			templateUrl:partialsPath+"propertydisplay.html",
			link: function(scope, element,attrs,formController){
				
				console.log(formController);
				
				var propertyDisplay = {
					object:scope.object,
					property:scope.property,
					errors:{},
					editing:scope.editing,
					isEditable:scope.isEditable,
					isHidden:scope.isHidden,
					optionsArguments:scope.optionsArguments,
					eagerLoadOptions:scope.eagerLoadOptions
				};
				
				scope.$id = 'propertyDisplay:'+scope.property;
				scope.propertyDisplay = propertyDisplayService.newPropertyDisplay(propertyDisplay);
				
				$log.debug(scope.propertyDisplay);
							
				
				$log.debug('propertyDisplay');
				$log.debug(scope.propertyDisplay);
			}
		};
	}
]);
	
