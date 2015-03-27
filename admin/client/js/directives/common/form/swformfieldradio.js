angular.module('slatwalladmin')
.directive('swFormFieldRadio', [
'$log',
'$timeout',
'$slatwall',
'formService',
'partialsPath',
	function(
	$log,
	$timeout,
	$slatwall,
	formService,
	partialsPath
	){
		return{
			templateUrl:partialsPath+'formfields/radio.html',
			require:"^form",
			restrict: 'E',
			scope:{
				propertyDisplay:"="
			},
			link:function(scope,element,attr,formController){
				var makeRandomID = function makeid(count)
				{
				    var text = "";
				    var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
				
				    for( var i=0; i < count; i++ )
				        text += possible.charAt(Math.floor(Math.random() * possible.length));
				
				    return text;
				};
				if(scope.propertyDisplay.fieldType === 'yesno'){
					//format value
					scope.selectedRadioFormName = makeRandomID(26);

					scope.propertyDisplay.object.data[scope.propertyDisplay.property] = scope.propertyDisplay.object.data[scope.propertyDisplay.property] === 'YES ' || scope.propertyDisplay.object.data[scope.propertyDisplay.property] == 1 ? 1 : 0;
					scope.formFieldChanged = function(option){
						$log.debug('formfieldchanged');
						$log.debug(option);
						scope.propertyDisplay.object.data[scope.propertyDisplay.property] = option.value;
						scope.propertyDisplay.form[scope.propertyDisplay.property].$dirty = true;
						scope.propertyDisplay.form['selected'+scope.propertyDisplay.object.metaData.className+scope.propertyDisplay.property+scope.selectedRadioFormName].$dirty = false;
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
					
					$timeout(function(){
						scope.propertyDisplay.form[scope.propertyDisplay.property].$dirty = scope.propertyDisplay.isDirty;
					});
					
				}
			}
		};
	}
]);
	
