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

//=============== Private Helper functions ====================================



	/**
	* @hint "Use '' for arguments not pass in"
	*
	*/
	private any function createMockContent(string title = "", boolean activeFlag = "") {
		var contentData = {
			contentID = ""
		};
		if (len(arguments.title)) {
			contentData.title = arguments.title;
		}
		if (len(arguments.activeFlag)) {
			contentData.activeFlag = arguments.activeFlag;
		}
		return createPersistedTestEntity('Content', contentData);
	}
	/**
	* @hint "return the mocked persisted Content entity with contentTemplateType (ctt)"
	*/
	private any function createMockContentWithContentTemplateType(required string contentTemplateTypeID) {
		var contentData = {
			contentID = "",
			contentTemplateType = {
				typeID = arguments.contentTemplateTypeID
			}
		};
		return createPersistedTestEntity('Content', contentData);
	}
	/**
	* @hint "Create Mocked Otpion entity with optionGroupID, make empty properties "" in order"
	*/
	private any function createMockOption(required string optionGroupID = "", string skuID = "" ) {
		var optionData1 = {
			optionID = "",
			optionGroup = {
				optionGroupID = arguments.optionGroupID
			}
		};			

		if(len(arguments.skuID)){
			optionData1.skus=[
				{
					skuID=arguments.skuID	
				}	
			];
		}
		
		return createPersistedTestEntity('Option', optionData1);
	}
	/**
	* @hint "Return mocked Product entity with properites you passed in.<br>If no argument, make it "". "
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
	* @hint "This function will return mockSku with properites you passed in <br> Make the null arguments "" in order "
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
	
	/**
	* @hint "This function will return mockImage with properites you passed in. Make the null arguments "" in order "
	*/
	private any function createMockImage(string imageDirectory = "", string imageFile = "") {
		var imageData = {
			imageID = ""
		};
		if (len(arguments.imageDirectory)) {
			imageData.directory = arguments.imageDirectory;
		}
		if (len(arguments.imageFile)) {
			imageData.imageFile = arguments.imageFile;
		}
		return createPersistedTestEntity('Image', imageData);
	}
	
	/**
	* @hint "This function will return mockOptionGroup with properites you passed in. Make the null arguments "" in order "
	*/
	private any function createMockOptionGroup(string optionGroupName = "", string optionGroupCode = "") {
		var optionGroupData = {
			optionGroupID = ""
		};
		if (len(arguments.optionGroupName)) {
			optionGroupData.optionGroupName = arguments.optionGroupName;
		}
		if (len(arguments.optionGroupCode)) {
			optionGroupData.optionGroupCode = arguments.optionGroupCode;
		}
		return createPersistedTestEntity('OptionGroup', optionGroupData);
	}
	
   //================== End Of Private Helper Functions =========================================
	
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
		var mockContent1 = createMockContent("Whisper In the Willow", 1);
		var mockContent2 = createMockContent("Black Beauty", 1);
		var mockContent3 = createMockContent("Macbeth", 1);
		var mockContent4 = createMockContent("", 1);
		var mockContent5 = createMockContent("The Happy Prince", 0);
		
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
		
		//testing the product without mockImages
		var productData2 = {
			productID = ""
		};
		var mockProductNoImages = createPersistedTestEntity('Product', productData2);
		
		assertEquals(0, mockProductNoImages.getProductImagesCount());
		assertEquals(0 + 0, mockProductNoImages.getTotalImageCount());
	}
	
	public void function getTemplateOptionsTest() {
		//Never been used elsewhere. Skip the test.
	}
		
	public void function getSkuSalePriceDetailsTest() {
		
	}
	
	public void function getSkuSalePriceDetailsByCurrencyCodeTest() {
		
	}
	
	//=================Non-persisted Helpers ====================
	
	/**
	* @hint "helper for getOptionsGroupsXXX() function to create mock Data. Arguments are 2 OptionGroup ID"
	*
	*/
	private any function createMockDataForGetOptionGroupsHelper(string optionGroupId1, string optionGroupId2) {
		var productData = {
			productID = ""
		};
		var mockProduct = createPersistedTestEntity('Product', productData);
		
		var mockOption1 = createMockOption(arguments.optionGroupId1);
		var mockOption2 = createMockOption(arguments.optionGroupId2);
		
		var skuData1 = {
			skuID = "",
			product = {
				productID = mockProduct.getProductID()
			},
			options = [
				{
					optionID = mockOption1.getOptionID()
				},
				{
					optionID = mockOption2.getOptionID()
				}
			]
		};
		var mockSku = createPersistedTestEntity('Sku', skuData1);
				
		if (!mockOption1.hasSku(mockSku)) {
			arrayAppend(mockOption1.getSkus(), mockSku);
		}
		
		if (!mockOption2.hasSku(mockSKU)) {
			arrayAppend(mockOption2.getSkus(), mockSku);
		}

		return mockProduct;
	}
	
	public void function getOptionGroupsTest() {				
		var optionGroupsData1 = {
			optionGroupID = ""
		};
		var mockOptionGroup1 = createPersistedTestEntity('OptionGroup', optionGroupsData1);
		var optionGroupsData2 = {
			optionGroupID = ""
			
		};
		var mockOptionGroup2 = createPersistedTestEntity('OptionGroup', optionGroupsData2);
		
		var mockProduct = createMockDataForGetOptionGroupsHelper(mockOptionGroup1.getOptionGroupID(), mockOptionGroup2.getOptionGroupID());
		var resultOptionGroups = mockProduct.getOptionGroups();
		
		var indexOfMockOptionGroup1 = arrayFind(resultOptionGroups, mockOptionGroup1);
		var indexOfMockOptionGroup2 = arrayFind(resultOptionGroups, mockOptionGroup2);
		
		//testing the productID filter
		assertNotEquals(0, indexOfMockOptionGroup1);
		assertNotEquals(0, indexOfMockOptionGroup2);
		assertEquals(mockProduct.getProductID(), resultOptionGroups[indexOfMockOptionGroup1].getOptions()[1].getSkus()[1].getProduct().getProductID());
		
		//testing the ascending order
		assertEquals(mockOptionGroup1.getOptionGroupID() < mockOptionGroup2.getOptionGroupID(), indexOfMockOptionGroup1 < indexOfMockOptionGroup2);
	}
	
	public void function getOptionGroupsStructTest() {		
		var optionGroupsData1 = {
			optionGroupID = "",
			optionGroupName = "Hello Kitty"
		};
		var mockOptionGroup1 = createPersistedTestEntity('OptionGroup', optionGroupsData1);
		var optionGroupsData2 = {
			optionGroupID = "",
			optionGroupName = "Hello Doggy"
			
		};
		var mockOptionGroup2 = createPersistedTestEntity('OptionGroup', optionGroupsData2);
		
		var mockProduct = createMockDataForGetOptionGroupsHelper(mockOptionGroup1.getOptionGroupID(), mockOptionGroup2.getOptionGroupID());
		var resultOptionGroupsStruct = mockProduct.getOptionGroupsStruct();
		
		assertIsStruct(resultOptionGroupsStruct);//Yuqing: Check if works in CircleCI
		assertEquals("Hello Kitty", resultOptionGroupsStruct[mockOptionGroup1.getOptionGroupID()].getOptionGroupName());
		assertEquals(mockOptionGroup2.getOptionGroupID(), resultOptionGroupsStruct[mockOptionGroup2.getOptionGroupID()].getOptionGroupID());
	}
	
	public void function getOptionGroupsAsListTest() {

		var optionGroupsData1 = {
			optionGroupID = ""
		};
		var mockOptionGroup1 = createPersistedTestEntity('OptionGroup', optionGroupsData1);
		var optionGroupsData2 = {
			optionGroupID = ""
			
		};
		var mockOptionGroup2 = createPersistedTestEntity('OptionGroup', optionGroupsData2);
		
		var mockProduct = createMockDataForGetOptionGroupsHelper(mockOptionGroup1.getOptionGroupID(), mockOptionGroup2.getOptionGroupID());
		var resultOptionGroupsList = mockProduct.getOptionGroupsAsList();
		
		assertTrue(len(resultOptionGroupsList) >= 2);
		assertTrue(listFind(resultOptionGroupsList, mockOptionGroup1.getOptionGroupID()) != 0);		
	}
	
	public void function getOptionGroupCountTest() {
		var optionGroupsData1 = {
			optionGroupID = ""
		};
		var mockOptionGroup1 = createPersistedTestEntity('OptionGroup', optionGroupsData1);
		var optionGroupsData2 = {
			optionGroupID = ""
			
		};
		var mockOptionGroup2 = createPersistedTestEntity('OptionGroup', optionGroupsData2);
		
		var mockProduct = createMockDataForGetOptionGroupsHelper(mockOptionGroup1.getOptionGroupID(), mockOptionGroup2.getOptionGroupID());
		assertEquals(2, mockProduct.getOptionGroupCount());
	}
	
	public void function getAllowAddOptionGroupFlag_OneSkuTwoOptionGroups_Test() {
		//Testing the mock Data from the private helper 
		var optionGroupsData1 = {
			optionGroupID = ""
		};
		var mockOptionGroup1 = createPersistedTestEntity('OptionGroup', optionGroupsData1);
		var optionGroupsData2 = {
			optionGroupID = ""
			
		};
		var mockOptionGroup2 = createPersistedTestEntity('OptionGroup', optionGroupsData2);
		
		var mockProduct = createMockDataForGetOptionGroupsHelper(mockOptionGroup1.getOptionGroupID(), mockOptionGroup2.getOptionGroupID());
		var resultAllowFlag = mockProduct.getAllowAddOptionGroupFlag();
		assertTrue(resultAllowFlag);
	}
	public void function getAllowAddOptionGroupFlag_MultipleSkus_Test() {
		//Testing when getSkus returns more then one Sku
		var productData = {
			productID = ""
		};
		var mockProduct = createPersistedTestEntity('Product', productData);
		
		var optionGroupsData1 = {
			optionGroupID = ""
		};
		var mockOptionGroup1 = createPersistedTestEntity('OptionGroup', optionGroupsData1);
		
		var mockOption1 = createMockOption(mockOptionGroup1.getOptionGroupID());
		var mockOption2 = createMockOption(mockOptionGroup1.getOptionGroupID());
		
		var skuData1 = {
			skuID = "",
			product = {
				productID = mockProduct.getProductID()
			},
			options = [
				{
					optionID = mockOption1.getOptionID()
				}
			]
		};
		var mockSku1 = createPersistedTestEntity('Sku', skuData1);
		var skuData2 = {
			skuID = "",
			product = {
				productID = mockProduct.getProductID()
			},
			options = [
				{
					optionID = mockOption2.getOptionID()
				}
			]
		};
		var mockSku2 = createPersistedTestEntity('Sku', skuData2);

		var resultMultiSku = mockProduct.getAllowAddOptionGroupFlag();
		assertTrue(resultMultiSku);
	}
	public void function getAllowAddOptionGroupFlag_NoOptionGroup_Test() {
		//testing product with one Sku but 0 OptionGroup
		var productData = {
			productID = ""
		};
		var mockProduct = createPersistedTestEntity('Product', productData);
		
		var optionData = {
			optionID = ""
		};
		var mockOption = createPersistedTestEntity('Option', optionData);
		
		var skuData = {
			skuID = "",
			product = {
				productID = mockProduct.getProductID()
			},
			options = [
				{
					optionID = mockOption.getOptionID()
				}
			]
		};
		var mockSku = createPersistedTestEntity('Sku', skuData);
		
		var resultNoOptionGroup = mockProduct.getAllowAddOptionGroupFlag();
		assertTrue(resultNoOptionGroup);		
	}
	public void function getCategoryIDsTest() {		
		var categoryData1 = {
			categoryID = ""
		};
		var mockCategory1 = createPersistedTestEntity('Category', categoryData1);
		var categoryData2 = {
			categoryID = ""
		};
		var mockCategory2 = createPersistedTestEntity('Category', categoryData2);
		var categoryData3 = {
			categoryID = ""
		};
		var mockCategory3 = createPersistedTestEntity('Category', categoryData3);
		
		//testing existed categories
		var productData = {
			productID = "",
			categories = [
				{
					categoryID = mockCategory1.getCategoryID()
				},
				{
					categoryID = mockCategory2.getCategoryID()
				}
			]
		};
		var mockProduct = createPersistedTestEntity('Product', productData);
		
		var resultExistCategories = mockProduct.getCategoryIDs();
		assertTrue(listFind(resultExistCategories, mockCategory1.getCategoryID()) > 0);
		assertTrue(listFind(resultExistCategories, mockCategory2.getCategoryID()) > 0);
		assertTrue(listFind(resultExistCategories, mockCategory3.getCategoryID()) == 0);
		
		//testing empty category
		var mockProductNoCategory = createMockProduct();
		var resultNoCategory = mockProductNoCategory.getCategoryIDs();
		assertTrue(Len(resultNoCategory) == 0);
	}
	
	public void function getTemplate_ContentTemplateTypeIsCttProduct_Test() {
		//testing product associate w/ content and ContentTemplateType is cttProduct
		var mockContent1 = createMockContentWithContentTemplateType("444df330fc19e5beb17ff974ac03db18");//cttProduct
		
		var productData = {
			productID = ""
			,
			listingPages = [
				{
					contentID = mockContent1.getContentID()
				}
			]
		};
		var mockProduct = createPersistedTestEntity('Product', productData);
		
		var settingData = {
			settingID="",
			settingName="productDisplayTemplate",
			settingValue = "cttBarrierPage, cttProduct, cttcttProductType"
		};
		var settingEntity = createPersistedTestEntity('Setting',settingData);
		
		var result = mockProduct.getTemplate();
		assertEquals(settingEntity.getsettingValue(), result);
		
	}
	
	public void function getTemplate_ContentTemplateTypeNotCttProduct_Test() {
		//testing product Template with mockContent
		var mockContent = createMockContentWithContentTemplateType("444df332f3988ad0c802b83361f99a01");//cttBrand
		
		var productData = {
			productID = "",
			listingPages = [
				{
					contentID = mockContent.getContentID()
				}
			]
		};
		var mockProduct = createPersistedTestEntity('Product', productData);
		
		var settingData = {
			settingID="",
			settingName="productDisplayTemplate",
			settingValue = "cttBarrierPage, cttProduct, cttcttProductType"
		};
		var settingEntity = createPersistedTestEntity('Setting',settingData);
		
		var result = mockProduct.getTemplate();
		//Even though the result is same, executing different code in SettingService
		assertEquals(settingEntity.getsettingValue(), result);
		
	}
	
	public void function getTemplate_GlobalSettingNoContents_Test() {
		//testing product Template with no mockContent
		var productData = {
			productID = ""

		};
		var mockProduct = createPersistedTestEntity('Product', productData);
		
		var settingData = {
			settingID="",
			settingName="productDisplayTemplate",
			settingValue = "cttBarrierPage, cttProduct, cttcttProductType"
		};
		var settingEntity = createPersistedTestEntity('Setting',settingData);
		
		var result = mockProduct.getTemplate();
		assertEquals(settingEntity.getsettingValue(), result);
		
	}

	public void function getAlternateImageDirectoryTest() {
		var mockProduct = createMockProduct();
		var result = mockProduct.getAlternateImageDirectory();
		assertEquals("/custom/assets/images/product/", result);
	}
	
	
	// @hint "This function mostly used by testing getProductRating()"
	private any function createMockProductReviewWithRating(numeric rating = -1) {
		var productReviewData = {
			productReviewID = ""			
		};
		if (rating != -1) {
			productReviewData.rating = arguments.rating;
		}
		return createPersistedTestEntity('ProductReview', productReviewData);
	}
	
	public void function getProductRatingTest2() {
		var mockProductReview1 = createMockProductReviewWithRating(10);
		var mockProductReview2 = createMockProductReviewWithRating(20);
		var mockProductReview3 = createMockProductReviewWithRating(30);
		var mockProductReview4 = createMockProductReviewWithRating();
		//testing the average math
		var productData1 = {
			productID = "",
			productReviews = [
				{
					productReviewID = mockProductReview1.getProductReviewID()
				},
				{
					productReviewID = mockProductReview2.getProductReviewID()
				},
				{
					productReviewID = mockProductReview3.getProductReviewID()
				}
			]
		};
		var mockProductOnMath = createPersistedTestEntity('Product', productData1);
		
		var resultOnMath = mockProductOnMath.getProductRating();
		assertEquals(20, resultOnMath);
		
		//testing the productReview w/ and w/o rating
		var productData2 = {
			productID = "",
			productReviews = [
				{
					productReviewID = mockProductReview1.getProductReviewID()
				},
				{
					productReviewID = mockProductReview4.getProductReviewID()
				}
			]
		};
		var mockProductWithWithoutRating = createPersistedTestEntity('Product', productData2);
		
		var resultWithWithoutRating = mockProductWithWithoutRating.getProductRating();
		assertEquals(5, resultWithWithoutRating);
		
		//testing the productReveiw without rating
		var productData3 = {
			productID = "",
			productReviews = [
				{
					productReviewID = mockProductReview4.getProductReviewID()
				}
			]
		};
		var mockProductWithoutRating = createPersistedTestEntity('Product', productData3);
		
		var resultWithoutRating = mockProductWithoutRating.getProductRating();
		assertEquals(0, resultWithoutRating);
		
		//testing the product without productReview properety
		var mockProductWithoutProductReveiw = createMockProduct();
		
		var resultWithoutProductReview = mockProductWithoutProductReveiw.getProductRating();
		assertEquals(0, resultWithoutProductReview);
	}
	
	public void function getImageGalleryArray_StructValues_Test() {
		//testing if the struct values works well		 	
		var mockSku = createMockSku("", "", "admin.logo.png");
	 				
		var imageData = {
			imageID = "",
			imageName = "Favicon Image Name",
			imageDescription = "Mock Image's Description'",
			imageFile = "/favicon.png",
			directory = "mockDirectory"
		};
		var mockImage = createPersistedTestEntity('Image', imageData);
		
		var productData = {
			productID = "",
			productName = "MockProductName",
			skus = [
				{
					skuID = mockSku.getSkuID()
				}
			],
			productImages = [
				{
					imageID = mockImage.getImageID()
				}
			],
			productDescription = "MockProduct's description"
		};
		var mockProduct = createPersistedTestEntity('Product', productData);
		
		var resultImageGalleryArray = mockProduct.getImageGalleryArray();
		
		assertEquals(2, arrayLen(resultImageGalleryArray));
		
		//testing values on sku default image
		assertEquals("admin.logo.png", resultImageGalleryArray[1].originalFileName);
		assertEquals("/custom/assets/images/product/default/admin.logo.png", resultImageGalleryArray[1].originalPath);
		assertEquals("skuDefaultImage", resultImageGalleryArray[1].type);
		assertEquals(mockProduct.getProductID(), resultImageGalleryArray[1].productID);
		assertEquals("MockProductName", resultImageGalleryArray[1].name);
		assertEquals("MockProduct's description", resultImageGalleryArray[1].description);
		assertTrue(!isNull(resultImageGalleryArray[1].resizedImagePaths[1]));
		assertTrue(!isNull(resultImageGalleryArray[1].resizedImagePaths[2]));
		assertTrue(!isNull(resultImageGalleryArray[1].resizedImagePaths[3]));
		
		//testing the values on productImage
		assertEquals("/custom/assets/images/mockDirectory/", resultImageGalleryArray[2].originalPath);
		assertEquals("productAlternateImage", resultImageGalleryArray[2].type);
		assertEquals(mockProduct.getProductID(), resultImageGalleryArray[2].productID);
		assertEquals("Favicon Image Name", resultImageGalleryArray[2].name);
		assertEquals("Mock Image's Description'", resultImageGalleryArray[2].description);
		assertTrue(!isNull(resultImageGalleryArray[2].resizedImagePaths[1]));
		assertTrue(!isNull(resultImageGalleryArray[2].resizedImagePaths[2]));
		assertTrue(!isNull(resultImageGalleryArray[2].resizedImagePaths[3]));		
	}
	public void function getImageGalleryArray_SkuImagesAssociation_Test() {
		//Testing the associatino
		var mockSku1 = createMockSku("", "", "admin.logo.png");
	 	var mockSku2 = createMockSku();//Does not have images, should not be added
	 	var mockSku3 = createMockSku("", "", "fakeFile.somefile");
	 	var mockSku4 = createMockSku("", "", "favicon.png");
	 	
		var mockImage1 = createMockImage("/fakedirectory", "admin.logo.png");
		var mockImage2 = createMockImage();
		
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
			],
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
		
		var resultImageGalleryArray = mockProduct.getImageGalleryArray();
		assertEquals(5, arrayLen(resultImageGalleryArray));
	}	
	
	public void function getProductURLTest() {
		//testing if the urlTitle exists
		var productData = {
			productID = "",
			urlTitle = "MockProductURLTitle"
		};
		var mockProduct = createPersistedTestEntity('Product', productData);
		
		var result = mockProduct.getPRoductURL();
		assertEquals("/sp/MockProductURLTitle/", result);
		
		//testing if the urlTitle exists
		var productData2 = {
			productID = ""
		};
		var mockProductNoURL = createPersistedTestEntity('Product', productData2);
		
		var resultNoProductURL = mockProductNoURL.getPRoductURL();
		assertEquals("/sp//", resultNoProductURL);
	}

	public void function getListingProductURLTest() {
		//testing if the urlTitle exists
		var productData = {
			productID = "",
			urlTitle = "MockProductURLTitle"
		};
		var mockProduct = createPersistedTestEntity('Product', productData);
		
		var result = mockProduct.getListingProductURL();
		assertEquals("sp/MockProductURLTitle/", result);
		
		//testing if the urlTitle exists
		var productData2 = {
			productID = ""
		};
		var mockProductNoURL = createPersistedTestEntity('Product', productData2);
		
		var resultNoProductURL = mockProductNoURL.getListingProductURL();
		assertEquals("sp//", resultNoProductURL);
	}

	//=================End Test: non-persisted Helpers===========

	
	// Start Testing: Functions that delegate to the default sku
	
	/**
	* @hint "Helper of functions delegate to the default sku. This returns the PRODUCT entity with the default SKU"
	*/
	private any function createMockDataWithDefaultSku() {
		var skuData = {
			skuID = "",
			imageFile = "admin.logo.png"
		};
		var mockSku = createPersistedTestEntity('Sku', skuData);
		
		var productData = {
			productID = "",
			productType = {
				typeID = "50cdfabbc57f7d103538d9e0e37f61e4" //giftcard
			},
			defaultSku = {
				skuID = mockSku.getSkuID()
			}
		};
		return createPersistedTestEntity('Product', productData);
		
	}
	
	/**
	* @hint "Helper of functions delegate to the default sku. This returns the PRODUCT entity without the default SKU"
	*/
	private any function createMockDataWithoutDefaultSku() {
		var productData = {
			productID = "",
			productType = {
				typeID = "50cdfabbc57f7d103538d9e0e37f61e4" //giftcard
			}
		};
		return createPersistedTestEntity('Product', productData);
		
	}
	
	public void function getImageDirectoryTest() {
		//TODO: deprecate method getImageDirectory() is undefined in sku.cfc
		
		//Testing the PRODUCT with defaultSKU
		var mockProductWithDefaultSku = createMockDataWithDefaultSku();
				
		//Testing the PRODUCT without defaultSKU
		var mockProductWithoutDefaultSku = createMockDataWithoutDefaultSku();				
	}
	
	public void function getImagePathTest() {
		//Testing the PRODUCT with defaultSKU
		var mockProductWithDefaultSku = createMockDataWithDefaultSku();
		
		var resultImagePathWithDefaultSKU = mockProductWithDefaultSku.getImagePath();
		assertEquals("/custom/assets/images/product/default/admin.logo.png", resultImagePathWithDefaultSKU);
		
		//Testing the PRODUCT without defaultSKU
		var mockProductWithoutDefaultSku = createMockDataWithoutDefaultSku();
				
		var resultImagePathWithoutDefaultSKU = mockProductWithoutDefaultSku.getImagePath();
		assertEquals("/custom/assets/images/product/default/", resultImagePathWithoutDefaultSKU);
		
	}
	
	public void function getImageTest() {
		//Testing the PRODUCT with defaultSKU
		var mockProductWithDefaultSku = createMockDataWithDefaultSku();
		
		var resultImageWithDefaultSKU = mockProductWithDefaultSku.getImage();
		assertEquals('<img src="/assets/images/missingimage.jpg" />', resultImageWithDefaultSKU);
		
		//Testing the PRODUCT without defaultSKU
		var mockProductWithoutDefaultSku = createMockDataWithoutDefaultSku();
				
		var resultImageWithoutDefaultSKU = mockProductWithoutDefaultSku.getImage();
		assertEquals('<img src="/assets/images/missingimage.jpg" />', resultImageWithoutDefaultSKU);
	}
	
	public void function getResizedImagePathTest() {
		//Testing the PRODUCT with defaultSKU
		var mockProductWithDefaultSku = createMockDataWithDefaultSku();
		
		var resultResizedPathWithDefaultSKU = mockProductWithDefaultSku.getResizedImagePath();
		assertEquals("/assets/images/missingimage.jpg", resultResizedPathWithDefaultSKU);
		
		//Testing the PRODUCT without defaultSKU
		var mockProductWithoutDefaultSku = createMockDataWithoutDefaultSku();
				
		var resultResizedPathWithoutDefaultSKU = mockProductWithoutDefaultSku.getResizedImagePath();
		assertEquals("/assets/images/missingimage.jpg", resultResizedPathWithoutDefaultSKU);
	}
	
	public void function getImageExistsFlagTest() {
		createTestFile (expandPath('/Slatwall') & '/assets/images/admin.logo.png', 
						"/custom/assets/images/product/default/admin.logo.png");
								
		//Testing the PRODUCT with defaultSKU
		var mockProductWithDefaultSku = createMockDataWithDefaultSku();
		
		var resultFlagWithDefaultSKU = mockProductWithDefaultSku.getImageExistsFlag();
		assertTrue(resultFlagWithDefaultSKU);
		
		//testing the PRODUCT without defaultSKU
		var mockProductWithoutDefaultSku = createMockDataWithoutDefaultSku();

		var resultFlagWithoutDefaultSKU = mockProductWithoutDefaultSku.getImageExistsFlag();
		assertFalse(resultFlagWithoutDefaultSKU);
	}
	
	public void function getOptionsByOptionGroupTest() {
		var mockOptionGroup1 = createMockOptionGroup();		
		var mockOptionGroup2 = createMockOptionGroup();
		
		var mockOption1 = createMockOption(mockOptionGroup1.getOptionGroupID());
		var mockOption2 = createMockOption(mockOptionGroup1.getOptionGroupID());
		var mockOption3 = createMockOption(mockOptionGroup2.getOptionGroupID());
		var mockOption4 = createMockOption(mockOptionGroup2.getOptionGroupID());
		
		var mockProduct1 = createMockProduct();
		var mockProduct2 = createMockProduct();
		//Mocked Data:
		//mockProduct1 -> mockSku1 -> mockOption1 -> mockOptionGroup1
		//						   -> mockOption2 -> mockOptionGroup1
		//						   -> mockOption3 -> mockOptionGroup2
		//mockProduct2 -> mockSku2 -> mockOption3 -> mockOptionGroup2
		//						   -> mockOption4 -> mockOptionGroup2
		var skuData1 = {
			skuID = "",
			options = [
				{
					optionID = mockOption1.getOptionID()
				},
				{
					optionID = mockOption2.getOptionID()
				},
				{
					optionID = mockOption3.getOptionID()
				}
			],
			product = {
				productID = mockProduct1.getProductID()
			}
		};
		var mockSku1 = createPersistedTestEntity('Sku', skuData1);
		
		var skuData2 = {
			skuID = "",
			options = [
				{
					optionID = mockOption3.getOptionID()
				},
				{
					optionID = mockOption4.getOptionID()
				}
			],
			product = {
				productID = mockProduct2.getProductID()
			}
		};
		var mockSku2 = createPersistedTestEntity('Sku', skuData2);

		//Testing the optionGroup filter on mockOptionGroup1
		var resultMockOptionGroup1 = mockProduct1.getOptionsByOptionGroup(mockOptionGroup1.getOptionGroupID());
		assertEquals(2, arrayLen(resultMockOptionGroup1));
		//Testing the optionGroup filter on mockOptionGroup2
		var resultMockOptionGroup2 = mockProduct1.getOptionsByOptionGroup(mockOptionGroup2.getOptionGroupID());
		assertEquals(1, arrayLen(resultMockOptionGroup2));
		//Testing the optionGroup filter does not match( MockOptionGroup1 on mockProduct2, which weren't linked by mockOption3)
		var resultMockOptionGroupNotMatch = mockProduct2.getOptionsByOptionGroup(mockOptionGroup1.getOptionGroupID());
		assertEquals(0, arrayLen(resultMockOptionGroupNotMatch));
		
		
		//Testing the Product filter on mockProduct2
		var resultTestProductFilterOnOptionGroup1 = mockProduct2.getOptionsByOptionGroup(mockOptionGroup2.getOptionGroupID());
		assertEquals(2, arrayLen(resultTestProductFilterOnOptionGroup1));
		
		//Testing the sort order on the pervious result: resultMockOptionGroup1
		var indexOfMockOption1 = arrayFind(resultMockOptionGroup1, mockOption1);
		var indexOfMockOption2 = arrayFind(resultMockOptionGroup1, mockOption2);
		assertEquals(indexOfMockOption1<indexOfMockOption2, mockOption1.getOptionID() < mockOption2.getOptionID());
	}
	
	public void function getRenewalMethodOptionsTest() {
		//Testing returns of the rbKey values
		var mockProduct = createMockProduct();
		var resultOptions = mockProduct.getRenewalMethodOptions();
		
		assertEquals("Select a Sku to be used upon renewal.", resultOptions[1].name);
		assertEquals("renewalsku", resultOptions[1].value);
		assertEquals("Select a benefit and price to be used upon renewal.", resultOptions[2].name);
		assertEquals("custom", resultOptions[2].value);
	}
	
	public void function getSkuBySelectedOptionsTest() {
		var mockOption1 = createMockOption();
		var mockOption2 = createMockOption();
		var mockOption3 = createMockOption();
		
		var mockProduct1 = createMockProduct();
		var mockProduct2 = createMockProduct();
		//Mocked Data:
		//mockProduct1 -> mockSku1 -> mockOption1 
		//mockProduct2 -> mockSku2 -> mockOption2 
		//						   -> mockOption3 
		//			   -> mockSku3 -> mockOption3 
		var skuData1 = {
			skuID = "",
			options = [
				{
					optionID = mockOption1.getOptionID()
				}
			],
			product = {
				productID = mockProduct1.getProductID()
			}
		};
		var mockSku1 = createPersistedTestEntity('Sku', skuData1);
		var skuData2 = {
			skuID = "",
			options = [
				{
					optionID = mockOption2.getOptionID()
				},
				{
					optionID = mockOption3.getOptionID()
				}
			],
			product = {
				productID = mockProduct2.getProductID()
			}
		};
		var mockSku2 = createPersistedTestEntity('Sku', skuData2);
		
		var skuData3 = {
			skuID = "",
			options = [
				{
					optionID = mockOption3.getOptionID()
				}
			],
			product = {
				productID = mockProduct2.getProductID()
			}
		};
		var mockSku3 = createPersistedTestEntity('Sku', skuData3);
		
		//Testing the result without options passed
		var resultSkuWithoutArgu = mockProduct1.getSkuBySelectedOptions();
		assertEquals(mockSku1.getSkuID(), resultSkuWithoutArgu.getSkuID());
		
		try { //arrayLen of getSkus() > 1
			mockProduct2.getSkuBySelectedOptions(); 
		} catch (any e) {
			assertTrue(find( "You must submit a comma seperated list of selectOptions to find an indvidual sku in this product", e.message) != 0);
		}
		
		//Testing results with arguments
		var resultSkuWithOption2 = mockProduct2.getSkuBySelectedOptions(mockOption2.getOptionID());
		assertEquals(mockSku2, resultSkuWithOption2);
		
		try { //arrayLen(skus) > 1
			result = mockProduct2.getSkuBySelectedOptions(mockOption3.getOptionID());
		} catch (any e) {
			assertTrue(find( "More than one sku is returned when the selected options are: ", e.message) != 0);
		}
		
		try { //arrayLen(skus) < 1
			mockProduct2.getSkuBySelectedOptions(mockOption1.getOptionID());
		} catch (any e) {
			assertTrue(find( "No Skus are found for these selected options: ", e.message) != 0);
		}
	}
	public void function getSkusBySelectedOptionsTest() {
		var mockOption1 = createMockOption();
		var mockOption2 = createMockOption();
		var mockOption3 = createMockOption();
		var mockOption4 = createMockOption();
		
		var mockProduct = createMockProduct();
		//Mocked Data:
		//mockProduct1 -> mockSku1 -> mockOption1 
		//						   -> mockOption2 
		//						   -> mockOption3 
		//			   -> mockSku2 -> mockOption3 
		//						   -> mockOption4 
		var skuData1 = {
			skuID = "",
			options = [
				{
					optionID = mockOption1.getOptionID()
				},
				{
					optionID = mockOption2.getOptionID()
				},
				{
					optionID = mockOption3.getOptionID()
				}
			],
			product = {
				productID = mockProduct.getProductID()
			}
		};
		var mockSku1 = createPersistedTestEntity('Sku', skuData1);
		
		var skuData2 = {
			skuID = "",
			options = [
				{
					optionID = mockOption3.getOptionID()
				},
				{
					optionID = mockOption4.getOptionID()
				}
			],
			product = {
				productID = mockProduct.getProductID()
			}
		};
		var mockSku2 = createPersistedTestEntity('Sku', skuData2);
		
		//Testing the result without options passed
		var resultSkusWithoutArgu = mockProduct.getSkusBySelectedOptions();
		assertEquals(2, arrayLen(resultSkusWithoutArgu));
		assertTrue(arrayFind(resultSkusWithoutArgu, mockSku1));
		assertTrue(arrayFind(resultSkusWithoutArgu, mockSku2));
		
		//Testing results with arguments
		var resultSkusWithOption3 = mockProduct.getSkusBySelectedOptions(mockOption3.getOptionID());
		assertEquals(2, arrayLen(resultSkusWithOption3));
		assertTrue(arrayFind(resultSkusWithOption3, mockSku1));
		
		var resultSkusWithOption4 = mockProduct.getSkusBySelectedOptions(mockOption4.getOptionID());
		assertEquals(1, arrayLen(resultSkusWithOption4));
		assertTrue(arrayFind(resultSkusWithOption4, mockSku2));	
	}
	
	public void function getSkuOptionDetailsTest() {
		var mockOptionGroup1 = createMockOptionGroup("optionGroupName1", "ogCodeA");		
		var mockOptionGroup2 = createMockOptionGroup("optionGroupName2", "ogCodeB");
		
		var mockOption1 = createMockOption(mockOptionGroup1.getOptionGroupID());
		var mockOption2 = createMockOption(mockOptionGroup1.getOptionGroupID());
		var mockOption3 = createMockOption(mockOptionGroup2.getOptionGroupID());
		var mockOption4 = createMockOption(mockOptionGroup2.getOptionGroupID());
		
		var productTypeData1 = {
			productTypeID = "",
			systemCode = "merchandise"
		};
		var mockProductType = createPersistedTestEntity('ProductType', productTypeData1);

		var mockProduct1 = createMockProduct(mockProductType.getProductTypeID());
		var mockProduct2 = createMockProduct(mockProductType.getProductTypeID());
		//Mocked Data:
		//mockProduct1 -> mockSku1 -> mockOption1 -> mockOptionGroup1 (ogCodeA)
		//						   -> mockOption2 -> mockOptionGroup1
		//						   -> mockOption3 -> mockOptionGroup2 (ogCodeB)
		//mockProduct2 XX mockSku2 -> mockOption4 -> mockOptionGroup2
		var skuData1 = {
			skuID = "",
			options = [
				{
					optionID = mockOption1.getOptionID()
				},
				{
					optionID = mockOption2.getOptionID()
				},
				{
					optionID = mockOption3.getOptionID()
				}
			],
			product = {
				productID = mockProduct1.getProductID()
			}
		};
		var mockSku1 = createPersistedTestEntity('Sku', skuData1);
		
		var skuData2 = {
			skuID = "",
			options = [
				{
					optionID = mockOption4.getOptionID()
				}
			]
		};
		var mockSku2 = createPersistedTestEntity('Sku', skuData2);
		
		//Testing product with Sku and no Argument passed
		var resultWithSkuNoArgus = mockProduct1.getSkuOptionDetails();
		assertEquals(2, structCount(resultWithSkuNoArgus));
		assertEquals(2, arrayLen(resultWithSkuNoArgus["ogCodeA"]["options"]));
		assertEquals(1, arrayLen(resultWithSkuNoArgus["ogCodeB"]["options"]));
		assertEquals(mockOption1.getOptionID(), resultWithSkuNoArgus["ogCodeA"]["options"][1]['OptionID']);
		
		//Testing product with Sku and the matched Argument passed
		var resultWithSkuWithMatchArgu = mockProduct1.getSkuOptionDetails(mockOption2.getOptionID());
		assertEquals(2, structCount(resultWithSkuWithMatchArgu));
		assertEquals(2, arrayLen(resultWithSkuWithMatchArgu["ogCodeA"]["options"]));
		assertEquals(1, arrayLen(resultWithSkuWithMatchArgu["ogCodeB"]["options"]));
		
		//Testing product with SKU but the argument not matched with mockProduct1
		try {
			mockProduct1.getSkuOptionDetails(mockOption4.getOptionID());
		} catch (any e) {
			//This is a potential bug which FrontEnd won't allow
		}	
				
		//Testing product WITHOUT Sku and no Argument passed
		var resultNoSkuNoArgus = mockProduct2.getSkuOptionDetails();
		assertEquals(0, structCount(resultNoSkuNoArgus));
		
		//Testing product WITHOUT Sku and matched Argument passed
		var resultNoSkuWithMatchArgu = mockProduct2.getSkuOptionDetails(mockOption4.getOptionID());
		assertEquals(0, structCount(resultNoSkuWithMatchArgu));
	}
	
	public void function getCrumbDataTest() {
		var mockPath = "HelloPath";
		
		var siteData = {
			siteID = ""
		};
		var mockSite = createPersistedTestEntity('Site', siteData);
		
		var mockBaseCrumbArray = [
			{
				parentArray = "MockedParentArray"
			}
		];
		
		var mockProduct = createMockProduct();
		
		var result = mockProduct.getCrumbData(mockPath, mockSite.getSiteID(), mockBaseCrumbArray);
		assertEquals("HelloPat", result.filename);
		assertEquals("MockedParentArray", result.parentArray);
	}	

	//End testing: functions that delegate to the default sku
	
	public any function getEstimatedReceivalDetailsTest() {
		var locationData = {
			locationID = ""
		};
		var mockLocation = createPersistedTestEntity('Location', locationData);
		
		var stockData = {
			stockID = "",
			location = {
				locationID = mockLocation.getLocationID()
			}
		};
		var mockStock = createPersistedTestEntity('Stock', stockData);
		
		var mockProduct = createMockProduct();
		
		var skuData = {
			skuID = "",
			stocks = [
				{
					stockID = mockStock.getStockID()
				}
			],
			product = {
				productID = mockProduct.getProductID()
			}
		};
		var mockSku = createPersistedTestEntity('Sku', skuData);
		
		if (!mockSku.hasStock(mockStock)) {
			arrayAppend(mockSku.getStocks(), mockStock);
		}

		var vendorOrderData = {
			vendorOrderID = "",
			estimatedReceivalDateTime = dateAdd('d', -5, now()),
			vendorOrderType = {
				typeID = "444df2dbfde8c38ab64bb21c724d46e0" //votPurchaseType
			},
			vendorORderStatusType = {
				typeID = "6b0f53eb598e42dcb995ed333cc8464a" //vostPartiallyReceived
			}
		};
		var mockVendorOrder = createPersistedTestEntity('VendorOrder', vendorOrderData);
		
		var vendorOrderItemData = {
			vendorOrderItemID = "",
			estimatedReceivalDateTime = dateAdd('d', -3, now()),
			quantity = 1000,
			stock = {
				stockID = mockStock.getStockID()
			},
			vendorOrder = {
				vendorOrderID = mockVendorOrder.getVendorOrderID()
			}			
		};
		var mockVendorOrderItem = createPersistedTestEntity('VendorOrderItem', vendorOrderItemData);
		
		var result = mockProduct.getEstimatedReceivalDetails();
		assertFalse(isNull(result.estimatedReceivals[1].estimatedReceivalDateTime));
		assertEquals(1000, result.skus[mockSku.getSkuID()].estimatedReceivals[1].quantity);
		return mockProduct;
	}
	
	public void function getEstimatedReceivalDates_NoArgument_Test() {
		//Using the mock data from getEstimatedReceivalDetailsTest()
		var mockProduct = getEstimatedReceivalDetailsTest();
		var result = mockProduct.getEstimatedReceivalDates();

		assertFalse(isNull(result[1].estimatedReceivalDateTime));
		assertEquals(1000, result[1].quantity);
	}
	
	public void function getEstimatedReceivalDates_WithArgument_Test() {
		//Copy the mock data from getEstimatedReceivalDetailsTest()
		var locationData = {
			locationID = ""
		};
		var mockLocation = createPersistedTestEntity('Location', locationData);
		
		var stockData = {
			stockID = "",
			location = {
				locationID = mockLocation.getLocationID()
			}
		};
		var mockStock = createPersistedTestEntity('Stock', stockData);
		
		var mockProduct = createMockProduct();
		
		var skuData = {
			skuID = "",
			stocks = [
				{
					stockID = mockStock.getStockID()
				}
			],
			product = {
				productID = mockProduct.getProductID()
			}
		};
		var mockSku = createPersistedTestEntity('Sku', skuData);
		
		if (!mockSku.hasStock(mockStock)) {
			arrayAppend(mockSku.getStocks(), mockStock);
		}

		var vendorOrderData = {
			vendorOrderID = "",
			estimatedReceivalDateTime = dateAdd('d', -5, now()),
			vendorOrderType = {
				typeID = "444df2dbfde8c38ab64bb21c724d46e0" //votPurchaseType
			},
			vendorORderStatusType = {
				typeID = "6b0f53eb598e42dcb995ed333cc8464a" //vostPartiallyReceived
			}
		};
		var mockVendorOrder = createPersistedTestEntity('VendorOrder', vendorOrderData);
		
		var vendorOrderItemData = {
			vendorOrderItemID = "",
			estimatedReceivalDateTime = dateAdd('d', -3, now()),
			quantity = 1000,
			stock = {
				stockID = mockStock.getStockID()
			},
			vendorOrder = {
				vendorOrderID = mockVendorOrder.getVendorOrderID()
			}			
		};
		var mockVendorOrderItem = createPersistedTestEntity('VendorOrderItem', vendorOrderItemData);
		
		//When the only argument stockID
		var resultArguStock = mockProduct.getEstimatedReceivalDates( stockID = mockStock.getStockID() );
		assertFalse(isNull(resultArguStock[1].estimatedReceivalDateTime));
		assertEquals(1000, resultArguStock[1].quantity);
		
		//When the only argument is sku
		var resultArguSku = mockProduct.getEstimatedReceivalDates( skuID = mockSku.getSkuID() );
		assertEquals(1000, resultArguSku[1].quantity);

		//When the only argumeis locationID
		var resultArguLocation = mockProduct.getEstimatedReceivalDates( locationID = mockLocation.getLocationID() );
		assertEquals(1000, resultArguLocation[1].quantity);
		
		//When the argumeits are skuID & locationID
		var resultArgusSkuLocation = mockProduct.getEstimatedReceivalDates( mockSku.getSkuID(), mockLocation.getLocationID() );
		assertFalse(isNull(resultArgusSkuLocation[1].estimatedReceivalDateTime));
		assertEquals(1000, resultArgusSkuLocation[1].quantity);		
	}
	
	public void function getQuantityTest() {
		
		
//		
//		var mockProduct = createMockProduct();
//		var result = mockProduct.getQuantity('QATS');
//		request.debug(result);
	}
   
	// ============ START: Non-Persistent Property Methods =================

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
	
	
	 public void function getDefaultProductImageFilesTest() {
	 	//testing product w/ skus
	 	var mockSku1 = createMockSku("", "", "/mock/SomeImageFilePath");
	 	var mockSku2 = createMockSku("", "", "/mockThe/Image/File2");
	 	var mockSku3 = createMockSku();
	 	var mockSku4 = createMockSku("", "",  "Mockfilefor other product entity");
		
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
		//testing sku w/ existed imageFile. Create the image file first
		createTestFile (expandPath('/Slatwall') & '/assets/images/admin.logo.png', 
						"/custom/assets/images/product/default/admin.logo.png");
		var mockSku1 = createMockSku("", "", "admin.logo.png");
		
		//testing null imageFile
	 	var mockSku2 = createMockSku();
	 	
	 	//testing the invalid imageFile
	 	var mockSku3 = createMockSku("", "", "fakeFile.somefile");
	 	
	 	//testing the sku belong to OTHER product instead of the testing one (mockProduct)
	 	createTestFile (expandPath('/Slatwall') & '/assets/images/favicon.png', 
						"/custom/assets/images/product/default/favicon.png");
	 	var mockSku4 = createMockSku("", "", "favicon.png");
	 	
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
		
		var productData2 = {
			productID = "",
			sku = [{
				skuID = mockSku4.getSkuID()
			}]
		};
		var mockProduct2 = createPersistedTestEntity('Product', productData2);
		
		//Only the imageFile of mockSku1 should be counted.
		var result = mockProduct.getDefaultProductImageFilesCount();
		assertEquals(1, result);
	}
	 
	 //TODO: finish it in another branch
//	 public void function getSalePriceDetailsForSkusTest() {
//	 	
//	 	var mockSku1 = createMockSku("", "CNY", "");
//	 	var mockSku2 = createMockSku("", "USD", "");
//	 	var mockSku3 = createMockSku("","","");
//	 	var mockSku4 = createMockSku("", "", "");
//		
//		var productData = {
//			productID = "",
//			skus = [
//				{
//					skuID = mockSku1.getSkuID()
//				},
//				{
//					skuID = mockSku2.getSkuID()
//				},
//				{
//					skuID = mockSku3.getSkuID()
//				}
//			]
//		};
//		var mockProduct = createPersistedTestEntity('Product', productData);
//		
//		var result = mockProduct.getSalePriceDetailsForSkus();
//	 }
//	 
//	 public void function getSalePriceDetailsForSkusByCurrencyCodeTest() {
//	 	//Todo: Finish the above function, then this one
//	 }
//	 
//	  public void function getQATSTest() {
//	 	//Testing default QATS
//	 	var productData = {
//	 		productID = ""
//	 	};
//	 	var mockProduct = createPersistedTestEntity('Product', productData);
//	 	
//	 	var resultDefault = mockProduct.getQATS();
//	 	assertTrue(resultDefault);
//	 	//TODO: try to modifiy the QATS
//	 }

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

}
