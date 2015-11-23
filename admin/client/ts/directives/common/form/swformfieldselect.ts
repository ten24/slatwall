/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
module slatwalladmin {

    export class swFormFieldSelect implements ng.IDirective {
        public static $inject = ['$log','$slatwall','formService','partialsPath','utilityService'];
		constructor(public $log, public $slatwall, public formService, public partialsPath, public utilityService){
			this.partialsPath = partialsPath;
			this.$log = $log;
			this.$slatwall = $slatwall;
			this.formService = formService;
			this.partialsPath = partialsPath;
            return this.getInstance(this.$log, this.$slatwall, this.partialsPath);
        }
		/** returns the directive function */
        getInstance($log, $slatwall, partialsPath): any {
            return{
			templateUrl:partialsPath+'formfields/select.html',
			require:"^form",
			restrict: 'E',
			scope:{
				propertyDisplay:"="
			},
			link:function(scope, element, attr, formController){
					
					var selectType;
					
					if(angular.isDefined(scope.propertyDisplay.object.metaData[scope.propertyDisplay.property].fieldtype)){
						selectType = 'object';
						$log.debug('selectType:object');
					}else{
						selectType = 'string';
						$log.debug('selectType:string');
					}
					
					
					scope.formFieldChanged = function(option){
						$log.debug('formfieldchanged');
						$log.debug(option);
						if(selectType === 'object' && typeof scope.propertyDisplay.object.data[scope.propertyDisplay.property].$$getIDName == "function" ){
							scope.propertyDisplay.object.data[scope.propertyDisplay.property]['data'][scope.propertyDisplay.object.data[scope.propertyDisplay.property].$$getIDName()] = option.value;
							if(angular.isDefined(scope.propertyDisplay.form[scope.propertyDisplay.object.data[scope.propertyDisplay.property].$$getIDName()])){
								scope.propertyDisplay.form[scope.propertyDisplay.object.data[scope.propertyDisplay.property].$$getIDName()].$dirty = true;
							}
						}else if(selectType === 'string'){
							scope.propertyDisplay.object.data[scope.propertyDisplay.property] = option.value;
							scope.propertyDisplay.form[scope.propertyDisplay.property].$dirty = true;
							
						}
						
					};
					
					
					scope.getOptions = function(){
						
						if(angular.isUndefined(scope.propertyDisplay.options)){
							
							var optionsPromise = $slatwall.getPropertyDisplayOptions(scope.propertyDisplay.object.metaData.className,
								scope.propertyDisplay.optionsArguments
							);
							optionsPromise.then(function(value){
								scope.propertyDisplay.options = value.data;
								
								if(selectType === 'object'
								){
									if(angular.isUndefined(scope.propertyDisplay.object.data[scope.propertyDisplay.property])){
										scope.propertyDisplay.object.data[scope.propertyDisplay.property] = $slatwall['new'+scope.propertyDisplay.object.metaData[scope.propertyDisplay.property].cfc]();
									}
									
									if(scope.propertyDisplay.object.data[scope.propertyDisplay.property].$$getID() === ''){
										$log.debug('no ID');
										$log.debug(scope.propertyDisplay.object.data[scope.propertyDisplay.property].$$getIDName());
										scope.propertyDisplay.object.data['selected'+scope.propertyDisplay.property] = scope.propertyDisplay.options[0];
										scope.propertyDisplay.object.data[scope.propertyDisplay.property] = $slatwall['new'+scope.propertyDisplay.object.metaData[scope.propertyDisplay.property].cfc]();
										scope.propertyDisplay.object.data[scope.propertyDisplay.property]['data'][scope.propertyDisplay.object.data[scope.propertyDisplay.property].$$getIDName()] = scope.propertyDisplay.options[0].value;
									}else{
										var found = false;
										for(var i in scope.propertyDisplay.options){
											if(angular.isObject(scope.propertyDisplay.options[i].value)){
												$log.debug('isObject');
												$log.debug(scope.propertyDisplay.object.data[scope.propertyDisplay.property].$$getIDName());
												if(scope.propertyDisplay.options[i].value === scope.propertyDisplay.object.data[scope.propertyDisplay.property]){
													scope.propertyDisplay.object.data['selected'+scope.propertyDisplay.property] = scope.propertyDisplay.options[i];
													scope.propertyDisplay.object.data[scope.propertyDisplay.property] = scope.propertyDisplay.options[i].value;
													found = true;
													break;
												}
											}else{
												$log.debug('notisObject');
												$log.debug(scope.propertyDisplay.object.data[scope.propertyDisplay.property].$$getIDName());
												if(scope.propertyDisplay.options[i].value === scope.propertyDisplay.object.data[scope.propertyDisplay.property].$$getID()){
													scope.propertyDisplay.object.data['selected'+scope.propertyDisplay.property] = scope.propertyDisplay.options[i];
													scope.propertyDisplay.object.data[scope.propertyDisplay.property]['data'][scope.propertyDisplay.object.data[scope.propertyDisplay.property].$$getIDName()] = scope.propertyDisplay.options[i].value;
													found = true;
													break;
												}
											}
											if(!found){
												scope.propertyDisplay.object.data['selected'+scope.propertyDisplay.property] = scope.propertyDisplay.options[0];    
											}
										}
										
									}
								}else if(selectType === 'string'){
									if(scope.propertyDisplay.object.data[scope.propertyDisplay.property] !== null){
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
									
								}
								
							});
						}
						
					};
					
					if(scope.propertyDisplay.eagerLoadOptions == true){
						scope.getOptions();
					}
					//formService.setPristinePropertyValue(scope.propertyDisplay.property,scope.propertyDisplay.object[scope.propertyDisplay.valueOptions].value[0]);
					
					if(selectType === 'object'){
						formController[scope.propertyDisplay.property+'ID'].$dirty = scope.propertyDisplay.isDirty;	
					}else if(selectType === 'string'){
						formController[scope.propertyDisplay.property].$dirty = scope.propertyDisplay.isDirty;	
					}
				}
			};//<--end return
        }
	}
	angular.module('slatwalladmin').directive('swFormFieldSelect',['$log','$slatwall','formService','partialsPath','utilityService',($log, $slatwall, formService, partialsPath,utilityService) => new swFormFieldSelect($log, $slatwall, formService, partialsPath,utilityService)]);
}
	
