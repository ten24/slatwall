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

		constructor(private $scope: IOrderItemGiftRecipientScope){
			this.orderItemGiftRecipients = $scope.orderItemGiftRecipients = [];
            this.quantity = angular.element("input[ng-model='giftRecipientControl.quantity']").val();
		}
        
        
        private getUnassignedCount = ():number =>{
            return this.quantity - this.orderItemGiftRecipients.length;
        }
        
        public addGiftRecipient = ():void =>{
            var giftRecipient = new GiftRecipient();
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
