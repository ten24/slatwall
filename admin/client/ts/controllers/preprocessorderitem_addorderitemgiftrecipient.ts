/// <reference path='../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../client/typings/tsd.d.ts' />
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
                public quantityForm;
        
		constructor(private $scope: IOrderItemGiftRecipientScope,  private $slatwall:ngSlatwall.$Slatwall){
                        this.orderItemGiftRecipients = $scope.orderItemGiftRecipients = [];
                        $scope.collection = {};
                        this.adding = false; 
                        this.searchText = "";
                        var count = 1;
                        this.currentGiftRecipient = new slatwalladmin.GiftRecipient();
                       
		}
                
                setQuantity = (value:number)=>{
                        this.quantity = Number(value);
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
	}
	
	angular.module('slatwalladmin').controller('preprocessorderitem_addorderitemgiftrecipient', OrderItemGiftRecipientControl);

}
