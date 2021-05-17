
	        /** SQL */
            
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
        				attributeOptionID                as id, 
        				attributeOptionLabel              as name, 
        				attributeOptionUrlTitle       as slug,
        				attributeOptionValue       as code,
        				'attribute'                   as facet, 
        				attributeCode        as subFacet,
        				attributeName    as subFacetName
        			FROM swProductFilterFacetOption 
        			WHERE attributeOptionID IS NOT NULL
        			 AND  
	        ( productPublishedStartDateTime IS NULL OR productPublishedStartDateTime <= '5/17/21 4:04 PM' )
            AND ( productPublishedEndDateTime IS NULL OR productPublishedEndDateTime >= '5/17/21 4:04 PM' )
	     AND ( 
    	            
    	                skuID IN (
        	                SELECT DISTINCT skuID
        	                FROM swProductFilterFacetOption
        	                WHERE
        	                optionGroupCode = 'productFinish'
        	                 AND optionName = 'Duronautic (695)'
    	                )
    	                
    	           ) AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL) AND (  productTypeID = '2c918086738dd3360173a1abdbca0469' ) AND (  brandName IN ('Sargent','LCN','Yale') ) 
        			GROUP BY skuID, attributeOptionID, attributeOptionLabel
        		) rs
        		
        		
    	        INNER JOIN swStock stk 
    	            ON 
	                stk.locationID IN (
	                    SELECT DISTINCT locationID from swLocationSite WHERE siteID = '2c9680847491ce86017491f46ec50036' 
                			UNION ALL
                		SELECT DISTINCT locationID FROM swLocation where locationID NOT IN (SELECT DISTINCT locationID FROM swLocationSite) 
	                )
    	            AND stk.calculatedQATS > 0 
    	            AND rs.skuID = stk.skuID 
            
        	    
        	    GROUP BY rs.id
        	    HAVING COUNT(DISTINCT rs.skuID) > 0
    	     
                                        
                                        UNION ALL
                                        
                                        
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
        				optionID                as id, 
        				optionName              as name, 
        				NULL       as slug,
        				optionCode       as code,
        				'option'                   as facet, 
        				optionGroupCode        as subFacet,
        				optionGroupName    as subFacetName
        			FROM swProductFilterFacetOption 
        			WHERE optionID IS NOT NULL
        			 AND  
	        ( productPublishedStartDateTime IS NULL OR productPublishedStartDateTime <= '5/17/21 4:04 PM' )
            AND ( productPublishedEndDateTime IS NULL OR productPublishedEndDateTime >= '5/17/21 4:04 PM' )
	     AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL) AND (  productTypeID = '2c918086738dd3360173a1abdbca0469' ) AND (  brandName IN ('Sargent','LCN','Yale') )  AND ( 
    	            
    	                skuID IN (
        	                SELECT DISTINCT skuID
        	                FROM swProductFilterFacetOption
        	                WHERE
        	                optionGroupCode = 'productFinish'
        	                 AND optionName = 'Duronautic (695)'
    	                )
    	                
    	           ) AND optionGroupCode NOT IN ('productFinish')
        			GROUP BY skuID, optionID, optionName
        		) rs
        		
        		
    	        INNER JOIN swStock stk 
    	            ON 
	                stk.locationID IN (
	                    SELECT DISTINCT locationID from swLocationSite WHERE siteID = '2c9680847491ce86017491f46ec50036' 
                			UNION ALL
                		SELECT DISTINCT locationID FROM swLocation where locationID NOT IN (SELECT DISTINCT locationID FROM swLocationSite) 
	                )
    	            AND stk.calculatedQATS > 0 
    	            AND rs.skuID = stk.skuID 
            
        	    
        	    GROUP BY rs.id
        	    HAVING COUNT(DISTINCT rs.skuID) > 0
    	     UNION ALL
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
        				optionID                as id, 
        				optionName              as name, 
        				NULL       as slug,
        				optionCode       as code,
        				'option'                   as facet, 
        				optionGroupCode        as subFacet,
        				optionGroupName    as subFacetName
        			FROM swProductFilterFacetOption 
        			WHERE optionID IS NOT NULL
        			 AND  
	        ( productPublishedStartDateTime IS NULL OR productPublishedStartDateTime <= '5/17/21 4:04 PM' )
            AND ( productPublishedEndDateTime IS NULL OR productPublishedEndDateTime >= '5/17/21 4:04 PM' )
	     AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL) AND (  productTypeID = '2c918086738dd3360173a1abdbca0469' ) AND (  brandName IN ('Sargent','LCN','Yale') )  AND optionGroupCode = 'productFinish'
        			GROUP BY skuID, optionID, optionName
        		) rs
        		
        		
    	        INNER JOIN swStock stk 
    	            ON 
	                stk.locationID IN (
	                    SELECT DISTINCT locationID from swLocationSite WHERE siteID = '2c9680847491ce86017491f46ec50036' 
                			UNION ALL
                		SELECT DISTINCT locationID FROM swLocation where locationID NOT IN (SELECT DISTINCT locationID FROM swLocationSite) 
	                )
    	            AND stk.calculatedQATS > 0 
    	            AND rs.skuID = stk.skuID 
            
        	    
        	    GROUP BY rs.id
        	    HAVING COUNT(DISTINCT rs.skuID) > 0
    	     
                                        
                                        UNION ALL
                                        
                                        
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
        				productTypeID                as id, 
        				productTypeName              as name, 
        				productTypeURLTitle       as slug,
        				NULL       as code,
        				'productType'                   as facet, 
        				NULL        as subFacet,
        				NULL    as subFacetName
        			FROM swProductFilterFacetOption 
        			WHERE productTypeID IS NOT NULL
        			 AND  
	        ( productPublishedStartDateTime IS NULL OR productPublishedStartDateTime <= '5/17/21 4:04 PM' )
            AND ( productPublishedEndDateTime IS NULL OR productPublishedEndDateTime >= '5/17/21 4:04 PM' )
	     AND ( 
    	            
    	                skuID IN (
        	                SELECT DISTINCT skuID
        	                FROM swProductFilterFacetOption
        	                WHERE
        	                optionGroupCode = 'productFinish'
        	                 AND optionName = 'Duronautic (695)'
    	                )
    	                
    	           ) AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL) AND (  brandName IN ('Sargent','LCN','Yale') )
        			GROUP BY skuID, productTypeID, productTypeName
        		) rs
        		
        		
    	        INNER JOIN swStock stk 
    	            ON 
	                stk.locationID IN (
	                    SELECT DISTINCT locationID from swLocationSite WHERE siteID = '2c9680847491ce86017491f46ec50036' 
                			UNION ALL
                		SELECT DISTINCT locationID FROM swLocation where locationID NOT IN (SELECT DISTINCT locationID FROM swLocationSite) 
	                )
    	            AND stk.calculatedQATS > 0 
    	            AND rs.skuID = stk.skuID 
            
        	    
        	    GROUP BY rs.id
        	    HAVING COUNT(DISTINCT rs.skuID) > 0
    	     
                                        
                                        UNION ALL
                                        
                                        
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
        				brandID                as id, 
        				brandName              as name, 
        				NULL       as slug,
        				NULL       as code,
        				'brand'                   as facet, 
        				NULL        as subFacet,
        				NULL    as subFacetName
        			FROM swProductFilterFacetOption 
        			WHERE brandID IS NOT NULL
        			 AND  
	        ( productPublishedStartDateTime IS NULL OR productPublishedStartDateTime <= '5/17/21 4:04 PM' )
            AND ( productPublishedEndDateTime IS NULL OR productPublishedEndDateTime >= '5/17/21 4:04 PM' )
	     AND ( 
    	            
    	                skuID IN (
        	                SELECT DISTINCT skuID
        	                FROM swProductFilterFacetOption
        	                WHERE
        	                optionGroupCode = 'productFinish'
        	                 AND optionName = 'Duronautic (695)'
    	                )
    	                
    	           ) AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL) AND (  productTypeID = '2c918086738dd3360173a1abdbca0469' )
        			GROUP BY skuID, brandID, brandName
        		) rs
        		
        		
    	        INNER JOIN swStock stk 
    	            ON 
	                stk.locationID IN (
	                    SELECT DISTINCT locationID from swLocationSite WHERE siteID = '2c9680847491ce86017491f46ec50036' 
                			UNION ALL
                		SELECT DISTINCT locationID FROM swLocation where locationID NOT IN (SELECT DISTINCT locationID FROM swLocationSite) 
	                )
    	            AND stk.calculatedQATS > 0 
    	            AND rs.skuID = stk.skuID 
            
        	    
        	    GROUP BY rs.id
        	    HAVING COUNT(DISTINCT rs.skuID) > 0
    	     
                                        
                                        UNION ALL
                                        
                                        
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
        				categoryID                as id, 
        				categoryName              as name, 
        				categoryURLTitle       as slug,
        				NULL       as code,
        				'category'                   as facet, 
        				NULL        as subFacet,
        				NULL    as subFacetName
        			FROM swProductFilterFacetOption 
        			WHERE categoryID IS NOT NULL
        			 AND  
	        ( productPublishedStartDateTime IS NULL OR productPublishedStartDateTime <= '5/17/21 4:04 PM' )
            AND ( productPublishedEndDateTime IS NULL OR productPublishedEndDateTime >= '5/17/21 4:04 PM' )
	     AND ( 
    	            
    	                skuID IN (
        	                SELECT DISTINCT skuID
        	                FROM swProductFilterFacetOption
        	                WHERE
        	                optionGroupCode = 'productFinish'
        	                 AND optionName = 'Duronautic (695)'
    	                )
    	                
    	           ) AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL) AND (  productTypeID = '2c918086738dd3360173a1abdbca0469' ) AND (  brandName IN ('Sargent','LCN','Yale') )
        			GROUP BY skuID, categoryID, categoryName
        		) rs
        		
        		
    	        INNER JOIN swStock stk 
    	            ON 
	                stk.locationID IN (
	                    SELECT DISTINCT locationID from swLocationSite WHERE siteID = '2c9680847491ce86017491f46ec50036' 
                			UNION ALL
                		SELECT DISTINCT locationID FROM swLocation where locationID NOT IN (SELECT DISTINCT locationID FROM swLocationSite) 
	                )
    	            AND stk.calculatedQATS > 0 
    	            AND rs.skuID = stk.skuID 
            
        	    
        	    GROUP BY rs.id
        	    HAVING COUNT(DISTINCT rs.skuID) > 0	    
	        
	        
	        /** Time Took 474658140 in fetching 7 records*/
	        
	        
	        /** Result */
	        /** 
	        
	            [{"facet":"option","count":3,"slug":"","code":"313","name":"Duronautic (695)","id":"2c91808e757ef05301758d90688b0a50","subFacetName":"Product: Finish","subFacet":"productFinish"},{"facet":"option","count":1,"slug":"","code":"BL","name":"Flat Black (622)","id":"2c94808478a0f9760178a1883dba003c","subFacetName":"Product: Finish","subFacet":"productFinish"},{"facet":"option","count":3,"slug":"","code":"SB","name":"Aluminum (689)","id":"2c94808478a0f9760178a1888df4003d","subFacetName":"Product: Finish","subFacet":"productFinish"},{"facet":"productType","count":1,"slug":"heavy-duty","code":"","name":"Heavy Duty","id":"2c91808575d3a3570175e674783b0030","subFacetName":"","subFacet":""},{"facet":"productType","count":3,"slug":"door-closer-parts","code":"","name":"Door Closer Parts","id":"2c918086738dd3360173a1abdbca0469","subFacetName":"","subFacet":""},{"facet":"productType","count":1,"slug":"accessory-hardware","code":"","name":"Accessory Hardware","id":"2c91808a73b48e860173b4de98160023","subFacetName":"","subFacet":""},{"facet":"brand","count":3,"slug":"","code":"","name":"Yale","id":"2c92808476e1c29f0176e1d042da02ab","subFacetName":"","subFacet":""}] 
	        
	        */
	    