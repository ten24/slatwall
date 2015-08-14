module slatwalladmin { 
	'use strict';

	export class AddOrderItemGiftRecipient{ 

		public static $inject = [
			'$scope' 
			
		];

		constructor(){
			this.orderItemGiftRecipients = []; 
		}

		function onTodos() {
			this.$scope.remainingCount = this.totalQuantity - this.orderItemGiftRecipients.length;
			this.$scope.totalCount = this.orderItemGiftRecipients.length;
	

		function add() {
			//process recipient
			this.orderItemGiftRecipients.push(recipient); 
		}

		function edit(recipient:any){
			//todo
		}

		function delete(recipient:any){ 
			//todo
		}

	}

	angular.module('slatwalladmin').controller('preprocesorderitem_addorderitemgiftrecipient', AddOrderItemGiftRecipient);

}