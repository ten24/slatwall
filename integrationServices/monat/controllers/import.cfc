component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiControllerEntity" {
	property name="ProductService";
	property name="SettingService";

	this.secureMethods="";
	this.secureMethods=listAppend(this.secureMethods,'importMonatProducts');
	this.secureMethods=listAppend(this.secureMethods,'importVibeAccounts');

	// @hint helper function to return a Setting
	public any function setting(required string settingName, array filterEntities=[], formatValue=false) {
		if(structKeyExists(getIntegration().getSettings(), arguments.settingName)) {
			return getService('settingService').getSettingValue(settingName='integration#getPackageName()##arguments.settingName#', object=this, filterEntities=arguments.filterEntities, formatValue=arguments.formatValue);
		}
		return getService('settingService').getSettingValue(settingName=arguments.settingName, object=this, filterEntities=arguments.filterEntities, formatValue=arguments.formatValue);
	}
	
	// @hint helper function to return the integration entity that this belongs to
	public any function getIntegration() {
		return getService('integrationService').getIntegrationByIntegrationPackage(getPackageName());
	}

	// @hint helper function to return the packagename of this integration
	public any function getPackageName() {
		return lcase(listGetAt(getClassFullname(), listLen(getClassFullname(), '.') - 2, '.'));
	}
	
	private any function getAPIResponse(string endpoint, numeric pageNumber, numeric pageSize){
		cftimer(label = "getAPIResponse request length #arguments.endpoint?:''# #arguments.pageNumber?:''# #arguments.pageSize?:''# ", type="outline"){
			var uri = setting('baseImportURL') & arguments.endPoint;
			var authKeyName = "authkey";
			var authKey = setting('authKey');
		
			var body = {
				"Pagination": {
					"PageSize": "#arguments.pageSize#",
					"PageNumber": "#arguments.pageNumber#"
				}
			};

			httpService = new http(method = "POST", charset = "utf-8", url = uri);
			httpService.addParam(name = "Authorization", type = "header", value = "#authKey#");
			httpService.addParam(name = "Accept", type = "header", value = "text/plain");
			httpService.addParam(name = "Content-Type", type = "header", value = "application/json-patch+json");
			httpService.addParam(name = "body", type = "body", value = "#serializeJson(body)#");
			
			try {
				httpService.setTimeout(10000)
				responseJson = httpService.send().getPrefix();
				
				var response = deserializeJson(responseJson.fileContent);
				
				if(isArray(response)){
					response = response[1];
				} 
			} catch (any e) {
				writeDump("Could not read response got #e.message# for page:#arguments.pageNumber#");
				if(!isNull(responseJson)){
					writeDump(responseJson);
				}
				var response = {}; 
				response.status = 'error';
			}
			response.hasErrors = false;
			if (isNull(response) || response.status != "success"){
				writeDump("Could not import from #arguments.endpoint# on this page: PS-#arguments.pageSize# PN-#arguments.pageNumber#");
				response.hasErrors = true;
			}
		}
		return response;
	}
 
    public void function importProducts(){
        param name="arguments.rc.fileLocation" default="#getDirectoryFromPath(getCurrentTemplatePath())#../assets/";
		param name="arguments.rc.skuFileName" default="sku-code-data.csv";
		param name="arguments.rc.priceFileName" default="sku-price-data.csv";
		param name="arguments.rc.bundleFileName" default="sku-kit-data.csv";
		param name="arguments.rc.includeSegments" default="sku,bundle,price";

		getService("HibachiTagService").cfsetting(requesttimeout="60000");
		if(listFindNoCase(arguments.rc.includeSegments,'sku')){
    		var columnTypeList = 'varchar,varchar,varchar,varchar,varchar,varcharvarchar,varchar,varchar,varchar,varchar,varcharvarchar,varchar,varchar,varchar,varchar,varchar';
    		var skuCodeQuery = getService('hibachiDataService').loadQueryFromCSVFileWithColumnTypeList(arguments.rc.fileLocation&arguments.rc.skufileName, columnTypeList);
            
            // Sanitize names
    		for(var i=1; i<=skuCodeQuery.recordCount; i++){
    			var title = trim(skuCodeQuery['ItemName'][i]);
    			title = getService('HibachiUtilityService').createUniqueURLTitle(titleString=title, tableName="SwProduct");
    			skuCodeQuery['ItemName'][i] = reReplace(skuCodeQuery['ItemName'][i],'[^\w\d\s\(\)\+\&\-\.\,]','','all');
    		};
            
            var importConfig = FileRead(getDirectoryFromPath(getCurrentTemplatePath()) & '../config/import/skus.json');
    		getService("HibachiDataService").loadDataFromQuery(skuCodeQuery,importConfig);
    		writeDump('imported skus');
    		
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
    		
		}
		
		/*=========== Sku Bundles ===========*/
		if(listFindNoCase(arguments.rc.includeSegments,'bundle')){
    		var defaultLocationSql = "update swlocation set locationCode = '1', locationName = 'MONAT GLOBAL' where locationID = '88e6d435d3ac2e5947c81ab3da60eba2'";
    		
    		columnTypeList = 'varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar';
    		var skuBundleQuery = getService('hibachiDataService').loadQueryFromCSVFileWithColumnTypeList(arguments.rc.fileLocation&arguments.rc.bundleFileName, columnTypeList);
            
            skuBundleQuery = filterBundleQueryToOneLocationPerBundle( skuBundleQuery );
            
    		importConfig = FileRead(getDirectoryFromPath(getCurrentTemplatePath()) & '../config/import/bundles.json');
    		getService("HibachiDataService").loadDataFromQuery(skuBundleQuery,importConfig);
    		writeDump('imported bundles');
    		importConfig = FileRead(getDirectoryFromPath(getCurrentTemplatePath()) & '../config/import/bundles2.json');
    		getService("HibachiDataService").loadDataFromQuery(skuBundleQuery,importConfig);
    		writeDump('imported bundles2');
		}
		
		/*=========== Sku Prices ===========*/
		if(listFindNoCase(arguments.rc.includeSegments,'price')){
		    columnTypeList = 'varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar';
    		var skuPriceQuery = getService('hibachiDataService').loadQueryFromCSVFileWithColumnTypeList(arguments.rc.fileLocation&arguments.rc.priceFileName, columnTypeList);
            
            var numericFields = 'PriceLevel,SellingPrice,QualifyingPrice,TaxablePrice,Commission,RetailsCommissions,ProductPackBonus,ReailValueVolume';
            for(var i = 1; i <= skuPriceQuery['RecordCount']; i++ ){
                switch(skuPriceQuery['CountryCode'][i]){
                    case 'CAN':
                        skuPriceQuery['CountryCode'][i] = 'CAD';
                        break;
                    case 'GBR':
                        skuPriceQuery['CountryCode'][i] = 'GBP';
                        break;
                    case 'USA':
                        skuPriceQuery['CountryCode'][i] = 'USD';
                        break;
                }
                for(var numericField in numericFields){
                    skuPriceQuery[numericField][i] = reReplace(skuPriceQuery[numericField][i],'[^\d\.]','','all');
                }
            }
            
            var usdSkuPriceQuery = new Query();
    		usdSkuPriceQuery.setDBType('query');
    		usdSkuPriceQuery.setAttributes(skuPrices=skuPriceQuery);
    		usdSkuPriceQuery.setSQL("SELECT * FROM skuPrices WHERE PriceLevel = '2' AND CountryCode = 'USD'");
    		var usdSkuPrices = usdSkuPriceQuery.execute().getResult();
    		importConfig = FileRead(getDirectoryFromPath(getCurrentTemplatePath()) & '../config/import/prices.json');
    		getService("HibachiDataService").loadDataFromQuery(usdSkuPrices,importConfig);
    		writeDump('Price Check on Freedom Shampoo')
    		
    		importConfig = FileRead(getDirectoryFromPath(getCurrentTemplatePath()) & '../config/import/skuprices.json');
    		getService("HibachiDataService").loadDataFromQuery(skuPriceQuery,importConfig);
    		writeDump('Price Check on Other Shampoo');
		}
		abort;
	}

	private array function getSkuPriceDataFlattened(required any skuPriceData, required struct skuData){ 
		var skuPrices = [];
		var sku = arguments.skuData;

		ArrayEach(arguments.skuPriceData, function(item){
			var skuPrice = {};
			var itemData = arguments.item;
			skuPrice["ItemCode"] = sku.ItemCode;

			StructEach(itemData, function(key, value){
				
				switch(arguments.key){
					case 'CommissionableVolume':
						skuPrice['CommissionableVolume'] = arguments.value;
						break;
					case 'QualifyingVolume':
						skuPrice['QualifyingPrice'] = arguments.value;
						break;
					case 'RetailProfit':
						skuPrice['RetailsCommissions'] = arguments.value;
						break;
					case 'RetailVolume':
						skuPrice['RetailValueVolume'] = arguments.value;
						break;
					case 'SellingPrice':
						skuPrice['SellingPrice'] = arguments.value;
						break;
					case 'TaxablePrice':
						skuPrice['TaxablePrice'] = arguments.value;
						break;
					case 'ProductPackVolume':
						skuPrice['ProductPackBonus'] = arguments.value;
						break;
					case 'PriceLevelCode':
						skuPrice['PriceLevel'] = arguments.value;
						break;
					case 'CountryCode':
						switch (arguments.value){	
							case 'CAN':
								skuPrice['CountryCode'] = 'CAD';
								break;
							case 'GBR':
								skuPrice['CountryCode'] = 'GBP';
								break;
							case 'USA':
								skuPrice['CountryCode'] = 'USD';
								break;
						}
						break;
				}
			}, true, 10);
			
			ArrayAppend(skuPrices, skuPrice);
		}, true, 10);
		
		return skuPrices;
	}

	private any function populateSkuQuery( required any skuQuery, required struct skuData ){
		var data = {};
		var query = arguments.skuQuery;
		var skuPriceData = [];

		if(structKeyExists(arguments.skuData, "PriceLevels") && ArrayLen(arguments.skuData['PriceLevels'])){
			skuPriceData = this.getSkuPriceDataFlattened(arguments.skuData['PriceLevels'], arguments.skuData);
			var defaultSkuPrice = ArrayFilter(skuPriceData, function(item){
				var hasDefaultSkuPrice = (structKeyExists(arguments.item, 'CountryCode') && arguments.item.CountryCode == 'USD') &&
										(structKeyExists(arguments.item, 'PriceLevel') && arguments.item.PriceLevel == '2') &&
										(structKeyExists(arguments.item, 'SellingPrice') && !isNull(arguments.item.SellingPrice));
										
				return hasDefaultSkuPrice; 
			},true, 10);

			if(ArrayLen(defaultSkuPrice)){
				data['Amount'] = defaultSkuPrice[1]['SellingPrice']; // this is the default sku price
			}
		}

		StructEach(arguments.skuData, function(key, value){
			var skuField = Trim(arguments.key);
			var fieldValue = arguments.value;
			if(isNull(fieldValue)){
				continue;
			}
			switch(skuField){
				case 'ItemCode':
					data['SKUItemCode'] = Trim(fieldValue);
					break;
				case 'ItemName':
					data['ItemName'] = Trim(fieldValue);
					break;
				case 'DisableOnRegularOrders':
					data['DisableOnRegularOrders'] = fieldValue;
					break;
				case 'DisableInFlexShip':
					data['DisableOnFlexShip'] = fieldValue;
					break;
				case 'ItemCategoryCode':
					data['ItemCategoryAccounting'] = Trim(fieldValue);
					break;
				case 'ItemCategoryName':
					data['CategoryNameAccounting'] = Trim(fieldValue);
					break;
			}
		}, true, 10);

		QueryAddRow(query, data);

		return query;
	}

	private any function populateSkuPriceQuery( required any skuPriceQuery, required struct skuData ){
		// var skuPriceData = {};
		var skuPriceData = [];
		var query = arguments.skuPriceQuery;
		if(structKeyExists(arguments.skuData, "PriceLevels") ){
			var priceLevels = skuData.PriceLevels;
			skuPriceData = skuData.PriceLevels;
		}

		var skuPricesFlattened = this.getSkuPriceDataFlattened( skuPriceData, arguments.skuData );

		ArrayEach(skuPricesFlattened, function(item){
			QueryAddRow(query, item);
		}, true, 10);

		return arguments.skuPriceQuery;
	}

	private string function getSkuColumnsList(){
		return "SKUItemCode,ItemName,Amount,SecondName,DisableOnRegularOrders,DisableOnFlexship,ItemCategoryAccounting,CategoryNameAccounting";
	}

	private string function getSkuPriceColumnsList(){
		return "ItemCode,SellingPrice,QualifyingPrice,TaxablePrice,Commission,RetailsCommissions,ProductPackBonus,RetailValueVolume,CountryCode,PriceLevel";
	}

	public void function importMonatProducts(){
		getService("HibachiTagService").cfsetting(requesttimeout="60000");
		getFW().setView("public:main.blank");

		var pageNumber = rc.pageNumber?:1;
		var pageSize = rc.pageSize?:25;
		var totalPages = 1;
		var initProductData = this.getApiResponse( "queryItems", 1, 1 );
		if(structKeyExists(initProductData, 'Data') && structKeyExists(initProductData['Data'], 'TotalPages')){
			totalPages = initProductData['Data']['TotalPages'];
		}
		var pageMax = rc.pageMax?:totalPages;
		var updateFlag = rc.updateFlag?:false;
		var index=0;
		var skuIndex=0;
		var skuPriceIndex=0;

		var skuColumns = this.getSkuColumnsList();
		var skuColumnTypes = [];
		ArraySet(skuColumnTypes, 1, ListLen(skuColumns), 'varchar');

		var skuPriceColumns = this.getSkuPriceColumnsList();
		skuPriceColumnTypes = [];
		ArraySet(skuPriceColumnTypes, 1, ListLen(skuPriceColumns), 'varchar');


		while( pageNumber <= pageMax ){
			var productResponse = this.getApiResponse( "queryItems", pageNumber, pageSize );

			if ( productResponse.hasErrors ){
				//goto next page causing this is erroring!
				pageNumber++;
				continue;
			}
			//Set the pagination info.
			var monatProducts = productResponse.Data.Records?:[];

    		try{
				
				var skuQuery = QueryNew(skuColumns, skuColumnTypes);
				var skuPriceQuery = QueryNew(skuPriceColumns, skuPriceColumnTypes);

				for (var skuData in monatProducts){
					
					var skuQuery = this.populateSkuQuery(skuQuery, skuData);

					if(structKeyExists(skuData, 'PriceLevels') && ArrayLen(skuData['PriceLevels'])){
						skuPriceQuery = this.populateSkuPriceQuery( skuPriceQuery, skuData);
					}
				}
				
				var importConfig = FileRead(getDirectoryFromPath(getCurrentTemplatePath()) & '../config/import/skus.json');
				getService("HibachiDataService").loadDataFromQuery(skuQuery, importConfig);

				importConfig = FileRead(getDirectoryFromPath(getCurrentTemplatePath()) & '../config/import/skuprices.json');
				getService("HibachiDataService").loadDataFromQuery(skuPriceQuery, importConfig);
			} catch (any e){
    			writeDump(e); // rollback the tx
			}
			pageNumber++
		}
		abort;
	}

	public void function importVibeAccounts(){
		param name="arguments.rc.fileLocation" default="/var/www/app/Monat/Slatwall/custom/";
		param name="arguments.rc.fileName" default="monat-prod-users-5-20-2019.csv";
		getService("HibachiTagService").cfsetting(requesttimeout="60000");
		var importSuccess = true;

		try{
			var columnTypeList = "varchar,varchar,varchar,varchar,varchar,varchar"
			var accountQuery = getService('hibachiDataService').loadQueryFromCSVFileWithColumnTypeList(arguments.rc.fileLocation&arguments.rc.fileName, columnTypeList);
			var index = 0;
			QueryEach(accountQuery, function(row, rowNumber, query){
				var userNameQuery = "UPDATE swaccount a SET a.userName = :userName WHERE a.accountNumber = :accountNumber";
				var accountAuthQuery = "INSERT INTO swaccountauthentication (
											accountAuthenticationID, 
											password, 
											activeFlag, 
											createdDateTime, 
											accountID, 
											legacyPassword
										) 
										VALUES (
											LOWER(REPLACE(CAST(UUID() as char character set utf8),'-','')),
											'LEGACY',
											1,
											NOW(),
											(
												SELECT a.accountID FROM swaccount a WHERE a.accountNumber = :accountNumber
												ORDER BY a.createdDateTime DESC LIMIT 1
											),
											:legacyPassword
										)";


				QueryExecute(userNameQuery, {userName=arguments.row['username'], accountNumber=arguments.row['consultantid']});
				QueryExecute(accountAuthQuery, {legacyPassword=arguments.row['encryptedpassword'], accountNumber=arguments.row['consultantid']});
				index++;
			});

		} catch(any e){
			importSuccess = false;
			writeDump("Something Went Wrong!!!");
			writeDump(var=e, label="ERROR");
		}

		if(importSuccess){
			writeDump("Import Success!!!");
			writeDump("Accounts Updated: #index#");
		}
		abort;
	}
    
    private query function filterBundleQueryToOneLocationPerBundle( required query skuBundleQuery ){
        var columnList = arguments.skuBundleQuery.columnList;
        var columnTypeList = '';
        for(var i = 1; i <= listLen(columnList); i++){
            columnTypeList = listAppend(columnTypeList,'varchar');
        }
        var newQuery = queryNew(columnList, columnTypeList);
        var location = '';
        var itemCode = '';
        for( var row in skuBundleQuery){
            
            if(len(itemCode) 
                && itemCode == row['SKUItemCode']
                && len(location)
                && location != row['WarehouseNumber']){
                    continue;
                }
            itemCode = row['SKUItemCode'];
            location = row['WarehouseNumber'];
            queryAddRow(newQuery,row);
        }

        return newQuery;
    }
    
}