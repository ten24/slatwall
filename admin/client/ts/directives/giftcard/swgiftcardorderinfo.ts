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
			
			console.log(scope.giftCard); 
			
			var orderConfig = new slatwalladmin.CollectionConfig($slatwall, 'Order');
			orderConfig.addFilter('giftCard.giftCardID', scope.giftCard.giftCardID);
			orderConfig.setAllRecords(true);
			
			var orderPromise = $slatwall.getEntity("GiftCardTransaction", orderConfig.getOptions());
			
			orderPromise.then((response)=>{
				
			});
			
			
			
					
		}
		
	}
	
	angular.module('slatwalladmin').directive('swGiftCardOrderInfo',["$slatwall", "$templateCache", "partialsPath", ($slatwall, $templateCache, partialsPath) => new GiftCardOrderInfo($slatwall, $templateCache, partialsPath)]);
}