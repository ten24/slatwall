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
		public quantityOptions:array; 

		constructor(private $scope: IOrderItemGiftRecipientScope){
			this.$scope
			this.orderItemGiftRecipients = $scope.orderItemGiftRecipients = [];
            this.quantity = angular.element("input[ng-model='giftRecipientControl.quantity']").val();
			this.quantityOptions = [];
			
			var count = 1;
			
			while(count <= this.quantity){ 
				this.quantityOptions.push(count++); 	
			}
		}
        
        
        private getUnassignedCount = ():number =>{
            return this.quantity - this.orderItemGiftRecipients.length;
        }
        
        private addGiftRecipient = ():void =>{
	    	console.log("adding recipient");
            var recipient = new GiftRecipient();
			recipient.firstName = this.$scope.giftRecipient.firstName;
            recipient.lastName = this.$scope.giftRecipient.lastName;
			recipient.email = this.$scope.giftRecipient.email;
			recipient.giftMessage = this.$scope.giftRecipient.giftMessage;
			this.orderItemGiftRecipients.push(recipient);
        }
		
		private saveGiftRecipient = (recipient:any) =>{
			console.log("saving recipient");
			recipient.editing = false; 
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


		private edit = (recipient:any) =>{
			console.log("editing recipient");
			if(!recipient.editing){
				recipient.editing=true; 
			}
		}

		private delete = (recipient:any) =>{
			console.log("deleting recipient");
			this.orderItemGiftRecipients.splice(this.orderItemGiftRecipients.indexOf(recipient), 1);
		}
	}
	
	angular.module('slatwalladmin').controller('preprocessorderitem_addorderitemgiftrecipient', OrderItemGiftRecipientControl);

}
