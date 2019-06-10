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
component extends="Slatwall.meta.tests.unit.dao.SlatwallDAOTestBase" {

	
	public void function setUp() {
		super.setup();
		
		variables.dao = variables.mockservice.getSkuDAOMock();
	}
		
	/**
	* @test
	*/
	public void function inst_ok() {
		assert(isObject(variables.dao));
	}
	
	private any function createMockSku() {
		var skuData = {
			skuID = ""
		};
		return createPersistedTestEntity('Sku', skuData);
	}
	
	private any function createMockProduct(string productID) {
		var productData = {
			productID = ""
		};
	}
		
	/**
	* @test
	*/
	public void function getSkuDefinitionForMerchandiseBySkuIDTest(){
		var skuData = {
			skuID=""
		};
		var sku = createPersistedTestEntity('Sku',skuData);
		
		var optionGroupData={
			optionGroupID="",
			optionGroupName='optionGroupNameb'&createUUID()
		};
		var optionGroup = createPersistedTestEntity('OptionGroup',optionGroupData);
		optionGroup.setSortOrder(7);
		
		var optionGroupData2={
			optionGroupID="",
			optionGroupName='optionGroupNamea'&createUUID()
		};
		var optionGroup2 = createPersistedTestEntity('OptionGroup',optionGroupData2);
		optionGroup2.setSortOrder(8);
		var optionData = {
			optionID="",
			optionName="optionName"&createUUID(),
			skus=[{
				skuID=sku.getSkuID()
			}],
			optionGroup={
				optionGroupID=optionGroup.getOptionGroupID()
			}
		};
		var option = createPersistedTestEntity('option',optionData);
		
		var optionData2 = {
			optionID="",
			optionName="optionNamec"&createUUID(),
			skus=[{
				skuID=sku.getSkuID()
			}],
			optionGroup={
				optionGroupID=optionGroup2.getOptionGroupID()
			}
		};
		var option2 = createPersistedTestEntity('option',optionData2);
		
		var skuDefinition = variables.dao.getSkuDefinitionForMerchandiseBySkuID(sku.getSkuID());
		
		assertEquals(trim(skuDefinition),'#optionGroup.getOptionGroupName()#: #option.getOptionName()#, #optionGroup2.getOptionGroupName()#: #option2.getOptionName()#');
		optionGroup2.setSortOrder(1);
		persistTestEntity(optionGroup2,{});
		
		var skuDefinition2 = variables.dao.getSkuDefinitionForMerchandiseBySkuID(sku.getSkuID());
		assertEquals(trim(skuDefinition2),'#optionGroup2.getOptionGroupName()#: #option2.getOptionName()#, #optionGroup.getOptionGroupName()#: #option.getOptionName()#');
		
	}
		
	/**
	* @test
	*/
	public void function getTransactionExistsFlagTest_Arguments() {
		//Testing the flag without any where-exists in hql
		var mockSku1 = createMockSku();
		var mockSku2 = createMockSku();
		
		var productData = {
			productID = "",
			skus = [
				{
					skuID = mockSku1.getSkuID()
				}, {
					skuID = mockSku2.getSkuID()
				}
				
			]
		};
		var mockProduct = createPersistedTestEntity('Product', productData);
		
		var resultBothArgus = variables.dao.getTransactionExistsFlag(mockProduct.getProductID(), mockSku1.getSkuID());
		assertFalse(resultBothArgus);

		var resultProductArgu = variables.dao.getTransactionExistsFlag(mockProduct.getProductID());
		assertFalse(resultProductArgu);
		
		var resultSkuArgu = variables.dao.getTransactionExistsFlag("", mockSku1.getSkuID());
		assertFalse(resultSkuArgu);
	}
		
	/**
	* @test
	*/
	public void function getTransactionExistsFlagTest_OrderItem() {
		//Testing then the orderItem exists
		var mockSku = createMockSku();
		
		var orderItemData = {
			orderItem = "",
			sku = {
				skuID = mockSku.getSkuID()
			}
		};
		var mockOrderItem = createPersistedTestEntity('OrderItem', orderItemData);

		var resultOrderItem = variables.dao.getTransactionExistsFlag("", mockSku.getSkuID());
		assertTrue(resultOrderItem);
	}
	
	private any function createMockStock(string skuID='') {
		var stockData = {
			stockID = ""
		};
		if(len(arguments.skuID)) {
			stockData.sku = {
				skuID = arguments.skuID
			};
		}
		return createPersistedTestEntity('Stock', stockData);
	}
		
	/**
	* @test
	*/
	public void function getTransactionExistsFlagTest_InventoryID() {
		var mockSku = createMockSKu();
		var mockStock = createMockStock(mockSku.getSkuID());

		var inventoryData = {
			inventoryID = "",
			stock = {
				stockID = mockStock.getStockID()
			}
		};
		var mockInventory = createPersistedTestEntity('Inventory', inventoryData);
		
		var resultInventory = variables.dao.getTransactionExistsFlag("", mockSku.getSkuID());
		assertTrue(resultInventory);	
	}
		
	/**
	* @test
	*/
	public void function getTransactionExistsFlagTest_PhysicalCountItemID() {
		var mockSku = createMockSKu();
		var mockStock = createMockStock(mockSku.getSkuID());
		
		var physicalCountItemData = {
			physicalCountItemID = "",
			stock = {
				stockID = mockStock.getStockID()
			}
		};
		var mockPhysicalCountItem= createPersistedTestEntity('PhysicalCountItem', PhysicalCountItemData);

		var resultPhysicalCountItem = variables.dao.getTransactionExistsFlag("", mockSku.getSkuID());
		assertTrue(resultPhysicalCountItem);
	}
		
	/**
	* @test
	*/
	public void function getTransactionExistsFlagTest_StockAdjustmentItem() {
		var mockSku = createMockSKu();
		var mockStock1 = createMockStock(mockSku.getSkuID());
		var mockStock2 = createMockStock(mockSku.getSkuID());
		
		var StockAdjustmentItemData = {
			physicalCountItemID = "",
			fromStock = {
				stockID = mockStock1.getStockID()
			},
			toStock = {
				stockID = mockStock2.getStockID()
			}
		};
		var mockStockAdjustmentItem= createPersistedTestEntity('StockAdjustmentItem', StockAdjustmentItemData);

		var resultStockAdjustmentItem = variables.dao.getTransactionExistsFlag("", mockSku.getSkuID());
		assertTrue(resultStockAdjustmentItem);
	}
	
	private void function getAverageLandedCostTest(){
		
	}
	
	private void function getAveragePriceSold(){
		var skuData = {
			skuID=""
		};
		var sku = createPersistedTestEntity('Sku',skuData);
		
		var orderData = {
			orderID="",
			orderStatusType={
				//ostNew
				typeID='444df2b5c8f9b37338229d4f7dd84ad1'
			}
		};
		var order = createPersistedTestEntity('Order',orderData);
		
		var orderItemData = {
			orderItemID="",
			orderItemStatusType={
				//oitSale
				typeID='444df2e9a6622ad1614ea75cd5b982ce'
			},
			price=8,
			order={
				orderID=order.getOrderID()
			},
			sku={
				skuID=sku.getSkuID()
			}
		};
		var orderItem = createPersistedTestEntity('OrderItem',orderItemData);
		order.addOrderItem(orderItem);
		orderItem.setOrder(order);
		
		var orderItemData2 = {
			orderItemID="",
			orderItemStatusType={
				//oitSale
				typeID='444df2e9a6622ad1614ea75cd5b982ce'
			},
			price=2,
			order={
				orderID=order.getOrderID()
			},
			sku={
				skuID=sku.getSkuID()
			}
		};
		var orderItem2 = createPersistedTestEntity('OrderItem',orderItemData2);
		order.addOrderItem(orderItem2);
		orderItem2.setOrder(order);
		
		var orderDeliveryItemData = {
			orderDeliveryItemID="",
			quantity=7,
			orderItem={
				orderItemID=orderItem.getOrderItemID()
			}
		};
		var orderDeliveryItem = createTestEntity('OrderDeliveryItem',orderDeliveryItemData);
		injectMethod(orderDeliveryItem, this, 'returnVoid', 'preInsert');
		persistTestEntity(orderDeliveryItem, orderDeliveryItemData);
		
		var orderDeliveryItemData2 = {
			orderDeliveryItemID="",
			quantity=2,
			orderItem={
				orderItemID=orderItem2.getOrderItemID()
			}
		};
		var orderDeliveryItem2 = createTestEntity('OrderDeliveryItem',orderDeliveryItemData2);
		injectMethod(orderDeliveryItem2, this, 'returnVoid', 'preInsert');
		persistTestEntity(orderDeliveryItem2, orderDeliveryItemData2);
		
		var averagePriceSold = variables.dao.getAveragePriceSold(sku.getSkuID());
		assertEquals(averagePriceSold,6.67,'((2*2)+ (8*7)) /9 )');
	}
	
	private  void function returnVoid() {
		
	}
}
