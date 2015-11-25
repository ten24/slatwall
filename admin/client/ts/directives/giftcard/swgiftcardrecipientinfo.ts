/// <reference path="../../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../../client/typings/slatwallTypeScript.d.ts" />
module slatwalladmin { 
	'use strict'; 
	
	export class swGiftCardRecipientInfoController { 
		
		public giftCard; 
		
		constructor(){ 
			
		}
		
	}
	
	export class GiftCardRecipientInfo implements ng.IDirective { 
		
		public static $inject = ["partialsPath"];
		public restrict:string; 
		public templateUrl:string;
		public scope = {}; 
		public bindToController = {
			giftCard:"=?"
		}; 
		public controller = swGiftCardRecipientInfoController; 
		public controllerAs = "swGiftCardRecipientInfo";
			
		constructor(private partialsPath){ 
			this.templateUrl = partialsPath + "/entity/giftcard/recipientinfo.html";
			this.restrict = "EA";
		}
		
	}
	
	angular.module('slatwalladmin')
	.directive('swGiftCardRecipientInfo',
		["partialsPath", 
			(partialsPath) => 
				new GiftCardRecipientInfo(partialsPath)
			]);
}