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
                        "name": "Featured",
                        "value": 'product.productFeaturedFlag|DESC,product.productName|ASC',
                    },{
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
        	    },
        	    'priceRange' : {
        	    	'name' : 'Price Range',
        	    	'facetKey' : 'priceRange',
        	    	'selectType': 'single',
        	    	'options' : [{
        	    		"name" : "100 - 500",
        	    		"value": "100-500",
        	    	},{
        	    		"name" : "501 - 1000",
        	    		"value": "501-1000",
        	    	},{
        	    		"name" : "1001 - 1500",
        	    		"value": "1001-1500",
        	    	}]
        	    }
    	    };
	}
	
	public struct function getPotentialFilterFacetsAndOptionsFormatted(){
	    param name="arguments.brand" default={};
	    param name="arguments.option" default={};
	    param name="arguments.content" default={};
	    param name="arguments.category" default={};
	    param name="arguments.attribute" default={};
	    param name="arguments.productType" default={};
	    
        param name="arguments.includeSKUCount" default=true;
        param name="arguments.priceRangesCount" default=5;
	    param name="arguments.applySiteFilter" default=false;
        param name="arguments.applyStockFilter" default=false;
	    
	    param name="arguments.returnFacetList" default='brand,option,attribute,sorting,priceRange'; // brand,option,attribute,category,sorting,priceRange,productType
	    
        param name="arguments.keyword" default='';
        
	    var rawFilterOptions = this.getSlatwallProductSearchDAO().getPotentialFilterFacetsAndOptions( argumentCollection = arguments);
	    var startTicks = getTickCount();
	    
        // we're using hash-maps for :
        // - duplicate-removal 
        // - faster lookups 
	    var potentialFacetsAndOption = this.getFacetsMetaData();
	    for(var facetName in potentialFacetsAndOption.keyArray() ){
    	    if(!arguments.returnFacetList.listFindNoCase( facetName) ){
                potentialFacetsAndOption.delete(facetName);
            }
	    }

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
                   'name': row.name
                };
                if( !isNull(row.count) ){
                    thisOption['count'] = row.count;
                }
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
                   'name': row.name
                };
                if( !isNull(row.count) ){
                    thisOption['count'] = row.count;
                }
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

	    return potentialFacetsAndOption;
	}
	
	public array function makePriceRangeOptions( required number priceRangesCount, required any priceRangeCollectionList ){
		//check to avoid division by zero
		if( arguments.priceRangesCount <= 0 ){
		    return [];
		}
        
		var startTicks = getTickCount();
		var records = arguments.priceRangeCollectionList.getRecords(formatRecords=false);

		var min = val(records[1]['min'] ?: 0);
		var max = val(records[1]['max'] ?: 0);
		this.getSlatwallProductSearchDAO().logQuery({
		    'sql': arguments.priceRangeCollectionList.getSQL(),
		    'result' : { 'min': min, 'max': max},
		    'recordCount' : 1,
		    'executionTime' : getTickCount() - startTicks,
		}, 'getProducts:: priceRangeCollectionList.getRecords' );


		min = floor(min);
		max = ceiling(max);
		var delta = floor((max - min) / arguments.priceRangesCount);

		if(delta <= 1){
		    return  [{"name": (min) &" - "&(max), "value": (min) &"-"&(max)}]
		}
        
		var ranges = [
		    {"name": (min) &" - "&(min+delta), "value": (min) &"-"&(min+delta)}
		];

		while( min < max) {
		    min = min + delta;
		    if( min + delta < max ) {
			ranges.append(
                    		{ "name": min &" - "&(min+delta), "value": min &"-"&(min+delta) }
			);
		    }
		}
        	return ranges;
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
	    
	    if(arguments.facetName == 'content'){
	        if(arguments.facetValueKey == 'id' ){
	            return 'content.contentID';
	        }  
	        if(arguments.facetValueKey == 'name' ){
	            return 'contentTitle';
	        }
	        if(arguments.facetValueKey == 'slug' ){
	            return 'contentUrlTitle';
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
	
	public string function formatComparisonOperator(required string comparisonOperator){
	    switch(arguments.comparisonOperator ){
    	    case 'eq':
    	        return '=';
    	    case 'neq':
    	        return '!=';
    	    case 'gte':
    	        return '>=';
    	    case 'gt':
    	        return '>';   
    	    case 'lte':
    	        return '<=';
    	    case 'lt':
    	        return '<'; 
    	    case 'in':
    	        return 'IN'; 
	    }
	}
	
	public any function getBaseSearchCollectionData(){
		param name="arguments.locale";
		param name="arguments.currencyCode";
		param name="arguments.priceGroupCode" default='';
		
        param name="arguments.applySiteFilter" default=false;
        param name="arguments.applyStockFilter" default=false;
        
	    // facets
	    param name="arguments.brand" default={};
	    param name="arguments.option" default={};
	    param name="arguments.content" default={};
	    param name="arguments.category" default={};
	    param name="arguments.attribute" default={};
	    param name="arguments.productType" default={};
	    
	    param name="arguments.f" default={}; // additional-filters
	    
	    param name="arguments.propertyIdentifierList" default='';
        // Search
        param name="arguments.keyword" default="";
        // Sorting
        param name="arguments.orderBy" default="product.productName|DESC"; 
        // Pricing
        param name="arguments.price" default=""; 
        //Price Range
        param name="arguments.priceRange" default="";
        // Pagination
	    param name="arguments.currentPage" default=1;
	    param name="arguments.pageSize" default=10;
	    
		var collectionList = this.getProductFilterFacetOptionCollectionList();
		
        // Product's filters
        collectionList.addFilter(
            propertyIdentifier = 'productPublishedStartDateTime',
            value='NULL',
            comparisonOperator="IS",
            filterGroupAlias = 'publishedStartDateTimeFilter');
        collectionList.addFilter( 
            propertyIdentifier = 'productPublishedStartDateTime',
            value= dateTimeFormat(now(), 'short'), 
            comparisonOperator="<=", 
            logicalOperator="OR",
            filterGroupAlias = 'publishedStartDateTimeFilter');

        collectionList.addFilter(
            propertyIdentifier = 'productPublishedEndDateTime',
            value='NULL', 
            comparisonOperator="IS", 
            filterGroupAlias = 'publishedEndDateTimeFilter');
        collectionList.addFilter(
            propertyIdentifier = 'productPublishedEndDateTime',
            value= dateTimeFormat(now(), 'short'), 
            comparisonOperator=">",
            logicalOperator="OR", 
            filterGroupAlias = 'publishedEndDateTimeFilter');
        
        // STOCK, 
        if(arguments.applyStockFilter){
            collectionList.addFilter('sku.stocks.calculatedQATS', 0, '>');
        }
        
        if( arguments.applySiteFilter && !isNull(arguments.site) ){
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
            
            // STOCK location, 
            if( arguments.site.hasLocation() ){
                collectionList.addFilter('sku.stocks.location.sites.siteID', arguments.site.getSiteID());
                collectionList.addFilter('sku.stocks.location.locationID', arguments.site.getLocations()[1].getLocationID());
            }
		}
        
        // SKU-Price's filters
        if( len(arguments.currencyCode) ){
            collectionList.addFilter(propertyIdentifier='skuPriceCurrencyCode', value=arguments.currencyCode, comparisonOperator="=");
        }
        // if there's a price-group then we wnat that sku-price
        // otherwise we want the sku-price which does-not have a price-group associated with it
        if( len(trim(arguments.priceGroupCode)) ){
            collectionList.addFilter(propertyIdentifier='priceGroupCode', value=arguments.priceGroupCode);
        } else {
            collectionList.addFilter(propertyIdentifier='priceGroupCode', value='NULL', comparisonOperator='IS');
        }
        // we also do not want sku-prices which have min-max quantities defined
        collectionList.addFilter(propertyIdentifier='skuPriceMinQuantity', value='NULL', comparisonOperator='IS');
        collectionList.addFilter(propertyIdentifier='skuPriceMaxQuantity', value='NULL', comparisonOperator='IS');
        

	    for(var facetName in ['brand', 'content', 'category', 'productType'] ){
    	    var selectedFacetOptions = arguments[ facetName ];
            if( !this.hibachiIsStructEmpty(selectedFacetOptions) ){
                for(var facteValueKey in selectedFacetOptions ){
                    var filterValue = selectedFacetOptions[facteValueKey];
                    var propertyIdentifier = this.getFacetFilterKeyPropertyIdentifierByFacetNameAndFacetValueKay(facetName, facteValueKey);
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
        
	    for(var facetName in ['option', 'attribute'] ){
    	    var selectedFacetOptions = arguments[ facetName ];
    	    var customHQL = '';
    	    if( !this.hibachiIsStructEmpty(selectedFacetOptions) ){
                for(var subFacetName in selectedFacetOptions ){
                    
                    var subFacetColumnName = 'optionGroupCode';
                    if(facetName == 'attribute'){
                        subFacetColumnName = 'attributeCode';
                    }
                    
                    for(var facteValueKey in selectedFacetOptions[subFacetName] ){
                        var filterValue = selectedFacetOptions[subFacetName][facteValueKey];
                        var propertyIdentifier = this.getFacetFilterKeyPropertyIdentifierByFacetNameAndFacetValueKay(facetName, facteValueKey);
                        if( !isNUll(propertyIdentifier) ){
                            
                            var conditionalOpp = '=';
                            if( isArray(filterValue) ){
                                conditionalOpp = 'IN';
                                filterValue = collectionList.getListPredicate({'value' : arrayToList(filterValue)});
                            } else {
                                filterValue = collectionList.getSimplePredicate({'value' : filterValue});
                            }
                            
                            var hql = "(
                                SELECT
                                    DISTINCT sku.skuID 
                                FROM
                                    SlatwallProductFilterFacetOption
                                WHERE
                                    #subFacetColumnName# = '#subFacetName#'
                                    AND
                                    #propertyIdentifier# #conditionalOpp# #filterValue#
                            )";
                            
                            collectionList.addFilter(
                                value              = hql,
                                customHQL          = true,
                                filterGroupAlias   = subFacetName&'_filters',
                                propertyIdentifier = 'sku.skuID', 
                                comparisonOperator = 'IN'
                            );
                        }
                    }
                }
            }
	    }

        // Searching
        if ( len(arguments.keyword) ){
            // TODO: translations
            for( var propertyIdentifier in ['product.productName', 'product.productCode', 'sku.skuCode'] ){
                collectionList.addFilter(
                    propertyIdentifier=propertyIdentifier, 
                    value="%"&arguments.keyword&"%", 
                    comparisonOperator='LIKE', 
                    filterGroupAlias='keyword',
                    logicalOperator='OR'
                );
            }
        }
        
        // Additional filters
        if( !hibachiIsStructEmpty(arguments.f) ){
            for(var propertyIdentifier in arguments.f ){
                var selectedPropertyFilters = arguments.f[propertyIdentifier];
                for(var comparisonOperator in selectedPropertyFilters){
                    var filterValue = selectedPropertyFilters[ comparisonOperator ];
                    if( comparisonOperator == 'like' ){
                        collectionList.addFilter(
                            propertyIdentifier= propertyIdentifier, 
                            value='%#filterValue#%', 
                            comparisonOperator='LIKE',
                            logicalOperator='OR', 
                            filterGroupAlias='keyword'
                        );
                    } else {
                        var formattedComparisonOperator = this.formatComparisonOperator( comparisonOperator );
                        collectionList.addFilter(
                            propertyIdentifier=propertyIdentifier, 
                            value=filterValue, 
                            comparisonOperator=formattedComparisonOperator 
                        );
                    }
                }
            }
        }
        
        
        // make a copy of the collection-object, with all the filters applied
        var priceRangeCollectionList = this.getProductFilterFacetOptionCollectionList();
        priceRangeCollectionList.setCollectionConfigStruct( 
            // duplicate so both collections are not sharing the same objects under the hood
            Duplicate( collectionList.getCollectionConfigStruct() ) 
        );
        priceRangeCollectionList.setHQLParams( 
            // duplicate so both collections are not sharing the same objects under the hood
            Duplicate( collectionList.getHQLParams() ) 
        );

        priceRangeCollectionList.setDisplayProperties('');
        priceRangeCollectionList.addDisplayAggregate(
            propertyIdentifier='skuPriceListPrice', 
            aggregateFunction='MIN', 
            aggregateAlias='min'
        );
        priceRangeCollectionList.addDisplayAggregate(
            propertyIdentifier='skuPriceListPrice', 
            aggregateFunction='MAX', 
            aggregateAlias='max'
        );
        
        // add the display-properties and the rest of the procing-filter, pagination, sorting etc.
        
        if( len(trim(arguments.propertyIdentifierList)) ){
		    collectionList.setDisplayProperties(arguments.propertyIdentifierList);
		} else {
    		// sku properties 
    		collectionList.setDisplayProperties('sku.skuID,sku.skuCode,sku.imageFile,skuPricePrice|skuPrice,skuPriceListPrice|listPrice');
            collectionList.addDisplayProperty('sku.stocks.calculatedQATS');
    		// product properties
    		collectionList.addDisplayProperties('product.productID,product.productName,product.productCode,product.urlTitle');
		}
		
        //Price Range Filter
        if( len(arguments.priceRange) ) {
        	collectionList.addFilter(
        		propertyIdentifier='skuPricePrice',
        		value=ReReplace(arguments.priceRange,"[^0-9.^-]","","all"),
        		comparisonOperator="between"
        	);
        }
        // Sorting
        collectionList.setOrderBy(arguments.orderBy);
        // Pagination
        collectionList.setPageRecordsShow( arguments.pageSize );
        collectionList.setCurrentPageDeclaration(arguments.currentPage);
        
        return { 
            'currencyCode': currencyCode,
            'priceGroupCode': priceGroupCode,
            'collectionList': collectionList,
            'priceRangeCollectionList': priceRangeCollectionList
        };
    }

	public struct function getProducts(){
	    this.logHibachi("Called: getProducts on service");

		param name="arguments.locale";
		param name="arguments.currencyCode";
		param name="arguments.priceGroupCode" default='';
        
	    // facets
	    param name="arguments.brand" default={};
	    param name="arguments.option" default={};
	    param name="arguments.content" default={};
	    param name="arguments.category" default={};
	    param name="arguments.attribute" default={};
	    param name="arguments.productType" default={};
	    
        // Search
        param name="arguments.keyword" default="";
        // Sorting
        param name="arguments.orderBy" default="product.productName|DESC"; 
        // Pricing
        param name="arguments.price" default=""; 
        // Price Range
        param name="arguments.priceRange" default=""; //value1-value2
        // Pagination
	    param name="arguments.currentPage" default=1;
	    param name="arguments.pageSize" default=10;
	    
        // additional properties
        param name="arguments.includeSKUCount" default=true;
        param name="arguments.applySiteFilter" default=false;
        param name="arguments.applyStockFilter" default=false;
        param name="arguments.priceRangesCount" default=5;
        param name="arguments.includePagination" default=false;
	    param name="arguments.includePotentialFilters" default=true;
	    param name="arguments.propertyIdentifierList" default='';
	    param name="arguments.returnFacetList" default='brand,option,attribute,category,sorting,priceRange'; // brand,option,attribute,category,sorting,priceRange,productType

	    
	    var collectionData = this.getBaseSearchCollectionData(argumentCollection=arguments);
	    
	    var startTicks = getTickCount();
        
	    var records = collectionData.collectionList.getPageRecords();
	    
        this.getSlatwallProductSearchDAO().logQuery({
            'sql': collectionData.collectionList.getSQL(),
            'result' : records,
            'recordCount' : arrayLen(records),
            'executionTime' : getTickCount() - startTicks,
        }, 'getProducts:: collection.getPageRecords, [page:#arguments.currentPage#, size: #arguments.pageSize#]');
        
	    var resultSet = {
	        'currencyCode': collectionData.currencyCode,
	        'priceGroupCode': collectionData.priceGroupCode,
	        
	        'products' : records
	    };
	    
	    // Pagination
	    if(arguments.includePagination){
	        
            startTicks = getTickCount();
	        var total = collectionData.collectionList.getRecordsCount();

            this.getSlatwallProductSearchDAO().logQuery({
                'sql': collectionData.collectionList.getSelectionCountSQL(),
                'result' : { 'total': total},
                'recordCount' : total,
                'executionTime' : getTickCount() - startTicks,
            }, 'getProducts:: collection.getRecordsCount' );
            
        
	        resultSet['total']  = total;
	        resultSet['pageSize'] = arguments.pageSize;
	        resultSet['currentPage'] = arguments.currentPage;
	    }
	    
	    // filter's options
	    if( arguments.includePotentialFilters ){
	        var potentialFilters = this.getPotentialFilterFacetsAndOptionsFormatted(argumentCollection=arguments);
	        
	        if( arguments.returnFacetList.listFindNoCase('priceRange') ){
	            potentialFilters['priceRange']['options'] = this.makePriceRangeOptions(arguments.priceRangesCount, collectionData.priceRangeCollectionList );
	        }
	        
	        resultSet['potentialFilters'] = potentialFilters;
	    }
	    
	    return resultSet;
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
