component output="false" accessors="true" extends="HibachiProcess" { 
	property name="sku";
		
	property name="productID"; 
	property name="product";

	public any function getProduct(){
		if(!structKeyExists(variables, "product") && !isNull(getProductID())){ 
			variables.product = getService("ProductService").getProduct(getProductID());
		} 
		return variables.product; 
	} 
} 
