angular.module('slatwalladmin')
.directive('swFormField', 
[
'$log',
'$templateCache',
'$http',
'$compile',
'formService',
'partialsPath',
function(
$log,
$templateCache,
$http,
$compile,
formService,
partialsPath
){
	var getTemplate = function(templateType){
		var templatePath = '';
		switch(templateType){
			case 'text':
				templatePath = partialsPath + 'formfields/text.html';
				break;
			case 'select':
				templatePath = partialsPath + 'formfields/select.html';
				break;
		};
		
		var templateLoader = $http.get(templatePath,{cache:$templateCache});
		
        return templateLoader;
	};
	
	return {
		require:"^form",
		restrict: 'A',
		scope:{
			propertyDisplay:"="
		},
		replace:true,
		link: function(scope, element,attrs, formController){
			scope.formFieldChanged = function(value){
				$log.debug('formfieldChanged');
				$log.debug(value);
				scope.propertyDisplay.errorMessages = [];
				if(formController[scope.propertyDisplay.property].$invalid && formController[scope.propertyDisplay.property].$dirty){
					for(key in formController[scope.propertyDisplay.property].$error){
						
						var errorMessage = '';
						if(key === 'required'){
							errorMessage = scope.propertyDisplay.title+' is required';
						}
						
						scope.propertyDisplay.errorMessages.push(errorMessage);
						console.log(scope.propertyDisplay.errorMessages);
					}
				};
				
			};
			
			//as soon as we get data compile the web componenet
			var unBindWatch = scope.$watch('propertyDisplay',function(newValue,oldValue){
				if(newValue !== oldValue){
					var templateLoader = getTemplate(newValue.type);
			    	var promise = templateLoader.success(function(html){
			    		var formfield = angular.element(html);
			    		//dynamic formfield name mapping
			    		formfield.attr('name',scope.propertyDisplay.property);
			    		if(angular.isDefined(scope.propertyDisplay.object.validation.properties[scope.propertyDisplay.property.split('.').pop()])){
			    			var validationProperties = scope.propertyDisplay.object.validation.properties[scope.propertyDisplay.property.split('.').pop()];
			    			for(i in validationProperties){
			    				for(key in validationProperties[i]){
			    					var validationProperty = validationProperties[i];
			    					if(key === 'required'){
			    						formfield.attr(key,validationProperty[key]);
			    					}
			    				}
			    			}
			    		}
			    		element.html(formfield);
						$compile(element.contents())(scope);
						if(scope.propertyDisplay.type === 'select'){
				        	scope.propertyDisplay.value = scope.propertyDisplay.object[scope.propertyDisplay.valueOptions].value[0];
				        }
				        
						unBindWatch();
					});
				}
			});
		}
	};
}]);
	
