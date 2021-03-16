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
	    return {
    	        'category' : {
        	        'name'           : 'Categories',
        	        'facetKey'       : 'category', 
        	        'selectType'     : 'single',
        	        'options'        : []
        	    },
                'productType': {
        	        'name'           : 'ProductTypes',
        	        'facetKey'       : 'productType', 
        	        'selectType'     : 'single',
        	        'options'        : []
        	    },
                'brand' : {
        	        'name'           : 'Brands',
        	        'facetKey'       : 'brands', 
        	        'selectType'     : 'multi',
        	        'options'        : []
        	    },
        	    'option' : {
        	        'facetKey'       : 'option', 
        	        'facetType'      : 'group',
        	        'selectType'     : 'multi',
        	        'subFacets'      : {}
        	    },
        	    'attribute' : {
            	    'facetKey'          : 'attribute', 
        	        'facetType'         : 'group',
        	        'selectType'        : 'multi',
        	        'subFacets'         : {}
        	    },
        	    'sorting' : {
        	        'name'       : "Sort By",
        	        'facetKey'   : 'orderBy',
        	        'selectType' : 'multi',
        	        'options' : [{
                        "name": "Price Low To High",
                        "value": 'skuPriceListPrice|ASC',
                    },{
                        "name": "Price High To Low",
                        "value": 'skuPriceListPrice|DESC',
                    },{
                        "name": "Product Name A-Z",
                        "value": 'product.productName|ASC',
                    },{
                        "name": "Product Name Z-A",
                        "value": 'product.productName|DESC',
                    },{
                        "name": "Brand A-Z",
                        "value": 'brandName|ASC',
                    },{
                        "name": "Brand Z-A",
                        "value": 'brandName|DESC',
                    }]
        	    }
    	    };
	}
	
	public struct function getPotentialFilterFacetsAndOptionsFormatted(){
	    param name="arguments.site";
	    param name="arguments.brand" default={};
	    param name="arguments.option" default={};
	    param name="arguments.category" default={};
	    param name="arguments.attribute" default={};
	    param name="arguments.productType" default={};
        param name="arguments.includeSKUCount" default=true;
        
	    var rawFilterOptions = this.getSlatwallProductSearchDAO().getPotentialFilterFacetsAndOptions( argumentCollection = arguments);
	    var startTicks = getTickCount();
	    
        // we're using hash-maps for :
        // - duplicate-removal 
        // - faster lookups 
	    var potentialFacetsAndOption = this.getFacetsMetaData();

       	this.logHibachi("SlatwallProductSearchService:: getPotentialFilterFacetsAndOptionsFormatted - processing - #rawFilterOptions.recordCount# ");
            
	    for( var row in rawFilterOptions ){
	        if( listFindNoCase('attribute,option', row.facet) ){
	            
	            var subFacets = potentialFacetsAndOption[row.facet]['subFacets'];
                if(!structKeyExists(subFacets, row.subFacet) ){
                    subFacets[row.subFacet] = {
                        'name'        : row.subFacetName,
                        'selectType'  : 'multi',
                        'subFacetKey' : row.subFacet,
                        'options': []
                    };
                }
                var thisSubFacet = subFacets[row.subFacet];
                
                var thisOption = {
                   'id': row.id,
                   'name': row.name,
                   'count': row.count,
                };
                if( len(row.code) ){
                    thisOption['code'] = row.code;
                }
                if( len(row.slug) ){
                    thisOption['slug'] = row.slug;
                }
                thisSubFacet.options.append(thisOption);
	        } else {
	            var thisFacet = potentialFacetsAndOption[row.facet];
                
                var thisOption = {
                   'id': row.id,
                   'name': row.name,
                   'count': row.count,
                };
                if( len(row.code) ){
                    thisOption['code'] = row.code;
                }
                if( len(row.slug) ){
                    thisOption['slug'] = row.slug;
                }
                thisFacet.options.append(thisOption);
	        }
	        
	    } // END loop
	    
	    this.logHibachi("SlatwallProductSearchService:: getPotentialFilterFacetsAndOptionsFormatted took #getTickCount() - startTicks# ms.")

	    return potentialFilters;
	}

	public string function getFacetFilterKeyPropertyIdentifierByFacetNameAndFacetValueKay(required string facetName, required string facetValueKey){
	    if(arguments.facetName == 'brand'){
	        if(arguments.facetValueKey == 'id' ){
	            return 'brand.brandID';
	        }  
	        if(arguments.facetValueKey == 'name' ){
	            return 'brandName';
	        }
	    }
	    
	    if(arguments.facetName == 'category'){
	        if(arguments.facetValueKey == 'id' ){
	            return 'category.categoryID';
	        }  
	        if(arguments.facetValueKey == 'name' ){
	            return 'categoryName';
	        }  
	        if(arguments.facetValueKey == 'slug' ){
	            return 'categoryUrlTitle';
	        }
	    }
	    
	    if(arguments.facetName == 'productType'){
	        if(arguments.facetValueKey == 'id' ){
	            return 'productType.productTypeID';
	        }  
	        if(arguments.facetValueKey == 'name' ){
	            return 'productTypeName';
	        }  
	        if(arguments.facetValueKey == 'slug' ){
	            return 'productTypeUrlTitle';
	        }
	    }
	    
	    if(arguments.facetName == 'attribute'){
	        if(arguments.facetValueKey == 'id' ){
	            return 'attributeOption.attributeOptionID';
	        }  
	        if(arguments.facetValueKey == 'name' ){
	            return 'attributeOptionLabel';
	        }  
	        if(arguments.facetValueKey == 'slug' ){
	            return 'attributeOptionUrlTitle';
	        }
	        if(arguments.facetValueKey == 'code' ){
	            return 'attributeOptionValue';
	        }
	    }

	    if(arguments.facetName == 'option'){
	        if(arguments.facetValueKey == 'id' ){
	            return 'option.optionID';
	        }  
	        if(arguments.facetValueKey == 'name' ){
	            return 'optionName';
	        }
	        if(arguments.facetValueKey == 'code' ){
	            return 'optionCode';
	        }
	    }
	    
	}
	
	public any function getBaseSearchCollectionData(){
        var hibachiScope = this.getHibachiScope();
        
		param name="arguments.site";
		param name="arguments.currencyCode" default=arguments.site.getCurrencyCode() ?: 'USD';
    
        //  account, order, for pricing
		param name="arguments.order" default=hibachiScope.getCart();
		param name="arguments.account" default=hibachiScope.getAccount();
		param name="arguments.priceGroupCode" default='';
        
	    // facets
	    param name="arguments.brand" default={};
	    param name="arguments.option" default={};
	    param name="arguments.category" default={};
	    param name="arguments.attribute" default={};
	    param name="arguments.productType" default={};
	    
        // Search
        param name="arguments.keyword" default="";
        // Sorting
        param name="arguments.orderBy" default="product.productName|DESC"; 
        // Pricing
        param name="arguments.price" default=""; 
        // Pagination
	    param name="arguments.currentPage" default=1;
	    param name="arguments.pageSize" default=10;
	    
		var collectionList = this.getProductFilterFacetOptionCollectionList();
		
		// product properties
		collectionList.setDisplayProperties('product.productID,product.productName,product.urlTitle');
		
		// sku properties 
		collectionList.addDisplayProperties('sku.skuID,sku.imageFile,sku.skuPrices.price');

        // Product's filters
        
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
        
        if( !isNull(arguments.site) ){
            // site's filters
            collectionList.addFilter( 
                propertyIdentifier = 'site.siteID',
                value=arguments.site.getSiteID(), 
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
            if( arguments.site.hasLocation() ){
                collectionList.addDisplayProperty('sku.stocks.calculatedQATS');
                collectionList.addFilter('sku.stocks.location.locationID', arguments.site.getLocations()[1].getLocationID());
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
        if( !this.hibachiIsStructEmpty(arguments.productType) ){
            for(var facteValueKey in arguments.productType ){
                var filterValue = arguments.productType[facteValueKey];
                var propertyIdentifier = this.getFacetFilterKeyPropertyIdentifierByFacetNameAndFacetValueKay('productType', facteValueKey);
                if( !isNUll(propertyIdentifier) ){
                    var conditionalOpp = '=';
                    if( isArray(filterValue) ){
                        conditionalOpp = 'IN';
                        filterValue = arrayToList(filterValue);
                    }
                    collectionList.addFilter(propertyIdentifier, filterValue, conditionalOpp );
                }
            }
        }
        // category
        if( !this.hibachiIsStructEmpty(arguments.category) ){
            for(var facteValueKey in arguments.category ){
                var filterValue = arguments.category[facteValueKey];
                var propertyIdentifier = this.getFacetFilterKeyPropertyIdentifierByFacetNameAndFacetValueKay('category', facteValueKey);
                if( !isNUll(propertyIdentifier) ){
                    var conditionalOpp = '=';
                    if( isArray(filterValue) ){
                        conditionalOpp = 'IN';
                        filterValue = arrayToList(filterValue);
                    }
                    collectionList.addFilter(propertyIdentifier, filterValue, conditionalOpp );
                }
            }
        }
        // brands
        if( !this.hibachiIsStructEmpty(arguments.brand) ){
            for(var facteValueKey in arguments.brand ){
                var filterValue = arguments.brand[facteValueKey];
                var propertyIdentifier = this.getFacetFilterKeyPropertyIdentifierByFacetNameAndFacetValueKay('brand', facteValueKey);
                if( !isNUll(propertyIdentifier) ){
                    var conditionalOpp = '=';
                    if( isArray(filterValue) ){
                        conditionalOpp = 'IN';
                        filterValue = arrayToList(filterValue);
                    }
                    collectionList.addFilter(propertyIdentifier, filterValue, conditionalOpp );
                }
            }
        }
        // options
        if( !this.hibachiIsStructEmpty(arguments.option) ){
            for(var optionGroupName in arguments.option ){
                for(var facteValueKey in arguments.option[optionGroupName] ){
                    var filterValue = arguments.option[optionGroupName][facteValueKey];
                    var propertyIdentifier = this.getFacetFilterKeyPropertyIdentifierByFacetNameAndFacetValueKay('option', facteValueKey);
                    if( !isNUll(propertyIdentifier) ){
                        var conditionalOpp = '=';
                        if( isArray(filterValue) ){
                            conditionalOpp = 'IN';
                            filterValue = arrayToList(filterValue);
                        }
                        collectionList.addFilter(propertyIdentifier, filterValue, conditionalOpp );
                    }
                }
            }
        }
        
        // Attribute options
        if( !this.hibachiIsStructEmpty(arguments.attribute) ){
            for(var attributeCode in arguments.attribute ){
                for(var facteValueKey in arguments.attribute[attributeCode] ){
                    var filterValue = arguments.attribute[attributeCode][facteValueKey];
                    var propertyIdentifier = this.getFacetFilterKeyPropertyIdentifierByFacetNameAndFacetValueKay('attribute', facteValueKey);
                    if( !isNUll(propertyIdentifier) ){
                        var conditionalOpp = '=';
                        if( isArray(filterValue) ){
                            conditionalOpp = 'IN';
                            filterValue = arrayToList(filterValue);
                        }
                        collectionList.addFilter(propertyIdentifier, filterValue, conditionalOpp );
                    }
                }
            }
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
	    
	    param name="arguments.site";
		param name="arguments.currencyCode" default=arguments.site.getCurrencyCode() ?: 'USD';
    
        //  account, order, for pricing
		param name="arguments.order" default=hibachiScope.getCart();
		param name="arguments.account" default=hibachiScope.getAccount();
		param name="arguments.priceGroupCode" default='';
        
	    // facets
	    param name="arguments.brand" default={};
	    param name="arguments.option" default={};
	    param name="arguments.category" default={};
	    param name="arguments.attribute" default={};
	    param name="arguments.productType" default={};
	    
        // Search
        param name="arguments.keyword" default="";
        // Sorting
        param name="arguments.orderBy" default="product.productName|DESC"; 
        // Pricing
        param name="arguments.price" default=""; 
        // Pagination
	    param name="arguments.currentPage" default=1;
	    param name="arguments.pageSize" default=10;
	    
        // additional properties
        param name="arguments.includeSKUCount" default=true;
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
	        resultSet['potentialFilters'] = this.getPotentialFilterFacetsAndOptionsFormatted(argumentCollection=arguments);
	    }
	    
	    return resultSet;

	}
	
	
	
	// Not In USE
	
	
	
	
		public struct function getPotentialFilterFacetsAndOptions(){
	    param name="arguments.site" default='';
	    param name="arguments.brand" default={};
	    param name="arguments.option" default={};
	    param name="arguments.category" default={};
	    param name="arguments.attribute" default={};
	    param name="arguments.productType" default={};
	    
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
                "value": 'skuPriceListPrice|ASC',
            },{
                "name": "Price High To Low",
                "value": 'skuPriceListPrice|DESC',
            },{
                "name": "Product Name A-Z",
                "value": 'product.productName|ASC',
            },{
                "name": "Product Name Z-A",
                "value": 'product.productName|DESC',
            },{
                "name": "Brand A-Z",
                "value": 'brandName|ASC',
            },{
                "name": "Brand Z-A",
                "value": 'brandName|DESC',
            }]
	    };
	    
	    this.logHibachi("SlatwallProductSearchService:: getFormattedFilterFacets took #getTickCount() - startTicks# ms.")
	 
	    
	    return formattedFacets;
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
