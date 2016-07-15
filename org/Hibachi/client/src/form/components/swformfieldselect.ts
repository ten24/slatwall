/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWFormFieldSelect implements ng.IDirective {
	public static Factory(){
		var directive = (
			$log,
			$hibachi,
			formService,
			coreFormPartialsPath,
			utilityService,
            observerService,
			hibachiPathBuilder
		)=>new SWFormFieldSelect(
			$log,
			$hibachi,
			formService,
			coreFormPartialsPath,
			utilityService,
            observerService,
			hibachiPathBuilder
		);
		directive.$inject = [
			'$log',
			'$hibachi',
			'formService',
			'coreFormPartialsPath',
			'utilityService',
            'observerService',
			'hibachiPathBuilder'
		];
		return directive;
	}
	//@ngInject
	constructor(
		$log,
		$hibachi,
		formService,
		coreFormPartialsPath,
		utilityService,
        observerService,
		hibachiPathBuilder
	){
		return{
			templateUrl:hibachiPathBuilder.buildPartialsPath(coreFormPartialsPath)+'select.html',
			require:"^form",
			restrict: 'E',
			scope:{
				propertyDisplay:"="
			},
			link:function(scope, element, attr, formController){
				
				    var propertyMetaData = scope.propertyDisplay.object.metaData[scope.propertyDisplay.property];

					if(angular.isDefined(propertyMetaData.fieldtype)){
						scope.selectType = 'object';
						$log.debug('selectType:object');
					}else{
                        scope.selectType = 'string';
						$log.debug('selectType:string');
					}
					if(angular.isDefined(propertyMetaData.fkcolumn)){
						scope.fieldName = scope.propertyDisplay.property + "." + propertyMetaData.fkcolumn;
					}

					scope.formFieldChanged = function(option){
						if(scope.selectType === 'object' && typeof scope.propertyDisplay.object.data[scope.propertyDisplay.property].$$getIDName == "function" ){
							scope.propertyDisplay.object.data[scope.propertyDisplay.property]['data'][scope.propertyDisplay.object.data[scope.propertyDisplay.property].$$getIDName()] = option.value;
							if(angular.isDefined(scope.propertyDisplay.form[scope.propertyDisplay.object.data[scope.propertyDisplay.property].$$getIDName()])){
								scope.propertyDisplay.form[scope.propertyDisplay.object.data[scope.propertyDisplay.property].$$getIDName()].$dirty = true;
							}
						}else if(scope.selectType === 'string'){
							scope.propertyDisplay.object.data[scope.propertyDisplay.property] = option.value;
							scope.propertyDisplay.form[scope.propertyDisplay.property].$dirty = true;
						}
                        observerService.notify(scope.propertyDisplay.object.metaData.className+scope.propertyDisplay.property.charAt(0).toUpperCase()+scope.propertyDisplay.property.slice(1)+'OnChange', option);
					};


					scope.getOptions = function(){

						if(angular.isUndefined(scope.propertyDisplay.options)){

							var optionsPromise = $hibachi.getPropertyDisplayOptions(scope.propertyDisplay.object.metaData.className,
								scope.propertyDisplay.optionsArguments
							);
							optionsPromise.then(function(value){
								scope.propertyDisplay.options = value.data;

								if(scope.selectType === 'object'
								){
									if(angular.isUndefined(scope.propertyDisplay.object.data[scope.propertyDisplay.property])){
										scope.propertyDisplay.object.data[scope.propertyDisplay.property] = $hibachi['new'+propertyMetaData.cfc]();
									}

									if(scope.propertyDisplay.object.data[scope.propertyDisplay.property].$$getID() === ''){
										scope.propertyDisplay.object.data['selected'+scope.propertyDisplay.property] = scope.propertyDisplay.options[0];
										scope.propertyDisplay.object.data[scope.propertyDisplay.property] = $hibachi['new'+propertyMetaData.cfc]();
										scope.propertyDisplay.object.data[scope.propertyDisplay.property]['data'][scope.propertyDisplay.object.data[scope.propertyDisplay.property].$$getIDName()] = scope.propertyDisplay.options[0].value;
									}else{
										var found = false;
										for(var i in scope.propertyDisplay.options){
											if(angular.isObject(scope.propertyDisplay.options[i].value)){
												if(scope.propertyDisplay.options[i].value === scope.propertyDisplay.object.data[scope.propertyDisplay.property]){
													scope.propertyDisplay.object.data['selected'+scope.propertyDisplay.property] = scope.propertyDisplay.options[i];
													scope.propertyDisplay.object.data[scope.propertyDisplay.property] = scope.propertyDisplay.options[i].value;
													found = true;
													break;
												}
											}else{
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
								}else if(scope.selectType === 'string'){
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
				}
			};//<--end return
	}

}
export{
	SWFormFieldSelect
}


