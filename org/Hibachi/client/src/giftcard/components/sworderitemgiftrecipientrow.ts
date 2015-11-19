/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWOrderItemGiftRecipientRowController {
	
	constructor(){
		
	}

	public edit = (recipient:any) =>{
		
		angular.forEach(this.recipients,(recipient)=>{
			recipient.editing=false; 
		});
		if(!recipient.editing){
			recipient.editing=true; 
		}
	}

	public delete = (recipient:any) =>{
		this.recipients.splice(this.recipients.indexOf(recipient), 1);
	}	
	
	this.saveGiftRecipient = (recipient:any) =>{
			recipient.editing = false; 
	}
	
	
	public getQuantity = ():number =>{ 
		if(isNaN(this.quantity)){
			return 0;
		} else { 
			return this.quantity; 
		}
	}

	public getUnassignedCount = ():number =>{
		var unassignedCount = this.getQuantity(); 
	
		angular.forEach(this.recipients,(recipient)=>{
			unassignedCount -= recipient.quantity;
		});
		
		return unassignedCount;
	}
	
	public getMessageCharactersLeft = ():number =>{				
		if(angular.isDefined(this.recipient.giftMessage)){ 
			return 250 - this.recipient.giftMessage.length;
		} else { 
			return 250; 
		}
	}
		
	public getUnassignedCountArray = ():number[] =>{
		
		var unassignedCountArray = new Array();
				
		for(var i = 1; i <= this.recipient.quantity + this.getUnassignedCount(); i++ ){			
			unassignedCountArray.push(i);
		}		
		
		return unassignedCountArray; 
	}			
}

class SWOrderItemGiftRecipientRow implements ng.IDirective {
			
			public static $inject = ["partialsPath"];
			public restrict:string = 'AE';
			public templateUrl:string = partialsPath + "orderitemgiftrecipientrow.html";
			
			public scope={
				recipient:"=",
				recipients:"=",
				quantity:"=",
				index:"="
			};
			public bindToController={
				recipient:"=",
				recipients:"=",
				quantity:"="
			};
			public controller= SWOrderItemGiftRecipientRowController;
			public controllerAs= "giftRecipientRowControl";
			
			public static Factory():ng.IDirectiveFactory{
				var directive:ng.IDirectiveFactory = (
					collectionConfigService,
					partialsPath
				) => new SWOrderItemGiftRecipientRow(
					collectionConfigService,
					partialsPath
				);
				directive.$inject = [
					'$slatwall',
					'partialsPath'
				];
				return directive;    
			}
			
			constructor(partialsPath){
			}				
}

export {
	SWOrderItemGiftRecipientRowController,
	SWOrderItemGiftRecipientRow
}
