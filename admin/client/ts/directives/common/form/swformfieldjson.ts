/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
module slatwalladmin {
export class swFormFieldJsonController implements ng.IDirective {
	public propertyDisplay = {
		form: {},
		property: any,
		isDirty: false,
		object: {
			data: {}
		}
	};
	constructor (formService) {
		this.propertyDisplay.form[this.propertyDisplay.property].$dirty = this.propertyDisplay.isDirty;
	}
}	
	
export class swFormFieldJson implements ng.IDirective {
        restrict = 'E';
        require = "^form";
        scope = {};
        transclude = true;
		controller = swFormFieldJsonController;
        bindToController = {
            propertyDisplay: "=?"
        };
        templateUrl = "";
		formController: ng.IFormController;
        $inject = ['partialsPath'];
        link = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs: ng.IAttributes, formController: ng.IFormController) => {}
        
		constructor(public $log, $slatwall, formService, public partialsPath) {
            this.templateUrl = this.partialsPath + "formfields/json.html";
        }

    }
    angular.module('slatwalladmin').directive('swFormFieldJson', ['$log','$slatwall','formService','partialsPath', ($log, $slatwall, formService, partialsPath) => new swFormFieldJson($log, $slatwall, formService, partialsPath)]);
}
	
