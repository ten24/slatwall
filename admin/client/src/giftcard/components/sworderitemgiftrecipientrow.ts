/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWOrderItemGiftRecipientRowController {
	public recipients;
	public recipient;
	public quantity;
    public tableForm:any;
    public showInvalidRecipientMessage:boolean;

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
		if(this.tableForm.$valid){
            this.showInvalidRecipientMessage = false;
            recipient.editing = false;
        } else {
            this.showInvalidRecipientMessage = true;
        }
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
		if(angular.isDefined(this.recipient.giftMessage) && this.recipient.giftMessage != null ){
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
                showInvalidRecipientMessage:"=",
                tableForm:"=?",
				index:"="
			};
			public bindToController={
				recipient:"=",
				recipients:"=",
				quantity:"=",
                showInvalidRecipientMessage:"=",
                tableForm:"=?",
                index:"="
			};
			public controller= SWOrderItemGiftRecipientRowController;
			public controllerAs= "giftRecipientRowControl";

			public static Factory():ng.IDirectiveFactory{
				var directive:ng.IDirectiveFactory = (
					giftCardPartialsPath,
					slatwallPathBuilder
				) => new SWOrderItemGiftRecipientRow(
					giftCardPartialsPath,
					slatwallPathBuilder
				);
				directive.$inject = [
					'giftCardPartialsPath',
					'slatwallPathBuilder'
				];
				return directive;
			}

			constructor(private giftCardPartialsPath, private slatwallPathBuilder){
				this.init()
			}

			public init = () => {
				this.templateUrl = this.slatwallPathBuilder.buildPartialsPath(this.giftCardPartialsPath) + "/orderitemgiftrecipientrow.html"
			}
}

export {
	SWOrderItemGiftRecipientRowController,
	SWOrderItemGiftRecipientRow
}
