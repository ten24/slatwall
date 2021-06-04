component output="false" accessors="true" extends="HibachiProcess" { 
	property name="sku";
		
	property name="productID"; 
	property name="product" cfc="Product" hb_formFieldType="typeahead";

	public any function getProduct(){
		if( !isNull(getProductID()) ) { 
			return getService("ProductService").getProduct(getProductID());
		} 
	} 
	
	public any function getProductTypeAheadCollectionList(){
		var productCollectionList=getHibachiScope().getService('productService').getProductCollectionList();
		productCollectionList.setDisplayProperties('productID',   {isVisible=false,isSearchable=false} );
		if(!IsNull(this.getSku())){
			productCollectionList.addFilter('productID', this.getSku().getProduct().getProductID(), '!=' );
		}
		return productCollectionList;
	}
} 
