/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
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
        var totalCredit:number = 0;
        
        var transactionConfig = this.collectionConfigService.newCollectionConfig('GiftCardTransaction');
        transactionConfig.setDisplayProperties("giftCardTransactionID, creditAmount, debitAmount, giftCard.giftCardID");
        transactionConfig.addFilter('giftCard.giftCardID', this.giftCard.giftCardID);
        transactionConfig.setAllRecords(true);
        transactionConfig.setOrderBy("createdDateTime|DESC");
        
        var transactionPromise = transactionConfig.getEntity();
        
        transactionPromise.then((response)=>{
            this.transactions = response.records;
            
            var initialCreditIndex = this.transactions.length-1;
            this.initialBalance = this.transactions[initialCreditIndex].creditAmount;  

            angular.forEach(this.transactions,(transaction, index)=>{
                
                if(!angular.isString(transaction.debitAmount)){
                    totalDebit += transaction.debitAmount; 
                }
                
                if(!angular.isString(transaction.creditAmount)){
                    totalCredit += transaction.creditAmount; 
                }
            });
            this.currentBalance = totalCredit - totalDebit; 

            this.balancePercentage = parseInt(((this.currentBalance / this.initialBalance)*100).toString());                    
        }); 
	}
}

class SWGiftCardBalance implements ng.IDirective {

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
		    giftCardPartialsPath,
			slatwallPathBuilder
        ) => new SWGiftCardBalance(
            collectionConfigService,
			giftCardPartialsPath,
			slatwallPathBuilder
        );
        directive.$inject = [
            'collectionConfigService',
			'giftCardPartialsPath',
			'slatwallPathBuilder'
        ];
        return directive;
    }

	constructor(private collectionConfigService, private giftCardPartialsPath, private slatwallPathBuilder){
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(giftCardPartialsPath) + "/balance.html";
		this.restrict = "EA";
	}

	public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

	}

}

export {
	SWGiftCardBalanceController,
	SWGiftCardBalance
};

