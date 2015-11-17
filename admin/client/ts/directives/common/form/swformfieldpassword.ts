/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
module slatwalladmin {
export class swFormFieldPasswordController implements ng.IDirective {
	public constructor () {
		this.propertyDisplay.form[this.propertyDisplay.property].$dirty = this.propertyDisplay.isDirty;
	}
}	
	
export class SWFormFieldPassword implements ng.IDirective {
        public restrict = 'E';
        public require = "^form";
        public scope = true;
        public bindToController = {
            propertyDisplay: "=?"
        };
		public controller = swFormFieldPasswordController;
		public controllerAs = "ctrl";
        
        public link = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs: ng.IAttributes, formController: ng.IFormController) => {}
        public $inject = ['$log','$slatwall','formService','partialsPath'];
		public constructor(public $log, $slatwall, formService, public partialsPath) {
            this.templateUrl = this.partialsPath + "formfields/password.html";
        }

    }
    angular.module('slatwalladmin').directive('swFormFieldPassword', ['$log','$slatwall','formService','partialsPath', ($log, $slatwall, formService, partialsPath) => new SWFormFieldPassword($log, $slatwall, formService, partialsPath)]);
}
