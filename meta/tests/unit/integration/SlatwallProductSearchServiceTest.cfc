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
		variables.service = variables.mockService.getSlatwallProductSearchServiceMock();
	}
	
	/**
	 *  @test
	 *  
	*/
	public void function getProductFilterFacetOptions_should_be_fast(){
        var start = getTickCount();
        
        // this.getService().getSlatwallProductSearchDAO().rePopulateProductFilterFacetOptionTable();
        // var facetOptions = this.getService().getProductFilterFacetOptions();
		
		var skuIDs = "2c978084764d746e01764d786fa0005d, 2c9180847652606f0176526b605006a2";
        // this.getService().getSlatwallProductSearchDAO().recalculateProductFilterFacetOprionsForProductsAndSkus(skuIDs=skuIDs);
		
		var productIDs = "2c9480847650a077017650af142f0970, 402810847651d69c017651f51a890c2b"; 
        // this.getService().getSlatwallProductSearchDAO().recalculateProductFilterFacetOprionsForProductsAndSkus(productIDs=productIDs);

        this.getService().getSlatwallProductSearchDAO()
        .recalculateProductFilterFacetOptionsForProductsAndSkus(
            productIDs=productIDs,
            skuIDs=skuIDs
        );

		var timeTook = getTickCount()-start;
		dump("getProductFilterFacetOptions took #timeTook#");
		expect( timeTook < 10*1000 ).toBeTrue('it should take less than 10 sec. ;) but it took #timeTook#');
	}
	
	/**
	* @test
	* 
	* This test checks if there're any wrong IDs in facet-relations, [from other facet-options]
	*/
	public void function calculatePopentialFaceteOptionsForSelectedFacetOptions_should_only_return_selected_brands_possible_relations_at_max(){
	    var allFacetOptions = this.getService().getProductFilterFacetOptions();
	    var selectedFacets = this.makeRandomSelectedFilters();
	    var selectedBrands = selectedFacets.brands;
	   // dump('selectedBrands:');
	   // dump(selectedBrands);
	    var calculatedPotentialFacetOptions = this.getService().calculatePopentialFaceteOptionsForSelectedFacetOptions({
	        'brands': selectedBrands
	    });
	    
        if( selectedBrands.isEmpty() ){
            // creating a copy here so we accidently update the cached options;
            var potentialBrandsOptions = structCopy( allFacetOptions['brands'] ); 
        } else {
            var potentialBrandsOptions = {};
            for(var thisBrandID in selectedBrands ){
                if(structKeyExists(allFacetOptions.brands, thisBrandID) ){
                    potentialBrandsOptions[ thisBrandID ] = structCopy( allFacetOptions.brands[ thisBrandID ] );
                }
            }
        }
        
        // dump('potentialBrandsOptions:');
        // dump(potentialBrandsOptions);
        
        // dump('calculatedPotentialFacetOptions:');
        // dump(calculatedPotentialFacetOptions);
        
        var expectedBrandRelations = {};
        
        //calculate pottential-brand-facet-relations
        potentialBrandsOptions.each( function(thisBrandOptionID){
            
            var thisBrandOption = allFacetOptions.brands[thisBrandOptionID];
            
            thisBrandOption.relations.each( function(brandOptionRelationName){
               if(!structKeyExists(expectedBrandRelations, brandOptionRelationName)){
                   expectedBrandRelations[ brandOptionRelationName ] = {};
               } 
               expectedBrandRelations[brandOptionRelationName].append(thisBrandOption.relations[brandOptionRelationName]);
            });
        });
        // dump('expectedBrandRelations:');
        // dump(expectedBrandRelations);
        calculatedPotentialFacetOptions.each(function(thisFacetName){
            if(thisFacetName == 'brands'){
                return;    
            }
            var calculatedThisFacetNameOptions = calculatedPotentialFacetOptions[ thisFacetName ];
            calculatedThisFacetNameOptions.each(function(thisOptionID){
                expect( expectedBrandRelations[thisFacetName] ).toHaveKey( thisOptionID );
            });
        });
	}
	
	/**
	* @test
	* 
	* This test checks if there're any wrong IDs in facet-relations, [from other facet-options]
	*/
	public void function validateFacetOptionsForInvalidIDs_should_return_false_for_invalid_optionIDs(){
	    
	    
	    var allFacetOptions = this.getService().getProductFilterFacetOptions();
	    var selectedFacets = this.makeRandomSelectedFilters();
	    
	    var availableFcets = this.getService().getProductFilterFacets();
	    var availableFacetsIndex =  {};
	    availableFcets.each( function(facet){
	        availableFacetsIndex[ facet.id ] = facet;
	    })
	    
	   selectedFacets.each( function(facetName){ 

	       var invalidOptions = selectedFacets[ facetName ].map( function(optionID){
               return hash(optionID, 'md5'); //changing it to something invalid
            });
            
            if(invalidOptions.isEmpty()){
                expect( 
                    this.getService().validateFacetOptionsForInvalidIDs( availableFacetsIndex[facetName], invalidOptions )
                )
                .toBeTrue();
            } else{
                expect( 
                    this.getService().validateFacetOptionsForInvalidIDs( availableFacetsIndex[facetName], invalidOptions )
                )
                .toBeFalse();
            }
	   });
	    
	}
	
	/**************** Utilitis ****************/
	
	public struct function makeRandomSelectedFilters(){
	    
	    var selectedFacets = {
	        "brands"        : [],
	        "options"       : [],
	        "optionGroups"  : [],
	        "productTypes"  : []
	    };
	    
	    var facetOptions = this.getService().getProductFilterFacetOptions();
	   // dump(facetOptions);

        
	   // var productTypeIDs = StructKeyList(facetOptions.productTypes);
	   // var productTypeIDsLen = listLen(productTypeIDs);
        
	    var count = RandRange( 1, RandRange(5,10) );
	    
	   // for(var i=1; i<=count; i++){
	   //     if( RandRange(1, productTypeIDsLen)  > RandRange(1, productTypeIDsLen) ){
    // 	        selectedFacets.productTypes.append(
    // 	            listGetAt(productTypeIDs, RandRange(1, productTypeIDsLen) )
    // 	        );
	   //     }
	   // }
	    
	   // dump(selectedFacets);

    //     // get the remaining ontions for selections
	   // facetOptions = this.getService().calculatePopentialFaceteOptionsForSelectedFacetOptions(selectedFacets);
	   // dump("facetOptions for Brands: ");
	   // dump(facetOptions.brands);

        
	    var brandIDs = StructKeyList(facetOptions.brands);
	    var brandIDsLen = listLen(brandIDs);
	    
	    for(var i=1; i<=count; i++){
	        
	        if( RandRange(1, brandIDsLen)  > RandRange(1, brandIDsLen) ){
    	        selectedFacets.brands.append(
    	            listGetAt(brandIDs, RandRange(1, brandIDsLen) )
    	        );
	        }
	    }
	    
	   // dump(selectedFacets);

	    // get the remaining ontions for selections
	    facetOptions = this.getService().calculatePopentialFaceteOptionsForSelectedFacetOptions(selectedFacets);
    //     dump("facetOptions for Options: ");
	   // dump(facetOptions.options);
	    
	    var optionIDs = StructKeyList(facetOptions.options);
	    var optionIDsLen = listLen(optionIDs);
	    if(optionIDsLen>0){
    	    for(var i=1; i<=count; i++){
    	        
    	        if( RandRange(1, optionIDsLen)  > RandRange(1, optionIDsLen) ){
        	        selectedFacets.options.append(
        	            listGetAt(optionIDs, RandRange(1, optionIDsLen) )
        	        );
    	        }
    	    }
	    }

	   // dump(selectedFacets);
	   // // get the remaining ontions for selections
	   // facetOptions = this.getService().calculatePopentialFaceteOptionsForSelectedFacetOptions(selectedFacets);
        
    //     dump("facetOptions for Option Groups: ");
	   // dump(facetOptions.optionGroups);
	    
	   // var optionGroupIDs = StructKeyList(facetOptions.optionGroups);
	   // var optionGroupIDsLen = listLen(optionGroupIDs);
	    
	   // for(var i=1; i<=count; i++){
	        
	   //     if( RandRange(1, optionGroupIDsLen)  > RandRange(1, optionGroupIDsLen) ){
    // 	        selectedFacets.optionGroups.append(
    // 	            listGetAt(optionGroupIDs, RandRange(1, optionGroupIDsLen) )
    // 	        );
	   //     }
	   // }
	    
	    return selectedFacets;
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
}


