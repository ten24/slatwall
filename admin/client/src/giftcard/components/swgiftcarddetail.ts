/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWGiftCardDetailController{
	public giftCardId;
	public giftCard;

	public static $inject = ["collectionConfigService"];

	constructor(private collectionConfigService){
		this.init();
	}

	public init = ():void =>{
		var giftCardConfig = this.collectionConfigService.newCollectionConfig('GiftCard');
		giftCardConfig.setDisplayProperties("giftCardID, giftCardCode, currencyCode, giftCardPin, expirationDate, ownerFirstName, ownerLastName, ownerEmailAddress, activeFlag, balanceAmount,  originalOrderItem.sku.product.productName, originalOrderItem.sku.product.productID, originalOrderItem.order.orderID, originalOrderItem.orderItemID, orderItemGiftRecipient.firstName, orderItemGiftRecipient.lastName, orderItemGiftRecipient.emailAddress, orderItemGiftRecipient.giftMessage, ownerAccount.accountID, ownerAccount.firstName, ownerAccount.lastName");
		giftCardConfig.addFilter('giftCardID', this.giftCardId);
		giftCardConfig.setAllRecords(true);

		giftCardConfig.getEntity().then((response:any):void =>{
			this.giftCard = response.records[0];
		});
	}
}

class SWGiftCardDetail implements ng.IDirective {

	public restrict:string;
	public templateUrl:string;
	public scope = {};
	public bindToController = {
		giftCardId:"@",
		giftCard:"=?"
	};
	public controller= SWGiftCardDetailController;
	public controllerAs="swGiftCardDetail";

	public static Factory():ng.IDirectiveFactory{
		var directive:ng.IDirectiveFactory = (
			collectionConfigService,
			giftCardPartialsPath,
			slatwallPathBuilder
		) => new SWGiftCardDetail(
			collectionConfigService,
			giftCardPartialsPath,
			slatwallPathBuilder
		);
		directive.$inject = [
			'collectionConfigService',
			'giftCardPartialsPath',
			'slatwallPathBuilder'
		];
		return directive;
	}

	constructor(private collectionConfigService, private giftCardPartialsPath, private slatwallPathBuilder){
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(giftCardPartialsPath) + "/basic.html";
		this.restrict = "E";
	}

	public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
	}

}

export {
	SWGiftCardDetailController,
	SWGiftCardDetail
};
