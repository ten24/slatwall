module slatwalladmin { 
	'use strict'; 
	
	export class GiftCardOrderInfo implements ng.IDirective { 
		
		public static $inject = ["$slatwall", "$templateCache", "partialsPath"];
		public restrict:string; 
		public templateUrl:string;
		public scope = { 
			giftCard:"=?", 
			order:"=?"
		}; 
		public bindToController; 
			
		constructor(private $slatwall:ngSlatwall.$Slatwall, private $templateCache:ng.ITemplateCache, private partialsPath:slatwalladmin.partialsPath){ 
			this.templateUrl = partialsPath + "/entity/giftcard/orderinfo.html";
			this.restrict = "EA";
		}
		
		public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
			
			var orderConfig = new slatwalladmin.CollectionConfig($slatwall, 'Order');
			orderConfig.setDisplayProperties("orderID, orderNumber, orderOpenDateTime, account.firstName, account.lastName");
			orderConfig.addFilter('orderID', scope.giftCard.originalOrderItem_order_orderID);
			orderConfig.setAllRecords(true);
		
			orderConfig.getEntity().then((response)=>{
				scope.order = response.records[0];
			});			
		}
		
	}
	
	angular.module('slatwalladmin').directive('swGiftCardOrderInfo',["$slatwall", "$templateCache", "partialsPath", ($slatwall, $templateCache, partialsPath) => new GiftCardOrderInfo($slatwall, $templateCache, partialsPath)]);
}