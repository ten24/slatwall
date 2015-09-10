module slatwalladmin { 
	'use strict'; 
	
	export class GiftCardBalance { 
		
		public static inject = ["$slatwall", "$scope"];
		public restrict = "E"; 
		public templateUrl: partialsPath + "/entity/giftcard/balance.html";
		
		public scope = { 
			
		}; 	
		
		public bindToController = { 
			
		}; 
		
		constructor(){ 
			
			
		}
		
	}
	
	angular.module('slatwalladmin').directive('swGiftCardBalance', GiftCardBalance); 
}