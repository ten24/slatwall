angular.module('slatwalladmin')
.directive('swPropertyDisplay', 
[
'$log',
'partialsPath',
function(
$log,
partialsPath
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
			type:"@",
			property:"@",
			title:"@",
			hint:"@",
			fieldName:"@",
			fieldType:"@"
		},
		templateUrl:partialsPath+"propertydisplay.html",
		link: function(scope, element,attrs,formController){
			var unBindObjectWatch = scope.$watch('object',function(newValue,oldValue){
				if(newValue !== oldValue){
					if(angular.isDefined(scope.object)){
						
						scope.propertyDisplay = {
							object:scope.object,
							property:scope.property,
							errors:{},
							editing:scope.editing,
							isEditable:scope.isEditable,
							isHidden:scope.isHidden,
							hint:scope.hint,
							type:scope.type,
							value:scope.value,
							valueOptions:scope.valueOptions,
							fieldName:scope.fieldName,
						};
						if(angular.isDefined(scope.object[scope.property].type)){
							scope.propertyDisplay.type = scope.object[scope.property].type;
						}
						if(angular.isDefined(scope.object[scope.property].hint)){
							scope.propertyDisplay.hint = scope.object[scope.property].hint;
							$(function(){
							    $('.j-tool-tip-item').tooltip();
							  });
						}
						if(angular.isDefined(scope.object[scope.property].title)){
							scope.propertyDisplay.title = scope.object[scope.property].title;
						}
						if(angular.isDefined(scope.object[scope.property].value)){
							scope.propertyDisplay.value = scope.object[scope.property].value;
						}
						if(angular.isDefined(scope.object[scope.valueOptions])){
							console.log('valueOptions');
							console.log(scope.valueOptions);
						}
						
						
						unBindObjectWatch();
					}
					
				}
			});
			
			$log.debug('propertyDisplay');
			$log.debug(scope.propertyDisplay);
		}
	};
}]);
	
