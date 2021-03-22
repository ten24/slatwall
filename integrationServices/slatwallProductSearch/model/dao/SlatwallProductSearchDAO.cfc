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
component extends="Slatwall.model.dao.HibachiDAO" persistent="false" accessors="true" output="false"{
	
	
	// ===================== START: Logical Methods ===========================
    
	public any function getProductAndSkuSelectTypeAttributes(){
	    var startTicks = getTickCount();
	    var query = new Query();
	    var sql = "
	        SELECT 
                att.attributeID, att.attributeCode, att.attributeInputType, ast.attributeSetObject
            
            FROM swProduct p
            
            LEFT JOIN swSku sk
            	ON sk.productID = p.productID
                          
            INNER JOIN swAttributeSet ast
            	ON ( ast.attributeSetObject = 'product' OR ast.attributeSetObject = 'sku' ) 

            INNER JOIN SwAttribute att
                ON att.attributeInputType IN ('select', 'multiSelect') 
                    AND att.attributeSetID = ast.attributeSetID 
			
            GROUP By att.attributeID
	    ";
	    
	    query.setSQL(sql);
	    query = query.execute().getResult();
	    
	    this.logHibachi("SlatwallProductSearchDAO:: getProductAndSkuSelectTypeAttributes took #getTickCount()-startTicks# ms., and fetched #query.recordCount# records ");
        
        return query;
	}
	
	public any function truncateProductFilterFacetOptionsTable(){
        var startTicks = getTickCount();
	    var query = new Query();
	    var sql = "TRUNCATE TABLE  swProductFilterFacetOption";
	    query.setSQL(sql);
	    query.execute().getResult();
	    this.logHibachi("SlatwallProductSearchDAO:: cleared swProductFilterFacetOption table, in #getTickCount()-startTicks# ms.");
	}
	
	public any function rePopulateProductFilterFacetOptionTable(){
	    this.truncateProductFilterFacetOptionsTable();
	    
	    var sql = " INSERT INTO swProductFilterFacetOption (
    	                #this.getProductFilterFacetOptionsSeletQueryColumnList()#
    	            ) 
                    #this.getProductFilterFacetOptionsSeletQuerySQL()#
               ";
               
        var startTicks = getTickCount();
	    var query = new Query();
	    query.setSQL(sql);
	    query.execute();
	    
	    this.logHibachi("SlatwallProductSearchDAO:: rePopulateProductFilterFacetOptionsTable took #getTickCount()-startTicks# ms.");
	}
	
	
	//just to save some maintenance, and remove duplicacy
	public any function getProductFilterFacetOptionsSeletQueryColumnList(){
	    
	    // NOTE: the position of the keys should alwasy match with query in function **getProductFilterFacetOptionsSeletQuerySQL** below
	    
	    if( !structKeyExists(variables, 'cached_productFilterFacetOptionsSeletQueryColumnList') ){
	        
	        variables['cached_productFilterFacetOptionsSeletQueryColumnList'] = "
	                        
	                        productFilterFacetOptionID,
    	   
                            productID,
                            productPublishedStartDateTime,
                            productPublishedEndDateTime,
                	        
                	        skuID,
                	        
                	        skuPriceID,
                		    skuPricePrice,
                		    skuPriceListPrice,
                		    skuPriceMinQuantity,
                		    skuPriceMaxQuantity,
                		    skuPriceCurrencyCode,
                		    skuPriceRenewalPrice,
                		    skuPriceExpiresDateTime,
                		    
                		    priceGroupID, priceGroupName, 
		                    priceGroupCode, parentPriceGroupID,
                            
                            brandID, brandName,
                            
                            categoryID, categoryName, parentCategoryID, 
                            categoryUrlTitle,
                            
                            optionID, optionName, optionCode, 
                            optionSortOrder,
                            
                            optionGroupID, optionGroupName, optionGroupCode,
                            optionGroupSortOrder,
                            
                            productTypeID, productTypeName, parentProductTypeID, 
                            productTypeURLTitle,
                            
                            contentID, parentContentID,
                            contentTitle, 
                            contentUrlTitle,
                            contentSortOrder,
                            
                            siteID, siteName, siteCode, currencyCode,
                       
                            attributeID, attributeName, attributeCode, attributeInputType, 
                            attributeUrlTitle, 
                            attributeSortOrder,
                       
                            attributeSetID, attributeSetCode, attributeSetName, attributeSetObject,
                            attributeSetSortOrder,

                            attributeOptionID, attributeOptionValue, attributeOptionLabel,
                            attributeOptionUrlTitle,
                            attributeOptionSortOrde
                    ";
	    }
	    
	    return variables['cached_productFilterFacetOptionsSeletQueryColumnList'];
	}
	
	
	/**
	 * This function is used to create a SQL query to create filter-option-relations [maximum possible]
	*/
	public any function getProductFilterFacetOptionsSeletQuerySQL( string productIDs = "", string skuIDs = "" ){
	    
	    
	    var startTicks = getTickCount();
	    
	    // TODO: can be cached     
	    var productAndSkuSelectTypeAttributes = this.getProductAndSkuSelectTypeAttributes();
        var attributeIDs = valueList(productAndSkuSelectTypeAttributes.attributeID);
        attributeIDs = listQualify(attributeIDs, "'");
        
        // TODO: multi-selet type
        var selectTypeAttributeOptionJoinParts = productAndSkuSelectTypeAttributes.reduce( function(joins,row){
            if( arguments.row.attributeInputType != 'select' ){
                return arguments.joins;
            }
            if( arguments.row.attributeSetObject == 'sku'){
                return listAppend(joins, "(
                    att.attributeCode = `#arguments.row.attributeCode#` 
                    AND sk.#arguments.row.attributeCode# = atto.attributeOptionValue 
                    AND sk.#arguments.row.attributeCode# != '' 
                    AND sk.#arguments.row.attributeCode# IS NOT NULL
                    )", '$' );
            } 
            return listAppend(joins, "(
                att.attributeCode = `#arguments.row.attributeCode#` 
                AND p.#arguments.row.attributeCode# = atto.attributeOptionValue
                AND p.#arguments.row.attributeCode# != '' 
                AND p.#arguments.row.attributeCode# IS NOT NULL
                )", '$' );
        }, "");
        selectTypeAttributeOptionJoinParts = selectTypeAttributeOptionJoinParts.replace(")$(", ") OR (", "ALL");
            
        // we'll use these to generate the records for perticular Products and SKUs
        // which, then, will be used to update the `swProductFilterFacetOption` table;
            
        var productAndSkuIDsQueryPart = '';
        if( !this.hibachiIsEmpty(arguments.productIDs) ){
            arguments.productIDs =  listQualify(arguments.productIDs, "'");
            productAndSkuIDsQueryPart = "p.productID IN (#arguments.productIDs#)";
            if( this.hibachiIsEmpty(arguments.skuIDs) ){
                productAndSkuIDsQueryPart = " AND " & productAndSkuIDsQueryPart;
            }
        }
        if( !this.hibachiIsEmpty(arguments.skuIDs) ){
            arguments.skuIDs =  listQualify(arguments.skuIDs, "'");
            var skuIDsQueryPart = "sk.skuID IN (#arguments.skuIDs#)";
            if(!this.hibachiIsEmpty(arguments.productIDs)){
                productAndSkuIDsQueryPart = " AND ( #productAndSkuIDsQueryPart# OR #skuIDsQueryPart# ) ";
            } else {
                productAndSkuIDsQueryPart = " AND #skuIDsQueryPart# ";
            }
        }
            
	    var sql = " SELECT DISTINCT
	            
			MD5( 
           		CONCAT(
           			COALESCE( p.productID, ''), 
           			COALESCE( sk.skuID, ''), 
           			COALESCE( sp.skuPriceID, ''), 
           			COALESCE( pg.priceGroupID, ''), 
           			COALESCE( br.brandID, ''), 
           			COALESCE( cr.categoryID, ''), 
           			COALESCE( o.optionID, ''), 
           			COALESCE( og.optionGroupID, ''), 
           			COALESCE( pt.productTypeID, ''), 
           			COALESCE( co.contentID , ''), 
           			COALESCE( st.siteID, ''), 
           			COALESCE( att.attributeID, ''), 
           			COALESCE( atst.attributeSetID, ''), 
           			COALESCE( atto.attributeOptionID,  '')
           		)
           ) AS productFilterFacetOptionID,
	
		   p.productID,
		   p.publishedStartDateTime AS productPublishedStartDateTime,
           p.publishedEndDateTime AS productPublishedEndDateTime,
		   
		   sk.skuID,
		   
		   sp.skuPriceID,
		   sp.price AS skuPricePrice,
		   sp.listPrice AS skuPriceListPrice,
		   sp.minQuantity AS skuPriceMinQuantity,
		   sp.maxQuantity AS skuPriceMaxQuantity,
		   sp.currencyCode AS skuPriceCurrencyCode,
		   sp.renewalPrice AS skuPriceRenewalPrice,
		   sp.expiresDateTime AS skuPriceExpiresDateTime,
		   
		   pg.priceGroupID, pg.priceGroupName, 
		   pg.priceGroupCode, pg.parentPriceGroupID,
		   
	       br.brandID, br.brandName,
	       
           cr.categoryID, cr.categoryName, cr.parentCategoryID, 
           cr.urlTitle AS categoryUrlTitle,
           
           o.optionID, o.optionName, o.optionCode, 
           o.sortOrder AS optionSortOrder,
           
           og.optionGroupID, og.optionGroupName, og.optionGroupCode,
           og.sortOrder AS optionGroupSortOrder,
           
           pt.productTypeID, pt.productTypeName, pt.parentProductTypeID, 
           pt.urlTitle AS productTypeURLTitle,
           
           co.contentID, co.parentContentID,
           co.title AS contentTitle,
           co.urlTitle AS contentUrlTitle,
           co.sortOrder AS contentSortOrder,
           
           st.siteID, st.siteName, st.siteCode, st.currencyCode,
           
           att.attributeID, att.attributeName, att.attributeCode, att.attributeInputType,
           att.urltitle AS attributeUrlTitle,
           att.sortOrder AS attributeSortOrder,
           
           atst.attributeSetID, atst.attributeSetCode, atst.attributeSetName, atst.attributeSetObject,
           atst.sortOrder AS attributeSetSortOrder,
           
           atto.attributeOptionID, atto.attributeOptionValue, atto.attributeOptionLabel,
           atto.urltitle AS attributeOptionUrlTitle,
           atto.sortOrder AS attributeOptionSortOrde

        FROM swProduct p
        
           INNER JOIN swSku sk
                ON sk.productID = p.productID #productAndSkuIDsQueryPart#
                    AND ( p.activeFlag = 1 OR p.activeFlag IS NULL ) 
                    AND ( p.publishedFlag = 1 OR p.publishedFlag IS NULL)
                    AND ( p.publishedStartDateTime IS NULL OR p.publishedStartDateTime <= NOW() )
                    AND ( p.publishedEndDateTime IS NULL OR p.publishedEndDateTime >= NOW() )
                    AND ( sk.activeFlag = 1 OR sk.activeFlag IS NULL ) 
                    AND ( sk.publishedFlag = 1 OR sk.publishedFlag IS NULL)
                    
            INNER JOIN swSkuPrice sp
                ON sp.skuID = sk.skuID 
                    AND ( sp.activeFlag = 1 OR sp.activeFlag IS NULL )
            LEFT JOIN swPriceGroup pg
                ON pg.priceGroupID = sp.priceGroupID
                    AND ( pg.activeFlag = 1 OR pg.activeFlag IS NULL )
                            
            LEFT JOIN swProductType pt
                ON pt.productTypeID = p.productTypeID 
                    AND ( pt.activeFlag = 1 OR pt.activeFlag IS NULL ) 
                    AND ( pt.publishedFlag = 1 OR pt.publishedFlag IS NULL )

            LEFT JOIN swBrand br
                ON br.brandID = p.brandID
                    AND ( br.activeFlag = 1 OR br.activeFlag IS NULL ) 
                    AND ( br.publishedFlag = 1 OR br.publishedFlag IS NULL )
            
            LEFT JOIN swProductCategory pc
                ON pc.productID = p.productID            
            LEFT JOIN swCategory cr
                ON cr.categoryID = pc.categoryID
            
            LEFT JOIN swProductListingPage plp
                ON plp.productID = p.productID 
            LEFT JOIN swContent co
                ON co.contentID = plp.contentID AND ( co.activeFlag = 1 OR co.activeFlag IS NULL )
                    
            LEFT JOIN swProductSite pst
                ON pst.productID = p.productID
            LEFT JOIN swSite st
                ON st.siteID = pst.siteID
                      
            LEFT JOIN swSkuOption so
                ON so.skuID = sk.skuID
            LEFT JOIN swOption o
                ON o.optionID = so.optionID
                    AND ( o.activeFlag = 1 OR o.activeFlag IS NULL ) 

            LEFT JOIN swOptionGroup og
                ON og.optionGroupID = o.optionGroupID
                  
            LEFT JOIN SwAttribute att
        	    ON att.attributeID IN (#attributeIDs#)

            LEFT JOIN SwAttributeSet atst
                ON atst.attributeSetID = att.attributeSetID
                    AND ( atst.activeFlag = 1 OR atst.activeFlag IS NULL ) 

            LEFT JOIN swAttributeOption atto
            	ON(#selectTypeAttributeOptionJoinParts#)
            	
            GROUP BY productFilterFacetOptionID
	   ";
	        
        this.logHibachi("SlatwallProductSearchDAO:: getProductFilterFacetOptionsSeletQuerySQL took #getTickCount()-startTicks# ms. in creating the SQL string");
        
        return sql;
	}
	
	/**
	 * **** START ********************** Keep the Filter-Relations updated in realtime
	*/

	public any function reCalculateProductFilterFacetOptionsForProductsAndSkus( string productIDs = "", string skuIDs = "" ){
	    
	    if( this.hibachiIsEmpty(arguments.skuIDs) && this.hibachiIsEmpty(arguments.productIDs) ){
            return;
        }
        
        var startTicks = getTickCount();
        var getExistingOptionsSQL = "SELECT productFilterFacetOptionID from swProductFilterFacetOption WHERE";
            
        if( !this.hibachiIsEmpty(arguments.productIDs) ){
            var qualifiedProductIDs =  listQualify(arguments.productIDs, "'");
            getExistingOptionsSQL &= " productID IN (#qualifiedProductIDs#)";
        }
        if( !this.hibachiIsEmpty(arguments.skuIDs) ){
            
            if(!this.hibachiIsEmpty(arguments.productIDs)){
                getExistingOptionsSQL &= " OR ";
            }
            
            qualifiedSkuIDs =  listQualify(arguments.skuIDs, "'");
            getExistingOptionsSQL &= " skuID IN (#qualifiedSkuIDs#)";
        }
            
        var getExistingOptionsQuery = new Query();
        getExistingOptionsQuery.setSQL( getExistingOptionsSQL );
        getExistingOptionsQuery = getExistingOptionsQuery.execute().getResult();
	        
        this.logHibachi("SlatwallProductSearchDAO:: updateProductFilterFacetOptionsForProductsAndSkus took #getTickCount()-startTicks# ms.; in fetching existing facet-options ");
 
	    var existingFFOsToDeletMap = {};
        for( var row in getExistingOptionsQuery ){
            existingFFOsToDeletMap[ row.productFilterFacetOptionID] = row.productFilterFacetOptionID;
        }
        
        var getNewOptionsQuerySQL = this.getProductFilterFacetOptionsSeletQuerySQL(argumentCollection = arguments ); 

        var getNewOptionsQuery = new Query();
        getNewOptionsQuery.setSQL(getNewOptionsQuerySQL);
        var getNewOptionsQueryResult = getNewOptionsQuery.execute().getResult();
        
        var newFFOsToInsertCount = 0;
        // we're looping over the new options and, 
        // checking if the new-option-id exists in the old options then we can exclude that option from deleting
        // otherwise it's a relation which is no longer valid, and needs to be deleted
        for( var row in getNewOptionsQueryResult ){
            if( structKeyExists(existingFFOsToDeletMap, row.productFilterFacetOptionID) ){
                existingFFOsToDeletMap.delete( row.productFilterFacetOptionID ); 
            } else {
                newFFOsToInsertCount++;
            }
        }
        
        // now delete whatever is left from the old options as these are no-longer valid
        if( structCount(existingFFOsToDeletMap) > 0 ){
	        this.logHibachi("SlatwallProductSearchDAO:: updateProductFilterFacetOptionsForProductsAndSkus deleting #structCount(existingFFOsToDeletMap)# old options");
        
            var ffoIDsToDelete = existingFFOsToDeletMap.keyList();
            ffoIDsToDelete = listQualify( ffoIDsToDelete , "'");
            
            var deleteQuery = new Query();
            var deleteSQL = "
                DELETE 
                FROM swProductFilterFacetOption
                WHERE productFilterFacetOptionID IN (#ffoIDsToDelete#)
            ";
            
            deleteQuery.setSQL( deleteSQL );
	        deleteQuery.execute();
        } else {
            this.logHibachi("SlatwallProductSearchDAO:: updateProductFilterFacetOptionsForProductsAndSkus did not found any old options to delete");
        }
	        
        // and insert any new filter-options
        if( newFFOsToInsertCount > 0 ){
	        this.logHibachi("SlatwallProductSearchDAO:: updateProductFilterFacetOptionsForProductsAndSkus inserting #newFFOsToInsertCount# new options");


            var insertQuery = new Query();
            
            // we're doing another query on the DB to get create the options and insert/replace, as doing that in the cf-code 
            // - will be some complicated logic, can be buggy and hard to maintain
            // - and a lot of string-manipulation, which will be slow
            // - and it can create a really big string-query to transfer over the network, which again will be slow
            // - also the replace query will takecare of updating the existing-option-fields like, brand-name, category-name, which is what we need 
            var insertSQL = "
        	        REPLACE INTO swProductFilterFacetOption ( 
        	            #this.getProductFilterFacetOptionsSeletQueryColumnList()# 
        	        ) 
    	            SELECT * FROM ( 
    	                #getNewOptionsQuerySQL# 
    	            ) result_set
                ";
            insertQuery.setSQL( insertSQL );
	        insertQuery.execute();
        } else {
            this.logHibachi("SlatwallProductSearchDAO:: updateProductFilterFacetOptionsForProductsAndSkus did not found any new options to insert");
        }

        this.logHibachi("SlatwallProductSearchDAO:: updateProductFilterFacetOptionsForProductsAndSkus took #getTickCount()-startTicks# ms.; in updating facte-options for Product: #arguments.productIDs#, SKU: #arguments.skuIDs# ");
	}
	
	public any function updateProductFilterFacetOptionsByEntityNameAndIDs( required string entityName, required string entityIDs ){
	    
	    if( this.hibachiIsEmpty(arguments.entityIDs) ){
            return;
        }
        
        var startTicks = getTickCount();
        
        var sql = " 
            UPDATE swProductFilterFacetOption ffo
            INNER JOIN
        ";
                    
        switch (arguments.entityName){
            case 'product':
                sql &= " 
                    swProduct p ON p.productID = ffo.productID AND p.productID IN (:entityIDs)
                    SET 
                        ffo.productPublishedStartDateTime = p.publishedStartDateTime,
                        ffo.productPublishedEndDateTime = p.publishedEndDateTime
                ";
            break;
            case 'brand':
                sql &= " 
                    swBrand br ON br.brandID = ffo.brandID AND br.brandID IN (:entityIDs)
                    SET 
                        ffo.brandName = br.brandName
                ";
            break;
            case 'category':
                sql &= " 
                    swCategory ct ON ct.categoryID = ffo.categoryID AND ct.categoryID IN (:entityIDs)
                    SET 
                        ffo.categoryName = ct.categoryName,
                        ffo.parentCategoryID = ct.parentCategoryID,
                        ffo.categoryUrlTitle = ct.urlTitle
                ";
            break;
            case 'option':
                sql &= " 
                    swOption o ON o.optionID = ffo.optionID AND o.optionID IN (:entityIDs)
                    SET 
                        ffo.optionName = o.optionName,
                        ffo.optionCode = o.optionCode,
                        ffo.optionSortOrder = o.sortOrder
                ";
            break;
            case 'optionGroup':
                sql &= " 
                    swOptionGroup og ON og.optionGroupID = ffo.optionGroupID AND og.optionGroupID IN (:entityIDs)
                    SET 
                        ffo.optionGroupName = og.optionGroupName,
                        ffo.optionGroupCode = og.optionGroupCode,
                        ffo.optionGroupSortOrder = og.sortOrder
                ";
            break;
            case 'productType':
                sql &= " 
                    swProductType pt ON pt.productTypeID = ffo.productTypeID AND pt.productTypeID IN (:entityIDs)
                    SET 
                        ffo.productTypeName = pt.productTypeName,
                        ffo.parentProductTypeID = pt.parentProductTypeID,
                        ffo.productTypeURLTitle = pt.urlTitle
                ";
            break;
            case 'site':
                sql &= " 
                    swSite s ON s.siteID = ffo.siteID AND s.siteID IN (:entityIDs)
                    SET 
                        ffo.siteName = s.siteName,
                        ffo.siteCode = s.siteCode,
                        ffo.currencyCode = s.currencyCode
                ";
            break;
            case 'attribute':
                sql &= " 
                    swAttribute att ON att.attributeID = ffo.attributeID AND att.attributeID IN (:entityIDs)
                    SET 
                        ffo.attributeName = att.attributeName,
                        ffo.attributeCode = att.attributeCode,
                        ffo.attributeInputType = att.attributeInputType,
                        ffo.attributeUrlTitle = att.urltitle,
                        ffo.attributeSortOrder = att.sortOrder
                ";
            break;
            case 'attributeSet':
                sql &= " 
                    swAttributeSet atst ON atst.attributeSetID = ffo.attributeSetID AND atst.attributeSetID IN (:entityIDs)
                    SET 
                        ffo.attributeSetName = atst.attributeSetName,
                        ffo.attributeSetCode = atst.attributeSetCode,
                        ffo.attributeSetObject = atst.attributeSetObject,
                        ffo.attributeSetUrlTitle = atst.urltitle
                ";
            break;
            case 'attributeOption':
                sql &= " 
                    swAttributeOption atto ON atto.attributeOptionID = ffo.attributeOptionID AND atto.attributeOptionID IN (:entityIDs)
                    SET 
                        ffo.attributeOptionLabel = atto.attributeOptionLabel,
                        ffo.attributeOptionValue = atto.attributeOptionValue,
                        ffo.attributeOptionUrlTitle = atto.urltitle,
                        ffo.attributeOptionSortOrde = atto.sortOrder
                ";
            break;
            case 'content':
                sql &= " 
                    swContent cont ON cont.contentID = ffo.contentID AND cont.contentID IN (:entityIDs)
                    SET 
                        ffo.parentContentID = cont.parentContentID,
                        ffo.contentUrlTitle = cont.urlTitle,
                        ffo.contentSortOrder = cont.sortOrder
                ";
            break;
            default:
                this.logHibachi("SlatwallProductSearchDAO:: updateProductFilterFacetOptionsByEntityNameAndIDs was called for not supported entity-name #arguments.entityName#");
                return;
            break;
        }
            
        var q = new Query();
        q.setSQL( sql );
        q.addParam( name='entityIDs', list="true", value=arguments.entityIDs );
        q.execute();
        
        this.logHibachi("SlatwallProductSearchDAO:: updateProductFilterFacetOptionsByEntityNameAndIDs took #getTickCount()-startTicks# ms.; in updating facte-options for #arguments.entityName#: #arguments.entityIDs#, SQL: #sql# ");
        
        return q;
	}
	
	public any function removeProductFilterFacetOptionsByEntityNameAndIDs( required string entityName, required string entityIDs ){
	    
	    if( this.hibachiIsEmpty(arguments.entityIDs) ){
            return;
        }
        
        var startTicks = getTickCount();
        
        var sql = " 
            DELETE ffo
                FROM swProductFilterFacetOption as ffo
            INNER JOIN
        ";
        
        switch (arguments.entityName){
            case 'product':
                sql &= " 
                    swProduct p ON p.productID = ffo.productID AND p.productID IN (:entityIDs)
                ";
            break;
            case 'sku':
                sql &= " 
                    swSku sk ON sk.skuID = ffo.skuID AND sk.skuID IN (:entityIDs)
                ";
            break;
            case 'brand':
                sql &= " 
                    swBrand br ON br.brandID = ffo.brandID AND br.brandID IN (:entityIDs)
                ";
            break;
            case 'category':
                sql &= " 
                    swCategory ct ON ct.categoryID = ffo.categoryID AND ct.categoryID IN (:entityIDs)
                ";
            break;
            case 'option':
                sql &= " 
                    swOption o ON o.optionID = ffo.optionID AND o.optionID IN (:entityIDs)
                ";
            break;
            case 'optionGroup':
                sql &= " 
                    swOptionGroup og ON og.optionGroupID = ffo.optionGroupID AND og.optionGroupID IN (:entityIDs)
                ";
            break;
            case 'productType':
                sql &= " 
                    swProductType pt ON pt.productTypeID = ffo.productTypeID AND pt.productTypeID IN (:entityIDs)
                ";
            break;
            case 'site':
                sql &= " 
                    swSite s ON s.siteID = ffo.siteID AND s.siteID IN (:entityIDs)
                ";
            break;
            case 'attribute':
                sql &= " 
                    swAttribute att ON att.attributeID = ffo.attributeID AND att.attributeID IN (:entityIDs)
                ";
            break;
            case 'attributeSet':
                sql &= " 
                    swAttributeSet atst ON atst.attributeSetID = ffo.attributeSetID AND atst.attributeSetID IN (:entityIDs)
                ";
            break;
            case 'attributeOption':
                sql &= " 
                    swAttributeOption atto ON atto.attributeOptionID = ffo.attributeOptionID AND atto.attributeOptionID IN (:entityIDs)
                ";
            break;
            case 'content':
                sql &= " 
                    swContent cont ON cont.contentID = ffo.contentID AND cont.contentID IN (:entityIDs)
                ";
            break;
            
            default:
                throw("not supported entity-name #arguments.entityName#");
            break;
        }
 
     
        var q = new Query();
        q.setSQL( sql );
        q.addParam( name='entityIDs', list="true", value=arguments.entityIDs );
        q.execute();
        
        this.logHibachi("SlatwallProductSearchDAO:: removeProductFilterFacetOptionsByEntityNameAndIDs took #getTickCount()-startTicks# ms.; in updating facte-options for #arguments.entityName#: #arguments.entityIDs#, SQL: #sql# ");
        
        return q;   
	}
	
	/**
	 * **** END ********************** Keep the Filter-Relations updated in realtime
	*/
	
	
	
	
	public string function getFacetFilterKeyColumnNameByFacetNameAndFacetValueKay(required string facetName, required string facetValueKey){
	    if(arguments.facetName == 'brand'){
	        if(arguments.facetValueKey == 'id' ){
	            return 'brandID';
	        }  
	        if(arguments.facetValueKey == 'name' ){
	            return 'brandName';
	        }
	    }
	    
	    if(arguments.facetName == 'category'){
	        if(arguments.facetValueKey == 'id' ){
	            return 'categoryID';
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
	            return 'productTypeID';
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
	            return 'attributeOptionID';
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
	            return 'optionID';
	        }  
	        if(arguments.facetValueKey == 'name' ){
	            return 'optionName';
	        }
	        if(arguments.facetValueKey == 'code' ){
	            return 'optionCode';
	        }
	    }
	}
	
	public struct function getFacetsMetaData(){
	    if( !structKeyExists(variables, 'cached_FacetsMetaData') ){
	        variables['cached_FacetsMetaData'] = {
    	        'brand' : {
            	    'facet'                 : 'brand',
    	            'facetIDKey'            : 'brandID',
            	    'facetNameKey'          : 'brandName',
            	    'subFacetKeyOrValue'    : 'NULL',
            	    'subFacetNameKeyOrValue' : 'NULL',
            	    'facetSlugKeyOrValue'   : 'NULL',
            	    'facetCodeKeyOrValue'   : 'NULL',
    	        },
    	        'category' : {
            	    'facet'                 : 'category',
    	            'facetIDKey'            : 'categoryID',
            	    'facetNameKey'          : 'categoryName',
            	    'subFacetKeyOrValue'    : 'NULL',
            	    'subFacetNameKeyOrValue' : 'NULL',
            	    'facetSlugKeyOrValue'   : 'categoryURLTitle',
            	    'facetCodeKeyOrValue'   : 'NULL',
    	        },
    	        'productType' : {
            	    'facet'                 : 'productType',
    	            'facetIDKey'            : 'productTypeID',
            	    'facetNameKey'          : 'productTypeName',
            	    'subFacetKeyOrValue'    : 'NULL',
            	    'subFacetNameKeyOrValue' : 'NULL',
            	    'facetSlugKeyOrValue'   : 'productTypeURLTitle',
            	    'facetCodeKeyOrValue'   : 'NULL',
    	        },
    	        'option' : {
            	    'facet'                 : 'option',
    	            'facetIDKey'            : 'optionID',
            	    'facetNameKey'          : 'optionName',
            	    'subFacetKeyOrValue'    : 'optionGroupCode',
            	    'subFacetNameKeyOrValue': 'optionGroupName',
            	    'facetSlugKeyOrValue'   : 'NULL',
            	    'facetCodeKeyOrValue'   : 'optionCode',
    	        },
    	        'attribute' : {
            	    'facet'                 : 'attribute',
    	            'facetIDKey'            : 'attributeOptionID',
            	    'facetNameKey'          : 'attributeOptionLabel',
            	    'subFacetKeyOrValue'    : 'attributeCode',
            	    'subFacetNameKeyOrValue': 'attributeName',
            	    'facetSlugKeyOrValue'   : 'attributeOptionUrlTitle',
            	    'facetCodeKeyOrValue'   : 'attributeOptionValue',
    	        }
    	    }
	    }
	    
	    return variables['cached_FacetsMetaData'];
	}
	
	public string function makeGetFacetOptionQuery(
	    required struct facetMetaData, 
	    required struct facetsFilterQueryFragments, 
	    required any site,
	    boolean includeSKUCount=true
	){
	    
	    var facetQuery = "";
	    if(arguments.includeSKUCount){
    	    facetQuery = "
    	        SELECT 
    	            rs.id, 
    	            rs.name, 
    	            rs.facet, 
    	            rs.subFacet, 
    	            rs.subFacetName, 
    	            rs.slug, 
    	            rs.code, 
    	            COUNT(DISTINCT rs.skuID) AS count 
    	        FROM
    	        ( 
    	            SELECT 
        				skuID, 
        				$facetIDKey$                as id, 
        				$facetNameKey$              as name, 
        				$facetSlugKeyOrValue$       as slug,
        				$facetCodeKeyOrValue$       as code,
        				'$facet$'                   as facet, 
        				$subFacetKeyOrValue$        as subFacet,
        				$subFacetNameKeyOrValue$    as subFacetName
        			FROM swProductFilterFacetOption 
        			WHERE $facetIDKey$ IS NOT NULL
        			$filterQueryFragment$
        			GROUP BY skuID, $facetIDKey$, $facetNameKey$
        		) rs
        		
        		$stockAvailabilitySQLFragment$
        	    
        	    GROUP BY rs.id
        	    HAVING COUNT(DISTINCT rs.skuID) > 0
    	    ";
	    } else {
	        facetQuery = "
                SELECT 
    	            id, 
    	            name, 
    	            facet, 
    	            subFacet, 
    	            subFacetName, 
    	            slug, 
    	            code 
    	        FROM
    	        ( 
    	            SELECT 
        				skuID, 
        				$facetIDKey$                as id, 
        				$facetNameKey$              as name, 
        				$facetSlugKeyOrValue$       as slug,
        				$facetCodeKeyOrValue$       as code,
        				'$facet$'                   as facet, 
        				$subFacetKeyOrValue$        as subFacet,
        				$subFacetNameKeyOrValue$    as subFacetName
        			FROM swProductFilterFacetOption 
        			WHERE $facetIDKey$ IS NOT NULL
        			$filterQueryFragment$
        			GROUP BY skuID, $facetIDKey$, $facetNameKey$
        		) rs
        		
        		$stockAvailabilitySQLFragment$
        	    GROUP BY id
    		";
	    }
	    
        facetQuery = replace(facetQuery, '$facet$',              arguments.facetMetaData.facet );
        facetQuery = replace(facetQuery, '$facetIDKey$',         arguments.facetMetaData.facetIDKey, 'all');
        facetQuery = replace(facetQuery, '$facetNameKey$',       arguments.facetMetaData.facetNameKey, 'all');
        facetQuery = replace(facetQuery, '$facetSlugKeyOrValue$', arguments.facetMetaData.facetSlugKeyOrValue );
        facetQuery = replace(facetQuery, '$facetCodeKeyOrValue$', arguments.facetMetaData.facetCodeKeyOrValue );
        facetQuery = replace(facetQuery, '$subFacetKeyOrValue$',  arguments.facetMetaData.subFacetKeyOrValue );
        facetQuery = replace(facetQuery, '$subFacetNameKeyOrValue$',  arguments.facetMetaData.subFacetNameKeyOrValue );
        
        var filterQueryFragment = '';
        if( !this.hibachiIsStructEmpty(arguments.facetsFilterQueryFragments) ){
            for(var facetName in arguments.facetsFilterQueryFragments ){
                if(facetName == arguments.facetMetaData.facet ){
                    continue;
                }
                if( !len(arguments.facetsFilterQueryFragments[facetName]) ){
                    continue;
                }

                if( len(filterQueryFragment) > 1 ){
                    filterQueryFragment &= ' AND';
                }
                filterQueryFragment &= ' '&arguments.facetsFilterQueryFragments[facetName];
            }
            
            if(len(filterQueryFragment)){
                filterQueryFragment = 'AND '&filterQueryFragment;
            }
        }
        facetQuery = replace(facetQuery, '$filterQueryFragment$', filterQueryFragment );
        
        var stockAvailabilitySQLFragment = '';
        if(arguments.site.hasLocation() ){
            // the :siteID param should already be added
	        // facetsSqlFilterQueryParams['siteID'] = arguments.site.getSiteID();
            stockAvailabilitySQLFragment = "
    	        INNER JOIN swStock stk 
    	            ON 
	                stk.stockID IN (SELECT DISTINCT locationID from swLocationSite WHERE siteID = :siteID )
    	            AND stk.calculatedQATS > 0 
    	            AND rs.skuID = stk.skuID 
            ";
	    }
        facetQuery = replace(facetQuery, '$stockAvailabilitySQLFragment$', stockAvailabilitySQLFragment );
        
        return facetQuery;
	}
	
	public struct function makeFacteSqlFilterQueryFragments(){
	    param name="arguments.site";
	    param name="arguments.brand" default={};
	    param name="arguments.option" default={};
	    param name="arguments.category" default={};
	    param name="arguments.attribute" default={};
	    param name="arguments.productType" default={};
	    
	    var facetsSqlFilterQueryFragments = {};
	    var facetsSqlFilterQueryParams = {};
	    
	    facetsSqlFilterQueryFragments['productSite'] = '';
	    if( len(arguments.site.getSiteID()) ){
	        facetsSqlFilterQueryParams['siteID'] = arguments.site.getSiteID();
	        facetsSqlFilterQueryFragments['productSite'] = '(siteID = :siteID OR siteID IS NULL)';
	    }
	    
	    // CF-Server's date-time instead of BD-Server's 
	    facetsSqlFilterQueryParams['dateTimeNow'] = dateTimeFormat(now(), 'short');
	    facetsSqlFilterQueryFragments['productPublishedPeriod'] = "
	        ( productPublishedStartDateTime IS NULL OR productPublishedStartDateTime <= :dateTimeNow )
            AND ( productPublishedEndDateTime IS NULL OR productPublishedEndDateTime >= :dateTimeNow )
	    ";

	    for(var facetName in ['brand', 'category', 'productType'] ){
    	    facetsSqlFilterQueryFragments[facetName] = '';
    	    var selectedFacetOptions = arguments[ facetName ];
    	    if( !this.hibachiIsStructEmpty(selectedFacetOptions) ){
    	        var queryFragment = '(';
    	        for(var facteValueKey in selectedFacetOptions ){
                    var filterValue = selectedFacetOptions[facteValueKey];
                    var columnName = this.getFacetFilterKeyColumnNameByFacetNameAndFacetValueKay(facetName, facteValueKey);
                    
                    if( !isNUll(columnName) ){
                        var filterValuePlaceholder = columnName&'_'&facteValueKey;
                        facetsSqlFilterQueryParams[ filterValuePlaceholder ] = filterValue;
                        
                        if( len(queryFragment) > 1 ){
                            queryFragment &= ' AND';
                        }
                        
                        if( isArray(filterValue) ){
                            queryFragment &= ' #columnName# IN (:#filterValuePlaceholder#)';
                        } else{
                            queryFragment &= ' #columnName# = :#filterValuePlaceholder#';
                        }
                    }
                }
                if( len(queryFragment) > 1){
                    queryFragment &= ')';
                    facetsSqlFilterQueryFragments[facetName] = queryFragment;
                }
    	    }
	    }
	    // TODO: refctor
	    for(var facetName in ['option', 'attribute'] ){
    	    facetsSqlFilterQueryFragments[facetName] = '';
    	    var selectedFacetOptions = arguments[ facetName ];
    	    if( !this.hibachiIsStructEmpty(selectedFacetOptions) ){
    	        var queryFragment = '(';
    	        for(var subFacetName in selectedFacetOptions ){
    	            var selectedSubFacetOptions = selectedFacetOptions[ subFacetName ];
    	            if(!this.hibachiIsStructEmpty(selectedSubFacetOptions) ){
            	        for(var facteValueKey in selectedSubFacetOptions ){
                            var filterValue = selectedSubFacetOptions[facteValueKey];
                            var columnName = this.getFacetFilterKeyColumnNameByFacetNameAndFacetValueKay(facetName, facteValueKey);
                            if( !isNUll(columnName) ){
                                var filterValuePlaceholder = subFacetName&'_'&columnName&'_'&facteValueKey;
                                facetsSqlFilterQueryParams[ filterValuePlaceholder ] = filterValue;
                                
                                if( len(queryFragment) > 1 ){
                                    queryFragment &= ' AND';
                                }
                                
                                if( isArray(filterValue) ){
                                    queryFragment &= ' #columnName# IN (:#filterValuePlaceholder#)';
                                } else{
                                    queryFragment &= ' #columnName# = :#filterValuePlaceholder#';
                                }
                            }
                        }
    	            }
    	        }
                if( len(queryFragment) > 1){
                    queryFragment &= ')';
                    facetsSqlFilterQueryFragments[facetName] = queryFragment;
                }
    	    }
	    }
	    
	    return {
	        'params': facetsSqlFilterQueryParams,
	        'fragments' : facetsSqlFilterQueryFragments
	    };
	}
	
	public any function getPotentialFilterFacetsAndOptions(){
        param name="arguments.site";
        param name="arguments.brand" default={};
        param name="arguments.option" default={};
        param name="arguments.category" default={};
        param name="arguments.attribute" default={};
        param name="arguments.productType" default={};
        param name="arguments.includeSKUCount" default=true;
        
        var startTicks = getTickCount();

	    var facetsMetadata = this.getFacetsMetaData();
    	var filterQueryFragmentsData = this.makeFacteSqlFilterQueryFragments(argumentCollection=arguments);

        var getAllFacetOptionsSQL = '';
        for(var facetName in facetsMetadata ){
            if( len(getAllFacetOptionsSQL) ){
               // union-all because there won't be any duplictes in the result-set, 
               // so we can avoide some computation, by avoiding the sorting of result-set to remove duplicates [ behaviour of simple UNION]
               getAllFacetOptionsSQL &= " 
                                        
                                        UNION ALL
                                        
                                        "; 
            }
            getAllFacetOptionsSQL &= this.makeGetFacetOptionQuery(
                facetMetaData = facetsMetadata[facetName], 
                facetsFilterQueryFragments = filterQueryFragmentsData.fragments, 
                includeSKUCount= arguments.includeSKUCount, 
                site = arguments.site 
            );
        }
                
        var queryService = new Query();
        queryService.setSQL(getAllFacetOptionsSQL);
        for(var paramName in filterQueryFragmentsData.params ){
            var paramValue = filterQueryFragmentsData.params[paramName];
            if( isArray(paramValue) ){
                queryService.addParam( name=paramName, list=true, value=arrayToList(paramValue) );
            } else {
                queryService.addParam( name=paramName, value=paramValue );
            }
        }
        queryService = queryService.execute().getResult();
        this.logHibachi("SlatwallProductSearchDAO:: getPotentialProductFilterFacetOptions took #getTickCount()-startTicks# ms.; and fetched #queryService.recordCount# records ");
        return queryService;
	}

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
