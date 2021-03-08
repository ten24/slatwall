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
	
	/**
	* @test
	*/
	public void function getProducts_test(){
	    
	    /*
    	    param name="arguments.data.currencyCode" default='USD';
    	    
    	    // facets-options	
    	    param name="arguments.data.productType" default='';
    	    param name="arguments.data.category" default='';
    	    param name="arguments.data.brands" default='';
    	    param name="arguments.data.options" default='';
    	    param name="arguments.data.attributeOptions" default='';
    	    
            // Search
            param name="arguments.data.keyword" default="";
            // Sorting
            param name="arguments.data.orderBy" default="product.productName|DESC"; 
            // Pricing
            param name="arguments.data.price" default=""; 
            // Pagination
    	    param name="arguments.data.currentPage" default=1;
    	    param name="arguments.data.pageSize" default=10;
    	
	    */
	    
	    var brands = [];
	    var productTypes = [];
	    var options = [];
	    
		var data = {
            "productType": "",
            "category": "",
            // "brands": "Yale,Lab",
            "options": "",
            "attributeOptions": "",
            "keyword": "Serrated",
        };
		
		this.getService().getProducts(data);
		
		dump(data);
		
	}
}


