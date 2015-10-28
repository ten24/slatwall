/// <reference path="../../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../../client/typings/slatwallTypeScript.d.ts" />
module slatwalladmin { 
	'use strict'; 
	
	export class SWGiftCardOrderInfoController{
		public order; 
		public giftCard;  
		
		public static $inject = ["collectionConfigService"];
		
		constructor(private collectionConfigService:CollectionConfig){
			this.init(); 	
		} 
		
		public init = ():void =>{

			var orderConfig = this.collectionConfigService.newCollectionConfig('Order');
			orderConfig.setDisplayProperties("orderID, orderNumber, orderOpenDateTime, account.firstName, account.lastName");
			orderConfig.addFilter('orderID', this.giftCard.originalOrderItem_order_orderID);
			orderConfig.setAllRecords(true);
		
			orderConfig.getEntity().then((response)=>{
				this.order = response.records[0];
			});	
		}
	}
	
	export class GiftCardOrderInfo implements ng.IDirective { 
		
		public static $inject = ["collectionConfigService", "partialsPath"];
		
		public restrict:string; 
		public templateUrl:string;
		public scope = {};  
		public bindToController = { 
			giftCard:"=?", 
			order:"=?"
		}; 
		public controller = SWGiftCardOrderInfoController; 
		public controllerAs = "swGiftCardOrderInfo";
			
		constructor(private collectionConfigService:CollectionConfig, private partialsPath){ 
			this.templateUrl = partialsPath + "/entity/giftcard/orderinfo.html";
			this.restrict = "EA";
		}
		
		public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
		}
		
	}
	
	angular.module('slatwalladmin')
	.directive('swGiftCardOrderInfo',
		["collectionConfigService", "partialsPath", 
			(collectionConfigService, partialsPath) => 
				new GiftCardOrderInfo(collectionConfigService, partialsPath)
			]);
}
