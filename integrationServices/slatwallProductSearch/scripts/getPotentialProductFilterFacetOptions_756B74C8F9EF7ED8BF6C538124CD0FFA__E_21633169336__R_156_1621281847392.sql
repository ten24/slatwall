
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
	        ( productPublishedStartDateTime IS NULL OR productPublishedStartDateTime <= '5/17/21 4:03 PM' )
            AND ( productPublishedEndDateTime IS NULL OR productPublishedEndDateTime >= '5/17/21 4:03 PM' )
	     AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL) AND (  productTypeID = '2c918086738dd3360173a1abdbca0469' ) 
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
	        ( productPublishedStartDateTime IS NULL OR productPublishedStartDateTime <= '5/17/21 4:03 PM' )
            AND ( productPublishedEndDateTime IS NULL OR productPublishedEndDateTime >= '5/17/21 4:03 PM' )
	     AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL) AND (  productTypeID = '2c918086738dd3360173a1abdbca0469' ) 
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
	        ( productPublishedStartDateTime IS NULL OR productPublishedStartDateTime <= '5/17/21 4:03 PM' )
            AND ( productPublishedEndDateTime IS NULL OR productPublishedEndDateTime >= '5/17/21 4:03 PM' )
	     AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL)
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
	        ( productPublishedStartDateTime IS NULL OR productPublishedStartDateTime <= '5/17/21 4:03 PM' )
            AND ( productPublishedEndDateTime IS NULL OR productPublishedEndDateTime >= '5/17/21 4:03 PM' )
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
	        ( productPublishedStartDateTime IS NULL OR productPublishedStartDateTime <= '5/17/21 4:03 PM' )
            AND ( productPublishedEndDateTime IS NULL OR productPublishedEndDateTime >= '5/17/21 4:03 PM' )
	     AND (siteID = '2c9680847491ce86017491f46ec50036' OR siteID IS NULL) AND (  productTypeID = '2c918086738dd3360173a1abdbca0469' )
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
	        
	        
	        /** Time Took 21633169336 in fetching 156 records*/
	        
	        
	        /** Result */
	        /** 
	        
	            [{"facet":"option","count":2,"slug":"","code":"EB690","name":"Dark Bronze (690)","id":"2c918086765110130176511f4d650031","subFacetName":"Door Knob: Finish","subFacet":"doorKnobFinish"},{"facet":"option","count":2,"slug":"","code":"EN689","name":"Aluminum (689)","id":"2c918086765110130176511f4d650032","subFacetName":"Door Knob: Finish","subFacet":"doorKnobFinish"},{"facet":"option","count":3,"slug":"","code":"313","name":"Duronautic (695)","id":"2c91808e757ef05301758d90688b0a50","subFacetName":"Product: Finish","subFacet":"productFinish"},{"facet":"option","count":1,"slug":"","code":"BL","name":"Flat Black (622)","id":"2c94808478a0f9760178a1883dba003c","subFacetName":"Product: Finish","subFacet":"productFinish"},{"facet":"option","count":3,"slug":"","code":"SB","name":"Aluminum (689)","id":"2c94808478a0f9760178a1888df4003d","subFacetName":"Product: Finish","subFacet":"productFinish"},{"facet":"productType","count":4,"slug":"surface-mount-style","code":"","name":"Surface Mount Style","id":"2c918082778cf2580177918558be030b","subFacetName":"","subFacet":""},{"facet":"productType","count":33,"slug":"paddles-levers","code":"","name":"Paddles/Levers","id":"2c918082778cf258017791898e6b07a7","subFacetName":"","subFacet":""},{"facet":"productType","count":9,"slug":"mortise-exit-devices","code":"","name":"Mortise Exit Devices","id":"2c918082778cf2580177918c8e520880","subFacetName":"","subFacet":""},{"facet":"productType","count":21,"slug":"in-frame-style","code":"","name":"In-Frame Style","id":"2c918082778cf2580177918f51a608fa","subFacetName":"","subFacet":""},{"facet":"productType","count":27,"slug":"deadlatches","code":"","name":"Deadlatches","id":"2c9180827791954d017791a02ef50117","subFacetName":"","subFacet":""},{"facet":"productType","count":3,"slug":"hookbolts","code":"","name":"Hookbolts","id":"2c9180827791954d017791a0329f0128","subFacetName":"","subFacet":""},{"facet":"productType","count":1,"slug":"deadbolts","code":"","name":"Deadbolts","id":"2c9180827791954d017791a0571701d1","subFacetName":"","subFacet":""},{"facet":"productType","count":1,"slug":"burglary-fire","code":"","name":"Burglary/Fire","id":"2c91808277abbcd30177b98334b0024a","subFacetName":"","subFacet":""},{"facet":"productType","count":5,"slug":"door-locks","code":"","name":"Door Locks","id":"2c91808478228855017822c408ec00d0","subFacetName":"","subFacet":""},{"facet":"productType","count":4,"slug":"continuous-hinges","code":"","name":"Continuous Hinges","id":"2c91808478228855017822c422fa00f1","subFacetName":"","subFacet":""},{"facet":"productType","count":5,"slug":"manual","code":"","name":"Manual","id":"2c91808478228855017822c61f8e02cd","subFacetName":"","subFacet":""},{"facet":"productType","count":9,"slug":"miscellaneous-storage","code":"","name":"Miscellaneous Storage","id":"2c9180847822885501782664fbdb095e","subFacetName":"","subFacet":""},{"facet":"productType","count":274,"slug":"levers","code":"","name":"Levers","id":"2c91808575d3a3570175e61bf97d0017","subFacetName":"","subFacet":""},{"facet":"productType","count":645,"slug":"parts-accessories","code":"","name":"Parts & Accessories","id":"2c91808575d3a3570175e61c6ae00018","subFacetName":"","subFacet":""},{"facet":"productType","count":171,"slug":"trim","code":"","name":"Trim","id":"2c91808575d3a3570175e61d2537001a","subFacetName":"","subFacet":""},{"facet":"productType","count":610,"slug":"mortise-cylinders","code":"","name":"Mortise Cylinders","id":"2c91808575d3a3570175e61dd863001c","subFacetName":"","subFacet":""},{"facet":"productType","count":261,"slug":"plugs","code":"","name":"Plugs","id":"2c91808575d3a3570175e61e7dee001e","subFacetName":"","subFacet":""},{"facet":"productType","count":49,"slug":"key-in-deadbolt","code":"","name":"Key-in-Deadbolt","id":"2c91808575d3a3570175e64380130022","subFacetName":"","subFacet":""},{"facet":"productType","count":186,"slug":"storefront-deadbolts","code":"","name":"Storefront Deadbolts","id":"2c91808575d3a3570175e643ff390023","subFacetName":"","subFacet":""},{"facet":"productType","count":350,"slug":"key-in-knob","code":"","name":"Key-In-Knob","id":"2c91808575d3a3570175e6443f9f0024","subFacetName":"","subFacet":""},{"facet":"productType","count":186,"slug":"knobs","code":"","name":"Knobs","id":"2c91808575d3a3570175e64489ed0025","subFacetName":"","subFacet":""},{"facet":"productType","count":140,"slug":"rim-cylinders","code":"","name":"Rim Cylinders","id":"2c91808575d3a3570175e644dac70026","subFacetName":"","subFacet":""},{"facet":"productType","count":27,"slug":"mortise-bodies","code":"","name":"Mortise Bodies","id":"2c91808575d3a3570175e645cd300028","subFacetName":"","subFacet":""},{"facet":"productType","count":217,"slug":"miscellaneous","code":"","name":"MISCELLANEOUS","id":"2c91808575d3a3570175e6461d7f0029","subFacetName":"","subFacet":""},{"facet":"productType","count":645,"slug":"pins-pinning-parts","code":"","name":"Pins & Pinning Parts","id":"2c91808575d3a3570175e6467980002a","subFacetName":"","subFacet":""},{"facet":"productType","count":140,"slug":"brass","code":"","name":"Brass","id":"2c91808575d3a3570175e64744d5002d","subFacetName":"","subFacet":""},{"facet":"productType","count":73,"slug":"cams","code":"","name":"CAMS","id":"2c91808575d3a3570175e673f2f6002f","subFacetName":"","subFacet":""},{"facet":"productType","count":19,"slug":"heavy-duty","code":"","name":"Heavy Duty","id":"2c91808575d3a3570175e674783b0030","subFacetName":"","subFacet":""},{"facet":"productType","count":316,"slug":"originals","code":"","name":"Originals","id":"2c91808575d3a3570175e67560620031","subFacetName":"","subFacet":""},{"facet":"productType","count":330,"slug":"parts","code":"","name":"Parts","id":"2c91808575d3a3570175e675cced0032","subFacetName":"","subFacet":""},{"facet":"productType","count":51,"slug":"rim-exit-devices","code":"","name":"Rim Exit Devices","id":"2c91808575d3a3570175e6803567003c","subFacetName":"","subFacet":""},{"facet":"productType","count":70,"slug":"padlock","code":"","name":"Padlock","id":"2c91808575d3a3570175e6b5cfd1004d","subFacetName":"","subFacet":""},{"facet":"productType","count":53,"slug":"electronic-standalone","code":"","name":"Electronic Standalone","id":"2c91808575d3a3570175e713c14b0067","subFacetName":"","subFacet":""},{"facet":"productType","count":16,"slug":"keypads","code":"","name":"Keypads","id":"2c91808575d3a3570175e7144d6e0069","subFacetName":"","subFacet":""},{"facet":"productType","count":71,"slug":"picks-tension-tools-extractors","code":"","name":"Picks, Tension Tools & Extractors","id":"2c91808575d3a3570176072165ff00af","subFacetName":"","subFacet":""},{"facet":"productType","count":67,"slug":"door-closer-parts","code":"","name":"Door Closer Parts","id":"2c918086738dd3360173a1abdbca0469","subFacetName":"","subFacet":""},{"facet":"productType","count":9,"slug":"medium-duty","code":"","name":"Medium Duty","id":"2c918086765110130176512fec4e07eb","subFacetName":"","subFacet":""},{"facet":"productType","count":29,"slug":"dummy-cylinders","code":"","name":"Dummy Cylinders","id":"2c91808878351e500178354591960271","subFacetName":"","subFacet":""},{"facet":"productType","count":22,"slug":"profile-cylinders","code":"","name":"Profile Cylinders","id":"2c91808878351e5001783573365013e2","subFacetName":"","subFacet":""},{"facet":"productType","count":1,"slug":"window-locks","code":"","name":"Window Locks","id":"2c91808878351e5001783587c3fc1c66","subFacetName":"","subFacet":""},{"facet":"productType","count":64,"slug":"accessory-hardware","code":"","name":"Accessory Hardware","id":"2c91808a73b48e860173b4de98160023","subFacetName":"","subFacet":""},{"facet":"productType","count":21,"slug":"bolts-latches","code":"","name":"Bolts & Latches","id":"2c91808a73b48e860173b4def8a60024","subFacetName":"","subFacet":""},{"facet":"productType","count":11,"slug":"cabinet-locks","code":"","name":"Cabinet Locks","id":"2c91808a73b48e860173b4df4bfd0025","subFacetName":"","subFacet":""},{"facet":"productType","count":16,"slug":"door-signs","code":"","name":"Door Signs","id":"2c91808a73b48e860173b4df9d700027","subFacetName":"","subFacet":""},{"facet":"productType","count":39,"slug":"door-stops-holders-bumpers","code":"","name":"DOOR STOPS, HOLDERS & BUMPERS","id":"2c91808a73b48e860173b4e14e9d0028","subFacetName":"","subFacet":""},{"facet":"productType","count":75,"slug":"filler-plates","code":"","name":"FILLER PLATES","id":"2c91808a73b48e860173b4e18d2c0029","subFacetName":"","subFacet":""},{"facet":"productType","count":46,"slug":"hinges","code":"","name":"HINGES","id":"2c91808a73b48e860173b4e224ab002a","subFacetName":"","subFacet":""},{"facet":"productType","count":102,"slug":"latch-protectors","code":"","name":"LATCH PROTECTORS","id":"2c91808a73b48e860173b4e2912c002c","subFacetName":"","subFacet":""},{"facet":"productType","count":45,"slug":"pushpull-hardware","code":"","name":"PUSH/PULL HARDWARE","id":"2c91808a73b48e860173b4e2e982002d","subFacetName":"","subFacet":""},{"facet":"productType","count":118,"slug":"strike-plates","code":"","name":"Strike Plates","id":"2c91808a73b48e860173b4e32f4a002e","subFacetName":"","subFacet":""},{"facet":"productType","count":146,"slug":"wrap-around-plates","code":"","name":"WRAP-AROUND PLATES","id":"2c91808a73b48e860173b4e37035002f","subFacetName":"","subFacet":""},{"facet":"productType","count":1,"slug":"semi-automatic","code":"","name":"Semi-Automatic","id":"2c91808a782c61aa0178350ab93e03ad","subFacetName":"","subFacet":""},{"facet":"productType","count":1,"slug":"automatic","code":"","name":"Automatic","id":"2c91808a782c61aa0178350b945404ea","subFacetName":"","subFacet":""},{"facet":"productType","count":2,"slug":"restricted","code":"","name":"Restricted","id":"2c91808a782c61aa0178350ba5ee04f9","subFacetName":"","subFacet":""},{"facet":"productType","count":31,"slug":"thumbturn","code":"","name":"Thumbturn","id":"2c91808a782c61aa0178350bf4c2057c","subFacetName":"","subFacet":""},{"facet":"productType","count":199,"slug":"ic-cores","code":"","name":"IC Cores","id":"2c91808e72edb2a80173248b44d20c00","subFacetName":"","subFacet":""},{"facet":"productType","count":90,"slug":"mortise-housings","code":"","name":"Mortise Housings","id":"2c91808e72edb2a80173248b98ec0c01","subFacetName":"","subFacet":""},{"facet":"productType","count":26,"slug":"rim-housings","code":"","name":"Rim Housings","id":"2c91808e72edb2a80173248c17870c02","subFacetName":"","subFacet":""},{"facet":"productType","count":18,"slug":"cams-tailpieces-parts","code":"","name":"Cams, Tailpieces & Parts","id":"2c91808e72edb2a8017325aafee00c51","subFacetName":"","subFacet":""},{"facet":"productType","count":15,"slug":"keys","code":"","name":"Keys","id":"2c91808e72edb2a8017325dcc0de0c60","subFacetName":"","subFacet":""},{"facet":"productType","count":133,"slug":"pin-kits","code":"","name":"Pin Kits","id":"2c91808e72edb2a8017325f051850c6a","subFacetName":"","subFacet":""},{"facet":"productType","count":56,"slug":"key-tags","code":"","name":"Key Tags","id":"2c91808e72edb2a801732b2e11e80d96","subFacetName":"","subFacet":""},{"facet":"productType","count":87,"slug":"key-rings","code":"","name":"Key Rings","id":"2c91808e72edb2a801732b2e7ab40d97","subFacetName":"","subFacet":""},{"facet":"productType","count":65,"slug":"painted-keys","code":"","name":"Painted Keys","id":"2c91808e72edb2a801732b2e9e850d98","subFacetName":"","subFacet":""},{"facet":"productType","count":14,"slug":"wrist-coils","code":"","name":"Wrist Coils","id":"2c91808e72edb2a801732b2ec3310d99","subFacetName":"","subFacet":""},{"facet":"productType","count":14,"slug":"lanyards","code":"","name":"Lanyards","id":"2c91808e72edb2a801732b2f18f40d9a","subFacetName":"","subFacet":""},{"facet":"productType","count":4,"slug":"key-retractors","code":"","name":"Key Retractors","id":"2c91808e72edb2a801732b2f95b80d9b","subFacetName":"","subFacet":""},{"facet":"productType","count":61,"slug":"tailpieces","code":"","name":"Tailpieces","id":"2c928084760415380176046396d000e9","subFacetName":"","subFacet":""},{"facet":"productType","count":10,"slug":"light-duty","code":"","name":"Light Duty","id":"2c9280847604153801760463ed9b0309","subFacetName":"","subFacet":""},{"facet":"productType","count":80,"slug":"collars","code":"","name":"Collars","id":"2c928084760415380176046ed3411178","subFacetName":"","subFacet":""},{"facet":"productType","count":33,"slug":"kick-plates","code":"","name":"KICK PLATES","id":"2c928084761df6e801761e02e2e80013","subFacetName":"","subFacet":""},{"facet":"productType","count":3,"slug":"sargent-kik-kil","code":"","name":"SARGENT KIK/KIL","id":"2c928084761df6e801761e138f9a00b0","subFacetName":"","subFacet":""},{"facet":"productType","count":59,"slug":"universal-kik-kil-kid-screwcap","code":"","name":"Universal KIK/KIL/KID Screwcap","id":"2c928084761df6e801761e138ff700b6","subFacetName":"","subFacet":""},{"facet":"productType","count":58,"slug":"universal-kik-kil-kid-c-clip","code":"","name":"Universal KIK/KIL/KID C-Clip","id":"2c928084761df6e801761e1393ce00d1","subFacetName":"","subFacet":""},{"facet":"productType","count":2,"slug":"restricted-keys","code":"","name":"RESTRICTED KEYS","id":"2c928084761df6e801761e13990900fc","subFacetName":"","subFacet":""},{"facet":"productType","count":9,"slug":"cable-locks","code":"","name":"CABLE LOCKS","id":"2c928084761df6e801761e2295d002a4","subFacetName":"","subFacet":""},{"facet":"productType","count":11,"slug":"laminated-brass","code":"","name":"Laminated Brass","id":"2c928084761df6e801761e22983102ac","subFacetName":"","subFacet":""},{"facet":"productType","count":6,"slug":"gun-locks","code":"","name":"GUN LOCKS","id":"2c928084761df6e801761e229a2f02bc","subFacetName":"","subFacet":""},{"facet":"productType","count":21,"slug":"vehicle-security","code":"","name":"Vehicle Security","id":"2c928084761df6e801761e22b60202ca","subFacetName":"","subFacet":""},{"facet":"productType","count":3,"slug":"u-locks","code":"","name":"U-LOCKS","id":"2c928084761df6e801761e2319f002df","subFacetName":"","subFacet":""},{"facet":"productType","count":5,"slug":"luggage-locks","code":"","name":"LUGGAGE LOCKS","id":"2c928084761df6e801761e237cbb037a","subFacetName":"","subFacet":""},{"facet":"productType","count":4,"slug":"bluetooth","code":"","name":"BLUETOOTH","id":"2c928084761df6e801761e23fcb503e0","subFacetName":"","subFacet":""},{"facet":"productType","count":5,"slug":"locker-locks","code":"","name":"LOCKER LOCKS","id":"2c928084761df6e801761e2544170455","subFacetName":"","subFacet":""},{"facet":"productType","count":6,"slug":"safety","code":"","name":"Safety","id":"2c928084761df6e801761e304e0c0b5a","subFacetName":"","subFacet":""},{"facet":"productType","count":3,"slug":"latch-retraction-kits","code":"","name":"Latch Retraction Kits","id":"2c92808477f3032d0177f30a70400014","subFacetName":"","subFacet":""},{"facet":"productType","count":3,"slug":"readers","code":"","name":"Readers","id":"2c92808477f3032d0177f30ae56702ec","subFacetName":"","subFacet":""},{"facet":"productType","count":1,"slug":"exit-devices-with-trim","code":"","name":"Exit Devices with Trim","id":"2c92808477fc63250177fc66ec00001d","subFacetName":"","subFacet":""},{"facet":"productType","count":4,"slug":"vertical-rod-exit-devices","code":"","name":"Vertical Rod Exit Devices","id":"2c92808477fc63250177fc66f308004e","subFacetName":"","subFacet":""},{"facet":"productType","count":3,"slug":"high-security","code":"","name":"High Security","id":"2c92808477fc63250177fc66f7cc006f","subFacetName":"","subFacet":""},{"facet":"productType","count":5,"slug":"specialty-cylinders","code":"","name":"Specialty Cylinders","id":"2c92808477fc63250177fc671f2e0187","subFacetName":"","subFacet":""},{"facet":"productType","count":5,"slug":"key-in-lever","code":"","name":"Key-In-Lever","id":"2c938084760493a2017604a78cb9080a","subFacetName":"","subFacet":""},{"facet":"productType","count":20,"slug":"complete-mortise-locks","code":"","name":"Complete Mortise Locks","id":"2c938084760493a2017604aa859d0b8a","subFacetName":"","subFacet":""},{"facet":"productType","count":73,"slug":"pushbutton","code":"","name":"Pushbutton","id":"2c938084760493a2017604c416f51027","subFacetName":"","subFacet":""},{"facet":"productType","count":39,"slug":"drawer-locks","code":"","name":"Drawer Locks","id":"2c938084760493a2017604c68a331530","subFacetName":"","subFacet":""},{"facet":"productType","count":9,"slug":"cards-fobs","code":"","name":"Cards & Fobs","id":"2c938084760493a2017604c68a441533","subFacetName":"","subFacet":""},{"facet":"productType","count":1,"slug":"key-identifiers","code":"","name":"Key Identifiers","id":"2c938084760493a2017604dba21c18fe","subFacetName":"","subFacet":""},{"facet":"productType","count":21,"slug":"tough-links","code":"","name":"Tough Links","id":"2c938084760493a2017604dba384190f","subFacetName":"","subFacet":""},{"facet":"productType","count":15,"slug":"key-hider","code":"","name":"Key Hider","id":"2c938084760493a2017604dba3991912","subFacetName":"","subFacet":""},{"facet":"productType","count":4,"slug":"bit-barrel","code":"","name":"Bit & Barrel","id":"2c938084760493a2017604dba7d9193d","subFacetName":"","subFacet":""},{"facet":"productType","count":14,"slug":"keychain-tools","code":"","name":"Keychain Tools","id":"2c938084760493a2017604dbb2c519a1","subFacetName":"","subFacet":""},{"facet":"productType","count":4,"slug":"key-releases","code":"","name":"Key Releases","id":"2c938084760493a2017604dbc14d1a10","subFacetName":"","subFacet":""},{"facet":"productType","count":5,"slug":"remotes","code":"","name":"Remotes","id":"2c938084760493a2017604dbc6981a3e","subFacetName":"","subFacet":""},{"facet":"productType","count":1,"slug":"key-lights","code":"","name":"Key Lights","id":"2c938084760493a2017604ddc9091dcd","subFacetName":"","subFacet":""},{"facet":"productType","count":7,"slug":"key-caps","code":"","name":"Key Caps","id":"2c938084760493a2017604e1ac612003","subFacetName":"","subFacet":""},{"facet":"productType","count":2,"slug":"misc","code":"","name":"Misc.","id":"2c938084760493a2017604e383ae2329","subFacetName":"","subFacet":""},{"facet":"productType","count":7,"slug":"mortise-trims","code":"","name":"Mortise Trims","id":"2c938084760493a2017604ee719d29b4","subFacetName":"","subFacet":""},{"facet":"productType","count":1,"slug":"mortise-deadlocks","code":"","name":"Mortise Deadlocks","id":"2c938084760493a2017604ee76fc29ed","subFacetName":"","subFacet":""},{"facet":"productType","count":26,"slug":"installation-tools","code":"","name":"Installation Tools","id":"2c9480847780af67017780b62f9c0028","subFacetName":"","subFacet":""},{"facet":"productType","count":16,"slug":"transponder-keys","code":"","name":"Transponder Keys","id":"2c9480847780af67017780b6324f0031","subFacetName":"","subFacet":""},{"facet":"productType","count":85,"slug":"auto-tools","code":"","name":"Auto Tools","id":"2c9480847780af67017780b6403d0072","subFacetName":"","subFacet":""},{"facet":"productType","count":140,"slug":"automotive-locks","code":"","name":"Automotive Locks","id":"2c9480847780af67017780b64c0900b3","subFacetName":"","subFacet":""},{"facet":"productType","count":4,"slug":"electronic-networked","code":"","name":"Electronic Networked","id":"2c9480847791123e01779122a4470ae0","subFacetName":"","subFacet":""},{"facet":"productType","count":13,"slug":"exit-alarms","code":"","name":"Exit Alarms","id":"2c9480847791123e01779123092e0af1","subFacetName":"","subFacet":""},{"facet":"productType","count":4,"slug":"gateways-expanders","code":"","name":"Gateways & Expanders","id":"2c9480847791123e0177912baf050c24","subFacetName":"","subFacet":""},{"facet":"productType","count":5,"slug":"hinge-repair","code":"","name":"Hinge Repair","id":"2c94808477f233070177f234f04d0019","subFacetName":"","subFacet":""},{"facet":"productType","count":16,"slug":"punch","code":"","name":"Punch","id":"2c948084783bbab501783bbee592000a","subFacetName":"","subFacet":""},{"facet":"productType","count":2,"slug":"automatic-operators","code":"","name":"Automatic Operators","id":"2c948084783bbab501783bbef0ef000d","subFacetName":"","subFacet":""},{"facet":"productType","count":1,"slug":"mullions","code":"","name":"Mullions","id":"2c948084783bbab501783bbfd3ab0013","subFacetName":"","subFacet":""},{"facet":"productType","count":11,"slug":"automatic-operator-parts","code":"","name":"Automatic Operator Parts","id":"2c948084783bbab501783bbfd51b0016","subFacetName":"","subFacet":""},{"facet":"productType","count":4,"slug":"power-supplies","code":"","name":"Power Supplies","id":"2c95808477f320d00177f324faab000d","subFacetName":"","subFacet":""},{"facet":"productType","count":21,"slug":"drill-bits","code":"","name":"Drill Bits","id":"2c96808477f329720177f32abe5a003f","subFacetName":"","subFacet":""},{"facet":"productType","count":1,"slug":"electrified-levers","code":"","name":"Electrified Levers","id":"2c96808477fca3d90177fca5cf1e0033","subFacetName":"","subFacet":""},{"facet":"productType","count":52,"slug":"keying-tools","code":"","name":"Keying Tools","id":"2c988084760a65cb01760a7261b50692","subFacetName":"","subFacet":""},{"facet":"productType","count":2,"slug":"lubricant","code":"","name":"Lubricant","id":"2c988084760a65cb01760a727dc506ef","subFacetName":"","subFacet":""},{"facet":"productType","count":16,"slug":"best-sfic-keys","code":"","name":"BEST SFIC KEYS","id":"2c988084760a65cb01760a728e730775","subFacetName":"","subFacet":""},{"facet":"productType","count":3,"slug":"convertible-housings","code":"","name":"Convertible Housings","id":"2c988084760a65cb01760a79eb25084c","subFacetName":"","subFacet":""},{"facet":"productType","count":21,"slug":"round-body","code":"","name":"Round Body","id":"2c988084760a65cb01760a7c90020a1f","subFacetName":"","subFacet":""},{"facet":"productType","count":56,"slug":"cam-locks","code":"","name":"Cam Locks","id":"2c988084760a65cb01760a7cadc50a7c","subFacetName":"","subFacet":""},{"facet":"productType","count":6,"slug":"puck-locks","code":"","name":"Puck Locks","id":"2c988084760a65cb01760a7e83590cea","subFacetName":"","subFacet":""},{"facet":"productType","count":14,"slug":"solid-body","code":"","name":"Solid Body","id":"2c9880847771e465017771e569110004","subFacetName":"","subFacet":""},{"facet":"productType","count":11,"slug":"showcase-locks","code":"","name":"Showcase Locks","id":"2c9880847771e465017771e5ecb60010","subFacetName":"","subFacet":""},{"facet":"productType","count":9,"slug":"mailbox-locks","code":"","name":"Mailbox Locks","id":"2c9880847771e465017771e5fadc0072","subFacetName":"","subFacet":""},{"facet":"productType","count":3,"slug":"desk-locks","code":"","name":"Desk Locks","id":"2c9880847771e465017771e61ceb0167","subFacetName":"","subFacet":""},{"facet":"productType","count":42,"slug":"auxiliary-locks","code":"","name":"Auxiliary Locks","id":"2c9880847771e465017771e62f5c01fc","subFacetName":"","subFacet":""},{"facet":"productType","count":23,"slug":"key-cabinets","code":"","name":"Key Cabinets","id":"2c98808477f337fe0177f339d2780033","subFacetName":"","subFacet":""},{"facet":"productType","count":13,"slug":"gate-boxes","code":"","name":"Gate Boxes","id":"2c98808477fcc2060177fcc4a2d5009c","subFacetName":"","subFacet":""},{"facet":"productType","count":2,"slug":"safe-change-keys","code":"","name":"Safe Change Keys","id":"2c98808477fcc2060177fcc4a5c100b2","subFacetName":"","subFacet":""},{"facet":"productType","count":66,"slug":"weatherized","code":"","name":"Weatherized","id":"2c99808475ffd5200175ffd7e43b0006","subFacetName":"","subFacet":""},{"facet":"productType","count":69,"slug":"steel","code":"","name":"Steel","id":"2c99808475ffd5200175ffd7edc3003a","subFacetName":"","subFacet":""},{"facet":"productType","count":186,"slug":"laminated-steel","code":"","name":"Laminated Steel","id":"2c99808475ffd5200175ffd810cc0109","subFacetName":"","subFacet":""},{"facet":"productType","count":12,"slug":"diskus","code":"","name":"Diskus","id":"2c99808475ffd5200175ffd834d3019e","subFacetName":"","subFacet":""},{"facet":"productType","count":6,"slug":"ic-core","code":"","name":"IC Core","id":"2c99808475ffd5200175ffd83a9e01ca","subFacetName":"","subFacet":""},{"facet":"productType","count":46,"slug":"combination","code":"","name":"Combination","id":"2c99808475ffd5200175ffd83b4c01d1","subFacetName":"","subFacet":""},{"facet":"productType","count":24,"slug":"key-storage","code":"","name":"Key Storage","id":"2c99808475ffd5200175ffd8400701f2","subFacetName":"","subFacet":""},{"facet":"productType","count":56,"slug":"aluminum","code":"","name":"Aluminum","id":"2c9a80847600044c01760006643901a2","subFacetName":"","subFacet":""},{"facet":"productType","count":29,"slug":"cutters","code":"","name":"Cutters","id":"4028b08477fdbe110177fdd225750007","subFacetName":"","subFacet":""},{"facet":"productType","count":4,"slug":"brushes","code":"","name":"Brushes","id":"4028b08477fdbe110177fdd23d03009d","subFacetName":"","subFacet":""},{"facet":"brand","count":55,"slug":"","code":"","name":"LCN","id":"2c918086738dd3360173a1ac3650046a","subFacetName":"","subFacet":""},{"facet":"brand","count":7,"slug":"","code":"","name":"Yale","id":"2c92808476e1c29f0176e1d042da02ab","subFacetName":"","subFacet":""},{"facet":"brand","count":4,"slug":"","code":"","name":"Sargent","id":"2c938084760493a2017604ee29f827ad","subFacetName":"","subFacet":""},{"facet":"brand","count":1,"slug":"","code":"","name":"Lockey USA","id":"2c9a808477f346bc0177f3c1780901b5","subFacetName":"","subFacet":""}] 
	        
	        */
	    