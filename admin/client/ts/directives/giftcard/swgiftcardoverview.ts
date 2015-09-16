module slatwalladmin { 
	'use strict'; 
	
	export class swGiftCardOverviewController { 
		
		public giftCard
		
		constructor(){ 
			
		}		
	}
	
	export class GiftCardOverview implements ng.IDirective { 
		
		public static $inject = ["$slatwall", "$templateCache", "partialsPath"];
		public restrict:string; 
		public templateUrl:string;
		public scope = {}; 
		public bindToController = {
			giftCard:"=?"
		}; 
		public controller = swGiftCardOverviewController; 
		public controllerAs = "swGiftCardOverview"
			
		constructor(private $slatwall:ngSlatwall.$Slatwall, private $templateCache:ng.ITemplateCache, private partialsPath:slatwalladmin.partialsPath){ 
			this.templateUrl = partialsPath + "/entity/giftcard/overview.html";
			this.restrict = "EA";	
		}
		
	}
	
	angular.module('slatwalladmin')
	.directive('swGiftCardOverview',
		["$slatwall", "$templateCache", "partialsPath", 
			($slatwall, $templateCache, partialsPath) 
			=> new GiftCardOverview($slatwall, $templateCache, partialsPath)
		]);
}