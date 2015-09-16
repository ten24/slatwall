module slatwalladmin { 
	'use strict'; 
	
	export class SWGiftCardHistoryController{
		public transactions;
		public giftCard; 
		public order; 
		
		
		constructor(private $slatwall:ngSlatwall.$Slatwall){
			this.$slatwall = $slatwall; 
			this.init();
		} 
		
		public init = ():void =>{
			var initialBalance:number = 0;
			var totalDebit:number = 0; 
			
			var transactionConfig = new slatwalladmin.CollectionConfig(this.$slatwall, 'GiftCardTransaction');
			transactionConfig.setDisplayProperties("giftCardTransactionID, creditAmount, debitAmount, createdDateTime, giftCard.giftCardID, orderPayment.order.orderNumber, orderPayment.order.orderOpenDateTime");
			transactionConfig.addFilter('giftCard.giftCardID', this.giftCard.giftCardID);
			transactionConfig.setAllRecords(true);
			transactionConfig.setOrderBy("orderPayment.order.orderOpenDateTime", "DESC");
			var transactionPromise = this.$slatwall.getEntity("GiftCardTransaction", transactionConfig.getOptions());
		
			transactionPromise.then((response)=>{
				this.transactions = response.records; 
				
				var initialCreditIndex = this.transactions.length-1;
				var initialBalance = this.transactions[initialCreditIndex].creditAmount; 
				var currentBalance = initialBalance; 
				angular.forEach(this.transactions, (transaction, index)=>{
				
					if(typeof transaction.debitAmount !== "string"){
						transaction.debit = true;
						totalDebit += transaction.debitAmount; 
						transaction.debitAmount = "$" + parseFloat(transaction.debitAmount.toString()).toFixed(2);
					} else { 
						if(index != initialCreditIndex){
							currentBalance += transaction.creditAmount; 
						}
						
						transaction.debit = false;
						transaction.creditAmount = "$" + parseFloat(transaction.creditAmount.toString()).toFixed(2);
					}
					
					var tempCurrentBalance = currentBalance - totalDebit; 
					transaction.balanceFormatted = "$" + parseFloat(tempCurrentBalance.toString()).toFixed(2);
					
					if(index == initialCreditIndex){
								
						var emailSent = { 
							emailSent: true, 
							debit:false, 
							sentAt: transaction.orderPayment_order_orderOpenDateTime,
							balanceFormatted:  "$" + parseFloat(initialBalance.toString()).toFixed(2)
						};
						
						var activeCard = {
							activated: true, 
							debit: false,
							activeAt: transaction.orderPayment_order_orderOpenDateTime,
							balanceFormatted:  "$" + parseFloat(initialBalance.toString()).toFixed(2)
						}
						
						this.transactions.splice(index, 0, activeCard); 
						this.transactions.splice(index, 0, emailSent); 
						
						
					}
				
				});
			});		
			
			var orderConfig = new slatwalladmin.CollectionConfig(this.$slatwall, 'Order');
			orderConfig.setDisplayProperties("orderID, orderNumber, orderOpenDateTime, account.firstName, account.lastName, account.primaryEmailAddress.emailAddress");
			orderConfig.addFilter('orderID', this.giftCard.originalOrderItem_order_orderID);
			orderConfig.setAllRecords(true);
		
			orderConfig.getEntity().then((response)=>{
				this.order = response.records[0];
			});	
		}
	}
	
	export class GiftCardHistory implements ng.IDirective { 
		
		public static $inject = ["$slatwall", "$templateCache", "partialsPath"];
		public restrict:string; 
		public templateUrl:string;
		public scope = {};
		public bindToController = {
			giftCard:"=?"		
		}; 
		public controller=SWGiftCardHistoryController;
		public controllerAs="swGiftCardHistory"; 
			
		constructor(private $slatwall:ngSlatwall.$Slatwall, private $templateCache:ng.ITemplateCache, private partialsPath:slatwalladmin.partialsPath){ 
			this.templateUrl = partialsPath + "/entity/giftcard/history.html";
			this.restrict = "EA";
		}
		
		public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
			
		}
		
	}
	
	angular.module('slatwalladmin').directive('swGiftCardHistory',["$slatwall", "$templateCache", "partialsPath", ($slatwall, $templateCache, partialsPath) => new GiftCardHistory($slatwall, $templateCache, partialsPath)]);
}