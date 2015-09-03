module slatwalladmin {
        'use strict';
	
	interface IOrderItemGiftRecipientScope extends ng.IScope {
		orderItemGiftRecipients: GiftRecipient[];
		unassignedCount: number;
		total: number;
                collection: any;
                $log: any; 
	}
    
	export class OrderItemGiftRecipientControl{
                
                
        public static $inject=["$scope", "$slatwall"];        
		public adding:boolean; 
        public orderItemGiftRecipients; 
        public quantity:number;
        public searchText:string; 
        public currentGiftRecipient:slatwalladmin.GiftRecipient;
        
		constructor(private $scope: IOrderItemGiftRecipientScope,  private $slatwall:ngSlatwall.$Slatwall){
            this.orderItemGiftRecipients = $scope.orderItemGiftRecipients = [];
            $scope.collection = {};
            this.adding = false; 
            this.searchText = ""; 
			var count = 1;
            this.currentGiftRecipient = new slatwalladmin.GiftRecipient();
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

        updateResults = (keyword):void =>{
                var options =  {    
                        baseEntityName:"SlatwallAccount", 
                        baseEntityAlias:"_account", 
                        keywords: keyword,
                        defaultColumns: false, 
                        columnsConfig:angular.toJson([
                                {
                                    isDeletable:false,
                                    isSearchable:false,
                                    isVisible:true,
                                    ormtype:"id",
                                    propertyIdentifier:"_account.accountID",
                                },

                                {
                                    isDeletable:false,
                                    isSearchable:true,
                                    isVisible:true,
                                    ormtype:"string",
                                    propertyIdentifier:"_account.firstName",
                                },

                                {
                                    isDeletable:false,
                                    isSearchable:true,
                                    isVisible:true,
                                    ormtype:"string",
                                    propertyIdentifier:"_account.lastName",
                                },

                                {
                                    isDeletable:false,
                                    isSearchable:true,
                                    title:"Email Address",
                                    isVisible:true,
                                    ormtype:"string",
                                    propertyIdentifier:"_account.primaryEmailAddress.emailAddress",
                                }
                        ])
                };

                var accountPromise = $slatwall.getEntity('account', options);

                accountPromise.then((response:any):void =>{
                        this.$scope.collection = response;
                        if(angular.isDefined(this.$scope.collection)){
                            angular.forEach(this.$scope.collection.pageRecords,(account)=>{
                                account.gravatar = "http://www.gravatar.com/avatar/" + md5(account.primaryEmailAddress_emailAddress.toLowerCase().trim());
                            });
                        }
                });
                

                return this.$scope.collection;
        }

        getUnassignedCountArray = ():number[] =>{
                var unassignedCountArray = new Array();

                for(var i = 1; i <= this.getUnassignedCount(); i++ ){			
                        unassignedCountArray.push(i);
                }		

                return unassignedCountArray; 
        }
        
        getAssignedCount = ():number =>{
            
            var assignedCount = 0; 
            
            angular.forEach(this.orderItemGiftRecipients,(orderItemGiftRecipient)=>{
                assignedCount += orderItemGiftRecipient.quantity;
            });
            
            return assignedCount; 

        }

        getUnassignedCount = ():number =>{
                var unassignedCount = this.quantity; 

                angular.forEach(this.orderItemGiftRecipients,(orderItemGiftRecipient)=>{
                        unassignedCount -= orderItemGiftRecipient.quantity;
                });

                return unassignedCount;
        }

        addGiftRecipient = ():void =>{
                this.adding = false; 
                var giftRecipient = new GiftRecipient();
                angular.extend(giftRecipient,this.currentGiftRecipient);
                this.orderItemGiftRecipients.push(giftRecipient);
                this.currentGiftRecipient = new slatwalladmin.GiftRecipient(); 
                this.searchText = ""; 
        }

        startFormWithName = ():void =>{
                this.adding = true; 
                if(this.searchText == ""){
                        this.currentGiftRecipient.firstName = this.searchText;
                } else { 
                        this.currentGiftRecipient.firstName = this.searchText; 
                        this.searchText = ""; 
                }
        }

        getTotalQuantity = ():number =>{
                var totalQuantity = 0;
                angular.forEach(this.orderItemGiftRecipients,(orderItemGiftRecipient)=>{
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
	
	angular.module('slatwalladmin').controller('preprocessorderitem_addorderitemgiftrecipient', OrderItemGiftRecipientControl);

}
