
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
	        ( productPublishedStartDateTime IS NULL OR productPublishedStartDateTime <= '5/17/21 4:02 PM' )
            AND ( productPublishedEndDateTime IS NULL OR productPublishedEndDateTime >= '5/17/21 4:02 PM' )
	     AND ( 
    	            
    	                skuID IN (
        	                SELECT DISTINCT skuID
        	                FROM swProductFilterFacetOption
        	                WHERE
        	                optionGroupCode = 'productFinish'
        	                 AND optionName = 'Brushed Chrome (626)'
    	                )
    	                
    	           ) AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL) AND (  productTypeID = '2c9480847791123e01779122a4470ae0' ) 
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
	        ( productPublishedStartDateTime IS NULL OR productPublishedStartDateTime <= '5/17/21 4:02 PM' )
            AND ( productPublishedEndDateTime IS NULL OR productPublishedEndDateTime >= '5/17/21 4:02 PM' )
	     AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL) AND (  productTypeID = '2c9480847791123e01779122a4470ae0' )  AND ( 
    	            
    	                skuID IN (
        	                SELECT DISTINCT skuID
        	                FROM swProductFilterFacetOption
        	                WHERE
        	                optionGroupCode = 'productFinish'
        	                 AND optionName = 'Brushed Chrome (626)'
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
	        ( productPublishedStartDateTime IS NULL OR productPublishedStartDateTime <= '5/17/21 4:02 PM' )
            AND ( productPublishedEndDateTime IS NULL OR productPublishedEndDateTime >= '5/17/21 4:02 PM' )
	     AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL) AND (  productTypeID = '2c9480847791123e01779122a4470ae0' )  AND optionGroupCode = 'productFinish'
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
	        ( productPublishedStartDateTime IS NULL OR productPublishedStartDateTime <= '5/17/21 4:02 PM' )
            AND ( productPublishedEndDateTime IS NULL OR productPublishedEndDateTime >= '5/17/21 4:02 PM' )
	     AND ( 
    	            
    	                skuID IN (
        	                SELECT DISTINCT skuID
        	                FROM swProductFilterFacetOption
        	                WHERE
        	                optionGroupCode = 'productFinish'
        	                 AND optionName = 'Brushed Chrome (626)'
    	                )
    	                
    	           ) AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL)
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
	        ( productPublishedStartDateTime IS NULL OR productPublishedStartDateTime <= '5/17/21 4:02 PM' )
            AND ( productPublishedEndDateTime IS NULL OR productPublishedEndDateTime >= '5/17/21 4:02 PM' )
	     AND ( 
    	            
    	                skuID IN (
        	                SELECT DISTINCT skuID
        	                FROM swProductFilterFacetOption
        	                WHERE
        	                optionGroupCode = 'productFinish'
        	                 AND optionName = 'Brushed Chrome (626)'
    	                )
    	                
    	           ) AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL) AND (  productTypeID = '2c9480847791123e01779122a4470ae0' )
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
	        ( productPublishedStartDateTime IS NULL OR productPublishedStartDateTime <= '5/17/21 4:02 PM' )
            AND ( productPublishedEndDateTime IS NULL OR productPublishedEndDateTime >= '5/17/21 4:02 PM' )
	     AND ( 
    	            
    	                skuID IN (
        	                SELECT DISTINCT skuID
        	                FROM swProductFilterFacetOption
        	                WHERE
        	                optionGroupCode = 'productFinish'
        	                 AND optionName = 'Brushed Chrome (626)'
    	                )
    	                
    	           ) AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL) AND (  productTypeID = '2c9480847791123e01779122a4470ae0' )
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
	        
	        
	        /** Time Took 5612466837 in fetching 48 records*/
	        
	        
	        /** Result */
	        /** 
	        
	            [{"facet":"option","count":4,"slug":"","code":"26D","name":"Brushed Chrome (626)","id":"2c91808e757ef05301758d90688b0a12","subFacetName":"Product: Finish","subFacet":"productFinish"},{"facet":"productType","count":1,"slug":"in-frame-style","code":"","name":"In-Frame Style","id":"2c918082778cf2580177918f51a608fa","subFacetName":"","subFacet":""},{"facet":"productType","count":1,"slug":"deadbolts","code":"","name":"Deadbolts","id":"2c9180827791954d017791a0571701d1","subFacetName":"","subFacet":""},{"facet":"productType","count":5,"slug":"door-locks","code":"","name":"Door Locks","id":"2c91808478228855017822c408ec00d0","subFacetName":"","subFacet":""},{"facet":"productType","count":135,"slug":"levers","code":"","name":"Levers","id":"2c91808575d3a3570175e61bf97d0017","subFacetName":"","subFacet":""},{"facet":"productType","count":66,"slug":"parts-accessories","code":"","name":"Parts & Accessories","id":"2c91808575d3a3570175e61c6ae00018","subFacetName":"","subFacet":""},{"facet":"productType","count":41,"slug":"trim","code":"","name":"Trim","id":"2c91808575d3a3570175e61d2537001a","subFacetName":"","subFacet":""},{"facet":"productType","count":122,"slug":"mortise-cylinders","code":"","name":"Mortise Cylinders","id":"2c91808575d3a3570175e61dd863001c","subFacetName":"","subFacet":""},{"facet":"productType","count":69,"slug":"plugs","code":"","name":"Plugs","id":"2c91808575d3a3570175e61e7dee001e","subFacetName":"","subFacet":""},{"facet":"productType","count":19,"slug":"key-in-deadbolt","code":"","name":"Key-in-Deadbolt","id":"2c91808575d3a3570175e64380130022","subFacetName":"","subFacet":""},{"facet":"productType","count":40,"slug":"storefront-deadbolts","code":"","name":"Storefront Deadbolts","id":"2c91808575d3a3570175e643ff390023","subFacetName":"","subFacet":""},{"facet":"productType","count":143,"slug":"key-in-knob","code":"","name":"Key-In-Knob","id":"2c91808575d3a3570175e6443f9f0024","subFacetName":"","subFacet":""},{"facet":"productType","count":4,"slug":"knobs","code":"","name":"Knobs","id":"2c91808575d3a3570175e64489ed0025","subFacetName":"","subFacet":""},{"facet":"productType","count":32,"slug":"rim-cylinders","code":"","name":"Rim Cylinders","id":"2c91808575d3a3570175e644dac70026","subFacetName":"","subFacet":""},{"facet":"productType","count":14,"slug":"mortise-bodies","code":"","name":"Mortise Bodies","id":"2c91808575d3a3570175e645cd300028","subFacetName":"","subFacet":""},{"facet":"productType","count":5,"slug":"miscellaneous","code":"","name":"MISCELLANEOUS","id":"2c91808575d3a3570175e6461d7f0029","subFacetName":"","subFacet":""},{"facet":"productType","count":2,"slug":"parts","code":"","name":"Parts","id":"2c91808575d3a3570175e675cced0032","subFacetName":"","subFacet":""},{"facet":"productType","count":38,"slug":"electronic-standalone","code":"","name":"Electronic Standalone","id":"2c91808575d3a3570175e713c14b0067","subFacetName":"","subFacet":""},{"facet":"productType","count":3,"slug":"keypads","code":"","name":"Keypads","id":"2c91808575d3a3570175e7144d6e0069","subFacetName":"","subFacet":""},{"facet":"productType","count":4,"slug":"dummy-cylinders","code":"","name":"Dummy Cylinders","id":"2c91808878351e500178354591960271","subFacetName":"","subFacet":""},{"facet":"productType","count":12,"slug":"profile-cylinders","code":"","name":"Profile Cylinders","id":"2c91808878351e5001783573365013e2","subFacetName":"","subFacet":""},{"facet":"productType","count":9,"slug":"accessory-hardware","code":"","name":"Accessory Hardware","id":"2c91808a73b48e860173b4de98160023","subFacetName":"","subFacet":""},{"facet":"productType","count":6,"slug":"bolts-latches","code":"","name":"Bolts & Latches","id":"2c91808a73b48e860173b4def8a60024","subFacetName":"","subFacet":""},{"facet":"productType","count":4,"slug":"cabinet-locks","code":"","name":"Cabinet Locks","id":"2c91808a73b48e860173b4df4bfd0025","subFacetName":"","subFacet":""},{"facet":"productType","count":18,"slug":"door-stops-holders-bumpers","code":"","name":"DOOR STOPS, HOLDERS & BUMPERS","id":"2c91808a73b48e860173b4e14e9d0028","subFacetName":"","subFacet":""},{"facet":"productType","count":5,"slug":"hinges","code":"","name":"HINGES","id":"2c91808a73b48e860173b4e224ab002a","subFacetName":"","subFacet":""},{"facet":"productType","count":2,"slug":"latch-protectors","code":"","name":"LATCH PROTECTORS","id":"2c91808a73b48e860173b4e2912c002c","subFacetName":"","subFacet":""},{"facet":"productType","count":2,"slug":"pushpull-hardware","code":"","name":"PUSH/PULL HARDWARE","id":"2c91808a73b48e860173b4e2e982002d","subFacetName":"","subFacet":""},{"facet":"productType","count":5,"slug":"strike-plates","code":"","name":"Strike Plates","id":"2c91808a73b48e860173b4e32f4a002e","subFacetName":"","subFacet":""},{"facet":"productType","count":10,"slug":"thumbturn","code":"","name":"Thumbturn","id":"2c91808a782c61aa0178350bf4c2057c","subFacetName":"","subFacet":""},{"facet":"productType","count":110,"slug":"ic-cores","code":"","name":"IC Cores","id":"2c91808e72edb2a80173248b44d20c00","subFacetName":"","subFacet":""},{"facet":"productType","count":32,"slug":"mortise-housings","code":"","name":"Mortise Housings","id":"2c91808e72edb2a80173248b98ec0c01","subFacetName":"","subFacet":""},{"facet":"productType","count":6,"slug":"rim-housings","code":"","name":"Rim Housings","id":"2c91808e72edb2a80173248c17870c02","subFacetName":"","subFacet":""},{"facet":"productType","count":6,"slug":"collars","code":"","name":"Collars","id":"2c928084760415380176046ed3411178","subFacetName":"","subFacet":""},{"facet":"productType","count":13,"slug":"universal-kik-kil-kid-screwcap","code":"","name":"Universal KIK/KIL/KID Screwcap","id":"2c928084761df6e801761e138ff700b6","subFacetName":"","subFacet":""},{"facet":"productType","count":22,"slug":"universal-kik-kil-kid-c-clip","code":"","name":"Universal KIK/KIL/KID C-Clip","id":"2c928084761df6e801761e1393ce00d1","subFacetName":"","subFacet":""},{"facet":"productType","count":2,"slug":"key-in-lever","code":"","name":"Key-In-Lever","id":"2c938084760493a2017604a78cb9080a","subFacetName":"","subFacet":""},{"facet":"productType","count":19,"slug":"complete-mortise-locks","code":"","name":"Complete Mortise Locks","id":"2c938084760493a2017604aa859d0b8a","subFacetName":"","subFacet":""},{"facet":"productType","count":47,"slug":"pushbutton","code":"","name":"Pushbutton","id":"2c938084760493a2017604c416f51027","subFacetName":"","subFacet":""},{"facet":"productType","count":9,"slug":"drawer-locks","code":"","name":"Drawer Locks","id":"2c938084760493a2017604c68a331530","subFacetName":"","subFacet":""},{"facet":"productType","count":2,"slug":"mortise-trims","code":"","name":"Mortise Trims","id":"2c938084760493a2017604ee719d29b4","subFacetName":"","subFacet":""},{"facet":"productType","count":4,"slug":"electronic-networked","code":"","name":"Electronic Networked","id":"2c9480847791123e01779122a4470ae0","subFacetName":"","subFacet":""},{"facet":"productType","count":1,"slug":"electrified-levers","code":"","name":"Electrified Levers","id":"2c96808477fca3d90177fca5cf1e0033","subFacetName":"","subFacet":""},{"facet":"productType","count":3,"slug":"convertible-housings","code":"","name":"Convertible Housings","id":"2c988084760a65cb01760a79eb25084c","subFacetName":"","subFacet":""},{"facet":"productType","count":14,"slug":"cam-locks","code":"","name":"Cam Locks","id":"2c988084760a65cb01760a7cadc50a7c","subFacetName":"","subFacet":""},{"facet":"productType","count":6,"slug":"showcase-locks","code":"","name":"Showcase Locks","id":"2c9880847771e465017771e5ecb60010","subFacetName":"","subFacet":""},{"facet":"productType","count":9,"slug":"auxiliary-locks","code":"","name":"Auxiliary Locks","id":"2c9880847771e465017771e62f5c01fc","subFacetName":"","subFacet":""},{"facet":"brand","count":4,"slug":"","code":"","name":"Alarm Lock","id":"2c9480847791123e01779122657d0acf","subFacetName":"","subFacet":""}] 
	        
	        */
	    