module slatwalladmin { 
	'use strict'; 
	
	export class GiftCardDetail implements ng.IDirective { 
		
		public static $inject = ["$slatwall", "$templateCache", "partialsPath"];
		public restrict:string; 
		public templateUrl:string;
		public scope = { 
			giftCardId:"@",
			giftCard:"=?"
		}; 	
		
		constructor(private $slatwall:ngSlatwall.$Slatwall, private $templateCache:ng.ITemplateCache, private partialsPath:slatwalladmin.partialsPath){ 
			this.templateUrl = partialsPath + "/entity/giftcard/basic.html";
			this.restrict = "E"; 	
		}
		
		public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
			
			//this.giftCardPromise = $slatwall.getEntity("GiftCard", scope.giftCardId);
			
			var giftCardConfig = new slatwalladmin.CollectionConfig($slatwall, 'GiftCard');
			giftCardConfig.setDisplayProperties("giftCardID, giftCardCode, giftCardPin, expirationDate, ownerFirstName, ownerLastName, ownerEmailAddress, activeFlag, balanceAmount, originalOrderItem.order.orderID");
			giftCardConfig.addFilter('giftCardID', scope.giftCardId);
			//giftCardConfig.setAllRecords(true);
			
			var giftCardPromise = $slatwall.getEntity("GiftCard", giftCardConfig.getOptions());
			
			giftCardPromise.then((response:any):void =>{
            	console.log(response);
				scope.giftCard = response;
            });
		}
		
	}
	
	angular.module('slatwalladmin').directive('swGiftCardDetail',["$slatwall", "$templateCache", "partialsPath", ($slatwall, $templateCache, partialsPath) => new GiftCardDetail($slatwall, $templateCache, partialsPath)]);
}