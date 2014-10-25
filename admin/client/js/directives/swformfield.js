angular.module('slatwalladmin')
.directive('swFormField', 
[
'$log',
'$templateCache',
'$http',
'$compile',
'$window',
'$slatwall',
'formService',
'partialsPath',
function(
$log,
$templateCache,
$http,
$compile,
$window,
$slatwall,
formService,
partialsPath
){
	var getTemplate = function(templateType){
		var templatePath = '';
		switch(templateType){
			case 'hidden':
			case 'text':
				templatePath = partialsPath + 'formfields/text.html';
				break;
			case 'select':
				templatePath = partialsPath + 'formfields/select.html';
				break;
			case 'yesno':
				templatePath = partialsPath + 'formfields/radio.html';
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
		
			scope.$id = 'formField:'+scope.propertyDisplay.property;			
					
			scope.revertValue = angular.copy(scope.propertyDisplay);
			
			scope.formFieldChanged = function(value){
				$log.debug('formfieldchanged');
				$log.debug(value);
			}
			
			var templateLoader = getTemplate(scope.propertyDisplay.meta.fieldType);
	    	var promise = templateLoader.success(function(html){
	    		var formfield = angular.element(html);
	    		//dynamic formfield name mapping
	    		formfield.attr('name',scope.propertyDisplay.property);
	    		
	    		if(angular.isDefined(scope.propertyDisplay.object.validation) && angular.isDefined(scope.propertyDisplay.object.validation.properties[scope.propertyDisplay.property.split('.').pop()])){
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
				
				if(scope.propertyDisplay.meta.fieldType === 'select'){
					scope.getOptions = function(){
						if(angular.isUndefined(scope.propertyDisplay.meta.options)){
							
							var optionsPromise = $slatwall.getPropertyDisplayOptions('product',
								 scope.propertyDisplay.optionsArguments
							);
							optionsPromise.then(function(value){
								scope.propertyDisplay.meta.options = value.data;
								//var selectElement = element.find('select');
								//selectElement.blur();
								if(angular.isDefined(scope.propertyDisplay.object[scope.propertyDisplay.property])){
									for(var i in scope.propertyDisplay.meta.options){
										if(scope.propertyDisplay.meta.options[i].value === scope.propertyDisplay.object[scope.propertyDisplay.property]){
											scope.propertyDisplay.selectedOption = scope.propertyDisplay.meta.options[i];
										}
									}
								}
							});
						}
						
					};
					if(scope.propertyDisplay.eagerLoadOptions === true){
						scope.getOptions();
					}
		        	//formService.setPristinePropertyValue(scope.propertyDisplay.property,scope.propertyDisplay.object[scope.propertyDisplay.valueOptions].value[0]);
		        }
				if(scope.propertyDisplay.meta.fieldType === 'text' || scope.propertyDisplay.meta.fieldType === 'hidden'){
					formService.setPristinePropertyValue(scope.propertyDisplay.property,scope.propertyDisplay.object[scope.propertyDisplay.property]);
				}
				if(scope.propertyDisplay.meta.fieldType === 'yesno' || scope.propertyDisplay.meta.fieldType === 'hidden'){
					formService.setPristinePropertyValue(scope.propertyDisplay.property,scope.propertyDisplay.object[scope.propertyDisplay.property]);
					console.log('radio');
					console.log(scope.propertyDisplay.object[scope.propertyDisplay.property]);
					scope.propertyDisplay.selectedOptions = scope.propertyDisplay.object[scope.propertyDisplay.property];
				}
				
				if(angular.isDefined(formController[scope.propertyDisplay.property])){
					scope.propertyDisplay.errors = formController[scope.propertyDisplay.property].$error;
				}
				
				scope.propertyDisplay.form = formController;
						
			});
		}
	};
}]);
	
