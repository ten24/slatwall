
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
	        ( productPublishedStartDateTime IS NULL OR productPublishedStartDateTime <= '5/17/21 3:50 PM' )
            AND ( productPublishedEndDateTime IS NULL OR productPublishedEndDateTime >= '5/17/21 3:50 PM' )
	     AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL) AND (  productTypeID = '2c91808e72edb2a8017325f051850c6a' ) AND (  brandName = 'COMPX SECURITY PRODUCTS' ) 
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
	        ( productPublishedStartDateTime IS NULL OR productPublishedStartDateTime <= '5/17/21 3:50 PM' )
            AND ( productPublishedEndDateTime IS NULL OR productPublishedEndDateTime >= '5/17/21 3:50 PM' )
	     AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL) AND (  productTypeID = '2c91808e72edb2a8017325f051850c6a' ) AND (  brandName = 'COMPX SECURITY PRODUCTS' ) 
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
	        ( productPublishedStartDateTime IS NULL OR productPublishedStartDateTime <= '5/17/21 3:50 PM' )
            AND ( productPublishedEndDateTime IS NULL OR productPublishedEndDateTime >= '5/17/21 3:50 PM' )
	     AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL) AND (  brandName = 'COMPX SECURITY PRODUCTS' )
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
	        ( productPublishedStartDateTime IS NULL OR productPublishedStartDateTime <= '5/17/21 3:50 PM' )
            AND ( productPublishedEndDateTime IS NULL OR productPublishedEndDateTime >= '5/17/21 3:50 PM' )
	     AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL) AND (  productTypeID = '2c91808e72edb2a8017325f051850c6a' )
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
	        ( productPublishedStartDateTime IS NULL OR productPublishedStartDateTime <= '5/17/21 3:50 PM' )
            AND ( productPublishedEndDateTime IS NULL OR productPublishedEndDateTime >= '5/17/21 3:50 PM' )
	     AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL) AND (  productTypeID = '2c91808e72edb2a8017325f051850c6a' ) AND (  brandName = 'COMPX SECURITY PRODUCTS' )
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
	        
	        
	        /** Time Took 66062631 in fetching 14 records*/
	        
	        
	        /** Result */
	        /** 
	        
	            [{"facet":"productType","count":11,"slug":"pin-kits","code":"","name":"Pin Kits","id":"2c91808e72edb2a8017325f051850c6a","subFacetName":"","subFacet":""},{"facet":"brand","count":1,"slug":"","code":"","name":"Olympus Lock","id":"2c91808478228855017822c39e46004f","subFacetName":"","subFacet":""},{"facet":"brand","count":11,"slug":"","code":"","name":"COMPX SECURITY PRODUCTS","id":"2c918086765110130176513a75f60934","subFacetName":"","subFacet":""},{"facet":"brand","count":6,"slug":"","code":"","name":"Medeco Security Locks Inc","id":"2c918086765110130176513a8e76099b","subFacetName":"","subFacet":""},{"facet":"brand","count":1,"slug":"","code":"","name":"ABLOY SECURITY","id":"2c918086765110130176513a925b09ab","subFacetName":"","subFacet":""},{"facet":"brand","count":2,"slug":"","code":"","name":"Kaba Ilco","id":"2c91808a782c61aa0178350aa4e4038c","subFacetName":"","subFacet":""},{"facet":"brand","count":2,"slug":"","code":"","name":"Assa","id":"2c92808476e1c29f0176e1dde7440ad5","subFacetName":"","subFacet":""},{"facet":"brand","count":1,"slug":"","code":"","name":"Marks USA","id":"2c92808477fc63250177fc66e838000b","subFacetName":"","subFacet":""},{"facet":"brand","count":3,"slug":"","code":"","name":"Master Lock","id":"2c9480847604f663017604f9f91804ca","subFacetName":"","subFacet":""},{"facet":"brand","count":1,"slug":"","code":"","name":"Capitol Industries","id":"2c9480847791123e0177911b0c15000a","subFacetName":"","subFacet":""},{"facet":"brand","count":37,"slug":"","code":"","name":"LAB","id":"2c958084760a25f801760a2ee574000b","subFacetName":"","subFacet":""},{"facet":"brand","count":1,"slug":"","code":"","name":"American","id":"2c988084760a65cb01760a79f7c90862","subFacetName":"","subFacet":""},{"facet":"brand","count":2,"slug":"","code":"","name":"CCL","id":"2c9880847771e465017771e5695b0005","subFacetName":"","subFacet":""},{"facet":"brand","count":1,"slug":"","code":"","name":"Abus","id":"2c99808475ffd5200175ffd7e4660009","subFacetName":"","subFacet":""}] 
	        
	        */
	    