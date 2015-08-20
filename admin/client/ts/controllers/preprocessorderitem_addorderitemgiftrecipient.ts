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
			this.$scope
			this.orderItemGiftRecipients = $scope.orderItemGiftRecipients = [];
                        this.quantity = angular.element("input[ng-model='giftRecipientControl.quantity']").val();
			var count = 1;
                        this.currentGiftRecipient = new slatwalladmin.GiftRecipient();
		}
        
        private getUnassignedCountArray = ():number[] =>{
            if(this.getUnassignedCount() != 0){
                var unassignedCountArray = new Array(this.getUnassignedCount());
                for(var i = 0; i < unassignedCountArray.length; i++ ){
                        unassignedCountArray[i] = i + 1;
                }
            } else { 
                var unassignedCountArray = new Array();
                unassignedCountArray[0] = 1; 
                console.log("countarray: " + unassignedCountArray);
            }
            
            return unassignedCountArray; 
        }
        
        private getUnassignedCount = ():number =>{
            var unassignedCount = this.quantity; 
           
            angular.forEach(this.orderItemGiftRecipients,(orderItemGiftRecipient)=>{
                unassignedCount -= orderItemGiftRecipient.quantity;
            });
            
            return unassignedCount;
        }
        
        public addGiftRecipient = ():void =>{
            var giftRecipient = new GiftRecipient();
            angular.extend(giftRecipient,this.currentGiftRecipient);
            this.orderItemGiftRecipients.push(giftRecipient);
			this.currentGiftRecipient = new slatwalladmin.GiftRecipient();; 
        }
        
        private getTotalQuantity = ():number =>{
            var totalQuantity = 0;
            angular.forEach(this.orderItemGiftRecipients,(orderItemGiftRecipient)=>{
                totalQuantity += orderItemGiftRecipient.quantity;
            });
            return totalQuantity;
        }
		
		private getMessageCharactersLeft = ():number =>{
			var totalChar = 250;
			
			//get chars subtract return
		}
	}
	
	angular.module('slatwalladmin').controller('preprocessorderitem_addorderitemgiftrecipient', OrderItemGiftRecipientControl);

}
