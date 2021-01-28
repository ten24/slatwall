component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiControllerREST"{
	
	public any function get( required struct rc ) {
		
	    super.get(arguments.rc);
	    
	    //Append Images & Categories for Products
	    if(
	        StructKeyExists(arguments.rc, "apiResponse") &&
	        StructKeyExists(arguments.rc.apiResponse, "content") &&
	        StructKeyExists(arguments.rc.apiResponse.content, "collectionObject") &&
	        arguments.rc.apiResponse.content.collectionObject== "Product"
	    ) {
	        arguments.rc.apiResponse.content.pageRecords = getService("productService").appendImagesToProduct(arguments.rc.apiResponse.content.pageRecords);
	        
	        // arguments.rc.apiResponse.content.pageRecords = getService("productService").appendCategoriesToProduct(arguments.rc.apiResponse.content.pageRecords);
	    }
	    
	    //Append Settings value when SKU is accessed for specific product
	    if(
	    	( StructKeyExists(arguments.rc, "f:product.productID") || StructKeyExists(arguments.rc, "productID") || StructKeyExists(arguments.rc, "f:skuID") || StructKeyExists(arguments.rc, "skuID") )
	    	&&
	        StructKeyExists(arguments.rc, "apiResponse") &&
	        StructKeyExists(arguments.rc.apiResponse, "content") &&
	        StructKeyExists(arguments.rc.apiResponse.content, "collectionObject") &&
	        arguments.rc.apiResponse.content.collectionObject== "Sku"
	    ) {
	        arguments.rc.apiResponse.content.pageRecords = getService("skuService").appendSettingsAndOptionsToSku(arguments.rc.apiResponse.content.pageRecords);
	    }
	}
}
