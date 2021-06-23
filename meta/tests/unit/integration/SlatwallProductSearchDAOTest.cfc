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
    
    property name="dao";
    property name="publicService";
    
	public void function setUp() {
		super.setup();
		variables.dao = variables.mockService.getSlatwallProductSearchDAOMock();
		variables.publicService = variables.mockService.getPublicServiceMock();
	}

	
	/**
	 *  @test
	 *  
	*/
	public void function recalculateProductFilterFacetOptionsForProductsAndSkus_should_be_fast(){
        var start = getTickCount();
        
        // this.getService().getSlatwallProductSearchDAO().rePopulateProductFilterFacetOptionTable();
        // var facetOptions = this.getService().getProductFilterFacetOptions();
		
		var skuIDs = "2c978084764d746e01764d786fa0005d, 2c9180847652606f0176526b605006a2";
        // this.getService().getSlatwallProductSearchDAO().recalculateProductFilterFacetOprionsForProductsAndSkus(skuIDs=skuIDs);
		
		var productIDs = "2c9480847650a077017650af142f0970, 402810847651d69c017651f51a890c2b"; 
        // this.getService().getSlatwallProductSearchDAO().recalculateProductFilterFacetOprionsForProductsAndSkus(productIDs=productIDs);

        this.getDao()
        .recalculateProductFilterFacetOptionsForProductsAndSkus(
            productIDs=productIDs,
            skuIDs=skuIDs
        );

		var timeTook = getTickCount()-start;
		dump("getProductFilterFacetOptions took #timeTook#");
		expect( timeTook < 10*1000 ).toBeTrue('it should take less than 10 sec. ;) but it took #timeTook#');
	}
	
	
	
	
	
	
	/**
	 *  @test
	 *  
	*/
	public void function makeFacetSqlFilterQueryFragments(){
	    var queryData = this.getSampleProductSearchQueryData();
	    dump(queryData);
	    
	    var start = getTickCount();
	    
	    var queryData = this.getDao().makeFacetSqlFilterQueryFragments(argumentCollection = queryData);
	    
	    var timeTook = getTickCount()-start;
		dump("getProductFilterFacetOptions took #timeTook#");
		
	    dump(queryData);
	}
	
	
	/**
	 *  @test
	 *  
	*/
	public void function makeFacetSqlFilterQueryFragmentsForJOIN(){
	    var queryData = this.getSampleProductSearchQueryData();
	    dump(queryData);
	    
	    var start = getTickCount();
	    
	    var queryData = this.getDao().makeFacetSqlFilterQueryFragmentsForJOIN(argumentCollection = queryData);
	    
	    var timeTook = getTickCount()-start;
		dump("getProductFilterFacetOptions took #timeTook#");
		
	    dump(queryData);
	}
	
	
	
	
	/**
	 *  @test
	 *  
	*/
	public void function doGetAllFacetOptionsSQLJOINQueryAndParams(){
	    var queryData = this.getSampleProductSearchQueryData();
	    dump(queryData);
	    
	    var start = getTickCount();
	    
	    var queryData = this.getDao().doGetAllFacetOptionsSQLJOINQueryAndParams(argumentCollection = queryData);
	    
	    var timeTook = getTickCount()-start;
		dump("getProductFilterFacetOptions took #timeTook#");
		
	    dump(queryData);
	}
	
	
	
	
	/**
	 *  @test
	 *  
	*/
	public void function doGetAllFacetOptionsSQLQueryAndParams(){
	    var queryData = this.getSampleProductSearchQueryData();
	    dump(queryData);
	    
	    var start = getTickCount();
	    
	    var queryData = this.getDao().doGetAllFacetOptionsSQLQueryAndParams(argumentCollection = queryData);
	    
	    var timeTook = getTickCount()-start;
		dump("getProductFilterFacetOptions took #timeTook#");
		
	    dump(queryData);
	}
	
	/**
	 *  @test
	 *  
	*/
	public void function getPotentialFilterFacetsAndOptions(){
	    var queryData = this.getSampleProductSearchQueryData();
	    dump(queryData);
	    
	    var start = getTickCount();
	    var facetOptions = this.getDao().getPotentialFilterFacetsAndOptions(argumentCollection = queryData);
	    var timeTook = getTickCount()-start;
		dump("getProductFilterFacetOptions took #timeTook#");
	    dump(facetOptions);
	   
		start = getTickCount();
		queryData['useJoinsInsteadWhere'] = true;
		var facetOptions = this.getDao().getPotentialFilterFacetsAndOptions(argumentCollection = queryData);
        timeTook = getTickCount()-start;
		dump("getProductFilterFacetOptions:: JOIN took #timeTook#");
		
// 		queryData['useJoinsInsteadWhere'] = false;
// 		start = getTickCount();
// 		var facetOptions = this.getDao().getPotentialFilterFacetsAndOptions(argumentCollection = queryData);
//         timeTook = getTickCount()-start;
// 		dump("getProductFilterFacetOptions:: took #timeTook#");
		
	    dump(facetOptions);
	    
	}
	
	
	
	
		
	/**************** Utilitis ****************/

	public struct function getSampleProductSearchQueryData(){
	    
	   // var testSearchQuery = "option_language=english,spanish&option_size_slug=medium,small&attribute_testing=1,2,3&brand=nike,puma&brand_id=1,2,4&brand_slug=acb,pqr,1112233&category_name=c1,c2,c3&productType=p1,p2,p3";
	 
	   // dump(testSearchQuery);
	    
	   // var testSearchQueryArray = listToArray(testSearchQuery, '&');
	   // dump(testSearchQueryArray);
	    
	    var testSearchQueryArray = [
            // 'brand=Abus,Arrow',
            // 'brand_id=2c9480847791123e01779122657d0acf',
            'brand_id=2c92808477f3032d0177f30ae57102ed,2c938084760493a2017604c413a01007,2c9480847791123e01779122657d0acf',
            // 'brand_id=2c9480847791123e01779122657d0acf,2c9480847791123e0177911b1a37006d,2c938084760493a2017604c413a01007,2c92808477f3032d0177f30a76970036',
            // 'brand_slug=acb,pqr,1112233', // bad option
            
            // 'productType=Steel,Levers',
            // 'productType_id=2c91808575d3a3570175e7144d6e0069,2c9480847791123e01779122a4470ae0,2c938084760493a2017604c68a441533,2c9480847791123e01779123092e0af1',
            // 'productType_id=2c96808477fca3d90177fca5cf1e0033',
            
            // 'brand=Gardall',
            // 'productType_slug=parts',
            
            // 'category_name=',
            
            'option_productFinish_id=2c91808e757ef05301758d90688b0a29,2c91808e757ef05301758d90688b0a12',
            // 'option_productFinish=p1,p2,p3',
            
            // 'option_safesFinish_id=2c91808372e5f4500172e6e6e05a0048',
            // 'option_safesLockType_id=2c91808372e5f4500172e6e8409e004c'
            
            // 'option_36_id=2c91808377724d53017772888237000c',
            // 'option_628_id=2c91808e757ef05301758d90688b0a46',
            
            
            // 'attribute_productKeyMachineType=1,2,3',
            
            // 'option_language=english,spanish',
            // 'option_size_slug=medium,small',
            
            // 'keyword=Serrated',
        ];
        
	    var urlScope = URL ?: {};
	    for(var pair in testSearchQueryArray){
	        urlScope[listFirst(pair, '=')] = listLast(pair, '=');
	    }
	    
	    return this.getPublicService().parseGetProductsQuery(urlScope);
	}
	
	
	public struct function makeRandomSelectedFilters(){
	   
	}
}


