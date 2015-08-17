module slatwalladmin {
	'use strict';

	export class AddOrderItemGiftRecipient{

		public static $inject = [
			'$scope'
		];

		constructor(){
			this.orderItemGiftRecipients = [];
		}

		onTodos() {
			this.$scope.remainingCount = this.totalQuantity - this.orderItemGiftRecipients.length;
			this.$scope.totalCount = this.orderItemGiftRecipients.length;
		}

		add() {
			this.orderItemGiftRecipients.push(recipient);
		}

		edit(recipient:any){

		}

		delete(recipient:any){

		}
	}

	angular.module('slatwalladmin').controller('preprocesorderitem_addorderitemgiftrecipient', AddOrderItemGiftRecipient);

}
