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

		variables.service = variables.mockService.getPublicServiceMock();

	}

	/**
	* @test
	*/
	public void function add_product_bundle_to_cart_test(){
		var data = {
			'productBundleBuildID' : '2c928084774f27d501774f3b3cf20017',
            'returnJSONObjects' : 'cart'
		};
		
		debug(data);
		
		variables.service.addProductBundleToCart(data);
		

		var cart = request.slatwallScope.getCart();
        // dump(var=cart, top=1);
	}
	
	public struct function setProductSearchQueryOnURLScope(){
	   // var testSearchQuery = "option_language=english,spanish&option_size_slug=medium,small&attribute_testing=1,2,3&brand=nike,puma&brand_id=1,2,4&brand_slug=acb,pqr,1112233&category_name=c1,c2,c3&productType=p1,p2,p3";
	 
	   // dump(testSearchQuery);
	    
	   // var testSearchQueryArray = listToArray(testSearchQuery, '&');
	   // dump(testSearchQueryArray);
	    
	    var testSearchQueryArray = [
            // 'brand=Abus,Arrow',
            'brand_id=2c9480847791123e01779122657d0acf',
            // 'brand_id=2c9480847791123e01779122657d0acf,2c9480847791123e0177911b1a37006d,2c928084761df6e801761e02e2fd0014',
            // 'brand_id=2c9480847791123e01779122657d0acf,2c9480847791123e0177911b1a37006d,2c938084760493a2017604c413a01007,2c92808477f3032d0177f30a76970036',
            // 'brand_slug=acb,pqr,1112233', // bad option
            
            // 'productType=Steel,Levers',
            // 'productType_id=2c91808575d3a3570175e7144d6e0069,2c9480847791123e01779122a4470ae0,2c938084760493a2017604c68a441533,2c9480847791123e01779123092e0af1',
            
            // 'category_name=',
            
            // 'option_productFinish_id=2c91808e757ef05301758d90688b0a29,2c91808e757ef05301758d90688b0a12',
            // 'option_productFinish_id=2c91808e757ef05301758d90688b0a29',
            
            // 'attribute_productKeyMachineType=1,2,3',
            
            // 'option_language=english,spanish',
            // 'option_size_slug=medium,small',
            // 'f_product.featuredFlag=1',
            // 'content=whatever',
            // 'f_product.activeFlag=1',
            'f_product.activeFlag_eq=1',
            'f_product.activeFlag_neq=0',
            'f_product.activeFlag_lt=1',
            'f_product.activeFlag_lte=1',
            'f_product.activeFlag_gt=1',
            'f_product.productName_like=test',
            // 'f_product.productName_in=abc,p12',
            'keyword=Serrated'
        ];
        
	    var urlScope = URL ?: {};
	    for(var pair in testSearchQueryArray){
	        urlScope[listFirst(pair, '=')] = listLast(pair, '=');
	    }
	    
	    return urlScope;
	}
	
	
	/**
	* @test
	*/
	public void function getProducts_test(){
	    
	    var urlScope = this.setProductSearchQueryOnURLScope();
	   // urlScope['includePotentialFilters'] = false;
	    var data = {};
	    
		this.getService().getProducts(data, urlScope);
		dump(data);
	}
	
	
	/**
	* @test
	*/
	public void function parseGetProductsQuery_test(){
	    
	    var testSearchQueryArray = [
            'brand=Abus,Arrow',
            'brand_id=2c9480847791123e01779122657d0acf',
            'brand_id=2c9480847791123e01779122657d0acf,2c9480847791123e0177911b1a37006d,2c928084761df6e801761e02e2fd0014',
            'brand_id=2c9480847791123e01779122657d0acf,2c9480847791123e0177911b1a37006d,2c938084760493a2017604c413a01007,2c92808477f3032d0177f30a76970036',
            'brand_slug=acb,pqr,1112233', // bad option
            
            'productType=Steel,Levers',
            'productType_id=2c91808575d3a3570175e7144d6e0069,2c9480847791123e01779122a4470ae0,2c938084760493a2017604c68a441533,2c9480847791123e01779123092e0af1',
            
            'category=cat112',
            'category_name=cat1',
            
            'content=cont1122',
            'content_id=12345t',

            'attribute_productKeyMachineType=1,2,3',

            'option_productFinish_id=2c91808e757ef05301758d90688b0a29,2c91808e757ef05301758d90688b0a12',

            'option_language=english,spanish',
            'option_size_slug=medium,small',
            
            'f_product.featuredFlag=1',
            'f_product.activeFlag_eq=1',
            'f_product.activeFlag_neq=0',
            'f_product.activeFlag_lt=1',
            'f_product.activeFlag_lte=1',
            'f_product.activeFlag_gt=1',
            'f_product.productName_like=test',
            'f_product.productName_in=abc,p12',            
            
            'keyword=Serrated'
        ];
        
        var urlScope = URL ?: {};
	    for(var pair in testSearchQueryArray){
	        urlScope[listFirst(pair, '=')] = listLast(pair, '=');
	    }
	    
	    var parsed = this.getService().parseGetProductsQuery(urlScope);
	    dump(parsed);
	}
	  
	
	
	
	
	


}


