module slatwalladmin { 
	'use strict'; 
	
	export class GiftCardDetail implements ng.IDirective { 
		
		public static $inject = ["$slatwall", "$templateCache", "partialsPath"];
		public restrict:string; 
		public templateUrl:string;
		public scope; 	
		
		constructor(private $slatwall:ngSlatwall.$Slatwall, private $templateCache:ng.ITemplateCache, private partialsPath:slatwalladmin.partialsPath){ 
			this.templateUrl = partialsPath + "/entity/giftcard/basic.html";
			this.restrict = "E"; 
			this.scope = { 
			
			}; 
		}
		
	}
	
	angular.module('slatwalladmin').directive('swGiftCardDetail',["$slatwall", "$templateCache", "partialsPath", ($slatwall, $templateCache, partialsPath) => new GiftCardDetail($slatwall, $templateCache, partialsPath)]);
}