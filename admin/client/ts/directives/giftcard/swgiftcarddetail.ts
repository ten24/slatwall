module slatwalladmin { 
	'use strict'; 
	
	export class SWGiftCardDetailController{
		public giftCardId; 
		public giftCard; 
		
		constructor(private $slatwall:ngSlatwall.$Slatwall){
			this.$slatwall = $slatwall; 
			this.init();
		} 
		
		public init = ():void =>{
			var giftCardConfig = new slatwalladmin.CollectionConfig(this.$slatwall, 'GiftCard');
			giftCardConfig.setDisplayProperties("giftCardID, giftCardCode, giftCardPin, expirationDate, ownerFirstName, ownerLastName, ownerEmailAddress, activeFlag, balanceAmount,  originalOrderItem.sku.product.productName, originalOrderItem.sku.product.productID, originalOrderItem.order.orderID, originalOrderItem.orderItemID, orderItemGiftRecipient.firstName, orderItemGiftRecipient.lastName, orderItemGiftRecipient.emailAddress, orderItemGiftRecipient.giftMessage");
			giftCardConfig.addFilter('giftCardID', this.giftCardId);
			giftCardConfig.setAllRecords(true);

			giftCardConfig.getEntity().then((response:any):void =>{
				this.giftCard = response.records[0];
            });
		}
	}
	
	export class GiftCardDetail implements ng.IDirective { 
		
		public static $inject = ["$slatwall", "partialsPath"];
		public restrict:string; 
		public templateUrl:string;
		public scope = {}; 	
		public bindToController = {
			giftCardId:"@",
			giftCard:"=?"
		};
		public controller= SWGiftCardDetailController;
        public controllerAs="swGiftCardDetail";
		
		constructor(private $slatwall:ngSlatwall.$Slatwall, private partialsPath:slatwalladmin.partialsPath){ 
			this.templateUrl = partialsPath + "/entity/giftcard/basic.html";
			this.restrict = "E"; 
			this.$slatwall = $slatwall;	
		}
		
		public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
			
			
		}
		
	}
	
	angular.module('slatwalladmin')
	.directive('swGiftCardDetail',
		["$slatwall", "partialsPath", 
			($slatwall, partialsPath) => 
				new GiftCardDetail($slatwall, partialsPath)
			]);
}