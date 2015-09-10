module slatwalladmin { 
	'use strict'; 
	
	export class GiftCardHistory { 
		
		public static inject = ["$slatwall", "$scope"];
		public restrict = "E"; 
		public templateUrl: partialsPath + "/entity/giftcard/history.html";
		
		public scope = { 
			
		}; 	
		
		public bindToController = { 
			
		}; 
		
		constructor(){ 
			
			
		}
		
	}
	
	angular.module('slatwalladmin').directive('swGiftCardHistory', GiftCardHistory); 
}