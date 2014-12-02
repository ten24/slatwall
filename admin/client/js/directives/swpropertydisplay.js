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
			restrict: 'A',
			scope:{
				object:"=",
				objectName:"@",
				property:"@",
				meta:"=",
				isEditable:"=",
				editing:"=",
				isHidden:"=",
				optionsArguments:"=",
				eagerLoadOptions:"="
				/*value:"=",
				valueOptions:"@",
				fieldType:"@",
				
				title:"@",
				hint:"@",
				fieldName:"@"*/
			},
			templateUrl:partialsPath+"propertydisplay.html",
			link: function(scope, element,attrs){
				
				var propertyDisplay = {
					object:scope.object,
					objectName:scope.objectName,
					property:scope.property,
					meta:scope.meta,
					errors:{},
					editing:scope.editing,
					isEditable:scope.isEditable,
					isHidden:scope.isHidden,
					optionsArguments:scope.optionsArguments,
					eagerLoadOptions:scope.eagerLoadOptions
					/*hint:scope.hint,
					fieldType:scope.fieldType,
					value:scope.value,
					valueOptions:scope.valueOptions,
					fieldName:scope.fieldName,
					title:scope.title,
					fieldType:scope.fieldType*/
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
	
