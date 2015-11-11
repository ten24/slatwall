/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
/*
angular.module('slatwalladmin')
.directive('swFormFieldPassword', [
'$log',
'$slatwall',
'formService',
'partialsPath',
	function(
	$log,
	$slatwall,
	formService,
	partialsPath
	){
		return{
			templateUrl:partialsPath+'formfields/password.html',
			require:"^form",
			restrict: 'E',
			scope:{
				propertyDisplay:"="
			},
			link:function(scope,element,attr,formController){
				
				scope.propertyDisplay.form[scope.propertyDisplay.property].$dirty = scope.propertyDisplay.isDirty;
				formService.setPristinePropertyValue(scope.propertyDisplay.property,scope.propertyDisplay.object.data[scope.propertyDisplay.property]);
				
			}
		};
	}
]);
*/
module slatwalladmin {
export class swFormFieldPasswordController implements ng.IDirective {
	public propertyDisplay = {
		form: {},
		property: any,
		isDirty: false
	};
	constructor () {
		this.propertyDisplay.form[this.propertyDisplay.property].$dirty = this.propertyDisplay.isDirty;
	}
}	
	
export class swFormFieldPassword implements ng.IDirective {
        restrict = 'E';
        require = "^form";
        scope = {};
        transclude = true;
        bindToController = {
            propertyDisplay: "=?"
        };
        templateUrl = "";
		controller = swFormFieldPasswordController;
		formController: ng.IFormController;
        $inject = ['partialsPath'];
        link = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs: ng.IAttributes, formController: ng.IFormController) => {}
        
		constructor(public $log, $slatwall, formService, public partialsPath) {
            this.templateUrl = this.partialsPath + "formfields/password.html";
        }

    }
    angular.module('slatwalladmin').directive('swFormFieldPassword', ['$log','$slatwall','formService','partialsPath', ($log, $slatwall, formService, partialsPath) => new swFormFieldPassword($log, $slatwall, formService, partialsPath)]);
}
	
