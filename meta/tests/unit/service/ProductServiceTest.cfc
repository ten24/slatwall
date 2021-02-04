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
component accessors="true" extends="Slatwall.meta.tests.unit.SlatwallUnitTestBase" {
    
    property name="service";
    
	public void function setUp() {
		super.setup();
		//variables.service = request.slatwallScope.getService("productService");
		variables.service = variables.mockService.getProductServiceMock();
	}

	/**
	* @test
	*/
	public void function getProductCollectionListTest(){
		var collection = variables.service.getProductCollectionList();
		assertEquals(collection.getCollectionObject(),'Product');
	}

	/**
	* @test
	*/
	public void function createSingleSkuTest(){
		var productData = {
			productID="",
			productName="unitTestProduct" & createUUID(),
			productCode="unitTestProductCode" & createUUID()
		};
		var product = createPersistedTestEntity('product',productData);

		var processObject = product.getProcessObject('create');
		product = variables.service.createSingleSku(product,processObject);
		//assert a single sku was created
		assertEquals(arrayLen(product.getSkus()),1);
	}

	/**
	* @test
	*/
	public void function createGiftCardProduct_sameAsPrice(){

		var productData = {
			productID="",
			productName="unitTestProductSameAsPrice" & createUUID(),
			productCode="unitTestProductCodeSameAsPrice" & createUUID()
		};
		var product = createTestEntity('product',productData);
		var processObject = product.getProcessObject('create');

		processObject.setPrice(20);
		processObject.setRedemptionAmountType('sameAsPrice');
		processObject.setRedemptionAmount(10);

		product = variables.service.createGiftCardProduct(product,processObject);

		addEntityForTearDown(product);

		assertEquals(product.getDefaultSku().getRedemptionAmountType(),'sameAsPrice');
		assertEquals(product.getDefaultSku().getRedemptionAmount(),20);

	}

	/**
	* @test
	*/
	public void function createGiftCardProduct_fixedAmount(){
		var someMoreProductData = {
			productID="",
			productName="unitTestProduct2FixedAmount" & createUUID(),
			productCode="unitTestProductCode2FixedAmount" & createUUID()
		};
		var anotherProduct = createTestEntity('product',someMoreProductData);
		var anotherProcessObject = anotherProduct.getProcessObject('create');

		anotherProcessObject.setPrice(20);
		anotherProcessObject.setRedemptionAmountType('fixedAmount');
		anotherProcessObject.setRedemptionAmount(10);

		anotherProduct = variables.service.createGiftCardProduct(anotherProduct,anotherProcessObject);

		addEntityForTearDown(anotherProduct);

		assertEquals(anotherProduct.getDefaultSku().getRedemptionAmountType(),'fixedAmount');
		assertEquals(anotherProduct.getDefaultSku().getRedemptionAmount(),10);
	}

	/**
	* @test
	*/
	public void function createGiftCardProduct_percentage(){
		var evenMoreProductData = {
			productID="",
			productName="unitTestProduct3Percentage" & createUUID(),
			productCode="unitTestProductCode3Percentage" & createUUID()
		};
		var yetAnotherProduct = createTestEntity('product',evenMoreProductData);
		var yetAnotherProcessObject = yetAnotherProduct.getProcessObject('create');

		yetAnotherProcessObject.setPrice(20);
		yetAnotherProcessObject.setRedemptionAmountType('percentage');
		yetAnotherProcessObject.setRedemptionAmount(10);

		yetAnotherProduct = variables.service.createGiftCardProduct(yetAnotherProduct, yetAnotherProcessObject);

		addEntityForTearDown(yetAnotherProduct);

		assertEquals(yetAnotherProduct.getDefaultSku().getRedemptionAmountType(),'percentage');
		assertEquals(yetAnotherProduct.getDefaultSku().getRedemptionAmount(),2);
	}
 
	/**
	* @test
	*/
	public void function saveProductTest_checkifSkusAreSetToInactive(){
		var productData = {
			productID="",
			productName="myproduct"& createUUID(),
			productCode="myproductcode" & createUUID(),
			activeFlag=1,
			publishedFlag=1,
			productType={
				productTypeID='444df2f7ea9c87e60051f3cd87b435a1'
			}
		};
		var product = createPersistedTestEntity('Product',productData);


		//start of with an active product
		assert(product.getActiveFlag());
		assert(product.getPublishedFlag());

		//add some active skus
		var skuData = {
			skuID="",
			skuCode="skucode"&createUUID(),
			activeFlag=1,
			publishedFlag=1,
			product={
				productID=product.getProductID()
			}
		};
		var sku = createPersistedTestEntity('Sku',skuData);

		var skuData2 = {
			skuID="",
			skuCode="skucode"&createUUID(),
			activeFlag=1,
			publishedFlag=1,
			product={
				productID=product.getProductID()
			}
		};
		var sku2 = createPersistedTestEntity('Sku',skuData2);

		//assert that all skus are active
		var skus = product.getSkus();
		for(var sku in skus){
			assert(sku.getActiveFlag());
		}

		//set the product as inactive via the service
		product = variables.service.saveProduct(product,{activeFlag=0});

		//assert that we set it as inactive
		assertFalse(product.getActiveFlag());

		assertFalse(product.getPublishedFlag());

		//and therefore we should be able to asssume that all skus were set to inactive as well if there were no validation errors
		//because the dao does the update we need to retrieve the data via dao method as well
		var skusquery = new Query();
		skusquery.addParam(name="productID",value=product.getProductID(),cfsqltype="cf_sql_varchar");
		var skus = skusquery.execute(
			sql='select s.activeFlag,s.publishedFlag from SwSku s where s.productID=:productID'
		).getResult();


		for(var sku in skus){
			assertFalse(sku.activeFlag);
			assertFalse(sku.publishedFlag);
		}
	}

	public void function saveProductWithProductListingPages(){

		var productData = {
			productID= '',
			productName="product"& createUUID(),
			productCode="productcode" & createUUID(),
			activeFlag=1,
			publishedFlag=1,
			productType={
				productTypeID='444df2f7ea9c87e60051f3cd87b435a1'
			}
		};
		var product = createPersistedTestEntity('Product',productData);

		var contentData1 = {
			contentID=''
		};
		var content1 = createPersistedTestEntity('Content',contentData1);
		var contentData2 = {
			contentID=''
		};
		var content2 = createPersistedTestEntity('Content',contentData2);
		var contentData3 = {
			contentID=''
		};
		var content3 = createPersistedTestEntity('Content',contentData3);

		var serviceData = {
			assignedContentIDList=ArrayToList([content1.getContentID(), content2.getContentID(), content3.getContentID()])
		};

		var productToAssert = variables.service.saveProduct(product, serviceData);

		assert(arrayLen(productToAssert.getListingPages()), 3);

		var serviceData2 = {
			assignedContentIDList=ArrayToList([content1.getContentID(), content2.getContentID()])
		};

		var productToAssert2 = variables.service.saveProduct(product, serviceData2);

		assert(arrayLen(productToAssert2.getListingPages()), 3);
	}
	
	
	
	/**
	* @test
	*/
	public void function getProductFilterFacetOptions_should_have_required_filter_types(){
		
		expect( this.getService()
            .getHibachiCacheService()
            .hasCachedValue('calculated_product_filter_facet_options')
        ).toBeFalse();
		
		var filters = this.getService().getProductFilterFacetOptions();
		
        // 		debug(filters);
		
        expect( filters ).toHaveKey('brands');
        expect( filters ).toHaveKey('options');
        expect( filters ).toHaveKey('optionGroups');
        expect( filters ).toHaveKey('productTypes');
        
        expect( this.getService()
            .getHibachiCacheService()
            .hasCachedValue('calculated_product_filter_facet_options')
        ).toBeTrue();
	}
	
	/**
	* @test
	*/
	public void function getProductFilterFacets_should_have_required_metadata(){
	    
	    var facets = this.getService().getProductFilterFacets();
	    debug(facets);
	    
	    expect(facets).toBeTypeOf('array');
	    
	    facets.each( function(facet){
            expect( facet ).toHaveKey('priority');
            expect( facet ).toHaveKey('selectType');
	        
	    });
	}
	
	public struct function makeRandomSelectedFilters(){
	    
	    var selectedFacets = {
	        "brands"        : [],
	        "options"       : [],
	        "optionGroups"  : [],
	        "productTypes"  : []
	    };
	    
	    var facetOptions = this.getService().getProductFilterFacetOptions();
	   // dump(facetOptions);


	    var brandIDs = StructKeyList(facetOptions.brands);
	    var brandIDsLen = listLen(brandIDs);
	    
	    var optionIDs = StructKeyList(facetOptions.options);
	    var optionIDsLen = listLen(optionIDs);
	    
	    var optionGroupIDs = StructKeyList(facetOptions.optionGroups);
	    var optionGroupIDsLen = listLen(optionGroupIDs);
	    
	    var productTypeIDs = StructKeyList(facetOptions.productTypes);
	    var optionGroupIDsLen = listLen(optionGroupIDs);
	    
	    var count = RandRange( 1, 10 );
	    for(var i=1; i<=count; i++){
	        
	        if( RandRange(1, brandIDsLen)  > RandRange(1, brandIDsLen) ){
    	        selectedFacets.brands.append(
    	            listGetAt(brandIDs, RandRange(1, brandIDsLen) )
    	        );
	        }
	        
	        if( RandRange(1, optionIDsLen)  > RandRange(1, optionIDsLen) ){
    	        selectedFacets.options.append(
    	            listGetAt(optionIDs, RandRange(1, optionIDsLen) )
    	        );
	        }
	        
	        if( RandRange(1, optionGroupIDsLen)  > RandRange(1, optionGroupIDsLen) ){
    	        selectedFacets.optionGroups.append(
    	            listGetAt(optionGroupIDs, RandRange(1, optionGroupIDsLen) )
    	        );
	        }
	    }
	    
	    return selectedFacets;
	}
	
	/**
	* @test
	* 
	* This test checks if there're any wrong IDs, from other facet-options. [wrong entity IDs];
	*/
	public void function calculateActualPopentialFilterFacates_should_not_modify_cached_calculated_facet_options(){
	    
	    
	    var oldFacetOptions = structCopy( this.getService().getProductFilterFacetOptions() );
	    var selectedFacets = this.makeRandomSelectedFilters();
	    dump(selectedFacets);
	    
	    var potentialFacetOptions = this.getService().calculatePopentialFilterFacates(selectedFacets);
	    var newFacetOptions = this.getService().getProductFilterFacetOptions();
	    
	    dump(
	      this.StructEquals(oldFacetOptions, newFacetOptions )  
	    );
	    
	    dump(newFacetOptions);
	}
	
	
    /**
	 * Returns whether two structures are equal, going deep.
	 * 
	 * CF-Script version of https://stackoverflow.com/a/48290726/6443429
	 * 
	*/
	public boolean function StructEquals(
    	required struct stc1, 
    	required struct stc2, 
    	boolean blnCaseSensitive=false, 
    	boolean blnCaseSensitiveKeys=false
	){
    
    	if(StructCount(stc1) != StructCount(stc2))
          return false;
    
        var arrKeys1 = StructKeyArray(stc1);
        var arrKeys2 = StructKeyArray(stc2);
    
        ArraySort(arrKeys1, 'text');
        ArraySort(arrKeys2, 'text');
    
        if(!ArrayEquals(arrKeys1, arrKeys2, blnCaseSensitiveKeys, blnCaseSensitiveKeys))
          return false;
    
        for(var i = 1; i <= ArrayLen(arrKeys1); i++) {
          var strKey = arrKeys1[i];
    
          if(IsStruct(stc1[strKey])) {
            if(!IsStruct(stc2[strKey]))
              return false;
            if(!StructEquals(stc1[strKey], stc2[strKey], blnCaseSensitive, blnCaseSensitiveKeys))
              return false;
          }
          else if(IsArray(stc1[strKey])) {
            if(!IsArray(stc2[strKey]))
              return false;
            if(!ArrayEquals(stc1[strKey], stc2[strKey], blnCaseSensitive, blnCaseSensitiveKeys))
              return false;
          }
          else if(IsSimpleValue(stc1[strKey]) && IsSimpleValue(stc2[strKey])) {
            if(blnCaseSensitive) {
              if(Compare(stc1[strKey], stc2[strKey]) != 0)
                return false;
            }
            else {
              if(CompareNoCase(stc1[strKey], stc2[strKey]) != 0)
                return false;
            }
          }
          else {
            throw("Can only compare structures, arrays, and simple values. No queries or complex objects.");
          }
        }
    
        return true;
    }
    
    /**
	 * Returns whether two arrays are equal, including deep comparison if the arrays contain structures or sub-arrays.
	 * 
	 * CF-Script version of https://stackoverflow.com/a/48290726/6443429
	 * 
	*/
    public boolean function ArrayEquals(
        required array arr1, 
        required array arr2, 
        boolean blnCaseSensitive="false", 
        boolean blnCaseSensitiveKeys="false"
    ){
    
    	if(ArrayLen(arr1) != ArrayLen(arr2))
          return false;
    
        for(var i = 1; i <= ArrayLen(arr1); i++) {
          if(IsStruct(arr1[i])) {
            if(!IsStruct(arr2[i]))
              return false;
            if(!StructEquals(arr1[i], arr2[i], blnCaseSensitive, blnCaseSensitiveKeys))
              return false;
          }
          else if(IsArray(arr1[i])) {
            if(!IsArray(arr2[i]))
              return false;
            if(!ArrayEquals(arr1[i], arr2[i], blnCaseSensitive, blnCaseSensitiveKeys))
              return false;
          }
          else if(IsSimpleValue(arr1[i]) && IsSimpleValue(arr2[i])) {
            if(blnCaseSensitive) {
              if(Compare(arr1[i], arr2[i]) != 0)
                return false;
            }
            else {
              if(CompareNoCase(arr1[i], arr2[i]) != 0)
                return false;
            }
          }
          else {
            throw("Can only compare structures, arrays, and simple values. No queries or complex objects.");
          }
        }
        return true;
    }

	
	/**
	* @test
	* 
	* This test checks if there're any wrong IDs, from other facet-options. [wrong entity IDs];
	*/
	public void function calculateActualPopentialFilterFacates_should_return_the_right_facet_option_IDs(){
	    
	    
	    var facetOptions = this.getService().getProductFilterFacetOptions();
	    var selectedFacets = this.makeRandomSelectedFilters();

	    dump(selectedFacets);
	    

	    var potentialFacetOptions = this.getService().calculatePopentialFilterFacates(selectedFacets);
	    
	    potentialFacetOptions.each( function(thisFacetName){
	        var thisFacetPotentialOptions = potentialFacetOptions[ thisFacetName ];
	        var thisFacetAllAvailableOptions = facetOptions[ thisFacetName ];
	        
	        thisFacetPotentialOptions.each( function(optionID){
	            expect(thisFacetAllAvailableOptions).toHaveKey( optionID );
	        });
	    });

	   // dump(potentialFacetOptions);
	}
	
	
	/**
	* @test
	* 
	* This test checks if there're any wrong IDs in facet-relations, [from other facet-options]
	*/
	public void function calculateActualPopentialFilterFacates_should_return_the_right_facet_option_relatations_option_IDs(){
	    
	    
	    var facetOptions = this.getService().getProductFilterFacetOptions();
	    var selectedFacets = this.makeRandomSelectedFilters();
	    dump(selectedFacets);
	    
	    var potentialFacetOptions = this.getService().calculatePopentialFilterFacates(selectedFacets);
	    
	    potentialFacetOptions.each( function(thisFacetName){
	        var thisFacetPotentialOptions = potentialFacetOptions[ thisFacetName ];
            // dump("thisFacetName");
	        // dump(thisFacetName);
	        // dump(thisFacetPotentialOptions);
	        thisFacetPotentialOptions.each( function(optionID){
	            var potentialFacetOption = thisFacetPotentialOptions[ optionID ];
                // dump("porential-facet-option");
	            // dump(optionID);
	            // dump(potentialFacetOption);
	            potentialFacetOption.relations.each( function(relatedFacetName){
	                var relatedFacetPotentialOptions = potentialFacetOption.relations[ relatedFacetName ];
	                var relatedFacetAllAvailableOptions = facetOptions[ relatedFacetName ];
                    // dump("porential-facet-option's related facet");
                    // dump(relatedFacetName);
    	            // dump(relatedFacetPotentialOptions);
                    relatedFacetPotentialOptions.each( function(optionID){
        	            expect(relatedFacetAllAvailableOptions).toHaveKey( optionID );
        	        });
	            });
	        });
	    });

	   // dump(potentialFacetOptions);
	}
	
	
	
}


