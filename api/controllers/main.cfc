component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiControllerREST"{
	
	public any function get( required struct rc ) {
	    super.get(arguments.rc);
	    
	    //Append Images for Products
	    if(
	        StructKeyExists(arguments.rc, "apiResponse") &&
	        StructKeyExists(arguments.rc.apiResponse, "content") &&
	        StructKeyExists(arguments.rc.apiResponse.content, "collectionObject") &&
	        arguments.rc.apiResponse.content.collectionObject== "Product"
	    ) {
	        arguments.rc.apiResponse.content.pageRecords = getService("productService").appendImagesToProduct(arguments.rc.apiResponse.content.pageRecords);
	    }
	}
}
