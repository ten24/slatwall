component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiControllerEntity" {
    property name="ProductService";
 
    public void function importProducts(){
        param name="arguments.rc.fileLocation" default="#getDirectoryFromPath(getCurrentTemplatePath())#../assets/";
		param name="arguments.rc.skuFileName" default="sku-code-data.csv";
		param name="arguments.rc.pricesFileName" default="sku-prices-data.csv";
		param name="arguments.rc.bundleFileName" default="sku-kit-data.csv";

		getService("HibachiTagService").cfsetting(requesttimeout="60000");
		var columnTypeList = 'varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar';
		var skuCodeQuery = getService('hibachiDataService').loadQueryFromCSVFileWithColumnTypeList(arguments.rc.fileLocation&arguments.rc.skufileName, columnTypeList);
        
        // Sanitize names
		QueryAddColumn(skuCodeQuery, 'urlTitle','varchar', []);
		for(var i=1; i<=skuCodeQuery.recordCount; i++){
			var title = trim(skuCodeQuery['ItemName'][i]);
			title = getService('HibachiUtilityService').createUniqueURLTitle(titleString=title, tableName="SwProduct");
			skuCodeQuery['ItemName'][i] = reReplace(skuCodeQuery['ItemName'][i],'[^\w\d\s\(\)\+\&\-\.\,]','','all');
		};
        
        var importConfig = FileRead(getDirectoryFromPath(getCurrentTemplatePath()) & '../config/import/skus.json');
		getService("HibachiDataService").loadDataFromQuery(skuCodeQuery,importConfig);
		writeDump('imported');
		
		var parentProductTypeSQL = "
		                    update swproducttype 
		                    set parentProductTypeID = '444df2f7ea9c87e60051f3cd87b435a1',
		                        productTypeNamePath=CONCAT('Merchandise > ',productTypeName),
		                        productTypeIDPath=CONCAT('444df2f7ea9c87e60051f3cd87b435a1,',productTypeID)
		                        where remoteID is not null";
		queryExecute(parentProductTypeSQL);
		writeDump('updated product types');
		
		var nullUrlTitleProductCollection = getProductService().getProductCollectionList();
		nullUrlTitleProductCollection.setDisplayProperties('productID,productName');
		nullUrlTitleProductCollection.addFilter('urlTitle','null','is');
		var nullUrlTitleProducts = nullUrlTitleProductCollection.getRecords();
		for(var product in nullUrlTitleProducts){
		    var urlTitle = getService('HibachiUtilityService').createUniqueURLTitle(titleString=product.productName, tableName="SwProduct");
		    var sql = "update swproduct set urlTitle = '#urlTitle#' where productID = '#product.productID#'";
		    queryExecute(sql);
		}
		writeDump('updated product urlTitles');
		abort;
    }
    
}