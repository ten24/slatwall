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
	    
	    if( !structKeyExists(variables, 'cached_productFilterFacetOptionsSeletQueryColumnList') ){
	        
	        variables['cached_productFilterFacetOptionsSeletQueryColumnList'] = "
	                        
	                        productFilterFacetOptionID,
    	   
                            productID, 
                            productActiveFlag, 
                            productPublishedFlag,
                	        
                	        skuID, 
                	        skuActiveFlag, 
                	        skuPublishedFlag,
                            
                            brandID, brandName, 
                            brandActiveFlag, 
                            brandPublishedFlag,
                            
                            categoryID, categoryName, parentCategoryID, 
                            categoryUrlTitle,
                            
                            optionID, optionName, optionCode, 
                            optionSortOrder, 
                            optionActiveFlag,
                            
                            optionGroupID, optionGroupName, 
                            optionGroupSortOrder,
                            
                            productTypeID, productTypeName, parentProductTypeID, 
                            productTypeURLTitle, 
                            productTypeActiveFlag, 
                            productTypePublishedFlag,
                            
                            contentID, parentContentID,
                            contentTitle, 
                            contentActiveFlag,
                            contentUrlTitle,
                            contentSortOrder,
                            
                            siteID, siteName, siteCode, currencyCode,
                       
                            attributeID, attributeName, attributeCode, attributeInputType, 
                            attributeUrlTitle, 
                            attributeSortOrder,
                       
                            attributeSetID, attributeSetCode, attributeSetName, attributeSetObject,
                            attributeSetSortOrder,
                            attributeSetActiveFlag,
                       
                            attributeOptionID, attributeOptionValue, attributeOptionLabel,
                            attributeOptionUrlTitle,
                            attributeOptionSortOrde
                    ";
	    }
	    
	    return variables['cached_productFilterFacetOptionsSeletQueryColumnList'];
	}
	
	
	/**
	 * 
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
                return listAppend(joins, "(att.attributeCode = `#arguments.row.attributeCode#` AND sk.#arguments.row.attributeCode# = atto.attributeOptionValue)", '$' );
            } 
            return listAppend(joins, "(att.attributeCode = `#arguments.row.attributeCode#` AND p.#arguments.row.attributeCode# = atto.attributeOptionValue)", '$' );
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
		   p.activeFlag AS productActiveFlag, 
		   p.publishedFlag AS productPublishedFlag,
		   
		   sk.skuID, 
		   sk.activeFlag AS skuActiveFlag, 
		   sk.publishedFlag AS skuPublishedFlag,
		   
	       br.brandID, br.brandName, 
	       br.activeFlag AS brandActiveFlag, 
	       br.publishedFlag AS brandPublishedFlag,
	       
           cr.categoryID, cr.categoryName, cr.parentCategoryID, 
           cr.urlTitle AS categoryUrlTitle,
           
           o.optionID, o.optionName, o.optionCode, 
           o.sortOrder AS optionSortOrder, 
           o.activeFlag AS optionActiveFlag,
           
           og.optionGroupID, og.optionGroupName, 
           og.sortOrder AS optionGroupSortOrder,
           
           pt.productTypeID, pt.productTypeName, pt.parentProductTypeID, 
           pt.urlTitle AS productTypeURLTitle,
           pt.activeFlag AS productTypeActiveFlag, 
           pt.publishedFlag AS productTypePublishedFlag,
           
           co.contentID, co.parentContentID,
           co.title AS contentTitle, 
           co.activeFlag AS contentActiveFlag,
           co.urlTitle AS contentUrlTitle,
           co.sortOrder AS contentSortOrder,
           
           st.siteID, st.siteName, st.siteCode, st.currencyCode,
           
           att.attributeID, att.attributeName, att.attributeCode, att.attributeInputType,
           att.urltitle AS attributeUrlTitle,
           att.sortOrder AS attributeSortOrder,
           
           atst.attributeSetID, atst.attributeSetCode, atst.attributeSetName, atst.attributeSetObject,
           atst.sortOrder AS attributeSetSortOrder,
           atst.activeFlag AS attributeSetActiveFlag,
           
           atto.attributeOptionID, atto.attributeOptionValue, atto.attributeOptionLabel,
           atto.urltitle AS attributeOptionUrlTitle,
           atto.sortOrder AS attributeOptionSortOrde

        FROM swProduct p
        
           INNER JOIN swSku sk
                ON sk.productID = p.productID #productAndSkuIDsQueryPart#
                            
           LEFT JOIN swProductType pt
                ON pt.productTypeID = p.productTypeID

           LEFT JOIN swBrand br
                ON br.brandID = p.brandID

            LEFT JOIN swCategory cr
                ON cr.categoryID IN (SELECT DISTINCT categoryID FROM swProductCategory)
            
            LEFT JOIN swProductListingPage plp
                ON plp.productID = p.productID 
            LEFT JOIN swContent co
                ON co.contentID = plp.contentID 
                    
            LEFT JOIN swProductSite pst
                ON pst.productID = p.productID
            LEFT JOIN swSite st
                ON st.siteID = pst.siteID
                      
            LEFT JOIN swSkuOption so
                ON so.skuID = sk.skuID
            LEFT JOIN swOption o
                ON o.optionID = so.optionID

            LEFT JOIN swOptionGroup og
                ON og.optionGroupID = o.optionGroupID
                  
            LEFT JOIN SwAttribute att
        	    ON att.attributeID IN (#attributeIDs#)

            LEFT JOIN SwAttributeSet atst
                ON atst.attributeSetID = att.attributeSetID
            	
            LEFT JOIN swAttributeOption atto
            	ON(#selectTypeAttributeOptionJoinParts#)
	   ";
	        
        this.logHibachi("SlatwallProductSearchDAO:: getProductFilterFacetOptionsSeletQuerySQL took #getTickCount()-startTicks# ms. in creating the SQL string");
        
        return sql;
	}
	
	/**
	 * 
	*/
	public any function recalculateProductFilterFacetOptionsForProductsAndSkus( string productIDs = "", string skuIDs = "" ){
	    
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
            
        dump(getExistingOptionsSQL);
            
        var getExistingOptionsQuery = new Query();
        getExistingOptionsQuery.setSQL( getExistingOptionsSQL );
        getExistingOptionsQuery = getExistingOptionsQuery.execute().getResult();
	        
        this.logHibachi("SlatwallProductSearchDAO:: updateProductFilterFacetOptionsForProductsAndSkus took #getTickCount()-startTicks# ms.; in fetching existing facet-options ");
 
	    var existingFFOsMap = {};
        for( var row in getExistingOptionsQuery ){
            existingFFOsMap[ row.productFilterFacetOptionID] = row.productFilterFacetOptionID;
        }
	        
        dump("Existing ffos");
        dump(existingFFOsMap);
	        
        var getNewOptionsQuerySQL = this.getProductFilterFacetOptionsSeletQuerySQL(argumentCollection = arguments ); 
        
        dump("getNewOptionsQuerySQL: ");
        dump(getNewOptionsQuerySQL);
        
        var getNewOptionsQuery = new Query();
        getNewOptionsQuery.setSQL(getNewOptionsQuerySQL);
        var getNewOptionsQueryResult = getNewOptionsQuery.execute().getResult();
        
        var newFFOsToInsert = {};
        for( var row in getNewOptionsQueryResult ){
            if( !structKeyExists(existingFFOsMap, row.productFilterFacetOptionID) ){
                newFFOsToInsert[ row.productFilterFacetOptionID ] = row.productFilterFacetOptionID;
            } else {
                // we don't need to insert/update/delete this record as it already exist
                existingFFOsMap.delete( row.productFilterFacetOptionID ); 
            }
        }
        
        dump(newFFOsToInsert);
	        
        // now delete whatever is left from the old options as these are no-longer valid
        if( structCount(existingFFOsMap) > 0 ){
	        this.logHibachi("SlatwallProductSearchDAO:: updateProductFilterFacetOptionsForProductsAndSkus deleting #structCount(existingFFOsMap)# old options");
        
            var ffoIDsToDelete = existingFFOsMap.keyList();
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
        if( structCount(newFFOsToInsert) > 0 ){
	        this.logHibachi("SlatwallProductSearchDAO:: updateProductFilterFacetOptionsForProductsAndSkus inserting #structCount(newFFOsToInsert)# new options");

            var ffoIDsToInsert = newFFOsToInsert.keyList();
            ffoIDsToInsert = listQualify( ffoIDsToInsert , "'");
        
            var insertQuery = new Query();
            
            // we're doing another query on the DB to get the options, as doing that in the cf-code is 
            // - and it will be some complicated logic, can be buggy and hard to maintain
            // - a lot of string-manipulation, which will be slow
            // - it can create a really big string-query totransfer over the network, again slow
            var insertSQL = "
        	        INSERT INTO swProductFilterFacetOption ( 
        	            #this.getProductFilterFacetOptionsSeletQueryColumnList()# 
        	        ) 
    	            SELECT * FROM ( 
    	                #getNewOptionsQuerySQL# 
    	            ) result_set 
    	            WHERE result_set.productFilterFacetOptionID IN( #ffoIDsToInsert# )
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
                        ffo.productActiveFlag = p.activeFlag,
                        ffo.productPublishedFlag = p.publishedFlag
                ";
            break;
            case 'sku':
                sql &= " 
                    swSku sk ON sk.skuID = ffo.skuID AND sk.skuID IN (:entityIDs)
                    SET 
                        ffo.skuActiveFlag = sk.activeFlag,
                        ffo.skuPublishedFlag = sk.publishedFlag
                ";
            break;
            case 'brand':
                sql &= " 
                    swBrand br ON br.brandID = ffo.brandID AND br.brandID IN (:entityIDs)
                    SET 
                        ffo.brandName = br.brandName,
                        ffo.brandActiveFlag = br.activeFlag,
                        ffo.brandPublishedFlag = br.publishedFlag
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
                        ffo.optionSortOrder = o.sortOrder,
                        ffo.optionActiveFlag = o.activeFlag
                ";
            break;
            case 'optionGroup':
                sql &= " 
                    swOptionGroup og ON og.optionGroupID = ffo.optionGroupID AND og.optionGroupID IN (:entityIDs)
                    SET 
                        ffo.optionGroupName = o.optionGroupName,
                        ffo.optionGroupSortOrder = o.sortOrder
                ";
            break;
            case 'productType':
                sql &= " 
                    swProductType pt ON pt.productTypeID = ffo.productTypeID AND pt.productTypeID IN (:entityIDs)
                    SET 
                        ffo.productTypeName = pt.productTypeName,
                        ffo.parentProductTypeID = pt.parentProductTypeID,
                        ffo.productTypeURLTitle = pt.urlTitle,
                        ffo.productTypeActiveFlag = pt.activeFlag,
                        ffo.productTypePublishedFlag = pt.publishedFlag
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
                        ffo.attributeSetUrlTitle = atst.urltitle,
                        ffo.attributeSetActiveFlag = atst.activeFlag
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
                        ffo.contentActiveFlag = cont.activeFlag,
                        ffo.contentUrlTitle = cont.urlTitle,
                        ffo.contentSortOrder = cont.sortOrder
                ";
            break;
            default:
                throw("not supported entity-name #arguments.entityName#");
            break;
        }
            
        var q = new Query();
        q.setSQL( sql );
        q.addParam( name='entityIDs', list="true", value=arguments.entityIDs );
        q = q.execute().getResult();
        
        this.logHibachi("SlatwallProductSearchDAO:: updateProductFilterFacetOptionsByEntityNameAndIDs took #getTickCount()-startTicks# ms.; in updating facte-options for #arguments.entityName# : #arguments.entityIDs# ");
        
        return q ? : {};
	}
	
	public any function removeProductFilterFacetOptionsByEntityNameAndIDs( required string entittyName, required string entityIDs ){
	    
	    if( this.hibachiIsEmpty(arguments.entityIDs) ){
            return;
        }
        
        var startTicks = getTickCount();
        
        var sql = " 
            DELETE swProductFilterFacetOption 
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
        q = q.execute().getResult();
        
        this.logHibachi("SlatwallProductSearchDAO:: removeProductFilterFacetOptionsByEntityNameAndIDs took #getTickCount()-startTicks# ms.; in updating facte-options for #arguments.entittyName# : #arguments.entityIDs# ");
        
        return q;   
	}
	
	public any function getPotentialFilterFacetsAndOptions(){
	    param name="arguments.siteID" default='';
	    param name="arguments.productType" default='';
	    param name="arguments.category" default='';
	    param name="arguments.brands" default='';
	    param name="arguments.options" default='';
	    param name="arguments.attributeOptions" default='';
	    
        var startTicks = getTickCount();
        
        var q = new Query();

        var siteJoinFilterQueryPart = "";
        if( !this.hibachiIsEmpty(arguments.siteID) ){
            siteJoinFilterQueryPart = " AND ( ffo.siteID = :siteID OR ffo.siteID IS NULL )";
            q.addParam(name='siteID', value=arguments.siteID)
        }
        
        var productTypeJoinFilterQueryPart = " 
            AND ( ffo.productTypeActiveflag = 1 OR ffo.productTypeActiveflag IS NULL ) 
            AND ( ffo.productTypePublishedFlag = 1 OR ffo.productTypePublishedFlag IS NULL)
        ";
        if( !this.hibachiIsEmpty(arguments.productType) ){
            productTypeJoinFilterQueryPart = " AND ffo.productTypeName IN ( :productType )";
            q.addParam( name='productType', list="true", value=arguments.productType );
        }
        
        var categoryJoinFilterQueryPart = "";
        if( !this.hibachiIsEmpty(arguments.category) ){
            categoryJoinFilterQueryPart = " AND ffo.categoryName IN ( :category )";
            q.addParam( name='category', list="true", value=arguments.category );
        }
        
        var brandJoinFilterQueryPart = " 
            AND ( ffo.brandActiveFlag = 1 OR ffo.brandActiveFlag IS NULL) 
            AND ( ffo.brandPublishedFlag = 1 OR ffo.brandPublishedFlag IS NULL)
        ";
        if( !this.hibachiIsEmpty(arguments.brands) ){
            brandJoinFilterQueryPart = " AND ffo.brandName IN ( :brands )";
            q.addParam( name='brands', list="true", value=arguments.brands );
        }
        
        var optionJoinFilterQueryPart = " AND (ffo.optionActiveFlag=1 OR ffo.optionActiveFlag IS NULL)";
        if( !this.hibachiIsEmpty(arguments.options) ){
            optionJoinFilterQueryPart = " AND ffo.optionName IN ( :options )";
            q.addParam( name='options', list="true", value=arguments.options );
        }
        
        
        var attributeOptionJoinFilterQueryPart = " AND (ffo.attributeSetActiveFlag=1 OR ffo.attributeSetActiveFlag IS NULL)";
        if( !this.hibachiIsEmpty(arguments.attributeOptions) ){
            attributeOptionJoinFilterQueryPart = " AND ffo.attributeOptionValue IN ( :attributeOptions )";
            q.addParam( name='attributeOptions', list="true", value=arguments.attributeOptions );
        }

        var sql = "
            SELECT   
               ffo.productFilterFacetOptionID,
		       ffo.brandID, ffo.brandName,
               ffo.categoryID, ffo.categoryName, ffo.parentCategoryID, ffo.categoryUrlTitle,
               ffo.optionID, ffo.optionName, ffo.optionCode, ffo.optionSortOrder,
               ffo.optionGroupID, ffo.optionGroupName, ffo.optionGroupSortOrder,
               ffo.productTypeID, ffo.productTypeName, ffo.parentProductTypeID, ffo.productTypeURLTitle,
               ffo.siteID, ffo.siteName, ffo.siteCode, ffo.currencyCode,
               
               ffo.attributeID, ffo.attributeName, ffo.attributeCode, ffo.attributeInputType,
               ffo.attributeUrlTitle,ffo.attributeSortOrder,
               
               ffo.attributeSetID, ffo.attributeSetCode, ffo.attributeSetName, ffo.attributeSetObject, ffo.attributeSetSortOrder,

               ffo.attributeOptionID, ffo.attributeOptionValue, ffo.attributeOptionLabel,
               ffo.attributeOptionUrlTitle, ffo.attributeOptionSortOrde
            
            FROM swProductFilterFacetOption as ffo
            
            INNER JOIN swSkuPrice sp
                ON sp.skuID = ffo.skuID 
                    AND sp.activeFlag = 1 
                    AND ffo.skuActiveflag = 1 AND ffo.skuPublishedFlag = 1
                    AND ffo.productActiveFlag = 1 AND ffo.productPublishedFlag = 1
                    
                    #siteJoinFilterQueryPart#
            		#productTypeJoinFilterQueryPart#
                    #categoryJoinFilterQueryPart#
                    #brandJoinFilterQueryPart#
                    #optionJoinFilterQueryPart#
                    #attributeOptionJoinFilterQueryPart#
                    
            GROUP BY ffo.productFilterFacetOptionID
        ";
	    
	    
        q.setSQL( sql );
        q = q.execute().getResult();
        
        this.logHibachi("SlatwallProductSearchDAO:: getPotentialProductFilterFacetOptions took #getTickCount()-startTicks# ms.; and fetched #q.recordCount# records ");
        
        return q;
	}
	
	
	
	
	
	
	
	
    
    /**
	 * ************** NOTO IN USE
	*/
	public any function _getPotentialProductFilterFacetOptions( string productIDs = "", string skuIDs = "" ){
	    
        
        var startTicks = getTickCount();
        // we'll use these to generate the records for perticular Products and SKUs
        // which, then, will be used to update the `swProductFilterFacetOption` table;
        
        var skuJoinFilterQueryPart = ' AND ffo.skuActiveflag = 1 AND ffo.skuPublishedFlag = 1';
        var productJoinFilterQueryPart = ' AND ffo.productActiveFlag = 1 AND ffo.productPublishedFlag = 1';
        if( !this.hibachiIsEmpty(arguments.productIDs) ){
            var qualifiedProductIDs =  listQualify(arguments.productIDs, "'");
            var productJoinFilterQueryPart &= " AND ffo.productID IN (#qualifiedProductIDs#)"
        }
        if( !this.hibachiIsEmpty(arguments.skuIDs) ){
            var qualifiedSkuIDs =  listQualify(arguments.skuIDs, "'");
            var skuJoinFilterQueryPart &= " AND ffo.skuID IN (#qualifiedSkuIDs#)";
        }
                
        var sql = "
            SELECT   
               ffo.productFilterFacetOptionID,
			   ffo.productID, ffo.skuID,
		       ffo.brandID, ffo.brandName,
               ffo.categoryID, ffo.categoryName, ffo.parentCategoryID, ffo.categoryUrlTitle,
               ffo.optionID, ffo.optionName, ffo.optionCode, ffo.optionSortOrder,
               ffo.optionGroupID, ffo.optionGroupName, ffo.optionGroupSortOrder,
               ffo.productTypeID, ffo.productTypeName, ffo.parentProductTypeID, ffo.productTypeURLTitle,
               ffo.siteID, ffo.siteName, ffo.siteCode, ffo.currencyCode,
               
               ffo.attributeID, ffo.attributeName, ffo.attributeCode, ffo.attributeInputType,
               ffo.attributeUrlTitle,ffo.attributeSortOrder,
               
               ffo.attributeSetID, ffo.attributeSetCode, ffo.attributeSetName, ffo.attributeSetObject, ffo.attributeSetSortOrder,

               ffo.attributeOptionID, ffo.attributeOptionValue, ffo.attributeOptionLabel,
               ffo.attributeOptionUrlTitle, ffo.attributeOptionSortOrde
            
            FROM swProductFilterFacetOption as ffo
            
            INNER JOIN swSkuPrice sp
                ON sp.skuID = ffo.skuID 
                    AND sp.activeFlag = 1 
                    
                    #skuJoinFilterQueryPart#
                    #productJoinFilterQueryPart#
                    
            		AND ffo.brandActiveFlag = 1 AND ffo.brandPublishedFlag = 1
            		AND ffo.productTypeActiveflag = 1 AND ffo.productTypePublishedFlag = 1
                    AND ffo.optionActiveFlag=1
                    AND ffo.attributeSetActiveFlag = 1
            
            GROUP BY ffo.productFilterFacetOptionID
        ";
        
        var q = new Query();
        q.setSQL( sql );
        var result = q.execute().getResult();
        
        this.logHibachi("SlatwallProductSearchDAO:: _getPotentialProductFilterFacetOptions took #getTickCount()-startTicks# ms.; and fetched #q.recordCount# records ");
        
        return result;
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
