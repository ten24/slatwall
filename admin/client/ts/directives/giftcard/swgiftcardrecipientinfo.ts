module slatwalladmin { 
	'use strict'; 
	
	export class swGiftCardRecipientInfoController { 
		
		public giftCard; 
		
		constructor(){ 
			
		}
		
	}
	
	export class GiftCardRecipientInfo implements ng.IDirective { 
		
		public static $inject = ["$slatwall", "$templateCache", "partialsPath"];
		public restrict:string; 
		public templateUrl:string;
		public scope = {}; 
		public bindToController = {
			giftCard:"=?"
		}; 
		public controller = swGiftCardRecipientInfoController; 
		public controllerAs = "swGiftCardRecipientInfo";
			
		constructor(private $slatwall:ngSlatwall.$Slatwall, private $templateCache:ng.ITemplateCache, private partialsPath:slatwalladmin.partialsPath){ 
			this.templateUrl = partialsPath + "/entity/giftcard/recipientinfo.html";
			this.restrict = "EA";
		}
		
	}
	
	angular.module('slatwalladmin').directive('swGiftCardRecipientInfo',["$slatwall", "$templateCache", "partialsPath", ($slatwall, $templateCache, partialsPath) => new GiftCardRecipientInfo($slatwall, $templateCache, partialsPath)]);
}