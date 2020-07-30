import cartSku from './cartSku'

//filler for objects that have not been defined yet so they do not error in compiler
type genericObject = { [key:string]: any };

export default interface cartOrderItem {
	showInCartFlag:boolean;
    freezeQuantity: boolean;
	skuProductURL: string;
	calculatedExtendedPersonalVolume: number;
	errors: genericObject;
	skuPrice: number;
	price: number;
	taxLiabilityAmount: number;
	extendedUnitPriceAfterDiscount: number;
	extendedPriceAfterDiscount: number;
	sku: cartSku;
	extendedPrice: number;
	orderItemID: string;
	orderFulfillment:genericObject;
	personalVolume: number;
	extendedUnitPrice: number;
	hasErrors: boolean;
	childOrderItems: Array<genericObject>;
	taxAmount: number;
	quantity: number;
	currencyCode: string;
	calculatedListPrice:number
}

 