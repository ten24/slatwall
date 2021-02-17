component extends="Slatwall.model.service.PublicService" {
    
        
    public void function getProductListingOptions(required struct data){
        param name="arguments.data.siteCode" default="";
        getHibachiScope().setSite(getService('siteService').getSiteBySiteCode(arguments.data.siteCode))
        var filters = []


         ArrayAppend(filters, {
            "filterName": "Brand",
            "key": "f:brand.brandID",
            "options": getService("productService").getProductSmartList().getFilterOptions('brand.brandID', 'brand.brandName')
        })
        //  ArrayAppend(filters, {
        //     "filterName": "Category",
        //     "key": "f:categories.categoryID",
        //     "filters": getService("productService").getProductSmartList().getFilterOptions('categories.categoryID','categories.categoryName')
        // })

        ArrayAppend(filters, {
            "filterName": "Price",
            "key": "r:calculatedSalePrice",
            "options": [{
                "name": 'less than $20.00',
                "value": '^20'
            },{
                "name": '$20.00 - $50.00',
                "value": '20^50'
            },{
                "name": '$50.00 - $100.00',
                "value": '50^100'
            },{
                "name": '$100.00 - $250.00',
                "value": '100^250'
            },{
                "name": 'over $250.00',
                "value": '250^'
            }]
        })
        getHibachiScope().addActionResult("public:getProductListingOptions", false);

        arguments.data['ajaxResponse']['possibleFilters'] = filters;
        arguments.data['ajaxResponse']['attributes'] = [{
            "filterName": "Finish",
            "key": "r:finish",
            "options": [{
                "name": 'Lifetime Brass',
                "sub": '505',
                "isSelected": false,
                "count": '20',
            },
            {
                "name": 'Bright Brass',
                "sub": '605 | US3',
                "isSelected": false,
                "count": '100',
            },
            {
                "name": 'Satin Brass',
                "sub": '606 | US4',
                "isSelected": false,
                "count": '500',
            },
            ]
        }];
        arguments.data['ajaxResponse']['sortingOptions'] = [{
            "name": "Price Low To High",
            "key": "orderBy",
            "value": 'calculatedSalePrice|ASC',
        },{
            "name": "Price High To Low",
            "key": "orderBy",
            "value": 'calculatedSalePrice|DESC',
        },{
            "name": "Product Title A-Z",
            "key": "orderBy",
            "value": 'calculatedTitle|ASC',
        },{
            "name": "Product Title Z-A",
            "key": "orderBy",
            "value": 'calculatedTitle|DESC',
        },{
            "name": "Product Name A-Z",
            "key": "orderBy",
            "value": 'productName|ASC',
        },{
            "name": "Product Name Z-A",
            "key": "orderBy",
            "value": 'productName|DESC',
        },{
            "name": "Brand A-Z",
            "key": "orderBy",
            "value": 'brand.brandName|ASC',
        },{
            "name": "Brand Z-A",
            "key": "orderBy",
            "value": 'brand.brandName|DESC',
        }];
    }

    public void function getHomePageContent(required struct data){
        param name="arguments.data.siteCode" default="";
        getHibachiScope().setSite(getService('siteService').getSiteBySiteCode(arguments.data.siteCode))


      	var productCollectionList = getService('ProductService').getProductCollectionList();
		productCollectionList.setDisplayProperties("productID,productClearance,urlTitle,productFeatured,brand.brandName,brand.urlTitle,calculatedTitle,calculatedSalePrice,listPrice,livePrice,productName,calculatedSalePrice,defaultProductImageFiles");
		productCollectionList.addFilter('productFeatured',1,'=');
        local.featuredProductCollectionList = productCollectionList.getRecords(formatRecords=false);


            local.contentForHomePage = getService('siteService').getStackedContent({
              'home/shop-by' : ['linkUrl', 'title', 'customBody']
            })

        local.contentForHomePage['featuredSlider'] = #local.featuredProductCollectionList#


        getHibachiScope().addActionResult("public:getHomePageContent", true);

        arguments.data['ajaxResponse']['content'] = local.contentForHomePage;
     }
     
     public void function getProductSkus( required struct data ) {
	    param name="arguments.data.productID";
	    param name="arguments.data.currentPage" default=1;
        param name="arguments.data.pageRecordsShow" default= getHibachiScope().setting('GLOBALAPIPAGESHOWLIMIT');
        
      
      var skuCollectionList = getService('SkuService').getSkuCollectionList();
	    skuCollectionList.setDisplayProperties( "skuID,skuCode,product.productName,product.productCode,product.productType.productTypeName,product.brand.brandName,listPrice,price,renewalPrice,calculatedSkuDefinition,activeFlag,publishedFlag,calculatedQATS");
         skuCollectionList.addFilter('product.productID',trim(arguments.data.productID));
		 skuCollectionList.setPageRecordsShow(arguments.data.pageRecordsShow);
		var results = skuCollectionList.getRecords()
    
        getHibachiScope().addActionResult("public:getProductSkus");

        arguments.data['ajaxResponse']['skus'] = results;
         
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
