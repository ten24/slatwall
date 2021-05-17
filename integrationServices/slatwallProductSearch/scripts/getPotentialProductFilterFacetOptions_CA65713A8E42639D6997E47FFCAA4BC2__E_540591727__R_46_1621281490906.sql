
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
	        ( productPublishedStartDateTime IS NULL OR productPublishedStartDateTime <= '5/17/21 3:58 PM' )
            AND ( productPublishedEndDateTime IS NULL OR productPublishedEndDateTime >= '5/17/21 3:58 PM' )
	     AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL) AND (  productTypeID = '2c91808575d3a3570175e6b5cfd1004d' ) AND (  brandName = 'Master Lock' ) 
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
	        ( productPublishedStartDateTime IS NULL OR productPublishedStartDateTime <= '5/17/21 3:58 PM' )
            AND ( productPublishedEndDateTime IS NULL OR productPublishedEndDateTime >= '5/17/21 3:58 PM' )
	     AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL) AND (  productTypeID = '2c91808575d3a3570175e6b5cfd1004d' ) AND (  brandName = 'Master Lock' ) 
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
	        ( productPublishedStartDateTime IS NULL OR productPublishedStartDateTime <= '5/17/21 3:58 PM' )
            AND ( productPublishedEndDateTime IS NULL OR productPublishedEndDateTime >= '5/17/21 3:58 PM' )
	     AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL) AND (  brandName = 'Master Lock' )
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
	        ( productPublishedStartDateTime IS NULL OR productPublishedStartDateTime <= '5/17/21 3:58 PM' )
            AND ( productPublishedEndDateTime IS NULL OR productPublishedEndDateTime >= '5/17/21 3:58 PM' )
	     AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL) AND (  productTypeID = '2c91808575d3a3570175e6b5cfd1004d' )
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
	        ( productPublishedStartDateTime IS NULL OR productPublishedStartDateTime <= '5/17/21 3:58 PM' )
            AND ( productPublishedEndDateTime IS NULL OR productPublishedEndDateTime >= '5/17/21 3:58 PM' )
	     AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL) AND (  productTypeID = '2c91808575d3a3570175e6b5cfd1004d' ) AND (  brandName = 'Master Lock' )
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
	        
	        
	        /** Time Took 540591727 in fetching 46 records*/
	        
	        
	        /** Result */
	        /** 
	        
	            [{"facet":"option","count":2,"slug":"","code":"W1","name":"W1","id":"2c91808372e5f4500172e6e6e05a0075","subFacetName":"Padlocks: Keyway","subFacet":"padlocksKeyway"},{"facet":"option","count":2,"slug":"","code":"W27","name":"W27","id":"2c91808372e5f4500172e6e6e05a0076","subFacetName":"Padlocks: Keyway","subFacet":"padlocksKeyway"},{"facet":"option","count":1,"slug":"","code":"W6000","name":"W6000","id":"2c91808372e5f4500172e6e6e05a0078","subFacetName":"Padlocks: Keyway","subFacet":"padlocksKeyway"},{"facet":"option","count":2,"slug":"","code":"W15","name":"W15","id":"2c91808372e5f4500172e6e6e05a0082","subFacetName":"Padlocks: Keyway","subFacet":"padlocksKeyway"},{"facet":"option","count":1,"slug":"","code":"W600A","name":"W600A","id":"2c91808372e5f4500172e6e6e05a0083","subFacetName":"Padlocks: Keyway","subFacet":"padlocksKeyway"},{"facet":"option","count":1,"slug":"","code":"81","name":"81","id":"2c91808372e5f4500172e6e6e05a0084","subFacetName":"Padlocks: Keyway","subFacet":"padlocksKeyway"},{"facet":"option","count":1,"slug":"","code":"81M","name":"81M","id":"2c91808372e5f4500172e6e6e05a0085","subFacetName":"Padlocks: Keyway","subFacet":"padlocksKeyway"},{"facet":"option","count":2,"slug":"","code":"W17","name":"W17","id":"2c91808372e5f4500172e6e6e05a0086","subFacetName":"Padlocks: Keyway","subFacet":"padlocksKeyway"},{"facet":"option","count":1,"slug":"","code":"W7000","name":"W7000","id":"2c91808372e5f4500172e6e6e05a0087","subFacetName":"Padlocks: Keyway","subFacet":"padlocksKeyway"},{"facet":"option","count":1,"slug":"","code":"W700A","name":"W700A","id":"2c91808372e5f4500172e6e6e05a0088","subFacetName":"Padlocks: Keyway","subFacet":"padlocksKeyway"},{"facet":"option","count":1,"slug":"","code":"81KM","name":"81KM","id":"2c91808372e5f4500172e6e6e05a0089","subFacetName":"Padlocks: Keyway","subFacet":"padlocksKeyway"},{"facet":"option","count":1,"slug":"","code":"81KR","name":"81KR","id":"2c91808372e5f4500172e6e6e05a0090","subFacetName":"Padlocks: Keyway","subFacet":"padlocksKeyway"},{"facet":"option","count":16,"slug":"","code":"0Bit","name":"0-Bit","id":"2c918088783591e30178362bf30e1341","subFacetName":"Padlocks : Keying","subFacet":"padlocksKeying"},{"facet":"option","count":1,"slug":"","code":"V606","name":"V606","id":"2c96808478a2458b0178a24b409d006b","subFacetName":"Padlocks : Keying","subFacet":"padlocksKeying"},{"facet":"productType","count":10,"slug":"levers","code":"","name":"Levers","id":"2c91808575d3a3570175e61bf97d0017","subFacetName":"","subFacet":""},{"facet":"productType","count":54,"slug":"parts-accessories","code":"","name":"Parts & Accessories","id":"2c91808575d3a3570175e61c6ae00018","subFacetName":"","subFacet":""},{"facet":"productType","count":8,"slug":"key-in-deadbolt","code":"","name":"Key-in-Deadbolt","id":"2c91808575d3a3570175e64380130022","subFacetName":"","subFacet":""},{"facet":"productType","count":17,"slug":"storefront-deadbolts","code":"","name":"Storefront Deadbolts","id":"2c91808575d3a3570175e643ff390023","subFacetName":"","subFacet":""},{"facet":"productType","count":4,"slug":"key-in-knob","code":"","name":"Key-In-Knob","id":"2c91808575d3a3570175e6443f9f0024","subFacetName":"","subFacet":""},{"facet":"productType","count":24,"slug":"knobs","code":"","name":"Knobs","id":"2c91808575d3a3570175e64489ed0025","subFacetName":"","subFacet":""},{"facet":"productType","count":3,"slug":"miscellaneous","code":"","name":"MISCELLANEOUS","id":"2c91808575d3a3570175e6461d7f0029","subFacetName":"","subFacet":""},{"facet":"productType","count":17,"slug":"pins-pinning-parts","code":"","name":"Pins & Pinning Parts","id":"2c91808575d3a3570175e6467980002a","subFacetName":"","subFacet":""},{"facet":"productType","count":24,"slug":"brass","code":"","name":"Brass","id":"2c91808575d3a3570175e64744d5002d","subFacetName":"","subFacet":""},{"facet":"productType","count":38,"slug":"padlock","code":"","name":"Padlock","id":"2c91808575d3a3570175e6b5cfd1004d","subFacetName":"","subFacet":""},{"facet":"productType","count":1,"slug":"electronic-standalone","code":"","name":"Electronic Standalone","id":"2c91808575d3a3570175e713c14b0067","subFacetName":"","subFacet":""},{"facet":"productType","count":3,"slug":"pin-kits","code":"","name":"Pin Kits","id":"2c91808e72edb2a8017325f051850c6a","subFacetName":"","subFacet":""},{"facet":"productType","count":9,"slug":"cable-locks","code":"","name":"CABLE LOCKS","id":"2c928084761df6e801761e2295d002a4","subFacetName":"","subFacet":""},{"facet":"productType","count":11,"slug":"laminated-brass","code":"","name":"Laminated Brass","id":"2c928084761df6e801761e22983102ac","subFacetName":"","subFacet":""},{"facet":"productType","count":4,"slug":"gun-locks","code":"","name":"GUN LOCKS","id":"2c928084761df6e801761e229a2f02bc","subFacetName":"","subFacet":""},{"facet":"productType","count":21,"slug":"vehicle-security","code":"","name":"Vehicle Security","id":"2c928084761df6e801761e22b60202ca","subFacetName":"","subFacet":""},{"facet":"productType","count":3,"slug":"u-locks","code":"","name":"U-LOCKS","id":"2c928084761df6e801761e2319f002df","subFacetName":"","subFacet":""},{"facet":"productType","count":5,"slug":"luggage-locks","code":"","name":"LUGGAGE LOCKS","id":"2c928084761df6e801761e237cbb037a","subFacetName":"","subFacet":""},{"facet":"productType","count":4,"slug":"bluetooth","code":"","name":"BLUETOOTH","id":"2c928084761df6e801761e23fcb503e0","subFacetName":"","subFacet":""},{"facet":"productType","count":5,"slug":"locker-locks","code":"","name":"LOCKER LOCKS","id":"2c928084761df6e801761e2544170455","subFacetName":"","subFacet":""},{"facet":"productType","count":6,"slug":"safety","code":"","name":"Safety","id":"2c928084761df6e801761e304e0c0b5a","subFacetName":"","subFacet":""},{"facet":"productType","count":11,"slug":"round-body","code":"","name":"Round Body","id":"2c988084760a65cb01760a7c90020a1f","subFacetName":"","subFacet":""},{"facet":"productType","count":3,"slug":"puck-locks","code":"","name":"Puck Locks","id":"2c988084760a65cb01760a7e83590cea","subFacetName":"","subFacet":""},{"facet":"productType","count":61,"slug":"weatherized","code":"","name":"Weatherized","id":"2c99808475ffd5200175ffd7e43b0006","subFacetName":"","subFacet":""},{"facet":"productType","count":24,"slug":"steel","code":"","name":"Steel","id":"2c99808475ffd5200175ffd7edc3003a","subFacetName":"","subFacet":""},{"facet":"productType","count":143,"slug":"laminated-steel","code":"","name":"Laminated Steel","id":"2c99808475ffd5200175ffd810cc0109","subFacetName":"","subFacet":""},{"facet":"productType","count":1,"slug":"diskus","code":"","name":"Diskus","id":"2c99808475ffd5200175ffd834d3019e","subFacetName":"","subFacet":""},{"facet":"productType","count":28,"slug":"combination","code":"","name":"Combination","id":"2c99808475ffd5200175ffd83b4c01d1","subFacetName":"","subFacet":""},{"facet":"productType","count":7,"slug":"key-storage","code":"","name":"Key Storage","id":"2c99808475ffd5200175ffd8400701f2","subFacetName":"","subFacet":""},{"facet":"brand","count":1,"slug":"","code":"","name":"Assa","id":"2c92808476e1c29f0176e1dde7440ad5","subFacetName":"","subFacet":""},{"facet":"brand","count":38,"slug":"","code":"","name":"Master Lock","id":"2c9480847604f663017604f9f91804ca","subFacetName":"","subFacet":""},{"facet":"brand","count":31,"slug":"","code":"","name":"Abus","id":"2c99808475ffd5200175ffd7e4660009","subFacetName":"","subFacet":""}] 
	        
	        */
	    