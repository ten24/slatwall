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

	// @hint put things in here that you want to run befor EACH test
	public void function setUp() {
		super.setup();
		
	}
	public void function CompareOrderItemsByProcessObject(){
		var sku = getTestSku('TestSku');
		var stock = getTestStock();
		var stock2 = getTestStock();
		var orderItem = request.slatwallScope.newEntity( 'orderItem' );
		orderItem.setSku(sku);
		orderItem.setPrice(11);
		orderItem.setStock(stock);
		
		//same as orderitem
		var order = request.slatwallScope.newEntity( 'order' );
		var processOrderItem = order.getProcessObject( 'AddOrderItem' );
		processOrderItem.setSku(sku);
		processOrderItem.setPrice(11);
		processOrderItem.setStock(stock);
		var foundMatch = processOrderItem.CompareOrderItemToProcessOrderItem(orderItem);
		assertTrue(foundMatch);
		
		//different sku as orderitem
		var sku2 = getTestSku('TestSku2');
		processOrderItem.setSku(sku2);
		processOrderItem.setPrice(11);
		processOrderItem.setStock(stock);
		var foundMatch = processOrderItem.CompareOrderItemToProcessOrderItem(orderItem);
		assertFalse(foundMatch);
		
		//different stock as orderitem
		processOrderItem.setSku(sku);
		processOrderItem.setPrice(11);
		processOrderItem.setStock(stock2);
		var foundMatch = processOrderItem.CompareOrderItemToProcessOrderItem(orderItem);
		assertFalse(foundMatch);
		
		//different price as orderitem
		processOrderItem.setSku(sku);
		processOrderItem.setPrice(12);
		processOrderItem.setStock(stock);
		var foundMatch = processOrderItem.CompareOrderItemToProcessOrderItem(orderItem);
		assertFalse(foundMatch);
		
		//attributes tests
		/*var attributeValue = request.slatwallScope.newEntity( 'AttributeValue' );
		
		orderitem.addAttributeValue(attributeValue);
		processOrderItem = order.getProcessObject( 'AddOrderItem' );
		
		
		processOrderItem.setattributeValuesByCodeStruct();
		processOrderItem.setSku(sku);
		processOrderItem.setPrice(11);
		processOrderItem.setStock(stock);
		var foundMatch = variables.service.CompareOrderItemToProcessOrderItem(orderItem,processOrderItem);
		assertFalse(foundMatch);*/
	}
	
	private any function getTestSku(string testsku){
		var sku = request.slatwallScope.newEntity('Sku');
		sku.setSkuName(arguments.testsku);
		sku.setSkuCode(arguments.testsku);
		sku.setSkuID(createUUID());
		return sku;
	}
	
	private any function getTestStock(){
		var stock = request.slatwallScope.newEntity('Stock');
		stock.setStockID(CreateUUID());
		return stock;
	}
	
}
