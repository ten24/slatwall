angular.module('slatwalladmin')
.directive('swFormField', [
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
			link: function(scope, element,attrs,formController){
			
				scope.$id = 'formField:'+scope.propertyDisplay.property;			
						
				scope.revertValue = angular.copy(scope.propertyDisplay);
				
				var templateLoader = getTemplate(scope.propertyDisplay.fieldType);
		    	var promise = templateLoader.success(function(html){
		    		var formfieldTemplate = angular.element(html);
		    		
		    		angular.forEach(formfieldTemplate,function(node){
		    			if(angular.isDefined(node.type) && node.type === 'text'){
		    				node.name = scope.propertyDisplay.property;
		    			}
		    		});
		    		
		    		/*if(angular.isDefined(scope.propertyDisplay.object.validation) && angular.isDefined(scope.propertyDisplay.object.validation.properties[scope.propertyDisplay.property.split('.').pop()])){
		    			var validationProperties = scope.propertyDisplay.object.validation.properties[scope.propertyDisplay.property.split('.').pop()];
		    			for(var i in validationProperties){
		    				for(key in validationProperties[i]){
		    					var validationProperty = validationProperties[i];
		    					if(key === 'required'){
		    						formfield.attr(key,validationProperty[key]);
		    					}
		    				}
		    			}
		    		}*/
		    		element.html(formfieldTemplate);
					$compile(element.contents())(scope);
					
					if(scope.propertyDisplay.fieldType === 'select'){
						scope.formFieldChanged = function(option){
							$log.debug('formfieldchanged');
							$log.debug(option);
							scope.propertyDisplay.object.data[scope.propertyDisplay.property] = option.value;
							scope.propertyDisplay.form[scope.propertyDisplay.property].$dirty = true;
						};
						
						scope.getOptions = function(){
							if(angular.isUndefined(scope.propertyDisplay.options)){
								
								var optionsPromise = $slatwall.getPropertyDisplayOptions(scope.propertyDisplay.object.metaData.className,
									 scope.propertyDisplay.optionsArguments
								);
								optionsPromise.then(function(value){
									scope.propertyDisplay.options = value.data;
									//var selectElement = element.find('select');
									//selectElement.blur();
									
									if(angular.isDefined(scope.propertyDisplay.object.data[scope.propertyDisplay.property])){
										for(var i in scope.propertyDisplay.options){
											if(scope.propertyDisplay.options[i].value === scope.propertyDisplay.object.data[scope.propertyDisplay.property]){
												scope.propertyDisplay.object.data['selected'+scope.propertyDisplay.property] = scope.propertyDisplay.options[i];
												scope.propertyDisplay.object.data[scope.propertyDisplay.property] = scope.propertyDisplay.options[i].value;
											}
										}
									}else{
										scope.propertyDisplay.object.data['selected'+scope.propertyDisplay.property] = scope.propertyDisplay.options[0];
										scope.propertyDisplay.object.data[scope.propertyDisplay.property] = scope.propertyDisplay.options[0].value;
									}
									
								});
							}
							
						};
						
						if(scope.propertyDisplay.eagerLoadOptions === true){
							scope.getOptions();
						}
			        	//formService.setPristinePropertyValue(scope.propertyDisplay.property,scope.propertyDisplay.object[scope.propertyDisplay.valueOptions].value[0]);
			        }
					if(scope.propertyDisplay.fieldType === 'text' || scope.propertyDisplay.fieldType === 'hidden'){
						formService.setPristinePropertyValue(scope.propertyDisplay.property,scope.propertyDisplay.object.data[scope.propertyDisplay.property]);
					}
					if(scope.propertyDisplay.fieldType === 'yesno' || scope.propertyDisplay.fieldType === 'hidden'){
						//format value
						console.log('format');
						console.log(scope.propertyDisplay.object.data[scope.propertyDisplay.property]);
						/*convert boolean to number*/
						scope.propertyDisplay.object.data[scope.propertyDisplay.property] = scope.propertyDisplay.object.data[scope.propertyDisplay.property] === 'YES ' || scope.propertyDisplay.object.data[scope.propertyDisplay.property] == 1 ? 1 : 0;
						console.log(scope.propertyDisplay.object.data[scope.propertyDisplay.property]);
						scope.formFieldChanged = function(option){
							$log.debug('formfieldchanged');
							$log.debug(option);
							scope.propertyDisplay.object.data[scope.propertyDisplay.property] = option.value;
							scope.propertyDisplay.form[scope.propertyDisplay.property].$dirty = true;
							scope.propertyDisplay.form['selected'+scope.propertyDisplay.object.metaData.className+scope.propertyDisplay.property].$dirty = false;
						};
						
						scope.propertyDisplay.options = [
							{
								name:'Yes',
								value:1
							},
							{
								name:'No',
								value:0
							}
						];
						if(angular.isDefined(scope.propertyDisplay.object.data[scope.propertyDisplay.property])){
							for(var i in scope.propertyDisplay.options){
								if(scope.propertyDisplay.options[i].value === scope.propertyDisplay.object.data[scope.propertyDisplay.property]){
									scope.selected = scope.propertyDisplay.options[i];
									scope.propertyDisplay.object.data[scope.propertyDisplay.property] = scope.propertyDisplay.options[i].value;
								}
							}
						}else{
							scope.selected = scope.propertyDisplay.options[0];
							scope.propertyDisplay.object.data[scope.propertyDisplay.property] = scope.propertyDisplay.options[0].value;
						}
						
					}
					if(angular.isDefined(formController[scope.propertyDisplay.property])){
						scope.propertyDisplay.errors = formController[scope.propertyDisplay.property].$error;
						formController[scope.propertyDisplay.property].formType = scope.propertyDisplay.fieldType;
					}
							
				});
			}
		};
	}
]);
	
