module slatwalladmin { 
	'use strict'; 
	
	export class SWGiftCardOrderInfoController{
		public order; 
		public giftCard;  
		
		
		constructor(private $slatwall:ngSlatwall.$Slatwall){
			this.$slatwall = $slatwall; 
			this.init(); 	
		} 
		
		public init = ():void =>{

			var orderConfig = new slatwalladmin.CollectionConfig($slatwall, 'Order');
			orderConfig.setDisplayProperties("orderID, orderNumber, orderOpenDateTime, account.firstName, account.lastName");
			orderConfig.addFilter('orderID', this.giftCard.originalOrderItem_order_orderID);
			orderConfig.setAllRecords(true);
		
			orderConfig.getEntity().then((response)=>{
				this.order = response.records[0];
			});	
		}
	}
	
	export class GiftCardOrderInfo implements ng.IDirective { 
		
		public static $inject = ["$slatwall", "partialsPath"];
		public restrict:string; 
		public templateUrl:string;
		public scope = {};  
		public bindToController = { 
			giftCard:"=?", 
			order:"=?"
		}; 
		public controller = SWGiftCardOrderInfoController; 
		public controllerAs = "swGiftCardOrderInfo";
			
		constructor(private $slatwall:ngSlatwall.$Slatwall, private partialsPath:slatwalladmin.partialsPath){ 
			this.templateUrl = partialsPath + "/entity/giftcard/orderinfo.html";
			this.restrict = "EA";
		}
		
		public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
		}
		
	}
	
	angular.module('slatwalladmin')
	.directive('swGiftCardOrderInfo',
		["$slatwall", "partialsPath", 
			($slatwall, partialsPath) => 
				new GiftCardOrderInfo($slatwall, partialsPath)
			]);
}