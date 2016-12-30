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
    public typeaheadCollectionConfig

    //@ngInject
    constructor(private $hibachi, private collectionConfigService, public entityService, public observerService){
        if(angular.isUndefined(this.adding)){
            this.adding = false;
        }
        if(angular.isUndefined(this.assignedCount)){
            this.assignedCount = 0;
        }
        if(angular.isUndefined(this.searchText)){
            this.searchText = "";
        }
        var count = 1;
        this.currentGiftRecipient = this.entityService.newEntity("OrderItemGiftRecipient");

        if(angular.isUndefined( this.orderItemGiftRecipients)){
            this.orderItemGiftRecipients = [];
        }
        if(angular.isUndefined(this.showInvalidAddFormMessage)){
            this.showInvalidAddFormMessage = false;
        }

        this.typeaheadCollectionConfig = collectionConfigService.newCollectionConfig('Account');
        this.typeaheadCollectionConfig.addDisplayProperty("accountID,firstName,lastName,primaryEmailAddress.emailAddress");
        this.typeaheadCollectionConfig.addFilter("primaryEmailAddress","null","is not");
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
            this.observerService.notify('updateBindings').then(()=>{
                this.showInvalidAddFormMessage = true;
                this.adding = false;

                var giftRecipient = new GiftRecipient();
                angular.extend(giftRecipient,this.currentGiftRecipient.data);
                this.orderItemGiftRecipients.push(giftRecipient);
                this.searchText = "";
                this.currentGiftRecipient = this.entityService.newEntity("OrderItemGiftRecipient");
            });
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
        this.adding = !this.adding;
        if(this.adding){
            this.currentGiftRecipient.forms.createRecipient.$setUntouched();
            this.currentGiftRecipient.forms.createRecipient.$setPristine();
            if(searchString != ""){
                this.currentGiftRecipient.firstName = searchString;
                this.searchText = "";
            }
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
        if(this.currentGiftRecipient.giftMessage && this.currentGiftRecipient.giftMessage != null){
            return 250 - this.currentGiftRecipient.giftMessage.length;
        } else {
            return 250;
        }
    }

}

class SWAddOrderItemGiftRecipient implements ng.IDirective{

	public static $inject=["$hibachi"];
    public templateUrl;
    public require = "^form";
    public restrict = "EA";
    public transclude = true;
    public scope = {};

    public bindToController = {
        "quantity":"=?",
        "orderItemGiftRecipients":"=?",
        "adding":"=?",
        "searchText":"=?",
        "currentgiftRecipient":"=?",
        "showInvalidAddFormMessage":"=?",
        "showInvalidRowMessage":"=?",
        "tableForm":"=?",
        "recipientAddForm":"=?"
    };

    public controller=SWAddOrderItemRecipientController;
    public controllerAs="addGiftRecipientControl";

	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
            $hibachi,
		    giftCardPartialsPath,
			slatwallPathBuilder
        ) => new SWAddOrderItemGiftRecipient(
            $hibachi,
			giftCardPartialsPath,
			slatwallPathBuilder
        );
        directive.$inject = [
            '$hibachi',
			'giftCardPartialsPath',
			'slatwallPathBuilder'
        ];
        return directive;
    }

	constructor(
		private $hibachi,
	    private giftCardPartialsPath,
		private slatwallPathBuilder
	){
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(giftCardPartialsPath) + "/addorderitemgiftrecipient.html";
    }

    public link:ng.IDirectiveLinkFn = ($scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
    }
}

export {
	SWAddOrderItemRecipientController,
	SWAddOrderItemGiftRecipient
};
