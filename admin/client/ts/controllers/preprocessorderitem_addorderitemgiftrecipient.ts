module slatwalladmin {
	
	
	interface IOrderItemGiftRecipientScope extends ng.IScope {
		orderItemGiftRecipients: GiftRecipient[];
		remaining: number;
		total: number;
	}

	export class OrderItemGiftRecipientControl{

		public static $inject = [
			'$scope'
		];
		
		private orderItemGiftRecipients; 

		constructor(private $scope: IOrderItemGiftRecipientScope){
			this.orderItemGiftRecipients = $scope.orderItemGiftRecipients = [];
            console.log('init gift');
		}

		private add(recipient:any) {
			this.orderItemGiftRecipients.push(recipient);
		}

		private edit(recipient:any){

		}

		private delete(recipient:any){
			
		}
	}
	
	angular.module('slatwalladmin').controller('preprocessorderitem_addorderitemgiftrecipient', OrderItemGiftRecipientControl);

}
