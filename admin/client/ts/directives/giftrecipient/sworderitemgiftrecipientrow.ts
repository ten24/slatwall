angular.module('slatwalladmin')
.directive('swOrderItemGiftRecipientRow', [
	'$http',
	'$compile',
	'$templateCache',
	'partialsPath',
	function(
		$http,
		$compile,
		$templateCache,
		partialsPath
	){
		return {
			restrict: 'AE',
			templateUrl:partialsPath+"orderitemgiftrecipientrow.html",
			scope:{
				recipient:"=",
				recipients:"="
			}, 
			bindToController: {
				recipient:"=",
				recipients:"="
			},
			controller: function(){ 
				this.edit = (recipient:any) =>{
					console.log("editing recipient");
					if(!recipient.editing){
						recipient.editing=true; 
					}
				}

				this.delete = (recipient:any) =>{
					console.log("deleting recipient");
					this.recipients.splice(this.recipients.indexOf(recipient), 1);
				}	
				
				this.saveGiftRecipient = (recipient:any) =>{
						console.log("saving recipient");
						recipient.editing = false; 
				}
			}, 
			controllerAs: "giftRecipientRowControl"
		};
	}
]);
	
