
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
	     AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL) AND (  productTypeID = '2c91808e72edb2a8017325f051850c6a' ) AND (  brandName IN ('COMPX SECURITY PRODUCTS','Kaba Ilco') ) 
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
	     AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL) AND (  productTypeID = '2c91808e72edb2a8017325f051850c6a' ) AND (  brandName IN ('COMPX SECURITY PRODUCTS','Kaba Ilco') ) 
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
	     AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL) AND (  brandName IN ('COMPX SECURITY PRODUCTS','Kaba Ilco') )
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
	     AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL) AND (  productTypeID = '2c91808e72edb2a8017325f051850c6a' ) AND (  brandName IN ('COMPX SECURITY PRODUCTS','Kaba Ilco') )
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
	        
	        
	        /** Time Took 6144574039 in fetching 56 records*/
	        
	        
	        /** Result */
	        /** 
	        
	            [{"facet":"productType","count":2,"slug":"paddles-levers","code":"","name":"Paddles/Levers","id":"2c918082778cf258017791898e6b07a7","subFacetName":"","subFacet":""},{"facet":"productType","count":3,"slug":"manual","code":"","name":"Manual","id":"2c91808478228855017822c61f8e02cd","subFacetName":"","subFacet":""},{"facet":"productType","count":45,"slug":"parts-accessories","code":"","name":"Parts & Accessories","id":"2c91808575d3a3570175e61c6ae00018","subFacetName":"","subFacet":""},{"facet":"productType","count":328,"slug":"mortise-cylinders","code":"","name":"Mortise Cylinders","id":"2c91808575d3a3570175e61dd863001c","subFacetName":"","subFacet":""},{"facet":"productType","count":21,"slug":"plugs","code":"","name":"Plugs","id":"2c91808575d3a3570175e61e7dee001e","subFacetName":"","subFacet":""},{"facet":"productType","count":21,"slug":"key-in-deadbolt","code":"","name":"Key-in-Deadbolt","id":"2c91808575d3a3570175e64380130022","subFacetName":"","subFacet":""},{"facet":"productType","count":26,"slug":"storefront-deadbolts","code":"","name":"Storefront Deadbolts","id":"2c91808575d3a3570175e643ff390023","subFacetName":"","subFacet":""},{"facet":"productType","count":261,"slug":"key-in-knob","code":"","name":"Key-In-Knob","id":"2c91808575d3a3570175e6443f9f0024","subFacetName":"","subFacet":""},{"facet":"productType","count":44,"slug":"rim-cylinders","code":"","name":"Rim Cylinders","id":"2c91808575d3a3570175e644dac70026","subFacetName":"","subFacet":""},{"facet":"productType","count":1,"slug":"mortise-bodies","code":"","name":"Mortise Bodies","id":"2c91808575d3a3570175e645cd300028","subFacetName":"","subFacet":""},{"facet":"productType","count":39,"slug":"miscellaneous","code":"","name":"MISCELLANEOUS","id":"2c91808575d3a3570175e6461d7f0029","subFacetName":"","subFacet":""},{"facet":"productType","count":15,"slug":"cams","code":"","name":"CAMS","id":"2c91808575d3a3570175e673f2f6002f","subFacetName":"","subFacet":""},{"facet":"productType","count":15,"slug":"parts","code":"","name":"Parts","id":"2c91808575d3a3570175e675cced0032","subFacetName":"","subFacet":""},{"facet":"productType","count":7,"slug":"picks-tension-tools-extractors","code":"","name":"Picks, Tension Tools & Extractors","id":"2c91808575d3a3570176072165ff00af","subFacetName":"","subFacet":""},{"facet":"productType","count":29,"slug":"dummy-cylinders","code":"","name":"Dummy Cylinders","id":"2c91808878351e500178354591960271","subFacetName":"","subFacet":""},{"facet":"productType","count":22,"slug":"profile-cylinders","code":"","name":"Profile Cylinders","id":"2c91808878351e5001783573365013e2","subFacetName":"","subFacet":""},{"facet":"productType","count":1,"slug":"window-locks","code":"","name":"Window Locks","id":"2c91808878351e5001783587c3fc1c66","subFacetName":"","subFacet":""},{"facet":"productType","count":1,"slug":"accessory-hardware","code":"","name":"Accessory Hardware","id":"2c91808a73b48e860173b4de98160023","subFacetName":"","subFacet":""},{"facet":"productType","count":5,"slug":"strike-plates","code":"","name":"Strike Plates","id":"2c91808a73b48e860173b4e32f4a002e","subFacetName":"","subFacet":""},{"facet":"productType","count":1,"slug":"semi-automatic","code":"","name":"Semi-Automatic","id":"2c91808a782c61aa0178350ab93e03ad","subFacetName":"","subFacet":""},{"facet":"productType","count":1,"slug":"automatic","code":"","name":"Automatic","id":"2c91808a782c61aa0178350b945404ea","subFacetName":"","subFacet":""},{"facet":"productType","count":2,"slug":"restricted","code":"","name":"Restricted","id":"2c91808a782c61aa0178350ba5ee04f9","subFacetName":"","subFacet":""},{"facet":"productType","count":31,"slug":"thumbturn","code":"","name":"Thumbturn","id":"2c91808a782c61aa0178350bf4c2057c","subFacetName":"","subFacet":""},{"facet":"productType","count":8,"slug":"ic-cores","code":"","name":"IC Cores","id":"2c91808e72edb2a80173248b44d20c00","subFacetName":"","subFacet":""},{"facet":"productType","count":26,"slug":"mortise-housings","code":"","name":"Mortise Housings","id":"2c91808e72edb2a80173248b98ec0c01","subFacetName":"","subFacet":""},{"facet":"productType","count":4,"slug":"rim-housings","code":"","name":"Rim Housings","id":"2c91808e72edb2a80173248c17870c02","subFacetName":"","subFacet":""},{"facet":"productType","count":1,"slug":"cams-tailpieces-parts","code":"","name":"Cams, Tailpieces & Parts","id":"2c91808e72edb2a8017325aafee00c51","subFacetName":"","subFacet":""},{"facet":"productType","count":13,"slug":"pin-kits","code":"","name":"Pin Kits","id":"2c91808e72edb2a8017325f051850c6a","subFacetName":"","subFacet":""},{"facet":"productType","count":22,"slug":"tailpieces","code":"","name":"Tailpieces","id":"2c928084760415380176046396d000e9","subFacetName":"","subFacet":""},{"facet":"productType","count":67,"slug":"collars","code":"","name":"Collars","id":"2c928084760415380176046ed3411178","subFacetName":"","subFacet":""},{"facet":"productType","count":25,"slug":"universal-kik-kil-kid-screwcap","code":"","name":"Universal KIK/KIL/KID Screwcap","id":"2c928084761df6e801761e138ff700b6","subFacetName":"","subFacet":""},{"facet":"productType","count":33,"slug":"universal-kik-kil-kid-c-clip","code":"","name":"Universal KIK/KIL/KID C-Clip","id":"2c928084761df6e801761e1393ce00d1","subFacetName":"","subFacet":""},{"facet":"productType","count":3,"slug":"specialty-cylinders","code":"","name":"Specialty Cylinders","id":"2c92808477fc63250177fc671f2e0187","subFacetName":"","subFacet":""},{"facet":"productType","count":11,"slug":"drawer-locks","code":"","name":"Drawer Locks","id":"2c938084760493a2017604c68a331530","subFacetName":"","subFacet":""},{"facet":"productType","count":1,"slug":"bit-barrel","code":"","name":"Bit & Barrel","id":"2c938084760493a2017604dba7d9193d","subFacetName":"","subFacet":""},{"facet":"productType","count":2,"slug":"keychain-tools","code":"","name":"Keychain Tools","id":"2c938084760493a2017604dbb2c519a1","subFacetName":"","subFacet":""},{"facet":"productType","count":1,"slug":"auto-tools","code":"","name":"Auto Tools","id":"2c9480847780af67017780b6403d0072","subFacetName":"","subFacet":""},{"facet":"productType","count":3,"slug":"keying-tools","code":"","name":"Keying Tools","id":"2c988084760a65cb01760a7261b50692","subFacetName":"","subFacet":""},{"facet":"productType","count":12,"slug":"solid-body","code":"","name":"Solid Body","id":"2c9880847771e465017771e569110004","subFacetName":"","subFacet":""},{"facet":"productType","count":3,"slug":"mailbox-locks","code":"","name":"Mailbox Locks","id":"2c9880847771e465017771e5fadc0072","subFacetName":"","subFacet":""},{"facet":"productType","count":11,"slug":"auxiliary-locks","code":"","name":"Auxiliary Locks","id":"2c9880847771e465017771e62f5c01fc","subFacetName":"","subFacet":""},{"facet":"productType","count":21,"slug":"cutters","code":"","name":"Cutters","id":"4028b08477fdbe110177fdd225750007","subFacetName":"","subFacet":""},{"facet":"productType","count":4,"slug":"brushes","code":"","name":"Brushes","id":"4028b08477fdbe110177fdd23d03009d","subFacetName":"","subFacet":""},{"facet":"brand","count":1,"slug":"","code":"","name":"Olympus Lock","id":"2c91808478228855017822c39e46004f","subFacetName":"","subFacet":""},{"facet":"brand","count":11,"slug":"","code":"","name":"COMPX SECURITY PRODUCTS","id":"2c918086765110130176513a75f60934","subFacetName":"","subFacet":""},{"facet":"brand","count":6,"slug":"","code":"","name":"Medeco Security Locks Inc","id":"2c918086765110130176513a8e76099b","subFacetName":"","subFacet":""},{"facet":"brand","count":1,"slug":"","code":"","name":"ABLOY SECURITY","id":"2c918086765110130176513a925b09ab","subFacetName":"","subFacet":""},{"facet":"brand","count":2,"slug":"","code":"","name":"Kaba Ilco","id":"2c91808a782c61aa0178350aa4e4038c","subFacetName":"","subFacet":""},{"facet":"brand","count":2,"slug":"","code":"","name":"Assa","id":"2c92808476e1c29f0176e1dde7440ad5","subFacetName":"","subFacet":""},{"facet":"brand","count":1,"slug":"","code":"","name":"Marks USA","id":"2c92808477fc63250177fc66e838000b","subFacetName":"","subFacet":""},{"facet":"brand","count":3,"slug":"","code":"","name":"Master Lock","id":"2c9480847604f663017604f9f91804ca","subFacetName":"","subFacet":""},{"facet":"brand","count":1,"slug":"","code":"","name":"Capitol Industries","id":"2c9480847791123e0177911b0c15000a","subFacetName":"","subFacet":""},{"facet":"brand","count":37,"slug":"","code":"","name":"LAB","id":"2c958084760a25f801760a2ee574000b","subFacetName":"","subFacet":""},{"facet":"brand","count":1,"slug":"","code":"","name":"American","id":"2c988084760a65cb01760a79f7c90862","subFacetName":"","subFacet":""},{"facet":"brand","count":2,"slug":"","code":"","name":"CCL","id":"2c9880847771e465017771e5695b0005","subFacetName":"","subFacet":""},{"facet":"brand","count":1,"slug":"","code":"","name":"Abus","id":"2c99808475ffd5200175ffd7e4660009","subFacetName":"","subFacet":""}] 
	        
	        */
	    