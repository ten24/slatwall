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
component extends="Slatwall.meta.tests.unit.SlatwallUnitTestBase" {

	public void function setUp() {
		super.setup();
		
		variables.smartList = request.slatwallScope.getSmartList("Product");
	}
	
	public void function getFilterOptionsTest(){
		
		var parentCategoryData = {
			categoryID="",
			categoryName="shoes"
		};
		var parentCategory = createPersistedTestEntity('category',parentCategoryData);
		
		var categoryData = {
			categoryID="",
			categoryName="sandals"
		};
		var category = createPersistedTestEntity('category',categoryData);
		
		category.setParentCategory(parentCategory);
		
		var productData = {
			productID="",
			productName="test" & createUUID(),
			productCode="test" & createUUID(),
			activeFlag=1,
			publishedFlag=1,
			calculatedQATS=4,
			categories=[
				{
					categoryID=category.getCategoryID()
				},
				{
					categoryID=parentCategory.getCategoryID()
				}
			]
		};
		var product = createPersistedTestEntity('product',productData);
		
		var categorySmartList = request.slatwallScope.getSmartList("Product");
		
		
		var results = variables.smartList.getFilterOptions('categories.categoryID','categories.categoryName');
		
		var parentresults = variables.smartList.getFilterOptions('categories.categoryID','categories.categoryName',"categories.parentCategory.categoryID");
		
		assert(arraylen(results) == 2);
		
		assert(arraylen(parentresults) == 2);
		
		assert(!structKeyExists(results[1],'parentValue'));
		assert(structKeyExists(parentResults[1],'parentValue'));
	}

	// buildURL()
	public void function buildURL_1() {
		var urlResponse = variables.smartList.buildURL(queryAddition="p:current=3", currentURL="?p:current=2");
		
		assert(urlResponse eq '?p:current=3');
	}
	
	public void function buildURL_2() {
		var urlResponse = variables.smartList.buildURL(queryAddition="p:current=3", currentURL="?f:productName=hello&p:current=2");
		
		assert(urlResponse eq '?f:productname=hello&p:current=3');
	}
	
	public void function buildURL_3() {
		var urlResponse = variables.smartList.buildURL(queryAddition="f:productName=hello", currentURL="?f:productName=hello");
			
		assertEquals('?c=1', urlResponse);
	}
	
	public void function buildURL_4() {	
		var urlResponse = variables.smartList.buildURL(queryAddition="f:productName=hello", currentURL="/");
		
		assert(urlResponse eq '?f:productName=hello');
	}
	
	public void function countTest(){
		var productData = {
			productID="",
			productName="test",
			productCode="test-#createUUID()#",
			skus=[
				{
					skuID="",
					skuName="test"
				},
				{
					skuID="",
					skuName="otherTest"
				}
			]
		};
		var product = createTestEntity('Product',productData);
		assertEquals(product.getSkus()[1].getSkuCode(),product.getProductCode()&'-1');
		assertEquals(product.getSkus()[2].getSkuCode(),product.getProductCode()&'-2');
		
		var productData2 = {
			productID="",
			productName="test",
			productCode="test-#createUUID()#",
			skus=[
				{
					skuID="",
					skuName="test"
				},
				{
					skuID="",
					skuName="otherTest"
				},
				{
					skuID="",
					skuName="test3"
				}
			]
		};
		var product2 = createPersistedTestEntity('Product',productData2);
		var skuData = {
			skuID="",
			skuName="test"
		};
		var sku = createTestEntity('Sku',skuData);
		product2.addSku(sku);
		var skuData2 = {
			skuID="",
			skuName="othertest"
		};
		var sku2 = createTestEntity('Sku',skuData2);
		product2.addSku(sku2);
		assertEquals(product2.getSkus()[1].getSkuCode(),product2.getProductCode()&'-1');
		assertEquals(product2.getSkus()[2].getSkuCode(),product2.getProductCode()&'-2');
		assertTrue(isNull(product2.getSkus()[4].getSkuCode()));
	}
	
}


