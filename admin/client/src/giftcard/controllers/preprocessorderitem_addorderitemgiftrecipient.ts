/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
import {GiftRecipient} from "../models/giftrecipient";

interface IOrderItemGiftRecipientScope extends ng.IScope {
        orderItemGiftRecipients: GiftRecipient[];
        unassignedCount: number;
        total: number;
        collection: any;
        $log: any;
}

class OrderItemGiftRecipientControl{


        public static $inject=["$scope", "$hibachi"];
        public adding:boolean;
        public orderItemGiftRecipients;
        public quantity:number;
        public searchText:string;
        public currentGiftRecipient:GiftRecipient;
        public quantityForm;
        //@ngInject
        constructor(private $scope: IOrderItemGiftRecipientScope,  private $hibachi){
                this.orderItemGiftRecipients = $scope.orderItemGiftRecipients = [];
                $scope.collection = {};
                this.adding = false;
                this.searchText = "";
                var count = 1;


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
export{
	OrderItemGiftRecipientControl
}
