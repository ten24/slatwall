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
		assertTrue(arrayFind(result, mockSku1));
		assertTrue(arrayFind(result, mockSku2));
		assertTrue(arrayFind(result, mockSku3));
	}
	
	public void function getSkus_SortedFetchOptionBothTrue_Test() {
		//Potential Bug: based on the function in SkuService.cfc, if we pass arguments, fetchOptions must be true, 
		//and sorted is a required argument

		var mockProductType = createMockProductType("", "444df2f7ea9c87e60051f3cd87b435a1");		
		var mockProduct = createMockProduct(mockProductType.getProductTypeID());
		
		var optionGroupData = {
			optionGroupID = ""
		};
		var mockOptionGroup = createPersistedTestEntity('OptionGroup', optionGroupData);
		
		var mockOption1 = createMockOption(mockOptionGroup.getOptionGroupID());
		var mockOption2 = createMockOption(mockOptionGroup.getOptionGroupID());
		var mockOption3 = createMockOption(mockOptionGroup.getOptionGroupID());
		
		var skuData1 = {//should be added
			skuID = "4028288f54f3979c01557df0b0b52aaaa",
			options = [
				{
					optionID = mockOption1.getOptionID()
				},
				{
					optionID = mockOption2.getOptionID()
				}
			],
			product = {
				productID = mockProduct.getProductID()
			}
		};
		var mockSku1 = createPersistedTestEntity('Sku', skuData1);
		
		var skuData2 = {//should be added
			skuID = "",
			options = [
				{
					optionID = mockOption3.getOptionID()
				}
			],
			product = {
				productID = mockProduct.getProductID()
			}
		};
		var mockSku2 = createPersistedTestEntity('Sku', skuData2);
		
		var skuData3 = {//should not be added
			skuID = "",
			product = {
				productID = mockProduct.getProductID()
			}
		};
		var mockSku3 = createPersistedTestEntity('Sku', skuData3);

		var result = mockProduct.getSkus(sorted = true, fetchOptions = true);
		assertTrue(arrayFind(result, mockSku1));
		assertTrue(arrayFind(result, mockSku2));
		assertFalse(arrayFind(result, mockSku3));
		assertEquals(2, arrayLen(result));	
	}
	
	
	public void function getProductTypeOptions_noArgument_Test() {
		//testing the function without the argument, should return child-types below the mockProduct's baseProductType
		
		//mock a child product type
		var mockProductType1 = createMockProductType("", '50cdfabbc57f7d103538d9e0e37f61e4');//parentProductType: gift-card
		var mockProductType2 = createMockProductType("", '50cdfabbc57f7d103538d9e0e37f61e4');
		var mockProductType3 = createMockProductType("", '50cdfabbc57f7d103538d9e0e37f61e4');
		var mockProductType4 = createMockProductType("", '444df315a963bea00867567110d47728');//parentProductType: event
		var mockProductType5 = createMockProductType("", mockProductType2.getProductTypeID());//parentProductType: mockProductType2
		var mockProductType6 = createMockProductType("", mockProductType2.getProductTypeID());//parentProductType: mockProductType2
		
		var mockProduct = createMockProduct(mockProductType3.getProductTypeID());//mockProduct <-> mockProductType2
		
		var resultNoArgument = mockProduct.getProductTypeOptions();
		
		var resultValues = [];
		for (i = 1; i <= arrayLen(resultNoArgument); i++) {
			ArrayAppend(resultValues, resultNoArgument[i].value);
		}
		request.debug(resultNoArgument);
		assertTrue(arrayFind(resultValues, mockProductType1.getProductTypeID()));
		assertFalse(arrayFind(resultValues, mockProductType2.getProductTypeID()));//Won't return the one with child types
		assertTrue(arrayFind(resultValues, mockProductType3.getProductTypeID()));
		assertFalse(arrayFind(resultValues, mockProductType4.getProductTypeID()));//Won't return child of other baseType
		assertTrue(arrayFind(resultValues, mockProductType5.getProductTypeID()));
		assertTrue(arrayFind(resultValues, mockProductType6.getProductTypeID()));		
	}
	
	public void function getProductTypeOptions_argumentSameWithProductType_Test() {
		//testing the argument passed in, is same with mockProduct's baseProductType
		
		//mock a child product type
		var mockProductType1 = createMockProductType("", '50cdfabbc57f7d103538d9e0e37f61e4');//parentProductType: gift-card
		var mockProductType2 = createMockProductType("", '50cdfabbc57f7d103538d9e0e37f61e4');		
		var mockProductType3 = createMockProductType("", '50cdfabbc57f7d103538d9e0e37f61e4');
		var mockProductType4 = createMockProductType("", '444df315a963bea00867567110d47728');//parentProductType: event
		
		var mockProduct = createMockProduct(mockProductType2.getProductTypeID());
		
		var resultWithArgument = mockProduct.getProductTypeOptions("gift-card");
		
		var resultValues = [];
		for (i = 1; i <= arrayLen(resultWithArgument); i++) {
			ArrayAppend(resultValues, resultWithArgument[i].value);
		}
		assertTrue(arrayFind(resultValues, mockProductType1.getProductTypeID()));
		assertTrue(arrayFind(resultValues, mockProductType2.getProductTypeID()));
		assertTrue(arrayFind(resultValues, mockProductType3.getProductTypeID()));
		assertFalse(arrayFind(resultValues, mockProductType4.getProductTypeID()));
	}
	
	public void function getProductTypeOptions_argumentDifferentFromProductType_Test() {
		//testing the argument passed in, is different with mockProduct's baseProductType, 
		//so should only return the relative-type with the argument type
		
		//mock a child product type
		var mockProductType1 = createMockProductType("", '50cdfabbc57f7d103538d9e0e37f61e4');//parentProductType: gift-card
		var mockProductType2 = createMockProductType("", '50cdfabbc57f7d103538d9e0e37f61e4');		
		var mockProductType3 = createMockProductType("", '50cdfabbc57f7d103538d9e0e37f61e4');
		var mockProductType4 = createMockProductType("", '444df315a963bea00867567110d47728');//parentProductType: event
		
		var mockProduct = createMockProduct(mockProductType2.getProductTypeID());//associate mockProduct w/ mockProdouctType2
		
		var result = mockProduct.getProductTypeOptions("Event");

		var resultValues = [];
		for (i = 1; i <= arrayLen(result); i++) {
			ArrayAppend(resultValues, result[i].value);
		}
		assertFalse(arrayFind(resultValues, mockProductType1.getProductTypeID()));
		assertFalse(arrayFind(resultValues, mockProductType2.getProductTypeID()));
		assertFalse(arrayFind(resultValues, mockProductType3.getProductTypeID()));
		assertTrue(arrayFind(resultValues, mockProductType4.getProductTypeID()));
	}
*/
	public void function getSkuByIDTest() {
		var mockSku1 = createMockSku();
		var mockSku2 = createMockSku();
		var mockSku3 = createMockSku();
		var mockSku4 = createMockSku();
		
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
		
		//testing the skuID belong to this product
		var result = mockProduct.getSkuByID(mockSku2.getSkuID());
		assertEquals(mockSku2.getSkuID(), result.getSkuID());
		
		//testing the skuID not belong to the product
		var resultNoExist = mockProduct.getSkuByID(mockSku4.getSkuID());
		assertTrue(isNull(resultNoExist));
		
		//testing error ID
		var resultRandomString = mockProduct.getSkuByID("randomStringNoID");
		assertTrue(isNull(resultRandomString));
	}
	
	public void function getTemplateOptionsTest() {
		//Todo: never been used elsewhere
	}
	
	public void function getImagesTest() {
		var mockImage1 = createMockImage();
		var mockImage2 = createMockImage();
		
		//testing the product with mockImage1
		var productData = {
			productID = "",
			productImages = [
				{
					imageID = mockImage1.getImageID()
				}
			]
		};
		var mockProduct = createPersistedTestEntity('Product', productData);
		
		var result = mockProduct.getImages();
		assertEquals(1, arrayLen(result));
		assertEquals(mockImage1.getImageID(), result[1].getImageID());
		
		//testing the product without Images
		var mockProductNoImage = createMockProduct();
		var resultNotExist = mockProductNoImage.getImages();
		assertTrue(isDefined("resultNotExist"));
		assertEquals(0, arrayLen(resultNotExist));
	
	}
	
	public void function getTotalImageCountTest() {
		var mockImage1 = createMockImage();
		var mockImage2 = createMockImage();
		
		//testing the product with mockImage1
		var productData = {
			productID = "",
			productImages = [
				{
					imageID = mockImage1.getImageID()
				},
				{
					imageID = mockImage2.getImageID()
				}
			]
		};
		var mockProduct = createPersistedTestEntity('Product', productData);
		
		assertEquals(2, mockProduct.getProductImagesCount());
		assertEquals(2 + 0, mockProduct.getTotalImageCount());
		request.debug(mockProduct.getDefaultProductImageFilesCount());//yuqing
		
		//testing the product without mockImages
		var productData2 = {
			productID = ""
		};
		var mockProductNoImages = createPersistedTestEntity('Product', productData2);
		
		assertEquals(0, mockProductNoImages.getProductImagesCount());
		assertEquals(0 + 0, mockProductNoImages.getTotalImageCount());
	}
	
	public void function getSkuSalePriceDetailsTest() {
		
	}
	
	public void function getSkuSalePriceDetailsByCurrencyCodeTest() {
		
	}

	//=============== Private Helper functions ====================================
	/**
	* @hint "Create Mocked Otpion entity with optionGroupID"
	*
	*/
	private any function createMockOption(required string optionGroupID ) {
		var optionData1 = {
			optionID = "",
			optionGroup = {
				optionGroupID = arguments.optionGroupID
			}
		};			
		return createPersistedTestEntity('Option', optionData1);
	}
	/**
	* @hint "Return mocked Product entity with properites you passed in.<br>If no argument, make it "". "
	*
	*/
	private any function createMockProduct(string productTypeID = "") {
		var productData = {
			productID = ""
		};
		if(len(arguments.productTypeID)){
			productData.productType.productTypeID = arguments.productTypeID;
		}
		return createPersistedTestEntity('Product', productData);
	}
	/**
	* @hint "Return mocked ProductType entity with properites you passed in<br>If only pass one argument, make the other one "". "
	*
	*/
	private any function createMockProductType (string productID="", string parentProductTypeID="") {
		var productTypeData = {
			productTypeID = ""			
		};
		
		if(len(arguments.productID)){
			productTypeData.product.productID = arguments.productID;
		}
		if(len(arguments.parentProductTypeID)){
			productTypeData.parentProductType.productTypeID = arguments.parentProductTypeID;
		}
		
		return createPersistedTestEntity('ProductType', productTypeData);
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
		if (len(arguments.skuPrice)) {
			skuData.price = arguments.skuPrice;
		}
		return createPersistedTestEntity('Sku', skuData);
	}
	
	private any function createMockImage(string imageDirectory = "") {
		var imageData = {
			imageID = ""
		};
		if (len(arguments.imageDirectory)) {
			imageData.directory = arguments.imageDirectory;
		}
		return createPersistedTestEntity('Image', imageData);
	}

   //================== End Of Private Helper Functions =========================================
   
	// ============ START: Non-Persistent Property Methods =================
	/*
	public void function getBaseProductType_ExistedSystemCode_Test() {
		//testing if the productType already has a systemCode
		var productTypeData = { //same name Yuqing
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
	 	//testing product w/ skus
	 	var mockSku1 = createMockSku("", "", "/mock/SomeImageFilePath", "");
	 	var mockSku2 = createMockSku("", "", "/mockThe/Image/File2", "");
	 	var mockSku3 = createMockSku();
	 	var mockSku4 = createMockSku("", "",  "Mockfilefor other product entity", "");
		
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
		
		var result = mockProduct.getDefaultProductImageFiles();
		assertEquals(2, arrayLen(result));
		assertEquals(mockSku1.getImageFile(), result[1].imageFile);
		
		//testing product without skus
		var productData2 = {
			productID = ""
		};
		var mockProductNoSku = createPersistedTestEntity('Product', productData2);
		
		var resultNoSku = mockProductNoSku.getDefaultProductImageFiles();
		assertEquals(0, arrayLen(resultNoSku));
	 }
	 
	 public void function getDefaultProductImageFilesCountTest() {
	 	var mockSku1 = createMockSku("", "", "mockImageFile");
	 	var mockSku2 = createMockSku();
	 	
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
		
		var result = mockProduct.getDefaultProductImageFilesCount();
		request.debug(result);//yuqing
	 }
	 
	 public void function getSalePriceDetailsForSkusTest() {
	 	var mockSku1 = createMockSku("", "CNY", "");
	 	var mockSku2 = createMockSku("", "USD", "");
	 	var mockSku3 = createMockSku("","","");
	 	var mockSku4 = createMockSku("", "", "");
		
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
//		request.debug(result);
		request.debug(mockProduct.getSalePriceDetailsForSkusByCurrencyCode());
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
/*
	 public void function getPlacedOrderItemsSmartListTest() {
	 	//mockProduct1 -> (Sku) -> MockOrderItem1 -> mockOrder1: ostNew
	 	//			   -> (Sku) -> MockOrderItem2 -> mockOrder2: ostNotPlaced
	 	//mockProduct2 -> (Sku) -> MockOrderItem3 -> mockOrder1: ostNew
	 	
	 	var productData1 = {
			productID = ""
		};
		var mockProduct1 = createPersistedTestEntity('Product', productData1);
		
		var productData2 = {
			productID = ""
		};
		var mockProduct2 = createPersistedTestEntity('Product', productData2);
				
		var orderItemData1 = {
	 		orderItemID = "",
	 		sku = {
	 			skuID = "",
	 			product = {
	 				productID = mockProduct1.getProductID()
	 			}
	 		}
	 	};
	 	var mockOrderItem1 = createPersistedTestEntity('OrderItem', orderItemData1);
	 	
	 	var orderItemData2 = {
	 		orderItemID = "",
	 		sku = {
	 			skuID = "",
	 			product = {
	 				productID = mockProduct1.getProductID()
	 			}
	 		}
	 	};
	 	var mockOrderItem2 = createPersistedTestEntity('OrderItem', orderItemData2);
	 	
	 	var orderItemData3 = {
	 		orderItemID = "",
	 		sku = {
	 			skuID = "",
	 			product = {
	 				productID = mockProduct2.getProductID()
	 			}
	 		}
	 	};
	 	var mockOrderItem3 = createPersistedTestEntity('OrderItem', orderItemData3);
	 	
		var orderData1 = {
			orderID = "",
			orderStatusType = {
				typeID = "444df2b5c8f9b37338229d4f7dd84ad1" //ostNew
			},
			orderItems = [
				{
					orderItemID = mockOrderItem1.getOrderItemID()
				},
				{
					orderItemID = mockOrderItem3.getOrderItemID()
				}
			]
		};
		var mockOrder1 = createPersistedTestEntity('Order', orderData1);
		
		var orderData2 = {
			orderID = "",
			orderStatusType = {
				typeID = "444df2b498de93b4b33001593e96f4be" //ostNotPlaced
			},
			orderItems = [
				{
					orderItemID = mockOrderItem2.getOrderItemID()
				}
			]
		};
		var mockOrder2 = createPersistedTestEntity('Order', orderData2);
		
	 	var result = mockProduct1.getPlacedOrderItemsSmartList().getRecords(refresh = true);
	 	//testing the filter of productID
	 	assertEquals(mockProduct1.getProductID(), result[1].getSku().getProduct().getProductID());
		//testing the filter of orderStatusType
	 	assertEquals(1, arrayLen(result));
	 	assertEquals("ostNew", result[1].getOrder().getOrderStatusType().getSystemCode());
	 	
	 	
	 }
	 public void function getBundleSkusSmartListTest() {
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
		
		var skuData2 = {
			skuID = "",
			bundleFlag = 0,
			product = {
				productID = mockProduct.getProductID()
			}
		};
		var mockSku2 = createPersistedTestEntity('Sku', skuData2);
		
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
