module slatwalladmin { 
	'use strict'; 
	
		export class SWGiftCardBalanceController{
			public transactions; 
			public giftCard;
			public currentBalanceFormatted; 
			public initialBalanceFormatted; 
			public balancePercentage;
			
			constructor(private $slatwall:ngSlatwall.SlatwallService){
				this.$slatwall = $slatwall; 
				this.init(); 
			} 
			
			public init = ():void =>{
				var initialBalance:number = 0;
				var totalDebit:number = 0; 
				
				var transactionConfig = new slatwalladmin.CollectionConfig(this.$slatwall, 'GiftCardTransaction');
				transactionConfig.setDisplayProperties("giftCardTransactionID, creditAmount, debitAmount, giftCard.giftCardID");
				transactionConfig.addFilter('giftCard.giftCardID', this.giftCard.giftCardID);
				transactionConfig.setAllRecords(true);
				
				var transactionPromise = this.$slatwall.getEntity("GiftCardTransaction", transactionConfig.getOptions());
				
				transactionPromise.then((response)=>{
					this.transactions = response.records; 
	
					angular.forEach(this.transactions, function(transaction, index){
						
						if(typeof transaction.creditAmount !== "string"){
							initialBalance += transaction.creditAmount;
						}
						
						if(typeof transaction.debitAmount !== "string"){
							totalDebit += transaction.debitAmount; 
						}
					});
					
					var currentBalance = initialBalance - totalDebit; 
					//temporarily hardcoded to $
					this.currentBalanceFormatted = "$" + parseFloat(currentBalance.toString()).toFixed(2);
					//temporarily hardcoded to $
					this.initialBalanceFormatted = "$" + parseFloat(initialBalance.toString()).toFixed(2);			
					this.balancePercentage = ((currentBalance / initialBalance)*100);					
				});	
			}
		}
	
	export class GiftCardBalance implements ng.IDirective { 
		
		public static $inject = ["$slatwall", "partialsPath"];
		public restrict:string; 
		public templateUrl:string;
		public scope = {}; 
		public bindToController = {
			giftCard:"=?", 
			transactions:"=?", 
			initialBalanceFormatted:"=?", 
			currentBalanceFormatted:"=?",
			balancePercentage:"=?"
		};
		public controller=SWGiftCardBalanceController;
        public controllerAs="swGiftCardBalance";
			
		constructor(private $slatwall:ngSlatwall.$Slatwall, private partialsPath:slatwalladmin.partialsPath){ 
			this.templateUrl = partialsPath + "/entity/giftcard/balance.html";
			this.restrict = "EA";	
		}
		
		public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
			
				
		}
		
	}
	
	angular.module('slatwalladmin')
	.directive('swGiftCardBalance',
		["$slatwall", "partialsPath", 
			($slatwall, partialsPath) => 
				new GiftCardBalance($slatwall, partialsPath)
			]);
}