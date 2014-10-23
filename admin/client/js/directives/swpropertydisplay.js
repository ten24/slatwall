angular.module('slatwalladmin')
.directive('swPropertyDisplay', 
[
'$log',
'partialsPath',
'propertyDisplayService',
function(
$log,
partialsPath,
propertyDisplayService
){
	return {
		require:"^form",
		restrict: 'A',
		scope:{
			object:"=",
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
		link: function(scope, element,attrs,formController){
			
			var propertyDisplay = {
				object:scope.object,
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
			/*if(!scope.propertyDisplay.fieldType.length && angular.isDefined(scope.meta[scope.property].fieldType)){
				scope.propertyDisplay.fieldType = scope.meta[scope.property].fieldType;
			}
			if(angular.isDefined(scope.meta[scope.property].hint)){
				scope.propertyDisplay.hint = scope.meta[scope.property].hint;
				$(function(){
				    $('.j-tool-tip-item').tooltip();
				  });
			}
			
			if(!scope.propertyDisplay.title.length && angular.isDefined(scope.meta[scope.property].title)){
				scope.propertyDisplay.title = scope.meta[scope.property].title;
			}
			if(angular.isDefined(scope.object[scope.property])){
				scope.propertyDisplay.value = scope.object[scope.property];
			}
			if(angular.isDefined(scope.object[scope.valueOptions])){
			}*/
						
			
			$log.debug('propertyDisplay');
			$log.debug(scope.propertyDisplay);
		}
	};
}]);
	
