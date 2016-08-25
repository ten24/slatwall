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
		
		var result = variables.dao.getQNDOSA(mockProduct.getProductID());
		assertEquals(70, result[1].QNDOSA, 'Should be 100 - (10 + 20) = 70');

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


