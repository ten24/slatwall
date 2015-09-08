module slatwalladmin {
    
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

		public controller: function(){
					
		}
        
        public link:ng.IDirectiveLinkFn = ($scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

		}
    }
    
    angular.module('slatwalladmin').directive('swTypeaheadSearch',[() => new SWTypeaheadSearch()]); 

}