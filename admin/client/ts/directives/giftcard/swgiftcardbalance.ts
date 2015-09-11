module slatwalladmin { 
	'use strict'; 
	
	export class GiftCardBalance implements ng.IDirective { 
		
		public static $inject = ["$slatwall", "$templateCache", "partialsPath"];
		public restrict:string; 
		public templateUrl:string;
		public scope = { 
			giftCard:"=?", 
			transactions:"=?", 
			initialBalanceFormatted:"=?", 
			currentBalanceFormatted:"=?",
			balancePercentage:"=?"
		}; 
		public bindToController; 
			
		constructor(private $slatwall:ngSlatwall.$Slatwall, private $templateCache:ng.ITemplateCache, private partialsPath:slatwalladmin.partialsPath){ 
			this.templateUrl = partialsPath + "/entity/giftcard/balance.html";
			this.restrict = "EA";	
		}
		
		public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
			
			var initialBalance:number = 0;
			var totalDebit:number = 0; 
			
			var transactionConfig = new slatwalladmin.CollectionConfig($slatwall, 'GiftCardTransaction');
			transactionConfig.addFilter('giftCard.giftCardID', scope.giftCard.giftCardID);
			transactionConfig.setAllRecords(true);
			
			var transactionPromise = $slatwall.getEntity("GiftCardTransaction", transactionConfig.getOptions());
			
			transactionPromise.then((response)=>{
				scope.transactions = response.records; 
				
				angular.forEach(scope.transactions, function(transaction, index){
					initialBalance += transaction.creditAmount;
					totalDebit += transaction.debitAmount; 
				});
				
				var currentBalance = initialBalance - totalDebit; 
				scope.currentBalanceFormatted = "$" + parseFloat(currentBalance.toString()).toFixed(2);
				scope.initialBalanceFormatted = "$" + parseFloat(initialBalance.toString()).toFixed(2);
				
				scope.balancePercentage = ((initialBalance /  currentBalance)*100);					
				console.log(scope.balancePercentage);
			});		
		}
		
	}
	
	angular.module('slatwalladmin').directive('swGiftCardBalance',["$slatwall", "$templateCache", "partialsPath", ($slatwall, $templateCache, partialsPath) => new GiftCardBalance($slatwall, $templateCache, partialsPath)]);
}