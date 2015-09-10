module slatwalladmin { 
	'use strict'; 
	
	export class GiftCardDetail { 
		
		public static inject = ["$slatwall", "$scope"];
		public restrict = "E"; 
		public templateUrl: partialsPath + "/entity/giftcard/basic.html";
		
		public scope = { 
			
		}; 	
		
		public bindToController = { 
			
		}; 
		
		constructor(){ 
			
			
		}
		
	}
	
	angular.module('slatwalladmin').directive('swGiftCardDetail', GiftCardDetail); 
}