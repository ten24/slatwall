module slatwalladmin {
	'use strict';
	
	interface ITypeaheadSearchScope extends ng.IScope {
		
	}
    
    export class SWTypeaheadSearch implements ng.IDirective{
        
		public restrict = "E"; 
		public scope = {
			entity:"=",
			properties:"=",
			placeholderText:"=?"
        }
		
		public bindToController = {
			entity:"=",
			properties:"=",
			placeholderText:"=?"
		}
		public static $inject=["$scope", "$slatwall"];
		
		constructor(private $scope: ITypeaheadSearchScope,  private $slatwall:ngSlatwall.$Slatwall){
			
		}

		public controller: function(){
					
		}
        
        public link:ng.IDirectiveLinkFn = ($scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

		}
    }
    
    angular.module('slatwalladmin').directive('swTypeaheadSearch',[() => new SWTypeaheadSearch()]); 

}