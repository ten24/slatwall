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
				recipients:"=",
				quantity:"=",
				index:"="
			}, 
			bindToController: {
				recipient:"=",
				recipients:"=",
				quantity:"="
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
				
				
				this.getQuantity = ():number =>{ 
					if(isNaN(this.quantity)){
						return 0;
					} else { 
						return this.quantity; 
					}
				}
		
				this.getUnassignedCount = ():number =>{
					var unassignedCount = this.getQuantity(); 
				
					angular.forEach(this.recipients,(recipient)=>{
						unassignedCount -= recipient.quantity;
					});
					
					return unassignedCount;
				}
					
				this.getUnassignedCountArray = ():number[] =>{
					
					var unassignedCountArray = new Array();
							
					for(var i = 1; i <= this.recipient.quantity + this.getUnassignedCount(); i++ ){			
						unassignedCountArray.push(i);
					}		
					
					return unassignedCountArray; 
				}
			}, 
			controllerAs: "giftRecipientRowControl"
		};
	}
]);
	
