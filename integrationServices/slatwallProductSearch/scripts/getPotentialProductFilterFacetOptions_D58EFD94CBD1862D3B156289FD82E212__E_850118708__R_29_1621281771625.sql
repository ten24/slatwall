
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
	     AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL) AND (  productTypeID = '2c918086738dd3360173a1abdbca0469' ) AND (  brandName = 'Sargent' ) 
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
	     AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL) AND (  productTypeID = '2c918086738dd3360173a1abdbca0469' ) AND (  brandName = 'Sargent' ) 
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
	     AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL) AND (  brandName = 'Sargent' )
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
	     AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL) AND (  productTypeID = '2c918086738dd3360173a1abdbca0469' )
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
	     AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL) AND (  productTypeID = '2c918086738dd3360173a1abdbca0469' ) AND (  brandName = 'Sargent' )
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
	        
	        
	        /** Time Took 850118708 in fetching 29 records*/
	        
	        
	        /** Result */
	        /** 
	        
	            [{"facet":"option","count":2,"slug":"","code":"EB690","name":"Dark Bronze (690)","id":"2c918086765110130176511f4d650031","subFacetName":"Door Knob: Finish","subFacet":"doorKnobFinish"},{"facet":"option","count":2,"slug":"","code":"EN689","name":"Aluminum (689)","id":"2c918086765110130176511f4d650032","subFacetName":"Door Knob: Finish","subFacet":"doorKnobFinish"},{"facet":"productType","count":24,"slug":"levers","code":"","name":"Levers","id":"2c91808575d3a3570175e61bf97d0017","subFacetName":"","subFacet":""},{"facet":"productType","count":28,"slug":"parts-accessories","code":"","name":"Parts & Accessories","id":"2c91808575d3a3570175e61c6ae00018","subFacetName":"","subFacet":""},{"facet":"productType","count":28,"slug":"trim","code":"","name":"Trim","id":"2c91808575d3a3570175e61d2537001a","subFacetName":"","subFacet":""},{"facet":"productType","count":28,"slug":"mortise-cylinders","code":"","name":"Mortise Cylinders","id":"2c91808575d3a3570175e61dd863001c","subFacetName":"","subFacet":""},{"facet":"productType","count":115,"slug":"plugs","code":"","name":"Plugs","id":"2c91808575d3a3570175e61e7dee001e","subFacetName":"","subFacet":""},{"facet":"productType","count":1,"slug":"storefront-deadbolts","code":"","name":"Storefront Deadbolts","id":"2c91808575d3a3570175e643ff390023","subFacetName":"","subFacet":""},{"facet":"productType","count":10,"slug":"key-in-knob","code":"","name":"Key-In-Knob","id":"2c91808575d3a3570175e6443f9f0024","subFacetName":"","subFacet":""},{"facet":"productType","count":2,"slug":"knobs","code":"","name":"Knobs","id":"2c91808575d3a3570175e64489ed0025","subFacetName":"","subFacet":""},{"facet":"productType","count":4,"slug":"rim-cylinders","code":"","name":"Rim Cylinders","id":"2c91808575d3a3570175e644dac70026","subFacetName":"","subFacet":""},{"facet":"productType","count":7,"slug":"mortise-bodies","code":"","name":"Mortise Bodies","id":"2c91808575d3a3570175e645cd300028","subFacetName":"","subFacet":""},{"facet":"productType","count":9,"slug":"miscellaneous","code":"","name":"MISCELLANEOUS","id":"2c91808575d3a3570175e6461d7f0029","subFacetName":"","subFacet":""},{"facet":"productType","count":21,"slug":"pins-pinning-parts","code":"","name":"Pins & Pinning Parts","id":"2c91808575d3a3570175e6467980002a","subFacetName":"","subFacet":""},{"facet":"productType","count":1,"slug":"brass","code":"","name":"Brass","id":"2c91808575d3a3570175e64744d5002d","subFacetName":"","subFacet":""},{"facet":"productType","count":1,"slug":"cams","code":"","name":"CAMS","id":"2c91808575d3a3570175e673f2f6002f","subFacetName":"","subFacet":""},{"facet":"productType","count":3,"slug":"heavy-duty","code":"","name":"Heavy Duty","id":"2c91808575d3a3570175e674783b0030","subFacetName":"","subFacet":""},{"facet":"productType","count":49,"slug":"originals","code":"","name":"Originals","id":"2c91808575d3a3570175e67560620031","subFacetName":"","subFacet":""},{"facet":"productType","count":2,"slug":"parts","code":"","name":"Parts","id":"2c91808575d3a3570175e675cced0032","subFacetName":"","subFacet":""},{"facet":"productType","count":6,"slug":"rim-exit-devices","code":"","name":"Rim Exit Devices","id":"2c91808575d3a3570175e6803567003c","subFacetName":"","subFacet":""},{"facet":"productType","count":4,"slug":"door-closer-parts","code":"","name":"Door Closer Parts","id":"2c918086738dd3360173a1abdbca0469","subFacetName":"","subFacet":""},{"facet":"productType","count":5,"slug":"ic-cores","code":"","name":"IC Cores","id":"2c91808e72edb2a80173248b44d20c00","subFacetName":"","subFacet":""},{"facet":"productType","count":2,"slug":"rim-housings","code":"","name":"Rim Housings","id":"2c91808e72edb2a80173248c17870c02","subFacetName":"","subFacet":""},{"facet":"productType","count":3,"slug":"mortise-trims","code":"","name":"Mortise Trims","id":"2c938084760493a2017604ee719d29b4","subFacetName":"","subFacet":""},{"facet":"productType","count":1,"slug":"mortise-deadlocks","code":"","name":"Mortise Deadlocks","id":"2c938084760493a2017604ee76fc29ed","subFacetName":"","subFacet":""},{"facet":"brand","count":55,"slug":"","code":"","name":"LCN","id":"2c918086738dd3360173a1ac3650046a","subFacetName":"","subFacet":""},{"facet":"brand","count":7,"slug":"","code":"","name":"Yale","id":"2c92808476e1c29f0176e1d042da02ab","subFacetName":"","subFacet":""},{"facet":"brand","count":4,"slug":"","code":"","name":"Sargent","id":"2c938084760493a2017604ee29f827ad","subFacetName":"","subFacet":""},{"facet":"brand","count":1,"slug":"","code":"","name":"Lockey USA","id":"2c9a808477f346bc0177f3c1780901b5","subFacetName":"","subFacet":""}] 
	        
	        */
	    