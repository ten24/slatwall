/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
module slatwalladmin {
export class SWFormFieldTextController implements ng.IDirective {

	static $inject = ['formService'];
	constructor (public formService) {
			console.log("Text Field Property Display: ", this.propertyDisplay);
			if (this.propertyDisplay.isDirty == undefined) this.propertyDisplay.isDirty = false;
			this.propertyDisplay.form.$dirty = this.propertyDisplay.isDirty;
			this.formService.setPristinePropertyValue(this.propertyDisplay.property,this.propertyDisplay.object.data[this.propertyDisplay.property]);
	}
	
}	
 	
export class SWFormFieldText implements ng.IDirective { 
        public restrict = 'E';
        public require = "^form";
		public controller = SWFormFieldTextController;
		public controllerAs = "ctrl";
		public scope = true;
        public bindToController = {
            propertyDisplay: "="
        };
        
		static $inject = ['$scope', '$element', '$attribute','formController'];
        public link = (scope: ng.IScope, element: ng.IAugmentedJQuery, attr:ng.IAttributes, formController: ng.IFormController) => {
			
		}
		
        public static $inject = ['$log','$slatwall','formService','partialsPath'];
		constructor(public $log, $slatwall, formService, public partialsPath) {
            this.templateUrl = this.partialsPath + "formfields/text.html";
			console.log("Partial: ", this.templateUrl);
        }
    }
    angular.module('slatwalladmin').directive('swFormFieldText', ['$log','$slatwall','formService','partialsPath', ($log, $slatwall, formService, partialsPath) => new SWFormFieldText($log, $slatwall, formService, partialsPath)]);
}

	
