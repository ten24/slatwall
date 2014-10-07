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
			isEditable:"=",
			editing:"=",
			isHidden:"=",
			value:"=",
			valueOptions:"@",
			fieldType:"@",
			property:"@",
			title:"@",
			hint:"@",
			fieldName:"@"
		},
		templateUrl:partialsPath+"propertydisplay.html",
		link: function(scope, element,attrs,formController){
						
			var propertyDisplay = {
				object:scope.object,
				property:scope.property,
				errors:{},
				editing:scope.editing,
				isEditable:scope.isEditable,
				isHidden:scope.isHidden,
				hint:scope.hint,
				fieldType:scope.fieldType,
				value:scope.value,
				valueOptions:scope.valueOptions,
				fieldName:scope.fieldName,
				title:scope.title,
				fieldType:scope.fieldType
			};
			
			scope.propertyDisplay = propertyDisplayService.newPropertyDisplay(propertyDisplay);
			console.log('propertyDisplaytest');
			console.log(propertyDisplay);
			console.log(scope.propertyDisplay);
			console.log(scope.propertyDisplay.fieldType);
			if(!scope.propertyDisplay.fieldType.length && angular.isDefined(scope.object[scope.property].fieldType)){
				scope.propertyDisplay.fieldType = scope.object[scope.property].fieldType;
			}
			if(angular.isDefined(scope.object[scope.property].hint)){
				scope.propertyDisplay.hint = scope.object[scope.property].hint;
				$(function(){
				    $('.j-tool-tip-item').tooltip();
				  });
			}
			
			if(!scope.propertyDisplay.title.length && angular.isDefined(scope.object[scope.property].title)){
				scope.propertyDisplay.title = scope.object[scope.property].title;
			}
			if(angular.isDefined(scope.object[scope.property].value)){
				scope.propertyDisplay.value = scope.object[scope.property].value;
			}
			if(angular.isDefined(scope.object[scope.valueOptions])){
			}
						
			
			$log.debug('propertyDisplay');
			$log.debug(scope.propertyDisplay);
		}
	};
}]);
	
