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
                
                
                public static $inject=["$scope", "$injector", "$slatwall"];        
		public orderItemGiftRecipients; 
                public quantity:number;
                public currentGiftRecipient:slatwalladmin.GiftRecipient;
        
		constructor(private $scope: IOrderItemGiftRecipientScope, private $injector: ng.auto.IInjectorService, private $slatwall:ngSlatwall.$Slatwall){
                        this.orderItemGiftRecipients = $scope.orderItemGiftRecipients = [];
                        $scope.collection = {};
                        this.quantity = angular.element("input[ng-model='giftRecipientControl.quantity']").val();
			var count = 1;
                        this.currentGiftRecipient = new slatwalladmin.GiftRecipient();
		}
        
                getQuantity = ():number =>{      
                        if(isNaN(this.quantity)){
                                return 0;
                        } else { 
                                return this.quantity; 
                        }
                }
                
                updateResults = (keyword):void =>{
                        console.log("searching for:" + keyword);
        
                        var options =  {    
                                baseEntityName:"SlatwallAccount", 
                                baseEntityAlias:"_account", 
                                keywords: keyword,
                                defaultColumns: false, 
                                columnsConfig:angular.toJson([
                                        {isDeletable:false,
                                        isSearchable:false,
                           
                                        isVisible:true,
                                        ormtype:"id",
                                        propertyIdentifier:"_account.accountID",
                                        },
                                        
                                        
                                
                                        {isDeletable:false,
                                        isSearchable:true,
                      
                                        isVisible:true,
                                        ormtype:"string",
                                        propertyIdentifier:"_account.firstName",
                                        },
                                
                                        {isDeletable:false,
                                        isSearchable:true,
                                        isVisible:true,
                                        ormtype:"string",
                                        propertyIdentifier:"_account.lastName",
                                        },
                                
                                        {isDeletable:false,
                                        isSearchable:true,
                                        title:"Email Address",
                                        isVisible:true,
                                        ormtype:"string",
                                        propertyIdentifier:"_account.primaryEmailAddress.emailAddress",
                                        }
                                ])
                        };
                        console.log(angular.toJson(options));
                        
                        var accountPromise = $slatwall.getEntity('account', options);
                        
                        accountPromise.then((response:any):void =>{
                                this.$scope.collection = response;
                                console.log(this.$scope.collection);
		        });
                        
                        return this.$scope.collection;
                }
                
                getUnassignedCountArray = ():number[] =>{
                        var unassignedCountArray = new Array();
                        if(this.getUnassignedCount() > 1){
                                for(var i = 1; i < this.getUnassignedCount(); i++ ){
                                        unassignedCountArray.push(i);
                                }
                        } else { 
                                unassignedCountArray.push(1); 
                        }
                        console.log(unassignedCountArray);
                        return unassignedCountArray; 
                }
                
                getUnassignedCount = ():number =>{
                        var unassignedCount = this.getQuantity(); 
                        
                        angular.forEach(this.orderItemGiftRecipients,(orderItemGiftRecipient)=>{
                                unassignedCount -= orderItemGiftRecipient.quantity;
                        });
                        
                        return unassignedCount;
                }
                
                addGiftRecipient = ():void =>{
                        var giftRecipient = new GiftRecipient();
                        angular.extend(giftRecipient,this.currentGiftRecipient);
                        this.orderItemGiftRecipients.push(giftRecipient);
                        this.currentGiftRecipient = new slatwalladmin.GiftRecipient();; 
                }
                
                getTotalQuantity = ():number =>{
                        var totalQuantity = 0;
                        angular.forEach(this.orderItemGiftRecipients,(orderItemGiftRecipient)=>{
                                totalQuantity += orderItemGiftRecipient.quantity;
                        });
                        return totalQuantity;
                }
                        
		getMessageCharactersLeft = ():number =>{
			var totalChar = 250;
			
			//get chars subtract return
		}
	}
	
	angular.module('slatwalladmin').controller('preprocessorderitem_addorderitemgiftrecipient', OrderItemGiftRecipientControl);

}
