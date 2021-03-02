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
component extends="Slatwall.model.service.HibachiService" persistent="false" accessors="true" output="false"{
	
	property name="productDAO";
	property name="siteService";
	property name="hibachiCacheService";
	property name="slatwallProductSearchDAO";
	
	public struct function getFacetsMetaData(){
	    if(!structKeyExists(variables, 'facetsMetaData') ){
	        variables['facetsMetaData'] = {
	            
    	        'categories' : {
        	        'name'           : 'Categories',
        	        'facetKey'       : 'category', 
        	        'selectType'     : 'single',
        	        
        	        'optionNameKey'  : 'categoryName',
        	        'optionValueKey' : 'categoryName'
        	    },
        	    
                'productTypes': {
        	        'name'           : 'ProductTypes',
        	        'facetKey'       : 'productType', 
        	        'selectType'     : 'single',
        	        
        	        'optionNameKey'  : 'productTypeName',
        	        'optionValueKey' : 'productTypeName'
        	    },
        	    
                'brands' : {
        	        'name'           : 'Brands',
        	        'facetKey'       : 'brands', 
        	        'selectType'     : 'multi',
        	        
        	        'optionNameKey'  : 'brandName',
        	        'optionValueKey' : 'brandName'
        	    },
        	    
        	    'optionGroups' : {
        	        'facetKey'       : 'options', 
        	        'facetType'      : 'group',
        	        'selectType'     : 'multi',
        	        'subFacetNameKey'        : 'optionGroupName',
        	        'subFacetOptionNameKey'  : 'optionName',
        	        'subFacetOptionValueKey' : 'optionCode'
        	    },
        	    
        	    'attributeOptions' : {
            	    'facetKey'          : 'attributeOptions', 
        	        'facetType'         : 'group',
        	        'selectType'        : 'multi',
        	        'subFacetNameKey'        : 'attributeName',
        	        'subFacetOptionNameKey'  : 'attributeOptionLabel',
        	        'subFacetOptionValueKey' : 'attributeOptionValue'
        	    }
        	    
        	   // 'sorting' : {
        	   //     'name'           : 'Sort By',
        	   //     'facetKey'       : 'orderBy',
        	   //     'selectType'     : 'multi'
        	   // },
        	    
        	   // 'price' : {
        	   //     'name'           : 'Price',
        	   //     'facetKey'       : 'price',
        	   //     'selectType'     : 'single'
        	   // }
    	    };
	    }
	    
	    return variables['facetsMetaData'];
	}
	

	public struct function getPotentialFilterFacetsAndOptions(){
	    param name="arguments.siteID" default='';
	    param name="arguments.productType" default='';
	    param name="arguments.category" default='';
	    param name="arguments.brands" default='';
	    param name="arguments.options" default='';
	    param name="arguments.attributeOptions" default='';
	    
	    var rawFilterOptions = this.getSlatwallProductSearchDAO().getPotentialFilterFacetsAndOptions( argumentCollection = arguments);
	    
	    var startTicks = getTickCount();
	    
        // we're using hash-maps for :
        // - duplicate-removal 
        // - faster lookups 
	    var potentialFilters = {
	        'brands'            : {},
	        'categories'        : {},
	        'attributes'        : {},
	        'optionGroups'      : {},
	        'productTypes'      : {}
	    };
	    
       	this.logHibachi("SlatwallProductSearchService:: getProductFilterFacetOptions - processing - #rawFilterOptions.recordCount# ");
            
	    for( var row in rawFilterOptions ){
	        
	        // ****** ProductType - Filter
	        if( !isNull(row.productTypeID) && !this.hibachiIsEmpty(row.productTypeID) && !structKeyExists(potentialFilters.productTypes, row.productTypeID) ){
	            potentialFilters.productTypes[ row.productTypeID ] = {
	                'productTypeID'              : row.productTypeID,
	                'productTypeName'            : row.productTypeName,
	                'productTypeURLTitle'        : row.productTypeURLTitle,
	                'parentProductTypeID'        : row.parentProductTypeID
	            };
	        }
	        
	        // ****** Categories 
	        if( !isNull(row.categoryID) && !this.hibachiIsEmpty(row.categoryID) && !structKeyExists(potentialFilters.categories, row.categoryID ) ){
	            potentialFilters.categories[ row.categoryID ] = {
	                'categoryID'            : row.categoryID,
	                'categoryName'          : row.categoryName,
	                'categoryUrlTitle'      : row.categoryUrlTitle,
	                'parentCategoryID'      : row.parentCategoryID
	            };
	        }
	        
	        // ****** Brands
	        if( !isNull(row.brandID) && !this.hibachiIsEmpty(row.brandID) && !structKeyExists(potentialFilters.brands, row.brandID )  ){
	             potentialFilters.brands[ row.brandID ] = {
	                'brandID'              : row.brandID,
	                'brandName'            : row.brandName
	            };
	        }

	        // ****** OptionGroups
	        if( !isNull(row.optionGroupID) && !this.hibachiIsEmpty(row.optionGroupID) ){
	            if(!structKeyExists(potentialFilters.optionGroups, row.optionGroupID ) ){
        	          potentialFilters.optionGroups[ row.optionGroupID ] = {
    	                'optionGroupID'             : row.optionGroupID,
    	                'optionGroupName'           : row.optionGroupName,
    	                'sortOrder'                 : row.optionGroupSortOrder,
    	                'options'                   : {}
    	             };
	            }
	            // ****** Options 
    	        if( !isNull(row.optionID) && !this.hibachiIsEmpty(row.optionID) ){
    	            var thisGroupsOptions = potentialFilters.optionGroups[ row.optionGroupID ].options;
        	        if( !structKeyExists(thisGroupsOptions, row.optionID ) ){
        	            thisGroupsOptions[ row.optionID ] = {
        	                'optionID'              : row.optionID,
        	                'optionCode'            : row.optionCode,
        	                'optionName'            : row.optionName,
        	                'sortOrder'             : row.optionSortOrder
        	            };
        	        }  
    	        }
    	        // ***
	        }
	        
	        // ****** Attributes
	        if( !isNull(row.attributeID) && !this.hibachiIsEmpty(row.attributeID) ){
	            // This Attribute
    	        if( !structKeyExists(potentialFilters.attributes, row.attributeID ) ){
    	            potentialFilters.attributes[ row.attributeID ] = {
    	                'attributeID'              : row.attributeID,
    	                'attributeName'            : row.attributeName,
    	                'attributeCode'            : row.attributeCode,
    	                'urlTitle'                 : row.attributeUrlTitle,
    	                'attributeEntity'          : row.attributeSetObject,
    	                'sortOrder'                : row.attributeSortOrder,
    	                'attributeInputType'       : row.attributeInputType,
    	                'options'                  : {}
    	            };
    	        }
    	        // ****** This Attribute's Options 
    	        if( !isNull(row.attributeOptionID) && !this.hibachiIsEmpty(row.attributeOptionID) ){
    	            var thisAttributesOptions = potentialFilters.attributes[ row.attributeID ].options;
        	        if( !structKeyExists(thisAttributesOptions, row.attributeOptionID ) ){
        	            thisAttributesOptions[ row.attributeOptionID ] = {
        	                'attributeOptionID'              : row.attributeOptionID,
        	                'attributeOptionLabel'           : row.attributeOptionLabel,
        	                'attributeOptionValue'           : row.attributeOptionValue,
        	                'urlTitle'                       : row.attributeOptionUrlTitle,
        	                'sortOrder'                      : row.attributeOptionSortOrder
        	            };
        	        } 
    	        }
    	        // ***
	        }
	        
	    } // END loop
	    
	    
	    
	    this.logHibachi("SlatwallProductSearchService:: getPotentialProductFilterFacetOptions took #getTickCount() - startTicks# ms.")

	    return potentialFilters;
	}
	
	
	public struct function getFormattedFilterFacets(required struct potentialFilterFacets){
	    var startTicks = getTickCount();
	    
	    var facetsMetaData = this.getFacetsMetaData();
	    
	    var formattedFacets = {};
	    
	    for(var facetName in facetsMetaData ){
	        
	        if(!structKeyExists(potentialFilterFacets, facetName) ){
	            continue;
	        }
	        
	        var thisFacetMetadata = facetsMetaData[ facetName ];
	        
	        if(structKeyExists(thisFacetMetadata, 'facetType') && thisFacetMetadata.facetType == 'group' ){
	            var subFacets = [];
	            var potentialSubFacets = potentialFilterFacets[ facetName ];
	            
	            for(var subFacetID in potentialSubFacets){
	                var thisSubFacet = potentialSubFacets[subFacetID];
	                
        	        var formattedSubFacet = {
        	            'name'      : thisSubFacet[ thisFacetMetadata.subFacetNameKey ],
        	            'facetKey'  : thisFacetMetadata.facetKey,
        	            'selectType' : thisFacetMetadata.selectType,
        	            'options'   : []
        	        };
        	        
        	        for(var sufFacetOptionID in thisSubFacet.options ){
        	            var thisSubFacetOption = thisSubFacet.options[sufFacetOptionID];
        	            var formattedSubFacetOption = {
        	                'name'  : thisSubFacetOption[ thisFacetMetadata.subFacetOptionNameKey ],
        	                'value' : thisSubFacetOption[ thisFacetMetadata.subFacetOptionValueKey ]
        	            }
    	                formattedSubFacet.options.append(formattedSubFacetOption);
        	        }
        	        
        	        subFacets.append( formattedSubFacet );
    	        }
	           
           	    formattedFacets[facetName] = subFacets;
           	    
           	    continue;
	        }
	        
	        var formattedThisFacet = {
	            'name'      : thisFacetMetadata.name,
	            'facetKey'  : thisFacetMetadata.facetKey,
	            'selectType' : thisFacetMetadata.selectType,
	            'options'   : []
	        };
	        
	        var potentialThisFacetOptions = potentialFilterFacets[ facetName ];
	        for( var thisFacetOptionID in potentialThisFacetOptions ){
	            
	            var thisFacetOption = potentialThisFacetOptions[thisFacetOptionID];
	            var formattedThisFacetOption = {
	                'name'  : thisFacetOption[ thisFacetMetadata.optionNameKey ],
	                'value' : thisFacetOption[ thisFacetMetadata.optionValueKey ]
	            }
	            
	            formattedThisFacet.options.append(formattedThisFacetOption);
	        }

	        formattedFacets[ facetName ] = formattedThisFacet;
	    }
	 
	 
	    formattedFacets['sorting'] = {
	        'name'       : "Sort By",
	        'facetKey'   : 'orderBy',
	        'selectType' : 'multi',
	        'options' : [{
                "name": "Price Low To High",
                "value": 'product.calculatedSalePrice|ASC',
            },{
                "name": "Price High To Low",
                "value": 'product.calculatedSalePrice|DESC',
            },{
                "name": "Product Name A-Z",
                "value": 'product.productName|ASC',
            },{
                "name": "Product Name Z-A",
                "value": 'product.productName|DESC',
            },{
                "name": "Brand A-Z",
                "value": 'brand.brandName|ASC',
            },{
                "name": "Brand Z-A",
                "value": 'brand.brandName|DESC',
            }]
	    };
	    
	    formattedFacets['price'] = {
	        'facetKey'      : 'price',
	        'name'          : "Price",
	        'selectType'    : 'single',
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
	    };
	    
	    this.logHibachi("SlatwallProductSearchService:: getFormattedFilterFacets took #getTickCount() - startTicks# ms.")
	 
	 /**   
	    
	    var categoryFacet = {
	        'id':  'categories', 
	        'name': "Categories",
	        'selectType': "single",
	        'optionValueKey' : 'categoryName',
	        'options' : []
	    };
	    for(var categoryID in potentialFilterFacets.categories ){
	        categoryFacet.options.append( potentialFilterFacets.categories[categoryID] );
	    }
	    formattedFacets['categories'] = categoryFacet;
	    
	    var productTypeFacet = {
	        'id':  'productTypes', 
	        'name': "ProductTypes",
	        'selectType': "single",
	        'optionValueKey' : 'productTypeName',
	        'options' : []
	    };
	    for(var productTypeID in potentialFilterFacets.productTypes ){
	        productTypeFacet.options.append( potentialFilterFacets.productTypes[productTypeID] );
	    }
	    formattedFacets['productTypes'] = productTypeFacet;
	    
	    
	    var brandFacet = {
	        'id':  'brands', 
	        'name': "Brands",
	        'selectType': "multi",
	        'optionValueKey' : 'brandName',
	        'options' : []
	    };
	    for(var brandID in potentialFilterFacets.brands ){
	        brandFacet.options.append( potentialFilterFacets.brands[brandID] );
	    }
	    formattedFacets['brands'] = brandFacet;
	    
	    formattedFacets['optionGroups'] = [];
	    for(var thisOptionGroupID in potentialFilterFacets.optionGroups ){
	        var thisOptionGroupFacet = potentialFilterFacets.optionGroups[thisOptionGroupID];
	        
	        var formattedOptionGroupFacet = {
    	        'id':  'options', 
    	        'name': thisOptionGroupFacet.optionGroupName,
    	        'selectType': 'multi',
    	        'optionValueKey' : 'optionName',
    	        'options' : []
    	    };
    	    for(var optionGroupOptionID in thisOptionGroupFacet.options ){
	            formattedOptionGroupFacet.options.append( thisOptionGroupFacet.options[optionGroupOptionID] );
    	    }
    	    formattedFacets.optionGroups.append( formattedOptionGroupFacet );
	    }
	    
	    formattedFacets['attributes'] = [];
	    for(var thisAttributeID in potentialFilterFacets.attributes ){
	        var thisAttributeFacet = potentialFilterFacets.attributes[thisAttributeID];
	        
	        var formattedAttributeFacet = {
    	        'id':  'attributeOptions', 
    	        'name': thisAttributeFacet.attributeName,
    	        'optionKey': 'attributeOptionValue',
    	        'selectType': 'multi',
    	        'options' : []
    	    };
    	    for(var attributeOptionID in thisAttributeFacet.options ){
	            formattedAttributeFacet.options.append( thisAttributeFacet.options[attributeOptionID] );
    	    }
    	    formattedFacets.attributes.append( formattedAttributeFacet );
	    }
	    
	    formattedFacets['sorting'] = {
	        'id': 'orderBy',
	        'name': "Sort By"
	        'selectType': 'multi',
	        'optionValueKey' : 'value',
	        
	        'options' : [{
                "name": "Price Low To High",
                "value": 'product.calculatedSalePrice|ASC',
            },{
                "name": "Price High To Low",
                "value": 'product.calculatedSalePrice|DESC',
            },{
                "name": "Product Name A-Z",
                "value": 'product.productName|ASC',
            },{
                "name": "Product Name Z-A",
                "value": 'product.productName|DESC',
            },{
                "name": "Brand A-Z",
                "value": 'brand.brandName|ASC',
            },{
                "name": "Brand Z-A",
                "value": 'brand.brandName|DESC',
            }]
	    };
	    
	    formattedFacets['price'] = {
	        'id'            : 'price',
	        'name'          : "Price",
	        'selectType'    : 'single',
	        'optionValueKey': 'value',
	 
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
	    };
	    
	    */
	    return formattedFacets;
	}
	
	
	public any function getBaseSearchCollectionData(){
        var hibachiScope = this.getHibachiScope();
        
		param name="arguments.siteID" default='';
    
        // account, order, for pricing
// 		param name="arguments.order" default=hibachiScope.getCart();
// 		param name="arguments.account" default=hibachiScope.getAccount();
		param name="arguments.priceGroupCode" default='';
	
		param name="arguments.currencyCode" default='USD';
	    
	    // facets-options	
	    param name="arguments.productType" default='';
	    param name="arguments.category" default='';
	    param name="arguments.brands" default='';
	    param name="arguments.options" default='';
	    param name="arguments.attributeOptions" default='';
	    
        // search
        param name="arguments.keyword" default=""; // TODO: multiple keywords ?
        
        // sorting
        param name="arguments.orderBy" default="product.productName|DESC"; 

        //TODO: pricing
        param name="arguments.price" default=""; 
        
        // pagination
	    param name="arguments.currentPage" default=1;
	    param name="arguments.pageSize" default=10;
	    
	    
		var collectionList = this.getProductFilterFacetOptionCollectionList();
		
		// product properties
		collectionList.setDisplayProperties('product.productID,product.productName,product.urlTitle');
		
		// sku properties 
		collectionList.addDisplayProperties('sku.skuID,sku.imageFile,sku.skuPrices.price');

        // Product's filters
        collectionList.addFilter('productActiveFlag',1);
        collectionList.addFilter('productPublishedFlag',1);
        
        collectionList.addFilter('skuActiveFlag',1);
        collectionList.addFilter('skuPublishedFlag',1);
        
        collectionList.addFilter(
            propertyIdentifier = 'product.publishedStartDateTime',
            value='NULL',
            comparisonOperator="IS",
            filterGroupAlias = 'publishedStartDateTimeFilter');
        collectionList.addFilter( 
            propertyIdentifier = 'product.publishedStartDateTime',
            value= dateTimeFormat(now(), 'short'), 
            comparisonOperator="<=", 
            logicalOperator="OR",
            filterGroupAlias = 'publishedStartDateTimeFilter');

        collectionList.addFilter(
            propertyIdentifier = 'product.publishedEndDateTime',
            value='NULL', 
            comparisonOperator="IS", 
            filterGroupAlias = 'publishedEndDateTimeFilter');
        collectionList.addFilter(
            propertyIdentifier = 'product.publishedEndDateTime',
            value= dateTimeFormat(now(), 'short'), 
            comparisonOperator=">",
            logicalOperator="OR", 
            filterGroupAlias = 'publishedEndDateTimeFilter');
        

        var site = this.getSiteService().getSite(arguments.siteID);
        
        if( !isNull(site) ){
            // site's filters
            collectionList.addFilter( 
                propertyIdentifier = 'site.siteID',
                value=site.getSiteID(), 
                comparisonOperator="=", 
                filterGroupAlias = 'productSiteFilter');
            collectionList.addFilter(
                propertyIdentifier = 'site',
                value='NULL',
                comparisonOperator="IS",
                logicalOperator="OR",
                filterGroupAlias = 'productSiteFilter');
            
            // STOCK, 
            // Q: should we add a check for if quantities exists?
            if( site.hasLocation() ){
                collectionList.addDisplayProperty('sku.stocks.calculatedQATS');
                collectionList.addFilter('sku.stocks.location.locationID', site.getLocations()[1].getLocationID());
            }
		}
        
        // SKU-Price's filters
        if( !len(arguments.currencyCode) ){
            arguments.currencyCode = !isNUll(site) ? site.setting('skuCurrency') : 'USD';
        }
        if( len(arguments.currencyCode) ){
            collectionList.addFilter(propertyIdentifier='sku.skuPrices.currencyCode', value=arguments.currencyCode, comparisonOperator="=");
        }
        
        
        
        // TODO: Solve the pricegroups later
        // var priceGroupCode =  2; // TODO: what's the default for slatwall?
        // var holdingPriceGroups = arguments.account.getPriceGroups();
        /*
            Price group is prioritized as so: 
                1. Order price group
                2. Price group passed in as argument
                3. Price group on account
                4. Default to 2
        */
        // if( !isNull(arguments.order.getPriceGroup()) ){ //order price group
        //     priceGroupCode = arguments.order.getPriceGroup().getPriceGroupCode();
        // }else if( len(arguments.priceGroupCode) ){ //argument price group
        //     priceGroupCode = arguments.priceGroupCode;
        // }else if( !isNull(holdingPriceGroups) && arrayLen(holdingPriceGroups) ){ //account price group
        //     priceGroupCode = holdingPriceGroups[1].getPriceGroupCode();
        // }
        // collectionList.addFilter(propertyIdentifier='sku.skuPrices.priceGroup.priceGroupCode', value=priceGroupCode);
    
    
        // ProductType
        if( len(arguments.productType) ){
            collectionList.addFilter('productTypeActiveFlag',1);
            collectionList.addFilter('productTypePublishedFlag',1);
            collectionList.addFilter('productTypeName', arguments.productType );
        }
        // category
        if( len(arguments.category) ){
            collectionList.addFilter('categoryName', arguments.category );
        }
        // brands
        if( len(arguments.brands) ){
            collectionList.addFilter('brandActiveFlag',1);
            collectionList.addFilter('brandPublishedFlag',1);
            collectionList.addFilter('brandName', arguments.brands, "IN" );
        }
        // options
        if( len(arguments.options) ){
            collectionList.addFilter('optionActiveFlag',1);
            collectionList.addFilter('optionCode', arguments.options, "IN" );
        }
        // Attribute options
        if( len(arguments.attributeOptions) ){
            collectionList.addFilter('attributeSetActiveFlag',1);
            collectionList.addFilter('attributeOptionValue', arguments.attributeOptions, "IN" );
        }
        
        // TODO: content products

        // Searching
        if ( len( arguments.keyword ) ) {
            
            // TODO: check if product is translated entity
            var locale = hibachiScope.getSession().getRbLocale();
            var sql = "SELECT 
                        baseID 
                        FROM swTranslation 
                        WHERE locale=:locale 
                        AND baseObject='Product' 
                        AND basePropertyName='productName'
                        AND value like :keyword";
            var params = {
                locale=locale,
                keyword='%#arguments.keyword#%'
            };
            var productIDQuery = queryExecute(sql,params);
            var productIDs = ValueList(productIDQuery.baseID);
            
            collectionList.addFilter(
                propertyIdentifier='product.productName', 
                value='%#arguments.keyword#%', 
                comparisonOperator='LIKE', 
                filterGroupAlias='keyword');
            collectionList.addFilter(
                propertyIdentifier='product.productID', 
                value=productIDs,
                comparisonOperator='IN',
                logicalOperator='OR', 
                filterGroupAlias='keyword');
        }
        
        // TODO: other inline filters, like price-range, reviews ....
 
        // Sorting
        collectionList.setOrderBy(arguments.orderBy);
        
        // Pagination
        collectionList.setPageRecordsShow( arguments.pageSize );
        collectionList.setCurrentPageDeclaration(arguments.currentPage);
        
        return { 
            'currencyCode': currencyCode,
            'priceGroupCode': priceGroupCode,
            'collectionList': collectionList
        };
    }


	public struct function getProducts(){
	    var hibachiScope = this.getHibachiScope();
        
		param name="arguments.siteID" default='';
    
        // account, order, for pricing
// 		param name="arguments.order" default=hibachiScope.getCart();
// 		param name="arguments.account" default=hibachiScope.getAccount();
// 		param name="arguments.priceGroupCode" default='';
	
		param name="arguments.currencyCode" default='USD';
	    
	    // facets-options	
	    param name="arguments.productType" default='';
	    param name="arguments.category" default='';
	    param name="arguments.brands" default='';
	    param name="arguments.options" default='';
	    param name="arguments.attributeOptions" default='';
	    
        // Search
        param name="arguments.keyword" default="";
        // Sorting
        param name="arguments.orderBy" default="product.productName|DESC"; 
        // Pricing
        param name="arguments.price" default=""; 
        // Pagination
	    param name="arguments.currentPage" default=1;
	    param name="arguments.pageSize" default=10;
	    
	    param name="arguments.includePotentialFilters" default=true;

	 
	    var collectionData = this.getBaseSearchCollectionData(argumentCollection=arguments);
	    
	    var startTicks = getTickCount();
	    var total = collectionData.collectionList.getRecordsCount();
	    this.logHibachi("SlatwallProductSearchService:: getProducts/getRecordsCount took #getTickCount() - startTicks# ms.");
        
        startTicks = getTickCount();
	    var records = collectionData.collectionList.getPageRecords();
	    this.logHibachi("SlatwallProductSearchService:: getProducts/getPageRecords [p:#arguments.currentPage#(#arguments.pageSize#)] took #getTickCount() - startTicks# ms.");

	    var resultSet = {
	        'total' : total,
	        'pageSize': arguments.pageSize,
	        'currentPage' : arguments.currentPage,
	        'currencyCode': collectionData.currencyCode,
	        'priceGroupCode': collectionData.priceGroupCode,
	        
	        'products' : records
	    };
	    
	        
	    if( arguments.includePotentialFilters ){
    	    var potentialFilters = this.getPotentialFilterFacetsAndOptions(argumentCollection=arguments);
	        resultSet['potentialFilters'] = this.getFormattedFilterFacets(potentialFilters);
	    }
	    
	    return resultSet;

	}
	

	
	
	
	/**
     * 
     *                              ********* NOT IN USE *********
     * 
     */
	
	
		
	// ===================== :Product Filters: =================================
	
	/**
	 * Function to return some meta-data about product-listing filter facets
	 * Meant to be overriden for different use-cases, Keeping is asside from `getProductFilterFacetOptions`, for that reason only
	 * 
	 * 
	 * priority : is how filter-groups are going to be applied, less is first, more is later
	 * 
	*/
	public array function getProductFilterFacets(){
	    // TODO: multi select attributes
	    return [
    	        {   'id'            : 'sites',
    	            'priority'      : 1,
    	            'facetType'     : 'internal',
    	            'selectType'    : 'single'
    	        },
    	        
    	        {   'id'                : 'productTypes',
    	            'priority'          : 2,
    	            'facetType'         : 'internal',
    	            'selectType'        : 'single',
    	            'parentFacetName'   : 'productTypes',
    	            'parentFacetOptionIDKey': 'productTypeID'
    	        },
    	        
    	        {   'id'                : 'categories',
    	            'priority'          : 3,
    	            'selectType'        : 'multi',
    	            'parentFacetName'   : 'categories',
    	            'parentFacetOptionIDKey': 'categoryID'
    	        },
	            
	            {   'id'            : 'brands',
    	            'priority'      : 4,
    	            'selectType'    : 'multi'
    	        },
    	        
	            {   'id'            : 'optionGroups',
    	            'priority'      : 5,
    	            'facetType'     : 'internal',
    	            'selectType'    : 'multi'
    	        },
    	        
    	        {   'id'            : 'options',
    	            'priority'      : 6,
    	            'selectType'    : 'multi',
    	            'parentFacetName' : 'optionGroups',
    	            'parentFacetOptionIDKey' : 'optionGroupID'
    	        },
    	        
    	        {   'id'            : 'attributeSets',
    	            'priority'      : 7,
    	            'facetType'     : 'internal',
    	            'selectType'    : 'multi'
    	        },
    	        
    	        {   'id'            : 'attributes',
    	            'priority'      : 8,
    	            'facetType'     : 'internal',
    	            'selectType'    : 'multi',
    	            'parentFacetName' : 'attributeSets',
    	            'parentFacetOptionIDKey' : 'attributeSetID'
    	        },
    	        
    	        {   'id'            : 'attributeOptions',
    	            'priority'      : 9,
    	            'selectType'    : 'multi',
    	            'parentFacetName' : 'attributes',
    	            'parentFacetOptionIDKey' : 'attributeID'
    	        }
    	   ];
	}
	
	
	
	
	
	// TODO: remove, not in use
	public any function getProductFilterFacetOptionBaseCollectionList(){
	   var facetOptionCollectionList = this.getProductFilterFacetOptionCollectionList();
	   
	   facetOptionCollectionList.addFilter('skuActiveFlag', 1);
	   facetOptionCollectionList.addFilter('skuPublishedFlag', 1);
	   
	   facetOptionCollectionList.addFilter('productActiveFlag', 1);
	   facetOptionCollectionList.addFilter('productPublishedFlag', 1);

	   facetOptionCollectionList.addFilter('brandActiveFlag', 1);
	   facetOptionCollectionList.addFilter('brandPublishedFlag', 1);
	   
	   facetOptionCollectionList.addFilter('productTypeActiveFlag', 1);
	   facetOptionCollectionList.addFilter('productTypePublishedFlag', 1);
	   
	   facetOptionCollectionList.addFilter('sku.skuPrices', "NULL", "IS NOT");
	   facetOptionCollectionList.addFilter('sku.skuPrices.activeFlag', 1);
	   
	   
   	   facetOptionCollectionList.addFilter('optionActiveFlag', 1);
	   facetOptionCollectionList.addFilter('attributeSetActiveFlag', 1);

	   return facetOptionCollectionList;
	}
	
	
    /**
     * 
     * ********* NOT IN USE *****
     * 
     * 
	 * Function to fetch, Brand, ProductType, OptionGroups, and Options 
	 * [ only then ones which are active and published including the active and published products ]
	 * and then construct some hashmaps for faster lookup;
	 * this function caches the calculated meta-data which is supposed to be cleared, every time any one of the given entity is saved in the DB;
	 * 
	*/
	public struct function getProductFilterFacetOptions(){
	    
	    if(this.getHibachiCacheService().hasCachedValue('calculated_product_filter_facet_options') ){
	        return this.getHibachiCacheService().getCachedValue('calculated_product_filter_facet_options');
	    }
	    
	    this.logHibachi("SlatwallProductSearchService:: getProductFilterFacetOptions - fetching raw facet options ")

	    var rawFilters = this.getSlatwallProductSearchDAO().getPotentialProductFilterFacetOptions();
	   
	    var startTicks = getTickCount();
	    
        // we're using hash-maps for :
        // - duplicate-removal 
        // - faster lookups 
	    var potentialFilters = {
	        'sites'             : {},
	        'brands'            : {},
	        'options'           : {},
	        'categories'        : {},
	        'attributes'        : {},
	        'optionGroups'      : {},
	        'productTypes'      : {},
	        'attributeSets'     : {},
	        'attributeOptions'  : {}
	    };
	    
	    
	       	
       	this.logHibachi("SlatwallProductSearchService:: getProductFilterFacetOptions - processing - #rawFilters.recordCount# ");
            
	    for( var row in rawFilters ){
	        
	        // ****** Site - Filter
	        if( !isNull(row.siteID) && !this.hibachiIsEmpty(row.siteID) ){
    	        if( structKeyExists(potentialFilters.sites, row.siteID ) ){
    	           var thisSiteFilter =  potentialFilters.sites[ row.siteID ]; 
    	        } else {
    	            var thisSiteFilter = {
    	                'siteID'              : row.siteID,
    	                'siteName'            : row.siteName,
    	                'siteCode'            : row.siteCode,
    	                'currencyCode'        : row.currencyCode,
    	                'relations' : {
        	                'brands'          : {},
        	                'options'         : {},
        	                'categories'      : {},
        	                'attributes'      : {},
        	                'optionGroups'    : {},
        	                'productTypes'    : {},
        	                'attributeSets'   : {},
        	                'attributeOptions': {}
    	                }
    	            };
    	            
    	            potentialFilters.sites[ row.siteID ] = thisSiteFilter;
    	        }
    	        
    	        if(!isNull(row.brandID) && !this.hibachiIsEmpty(row.brandID)){
    	            thisSiteFilter.relations.brands[ row.brandID ] = row.brandID;
    	        }
    	        if(!isNull(row.optionID) && !this.hibachiIsEmpty(row.optionID)){
    	            thisSiteFilter.relations.options[ row.optionID ] = row.optionID;
    	        }
    	        if(!isNull(row.categoryID) && !this.hibachiIsEmpty(row.categoryID)){
    	            thisSiteFilter.relations.categories[ row.categoryID ] = row.categoryID;
    	        }
                if(!isNull(row.productTypeID) && !this.hibachiIsEmpty(row.productTypeID)){
    	            thisSiteFilter.relations.productTypes[ row.productTypeID ] = row.productTypeID;
                }
                if(!isNull(row.optionGroupID) && !this.hibachiIsEmpty(row.optionGroupID)){
    	            thisSiteFilter.relations.optionGroups[ row.optionGroupID ] = row.optionGroupID;
                }
                if(!isNull(row.attributeID) && !this.hibachiIsEmpty(row.attributeID)){
    	            thisSiteFilter.relations.attributes[ row.attributeID ] = row.attributeID;
                }
                if(!isNull(row.attributeOptionID) && !this.hibachiIsEmpty(row.attributeOptionID)){
    	            thisSiteFilter.relations.attributeOptions[ row.attributeOptionID ] = row.attributeOptionID;
                }
                if(!isNull(row.attributeSetID) && !this.hibachiIsEmpty(row.attributeSetID)){
    	            thisSiteFilter.relations.attributeSets[ row.attributeSetID ] = row.attributeSetID;
                }
	        }
	        
	        // ****** Category - Filter
	        if( !isNull(row.categoryID) && !this.hibachiIsEmpty(row.categoryID) ){
    	        if( structKeyExists(potentialFilters.options, row.categoryID ) ){
    	           var thisCategoryFilter =  potentialFilters.categories[ row.categoryID ]; 
    	        } else {
    	            var thisCategoryFilter = {
    	                'categoryID'            : row.categoryID,
    	                'categoryName'          : row.categoryName,
    	                'categoryUrlTitle'      : row.categoryUrlTitle,
    	                'parentCategoryID'      : row.parentCategoryID,
    	                'relations' : {
        	                'sites'           : {},
        	                'brands'          : {},
        	                'options'         : {},
        	                'attributes'      : {},
        	                'optionGroups'    : {},
        	                'productTypes'    : {},
        	                'attributeSets'   : {},
        	                'attributeOptions': {}
    	                }
    	            };
    	            
    	            potentialFilters.categories[ row.optionID ] = thisCategoryFilter;
    	        }
    	        
    	        if( !isNull(row.siteID) && !this.hibachiIsEmpty(row.siteID)){
    	            thisCategoryFilter.relations.sites[ row.siteID ] = row.siteID;
    	        }
    	        if(!isNull(row.brandID) && !this.hibachiIsEmpty(row.brandID)){
    	            thisCategoryFilter.relations.brands[ row.brandID ] = row.brandID;
    	        }
    	        if(!isNull(row.optionID) && !this.hibachiIsEmpty(row.optionID)){
    	            thisCategoryFilter.relations.options[ row.optionID ] = row.optionID;
    	        }
                if(!isNull(row.productTypeID) && !this.hibachiIsEmpty(row.productTypeID)){
    	            thisCategoryFilter.relations.productTypes[ row.productTypeID ] = row.productTypeID;
                }
                if(!isNull(row.optionGroupID) && !this.hibachiIsEmpty(row.optionGroupID)){
    	            thisCategoryFilter.relations.optionGroups[ row.optionGroupID ] = row.optionGroupID;
                }
                if(!isNull(row.attributeID) && !this.hibachiIsEmpty(row.attributeID)){
    	            thisCategoryFilter.relations.attributes[ row.attributeID ] = row.attributeID;
                }
                if(!isNull(row.attributeOptionID) && !this.hibachiIsEmpty(row.attributeOptionID)){
    	            thisCategoryFilter.relations.attributeOptions[ row.attributeOptionID ] = row.attributeOptionID;
                }
                if(!isNull(row.attributeSetID) && !this.hibachiIsEmpty(row.attributeSetID)){
    	            thisCategoryFilter.relations.attributeSets[ row.attributeSetID ] = row.attributeSetID;
                }
	        }
	        
	        // ****** Brand - Filter
	        if( !isNull(row.brandID) && !this.hibachiIsEmpty(row.brandID) ){
    	        if( structKeyExists(potentialFilters.brands, row.brandID ) ){
    	           var thisBrandFilter =  potentialFilters.brands[ row.brandID ]; 
    	        } else {
    	            var thisBrandFilter = {
    	                'brandID'              : row.brandID,
    	                'brandName'            : row.brandName,
    	                'relations' : {
        	                'sites'           : {},
        	                'options'         : {},
        	                'categories'      : {},
        	                'attributes'      : {},
        	                'optionGroups'    : {},
        	                'productTypes'    : {},
        	                'attributeSets'   : {},
        	                'attributeOptions': {}
    	                }
    	            };
    	            
    	            potentialFilters.brands[ row.brandID ] = thisBrandFilter;
    	        }
    	        
    	        if(!isNull(row.optionID) && !this.hibachiIsEmpty(row.optionID)){
    	            thisBrandFilter.relations.options[ row.optionID ] = row.optionID;
    	        }
    	        if( !isNull(row.siteID) && !this.hibachiIsEmpty(row.siteID)){
    	            thisBrandFilter.relations.sites[ row.siteID ] = row.siteID;
    	        }
    	        if(!isNull(row.categoryID) && !this.hibachiIsEmpty(row.categoryID)){
    	            thisBrandFilter.relations.categories[ row.categoryID ] = row.categoryID;
    	        }
                if(!isNull(row.productTypeID) && !this.hibachiIsEmpty(row.productTypeID)){
    	            thisBrandFilter.relations.productTypes[ row.productTypeID ] = row.productTypeID;
                }
                if(!isNull(row.optionGroupID) && !this.hibachiIsEmpty(row.optionGroupID)){
    	            thisBrandFilter.relations.optionGroups[ row.optionGroupID ] = row.optionGroupID;
                }
                if(!isNull(row.attributeID) && !this.hibachiIsEmpty(row.attributeID)){
    	            thisBrandFilter.relations.attributes[ row.attributeID ] = row.attributeID;
                }
                if(!isNull(row.attributeOptionID) && !this.hibachiIsEmpty(row.attributeOptionID)){
    	            thisBrandFilter.relations.attributeOptions[ row.attributeOptionID ] = row.attributeOptionID;
                }
                if(!isNull(row.attributeSetID) && !this.hibachiIsEmpty(row.attributeSetID)){
    	            thisBrandFilter.relations.attributeSets[ row.attributeSetID ] = row.attributeSetID;
                }
	        }
	        
	        // ****** Option - Filter
	        if( !isNull(row.optionID) && !this.hibachiIsEmpty(row.optionID) ){
    	        if( structKeyExists(potentialFilters.options, row.optionID ) ){
    	           var thisOptionFilter =  potentialFilters.options[ row.optionID ]; 
    	        } else {
    	            var thisOptionFilter = {
    	                'optionID'              : row.optionID,
    	                'optionCode'            : row.optionCode,
    	                'optionName'            : row.optionName,
    	                'optionGroupID'         : row.optionGroupID,
    	                'sortOrder'             : row.optionSortOrder,
    	                'relations' : {
        	                'sites'           : {},
        	                'brands'          : {},
        	                'categories'      : {},
        	                'attributes'      : {},
        	                'optionGroups'    : {},
        	                'productTypes'    : {},
        	                'attributeSets'   : {},
        	                'attributeOptions': {}
    	                }
    	            };
    	            
    	            potentialFilters.options[ row.optionID ] = thisOptionFilter;
    	        }
    	        
    	        if( !isNull(row.siteID) && !this.hibachiIsEmpty(row.siteID)){
    	            thisOptionFilter.relations.sites[ row.siteID ] = row.siteID;
    	        }
    	        if(!isNull(row.brandID) && !this.hibachiIsEmpty(row.brandID)){
    	            thisOptionFilter.relations.brands[ row.brandID ] = row.brandID;
    	        }
    	        if(!isNull(row.categoryID) && !this.hibachiIsEmpty(row.categoryID)){
    	            thisOptionFilter.relations.categories[ row.categoryID ] = row.categoryID;
    	        }
                if(!isNull(row.productTypeID) && !this.hibachiIsEmpty(row.productTypeID)){
    	            thisOptionFilter.relations.productTypes[ row.productTypeID ] = row.productTypeID;
                }
                if(!isNull(row.optionGroupID) && !this.hibachiIsEmpty(row.optionGroupID)){
    	            thisOptionFilter.relations.optionGroups[ row.optionGroupID ] = row.optionGroupID;
                }
                if(!isNull(row.attributeID) && !this.hibachiIsEmpty(row.attributeID)){
    	            thisOptionFilter.relations.attributes[ row.attributeID ] = row.attributeID;
                }
                if(!isNull(row.attributeOptionID) && !this.hibachiIsEmpty(row.attributeOptionID)){
    	            thisOptionFilter.relations.attributeOptions[ row.attributeOptionID ] = row.attributeOptionID;
                }
                if(!isNull(row.attributeSetID) && !this.hibachiIsEmpty(row.attributeSetID)){
    	            thisOptionFilter.relations.attributeSets[ row.attributeSetID ] = row.attributeSetID;
                }
	        }
	        
	        // ****** OptionGroups - Filter
	        if( !isNull(row.optionGroupID) && !this.hibachiIsEmpty(row.optionGroupID) ){
    	        if( structKeyExists(potentialFilters.optionGroups, row.optionGroupID ) ){
    	           var thisOptionGroupFilter =  potentialFilters.optionGroups[ row.optionGroupID ]; 
    	        } else {
    	            var thisOptionGroupFilter = {
    	                'optionGroupID'             : row.optionGroupID,
    	                'optionGroupName'           : row.optionGroupName,
    	                'sortOrder'                 : row.optionGroupSortOrder,
    	                'relations' : {
        	                'sites'           : {},
        	                'brands'          : {},
        	                'options'         : {},
        	                'categories'      : {},
        	                'attributes'      : {},
        	                'productTypes'    : {},
        	                'attributeSets'   : {},
        	                'attributeOptions': {}
    	                }
    	            };
    	            
    	            potentialFilters.optionGroups[ row.optionGroupID ] = thisOptionGroupFilter;
    	        }
    	        
    	        if( !isNull(row.siteID) && !this.hibachiIsEmpty(row.siteID)){
    	            thisOptionGroupFilter.relations.sites[ row.siteID ] = row.siteID;
    	        }
    	        if(!isNull(row.brandID) && !this.hibachiIsEmpty(row.brandID)){
    	            thisOptionGroupFilter.relations.brands[ row.brandID ] = row.brandID;
    	        }
                if(!isNull(row.optionID) && !this.hibachiIsEmpty(row.optionID)){
    	            thisOptionGroupFilter.relations.options[ row.optionID ] = row.optionID;
                }
    	        if(!isNull(row.categoryID) && !this.hibachiIsEmpty(row.categoryID)){
    	            thisOptionGroupFilter.relations.categories[ row.categoryID ] = row.categoryID;
    	        }
                if(!isNull(row.productTypeID) && !this.hibachiIsEmpty(row.productTypeID)){
    	            thisOptionGroupFilter.relations.productTypes[ row.productTypeID ] = row.productTypeID;
                }
                if(!isNull(row.attributeID) && !this.hibachiIsEmpty(row.attributeID)){
    	            thisOptionGroupFilter.relations.attributes[ row.attributeID ] = row.attributeID;
                }
                if(!isNull(row.attributeOptionID) && !this.hibachiIsEmpty(row.attributeOptionID)){
    	            thisOptionGroupFilter.relations.attributeOptions[ row.attributeOptionID ] = row.attributeOptionID;
                }
                if(!isNull(row.attributeSetID) && !this.hibachiIsEmpty(row.attributeSetID)){
    	            thisOptionGroupFilter.relations.attributeSets[ row.attributeSetID ] = row.attributeSetID;
                }
	        }
	        
	        // ****** ProductType - Filter
	        if( !isNull(row.productTypeID) && !this.hibachiIsEmpty(row.productTypeID) ){
    	        if( structKeyExists(potentialFilters.productTypes, row.productTypeID ) ){
    	           var thisProductTypeFilter =  potentialFilters.productTypes[ row.productTypeID ]; 
    	        } else {
    	            var thisProductTypeFilter = {
    	                'productTypeID'              : row.productTypeID,
    	                'productTypeName'            : row.productTypeName,
    	                'productTypeURLTitle'        : row.productTypeURLTitle,
    	                'parentProductTypeID'        : row.parentProductTypeID,
    	                'relations' : {
    	                    'sites'           : {},
        	                'brands'          : {},
        	                'options'         : {},
        	                'categories'      : {},
        	                'attributes'      : {},
        	                'optionGroups'    : {},
        	                'attributeSets'   : {},
        	                'attributeOptions': {}
    	                }
    	            };
    	            
    	            potentialFilters.productTypes[ row.productTypeID ] = thisProductTypeFilter;
    	        }
    	        
    	        if( !isNull(row.siteID) && !this.hibachiIsEmpty(row.siteID)){
    	            thisProductTypeFilter.relations.sites[ row.siteID ] = row.siteID;
    	        }
    	        if(!isNull(row.brandID) && !this.hibachiIsEmpty(row.brandID)){
    	            thisProductTypeFilter.relations.brands[ row.brandID ] = row.brandID;
    	        }
                if(!isNull(row.optionID) && !this.hibachiIsEmpty(row.optionID)){
    	            thisProductTypeFilter.relations.options[ row.optionID ] = row.optionID;
                }
    	        if(!isNull(row.categoryID) && !this.hibachiIsEmpty(row.categoryID)){
    	            thisProductTypeFilter.relations.categories[ row.categoryID ] = row.categoryID;
    	        }
                if(!isNull(row.optionGroupID) && !this.hibachiIsEmpty(row.optionGroupID)){
    	            thisProductTypeFilter.relations.optionGroups[ row.optionGroupID ] = row.optionGroupID;
                }
                if(!isNull(row.attributeID) && !this.hibachiIsEmpty(row.attributeID)){
    	            thisProductTypeFilter.relations.attributes[ row.attributeID ] = row.attributeID;
                }
                if(!isNull(row.attributeOptionID) && !this.hibachiIsEmpty(row.attributeOptionID)){
    	            thisProductTypeFilter.relations.attributeOptions[ row.attributeOptionID ] = row.attributeOptionID;
                }
                if(!isNull(row.attributeSetID) && !this.hibachiIsEmpty(row.attributeSetID)){
    	            thisProductTypeFilter.relations.attributeSets[ row.attributeSetID ] = row.attributeSetID;
                }
	        }
	        
	        
	        // ****** Attribute - Filter
	        if( !isNull(row.attributeID) && !this.hibachiIsEmpty(row.attributeID) ){
    	        if( structKeyExists(potentialFilters.attributes, row.attributeID ) ){
    	           var thisAttributeFilter =  potentialFilters.attributes[ row.attributeID ]; 
    	        } else {
    	            var thisAttributeFilter = {
    	                'attributeID'              : row.attributeID,
    	                'attributeSetID'           : row.attributeSetID,
    	                'attributeName'            : row.attributeName,
    	                'attributeCode'            : row.attributeCode,
    	                'urlTitle'                 : row.attributeUrlTitle,
    	                'sortOrder'                : row.attributeSortOrder,
    	                'attributeInputType'       : row.attributeInputType,
    	                'relations' : {
    	                    'sites'           : {},
        	                'brands'          : {},
        	                'options'         : {},
        	                'categories'      : {},
        	                'optionGroups'    : {},
        	                'productTypes'    : {},
        	                'attributeSets'   : {},
        	                'attributeOptions': {}
    	                }
    	            };
    	            
    	            potentialFilters.attributes[ row.attributeID ] = thisAttributeFilter;
    	        }
    	        
    	        if( !isNull(row.siteID) && !this.hibachiIsEmpty(row.siteID)){
    	            thisAttributeFilter.relations.sites[ row.siteID ] = row.siteID;
    	        }
    	        if(!isNull(row.brandID) && !this.hibachiIsEmpty(row.brandID)){
    	            thisAttributeFilter.relations.brands[ row.brandID ] = row.brandID;
    	        }
                if(!isNull(row.optionID) && !this.hibachiIsEmpty(row.optionID)){
    	            thisAttributeFilter.relations.options[ row.optionID ] = row.optionID;
                }
    	        if(!isNull(row.categoryID) && !this.hibachiIsEmpty(row.categoryID)){
    	            thisAttributeFilter.relations.categories[ row.categoryID ] = row.categoryID;
    	        }
                if(!isNull(row.optionGroupID) && !this.hibachiIsEmpty(row.optionGroupID)){
    	            thisAttributeFilter.relations.optionGroups[ row.optionGroupID ] = row.optionGroupID;
                }
                if(!isNull(row.productTypeID) && !this.hibachiIsEmpty(row.productTypeID)){
    	            thisAttributeFilter.relations.productTypes[ row.productTypeID ] = row.productTypeID;
                }
                if(!isNull(row.attributeOptionID) && !this.hibachiIsEmpty(row.attributeOptionID)){
    	            thisAttributeFilter.relations.attributeOptions[ row.attributeOptionID ] = row.attributeOptionID;
                }
                if(!isNull(row.attributeSetID) && !this.hibachiIsEmpty(row.attributeSetID)){
    	            thisAttributeFilter.relations.attributeSets[ row.attributeSetID ] = row.attributeSetID;
                }
	        }
	        
	        
	        // ****** Attribute-set - Filter
	        if( !isNull(row.attributeSetID) && !this.hibachiIsEmpty(row.attributeSetID) ){
    	        if( structKeyExists(potentialFilters.attributeSets, row.attributeSetID ) ){
    	           var thisAttributeSetFilter =  potentialFilters.attributeSets[ row.attributeSetID ]; 
    	        } else {
    	            var thisAttributeSetFilter = {
    	                'attributeSetID'              : row.attributeSetID,
    	                'attributeSetName'            : row.attributeSetName,
    	                'attributeSetCode'            : row.attributeSetCode,
    	                'attributeSetObject'          : row.attributeSetObject,
    	                'sortOrder'                   : row.attributeSetSortOrder,
    	                'relations' : {
    	                    'sites'           : {},
        	                'brands'          : {},
        	                'options'         : {},
        	                'categories'      : {},
        	                'attributes'      : {},
        	                'optionGroups'    : {},
        	                'productTypes'    : {},
        	                'attributeOptions': {}
    	                }
    	            };
    	            
    	            potentialFilters.attributeSets[ row.attributeSetID ] = thisAttributeSetFilter;
    	        }
    	        
    	        if( !isNull(row.siteID) && !this.hibachiIsEmpty(row.siteID)){
    	            thisAttributeSetFilter.relations.sites[ row.siteID ] = row.siteID;
    	        }
    	        if(!isNull(row.brandID) && !this.hibachiIsEmpty(row.brandID)){
    	            thisAttributeSetFilter.relations.brands[ row.brandID ] = row.brandID;
    	        }
                if(!isNull(row.optionID) && !this.hibachiIsEmpty(row.optionID)){
    	            thisAttributeSetFilter.relations.options[ row.optionID ] = row.optionID;
                }
    	        if(!isNull(row.categoryID) && !this.hibachiIsEmpty(row.categoryID)){
    	            thisAttributeSetFilter.relations.categories[ row.categoryID ] = row.categoryID;
    	        }
                if(!isNull(row.optionGroupID) && !this.hibachiIsEmpty(row.optionGroupID)){
    	            thisAttributeSetFilter.relations.optionGroups[ row.optionGroupID ] = row.optionGroupID;
                }
                if(!isNull(row.productTypeID) && !this.hibachiIsEmpty(row.productTypeID)){
    	            thisAttributeSetFilter.relations.productTypes[ row.productTypeID ] = row.productTypeID;
                }
                if(!isNull(row.attributeID) && !this.hibachiIsEmpty(row.attributeID)){
    	            thisAttributeSetFilter.relations.attributes[ row.attributeID ] = row.attributeID;
                }
                if(!isNull(row.attributeOptionID) && !this.hibachiIsEmpty(row.attributeOptionID)){
    	            thisAttributeSetFilter.relations.attributeOptions[ row.attributeOptionID ] = row.attributeOptionID;
                }
	        }
	        
	        
	        // ****** Attribute-option - Filter
	        if( !isNull(row.attributeOptionID) && !this.hibachiIsEmpty(row.attributeOptionID) ){
    	        if( structKeyExists(potentialFilters.attributeOptions, row.attributeOptionID ) ){
    	           var thisAttributeOptionFilter =  potentialFilters.attributeOptions[ row.attributeOptionID ]; 
    	        } else {
    	            
    	            var thisAttributeOptionFilter = {
    	                'attributeID'                    : row.attributeID,
    	                'attributeOptionID'              : row.attributeOptionID,
    	                'attributeOptionLabel'           : row.attributeOptionLabel,
    	                'attributeOptionValue'           : row.attributeOptionValue,
    	                'urlTitle'                       : row.attributeOptionUrlTitle,
    	                'sortOrder'                      : row.attributeOptionSortOrder,
    	                'relations' : {
    	                    'sites'           : {},
        	                'brands'          : {},
        	                'options'         : {},
        	                'categories'      : {},
        	                'attributes'      : {},
        	                'optionGroups'    : {},
        	                'productTypes'    : {},
        	                'attributeSets': {}
    	                }
    	            };
    	            
    	            potentialFilters.attributeOptions[ row.attributeOptionID ] = thisAttributeOptionFilter;
    	        }
    	        
    	        if( !isNull(row.siteID) && !this.hibachiIsEmpty(row.siteID)){
    	            thisAttributeOptionFilter.relations.sites[ row.siteID ] = row.siteID;
    	        }
    	        if(!isNull(row.brandID) && !this.hibachiIsEmpty(row.brandID)){
    	            thisAttributeOptionFilter.relations.brands[ row.brandID ] = row.brandID;
    	        }
                if(!isNull(row.optionID) && !this.hibachiIsEmpty(row.optionID)){
    	            thisAttributeOptionFilter.relations.options[ row.optionID ] = row.optionID;
                }
    	        if(!isNull(row.categoryID) && !this.hibachiIsEmpty(row.categoryID)){
    	            thisAttributeOptionFilter.relations.categories[ row.categoryID ] = row.categoryID;
    	        }
                if(!isNull(row.optionGroupID) && !this.hibachiIsEmpty(row.optionGroupID)){
    	            thisAttributeOptionFilter.relations.optionGroups[ row.optionGroupID ] = row.optionGroupID;
                }
                if(!isNull(row.productTypeID) && !this.hibachiIsEmpty(row.productTypeID)){
    	            thisAttributeOptionFilter.relations.productTypes[ row.productTypeID ] = row.productTypeID;
                }
                if(!isNull(row.attributeID) && !this.hibachiIsEmpty(row.attributeID)){
    	            thisAttributeOptionFilter.relations.attributes[ row.attributeID ] = row.attributeID;
                }
                if(!isNull(row.attributeSetID) && !this.hibachiIsEmpty(row.attributeSetID)){
    	            thisAttributeSetFilter.relations.attributeSets[ row.attributeSetID ] = row.attributeSetID;
                }
	        }
	       
   	        // processed++;
	    }
   
	    this.getHibachiCacheService().setCachedValue('calculated_product_filter_facet_options', potentialFilters);

	    this.logHibachi("SlatwallProductSearchService:: getProductFilterFacetOptions took #getTickCount() - startTicks# ms.")

	    return potentialFilters;
	}
	
	
	/**
	 * Helper function to validate if passed-in facet-options are availabe in availableFacetOptions
	*/
	public struct function validateSelectedFacetOptions(required struct selectedFacets ){
	    param name="arguments.selectedFacets.brands" default=[];
	    param name="arguments.selectedFacets.options" default=[];
	    param name="arguments.selectedFacets.optionGroups" default=[];
	    param name="arguments.selectedFacets.productTypes" default=[];
	    
	    if( this.hibachiIsStructEmpty(arguments.selectedFacets) ){
	        return true; // nothing is selected so nothing to validate;
	    }
	    
	    var availableFcets = this.getProductFilterFacets();

        var invalidOptionFound = false;
	    for(var thisFacet in arguments.availableFcets ){
	        var selectedThisFacetOptions = arguments.selectedFacets[ thisFacet.id ];
	        
	        if(selectedThisFacetOptions.isEmpty() ){
	            continue; // again nothing to validate
	        }
	        
	        var invalidOptionFound = this.validateFacetOptionsForInvalidIDs(thisFacet, selectedThisFacetOptions);
	        
	        if(!invalidOptionFound && thisFacet.selectType == 'single' ){
	            invalidOptionFound = !this.areSelectedFacetOptionsValidForSingleSelect(thisFacet, selectedThisFacetOptions);
	        }
	        
	        if(invalidOptionFound){
	            return false;
	        }
	    }
	    
	    return true;
	}
	
	public boolean function validateFacetOptionsForInvalidIDs(required struct facet, required array selectedOptions ){
        
        var availabelThisFacetOptions = this.getProductFilterFacetOptions()[ arguments.facet.id ];
        for(var optionID in arguments.selectedOptions ){
            if(!structKeyExists(availabelThisFacetOptions, optionID) ){
                return false;
            }
        }
        
        return true;
	}

	// TODO: 
	public boolean function validateFacetOptionsForSingleSelect(required struct facet, required array selectedOptions){
        
        var availablefacetOptions = this.getProductFilterFacetOptions();
        
        var invalidOptionFound = false;
        var selectedChildOptionsCount  = 0;
        for(var optionID in arguments.selectedOptions ){

            var selectedThisFacetOption = availablefacetOptions[ arguments.facet.id ][ optionID ];
            var parentFacetOptionsID = selectedThisFacetOption[ arguments.facet.parentFacetOptionIDKey ];
            var parentFacetOption = availableFacetOptions[ arguments.facet.parentFacetName ][ parentFacetOptionsID ];
            var parentFacetRelationsWithThisFacet = parentFacetOption.relations[ arguments.facet.id  ];
            
            selectedChildOptionsCount  = 0; //reset
            for(var optionID2 in arguments.selectedOptions ){
                if(structKeyExists(parentFacetRelationsWithThisFacet, optionID2) ){
                    selectedChildOptionsCount++;
                    if( selectedChildOptionsCount>1 ){
                        invalidOptionFound = true;
                        break;
                    }   
                }
            }
            
            if(invalidOptionFound){
                return false;
            }
        }

	    return true;
	}
	
	
	public struct function calculatePopentialFaceteOptionsForSelectedFacetOptions(required struct selectedFacets ){
	    param name="arguments.selectedFacets.brands" default=[];
	    param name="arguments.selectedFacets.options" default=[];
	    param name="arguments.selectedFacets.optionGroups" default=[];
	    param name="arguments.selectedFacets.productTypes" default=[];

        var facets = this.getProductFilterFacets();

        // creating a copy here as we don't want to modify the cached data;
        var potentialFacetOptions =  structCopy( this.getProductFilterFacetOptions() );
        
        for(var thisFacet in facets){
            var thisFacetHasSelectedFilters = structKeyExists(arguments.selectedFacets, thisFacet.id) && !arguments.selectedFacets[thisFacet.id].isEmpty();

            // calculate available options for this-facet
            if( !thisFacetHasSelectedFilters ){
                continue;
                // nothing to do, and all of the other available facet options are potential options
            }
            
            // get the selected-option's structs, so we can calculate the relatated facet-options
            var selectedThisFacetOptions = {};
            
            var potentialThisFacetOptions =  potentialFacetOptions[ thisFacet.id ];
            for(var facetOptionID in arguments.selectedFacets[thisFacet.id] ){
                if(structKeyExists(potentialThisFacetOptions, facetOptionID) ){
                    selectedThisFacetOptions[ facetOptionID ] = potentialThisFacetOptions[ facetOptionID ];
                }
            }

            // now calculate options for remainig facets, by eliminating whatever is not-related to selected-facet-options
            for( var otherFacet in facets ){
                
                if(otherFacet.id == thisFacet.id ){
                    continue;
                }
                
                var filteredOtherFacetOptions = {}; // e.g. potential-brands, related to selected product-types
                var potentialOtherFacetOptions = potentialFacetOptions[ otherFacet.id ]; // e.g. potential-remaining brands or options

                //e.g. selected product-types/brands
                for(var thisFacetOptionID in selectedThisFacetOptions){

                    var selectedThisFacetOption = selectedThisFacetOptions[ thisFacetOptionID ]; // e.g. selected ptoducy-type
                    var thisOptionRelationsWithOtherFacet = selectedThisFacetOption.relations[ otherFacet.id ]; // e.g. this productType's brands, or this-brand's options
                    
                    // now filterout other-facet options relations with this-facet
                    for(var relatedOhterFacetOptionID in thisOptionRelationsWithOtherFacet ){
                        // this check is needed as some-other facet can also have a relation with this-other-facet, 
                        // and can filterout more potential-options.
                        if(!structKeyExists(potentialOtherFacetOptions, relatedOhterFacetOptionID) ){
                            // if the option does not exist in available other facet options, then delete the relations
                            thisOptionRelationsWithOtherFacet.delete(relatedOhterFacetOptionID); 
                            //e.g  if selected-product-type's this-brand-id is not available in potential-brands, delete the relation.
                            continue; // nothing else to do; this related-other-facet-option is eliminated from filtered options
                        }
                            
                        // to get the full option-struct instead of an ID
                        var relatedOtherFacetOption = potentialOtherFacetOptions[ relatedOhterFacetOptionID ];  // e.g. selected product-type's related-brand
                        //related facet-option also has a relation with this facet, filter them out
                        var otherFacetOptionRelationsWithThisFacet = relatedOtherFacetOption.relations[ thisFacet.id ]; // e.g. related-brand's related product-types
                        //delete the relations back relation with this option, if they does not qualify
                        for(var relatedThisfacetOptionID in otherFacetOptionRelationsWithThisFacet ){
                            if(!structKeyExists(potentialThisFacetOptions, relatedThisfacetOptionID) ){
                                // if other facet optin has a back relation with this facet, which does not exist in potential options, then delete the relation.
                                // e.g. we're looping over product type, and then product-type-brands, 
                                // one of the brand in the loop can be associsted with more than one product type, 
                                // but we've only selected only a few of them, 
                                // so we gotta delete the relation
                                otherFacetOptionRelationsWithThisFacet.delete(relatedThisfacetOptionID);
                            }
                        }
                        
                        filteredOtherFacetOptions[ relatedOhterFacetOptionID ] = relatedOtherFacetOption;
                    }
                }    
                
                potentialFacetOptions[ otherFacet.id ] = filteredOtherFacetOptions;
            }
            
            
        }

        return potentialFacetOptions;
	}

	
	// ===================== START: Logical Methods ===========================

	// =====================  END: Logical Methods ============================

	// ===================== START: DAO Passthrough ===========================

	// ===================== START: DAO Passthrough ===========================

	// ===================== START: Process Methods ===========================

	// =====================  END: Process Methods ============================

	// ====================== START: Save Overrides ===========================

	// ======================  END: Save Overrides ============================

	// ==================== START: Smart List Overrides =======================

	// ====================  END: Smart List Overrides ========================

	// ====================== START: Get Overrides ============================

	// ======================  END: Get Overrides =============================

}
