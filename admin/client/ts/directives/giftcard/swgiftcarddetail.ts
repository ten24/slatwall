/// <reference path="../../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../../client/typings/slatwallTypeScript.d.ts" />
module slatwalladmin { 
	'use strict'; 
	
	export class SWGiftCardDetailController{
		public giftCardId; 
		public giftCard; 
		
		public static $inject = ["collectionConfigService"];
		
		constructor(private collectionConfigService:CollectionConfig){
			this.init();
		} 
		
		public init = ():void =>{
			var giftCardConfig = this.collectionConfigService.newCollectionConfig('GiftCard');
			giftCardConfig.setDisplayProperties("giftCardID, giftCardCode, currencyCode, giftCardPin, expirationDate, ownerFirstName, ownerLastName, ownerEmailAddress, activeFlag, balanceAmount,  originalOrderItem.sku.product.productName, originalOrderItem.sku.product.productID, originalOrderItem.order.orderID, originalOrderItem.orderItemID, orderItemGiftRecipient.firstName, orderItemGiftRecipient.lastName, orderItemGiftRecipient.emailAddress, orderItemGiftRecipient.giftMessage");
			giftCardConfig.addFilter('giftCardID', this.giftCardId);
			giftCardConfig.setAllRecords(true);

			giftCardConfig.getEntity().then((response:any):void =>{
				this.giftCard = response.records[0];
            });
		}
	}
	
	export class GiftCardDetail implements ng.IDirective { 
		
		public static $inject = ["collectionConfigService", "partialsPath"];
		
		public restrict:string; 
		public templateUrl:string;
		public scope = {}; 	
		public bindToController = {
			giftCardId:"@",
			giftCard:"=?"
		};
		public controller= SWGiftCardDetailController;
        public controllerAs="swGiftCardDetail";
		
		constructor(private collectionConfigService:slatwalladmin.CollectionConfig, private partialsPath){ 
			this.templateUrl = partialsPath + "/entity/giftcard/basic.html";
			this.restrict = "E"; 
		}
		
		public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
			
			
		}
		
	}
	
	angular.module('slatwalladmin')
	.directive('swGiftCardDetail',
		["collectionConfigService", "partialsPath", 
			(collectionConfigService, partialsPath) => 
				new GiftCardDetail(collectionConfigService, partialsPath)
			]);
}
