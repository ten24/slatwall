import product from './cartProduct'

export default interface sku{
	errors: { [key:string]: any },
	listPrice: string,
	imageFile: string,
	product: product,
	hasErrors: boolean,
	skuID: string,
	skuDefinition: string,
	skuCode: string,
	imagePath: string
}
