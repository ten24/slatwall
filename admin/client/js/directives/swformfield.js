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
				
				/*scope.$watch(scope.propertyDisplay.form[scope.propertyDisplay.property],function(newValue,oldValue){
					$log.debug('field dirty');
				});*/
				
				var templateLoader = getTemplate(scope.propertyDisplay.fieldType);
		    	var promise = templateLoader.success(function(html){
		    		var formfieldTemplate = angular.element(html);
		    		//console.log('formfield');
		    		//console.log(formfield);
		    		//dynamic formfield name mapping
		    		//formfield.attr('name',scope.propertyDisplay.object.metaData.className+'.'+scope.propertyDisplay.property);
		    		
		    		angular.forEach(formfieldTemplate,function(node){
		    			if(angular.isDefined(node.type) && node.type === 'text'){
		    				console.log('found text node');
		    				console.log(node);
		    				node.name = scope.propertyDisplay.object.metaData.className+'.'+scope.propertyDisplay.property;
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
						
						scope.formFieldChanged = function(option){
							$log.debug('formfieldchanged');
							$log.debug(option);
							scope.propertyDisplay.object.data[scope.propertyDisplay.property] = option.value;
							scope.propertyDisplay.object.metaData.form[scope.propertyDisplay.object.metaData.className+'.'+scope.propertyDisplay.property].$dirty = true;
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
						scope.propertyDisplay.options = [
							{
								name:'Yes',
								value:'YES '
							},
							{
								name:'No',
								value:'NO '
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
						
						
						
						//formService.setPristinePropertyValue(scope.propertyDisplay.property,scope.propertyDisplay.object.data[scope.propertyDisplay.property]);
						//scope.propertyDisplay.selectedOptions = scope.propertyDisplay.object.data[scope.propertyDisplay.property];
						/*scope.$watch(,function(newValue,oldValue){
							console.log('setRadio');
							console.log(scope.propertyDisplay.object.data[scope.propertyDisplay.property]);
							console.log(newValue);
							console.log(oldValue);
							if(angular.isUndefined(newValue)){
								
							}
						});*/
					}
					if(angular.isDefined(formController[scope.propertyDisplay.property])){
						scope.propertyDisplay.errors = formController[scope.propertyDisplay.property].$error;
						formController[scope.propertyDisplay.property].formType = scope.propertyDisplay.fieldType;
					}
					console.log('formController');
					console.log(formController);
					scope.propertyDisplay.object.metaData.form = formController;
							
				});
			}
		};
	}
]);
	
