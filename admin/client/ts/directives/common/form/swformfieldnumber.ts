/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />

module slatwalladmin {
export class SWFormFieldNumberController implements ng.IDirective {
	constructor () {
		this.propertyDisplay.form.$dirty = this.propertyDisplay.isDirty;
	}
}	
	
export class SWFormFieldNumber implements ng.IDirective {
        public restrict = 'E';
        public require = "^form";
        public scope = {};
        public bindToController = {
            propertyDisplay: "=?"
        };
        public templateUrl = "";
		public controller = SWFormFieldNumberController;
        public controllerAs = "numberCtrl";
		public formController: ng.IFormController;
        public link = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs: ng.IAttributes, formController: ng.IFormController) => {}
        
        public static $inject = ['$log', '$slatwall', 'formService', 'partialsPath'];
		constructor(public $log, $slatwall, formService, public partialsPath) {
            this.templateUrl = this.partialsPath + "formfields/number.html";
        }
    }
    angular.module('slatwalladmin').directive('swFormFieldNumber', ['$log','$slatwall','formService','partialsPath', ($log, $slatwall, formService, partialsPath) => new SWFormFieldNumber($log, $slatwall, formService, partialsPath)]);
}
	
