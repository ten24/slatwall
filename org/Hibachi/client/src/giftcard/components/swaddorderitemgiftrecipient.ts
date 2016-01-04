/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
import {GiftRecipient} from "../models/giftrecipient";

class SWAddOrderItemRecipientController {

	public adding:boolean; 
    public assignedCount:number;
    public unassignedCount:number;
    public orderItemGiftRecipients; 
    public quantity:number;
    public searchText:string; 
    public collection;  
    public currentGiftRecipient;
    public showInvalidRowMessage;
    public unassignedCountArray = [];
    public recipientAddForm;
    public tableForm;
    public showInvalidAddFormMessage:boolean;
    
    public static $inject=["$slatwall"];
    
    constructor(private $slatwall){
        this.adding = false; 
        this.assignedCount = 0; 
        this.searchText = ""; 
        var count = 1;
        this.currentGiftRecipient = $slatwall.newEntity("OrderItemGiftRecipient");
        this.orderItemGiftRecipients = [];
        this.showInvalidAddFormMessage = false;
    }
    
    addGiftRecipientFromAccountList = (account:any):void =>{
        var giftRecipient = new GiftRecipient();
        giftRecipient.firstName = account.firstName; 
        giftRecipient.lastName = account.lastName; 
        giftRecipient.emailAddress = account.primaryEmailAddress_emailAddress;
        giftRecipient.account = true; 
        this.orderItemGiftRecipients.push(giftRecipient); 
        this.searchText = "";   
    }
    
    getUnassignedCountArray = ():number[] =>{   
        if(this.getUnassignedCount() < this.unassignedCountArray.length){
            this.unassignedCountArray.splice(this.getUnassignedCount(), this.unassignedCountArray.length);  
        }  
        if (this.getUnassignedCount() > this.unassignedCountArray.length) {     
            for(var i = this.unassignedCountArray.length+1; i <= this.getUnassignedCount(); i++ ){
                this.unassignedCountArray.push({name:i,value:i});
            }
        }
        return this.unassignedCountArray; 
    }
    
    getAssignedCount = ():number =>{
    
        this.assignedCount = 0; 
        
        angular.forEach(this.orderItemGiftRecipients,(orderItemGiftRecipient)=>{
                this.assignedCount += orderItemGiftRecipient.quantity;
        });
        
        return this.assignedCount; 

    }

    getUnassignedCount = ():number =>{
        this.unassignedCount = this.quantity; 

        angular.forEach(this.orderItemGiftRecipients,(orderItemGiftRecipient)=>{
                this.unassignedCount -= orderItemGiftRecipient.quantity;
        });

        return this.unassignedCount;
    }

    addGiftRecipient = ():void =>{
            if(this.currentGiftRecipient.forms.createRecipient.$valid){
                this.showInvalidAddFormMessage = true;
                this.adding = false; 
                var giftRecipient = new GiftRecipient();
                angular.extend(giftRecipient,this.currentGiftRecipient.data);
                this.orderItemGiftRecipients.push(giftRecipient);
                this.searchText = ""; 
                this.currentGiftRecipient = this.$slatwall.newEntity("OrderItemGiftRecipient"); 
            } else { 
                this.showInvalidAddFormMessage = true;
            }
    }
    
    cancelAddRecipient = ():void =>{
        this.adding = false; 
        this.currentGiftRecipient.reset();
        this.searchText = ""; 
        this.showInvalidAddFormMessage = false;
    }

    startFormWithName = (searchString = this.searchText):void =>{
        this.adding = true; 
        this.currentGiftRecipient.forms.createRecipient.$setUntouched();
        this.currentGiftRecipient.forms.createRecipient.$setPristine();
        if(searchString != ""){
            this.currentGiftRecipient.firstName = searchString; 
            this.searchText = ""; 
        }
    }

    getTotalQuantity = ():number =>{
        var totalQuantity = 0;
        angular.forEach(this.orderItemGiftRecipients,(orderItemGiftRecipient:GiftRecipient)=>{
                totalQuantity += orderItemGiftRecipient.quantity;
        });
        return totalQuantity;
    }

    getMessageCharactersLeft = ():number =>{                
        if(angular.isDefined(this.currentGiftRecipient.giftMessage)){ 
            return 250 - this.currentGiftRecipient.giftMessage.length;
        } else { 
            return 250; 
        }
    }

}

class SWAddOrderItemGiftRecipient implements ng.IDirective{

	public static $inject=["$slatwall"];
    public templateUrl; 
    public require = "^form";
    public restrict = "EA";
    public transclude = true; 
    public scope = {};  
    
    public bindToController = {
        "quantity":"=", 
        "orderItemGiftRecipients":"=", 
        "adding":"=", 
        "searchText":"=", 
        "currentgiftRecipient":"=",
        "showInvalidAddFormMessage":"=?",
        "showInvalidRowMessage":"=?",
        "tableForm":"=",
        "recipientAddForm":"="
    };
    
    public controller=SWAddOrderItemRecipientController;
    public controllerAs="addGiftRecipientControl";
    
	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
            $slatwall,
		    giftCardPartialsPath,
			pathBuilderConfig
        ) => new SWAddOrderItemGiftRecipient(
            $slatwall,
			giftCardPartialsPath,
			pathBuilderConfig
        );
        directive.$inject = [
            '$slatwall',
			'giftCardPartialsPath',
			'pathBuilderConfig'
        ];
        return directive;
    }
    
	constructor(
		private $slatwall,
	    private giftCardPartialsPath,
		private pathBuilderConfig
	){
		this.templateUrl = pathBuilderConfig.buildPartialsPath(giftCardPartialsPath) + "entity/OrderItemGiftRecipient/addorderitemgiftrecipient.html";
    }

    public link:ng.IDirectiveLinkFn = ($scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
    }
}

export {
	SWAddOrderItemRecipientController,
	SWAddOrderItemGiftRecipient
};
