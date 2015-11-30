/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
module slatwalladmin {

    export class swAnchor implements ng.IDirective {
		public static $inject = [];
		
        constructor(private $rootScope){
			return this.Get();
        }

        Get(): any{
			return {
			link: (scope) =>{
				scope.$emit('anchor', {anchorType: "form", scope: scope});
				}
			}
        }
    }
	angular.module('slatwalladmin').directive('swAnchor',['$rootScope',($rootScope) => new swAnchor($rootScope)]);
}

	
