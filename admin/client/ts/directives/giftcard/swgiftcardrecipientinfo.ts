module slatwalladmin { 
	'use strict'; 
	
	export class swGiftCardRecipientInfoController { 
		
		public giftCard; 
		
		constructor(){ 
			
		}
		
	}
	
	export class GiftCardRecipientInfo implements ng.IDirective { 
		
		public static $inject = ["$slatwall", "partialsPath"];
		public restrict:string; 
		public templateUrl:string;
		public scope = {}; 
		public bindToController = {
			giftCard:"=?"
		}; 
		public controller = swGiftCardRecipientInfoController; 
		public controllerAs = "swGiftCardRecipientInfo";
			
		constructor(private $slatwall:ngSlatwall.$Slatwall, private partialsPath:slatwalladmin.partialsPath){ 
			this.templateUrl = partialsPath + "/entity/giftcard/recipientinfo.html";
			this.restrict = "EA";
		}
		
	}
	
	angular.module('slatwalladmin')
	.directive('swGiftCardRecipientInfo',
		["$slatwall", "partialsPath", 
			($slatwall, partialsPath) => 
				new GiftCardRecipientInfo($slatwall, partialsPath)
			]);
}