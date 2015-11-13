/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />

module slatwalladmin {
export class swFormFieldRadioController implements ng.IDirective {
	public propertyDisplay;
	public selectedRadioFormName;
	public formFieldChanged;
	public selected;
	public makeRandomID:Function;
	public static $inject = ['$timeout', '$log'];
	public constructor (public $timeout, public $log) {
		/** Creates a random ID - I think this should use UUID instead now that we have hibachi utilities */
		this.makeRandomID = (count) => {
			let text:string = "";
			let possible:string = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
		
			for( var i:number = 0; i < count; i++ )
				text += possible.charAt(Math.floor(Math.random() * possible.length));
		
			return text;
		}
		/**  */
		if(this.propertyDisplay.fieldType === 'yesno'){
			//format value
			this.selectedRadioFormName = this.makeRandomID(26);
			this.propertyDisplay.object.data[this.propertyDisplay.property] = this.propertyDisplay.object.data[this.propertyDisplay.property] === 'YES ' || this.propertyDisplay.object.data[this.propertyDisplay.property] == 1 ? 1 : 0;
			
			/** on a formField changing, sets the form to dirty so that validation can kick in */
			this.formFieldChanged = (option) => {
				this.propertyDisplay.object.data[this.propertyDisplay.property] = option.value;
				this.propertyDisplay.form[this.propertyDisplay.property].$dirty = true;
				this.propertyDisplay.form['selected'+this.propertyDisplay.object.metaData.className+this.propertyDisplay.property+this.selectedRadioFormName].$dirty = false;
			};
			
			/** sets the valid values for the radio */
			this.propertyDisplay.options = [
				{
					name:'Yes',
					value:1
				},
				{
					name:'No',
					value:0
				}
			];
			
			if(angular.isDefined(this.propertyDisplay.object.data[this.propertyDisplay.property])){
				
				for(var i in this.propertyDisplay.options){
					if(this.propertyDisplay.options[i].value === this.propertyDisplay.object.data[this.propertyDisplay.property]){
						this.selected = this.propertyDisplay.options[i];
						this.propertyDisplay.object.data[this.propertyDisplay.property] = this.propertyDisplay.options[i].value;
					}
				}
				
			}else{
				this.selected = this.propertyDisplay.options[0];
				this.propertyDisplay.object.data[this.propertyDisplay.property] = this.propertyDisplay.options[0].value;
			}
			
			/** doing this in a timeout creates a way to effect a digest without calling apply  */
			this.$timeout(() => {
				this.propertyDisplay.form[this.propertyDisplay.property].$dirty = this.propertyDisplay.isDirty;
			});
		}
	}
}	
/**
 * This directive handles converting a property display into a form. 
 * */	
export class swFormFieldRadio implements ng.IDirective {
        restrict = 'E';
        require = "^form";
        scope = {};
        transclude = true;
        bindToController = {
            propertyDisplay: "=?"
        };
        templateUrl = "";
		controller: swFormFieldRadioController;
		formController: ng.IFormController;
		
        link = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs: ng.IAttributes, formController: ng.IFormController) => {}
        public static $inject = ['$log','$timeout', '$slatwall','formService','partialsPath'];
		constructor(public $log, public $timeout, $slatwall, formService, public partialsPath) {
            this.templateUrl = this.partialsPath + 'formfields/radio.html';
        }

    }
    angular.module('slatwalladmin').directive('swFormFieldRadioController', ['$log','$timeout','$slatwall','formService','partialsPath', ($log, $timeout, $slatwall, formService, partialsPath) => new swFormFieldNumber($log, $timeout, $slatwall, formService, partialsPath)]);
}
	
