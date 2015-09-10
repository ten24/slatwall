module slatwalladmin { 
	'use strict'; 
	
	export class GiftCardDetail implements ng.IDirective { 
		
		public static $inject = ["$slatwall", "$templateCache", "partialsPath"];
		public restrict:string; 
		public templateUrl:string;
		public scope = { 
			giftCardId:"@",
			giftCard:"=?"
		}; 
		private giftCardPromise; 	
		
		constructor(private $slatwall:ngSlatwall.$Slatwall, private $templateCache:ng.ITemplateCache, private partialsPath:slatwalladmin.partialsPath){ 
			this.templateUrl = partialsPath + "/entity/giftcard/basic.html";
			this.restrict = "E"; 	
		}
		
		public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
			
			this.giftCardPromise = $slatwall.getEntity("GiftCard", scope.giftCardId);
			
			this.giftCardPromise.then((response:any):void =>{
            	scope.giftCard = response;
            });
			
			console.log(scope);
		}
		
	}
	
	angular.module('slatwalladmin').directive('swGiftCardDetail',["$slatwall", "$templateCache", "partialsPath", ($slatwall, $templateCache, partialsPath) => new GiftCardDetail($slatwall, $templateCache, partialsPath)]);
}