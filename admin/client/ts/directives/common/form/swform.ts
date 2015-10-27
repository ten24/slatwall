/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
module slatwalladmin {

    export class swForm implements ng.IDirective {
		public static $inject = ['formService'];
        constructor(public formService){
			this.formService = formService;
            return this.GetInstance();
        }

        GetInstance(): any {
            return {
				restrict: 'E',
				transclude:true,
				scope:{
					object:"=",
					context:"@",
					name:"@"
				},
				template:'<ng-form><sw-form-registrar ng-transclude></sw-form-registrar></ng-form>',
				replace:true,
				link: function(scope){
					scope.context = scope.context || 'save';
				}
			}
        }
    }
	angular.module('slatwalladmin').directive('swForm',['formService',(formService) => new swForm(formService)]);
}

	
