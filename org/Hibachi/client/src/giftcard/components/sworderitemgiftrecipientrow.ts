/// <reference path="../../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../../client/typings/slatwallTypeScript.d.ts" />

class SWOrderItemGiftRecipientRowController {
	public recipients; 
	public recipient;
	public quantity; 
	
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
	
	public saveGiftRecipient = (recipient:any) =>{
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
			
			public restrict:string = 'AE';
			public templateUrl:string;
			
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
					giftCardPartialsPath,
					pathBuilderConfig
				) => new SWOrderItemGiftRecipientRow(
					giftCardPartialsPath,
					pathBuilderConfig
				);
				directive.$inject = [
					'giftCardPartialsPath',
					'pathBuilderConfig'
				];
				return directive;    
			}
			
			constructor(private giftCardPartialsPath, private pathBuilderConfig){
				this.init()
			}		
			
			public init = () => {
				this.templateUrl = this.pathBuilderConfig.buildPartialsPath(this.giftCardPartialsPath) + "/orderitemgiftrecipientrow.html"								
			}	
}

export {
	SWOrderItemGiftRecipientRowController,
	SWOrderItemGiftRecipientRow
}
