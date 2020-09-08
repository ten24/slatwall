component output="false" accessors="true" extends="HibachiProcess" { 
	property name="sku";
		
	property name="productID"; 
	property name="product" cfc="Product" hb_formFieldType="typeahead";
	
	
	public any function getProduct(){
		if(
			!isNull(getProductID())
		){ 
			return getService("ProductService").getProduct(getProductID());
		} 
	} 
} 
