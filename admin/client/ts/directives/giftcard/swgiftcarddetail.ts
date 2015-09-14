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
			this.$slatwall = $slatwall;	
		}
		
		public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
			
			var giftCardConfig = new slatwalladmin.CollectionConfig(this.$slatwall, 'GiftCard');
			giftCardConfig.setDisplayProperties("giftCardID, giftCardCode, giftCardPin, expirationDate, ownerFirstName, ownerLastName, ownerEmailAddress, activeFlag, balanceAmount,  originalOrderItem.sku.product.productName, originalOrderItem.order.orderID, originalOrderItem.orderItemID, orderItemGiftRecipient.firstName, orderItemGiftRecipient.lastName, orderItemGiftRecipient.emailAddress, orderItemGiftRecipient.giftMessage");
			giftCardConfig.addFilter('giftCardID', scope.giftCardId);
			giftCardConfig.setAllRecords(true);

			giftCardConfig.getEntity().then((response:any):void =>{
				scope.giftCard = response.records[0];
            });
		}
		
	}
	
	angular.module('slatwalladmin').directive('swGiftCardDetail',["$slatwall", "$templateCache", "partialsPath", ($slatwall, $templateCache, partialsPath) => new GiftCardDetail($slatwall, $templateCache, partialsPath)]);
}