/// <reference path="../../../client/typings/tsd.d.ts" />
/// <reference path="../../../client/typings/slatwallTypeScript.d.ts" />
	
class SWGiftCardBalanceController{
	public transactions; 
	public giftCard;
	public currentBalance:number; 
	public initialBalance:number; 
	public balancePercentage;
	
	public static $inject = ["collectionConfigService"];
	
	constructor(private collectionConfigService){
		this.init(); 
	} 
	
	public init = ():void =>{
		this.initialBalance = 0;
		var totalDebit:number = 0; 
		
		var transactionConfig = this.collectionConfigService.newCollectionConfig('GiftCardTransaction');
		transactionConfig.setDisplayProperties("giftCardTransactionID, creditAmount, debitAmount, giftCard.giftCardID");
		transactionConfig.addFilter('giftCard.giftCardID', this.giftCard.giftCardID);
		transactionConfig.setAllRecords(true);
		
		var transactionPromise = transactionConfig.getEntity();
		
		transactionPromise.then((response)=>{
			this.transactions = response.records; 

			angular.forEach(this.transactions,(transaction, index)=>{
				
				if(typeof transaction.creditAmount !== "string"){
					this.initialBalance += transaction.creditAmount;
				}
				
				if(typeof transaction.debitAmount !== "string"){
					totalDebit += transaction.debitAmount; 
				}
			});
			this.currentBalance = this.initialBalance - totalDebit; 

			this.balancePercentage = ((this.currentBalance / this.initialBalance)*100);					
		});	
	}
}

class SWGiftCardBalance implements ng.IDirective { 

	public static $inject = ["collectionConfigService", "partialsPath"];
	public restrict:string; 
	public templateUrl:string;
	public scope = {}; 
	public bindToController = {
		giftCard:"=?", 
		transactions:"=?", 
		initialBalance:"=?", 
		currentBalance:"=?",
		balancePercentage:"=?"
	};
	public controller=SWGiftCardBalanceController;
	public controllerAs="swGiftCardBalance";
		
	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
            collectionConfigService,
		    partialsPath
        ) => new GiftCardBalance(
            collectionConfigService,
			partialsPath
        );
        directive.$inject = [
            '$slatwall',
			'partialsPath'
        ];
        return directive;    
    }
		
	constructor(private collectionConfigService, private partialsPath){ 
		this.templateUrl = partialsPath + "/entity/giftcard/balance.html";
		this.restrict = "EA";	
	}
	
	public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
				
	}

}

export {
	SWGiftCardBalanceController,
	SWGiftCardBalance
};

