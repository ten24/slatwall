/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
module slatwalladmin {

    export class swFormRegistrar implements ng.IDirective {
        public static $inject = ['formService', 'partialsPath'];
		constructor(public formService, public partialsPath){
			this.partialsPath = partialsPath;
			this.formService = formService;
			console.log("formService", formService);
            return this.GetInstance(this.formService);
        }

	    GetInstance(formService): any {
				return {
				restrict: 'E',
				require:"^form",
				link: function(scope, element, attrs, formController){
					/*add form info at the form level*/
					formController.$$swFormInfo={
						object:scope.object,
						context:scope.context || 'save',
						name:scope.name
					};
					var makeRandomID = function makeid(count)
					{
						var text = "";
						var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
					
						for( var i=0; i < count; i++ )
							text += possible.charAt(Math.floor(Math.random() * possible.length));
					
						return text;
					};
					
					scope.form = formController;
					/*register form with service*/
					formController.name = scope.name;
					formService.setForm(formController);
					
					/*register form at object level*/
					if(!angular.isDefined(scope.object.forms)){
						scope.object.forms = {};
					}
					scope.object.forms[scope.name] = formController;
				}
			};
        }
	}
	angular.module('slatwalladmin').directive('swFormRegistrar',[ 'formService', 'partialsPath', (formService, partialsPath) => new swFormRegistrar(formService, partialsPath)]);
}