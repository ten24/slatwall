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
		
		variables.service = request.slatwallScope.getBean("inventoryService");
	}
	
	public void function getQIATSTest() {
		//Testing when the function is called w/ stock argument
		var skuData = {
			skuID = ''
		};
		var mockSku = createPersistedTestEntity('Sku', skuData);
		var stockData = {
			stockID = '',
			sku = {
				skuID = mockSku.getSkuID()
			}
		};
		var mockStock = createPersistedTestEntity('Stock', stockData);
		
		var resultQIATS = variables.service.getQIATS(mockStock);
		assertEquals(1000, resultQIATS, 'For simple Sku and Stock, should return the orderMaximumQuanitty which is 1000');
		
		//Testing when function is called w/ argus sku
		var resultQIATSNoEntity = variables.service.getQIATS(mockSku);
		assertEquals(1000, resultQIATSNoEntity, 'trackInventoryFlag is undefined, should return orderMaximumQuantity');
	}
	
	
	
	public void function getQATSTest_Arguments() {
		//Testing when argument is stock entity
		var skuData = {
			skuID = ''
		};
		var mockSku = createPersistedTestEntity('Sku', skuData);
		
		var stockData = {
			stockID = '',
			sku = {
				skuID = mockSku.getSkuID()
			}
		};
		var mockStock = createPersistedTestEntity('Stock', stockData);
		
		var resultStockQATS = variables.service.getQATS(mockStock);
		assertEquals(1000, resultStockQATS, 'The result should be orderMaximumQuantity as other varaibles are all 0');
		
		//Testing when argument is not Stock entity
		var productData = {
			skuID = ''
		};
		var mockProduct = createPersistedTestEntity('Product', productData);
		
		var resultProductQATS = variables.service.getQATS(mockProduct);
		assertEquals(1000, resultProductQATS, 'The result should be orderMaximumQuantity because of trackInventory and backorder values');
	}
	
	public void function getQATSTest_ifLogics() {
		var productData = {
			productID = ''
		};
		var mockProduct = createPersistedTestEntity('Product', productData);
		
		var qatsIncludesQNROROFlagSetting = resetSettingValue('skuHoldBackQuantity', 50);
		var trackInventoryFlagSetting = resetSettingValue('skuTrackInventoryFlag', 'TRUE');
		var skuQATSIncludesQNROROFlagSetting = resetSettingValue('skuQATSIncludesQNROROFlag', 'TRUE');
		var skuQATSIncludesQNROVOFlagSetting = resetSettingValue('skuQATSIncludesQNROVOFlag', 'TRUE');
		var skuQATSIncludesQNROSAFlagSetting = resetSettingValue('skuQATSIncludesQNROSAFlag', 'TRUE');
		
		injectMethod(mockProduct, this, 'returnOneHundred', 'getQuantity');
		
		var resultQATS = variables.service.getQATS(mockProduct);
		assertEquals(350, resultQATS, 'The result should be 100+100+100+100-50 = 350');
	}
	
	//=========== START: Unit Test Private Helpers =============
	private numeric function returnOneHundred() {
		return 100;
	}
	
	private any function resetSettingValue(required string settingName, required any returnValue) {
		var settingData = {
			settingID = '',
			settingName = arguments.settingName,
			settingValue = arguments.returnValue
		};
		return createPersistedTestEntity('Setting', settingData);
	}
	//============ END: Unit Test Private Helpers ==============s
}