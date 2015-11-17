/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
angular.module('slatwalladmin')
.directive('swFormFieldRadio', [
'$log',
'$timeout',
'$slatwall',
'formService',
'partialsPath',
	function(
	$log,
	$timeout,
	$slatwall,
	formService,
	partialsPath
	){
		return{
			templateUrl:partialsPath+'formfields/radio.html',
			require:"^form",
			restrict: 'E',
			scope:{
				propertyDisplay:"="
			},
			link:function(scope,element,attr,formController){
				var makeRandomID = function makeid(count)
				{
				    var text = "";
				    var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
				
				    for( var i=0; i < count; i++ )
				        text += possible.charAt(Math.floor(Math.random() * possible.length));
				
				    return text;
				};
				if(scope.propertyDisplay.fieldType === 'yesno'){
					//format value
					scope.selectedRadioFormName = makeRandomID(26);

					scope.propertyDisplay.object.data[scope.propertyDisplay.property] = scope.propertyDisplay.object.data[scope.propertyDisplay.property] === 'YES ' || scope.propertyDisplay.object.data[scope.propertyDisplay.property] == 1 ? 1 : 0;
					scope.formFieldChanged = function(option){
						$log.debug('formfieldchanged');
						$log.debug(option);
						scope.propertyDisplay.object.data[scope.propertyDisplay.property] = option.value;
						scope.propertyDisplay.form[scope.propertyDisplay.property].$dirty = true;
						scope.propertyDisplay.form['selected'+scope.propertyDisplay.object.metaData.className+scope.propertyDisplay.property+scope.selectedRadioFormName].$dirty = false;
					};
					
					scope.propertyDisplay.options = [
						{
							name:'Yes',
							value:1
						},
						{
							name:'No',
							value:0
						}
					];
					if(angular.isDefined(scope.propertyDisplay.object.data[scope.propertyDisplay.property])){
						
						for(var i in scope.propertyDisplay.options){
							if(scope.propertyDisplay.options[i].value === scope.propertyDisplay.object.data[scope.propertyDisplay.property]){
								scope.selected = scope.propertyDisplay.options[i];
								scope.propertyDisplay.object.data[scope.propertyDisplay.property] = scope.propertyDisplay.options[i].value;
							}
						}
					}else{
						scope.selected = scope.propertyDisplay.options[0];
						scope.propertyDisplay.object.data[scope.propertyDisplay.property] = scope.propertyDisplay.options[0].value;
					}
					
					$timeout(function(){
						scope.propertyDisplay.form[scope.propertyDisplay.property].$dirty = scope.propertyDisplay.isDirty;
					});
					
				}
			}
		};
	}
]);
/*module slatwalladmin {

export class SWFormFieldRadioController implements ng.IDirective {
	public propertyDisplay;
	public selectedRadioFormName;
	public formFieldChanged;
	public selected;
	public makeRandomID:Function;
	public static $inject = ['$timeout', '$log'];
	public constructor (public $timeout, public $log) {
		console.log("Radio called");
		// Creates a random ID - I think this should use UUID instead now that we have hibachi utilities 
		this.makeRandomID = (count) => {
			let text:string = "";
			let possible:string = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
		
			for( var i:number = 0; i < count; i++ )
				text += possible.charAt(Math.floor(Math.random() * possible.length));
		
			return text;
		}
		
		if(this.propertyDisplay.fieldType === 'yesno'){
			//format value
			this.selectedRadioFormName = this.makeRandomID(26);
			this.propertyDisplay.object.data[this.propertyDisplay.property] = this.propertyDisplay.object.data[this.propertyDisplay.property] === 'YES ' || this.propertyDisplay.object.data[this.propertyDisplay.property] == 1 ? 1 : 0;
			
			// on a formField changing, sets the form to dirty so that validation can kick in 
			this.formFieldChanged = (option) => {
				this.propertyDisplay.object.data[this.propertyDisplay.property] = option.value;
				this.propertyDisplay.form.$dirty = true;
				this.propertyDisplay.form['selected'+this.propertyDisplay.object.metaData.className+this.propertyDisplay.property+this.selectedRadioFormName].$dirty = false;
			};
			
			// sets the valid values for the radio 
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
			
			// doing this in a timeout creates a way to effect a digest without calling apply  
			this.$timeout(() => {
				this.propertyDisplay.form[this.propertyDisplay.property].$dirty = this.propertyDisplay.isDirty;
			});
		}
	}
}	
	
export class SWFormFieldRadio implements ng.IDirective {
        public restrict = 'E';
        public require = "^form";
        public scope = true;
		public controller = SWFormFieldRadioController;
		public controllerAs = "ctrl";
		public bindToController = {
            propertyDisplay: "=?"
        };
        public link = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs: ng.IAttributes, formController: ng.IFormController) => {}
        
		public static $inject = ['$log', '$timeout', '$slatwall', 'formService', 'partialsPath'];
		constructor(public $log, public $timeout, public $slatwall, public formService, public partialsPath) {
			console.log("Called");
            this.templateUrl = this.partialsPath + 'formfields/radio.html';
        }

    }
    angular.module('slatwalladmin').directive('swFormFieldRadio', ['$log','$timeout','$slatwall','formService','partialsPath', ($log, $timeout, $slatwall, formService, partialsPath) => new SWFormFieldRadio($log, $timeout, $slatwall, formService, partialsPath)]);
}*/
