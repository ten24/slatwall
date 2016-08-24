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
		
		var result = variables.dao.getQOH(mockProduct.getProductID());
		assertEquals(250, result[1].QOH, 'It should be (100 + 200) - (30 + 20) = 250');
	}
	
	public void function getQNDOOTest() {
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
		
		var orderData = {
			orderID = '',
			orderStatusType = {
				typeID = '444df2b6b8b5d1ccfc14a4ab38aa0a4c'//ostProcessing
			}
		};
		var mockOrder = createPersistedTestEntity('Order', orderData);
		
		var orderDeliveryItemData1 = {
			orderDeliveryItemID = '',
			quantity = 1
		};
		var mockOrderDeliveryItem1 = createTestEntity('OrderDeliveryItem', orderDeliveryItemData1);
		
		var orderDeliveryItemData2 = {
			orderDeliveryItemID = '',
			quantity = 2 
		};
		var mockOrderDeliveryItem2 = createTestEntity('OrderDeliveryItem', orderDeliveryItemData2);
		injectMethod(mockOrderDeliveryItem1, this, 'returnVoid', 'preInsert');
		persistTestEntity(mockOrderDeliveryItem1, orderDeliveryItemData1);
		injectMethod(mockOrderDeliveryItem2, this, 'returnVoid', 'preInsert');
		persistTestEntity(mockOrderDeliveryItem2, orderDeliveryItemData2);
		
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
			},
			orderDeliveryItems = [{
					orderDeliveryItemID = mockOrderDeliveryItem1.getOrderDeliveryItemID()
				}, {
					OrderDeliveryItemID = mockOrderDeliveryItem2.getOrderDeliveryItemID()
			}]
		};
		var mockOrderItem = createPersistedTestEntity('OrderItem', orderItemData);
		injectMethod(mockOrderItem, this, 'returnVoid', 'preUpdate');
		persistTestEntity(mockOrderItem, orderItemData);
		
		var result = variables.dao.getQNDOO(mockProduct.getProductID);
		request.debug(result);
		assertEquals(100, result[1].QNDOO, 'Should be 100 - (1 + 2) = 97');
	}
	
	public void function getQNDOSATest() {
		var mockProduct = createMockProduct();
		var mockLocation = createMockLocation();
		var mockSku = createMockSku(mockProduct.getProductID());

		var stockAdjustmentData = {
			stockAdjustmentID = '',
			stockAdjustmentStatusType = {
				typeID = '444df2e2f66ddfaf9c60caf5c76349a6'//sastNew
			}
		};
		var mockStockAdjustment = createPersistedTestEntity('StockAdjustment', stockAdjustmentData);
		
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
		
		request.debug(mockstockAdjustmentDeliveryItem1.getStockAdjustmentDeliveryItemID());
		request.debug(mockStockAdjustmentItem.getStockAdjustmentDeliveryItems()[1].getStockAdjustmentDeliveryItemID());
		request.debug(mockStockAdjustmentItem.getStockAdjustmentDeliveryItems()[1].getQuantity());
		request.debug(mockStockAdjustmentItem.getFromStock().getSku().getProduct().getProductID());
		request.debug('mockStock.getLocation().getLocationID()='&mockStock.getLocation().getLocationID());
		request.debug('IDPath='&mockStock.getLocation().getLocationIDPath());
		
		var result = variables.dao.getQNDOSA(mockProduct.getProductID);
//		request.debug(result);
		assertEquals(100, result[1].QNDOSA, 'Should be 100 - (10 + 20) = 70');

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
		
		var vendorOrderItemData = {
			vendorOrderItemID = '',
			quantity = 100,
			vendorOrder = {
				vendorOrderID = mockVendorOrder.getVendorOrderID()
			},
			stock = {
				stockID = mockStock.getStockID()
			}
		};
		var mockVendorOrderItem = createPersistedTestEntity('VendorOrderItem', vendorOrderItemData);
		
		var stockReceiverItemData = {
			stockReceiverItemID = '',
			quantity = 10,
			vendorOrderItem = {
				vendorOrderItemID = mockVendorOrderItem.getVendorOrderItemID()
			}
		};
		var mockStockReceiverItem = createTestEntity('StockReceiverItem', stockReceiverItemData);
		//Bypass preInsert() and create persisted entity
		injectMethod(mockStockReceiverItem, this, 'returnVoid', 'preInsert');
		persistTestEntity(mockStockReceiverItem, stockReceiverItemData);

		mockVendorOrderItem.addStockReceiverItem(mockStockReceiverItem);
		
		var result = variables.dao.getQNROVO(mockProduct.getProductID());
		assertEquals(90, result[1].QNROVO, 'QNROVO should be 100 - 10 = 90');
	}
	
	public void function getQNROSATest() {
		
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
	public void function returnVoid() {
		
	}
	
	
	//============ END: Helpers to mock the data ==============
}


