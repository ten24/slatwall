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
        
        private getQuantity = ():number =>{ 
                
             if(isNaN(this.quantity)){
                return 0;
             } else { 
                return this.quantity; 
             }
             
        }
        
        private getUnassignedCountArray = ():number[] =>{
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
        
        private getUnassignedCount = ():number =>{
            var unassignedCount = this.getQuantity(); 
           
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
