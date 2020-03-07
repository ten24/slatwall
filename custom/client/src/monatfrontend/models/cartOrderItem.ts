import cartSku from './cartSku'

export default interface cartOrderItem {
	skuProductURL: string,
	calculatedExtendedPersonalVolume: number,
	errors: object,
	skuPrice: number,
	price: number,
	taxLiabilityAmount: number,
	extendedUnitPriceAfterDiscount: number,
	extendedPriceAfterDiscount: number,
	sku: cartSku,
	extendedPrice: number,
	orderItemID: string,
	orderFulfillment:object,
	personalVolume: number,
	extendedUnitPrice: number,
	hasErrors: boolean,
	childOrderItems: Array<object>,
	taxAmount: number,
	quantity: number,
	currencyCode: string
}

 