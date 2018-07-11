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
		
		variables.service = createMock(object=request.slatwallScope.getBean("vendorOrderService"));
	}
	
	/*public void function processVendorOrder_receiveTest(){
		
		var productData={
			productID="",
			productName="test",
			productCode="test"&createUUID()
		};
		var product = createPersistedTestENtity('product',productData);
		
		var skuData = {
			skuID="",
			skuName="test",
			skuCode="test"&createUUID(),
			product={
				productID=product.getProductID()
			}
		};
		var sku = createPersistedTestEntity('sku',skuData);
		
		var stockData = {
			stockID="",
			sku={
				skuID=sku.getSkuID()
			},
			locations=[
				{
					locationID='88e6d435d3ac2e5947c81ab3da60eba2'
				}
			]
		};
		var stock = createPersistedTestEntity('stock',stockData);
		
		var vendorOrderItemData = {
			vendorOrderItemID="",
			stock={
				stockid=stock.getStockID()
			}
		};
		var vendorOrderItem = createPersistedTestEntity('vendorOrderItem',vendorOrderItemData);
		
		
		var vendorOrderData = {
			vendorOrderID="",
			vendorOrderItems=[
				{
					quantity=5,
					vendorOrderItemID=vendorOrderItem.getVendorOrderItemID()
				}
			]
		};
		var vendorOrder = createPersistedTestEntity('VendorOrder',vendorOrderData);
		
		var vendorOrder_ReceiveData = {
			//default location
			locationID='88e6d435d3ac2e5947c81ab3da60eba2',
			vendorOrderItems=[
				{
					quantity=5,
					vendorOrderItem.vendorOrderItemID=vendorOrderItem.getVendorOrderItemID()
				}
			]
		};
		
		vendorOrder = variables.service.processVendorOrder(vendorOrder,vendorOrder_ReceiveData,'Receive');
		
		//make sure that a stockReceiverItem is created
		assert(arrayLen(vendorOrder.getVendorOrderItems()[1].getStockReceiverItems()));
		assertEquals(vendorOrder.getVendorOrderStatusType().getSystemCode(),'vostClosed');
	}*/
	
	public void function processVendorOrder_receiveTest_partiallyRecieived(){
		
		var productData={
			productID="",
			productName="test",
			productCode="test"&createUUID()
		};
		var product = createPersistedTestENtity('product',productData);
		
		var skuData = {
			skuID="",
			skuName="test",
			skuCode="test"&createUUID(),
			product={
				productID=product.getProductID()
			}
		};
		var sku = createPersistedTestEntity('sku',skuData);
		
		var stockData = {
			stockID="",
			sku={
				skuID=sku.getSkuID()
			},
			locations=[
				{
					locationID='88e6d435d3ac2e5947c81ab3da60eba2'
				}
			]
		};
		var stock = createPersistedTestEntity('stock',stockData);
		
		var vendorOrderItemData = {
			vendorOrderItemID="",
			quantity=7,
			stock={
				stockid=stock.getStockID()
			}
		};
		var vendorOrderItem = createPersistedTestEntity('vendorOrderItem',vendorOrderItemData);
		
		
		var vendorOrderData = {
			vendorOrderID="",
			vendorOrderItems=[
				{
					vendorOrderItemID=vendorOrderItem.getVendorOrderItemID()
				}
			]
		};
		var vendorOrder = createPersistedTestEntity('VendorOrder',vendorOrderData);
		
		var vendorOrder_ReceiveData = {
			//default location
			locationID='88e6d435d3ac2e5947c81ab3da60eba2',
			vendorOrderItems=[
				{
					quantity=5,
					vendorOrderItem.vendorOrderItemID=vendorOrderItem.getVendorOrderItemID()
				}
			]
		};
		
		vendorOrder = variables.service.processVendorOrder(vendorOrder,vendorOrder_ReceiveData,'Receive');
		
		//make sure that a stockReceiverItem is created
		assert(arrayLen(vendorOrder.getVendorOrderItems()[1].getStockReceiverItems()));
		assertEquals(vendorOrder.getVendorOrderStatusType().getSystemCode(),'vostPartiallyReceived');
	}
	
	
}


