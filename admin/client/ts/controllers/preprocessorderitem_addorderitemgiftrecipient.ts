module slatwalladmin {
	
	
	interface IOrderItemGiftRecipientScope extends ng.IScope {
		orderItemGiftRecipients: GiftRecipient[];
		unassignedCount: number;
		total: number;
	}
    
	export class OrderItemGiftRecipientControl{

		public static $inject = [
			'$scope'
		];
		
		public orderItemGiftRecipients; 
        public quantity:number;
        public currentGiftRecipient:slatwalladmin.GiftRecipient;
        
		constructor(private $scope: IOrderItemGiftRecipientScope){
			this.orderItemGiftRecipients = $scope.orderItemGiftRecipients = [];
            this.quantity = angular.element("input[ng-model='giftRecipientControl.quantity']").val();
            this.currentGiftRecipient = new slatwalladmin.GiftRecipient();
		}
        
        public getUnassignedCountArray = ():number[] =>{
            var unassignedCountArray = new Array(this.getUnassignedCount());
            for(var i = 0; i < unassignedCountArray.length; i++ ){
                unassignedCountArray[i] = i + 1;
            }
            return unassignedCountArray; 
        }
        
        private getUnassignedCount = ():number =>{
            return this.quantity - this.orderItemGiftRecipients.length;
        }
        
        public addGiftRecipient = ():void =>{
            var giftRecipient = new GiftRecipient();
            angular.extend(giftRecipient,this.currentGiftRecipient)
            this.orderItemGiftRecipients.push(giftRecipient);
        }
        
        public getTotalQuantity = ():number =>{
            var totalQuantity = 0;
            angular.forEach(this.orderItemGiftRecipients,(orderItemGiftRecipient)=>{
                totalQuantity += orderItemGiftRecipient.quantity;
            });
            return totalQuantity;
        }


		private edit = (recipient:any) =>{

		}

		private delete = (recipient:any) =>{
			
		}
	}
	
	angular.module('slatwalladmin').controller('preprocessorderitem_addorderitemgiftrecipient', OrderItemGiftRecipientControl);

}
