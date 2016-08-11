/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWGiftCardHistoryController{
	public transactions;
    public bouncedEmails; 
    public giftCard; 
    public emails; 
    public order; 
    
    //@ngInject
    constructor( public collectionConfigService, 
                 public $hibachi        
    ){
        
        var initialBalance:number = 0;
        var totalDebit:number = 0; 
        
        var transactionConfig = this.collectionConfigService.newCollectionConfig('GiftCardTransaction');
        
        transactionConfig.setDisplayProperties("giftCardTransactionID, creditAmount, debitAmount, createdDateTime, giftCard.giftCardID, orderPayment.order.orderID, orderPayment.order.orderNumber, orderPayment.order.orderOpenDateTime", "id,credit,debit,created,giftcardID,ordernumber,orderdatetime");
        transactionConfig.addFilter('giftCard.giftCardID', this.giftCard.giftCardID);
        transactionConfig.setAllRecords(true);
        transactionConfig.setOrderBy("createdDateTime|DESC");
        
        var emailBounceConfig = this.collectionConfigService.newCollectionConfig('EmailBounce');
        emailBounceConfig.setDisplayProperties("emailBounceID, rejectedEmailTo, rejectedEmailSendTime, relatedObject, relatedObjectID");
        emailBounceConfig.addFilter('relatedObjectID', this.giftCard.giftCardID);
        emailBounceConfig.setAllRecords(true);
        emailBounceConfig.setOrderBy("rejectedEmailSendTime|DESC");
        
        var emailConfig = this.collectionConfigService.newCollectionConfig('Email'); 
        emailConfig.setDisplayProperties('emailID, emailTo, relatedObject, relatedObjectID, createdDateTime');
        emailConfig.addFilter('relatedObjectID', this.giftCard.giftCardID);
        emailConfig.setAllRecords(true); 
        emailConfig.setOrderBy("createdDateTime|DESC");
        
        emailConfig.getEntity().then((response)=>{
            this.emails = response.records; 
        
            emailBounceConfig.getEntity().then((response)=>{
                this.bouncedEmails = response.records; 

                transactionConfig.getEntity().then((response)=>{
                    this.transactions = response.records; 
                    var initialCreditIndex = this.transactions.length-1;
                    var initialBalance = this.transactions[initialCreditIndex].creditAmount; 
                    var currentBalance = initialBalance; 
                    
                    for(var i = initialCreditIndex; i >= 0; i--){
                        var transaction = this.transactions[i];
                        if(typeof transaction.debitAmount !== "string"){
                            transaction.debit = true;
                            totalDebit += transaction.debitAmount; 
                        } else if(typeof transaction.creditAmount !== "string") { 
                            if(i != initialCreditIndex){
                                currentBalance += transaction.creditAmount; 
                            }
                            transaction.debit = false;
                        }

                        transaction.detailOrderLink = $hibachi.buildUrl('admin:entity.detailOrder', 'orderID=' + transaction.orderPayment_order_orderID)
                        
                        var tempCurrentBalance = currentBalance - totalDebit; 
                    
                        transaction.balance = tempCurrentBalance;
                        
                        if(i == initialCreditIndex){            
                            
                            var activeCard = {
                                activated: true, 
                                debit:false,
                                activeAt: transaction.orderPayment_order_orderOpenDateTime,
                                balance: initialBalance
                            }
                            
                            this.transactions.splice(i, 0, activeCard);  
                            
                            if(angular.isDefined(this.bouncedEmails)){
                                angular.forEach(this.bouncedEmails, (email, bouncedEmailIndex)=>{
                                    email.bouncedEmail = true; 
                                    email.balance = initialBalance; 
                                    this.transactions.splice(i, 0, email);
                                }); 
                            }
                            if(angular.isDefined(this.emails)){
                                angular.forEach(this.emails, (email)=>{
                                    email.emailSent = true; 
                                    email.debit = false;
                                    email.sentAt = email.createdDateTime;
                                    email.balance = initialBalance;
                                    this.transactions.splice(i, 0, email);
                                });
                            }
                        }       
                    }
                    
                });
            }); 
        }); 
        
        var orderConfig = this.collectionConfigService.newCollectionConfig('Order');
        orderConfig.setDisplayProperties("orderID,orderNumber,orderOpenDateTime,account.firstName,account.lastName,account.accountID,account.primaryEmailAddress.emailAddress");
        orderConfig.addFilter('orderID', this.giftCard.originalOrderItem_order_orderID);
        orderConfig.setAllRecords(true);
    
        orderConfig.getEntity().then((response)=>{
            this.order = response.records[0];
        }); 
    }
}

class SWGiftCardHistory implements ng.IDirective {

	public restrict:string;
	public templateUrl:string;
	public scope = {};
	public bindToController = {
		giftCard:"=?",
		transactions:"=?",
		bouncedEmails:"=?",
		order:"=?"
	};
	public controller=SWGiftCardHistoryController;
	public controllerAs="swGiftCardHistory";

	public static Factory():ng.IDirectiveFactory{
		var directive:ng.IDirectiveFactory = (
			collectionConfigService,
			giftCardPartialsPath,
			slatwallPathBuilder
		) => new SWGiftCardHistory(
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

    //@ngInject
	constructor(private collectionConfigService, private giftCardPartialsPath, private slatwallPathBuilder){
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(giftCardPartialsPath) + "/history.html";
		this.restrict = "EA";
	}

	public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

	}

}

export {
	SWGiftCardHistoryController,
	SWGiftCardHistory
}
