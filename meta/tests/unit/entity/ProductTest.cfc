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
component extends="Slatwall.meta.tests.unit.entity.SlatwallEntityTestBase" {

	// @hint put things in here that you want to run befor EACH test
	public void function SetUp() {
		super.setup();

		variables.entity = request.slatwallScope.getService("productService").newProduct();
	}

	public void function productUrlIsCorrectlyFormatted() {
		variables.entity.setURLTitle("nike-air-jorden");

		assertEquals("/#request.slatwallScope.setting('globalURLKeyProduct')#/nike-air-jorden/", variables.entity.getProductURL());
	}

	public void function getProductRatingTest(){
		var productData = {
			productid = '',
			productName='test',
			productReviews = [
				{
					productReviewid='',
					rating=5
				},
				{
					productReviewid='',
					rating=1
				},
				{
					productReviewid='',
					rating=4
				}
			]
		};
		var product = createPersistedTestEntity('product',productData);
		var productRating = product.getProductRating();
		assertEquals(productRating,3.3333);
	}

	public void function getUnusedProductOptionsTestCaseHasUnusedOptions(){

		var optionGroup1 = createUUID();
		var optionG11 = createUUID();
		var optionG12 = createUUID();

		var optionGroup1Data = {
			optionGroupID = optionGroup1,
			options = [
				{
					optionID = optionG11
				},
				{
					optionID = optionG12
				}
			]
		};

		var og1 = createPersistedTestEntity('optionGroup', optionGroup1Data);

		var optionGroup2 = createUUID();
		var optionG21 = createUUID();
		var optionG22 = createUUID();
		var optionG23 = createUUID();

		var optionGroup2Data = {
			optionGroupID = optionGroup2,
			options = [
				{
					optionID = optionG21
				},
				{
					optionID = optionG22
				},
				{
					optionID = optionG23
				}
			]
		};

		var og2 = createPersistedTestEntity('optionGroup', optionGroup2Data);

		var optionGroup3 = createUUID();
		var optionG31 = createUUID();
		var optionG32 = createUUID();

		var optionGroup3Data = {
			optionGroupID = optionGroup3,
			options = [
				{
					optionID = optionG31
				},
				{
					optionID = optionG32
				}
			]
		};

		var og3 = createPersistedTestEntity('optionGroup', optionGroup3Data);

		var productData = {
			productID = '',
			productName = 'TestName',
			productCode=createUUID(),
			skus = [
				{
					skuID = "",
					skuCode = CreateUUID(),
					options=[
						{
							optionID=og1.getOptions()[1].getOptionID()
						},
						{
							optionID=og2.getOptions()[1].getOptionID()
						},
						{
							optionID=og3.getOptions()[1].getOptionID()
						}
					]
				}
			]
		};

		var product = createPersistedTestEntity('product', productData);

		addToDebug(product.getNumberOfUnusedProductOptionCombinations());

		assertEquals(11, product.getNumberOfUnusedProductOptionCombinations());
		assertTrue(product.hasUnusedProductOptionCombinations());
	}

	public void function getUnusedProductOptionsTestCaseNoOptions(){

		var optionGroup1 = createUUID();
		var optionG11 = createUUID();
		var optionG12 = createUUID();

		var optionGroup1Data = {
			optionGroupID = optionGroup1,
			options = [
				{
					optionID = optionG11
				}
			]
		};

		var og1 = createPersistedTestEntity('optionGroup', optionGroup1Data);

		var optionGroup2 = createUUID();
		var optionG21 = createUUID();
		var optionG22 = createUUID();

		var optionGroup2Data = {
			optionGroupID = optionGroup2,
			options = [
				{
					optionID = optionG21
				}
			]
		};

		var og2 = createPersistedTestEntity('optionGroup', optionGroup2Data);

		var optionGroup3 = createUUID();
		var optionG31 = createUUID();
		var optionG32 = createUUID();

		var optionGroup3Data = {
			optionGroupID = optionGroup3,
			options = [
				{
					optionID = optionG31
				}
			]
		};

		var og3 = createPersistedTestEntity('optionGroup', optionGroup3Data);

		var productData = {
			productID = '',
			productName = 'TestName',
			skus = [
				{
					skuID = ''
				}
			]
		};

		var product = createPersistedTestEntity('product', productData);
		product.getSkus()[1].addOption(og1.getOptions()[1]);
		product.getSkus()[1].addOption(og2.getOptions()[1]);
		product.getSkus()[1].addOption(og3.getOptions()[1]);

		addToDebug(og1.getOptions()[1].getOptionID());
		addToDebug("|       |");
		addToDebug(og2.getOptions()[1].getOptionID());
		addToDebug("|       |");
		addToDebug(og3.getOptions()[1].getOptionID());

		addToDebug(product.getNumberOfUnusedProductOptionCombinations());

		assertEquals(0, product.getNumberOfUnusedProductOptionCombinations());
		assertFalse(product.hasUnusedProductOptionCombinations());
	}
	
	/**
	* @hint "This function will return mockSku with properites you passed in <br> Make the null arguments "" by the order "
	*
	*/
	private any function createMockSku(string idOfProduct = "", string currencyCode = "", string skuImageFile = "") {
		var skuData = {
			skuID = ""
		};
		if (len(arguments.idOfProduct)) {
			skuData.product.productID = arguments.idOfProduct;
		}
		if (len(arguments.currencyCode)) {
			skuData.currencyCode = arguments.currencyCode;
		}		
		if (len(arguments.skuImageFile)) {
			skuData.imageFile = arguments.skuImageFile;
		}
		return createPersistedTestEntity('Sku', skuData);
	}
	
	public void function getDefaultProductImageFilesCountTest() {
		
//		fileCopy("/Users/ten24user/Downloads/testfilearrow.jpeg", expandPath('/Slatwall') & "/custom/assets/images/product/default/testfilearrow.jpeg");
		createTestFile ("/Users/ten24user/Sites/sandbox/testfilearrow.jpeg","/custom/assets/images/product/default/testfilearrow.jpeg");
		
		var mockSku1 = createMockSku("", "", "testfilearrow.jpeg");
	 	var mockSku2 = createMockSku();
	 	var mockSku3 = createMockSku("", "", "fakepath");
	 	
	 	var productData = {
			productID = "",
			skus = [
				{
					skuID = mockSku1.getSkuID()
				},
				{
					skuID = mockSku2.getSkuID()
				},
				{
					skuID = mockSku3.getSkuID()
				}
			]
		};
		var mockProduct = createPersistedTestEntity('Product', productData);
		
		var resultInForLoop = mockProduct.getDefaultProductImageFiles();
		var result = mockProduct.getDefaultProductImageFilesCount();
		request.debug(arrayLen(resultInForLoop));//yuqing
		request.debug(result);//yuqing
	}
	
	public void function getSalePriceDetailsForSkusTest() {
		var skuData1 = {
			skuID = "",
			price = 500,
			currencyCode = "CNY"
		};
		var skuData2 = {
			skuID = "",
			price = 300,
			currencyCode = "CNY"
		};
		var skuData3 = {
			skuID = "",
			price = 900
		};
		var mockSku1 = createPersistedTestEntity('Sku', skuData1);
	 	var mockSku2 = createPersistedTestEntity('Sku', skuData2);
	 	var mockSku3 = createPersistedTestEntity('Sku', skuData3);
	 	var mockSku4 = createPersistedTestEntity('Sku', skuData1);
		
		var productData = {
			productID = "",
			skus = [
				{
					skuID = mockSku1.getSkuID()
				},
				{
					skuID = mockSku2.getSkuID()
				},
				{
					skuID = mockSku3.getSkuID()
				}
			]
		};
		var mockProduct = createPersistedTestEntity('Product', productData);
		
		var result = mockProduct.getSalePriceDetailsForSkus();
		request.debug(result);
//		request.debug(mockProduct.getSalePriceDetailsForSkusByCurrencyCode());
	}
}
