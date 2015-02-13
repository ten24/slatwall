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
		
		variables.service = request.slatwallScope.getBean("orderService");
		
	}
	
	public void function processOrder_addOrderItem_addProductBundle(){
		//set up data
		
		//set up productBundle
		var productData = {
			productName="productBundleName",
			productid="",
			activeflag=1,
			skus=[
				{
					skuid="",
					activeflag=1,
					skuCode = 'productBundle-1',
					productBundleGroups=[
						{
							productBundleGroupid:""
						},
						{
							productBundleGroupid:""
						}
					]
				}
			],
			//product Bundle type from SlatwallProductType.xml
			productType:{
				productTypeid:"ad9bb5c8f60546e0adb428b7be17673e"
			}
		};
		var product = createPersistedTestEntity('product',productData);
		
		//set up child orderitems
		var childOrderItem1Data = {
			orderitemid:"",
			sku={
				skuid="",
				skuCode="child-orderitem-1",
				product={
					productName="productchild-1",
					productid="",
					activeflag=1
				},
				activeflag=1
			},
			quantity=2,
			productBundleGroup=product.getSkus()[1].getProductBundleGroups()[1]
		};
		var childOrderItem1 = createTestEntity('orderitem',childOrderItem1Data);
		
		var childOrderItem2Data = {
			orderitemid:""	,
			quantity=3,
			sku={
				skuid="",
				skuCode="child-orderitem-2",
				product={
					productName="productchild-2",
					productid="",
					activeflag=1
				},
				activeflag=1
			},
			productBundleGroup=product.getSkus()[1].getProductBundleGroups()[2]
		};
		var childOrderItem2 = createTestEntity('orderItem',childOrderItem2Data);
		
		//set up order
		var orderData = {
			orderid="",
			activeflag=1,
			currencycode="USD"
			
		};
		var order = createPersistedTestEntity('Order',orderData);
		
		//add orderfulfillment
		var processObjectData = {
			quantity=1,
			price=1,
			sku=product.getSkus()[1],
			childOrderItems=[
				childOrderItem1,
				childOrderItem2
			]
//			orderFulfillment={
//				orderfulfillmentid:""
//			}
		};
		var processObject = order.getProcessObject('AddOrderItem',processObjectData);
		
		
		//verify that the process object has two child order items
		assertTrue(arraylen(processObject.getChildOrderItems()) == 2);
		//verify that the process object is of productBundle
		assertTrue(processObject.getSku().getBaseProductType() == 'productBundle');
		
		//run the process
		var orderReturn = variables.service.processOrder_addOrderItem(order,processObject);
		//verify there are no errors
		assertFalse(processObject.hasErrors());
		assertFalse(orderReturn.hasErrors());
		
		//verify that the orderitem sku is the same as the product bundle sku
		assertTrue(orderReturn.getOrderItems()[1].getSku().getSkuid() == product.getSkus()[1].getSkuid());
		assertEquals(arraylen(orderReturn.getOrderItems()),1);
		//verify that we have childOrderItems
		assertTrue(orderReturn.getOrderItems()[1].hasChildOrderItem());
		assertEquals(arraylen(orderReturn.getOrderItems()[1].getChildOrderItems()),2);
		
	} 
	
	public void function test(){
		//set up order
		var orderItemData = {
			orderItemid=""
		};
		var orderItem = createPersistedTestEntity('OrderItem',orderItemData);
		
		//var processObject = order.getProcessObject('AddOrderItem');
		//request.debug(processObject); 
	}
	
}


