/// <reference path="../../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../../client/typings/slatwallTypeScript.d.ts" />
module slatwalladmin {
	'use strict';
	
	export class SWAddOrderItemRecipientController {
		

		public adding:boolean; 
		public assignedCount:number;
		public unassignedCount:number;
        public orderItemGiftRecipients:Array<slatwalladmin.GiftRecipient>; 
        public quantity:number;
        public searchText:string; 
		public collection;  
        public currentGiftRecipient;
		public showInvalidAddFormMessage; 
		public showInvalidRowMessage;
		public unassignedCountArray = [];
		public recipientAddForm;
		public tableForm;
		
		public static $inject=["$slatwall"];
		
		constructor(private $slatwall:ngSlatwall.$Slatwall){
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
			giftRecipient.email = account.primaryEmailAddress_emailAddress;
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
			console.log("current")
			console.log(this.currentGiftRecipient.forms.createRecipient)
				if(this.currentGiftRecipient.forms.createRecipient.$valid){
					this.showInvalidAddFormMessage = true;
					this.adding = false; 
					var giftRecipient = new slatwalladmin.GiftRecipient();
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
			angular.forEach(this.orderItemGiftRecipients,(orderItemGiftRecipient:slatwalladmin.GiftRecipient)=>{
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
    
    export class SWAddOrderItemGiftRecipient implements ng.IDirective{
        
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
		
		
		constructor(private $slatwall:ngSlatwall.$Slatwall, private partialsPath){
			this.templateUrl = partialsPath + "entity/OrderItemGiftRecipient/addorderitemgiftrecipient.html";
		}

        public link:ng.IDirectiveLinkFn = ($scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
		}
    }
    
    angular.module('slatwalladmin').directive('swAddOrderItemGiftRecipient',
		["$slatwall", "partialsPath", 
			($slatwall, partialsPath) => 
				new SWAddOrderItemGiftRecipient($slatwall, partialsPath)]); 

}
