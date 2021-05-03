/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC
    
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
    
    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your 
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms 
    of your choice, provided that you follow these specific guidelines: 

    - You also meet the terms and conditions of the license of each 
      independent module 
    - You must not alter the default display of the Slatwall name or logo from  
      any part of the application 
    - Your custom code must not alter or create any files inside Slatwall, 
      except in the following directories:
        /integrationServices/

    You may copy and distribute the modified version of this program that meets 
    the above guidelines as a combined work under the terms of GPL for this program, 
    provided that you include the source code of that other code when and as the 
    GNU GPL requires distribution of source code.
    
    If you modify this program, you may extend this exception to your version 
    of the program, but you are not obligated to do so.

Notes:

*/
component  accessors="true" output="false" 
{
    property name="accountService" type="any";
    property name="addressService" type="any";
    property name="attributeService" type="any";
    property name="formService" type="any";
    property name="orderService" type="any";
    property name="userUtility" type="any";
    property name="paymentService" type="any";
    property name="subscriptionService" type="any";
    property name="hibachiCacheService" type="any";
    property name="hibachiCollectionService" type="any";
    property name="hibachiSessionService" type="any";
    property name="hibachiUtilityService" type="any";
    property name="productService" type="any";
    property name="skuService" type="any";
    property name="hibachiAuditService" type="any";
    property name="validationService" type="any";
    property name="hibachiService" type="any";
    property name="typeService" type="any";
    property name="giftCardService";
    property name="integrationService" type="any";
    property name="imageService" type="any";
    property name="locationService" type="any";


    variables.publicContexts = [];
    variables.responseType = "json";
    
    public any function getHibachiScope(){
        return getHibachiService().getHibachiScope();
    }
    
    public any function getDAO(required string daoName){
        return getHibachiService().getDAO(arguments.daoName);
    }
    
    public any function getService(required string serviceName){
        return getHibachiService().getService(arguments.serviceName);
    }
    
    public any function invokeMethod(required string methodName, struct methodArguments={}) {
        
		if(structKeyExists(this, arguments.methodName)) {
			var theMethod = this[ arguments.methodName ];
			return theMethod(argumentCollection = arguments.methodArguments);
		}
		
		throw("You have attempted to call the method #arguments.methodName# which does not exist in publicService");
	}
	
	public void function addFormResponse(required struct data){
		 param name="arguments.data.formResponse.formID" default="";

    	var formToProcess = getService('formService').getForm(arguments.data.formResponse.formID);
        formToProcess = getFormService().process(formToProcess,arguments.data,"addFormResponse");
    	getHibachiScope().addActionResult( "public:form.addFormResponse", formToProcess.hasErrors() );
    }
    
    
    /**
     * Utility function to parse getProducts API query
     * 
     * it will create an struct of keys, and nested structs for facet key
     * 
     * - every facet can have multiple filter values `[ id, name, slug, code ]``
     * - the facet-filters will fllow the following conventions forfilter-keys 
     *      - `facetName_[facet_value_key]` i.e. brand_name, category_id, productType_slug
     *      - for attributes, `attribute_[attributeGroupName]_[facet_value_key]` i.e. attribute_abc_name, attribute_abc_code
     *      - for options, `option_[optionGroupCode]_[facet_value_key]` i.e. option_abc_name, option_abc_code
     * 
     * - the default facet-key is `name` i.e. if the last-part of the facet-keys is missing then the value will e treated as `name`
     * - the value for filter-keys can be an array, or a single value 
     * 
     */
    public struct function parseGetProductsQuery(struct urlScopeOrStruct, string defaultFacetValueKey = 'name', string keyDelemiter='_'){
        var parsed = {};
        var allowedFacetKeys = ['f','brand','option','content','category','attribute','productType'];

        for(var thisKey in arguments.urlScopeOrStruct){
            var subKeys = listToArray(thisKey, arguments.keyDelemiter);
            var subKeysLen = subKeys.len();
            
            // append default keys as needed
            var firstSubKey = subKeys[1];
            if( allowedFacetKeys.find(firstSubKey) ){
                if( subKeysLen == 1 ){
                    subKeys.append(  arguments.defaultFacetValueKey ); 
                }  else if(subKeysLen == 2 && firstSubKey == 'f' ){
                    subKeys.append('eq'); // for filters default conditionalOperators is `Equal`
                } else if(subKeysLen == 2 && listFindNoCase('attribute,option', firstSubKey) ){
                    subKeys.append(  arguments.defaultFacetValueKey ); 
                }
            }
            
            this.recursivelyInsertIntoNestedStruct( parsed, subKeys, arguments.urlScopeOrStruct[thisKey] )
        }
        return parsed;
    }
    
    
    /**
     * Utility function to insert a value into nested structs
     * 
     * TODO: move to HibachiUtilityService
     * 
     * it loops over the keys and will create's nested structs if needed until the second-last sub key
     * and then try to insert/append value into that struct using the last sub-key as the key and the givenValue as the value for that key
     * however if there already is a vlaue for the last sub-key, then
     * - if it's a simple value or a list then it will create a array, by adding the both old and the given value values
     * - if it's an array then it will append the given value into it
     * - if it's an struct and the given value is also an struct, then it will merge both structs
     */
    public void function recursivelyInsertIntoNestedStruct(required struct theStruct, required array keys, required any theValue , string listTypeValueDelimiter=','){
        if(!arguments.keys.len() ){
            return;
        }
        
        var firstSubKey = arguments.keys[1];
        var subKeysLen = arguments.keys.len();
        
        if( subKeysLen == 1 ){
            arguments.theStruct[ firstSubKey ] = arguments.theValue;
            return;
        }

        if(!structKeyExists(arguments.theStruct, firstSubKey ) ){
            arguments.theStruct[ firstSubKey ] = {};
        }
        
        var lastSubKeyScope = theStruct[firstSubKey];
        // skip the first and created nested structs until the secondLast
        for(var i=2; i<=subKeysLen-1; i++ ){
            var nextSubKey = arguments.keys[i];
            
            if(!structKeyExists(lastSubKeyScope, nextSubKey) ){
                lastSubKeyScope[nextSubKey] = {};
            }
            lastSubKeyScope = lastSubKeyScope[nextSubKey];
        }
        
        var lastKeyToInsertOrAppend = arguments.keys[subKeysLen];
        
        // if it does not exist, add, else append into array
        if( !structKeyExists(lastSubKeyScope, lastKeyToInsertOrAppend) ){
            lastSubKeyScope[ lastKeyToInsertOrAppend ] = arguments.theValue;
            
            // if the value is a list type, convert it into an array
            var valuesArray = listToArray(arguments.theValue, arguments.listTypeValueDelimiter );
            if( valuesArray.len() > 1 ){
                lastSubKeyScope[ lastKeyToInsertOrAppend ] = valuesArray;
            }
            return;
        }
        
        var lastKeyValue = lastSubKeyScope[ lastKeyToInsertOrAppend ];
        
        // if it's a simple-value or a list turn it into an array and add the given-value into the array
        if( isSimpleValue(lastKeyValue) ){
            lastKeyValue = listToArray(lastKeyValue, arguments.listTypeValueDelimiter );
            lastKeyValue.append(arguments.theValue);
            lastSubKeyScope[ lastKeyToInsertOrAppend ] = lastKeyValue;
            return;
        }
        
        // if it's an array then try to add
        if( isArray(lastKeyValue) ){
            lastKeyValue.append(arguments.theValue, true); // merge-arrays
            return;
        }
        
        if( isStruct( lastKeyValue) ){
            if( isStruct(arguments.theValue) ){
                lastKeyValue.append(arguments.theValue); // add and override keys values from new struct
            } else {
                throw("can't merge a value into an struct without a key");
            }
            return;
        }
        
        throw("Unsupported operation...");
    }
    
    /**
     * ?[facetName]_[facetValueKey]=value
     * ?[facetName]_[subFacetKey]_[facetValueKey]=value
     * 
     * e.g.
	 * ?brand=abc OR 	 * ?brand_name=abc
	 * ?brand_id=123
	 * ?brand=abc,pqr,xyz&brand_id=123
	 * ?productType_slug=abc-pqr-xyz
	 * ?option_color=blue  OR  ?option_color_name=blue
	 * ? option_size_code=x1,x2,x3
	 * 
	 * 
	 * allowed facets, ['brand','category', 'productType', 'option', 'atttribute']
	 * 'option' and 'attributes have sub-facets'
	 * allowed facetValueKeys are ['id', 'name', 'code', 'slug' ] and if none is defined, then name is the default.
	 * 
	 * 
	 * the `parseProductSearchQuery` will split the keys by `_`[the default `keyDelemiter` ] and will create nested structs;
	 * 
	 * Additional-Filters:
	 * f_[propertyIdentifier]_[conditionalOperators]=value;
	 * e.g. 
	 * f_product.featuredFlag=1 OR f_product.featuredFlag_eq=1
	 * 
	 * conditionalOperators = [`eq`,`neq`, `gt`, `gte`, `lt`, `lte`, `like`, `in`]
	 * 
	 * Content:
	 * for content allowed facet-value-keys are [`id`, `name`, `slug`] 
	 * 
	 * Order Bys:
	 * ?orderby=someKey|direction
	 * ?orderBy=someKey|direction,someOtherKey|direction ...
	 * 
	 */
    public void function getProducts(required struct data, struct urlScope=url ){
        var hibachiScope = this.getHibachiScope();
        
        // we're not using RequestContext here, but the URL-scope
        arguments.parsedQuery = this.parseGetProductsQuery(arguments.urlScope);

		param name="arguments.parsedQuery.siteID" default='';
	    param name="arguments.parsedQuery.locale" default=hibachiScope.getSession().getRbLocale(); 

        //  account, order, for pricing
		param name="arguments.parsedQuery.order" default=hibachiScope.getCart();
		param name="arguments.parsedQuery.account" default=hibachiScope.getAccount();
        param name="arguments.parsedQuery.priceGroupCode" default='';
        
	    // facets
	    param name="arguments.parsedQuery.brand" default={};
	    param name="arguments.parsedQuery.content" default={};
	    param name="arguments.parsedQuery.option" default={};
	    param name="arguments.parsedQuery.category" default={};
	    param name="arguments.parsedQuery.attribute" default={};
	    param name="arguments.parsedQuery.productType" default={};
	    
        // Search
        param name="arguments.parsedQuery.keyword" default="";
        // Sorting
        param name="arguments.parsedQuery.orderBy" default="product.productName|DESC"; 
        // Pricing
        param name="arguments.parsedQuery.priceRange" default="";

        // Pagination
	    param name="arguments.parsedQuery.currentPage" default=1;
	    param name="arguments.parsedQuery.pageSize" default=10;
	    
	    // Additional Filters
	    // product and sku properties/attributes 
	    // like product.featuredFlag=true
	    param name="arguments.parsedQuery.f" default={}; 
	    
        // Additional Params
        param name="arguments.parsedQuery.propertyIdentifiers" default='';
        param name="arguments.parsedQuery.includeSKUCount" default=true;
        param name="arguments.parsedQuery.priceRangesCount" default=5;
	    param name="arguments.parsedQuery.includePotentialFilters" default=true;
	    
	    param name="arguments.data.includeAttributesMetadata" default=false;

	    // TODO: Nitin is working on it and will update.
        // currently it will set a transient site, but it need's to figure-out current-request-site 
	    var currentRequestSite = hibachiScope.getCurrentRequestSite();
	    if(isNUll(currentRequestSite) ){
	        // throw('current request site should never be null');
	        hibachiScope.logHibachi('CurrentRequest site is null, which should never happen');
	        var currentRequestSite = hibachiScope.getService('SiteService').newSite();
	    }
	    if( len(trim(arguments.parsedQuery.siteID)) && currentRequestSite.getSiteID() != arguments.parsedQuery.siteID ){
	        currentRequestSite = hibachiScope.getService('siteService').getSiteBySiteID(arguments.parsedQuery.siteID);
	    } else {
	        // in case if it was not passed in from the frontend, and hibachi-scope figures-out the current-request-site
	        arguments.parsedQuery.siteID = currentRequestSite.getSiteID();
	    }
	    
	    if( isNull(arguments.parsedQuery.currencyCode) || !len(trim(arguments.parsedQuery.currencyCode)) ){
	        arguments.parsedQuery.currencyCode = currentRequestSite.getCurrencyCode() ?: 'USD';
	    }
	    
	    
        /*
            Price group is prioritized as so: 
                1. Order price group
                2. Price group passed in as argument
                3. Price group on account
                4. Default to ''
        */
        if( !isNull(arguments.parsedQuery.order.getPriceGroup()) ){ 
            //order price group
            arguments.parsedQuery.priceGroupCode = arguments.parsedQuery.order.getPriceGroup().getPriceGroupCode();
        }
        // if nothing was passed-in, no price-group on order and the account is loggd-in
	    if(!len(arguments.parsedQuery.priceGroupCode) && hibachiScope.getLoggedInFlag() ){
            var holdingPriceGroups = arguments.parsedQuery.account.getPriceGroups();
            if( !isNull(holdingPriceGroups) && arrayLen(holdingPriceGroups) ){ 
                // then use First of account's price-group
                arguments.parsedQuery.priceGroupCode = holdingPriceGroups[1].getPriceGroupCode();
            }
	    }

	    var integrationPackage = currentRequestSite.setting('siteProductSearchIntegration');
	    var integrationEntity = this.getIntegrationService().getIntegrationByIntegrationPackage(integrationPackage);
        var integrationCFC = integrationEntity.getIntegrationCFC("Search");
        
        arguments.parsedQuery.site = currentRequestSite;
        arguments.data.ajaxResponse = {
            'data' : integrationCFC.getProducts( argumentCollection=arguments.parsedQuery )
        };
    }


	
	/***
	 * Method to return list of bundle groups and sku list for product
	 * 
	 * @param - productID
	 * @param - currentPage
	 * @param - pageRecordsShow
	 * @return - bundleResponse - custom array of keys
	 **/
	public void function getProductBundles( required struct data ) {
	    param name="arguments.data.productID";
	    param name="arguments.data.currentPage" default=1;
        param name="arguments.data.pageRecordsShow" default= getHibachiScope().setting('GLOBALAPIPAGESHOWLIMIT');
        
	    var product = getProductService().getProduct( arguments.data.productID );
        
        if( !isNull(product) && product.getBaseProductType() == "productBundle") {
            //get product bundles
            var bundleProductCollectionList = getProductService().getProductBundleGroupCollectionList();
            bundleProductCollectionList.setDisplayProperties("productBundleGroupID, skuCollectionConfig, minimumQuantity, maximumQuantity, amount, amountType, productBundleGroupType.typeName");
            bundleProductCollectionList.addFilter("productBundleSku.skuID", product.getDefaultSku().getSkuID());
            bundleProductCollectionList.addFilter("activeFlag", 1);
            var bundleProducts = bundleProductCollectionList.getRecords(formatRecords=false);
            
            
            //var bundleProducts = product.getDefaultSku().getProductBundleGroups();
            var bundleResponse = [];
            
            //populate bundle response
            for( var bundle in bundleProducts) {
                //get sku list form collection config
                var skuCollections = getSkuService().getSkuCollectionList();
                skuCollections.setCollectionConfig( bundle['skuCollectionConfig'] );
                skuCollections.addDisplayProperties("calculatedSkuDefinition");
                skuCollections.setPageRecordsShow(arguments.data.pageRecordsShow);
	            skuCollections.setCurrentPageDeclaration(arguments.data.currentPage); 
                var bundleSkuList = skuCollections.getPageRecords(formatRecords=false);
                
                ArrayAppend(bundleResponse, {
                  'minimumQuantity':  bundle['minimumQuantity'],
                  'maximumQuantity': bundle['maximumQuantity'],
                  'bundleType': bundle['productBundleGroupType_typeName'],
                  'amount': bundle['amount'],
                  'amountType': bundle['amountType'],
                  'skuList': bundleSkuList,
                  'defaultSkuID': product.getDefaultSku().getSkuID(),
                  'productBundleGroupID': bundle['productBundleGroupID'],
                });
            }
            
            arguments.data.ajaxResponse['data'] = bundleResponse;
            getHibachiScope().addActionResult("public:product.getProductBundles",false);
        } else {
            getHibachiScope().addActionResult("public:product.getProductBundles",true);
        }
	}
	
	/**
	 * Method to get existing product bundle builds
	 * @param - skuID (default sku ID for bundle product)
	 * @return bundleBuildResponse - custom array of product bundle builds
	 * */
	public void function getProductBundleBuild( required struct data ) {
	    param name="arguments.data.skuID";

	    var account = getHibachiScope().getAccount();
	    var sku = getProductService().getSku( arguments.data.skuID );

	    if( isNull( sku ) ) {
	        getHibachiScope().addActionResult("public:product.getProductBundleBuilds",true);
	        return;
	    }

	    var productBundleBuildCollectionList = getProductService().getProductBundleBuildCollectionList();
	    productBundleBuildCollectionList.setDisplayProperties('productBundleBuildID');
	    if( !account.isNew() ) {
	        productBundleBuildCollectionList.addFilter('account.accountID', account.getAccountID());
	    } else {
	        productBundleBuildCollectionList.addFilter('session.sessionID', getHibachiScope().getSession().getSessionID());
	    }
	    productBundleBuildCollectionList.addFilter('productBundleSku.skuID', sku.getSkuID() );
	    productBundleBuildCollectionList.addFilter('activeFlag', 1);
	    var productBundle = productBundleBuildCollectionList.getRecords();

        //return false if there are no active builds
        if( !ArrayLen( productBundle ) ) {
	        getHibachiScope().addActionResult("public:product.getProductBundleBuilds",true);
	        return;
	    }

        var productBundleBuildItemCollectionList = getProductService().getProductBundleBuildItemCollectionList();
        productBundleBuildItemCollectionList.setDisplayProperties("quantity, productBundleBuildItemID, sku.skuID")
        productBundleBuildItemCollectionList.addFilter( "productBundleBuild.productBundleBuildID",  productBundle[1]['productBundleBuildID'] );

        var bundleBuildResponse = {
            "productBundleBuildID" : productBundle[1]['productBundleBuildID'],
            "productBundleSkuID" : sku.getSkuID(),
            "bundleItems" : productBundleBuildItemCollectionList.getRecords( formatRecords = false )
        };

	    arguments.data.ajaxResponse['data'] = bundleBuildResponse;
        getHibachiScope().addActionResult("public:product.getProductBundleBuilds",false);
	}

		/**
	 * Method to create product bundle build
	 * 
	 * @param - skuID (can also accept comma separated list)
	 * @param - default skuID (from bundle product)
	 * @param - quantity (can also accept comma separated list)
	 * @param - productBundleGroupID
	 * */
	public void function createProductBundleBuild( required struct data ) {
	    param name="arguments.data.skuID";
	    param name="arguments.data.quantity";
	    param name="arguments.data.productBundleGroupID";
	    param name="arguments.data.defaultSkuID";

	    var bundleSku = getProductService().getSku( arguments.data.defaultSkuID );
	    var account = getHibachiScope().getAccount();

	    if( isNull( bundleSku ) ) {
	        getHibachiScope().addActionResult("public:product.createProductBundleBuild",true);
	        return;
	    }

	    var productBundleBuildCollectionList = getProductService().getProductBundleBuildCollectionList();
	    productBundleBuildCollectionList.setDisplayProperties('productBundleBuildID');
	    if( !account.isNew() ) {
	        productBundleBuildCollectionList.addFilter('account.accountID', account.getAccountID());
	    } else {
	        productBundleBuildCollectionList.addFilter('session.sessionID', getHibachiScope().getSession().getSessionID());
	    }
	    productBundleBuildCollectionList.addFilter('productBundleSku.skuID', bundleSku.getSkuID() );
	    productBundleBuildCollectionList.addFilter('activeFlag', 1);
	    var productBundle = productBundleBuildCollectionList.getRecords();

        if( !ArrayLen( productBundle ) ) {
            var productBundleBuild = getProductService().newProductBundleBuild();
            productBundleBuild.setProductBundleSku( bundleSku );

            if( !isNull( getHibachiScope().getSession() ) ) {
                productBundleBuild.setSession( getHibachiScope().getSession() );
            }

            if( !account.isNew() ) {
                productBundleBuild.setAccount( account );
            }
            productBundleBuild.setActiveFlag(true);
            productBundleBuild = getProductService().saveProductBundleBuild( productBundleBuild );

            if( productBundleBuild.hasErrors() ) {
                getHibachiScope().addActionResult("public:product.createProductBundleBuild",true);
	            return;
            }
        } else {
            var productBundleBuild = getProductService().getProductBundleBuild( productBundle[1]['productBundleBuildID'] );
        }

        //Check & update bundle items
        var skuList = ListToArray( arguments.data.skuID );
        var quantities = ListToArray( arguments.data.quantity );

        var index = 1;
        for( var skuID in skuList ) {
            var sku = getProductService().getSku( skuID );

            if( isNull( sku ) ) {
    	        getHibachiScope().addActionResult("public:product.createProductBundleBuild",true);
    	        return;
    	    }

            var productBundleBuildItem = getProductService().getProductBundleBuildItemBySkuANDProductBundleBuild( [sku, productBundleBuild] );

            if( isNull( productBundleBuildItem ) ) {
                productBundleBuildItem = getProductService().newProductBundleBuildItem();
            }
            productBundleBuildItem.setQuantity( quantities[ index++ ] );
            productBundleBuildItem.setSku( sku );
            productBundleBuildItem.setProductBundleBuild( productBundleBuild );
            productBundleBuildItem.setProductBundleGroup( getProductService().getProductBundleGroup( arguments.data.productBundleGroupID ) );
            productBundleBuildItem = getProductService().saveProductBundleBuildItem( productBundleBuildItem );

            if( productBundleBuildItem.hasErrors() ) {
                this.addErrors(arguments.data, productBundleBuildItem.getErrors()); //add the basic errors
                getHibachiScope().addActionResult("public:product.createProductBundleBuild", productBundleBuildItem.hasErrors());
                return;
            }
        }

        getHibachiScope().addActionResult("public:product.createProductBundleBuild",false);
	}
	
	 /**
	 * Method to delete product bundle build
	 * 
	 * @param - productBundleBuildID
	 * */
	public void function removeProductBundleBuild( required struct data ) {
	    param name="arguments.data.productBundleBuildID";
	    var account = getHibachiScope().getAccount();
	    
	    var productBundleBuild = getProductService().getProductBundleBuild( arguments.data.productBundleBuildID );
        
        if( isNull( productBundleBuild ) || ( ( !isNull(productBundleBuild.getAccount()) && productBundleBuild.getAccount().getAccountID() != account.getAccountID() ) && ( !isNull(productBundleBuild.getSession()) && productBundleBuild.getSession().getSessionID() != getHibachiScope().getSession().getSessionID() ) ) ) {
            getHibachiScope().addActionResult("public:product.removeProductBundleBuild",true);
            return;
        }
        
        var deleteBundle = getProductService().deleteProductBundleBuild( productBundleBuild );
        getHibachiScope().addActionResult("public:product.removeProductBundleBuild", !deleteBundle );
	}
	
	/**
	 * Method to set product bundle build to cart
	 * @param - productBundleBuildID
	 * */
	 public void function addProductBundleToCart( required struct data ) {
	    param name="arguments.data.productBundleBuildID";
	    var account = getHibachiScope().getAccount();
	    
	    var productBundleBuild = getProductService().getProductBundleBuild( arguments.data.productBundleBuildID );
        
        if( isNull( productBundleBuild ) || ( !isNull(productBundleBuild.getAccount()) && productBundleBuild.getAccount().getAccountID() != account.getAccountID() ) ) {
            getHibachiScope().addActionResult("public:product.addProductBundleToCart",true);
            return;
        }
        
        //set bundle sku id
        arguments.data['skuID'] = productBundleBuild.getProductBundleSku().getSkuID();
        arguments.data['quantity'] = 1;
        arguments.data['parentOrderItem']['orderItemID'] = productBundleBuild.getProductBundleSku().getSkuID();
        arguments.data['productBundleGroups'] = [];
        arguments.data['productBundleGroups'][1]['productBundleGroupID'] = productBundleBuild.getProductBundleSku().getProductBundleGroups()[1].getProductBundleGroupID();
        arguments.data['childOrderItems'] = [];
        //Populate child order items
        var childCount = 0;
        for( var bundleItem in productBundleBuild.getProductBundleBuildItems() ) {
            childCount++;
            arguments.data['childOrderItems'][childCount]['sku']['skuID'] = bundleItem.getSku().getSkuID();
            arguments.data['childOrderItems'][childCount]['quantity'] = bundleItem.getQuantity();
            arguments.data['childOrderItems'][childCount]['parentOrderItem']['orderItemID'] = bundleItem.getSku().getSkuID();
            arguments.data['childOrderItems'][childCount]['productBundleGroup']['productBundleGroupID'] = bundleItem.getProductBundleGroup().getProductBundleGroupID();
        }
        
        //Call Add Order Item
        this.addOrderItem(data= arguments.data);
        
        
        //set bundle build to false
        productBundleBuild.setActiveFlag(false);
        getProductService().saveProductBundleBuild( productBundleBuild );

	 }
	
	
	/**
	 * Get Order Details with Order Invoice
	 * @param orderID
	 * @return none
	 * */
	 public void function getOrderDetails(required struct data) {
	     param name="arguments.data.orderID";
	     
	     var account = getHibachiScope().getAccount();
	     if(!isNull(account) && !this.getHibachiScope().hibachiIsEmpty(account.getAccountID())) {
	         var order = orderService.getOrder(arguments.data.orderID);
	         if(!isNull(order) && (order.getAccount().getAccountID() == account.getAccountID() || account.getSuperUserFlag() == true ) ) {
	             arguments.data.ajaxResponse['orderDetails'] = orderService.getOrderDetails(order.getOrderID(), account.getAccountID());
	             getHibachiScope().addActionResult("public:account.getOrderDetails",false);
	         } else {
	             getHibachiScope().addActionResult("public:account.getOrderDetails",true);
	         }
	     } else {
	         getHibachiScope().addActionResult("public:account.getOrderDetails",true);
	     }
	 }
	
	/**
	 * Function add account phone phone
	 * @param phoneNumber required
	 * @return none
	 * */
	 public void function addAccountPhoneNumber(required struct data) {
	     param name="arguments.data.phoneNumber";
	     
	     var account = getService("AccountService").processAccount(getHibachiScope().getAccount(), arguments.data, 'addAccountPhoneNumber');
        if (account.hasErrors()) {
            addErrors(arguments.data, getHibachiScope().getAccount().getProcessObject('addAccountPhoneNumber').getErrors());
        }
        getHibachiScope().addActionResult("public:account.addAccountPhoneNumber",account.hasErrors());
	 }
	
	/**
	 * Function add account email address
	 * @param emailAddress required
	 * @return none
	 * */
	 public void function addAccountEmailAddress(required struct data) {
	     param name="arguments.data.emailAddress";
	     
	     var account = getService("AccountService").processAccount(getHibachiScope().getAccount(), arguments.data, 'addAccountEmailAddress');
        if (account.hasErrors()) {
            addErrors(arguments.data, getHibachiScope().getAccount().getProcessObject('addAccountEmailAddress').getErrors());
        }
        getHibachiScope().addActionResult("public:account.addAccountEmailAddress",account.hasErrors());
	 }
	
     /**
     * Function to set primary email address
     * @param accountEmailAddressID required
     * @return none
     **/
     public void function setPrimaryEmailAddress(required struct data) {
        param name="arguments.data.accountEmailAddressID";
        var accountEmailAddress = getService('accountService').getAccountEmailAddress(arguments.data.accountEmailAddressID);
        if(!isNull(accountEmailAddress) && getHibachiScope().getAccount().getAccountID() == accountEmailAddress.getAccount().getAccountID() ) {
            getHibachiScope().getAccount().setPrimaryEmailAddress(accountEmailAddress);
            var accountSave = getService('accountService').saveAccount(getHibachiScope().getAccount());
            getHibachiScope().addActionResult( "public:setPrimaryEmailAddress", accountSave.hasErrors() );
        } else {
            getHibachiScope().addActionResult( "public:setPrimaryEmailAddress", true );
        }
        
        if(isNull(accountEmailAddress)){
            addErrors(arguments.data, getHibachiScope().rbKey('validate.setPrimaryEmailAddress.accountEmailAddressID.isRequired')) ;
        }else if(getHibachiScope().getAccount().getAccountID() != accountEmailAddress.getAccount().getAccountID()){
            addErrors(arguments.data, getHibachiScope().rbKey('validate.addAccountEmailAddress.Account_AddAccountEmailAddress.emailAddress.isUniqueEmailToAccount'));
        }
        
        
        
     }
    
    
    /**
     * Function to set primary account address
     * @param accountAddressId required
     * @return none
     **/
     public void function setPrimaryAccountAddress(required struct data) {
        param name="arguments.data.accountAddressID";
        var accountAddress = getService('accountService').getAccountAddress(arguments.data.accountAddressID);
        if(!isNull(accountAddress) && getHibachiScope().getAccount().getAccountID() == accountAddress.getAccount().getAccountID() ) {
            
            getHibachiScope().getAccount().setPrimaryAddress(accountAddress);
            var accountSave = getService('accountService').saveAccount(getHibachiScope().getAccount());
            getHibachiScope().addActionResult( "public:cart.setPrimaryAccountAddress", accountSave.hasErrors() );
        } else {
            getHibachiScope().addActionResult( "public:cart.setPrimaryAccountAddress", true );
        }
     }
	
	
	/**
     * Function to set primary phone number
     * @param accountPhoneNumberID required
     * @return none
     **/
     public void function setPrimaryPhoneNumber(required struct data) {
        param name="arguments.data.accountPhoneNumberID";
        var accountPhoneNumber = getService('accountService').getAccountPhoneNumber(arguments.data.accountPhoneNumberID);
        if(!isNull(accountPhoneNumber) && getHibachiScope().getAccount().getAccountID() == accountPhoneNumber.getAccount().getAccountID() ) {
            
            getHibachiScope().getAccount().setPrimaryPhoneNumber(accountPhoneNumber);
            var accountSave = getService('accountService').saveAccount(getHibachiScope().getAccount());
            getHibachiScope().addActionResult( "public:setPrimaryPhoneNumber", accountSave.hasErrors() );
        } else {
            getHibachiScope().addActionResult( "public:setPrimaryPhoneNumber", true );
        }
     }
     
    
    /**
     * Function to get Types by Type Code
     * It adds typeList as key in ajaxResponse
     * @param typeCode required
     * @return none
    */
    public void function getSystemTypesByTypeCode(required struct data){
        param name="arguments.data.typeCode" default="";
        
        var typeList = getService('TypeService').getTypeByTypeCode(arguments.data.typeCode);
        
        if(isNull(typeList)){
            this.addErrors(arguments.data, ["No System Types Found."])
        } else {
            arguments.data.ajaxResponse['typeList'] = typeList;
        }

        getHibachiScope().addActionResult("public:getSystemTypesByTypeCode", isNull(typeList));
    }
    
    /**
     * Function to get Sku Stock
     * It adds stock as key in ajaxResponse
     * @param skuID required
     * @param locationID required
     * @return none
    */
    public void function getSkuStock(required struct data){
        param name="arguments.data.skuID" default="";
        param name="arguments.data.locationID" default="";
        
        var stock = getService('stockService').getCurrentStockBySkuAndLocation( arguments.data.skuID, arguments.data.locationID );
        arguments.data.ajaxResponse['stock'] = stock;
    }
    
    /**
     * Function to get Product Reviews
     * It adds productReviews as key in ajaxResponse
     * @param productID
     * @return none
    */
    public void function getProductReviews(required struct data){
        param name="arguments.data.productID" default="";
        
        var productReviews = getProductService().getAllProductReviews(productID = arguments.data.productID);
        arguments.data.ajaxResponse['productReviews'] = productReviews;
    }
    
    /**
     * Function to get Related Products
     * It adds relatedProducts as key in ajaxResponse
     * @param productID
     * @return none
    */
    public void function getRelatedProducts(required struct data){
        param name="arguments.data.productID" default="";
        var relatedProducts = getProductService().getAllRelatedProducts(productID = arguments.data.productID);
        //add images
        if(arrayLen(relatedProducts)) {
            relatedProducts = getProductService().appendImagesToProduct(relatedProducts, "relatedProduct_defaultSku_imageFile");
        }
        arguments.data.ajaxResponse['relatedProducts'] = relatedProducts;
    }
    
    /**
     * Function get Images assigned to product
     * It adds Images array as key in ajaxResponse
     * @param productID
     * @param defaultSkuOnlyFlag
     * @param resizeSizes ('s,m,l') optional
     * @return none
    */
    public void function getProductImageGallery(required struct data){
        param name="arguments.data.productID" default="";
        param name="arguments.data.defaultSkuOnlyFlag" default="false";
        
        var product = getProductService().getProduct(arguments.data.productID);
        if(structKeyExists(arguments.data,'resizeSizes')){
            var sizeArray = [];
            for(var size in arguments.data.resizeSizes){
                arrayAppend(sizeArray,{"size"=size});
            }
            arguments.data.resizeSizes = sizeArray;
        }
        arguments.data.ajaxResponse['images'] = product.getImageGalleryArray(argumentCollection=arguments.data);
    }
    
    /**
     * Function get Product Type detail information
     * @param urlTitle
     * @return none
    */
    public void function getProductType(required struct data){
        param name="arguments.data.urlTitle";
        
        var productType = getProductService().getProductTypeByUrlTitle( arguments.data.urlTitle );
        
        if( IsNull( productType ) 
            || ( !IsNull(productType.getActiveFlag()) && !productType.getActiveFlag() ) 
            || ( !IsNull(productType.getPublishedFlag()) && !productType.getPublishedFlag() )
            ) {
            getHibachiScope().addActionResult( "public:product.getProductType", true );
            return;
        }
        
        //get sub product types
        var childProductTypeCollectionList = getProductService().getProductTypeCollectionList();
        childProductTypeCollectionList.setDisplayProperties("productTypeName, urlTitle, imageFile, productTypeID, productTypeIDPath");
        childProductTypeCollectionList.addFilter('productTypeIDPath', "%#productType.getProductTypeID()#%", "LIKE");
        childProductTypeCollectionList.addOrderBy("productTypeIDPath|ASC"); //to arrange them from parent to child order
        var childProductTypesRecord = childProductTypeCollectionList.getRecords( formatRecords = true );
        
        var childProductTypes = [];
        var typeIndex = 0;
        for( var childProductType in childProductTypesRecord ) {
            
            //skip current record
            if( childProductType['productTypeID'] == productType.getProductTypeID()  ) {
                continue;
            }
            
            //remove parent ids from path
            var productTypeIDPath = childProductType['productTypeIDPath'];
            productTypeIDPath = ReplaceList( productTypeIDPath, productType.getProductTypeIDPath(), "");
            productTypeIDPath = ListChangeDelims( productTypeIDPath, ",", ",");
            
            var responseStruct = {
                "title": childProductType['productTypeName'],
                "productTypeID": childProductType['productTypeID'],
                "imageFile" : trim(childProductType['imageFile']) != "" ? getProductService().getProductTypeImageBasePath( frontendURL = true ) & "/" & childProductType['imageFile'] : "",
                "urlTitle" : childProductType['urlTitle']
            };
            
            //if it's a parent type set title and correct index
            if( productTypeIDPath == childProductType['productTypeID'] ) {
                childProductTypes[ ++typeIndex ] = responseStruct;
                //add an index for 2nd level sub types
                childProductTypes[ typeIndex ]["childProductTypes"] = [];
            } else {
                
                //remove immediate parent id from path
                productTypeIDPath = ReplaceList( productTypeIDPath, childProductTypes[ typeIndex ]['productTypeID'], "");
                productTypeIDPath = ListChangeDelims( productTypeIDPath, ",", ",");
                
                //add show products flag if it's last child
                StructAppend( responseStruct, {"showProducts" : productTypeIDPath !== childProductType['productTypeID'] });
                
                //append sub type array
                ArrayAppend( childProductTypes[ typeIndex ]["childProductTypes"], responseStruct);
            }
        }
        
        var titleTemplate = productType.getSettingValueFormatted('productTypeHTMLTitleString');
        var descriptionTemplate = productType.getSettingValueFormatted('productTypeMetaDescriptionString');
        var metaKeywordsTemplate = productType.getSettingValueFormatted('productTypeMetaKeywordsString');
        
        var response = {
            "title"         : productType.getProductTypeName(),
            "urlTitle"      : productType.getUrlTitle(),
            "imageFile"     : productType.getImageFile(),
            "htmlTitle"     : productType.stringReplace(template=titleTemplate, formatValues=true),
            "description"   : productType.stringReplace(template=descriptionTemplate, formatValues=true),
            "metaKeywords"  : productType.stringReplace(template=metaKeywordsTemplate, formatValues=true),
            "productTypeID" : productType.getProductTypeID()
        };

        // if image is not empty, prefix with base-path
        if( !isNull(response.imageFile) ){
            response['imageFile'] = this.getProductService().getProductTypeImageBasePath( frontendURL = true ) & "/" & response.imageFile;
        }    
    
        if( childProductTypes.len() > 0 ){
           response["childProductTypes"] = childProductTypes; 
        } else {
            response["showProducts"] = true;
        }
        
        arguments.data.ajaxResponse['data'] = response;
        this.getHibachiScope().addActionResult( "public:product.getProductType", false );
    }
    
     /**
     * Function get Product Options By Option Group
     * It adds productOptions as key in ajaxResponse
     * @param productID
     * @param optionGroupID
     * @return none
    */
    public void function getProductOptionsByOptionGroup(required struct data){
        param name="arguments.data.productID" default="";
        param name="arguments.data.optionGroupID" default="";
        
        arguments.data.ajaxResponse['productOptions'] = getService('optionService').getOptionsByOptionGroup( arguments.data.productID, arguments.data.optionGroupID );
    }
    
    /**
     * Function to get applied payments on order
     * adds appliedPayments in ajaxResponse
     * @param request data
     * @return none
     **/
    public void function getAppliedPayments(required any data) {
        
        arguments.data['ajaxResponse']['appliedPayments'] = getOrderService().getAppliedOrderPayments(getHibachiScope().getCart());
    }
    
    /**
     * Function to get applied promotions on order
     * adds appliedPromotionCodes in ajaxResponse
     * @param request data
     * @return none
     **/
    public void function getAppliedPromotionCodes(required any data) {
        
        arguments.data['ajaxResponse']['appliedPromotionCodes'] = getHibachiScope().getCart().getAllAppliedPromotions();
    }
    
    /**
     * Function to get all eligible account payment methods 
     * adds availableShippingMethods in ajaxResponse
     * @param request data
     * @return none
     **/
    public void function getAvailablePaymentMethods(required any data) {
        
        arguments.account = getHibachiScope().getAccount();
        
        var accountPaymentMethods = getService("accountService").getAvailablePaymentMethods( argumentCollection=arguments );
	    arguments.data['ajaxResponse']['availablePaymentMethods'] = accountPaymentMethods;
    }
    
    /**
     * Function to get all available shipping methods 
     * adds availableShippingMethods in ajaxResponse
     * @param request data
     * @return none
     **/
    public void function getAvailableShippingMethods(required any data) {
        var orderFulfillments = getHibachiScope().getCart().getOrderFulfillments();
        for(var orderFulfillment in orderFulfillments) {
            if(orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() == "shipping") {
                var shippingMethods = getOrderService().getShippingMethodOptions(orderFulfillment);
	            arguments.data['ajaxResponse']['availableShippingMethods'] = shippingMethods;
	            break;
            }
        }
    }
	
	/**
     * Function to get the parent accounts of user account
     **/
    public void function getParentOnAccount(required any data) {
        arguments.data['ajaxResponse']['parentAccount'] = getAccountService().getAllParentsOnAccount(getHibachiScope().getAccount());
    }
    
    /**
     * Function to get the child accounts of user account
     **/
    public void function getChildOnAccount(required any data) {
        arguments.data['ajaxResponse']['childAccount'] = getAccountService().getAllChildsOnAccount(getHibachiScope().getAccount());
    }
	
	/**
     * Function to get list of subscription usage
     * adds subscriptionUsageOnAccount in ajaxResponse
     * @param pageRecordsShow optional
     * @param currentPage optional
     * @return none
     **/
    public void function getSubscriptionsUsageOnAccount(required any data) {
        
        arguments.account = getHibachiScope().getAccount();
        
        var subscriptionUsage = getSubscriptionService().getSubscriptionsUsageOnAccount( argumentCollection=arguments );
        arguments.data['ajaxResponse']['subscriptionUsageOnAccount'] = subscriptionUsage;
    }
	
	/**
     * Function to get list of gift cards for user
     * adds giftCardsOnAccount in ajaxResponse
     * @param pageRecordsShow optional
     * @param currentPage optional
     * @return none
     **/
    public void function getAllGiftCardsOnAccount(required any data) {
        arguments.account = getHibachiScope().getAccount();
        var giftCards = getService('giftCardService').getAllGiftCardsOnAccount( argumentCollection=arguments);
        arguments.data['ajaxResponse']['giftCardsOnAccount'] = giftCards;
    }
	
	/**
     * Function to get all order deliveries for user
     * adds cartsAndQuotesOnAccount in ajaxResponse
     * @param pageRecordsShow optional
     * @param currentPage optional
     * @return none
     **/
    public void function getAllOrderDeliveryOnAccount(required any data) {
        arguments.account = getHibachiScope().getAccount();
        var accountOrders = getOrderService().getAllOrderDeliveryOnAccount( argumentCollection=arguments );
        arguments.data['ajaxResponse']['orderDeliveryOnAccount'] = accountOrders;
    }
	
	/**
     * Function to get all order fulfilments for user
     * adds cartsAndQuotesOnAccount in ajaxResponse
     * @param pageRecordsShow optional
     * @param currentPage optional
     * @return none
     **/
    public void function getAllOrderFulfillmentsOnAccount(required any data) {
        
        arguments.account = getHibachiScope().getAccount();
        
        var accountOrders = getOrderService().getAllOrderFulfillmentsOnAccount( argumentCollection=arguments );
        arguments.data['ajaxResponse']['orderFulFillemntsOnAccount'] = accountOrders;
    }
	
	/**
     * Function to get all carts and quotes for user
     * adds cartsAndQuotesOnAccount in ajaxResponse
     * @param pageRecordsShow optional
     * @param currentPage optional
     * @return none
     **/
    public void function getAllCartsAndQuotesOnAccount(required any data) {
        
        arguments.account = getHibachiScope().getAccount();
        
        var accountOrders = getOrderService().getAllCartsAndQuotesOnAccount( argumentCollection=arguments );
        arguments.data['ajaxResponse']['cartsAndQuotesOnAccount'] = accountOrders;
    }
	
	/**
     * Function to get all orders for user
     * adds ordersOnAccount in ajaxResponse
     * @param pageRecordsShow optional
     * @param currentPage optional
     * @return none
     **/ 
    public void function getAllOrdersOnAccount(required any data){
        
        arguments.account = getHibachiScope().getAccount();
        
        var accountOrders = getAccountService().getAllOrdersOnAccount(
            argumentCollection=arguments );
        arguments.data['ajaxResponse']['ordersOnAccount'] = accountOrders;
    }
	
	
	
	/**
      * Updates an Account address.
      */
    public void function updateAccountAddress(required data){
     	param name="arguments.data.countryCode" default="US";
     	param name="arguments.data.accountAddressID" default="";
     	param name="arguments.data.phoneNumber" default="";

     	var addressID = "";
     	var accountAddress = getHibachiScope().getService("AccountService").getAccountAddress( arguments.data.accountAddressID );
        
        if (!isNull(accountAddress) && getHibachiScope().getAccount().getAccountID() == accountAddress.getAccount().getAccountID() ){
            addressID = accountAddress.getAddressID();
        }

     	var newAddress = getService("AddressService").getAddress(addressID);
     	if ( !isNull(newAddress) && !newAddress.hasErrors() ) {
     	    
     	    newAddress = getService("AddressService").saveAddress(newAddress, arguments.data, "full");
     	    
     	    //save account address
     	    accountAddress = getHibachiScope().getService("AccountService").saveAccountAddress( accountAddress, arguments.data );
     	    
            if(!newAddress.hasErrors() && !accountAddress.hasErrors()) {
  	     	   getHibachiScope().addActionResult( "public:cart.updateAddress", true );
            }else {
                getHibachiScope().addActionResult( "public:cart.updateAddress", (newAddress.hasErrors() || accountAddress.hasErrors() ) ); 
            }
    	}else {
    	    if(isNull(newAddress)) {
                getHibachiScope().addActionResult( "public:cart.updateAddress", false );
    	    } else {
    	        getHibachiScope().addActionResult( "public:cart.updateAddress", newAddress.getErrors() );
    	    }
        }
     }
    
    /**
      * Updates an Account Phone Number.
      */
    public void function updateAccountPhoneNumber(required data){
     	param name="arguments.data.accountPhoneNumberID";
     	param name="arguments.data.phoneNumber" default="";
     	param name="arguments.data.countryCallingCode" default="";
     	
        if( !(getHibachiScope().getLoggedInFlag()) ) {
            arguments.data.ajaxResponse['error'] = getHibachiScope().rbKey('validate.loggedInUser.updateAccount');
        }
        if( isNull(arguments.data.accountPhoneNumberID) ) {
			return;
		}
     	var accountPhoneNumber = getAccountService().getAccountPhoneNumber( arguments.data.accountPhoneNumberID );
     	
        if (isNull(accountPhoneNumber) || getHibachiScope().getAccount().getAccountID() != accountPhoneNumber.getAccount().getAccountID() ){
            getHibachiScope().addActionResult( "public:account.updateAccountPhoneNumber", true);
            return;
        }
        this.getAccountService().saveAccountPhoneNumber( accountPhoneNumber, arguments.data, "update");
        getHibachiScope().addActionResult( "public:account.updateAccountPhoneNumber", accountPhoneNumber.hasErrors() );
     }
    
    /**
     * This will return the path to an image based on the skuIDs (sent as a comma seperated list)
     * and a 'profile name' that determines the size of that image.
     * /api/scope/getResizedImageByProfileName&profileName=large&skuIDs=8a8080834721af1a0147220714810083,4028818d4b31a783014b5653ad5d00d2,4028818d4b05b871014b102acb0700d5
     * ...should return three paths.
     */
    public any function getResizedImageByProfileName(required any data) {
        
        var imageHeight = 60;
        var imageWidth  = 60;
        
        if(arguments.data.profileName == "small"){
            imageHeight = getService('SettingService').getSettingValue('productImageSmallHeight');
            imageWidth  = getService('SettingService').getSettingValue('productImageSmallWidth');
            
        }else if (arguments.data.profileName == "medium"){
            imageHeight = getService('SettingService').getSettingValue('productImageMediumHeight');
            imageWidth  = getService('SettingService').getSettingValue('productImageMediumWidth');
        }
        else if (arguments.data.profileName == "large"){
            imageHeight = getService('SettingService').getSettingValue('productImageLargeHeight');
            imageWidth  = getService('SettingService').getSettingValue('productImageLargeWidth');
        }
        else if (arguments.data.profileName == "xlarge"){
            imageHeight = getService('SettingService').getSettingValue('productImageXLargeHeight');
            imageWidth  = getService('SettingService').getSettingValue('productImageXLargeWidth');
        }
        else if (arguments.data.profileName == "listing"){
            imageHeight = getService('SettingService').getSettingValue('productListingImageHeight');
            imageWidth  = getService('SettingService').getSettingValue('productListingImageWidth');
        }
        arguments.data.ajaxResponse['resizedImagePaths'] = {};
        var skus = [];
        
        //smart list to load up sku array
        var skuSmartList = getService('skuService').getSkuSmartList();
        skuSmartList.addInFilter('skuID',data.skuIDs);
        
        for (var skuID in data.skuIDs){
            var sku = getService('SkuService').getSku(skuID);
            if(!isNull(sku)){
                arguments.data.ajaxResponse['resizedImagePaths'][skuID] = sku.getResizedImagePath(width=imageWidth, height=imageHeight);         
            }
        }
        arguments.data.returnJsonObjects = "";
    }
    
    /**
     @method Login <b>Log a user account into Slatwall given the users emailAddress and password</b>
     @http-context <b>Login</b> Use this context in conjunction with the listed http-verb to use this resoudatae.
     @http-verb POST
     @http-return <b>(200)</b> Request Successful, <b>(400)</b> Bad or Missing Input Data
     @param Required Header: emailAddress
     @param Required Header: password
     @description Use this context to log a user into Slatwall. The required email address/password should be sent
                               bundled in a Basic Authorization header with the emailAddress and password 
                               appended together using an colon and then converted to base64.
                                                  
     @example  testuser@slatwalltest.com:Vah7cIxXe would become dGVzdHVzZXJAc2xhdHdhbGx0ZXN0LmNvbTpWYWg3Y0l4WGU=    
     @ProcessMethod Account_Login           
     */
    
    public any function login( required struct data ){
        var accountProcess = getService("AccountService").processAccount( getHibachiScope().getAccount(), arguments.data, 'login' );
        getHibachiScope().addActionResult( "public:account.login", accountProcess.hasErrors() );
        if (accountProcess.hasErrors()){
            if (getHibachiScope().getAccount().hasErrors()){
                acountProcess.$errors = getHibachiScope().getAccount().getErrors();
            }
            addErrors(data, getHibachiScope().getAccount().getProcessObject("login").getErrors());
        }
        return accountProcess;
    }
    
    /** returns the result of a processObject based action including error information. A form submit.
        This is the default behavior for a POST request to process context /api/scope/process/ */    
    public any function doProcess(required struct data){
        
        if (structKeyExists(data, "processObject")){
            try{
                var processObject = this.invokeMethod(data.processObject,{1=data});
                
            }catch(any e){
                arguments.data.ajaxResponse['processObject']['errors'] = "#e#";
            }
        }
        if (!isNull(processObject)){
            arguments.data.ajaxResponse['processObject']                  = processObject.getThisMetaData();
            arguments.data.ajaxResponse['processObject']['validations']   = processObject.getValidations();
            arguments.data.ajaxResponse['processObject']['hasErrors']     = processObject.hasErrors();
            arguments.data.ajaxResponse['processObject']['errors']        = processObject.getErrors();
            arguments.data.ajaxResponse['processObject']['messages']      = processObject.getMessages();    
        }
    }
    
    /** 
     * @method Logout <b>Log a user account outof Slatwall given the users request_token and deviceID</b>
     * @http-context Logout Use this context in conjunction with the listed http-verb to use this resoudatae.
     * @http-verb POST
     * @http-return <b>(200)</b> Request Successful <b>(400)</b> Bad or Missing Input Data
     * @description  Logs a user out of the given device  
     * @param Required request_token
     * @param Required deviceID
     * @example POST to /api/scope/logout with request_token and deviceID in headers
     * @ProcessMethod Account_Logout
     */
    public any function logout( struct data  = {} ){ 
        
        var account = getService("AccountService").processAccount( getHibachiScope().getAccount(), arguments.data, 'logout' );
        getHibachiScope().addActionResult( "public:account.logout", account.hasErrors() );
        if(account.hasErrors()){
            addErrors(data, getHibachiScope().getAccount().getProcessObject("logout").getErrors());
        }
        arguments.data.ajaxResponse['token'] = '';
        return account;
    }   
    
    /** 
     *  @method CreateAccount
     *  @http-context createAccount
     *  @http-verb POST
     *  @description  CreateAccount Creates a new user account.  
     *  @http-return <b>(201)</b> Created Successfully or <b>(400)</b> Bad or Missing Input Data
     *  @param firstName {string}
     *  @param lastName {string}
     *  @param company {string}
     *  @param phone {string}
     *  @param emailAddress {string}
     *  @param emailAddressConfirm {string}
     *  @param createAuthenticationFlag {string}
     *  @param password {string}
     *  @param passwordConfirm {string}
     *  @ProcessMethod Account_Create
     */

    public any function createAccount( required struct data ) {
        param name="arguments.data.createAuthenticationFlag" default="1";
        param name="arguments.data.returnTokenFlag" default="0";        

        var account = getService("AccountService").processAccount( getHibachiScope().getAccount(), arguments.data, 'create');

        if(account.hasErrors()){
            addErrors(arguments.data, getHibachiScope().getAccount().getProcessObject("create").getErrors());
        } else if(arguments.data.returnTokenFlag) {
            //Attempt Login
            var accountProcess = getService("AccountService").processAccount( getHibachiScope().getAccount(), arguments.data, 'login' );
            if ( !accountProcess.hasErrors() && getHibachiScope().getLoggedinFlag() ){
                arguments.data.ajaxResponse['token'] = getService('HibachiJWTService').createToken();
            }
        }

        getHibachiScope().addActionResult( "public:account.create", account.hasErrors() );
        return account;
    }
    
    public any function updatePrimaryEmailAddress(required struct data) {
        var account = getService("AccountService").processAccount(getHibachiScope().getAccount(), arguments.data, 'updatePrimaryEmailAddress');
        if (account.hasErrors()) {
            addErrors(arguments.data, getHibachiScope().getAccount().getProcessObject('updatePrimaryEmailAddress').getErrors());
        }
        getHibachiScope().addActionResult("public:account.updatePrimaryAccountEmailAddress",account.hasErrors());
    }
    
    public any function updatePassword(requried struct data) {
        var account = getService("AccountService").processAccount(getHibachiScope().getAccount(), arguments.data, 'updatePassword');
        if (account.hasErrors()) {
            addErrors(arguments.data, getHibachiScope().getAccount().getProcessObject('updatePassword').getErrors());
        }
        getHibachiScope().addActionResult("public:account.updatePassword",account.hasErrors());
    }
    
    /**
     * @http-context updateDeviceID
     * @description  Updates the device ID for a user account 
     * @http-return <b>(201)</b> Created Successfully or <b>(400)</b> Bad or Missing Input Data
     */
    public void function updateDeviceID( required struct data ){
        param name="arguments.data.deviceID" default="";
        param name="arguments.data.request_token" default="";

        var sessionEntity = getService("HibachiSessionService").getSessionBySessionCookie('sessionCookieNPSID', arguments.data.request_token, true );
        sessionEntity.setDeviceID(arguments.data.deviceID);
        
        //If this is a request from the api, setup the response header and populate it with data.
        //any onSuccessCode, any onErrorCode, any genericObject, any responseData, any extraData, required struct data
        //handlePublicAPICall(201, 400, sessionEntity, "Device ID Added", "#arguments.data.deviceID#",  arguments.data);  
    }
    
    
    /**
      * @method forgotPassword
      * @http-context ForgotPassword
      * @http-verb POST
      * @description  Sends an email to a user to reset a password.  
      * @htt-return <b>(200)</b> Successfully Sent or <b>(400)</b> Bad or Missing Input Data
      * @param emailAddress {string}
      * @ProcessMethod Account_ForgotPassword
      **/
    public any function forgotPassword( required struct data ) {
        var account = getService("AccountService").processAccount( getHibachiScope().getAccount(), arguments.data, 'forgotPassword');
        //let's hard code the action to always be successful. Indicating failure exposes if the account exists and is a security issue
        getHibachiScope().addActionResult( "public:account.forgotPassword", false );
        return account;
    }
    
    /**
      * @method resetPasswordUpdate
      * @http-context resetPasswordUpdate
      * @http-verb POST
      * @description  Reset User Password based on reset token - This method to be used as API end point
      * @http-return <b>(200)</b> Successfully Sent or <b>(400)</b> Bad or Missing Input Data
      * @param accountID {string}
      * @param emailAddress {string}
      * @ProcessMethod Account_ResetPassword
      **/
    public void function resetPasswordUpdate( required struct data ) {
        param name="data.swprid";

        var account = getAccountService().getAccount( left(arguments.data.swprid, 32) );

        //Check if account is not null and has correct reset token
        if(!isNull(account) && getAccountService().getPasswordResetID(account, false) == arguments.data.swprid ) {
            var account = getService("AccountService").processAccount(account, data, "resetPassword");
            if (account.hasErrors()) {
                addErrors(arguments.data, account.getProcessObject('resetPassword').getErrors());
            }

            getHibachiScope().addActionResult( "public:account.resetPassword", account.hasErrors() );

        } else {
            getHibachiScope().addActionResult( "public:account.resetPassword", true );
        }
    }
    
    /**
      * @method resetPassword
      * @http-context resetPassword
      * @http-verb POST
      * @description  Sends an email to a user to reset a password.  
      * @http-return <b>(200)</b> Successfully Sent or <b>(400)</b> Bad or Missing Input Data
      * @param accountID {string}
      * @param emailAddress {string}
      * @ProcessMethod Account_ResetPassword
      **/
    public any function resetPassword( required struct data ) {
        param name="data.accountID" default="";
        var account = getAccountService().getAccount( data.accountID );
        if(!isNull(account)) {
            var account = getService("AccountService").processAccount(account, data, "resetPassword");
            getHibachiScope().addActionResult( "public:account.resetPassword", account.hasErrors() );
            // As long as there were no errors resetting the password, then we can set the email address in the form scope so that a chained login action will work
            if(!account.hasErrors() && !structKeyExists(form, "emailAddress") && !structKeyExists(url, "emailAddress")) {
                form.emailAddress = account.getEmailAddress();
            }
        } else {
            getHibachiScope().addActionResult( "public:account.resetPassword", true );
        }
        
        if ( account.getProcessObject( "resetPassword" ).hasErrors() ) {
            this.addErrors( data, account.getProcessObject( "resetPassword" ).getErrors() );
        }
        
        // Populate the current account with this processObject so that any errors are there.
        getHibachiScope().account().setProcessObject( account.getProcessObject( "resetPassword" ) );
        return account.getProcessObject( "resetPassword" );
    }
    
    /**
      * @method changePassword
      * @http-context changePassword
      * @http-verb POST
      * @description  Change a users password.  
      * @http-return <b>(200)</b> Successfully Sent or <b>(400)</b> Bad or Missing Input Data
      * @param emailAddress {string}
      * @ProcessMethod Account_ChangePassword
      **/
    public any function changePassword( required struct data ) {
        
        var account = getService("AccountService").processAccount( getHibachiScope().getAccount(), arguments.data, 'changePassword');
        getHibachiScope().addActionResult( "public:account.changePassword", account.hasErrors() );
        addErrors(arguments.data, account.getProcessObject('changePassword').getErrors());
        return account;
    }
    
    /**
      * @method updateAccount
      * @http-context updateAccount
      * @http-verb POST
      * @description  Update a users account data.  
      * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
      * @param aFieldToUpdate {json key}
      * @param authToken {json key}
      * @ProcessMethod Account_Save
      **/
    public any function updateAccount( required struct data ) {
        param name="arguments.data.context" default="save";
     
        var account = getAccountService().saveAccount( getHibachiScope().getAccount(), arguments.data, arguments.data.context);
        getHibachiScope().addActionResult( "public:account.update", account.hasErrors() );
        if(account.hasErrors()){
            var errorStruct = account.getErrors();
            for(var key in errorStruct){
                var messagesArray = errorStruct[key];
                for(var message in messagesArray){
                    getHibachiScope().showMessage(message,"error");
                }
            }
            
            addErrors(arguments.data, account.getErrors());
        }

        return account;
    }
    
    /**
      * @method deleteAccountEmailAddress
      * @http-context deleteAccountEmailAddress
      * @http-verb POST
      * @description delete a users account email address
      * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
      * @param emailAddress {string}
      * @ProcessMethod AccountEmailAddress_Delete
      **/
    public any function deleteAccountEmailAddress() {
        param name="data.accountEmailAddressID" default="";
        
        var accountEmailAddress = getAccountService().getAccountEmailAddress( data.accountEmailAddressID );
        
        if(!isNull(accountEmailAddress) && accountEmailAddress.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID() ) {
            var deleteOk = getAccountService().deleteAccountEmailAddress( accountEmailAddress );
            getHibachiScope().addActionResult( "public:account.deleteAccountEmailAddress", !deleteOK );
        } else {
            getHibachiScope().addActionResult( "public:account.deleteAccountEmailAddress", true );  
        }
        return accountEmailAddress;
    }
    
    /** 
      * @method sendAccountEmailAddressVerificationEmail
      * @http-context send AccountEmailAddressVerificationEmail
      * @description Account Email Address - Send Verification Email 
      * @param accountEmailAddressID The ID of the email address
      * @http-return <b>(200)</b> Successfully Sent or <b>(400)</b> Bad or Missing Input Data
      * @ProcessMethod AccountEmailAddress_SendVerificationEmail
      */
    public void function sendAccountEmailAddressVerificationEmail() {
        param name="data.accountEmailAddressID" default="";
        
        var accountEmailAddress = getAccountService().getAccountEmailAddress( data.accountEmailAddressID );
        
        if(!isNull(accountEmailAddress) && !isNull(accountEmailAddress.getVerifiedFlag()) && !accountEmailAddress.getVerifiedFlag()) {
            accountEmailAddress = getAccountService().processAccountEmailAddress( accountEmailAddress, data, 'sendVerificationEmail' );
            getHibachiScope().addActionResult( "public:account.sendAccountEmailAddressVerificationEmail", accountEmailAddress.hasErrors() );
        } else {
            getHibachiScope().addActionResult( "public:account.sendAccountEmailAddressVerificationEmail", true );
        }
        
        //return accountEmailAddress;
    }
    
    /** 
     * @method verifyAccountEmailAddress
     * @http-context verifyAccountEmailAddress
     * @http-resoudatae /api/scope/verifyAccountEmailAddress
     * @description Account Email Address - Verify 
     * @http-return <b>(200)</b> Successfully Sent or <b>(400)</b> Bad or Missing Input Data
     * @ProcessMethod AccountEmailAddress_Verify
     */
    public void function verifyAccountEmailAddress() {
        param name="data.accountEmailAddressID" default="";
        
        var accountEmailAddress = getAccountService().getAccountEmailAddress( data.accountEmailAddressID );
        
        if(!isNull(accountEmailAddress)) {
            accountEmailAddress = getAccountService().processAccountEmailAddress( accountEmailAddress, data, 'verify' );
            getHibachiScope().addActionResult( "public:account.verifyAccountEmailAddress", accountEmailAddress.hasErrors() );
        } else {
            getHibachiScope().addActionResult( "public:account.verifyAccountEmailAddress", true );
        }
        //handlePublicAPICall(200, 400, accountEmailAddress, "Email Address Verified", "",  arguments.data);
    }
    
    /** 
     * @http-context deleteAccountPhoneNumber
     * @http-verb Delete
     * @description Deletes an Account Phone Number by an accountID 
     * @http-return <b>(200)</b> Successfully Deleted or <b>(400)</b> Bad or Missing Input Data
     * @ProcessMethod AccountPhoneNumber_Delete
     */
    public void function deleteAccountPhoneNumber() {
        param name="data.accountPhoneNumberID" default="";
        
        var accountPhoneNumber = getAccountService().getAccountPhoneNumber( data.accountPhoneNumberID );
        
        if(!isNull(accountPhoneNumber) && accountPhoneNumber.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID() ) {
            var deleteOk = getAccountService().deleteAccountPhoneNumber( accountPhoneNumber );
            getHibachiScope().addActionResult( "public:account.deleteAccountPhoneNumber", !deleteOK );
        } else {
            getHibachiScope().addActionResult( "public:account.deleteAccountPhoneNumber", true );   
        }
    }
    
    /** 
     * @http-context deleteAccountAddress
     * @description Account Address - Delete 
     * @http-return <b>(200)</b> Successfully Deleted or <b>(400)</b> Bad or Missing Input Data
     * @ProcessMethod AccountAddress_Delete
     */
    public void function deleteAccountAddress() {
        param name="data.accountAddressID" default="";
        
        var accountAddress = getAccountService().getAccountAddress( data.accountAddressID );
        
        if(!isNull(accountAddress) &&
            !IsNull(accountAddress.getAccount()) &&
            getHibachiScope().getLoggedInFlag()  &&
            accountAddress.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID() 
        ) {
            
            var deleteOk = getAccountService().deleteAccountAddress( accountAddress );
            getHibachiScope().addActionResult( "public:account.deleteAccountAddress", !deleteOK );
         
            if(!deleteOk) {
                if(accountAddress.hasErrors()){
                    this.addErrors( arguments.data, accountAddress.getErrors() );
                } else {
                    this.addErrors(  arguments.data, [ 
                        { 'AccountAddress': getHibachiScope().rbKey('validate.define.somethingWentWrong') } 
                    ]);
                }
            }else{
                getDao('AccountAddressDAO').deleteDependentRelationsByAccountAddressID(data.accountAddressID);
            }
            
        } else {
            this.addErrors(arguments.data, [ 
                { 'AccountAddress': getHibachiScope().rbKey('validate.delete.AccountAddress.Invalid') }
            ]);
            getHibachiScope().addActionResult( "public:account.deleteAccountAddress", true );   
        }
    }
    
   public void function verifyAddress(required struct data){
        param name="data.accountAddressID" default="";

        arguments.data['ajaxResponse']['verifyAddress'] = getService("AddressService").verifyAccountAddressByID(arguments.data.accountAddressID);
        getHibachiScope().addActionResult("verifyAddress",false);
    }
    
    public void function addEditAccountAddress(required any data){


        if(structKeyExists(arguments.data,'accountAddressID') && len(arguments.data['accountAddressID'])){
            param name="data.countrycode" default="US";
         	var accountAddress = getService("AccountService").getAccountAddress(data.accountAddressID);
         	if (structKeyExists(data, "accountAddressName")){
         		accountAddress.setAccountAddressName(data.accountAddressName);
         	}
         	var address = accountAddress.getAddress();
         	address = getService("AddressService").saveAddress(address, data, "full");
          	
          	if (!address.hasErrors()){
          		accountAddress.setAddress(address);
          		accountAddress.setAccount(getHibachiScope().getAccount());	
          		var savedAccountAddress = getService("AccountService").saveAccountAddress(accountAddress);
                getHibachiScope().addActionResult("public:account.addNewAccountAddress", savedAccountAddress.hasErrors());
       	     	if (!savedAccountAddress.hasErrors()){
       	     		getDao('hibachiDao').flushOrmSession();
                    arguments.data.accountAddressID = savedAccountAddress.getAccountAddressID();
                    arguments.data['ajaxResponse']['newAccountAddressID'] = arguments.data.accountAddressID;
                    arguments.data['ajaxResponse']['newAccountAddress'] = savedAccountAddress.getStructRepresentation();

                    var addressVerificationStruct = getService('AddressService').verifyAddressByID(savedAccountAddress.getAddress().getAddressID());
                    arguments.data.ajaxResponse['addressVerification'] = addressVerificationStruct;
       	     	}
          	}else{
              this.addErrors(arguments.data, address.getErrors());
              getHibachiScope().addActionResult("public:account.addNewAccountAddress", address.hasErrors());
            }
        }else{
            addNewAccountAddress(argumentCollection=arguments);
        }
    }
    
     /**
      * Adds a new account address.
      */
     public void function addNewAccountAddress(required data){
     	param name="data.countrycode" default="US";
     	
     	var accountAddress = getService("AccountService").newAccountAddress();
     	if (structKeyExists(data, "accountAddressName")){
     		accountAddress.setAccountAddressName(data.accountAddressName);
     	}
     	var newAddress = getService("AddressService").newAddress();
     	newAddress = getService("AddressService").saveAddress(newAddress, data, "full");
      	
      	if (!newAddress.hasErrors()){
      		accountAddress.setAddress(newAddress);
      		if( !getHibachiScope().getAccount().getNewFlag() ){
      		    accountAddress.setAccount(getHibachiScope().getAccount());	
      		}
      		var savedAccountAddress = getService("AccountService").saveAccountAddress(accountAddress);
            getHibachiScope().addActionResult("public:account.addNewAccountAddress", savedAccountAddress.hasErrors());
   	     	if (!savedAccountAddress.hasErrors()){
   	     		getDao('hibachiDao').flushOrmSession();
                arguments.data.accountAddressID = savedAccountAddress.getAccountAddressID();
                arguments.data['ajaxResponse']['newAccountAddressID'] = arguments.data.accountAddressID;
                arguments.data['ajaxResponse']['newAccountAddress'] = savedAccountAddress.getStructRepresentation();

                var addressVerificationStruct = getService('AddressService').verifyAddressByID(savedAccountAddress.getAddress().getAddressID());
                arguments.data.ajaxResponse['addressVerification'] = addressVerificationStruct;
   	     	}
      	}else{
          this.addErrors(data, newAddress.getErrors());
          getHibachiScope().addActionResult("public:account.addNewAccountAddress", newAddress.hasErrors());
        }
     }
     
     /**
      * Updates an address.
      */
    public void function updateAddress(required data){
     	param name="data.countrycode" default="US";
     	param name="data.addressID" default="";
     	param name="data.phoneNumber" default="";
     	
     	var newAddress = getService("AddressService").getAddress(data.addressID, true);
     	if (!isNull(newAddress) && !newAddress.hasErrors()){
     	    newAddress = getService("AddressService").saveAddress(newAddress, data, "full");
      		//save the order.
          if(!newAddress.hasErrors()){
  	     	   getService("OrderService").saveOrder(getHibachiScope().getCart());
           }else{
            this.addErrors(data, newAddress.getErrors());
           }
  	     	getHibachiScope().addActionResult( "public:cart.updateAddress", newAddress.hasErrors() ); 
    	}else{
        getHibachiScope().addActionResult( "public:cart.updateAddress", true );
      }
     }
    
    /** 
     * @http-context deleteAccountAddress
     * @description Account Payment Method - Delete 
     * @http-return <b>(200)</b> Successfully Deleted or <b>(400)</b> Bad or Missing Input Data
     * @ProcessMethod AccountPaymentMethod_Delete
     */
    public void function deleteAccountPaymentMethod(required struct data) {
        param name="data.accountPaymentMethodID" default="";
        
        var accountPaymentMethod = getAccountService().getAccountPaymentMethod( data.accountPaymentMethodID );
        
        if(!isNull(accountPaymentMethod) && accountPaymentMethod.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID() ) {
            var deleteOk = getAccountService().deleteAccountPaymentMethod( accountPaymentMethod );
            getHibachiScope().addActionResult( "public:account.deleteAccountPaymentMethod", !deleteOK );
            if(!deleteOk) {
                ArrayAppend(arguments.data.messages, accountPaymentMethod.getErrors(), true);
            }
        } else {
            getHibachiScope().addActionResult( "public:account.deleteAccountPaymentMethod", true ); 
        }
    }
    
    public any function addOrderShippingAddress(required data){
        param name="data.saveAsAccountAddressFlag" default="0";
        param name="data.saveShippingAsBilling" default="1";
        /** add a shipping address */
        var shippingAddress = {};
        if (!isNull(data)){
            //if we have that data and don't have any suggestions to make, than try to populate the address
            shippingAddress = getService('AddressService').newAddress();   
            //get a new address populated with the data.

            var savedAddress = getService('AddressService').saveAddress(shippingAddress, data, "full");
            if (isObject(savedAddress) && !savedAddress.hasErrors()){
                //save the address at the order level.
                if(structKeyExists(arguments.data, 'orderID')){
                    var order = getOrderService().getOrder(arguments.data.orderID);
                    if(isNull(order) || order.getaccount().getAccountID() != getHibachiScope().getAccount().getAccountID() ){
                        this.addErrors(data, 'Could not find Order');
                        getHibachiScope().addActionResult( "public:cart.addShippingAddress", true);
                        return;
                    }
                }
                var order = getHibachiScope().cart();
                order.setShippingAddress(savedAddress);
                for(var fulfillment in order.getOrderFulfillments()){
                  if(fulfillment.getOrderFulfillmentID() == data.fulfillmentID){
                    var orderFulfillment = fulfillment;
                  }
                }
                if(!isNull(orderFulfillment) && !orderFulfillment.hasErrors()){
                    orderFulfillment.setShippingAddress(savedAddress);
                    //Add Shiping Method on Order Fulfillment
                    if(StructKeyExists(arguments.data, 'shippingMethodID') && !this.getHibachiScope().hibachiIsEmpty(arguments.data.shippingMethodID) ) {
                        var shippingMethod = getService('ShippingService').getShippingMethod(arguments.data.shippingMethodId);
                        if(!isNull(shippingMethod)) {
                            orderFulfillment.setShippingMethod(shippingMethod);
                        }
                    }
                }
                if (structKeyExists(data, "saveShippingAsBilling") && data.saveShippingAsBilling){
                    order.setBillingAddress(savedAddress);
                }
                
                if (structKeyExists(data, "saveAsAccountAddressFlag") && data.saveAsAccountAddressFlag){
                   
                 	var accountAddress = getService("AccountService").newAccountAddress();
                 	accountAddress.setAddress(shippingAddress);
                 	accountAddress.setAccount(getHibachiScope().getAccount());
                 	var savedAccountAddress = getService("AccountService").saveAccountAddress(accountAddress);
                 	if (!savedAddress.hasErrors()){
                 		getDao('hibachiDao').flushOrmSession();
                 	}
                  
                }
                
                getService("OrderService").saveOrder(order);
                if(structKeyExists(arguments.data,'ajaxResponse')){
                    // var addressVerificationStruct = getService('AddressService').verifyAddressByID(savedAddress.getAddressID());
                    arguments.data.ajaxResponse['addressVerification'] = getService('AddressService').verifyAddressByID(savedAddress.getAddressID());
                }
                getHibachiScope().addActionResult( "public:cart.addShippingAddress", order.hasErrors());
            }else{
                    
                    this.addErrors(data, savedAddress.getErrors()); //add the basic errors
                    getHibachiScope().addActionResult( "public:cart.addShippingAddress", savedAddress.hasErrors());
            }
        }
    }
    
    /** Adds a shipping address to an order using an account address */
    public void function addShippingAddressUsingAccountAddress(required data){
        if(structKeyExists(data,'accountAddressID')){
          var accountAddressId = data.accountAddressID;
        }else{
            getHibachiScope().addActionResult( "public:cart.addShippingAddressUsingAccountAddress", true);
          return;
        }

        var accountAddress = getService('AddressService').getAccountAddress(accountAddressID);
        if (!isNull(accountAddress) && !accountAddress.hasErrors()){
            //save the address at the order level.
            if(structKeyExists(arguments.data, 'orderID')){
                var order = getOrderService().getOrder(arguments.data.orderID);
                if(isNull(order) || order.getaccount().getAccountID() != getHibachiScope().getAccount().getAccountID() ){
                    this.addErrors(data, 'Could not find Order');
                    getHibachiScope().addActionResult( "public:cart.addShippingAddressUsingAccountAddress", true);
                    return;
                }
            }else{
                var order = getHibachiScope().getCart();
            }
            
            if(structKeyExists(data,'fulfillmentID')){
                
                var orderFulfillment = getOrderService().getOrderFulfillment(arguments.data.fulfillmentID);
                if(!isNull( orderFulfillment ) && !isNull( orderFulfillment.getOrder() ) && orderFulfillment.getOrder().getOrderID() == order.getOrderID()){
                    orderFulfillment.setShippingAddress(accountAddress.getAddress());
                    orderFulfillment.setAccountAddress(accountAddress);
                }
                
            }else{
                for(var fulfillment in order.getOrderFulfillments()){
                    fulfillment.setShippingAddress(accountAddress.getAddress());
                    fulfillment.setAccountAddress(accountAddress);
                    getService("OrderService").saveOrderFulfillment(orderFulfillment = fulfillment, updateOrderAmounts = false);
                }
            }
            getService("OrderService").saveOrder(order = order, updateOrderAmounts = false);
            getHibachiScope().addActionResult( "public:cart.addShippingAddressUsingAccountAddress", order.hasErrors());
        }else{
            if(!isNull(accountAddress)){
              this.addErrors(arguments.data, accountAddress.getErrors()); //add the basic errors
            }
            getHibachiScope().addActionResult( "public:cart.addShippingAddressUsingAccountAddress", true);
        }
    }

    /** Sets an email address for email fulfillment */
    public void function addEmailFulfillmentAddress(required data){
      var emailAddress = data.emailAddress;
      var order = getHibachiScope().getCart();
      var orderFulfillments = order.getOrderFulfillments();

      for(var fulfillment in orderFulfillments){
        if(fulfillment.getOrderFulfillmentID() == data.fulfillmentID){
          var orderFulfillment = fulfillment;
          break;
        }
      }

      if(!isNull(orderFulfillment)){
        orderFulfillment.setEmailAddress(emailAddress);
        orderFulfillment.validate("save");
        if(!orderFulfillment.hasErrors()){

          getService("OrderService").saveOrder(order);
          getDao('hibachiDao').flushOrmSession();
          getHibachiScope().addActionResult('public:cart.addEmailFulfillmentAddress', order.hasErrors());

        }else{
            this.addErrors(arguments.data, orderFulfillment.getErrors());
            entityReload(orderFulfillment);
            getHibachiScope().addActionResult('public:cart.addEmailFulfillmentAddress', orderFulfillment.hasErrors());
        }
      }else{
          getHibachiScope().addActionResult('public:cart.addEmailFulfillmentAddress', true);
      }
    }

    /** Set store pickup location */
    public void function addPickupFulfillmentLocation(required struct data){
      param name="arguments.data.value" default="";
      
      if(!len(arguments.data.value)){
          getHibachiScope().addActionResult('public:cart.addPickupFulfillmentLocation', true);
          return;
      }
      var location = this.getLocationService().getLocation(arguments.data.value);
      
      if(isNull(location)){
          getHibachiScope().addActionResult('public:cart.addPickupFulfillmentLocation', true);
          return;
      }
      var order = getHibachiScope().getCart();
      var orderFulfillments = order.getOrderFulfillments();

      for(var fulfillment in orderFulfillments){
        if(!isNull(arguments.data.fulfillmentID)){
          if(fulfillment.getOrderFulfillmentID() == arguments.data.fulfillmentID){
            var orderFulfillment = fulfillment;
            break;
          }
        }else if(fulfillment.getFulfillmentMethod().getFulfillmentMethodType() == 'pickup'){
          var orderFulfillment = fulfillment;
          break;
        }
      }

      if(!isNull(orderFulfillment) && !orderFulfillment.hasErrors()){
        orderFulfillment.setPickupLocation(location);
        orderFulfillment = getService("OrderService").saveOrderFulfillment(orderFulfillment);
        getService("OrderService").saveOrder(order);
        getDAO('HibachiDAO').flushOrmSession();
        getHibachiScope().addActionResult('public:cart.addPickupFulfillmentLocation', order.hasErrors());
      }else{
        if(!isNull(orderFulfillment)){
          this.addErrors(arguments.data, orderFulfillment.getErrors());
        }
        getHibachiScope().addActionResult('public:cart.addPickupFulfillmentLocation', true);
      }
    }
    
   /** Sets the shipping method to an order shippingMethodID */
    public void function addShippingMethodUsingShippingMethodID(required struct data, boolean addSuccessAction=true){
        param name="arguments.data.shippingMethodID" default="";
        
        if(!len(arguments.data.shippingMethodID)){
            getHibachiScope().addActionResult( "public:cart.addShippingMethodUsingShippingMethodID", true);  
            return;
        }
        
        if(structKeyExists(arguments.data, 'orderFulfillmentWithShippingMethodOptions')){
            arguments.data.orderFulfillmentWithShippingMethodOptions += 1;//from js to cf
        }else{
            arguments.data.orderFulfillmentWithShippingMethodOptions = 1;
        }
        
        var shippingMethod = getService('ShippingService').getShippingMethod(arguments.data.shippingMethodID);
        
        if(isNull(shippingMethod)){
            getHibachiScope().addActionResult( "public:cart.addShippingMethodUsingShippingMethodID", true);
            return;
        }
        
        if (shippingMethod.hasErrors()){
            getHibachiScope().addActionResult( "public:cart.addShippingMethodUsingShippingMethodID", shippingMethod.hasErrors());
            return;
        }
        
        var order = getHibachiScope().cart();
        var orderFulfillments = order.getOrderFulfillments();
        
        if(structKeyExists(arguments.data, 'fulfillmentID')){
            //TODO: Refactor this loop
            for(var fulfillment in orderFulfillments){
                if(fulfillment.getOrderFulfillmentID() == data.fulfillmentID){
                    var orderFulfillment = fulfillment;
                    break;
                }
            }
            orderFulfillment.setShippingMethod(shippingMethod);
            getService("OrderService").saveOrder(order = order, updateOrderAmounts = false); 
            getHibachiScope().flushOrmSession();
            if(arguments.addSuccessAction || shippingMethod.hasErrors()){
                getHibachiScope().addActionResult( "public:cart.addShippingMethodUsingShippingMethodID", shippingMethod.hasErrors());          
            }
        }else{
             getHibachiScope().addActionResult( "public:cart.addShippingMethodUsingShippingMethodID", true);
            return;
        }
        
        orderFulfillment.setShippingMethod(shippingMethod);
        orderFulfillment = getService("OrderService").saveOrderFulfillment(orderFulfillment = orderFulfillment, updateOrderAmounts = false);
        if(orderFulfillment.hasErrors()){
            getHibachiScope().addActionResult( "public:cart.addShippingMethodUsingShippingMethodID", orderFulfillment.hasErrors());
            return;
        }
        order = getService("OrderService").saveOrder(order = order, updateOrderAmounts = false); 
        if(!order.hasErrors()){
			getDao('hibachiDao').flushOrmSession();
        }else{
		    getHibachiScope().addActionResult( "public:cart.addShippingMethodUsingShippingMethodID", order.hasErrors());          
        }
    }
    
    public any function addBillingAddressUsingAccountAddress(required data){
        var accountAddress = getService('addressService').getAccountAddress(data.accountAddressID);
        
        if(!isNull(accountAddress)){
            getHibachiScope().getCart().setBillingAccountAddress(accountAddress);
            var addressData = {
                address=accountAddress.getAddress()  
            };
        }
        
        return addBillingAddress(addressData);
    }
    
    /** adds a billing address to an order. 
    @ProcessMethod Address_Save
    */
    public any function addBillingAddress(required data){
        param name="data.saveAsAccountAddressFlag" default="0"; 
        
        //if we have that data and don't have any suggestions to make, than try to populate the address
        billingAddress = getService('AddressService').newAddress();    
        
        //if we have an address then copy it and validate it
        if(structKeyExists(data,'address')){
            var savedAddress = getService('AddressService').copyAddress(data.address);
            savedAddress = getService('AddressService').saveAddress(savedAddress, {}, "full");    
        
        }else if(!isNull(data.addressID)){
            var savedAddress = getService('AddressService').getAddress(data.addressID);
        }//get a new address populated with the data.    
        else{
            var savedAddress = getService('AddressService').saveAddress(billingAddress, arguments.data, "full");    
        }
        
        if (!isNull(savedAddress) && !savedAddress.hasErrors()){
            //save the address at the order level.
            var order = getHibachiScope().cart();
            order.setBillingAddress(savedAddress);
            
            var orderPayments = order.getOrderPayments();
            if(arrayLen(orderPayments)){
               orderPayments[1].setBillingAddress(savedAddress); 
            }
            
            getService("OrderService").saveOrder(order);
            getHibachiScope().addActionResult( "public:cart.addBillingAddress", false);
        }
        
        if(isNull(savedAddress)){
            getHibachiScope().addActionResult( "public:cart.addBillingAddress", true);
            return;
        }
        
        if(savedAddress.hasErrors()){
            this.addErrors(arguments.data, savedAddress.getErrors()); //add the basic errors
    	    getHibachiScope().addActionResult( "public:cart.addBillingAddress", true);
        }
        return savedAddress;
    }
    
    /** 
     * @http-context addAccountPaymentMethod
     * @description Account Payment Method - Add 
     * @http-return <b>(200)</b> Successfully Deleted or <b>(400)</b> Bad or Missing Input Data
     * @ProcessMethod AccountPaymentMethod_Save
     */
    public void function addAccountPaymentMethod(required any data) {
        
        if (!isNull(data) && !structKeyExists(data, 'accountPaymentMethod') && structKeyExists(data, "selectedPaymentMethod")){
        	data['accountPaymentMethod'] = {};
        	data['accountPaymentMethod']['accountPaymentMethodID']  = data.selectedPaymentMethod;
        }
        if (!isNull(data) && !structKeyExists(data, 'paymentMethod')){
         	data['paymentMethod'] = {};
         	data['paymentMethod'].paymentMethodID = '444df303dedc6dab69dd7ebcc9b8036a';
        }
        if (!isNull(data) && structKeyExists(data, 'newOrderPayment')){
         	data['accountPaymentMethod'] = data;
         	data['accountPaymentMethod']['billingAddress'] = data.newOrderPayment;
        }
        
        if(getHibachiScope().getLoggedInFlag()) {
            
            // Fodatae the payment method to be added to the current account
           if (structKeyExists(data, "selectedPaymentMethod")){
                var accountPaymentMethod = getHibachiScope().getService("AccountService").getAccountPaymentMethod( data.selectedPaymentMethod );
            }else{
                var accountPaymentMethod = getHibachiScope().getService("AccountService").newAccountPaymentMethod(  );	
                accountPaymentMethod.setAccount( getHibachiScope().getAccount() );
            }
            
            accountPaymentMethod = getAccountService().saveAccountPaymentMethod( accountPaymentMethod, arguments.data );
            
            getHibachiScope().addActionResult( "public:account.addAccountPaymentMethod", accountPaymentMethod.hasErrors() );
            data['ajaxResponse']['errors'] = accountPaymentMethod.getErrors();
            // If there were no errors then we can clear out the
            
        } else {
            
            getHibachiScope().addActionResult( "public:account.addAccountPaymentMethod", true );
                
        }
        
    }
    
    /** 
     * @http-context guestAccount
     * @description Logs in a user with a guest account 
     * @http-return <b>(200)</b> Successfully Deleted or <b>(400)</b> Bad or Missing Input Data
     * @ProcessMethod Account_Create
     */
    public void function guestAccount(required any data) {
        param name="arguments.data.createAuthenticationFlag" default="0";
        
        var account = getAccountService().processAccount( getHibachiScope().getAccount(), arguments.data, 'create');
        
        if( !account.hasErrors() ) {
            if( !isNull(getHibachiScope().getCart().getAccount())) {
                var newCart = getService("OrderService").duplicateOrderWithNewAccount( getHibachiScope().getCart(), account );
                getHibachiScope().getSession().setOrder( newCart );
            } else {
                getHibachiScope().getCart().setAccount( account );    
            }
            getHibachiScope().addActionResult( "public:cart.guestCheckout", false );
        } else {
            getHibachiScope().addActionResult( "public:cart.guestCheckout", true ); 
        }
        
    }
    
    /** 
     * @http-context guestAccountCreatePassword
     * @description Save Guest Account
     * @http-return <b>(200)</b> Successfully Created Password or <b>(400)</b> Bad or Missing Input Data
     * @ProcessMethod Account_CreatePassword
     */
    public void function guestAccountCreatePassword( required struct data ) {
        param name="arguments.data.orderID" default="";
        param name="arguments.data.accountID" default="";

        var order = getService("OrderService").getOrder( arguments.data.orderID );
        
        // verify that the orderID passed in was in fact the lastPlacedOrderID from the session, that the order & account match up, and that the account is in fact a guest account right now
        if(!isNull(order) && arguments.data.orderID == getHibachiScope().getSession().getLastPlacedOrderID() && order.getAccount().getAccountID() == arguments.data.accountID && order.getAccount().getGuestAccountFlag()) {
            
            var account = getAccountService().processAccount( order.getAccount(), arguments.data, "createPassword" );
            getHibachiScope().addActionResult( "public:cart.guestAccountCreatePassword", account.hasErrors() );
            return account;
        } else {
            
            getHibachiScope().addActionResult( "public:cart.guestAccountCreatePassword", true );
        }
        
    }
    /** 
     * @http-context updateSubscriptionUsage
     * @description Subscription Usage - Update
     * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     @ProcessMethod SubscriptionUsage_Save
     */
    public void function updateSubscriptionUsage() {
        param name="data.subscriptionUsageID" default="";
        
        var subscriptionUsage = getSubscriptionService().getSubscriptionUsage( data.subscriptionUsageID );
        
        if(!isNull(subscriptionUsage) && subscriptionUsage.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID() ) {
            var subscriptionUsage = getSubscriptionService().saveSubscriptionUsage( subscriptionUsage, arguments.data );
            if(subscriptionUsage.hasErrors()){
                addErrors(arguments.data,subscriptionUsage.getErrors());
            }
            getHibachiScope().addActionResult( "public:account.updateSubscriptionUsage", subscriptionUsage.hasErrors() );
        } else {
            getHibachiScope().addActionResult( "public:account.updateSubscriptionUsage", true );
        }
        
    }
    
    /** 
     * @http-context renewSubscriptionUsage
     * @description Subscription Usage - Renew
     * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     @ProcessMethod SubscriptionUsage_Renew
     */
    public void function renewSubscriptionUsage() {
        param name="data.subscriptionUsageID" default="";
        
        var subscriptionUsage = getSubscriptionService().getSubscriptionUsage( data.subscriptionUsageID );
        
        if(!isNull(subscriptionUsage) && subscriptionUsage.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID() ) {
            var subscriptionUsage = getSubscriptionService().processSubscriptionUsage( subscriptionUsage, arguments.data, 'renew' );
            if(subscriptionUsage.hasErrors()){
                addErrors(arguments.data,subscriptionUsage.getErrors());
            }
            getHibachiScope().addActionResult( "public:account.updateSubscriptionUsage", subscriptionUsage.hasErrors() );
        } else {
            getHibachiScope().addActionResult( "public:account.updateSubscriptionUsage", true );
        }
    }
    
    /** 
     * @http-context cancelSubscriptionUsage
     * @description Subscription Usage - Cancel
     * @http-return <b>(200)</b> Successfully Cancelled or <b>(400)</b> Bad or Missing Input Data
     @ProcessMethod SubscriptionUsage_Cancel
     */
    public void function cancelSubscriptionUsage(required struct data) {
        param name="arguments.data.subscriptionUsageID" default="";
        
        var subscriptionUsage = getSubscriptionService().getSubscriptionUsage( arguments.data.subscriptionUsageID );
        
        if(!structKeyExists(arguments.data,'effectiveDateTime')){
            arguments.data.effectiveDateTime = subscriptionUsage.getExpirationDate();
        }
        
        if(!isNull(subscriptionUsage) && subscriptionUsage.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID() ) {
            var subscriptionUsage = getSubscriptionService().processSubscriptionUsage( subscriptionUsage, arguments.data, 'cancel' );
            if(subscriptionUsage.hasErrors()){
                addErrors(arguments.data,subscriptionUsage.getErrors());
            }
            getHibachiScope().addActionResult( "public:account.cancelSubscriptionUsage", subscriptionUsage.hasErrors() );
        } else {
            getHibachiScope().addActionResult( "public:account.cancelSubscriptionUsage", true );
        }
    }
    
    /** exposes the cart and account */
    public void function getCartData(any data) {
        if(!structKeyExists(arguments.data,'cartDataOptions') || !len(arguments.data['cartDataOptions'])){
            arguments.data['cartDataOptions']='full';
        }
        
        var updateOrderAmounts = structKeyExists( arguments.data, 'updateOrderAmounts' ) && arguments.data.updateOrderAmounts;
    
        arguments.data.ajaxResponse = {'cart':getHibachiScope().getCartData(cartDataOptions=arguments.data['cartDataOptions'], updateOrderAmounts = updateOrderAmounts)};
    }
    
    public void function getAccountData(any data) {
        arguments.data.ajaxResponse = {'account':getHibachiScope().getAccountData()};
    }
    
    /** 
     * @http-context duplicateOrder
     * @description Duplicate - Order
     * @http-return <b>(200)</b> Successfully Created Duplicate Order or <b>(400)</b> Bad or Missing Input Data
     @ProcessMethod Order_DuplicateOrder
     */
    public void function duplicateOrder() {
        param name="arguments.data.orderID" default="";
        param name="arguments.data.setAsCartFlag" default="0";
        
        var order = getService("OrderService").getOrder( arguments.data.orderID );
        if(!isNull(order) && order.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID()) {
            
            var data = {
                saveNewFlag=true, 
                copyPersonalDataFlag=true
            };
            
            var duplicateOrder = getService("OrderService").processOrder(order,data,"duplicateOrder" );
            
            if(isBoolean(arguments.data.setAsCartFlag) && arguments.data.setAsCartFlag) {
                getHibachiScope().getSession().setOrder( duplicateOrder );
            }
            
            //create new token with cart information
            if( getHibachiScope().getLoggedInFlag()  && !isNull(getHibachiScope().getAccount()) && trim( getHibachiScope().getAccount().getAccountID()) != "")  {
                arguments.data.ajaxResponse['token'] = getService('HibachiJWTService').createToken();
            }
            
            getHibachiScope().addActionResult( "public:account.duplicateOrder", false );
        } else {
            getHibachiScope().addActionResult( "public:account.duplicateOrder", true );
        }
    }
    
    /** 
     * @http-context updateOrder
     * @description  Update Order Data
     * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     @ProcessMethod Order_ForceItemQuantityUpdate
     */
    public void function updateOrder( required struct data ) {

        var cart = getService("OrderService").saveOrder( getHibachiScope().cart(), arguments.data );
        
        // Insure that all items in the cart are within their max constraint
        if(!cart.hasItemsQuantityWithinMaxOrderQuantity()) {
            cart = getService("OrderService").processOrder(cart, 'forceItemQuantityUpdate');
        }
        
        getHibachiScope().addActionResult( "public:cart.update", cart.hasErrors() );
    }
    
    /** 
     * @http-context clearOrder
     * @description  Clear the order data
     * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     @ProcessMethod Order_Clear
     */
    public void function clearOrder( required struct data ) {
        var cart = getService("OrderService").processOrder( getHibachiScope().cart(), arguments.data, 'clear');
        
        if( !cart.hasErrors() ) {
            //create new session with blank orderid
            if( getHibachiScope().getLoggedInFlag()  && !isNull(getHibachiScope().getAccount()) && !this.getHibachiScope().hibachiIsEmpty( getHibachiScope().getAccount().getAccountID() ) ) {
                arguments.data.ajaxResponse['token'] = getService('HibachiJWTService').createToken(clearOrder = true);
            }

        }
        
        getHibachiScope().addActionResult( "public:cart.clear", cart.hasErrors() );
    }
    
    /** 
     * @http-context changeOrder
     * @description Change Order
     * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     */
    public void function changeOrder( required struct data ){
        param name="arguments.data.orderID" default="";
        
        var order = getService("OrderService").getOrder( arguments.data.orderID );
        if(!isNull(order) && order.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID()) {
            getHibachiScope().getSession().setOrder( order );
            getHibachiScope().addActionResult( "public:cart.change", false );
        } else {
            getHibachiScope().addActionResult( "public:cart.change", true );
        }
    }
    
    /** 
     * @http-context deleteOrder
     * @description Delete an Order
     * @http-return <b>(200)</b> Successfully Deleted or <b>(400)</b> Bad or Missing Input Data
     @ProcessMethod Order_Delete
     */
    public void function deleteOrder( required struct data ) {
        param name="arguments.data.orderID" default="";
        
        var order = getService("OrderService").getOrder( arguments.data.orderID );
        if(!isNull(order) && order.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID()) {
            var deleteOk = getService("OrderService").deleteOrder(order);
            getHibachiScope().addActionResult( "public:cart.delete", !deleteOK );
        } else {
            getHibachiScope().addActionResult( "public:cart.delete", true );
        }
    }
    
    /**
     * Will add multiple orderItems at once given a list of skuIDs or skuCodes.
     */
    public void function addOrderItems(required any data){
    	param name="data.skuIds" default="";
    	param name="data.skuCodes" default="";
    	param name="data.quantities" default="";
    	
    	//add skuids
		var index = 1;
		var hasSkuCodes = false;
		
		//get the quantities being added
		if (structKeyExists(data, "quantities") && len(data.quantities)){
			var quantities = listToArray(data.quantities);
		}
		
		//get the skus being added
		if (structKeyExists(data, "skuIds") && len(data.skuIds)){
			var skus = listToArray(data.skuIds);
		}
		
		//get the skuCodes if they exist.
		if (structKeyExists(data, "skuCodes") && len(data.skuCodes)){
			var skus = listToArray(data.skuCodes);
			hasSkuCodes = true;
		}
		
		//if we have both skus and quantities, add them.
		if (!isNull(skus) && !isNull(quantities) && arrayLen(skus) && arrayLen(quantities)){
			if (arrayLen(skus) == arrayLen(quantities)){
				//we have a quantity fo each sku.
				for (var sku in skus){
					//send that sku and that quantity.
					if (hasSkuCodes == true){
						data["skuCode"]=sku; 
					}else{
						data["skuID"]=sku; 	
					}
	    			
	    			data["quantity"]=quantities[index];
	    			addOrderItem(data=data);
	    			index++;
	    		}
			}
		
		//If they did not pass in quantities, but we have skus, assume 1 for each quantity.
		}else if(!isNull(skus)){
    		for (var sku in skus){
    			if (hasSkuCodes == true){
					data["skuCode"]=sku; 
				}else{
					data["skuID"]=sku; 	
				}
    			data["quantity"]=1;
    			addOrderItem(data=data);
    		}
		}
    }
    
    /** 
     * @http-context addOrderItem
     * @description Add Order Item to an Order
     * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     * @ProcessMethod Order_addOrderItem
     */
    public any function addOrderItem(required any data) {
        // Setup the frontend defaults
        param name="data.preProcessDisplayedFlag" default="true";
        param name="data.saveShippingAccountAddressFlag" default="false";
        
        var cart = getHibachiScope().cart();

        // Check to see if we can attach the current account to this order, required to apply price group details
        if( isNull(cart.getAccount()) && getHibachiScope().getLoggedInFlag() ) {
            cart.setAccount( getHibachiScope().getAccount() );
        }
        
        cart = getService("OrderService").processOrder( cart, arguments.data, 'addOrderItem');
        
        getHibachiScope().addActionResult( "public:cart.addOrderItem", cart.hasErrors() );
        
        if(!cart.hasErrors()) {
            // If the cart doesn't have errors then clear the process object
            cart.clearProcessObject("addOrderItem");
            
            // Also make sure that this cart gets set in the session as the order
            getHibachiScope().getSession().setOrder( cart );
            
            // Make sure that the session is persisted
            getHibachiSessionService().persistSession(true);
            
        }else{
            addErrors(data, cart.getProcessObject("addOrderItem").getErrors());
            addErrors(data, cart.getErrors());
        }
        
        return cart;
    }
    
    /* @http-context updateOrderNotes
     * @description Set shipping instructions for order
     * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     */
    public void function updateOrderNotes(required any data) {
        param name="arguments.data.orderNotes" default="";
        var cart = getHibachiScope().getCart();
        cart.setOrderNotes(arguments.data.orderNotes);
        getHibachiScope().addActionResult( "public:cart.updateOrderNotes", cart.hasErrors() );
    }
    
    /** 
     * @http-context updateOrderItemQuantity
     * @description Update Order Item on an Order
     * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     @ProcessMethod Order_Save
     */
    public void function updateOrderItemQuantity(required any data) {
        
        var cart = getHibachiScope().cart();

        // Check to see if we can attach the current account to this order, required to apply price group details
        if( isNull(cart.getAccount()) && getHibachiScope().getLoggedInFlag() ) {
            cart.setAccount( getHibachiScope().getAccount() );
        }
        
        if (structKeyExists(data, "orderItem") && structKeyExists(data.orderItem, "orderItemID") && structKeyExists(data.orderItem, "quantity")){
            for (var orderItem in cart.getOrderItems()){
                if (orderItem.getOrderItemID() == data.orderItem.orderItemID){
                    var oldQuantity = orderItem.getQuantity();
                    orderItem.setQuantity(data.orderItem.quantity);
                    getService("HibachiValidationService").validate(cart,'save');
                    if(cart.hasErrors()){
                        orderItem.setQuantity(oldQuantity);
                        orderItem.clearVariablesKey('extendedPrice');
                    }
                }
            }
		}else if (structKeyExists(data, "orderItem") && structKeyExists(data.orderItem, "sku") && structKeyExists(data.orderItem.sku, "skuID") && structKeyExists(data.orderItem, "qty") ){
            for (var orderItem in cart.getOrderItems()){
                if (orderItem.getSku().getSkuID() == data.orderItem.sku.skuID){
                    var oldQuantity = orderItem.getQuantity();
                    orderItem.setQuantity(data.orderItem.qty);
                    
                    getService("HibachiValidationService").validate(cart,'save');
                    if(cart.hasErrors()){
                        orderItem.setQuantity(oldQuantity);
                        orderItem.clearVariablesKey('extendedPrice');
                    }
                }
            }
        }
        
        
        if(!cart.hasErrors()) {
            
            //Persist the quantity change
            getService("OrderService").saveOrder(cart);
            
            // Insure that all items in the cart are within their max constraint
 	    	if(!cart.hasItemsQuantityWithinMaxOrderQuantity()) {
	 	        cart = getService("OrderService").processOrder(cart, 'forceItemQuantityUpdate');
	 	        if(!cart.hasErrors()) {
                  getService("OrderService").saveOrder(cart);
                }
	 	    } 
	 	    
            // Also make sure that this cart gets set in the session as the order
            getHibachiScope().getSession().setOrder( cart );
            
            // Make sure that the session is persisted
            getHibachiSessionService().persistSession();
            
        } else {
            addErrors(data, getHibachiScope().getCart().getErrors());
        }
        
        getHibachiScope().addActionResult( "public:cart.updateOrderItem", cart.hasErrors() );
    }
    /** 
     * @http-context removeOrderItem
     * @description Remove Order Item from an Order
     * @http-return <b>(200)</b> Successfully Removed or <b>(400)</b> Bad or Missing Input Data
     @ProcessMethod Order_RemoveOrderItem
     */
    public void function removeOrderItem(required any data) {
        var cart = getService("OrderService").processOrder( getHibachiScope().cart(), arguments.data, 'removeOrderItem');
        if(!arraylen(cart.getOrderItems())){
            clearOrder(arguments.data);
        }
        getHibachiScope().addActionResult( "public:cart.removeOrderItem", cart.hasErrors() );
    }
    
    /** 
     * @http-context updateOrderFulfillment
     * @description Update Order Fulfillment 
      * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
      @ProcessMethod Order_UpdateOrderFulfillment
     */
    public void function updateOrderFulfillment(required any data) {
        param name="orderID" default="#getHibachiScope().getCart().getOrderID()#";
        var cart = getService("OrderService").processOrder( getHibachiScope().cart(), arguments.data, 'updateOrderFulfillment');
        
        getHibachiScope().addActionResult( "public:cart.updateOrderFulfillment", cart.hasErrors() );
    }
    
    /**
     * Method To change fulfillment method on existing order items
     * @param - orderItemIDList
     * @param - fulfillmentMethodID
     * */
    public void function changeOrderFulfillment(required any data) {
        param name="data.orderItemIDList";
        param name="data.fulfillmentMethodID";

        var cart = getHibachiScope().getCart();

        var orderItemIDList = ListToArray(arguments.data.orderItemIDList);

        var existingOrderFulfillment = "";

        //check if fulfillment method already exists on order
        var allOrderFulfillments = cart.getOrderFulfillments();
        for(var orderFulfillment in allOrderFulfillments) {

            //get existing fulfillment method based on fulfillment method ID
            if(orderFulfillment.getFulfillmentMethod().getFulfillmentMethodID() == arguments.data.fulfillmentMethodID ) {
                existingOrderFulfillment = orderFulfillment;
            }
        }

        var orderItems = cart.getOrderItems();
        for(var orderItem in orderItems) {

            //Get List of eligible methods
            var eligibleFulfillmentMethods = listToArray(orderItem.getSku().setting("skuEligibleFulfillmentMethods"));

            //Check if item id exists, existing fulfillment method is different than the one we're passing, and new fulfillment should be eligible
            if( ArrayContains(orderItemIDList, orderItem.getOrderItemID()) && orderItem.getOrderFulfillment().getFulfillmentMethod().getFulfillmentMethodID() != arguments.data.fulfillmentMethodID &&  ArrayContains(eligibleFulfillmentMethods, arguments.data.fulfillmentMethodID) ) {

                //Remove existing method
                orderItem.removeOrderFulfillment(orderItem.getOrderFulfillment());

                if( !this.getHibachiScope().hibachiIsEmpty(existingOrderFulfillment) ) {
                    orderItem.setOrderFulfillment( existingOrderFulfillment );
                } else {
                    //get fulfillment method
                    var fulfillmentMethod = getService('fulfillmentService').getFulfillmentMethod( arguments.data.fulfillmentMethodID );

                    //create new method
                    var orderFulfillment = getService("OrderService").newOrderFulfillment();
                    orderFulfillment.setOrder( cart );
                    orderFulfillment.setFulfillmentMethod( fulfillmentMethod );
    				orderFulfillment.setCurrencyCode( cart.getCurrencyCode() );

                    orderItem.setOrderFulfillment( orderFulfillment );
                }
            }
        }

        getService("OrderService").saveOrder(getHibachiScope().getCart());

        getHibachiScope().addActionResult( "public:cart.changeOrderFulfillment", cart.hasErrors() );
    }



    /** 
     * @http-context updateOrderFulfillmentAddressZone
     * @description Update Order Fulfillment Address Zone
     * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     * @ProcessMethod Order_UpdateOrderFulfillmentAddressZone
     */
    public any function updateOrderFulfillmentAddressZone(required any data) {
        
        var orderFulfillments = getHibachiScope().cart().getOrderFulfillments();
        //Find a shipping fulfillment.    
        for (var of in orderFulfillments){
            if (of.getFulfillmentMethodType() == "shipping"){
                var orderFulfillment = of; break;
            }
        }  
        
        if (structKeyExists(data, "addressZoneCode")){
            var addressZone = getService("AddressService").getAddressZoneByAddressZoneCode(data.addressZoneCode);
        }     
        
        if (!isNull(orderFulfillment) && !isNull(addressZone)){
            orderFulfillment.setAddressZone(addressZone);
            orderFulfillment = getService("OrderService").saveOrderFulfillment(orderFulfillment);
            getService("ShippingService").updateOrderFulfillmentShippingMethodOptions(orderFulfillment);
            getHibachiScope().addActionResult( "public:cart.updateOrderFulfillmentAddressZone", false);
        } else {  
			getHibachiScope().addActionResult( "public:cart.updateOrderFulfillmentAddressZone", true);
        }
    }

    /** 
     * @http-context addPromotionCode
     * @description Add Promotion Code
     * @http-return <b>(200)</b> Successfully Updated or <b>(400)</b> Bad or Missing Input Data
     @ProcessMethod Order_addPromotionCode
     */
    public void function addPromotionCode(required any data) {
        var cart = getService("OrderService").processOrder( getHibachiScope().cart(), arguments.data, 'addPromotionCode');
        
        getHibachiScope().addActionResult( "public:cart.addPromotionCode", cart.hasErrors() );
        
        if(!cart.hasErrors()) {
            cart.clearProcessObject("addPromotionCode");
        }else{
            var processObject = cart.getProcessObject("AddPromotionCode");
            if(processObject.hasErrors()){
                addErrors(data, cart.getProcessObject("AddPromotionCode").getErrors());
            }else{
                addErrors(data,cart.getErrors());
            }
        }
    }
    
    /** 
     * @http-context removePromotionCode
     * @description Remove Promotion Code
     @ProcessMethod Order_RemovePromotionCode
     */
    public void function removePromotionCode(required any data) {
        var cart = getService("OrderService").processOrder( getHibachiScope().cart(), arguments.data, 'removePromotionCode');
        
        getHibachiScope().addActionResult( "public:cart.removePromotionCode", cart.hasErrors() );
    }

    /** 
     * @http-context addGiftCardOrderPayment
     * @description Add Gift Card to Order
     @ProcessMethod Order_AddOrderPayment
     */
    public void function addGiftCardOrderPayment(required any data) {
        param name="data.newOrderPayment.paymentMethod.paymentMethodID" default="50d8cd61009931554764385482347f3a";
        param name="data.newOrderPayment.redeemGiftCardToAccount" default=true;
        param name="data.copyFromType" default="";
        param name="data.newOrderPayment.requireBillingAddress" default="0";
        var addOrderPayment = addOrderPayment(data, true);
        if(addOrderPayment.hasErrors()){
          addErrors(data, addOrderPayment.getProcessObject('addOrderPayment').getErrors());
        }
        getHibachiScope().addActionResult('public:cart.addGiftCardOrderPayment', addOrderPayment.hasErrors());
    }
    
    /** 
     * @http-context addOrderPayment
     * @description Add Order Payment
     @ProcessMethod Order_AddOrderPayment
     */
    public any function addOrderPayment(required any data, boolean giftCard = false) {
        param name = "data.newOrderPayment" default = "#structNew()#";
        param name = "data.newOrderPayment.orderPaymentID" default = "";
        param name = "data.newOrderPayment.requireBillingAddress" default = "1";
        param name = "data.newOrderPayment.saveShippingAsBilling" default = "0";
        param name = "data.accountAddressID" default = "";
        param name = "data.accountPaymentMethodID" default = "";
        param name = "data.newOrderPayment.paymentMethod.paymentMethodID" default = "444df303dedc6dab69dd7ebcc9b8036a";
        param name = "data.orderID" default = "";

        //Make sure orderID passed in belongs to logged in account
        var accountID = getHibachiScope().getAccount().getAccountID();
        if (len(data.orderID)) {
            if (isNull(accountID) || !len(accountID) || accountID != getOrderService().getOrder(data.orderID).getAccount().getAccountID()) {
                data.orderID = '';
            }
        }
        
        if (len(data.orderID)) {
            var order = getOrderService().getOrder(data.orderID);
        }
        else {
            var order = getHibachiScope().getCart();
        }

        if (structKeyExists(data, 'accountAddressID') && len(data.accountAddressID)) {
            var paymentMethod = getPaymentService().getPaymentMethod(data.newOrderPayment.paymentMethod.paymentMethodID);
            if(!isNull(paymentMethod) && paymentMethod.getPaymentMethodType() == 'termPayment'){
                data.newOrderPayment.termPaymentAccount.accountID = getHibachiScope().getAccount().getAccountID();
            }
            var accountAddress = getService('addressService').getAccountAddress(data.accountAddressID);
            var addOrderPayment = getService('OrderService').processOrder(order, arguments.data, 'addOrderPayment');
            for (var payment in addOrderPayment.getOrderPayments()) {
                addErrors(data, payment.getErrors());
            }
            getHibachiScope().addActionResult("public:cart.addOrderPayment", addOrderPayment.hasErrors());
            return addOrderPayment;
        }

        if (structKeyExists(data.newOrderPayment, 'billingAddress') && structKeyExists(data.newOrderPayment.billingAddress, 'accountAddressID')) {
            data.accountAddressID = data.newOrderPayment.billingAddress.accountAddressID;
        }


        // Make sure that someone isn't trying to pass in another users orderPaymentID
        if (len(data.newOrderPayment.orderPaymentID)) {
            var orderPayment = getService("OrderService").getOrderPayment(data.newOrderPayment.orderPaymentID);
            if (orderPayment.getOrder().getOrderID() != getHibachiScope().cart().getOrderID()) {
                data.newOrderPayment.orderPaymentID = "";
            }
        }

        
        if (data.newOrderPayment.requireBillingAddress || data.newOrderPayment.saveShippingAsBilling) {
            
            //If we have saveShippingAsBilling
             if( structKeyExists(data.newOrderPayment,'saveShippingAsBilling') && data.newOrderPayment.saveShippingAsBilling ) {

                 var addressData = {
                    address=order.getShippingAddress()
                };

                 var newBillingAddress = this.addBillingAddress(addressData, "billing");

             } else {
                // Only create a new billing address here if its not being created later using the account payment method.
                if (!structKeyExists(data.newOrderPayment, 'billingAddress') 
                    && (!structKeyExists(data, "accountPaymentMethodID") 
                    && len(data.accountPaymentMethodID))) {
    
                    var orderPayment = getPaymentService().newOrderPayment();
                    orderPayment.populate(data.newOrderPayment);
                    orderPayment.setOrder(getHibachiScope().getCart());
                    if (orderPayment.getPaymentMethod().getPaymentMethodType() == 'termPayment') {
                        orderPayment.setTermPaymentAccount(getHibachiScope().getAccount());
                    }
                    //Add billing address error
                    orderPayment.addError('addBillingAddress', getHibachiScope().rbKey('validate.processOrder_addOrderPayment.billingAddress'));
                    //Validate to get all errors
                    orderPayment.validate('save');
    
                    this.addErrors(data, orderPayment.getErrors());
    
                    getHibachiScope().addActionResult("public:cart.addOrderPayment", true);
                    return;
                }
            }
            
            if (structKeyExists(data, "accountPaymentMethodID") && len(data.accountPaymentMethodID)){
                //use this billing information
                var paymentMethod = getService('accountService').getAccountPaymentMethod(data.accountPaymentMethodID);
                if(!isNull(paymentMethod)){
                    if(!isNull(paymentMethod.getBillingAccountAddress())){
                        var address = paymentMethod.getBillingAccountAddress().getAccountAddressID();
                        var newBillingAddress = this.addBillingAddressUsingAccountAddress({accountAddressID:  paymentMethod.getBillingAccountAddress().getAccountAddressID()});
                    }else if(!isNull(paymentMethod.getBillingAddress())){
                        var address= paymentMethod.getBillingAddress() //pass the object rather than ID
                        var newBillingAddress = this.addBillingAddress({address:  address});
                    }else{
                        getHibachiScope().addActionResult("public:cart.addOrderPayment", true);
                        return;
                    }
                  
                }else{
                    getHibachiScope().addActionResult("public:cart.addOrderPayment", true);
                    return;
                }
            }
        }

        if (!isNull(newBillingAddress) && newBillingAddress.hasErrors()) {
            if(!isNull(paymentMethod)){
                paymentMethod.addError('addOrderPayment',getHibachiScope().rbKey('validate.processOrder_AddOrderPayment.invalidBillingAddress'),true);
                this.addErrors(arguments.data, paymentMethod.getErrors());
                getDAO('AccountDAO').setAccountPaymentMethodInactive(paymentMethod.getAccountPaymentMethodID());
            }else{
                this.addErrors(arguments.data, newBillingAddress.getErrors());
            }
            return;
        }

        var addOrderPayment = getService('OrderService').processOrder(order, arguments.data, 'addOrderPayment');

        if (!giftCard) {
            for (var payment in addOrderPayment.getOrderPayments()) {
                addErrors(data, payment.getErrors());
            }
            getHibachiScope().addActionResult("public:cart.addOrderPayment", addOrderPayment.hasErrors());
        }

        return addOrderPayment;
    }


	/**
     Adds an order payment and then calls place order.
    */
    public void function addOrderPaymentAndPlaceOrder(required any data) {
        addOrderPayment(arguments.data);
        if (!getHibachiScope().cart().hasErrors()){
            placeOrder(arguments.data);
        }
        
    }

    /** 
     * @http-context removeOrderPayment
     * @description Remove Order Payment 
     */
    public void function removeOrderPayment(required any data) {
        var cart = getHibachiScope().getCart();
        cart = getService("OrderService").processOrder( cart, arguments.data, 'removeOrderPayment');
        
        getHibachiScope().addActionResult( "public:cart.removeOrderPayment", cart.hasErrors() );
    }
    
    /** 
     * @http-context placeOrder
     * @description Place Order
     @ProcessMethod Order_PlaceOrder
     */
    public void function placeOrder(required any data) {

        // Insure that all items in the cart are within their max constraint
        if(!getHibachiScope().cart().hasItemsQuantityWithinMaxOrderQuantity()) {
            getService("OrderService").processOrder(getHibachiScope().cart(), 'forceItemQuantityUpdate');
            getHibachiScope().addActionResult( "public:cart.placeOrder", true );
        } else {
            // Setup newOrderPayment requirements
            if(structKeyExists(data, "newOrderPayment")) {
                param name="data.newOrderPayment.orderPaymentID" default="";
                param name="data.accountAddressID" default="";
                param name="data.accountPaymentMethodID" default="";

                // Make sure that someone isn't trying to pass in another users orderPaymentID
                if(len(data.newOrderPayment.orderPaymentID)) {
                    var orderPayment = getService("OrderService").getOrderPayment(data.newOrderPayment.orderPaymentID);
                    if(orderPayment.getOrder().getOrderID() != getHibachiScope().cart().getOrderID()) {
                        data.newOrderPayment.orderPaymentID = "";
                    }
                }
                
                data.newOrderPayment.order.orderID = getHibachiScope().cart().getOrderID();
                data.newOrderPayment.orderPaymentType.typeID = '444df2f0fed139ff94191de8fcd1f61b';
            }
            
            var order = getService("OrderService").processOrder( getHibachiScope().cart(), arguments.data, 'placeOrder');

            getHibachiScope().addActionResult( "public:cart.placeOrder", order.hasErrors() );
            
            if(!order.hasErrors()) {
                getHibachiScope().setSessionValue('confirmationOrderID', order.getOrderID());
                getHibachiScope().getSession().setLastPlacedOrderID( order.getOrderID() );
                
                //create new session with blank orderid
                arguments.data.ajaxResponse['token'] = getService('HibachiJWTService').createToken(clearOrder = true);
                
            } else {
              this.addErrors(data,order.getErrors());
            }
            
            if(getHibachiScope().getAccount().getGuestAccountFlag()){
                getHibachiScope().getSession().removeAccount();
            }
        }

    
    }
    
    /** 
     * @http-context addProductReview
     *  @description Add Product Review
     @ProcessMethod Order_addProductReview
     */
    public void function addProductReview(required any data) {
        param name="data.newProductReview.product.productID" default="";
        
        var product = getProductService().getProduct( data.newProductReview.product.productID );
        
        if( !isNull(product) ) {
            product = getProductService().processProduct( product, arguments.data, 'addProductReview');
            
            getHibachiScope().addActionResult( "public:product.addProductReview", product.hasErrors() );
            
            if(!product.hasErrors()) {
                product.clearProcessObject("addProductReview");
            }
        } else {
            getHibachiScope().addActionResult( "public:product.addProductReview", true );
        }
    }
    
    public any function addErrors( required struct data , errors){

        if (!structKeyExists(arguments.data, "ajaxResponse")){
            arguments.data["ajaxResponse"] = {};
        }
        
        if (!structKeyExists(arguments.data.ajaxResponse, "errors")){
            arguments.data.ajaxResponse["errors"] = {};
        }
        arguments.data.ajaxResponse["errors"] = errors;
    }
    
    public any function addMessages( required struct data , messages){

        if (!structKeyExists(arguments.data, "ajaxResponse")){
            arguments.data["ajaxResponse"] = {};
        }
        
        if (!structKeyExists(arguments.data.ajaxResponse, "messages")){
            arguments.data.ajaxResponse["messages"] = {};
        }
        arguments.data.ajaxResponse["messages"] = messages;
    } 
    
    /** returns a list of state code options either for us (default) or by the passed in countryCode */
    public void function getStateCodeOptionsByCountryCode( required struct data ) {
        param name="data.countryCode" type="string" default="US";
        var cacheKey = "PublicService.getStateCodeOptionsByCountryCode#arguments.data.countryCode#";
        var stateCodeOptions = [];
        if(getHibachiCacheService().hasCachedValue(cacheKey)){
        	stateCodeOptions = getHibachiCacheService().getCachedValue(cacheKey);
        }else{
        	var country = getAddressService().getCountry(data.countryCode);
        	stateCodeOptions = country.getStateCodeOptions();
        	getHibachiCacheService().setCachedValue(cacheKey,stateCodeOptions);
        }
         arguments.data.ajaxResponse["stateCodeOptions"] = stateCodeOptions;
        //get the address options.
        if (!isNull(arguments.data.countryCode)){
          getAddressOptionsByCountryCode(arguments.data);
        }
    }
    
    public void function getStateCodeOptionsByAddressZoneCode( required struct data ) {
        if(!structKeyExists(data,addressZoneCode) || data.addressZoneCode == 'undefined'){
            data.addressZoneCode = 'US';
        }
        var addressZoneLocations = getAddressService().getAddressZoneByAddressZoneCode('US').getAddressZoneLocations();
        cacheKey = "PublicService.getStateCodeOptionsByAddressZoneCode#arguments.data.addressZoneCode#";
        stateCodeOptions = "";
        if(getHibachiCacheService().hasCachedValue(cacheKey)){
            stateCodeOptions = getHibachiCacheService().getCachedValue(cacheKey);
        }else{
            for(var addressZoneLocation in addressZoneLocations){
                stateCodeOptions = listAppend(stateCodeOptions,addressZoneLocation.getStateCode());
            }
            getHibachiCacheService().setCachedValue(cacheKey,stateCodeOptions);
        }
          arguments.data.ajaxResponse["stateCodeOptions"] = listSort(stateCodeOptions,'text');
    }
    
    /** Given a country - this returns all of the address options for that country */
    public void function getAddressOptionsByCountryCode( required data ) {
        param name="data.countryCode" type="string" default="US";
        
        var addressOptions = {};
        var cacheKey = 'PublicService.getAddressOptionsByCountryCode#arguments.data.countryCode#';
        if(getHibachiCacheService().hasCachedValue(cacheKey)){
          addressOptions = getHibachiCacheService().getCachedValue(cacheKey);
        }else{
          var country = getAddressService().getCountry(data.countryCode);
          addressOptions = {
            
              'streetAddressLabel' =  country.getStreetAddressLabel(),
              'streetAddressShowFlag' =  country.getStreetAddressShowFlag(),
              'streetAddressRequiredFlag' =  country.getStreetAddressRequiredFlag(),
              
              'street2AddressLabel' =  country.getStreet2AddressLabel(),
              'street2AddressShowFlag' =  country.getStreet2AddressShowFlag(),
              'street2AddressRequiredFlag' =  country.getStreet2AddressRequiredFlag(),
              
              'cityLabel' =  country.getCityLabel(),
              'cityShowFlag' =  country.getCityShowFlag(),
              'cityRequiredFlag' =  country.getCityRequiredFlag(),
              
              'localityLabel' =  country.getLocalityLabel(),
              'localityShowFlag' =  country.getLocalityShowFlag(),
              'localityRequiredFlag' =  country.getLocalityRequiredFlag(),
              
              'stateCodeLabel' =  country.getStateCodeLabel(),
              'stateCodeShowFlag' =  country.getStateCodeShowFlag(),
              'stateCodeRequiredFlag' =  country.getStateCodeRequiredFlag(),
              
              'postalCodeLabel' =  country.getPostalCodeLabel(),
              'postalCodeShowFlag' =  country.getPostalCodeShowFlag(),
              'postalCodeRequiredFlag' =  country.getPostalCodeRequiredFlag()
              
          };
          getHibachiCacheService().setCachedValue(cacheKey,addressOptions);
        }
        arguments.data.ajaxResponse["addressOptions"] = addressOptions;
        
    }
    
    public void function getAccountWishlistsOptions(required struct data){
        var options = getOrderService().getAccountWishlistsOptions(getHibachiScope().getAccount().getAccountID());
        arguments.data.ajaxResponse["accountWishlistOptions"] = options;
    }
    
    /** returns the list of country code options */
     public void function getCountries( required struct data ) {
        arguments.data.ajaxResponse['countryCodeOptions'] = getService('HibachiCacheService').getOrCacheFunctionValue('PublicService.getCountries',getAddressService(),'getCountryCodeOptions');
    }
    
    /** Given a skuCode, returns the estimated shipping rates for that sku. */
    public any function getEstimatedShippingCostBySkuCode(any data){
    	if (!isNull(data.skuCode)){
    		
    		//data setup.
    		var orderFulfillment = getService("OrderService").newOrderFulfillment();
    		var orderItem = getService("OrderService").newOrderItem();
    		var sku = getService("SkuService").getSkuBySkuCode(data.skuCode);
    		
    		//set the sku so we have data for the rates.
    		orderItem.setSku(sku);
    		var shippingMethodOptions = [];
    		
    		//set the order so it doesn't stall when updating options.
    		orderFulfillment.setOrder(getHibachiScope().getCart());
    		
    		var eligibleFulfillmentMethods = listToArray(sku.setting("skuEligibleFulfillmentMethods"));
    		
    		var options = {};
    		
    		//iterate through getting the options.
    		for (var eligibleFulfillmentMethod in eligibleFulfillmentMethods){
    			//get the fulfillment methods for this item.
    			var fulfillmentMethod = getService("FulfillmentService").getFulfillmentMethod(eligibleFulfillmentMethod);
    			if (!isNull(fulfillmentMethod) &&!isNull(fulfillmentMethod.getFulfillmentMethodType()) &&  fulfillmentMethod.getFulfillmentMethodType() == "shipping"){
    				
    				//set the method so we can update with the options.
    				orderFulfillment.setFulfillmentMethod(fulfillmentMethod);
    				getService("ShippingService").updateOrderFulfillmentShippingMethodOptions(orderFulfillment);
    				if (!isNull(orderFulfillment.getShippingMethodOptions())){
    					for (var rate in orderFulfillment.getShippingMethodOptions()){
    						options['#rate.shippingMethodCode#'] = rate;
    					}
    				}
    			}
    		}
    		
    		//remove the orderfulfillment that we used to get the rates because it will disrupt other entities saving.
    		getService("OrderService").deleteOrderFulfillment(orderFulfillment);
    		arguments.data['ajaxResponse']['estimatedShippingRates'] = options;
    	}
    }
    
    public void function getSkuPriceByQuantity(required any data){
        if(isNull(arguments.data.skuID)){
            addErrors(arguments.data, [{'skuID':"Error retrieving price; skuID is required."}]);
        }
        if(isNull(arguments.data.quantity) || !isNumeric(arguments.data.quantity)){
            arguments.data.quantity = 1;
        }
        if(isNull(arguments.data.currencyCode)){
            arguments.data.currencyCode = 'USD';
        }
        
        var sku = getSkuService().getSku(arguments.data.skuID);
        arguments.data['ajaxResponse']['price'] = sku.getPriceByCurrencyCode(arguments.data.currencyCode, arguments.data.quantity);
    }
    
    public void function getAccountAddresses(required struct data){
        
        var account = getHibachiScope().getAccount();
        
        arguments.data['ajaxResponse']['accountAddresses'] = account.getAccountAddressesCollectionList().getRecords(); 
        
        if(account.hasPrimaryAddress()) {
            arguments.data['ajaxResponse']['primaryAccountAddressID'] = account.getPrimaryAddress().getAccountAddressID(); 
        }
        
        if(account.hasPrimaryBillingAddress()) {
            arguments.data['ajaxResponse']['primaryBillingAddressID'] = account.getPrimaryBillingAddress().getAccountAddressID(); 
        }
        
        if(account.hasPrimaryShippingAddress()) {
            arguments.data['ajaxResponse']['primaryShippingAddressID'] = account.getPrimaryShippingAddress().getAccountAddressID(); 
        }
    }
    
    public void function getAccountPaymentMethods(required struct data){
	
		var account = getHibachiScope().getAccount();
	
		arguments.data['ajaxResponse']['accountPaymentMethods'] = account.getAccountPaymentMethodsCollectionList().getRecords();  
		
		if(account.hasPrimaryPaymentMethod()){
            arguments.data['ajaxResponse']['primaryPaymentMethodID'] = account.getPrimaryPaymentMethod().getAccountPaymentMethodID(); 
        }
    }
    
    public void function setPrimaryPaymentMethod(required any data){
        param name="data.accountPaymentMethodID" default="";
        var hibachiScope = this.getHibachiScope();
        if( !(hibachiScope.getLoggedInFlag()) ) {
            arguments.data.ajaxResponse['error'] = hibachiScope.rbKey('validate.api.loginRequired');
            return;
        }

        var account = hibachiScope.getAccount();
        var accountPaymentMethod = this.getAccountService().getAccountPaymentMethod(arguments.data.accountPaymentMethodID);
        
        if( accountPaymentMethod.getAccount().getAccountID() != account.getAccountID() ){
            arguments.data.ajaxResponse['error'] = hibachiScope.rbKey('validate.api.doesNotBelongToUser');
            return;
        }

        account.setPrimaryPaymentMethod(accountPaymentMethod);
        account = this.getAccountService().saveAccount(account, {}, 'updatePrimaryPaymentMethod');

        this.getHibachiScope().addActionResult( "public:account.updatePrimaryPaymentMethod", account.hasErrors());
        if( account.hasErrors() ){
            this.addErrors(arguments.data, account.getErrors() );
        }
    }
    
    public any function createOrderTemplate( required struct data ) {
        param name="arguments.data.siteID" default="";
        param name="arguments.data.siteCode" default="";
        param name="arguments.data.cmsSiteID" default="";
        param name="arguments.data.frequencyTermID" default="23c6a8caa4f890196664237003fe5f75";// TermID for monthly
        param name="arguments.data.orderTemplateName" default="";
        param name="arguments.data.orderTemplateTypeID" default="";
        param name="arguments.data.orderTemplateSystemCode" default="ottSchedule";
        param name="arguments.data.scheduleOrderDayOfTheMonth" default=1;

        var hibachiScope = this.getHibachiScope();
        
        if( !(hibachiScope.getLoggedInFlag()) ) {
            arguments.data.ajaxResponse['error'] = hibachiScope.rbKey('validate.loginRequired');
            return;
        }
        
        var newOrderTemplate = this.getOrderService().newOrderTemplate();
        
        arguments.data['accountID'] = hibachiScope.getAccount().getAccountID();
        if( !(len(arguments.data.orderTemplateTypeID)) && len(arguments.data.orderTemplateSystemCode) ){
            arguments.data.orderTemplateTypeID = this.getTypeService().getTypeBySystemCode(arguments.data.orderTemplateSystemCode).getTypeID();
        }
        
        newOrderTemplate = this.getOrderService().processOrderTemplate(newOrderTemplate, arguments.data, "create");
        
        var processObject = newOrderTemplate.getProcessObject('create');
        if( processObject.hasErrors() ){
            newOrderTemplate.addErrors( processObject.getErrors() );
        }

        hibachiScope.addActionResult("public:orderTemplate.create", newOrderTemplate.hasErrors() );
        if( newOrderTemplate.hasErrors() ){
            this.addErrors(arguments.data, newOrderTemplate.getErrors());
        } else {
            arguments.data['ajaxResponse']['orderTemplate'] = newOrderTemplate.getOrderTemplateID();
        }
    }

   
	public void function getOrderTemplates(required any data){ 
        param name="arguments.data.pageRecordsShow" default=5;
        param name="arguments.data.currentPage" default=1;
        param name="arguments.data.orderTemplateID" default="";
		param name="arguments.data.orderTemplateTypeID" default="2c948084697d51bd01697d5725650006"; 
		param name="arguments.data.optionalProperties" default="";

		arguments.data['ajaxResponse']['orderTemplates'] = getOrderService().getOrderTemplatesForAccount(arguments.data); 
	}
	
	public void function getOrderTemplateItems(required any data){
        param name="arguments.data.pageRecordsShow" default=5;
        param name="arguments.data.currentPage" default=1;
        param name="arguments.data.orderTemplateID" default="";
		param name="arguments.data.orderTemplateTypeID" default="2c948084697d51bd01697d5725650006"; // defaults to - "ottSchedule", we should use system-code

		arguments.data['ajaxResponse']['orderTemplateItems'] = getOrderService().getOrderTemplateItemsForAccount(arguments.data);  
	} 
	
	
	public void function getOrderTemplateDetails(required any data){
        param name="arguments.data.pageRecordsShow" default=5;
        param name="arguments.data.currentPage" default=1;
        param name="arguments.data.orderTemplateId" default="";
		param name="arguments.data.orderTemplateTypeID" default="2c948084697d51bd01697d5725650006"; 
		param name="arguments.data.optionalProperties" type="string" default="";  //putting here for documentation purpous only
				
		arguments.data['ajaxResponse']['orderTemplate'] = getOrderService().getOrderTemplateDetailsForAccount(arguments.data);  
	}
	
	private void function setOrderTemplateAjaxResponse(required any data) {
	    
		var orderTemplateCollection = getOrderService().getOrderTemplatesCollectionForAccount(argumentCollection = arguments); 
	    orderTemplateCollection.addFilter("orderTemplateID", arguments.data.orderTemplateID); // limit to our order-template
	    var orderTemplates = orderTemplateCollection.getPageRecords(); 
 		arguments.data['ajaxResponse']['orderTemplate'] = arrayLen(orderTemplates) ? orderTemplates[1] : []; // there should be only one record;  
	}
	
	
	
	public void function updateOrderTemplateShippingAndBilling(required any data){
	    param name="arguments.data.orderTemplateID" default="";
	
     	var orderTemplate = getOrderService().getOrderTemplateAndEnforceOwnerAccount(argumentCollection = arguments);
		if( isNull(orderTemplate) ) {
			return; 
		}
		
		orderTemplate = getOrderService().processOrderTemplate(orderTemplate, arguments.data, 'updateShipping'); 
        var processObject = orderTemplate.getProcessObject('UpdateShipping');
        orderTemplate.addErrors( processObject.getErrors() );
        getHibachiScope().addActionResult( "public:updateOrderTemplateShipping", orderTemplate.hasErrors() );
        
        if(!orderTemplate.hasErrors() && !getHibachiScope().getORMHasErrors() && !processObject.hasErrors() ) {
            getHibachiScope().flushORMSession(); //flushing to make new data availble
        }
        
		orderTemplate = getOrderService().processOrderTemplate(orderTemplate, arguments.data, 'updateBilling'); 
        processObject = orderTemplate.getProcessObject('UpdateBilling');
        orderTemplate.addErrors( processObject.getErrors() );
        getHibachiScope().addActionResult( "public:updateOrderTemplateBilling", orderTemplate.hasErrors() );

        if(!orderTemplate.hasErrors() && !getHibachiScope().getORMHasErrors() && !processObject.hasErrors() ) {
    		getHibachiScope().flushORMSession(); //flushing to make new data availble
        }
        
        getService('OrderService').getOrderTemplateOrderDetails(orderTemplate);

        getOrderTemplateDetails(argumentCollection=arguments);
        addErrors(arguments.data, orderTemplate.getErrors());
        
	}


 	public void function updateOrderTemplateShipping(required any data){ 
        param name="arguments.data.orderTemplateID" default="";
	
     	var orderTemplate = getOrderService().getOrderTemplateAndEnforceOwnerAccount(argumentCollection = arguments);
		if( isNull(orderTemplate) ) {
			return; 
		}
	    
 		orderTemplate = getOrderService().processOrderTemplate(orderTemplate, arguments.data, 'updateShipping'); 
        getHibachiScope().addActionResult( "public:orderTemplate.updateShipping", orderTemplate.hasErrors() );
            
        if(!orderTemplate.hasErrors() && !getHibachiScope().getORMHasErrors()) {
            
            orderTemplate.clearProcessObject("updateShipping");
            getHibachiScope().flushORMSession(); //flushing to make new data availble
    		
    		setOrderTemplateAjaxResponse(argumentCollection = arguments);
     		
     		//if there's a new account address
     		if(StructKeyExists(arguments.data, "newAccountAddress")) {
     		    arguments.data['ajaxResponse']['newAccountAddress'] = orderTemplate.getShippingAccountAddress().getStructRepresentation();
     		}
     		
        } else {
            var processObject = orderTemplate.getProcessObject('UpdateShipping');
            if(processObject.hasErrors()){
                addErrors(arguments.data, processObject.getErrors());
            }else{
                addErrors(arguments.data, orderTemplate.getErrors());
            }
        }
 	}   
 	
 	
 	public void function updateOrderTemplateBilling(required any data){ 
        param name="arguments.data.orderTemplateID" default="";
	
     	var orderTemplate = getOrderService().getOrderTemplateAndEnforceOwnerAccount(argumentCollection = arguments);
		if( isNull(orderTemplate) ) {
			return; 
		}
	    
 		orderTemplate = getOrderService().processOrderTemplate(orderTemplate, arguments.data, 'updateBilling'); 
        getHibachiScope().addActionResult( "public:orderTemplate.updateBilling", orderTemplate.hasErrors() );
            
        if(!orderTemplate.hasErrors() && !getHibachiScope().getORMHasErrors()) {
            
            orderTemplate.clearProcessObject("updateBilling");
            getHibachiScope().flushORMSession(); //flushing to make new data availble
    		
    		setOrderTemplateAjaxResponse(argumentCollection = arguments);
     		
     		//if there's a new account address
     		if(StructKeyExists(arguments.data, "newAccountAddress")) {
     		    arguments.data['ajaxResponse']['newAccountAddress'] = orderTemplate.getBillingAccountAddress().getStructRepresentation();
     		}
     		
     			//if there's a new account address
     		if(StructKeyExists(arguments.data, "newAccountPaymentMethod")) {
     		    arguments.data['ajaxResponse']['newAccountPaymentMethod'] = orderTemplate.getAccountPaymentMethod().getStructRepresentation();
     		}
     		
        } else {
            ArrayAppend(arguments.data.messages, orderTemplate.getErrors(), true);
        }
 	}   

 	
 	public void function activateOrderTemplate(required any data) { 
        param name="arguments.data.orderTemplateID" default="";
	
     	var orderTemplate = getOrderService().getOrderTemplateAndEnforceOwnerAccount(argumentCollection = arguments);
		if( isNull(orderTemplate) ) {
			return;
		}
		
 		orderTemplate = getOrderService().processOrderTemplate(orderTemplate, arguments.data, 'activate'); 
        getHibachiScope().addActionResult( "public:orderTemplate.activate", orderTemplate.hasErrors() );
            
        if(!orderTemplate.hasErrors() && !getHibachiScope().getORMHasErrors()) {
            
            orderTemplate.clearProcessObject("activate");
            getHibachiScope().flushORMSession(); //TODO.......check?  flushing to make new data availble
            setOrderTemplateAjaxResponse(argumentCollection = arguments);
            
        } else {
            ArrayAppend(arguments.data.messages, orderTemplate.getErrors(), true);
        }
 	} 
 	

 	public void function cancelOrderTemplate(required any data) { 
        param name="arguments.data.orderTemplateID" default="";
	
     	var orderTemplate = getOrderService().getOrderTemplateAndEnforceOwnerAccount(argumentCollection = arguments);
		if( isNull(orderTemplate) ) {
			return;
		}
	    
 		orderTemplate = getOrderService().processOrderTemplate(orderTemplate, arguments.data, 'cancel'); 
        getHibachiScope().addActionResult( "public:orderTemplate.cancel", orderTemplate.hasErrors() );
        
        if(!orderTemplate.hasErrors() && !getHibachiScope().getORMHasErrors()) {
            
            orderTemplate.clearProcessObject("cancel");
            getHibachiScope().flushORMSession(); //flushing to make new data availble
    		setOrderTemplateAjaxResponse(argumentCollection = arguments);
        
        } else {
            ArrayAppend(arguments.data.messages, orderTemplate.getErrors(), true);
        }
 	}   
 	
 	
 	public any function updateOrderTemplateSchedule( required any data ){
        param name="arguments.data.orderTemplateID" default="";
	
     	var orderTemplate = getOrderService().getOrderTemplateAndEnforceOwnerAccount(argumentCollection = arguments);
		if( isNull(orderTemplate) ) {
			return;
		}
	    
 		orderTemplate = getOrderService().processOrderTemplate(orderTemplate, arguments.data, 'updateSchedule'); 
        getHibachiScope().addActionResult( "public:orderTemplate.updateSchedule", orderTemplate.hasErrors() );
            
        if(!orderTemplate.hasErrors() && !getHibachiScope().getORMHasErrors()) {
            
            orderTemplate.clearProcessObject("updateSchedule");
            getHibachiScope().flushORMSession(); //flushing to make new data availble
    		setOrderTemplateAjaxResponse(argumentCollection = arguments);
        
        } else {
            ArrayAppend(arguments.data.messages, orderTemplate.getErrors(), true);
        }
 	} 
	
	
	public any function updateOrderTemplateFrequency( required any data ){
        param name="arguments.data.orderTemplateID" default="";
	
     	var orderTemplate = getOrderService().getOrderTemplateAndEnforceOwnerAccount(argumentCollection = arguments);
		if( isNull(orderTemplate) ) {
			return;
		}
	    
 		orderTemplate = getOrderService().processOrderTemplate(orderTemplate, arguments.data, 'updateFrequency'); 
        getHibachiScope().addActionResult( "public:orderTemplate.updateFrequency", orderTemplate.hasErrors() );
            
        if(orderTemplate.hasErrors() && getHibachiScope().getORMHasErrors()) {
            ArrayAppend(arguments.data.messages, orderTemplate.getErrors(), true);
            return;
        }
        orderTemplate.clearProcessObject("updateFrequency");
     
	} 
	
	public any function getAccountGiftCards( required struct data) {
        param name="arguments.data.pageRecordsShow" default=5;
        param name="arguments.data.currentPage" default=1;
        
        var giftCardCollectionList = getGiftCardService().getGiftCardCollectionList();    
        
        giftCardCollectionList.setPageRecordsShow(arguments.data.pageRecordsShow);
		giftCardCollectionList.setCurrentPageDeclaration(arguments.data.currentPage); 
		giftCardCollectionList.addFilter('ownerAccount.accountID', getHibachiScope().getAccount().getAccountID());
	

		arguments.data['ajaxResponse']['giftCards'] = giftCardCollectionList.getPageRecords();  
	
	}
	
	public any function applyGiftCardToOrderTemplate( required struct data ){
        param name="arguments.data.orderTemplateID" default="";
	
     	var orderTemplate = getOrderService().getOrderTemplateAndEnforceOwnerAccount(argumentCollection = arguments);
		if( isNull(orderTemplate) ) {
			return;
		}
	    
 		orderTemplate = getOrderService().processOrderTemplate(orderTemplate, arguments.data, 'applyGiftCard'); 
        getHibachiScope().addActionResult( "public:orderTemplate.applyGiftCard", orderTemplate.hasErrors() );
        
        var processObject = orderTemplate.getProcessObjects()['applyGiftCard'];
        if( processObject.hasErrors() ){
            ArrayAppend(arguments.data.messages, processObject.getErrors(), true);
            return;
        }
        
        if( orderTemplate.hasErrors() ){
            ArrayAppend(arguments.data.messages, orderTemplate.getErrors(), true);
            return;
        }    
            
        if( !getHibachiScope().getORMHasErrors()) {
            
            orderTemplate.clearProcessObject("applyGiftCard");
            getHibachiScope().flushORMSession(); //flushing to make new data availble
        	setOrderTemplateAjaxResponse(argumentCollection = arguments);
        }
	}
	
	public any function getOrderTemplatePromotionSkuCollectionConfig( required any data ){
        param name="arguments.data.orderTemplateID" default="";
	
     	var orderTemplate = getOrderService().getOrderTemplateAndEnforceOwnerAccount(argumentCollection = arguments);
		if( isNull(orderTemplate) ) {
			return;
		}
		
        arguments.data['ajaxResponse']['orderTemplatePromotionSkuCollectionConfig'] = orderTemplate.getPromotionalRewardSkuCollectionConfig();
	}
	
	public any function getOrderTemplatePromotionSkus( required any data ){
        param name="arguments.data.orderTemplateID" default="";
        param name="arguments.data.pageRecordsShow" default=10;
        param name="arguments.data.currentPage" default=1;
        
     	var orderTemplate = getOrderService().getOrderTemplateAndEnforceOwnerAccount(argumentCollection = arguments);
		if( isNull(orderTemplate) ) {
			return;
		}
		
		if(!StructKeyExists(arguments.data, 'orderTemplatePromotionSkuCollectionConfig')){
	        var promotionsCollectionConfig =  orderTemplate.getPromotionalFreeRewardSkuCollectionConfig();
	        promotionsCollectionConfig['pageRecordsShow'] = arguments.data.pageRecordsShow;
	        promotionsCollectionConfig['currentPage'] = arguments.data.currentPage;
	        arguments.data.orderTemplatePromotionSkuCollectionConfig = promotionsCollectionConfig;
		}
	    
	    var promotionsCollectionList = getService("SkuService").getSkuCollectionList();
	    promotionsCollectionList.setCollectionConfigStruct(arguments.data.orderTemplatePromotionSkuCollectionConfig);
        
        arguments.data['ajaxResponse']['orderTemplatePromotionSkus'] = promotionsCollectionList.getPageRecords(); 
	}
	
	private void function setOrderTemplateItemAjaxResponse(required any data) {
	    
		var orderTemplateItemCollection = getOrderService().getOrderTemplateItemCollectionForAccount(argumentCollection = arguments); 
	    orderTemplateItemCollection.addFilter("orderTemplateItemID", arguments.data.orderTemplateItemID); // filter with our-order-template-item
	    
 		arguments.data['ajaxResponse']['orderTemplateItem'] = orderTemplateItemCollection.getPageRecords()[1]; // there should be only one record;  
	}
	
	/**
	 * Wishlist API - get all wishlist Items
	 * createWishlist
     * getWishlist
	 * getWishlistItems
	 * addWishlistItem
	 * removeWishlistItem
	 * */
	public any function createWishlist(required any data) {
        param name="arguments.data.orderTemplateName" default="";
        param name="arguments.data.currencyCode" default="USD";
        param name="arguments.data.siteID" default="";
        
        if( !this.getHibachiScope().getLoggedInFlag() ){
            arguments.data.ajaxResponse['error'] = this.getHibachiScope().rbKey('validate.loggedInUser.wishlist');
        }

        arguments.data['orderTemplateTypeID'] = "2c9280846b712d47016b75464e800014"; // type-id for wishlist
		if( !len(trim(arguments.data.orderTemplateName)) ){
			arguments.data.orderTemplateName = "My Wish List, Created on " & dateFormat(now(), "long");
        }
        
        var orderTemplate = this.getOrderService().newOrderTemplate();
 		orderTemplate = this.getOrderService().processOrderTemplate(orderTemplate, arguments.data, 'createWishlist'); 
 		
 		var processObject = orderTemplate.getProcessObject('createWishlist');
 		if( processObject.hasErrors() ){
 		    orderTemplate.addErrors( processObject.getErrors() );
 		} else {
            arguments.data['ajaxResponse']['orderTemplateID'] = orderTemplate.getOrderTemplateID();
 		}
 		
        this.addErrors(arguments.data, orderTemplate.getErrors());
        this.getHibachiScope().addActionResult( "public:orderTemplate.createWishlist", orderTemplate.hasErrors() );
        
        return orderTemplate; // addItemAndCreateWishlist uses it
    }
    
    public any function addItemAndCreateWishlist( required struct data ){
        var orderTemplate = this.createWishlist(argumentCollection= arguments);

        if( !orderTemplate.hasErrors() ){
            this.getHibachiScope().flushORMSession();
            
            arguments.data['orderTemplateID'] = orderTemplate.getOrderTemplateID();
            this.addWishlistItem(arguments.data)
        }

        this.addErrors(arguments.data, orderTemplate.getErrors());
        this.getHibachiScope().addActionResult("public:orderTemplate.addItemAndCreateWishlist", orderTemplate.hasErrors() );
    }
	
	public void function getWishlist(required any data) {
	    
	    if( !(getHibachiScope().getLoggedInFlag()) ) {
            arguments.data.ajaxResponse['error'] = getHibachiScope().rbKey('validate.loggedInUser.wishlist');
        }
        var wishlist = getOrderService().getAccountWishlists(getHibachiScope().getAccount().getAccountID());
        arguments.data.ajaxResponse["accountWishlistProducts"] = wishlist;
        getHibachiScope().addActionResult( "public:order.getWishlist", false);
    }
    
    public void function getWishlistItems(required any data) {
        if( !(getHibachiScope().getLoggedInFlag()) ) {
            arguments.data.ajaxResponse['error'] = getHibachiScope().rbKey('validate.loggedInUser.wishlist');
        }
        var wishlistItems = getOrderService().getAccountWishlistsProducts(getHibachiScope().getAccount().getAccountID());
        arguments.data.ajaxResponse["accountWishlistProducts"] = wishlistItems;
        getHibachiScope().addActionResult( "public:order.getWishlistItems", false);
    }
	
	public void function addWishlistItem(required any data) {
        param name="arguments.data.orderTemplateID" default="";
        param name="arguments.data.skuID" default="";
        
        if( !(getHibachiScope().getLoggedInFlag()) ) {
            arguments.data.ajaxResponse['error'] = getHibachiScope().rbKey('validate.loggedInUser.wishlist');
        }
        
        var orderTemplate = getOrderService().getOrderTemplateAndEnforceOwnerAccount(argumentCollection = arguments);
		
		//create wishlist if not found with OrderTemplateID
		if( isNull(orderTemplate) || isNull( arguments.data.orderTemplateID)) {
		    arguments.data.messages = [];
			var orderTemplate = getOrderService().newOrderTemplate();
			arguments.data.orderTemplateName = "My Wish List, Created on " & dateFormat(now(), "long");
		}
	    
 		orderTemplate = getOrderService().processOrderTemplate(orderTemplate, arguments.data, 'addWishlistItem');
 		
 		var processObject = orderTemplate.getProcessObject('addWishlistItem');
 		if( processObject.hasErrors() ){
 		    orderTemplate.addErrors( processObject.getErrors() );
 		}
 		
        getHibachiScope().addActionResult( "public:orderTemplate.addWishlistItem", orderTemplate.hasErrors() );
            
        if(orderTemplate.hasErrors()) {
            ArrayAppend(arguments.data.messages, orderTemplate.getErrors(), true);
        }
    }
	
	public void function removeWishlistItem(required any data) {
        param name="arguments.data.orderTemplateID" default="";
        param name="arguments.data.removalSkuID" default="";
        
        if( !(getHibachiScope().getLoggedInFlag()) ) {
            arguments.data.ajaxResponse['error'] = getHibachiScope().rbKey('validate.loggedInUser.wishlist');
        }
        
        var orderTemplate = getOrderService().getOrderTemplateAndEnforceOwnerAccount(argumentCollection = arguments);
		if( isNull(orderTemplate) ) {
			return;
		}
		
 		orderTemplate = getOrderService().processOrderTemplate(orderTemplate, arguments.data, 'removeWishlistItem'); 
 		
 		var processObject = orderTemplate.getProcessObject('removeWishlistItem');
 		if( processObject.hasErrors() ){
 		    orderTemplate.addErrors( processObject.getErrors() );
 		}
 		
        getHibachiScope().addActionResult( "public:orderTemplate.removeWishlistItem", orderTemplate.hasErrors() );
            
        if(orderTemplate.hasErrors()) {
            ArrayAppend(arguments.data.messages, orderTemplate.getErrors(), true);
        }
    }
    
    public any function shareWishlist( required struct data ) {
        param name="arguments.data.orderTemplateID" default="";
        param name="arguments.data.receiverEmailAddress" default="";

        var orderTemplate = this.getOrderService().getOrderTemplateAndEnforceOwnerAccount(argumentCollection = arguments);
        if( isNull(orderTemplate) ){
            return;
        }

        orderTemplate = this.getOrderService().processOrderTemplate(orderTemplate, arguments.data, "shareWishlist");
        
        var processObject = orderTemplate.getProcessObject("shareWishlist");
        if( processObject.hasErrors() ){
            orderTemplate.addErrors( processObject.getErrors() );
        }

        this.addErrors(arguments.data, orderTemplate.getErrors());
        this.getHibachiScope().addActionResult( "public:orderTemplate.shareWishlist", orderTemplate.hasErrors() );
    }
    
	public void function addOrderTemplateItem(required any data) {
        param name="data.orderTemplateID" default="";
        param name="data.skuID" default="";
        param name="data.quantity" default=1;
        
        var orderTemplate = getOrderService().getOrderTemplateAndEnforceOwnerAccount(argumentCollection = arguments);
		if( isNull(orderTemplate) ) {
			return;
		}
	    
 		orderTemplate = getOrderService().processOrderTemplate(orderTemplate, arguments.data, 'addOrderTemplateItem'); 
 		orderTemplate = getOrderService().saveOrderTemplate(orderTemplate);
        getHibachiScope().addActionResult( "public:order.addOrderTemplateItem", orderTemplate.hasErrors() );
            
        if(orderTemplate.hasErrors()) {
            ArrayAppend(arguments.data.messages, orderTemplate.getErrors(), true);
        }else if(!orderTemplate.hasErrors() && !getHibachiScope().getORMHasErrors()) {
            getHibachiScope().flushORMSession(); 
        }
        
    }
    
    
    public void function editOrderTemplateItem(required any data) {
        param name="data.orderTemplateItemID" default="";
        param name="data.quantity" default=1;
        
        var orderTemplateItem = getOrderService().getOrderTemplateItemForAccount( argumentCollection=arguments );
        if( isNull(orderTemplateItem) ) {
			return;
		}
		
		orderTemplateItem.setQuantity(arguments.data.quantity); 
        var orderTemplateItem = getOrderService().saveOrderTemplateItem( orderTemplateItem, arguments.data );
        orderTemplateItem.getOrderTemplate().updateCalculatedProperties();

        getHibachiScope().addActionResult( "public:order.editOrderTemplateItem", orderTemplateItem.hasErrors() );
            
        if(orderTemplateItem.hasErrors()) {
            ArrayAppend(arguments.data.messages, orderTemplateItem.getErrors(), true);
        }
    }


	public void function removeOrderTemplateItem(required any data) {
        param name="data.orderTemplateItemID" default="";
        
        var orderTemplateItem = getOrderService().getOrderTemplateItemForAccount( argumentCollection=arguments );
        if( isNull(orderTemplateItem) ) {
			return;
		}
	    
 		orderTemplate = getOrderService().processOrderTemplate(orderTemplateItem.getOrderTemplate(), arguments.data, 'removeOrderTemplateItem'); 
        orderTemplate.updateCalculatedProperties();
        getHibachiScope().addActionResult( "public:order.removeOrderTemplateItem", orderTemplate.hasErrors() );
            
        if(orderTemplate.hasErrors()) {
            ArrayAppend(arguments.data.messages, orderTemplate.getErrors(), true);
        }
    }

	
	public void function deleteOrderTemplateItem(required any data) {
        param name="data.orderTemplateItemID" default="";
        
        var orderTemplateItem = getOrderService().getOrderTemplateItem( arguments.data.orderTemplateItemID );
        
        if(!isNull(orderTemplateItem) && orderTemplateItem.getOrderTemplate().getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID() ) {
            var deleteOk = getOrderService().deleteOrderTemplateItem( orderTemplateItem );
            getHibachiScope().addActionResult( "public:order.deleteOrderTemplateItem", !deleteOK );
            return;
        }
        
        getHibachiScope().addActionResult( "public:order.deleteOrderTemplateItem", true );  
    }
    
    public void function editOrderTemplate(required any data){
        param name="data.orderTemplateID" default="";
        param name="data.orderTemplateName" default="";
        
        var orderTemplate = getOrderService().getOrderTemplateAndEnforceOwnerAccount(argumentCollection = arguments);
		if( isNull(orderTemplate) ) {
			return;
		}
	    
	    if(len(arguments.data.orderTemplateName)) {
 		    orderTemplate.setOrderTemplateName(arguments.data.orderTemplateName);
	    }
	    
	    orderTemplate = getOrderService().saveOrderTemplate(orderTemplate);
        getHibachiScope().addActionResult( "public:orderTemplate.edit", orderTemplate.hasErrors() );

        if(!orderTemplate.hasErrors() && !getHibachiScope().getORMHasErrors()) {
            
            getHibachiScope().flushORMSession(); 
            //flushing to make new data availble
    		setOrderTemplateAjaxResponse(argumentCollection = arguments);
        
        } else {
            ArrayAppend(arguments.data.messages, orderTemplate.getErrors(), true);
        }
    }
    
    public void function deleteOrderTemplate(required any data){
        param name="data.orderTemplateID" default="";

        var orderTemplate = getOrderService().getOrderTemplate( arguments.data.orderTemplateID );
        
        if(!isNull(orderTemplate) && orderTemplate.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID() ) {
            var deleteOK = getOrderService().deleteOrderTemplate(orderTemplate);
            getHibachiScope().addActionResult( "public:order.deleteOrderTemplate", !deleteOK);
            if(!deleteOK){
                ArrayAppend(arguments.data.messages, orderTemplate.getErrors(), true);
            }
            return;
        }
        
        getHibachiScope().addActionResult( "public:order.deleteOrderTemplate", true );  
        
    }
    
    public void function addOrderTemplatePromotionCode(required any data) {
        param name="arguments.data.promotionCode" default="";
        param name="arguments.data.orderTemplateID" default="";
     	param name="arguments.data.returnAppliedPromotionCodes" default="true";

        var orderTemplate = this.getOrderService().getOrderTemplateAndEnforceOwnerAccount(argumentCollection = arguments);
        if( isNull(orderTemplate) ){
            return;
        }
        
        orderTemplate = this.getService("OrderService").processOrderTemplate( orderTemplate, arguments.data, 'addPromotionCode');
        var processObject = orderTemplate.getProcessObject("addPromotionCode");
        if( processObject.hasErrors() ){
            orderTemplate.addErrors( processObject.getErrors() );
        }
        
        this.getHibachiScope().addActionResult( "public:orderTemplate.addOrderTemplatePromotionCode", orderTemplate.hasErrors() );
        this.addErrors(arguments.data, orderTemplate.getErrors() );
        
        if( !orderTemplate.hasErrors() ){
            orderTemplate.clearProcessObject("addPromotionCode");
            if(arguments.data.returnAppliedPromotionCodes){
                this.getHibachiScope().flushORMSession(); 
                this.getAppliedOrderTemplatePromotionCodes(arguments.data);
            }
            this.getOrderTemplateDetails(arguments.data);
        }
    }
    
    public void function removeOrderTemplatePromotionCode(required any data) {
        param name="arguments.data.promotionCodeID" default="";
        param name="arguments.data.orderTemplateID" default="";
     	param name="arguments.data.returnAppliedPromotionCodes" default="true";

        var orderTemplate = this.getOrderService().getOrderTemplateAndEnforceOwnerAccount(argumentCollection = arguments);
        if( isNull(orderTemplate) ){
            return;
        }
        
        orderTemplate = this.getOrderService().processOrderTemplate( orderTemplate, arguments.data, 'removePromotionCode');

        var processObject = orderTemplate.getProcessObject("removePromotionCode");
        if( processObject.hasErrors() ){
            orderTemplate.addErrors( processObject.getErrors() );
        }
        
        this.getHibachiScope().addActionResult( "public:orderTemplate.removeOrderTemplatePromotionCode", orderTemplate.hasErrors() );
        this.addErrors(arguments.data, orderTemplate.getErrors() );
        
        if( !orderTemplate.hasErrors() ){
            orderTemplate.clearProcessObject("removePromotionCode");
            if( arguments.data.returnAppliedPromotionCodes ){
                this.getHibachiScope().flushORMSession(); 
                this.getAppliedOrderTemplatePromotionCodes(arguments.data);
            }
            this.getOrderTemplateDetails(arguments.data);
        } 
    }
    
    public void function getAppliedOrderTemplatePromotionCodes(required any data){
        param name="arguments.data.orderTemplateID" default="";

		arguments.data['ajaxResponse']['appliedOrderTemplatePromotionCodes'] = [];
        if( len(arguments.data.orderTemplateID) ){
            arguments.data['ajaxResponse']['appliedOrderTemplatePromotionCodes'] 
                = this.getDAO('orderDAO').getAppliedOrderTemplatePromotionCodes( arguments.data.orderTemplateID );
        } 
    }
    
    public any function deleteOrderTemplatePromoItems(required any data ){
        param name="data.orderTemplateID" default="";

        var orderTemplate = this.getOrderService().getOrderTemplateAndEnforceOwnerAccount(argumentCollection = arguments);

    	if(!isNull(orderTemplate)){
    	    this.getDAO('orderDAO').removeTemporaryOrderTemplateItems(arguments.data.orderTemplateID);
            this.getHibachiScope().addActionResult( "public:orderTemplate.deleteOrderTemplatePromoItems", false );  
    	}
    }
    
    public any function getOrderTemplatePromotionProducts( required any data ) {
        param name="arguments.data.orderTemplateID" default="";
        param name="arguments.data.pageRecordsShow" default=10;
        param name="arguments.data.currentPage" default=1;

        var orderTemplate = this.getOrderService().getOrderTemplateAndEnforceOwnerAccount( argumentCollection = arguments );
        if( isNull(orderTemplate) ){
            return;
        }

        if( !structKeyExists(arguments.data, 'orderTemplatePromotionSkuCollectionConfig') ){
            var promotionsCollectionConfig =  orderTemplate.getPromotionalFreeRewardSkuCollectionConfig();
            promotionsCollectionConfig['pageRecordsShow'] = arguments.data.pageRecordsShow;
            promotionsCollectionConfig['currentPage'] = arguments.data.currentPage;
            arguments.data.orderTemplatePromotionSkuCollectionConfig = promotionsCollectionConfig;
        }

        var promotionsCollectionList = this.getService("SkuService").getSkuCollectionList();
        promotionsCollectionList.setCollectionConfigStruct( arguments.data.orderTemplatePromotionSkuCollectionConfig );
        promotionsCollectionList.setPageRecordsShow( arguments.data.pageRecordsShow );
        promotionsCollectionList.setDisplayProperties('
            product.defaultSku.skuID|skuID,
            product.urlTitle|urlTitle,
            product.productName|productName
        ');

        var records = promotionsCollectionList.getPageRecords();

        var imageService = this.getService('ImageService');
        records = arrayMap(records, function(product){
            product.skuImagePath = imageService.getResizedImageByProfileName(product.skuID, 'medium');
            return product;
        }) 

        arguments.data['ajaxResponse']['orderTemplatePromotionProducts'] = records; 
    }

   
    
    
    
    ///    ############### .  getXXXOptions();  .  ###############   
    
    /**
     *  data.optionsList = "frequencyTermOptions,siteOrderTemplateShippingMethodOptions,cancellationReasonTypeOptions....."; 
    */ 
    public void function getOptions(required any data){
        param name="data.optionsList" default="" pattern="^[\w,]+$"; //option-name-list
        
        for(var optionName in arguments.data.optionsList) {
            if(right(optionName,7) == 'Options'){
                this.invokeMethod("get#optionName#", {'data' = arguments.data});
            }
        }
    }
    
    public void function getFrequencyTermOptions(required any data) {
		arguments.data['ajaxResponse']['frequencyTermOptions'] = getOrderService().getOrderTemplateFrequencyTermOptions();
    }
    
    public void function getFrequencyDateOptions(required any data) {
		arguments.data['ajaxResponse']['frequencyDateOptions'] = getOrderService().getOrderTemplateFrequencyDateOptions();
    }
    
    public void function getSiteOrderTemplateShippingMethodOptions(required any data) {
        var orderTemplate = getOrderService().getOrderTemplate(arguments.data.orderTemplateID);
        if(isNull(orderTemplate)){
            return arguments.data['ajaxResponse']['siteOrderTemplateShippingMethodOptions'] = {};   
        }
        
		arguments.data['ajaxResponse']['siteOrderTemplateShippingMethodOptions'] = orderTemplate.getShippingMethodOptions();
    }
    
    public void function getCancellationReasonTypeOptions(required any data) {
        var tmpOrderTemplate = getOrderService().newOrderTemplate();
		arguments.data['ajaxResponse']['cancellationReasonTypeOptions'] = tmpOrderTemplate.getOrderTemplateCancellationReasonTypeOptions();
    }
    
    public void function getScheduleDateChangeReasonTypeOptions(required any data) {
        var tmpOrderTemplate = getOrderService().newOrderTemplate();
		arguments.data['ajaxResponse']['scheduleDateChangeReasonTypeOptions'] = tmpOrderTemplate.getOrderTemplateScheduleDateChangeReasonTypeOptions();
    }
    
    public void function getExpirationMonthOptions(required any data) {
       	var tmpAccountPaymentMethod = getAccountService().newAccountPaymentMethod();
		arguments.data['ajaxResponse']['expirationMonthOptions'] = tmpAccountPaymentMethod.getExpirationMonthOptions();
    }
    
     public void function getExpirationYearOptions(required any data) {
       	var tmpAccountPaymentMethod = getAccountService().newAccountPaymentMethod();
		arguments.data['ajaxResponse']['expirationYearOptions'] = tmpAccountPaymentMethod.getExpirationYearOptions();
    }
    
    public void function getQualifiedMerchandiseRewardsForOrder(required struct data){
        param name="arguments.data.orderID";
        
        var order = getOrderService().getOrder(arguments.data.orderID);
        
        if( !isNull(order) &&
            ( isNull(order.getAccount()) || order.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID() ) 
        ){
            var rewardArgs = {
                order:order,
                apiFlag:true,
                rewardTypeList:'merchandise'
            };
            var rewards = getService('PromotionService').getQualifiedPromotionRewardsForOrder(argumentCollection=rewardArgs);
            
            arguments.data['ajaxResponse']['rewards'] = rewards;
        }
    }
    
    public void function getQualifiedPromotionRewardSkusForOrder(required struct data){
        param name="arguments.data.orderID";
        /*
            OrderID is required, data can also include promotionRewardID to return skus for a particular reward.
            Other optional arguments: pageRecordsShow (default 25), formatRecords (default false)
        */
        var order = getOrderService().getOrder(arguments.data.orderID);
        if( !isNull(order) &&
            ( isNull(order.getAccount()) || order.getAccount().getAccountID() == getHibachiScope().getAccount().getAccountID() ) 
        ){
            arguments.data.order = order;
            var rewardSkus = getService('PromotionService').getQualifiedPromotionRewardSkusForOrder(argumentCollection=arguments.data);
            arguments.data['ajaxResponse']['rewardSkus'] = rewardSkus;
        }
    }
    
    
    /**
     * 
     * /api/scope/getSlatwallContent
     * 
     */
    public void function getSlatwallContent(required struct data){
        param name="arguments.data.siteCode" default="";
        param name="arguments.data.content" default={};
        param name="arguments.data.formCode" default='';
        param name="arguments.data.formPostfix" default="/";
        getHibachiScope().setSite(getService('siteService').getSiteBySiteCode(arguments.data.siteCode))
        
        var stackedContent= {}
        for(var content in arguments.data.content) {
            StructAppend(stackedContent, getService('siteService').getStackedContentForPage({"#content#":arguments.data.content[content] }),"true")
        }

        if(!this.getHibachiScope().hibachiIsEmpty(arguments.data.formCode)){
            stackedContent['form'] = {
                "type": arguments.data.formCode,
                "markup": getService('siteService').dspForm(arguments.data.formCode,arguments.data.formPostfix)
            };
        }

        getHibachiScope().addActionResult("public:getSlatwallContent", false);

        arguments.data['ajaxResponse']['content'] = stackedContent;

    }

    public void function getSlatwallForm(required struct data){
        param name="arguments.data.siteCode" default="";
        param name="arguments.data.formCode" default="contact-us";
        param name="arguments.data.formPostfix" default="?submitted=true";

        getHibachiScope().setSite(getService('siteService').getSiteBySiteCode(arguments.data.siteCode))

        var markup =  getService('siteService').dspForm(arguments.data.formCode,arguments.data.formPostfix)
        getHibachiScope().addActionResult("public:getSlatwallForm", false);

        arguments.data['ajaxResponse']['content'] = {"form": {
            "type": arguments.data.formCode,
            "markup": markup
        }};

    }
    
    /***
	 * Method to return combined list of category, producttype, brand, option
	 * @param - pageRecordsShow
	 * @param - allowProductAssignmentFlag
	 * @param - activeFlag
	 * @return - filterOptionsResponse - custom array of keys
	 **/
    public void function getProductFilterOptions(struct data={}) {
	    param name="arguments.data.allowProductAssignmentFlag" default=true;
	    param name="arguments.data.activeFlag" default=true;

        // Category Collection List
        var categoryCollectionList = getService("ContentService").getCategoryCollectionList();
        categoryCollectionList.addFilter("allowProductAssignmentFlag", arguments.data.allowProductAssignmentFlag );
        var categories = categoryCollectionList.getRecords(formatRecords=false);
        
        // Product Type Collection List
        var productTypeCollectionList = getProductService().getProductTypeCollectionList();
        productTypeCollectionList.addFilter("activeFlag", arguments.data.activeFlag );
        var productTypes = productTypeCollectionList.getRecords(formatRecords=false);
        
        // Brand Collection List
        var brandCollectionList = getProductService().getBrandCollectionList();
        brandCollectionList.addFilter("activeFlag", arguments.data.activeFlag );
        var brands = brandCollectionList.getRecords(formatRecords=false);
        
        // Option Collection List
        var optionCollectionList = getProductService().getOptionCollectionList();
        optionCollectionList.addFilter("activeFlag", arguments.data.activeFlag );
        var options = optionCollectionList.getRecords(formatRecords=false);
        
        arguments.data.ajaxResponse['data'] = {
           'category'   : categories, 
           'productType': productTypes,
           'brand'      : brands,
           'option'     : options
        };
        getHibachiScope().addActionResult("public:scope.getProductFilterOptions",false);
    }
    
    /** 
     * @http-context getDiscountsByCartData
     * @description This method exposes Slatwall promotion engine to be used standalone
     * Promotion engine will evaluate discounts based on cart data passed in. Cart data
     * will create a transient order to do the calculation and delete the order after response
     * example data struct: 
     * {
     *  "skus":[{"skucode":"item1","quantity":"1"}, {"skucode":"item2","quantity":"1"}],
     *  "promotionCode":"123",
     *  "account":{"firstName": "", "lastName": "", "emailAddress": ""}
     * }
     */
     public void function getDiscountsByCartData(required struct data) {
         param name="arguments.data.skus" default=[];
         arguments.data["updateOrderAmountFlag"] = false;

         var cart = getOrderService().newOrder();
         getHibachiScope().getSession().setOrder( cart );
         
         if(structKeyExists(arguments.data, "promotionCode")) {
             addPromotionCode(arguments.data);
         }
         
         for(var sku in arguments.data.skus) {
             var cartData = {};
             cartData["updateShippingMethodOptionsFlag"] = false;
             cartData["updateOrderAmountFlag"] = false;
             cartData["saveOrderFlag"] = false;
         
             if(structKeyExists(sku, "skucode")){
                 param name="sku.quantity" default=1;
                 cartData["skuCode"] = sku["skuCode"];
                 cartData["quantity"] = sku["quantity"];
                 addOrderItem( cartData );
             }
         }
         
         if(structKeyExists(arguments.data, "account")) {
            var account = getAccountService().newAccount();
            getAccountService().saveAccount( account, arguments.data.account );
            if(!account.hasErrors()){
                cart.setAccount( account );
            } else {
                cart.addErrors( account.getErrors() );
                getHibachiScope().setORMHasErrors( true );
            }
         }
         
         // save order and update amounts
         getOrderService().saveOrder( order=cart, updateOrderAmounts=true, updateShippingMethodOptions=false);
         
         var cartData = {"cartDataOptions": "order,orderitem"};
         getCartData( arguments.data );
         
         getOrderService().deleteOrder( cart );
    }
     
    /**
	 * Generic Endpoint to get any entity
	* */
	public any function getEntity( required struct data ) {
	    param name="arguments.data.entityID" default="";
	    param name="arguments.data.entityName" default="";
        param name="arguments.data.currentPage" default=1;
        param name="arguments.data.pageRecordsShow" default=getHibachiScope().setting('GLOBALAPIPAGESHOWLIMIT');
	    param name="arguments.data.propertyIdentifierList" default="";

        if( !len(arguments.data.entityName) ){
            getHibachiScope().addActionResult("public:scope.getEntity",true);
            return;
        }
        
        arguments.data.restRequestFlag = 1;
        arguments.data.enforceAuthorization = true;
        arguments.data.useAuthorizedPropertiesAsDefaultColumns = true;
        
        var overrideFunctionName = 'get'&arguments.data.entityName;
        if( structKeyExists(this, overrideFunctionName) ){
            return this.invokeMethod(overrideFunctionName, {data=arguments.data});
        }
        
        //Use public Properties logic here to fetch default properties
        if( len(arguments.data.entityID) ){
            arguments.data.ajaxResponse['data'] = this.getHibachiCollectionService().getAPIResponseForBasicEntityWithID( arguments.data.entityName, arguments.data.entityID, arguments.data );
        } else {
    	    arguments.data.ajaxResponse['data'] = this.gethibachiCollectionService().getAPIResponseForEntityName( arguments.data.entityName, arguments.data );
        }

        this.getHibachiScope().addActionResult("public:scope.getEntity", false);
	}
	
	/**
	 * this function extends/overrides the generic `getEntity` and is not supposed to be called directly 
	 * @path `/api/public/product/{entityID}`
	 * 
	 * if @includeAttributesMetadata is set to true, and the request is for an specific product [entityID is set], 
	 * it will all attribute-sets related to the requested-product [ Global, product-tpyes(the hierarchy), brand and the requested product ];
	 * 
	 * @includeAttributesMetadata, defaults to `false`; is boolean flag to return the attribute-sets metadata for that product
	 */
	public any function getProduct(required struct data ){
	    param name="arguments.data.includeAttributesMetadata" default=false;
	     arguments.data.ajaxResponse['attributeSets'] = []
	     if( arguments.data.includeAttributesMetadata ){
            if(!arguments.data.propertyIdentifierList.listFindNoCase('productType.productTypeID') ){
                arguments.data.propertyIdentifierList = arguments.data.propertyIdentifierList.listAppend('productType.productTypeIDPath');
            }
            if(!arguments.data.propertyIdentifierList.listFindNoCase('brand.brandID') ){
                arguments.data.propertyIdentifierList = arguments.data.propertyIdentifierList.listAppend('brand.brandID');
            }
        }
	    
	    // if this's  cal to get all-products
	    if( !len(arguments.data.entityID) ){
    	    arguments.data.ajaxResponse['data'] = this.gethibachiCollectionService().getAPIResponseForEntityName( arguments.data.entityName, arguments.data );
             arguments.data.ajaxResponse['data'].pageRecords = getService("productService").appendImagesToProduct(arguments.data.ajaxResponse['data'].pageRecords);
	         arguments.data.ajaxResponse['data'].pageRecords = getService("productService").appendCategoriesAndOptionsToProduct(arguments.data.ajaxResponse['data'].pageRecords);
	         if(arguments.data.includeAttributesMetadata && Len(arguments.data.ajaxResponse['data'].pageRecords) == 1){
	             var product = getProductService().getProduct(arguments.data.ajaxResponse['data'].pageRecords[1].productID)
	             if(!isNull(product)){
	                arguments.data.ajaxResponse['attributeSets'] = getAttributeSetMetadataForProduct(product.getProductID(), product.getProductType().getProductTypeIDPath() ,product.getBrand().getBrandID() ); 
 	             }
	         }
                
            this.getHibachiScope().addActionResult("public:scope.getProduct", true);
            return;
        }
        
       
        
        var response = {};
        response['product'] = this.getHibachiCollectionService().getAPIResponseForBasicEntityWithID( arguments.data.entityName, arguments.data.entityID, arguments.data );
        response['product'] = getService("productService").appendImagesToProduct([response['product']]);

	    response['product'] = getService("productService").appendCategoriesAndOptionsToProduct(response['product']);
	    response['product'] = response['product'][1]
        if(arguments.data.includeAttributesMetadata){
            response['attributeSets'] = getAttributeSetMetadataForProduct(response.product.productID, response.product.productType_productTypeIDPath, response.product.brand_brandID );
        }
        
        arguments.data.ajaxResponse['data'] = response;
        this.getHibachiScope().addActionResult("public:scope.getProduct", true);
	}
	
	
	/**
	 * this function extends/overrides the generic `getEntity` and is not supposed to be called directly 
	 * @path `/api/public/brand/{entityID}`
	 * 
	 */
	public any function getBrand(required struct data ){
	    
	    // if this's  cal to get all-products
	    if( !len(arguments.data.entityID) ){
    	    arguments.data.ajaxResponse['data'] = this.gethibachiCollectionService().getAPIResponseForEntityName( arguments.data.entityName, arguments.data );
            arguments.data.ajaxResponse['data'].pageRecords = getService("brandService").appendSettingsAndOptions(arguments.data.ajaxResponse['data'].pageRecords);
            this.getHibachiScope().addActionResult("public:scope.getBrand", true);
            return;
        }
       
        
        var response = {};
        response['brand'] = this.getHibachiCollectionService().getAPIResponseForBasicEntityWithID( arguments.data.entityName, arguments.data.entityID, arguments.data );
        response['brand'] = getService("brandService").appendSettingsAndOptions([response['brand']]);
	    response['brand'] = response['brand'][1]
       
        arguments.data.ajaxResponse['data'] = response;
        this.getHibachiScope().addActionResult("public:scope.getProduct", true);
	}
	
	
	private array function getAttributeSetMetadataForProduct(required productID, required string productTypeIDPath, string brandID=''){
	    
	    var attributeSetCollectionList = this.getAttributeService().getAttributeSetCollectionList();
	    
	    attributeSetCollectionList.setDisplayProperties('attributeSetName, attributeSetCode, attributeSetDescription, globalFlag, sortOrder');
	    attributeSetCollectionList.addDisplayProperties('attributes.attributeName, attributes.attributeCode, attributes.attributeDescription, attributes.sortOrder');
	    
        attributeSetCollectionList.setDistinct(true);
	    attributeSetCollectionList.addFilter('activeFlag', 1);
	    attributeSetCollectionList.addFilter('attributeSetObject', 'Product');
	    attributeSetCollectionList.addFilter('attributes.activeFlag', 1);
	    
	    attributeSetCollectionList.addFilter(
            value               =  1,
            filterGroupAlias    = 'attribute_set_filters',
            propertyIdentifier  = 'globalFlag',
            comparisonOperator  = "="
        );
        
        if( len(arguments.productTypeIDPath) ){
            attributeSetCollectionList.addFilter( 
                value               = arguments.productTypeIDPath, 
                logicalOperator     = "OR",
                filterGroupAlias    = 'attribute_set_filters',
                propertyIdentifier  = 'productTypes.productTypeIDPath',
                comparisonOperator  = "IN"
            );
        }
        
         if( len(arguments.brandID) ){
            attributeSetCollectionList.addFilter( 
                value               = arguments.brandID, 
                logicalOperator     = "OR",
                filterGroupAlias    = 'attribute_set_filters',
                propertyIdentifier  = 'brands.brandID',
                comparisonOperator  = "="
            );
        }
        
        attributeSetCollectionList.addFilter( 
            value               = arguments.productID, 
            logicalOperator     = "OR",
            filterGroupAlias    = 'attribute_set_filters',
            propertyIdentifier  = 'products.productID',
            comparisonOperator  = "="
        );
        
        var attributeSets =attributeSetCollectionList.getRecords();
        var formattedAttributeSets = {};

        for(var attributeSet in attributeSets){
            if(!structKeyExists(formattedAttributeSets, attributeSet.attributeSetCode) ){
                formattedAttributeSets[attributeSet.attributeSetCode] = {
                    'sortOrder'                 : attributeSet.sortOrder,
                    'globalFlag'                : attributeSet.globalFlag,
                    'attributes'                : {},
                    'attributeSetName'          : attributeSet.attributeSetName,
                    'attributeSetCode'          : attributeSet.attributeSetCode,
                    'attributeSetDescription'   : attributeSet.attributeSetDescription
                }
            }
            
            var formattedAttributeSet = formattedAttributeSets[attributeSet.attributeSetCode];
            
            formattedAttributeSet.attributes[ attributeSet.attributes_attributeCode ] = {
                'sortOrder'              : attributeSet.attributes_sortOrder,
                'attributeName'          : attributeSet.attributes_attributeName,
                'attributeCode'          : attributeSet.attributes_attributeCode,
                'attributeDescription'   : attributeSet.attributes_attributeDescription
            }
        }
        
        var attributeSets = [];
        for(var attributeSetCode in formattedAttributeSets){
            var formattedAttributeSet = formattedAttributeSets[attributeSetCode];
            
            var attributes = [];
            for(var attributeCode in formattedAttributeSet.attributes ){
                attributes.append( formattedAttributeSet.attributes[attributeCode] );
            }
            
            formattedAttributeSet['attributes'] = attributes;
            attributeSets.append(formattedAttributeSet);
        }
        
        return attributeSets;
	}
    
    public any function getPickupLocations() {
		arguments.data.ajaxResponse['locations'] = this.getLocationService().getLocationParentOptions(false)
    }
    
    public any function setPickupDate(required any data) {
        param name="data.pickupDate" default="";
		param name="data.orderFulfillmentID" default="";
        if( getHibachiScope().getLoggedInFlag() ) {
            var cart = getHibachiScope().cart();

            if(!len(arguments.data.orderFulfillmentID)){
    			var orderFulfillment = cart.getOrderFulfillments()[1];
    		}else{
    			var orderFulfillment = getService("OrderService").getOrderFulfillment(arguments.data.orderFulfillmentID);
    		}
		    orderFulfillment.setEstimatedShippingDate(arguments.data.pickupDate);
		    orderFulfillment.setPickupDate(arguments.data.pickupDate);

		    getService("OrderService").saveOrderFulfillment(orderFulfillment);
		    

    		if(orderFulfillment.hasErrors()){
			 getHibachiScope().addActionResult( "public:cart.setPickupDate", true);
               arguments.data.ajaxResponse['errors'] = orderFulfillment.getErrors();
		    }else{
		        getHibachiScope().addActionResult( "public:cart.setPickupDate", false);
		    }
    
    		return cart;
		}
    } 

    public any function getEligibleFulfillmentMethods() {
        
        if( getHibachiScope().getLoggedInFlag() ) {
            var cart = getHibachiScope().cart();
            var orderItems = cart.getOrderItems();


            var sl = getService("fulfillmentService").getFulfillmentMethodSmartList();
			sl.addFilter('activeFlag', 1);
			sl.addSelect('fulfillmentMethodName', 'name');
			sl.addSelect('fulfillmentMethodID', 'value');
			sl.addSelect('fulfillmentMethodType', 'fulfillmentMethodType');
			
			var eligibleFulfillmentMethods = '';
			for(var orderItem in orderItems){
				var sku = orderItem.getSku();
				if(!isNull(sku)) {
					if(!len(eligibleFulfillmentMethods)){
						eligibleFulfillmentMethods = sku.setting('skuEligibleFulfillmentMethods');
					}else{
						for(var fulfillmentMethod in eligibleFulfillmentMethods){
							if(!listFind(sku.setting('skuEligibleFulfillmentMethods'), fulfillmentMethod)){
								eligibleFulfillmentMethods = listDeleteAt(eligibleFulfillmentMethods, listFind(eligibleFulfillmentMethods,fulfillmentMethod));
							}
						}
					}
				}
			}
			
			sl.addInFilter('fulfillmentMethodID', eligibleFulfillmentMethods);
			arguments.data.ajaxResponse['eligibleFulfillmentMethods'] = sl.getRecords();
        }
    }
    
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
        
        arguments.data['ajaxResponse']['config']['formatting'] = {
            "dateFormat": UCase(getHibachiScope().setting('globalDateFormat')),
            "timeFormat": Replace(UCase(getHibachiScope().setting('globalTimeFormat')), 'TT', 'a', 'all')};

        getHibachiScope().addActionResult("public:getConfiguration");

        arguments.data['ajaxResponse']['config']['router'] = router;
        return 
         
     }
     
    public void function productDetailData( required struct data ) {
		param name="arguments.data.productID" type="string" default="";
		param name="arguments.data.selectedOptionIDList" type="string" default="";

		var product = getProductService().getProduct( arguments.data.productID );

		if(!isNull(product) && product.getActiveFlag() && product.getPublishedFlag()) {
			arguments.data.ajaxResponse["availableSkuOptions"] = product.getAvailableSkuOptions( arguments.data.selectedOptionIDList );

			try{
				var sku = product.getSkuBySelectedOptions(arguments.data.selectedOptionIDList);
				if(!isNull(sku) && sku.getActiveFlag() && sku.getPublishedFlag()) {
					arguments.data.ajaxResponse['skuID'] = sku.getSkuID();
				
					var skuCollectionList = getService('SkuService').getSkuCollectionList();
				    skuCollectionList.setDisplayProperties( "skuID,skuCode,product.productName,product.productCode,product.productType.productTypeName,product.brand.brandName,listPrice,price,renewalPrice,calculatedSkuDefinition,activeFlag,publishedFlag,calculatedQATS");
		    	    skuCollectionList.addFilter('skuID',sku.getSkuID());
					var results = skuCollectionList.getRecords()
					if(!ArrayIsEmpty(results) ) {
			        	arguments.data.ajaxResponse['sku'] = getService("skuService").appendSettingsAndOptionsToSku(results);
			    	}
				}else{
					arguments.data.ajaxResponse['skuID'] = '';
					arguments.data.ajaxResponse['sku'] = {};
				}
			}catch(any e){
				arguments.data.ajaxResponse['skuID'] = '';
				arguments.data.ajaxResponse['sku'] = {};
			}
		}
	}
    
}
