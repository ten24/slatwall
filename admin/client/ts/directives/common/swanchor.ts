/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
module slatwalladmin {

    export class swAnchor implements ng.IDirective {
		public static $inject = [];
		
        constructor(private $rootScope){
			return this.Get();
        }

        Get(): any{
            return {
				restrict: 'A',
				transclude:false,
				scope:false,
    			controllerAs: "$ctrl",
				controller: ($scope, $attrs) =>{ 
                    
					$scope.$emit('anchor', {anchorType: $attrs.swAnchor, scope: $scope});
					
                },
				replace:false,
				link: function(){}
			}
        }
    }
	angular.module('slatwalladmin').directive('swAnchor',['$rootScope',($rootScope) => new swAnchor($rootScope)]);
}

	
