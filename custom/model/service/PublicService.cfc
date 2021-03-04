component extends="Slatwall.model.service.PublicService" {
    
        
     public void function productAvailableSkuOptions( required struct data ) {
		param name="arguments.data.productID" type="string" default="";
		param name="arguments.data.selectedOptionIDList" type="string" default="";

		var product = getProductService().getProduct( arguments.data.productID );

		if(!isNull(product) && product.getActiveFlag() && product.getPublishedFlag()) {
			arguments.data.ajaxResponse["availableSkuOptions"] = product.getAvailableSkuOptions( arguments.data.selectedOptionIDList );
		}
	}

	public void function productSkuSelected(required struct data){
		param name="arguments.data.productID" type="string" default="";
		param name="arguments.data.selectedOptionIDList" type="string" default="";
		var product = getProductService().getProduct( arguments.data.productID );
		try{
			var sku = product.getSkuBySelectedOptions(arguments.data.selectedOptionIDList);
			arguments.data.ajaxResponse['skuID'] = sku.getSkuID();
		}catch(any e){
			arguments.data.ajaxResponse['skuID'] = '';
		}
	}
	
	public void function getSkuOptionDetails(required struct data){
		param name="arguments.data.productID" type="string" default="";
		param name="arguments.data.selectedOptionIDList" type="string" default="";
		var product = getProductService().getProduct( arguments.data.productID );
		try{
			var skuOptionDetails = product.getSkuOptionDetails(arguments.data.selectedOptionIDList);
			arguments.data.ajaxResponse['skuOptionDetails'] = skuOptionDetails;
		}catch(any e){
			arguments.data.ajaxResponse['skuOptionDetails'] = '';
		}
	}
	
	
	
     
     public void function getProductSkus( required struct data ) {
	    param name="arguments.data.productID";
	    param name="arguments.data.currentPage" default=1;
        param name="arguments.data.pageRecordsShow" default= getHibachiScope().setting('GLOBALAPIPAGESHOWLIMIT');
        var optsList = [];
        var defaultSelectedOptions = '';
        var product = getService("productService").getProduct( arguments.data.productID )
        var optionGroupsArr = product.getOptionGroups()
        var skuOptionDetails = product.getSkuOptionDetails()
        var defaultSku = product.getDefaultSku()
        if(!isNull(defaultSku)){
        defaultSelectedOptions = defaultSku.getOptionsIDList()
            for(var optionGroup in optionGroupsArr) {
                var options = product.getOptionsByOptionGroup( optionGroup.getOptionGroupID() )
                var group = []
                for(var option in options) {
                    ArrayAppend(group,{"optionID": option.getOptionID()
                    ,"optionName": option.getOptionName()})
                }
                ArrayAppend(optsList, {
                    "optionGroupName": optionGroup.getOptionGroupName(),
                    "optionGroupID": optionGroup.getOptionGroupID(),
                    "optionGroupCode": optionGroup.getOptionGroupCode(),
                    "options": group })
            }
        }
 
        
      var skuCollectionList = getService('SkuService').getSkuCollectionList();
	    skuCollectionList.setDisplayProperties( "skuID,skuCode,product.productName,product.productCode,product.productType.productTypeName,product.brand.brandName,listPrice,price,renewalPrice,calculatedSkuDefinition,activeFlag,publishedFlag,calculatedQATS");
         skuCollectionList.addFilter('product.productID',trim(arguments.data.productID));
		 skuCollectionList.setPageRecordsShow(arguments.data.pageRecordsShow);
		var results = skuCollectionList.getRecords()
    
        getHibachiScope().addActionResult("public:getProductSkus");

        arguments.data['ajaxResponse']['skus'] = results;
        arguments.data['ajaxResponse']['options'] = optsList;
                arguments.data['ajaxResponse']['defaultSelectedOptions'] = defaultSelectedOptions;
     
     }
     
public void function getConfiguration( required struct data ) {
        param name="arguments.data.siteCode" default="";
        var siteLookup = getService('siteService').getSiteBySiteCode(arguments.data.siteCode);
        getHibachiScope().setSite(siteLookup);
        
            var site = {};
            site["siteID"] = siteLookup.getSiteID();
            site["siteCode"] = siteLookup.getSiteCode();
            site["siteName"] = siteLookup.getSiteName();
            site["hibachiInstanceApplicationScopeKey"] = siteLookup.getHibachiInstanceApplicationScopeKey();
            site["hibachiConfig"] = getHibachiScope().getHibachiConfig();
            arguments.data['ajaxResponse']['config']['site'] = site;
        


        var router = []
        ArrayAppend(router , {"URLKey": getHibachiScope().setting('globalURLKeyProduct'),"URLKeyType": 'Product' });
        ArrayAppend(router , {"URLKey": getHibachiScope().setting('globalURLKeyProductType'),"URLKeyType": 'ProductType' });
        ArrayAppend(router , {"URLKey": getHibachiScope().setting('globalURLKeyCategory'),"URLKeyType": 'Category' });
        ArrayAppend(router , {"URLKey": getHibachiScope().setting('globalURLKeyBrand'),"URLKeyType": 'Brand' });
        ArrayAppend(router , {"URLKey": getHibachiScope().setting('globalURLKeyAccount'),"URLKeyType": 'Account' });
        ArrayAppend(router , {"URLKey": getHibachiScope().setting('globalURLKeyAddress'),"URLKeyType": 'Address' });
        ArrayAppend(router , {"URLKey": getHibachiScope().setting('globalURLKeyAttribute'),"URLKeyType": 'Attribute' });
        
        getHibachiScope().addActionResult("public:getConfiguration");

        arguments.data['ajaxResponse']['config']['router'] = router;
        return 
         
     }
}
