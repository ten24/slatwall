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
		variables.dao = request.slatwallScope.getDAO("inventoryDAO");
	}

	public void function inst_ok() {
		assert(isObject(variables.dao));
	}
	
	// Ensure getQOH executes without error
	public any function getQOH_runs_without_error() {
		assertEquals([],variables.dao.getQOH(productID="1", productRemoteID="1"));
	}	
	
	// Ensure getQOSH executes without error
	public any function getQOSH_runs_without_error() {
		assertEquals(0,variables.dao.getQOSH(productID="1", productRemoteID="1"));
	}
		
	// Ensure getQNDOO executes without error
	public any function getQNDOO_runs_without_error() {
		assertEquals([],variables.dao.getQNDOO(productID="1", productRemoteID="1"));
	}	
		
	// Ensure getQNDORVO executes without error
	public any function getQNDORVO_runs_without_error() {
		assertEquals(0,variables.dao.getQNDORVO(productID="1", productRemoteID="1"));
	}	
		
	// Ensure getQNDOSA executes without error
	public any function getQNDOSA_runs_without_error() {
		assertEquals([],variables.dao.getQNDOSA(productID="1", productRemoteID="1"));
	}	
		
	// Ensure getQNROVO executes without error
	public any function getQNROVO_runs_without_error() {
		assertEquals([],variables.dao.getQNROVO(productID="1", productRemoteID="1"));
	}	
		
	// Ensure getQNRORO executes without error
	public any function getQNRORO_runs_without_error() {
		assertEquals([],variables.dao.getQNRORO(productID="1", productRemoteID="1"));
	}	
		
	// Ensure getQNROSA executes without error
	public any function getQNROSA_runs_without_error() {
		assertEquals([],variables.dao.getQNROSA(productID="1", productRemoteID="1"));
	}	
	
	public any function getQOHTest() {
		var mockProduct = createMockProduct();
		var mockLocation = createMockLocation();
		var mockSku = createMockSku(mockProduct.getProductID());
		var mockSku2 = createMockSku(mockProduct.getProductID());
		
		var stockData = {
			stockID = '',
			sku = {
				skuID = mockSku.getSkuID()
			},
			location = {
				locationID = mockLocation.getLocationID()
			}
		};
		var mockStock = createPersistedTestEntity('Stock', stockData);
		
		var stockData2 = {
			stockID = '',
			sku = {
				skuID = mockSku2.getSkuID()
			},
			location = {
				locationID = mockLocation.getLocationID()
			}
		};
		var mockStock2 = createPersistedTestEntity('Stock', stockData2);
		
		var inventoryData1 = {
			inventoryID = '',
			stock =  {
				stockID = mockStock.getStockID()
			},
			quantityIn = 100,
			quantityOut = 30
		};
		var mockInventory1 = createPersistedTestEntity('Inventory', inventoryData1);
		
		var inventoryData2 = {
			inventoryID = '',
			stock =  {
				stockID = mockStock.getStockID()
			},
			quantityIn = 200,
			quantityOut = 20 
		};
		var mockInventory2 = createPersistedTestEntity('Inventory', inventoryData2);
		
		var inventoryData3 = {
			inventoryID = '',
			stock =  {
				stockID = mockStock2.getStockID()
			},
			quantityIn = 22,
			quantityOut = 11
		};
		var mockInventory3 = createPersistedTestEntity('Inventory', inventoryData3);
		
		var result = variables.dao.getQOH(mockProduct.getProductID());
		assertEquals(250, result[1].QOH, 'It should be (100 + 200) - (30 + 20) = 250');
	}
	
	public void function getQDOOTest(){
		var mockProduct = createMockProduct();
		var mockLocation = createMockLocation();
		var mockSku = createMockSku(mockProduct.getProductID());
		var mockSku2 = createMockSku(mockProduct.getProductID());
		
		var stockData = {
			stockID = '',
			sku = {
				skuID = mockSku.getSkuID()
			},
			location = {
				locationID = mockLocation.getLocationID()
			}
		};
		var mockStock = createPersistedTestEntity('Stock', stockData);
		
		var stockData2 = {
			stockID = '',
			sku = {
				skuID = mockSku2.getSkuID()
			},
			location = {
				locationID = mockLocation.getLocationID()
			}
		};
		var mockStock2 = createPersistedTestEntity('Stock', stockData2);
		
		
		//first order
		var orderItemData = {
			orderItemID = '',
			orderItemType = {
				typeID = '444df2e9a6622ad1614ea75cd5b982ce'//oitSale
			},
			quantity = 12,
			sku = {
				skuID = mockSku.getSkuID()
			},
			stock = {
				stockID = mockStock.getStockID()
			}
		};
		var mockOrderItem = createPersistedTestEntity('OrderItem', orderItemData);
		
		var orderDeliveryItemData1 = {
			orderDeliveryItemID = '',
			quantity = 1,
			orderItem = {
				orderItemID = mockOrderItem.getOrderItemID()
			}
		};
		var mockOrderDeliveryItem1 = createTestEntity('OrderDeliveryItem', orderDeliveryItemData1);
		injectMethod(mockOrderDeliveryItem1, this, 'returnVoid', 'preInsert');
		persistTestEntity(mockOrderDeliveryItem1, orderDeliveryItemData1);
		
		var orderDeliveryItemData2 = {
			orderDeliveryItemID = '',
			quantity = 2,
			orderItem = {
				orderItemID = mockOrderItem.getOrderItemID()
			}
		};
		var mockOrderDeliveryItem2 = createTestEntity('OrderDeliveryItem', orderDeliveryItemData2);
		
		injectMethod(mockOrderDeliveryItem2, this, 'returnVoid', 'preInsert');
		persistTestEntity(mockOrderDeliveryItem2, orderDeliveryItemData2);
		
		var orderData = {
			orderID = '',
			orderStatusType = {
				typeID = '444df2b6b8b5d1ccfc14a4ab38aa0a4c'//ostProcessing
			},
			orderItems = [{
				orderItemID = mockOrderItem.getOrderItemID()
			}]
		};
		var mockOrder = createPersistedTestEntity('Order', orderData);
		
		mockOrderItem.addOrderDeliveryItem(mockOrderDeliveryItem1);
		mockOrderItem.addOrderDeliveryItem(mockOrderDeliveryItem2);
		mockOrderItem.setOrder(mockOrder);
		
		
		//second order
		var orderItemData3 = {
			orderItemID = '',
			orderItemType = {
				typeID = '444df2e9a6622ad1614ea75cd5b982ce'//oitSale
			},
			quantity = 15,
			sku = {
				skuID = mockSku2.getSkuID()
			},
			stock = {
				stockID = mockStock2.getStockID()
			}
		};
		var mockOrderItem3 = createPersistedTestEntity('OrderItem', orderItemData3);
		var orderItemData4 = {
			orderItemID = '',
			orderItemType = {
				typeID = '444df2e9a6622ad1614ea75cd5b982ce'//oitSale
			},
			quantity = 17,
			sku = {
				skuID = mockSku2.getSkuID()
			},
			stock = {
				stockID = mockStock2.getStockID()
			}
		};
		var mockOrderItem4 = createPersistedTestEntity('OrderItem', orderItemData4);
		
		var orderDeliveryItemData3 = {
			orderDeliveryItemID = '',
			quantity = 1,
			orderItem = {
				orderItemID = mockOrderItem3.getOrderItemID()
			}
		};
		var mockOrderDeliveryItem3 = createTestEntity('OrderDeliveryItem', orderDeliveryItemData3);
		injectMethod(mockOrderDeliveryItem3, this, 'returnVoid', 'preInsert');
		persistTestEntity(mockOrderDeliveryItem3, orderDeliveryItemData3);
		
		var orderData2 = {
			orderID = '',
			orderStatusType = {
				typeID = '444df2b6b8b5d1ccfc14a4ab38aa0a4c'//ostProcessing
			},
			orderItems = [{
				orderItemID = mockOrderItem3.getOrderItemID()
			},
			{
				orderItemID = mockOrderItem4.getOrderItemID()
			}]
		};
		var mockOrder2 = createPersistedTestEntity('Order', orderData2);
		
		mockOrderItem3.addOrderDeliveryItem(mockOrderDeliveryItem3);
		mockOrderItem3.addOrderDeliveryItem(mockOrderDeliveryItem3);
		mockOrderItem3.setOrder(mockOrder2);
		mockOrderItem4.setOrder(mockOrder2);
		
		
		
		var result = variables.dao.getQDOO(mockProduct.getProductID());
		assertEquals(3, result[1].QDOO,'should be 1+2=3');
		assertEquals(1, result[2].QDOO);
	}
	
	public void function getQOOTest(){
		var mockProduct = createMockProduct();
		var mockLocation = createMockLocation();
		var mockSku = createMockSku(mockProduct.getProductID());
		var mockSku2 = createMockSku(mockProduct.getProductID());
		
		var stockData = {
			stockID = '',
			sku = {
				skuID = mockSku.getSkuID()
			},
			location = {
				locationID = mockLocation.getLocationID()
			}
		};
		var mockStock = createPersistedTestEntity('Stock', stockData);
		
		var stockData2 = {
			stockID = '',
			sku = {
				skuID = mockSku2.getSkuID()
			},
			location = {
				locationID = mockLocation.getLocationID()
			}
		};
		var mockStock2 = createPersistedTestEntity('Stock', stockData2);
		
		
		//first order
		var orderItemData = {
			orderItemID = '',
			orderItemType = {
				typeID = '444df2e9a6622ad1614ea75cd5b982ce'//oitSale
			},
			quantity = 12,
			sku = {
				skuID = mockSku.getSkuID()
			},
			stock = {
				stockID = mockStock.getStockID()
			}
		};
		var mockOrderItem = createPersistedTestEntity('OrderItem', orderItemData);
		
		var orderDeliveryItemData1 = {
			orderDeliveryItemID = '',
			quantity = 1,
			orderItem = {
				orderItemID = mockOrderItem.getOrderItemID()
			}
		};
		var mockOrderDeliveryItem1 = createTestEntity('OrderDeliveryItem', orderDeliveryItemData1);
		injectMethod(mockOrderDeliveryItem1, this, 'returnVoid', 'preInsert');
		persistTestEntity(mockOrderDeliveryItem1, orderDeliveryItemData1);
		
		var orderDeliveryItemData2 = {
			orderDeliveryItemID = '',
			quantity = 2,
			orderItem = {
				orderItemID = mockOrderItem.getOrderItemID()
			}
		};
		var mockOrderDeliveryItem2 = createTestEntity('OrderDeliveryItem', orderDeliveryItemData2);
		
		injectMethod(mockOrderDeliveryItem2, this, 'returnVoid', 'preInsert');
		persistTestEntity(mockOrderDeliveryItem2, orderDeliveryItemData2);
		
		var orderData = {
			orderID = '',
			orderStatusType = {
				typeID = '444df2b6b8b5d1ccfc14a4ab38aa0a4c'//ostProcessing
			},
			orderItems = [{
				orderItemID = mockOrderItem.getOrderItemID()
			}]
		};
		var mockOrder = createPersistedTestEntity('Order', orderData);
		
		mockOrderItem.addOrderDeliveryItem(mockOrderDeliveryItem1);
		mockOrderItem.addOrderDeliveryItem(mockOrderDeliveryItem2);
		mockOrderItem.setOrder(mockOrder);
		
		
		//second order
		var orderItemData3 = {
			orderItemID = '',
			orderItemType = {
				typeID = '444df2e9a6622ad1614ea75cd5b982ce'//oitSale
			},
			quantity = 15,
			sku = {
				skuID = mockSku2.getSkuID()
			},
			stock = {
				stockID = mockStock2.getStockID()
			}
		};
		var mockOrderItem3 = createPersistedTestEntity('OrderItem', orderItemData3);
		var orderItemData4 = {
			orderItemID = '',
			orderItemType = {
				typeID = '444df2e9a6622ad1614ea75cd5b982ce'//oitSale
			},
			quantity = 17,
			sku = {
				skuID = mockSku2.getSkuID()
			},
			stock = {
				stockID = mockStock2.getStockID()
			}
		};
		var mockOrderItem4 = createPersistedTestEntity('OrderItem', orderItemData4);
		
		var orderDeliveryItemData3 = {
			orderDeliveryItemID = '',
			quantity = 1,
			orderItem = {
				orderItemID = mockOrderItem.getOrderItemID()
			}
		};
		var mockOrderDeliveryItem3 = createTestEntity('OrderDeliveryItem', orderDeliveryItemData3);
		injectMethod(mockOrderDeliveryItem3, this, 'returnVoid', 'preInsert');
		persistTestEntity(mockOrderDeliveryItem3, orderDeliveryItemData3);
		
		var orderData2 = {
			orderID = '',
			orderStatusType = {
				typeID = '444df2b6b8b5d1ccfc14a4ab38aa0a4c'//ostProcessing
			},
			orderItems = [{
				orderItemID = mockOrderItem3.getOrderItemID()
			},
			{
				orderItemID = mockOrderItem4.getOrderItemID()
			}]
		};
		var mockOrder2 = createPersistedTestEntity('Order', orderData2);
		
		mockOrderItem3.addOrderDeliveryItem(mockOrderDeliveryItem3);
		mockOrderItem3.addOrderDeliveryItem(mockOrderDeliveryItem3);
		mockOrderItem3.setOrder(mockOrder2);
		mockOrderItem4.setOrder(mockOrder2);
		
		
		
		var result = variables.dao.getQOO(mockProduct.getProductID());
		assertEquals(12, result[1].QOO);
		assertEquals(32, result[2].QOO,'should be 17+15=32');
	}
	
	public void function getQNDOOTest() {
		var mockProduct = createMockProduct();
		var mockLocation = createMockLocation();
		var mockSku = createMockSku(mockProduct.getProductID());
		var mockSku2 = createMockSku(mockProduct.getProductID());
		
		var stockData = {
			stockID = '',
			sku = {
				skuID = mockSku.getSkuID()
			},
			location = {
				locationID = mockLocation.getLocationID()
			}
		};
		var mockStock = createPersistedTestEntity('Stock', stockData);
		
		var stockData2 = {
			stockID = '',
			sku = {
				skuID = mockSku2.getSkuID()
			},
			location = {
				locationID = mockLocation.getLocationID()
			}
		};
		var mockStock2 = createPersistedTestEntity('Stock', stockData2);
		
		
		//first order
		var orderItemData = {
			orderItemID = '',
			orderItemType = {
				typeID = '444df2e9a6622ad1614ea75cd5b982ce'//oitSale
			},
			quantity = 10,
			sku = {
				skuID = mockSku.getSkuID()
			},
			stock = {
				stockID = mockStock.getStockID()
			}
		};
		var mockOrderItem = createPersistedTestEntity('OrderItem', orderItemData);
		
		var orderDeliveryItemData1 = {
			orderDeliveryItemID = '',
			quantity = 1,
			orderItem = {
				orderItemID = mockOrderItem.getOrderItemID()
			}
		};
		var mockOrderDeliveryItem1 = createTestEntity('OrderDeliveryItem', orderDeliveryItemData1);
		injectMethod(mockOrderDeliveryItem1, this, 'returnVoid', 'preInsert');
		persistTestEntity(mockOrderDeliveryItem1, orderDeliveryItemData1);
		
		var orderDeliveryItemData2 = {
			orderDeliveryItemID = '',
			quantity = 2,
			orderItem = {
				orderItemID = mockOrderItem.getOrderItemID()
			}
		};
		var mockOrderDeliveryItem2 = createTestEntity('OrderDeliveryItem', orderDeliveryItemData2);
		
		injectMethod(mockOrderDeliveryItem2, this, 'returnVoid', 'preInsert');
		persistTestEntity(mockOrderDeliveryItem2, orderDeliveryItemData2);
		
		var orderData = {
			orderID = '',
			orderStatusType = {
				typeID = '444df2b6b8b5d1ccfc14a4ab38aa0a4c'//ostProcessing
			},
			orderItems = [{
				orderItemID = mockOrderItem.getOrderItemID()
			}]
		};
		var mockOrder = createPersistedTestEntity('Order', orderData);
		
		mockOrderItem.addOrderDeliveryItem(mockOrderDeliveryItem1);
		mockOrderItem.addOrderDeliveryItem(mockOrderDeliveryItem2);
		mockOrderItem.setOrder(mockOrder);
		
		
		//second order
		var orderItemData3 = {
			orderItemID = '',
			orderItemType = {
				typeID = '444df2e9a6622ad1614ea75cd5b982ce'//oitSale
			},
			quantity = 10,
			sku = {
				skuID = mockSku2.getSkuID()
			},
			stock = {
				stockID = mockStock2.getStockID()
			}
		};
		var mockOrderItem3 = createPersistedTestEntity('OrderItem', orderItemData3);
		
		var orderDeliveryItemData3 = {
			orderDeliveryItemID = '',
			quantity = 1,
			orderItem = {
				orderItemID = mockOrderItem3.getOrderItemID()
			}
		};
		var mockOrderDeliveryItem3 = createTestEntity('OrderDeliveryItem', orderDeliveryItemData3);
		injectMethod(mockOrderDeliveryItem3, this, 'returnVoid', 'preInsert');
		persistTestEntity(mockOrderDeliveryItem3, orderDeliveryItemData3);
		
		var orderData2 = {
			orderID = '',
			orderStatusType = {
				typeID = '444df2b6b8b5d1ccfc14a4ab38aa0a4c'//ostProcessing
			},
			orderItems = [{
				orderItemID = mockOrderItem3.getOrderItemID()
			}]
		};
		var mockOrder2 = createPersistedTestEntity('Order', orderData2);
		
		mockOrderItem3.addOrderDeliveryItem(mockOrderDeliveryItem3);
		mockOrderItem3.addOrderDeliveryItem(mockOrderDeliveryItem3);
		mockOrderItem3.setOrder(mockOrder2);
		
		
		var result = variables.dao.getQNDOO(mockProduct.getProductID());
		assertEquals(7, result[1].QNDOO, 'Should be 10 - (1 + 2) = 7');
		assertEquals(9, result[2].QNDOO, 'Should be 10 - (1) = 9');
	}
	
	public void function getQNROROTest() {
		var mockProduct = createMockProduct();
		var mockLocation = createMockLocation();
		var mockSku = createMockSku(mockProduct.getProductID());
		
		var mockSku2 = createMockSku(mockProduct.getProductID());
		
		var stockData = {
			stockID = '',
			sku = {
				skuID = mockSku.getSkuID()
			},
			location = {
				locationID = mockLocation.getLocationID()
			}
		};
		var mockStock = createPersistedTestEntity('Stock', stockData);
		
		var stockData2 = {
			stockID = '',
			sku = {
				skuID = mockSku2.getSkuID()
			},
			location = {
				locationID = mockLocation.getLocationID()
			}
		};
		var mockStock2 = createPersistedTestEntity('Stock', stockData2);
		
		var orderItemData = {
			orderItemID = '',
			orderItemType = {
				typeID = '444df2eac18fa589af0f054442e12733'//oitReturn
			},
			quantity = 10,
			sku = {
				skuID = mockSku.getSkuID()
			},
			stock = {
				stockID = mockStock.getStockID()
			}
		};
		var mockOrderItem = createPersistedTestEntity('OrderItem', orderItemData);
		
		var orderItemData2 = {
			orderItemID = '',
			orderItemType = {
				typeID = '444df2eac18fa589af0f054442e12733'//oitReturn
			},
			quantity = 10,
			sku = {
				skuID = mockSku2.getSkuID()
			},
			stock = {
				stockID = mockStock2.getStockID()
			}
		};
		var mockOrderItem2 = createPersistedTestEntity('OrderItem', orderItemData2);
		
		var stockReceiverItemData1 = {
			orderDeliveryItemID = '',
			quantity = 1
		};
		var mockStockReceiverItem1 = createTestEntity('stockReceiverItem', stockReceiverItemData1);
		mockStockReceiverItem1.setOrderItem(mockOrderItem);
		injectMethod(mockStockReceiverItem1, this, 'returnVoid', 'preInsert');
		injectMethod(mockStockReceiverItem1, this, 'returnVoid', 'preUpdate');
		persistTestEntity(mockStockReceiverItem1, stockReceiverItemData1);
		
		var stockReceiverItemData2 = {
			orderDeliveryItemID = '',
			quantity = 2,
			orderItem = {
				orderItemID = mockOrderItem.getOrderItemID()
			}
		};
		var mockStockReceiverItem2 = createTestEntity('StockReceiverItem', StockReceiverItemData2);
		mockStockReceiverItem2.setOrderItem(mockOrderItem);
		injectMethod(mockStockReceiverItem2, this, 'returnVoid', 'preInsert');
		injectMethod(mockStockReceiverItem2, this, 'returnVoid', 'preUpdate');
		persistTestEntity(mockStockReceiverItem2, stockReceiverItemData2);
		
		var stockReceiverItemData3 = {
			orderDeliveryItemID = '',
			quantity = 1
		};
		var mockStockReceiverItem3 = createTestEntity('stockReceiverItem', stockReceiverItemData3);
		mockStockReceiverItem3.setOrderItem(mockOrderItem2);
		injectMethod(mockStockReceiverItem3, this, 'returnVoid', 'preInsert');
		injectMethod(mockStockReceiverItem3, this, 'returnVoid', 'preUpdate');
		persistTestEntity(mockStockReceiverItem3, stockReceiverItemData3);

		var orderData = {
			orderID = '',
			orderStatusType = {
				typeID = '444df2b6b8b5d1ccfc14a4ab38aa0a4c'//ostProcessing
			},
			orderItems = [{
				orderItemID = mockOrderItem.getOrderItemID()
			},{
				orderItemID = mockOrderItem2.getOrderItemID()
			}]
		};
		var mockOrder = createPersistedTestEntity('Order', orderData);
		
		mockOrderItem.addStockReceiverItem(mockStockReceiverItem1);
		mockOrderItem.addStockReceiverItem(mockStockReceiverItem2);
		mockOrder.addOrderItem(mockOrderItem);
		
		mockOrderItem2.addStockReceiverItem(mockStockReceiverItem3);
		mockOrder.addOrderItem(mockOrderItem2);
		var result = var result = variables.dao.getQNRORO(mockProduct.getProductID());
		assertEquals(7, result[1].QNRORO, 'Should be 10 - (1 + 2) = 7');
		assertEquals(9, result[2].QNRORO, 'Should be 10 - (1) = 9');
	}
	
	public void function getQNDOSATest() {
		var mockProduct = createMockProduct();
		var mockLocation = createMockLocation();
		var mockSku = createMockSku(mockProduct.getProductID());
		
		var mockSku2 = createMockSku(mockProduct.getProductID());

		var stockAdjustmentData = {
			stockAdjustmentID = '',
			stockAdjustmentStatusType = {
				typeID = '444df2e2f66ddfaf9c60caf5c76349a6'//sastNew
			}
		};
		var mockStockAdjustment = createPersistedTestEntity('StockAdjustment', stockAdjustmentData);
		
		var stockAdjustmentData2 = {
			stockAdjustmentID = '',
			stockAdjustmentStatusType = {
				typeID = '444df2e2f66ddfaf9c60caf5c76349a6'//sastNew
			}
		};
		var mockStockAdjustment2 = createPersistedTestEntity('StockAdjustment', stockAdjustmentData2);
		
		var stockData = {
			stockID = '',
			sku = {
				skuID = mockSku.getSkuID()
			},
			location = {
				locationID = mockLocation.getLocationID()
			}
		};
		var mockStock = createPersistedTestEntity('Stock', stockData);
		
		var stockData2 = {
			stockID = '',
			sku = {
				skuID = mockSku2.getSkuID()
			},
			location = {
				locationID = mockLocation.getLocationID()
			}
		};
		var mockStock2 = createPersistedTestEntity('Stock', stockData2);
		
		var stockAdjustmentItemData = {
			stockAdjustmentItemID = '',
			quantity = 100,
			fromStock = {
				stockID = mockStock.getStockID()
			},
			stockAdjustment = {
				stockAdjustmentID = mockStockAdjustment.getStockAdjustmentID()
			}
		};
		var mockStockAdjustmentItem = createPersistedTestEntity('StockAdjustmentItem', stockAdjustmentItemData);
		
		var stockAdjustmentItemData2 = {
			stockAdjustmentItemID = '',
			quantity = 1300,
			fromStock = {
				stockID = mockStock2.getStockID()
			},
			stockAdjustment = {
				stockAdjustmentID = mockStockAdjustment2.getStockAdjustmentID()
			}
		};
		var mockStockAdjustmentItem2 = createPersistedTestEntity('StockAdjustmentItem', stockAdjustmentItemData2);
		
		var stockAdjustmentDeliveryItemData1 = {
			stockAdjustmentDeliveryItemID = '',
			quantity = 10,
			stockAdjustmentItem = {
				stockAdjustmentItemID = mockStockAdjustmentItem.getStockAdjustmentItemID()
			}
		};
		var mockstockAdjustmentDeliveryItem1 = createTestEntity('stockAdjustmentDeliveryItem', stockAdjustmentDeliveryItemData1);
		
		var stockAdjustmentDeliveryItemData2 = {
			stockAdjustmentDeliveryItemID = '',
			quantity = 20,
			stockAdjustmentItem = {
				stockAdjustmentItemID = mockStockAdjustmentItem.getStockAdjustmentItemID()
			}
		};
		var mockstockAdjustmentDeliveryItem2 = createTestEntity('stockAdjustmentDeliveryItem', stockAdjustmentDeliveryItemData2);
		
		injectMethod(mockstockAdjustmentDeliveryItem1, this, 'returnVoid', 'preInsert');
		injectMethod(mockstockAdjustmentDeliveryItem2, this, 'returnVoid', 'preInsert');
		persistTestEntity(mockstockAdjustmentDeliveryItem1, stockAdjustmentDeliveryItemData1);
		persistTestEntity(mockstockAdjustmentDeliveryItem2, stockAdjustmentDeliveryItemData2);
		
		mockStockAdjustmentItem.addStockAdjustmentDeliveryItem(mockstockAdjustmentDeliveryItem1);
		mockStockAdjustmentItem.addStockAdjustmentDeliveryItem(mockstockAdjustmentDeliveryItem2);
		
		var stockAdjustmentDeliveryItemData3 = {
			stockAdjustmentDeliveryItemID = '',
			quantity = 10,
			stockAdjustmentItem = {
				stockAdjustmentItemID = mockStockAdjustmentItem2.getStockAdjustmentItemID()
			}
		};
		var mockstockAdjustmentDeliveryItem3 = createTestEntity('stockAdjustmentDeliveryItem', stockAdjustmentDeliveryItemData3);
		
		injectMethod(mockstockAdjustmentDeliveryItem3, this, 'returnVoid', 'preInsert');
		persistTestEntity(mockstockAdjustmentDeliveryItem3, stockAdjustmentDeliveryItemData3);
		
		mockStockAdjustmentItem2.addStockAdjustmentDeliveryItem(mockstockAdjustmentDeliveryItem3);
		
		var result = variables.dao.getQNDOSA(mockProduct.getProductID());
		assertEquals(70, result[1].QNDOSA, 'Should be 100 - (10 + 20) = 70');
		assertEquals(1290, result[2].QNDOSA, 'Should be 1300 - (10) = 1290');

	}
	
	public void function getQNROVOTest_mulitipleSkus() {
		var productData = {
			productID="",
			productCode='test'&createUUID()
		};
		var product = createPersistedTestEntity('Product',productData);
		
		var skuData = {
			skuID="",
			skuCode="test"&createUUID(),
			product={
				productID=product.getProductID()
			}
		};
		var sku = createPersistedTestEntity('Sku',skuData);
		
		var skuData2 = {
			skuID="",
			skuCode="test"&createUUID(),
			product={
				productID=product.getProductID()
			}
		};
		var sku2 = createPersistedTestEntity('Sku',skuData2);
		
		var skuData3 = {
			skuID="",
			skuCode="test"&createUUID(),
			product={
				productID=product.getProductID()
			}
		};
		var sku3 = createPersistedTestEntity('Sku',skuData3);
		
		var locationEntity = createMockLocation();
		
		var stockData = {
			stockID = '',
			sku = {
				skuID = sku.getSkuID()
			},
			location = {
				locationID = locationEntity.getLocationID()
			}
		};
		var stock = createPersistedTestEntity('Stock', stockData);
		
		var stockData2 = {
			stockID = '',
			sku = {
				skuID = sku2.getSkuID()
			},
			location = {
				locationID = locationEntity.getLocationID()
			}
		};
		var stock2 = createPersistedTestEntity('Stock', stockData2);
		
		var stockData3 = {
			stockID = '',
			sku = {
				skuID = sku3.getSkuID()
			},
			location = {
				locationID = locationEntity.getLocationID()
			}
		};
		var stock3 = createPersistedTestEntity('Stock', stockData3);
		
		var vendorOrderData = {
			vendorOrderID = '',
			vendorOrderStatusType = {
				typeID = '444df2b5c8f9b37338229d4f7dd84ad1'//ostNew
			},
			vendorOrderType = {
				typeID = '444df2dbfde8c38ab64bb21c724d46e0'//votPurchaseOrder
			}
		};
		var vendorOrder = createPersistedTestEntity('VendorOrder', vendorOrderData);
		
		var vendorOrderItemData = {
			vendorOrderItemID = '',
			quantity = 100,
			vendorOrder = {
				vendorOrderID = vendorOrder.getVendorOrderID()
			},
			stock = {
				stockID = stock.getStockID()
			}
		};
		var vendorOrderItem = createPersistedTestEntity('VendorOrderItem', vendorOrderItemData);
		
		var vendorOrderItemData2 = {
			vendorOrderItemID = '',
			quantity = 200,
			vendorOrder = {
				vendorOrderID = vendorOrder.getVendorOrderID()
			},
			stock = {
				stockID = stock.getStockID()
			}
		};
		var vendorOrderItem2 = createPersistedTestEntity('VendorOrderItem', vendorOrderItemData2);
		
		//vo for second sku
		var vendorOrderItemData3 = {
			vendorOrderItemID = '',
			quantity = 155,
			vendorOrder = {
				vendorOrderID = vendorOrder.getVendorOrderID()
			},
			stock = {
				stockID = stock2.getStockID()
			}
		};
		var vendorOrderItem3 = createPersistedTestEntity('VendorOrderItem', vendorOrderItemData3);
		
		var vendorOrderItemData4 = {
			vendorOrderItemID = '',
			quantity = 100,
			vendorOrder = {
				vendorOrderID = vendorOrder.getVendorOrderID()
			},
			stock = {
				stockID = stock3.getStockID()
			}
		};
		var vendorOrderItem4 = createPersistedTestEntity('VendorOrderItem', vendorOrderItemData4);
		
		var stockReceiverItemData = {
			stockReceiverItemID = '',
			quantity = 10,
			vendorOrderItem = {
				vendorOrderItemID = vendorOrderItem.getVendorOrderItemID()
			}
		};
		var stockReceiverItem = createTestEntity('StockReceiverItem', stockReceiverItemData);
		
		injectMethod(stockReceiverItem, this, 'returnVoid', 'preInsert');
		persistTestEntity(stockReceiverItem, stockReceiverItemData);
		
		var stockReceiverItemData2 = {
			stockReceiverItemID = '',
			quantity = 20,
			vendorOrderItem = {
				vendorOrderItemID = vendorOrderItem.getVendorOrderItemID()
			}
		};
		var stockReceiverItem2 = createTestEntity('StockReceiverItem', stockReceiverItemData2);
		
		injectMethod(stockReceiverItem2, this, 'returnVoid', 'preInsert');
		persistTestEntity(stockReceiverItem2, stockReceiverItemData2);
		
		
		var stockReceiverItemData3 = {
			stockReceiverItemID = '',
			quantity = 47,
			vendorOrderItem = {
				vendorOrderItemID = vendorOrderItem3.getVendorOrderItemID()
			}
		};
		var stockReceiverItem3 = createTestEntity('StockReceiverItem', stockReceiverItemData3);
		injectMethod(stockReceiverItem3, this, 'returnVoid', 'preInsert');
		persistTestEntity(stockReceiverItem3, stockReceiverItemData3);
		
		vendorOrderItem.addStockReceiverItem(stockReceiverItem);
		vendorOrderItem.addStockReceiverItem(stockReceiverItem2);
		vendorOrderItem2.addStockReceiverItem(stockReceiverItem3);
		
		var stockReceiverItemData4 = {
			stockReceiverItemID = '',
			quantity = 35,
			vendorOrderItem = {
				vendorOrderItemID = vendorOrderItem3.getVendorOrderItemID()
			}
		};
		var stockReceiverItem4 = createTestEntity('StockReceiverItem', stockReceiverItemData4);
		vendorOrderItem3.addStockReceiverItem(stockReceiverItem4);
		
		var result = variables.dao.getQNROVO(product.getProductID());
		assertEquals(270, result[1].QNROVO, 'QNROVO should be (100+200) - (10+20+40) = 230');
		assertEquals(108, result[2].QNROVO, 'QNROVO should be (155) - (47) = 108');
		assertEquals(100, result[3].QNROVO);
	}
	
	public void function getQOVOTest_mulitipleSkus() {
		var productData = {
			productID="",
			productCode='test'&createUUID()
		};
		var product = createPersistedTestEntity('Product',productData);
		
		var skuData = {
			skuID="",
			skuCode="test"&createUUID(),
			product={
				productID=product.getProductID()
			}
		};
		var sku = createPersistedTestEntity('Sku',skuData);
		
		var skuData2 = {
			skuID="",
			skuCode="test"&createUUID(),
			product={
				productID=product.getProductID()
			}
		};
		var sku2 = createPersistedTestEntity('Sku',skuData2);
		
		var locationEntity = createMockLocation();
		
		var stockData = {
			stockID = '',
			sku = {
				skuID = sku.getSkuID()
			},
			location = {
				locationID = locationEntity.getLocationID()
			}
		};
		var stock = createPersistedTestEntity('Stock', stockData);
		
		var stockData2 = {
			stockID = '',
			sku = {
				skuID = sku2.getSkuID()
			},
			location = {
				locationID = locationEntity.getLocationID()
			}
		};
		var stock2 = createPersistedTestEntity('Stock', stockData2);
		
		var vendorOrderData = {
			vendorOrderID = '',
			vendorOrderStatusType = {
				typeID = '444df2b5c8f9b37338229d4f7dd84ad1'//ostNew
			},
			vendorOrderType = {
				typeID = '444df2dbfde8c38ab64bb21c724d46e0'//votPurchaseOrder
			}
		};
		var vendorOrder = createPersistedTestEntity('VendorOrder', vendorOrderData);
		
		var vendorOrderItemData = {
			vendorOrderItemID = '',
			quantity = 1070,
			vendorOrder = {
				vendorOrderID = vendorOrder.getVendorOrderID()
			},
			stock = {
				stockID = stock.getStockID()
			}
		};
		var vendorOrderItem = createPersistedTestEntity('VendorOrderItem', vendorOrderItemData);
		
		var vendorOrderItemData2 = {
			vendorOrderItemID = '',
			quantity = 2030,
			vendorOrder = {
				vendorOrderID = vendorOrder.getVendorOrderID()
			},
			stock = {
				stockID = stock2.getStockID()
			}
		};
		var vendorOrderItem2 = createPersistedTestEntity('VendorOrderItem', vendorOrderItemData2);
		
		var stockReceiverItemData = {
			stockReceiverItemID = '',
			quantity = 10,
			vendorOrderItem = {
				vendorOrderItemID = vendorOrderItem.getVendorOrderItemID()
			}
		};
		var stockReceiverItem = createTestEntity('StockReceiverItem', stockReceiverItemData);
		
		injectMethod(stockReceiverItem, this, 'returnVoid', 'preInsert');
		persistTestEntity(stockReceiverItem, stockReceiverItemData);
		
		var stockReceiverItemData2 = {
			stockReceiverItemID = '',
			quantity = 20,
			vendorOrderItem = {
				vendorOrderItemID = vendorOrderItem.getVendorOrderItemID()
			}
		};
		var stockReceiverItem2 = createTestEntity('StockReceiverItem', stockReceiverItemData2);
		
		injectMethod(stockReceiverItem2, this, 'returnVoid', 'preInsert');
		persistTestEntity(stockReceiverItem2, stockReceiverItemData2);
		
		
		var stockReceiverItemData3 = {
			stockReceiverItemID = '',
			quantity = 40,
			vendorOrderItem = {
				vendorOrderItemID = vendorOrderItem2.getVendorOrderItemID()
			}
		};
		var stockReceiverItem3 = createTestEntity('StockReceiverItem', stockReceiverItemData3);
		
		injectMethod(stockReceiverItem3, this, 'returnVoid', 'preInsert');
		persistTestEntity(stockReceiverItem3, stockReceiverItemData3);
		
		vendorOrderItem.addStockReceiverItem(stockReceiverItem);
		vendorOrderItem.addStockReceiverItem(stockReceiverItem2);
		vendorOrderItem2.addStockReceiverItem(stockReceiverItem3);
		
		var result = variables.dao.getQOVO(product.getProductID());
		assertEquals(1070, result[1].QOVO );
		assertEquals(2030, result[2].QOVO);
	}
	
	public void function getQROVOTest_mulitipleSkus() {
		var productData = {
			productID="",
			productCode='test'&createUUID()
		};
		var product = createPersistedTestEntity('Product',productData);
		
		var skuData = {
			skuID="",
			skuCode="test"&createUUID(),
			product={
				productID=product.getProductID()
			}
		};
		var sku = createPersistedTestEntity('Sku',skuData);
		
		var skuData2 = {
			skuID="",
			skuCode="test"&createUUID(),
			product={
				productID=product.getProductID()
			}
		};
		var sku2 = createPersistedTestEntity('Sku',skuData2);
		
		var locationEntity = createMockLocation();
		
		var stockData = {
			stockID = '',
			sku = {
				skuID = sku.getSkuID()
			},
			location = {
				locationID = locationEntity.getLocationID()
			}
		};
		var stock = createPersistedTestEntity('Stock', stockData);
		
		var stockData2 = {
			stockID = '',
			sku = {
				skuID = sku2.getSkuID()
			},
			location = {
				locationID = locationEntity.getLocationID()
			}
		};
		var stock2 = createPersistedTestEntity('Stock', stockData2);
		
		var vendorOrderData = {
			vendorOrderID = '',
			vendorOrderStatusType = {
				typeID = '444df2b5c8f9b37338229d4f7dd84ad1'//ostNew
			},
			vendorOrderType = {
				typeID = '444df2dbfde8c38ab64bb21c724d46e0'//votPurchaseOrder
			}
		};
		var vendorOrder = createPersistedTestEntity('VendorOrder', vendorOrderData);
		
		var vendorOrderItemData = {
			vendorOrderItemID = '',
			quantity = 100,
			vendorOrder = {
				vendorOrderID = vendorOrder.getVendorOrderID()
			},
			stock = {
				stockID = stock.getStockID()
			}
		};
		var vendorOrderItem = createPersistedTestEntity('VendorOrderItem', vendorOrderItemData);
		
		var vendorOrderItemData2 = {
			vendorOrderItemID = '',
			quantity = 200,
			vendorOrder = {
				vendorOrderID = vendorOrder.getVendorOrderID()
			},
			stock = {
				stockID = stock2.getStockID()
			}
		};
		var vendorOrderItem2 = createPersistedTestEntity('VendorOrderItem', vendorOrderItemData2);
		
		var stockReceiverItemData = {
			stockReceiverItemID = '',
			quantity = 10,
			vendorOrderItem = {
				vendorOrderItemID = vendorOrderItem.getVendorOrderItemID()
			}
		};
		var stockReceiverItem = createTestEntity('StockReceiverItem', stockReceiverItemData);
		
		injectMethod(stockReceiverItem, this, 'returnVoid', 'preInsert');
		persistTestEntity(stockReceiverItem, stockReceiverItemData);
		
		var stockReceiverItemData2 = {
			stockReceiverItemID = '',
			quantity = 20,
			vendorOrderItem = {
				vendorOrderItemID = vendorOrderItem.getVendorOrderItemID()
			}
		};
		var stockReceiverItem2 = createTestEntity('StockReceiverItem', stockReceiverItemData2);
		
		injectMethod(stockReceiverItem2, this, 'returnVoid', 'preInsert');
		persistTestEntity(stockReceiverItem2, stockReceiverItemData2);
		
		
		var stockReceiverItemData3 = {
			stockReceiverItemID = '',
			quantity = 40,
			vendorOrderItem = {
				vendorOrderItemID = vendorOrderItem2.getVendorOrderItemID()
			}
		};
		var stockReceiverItem3 = createTestEntity('StockReceiverItem', stockReceiverItemData3);
		
		injectMethod(stockReceiverItem3, this, 'returnVoid', 'preInsert');
		persistTestEntity(stockReceiverItem3, stockReceiverItemData3);
		
		vendorOrderItem.addStockReceiverItem(stockReceiverItem);
		vendorOrderItem.addStockReceiverItem(stockReceiverItem2);
		vendorOrderItem2.addStockReceiverItem(stockReceiverItem3);
		
		var result = variables.dao.getQROVO(product.getProductID());
		assertEquals(30, result[1].QROVO, 'QROVO should be (10+20) = 30');
		assertEquals(40, result[2].QROVO, 'QROVO should be (40) = 40');
	}
	
	public void function getQNROVOTest() {
		var mockProduct = createMockProduct();
		var mockLocation = createMockLocation();
		var mockSku = createMockSku(mockProduct.getProductID());
		
		var stockData = {
			stockID = '',
			sku = {
				skuID = mockSku.getSkuID()
			},
			location = {
				locationID = mockLocation.getLocationID()
			}
		};
		var mockStock = createPersistedTestEntity('Stock', stockData);
		
		var vendorOrderData = {
			vendorOrderID = '',
			vendorOrderStatusType = {
				typeID = '444df2b5c8f9b37338229d4f7dd84ad1'//ostNew
			},
			vendorOrderType = {
				typeID = '444df2dbfde8c38ab64bb21c724d46e0'//votPurchaseOrder
			}
		};
		var mockVendorOrder = createPersistedTestEntity('VendorOrder', vendorOrderData);
		//Mocking Data: 
		//mockVendorOrderItem1 (100) <- mockStockReceiverItem1 (10)
		//							 <- mockStockReceiverItem2 (20)
		//mockVendorOrderItem2 (200) <- mockStockReceiverItem3 (40)
		var vendorOrderItemData1 = {
			vendorOrderItemID = '',
			quantity = 100,
			vendorOrder = {
				vendorOrderID = mockVendorOrder.getVendorOrderID()
			},
			stock = {
				stockID = mockStock.getStockID()
			}
		};
		var mockVendorOrderItem1 = createPersistedTestEntity('VendorOrderItem', vendorOrderItemData1);
		
		var vendorOrderItemData2 = {
			vendorOrderItemID = '',
			quantity = 200,
			vendorOrder = {
				vendorOrderID = mockVendorOrder.getVendorOrderID()
			},
			stock = {
				stockID = mockStock.getStockID()
			}
		};
		var mockVendorOrderItem2 = createPersistedTestEntity('VendorOrderItem', vendorOrderItemData2);
		
		var stockReceiverItemData1 = {
			stockReceiverItemID = '',
			quantity = 10,
			vendorOrderItem = {
				vendorOrderItemID = mockVendorOrderItem1.getVendorOrderItemID()
			}
		};
		var mockStockReceiverItem1 = createTestEntity('StockReceiverItem', stockReceiverItemData1);
		
		injectMethod(mockStockReceiverItem1, this, 'returnVoid', 'preInsert');
		persistTestEntity(mockStockReceiverItem1, stockReceiverItemData1);
		
		var stockReceiverItemData2 = {
			stockReceiverItemID = '',
			quantity = 20,
			vendorOrderItem = {
				vendorOrderItemID = mockVendorOrderItem1.getVendorOrderItemID()
			}
		};
		var mockStockReceiverItem2 = createTestEntity('StockReceiverItem', stockReceiverItemData2);
		
		injectMethod(mockStockReceiverItem2, this, 'returnVoid', 'preInsert');
		persistTestEntity(mockStockReceiverItem2, stockReceiverItemData2);
		
		var stockReceiverItemData3 = {
			stockReceiverItemID = '',
			quantity = 40,
			vendorOrderItem = {
				vendorOrderItemID = mockVendorOrderItem2.getVendorOrderItemID()
			}
		};
		var mockStockReceiverItem3 = createTestEntity('StockReceiverItem', stockReceiverItemData3);
		
		injectMethod(mockStockReceiverItem3, this, 'returnVoid', 'preInsert');
		persistTestEntity(mockStockReceiverItem3, stockReceiverItemData3);
		
		mockVendorOrderItem1.addStockReceiverItem(mockStockReceiverItem1);
		mockVendorOrderItem1.addStockReceiverItem(mockStockReceiverItem2);
		mockVendorOrderItem2.addStockReceiverItem(mockStockReceiverItem3);
		
		var result = variables.dao.getQNROVO(mockProduct.getProductID());
		assertEquals(230, result[1].QNROVO, 'QNROVO should be (100+200) - (10+20+40) = 230');
	}
	
	public void function getQNROSATest() {
		var mockProduct = createMockProduct();
		var mockLocation = createMockLocation();
		var mockSku = createMockSku(mockProduct.getProductID());
		var mockSku2 = createMockSku(mockProduct.getProductID());

		var stockAdjustmentData = {
			stockAdjustmentID = '',
			stockAdjustmentStatusType = {
				typeID = '444df2e2f66ddfaf9c60caf5c76349a6'//sastNew
			}
		};
		var mockStockAdjustment = createPersistedTestEntity('StockAdjustment', stockAdjustmentData);
		
		var stockAdjustmentData2 = {
			stockAdjustmentID = '',
			stockAdjustmentStatusType = {
				typeID = '444df2e2f66ddfaf9c60caf5c76349a6'//sastNew
			}
		};
		var mockStockAdjustment2 = createPersistedTestEntity('StockAdjustment', stockAdjustmentData2);
		
		var stockData = {
			stockID = '',
			sku = {
				skuID = mockSku.getSkuID()
			},
			location = {
				locationID = mockLocation.getLocationID()
			}
		};
		var mockStock = createPersistedTestEntity('Stock', stockData);
		
		var stockData2 = {
			stockID = '',
			sku = {
				skuID = mockSku2.getSkuID()
			},
			location = {
				locationID = mockLocation.getLocationID()
			}
		};
		var mockStock2 = createPersistedTestEntity('Stock', stockData2);
		
		var stockAdjustmentItemData = {
			stockAdjustmentItemID = '',
			quantity = 100,
			toStock = {
				stockID = mockStock.getStockID()
			},
			stockAdjustment = {
				stockAdjustmentID = mockStockAdjustment.getStockAdjustmentID()
			}
		};
		var mockStockAdjustmentItem = createPersistedTestEntity('StockAdjustmentItem', stockAdjustmentItemData);
		
		var stockAdjustmentItemData2 = {
			stockAdjustmentItemID = '',
			quantity = 100,
			toStock = {
				stockID = mockStock2.getStockID()
			},
			stockAdjustment = {
				stockAdjustmentID = mockStockAdjustment2.getStockAdjustmentID()
			}
		};
		var mockStockAdjustmentItem2 = createPersistedTestEntity('StockAdjustmentItem', stockAdjustmentItemData2);
		
		var stockReceiverItemData1 = {
			stockReceiverItemID = '',
			quantity = 10,
			stockAdjustmentItem = {
				stockAdjustmentItemID = mockStockAdjustmentItem.getStockAdjustmentItemID()
			}
		};
		var mockstockReceiverItem1 = createTestEntity('stockReceiverItem', stockReceiverItemData1);
		
		var stockReceiverItemData2 = {
			stockReceiverItemID = '',
			quantity = 20,
			stockAdjustmentItem = {
				stockAdjustmentItemID = mockStockAdjustmentItem.getStockAdjustmentItemID()
			}
		};
		var mockstockReceiverItem2 = createTestEntity('stockReceiverItem', stockReceiverItemData2);
		
		injectMethod(mockstockReceiverItem1, this, 'returnVoid', 'preInsert');
		injectMethod(mockstockReceiverItem2, this, 'returnVoid', 'preInsert');
		persistTestEntity(mockstockReceiverItem1, stockReceiverItemData1);
		persistTestEntity(mockstockReceiverItem2, stockReceiverItemData2);
		
		mockStockAdjustmentItem.addStockReceiverItem(mockstockReceiverItem1);
		mockStockAdjustmentItem.addStockReceiverItem(mockstockReceiverItem1);
		
		var stockReceiverItemData3 = {
			stockReceiverItemID = '',
			quantity = 20,
			stockAdjustmentItem = {
				stockAdjustmentItemID = mockStockAdjustmentItem2.getStockAdjustmentItemID()
			}
		};
		var mockstockReceiverItem3 = createTestEntity('stockReceiverItem', stockReceiverItemData3);
		
		injectMethod(mockstockReceiverItem3, this, 'returnVoid', 'preInsert');
		persistTestEntity(mockstockReceiverItem3, stockReceiverItemData3);
		
		mockStockAdjustmentItem2.addStockReceiverItem(mockstockReceiverItem3);
		var result = variables.dao.getQNROSA(mockProduct.getProductID());
		assertEquals(70, result[1].QNROSA, 'Should be 100 - (10 + 20) = 70');
	}
	
	
	//============ START: Helpers to mock the data ============
	private any function createMockProduct() {
		var productData = {
			productID = ''
		};
		return createPersistedTestEntity('Product', productData);
	}
	private any function createMockLocation() {
		var locationData = {
			locationID = '',
			locationIDPath = 'a/bb'
		};
		return createPersistedTestEntity('Location', locationData);
	}
	
	private any function createMockSku(string productID='') {
		var skuData = {
			skuID = ''
		};
		if(len(arguments.productID)) {
			skuData.product = {
				productID = arguments.productID
			};
		}
		return createPErsistedTestEntity('Sku', skuData);
	}
	private  void function returnVoid() {
		
	}
	
	
	//============ END: Helpers to mock the data ==============
}


