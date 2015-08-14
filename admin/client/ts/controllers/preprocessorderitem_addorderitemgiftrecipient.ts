module slatwalladmin { 
	'use strict';

	export class AddOrderItemGiftRecipient{ 

		public static $inject = [
			'$scope'
		];

		constructor(){

		}

		public function add(recipient:any){ 
			//todo
		}

		public function edit(recipient:any){
			//todo
		}

		public function delete(recipient:any){ 
			//todo
		}

	}

	angular.module('slatwalladmin').controller('preprocesorderitem_addorderitemgiftrecipient', AddOrderItemGiftRecipient);

}