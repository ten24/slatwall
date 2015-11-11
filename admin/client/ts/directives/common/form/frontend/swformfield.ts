/// <reference path='../../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../../client/typings/tsd.d.ts' />
module slatwalladmin {

    export class swFormFieldR implements ng.IDirective {
        public static $inject = ['$log','templateCache','$window','$slatwall','formService','partialsPath'];
		constructor(public $log, public $templateCache, public $window, public $slatwall, public formService, public partialsPath){
			this.partialsPath = partialsPath;
			this.$templateCache = $templateCache;
			this.$window = $window;
			this.$slatwall = $slatwall;
			this.formService = formService;
			this.partialsPath = partialsPath;
            return this.GetInstance();
        }

        GetInstance(): any {
            return {
                require:"^form",
				restrict: 'AE',
				scope:{
					propertyDisplay:"="
				},
				templateUrl:this.partialsPath+'formfields/formfield.html',
				link: (scope, element: ng.IAugmentedJQuery, attrs: ng.IAttributes, formController: ng.IFormController) =>{
					if(angular.isUndefined(scope.propertyDisplay.object.$$getID) || scope.propertyDisplay.object.$$getID() === ''){
						scope.propertyDisplay.isDirty = true;
					} 
					
					if(angular.isDefined(formController[scope.propertyDisplay.property])){
						scope.propertyDisplay.errors = formController[scope.propertyDisplay.property].$error;
						formController[scope.propertyDisplay.property].formType = scope.propertyDisplay.fieldType;
					}
				}
            };
        }
	}
	angular.module('slatwalladmin').directive('swFormFieldR',['$log','$templateCache', '$window', '$slatwall', 'formService', 'partialsPath',($log, $templateCache, $window, $slatwall, formService, partialsPath) => new swFormFieldR($log, $templateCache, $window, $slatwall, formService, partialsPath)]);
}

	
