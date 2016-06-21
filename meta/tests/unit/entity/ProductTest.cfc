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
/*
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
	
	//============Start From Here
	public void function getAvailableForPurchaseFlagTest() {
		//testing startDate < now() < endDate
		var productData1 = {
			productID = '',
			purchaseStartDateTime = dateAdd('d', -3, now()),
			purchaseEndDateTime = dateAdd('d', 3, now())
		};
		var product1 = createTestEntity('Product', productData1);
		
		var resultBetweenTwoDates = product1.getAvailableForPurchaseFlag();
		assertTrue(resultBetweenTwoDates);
		
		//testing startDate > now() < endDate
		var productData2 = {
			productID = '',
			purchaseStartDateTime = dateAdd('d', 2, now()),
			purchaseEndDateTime = dateAdd('d', 3, now())
		};
		var product2 = createTestEntity('Product', productData2);
		
		var resultBeforeTwoDates = product2.getAvailableForPurchaseFlag();
		assertFalse(resultBeforeTwoDates);
		
		//testing empty startDate and endDate
		var productData3 = {
			productID = ''
		};
		var product3 = createTestEntity('Product', productData3);
		
		var resultEmptyTwoDates = product3.getAvailableForPurchaseFlag();
		assertTrue(resultEmptyTwoDates);
		
		//testing valid startDate but empty endDate
		var productData4 = {
			productID = '',
			purchaseStartDateTime = dateAdd('d', -2, now())
		};
		var product4 = createTestEntity('Product', productData4);
		
		var resultExistedStartDateEmptyEndDate = product4.getAvailableForPurchaseFlag();
		assertTrue(resultExistedStartDateEmptyEndDate);
	}
	

	public void function getListingPagesOptionsSmartListTest() {
		//mockContent 1-4 to test order, and 1&5 to test the activeFlag filter
		var contentData1 = {
			contentID = "",
			activeFlag = 1,
			title = "Whisper In the Willow"
		};
		var mockContent1 = createPersistedTestEntity('Content', contentData1);
		
		var contentData2 = {
			contentID = "",
			activeFlag = 1,
			title = "Black Beauty"
		};
		var mockContent2 = createPersistedTestEntity('Content', contentData2);
		
		var contentData3 = {
			contentID = "",
			activeFlag = 1,
			title = "Macbeth"
		};
		var mockContent3 = createPersistedTestEntity('Content', contentData3);
		
		var contentData4 = {
			contentID = "",
			activeFlag = 1
		};
		var mockContent4 = createPersistedTestEntity('Content', contentData4);
		
		var contentData5 = {
			contentID = "",
			activeFlag = 0,
			title = "The Happy Prince"
		};
		var mockContent5 = createPersistedTestEntity('Content', contentData5);		
		
		var productData = {
			productID = "",
			listingPages = [
				{
					contentID = mockContent1.getContentID()
				},
				{
					contentID = mockContent2.getContentID()
				},
				{
					contentID = mockContent3.getContentID()
				},
				{
					contentID = mockContent4.getContentID()
				},
				{
					contentID = mockContent5.getContentID()
				}
			]
		};
		var mockProduct = createPersistedTestEntity('Product', productData);
		
		var result = mockProduct.getListingPagesOptionsSmartList().getRecords(refresh = true);
		//testing the activeFlag filter
		assertEquals(4, arrayLen(result));
		//testing the order on TITLE
		assertEquals(mockContent4.getContentID(), result[1].getContentID());
		assertEquals("Black Beauty", result[2].getTitle());
		assertEquals("Macbeth", result[3].getTitle());
		assertEquals("Whisper In the Willow", result[4].getTitle());
	}


	public void function getProductBundleGroupsCount_CorrectCount_Test() {
		//Mocking data: mockProduct -> mockSku1 -> mockProductBundleGroup1 & mockProductBundleGroup2
		//Mocking data: mockProduct -> mockSku2 -> mockProductBundleGroup3
		var productBundleGroupData1 = {
			productBundleGroupID = ""
		};
		var mockProductBundleGroup1 = createPersistedTestEntity('ProductBundleGroup', productBundleGroupData1);
		
		var productBundleGroupData2 = {
			productBundleGroupID = ""
		};
		var mockProductBundleGroup2 = createPersistedTestEntity('ProductBundleGroup', productBundleGroupData2);
		
		var productBundleGroupData3 = {
			productBundleGroupID = ""
		};
		var mockProductBundleGroup3 = createPersistedTestEntity('ProductBundleGroup', productBundleGroupData3);
		
		var skuData = {
			skuID = "",
			productBundleGroups = [
				{
					productBundleGroupID = mockProductBundleGroup1.getProductBundleGroupID()
				},
				{
					productBundleGroupID = mockProductBundleGroup2.getProductBundleGroupID()
				}	
			]
		};
		var mockSku1 = createPersistedTestEntity('Sku', skuData);
		
		var skuData2 = {
			skuID = "",
			productBundleGroups = [
				{
					productBundleGroupID = mockProductBundleGroup3.getProductBundleGroupID()
				}
			]
		};
		var mockSku2 = createPersistedTestEntity('Sku', skuData2);
		
		var productData = {
			productID = "",
			skus = [
				{
					skuID = mockSku1.getSkuID()
				},
				{
					skuID = mockSku2.getSkuID()
				}
			]
		};
		var mockProduct = createPersistedTestEntity('Product', productData);
		
		//testing if the result is correct
		var result = mockProduct.getProductBundleGroupsCount();
		assertEquals(3, result);	 
	}
	
	public void function getProductBundleGroupsCount_NoSku_Test() {
		//testing if no SKU entity created
		var skuData = {
			skuID = ""
		};
		var mockSku = createPersistedTestEntity('Sku', skuData);
		
		var productData = {
			productID = "",
			skus = [
				{
					skuID = mockSku.getSkuID()
				}
			]
		};
		var mockProduct = createPersistedTestEntity('Product', productData);
		
		var result = mockProduct.getProductBundleGroupsCount();
		assertEquals(0, result);	 
	}
	
	public void function getProductBundleGroupsCount_NoProductBundleGroup_Test() {
		//testing if no ProductBundleGroups entity created in SKU 
		var productData = {
			productID = ""
		};
		var mockProduct = createPersistedTestEntity('Product', productData);
		
		var result = mockProduct.getProductBundleGroupsCount();
		assertEquals(0, result);	 
	}


	public void function getSubscriptionSkuSmartListTest() {
		//testing the inner join works and where condition works
		var subscriptionTermData = {
			subscriptionTermID = ""
		};
		var mockSubscriptionTerm = createPersistedTestEntity('SubscriptionTerm', subscriptionTermData);
		
		var skuData1 = {//no renewalSku, has subscriptionTerm, should be added
			skuID = "",
			subscriptionTerm = {
				subscriptionTermID = mockSubscriptionTerm.getSubscriptionTermID()
			}
		};
		var mockSku1 = createPersistedTestEntity('Sku', skuData1);
		
		var skuDataForRenewal = {
			skuID = ""
		};
		var mockSkuForRenewal = createPersistedTestEntity('Sku', skuDataForRenewal);
		
		var skuData2 = {//has renewalSku, has subscriptionTerm, should not be added
			skuID = "",
			renewalSku = {
				skuID = mockSkuForRenewal.getSkuID()
			},
			subscriptionTerm = {
				subscriptionTermID = mockSubscriptionTerm.getSubscriptionTermID()
			}
		};
		var mockSku2 = createPersistedTestEntity('Sku', skuData2);
		
		var skuData3 = {//no renewalSku, no subscriptionTerm, should not be added
			skuID = ""
		};
		var mockSku3 = createPersistedTestEntity('Sku', skuData3);
		
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
		
		var result = mockProduct.getSubscriptionSkuSmartList().getRecords(refresh = true);
		assertTrue(arrayFind(result, mockSku1));
		assertEquals(0, arrayFind(result, mockSku2));
		assertEquals(0, arrayFind(result, mockSku3));
	}
*/	
	public void function getSkus_NoArgument_Test() {
		var skuData1 = {
			skuID = ""
		};
		var mockSku1 = createPersistedTestEntity('Sku', skuData1);
		
		var skuData2 = {
			skuID = ""
		};
		var mockSku2 = createPersistedTestEntity('Sku', skuData2);
		
		var skuData3 = {
			skuID = ""
		};
		var mockSku3 = createPersistedTestEntity('Sku', skuData3);
		
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
		
		var result = mockProduct.getSkus(sorted = true);
		request.debug(arrayLen(result));
		assertEquals(1, arrayFind(result, mockSku1));
		assertEquals(2, arrayFind(result, mockSku2));
		assertEquals(3, arrayFind(result, mockSku3));
	}
	
	public void function getSkus_SortedIsTrue_Test() {
		var expectResult = [];//build the sorted skus
		
		var skuData1 = {
			skuID = createUUID()
		};
		var mockSku1 = createPersistedTestEntity('Sku', skuData1);
		arrayAppend(expectResult, mockSku1);
		
		var skuData2 = {
			skuID = createUUID()
		};
		var mockSku2 = createPersistedTestEntity('Sku', skuData2);
		arrayAppend(expectResult, mockSku2);
		
		var skuData3 = {
			skuID = ""
		};
		var mockSku3 = createPersistedTestEntity('Sku', skuData3);
		arrayAppend(expectResult, mockSku3);
		
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
		
		var result = mockProduct.getSkus(sorted = true);
		request.debug(arrayLen(result));
		request.debug(Len(createUUID()));
		request.debug(mockSku1.getSkuID());
		request.debug(mockSku2.getSkuID());
		request.debug(mockSku3.getSkuID());
		assertEquals(expectResult, result);
	}
	
	
	
	public void function getProductTypeOptions_baseProductTypeExists_Test() {
		var productTypeParentData = {
			productTypeID = 
				"444df2f9c7deaa1582e021e894c0e299" //subscription
				//"444df313ec53a08c32d8ae434af5819a" //content access
		};
		var mockParentProductType = createPersistedTestEntity('ProductType', productTypeParentData);
		
		var productTypeData = {
			productTypeID = 
				"444df2f9c7deaa1582e021e894c0e299", //subscription
				//"50cdfabbc57f7d103538d9e0e37f61e4", //gift card
			parentProductType = {
				productTypeID = mockParentProductType.getProductTypeID()
			}
		};
		var mockProductType = createPersistedTestEntity('ProductType', productTypeData);
		
		var productData = {
			productID = "",
			productType = mockProductType.getProductTypeID()
		};
		var mockProduct = createPersistedTestEntity('Product', productData);
		
		var result = mockProduct.getProductTypeOptions("subscription");
		request.debug(arrayLen(result));
		request.debug(result[1].name);
		request.debug(result[1].value);
	}
	
	public void function getProductTypeOptions_noBaseProductType_Test() {
		var productTypeParentData = {
			productTypeID = "444df313ec53a08c32d8ae434af5819a" //content access
		};
		var mockParentProductType = createPersistedTestEntity('ProductType', productTypeParentData);
		
		var productTypeData = {
			productTypeID = "50cdfabbc57f7d103538d9e0e37f61e4", //gift card
			parentProductType = {
				productTypeID = mockParentProductType.getProductTypeID()
			}
		};
		var mockProductType = createPersistedTestEntity('ProductType', productTypeData);
		
		var productData = {
			productID = "",
			productType = mockProductType.getProductTypeID()
		};
		var mockProduct = createPersistedTestEntity('Product', productData);
		
		var result = mockProduct.getProductTypeOptions();
		request.debug(arrayLen(result));
		request.debug(result[1].name);
		request.debug(result[1].value);
	}
	
	
	
	// ============ START: Non-Persistent Property Methods =================
	/*
	public void function getBaseProductType_ExistedSystemCode_Test() {
		//testing if the productType already has a systemCode
		var productTypeData = {
			productTypeID = "",
			systemCode = "merchandise"
		};
		var mockParentProductType = createPersistedTestEntity('ProductType', productTypeData);
		
		var productTypeData = {
			productTypeID = "",
			systemCode = "Hellokitty",
			parentProductType = {
				productTypeID = mockParentProductType.getProductTypeID()
			}
		};
		var mockProductType = createPersistedTestEntity('ProductType', productTypeData);
		
		var productData = {
			productID = "",
			productType = {
				productTypeID = mockProductType.getProductTypeID()
			}
		};
		var mockProduct = createPersistedTestEntity('Product', productData);
		
		var result = mockProduct.getBaseProductType();
		assertEquals('Hellokitty', result);	
		
			
	}
	public void function getBaseProductType_NoSystemCodeButHasParentProductType_Test() {
		//testing if the productType has no systemCode, but parentProductType has one
		var productTypeData = {
			productTypeID = "",
			systemCode = "merchandise"
		};
		var mockParentProductType = createPersistedTestEntity('ProductType', productTypeData);
		
		var productTypeData = {
			productTypeID = "",
			parentProductType = {
				productTypeID = mockParentProductType.getProductTypeID()
			}
		};
		var mockProductType = createPersistedTestEntity('ProductType', productTypeData);
		
		var productData = {
			productID = "",
			productType = {
				productTypeID = mockProductType.getProductTypeID()
			}
		};
		var mockProduct = createPersistedTestEntity('Product', productData);
		
		var result = mockProduct.getBaseProductType();
		assertEquals('merchandise', result);			
	}
	
	public void function getBaseProductType_NullProductType_Test() {
		//testing if ProductType is undefined
		var productData = {
			productID = ""
		};
		var mockProduct = createPersistedTestEntity('Product', productData);
		
		var result = mockProduct.getBaseProductType();
		assertTrue(isNull(mockProduct.getBaseProductType()));
	}
	
*/	
	
	
	 public void function getDefaultProductImageFilesTest() {
	 	//TODO: Test image
	 }
	 
	 public void function getDefaultProductImageFilesCountTest() {
	 	
	 }
	 
	 public void function getSalePriceDetailsForSkusTest() {
	 	
	 }
	 
	 public void function getSalePriceDetailsForSkusByCurrencyCodeTest() {
	 	
	 }
	 
	  public void function getQATSTest() {
	 	//Testing default QATS
	 	var productData = {
	 		productID = ""
	 	};
	 	var mockProduct = createPersistedTestEntity('Product', productData);
	 	
	 	var resultDefault = mockProduct.getQATS();
	 	assertTrue(resultDefault);
	 	//TODO: try to modifiy the QATS
	 }
	 
	 public void function getQuantity() {
	 	
	 }
	 
/*	 public void function getBundleSkusSmartListTest() {
		var productData = {
			productID = ""
		};
		var mockProduct = createPersistedTestEntity('Product', productData);
		
		var skuData1 = {
			skuID = "",
			bundleFlag = 1,
			product = {
				productID = mockProduct.getProductID()
			}
		};
		var mockSku1 = createPersistedTestEntity('Sku', skuData1);
		
		var skuData1 = {
			skuID = "",
			bundleFlag = 0,
			product = {
				productID = mockProduct.getProductID()
			}
		};
		var mockSku1 = createPersistedTestEntity('Sku', skuData1);
		
		var result = mockProduct.getBundleSkusSmartList().getRecords(refresh = true);
		//testing the bundleFlag filter
		assertEquals(1, arrayLen(result));
		//testing the productID filter
		assertEquals(mockProduct.getProductID(), result[1].getProduct().getProductID());		
	}
	
	 public void function getBrandNameTest() {
	 	//testing if both brand and brandName existed
	 	var brandData = {
	 		brandID = "",
	 		brandName = "ten24 Undigital Solution"
	 	};
	 	var mockBrand = createPersistedTestEntity('Brand', brandData);
	 	
	 	var productData = {
	 		productID = "",
	 		brand = {
	 			brandID = mockBrand.getBrandID()
	 		}
	 	};
	 	var mockProduct = createPersistedTestEntity('Product', productData);
	 	
	 	var resultBoth = mockProduct.getBrandName();
	 	assertEquals(mockBrand.getBrandName(), resultBoth);
	 	
	 	//testing if brandName is NULL	 	
	 	var brandData2 = {
	 		brandID = ""
	 	};
	 	var mockBrandNoName = createPersistedTestEntity('Brand', brandData2);
	 	
	 	var productData2 = {
	 		productID = "",
	 		brand = {
	 			brandID = mockBrandNoName.getBrandID()
	 		}
	 	};
	 	var mockProductNoName = createPersistedTestEntity('Product', productData2);
	 	
	 	var resultNoBrandName = mockProductNoName.getBrandName();
	 	assertIsEmpty(resultNoBrandName);

		//testing if brand does not exist
		var productData3 = {
			productID = ""
		};
		var mockProductNoBrand = createPersistedTestEntity('Product', productData3);
		
		var resultNoBrand = mockProductNoBrand.getBrandName();
		assertIsEmpty(resultNoBrand);	 	
	 }
	 
	 public void function getAllowBackorderFlagTest() {
	 	//testing default setting
	 	var productData = {
	 		productID = ""
	 	};
	 	var mockProduct = createPersistedTestEntity('Product', productData);
	 	
	 	var resultDefault = mockProduct.getAllowBackorderFlag();
	 	assertFalse(resultDefault);
	 	
	 	//testing setting is override
	 	var productData2 = {
	 		productID = ""
	 	};
	 	var mockProduct2 = createPersistedTestEntity('Product', productData2);
	 	
	 	var settingData = {
	 		settingID = "",
	 		settingName = "skuAllowBackorderFlag",
	 		settingValue = 1
	 	};
	 	var settingEntity = createPersistedTestEntity('Setting', settingData);
	 	
	 	var resultOverrideSetting = mockProduct2.getAllowBackorderFlag();
	 	assertTrue(resultOverrideSetting);
	 }
	 
	 public void function getTitleTest() {
	 	//testing if both brandName and productName existed
	 	var brandData1 = {
	 		brandID = "",
	 		brandName = "24ten"
	 	};
	 	var mockBrandHasName= createPersistedTestEntity('Brand', brandData1);
	 	
	 	var productData1 = {
	 		productID = "",
	 		productName = "ten24 beer",
	 		brand = {
	 			brandID = mockBrandHasName.getBrandID()
	 		}
	 	};
	 	var mockProductHasName = createPersistedTestEntity('Product', productData1);
	 	
	 	var resultBothName = mockProductHasName.getTitle();
	 	assertFalse(isNull(resultBothName));
	 	
	 	//testing if productName is missing
	 	var productData2 = {
	 		productID = "",
	 		brand = {
	 			brandID = mockBrandHasName.getBrandID()
	 		}
	 	};
	 	var mockProductNoName = createPersistedTestEntity('Product', productData2);
	 	
	 	var resultBrandNameOnly = mockProductNoName.getTitle();
	 	assertEquals(mockBrandHasName.getBrandName(), resultBrandNameOnly);
	 	
	 	//testing if brandName is missing
	 	var brandData2 = {
	 		brandID = ""
	 	};
	 	var mockBrandNoName = createPersistedTestEntity('Brand', brandData2);
	 	
	 	var productData2 = {
	 		productID = "",
	 		productName = "Sakura JJ15",
	 		brand = {
	 			brandID = mockBrandNoName.getBrandID()
	 		}
	 	};
	 	var mockProductHasName2 = createPersistedTestEntity('Product', productData2);
	 	
	 	var resultProductNameOnly = mockProductHasName2.getTitle();
	 	assertEquals(mockProductHasName2.getProductName(), resultProductNameOnly);
	 }
	 
	
	 public void function getCurrencyCode() {
	 	//testing default currency code
		var skuData = {
			skuID = ""
		};
		var mockSku = createPersistedTestEntity('Sku', skuData);
		
	 	var productData = {
	 		productID = "",
	 		defaultSku = {
	 			skuID = mockSku.getSkuID()
	 		}
	 	};
	 	var mockProduct = createPersistedTestEntity('Product', productData);
	 	
	 	assertEquals("USD", mockProduct.getCurrencyCode());

		//testing other currency code
		var skuData2 = {
			skuID = "",
			currencyCode = "CNY"
		};
		var mockSku2 = createPersistedTestEntity('Sku', skuData2);
		
	 	var productData2 = {
	 		productID = "",
	 		defaultSku = {
	 			skuID = mockSku2.getSkuID()
	 		}
	 	};
	 	var mockProduct2 = createPersistedTestEntity('Product', productData2);
	 	
	 	assertEquals("CNY", mockProduct2.getCurrencyCode());
		
		//Potential bug: invalid currencyCode could also be returned; 
		//should add validation if not select button frontend
	 }
*/	
}
