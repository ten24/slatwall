
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
	        ( productPublishedStartDateTime IS NULL OR productPublishedStartDateTime <= '5/17/21 3:53 PM' )
            AND ( productPublishedEndDateTime IS NULL OR productPublishedEndDateTime >= '5/17/21 3:53 PM' )
	     AND ( 
    	            
    	                skuID IN (
        	                SELECT DISTINCT skuID
        	                FROM swProductFilterFacetOption
        	                WHERE
        	                optionGroupCode = 'padlocksKeyway'
        	                 AND optionName IN ('W6000','W15','W17')
    	                )
    	                
    	            AND  
    	            
    	                skuID IN (
        	                SELECT DISTINCT skuID
        	                FROM swProductFilterFacetOption
        	                WHERE
        	                optionGroupCode = 'padlocksKeying'
        	                 AND optionName = '0-Bit'
    	                )
    	                
    	           ) AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL) AND (  productTypeID = '2c91808575d3a3570175e6b5cfd1004d' ) AND (  brandName = 'Master Lock' ) 
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
	        ( productPublishedStartDateTime IS NULL OR productPublishedStartDateTime <= '5/17/21 3:53 PM' )
            AND ( productPublishedEndDateTime IS NULL OR productPublishedEndDateTime >= '5/17/21 3:53 PM' )
	     AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL) AND (  productTypeID = '2c91808575d3a3570175e6b5cfd1004d' ) AND (  brandName = 'Master Lock' )  AND ( 
    	            
    	                skuID IN (
        	                SELECT DISTINCT skuID
        	                FROM swProductFilterFacetOption
        	                WHERE
        	                optionGroupCode = 'padlocksKeyway'
        	                 AND optionName IN ('W6000','W15','W17')
    	                )
    	                
    	            AND  
    	            
    	                skuID IN (
        	                SELECT DISTINCT skuID
        	                FROM swProductFilterFacetOption
        	                WHERE
        	                optionGroupCode = 'padlocksKeying'
        	                 AND optionName = '0-Bit'
    	                )
    	                
    	           ) AND optionGroupCode NOT IN ('padlocksKeyway','padlocksKeying')
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
	        ( productPublishedStartDateTime IS NULL OR productPublishedStartDateTime <= '5/17/21 3:53 PM' )
            AND ( productPublishedEndDateTime IS NULL OR productPublishedEndDateTime >= '5/17/21 3:53 PM' )
	     AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL) AND (  productTypeID = '2c91808575d3a3570175e6b5cfd1004d' ) AND (  brandName = 'Master Lock' )  AND (
    	            
    	                skuID IN (
        	                SELECT DISTINCT skuID
        	                FROM swProductFilterFacetOption
        	                WHERE
        	                optionGroupCode = 'padlocksKeying'
        	                 AND optionName = '0-Bit'
    	                )
    	                
    	           ) AND optionGroupCode = 'padlocksKeyway'
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
	        ( productPublishedStartDateTime IS NULL OR productPublishedStartDateTime <= '5/17/21 3:53 PM' )
            AND ( productPublishedEndDateTime IS NULL OR productPublishedEndDateTime >= '5/17/21 3:53 PM' )
	     AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL) AND (  productTypeID = '2c91808575d3a3570175e6b5cfd1004d' ) AND (  brandName = 'Master Lock' )  AND (
    	            
    	                skuID IN (
        	                SELECT DISTINCT skuID
        	                FROM swProductFilterFacetOption
        	                WHERE
        	                optionGroupCode = 'padlocksKeyway'
        	                 AND optionName IN ('W6000','W15','W17')
    	                )
    	                
    	           ) AND optionGroupCode = 'padlocksKeying'
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
	        ( productPublishedStartDateTime IS NULL OR productPublishedStartDateTime <= '5/17/21 3:53 PM' )
            AND ( productPublishedEndDateTime IS NULL OR productPublishedEndDateTime >= '5/17/21 3:53 PM' )
	     AND ( 
    	            
    	                skuID IN (
        	                SELECT DISTINCT skuID
        	                FROM swProductFilterFacetOption
        	                WHERE
        	                optionGroupCode = 'padlocksKeyway'
        	                 AND optionName IN ('W6000','W15','W17')
    	                )
    	                
    	            AND  
    	            
    	                skuID IN (
        	                SELECT DISTINCT skuID
        	                FROM swProductFilterFacetOption
        	                WHERE
        	                optionGroupCode = 'padlocksKeying'
        	                 AND optionName = '0-Bit'
    	                )
    	                
    	           ) AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL) AND (  brandName = 'Master Lock' )
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
	        ( productPublishedStartDateTime IS NULL OR productPublishedStartDateTime <= '5/17/21 3:53 PM' )
            AND ( productPublishedEndDateTime IS NULL OR productPublishedEndDateTime >= '5/17/21 3:53 PM' )
	     AND ( 
    	            
    	                skuID IN (
        	                SELECT DISTINCT skuID
        	                FROM swProductFilterFacetOption
        	                WHERE
        	                optionGroupCode = 'padlocksKeyway'
        	                 AND optionName IN ('W6000','W15','W17')
    	                )
    	                
    	            AND  
    	            
    	                skuID IN (
        	                SELECT DISTINCT skuID
        	                FROM swProductFilterFacetOption
        	                WHERE
        	                optionGroupCode = 'padlocksKeying'
        	                 AND optionName = '0-Bit'
    	                )
    	                
    	           ) AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL) AND (  productTypeID = '2c91808575d3a3570175e6b5cfd1004d' )
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
	        ( productPublishedStartDateTime IS NULL OR productPublishedStartDateTime <= '5/17/21 3:53 PM' )
            AND ( productPublishedEndDateTime IS NULL OR productPublishedEndDateTime >= '5/17/21 3:53 PM' )
	     AND ( 
    	            
    	                skuID IN (
        	                SELECT DISTINCT skuID
        	                FROM swProductFilterFacetOption
        	                WHERE
        	                optionGroupCode = 'padlocksKeyway'
        	                 AND optionName IN ('W6000','W15','W17')
    	                )
    	                
    	            AND  
    	            
    	                skuID IN (
        	                SELECT DISTINCT skuID
        	                FROM swProductFilterFacetOption
        	                WHERE
        	                optionGroupCode = 'padlocksKeying'
        	                 AND optionName = '0-Bit'
    	                )
    	                
    	           ) AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL) AND (  productTypeID = '2c91808575d3a3570175e6b5cfd1004d' ) AND (  brandName = 'Master Lock' )
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
	        
	        
	        /** Time Took 1355701537 in fetching 16 records*/
	        
	        
	        /** Result */
	        /** 
	        
	            [{"facet":"option","count":2,"slug":"","code":"W1","name":"W1","id":"2c91808372e5f4500172e6e6e05a0075","subFacetName":"Padlocks: Keyway","subFacet":"padlocksKeyway"},{"facet":"option","count":2,"slug":"","code":"W27","name":"W27","id":"2c91808372e5f4500172e6e6e05a0076","subFacetName":"Padlocks: Keyway","subFacet":"padlocksKeyway"},{"facet":"option","count":1,"slug":"","code":"W6000","name":"W6000","id":"2c91808372e5f4500172e6e6e05a0078","subFacetName":"Padlocks: Keyway","subFacet":"padlocksKeyway"},{"facet":"option","count":2,"slug":"","code":"W15","name":"W15","id":"2c91808372e5f4500172e6e6e05a0082","subFacetName":"Padlocks: Keyway","subFacet":"padlocksKeyway"},{"facet":"option","count":1,"slug":"","code":"W600A","name":"W600A","id":"2c91808372e5f4500172e6e6e05a0083","subFacetName":"Padlocks: Keyway","subFacet":"padlocksKeyway"},{"facet":"option","count":1,"slug":"","code":"81","name":"81","id":"2c91808372e5f4500172e6e6e05a0084","subFacetName":"Padlocks: Keyway","subFacet":"padlocksKeyway"},{"facet":"option","count":1,"slug":"","code":"81M","name":"81M","id":"2c91808372e5f4500172e6e6e05a0085","subFacetName":"Padlocks: Keyway","subFacet":"padlocksKeyway"},{"facet":"option","count":2,"slug":"","code":"W17","name":"W17","id":"2c91808372e5f4500172e6e6e05a0086","subFacetName":"Padlocks: Keyway","subFacet":"padlocksKeyway"},{"facet":"option","count":1,"slug":"","code":"W7000","name":"W7000","id":"2c91808372e5f4500172e6e6e05a0087","subFacetName":"Padlocks: Keyway","subFacet":"padlocksKeyway"},{"facet":"option","count":1,"slug":"","code":"W700A","name":"W700A","id":"2c91808372e5f4500172e6e6e05a0088","subFacetName":"Padlocks: Keyway","subFacet":"padlocksKeyway"},{"facet":"option","count":1,"slug":"","code":"81KM","name":"81KM","id":"2c91808372e5f4500172e6e6e05a0089","subFacetName":"Padlocks: Keyway","subFacet":"padlocksKeyway"},{"facet":"option","count":1,"slug":"","code":"81KR","name":"81KR","id":"2c91808372e5f4500172e6e6e05a0090","subFacetName":"Padlocks: Keyway","subFacet":"padlocksKeyway"},{"facet":"option","count":5,"slug":"","code":"0Bit","name":"0-Bit","id":"2c918088783591e30178362bf30e1341","subFacetName":"Padlocks : Keying","subFacet":"padlocksKeying"},{"facet":"productType","count":5,"slug":"padlock","code":"","name":"Padlock","id":"2c91808575d3a3570175e6b5cfd1004d","subFacetName":"","subFacet":""},{"facet":"productType","count":1,"slug":"laminated-steel","code":"","name":"Laminated Steel","id":"2c99808475ffd5200175ffd810cc0109","subFacetName":"","subFacet":""},{"facet":"brand","count":5,"slug":"","code":"","name":"Master Lock","id":"2c9480847604f663017604f9f91804ca","subFacetName":"","subFacet":""}] 
	        
	        */
	    