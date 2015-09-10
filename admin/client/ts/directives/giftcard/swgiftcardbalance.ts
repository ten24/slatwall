module slatwalladmin { 
	'use strict'; 
	
	export class GiftCardBalance implements ng.IDirective { 
		
		public static $inject = ["$slatwall", "$templateCache", "partialsPath"];
		public restrict:string; 
		public templateUrl:string;
		public scope;
		public bindToController; 
			
		constructor(private $slatwall:ngSlatwall.$Slatwall, private $templateCache:ng.ITemplateCache, private partialsPath:slatwalladmin.partialsPath){ 
			this.templateUrl = partialsPath + "/entity/giftcard/balance.html";
			this.scope = { 
			
			}; 	
		}
		
	}
	
	angular.module('slatwalladmin').directive('swGiftCardBalance',["$slatwall", "$templateCache", "partialsPath", ($slatwall, $templateCache, partialsPath) => new GiftCardBalance($slatwall, $templateCache, partialsPath)]);
}