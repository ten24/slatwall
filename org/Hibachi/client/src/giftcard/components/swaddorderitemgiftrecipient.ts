/// <reference path="../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../client/typings/slatwallTypeScript.d.ts" />

import {GiftRecipient} from "../models/giftrecipient";

class SWAddOrderItemRecipientController {

	public adding:boolean; 
	public orderItemGiftRecipients:Array<GiftRecipient>; 
	public quantity:number;
	public searchText:string; 
	public collection;  
	public currentGiftRecipient:GiftRecipient;
	
	public static $inject=["$slatwall"];
	
	constructor(private $slatwall){
		this.adding = false; 
		this.searchText = ""; 
		var count = 1;
		this.currentGiftRecipient = new GiftRecipient();
		this.orderItemGiftRecipients = [];
	}
	
	public addGiftRecipientFromAccountList = (account:any):void =>{
		var giftRecipient = new GiftRecipient();
		giftRecipient.firstName = account.firstName; 
		giftRecipient.lastName = account.lastName; 
		giftRecipient.email = account.primaryEmailAddress_emailAddress;
		giftRecipient.account = true; 
		this.orderItemGiftRecipients.push(giftRecipient); 
		this.searchText = "";   
	}
	
	public getUnassignedCountArray = ():number[] =>{
		var unassignedCountArray = new Array();

		for(var i = 1; i <= this.getUnassignedCount(); i++ ){			
				unassignedCountArray.push(i);
		}		

		return unassignedCountArray; 
	}
	
	public getAssignedCount = ():number =>{
	
		var assignedCount = 0; 
		
		angular.forEach(this.orderItemGiftRecipients,(orderItemGiftRecipient)=>{
				assignedCount += orderItemGiftRecipient.quantity;
		});
		
		return assignedCount; 

	}

	public getUnassignedCount = ():number =>{
		var unassignedCount = this.quantity; 

		angular.forEach(this.orderItemGiftRecipients,(orderItemGiftRecipient)=>{
				unassignedCount -= orderItemGiftRecipient.quantity;
		});

		return unassignedCount;
	}

	public addGiftRecipient = ():void =>{
		this.adding = false; 
		var giftRecipient = new GiftRecipient();
		angular.extend(giftRecipient,this.currentGiftRecipient);
		this.orderItemGiftRecipients.push(giftRecipient);
		this.currentGiftRecipient = new GiftRecipient(); 
		this.searchText = ""; 
	}

	public startFormWithName = (searchString = this.searchText):void =>{
		this.adding = true; 
		
		if(searchString == ""){
			this.currentGiftRecipient.firstName = searchString;
		} else { 
			this.currentGiftRecipient.firstName = searchString; 
			this.searchText = ""; 
		}
	}

	public getTotalQuantity = ():number =>{
		var totalQuantity = 0;
		angular.forEach(this.orderItemGiftRecipients,(orderItemGiftRecipient)=>{
				totalQuantity += orderItemGiftRecipient.quantity;
		});
		return totalQuantity;
	}

	public getMessageCharactersLeft = ():number =>{				
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
	public restrict = "EA"; 
	public transclude = true; 
	public scope = {}; 	
	
	public bindToController = {
		"quantity":"=", 
		"orderItemGiftRecipients":"=", 
		"adding":"=", 
		"searchText":"=", 
		"currentgiftRecipient":"="
	};
	
	public controller=SWAddOrderItemRecipientController;
	public controllerAs="addGiftRecipientControl";
	
	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
            $slatwall,
		    partialsPath
        ) => new SWAddOrderItemGiftRecipient(
            $slatwall,
			partialsPath
        );
        directive.$inject = [
            '$slatwall',
			'partialsPath'
        ];
        return directive;    
    }
	
	constructor(
		private $slatwall,
	    private partialsPath
	){
		this.templateUrl = partialsPath + "entity/OrderItemGiftRecipient/addorderitemgiftrecipient.html";
	}

	public link:ng.IDirectiveLinkFn = ($scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

	}
}

export {
	SWAddOrderItemRecipientController,
	SWAddOrderItemGiftRecipient
}; 
