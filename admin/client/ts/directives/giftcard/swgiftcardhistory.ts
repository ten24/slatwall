module slatwalladmin { 
	'use strict'; 
	
	export class GiftCardHistory implements ng.IDirective { 
		
		public static $inject = ["$slatwall", "$templateCache", "partialsPath"];
		public restrict:string; 
		public templateUrl:string;
		public scope = { 
			giftCard:"=?"
		}; 
		public bindToController; 
			
		constructor(private $slatwall:ngSlatwall.$Slatwall, private $templateCache:ng.ITemplateCache, private partialsPath:slatwalladmin.partialsPath){ 
			this.templateUrl = partialsPath + "/entity/giftcard/history.html";
			this.restrict = "EA";
		}
		
		public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
			
			var initialBalance:number = 0;
			var totalDebit:number = 0; 
			
			var transactionConfig = new slatwalladmin.CollectionConfig($slatwall, 'GiftCardTransaction');
			transactionConfig.setDisplayProperties("giftCardTransactionID, creditAmount, debitAmount, createdDateTime, giftCard.giftCardID, orderPayment.order.orderNumber, orderPayment.order.orderOpenDateTime");
			transactionConfig.addFilter('giftCard.giftCardID', scope.giftCard.giftCardID);
			transactionConfig.setAllRecords(true);
			transactionConfig.setOrderBy("orderPayment.order.orderOpenDateTime", "DESC");
			
			var transactionPromise = $slatwall.getEntity("GiftCardTransaction", transactionConfig.getOptions());
			
			transactionPromise.then((response)=>{
				scope.transactions = response.records; 
				
				var initialCreditIndex = scope.transactions.length-1;
				console.log(initialCreditIndex);
				var initialBalance = scope.transactions[initialCreditIndex].creditAmount; 
				console.log(initialBalance);
				
				angular.forEach(scope.transactions, function(transaction, index){
					
					if(typeof transaction.debitAmount !== "string"){
						totalDebit += transaction.debitAmount; 
					}
					
					var currentBalance = initialBalance - totalDebit; 
					transaction.balanceFormatted = "$" + parseFloat(currentBalance.toString()).toFixed(2);
				});
				
				console.log(scope); 
			});		
			
			var orderConfig = new slatwalladmin.CollectionConfig($slatwall, 'Order');
			orderConfig.setDisplayProperties("orderID, orderNumber, orderOpenDateTime, account.firstName, account.lastName, account.primaryEmailAddress.emailAddress");
			orderConfig.addFilter('orderID', scope.giftCard.originalOrderItem_order_orderID);
			orderConfig.setAllRecords(true);
		
			orderConfig.getEntity().then((response)=>{
				scope.order = response.records[0];
				
				console.log(scope);
			});	
		}
		
	}
	
	angular.module('slatwalladmin').directive('swGiftCardHistory',["$slatwall", "$templateCache", "partialsPath", ($slatwall, $templateCache, partialsPath) => new GiftCardHistory($slatwall, $templateCache, partialsPath)]);
}