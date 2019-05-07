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
	/**
	* @test
	*/
	public void function getCacheableSmartlistTest(){
		var smartlist = request.slatwallScope.getSmartList("Product");
		smartlist.setCacheable(true);
		var recordsCount = smartlist.getRecordsCount();
	}
	
	/**
	* @test
	*/
	public void function getSaveAndLoadStateSmartlistTest(){
		var smartlist = request.slatwallScope.getSmartList("Account");
		smartlist.setPageRecordsShow(2);
		makePublic(smartlist,'saveState');
		
		smartlist.getPageRecords();
		var newSmartList = request.slatwallScope.getSmartList("Account");
		newSmartList.setSavedStateID(smartlist.getSavedStateID());
		assertEquals(newSmartList.getSavedStateID(),smartlist.getSavedStateID());
		var loaded = newSmartList.loadSavedState(smartlist.getSavedStateID());
		
		newSmartList.getPageRecords();
		
		assertEquals(newsmartlist.getPageRecordsShow(),smartlist.getPageRecordsShow());
	}
	
		
	/**
	* @test
	*/
	public void function removeOrderTest(){
		var smartlist = request.slatwallScope.getSmartList('Product');
		smartlist.addOrder('productName|ASC');
		smartlist.addOrder('productDescription|DESC');


		assertEquals(smartlist.getOrders()[1]['property'],'aslatwallproduct.productName');

		assertEquals(arraylen(smartlist.getOrders()),2);

		smartlist.removeOrder('productName|ASC');

		assertEquals(arraylen(smartlist.getOrders()),1);

	}

	/**
	* @test
	*/
	public void function removeOrderTest_relatedProperty(){
		var smartlist = request.slatwallScope.getSmartList('Product');
		smartlist.addOrder('brand.brandName|ASC');

		assertEquals(smartlist.getOrders()[1]['property'],'aslatwallbrand.brandName');
		assertEquals(arraylen(smartlist.getOrders()),1);
		smartlist.removeOrder('brand.brandName|ASC');
		assertEquals(arraylen(smartlist.getOrders()),0);

	}

	/**
	* @test
	*/
	/*public void function getFilterOptionsTest(){
		
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
		debug(results);
		var parentresults = variables.smartList.getFilterOptions('categories.categoryID','categories.categoryName',"categories.parentCategory.categoryID");
		
		assert(arraylen(results) == 2);
		
		assert(arraylen(parentresults) == 2);
		
		assert(!structKeyExists(results[1],'parentValue'));
		assert(structKeyExists(parentResults[1],'parentValue'));
	}*/

	// buildURL()	
	/**
	* @test
	*/
	public void function buildURL_1() {
		var urlResponse = variables.smartList.buildURL(queryAddition="p:current=3", currentURL="?p:current=2");
		
		assert(urlResponse eq '?p:current=3');
	}
		
	/**
	* @test
	*/
	public void function buildURL_2() {
		var urlResponse = variables.smartList.buildURL(queryAddition="p:current=3", currentURL="?f:productName=hello&p:current=2");
		
		assertEquals(urlResponse,'?f:productname=hello&amp;p:current=3');
	}
		
	/**
	* @test
	*/
	public void function buildURL_3() {
		var urlResponse = variables.smartList.buildURL(queryAddition="f:productName=hello", currentURL="?f:productName=hello");
			
		assertEquals('?c=1', urlResponse);
	}
		
	/**
	* @test
	*/
	public void function buildURL_4() {	
		var urlResponse = variables.smartList.buildURL(queryAddition="f:productName=hello", currentURL="/");
		
		assert(urlResponse eq '?f:productName=hello');
	}
		
	
	
}


