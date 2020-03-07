import productType from './productType'

//filler for objects that have not been defined yet so they do not error in console
type genericObject = { [key:string]: any }

export default interface product{
	errors: genericObject,
	urlTitle: string,
	productType: productType,
	brand: genericObject,
	productDescription: string,
	hasErrors: boolean,
	productName: string,
	productID: string,
	productCode: string,
	baseProductType: string
}