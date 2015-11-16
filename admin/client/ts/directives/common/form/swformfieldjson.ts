/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
module slatwalladmin {
export class SWFormFieldJsonController implements ng.IDirective {
	constructor (formService) {
		this.propertyDisplay.form[this.propertyDisplay.property].$dirty = this.propertyDisplay.isDirty;
	}
}	
	
export class SWFormFieldJson implements ng.IDirective {
        public restrict = 'E';
        public require = "^form";
        public scope = {};
		public controller = SWFormFieldJsonController;
        public bindToController = {
            propertyDisplay: "=?"
        };
		public controllerAs = "jsonCtrl";
        public templateUrl = "";
		public formController: ng.IFormController;
        public $inject = ['partialsPath'];
        public link = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs: ng.IAttributes, formController: ng.IFormController) => {}
		constructor(public $log, $slatwall, formService, public partialsPath) {
            this.templateUrl = this.partialsPath + "formfields/json.html";
        }

    }
    angular.module('slatwalladmin').directive('swFormFieldJson', ['$log','$slatwall','formService','partialsPath', ($log, $slatwall, formService, partialsPath) => new SWFormFieldJson($log, $slatwall, formService, partialsPath)]);
}
	
