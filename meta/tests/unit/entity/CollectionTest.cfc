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
	public void function setUp() {
		super.setup();

		variables.entityService = request.slatwallScope.getService("hibachiCollectionService");
		variables.entity = variables.entityService.newCollection();
		variables.entity.setCollectionObject('Account');
	}
	
	public void function fixBadCollectionConfigTest(){
		var collectionEntityData = {
			collectionid = '',
			collectionCode = 'RyansAccountOrders'&createUUID(),
			collectionName = 'RyansAccountOrders'&createUUID(),
			collectionConfig = '
				{
					"baseEntityName":"SlatwallAccount",
					"baseEntityAlias":"Account",
					"columns":[
						{
							"propertyIdentifier":""
						},
						{
							"propertyIdentifier":"Account.firstName"
						}
					],
					"joins":[
						{
							"associationName":"orders",
							"alias":"Account_orders"
						}
					],
					"orderBy":[
						{
							"propertyIdentifier":"Account.firstName",
							"direction":"DESC"
						}
					],
					"groupBy":[
						{
							"propertyIdentifier":"accountID"
						}
					],
					"filterGroups":[
						{
							"filterGroup":[
								{
									"propertyIdentifier":"",
									"comparisonOperator":"",
									"value":""
								},
								{
									"logicalOperator":"AND",
									"propertyIdentifier":"",
									"comparisonOperator":"",
									"value":""
								}
							]

						},
						{
							"filterGroup":[
								{
									"propertyIdentifier":"",
									"comparisonOperator":"",
									"value":""
								}
							]

						}
					]

				}
			',
			collectionObject = "SlatwallAccount"
		};
		var collectionEntity = createPersistedTestEntity('collection',collectionEntityData);
		
		var pageRecords = collectionEntity.getPageRecords();
		
		assert(isArray(pageRecords));
		
	}

	public void function addFilterTest(){

		var uniqueNumberForDescription = createUUID();

		var productActiveData = {
			productID = '',
			productName = 'ProductUnitTest',
			productDescription = uniqueNumberForDescription
		};
		//By default Active flag is true.
		var product = createPersistedTestEntity('product', productActiveData);

		var productNotActiveData = {
			productID = '',
			productName = 'ProductUnitTest',
			productDescription = uniqueNumberForDescription,
			activeFlag = 'false'
		};
		var product = createPersistedTestEntity('product', productNotActiveData);

		var myProductCollection = variables.entityService.getProductCollectionList();
		myProductCollection.setDisplayProperties('productName,productDescription');
		myProductCollection.addFilter('productName','ProductUnitTest');
		myProductCollection.addFilter('productDescription',uniqueNumberForDescription);
		var pageRecords = myProductCollection.getPageRecords();

		assertTrue(arrayLen(pageRecords) == 2, "Wrong amount of products returned! Expecting 2 records but returned #arrayLen(pageRecords)#");

		var myProductActiveCollection = variables.entityService.getProductCollectionList();
		myProductActiveCollection.setDisplayProperties('productName,productDescription');
		myProductActiveCollection.addFilter('productName','ProductUnitTest');
		myProductActiveCollection.addFilter('productDescription',uniqueNumberForDescription);
		myProductActiveCollection.addFilter('activeFlag','YES');
		var pageRecords = myProductActiveCollection.getPageRecords();

		assertTrue(arrayLen(pageRecords) == 1, "Wrong amount of products returned! Expecting 1 record but returned #arrayLen(pageRecords)#");

	}	
	
	public void function addFilterToFilterGroupsTest(){

		var uniqueNumberForTest = createUUID();

		var productActiveData = {
			productID = '',
			productName = 'FilterGroupProduct1',
			productCode = "FGP1",
			productDescription = uniqueNumberForTest
		};
		//By default Active flag is true.
		var product = createPersistedTestEntity('product', productActiveData);

		var productNotActiveData = {
			productID = '',
			productName = 'FilterGroupProduct2',
			productCode = "FGP2",
			productDescription = uniqueNumberForTest,
			activeFlag = 'false'
		};
		var product = createPersistedTestEntity('product', productNotActiveData);

		var myProductCollection = variables.entityService.getProductCollectionList();
		myProductCollection.setDisplayProperties('productName,productDescription');
		myProductCollection.addFilter('productDescription',uniqueNumberForTest);
		var pageRecords = myProductCollection.getPageRecords();

		assertTrue(arrayLen(pageRecords) == 2, "Wrong amount of products returned! Expecting 2 records but returned #arrayLen(pageRecords)#");

		myProductCollection = variables.entityService.getProductCollectionList();
		myProductCollection.setDisplayProperties('productName,productDescription');
		myProductCollection.addFilter('productDescription',uniqueNumberForTest);
		myProductCollection.addFilter('productCode','FGP1', "=", "OR", "", "productCodeFilterGroup");
		myProductCollection.addFilter('productCode','FGP2', "=", "OR", "", "productCodeFilterGroup");
		var pageRecords = myProductCollection.getPageRecords();

		assertTrue(arrayLen(pageRecords) == 2, "Wrong amount of products returned! Expecting 2 record but returned #arrayLen(pageRecords)#");

		myProductCollection = variables.entityService.getProductCollectionList();
		myProductCollection.setDisplayProperties('productName,productDescription');
		myProductCollection.addFilter('productDescription',uniqueNumberForTest);
		myProductCollection.addFilter('productCode','FGP1', "=", "OR", "", "productCodeFilterGroup1");
		myProductCollection.addFilter('productCode','FGP2', "=", "OR", "", "productCodeFilterGroup2", "OR");
		var pageRecords = myProductCollection.getPageRecords();
		
		assertTrue(arrayLen(pageRecords) == 2, "Wrong amount of products returned! Expecting 2 record but returned #arrayLen(pageRecords)#");
		
		myProductCollection = variables.entityService.getProductCollectionList();
		myProductCollection.setDisplayProperties('productName,productDescription');
		myProductCollection.addFilter('productDescription',uniqueNumberForTest);
		myProductCollection.addFilter('productCode','FGP1', "=", "OR", "", "productCodeFilterGroup1");
		myProductCollection.addFilter('productCode','FGP2', "=", "OR", "", "productCodeFilterGroup2");//AND is the default filter group comparison operator
		var pageRecords = myProductCollection.getPageRecords();
		
		assertTrue(arrayLen(pageRecords) == 0, "Wrong amount of products returned! Expecting 0 record but returned #arrayLen(pageRecords)#");
		
	}
	public void function addFilterOneToManyTest(){

		var uniqueNumberForDescription = createUUID();

		var productWithoutActiveSkusData = {
			productID = '',
			productName = 'ProductUnitTest',
			productDescription = uniqueNumberForDescription,
			skus = [
				{
					skuID = '',
					skuCode= createUUID(),
					activeFlag = 'false'
				},
				{
					skuID = '',
					skuCode= createUUID(),
					activeFlag = 'false'
				}
			]
		};
		var productWithoutActiveSkus = createPersistedTestEntity('product', productWithoutActiveSkusData);


		var productWithActiveSkusData = {
			productID = '',
			productName = 'ProductUnitTest',
			productDescription = uniqueNumberForDescription,
			skus = [
				{
					skuID = '',
					skuCode= createUUID()
				},
				{
					skuID = '',
					skuCode= createUUID()
				},
				{
					skuID = '',
					skuCode= createUUID()
				},
				{
					skuID = '',
					skuCode= createUUID()
				},
				{
					skuID = '',
					skuCode= createUUID(),
					activeFlag = 'false'
				}
			]
		};
		//By default Active flag is true.
		var SkusInActiveProducts = createPersistedTestEntity('product', productWithActiveSkusData);



		var myProductCollection = variables.entityService.getProductCollectionList();
		myProductCollection.setDisplayProperties('productName,productDescription');
		myProductCollection.addFilter('productName','ProductUnitTest');
		myProductCollection.addFilter('productDescription',uniqueNumberForDescription);
		myProductCollection.addFilter('skus.activeFlag','YES');
		var pageRecords = myProductCollection.getPageRecords();

		assertTrue(arrayLen(pageRecords) == 1, "Wrong amount of products returned! Expecting 1 record but returned #arrayLen(pageRecords)#");

	}

	public void function addFilterManyToOneTest(){

		var uniqueNumberForDescription = createUUID();

		//Inactive product with 2 active skulls
		var productWithoutActiveSkusData = {
			productID = '',
			productName = 'ProductUnitTest',
			productDescription = uniqueNumberForDescription,
			activeFlag='false',
			skus = [
				{
					skuID = '',
					skuCode= createUUID()
				},
				{
					skuID = '',
					skuCode= createUUID()
				}
			]
		};
		var productWithoutActiveSkus = createPersistedTestEntity('product', productWithoutActiveSkusData);

		//Active product with 4 active skuls
		var productWithActiveSkusData = {
			productID = '',
			productName = 'ProductUnitTest',
			productDescription = uniqueNumberForDescription,
			skus = [
				{
					skuID = '',
					skuCode= createUUID()
				},
				{
					skuID = '',
					skuCode= createUUID()
				},
				{
					skuID = '',
					skuCode= createUUID()
				},
				{
					skuID = '',
					skuCode= createUUID()
				},
				{
					skuID = '',
					skuCode= createUUID(),
					activeFlag = 'false'
				}
			]
		};

		var productWithActiveSkus = createPersistedTestEntity('product', productWithActiveSkusData);

		//Get Active Skulls from Active Products

		var mySkuCollection = variables.entityService.getSkuCollectionList();
		mySkuCollection.setDisplayProperties('skuID');
		mySkuCollection.addFilter('activeFlag','YES');
		mySkuCollection.addFilter('product.activeFlag','YES');
		mySkuCollection.addFilter('product.productDescription',uniqueNumberForDescription);
		var pageRecords = mySkuCollection.getPageRecords();

		assertTrue(arrayLen(pageRecords) == 4, "Wrong amount of products returned! Expecting 1 record but returned #arrayLen(pageRecords)#");

	}

	public void function displayPropertyTest(){

		var uniqueNumberForDescription = createUUID();

		var productData = {
			productID = '',
			productName = 'ProductUnitTest',
			productDescription = uniqueNumberForDescription
		};

		var product = createPersistedTestEntity('product', productData);

		var myProductCollection = variables.entityService.getProductCollectionList();
		myProductCollection.setDisplayProperties('productID,productName');
		myProductCollection.addFilter('productDescription',uniqueNumberForDescription);
		var pageRecords = myProductCollection.getPageRecords();


		assertTrue(arraylen(pageRecords) == 1,  "Wrong amount of products returned! Expecting 1 record but returned #arrayLen(pageRecords)#");

		assertTrue(structKeyExists(pageRecords[1], 'productDescription'), "The collection didn't return productDescription property");

		assertTrue(len(trim(pageRecords[1]['productDescription'])) == 0, "The collection returned value for non requested property");

	}

	public void function displayPropertyManyToOneTest(){

		var uniqueNumberForDescription = createUUID();

		var productWithSkusData = {
			productID = '',
			productName = 'ProductUnitTest',
			productDescription = uniqueNumberForDescription,
			skus = [
				{
					skuID = '',
					skuCode= createUUID()
				},
				{
					skuID = '',
					skuCode= createUUID(),
					activeFlag = 'false'
				}
			]
		};
		var productWithSkus = createPersistedTestEntity('product', productWithSkusData);

		var mySkuCollection = variables.entityService.getSkuCollectionList();
		mySkuCollection.setDisplayProperties('skuID,skuCode,product.productName');
		mySkuCollection.addFilter('product.productDescription',uniqueNumberForDescription);
		var pageRecords = mySkuCollection.getPageRecords();

		assertTrue(arraylen(pageRecords) == 2,  "Wrong amount of products returned! Expecting 2 records but returned #arrayLen(pageRecords)#");

		assertTrue(structKeyExists(pageRecords[1], 'product_productName'), "The collection didn't requested property");

		assertFalse(structKeyExists(pageRecords[1], 'product_productDescription'), "The collection returned not requested related property");

		assertTrue(len(trim(pageRecords[1]['product_productName'])) > 0, "The collection didn't returned value for requested property");

	}

	public void function addOrderByTest(){

		var uniqueNumberForDescription = createUUID();

		var productData1 = {
			productID = '',
			productName = 'dProduct',
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData1);

		var productData2 = {
			productID = '',
			productName = 'cProduct',
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData2);

		var productData3 = {
			productID = '',
			productName = 'bProduct',
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData3);

		var productData4 = {
			productID = '',
			productName = 'aProduct',
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData4);


		var myCollection = variables.entityService.getProductCollectionList();
		myCollection.setDisplayProperties('productName');
		myCollection.addFilter('productDescription',uniqueNumberForDescription);
		myCollection.setOrderBy('productName|asc');

		var pageRecords = myCollection.getPageRecords();

		assertTrue(arraylen(pageRecords) == 4,  "Wrong amount of products returned! Expecting 4 records but returned #arrayLen(pageRecords)#");

		assertTrue(pageRecords[1]['productName'] == 'aProduct', "'aProduct' was expected in the 1st record");
		assertTrue(pageRecords[2]['productName'] == 'bProduct', "'bProduct' was expected in the 2nd record");
		assertTrue(pageRecords[3]['productName'] == 'cProduct', "'cProduct' was expected in the 3rd record");
		assertTrue(pageRecords[4]['productName'] == 'dProduct', "'dProduct' was expected in the 4rt record");

	}

	public void function addDisplayAggregateCOUNTTest(){
		var uniqueNumberForDescription = createUUID();

		var productWithSkusData = {
			productID = '',
			productName = 'ProductUnitTest',
			productDescription = uniqueNumberForDescription,
			skus = [
				{
					skuID = '',
					skuCode= createUUID()
				},
				{
					skuID = '',
					skuCode= createUUID()
				}
			]
		};
		var productWithSkus = createPersistedTestEntity('product', productWithSkusData);

		var myCollection = variables.entityService.getProductCollectionList();
		myCollection.setDisplayProperties('productName');
		myCollection.addDisplayAggregate('skus','count','skuCount');
		myCollection.addFilter('productDescription',uniqueNumberForDescription);

		var pageRecords = myCollection.getPageRecords();
		assertTrue(pageRecords[1]['skuCount'] == 2);
	}

	public void function addDisplayAggregateSUMTest(){
		var uniqueNumberForDescription = createUUID();

		var productWithSkusData = {
			productID = '',
			productName = 'ProductUnitTest',
			productDescription = uniqueNumberForDescription,
			skus = [
				{
					skuID = '',
					price = '10',
					skuCode= createUUID()
				},
				{
					skuID = '',
					price = '20',
					skuCode= createUUID()
				},
				{
					skuID = '',
					price = '30',
					skuCode= createUUID()
				}
			]
		};
		var productWithSkus = createPersistedTestEntity('product', productWithSkusData);

		var myCollection = variables.entityService.getProductCollectionList();
		myCollection.setDisplayProperties('productName');
		myCollection.addDisplayAggregate('skus.price','SUM','skuPriceSum');
		myCollection.addFilter('productDescription',uniqueNumberForDescription);

		var pageRecords = myCollection.getPageRecords();
		assertTrue(pageRecords[1]['skuPriceSum'] == '60');
	}

	public void function addDisplayAggregateAVGTest(){
		var uniqueNumberForDescription = createUUID();

		var productWithSkusData = {
			productID = '',
			productName = 'ProductUnitTest',
			productDescription = uniqueNumberForDescription,
			skus = [
				{
					skuID = '',
					price = '10',
					skuCode= createUUID()
				},
				{
					skuID = '',
					price = '20',
					skuCode= createUUID()
				},
				{
					skuID = '',
					price = '30',
					skuCode= createUUID()
				}
			]
		};
		var productWithSkus = createPersistedTestEntity('product', productWithSkusData);

		var myCollection = variables.entityService.getProductCollectionList();
		myCollection.setDisplayProperties('productName');
		myCollection.addDisplayAggregate('skus.price','AVG','skuPriceAvg');
		myCollection.addFilter('productDescription',uniqueNumberForDescription);

		var pageRecords = myCollection.getPageRecords();
		assertTrue(pageRecords[1]['skuPriceAvg'] == '20');
	}

	public void function addDisplayAggregateMINTest(){
		var uniqueNumberForDescription = createUUID();

		var productWithSkusData = {
			productID = '',
			productName = 'ProductUnitTest',
			productDescription = uniqueNumberForDescription,
			skus = [
				{
					skuID = '',
					price = '10',
					skuCode= createUUID()
				},
				{
					skuID = '',
					price = '20',
					skuCode= createUUID()
				},
				{
					skuID = '',
					price = '30',
					skuCode= createUUID()
				}
			]
		};
		var productWithSkus = createPersistedTestEntity('product', productWithSkusData);

		var myCollection = variables.entityService.getProductCollectionList();
		myCollection.setDisplayProperties('productName');
		myCollection.addDisplayAggregate('skus.price','MIN','skuPriceMin');
		myCollection.addFilter('productDescription',uniqueNumberForDescription);

		var pageRecords = myCollection.getPageRecords();
		assertTrue(pageRecords[1]['skuPriceMin'] == '10');
	}

	public void function addDisplayAggregateMAXTest(){
		var uniqueNumberForDescription = createUUID();

		var productWithSkusData = {
			productID = '',
			productName = 'ProductUnitTest',
			productDescription = uniqueNumberForDescription,
			skus = [
			{
				skuID = '',
				price = '10',
				skuCode= createUUID()
			},
			{
				skuID = '',
				price = '20',
				skuCode= createUUID()
			},
			{
				skuID = '',
				price = '30',
				skuCode= createUUID()
			}
				]
		};
		var productWithSkus = createPersistedTestEntity('product', productWithSkusData);

		var myCollection = variables.entityService.getProductCollectionList();
		myCollection.setDisplayProperties('productName');
		myCollection.addDisplayAggregate('skus.price','MAX','skuPriceMax');
		myCollection.addFilter('productDescription',uniqueNumberForDescription);

		var pageRecords = myCollection.getPageRecords();
		assertTrue(pageRecords[1]['skuPriceMax'] == '30');
	}

	public void function addFilterSUMAggregateTest(){

	var uniqueNumberForDescription = createUUID();


	var productWithSkusData1 = {
		productID = '',
		productName = 'ProductUnitTest1',
		productDescription = uniqueNumberForDescription,
		skus = [
		{
			skuID = '',
			price = '10',
			skuCode= createUUID()
		},
		{
			skuID = '',
			price = '20',
			skuCode= createUUID()
		}
			]
	};
	createPersistedTestEntity('product', productWithSkusData1);


	var productWithSkusData2 = {
		productID = '',
		productName = 'ProductUnitTest2',
		productDescription = uniqueNumberForDescription,
		skus = [
		{
			skuID = '',
			price = '10',
			skuCode= createUUID()
		},
		{
			skuID = '',
			price = '20',
			skuCode= createUUID()
		},
		{
			skuID = '',
			price = '30',
			skuCode= createUUID()
		},
		{
			skuID = '',
			price = '40',
			skuCode= createUUID()
		}
			]
	};

	createPersistedTestEntity('product', productWithSkusData2);

	var myProductCollection = variables.entityService.getProductCollectionList();
	myProductCollection.setDisplayProperties('productName');
	myProductCollection.addFilter('skus.price','30', '=', 'AND', 'SUM');
	myProductCollection.addFilter('productDescription',uniqueNumberForDescription);
	var pageRecords = myProductCollection.getPageRecords();

	assert(arraylen(pageRecords) == 1 && pageRecords[1]['productName'] == 'ProductUnitTest1');
}

	public void function addFilterAVGAggregateTest(){

		var uniqueNumberForDescription = createUUID();


		var productWithSkusData1 = {
			productID = '',
			productName = 'ProductUnitTest1',
			productDescription = uniqueNumberForDescription,
			skus = [
				{
					skuID = '',
					price = '10',
					skuCode= createUUID()
				},
				{
					skuID = '',
					price = '20',
					skuCode= createUUID()
				}
			]
		};
		createPersistedTestEntity('product', productWithSkusData1);


		var productWithSkusData2 = {
			productID = '',
			productName = 'ProductUnitTest2',
			productDescription = uniqueNumberForDescription,
			skus = [
				{
					skuID = '',
					price = '10',
					skuCode= createUUID()
				},
				{
					skuID = '',
					price = '20',
					skuCode= createUUID()
				},
				{
					skuID = '',
					price = '30',
					skuCode= createUUID()
				},
				{
					skuID = '',
					price = '40',
					skuCode= createUUID()
				}
			]
		};

		createPersistedTestEntity('product', productWithSkusData2);

		var myProductCollection = variables.entityService.getProductCollectionList();
		myProductCollection.setDisplayProperties('productName');
		myProductCollection.addFilter('skus.price','25', '=', 'AND', 'AVG');
		myProductCollection.addFilter('productDescription',uniqueNumberForDescription);
		var pageRecords = myProductCollection.getPageRecords();
		assert(arraylen(pageRecords) == 1 && pageRecords[1]['productName'] == 'ProductUnitTest2');
	}

	public void function addFilterMINAggregateTest(){

		var uniqueNumberForDescription = createUUID();


		var productWithSkusData1 = {
			productID = '',
			productName = 'ProductUnitTest1',
			productDescription = uniqueNumberForDescription,
			skus = [
				{
					skuID = '',
					price = '10',
					skuCode= createUUID()
				},
				{
					skuID = '',
					price = '20',
					skuCode= createUUID()
				}
			]
		};
		createPersistedTestEntity('product', productWithSkusData1);


		var productWithSkusData2 = {
			productID = '',
			productName = 'ProductUnitTest2',
			productDescription = uniqueNumberForDescription,
			skus = [
				{
					skuID = '',
					price = '5',
					skuCode= createUUID()
				},
				{
					skuID = '',
					price = '10',
					skuCode= createUUID()
				},
				{
					skuID = '',
					price = '15',
					skuCode= createUUID()
				},
				{
					skuID = '',
					price = '20',
					skuCode= createUUID()
				}
			]
		};

		createPersistedTestEntity('product', productWithSkusData2);

		var myProductCollection = variables.entityService.getProductCollectionList();
		myProductCollection.setDisplayProperties('productName');
		myProductCollection.addFilter('skus.price','5', '=', 'AND', 'MIN');
		myProductCollection.addFilter('productDescription',uniqueNumberForDescription);
		var pageRecords = myProductCollection.getPageRecords();
		assert(arraylen(pageRecords) == 1 && pageRecords[1]['productName'] == 'ProductUnitTest2');
	}

	public void function addFilterMAXAggregateTest(){

		var uniqueNumberForDescription = createUUID();


		var productWithSkusData1 = {
			productID = '',
			productName = 'ProductUnitTest1',
			productDescription = uniqueNumberForDescription,
			skus = [
				{
					skuID = '',
					price = '10',
					skuCode= createUUID()
				},
				{
					skuID = '',
					price = '20',
					skuCode= createUUID()
				}
			]
		};
		createPersistedTestEntity('product', productWithSkusData1);


		var productWithSkusData2 = {
			productID = '',
			productName = 'ProductUnitTest2',
			productDescription = uniqueNumberForDescription,
			skus = [
				{
					skuID = '',
					price = '5',
					skuCode= createUUID()
				},
				{
					skuID = '',
					price = '10',
					skuCode= createUUID()
				},
				{
					skuID = '',
					price = '15',
					skuCode= createUUID()
				}
			]
		};

		createPersistedTestEntity('product', productWithSkusData2);

		var myProductCollection = variables.entityService.getProductCollectionList();
		myProductCollection.setDisplayProperties('productName');
		myProductCollection.addFilter('skus.price','20', '=', 'AND', 'MAX');
		myProductCollection.addFilter('productDescription',uniqueNumberForDescription);
		var pageRecords = myProductCollection.getPageRecords();
		assert(arraylen(pageRecords) == 1 && pageRecords[1]['productName'] == 'ProductUnitTest1');
	}

	public void function addFilterCOUNTAggregateTest(){

		var uniqueNumberForDescription = createUUID();


		var productWithSkusData1 = {
			productID = '',
			productName = 'ProductUnitTest1',
			productDescription = uniqueNumberForDescription,
			skus = [
				{
					skuID = '',
					price = '10',
					skuCode= createUUID()
				},
				{
					skuID = '',
					price = '20',
					skuCode= createUUID()
				}
			]
		};
		createPersistedTestEntity('product', productWithSkusData1);


		var productWithSkusData2 = {
			productID = '',
			productName = 'ProductUnitTest2',
			productDescription = uniqueNumberForDescription,
			skus = [
				{
					skuID = '',
					price = '10',
					skuCode= createUUID()
				},
				{
					skuID = '',
					price = '20',
					skuCode= createUUID()
				},
				{
					skuID = '',
					price = '30',
					skuCode= createUUID()
				},
				{
					skuID = '',
					price = '40',
					skuCode= createUUID()
				}
			]
		};

		createPersistedTestEntity('product', productWithSkusData2);

		var myProductCollection = variables.entityService.getProductCollectionList();
		myProductCollection.setDisplayProperties('productName');
		myProductCollection.addFilter('skus','4', '=', 'AND', 'COUNT');
		myProductCollection.addFilter('productDescription',uniqueNumberForDescription);
		var pageRecords = myProductCollection.getPageRecords();

		assert(arraylen(pageRecords) == 1 && pageRecords[1]['productName'] == 'ProductUnitTest2');
	}

	public void function getAggregateHQLTest(){
		makePublic(variables.entity,"getAggregateHQL");
		var propertyIdentifier = "Account.firstName";
		var aggregate = {
			aggregateFunction = "count",
			aggregateAlias = "Account_firstName"
		};
		//addToDebug(lcase(replace(createUUID(),'-','')));
		var aggregateHQL = variables.entity.getAggregateHQL(aggregate,propertyIdentifier);
		//addToDebug(aggregateHQL);
		assertFalse(Compare("COUNT(DISTINCT Account.firstName) as Account_firstName",trim(aggregateHQL)));
	}

	public void function addHQLParamTest(){
		var collectionEntityData = {
			collectionid = '',
			collectionCode = 'RyansAccountOrders',
			collectionName = 'RyansAccountOrders',
			collectionConfig = '{}
			',
			collectionObject = "SlatwallAccount"
		};
		var collectionEntity = createPersistedTestEntity('collection',collectionEntityData);

		collectionEntity.addHQLParam('testKey','testValue');
		var HQLParams = collectionEntity.getHQLParams();

		assertTrue(structKeyExists(HQLParams,'testKey'));
		assertEquals(HQLParams['testKey'],'testValue');
	}

	public void function exactDateFilter(){

		var uniqueNumberForDescription = createUUID();

		var productData1 = {
			productID = '',
			productName = 'dProduct',
			purchaseStartDateTime = DateAdd('d', -10, now()),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData1);

		var productData2 = {
			productID = '',
			productName = 'cProduct',
			purchaseStartDateTime = DateAdd('d', -10, now()),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData2);

		var productData3 = {
			productID = '',
			productName = 'bProduct',
			purchaseStartDateTime = DateAdd('d', -10, now()),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData3);

		var productData4 = {
			productID = '',
			productName = 'aProduct',
			purchaseStartDateTime = DateAdd('d', -10, now()),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData4);

		var collectionEntityData = {
			collectionid = '',
			collectionCode = 'exactDateProducts'&createUUID(),
			collectionName = 'exactDateProducts'&createUUID(),
			collectionObject = "SlatwallProduct",
			collectionConfig = '
				{
				   "baseEntityAlias":"_product",
				   "baseEntityName":"Product",
				   "columns":[
				      {
				         "isDeletable":false,
				         "isExportable":true,
				         "propertyIdentifier":"_product.productID",
				         "ormtype":"id",
				         "isVisible":false,
				         "isSearchable":true,
				         "title":"Product ID",
				         "key":"productID",
				         "sorting":{
				            "active":false,
				            "sortOrder":"asc",
				            "priority":0
				         }
				      }
				   ],
				   "filterGroups":[
				      {
				         "filterGroup":[
				            {
				               "displayPropertyIdentifier":"Purchase Start Date Time",
				               "propertyIdentifier":"_product.purchaseStartDateTime",
				               "comparisonOperator":"between",
				               "breadCrumbs":[
				                  {
				                     "rbKey":"Product",
				                     "entityAlias":"_product",
				                     "cfc":"_product",
				                     "propertyIdentifier":"_product"
				                  }
				               ],
				               "measureType":"d",
				               "measureCriteria":"exactDate",
				               "criteriaNumberOf":"10",
				               "value":"10",
				               "displayValue":"10 Days Ago",
				               "ormtype":"timestamp",
				               "conditionDisplay":"Exact N Day(s) Ago"
				            },
				            {
				               "displayPropertyIdentifier":"Product Description",
				               "propertyIdentifier":"_product.productDescription",
				               "comparisonOperator":"=",
				               "logicalOperator":"AND",
				               "breadCrumbs":[
				                  {
				                     "rbKey":"Product",
				                     "entityAlias":"_product",
				                     "cfc":"_product",
				                     "propertyIdentifier":"_product"
				                  }
				               ],
				               "value":"#uniqueNumberForDescription#",
				               "displayValue":"#uniqueNumberForDescription#",
				               "ormtype":"string",
				               "conditionDisplay":"Equals"
				            }
				         ]
				      }
				   ],
				   "currentPage":1,
				   "pageShow":10
				}
			'
		};
		var collectionEntity = createPersistedTestEntity('collection',collectionEntityData);
		var pageRecords = collectionEntity.getPageRecords();

		assertTrue(arraylen(pageRecords) == 4,  "Wrong amount of products returned! Expecting 4 records but returned #arrayLen(pageRecords)#");


	}

	public void function addHQLParamsFromNestedCollectionTest(){

		var collectionEntityData = {
			collectionid = '',
			collectionCode = 'RyansAccountOrders',
			collectionName = 'RyansAccountOrders',
			collectionConfig = '{}
			',
			collectionObject = "SlatwallAccount"

		};
		var collectionEntity = createPersistedTestEntity('collection',collectionEntityData);
		collectionEntity.getHQLParams()['testKey'] = 'testValue';
		collectionEntity.getHQLParams()['testKey2'] = 'testValue2';

		var collectionEntityData2 = {
			collectionid = '',
			collectionCode = 'RyansAccountOrders2',
			collectionName = 'RyansAccountOrders2',
			collectionConfig = '{}
			',
			baseEntityName = "SlatwallAccount"

		};
		var collectionEntity2 = createPersistedTestEntity('collection',collectionEntityData2);
		collectionEntity2.getHQLParams()['testKey3'] = 'testValue3';
		collectionEntity2.getHQLParams()['testKey4'] = 'testValue4';


		assertEquals(2,structCount(collectionEntity2.getHQLParams()));
		makePublic(collectionEntity2,'addHQLParamsFromNestedCollection');
		collectionEntity2.addHQLParamsFromNestedCollection(collectionEntity.getHQLParams());

		assertEquals(2,structCount(collectionEntity.getHQLParams()));
		assertEquals(4,structCount(collectionEntity2.getHQLParams()));
	}

	public void function getRecordsCountTest(){
		var uniqueNumberForDescription = createUUID();

		var productData1 = {
			productID = '',
			productName = 'ProductUnitTest',
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData1);

		var productData2 = {
			productID = '',
			productName = 'ProductUnitTest',
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData2);


		var myCollection = variables.entityService.getProductCollectionList();
		myCollection.setDisplayProperties('productName');
		myCollection.addFilter('productDescription',uniqueNumberForDescription);
		myCollection.setOrderBy('productName|asc');

		var recordsCount = myCollection.getRecordsCount();

		assertTrue(recordsCount == 2,  "Wrong amount of products returned! Expecting 2 records but returned #recordsCount#");

	}

	public void function getRecordsCountWithGroupByTest(){
		var uniqueNumberForDescription = createUUID();

		var productData1 = {
			productID = '',
			productName = 'ProductUnitTest',
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData1);

		var productData2 = {
			productID = '',
			productName = 'ProductUnitTest',
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData2);

		var myCollection = variables.entityService.getProductCollectionList();
		myCollection.setDisplayProperties('productName');
		myCollection.addFilter('productDescription',uniqueNumberForDescription);
		myCollection.addGroupBy('productName');
		myCollection.setOrderBy('productName|asc');

		var recordsCount = myCollection.getRecordsCount();

		assertTrue(recordsCount == 1,  "Wrong amount of products returned! Expecting 1 record but returned #recordsCount#");

	}

	public void function getRecordsCountWithGroupBy2Test(){
		var uniqueNumberForDescription = createUUID();

		var productData1 = {
			productID = '',
			productName = 'ProductUnitTest',
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData1);

		var productData2 = {
			productID = '',
			productName = 'ProductUnitTest',
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData2);

		var myCollection = variables.entityService.getProductCollectionList();
		myCollection.setDisplayProperties('productID,productName');
		myCollection.addFilter('productDescription',uniqueNumberForDescription);
		myCollection.addGroupBy('productID,productName');
		myCollection.setOrderBy('_product.productName|asc');

		var recordsCount = myCollection.getRecordsCount();

		assertTrue(recordsCount == 2,  "Wrong amount of products returned! Expecting 2 record but returned #recordsCount#");

	}

	public void function getRecordsCountWithAggregateTest(){

		var uniqueNumberForDescription = createUUID();


		var productWithSkusData1 = {
			productID = '',
			productName = 'ProductUnitTest1',
			productDescription = uniqueNumberForDescription,
			skus = [
			{
				skuID = '',
				price = '10',
				skuCode= createUUID()
			},
			{
				skuID = '',
				price = '20',
				skuCode= createUUID()
			}
				]
		};
		createPersistedTestEntity('product', productWithSkusData1);


		var productWithSkusData2 = {
			productID = '',
			productName = 'ProductUnitTest2',
			productDescription = uniqueNumberForDescription,
			skus = [
				{
					skuID = '',
					price = '10',
					skuCode= createUUID()
				},
				{
					skuID = '',
					price = '20',
					skuCode= createUUID()
				},
				{
					skuID = '',
					price = '30',
					skuCode= createUUID()
				},
				{
					skuID = '',
					price = '40',
					skuCode= createUUID()
				}
			]
		};

		var productWithSkusData3 = {
			productID = '',
			productName = 'ProductUnitTest3',
			productDescription = uniqueNumberForDescription,
			skus = [
				{
					skuID = '',
					price = '10',
					skuCode= createUUID()
				},
				{
					skuID = '',
					price = '20',
					skuCode= createUUID()
				}
			]
		};

		createPersistedTestEntity('product', productWithSkusData3);

		var myProductCollection = variables.entityService.getProductCollectionList();
		myProductCollection.setDisplayProperties('productName');
		myProductCollection.addFilter('skus.price','20', '=', 'AND', 'MAX');
		myProductCollection.addFilter('productDescription',uniqueNumberForDescription);
		var pageRecords = myProductCollection.getPageRecords();
		var recordsCount = myProductCollection.getRecordsCount();

		assert(recordsCount == 2, "Wrong amount of products returned! Expecting 2 records but returned #recordsCount#");
	}

	public void function getRecordsTest(){
		var uniqueNumberForDescription = createUUID();

		var productData1 = {
			productID = '',
			productName = 'ProductUnitTest',
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData1);

		var productData2 = {
			productID = '',
			productName = 'ProductUnitTest',
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData2);


		var myCollection = variables.entityService.getProductCollectionList();
		myCollection.setDisplayProperties('productName');
		myCollection.addFilter('productDescription',uniqueNumberForDescription);
		myCollection.setOrderBy('productName|asc');

		var pageRecords = myCollection.getRecords();

		assertTrue(arraylen(pageRecords) == 2,  "Wrong amount of products returned! Expecting 2 records but returned #arrayLen(pageRecords)#");

		//addToDebug(records);
	}

	public void function deserializeCollectionConfigTest(){
		makePublic(variables.entity,'deserializeCollectionConfig');
		var collectionEntityData = {
			collectionid = '',
			collectionCode = 'RyansAccountOrders',
			collectionName = 'RyansAccountOrders',
			collectionConfig = '
				{
					"baseEntityName":"SlatwallAccount",
					"baseEntityAlias":"Account",
					"columns":[
						{
							"propertyIdentifier":"Account_orders"
						},
						{
							"propertyIdentifier":"Account.firstName"
						}
					],
					"joins":[
						{
							"associationName":"orders",
							"alias":"Account_orders"
						}
					],
					"orderBy":[
						{
							"propertyIdentifier":"Account.firstName",
							"direction":"DESC"
						}
					],
					"groupBy":[
						{
							"propertyIdentifier":"accountID"
						}
					],
					"filterGroups":[
						{
							"filterGroup":[
								{
									"propertyIdentifier":"Account.firstName",
									"comparisonOperator":"=",
									"value":"Ryan"
								}
							]

						}
					]

				}
			',
			collectionObject = "SlatwallAccount"
		};
		var collectionEntity = createPersistedTestEntity('collection',collectionEntityData);
		var deserializedCollectionConfig = collectionEntity.deserializeCollectionConfig();
		assertFalse(isJSON(deserializedCollectionConfig));
		assertTrue(isStruct(deserializedCollectionConfig));
	}

	public void function getHQLFilteringWithOtherCollectionTest(){
		var collectionEntityData = {
			collectionid = '',
			collectionCode = 'RyansAccountOrders',
			collectionName = 'RyansAccountOrders',
			collectionObject = 'SlatwallAccount',
			collectionConfig = '
				{
					"baseEntityName":"SlatwallAccount",
					"baseEntityAlias":"_account",
					"columns":[
						{
							"propertyIdentifier":"_account_orders"
						},
						{
							"propertyIdentifier":"_account.firstName"
						}
					],
					"joins":[
						{
							"associationName":"orders",
							"alias":"_account_orders"
						}
					],
					"orderBy":[
						{
							"propertyIdentifier":"_account.firstName",
							"direction":"DESC"
						}
					],
					"groupBy":[
						{
							"propertyIdentifier":"accountID"
						}
					],
					"filterGroups":[
						{
							"filterGroup":[
								{
									"propertyIdentifier":"_account.firstName",
									"comparisonOperator":"=",
									"value":"Ryan"
								}
							]
						}
					]

				}
			',
			baseEntityName = "SlatwallAccount"
		};
		var collectionEntity = createPersistedTestEntity('collection',collectionEntityData);

		var collectionEntityData2 = {
			collectionid = '',
			collectionCode = 'AccountOrders',
			baseEntityName = 'SlatwallAccount',
			collectionConfig = '
				{
					"baseEntityName":"SlatwallAccount",
					"baseEntityAlias":"_account",
					"columns":[
						{
							"propertyIdentifier":"_account.orders"
						}
					],
					"joins":[
						{
							"associationName":"orders",
							"alias":"_account_orders"
						}
					],
					"orderBy":[
						{
							"propertyIdentifier":"_account.lastName",
							"direction":"DESC"
						},
						{
							"propertyIdentifier":"_account.firstName",
							"direction":"DESC"
						}
					],
					"groupBy":[
						{
							"propertyIdentifier":"accountID"
						}
					],
					"filterGroups":[
						{
							"filterGroup":[
								{
									"propertyIdentifier":"_account.firstName",
									"comparisonOperator":"=",
									"value":"Ryan"
								}
							]

						}
					]

				}
			'
		};
		var collectionEntity2 = createTestEntity('collection',collectionEntityData2);

		var collectionEntityHQL = collectionEntity.getHQL();
		var testquery = ORMExecuteQuery(collectionEntityHQL,collectionEntity.gethqlParams());

	}

	/* TODO: need default data for the pagination record to be correct*/
	/*public void function getPageRecordsTest(){
		var collectionBestAcountEmailAddressesData = {
			collectionid = '',
			collectionCode = 'BestOrders',
			baseEntityName="Order",
			collectionConfig = '
				{
					"baseEntityName":"SlatwallOrder",
					"baseEntityAlias":"_Order",
					"columns":[
						{
							"propertyIdentifier":"_Order.orderID"

						}

					]
				}
			'
		};
		var collectionBestAcountEmailAddresses = createPersistedTestEntity('collection',collectionBestAcountEmailAddressesData);
		collectionBestAcountEmailAddresses.setPageRecordsShow(15);
		var pageRecords = collectionBestAcountEmailAddresses.getPageRecords();
		assertEquals(10,arrayLen(pageRecords));
		//addToDebug(pageRecords);
	}*/

	public void function getHQLNestedFilterTest(){

		var collectionEntityData = {
			collectionid = '',
			collectionCode = 'BestAccounts',
			baseEntityName = 'Account',
			collectionConfig = '
				{
					"isDistinct":"true",
					"baseEntityName":"SlatwallAccount",
					"baseEntityAlias":"Account",
					"columns":[
						{
							"propertyIdentifier":"Account.firstName"

						},
						{
							"propertyIdentifier":"Account.lastName"
						},
						{
							"propertyIdentifier":"Account_accountEmailAddresses.emailAddress"
						},
						{
							"propertyIdentifier":"Account_accountEmailAddresses_accountEmailType.type"
						}

					],

					"orderBy":[
						{
							"propertyIdentifier":"Account.firstName",
							"direction":"ASC"
						},
						{
							"propertyIdentifier":"Account.lastName",
							"direction":"ASC"
						}
					],
					"filterGroups":[
						{
							"filterGroup":[
								{
									"propertyIdentifier":"Account.superUserFlag",
									"comparisonOperator":"=",
									"value":"true"
								},
								{
									"logicalOperator":"AND",
									"propertyIdentifier":"Account.superUserFlag",
									"comparisonOperator":"=",
									"value":"false"
								},
								{
									"logicalOperator":"AND",
									"filterGroup":[
										{
											"propertyIdentifier":"Account.superUserFlag",
											"comparisonOperator":"=",
											"value":"true"
										},
										{
											"logicalOperator":"OR",
											"propertyIdentifier":"Account.superUserFlag",
											"comparisonOperator":"=",
											"value":"false"
										},
										{
											"logicalOperator":"AND",
											"filterGroup":[
												{
													"propertyIdentifier":"Account.superUserFlag",
													"comparisonOperator":"=",
													"value":"true"
												},
												{
													"logicalOperator":"OR",
													"propertyIdentifier":"Account.superUserFlag",
													"comparisonOperator":"=",
													"value":"false"
												}
											]
										}
									]
								}
							]
						}
					]

				}
			'
		};

		var collectionEntity = createTestEntity('collection',collectionEntityData);

		//creating a post filter group struct
		var postOrderBy = {
				"propertyIdentifier":"Account_accountEmailAddresses.emailAddress",
				"direction":"DESC"
			};


		var postFilterGroup = {
			logicalOperator = "AND",
			filterGroup = [
				{
					propertyIdentifier = "Account.lastName",
					comparisonOperator = "=",
					value="Marchand"
				}
			]
		};

		//collectionEntity.addPostOrderBy(postOrderBy);
		////addToDebug(collectionEntity.getPostOrderBys());

		//collectionEntity.addPostFilterGroup(postFilterGroup);

		////addToDebug(collectionEntity.getPostFilterGroups());

		//var collectionEntityHQL = collectionEntity.getHQL();

		////addToDebug(collectionEntityHQL);
		////addToDebug(collectionEntity);
		////addToDebug(collectionEntity.gethqlParams());
		//ORMExecuteQuery('FROM SlatwallAccount where accountID = :p1',{p1='2'});

		//var query = collectionEntity.executeHQL();
		//var query = ORMExecuteQuery(collectionEntityHQL,collectionEntity.gethqlParams());

	}

	/*
	public any function getProductSmartList(struct data={}, currentURL="") {
		arguments.entityName = "SlatwallProduct";

		var smartList = getHibachiDAO().getSmartList(argumentCollection=arguments);

		smartList.joinRelatedProperty("SlatwallProduct", "productType");
		smartList.joinRelatedProperty("SlatwallProduct", "defaultSku");
		smartList.joinRelatedProperty("SlatwallProduct", "brand", "left");

		smartList.addKeywordProperty(propertyIdentifier="calculatedTitle", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="brand.brandName", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="productName", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="productCode", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="productType.productTypeName", weight=1);

		return smartList;
	}*/



	public void function getHQLTest_date_in_range(){
		var collectionData = {
			collectionid = '',
			collectionName='dateInRange',
			collectionObject = 'SlatwallAccount',
			collectionConfig = '
				{
				   "baseEntityName":"SlatwallAccount",
				   "baseEntityAlias":"_account",
				   "columns":[
				      {
				         "isDeletable":false,
				         "isExportable":true,
				         "propertyIdentifier":"_account.accountID",
				         "ormtype":"id",
				         "isVisible":false,
				         "isSearchable":true,
				         "title":"accountID",
				         "sorting":{
				            "active":false,
				            "sortOrder":"asc",
				            "priority":0
				         }
				      },
				      {
				         "isDeletable":true,
				         "isExportable":true,
				         "propertyIdentifier":"_account.superUserFlag",
				         "ormtype":"boolean",
				         "isVisible":true,
				         "isSearchable":true,
				         "title":"Super User",
				         "sorting":{
				            "active":false,
				            "sortOrder":"asc",
				            "priority":0
				         }
				      },
				      {
				         "isDeletable":true,
				         "isExportable":true,
				         "propertyIdentifier":"_account.firstName",
				         "ormtype":"string",
				         "isVisible":true,
				         "isSearchable":true,
				         "title":"First Name",
				         "sorting":{
				            "active":false,
				            "sortOrder":"asc",
				            "priority":0
				         }
				      },
				      {
				         "isDeletable":true,
				         "isExportable":true,
				         "propertyIdentifier":"_account.lastName",
				         "ormtype":"string",
				         "isVisible":true,
				         "isSearchable":true,
				         "title":"Last Name",
				         "sorting":{
				            "active":false,
				            "sortOrder":"asc",
				            "priority":0
				         }
				      },
				      {
				         "isDeletable":true,
				         "isExportable":true,
				         "propertyIdentifier":"_account.company",
				         "ormtype":"string",
				         "isVisible":true,
				         "isSearchable":true,
				         "title":"Company",
				         "sorting":{
				            "active":false,
				            "sortOrder":"asc",
				            "priority":0
				         }
				      },
				      {
				         "isDeletable":true,
				         "isExportable":true,
				         "propertyIdentifier":"_account.loginLockExpiresDateTime",
				         "ormtype":"timestamp",
				         "isVisible":true,
				         "isSearchable":true,
				         "title":"Account Locked",
				         "sorting":{
				            "active":false,
				            "sortOrder":"asc",
				            "priority":0
				         }
				      },
				      {
				         "isDeletable":true,
				         "isExportable":true,
				         "propertyIdentifier":"_account.failedLoginAttemptCount",
				         "ormtype":"integer",
				         "isVisible":true,
				         "isSearchable":true,
				         "title":"Failed Login Attempts",
				         "sorting":{
				            "active":false,
				            "sortOrder":"asc",
				            "priority":0
				         }
				      },
				      {
				         "isDeletable":true,
				         "isExportable":true,
				         "propertyIdentifier":"_account.cmsAccountID",
				         "ormtype":"string",
				         "isVisible":true,
				         "isSearchable":true,
				         "title":"CMS Account ID",
				         "sorting":{
				            "active":false,
				            "sortOrder":"asc",
				            "priority":0
				         }
				      },
				      {
				         "isDeletable":true,
				         "isExportable":true,
				         "propertyIdentifier":"_account.remoteEmployeeID",
				         "ormtype":"string",
				         "isVisible":true,
				         "isSearchable":true,
				         "title":"Remote Employee ID",
				         "sorting":{
				            "active":false,
				            "sortOrder":"asc",
				            "priority":0
				         }
				      },
				      {
				         "isDeletable":true,
				         "isExportable":true,
				         "propertyIdentifier":"_account.remoteCustomerID",
				         "ormtype":"string",
				         "isVisible":true,
				         "isSearchable":true,
				         "title":"Remote Customer ID",
				         "sorting":{
				            "active":false,
				            "sortOrder":"asc",
				            "priority":0
				         }
				      },
				      {
				         "isDeletable":true,
				         "isExportable":true,
				         "propertyIdentifier":"_account.remoteContactID",
				         "ormtype":"string",
				         "isVisible":true,
				         "isSearchable":true,
				         "title":"Remote Contact ID",
				         "sorting":{
				            "active":false,
				            "sortOrder":"asc",
				            "priority":0
				         }
				      },
				      {
				         "isDeletable":true,
				         "isExportable":true,
				         "propertyIdentifier":"_account.createdByAccountID",
				         "ormtype":"string",
				         "isVisible":true,
				         "isSearchable":true,
				         "title":"Created By AccountID",
				         "sorting":{
				            "active":false,
				            "sortOrder":"asc",
				            "priority":0
				         }
				      },
				      {
				         "isDeletable":true,
				         "isExportable":true,
				         "propertyIdentifier":"_account.modifiedByAccountID",
				         "ormtype":"string",
				         "isVisible":true,
				         "isSearchable":true,
				         "title":"Modified By AccountID",
				         "sorting":{
				            "active":false,
				            "sortOrder":"asc",
				            "priority":0
				         }
				      },
				      {
				         "title":"Created Date Time",
				         "propertyIdentifier":"_account.createdDateTime",
				         "isVisible":true,
				         "isDeletable":true,
				         "sorting":{
				            "active":false,
				            "sortOrder":"asc",
				            "priority":0
				         }
				      }
				   ],
				   "filterGroups":[
				      {
				         "filterGroup":[
				            {
				               "displayPropertyIdentifier":"Created Date Time",
				               "propertyIdentifier":"_account.createdDateTime",
				               "comparisonOperator":"between",
				               "breadCrumbs":[
				                  {
				                     "rbKey":"Account",
				                     "entityAlias":"_account",
				                     "cfc":"_account",
				                     "propertyIdentifier":"_account"
				                  }
				               ],
				               "value":"1393218000000-1420693199999",
				               "displayValue":"02/24/2014 @ 12:00AM-01/07/2015 @ 11:59PM",
				               "ormtype":"timestamp",
				               "conditionDisplay":"In Range"
				            }
				         ]
				      }
				   ]
				}
			'
		};
		var collectionEntity = createPersistedTestEntity('Collection',collectionData);
		assert(REFind('_account\.createdDateTime BETWEEN :P[a-f0-9]{32} AND :P[a-f0-9]{32}', collectionEntity.getHQL()) > 0);
	}

	public void function getHQLTest_Contains(){
		var collectionBestAcountEmailAddressesData = {
			collectionid = '',
			collectionCode = 'BestAccountEmailAddresses',
			collectionObject="Account",
			collectionConfig = '
				{
					"baseEntityName":"SlatwallAccount",
					"baseEntityAlias":"Account",
					"columns":[{"propertyIdentifier":"Account.accountID"},{"propertyIdentifier":"Account.superUserFlag"},{"propertyIdentifier":"Account.firstName"},{"propertyIdentifier":"Account.lastName"},{"propertyIdentifier":"Account.company"},{"propertyIdentifier":"Account.cmsAccountID"},{"propertyIdentifier":"Account.remoteEmployeeID"},{"propertyIdentifier":"Account.remoteCustomerID"},{"propertyIdentifier":"Account.remoteContactID"},{"propertyIdentifier":"Account.createdByAccountID"},{"propertyIdentifier":"Account.modifiedByAccountID"}]

					"filterGroups":[
						{
							"filterGroup":[
								{
									"propertyIdentifier":"Account.firstName",
									"comparisonOperator":"like",
									"value":"Ryan%"
								}
							]

						}
					]

				}
			'
		};
		var collectionBestAcountEmailAddresses = createPersistedTestEntity('collection',collectionBestAcountEmailAddressesData);

		//addToDebug(collectionBestAcountEmailAddresses.getPageRecords());
	}

	public void function getHQLTest_dateFilter(){
		var collectionBestAcountEmailAddressesData = {
		collectionid = '',
		collectionCode = 'BestAccountEmailAddresses',
		baseEntityName="Account",
		collectionConfig = '{
			  "baseEntityName": "SlatwallAccount",
			  "baseEntityAlias": "Account",
			  "filterGroups": [
			    {
			      "filterGroup": [
			        {
			          "displayPropertyIdentifier": "Super User",
			          "propertyIdentifier": "Account.superUserFlag",
			          "comparisonOperator": "=",
			          "value": "True",
			          "conditionDisplay": "True"
			        },
			        {
			          "displayPropertyIdentifier": "First Name",
			          "propertyIdentifier": "Account.firstName",
			          "comparisonOperator": "=",
			          "value": "Ryan",
			          "logicalOperator": "OR",
			          "conditionDisplay": "Equals"
			        },
			        {
			          "displayPropertyIdentifier": "Created Date Time",
			          "propertyIdentifier": "Account.createdDateTime",
			          "comparisonOperator": "between",
			          "value": "1407556800000-1407643199999",
			          "logicalOperator": "AND",
			          "conditionDisplay": "Date"
			        }
			      ]
			    }
			  ]
			}'
		};

		var collectionBestAcountEmailAddresses = createPersistedTestEntity('collection',collectionBestAcountEmailAddressesData);
		var items = ormExecuteQUery("FROM SlatwallAccount as Account where ( Account.superUserFlag = true OR Account.firstName = 'Ryan' AND Account.createdDateTime BETWEEN 1407556800000 AND 1407643199999 )");
	}

	public void function getHQLTest(){
		/*var collectionBestAcountEmailAddressesData = {
			collectionid = '',
			collectionCode = 'TestAccountEmailAddresses',
			baseEntityName="AccountEmailAddress",
			collectionConfig = '
				{
					"baseEntityName":"SlatwallAccountEmailAddress",
					"baseEntityAlias":"AccountEmailAddress",

					"filterGroups":[
						{
							"filterGroup":[
								{
									"propertyIdentifier":"AccountEmailAddress.verifiedFlag",
									"comparisonOperator":"=",
									"value":"false"
								}
							]

						}
					]

				}
			'
		};
		var collectionBestAcountEmailAddresses = createPersistedTestEntity('collection',collectionBestAcountEmailAddressesData);
		*/

		var collectionEntityData = {
			collectionid = '12',
			collectionCode = 'BestAccounts',
			baseEntityName = 'Sku',
			collectionConfig = '
				{"baseEntityName":"SlatwallAccount","baseEntityAlias":"Account","columns":[{"title":"First Name","propertyIdentifier":"Account.firstName","isVisible":true},{"title":"Last Name","propertyIdentifier":"Account.lastName","isVisible":true},{"title":"Email Address","propertyIdentifier":"Account.primaryEmailAddress.emailAddress","isVisible":true}],"filterGroups":[{"filterGroup":[]}]}
			'
		};

		/*
		,
		{
			"logicalOperator":"AND",
			"filterGroup":[
				{
					"propertyIdentifier":"Account.accountEmailAddresses",
					"collectionCode":"BestAccountEmailAddresses",
					"criteria":"None"
				}
			]
		}*/
		/*//addToDebug(ORMExecuteQuery("SELECT attributeValue
					FROM SlatwallAttributeValue
					WHERE attribute.attributeID = '2c909fea47fa423b014884fd8eea0919'"));*/

		var collectionEntity = createPersistedTestEntity('collection',collectionEntityData);
		//addToDebug(collectionEntity.getPageRecords());



	}

	public void function getHQLTest_exists_in_collection(){



		var collectionEntityData = {
			collectionid = '12',
			collectionCode = 'BestAccounts',
			baseEntityName = 'Sku',
			collectionConfig = '
				{"baseEntityName":"SlatwallAccount","baseEntityAlias":"_account","columns":[{"isExportable":true,"propertyIdentifier":"_account.accountID","ormtype":"id","isVisible":true,"isSearchable":true,"title":"accountID","sorting":{"active":true,"sortOrder":"asc"}},{"isExportable":true,"propertyIdentifier":"_account.superUserFlag","ormtype":"boolean","isVisible":true,"isSearchable":true,"title":"Super User","sorting":{"active":true,"sortOrder":"asc"}},{"isExportable":true,"propertyIdentifier":"_account.firstName","ormtype":"string","isVisible":true,"isSearchable":true,"title":"First Name","sorting":{"active":true,"sortOrder":"asc"}},{"isExportable":true,"propertyIdentifier":"_account.lastName","ormtype":"string","isVisible":true,"isSearchable":true,"title":"Last Name","sorting":{"active":true,"sortOrder":"asc"}},{"isExportable":true,"propertyIdentifier":"_account.company","ormtype":"string","isVisible":true,"isSearchable":true,"title":"Company","sorting":{"active":true,"sortOrder":"asc"}},{"isExportable":true,"propertyIdentifier":"_account.loginLockExpiresDateTime","ormtype":"timestamp","isVisible":true,"isSearchable":true,"title":"Account Locked","sorting":{"active":true,"sortOrder":"asc"}},{"isExportable":true,"propertyIdentifier":"_account.failedLoginAttemptCount","ormtype":"integer","isVisible":true,"isSearchable":true,"title":"Failed Login Attempts","sorting":{"active":true,"sortOrder":"asc"}},{"isExportable":true,"propertyIdentifier":"_account.cmsAccountID","ormtype":"string","isVisible":true,"isSearchable":true,"title":"CMS Account ID","sorting":{"active":true,"sortOrder":"asc"}},{"isExportable":true,"propertyIdentifier":"_account.remoteEmployeeID","ormtype":"string","isVisible":true,"isSearchable":true,"title":"Remote Employee ID","sorting":{"active":true,"sortOrder":"asc"}},{"isExportable":true,"propertyIdentifier":"_account.remoteCustomerID","ormtype":"string","isVisible":true,"isSearchable":true,"title":"Remote Customer ID","sorting":{"active":true,"sortOrder":"asc"}},{"isExportable":true,"propertyIdentifier":"_account.remoteContactID","ormtype":"string","isVisible":true,"isSearchable":true,"title":"Remote Contact ID","sorting":{"active":true,"sortOrder":"asc"}},{"isExportable":true,"propertyIdentifier":"_account.createdByAccountID","ormtype":"string","isVisible":true,"isSearchable":true,"title":"Created By AccountID","sorting":{"active":true,"sortOrder":"asc"}},{"isExportable":true,"propertyIdentifier":"_account.modifiedByAccountID","ormtype":"string","isVisible":true,"isSearchable":true,"title":"Modified By AccountID","sorting":{"active":true,"sortOrder":"asc"}},{"title":"Created Date Time","propertyIdentifier":"_account.createdDateTime","isVisible":true,"sorting":{"active":true,"sortOrder":"asc"}}],
				"filterGroups":[
					{"filterGroup":[
						{
							"propertyIdentifier":"_account.accountAuthentications",
							"ormtype":"timestamp",
							"collectionID":"40288188495db5e3014962161c60001d",
							"criteria":"One",
							"fieldtype":"one-to-many"
						}
					]}
				]}
			'
		};
		var collectionEntity = createPersistedTestEntity('collection',collectionEntityData);
		//addToDebug(collectionEntity.getPageRecords());



	}

	public void function getHQLTest_list(){



		var collectionEntityData = {
			collectionid = '12',
			collectionCode = 'BestAccounts',
			baseEntityName = 'Sku',
			collectionConfig = '
				{"baseEntityName":"SlatwallAccount","baseEntityAlias":"_account","columns":[{"isExportable":true,"propertyIdentifier":"_account.accountID","ormtype":"id","isVisible":true,"isSearchable":true,"title":"accountID","sorting":{"active":true,"sortOrder":"asc"}},{"isExportable":true,"propertyIdentifier":"_account.superUserFlag","ormtype":"boolean","isVisible":true,"isSearchable":true,"title":"Super User","sorting":{"active":true,"sortOrder":"asc"}},{"isExportable":true,"propertyIdentifier":"_account.firstName","ormtype":"string","isVisible":true,"isSearchable":true,"title":"First Name","sorting":{"active":true,"sortOrder":"asc"}},{"isExportable":true,"propertyIdentifier":"_account.lastName","ormtype":"string","isVisible":true,"isSearchable":true,"title":"Last Name","sorting":{"active":true,"sortOrder":"asc"}},{"isExportable":true,"propertyIdentifier":"_account.company","ormtype":"string","isVisible":true,"isSearchable":true,"title":"Company","sorting":{"active":true,"sortOrder":"asc"}},{"isExportable":true,"propertyIdentifier":"_account.loginLockExpiresDateTime","ormtype":"timestamp","isVisible":true,"isSearchable":true,"title":"Account Locked","sorting":{"active":true,"sortOrder":"asc"}},{"isExportable":true,"propertyIdentifier":"_account.failedLoginAttemptCount","ormtype":"integer","isVisible":true,"isSearchable":true,"title":"Failed Login Attempts","sorting":{"active":true,"sortOrder":"asc"}},{"isExportable":true,"propertyIdentifier":"_account.cmsAccountID","ormtype":"string","isVisible":true,"isSearchable":true,"title":"CMS Account ID","sorting":{"active":true,"sortOrder":"asc"}},{"isExportable":true,"propertyIdentifier":"_account.remoteEmployeeID","ormtype":"string","isVisible":true,"isSearchable":true,"title":"Remote Employee ID","sorting":{"active":true,"sortOrder":"asc"}},{"isExportable":true,"propertyIdentifier":"_account.remoteCustomerID","ormtype":"string","isVisible":true,"isSearchable":true,"title":"Remote Customer ID","sorting":{"active":true,"sortOrder":"asc"}},{"isExportable":true,"propertyIdentifier":"_account.remoteContactID","ormtype":"string","isVisible":true,"isSearchable":true,"title":"Remote Contact ID","sorting":{"active":true,"sortOrder":"asc"}},{"isExportable":true,"propertyIdentifier":"_account.createdByAccountID","ormtype":"string","isVisible":true,"isSearchable":true,"title":"Created By AccountID","sorting":{"active":true,"sortOrder":"asc"}},{"isExportable":true,"propertyIdentifier":"_account.modifiedByAccountID","ormtype":"string","isVisible":true,"isSearchable":true,"title":"Modified By AccountID","sorting":{"active":true,"sortOrder":"asc"}},{"title":"Created Date Time","propertyIdentifier":"_account.createdDateTime","isVisible":true,"sorting":{"active":true,"sortOrder":"asc"}}],
				"filterGroups":[
					{"filterGroup":[
						{
							"propertyIdentifier":"_account.firstName",
							"comparisonOperator":"in",
							"value":"Ryan,TestRunnerAccount"
						}
					]}
				]}
			'
		};
		var collectionEntity = createPersistedTestEntity('collection',collectionEntityData);
		//addToDebug(collectionEntity.getPageRecords());



	}

	public void function getHQLTest_keywords_with_filterGroup(){

		//acount data

		var collectionEntityData = {
			collectionid = '12',
			collectionCode = 'keywordAccount',
			collectionObject = 'account',

			collectionConfig = '
				{
				  "baseEntityName": "SlatwallAccount",
				  "baseEntityAlias": "_account",
				  "columns": [
				  	{
				  		"propertyIdentifier":"_account.firstName",
				  		"isSearchable":true,
				  		"ormtype":"string"
				  	},
				  	{
				  		"propertyIdentifier":"_account.lastName",
				  		"isSearchable":true,
				  		"ormtype":"string"
				  	}
				  	,
				  	{
				  		"propertyIdentifier":"_account_accountEmailAddresses",
				  		"aggregate":{
				  			"aggregateFunction":"count",
				  			"aggregateAlias":"emailcount"
				  		}
				  	}
				  ],
				  "joins":[
				  	{
				  		"associationName":"accountEmailAddresses",
						"alias":"_account_accountEmailAddresses"
				  	}
				  ],
				  "filterGroups":[
				  	{
				  		"filterGroup":[
				  			{
								"propertyIdentifier":"_account.firstName",
								"comparisonOperator":"=",
								"value":"Ryan"
				  			}
				  		]
				  	}
				  ],
				  "groupBys":"_account"
				}
			'
		};

		var collectionEntity = createPersistedTestEntity('collection',collectionEntityData);


		collectionEntity.setKeywords('Ryan Marchand');
		//addToDebug(collectionEntity.getHQL());
		addToDebug(collectionEntity.getRecords());
	}

	public void function getHQLTest_keywords_without_filterGroup(){

		//acount data

		var collectionEntityData = {
			collectionid = '12',
			collectionCode = 'keywordAccount',
			collectionObject = 'account',

			collectionConfig = '
				{
				  "baseEntityName": "SlatwallAccount",
				  "baseEntityAlias": "_account",
				  "columns": [
				  	{
				  		"propertyIdentifier":"_account.firstName",
				  		"isSearchable":true,
				  		"ormtype":"string"
				  	},
				  	{
				  		"propertyIdentifier":"_account.lastName",
				  		"isSearchable":true,
				  		"ormtype":"string"
				  	},
				  	{
				  		"propertyIdentifier":"_account.accountEmailAddresses",
				  		"isSearchable":true,
				  		"aggregate":{
				  			"aggregateFunction":"count",
				  			"aggregateAlias":"emailcount"
				  		}
				  	}
				  ]
				}
			'
		};


		var collectionEntity = createPersistedTestEntity('collection',collectionEntityData);
		collectionEntity.setKeywords('Ryan Marchand');
		addToDebug(collectionEntity.getHQL());
	}

	public void function getHQLTest_keywords_without_defaultColumns(){

		//acount data

		var collectionEntityData = {
		collectionid = '12',
		collectionCode = 'keywordAccount',
		collectionObject = 'account',

		collectionConfig = '
						{
						  "baseEntityName": "SlatwallAccount",
						  "baseEntityAlias": "_account",
						  "columns": []
						}
					'
		};


		var collectionEntity = createPersistedTestEntity('collection',collectionEntityData);
		collectionEntity.setKeywords('Miguel Targa');
		addToDebug(collectionEntity.getHQL());
	}

	public void function getHQLTest_keywords_without_ormtype(){

		//acount data

		var collectionEntityData = {
		collectionid = '12',
		collectionCode = 'keywordAccount',
		collectionObject = 'account',

		collectionConfig = '
						{
						  "baseEntityName": "SlatwallAccount",
						  "baseEntityAlias": "_account",
						  "columns": [
							{
								"propertyIdentifier":"_account.firstName",
								"isSearchable":true
							},
							{
								"propertyIdentifier":"_account.lastName",
								"isSearchable":true
							},
							{
								"propertyIdentifier":"_account.accountEmailAddresses",
								"isSearchable":true,
								"aggregate":{
									"aggregateFunction":"count",
									"aggregateAlias":"emailcount"
								}
							}
						  ]
						}
					'
		};


		var collectionEntity = createPersistedTestEntity('collection',collectionEntityData);
		collectionEntity.setKeywords('Ryan Marchand');
		addToDebug(collectionEntity.getHQL());
	}

	public void function getHQLTest_notpersistent(){

		var collectionEntityData = {
			collectionid = '12',
			collectionCode = 'BestAccounts',
			collectionObject = 'orderItem',

			collectionConfig = '
				{
				  "baseEntityName": "SlatwallOrderItem",
				  "baseEntityAlias": "_orderitem",
				  "columns": [
				    {
				      "isDeletable": false,
				      "isExportable": true,
				      "propertyIdentifier": "_orderitem.orderItemID",
				      "ormtype": "id",
				      "isVisible": false,
				      "isSearchable": true,
				      "title": "Order Item ID"
				    },
				    {
				      "isDeletable": false,
				      "isExportable": true,
				      "propertyIdentifier": "_orderitem.price"
				    },
				    {
				      "isDeletable": false,
				      "isExportable": true,
				      "propertyIdentifier": "_orderitem.quantity",
				      "isVisible": false,
				      "isSearchable": true
				    },
				    {
				      "isDeletable": false,
				      "isExportable": true,
				      "propertyIdentifier": "_orderitem.itemTotal",
				      "isVisible": false,
				      "isSearchable": true,
				      "persistent":false
				    }
				  ]
				}
			'
		};
		var orderItem = request.slatwallScope.getService( 'hibachiService' ).newOrderItem();

		var sku = request.slatwallScope.getService( 'skuService' ).newSku();
		sku.setPrice(9.50);
		orderItem.setQuantity(5);
		orderItem.setSku(sku);
		//var test = '';
		//test = orderItem.getitemTotal();
		//addToDebug(test);

		var collectionEntity = createPersistedTestEntity('collection',collectionEntityData);
		//addToDebug(collectionEntity.getPageRecords());
	}

	public void function hasNonPersistentColumn(){

		var collectionEntityData = {
			collectionid = '12',
			collectionCode = 'BestAccounts',
			collectionObject = 'orderItem',

			collectionConfig = '
				{
				  "baseEntityName": "SlatwallOrderItem",
				  "baseEntityAlias": "_orderitem",
				  "columns": [
				    {
				      "isDeletable": false,
				      "isExportable": true,
				      "propertyIdentifier": "_orderitem.orderItemID",
				      "ormtype": "id",
				      "isVisible": false,
				      "isSearchable": true,
				      "title": "Order Item ID"
				    },
				    {
				      "isDeletable": false,
				      "isExportable": true,
				      "propertyIdentifier": "_orderitem.price"
				    },
				    {
				      "isDeletable": false,
				      "isExportable": true,
				      "propertyIdentifier": "_orderitem.quantity",
				      "isVisible": false,
				      "isSearchable": true
				    },
				    {
				      "isDeletable": false,
				      "isExportable": true,
				      "propertyIdentifier": "_orderitem.itemTotal",
				      "persistent":false,
				      "isVisible": false,
				      "isSearchable": true
				    }
				  ]
				}
			'
		};

		var collectionEntity = createPersistedTestEntity('collection',collectionEntityData);
		//MakePublic(collectionEntity,'hasNonPersistentColumn');

		//addToDebug(collectionEntity.getNonPersistentColumn());
	}

	public void function removeFilterTest(){
		var accountCollectionList = variables.entityService.getCollectionList('Account');
		accountCollectionList.addFilter('accountID','test');
		accountCollectionList.addFilter('accountID','tester','=','OR');
		accountCollectionList.addFilter('accountID','testee','=','AND');
		
		accountCollectionList.removeFilter(propertyIdentifier='accountID',value='testee');
		assert(arrayLen(accountCollectionList.getCollectionConfigStruct().filterGroups[1].filterGroup)==2);
		assert(accountCollectionList.getCollectionConfigStruct().filterGroups[1].filterGroup[1].value == 'test');
		assert(accountCollectionList.getCollectionConfigStruct().filterGroups[1].filterGroup[2].value == 'tester');

	}
	
	public void function getHQLTest_emptyFilterGroup(){
		var collectionBestAcountEmailAddressesData = {
			collectionid = '',
			collectionCode = 'BestAccountEmailAddresses'&createUUID(),
			baseEntityName="AccountEmailAddress",
			collectionConfig = '
				 {
					  "baseEntityName": "SlatwallAccount",
					  "baseEntityAlias": "Account",
					  "filterGroups": [
					    {
					      "filterGroup": [
					        {
					          "filterGroup": [
					            {
					              "displayPropertyIdentifier": "Super User",
					              "propertyIdentifier": "Account.superUserFlag",
					              "comparisonOperator": "=",
					              "value": "True"
					            },
					            {
					              "displayPropertyIdentifier": "First Name",
					              "propertyIdentifier": "Account.firstName",
					              "comparisonOperator": "=",
					              "value": "Ryan",
					              "logicalOperator": "OR"
					            }
					          ]
					        },
					        {
					          "filterGroup": [],
					          "logicalOperator": "AND"
					        }
					      ]
					    }
					  ]
					}
			'
		};
		var collectionEntity = createPersistedTestEntity('collection',collectionBestAcountEmailAddressesData);


		//ormexecutequery('FROM SlatwallAccount as Account where   (  (  Account.superUserFlag = "true"  OR Account.firstName = "true" ) )');
		////addToDebug(collectionEntity.getHQL());

	}

	public void function getHQLTest_joins(){

		var collectionEntityData = {
			collectionid = '12',
			collectionCode = 'BestAccounts',
			baseEntityName = 'Sku',
			collectionConfig = '
				{"baseEntityName":"SlatwallAccount","baseEntityAlias":"Account","columns":[{"title":"First Name","propertyIdentifier":"Account.firstName","isVisible":true},{"title":"Last Name","propertyIdentifier":"Account.lastName","isVisible":true},{"title":"Email Address","propertyIdentifier":"Account.primaryEmailAddress.emailAddress","isVisible":true}],"filterGroups":[{"filterGroup":[]}]}
			'
		};

		/*
		,
		{
			"logicalOperator":"AND",
			"filterGroup":[
				{
					"propertyIdentifier":"Account.accountEmailAddresses",
					"collectionCode":"BestAccountEmailAddresses",
					"criteria":"None"
				}
			]
		}*/
		/*//addToDebug(ORMExecuteQuery("SELECT attributeValue
					FROM SlatwallAttributeValue
					WHERE attribute.attributeID = '2c909fea47fa423b014884fd8eea0919'"));*/

		var collectionEntity = createPersistedTestEntity('collection',collectionEntityData);
		//addToDebug(collectionEntity.getPageRecords());

	}

	public void function getSelectionsHQLTest(){
		MakePublic(variables.entity,'getSelectionsHQL');
		var selectionsJSON = '	[
									{
										"propertyIdentifier":"firstName"
									},
									{
										"propertyIdentifier":"accountID",
										"aggregateFunction":"count"
									}
								]';
		var selections = deserializeJSON(selectionsJSON);

		var selectionsHQL = variables.entity.getSelectionsHQL(selections);
		//addToDebug(selectionsHQL);
		assertFalse(Compare("SELECT  new Map( firstName as firstName, accountID as accountID)",trim(selectionsHQL)));

	}

	public void function getFilterHQLTest(){
		MakePublic(variables.entity,'getFilterHQL');
		var filterGroupsJSON = '	[
						{
							"filterGroup":[
								{
									"propertyIdentifier":"Account.superUserFlag",
									"comparisonOperator":"=",
									"value":"true"
								},
								{
									"logicalOperator":"AND",
									"propertyIdentifier":"Account.superUserFlag",
									"comparisonOperator":"=",
									"value":"false"
								}
							]

						},
						{
							"logicalOperator":"OR",
							"filterGroup":[
								{
								"propertyIdentifier":"Account.superUserFlag",
									"comparisonOperator":"=",
									"value":"true"
								},
								{
									"logicalOperator":"OR",
									"propertyIdentifier":"Account.superUserFlag",
									"comparisonOperator":"=",
									"value":"false"
								}
							]
						}
					]';
		var filterGroups = deserializeJSON(filterGroupsJSON);

		var filterHQL = variables.entity.getFilterHQL(filterGroups);
		//addToDebug(filterHQL);
	}

	public void function getFilterGroupHQLTest(){
		MakePublic(variables.entity,'getFilterGroupHQL');
		var filterGroupJSON = '	[
								{
									"propertyIdentifier":"superUserFlag",
									"comparisonOperator":"=",
									"value":"true"
								},
								{
									"logicalOperator":"AND",
									"propertyIdentifier":"superUserFlag",
									"comparisonOperator":"=",
									"value":"false"
								},
								{
									"logicalOperator":"AND",
									"filterGroup":[
										{
											"propertyIdentifier":"Account.superUserFlag",
											"comparisonOperator":"=",
											"value":"true"
										},
										{
											"logicalOperator":"OR",
											"propertyIdentifier":"Account.superUserFlag",
											"comparisonOperator":"=",
											"value":"false"
										},
										{
											"logicalOperator":"AND",
											"filterGroup":[
												{
													"propertyIdentifier":"Account.superUserFlag",
													"comparisonOperator":"=",
													"value":"true"
												},
												{
													"logicalOperator":"OR",
													"propertyIdentifier":"Account.superUserFlag",
													"comparisonOperator":"=",
													"value":"false"
												}
											]
										}
									]
								}
							]';

		var filterGroup = deserializeJSON(filterGroupJSON);

		var filterGroupHQL = variables.entity.getFilterGroupHQL(filterGroup);
	}

	public void function getFilterGroupsHQLTest(){
		MakePublic(variables.entity,'getFilterGroupsHQL');
		var filterGroupsJSON = '	[
						{
							"filterGroup":[
								{
									"propertyIdentifier":"Account.superUserFlag",
									"comparisonOperator":"=",
									"value":"true"
								},
								{
									"logicalOperator":"AND",
									"propertyIdentifier":"Account.superUserFlag",
									"comparisonOperator":"=",
									"value":"false"
								}
							]

						}
					]';
		var filterGroups = deserializeJSON(filterGroupsJSON);

		var filterGroupsHQL = variables.entity.getFilterGroupsHQL(filterGroups);
	}

	public void function getOrderByHQLTest(){
		makePublic(variables.entity,"getOrderByHQL");
		var orderBy = [
			{
				propertyIdentifier="Account.lastName",
				direction="DESC"
			},
			{
				propertyIdentifier="Account.company",
				direction="DESC"
			},
			{
				propertyIdentifier="Account.firstName",
				direction="ASC"
			}
		];

		var orderByHQL = variables.entity.getOrderByHQL(orderBy);
		//not truly false, using Compare to test case-sensitive strings 1 is greater, 0 is equal, -1 is less than. Coldfusion saying 0 is equal, i know awesome! :)
		assertFalse(Compare(" ORDER BY Account.lastName DESC ,Account.company DESC ,Account.firstName ASC ",orderByHQL));

		//addToDebug(orderByHQL);
	}

	public void function addJoinHQLTest(){
		makePublic(variables.entity,'addJoinHQL');
		var joinJSON = '
							{
								"associationName":"primaryEmailAddress",
								"alias":"Account_primaryEmailAddress",
								"joins":[
									{
										"associationName":"accountEmailType",
										"alias":"Account_primaryEmailAddress_AccountEmailType"
									}
								]
							}
						';
		var join = deserializeJSON(joinJSON);
		var joinHQL = variables.entity.addJoinHQL('Account',join);
		assertFalse(Compare(" left join Account.primaryEmailAddress as Account_primaryEmailAddress  left join Account_primaryEmailAddress.accountEmailType as Account_primaryEmailAddress_AccountEmailType ",joinHQL));
	}

	/*public void function HQLTestWithExistingCollection(){

		var CollectionEntityData = {
			collectionid = '',
			collectionCode = 'RyansTen24Accounts',
			collectionName = 'RyansTen24Accounts',
			collectionObject = 'SlatwallAccount',
			collectionConfig = '{
					"baseEntityName":"SlatwallAccount",
					"baseEntityAlias":"Account",
					"columns":[
						{
							"propertyIdentifier":"Account.firstName"
						},
						{
							"propertyIdentifier":"Account.lastName"
						}
					],
					"joins":[
						{
							"associationName":"primaryEmailAddress",
							"alias":"Account_primaryEmailAddress"
						}
					],
					"orderBy":[
						{
							"propertyIdentifier":"Account.firstName",
							"direction":"ASC"
						},
						{
							"propertyIdentifier":"Account.lastName",
							"direction":"ASC"
						}
					],
					"filterGroups":[
						{
							"filterGroup":[
								{
									"propertyIdentifier":"_Account.superUserFlag",
									"comparisonOperator":"=",
									"value":"true"
								},
								{
									"logicalOperator":"OR",
									"propertyIdentifier":"_Account.superUserFlag",
									"comparisonOperator":"=",
									"value":"false"
								}
							]

						},

						{
							"logicalOperator":"AND",
							"filterGroup":[
								{
									"propertyIdentifier":"Account.accountEmailAddresses",
									"collectionCode":"BestAccountEmailAddresses",
									"criteria":"All"
								}
							]
						}
					]

				}'
		};

		var collectionEntity = createPersistedTestEntity('collection',CollectionEntityData);
		//addToDebug(collectionEntity.getHQL());
	}*/

	public void function HQLTestJoins(){

		var CollectionEntityData = {
			collectionid = '',
			collectionCode = 'RyansTen24Product',
			collectionName = 'RyansTen24Product',
			collectionObject = 'Product',
			collectionConfig = '{
					"baseEntityName":"SlatwallProduct",
					"baseEntityAlias":"_product",
					"columns":[
						{
							"propertyIdentifier":"_Product_defaultSku_productBundleGroups"
						}
					],
					"joins":[
						{
							"associationName":"defaultSku",
							"alias":"Product_defaultSku",
							"joins":[
								{
									"associationName":"productBundleGroups",
									"alias":"_Product_defaultSku_productBundleGroups"
								}
							]
						}
					]

				}'
		};

		var collectionEntity = createPersistedTestEntity('collection',CollectionEntityData);
		//addToDebug(collectionEntity.getPageRecords());
	}

	public void function getHQLWithSettingTest(){
		var CollectionEntityData = {
			collectionid = '',
			collectionCode = 'RyansTen24Product',
			collectionName = 'RyansTen24Product',
			collectionObject = 'Content',
			collectionConfig = '{
				"baseEntityName":"SlatwallContent",
				"baseEntityAlias":"_content",
				"columns":[
					{
						"propertyIdentifier":"_content.contentID"
					},
					{
						"propertyIdentifier":"_content.contentTemplateFile",
						"persistent":false,
						"setting":true
					}
				]

			}'
		};

		var collectionEntity = createPersistedTestEntity('collection',CollectionEntityData);
		//addToDebug(collectionEntity.getPageRecords());
	}

	public void function getHQLForCollectionFilterSkuTest(){
		var collectionBestSkuData = {
			collectionid = '',
			collectionCode = 'BestSku#createUUID()#',
			collectionObject="Sku",
			collectionConfig = '
				{
					"baseEntityName":"SlatwallSku",
					"baseEntityAlias":"_sku"
				}
			'
		};
		var collectionBestSkuData = createPersistedTestEntity('collection',collectionBestSkuData);


		var filter = {
						propertyIdentifier="_orderItem.sku.product.skus",
						collectionID=collectionBestSkuData.getCollectionID(),
						criteria="One"
					};
					var propertyIdentifier = 'sku.product.skus';
		var test = request.slatwallScope.getService('hibachiService').getLastEntityNameInPropertyIdentifier('OrderItem',propertyIdentifier);
		var property = request.slatwallScope.getService('hibachiService').getPropertyByEntityNameAndPropertyName(test,listlast(propertyIdentifier,'.'));
		addToDebug(test);
		addToDebug(property);
		variables.entity = variables.entityService.newCollection();
		MakePublic(variables.entity,'getHQLForCollectionFilter');
		variables.entity.setCollectionObject('OrderItem');
		var HQL = variables.entity.getHQLForCollectionFilter(filter);
		addToDebug(HQL);
	}

	public void function getHQLForCollectionFilterManyToManyTest(){
		var collectionPromotionRewardData = {
			collectionid = '',
			collectionCode = 'promotionReward#createUUID()#',
			collectionObject="PromotionReward",
			collectionConfig = '
				{
					"baseEntityName":"SlatwallPromotionReward",
					"baseEntityAlias":"_promotionreward"
				}
			'
		};
		var collectionPromotionReward = createPersistedTestEntity('collection',collectionPromotionRewardData);
		variables.entity = variables.entityService.newCollection();
		variables.entity.setCollectionObject('PromotionReward');

		var filter = {
						propertyIdentifier="_product.defautlSku.product.promotionRewards",
						collectionID=collectionPromotionReward.getCollectionID(),
						criteria="One"
					};

		MakePublic(variables.entity,'getHQLForCollectionFilter');
		var HQL = variables.entity.getHQLForCollectionFilter(filter);
		addToDebug(HQL);

		filter = {
						propertyIdentifier="_product.defautlSku.product.promotionRewards",
						collectionID=collectionPromotionReward.getCollectionID(),
						criteria="NONE"
					};
		HQL = variables.entity.getHQLForCollectionFilter(filter);
		addToDebug(HQL);

		filter = {
						propertyIdentifier="_product.defautlSku.product.promotionRewards",
						collectionID=collectionPromotionReward.getCollectionID(),
						criteria="ALL"
					};
		HQL = variables.entity.getHQLForCollectionFilter(filter);
		addToDebug(HQL);

		filter = {
						propertyIdentifier="_product.defautlSku.product.promotionRewards",
						collectionID=collectionPromotionReward.getCollectionID(),
						criteria="ALL"
					};
		HQL = variables.entity.getHQLForCollectionFilter(filter);
		addToDebug(HQL);
	}

	public void function getHQLForCollectionFilterOneToManyTest(){

		var collectionBestAcountEmailAddressesData = {
			collectionid = '',
			collectionCode = 'BestAccountEmailAddresses#createUUID()#',
			collectionObject="AccountEmailAddress",
			collectionConfig = '
				{
					"baseEntityName":"SlatwallAccountEmailAddress",
					"baseEntityAlias":"_accountemailaddress"

				}
			'
		};
		var collectionBestAcountEmailAddresses = createPersistedTestEntity('collection',collectionBestAcountEmailAddressesData);


		var filter = {
						propertyIdentifier="_account.accountEmailAddresses",
						collectionID=collectionBestAcountEmailAddresses.getCollectionID(),
						criteria="One"
					};

		MakePublic(variables.entity,'getHQLForCollectionFilter');
		var HQL = variables.entity.getHQLForCollectionFilter(filter);
		addToDebug(HQL);

		filter = {
						propertyIdentifier="_account.accountEmailAddresses",
						collectionID=collectionBestAcountEmailAddresses.getCollectionID(),
						criteria="NONE"
					};
		HQL = variables.entity.getHQLForCollectionFilter(filter);
		addToDebug(HQL);

		filter = {
						propertyIdentifier="_account.accountEmailAddresses",
						collectionID=collectionBestAcountEmailAddresses.getCollectionID(),
						criteria="ALL"
					};
		HQL = variables.entity.getHQLForCollectionFilter(filter);
		addToDebug(HQL);

		filter = {
						propertyIdentifier="_account.accountEmailAddresses",
						collectionID=collectionBestAcountEmailAddresses.getCollectionID(),
						criteria="ALL"
					};
		HQL = variables.entity.getHQLForCollectionFilter(filter);
		addToDebug(HQL);
	}

	/*public void function getCollectionObjectParentChildTest(){
		//first a list of collection options is presented to the user
		var collectionEntityData = {
			collectionid = '',
			collectionCode = 'BestAccounts',
			collectionConfig = '{
					"isDistinct":"true",
					"baseEntityName":"SlatwallAccount",
					"baseEntityAlias":"Account",
					"columns":[
						{
							"propertyIdentifier":"Account.firstName"
						},
						{
							"propertyIdentifier":"Account.lastName"
						}
					],
					"joins":[
						{
							"associationName":"primaryEmailAddress",
							"alias":"Account_primaryEmailAddress"
						}
					],
					"orderBy":[
						{
							"propertyIdentifier":"Account.firstName",
							"direction":"ASC"
						},
						{
							"propertyIdentifier":"Account.lastName",
							"direction":"ASC"
						}
					],
					"filterGroups":[
						{
							"filterGroup":[
								{
									"propertyIdentifier":"Account.superUserFlag",
									"comparisonOperator":"=",
									"value":"true"
								},
								{
									"logicalOperator":"OR",
									"propertyIdentifier":"Account.superUserFlag",
									"comparisonOperator":"=",
									"value":"false"
								}
							]

						}
					]

				}'
		};
		var collectionEntity = createTestEntity('collection',collectionEntityData);

		var parentCollectionEntityData = {
			collectionid = '',
			collectionCode = 'RyansAccounts',
			collectionConfig = '{
					"isDistinct":"true",
					"baseEntityName":"SlatwallAccount",
					"baseEntityAlias":"Account",
					"columns":[
						{
							"propertyIdentifier":"Account.firstName"
						},
						{
							"propertyIdentifier":"Account.lastName"
						}
					],
					"joins":[
						{
							"associationName":"primaryEmailAddress",
							"alias":"Account_primaryEmailAddress"
						}
					],
					"orderBy":[
						{
							"propertyIdentifier":"Account.firstName",
							"direction":"ASC"
						},
						{
							"propertyIdentifier":"Account.lastName",
							"direction":"ASC"
						}
					],
					"filterGroups":[
						{
							"filterGroup":[
								{
									"propertyIdentifier":"Account.superUserFlag",
									"comparisonOperator":"=",
									"value":"true"
								},
								{
									"logicalOperator":"OR",
									"propertyIdentifier":"Account.superUserFlag",
									"comparisonOperator":"=",
									"value":"false"
								}
							]

						}
					]

				}'
		};
		var parentCollectionEntity = createTestEntity('collection',parentCollectionEntityData);
		parentCollectionEntity.setParentCollection(collectionEntity);

		var parentOfParentCollectionEntityData = {
			collectionid = '',
			collectionCode = 'RyansTen24Accounts',
			collectionConfig = '{
					"isDistinct":"true",
					"baseEntityName":"SlatwallAccount",
					"baseEntityAlias":"Account",
					"columns":[
						{
							"propertyIdentifier":"Account.firstName"
						},
						{
							"propertyIdentifier":"Account.lastName"
						}
					],
					"joins":[
						{
							"associationName":"primaryEmailAddress",
							"alias":"Account_primaryEmailAddress"
						}
					],
					"orderBy":[
						{
							"propertyIdentifier":"Account.firstName",
							"direction":"ASC"
						},
						{
							"propertyIdentifier":"Account.lastName",
							"direction":"ASC"
						}
					],
					"groupBy":[
						{
							"propertyIdentifier":"accountID"
						}
					],
					"filterGroups":[
						{
							"filterGroup":[
								{
									"propertyIdentifier":"Account.superUserFlag",
									"comparisonOperator":"=",
									"value":"true"
								},
								{
									"logicalOperator":"OR",
									"propertyIdentifier":"Account.superUserFlag",
									"comparisonOperator":"=",
									"value":"false"
								}
							]

						},

						{
							"logicalOperator":"AND",
							"filterGroup":[
								{
									"propertyIdentifier":"Account.accountEmailAddresses",
									"collectionCode":"BestAccountEmailAddresses",
									"criteria":"All"
								}
							]
						}
					]

				}'
		};

		var parentOfParentCollectionEntity = createTestEntity('collection',parentOfParentCollectionEntityData);
		parentOfParentCollectionEntity.setCollectionObject(parentCollectionEntity);


		var result = ORMExecuteQuery(collectionEntity.getHQL(),collectionEntity.getHQLParams());
		//addToDebug(result);
	}*/
}

/*
collectionConfig = '
				{
					"baseEntityName":"SlatwallAccount",
					"baseEntityAlias":"Account",
					"columns":[
						{
							"propertyIdentifier":"Account.firstName"
						},
						{
							"propertyIdentifier":"Account.accountID",
							"aggregate":{
								"aggregateFunction":"count",
								"aggregateAlias":"accountAmount"
							}

						},
						{
							"propertyIdentifier":"Account_primaryEmailAddress.emailAddress"
						},
						{
							"propertyIdentifier":"Account_accountAddresses.accountAddressName"
						},
						{
							"propertyIdentifier":"Account_primaryEmailAddress_AccountEmailType.typeID"
						}
					],
					"joins":[
						{
							"associationName":"primaryEmailAddress",
							"alias":"Account_primaryEmailAddress",
							"joins":[
								{
									"associationName":"accountEmailType",
									"alias":"Account_primaryEmailAddress_AccountEmailType"
								}
							]
						},
						{
							"associationName":"accountAddresses",
							"alias":"Account_accountAddresses"
						}
					],
					"orderBy":[
						{
							"propertyIdentifier":"Account.firstName",
							"direction":"DESC"
						}
					],
					"groupBy":[
						{
							"propertyIdentifier":"accountID"
						}
					],
					"filterGroups":[
						{
							"filterGroup":[
								{
									"propertyIdentifier":"Account.superUserFlag",
									"comparisonOperator":"=",
									"value":"true"
								},
								{
									"logicalOperator":"AND",
									"propertyIdentifier":"Account.superUserFlag",
									"comparisonOperator":"=",
									"value":"false"
								}
							]

						},
						{
							"logicalOperator":"OR",
							"filterGroup":[
								{
									"propertyIdentifier":"Account.superUserFlag",
									"comparisonOperator":"=",
									"value":"true"
								},
								{
									"logicalOperator":"OR",
									"propertyIdentifier":"Account.superUserFlag",
									"comparisonOperator":"=",
									"value":"false"
								}
							]
						}
					]

				}
			'


*/
