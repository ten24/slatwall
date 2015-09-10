module slatwalladmin { 
	'use strict'; 
	
	export class GiftCardRecipientInfo { 
		
		public static inject = ["$slatwall", "$scope"];
		public restrict = "E"; 
		public templateUrl: partialsPath + "/entity/giftcard/recipientinfo.html";
		
		public scope = { 
			
		}; 	
		
		public bindToController = { 
			
		}; 
		
		constructor(){ 
			
			
		}
		
	}
	
	angular.module('slatwalladmin').directive('swGiftCardRecipientInfo', GiftCardRecipientInfo); 
}