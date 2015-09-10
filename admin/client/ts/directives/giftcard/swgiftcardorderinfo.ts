module slatwalladmin { 
	'use strict'; 
	
	export class GiftCardOrderInfo { 
		
		public static inject = ["$slatwall", "$scope"];
		public restrict = "E"; 
		public templateUrl: partialsPath + "/entity/giftcard/orderinfo.html";
		
		public scope = { 
			
		}; 	
		
		public bindToController = { 
			
		}; 
		
		constructor(){ 
			
			
		}
		
	}
	
	angular.module('slatwalladmin').directive('swGiftCardOrderInfo', GiftCardOrderInfo); 
}