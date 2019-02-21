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

		variables.entityService = variables.mockService.getHibachiCollectionServiceMock();
		variables.entity = variables.entityService.newCollection();
		variables.entity.setCollectionObject('Account');
	}

	public boolean function returnFalse(){
		return false;
	}
	
	/**
	* @test
	*/
	public void function convertAliasToPropertyIdentifier_collectionConfigFormat(){
		var alias = "_product_defaultSku.skuID";
		var myCollection = variables.entityService.newCollection();
		myCollection.setCollectionObject('product');
		var propertyIdentifier = myCollection.convertAliasToPropertyIdentifier(alias);
		assertEquals('defaultSku.skuID',propertyIdentifier);
		
	}
	
	/**
	* @test
	*/
	public void function convertAliasToPropertyIdentifier_OutputFormat(){
		var alias = "sku_createdDateTime";
		var myCollection=variables.entityService.newCollection();
		myCollection.setCollectionObject('OrderItem');
		var propertyIdentifier = myCollection.convertAliasToPropertyIdentifier(alias);
		assertEquals('sku.createdDateTime',propertyIdentifier);
	}
	
	/**
	* @test
	*/
	public void function convertRelatedFilterTest(){
		var orderItemCollectionList = request.slatwallScope.getService('HibachiService').getOrderItemCollectionList();
		
		var accountCollectionList = request.slatwallScope.getService('HibachiService').getAccountCollectionList();
		
		accountCollectionList.addFilter('orders.orderID','test','IN');
		accountCollectionList.addFilter('accountID','test','IN');
		
		//property Identifier that orderitem is trying to get
		var propertyIdentifier = 'order.account.accountName';
		
		var filter = accountCollectionList.getCollectionConfigStruct().filterGroups[1].filterGroup[1];
		var filterData = orderItemCollectionList.convertRelatedFilter(propertyIdentifier,filter);
		assertEquals(filterData.propertyIdentifier,'_orderitem_order_account_orders.orderID');
	}
	
	/**
	* @test
	*/
	public void function getManyToOnePropertiesToJoinTest(){
		var collectionEntity = request.slatwallScope.getService('HibachiService').getOrderCollectionList();
		makePublic(collectionEntity,'getManyToOnePropertiesToJoin');
		
		
		var manyToONeProperties = collectionEntity.getManyToOnePropertiesToJoin();
		
		var orderOriginFound = false;
		for(var item in manyToONeProperties){
			if(item.cfc == 'OrderOrigin'){
				orderOriginFound = true;
			}
		}
		assert(orderOriginFound);
	}
	/**
	* @test
	*/
	public void function getManyToOnePropertiesToJoinTest_bymetadata(){
		var collectionEntity = request.slatwallScope.getService('HibachiService').getOrderCollectionList();
		makePublic(collectionEntity,'getManyToOnePropertiesToJoin');
		
		var hibachiService = createObject('Slatwall.model.service.HibachiService');
		hibachiService.getPropertiesByEntityName=function(){
			return [
				{
					cfc="Account",
					fieldtype="many-to-one",
					fkcolumn="assignedAccountID",
					name="assignedAccount",
					hb_permissionRecordRestrictionJoin="true"
				}
			];
			
		};
		
		collectionEntity.setHibachiService(hibachiService);
		
		var manyToONeProperties = collectionEntity.getManyToOnePropertiesToJoin();
		
		
		assertEquals(manyToOneProperties[1].name,hibachiService.getPropertiesByEntityName()[1].name);
		
	}
	
	/**
	* @test
	*/
	public void function convertRelatedFilterGroupTest(){
		var orderItemCollectionList = request.slatwallScope.getService('HibachiService').getOrderItemCollectionList();
		
		var orderCollectionList = request.slatwallScope.getService('HibachiService').getOrderCollectionList();
		
		orderCollectionList.addFilter('orderID','test','IN');
		
		var propertyIdentifier = 'order.orderID';
		var filterGroup = orderCollectionList.getCollectionConfigStruct().filterGroups;
		
		var convertedFilterGroup = orderItemCollectionList.convertRelatedFilterGroup(propertyIdentifier,filterGroup);
		assert(arrayLen(convertedFilterGroup));
		assertEquals(convertedFilterGroup[1].filterGroup[1].propertyIdentifier,'_orderitem_order.orderID');
		
	}
	
	/**
	* @test
	*/
	public void function applyRelatedFilterGroupsTest(){
		var orderItemCollectionList = request.slatwallScope.getService('HibachiService').getOrderItemCollectionList();
		
		var orderCollectionList = request.slatwallScope.getService('HibachiService').getOrderCollectionList();
		
		orderCollectionList.addFilter('orderID','test','IN');
		
		var propertyIdentifier = 'order.referencedOrder.orderID';
		var filterGroups = orderCollectionList.getCollectionConfigStruct().filterGroups;
		orderItemCollectionList.applyRelatedFilterGroups(propertyIdentifier,filterGroups);
		orderItemCollectionList.getRecords();
	}
	

	/**
	* @test
	*/
	public void function sessionBasedFiltersTest(){
		var collectionEntity = variables.entityService.getAccountCollectionList();
		collectionEntity.setDisplayProperties('firstName');
		collectionEntity.addFilter('firstName', '${account.firstName}');

		collectionEntity.getPageRecords();
		var collectionParams = collectionEntity.getHqlParams();
		assert( collectionParams[listFirst(StructKeyList(collectionParams))] ==  'BigBoy');
	}

	/**
	* @test
	*/
	public void function getCollectionReportTest(){
		var collectionEntity = request.slatwallScope.getService('HibachiCollectionService').getAccountCollectionList();
		collectionEntity.setDisplayProperties('firstName');
		collectionEntity.addDisplayAggregate('firstName',"COUNT",'itemCount');
		collectionEntity.addOrderBy('firstName');

		var pageRecords = collectionEntity.getPageRecords();
	}

	/**
	* @test
	*/
	public void function getLeafNodesOnlyTest(){
		//TODO: setup up heirarchy with leaf nodes to assert

		var productTypeCollectionList = request.slatwallScope.getService('hibachiService').getProductTypeCollectionList();
		productTypeCollectionList.setFilterByLeafNodesFlag(true);
		debug(productTypeCollectionList.getHQL());
		debug(productTypeCollectionList.getPageRecords());

		assert(productTypeCollectionList.getFilterByLeafNodesFlag());
	}

	//test that if we trun enforce auth off but also aren't authenticated that only 1st level props are available
	/**
	* @test
	*/
	public void function backendCollectionAuthorizedTest(){
		var skuCollection = variables.entityService.getSkuCollectionList();
		var hibachiAuthenticationServiceFake = new Slatwall.model.service.HibachiAuthenticationService();
		hibachiAuthenticationServiceFake.authenticateCollectionCrudByAccount = returnFalse;
		hibachiAuthenticationServiceFake.authenticateCollectionPropertyIdentifierCrudByAccount=returnFalse;
		request.slatwallScope.setHibachiAuthenticationService(hibachiAuthenticationServiceFake);
		skuCollection.addColumn({propertyIdentifier='product.productName'});
		skuCollection.getPageRecords();
		//test checks to make sure that if the user is public and authentication isn't enforced that all dot chained properties must be declared explicity in authorized Properties via backend
		assert(!arrayFind(skuCollection.getAuthorizedProperties(),'product_productName'));

		//manually adding to the whitelist
		skuCollection.addAuthorizedProperty('product.productName');

		skuCollection.getPageRecords();
		assert(arrayFind(skuCollection.getAuthorizedProperties(),'product_productName'));

		skuCollection.addDisplayProperty('product.productCode');
		assert(arrayFind(skuCollection.getAuthorizedProperties(),'product_productCode'));

	}
	/**
	* @test
	*/
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
							"propertyIdentifier":"firstName",
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

	/**
	* @test
	*/
	public void function applyDataTest_pageShowTest(){
		var collectionEntity = variables.entityService.getAccountCollectionList();

		var data = {};
		data['p:show'] =2;

		collectionEntity.applyData(data);

		assertEquals(collectionEntity.getPageRecordsShow(),2);
	}
	/**
	* @test
	*/
	public void function applyDataTest_pageShowTest_queryString(){
		var collectionEntity = variables.entityService.getAccountCollectionList();

		var queryString = '?p:show=2&p:current=3';

		collectionEntity.applyData(queryString);

		assertEquals(collectionEntity.getPageRecordsShow(),2);
		assertEquals(collectionEntity.getCurrentPageDeclaration(),3);
	}
	/**
	* @test
	*/
	public void function applyDataTest_pageNumericTest_queryString(){
		var collectionEntity = variables.entityService.getAccountCollectionList();

		var queryString = '?p:show=2thisisnotanumber&p:current=3neitheristhis';

		collectionEntity.applyData(queryString);

		assertEquals(collectionEntity.getPageRecordsShow(),10);
		assertEquals(collectionEntity.getCurrentPageDeclaration(),1);
	}
	/**
	* @test
	*/
	public void function applyDataTest_filterTest_queryString(){
		var collectionEntity = variables.entityService.getAccountCollectionList();

		var queryString = '?f:firstName:eq=Ryan';

		collectionEntity.applyData(queryString);
		var filter = collectionEntity.getCollectionConfigStruct().filterGroups[1].filterGroup[1];
		assert(filter.propertyIdentifier == '_account.firstName');
		assert(filter.comparisonOperator == '=');
		assert(filter.value == 'Ryan');
		assert(collectionEntity.getHQL() Contains '_account.firstName = ');
	}
	/**
	* @test
	*/
	public void function applyDataTest_currentPageTest(){
		var collectionEntity = variables.entityService.getAccountCollectionList();
		var data = {};
		data['p:current'] = 72;
		collectionEntity.applyData(data);
		assertEquals(collectionEntity.getCurrentPageDeclaration(),72);
	}
	/**
	* @test
	*/
	public void function applyData_filterEqualsTest(){
		var collectionEntity = variables.entityService.getAccountCollectionList();
		var data = {};
		data['f:firstName:eq']='Ryan';
		collectionEntity.applyData(data);
		var filter = collectionEntity.getCollectionConfigStruct().filterGroups[1].filterGroup[1];
		assert(filter.propertyIdentifier == '_account.firstName');
		assert(filter.comparisonOperator == '=');
		assert(filter.value == 'Ryan');
		assert(collectionEntity.getHQL() Contains '_account.firstName = ');
	}
	/**
	* @test
	*/
	public void function applyDataTest_filterRangeTest_queryString(){
		var collectionEntity = variables.entityService.getSkuCollectionList();

		var queryString = '?r:price=20^100';

		collectionEntity.applyData(queryString);
		
		var filter = collectionEntity.getCollectionConfigStruct().filterGroups[2].filterGroup[1];
		assertEquals(filter.propertyIdentifier,'_sku.price');
		assertEquals(filter.comparisonOperator,'BETWEEN');
		assertEquals(filter.value,'20-100');
		assert(collectionEntity.getHQL() CONTAINS '_sku.price BETWEEN ');
	}
	/**
	* @test
	*/
	public void function applyDataTest_filterStartRangeTest_queryString(){
		var collectionEntity = variables.entityService.getSkuCollectionList();

		var queryString = '?r:price=20^';

		collectionEntity.applyData(queryString);
		var filter = collectionEntity.getCollectionConfigStruct().filterGroups[2].filterGroup[1];
		assertEquals(filter.propertyIdentifier,'_sku.price');
		assertEquals(filter.comparisonOperator,'>=');
		assertEquals(filter.value,'20');
		assert(collectionEntity.getHQL() CONTAINS '_sku.price >= ');

	}
	/**
	* @test
	*/
	public void function applyDataTest_filterEndRangeTest_queryString(){
		var collectionEntity = variables.entityService.getSkuCollectionList();

		var queryString = '?r:price=^100';

		collectionEntity.applyData(queryString);
		var filter = collectionEntity.getCollectionConfigStruct().filterGroups[2].filterGroup[1];
		assertEquals(filter.propertyIdentifier,'_sku.price');
		assertEquals(filter.comparisonOperator,'<=');
		assertEquals(filter.value,'100');
		assert(collectionEntity.getHQL() CONTAINS '_sku.price <= ');
	}
	/**
	* @test
	*/
	public void function applyDataTest_orderByTest_queryString(){
		var collectionEntity = variables.entityService.getSkuCollectionList();

		var queryString = '?orderby=price|DESC,skuName|ASC';
		collectionEntity.applyData(queryString);

		var orderBy = collectionEntity.getCollectionConfigStruct().orderBy;
		assertEquals(orderBy[1].propertyIdentifier,'_sku.price');
		assertEquals(orderBy[1].direction,'DESC');

		assertEquals(orderBy[2].propertyIdentifier,'_sku.skuName');
		assertEquals(orderBy[2].direction,'ASC');
		assert(collectionEntity.getHQL() CONTAINS 'ORDER BY _sku.price DESC ,_sku.skuName ASC');
	}
	/**
	* @test
	*/
	public void function applyData_removeFilterTest_queryString(){
		var collectionEntity = variables.entityService.getSkuCollectionList();
		collectionEntity.addFilter('price',1);
		//make sure filter was added
		assertTrue(arrayLen(collectionEntity.getCollectionConfigStruct().filterGroups[1].filterGroup));
		var queryString = "?fr:price:eq=1";
		collectionEntity.applyData(queryString);
		//make sure filter was removed
		assertFalse(arrayLen(collectionEntity.getCollectionConfigStruct().filterGroups[1].filterGroup));
	}
	/**
	* @test
	*/
	public void function displayPropertyAliasTest(){
		var collectionEntity = variables.entityService.getAccountCollectionList();
		collectionEntity.setDisplayProperties('firstName|MyFirstName,lastName|MyLastName');

		var collectionRecords = collectionEntity.getPageRecords();
		assert( structKeyExists(collectionRecords[1], 'MyFirstName'));
		assert( structKeyExists(collectionRecords[1], 'MyLastName'));

	}
	/**
	* @test
	*/
	public void function addFilterTest(){

		var uniqueNumberForDescription = createUUID();

		var productActiveData = {
			productID = '',
			productName = 'ProductUnitTest',
			productDescription = uniqueNumberForDescription,
			activeFlag=true
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

	/**
	* @test
	*/
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
		debug(myProductCollection.getHQL());
		debug(myProductCollection.getCollectionConfigStruct());
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
	/**
	* @test
	*/
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
					activeFlag = false
				},
				{
					skuID = '',
					skuCode= createUUID(),
					activeFlag = false
				}
			]
		};
		var productWithoutActiveSkus = createPersistedTestEntity('product', productWithoutActiveSkusData);

		//skus will default as active
		var productWithActiveSkusData = {
			productID = '',
			productName = 'ProductUnitTest',
			productDescription = uniqueNumberForDescription,
			skus = [
				{
					skuID = '',
					skuCode= 'aa'&createUUID()
				},
				{
					skuID = '',
					skuCode= 'ab'&createUUID()
				},
				{
					skuID = '',
					skuCode= 'ac'&createUUID()
				},
				{
					skuID = '',
					skuCode= 'ad'&createUUID()
				},
				{
					skuID = '',
					skuCode= 'ae'&createUUID(),
					activeFlag = 'false'
				}
			]
		};
		//By default Active flag is true.
		var SkusInActiveProducts = createPersistedTestEntity('product', productWithActiveSkusData);
		
		var myProductCollection = variables.entityService.getProductCollectionList();
		myProductCollection.setDisplayProperties('productName,productDescription,activeFlag');
		myProductCollection.addFilter('productName','ProductUnitTest');
		myProductCollection.addFilter('productDescription',trim(uniqueNumberForDescription));
		myProductCollection.addFilter('skus.activeFlag','YES');
	
		assertEquals(myProductCollection.getRecordsCount(),1);
		
		var pageRecords = myProductCollection.getPageRecords();


		assertTrue(arrayLen(pageRecords) == 1, "Wrong amount of products returned! Expecting 1 record but returned #arrayLen(pageRecords)#");
	}

	/**
	* @test
	*/
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

	/**
	* @test
	*/
	public void function removeOrderByTest(){
		var productCollectionList = variables.entityService.getCollectionList('Product');
    if (!isNull(productCollectionList.getCollectionConfigStruct())){
			var orderByExists = structKeyExists(productCollectionList.getCollectionConfigStruct(),'orderBy');
	  }

		productCollectionList.addOrderBy('productName|asc');
		assertEquals('YES', arrayLen(productCollectionList.getCollectionConfigStruct().orderBy)==1);
		productCollectionList.addOrderBy('productDescription|DESC');
		assertEquals('YES', arrayLen(productCollectionList.getCollectionConfigStruct().orderBy)==2);
		productCollectionList.removeOrderBy('productName|asc');
		assertEquals('YES', arrayLen(productCollectionList.getCollectionConfigStruct().orderBy)==1);
	}

	/**
	* @test
	*/
	public void function addOrderBy_defaultDirection_Test(){
		var productCollectionList = variables.entityService.getCollectionList('Product');
		if (!isNull(productCollectionList.getCollectionConfigStruct())){
			var orderByExists = structKeyExists(productCollectionList.getCollectionConfigStruct(),'orderBy');
		}

		productCollectionList.addOrderBy('productName');
		assertEquals('YES', arrayLen(productCollectionList.getCollectionConfigStruct().orderBy)==1);
		assertEquals('YES', productCollectionList.getCollectionConfigStruct().orderBy[1].direction == "asc");
	}

	/**
	* @test
	*/
	public void function addFilterManyToOneTest(){

		var uniqueNumberForDescription = createUUID();

		//Inactive product with 2 active skulls
		var productWithoutActiveSkusData = {
			productID = '',
			productName = 'ProductUnitTest',
			productDescription = uniqueNumberForDescription,
			activeFlag=false,
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
			activeFlag=true,
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
		assertTrue(arrayLen(pageRecords) == 4, "Wrong amount of products returned! Expecting 4 records but returned #arrayLen(pageRecords)#");

	}


	/**
	* @test
	*/
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

	/**
	* @test
	*/
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


	/**
	* @test
	*/
	public void function getPrimaryIDsTest(){

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


		var collectionConfigStruct = myCollection.getCollectionConfigStruct();

		var pageRecords = myCollection.getPrimaryIDs(2);
		assertTrue(arraylen(pageRecords) == 2,  "Wrong amount of products returned! Expecting 2 records but returned #arrayLen(pageRecords)#");

		var pageRecords = myCollection.getPrimaryIDs();
		assertTrue(arraylen(pageRecords) == 4,  "Wrong amount of products returned! Expecting 4 records but returned #arrayLen(pageRecords)#");
	}
	
	/**
	* @test
	*/

	public void function getPrimaryIDsTest_workflowCollection(){
		//default data collection
		var myCollection = variables.entityService.getCollection('2c92808362e398b10162e4c489b5000x');

		var collectionConfigStruct = myCollection.getCollectionConfigStruct();

		var pageRecords = myCollection.getPrimaryIDs(2);
		
		if(arraylen(pageRecords)){
			assert(!structKeyExists(pageRecords[1],'failedCollection'));
		}

	}


	public void function addOrderByAliasTest(){

		var myCollection = variables.entityService.getProductCollectionList();
		myCollection.setDisplayProperties('productName');
		myCollection.setOrderBy('productName|asc');

		var collectionConfigStruct = myCollection.getCollectionConfigStruct();

		assertTrue(collectionConfigStruct.orderBy[1]['propertyIdentifier'] == '_product.productName', "Wrong Order by Alias! Expecting '_product.productName' but returned #collectionConfigStruct.orderBy[1]['propertyIdentifier']#");
	}


	public void function addOrderByAlias2Test(){

		var myCollection = variables.entityService.getProductCollectionList();
		myCollection.setDisplayProperties('productName');
		myCollection.setOrderBy('_product.productName|asc');

		var collectionConfigStruct = myCollection.getCollectionConfigStruct();

		assertTrue(collectionConfigStruct.orderBy[1]['propertyIdentifier'] == '_product.productName', "Wrong Order by Alias! Expecting '_product.productName' but returned #collectionConfigStruct.orderBy[1]['propertyIdentifier']#");
	}

	public void function addOrderByAliasFromRelatedObjectTest(){

		var myCollection = variables.entityService.getProductCollectionList();
		myCollection.setDisplayProperties('productName');
		myCollection.setOrderBy('brand.brandName|asc');

		var collectionConfigStruct = myCollection.getCollectionConfigStruct();

		assertTrue(collectionConfigStruct.orderBy[1]['propertyIdentifier'] == '_product_brand.brandName', "Wrong Order by Alias! Expecting '_product_brand.brandName' but returned #collectionConfigStruct.orderBy[1]['propertyIdentifier']#");
	}

	/**
	* @test
	*/
	public void function addDisplayAggregateCOUNTTest(){
		var uniqueNumberForDescription = createUUID();

		var productWithSkusData = {
			productID = '',
			productName = 'ProductUnitTest',
			productCode = 'ProductUnitTest'&createUUID(),
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


	/**
	* @test
	*/
	public void function addDisplayAggregateSUMTest(){
		var uniqueNumberForDescription = createUUID();

		var productWithSkusData = {
			productID = '',
			productName = 'ProductUnitTest',
			productCode = 'ProductUnitTest'&createUUID(),
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

	/**
	* @test
	*/
	public void function addDisplayAggregateAVGTest(){
		var uniqueNumberForDescription = createUUID();

		var productWithSkusData = {
			productID = '',
			productName = 'ProductUnitTest',
			productCode = 'ProductUnitTest'&createUUID(),
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

	/**
	* @test
	*/
	public void function addDisplayAggregateMINTest(){
		var uniqueNumberForDescription = createUUID();

		var productWithSkusData = {
			productID = '',
			productName = 'ProductUnitTest',
			productCode = 'ProductUnitTest'&createUUID(),
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

	/**
	* @test
	*/
	public void function addDisplayAggregateMAXTest(){
		var uniqueNumberForDescription = createUUID();

		var productWithSkusData = {
			productID = '',
			productName = 'ProductUnitTest',
			productCode = 'ProductUnitTest'&createUUID(),
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

	// Tests to check if orderBy createdDateTime is excluded in case of hasDisplayAggregate is true when orderBy applied or not applied
	/**
	* @test
	*/
	public void function check_DateTime_when_hasAggregate_true_no_orderBy_added_for_DisplayAggregateSUMTest(){
		var uniqueNumberForDescription = createUUID();

		var productWithSkusData = {
			productID = '',
			productName = 'ProductUnitTest',
			productCode = 'ProductUnitTest'&createUUID(),
			productDescription = uniqueNumberForDescription,
			skus = [
				{
					skuID = '',
					price = '-100',
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
		assertFalse(FindNoCase("createdDateTime",myCollection.getHQL()));
	}

	/**
	* @test
	*/
	public void function check_DateTime_when_hasAggregate_true_orderBy_added_for_DisplayAggregateSUMTest(){
		var uniqueNumberForDescription = createUUID();

		var productWithSkusData = {
			productID = '',
			productName = 'ProductUnitTest',
			productCode = 'ProductUnitTest'&createUUID(),
			productDescription = uniqueNumberForDescription,
			skus = [
				{
					skuID = '',
					price = '-100',
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
		myCollection.addOrderBy('productDescription|asc');
		assertFalse(FindNoCase("createdDateTime",myCollection.getHQL()));
	}

	/**
	* @test
	*/
	public void function check_DateTime_when_hasAggregate_true_no_orderBy_added_for_DisplayAggregateCOUNTTest(){
		var uniqueNumberForDescription = createUUID();

		var productWithSkusData = {
			productID = '',
			productName = 'ProductUnitTest',
			productCode = 'ProductUnitTest'&createUUID(),
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
		assertFalse(FindNoCase("createdDateTime",myCollection.getHQL()));
	}

	/**
	* @test
	*/
	public void function check_DateTime_when_hasAggregate_true_orderBy_added_for_DisplayAggregateCOUNTTest(){
		var uniqueNumberForDescription = createUUID();

		var productWithSkusData = {
			productID = '',
			productName = 'ProductUnitTest',
			productCode = 'ProductUnitTest'&createUUID(),
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
		myCollection.addOrderBy('productDescription|asc');
		assertFalse(FindNoCase("createdDateTime",myCollection.getHQL()));
	}

	/**
	* @test
	*/
	public void function check_DateTime_when_hasAggregate_true_no_orderBy_added_for_DisplayAggregateAVGTest(){
		var uniqueNumberForDescription = createUUID();

		var productWithSkusData = {
			productID = '',
			productName = 'ProductUnitTest',
			productCode = 'ProductUnitTest'&createUUID(),
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
		assertFalse(FindNoCase("createdDateTime",myCollection.getHQL()));
	}

	/**
	* @test
	*/
	public void function check_DateTime_when_hasAggregate_true_orderBy_added_for_DisplayAggregateAVGTest(){
		var uniqueNumberForDescription = createUUID();

		var productWithSkusData = {
			productID = '',
			productName = 'ProductUnitTest',
			productCode = 'ProductUnitTest'&createUUID(),
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
		myCollection.addOrderBy('productDescription|asc');
		assertFalse(FindNoCase("createdDateTime",myCollection.getHQL()));
	}

	/**
	* @test
	*/
	public void function check_DateTime_when_hasAggregate_true_no_orderBy_added_for_DisplayAggregateMINTest(){
		var uniqueNumberForDescription = createUUID();

		var productWithSkusData = {
			productID = '',
			productName = 'ProductUnitTest',
			productCode = 'ProductUnitTest'&createUUID(),
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
		assertFalse(FindNoCase("createdDateTime",myCollection.getHQL()));
	}

	/**
	* @test
	*/
	public void function check_DateTime_when_hasAggregate_true_orderBy_added_for_DisplayAggregateMINTest(){
		var uniqueNumberForDescription = createUUID();

		var productWithSkusData = {
			productID = '',
			productName = 'ProductUnitTest',
			productCode = 'ProductUnitTest'&createUUID(),
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
		//will throw and not add
		try{
			myCollection.addOrderBy('productDesc|asc');
		}catch(any e){}
		assertFalse(FindNoCase("createdDateTime",myCollection.getHQL()));
	}

	/**
	* @test
	*/
	public void function check_DateTime_when_hasAggregate_true_no_orderBy_added_for_DisplayAggregateMAXTest(){
		var uniqueNumberForDescription = createUUID();

		var productWithSkusData = {
			productID = '',
			productName = 'ProductUnitTest',
			productCode = 'ProductUnitTest'&createUUID(),
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
		assertFalse(FindNoCase("createdDateTime",myCollection.getHQL()));
	}

	/**
	* @test
	*/
	public void function check_DateTime_when_hasAggregate_true_orderBy_added_for_DisplayAggregateMAXTest(){
		var uniqueNumberForDescription = createUUID();

		var productWithSkusData = {
			productID = '',
			productName = 'ProductUnitTest',
			productCode = 'ProductUnitTest'&createUUID(),
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
		myCollection.addOrderBy('productDescription|asc');
		assertFalse(FindNoCase("createdDateTime",myCollection.getHQL()));
	}


	/**
	* @test
	*/
	public void function verify_cached_collectionList_present(){
		var uniqueNumberForDescription = createUUID();

		var productWithSkusData = {
			productID = '',
			productName = 'ProductUnitTest',
			productCode = 'ProductUnitTest'&createUUID(),
			productDescription = uniqueNumberForDescription,
			skus = [
				{
					skuID = '',
					price = '300',
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

		var myCollection = productWithSkus.getskusCollectionlist();
		myCollection.setDisplayProperties('skuName');
		myCollection.addDisplayAggregate('price','SUM','priceSum');
		myCollection.addFilter('skuDescription',uniqueNumberForDescription);
		myCollection.addOrderBy('skuCode|DESC');

		var myCollectionNew = productWithSkus.getskusCollectionlist();
		myCollectionNew.setDisplayProperties('skuCode');
		myCollectionNew.addDisplayAggregate('price','AVG','priceAvg');
		myCollectionNew.addFilter('skuName',uniqueNumberForDescription);
		myCollectionNew.addOrderBy('skuCode|DESC');
		// assertions for mycollection
		assertTrue(FindNoCase("_sku.skuCode as skuCode",myCollection.getHQL()));
		asserttrue(FindNoCase("AVG(COALESCE(_sku.price,0)) as priceAvg",myCollection.getHQL()));
		assertTrue(FindNoCase("_sku.skuCode desc",myCollection.getHQL()));

		// assertions for mycollectionNew
		assertTrue(FindNoCase("_sku.skuCode as skuCode",myCollectionNew.getHQL()));
		asserttrue(FindNoCase("AVG(COALESCE(_sku.price,0)) as priceAvg",myCollectionNew.getHQL()));
		assertTrue(FindNoCase("_sku.skuCode desc",myCollectionNew.getHQL()));
	}

	/**
	* @test
	*/
	public void function verify_new_collectionList_created(){
		var uniqueNumberForDescription = createUUID();

		var productWithSkusData = {
			productID = '',
			productName = 'ProductUnitTest',
			productCode = 'ProductUnitTest'&createUUID(),
			productDescription = uniqueNumberForDescription,
			skus = [
				{
					skuID = '',
					price = '300',
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

		var myCollection = productWithSkus.getskusCollectionlist();
		myCollection.setDisplayProperties('skuName');
		myCollection.addDisplayAggregate('price','SUM','priceSum');
		myCollection.addFilter('skuDescription',uniqueNumberForDescription);

		var myCollectionNew = productWithSkus.getskusCollectionlist(isNew=true);
		myCollectionNew.setDisplayProperties('skuCode');
		myCollectionNew.addDisplayAggregate('price','AVG','priceAvg');
		myCollectionNew.addFilter('skuName',uniqueNumberForDescription);

		// assertions for mycollection
		assertTrue(FindNoCase("_sku.skuName as skuName",myCollection.getHQL()));
		asserttrue(FindNoCase("SUM(COALESCE(_sku.price,0)) as priceSum",myCollection.getHQL()));

		// assertions for mycollectionNew
		assertTrue(FindNoCase("_sku.skuCode as skuCode",myCollectionNew.getHQL()));
		asserttrue(FindNoCase("AVG(COALESCE(_sku.price,0)) as priceAvg",myCollectionNew.getHQL()));
	}

	/**
	* @test
	*/
	public void function verify_duplicate_propertyIdentifier_for_orderBy_donot_exists(){

		var uniqueNumberForDescription = createUUID();

		var productWithSkusData = {
			productID = '',
			productName = 'ProductUnitTest',
			productCode = 'ProductUnitTest'&createUUID(),
			productDescription = uniqueNumberForDescription,
			skus = [
				{
					skuID = '',
					price = '300',
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

		var myCollection = productWithSkus.getskusCollectionlist();
		myCollection.setDisplayProperties('skuName');
		myCollection.addOrderBy('skuCode|asc');
		myCollection.addOrderBy('skuCode|desc');
		assertTrue(FindNoCase("_sku.skuCode desc",myCollection.getHQL())); // contains skuDesc|desc in hql
		assertFalse(FindNoCase("_sku.skuCode asc",myCollection.getHQL())); // donot contains skuDesc|asc in hql
	}

	/**
	* @test
	*/
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
		var product1 = createPersistedTestEntity('product', productWithSkusData1);
	
	
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
	
		var product2 = createPersistedTestEntity('product', productWithSkusData2);
	
		var myProductCollection = variables.entityService.getProductCollectionList();
		myProductCollection.setDisplayProperties('productName');
		myProductCollection.addFilter('skus.price','30', '=', 'AND', 'SUM');
		myProductCollection.addFilter('productID','#product1.getProductID()#,#product2.getProductID()#','IN');
		
		var recordCount = myProductCollection.getRecordsCount();
		assert(recordCount > 0);
		var pageRecords = myProductCollection.getPageRecords();
		assert(arraylen(pageRecords) == 1 && pageRecords[1]['productName'] == 'ProductUnitTest1');
	}

	/**
	* @test
	*/
	public void function addFilterAVGAggregateTest(){

		var uniqueNumberForDescription = createUUID();


		var productWithSkusData1 = {
			productID = '',
			productName = 'ProductUnitTest1',
			productCode = 'ProductUnitTest'&createUUID(),
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

	/**
	* @test
	*/
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

	/**
	* @test
	*/
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

	/**
	* @test
	*/
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

	/**
	* @test
	*/
	public void function getPropertyIdentifierAliasTest(){
		var propertyIdentifier = 'productName';

		var collectionData = {
			collectionID="",
			collectionObject='Product'
		};
		var collectionEntity = createPersistedTestEntity('collection',collectionData);
		assertEquals(collectionEntity.getPropertyIdentifierAlias(propertyIdentifier),'_product.productName');
		assertEquals(collectionEntity.getPropertyIdentifierAlias('brand.brandName'),'_product_brand.brandName');
		assertEquals(collectionEntity.getPropertyIdentifierAlias('skus'),'_product_skus');
	}

	/**
	* @test
	*/
	public void function getAggregateHQLTest(){
		makePublic(variables.entity,"getAggregateHQL");
		var column={
			propertyIdentifier = "firstName",
			aggregate = {
				aggregateFunction = "count",
				aggregateAlias = "Account_firstName"
			}
		};

		//addToDebug(lcase(replace(createUUID(),'-','')));
		var aggregateHQL = variables.entity.getAggregateHQL(column);
		//addToDebug(aggregateHQL);
		assertFalse(Compare("COUNT( firstName) as Account_firstName",trim(aggregateHQL)));
	}

	/**
	* @test
	*/

	public void function getAggregateHQLTest_hasObject(){
		makePublic(variables.entity,"getAggregateHQL");
		var column={
			propertyIdentifier = "accountAuthentications",
			aggregate = {
				aggregateFunction = "count",
				aggregateAlias = "Account_accountAuthentications"
			}
		};

		//addToDebug(lcase(replace(createUUID(),'-','')));
		var aggregateHQL = variables.entity.getAggregateHQL(column);
		//addToDebug(aggregateHQL);
		assertFalse(Compare("COUNT(DISTINCT accountAuthentications) as Account_accountAuthentications",trim(aggregateHQL)));
	}

	/**
	* @test
	*/
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

	/**
	* @test
	*/
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

	/**
	* @test
	*/

	public void function mergeParentCollectionFiltersTest(){


		var uniqueSkuName = createUUID();

		//Active product with 4 active skuls
		var productWithActiveSkusData = {
			productID = '',
			productName = 'ProductUnitTest',
			skus = [
				{
					skuID = '',
					skuName = uniqueSkuName,
					skuCode = createUUID(),
					activeFlag = true
				},
				{
					skuID = '',
					skuName = uniqueSkuName,
					skuCode = createUUID(),
					activeFlag = true
				},
				{
					skuID = '',
					skuName = uniqueSkuName,
					skuCode = createUUID(),
					activeFlag = true
				},
				{
					skuID = '',
					skuName = uniqueSkuName,
					skuCode = createUUID(),
					activeFlag = false
				},
				{
					skuID = '',
					skuName = 'Other Name',
					skuCode = createUUID(),
					activeFlag = false
				}
			]
		};

		var productWithActiveSkus = createPersistedTestEntity('product', productWithActiveSkusData);

		//Create Parent Colleciton

		var mySkuParentCollection = variables.entityService.getSkuCollectionList();
		mySkuParentCollection.setDisplayProperties('skuID,skuName,skuCode,activeFlag');
		mySkuParentCollection.addFilter('skuName',uniqueSkuName);
		var pageRecords = mySkuParentCollection.getPageRecords();

		assertTrue(arrayLen(pageRecords) == 4, "Wrong amount of products returned! Expecting 4 records but returned #arrayLen(pageRecords)#");

		persistTestEntity(mySkuParentCollection, {});



		//Create New collection
		var mySkuCollection = variables.entityService.getSkuCollectionList();

		mySkuCollection.setParentCollection(mySkuParentCollection);
		mySkuCollection.setDisplayProperties('skuID,skuName,skuCode,activeFlag');
		mySkuCollection.addFilter('activeFlag',false);
		var pageRecords = mySkuCollection.getPageRecords();
		assertTrue(arrayLen(pageRecords) == 1, "Wrong amount of products returned! Expecting 1 record but returned #arrayLen(pageRecords)#");

	}

	/**
	* @test
	*/
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

    /**
    * @test
    **/

    public void function removeJoinsNotInUseTest(){
        var collectionEntityData2 = {
            collectionid = '',
            collectionCode = 'AccountOrders',
            baseEntityName = 'SlatwallAccount',
            collectionObject = 'Account',
            collectionConfig = '
				{
					"baseEntityName":"SlatwallAccount",
					"baseEntityAlias":"_account",
					"columns":[
						{
							"propertyIdentifier":"_account.firstName"
						},
						{
							"propertyIdentifier":"_account.lastName"
						},
						{
							"propertyIdentifier":"_account_primaryEmailAddress.emailAddress"
						}
					],
					"joins":[
						{
							"associationName":"orders",
							"alias":"_account_orders"
						},
						{
							"associationName":"primaryEmailAddress",
							"alias":"_account_primaryEmailAddress"
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
									"value":"Miguel"
								},
								{
									"logicalOperator":"AND",
									"propertyIdentifier":"_account.LastName",
									"comparisonOperator":"=",
									"value":"Targa"
								},
								{
									"logicalOperator":"AND",
									"filterGroup":[
										{
											"propertyIdentifier":"_account.superUserFlag",
											"comparisonOperator":"=",
											"value":"true"
										},
										{
											"logicalOperator":"OR",
											"propertyIdentifier":"_account.superUserFlag",
											"comparisonOperator":"=",
											"value":"false"
										},
										{
											"logicalOperator":"AND",
											"filterGroup":[
												{
													"propertyIdentifier":"_account_primaryEmailAddress.emailAddress",
													"comparisonOperator":"=",
													"value":"miguel.targa@ten24web.com"
												},
												{
													"logicalOperator":"OR",
													"propertyIdentifier":"_account_primaryEmailAddress.emailAddress",
													"comparisonOperator":"=",
													"value":"miguel@targa.me"
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
        var collectionEntity2 = createTestEntity('collection',collectionEntityData2);
        var joinsHQL = trim(collectionEntity2.getJoinHQL());

        assert(joinsHQL == "left join _account.primaryEmailAddress as _account_primaryEmailAddress", 'Bad Join HQL: "#joinsHQL#", expected: "left join _account.primaryEmailAddress as _account_primaryEmailAddress"');
    }

	/**
	* @test
	*/
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

	/**
	* @test
	*/
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
		myCollection.setReportFlag(1);
		myCollection.setDisplayProperties('productName');
		myCollection.addFilter('productDescription',uniqueNumberForDescription);
		myCollection.addGroupBy('productName');
		myCollection.setOrderBy('productName|asc');
		
		var recordsCount = myCollection.getRecordsCount();

		assertTrue(recordsCount == 1,  "Wrong amount of products returned! Expecting 1 record but returned #recordsCount#");

	}

	/**
	* @test
	*/
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
		myCollection.setOrderBy('productName|asc');
		var recordsCount = myCollection.getRecordsCount();

		assertTrue(recordsCount == 2,  "Wrong amount of products returned! Expecting 2 record but returned #recordsCount#");

	}

	/**
	* @test
	*/
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

	/**
	* @test
	*/
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

	/**
	* @test
	*/
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

	/**
	* @test
	*/
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
							"propertyIdentifier":"_account_orders",
							"aggregate":{
								"aggregateFunction":"COUNT",
								"aggregateAlias":"ordersCount"
							}
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

	/**
	* @test
	*/
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



	/**
	* @test
	*/
	public void function getHQLTest_date_in_range_epoch(){
		var collectionData = {
			collectionid = '',
			collectionName='dateInRangeEpoch',
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


    /**
    * @test
    */
    public void function betweenDateTest(){

        var uniqueSkuName = createUUID();

        var productWithActiveSkusData = {
            productID = '',
            productName = 'ProductUnitTest',
            skus = [
            {
                skuID = '',
                skuName = uniqueSkuName,
                skuCode = 'sku_code_1',
                activeFlag = true
            },
            {
                skuID = '',
                skuName = uniqueSkuName,
                skuCode = 'sku_code_2',
                activeFlag = true
            },
            {
                skuID = '',
                skuName = uniqueSkuName,
                skuCode = 'sku_code_3',
                activeFlag = true
            },
            {
                skuID = '',
                skuName = uniqueSkuName,
                skuCode = 'sku_code_4',
                activeFlag = false
            },
            {
                skuID = '',
                skuName = uniqueSkuName,
                skuCode = 'sku_code_5',
                activeFlag = false
            }
                ]
        };

        var productWithActiveSkus = createPersistedTestEntity('product', productWithActiveSkusData);

        var startDateTime = createDateTime(2018, 8, 3, 0, 0, 0);

        for(var i = 1; i <= arrayLen(productWithActiveSkus.getSkus()); i++){
            productWithActiveSkus.getSkus()[i].setCreatedDateTime(dateAdd('d', i, startDateTime));
        }

        var collectionData = {
            collectionid = '',
            collectionName='dateInRangeEpoch',
            collectionObject = 'SlatwallSku',
            collectionConfig = '
				{
				   "baseEntityName":"Sku",
				   "baseEntityAlias":"_sku",
				   "columns":[
				      {
				         "isDeletable":false,
				         "isExportable":true,
				         "propertyIdentifier":"_sku.skuID",
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
				         "propertyIdentifier":"_sku.skuCode",
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
				         "propertyIdentifier":"_sku.createdDateTime",
				         "ormtype":"string",
				         "isVisible":true,
				         "isSearchable":true,
				         "title":"First Name",
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
				               "propertyIdentifier":"_sku.createdDateTime",
				               "comparisonOperator":"between",
				               "value":"1533303982000-1533563182000",
				               "ormtype":"timestamp",
				               "conditionDisplay":"In Range"
				            },
				            {
				               "propertyIdentifier":"_sku.skuName",
				               "comparisonOperator":"=",
				               "value":"#uniqueSkuName#",
				               "ormtype":"string",
				               "logicalOperator":"AND"
				            }
				         ]
				      }
				   ]
				}
			'
        };
        var collectionEntity = createPersistedTestEntity('Collection',collectionData);

        assert(arraylen(collectionEntity.getRecords()) == 3);
    }



    /**
    * @test
    */
    public void function betweenDateTimeTest(){



        var uniqueSkuName = createUUID();


        var productWithActiveSkusData = {
            productID = '',
            productName = 'ProductUnitTest',
            skus = [
            {
                skuID = '',
                skuName = uniqueSkuName,
                skuCode = 'sku_code_1',
                activeFlag = true
            },
            {
                skuID = '',
                skuName = uniqueSkuName,
                skuCode = 'sku_code_2',
                activeFlag = true
            },
            {
                skuID = '',
                skuName = uniqueSkuName,
                skuCode = 'sku_code_3',
                activeFlag = true
            },
            {
                skuID = '',
                skuName = uniqueSkuName,
                skuCode = 'sku_code_4',
                activeFlag = false
            },
            {
                skuID = '',
                skuName = uniqueSkuName,
                skuCode = 'sku_code_5',
                activeFlag = false
            }
                ]
        };

        var productWithActiveSkus = createPersistedTestEntity('product', productWithActiveSkusData);

        var startDateTime = createDateTime(2018, 8, 3, 0, 0, 0);


        for(var i = 1; i <= arrayLen(productWithActiveSkus.getSkus()); i++){

            productWithActiveSkus.getSkus()[i].setCreatedDateTime(dateAdd('d', i, dateAdd('h', i, startDateTime)));
        }

        var collectionData = {
            collectionid = '',
            collectionName='dateInRangeEpoch',
            collectionObject = 'SlatwallSku',
            collectionConfig = '
				{
				   "baseEntityName":"Sku",
				   "baseEntityAlias":"_sku",
				   "columns":[
				      {
				         "isDeletable":false,
				         "isExportable":true,
				         "propertyIdentifier":"_sku.skuID",
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
				         "propertyIdentifier":"_sku.skuCode",
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
				         "propertyIdentifier":"_sku.createdDateTime",
				         "ormtype":"string",
				         "isVisible":true,
				         "isSearchable":true,
				         "title":"First Name",
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
				               "propertyIdentifier":"_sku.createdDateTime",
				               "comparisonOperator":"between",
				               "value":"1533254400000-1533513600000",
				               "displayValue":"02/24/2014 @ 12:00AM-01/07/2015 @ 11:59PM",
				               "ormtype":"timestamp",
				               "conditionDisplay":"In Range"
				            },
				            {
				               "propertyIdentifier":"_sku.skuName",
				               "comparisonOperator":"=",
				               "value":"#uniqueSkuName#",
				               "ormtype":"string",
				               "logicalOperator":"AND"
				            }
				         ]
				      }
				   ]
				}
			'
        };
        var collectionEntity = createPersistedTestEntity('Collection',collectionData);
        assert(arrayLen(collectionEntity.getRecords()) == 2);
    }

	/**
	* @test
	*/
	public void function getHQLTest_date_in_range_gregorian(){
		var collectionData = {
			collectionid = '',
			collectionName='dateInRangeGregorian',
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
				               "value":"1/1/2015-1/1/2017",
				               "displayValue":"01/01/2015 - 01/01/2017 ",
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
		//addToDebug("HQL: #collectionEntity.getHQL()#");
	}

	/**
	* @test
	*/
	public void function getHQLTest_Contains(){
		var collectionBestAcountEmailAddressesData = {
			collectionid = '',
			collectionCode = 'BestAccountEmailAddresses'&createUUID(),
			collectionObject="Account",
			collectionConfig = '
				{
					"baseEntityName":"SlatwallAccount",
					"baseEntityAlias":"Account",
					"columns":[{"propertyIdentifier":"Account.accountID"},{"propertyIdentifier":"Account.superUserFlag"},{"propertyIdentifier":"Account.firstName"},{"propertyIdentifier":"Account.lastName"},{"propertyIdentifier":"Account.company"},{"propertyIdentifier":"Account.cmsAccountID"},{"propertyIdentifier":"Account.remoteEmployeeID"},{"propertyIdentifier":"Account.remoteCustomerID"},{"propertyIdentifier":"Account.remoteContactID"},{"propertyIdentifier":"Account.createdByAccountID"},{"propertyIdentifier":"Account.modifiedByAccountID"}],

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

	/**
	* @test
	*/
	public void function getHQLTest_dateFilter(){
		var collectionBestAcountEmailAddressesData = {
		collectionid = '',
		collectionCode = 'BestAccountEmailAddresses'&createUUID(),
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

	/**
	* @test
	*/
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

	/**
	* @test
	*/
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

	/**
	* @test
	*/
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

	/**
	* @test
	*/
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

	/**
	* @test
	*/
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

	/**
	* @test
	*/
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

	/**
	* @test
	*/
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

	/**
	* @test
	*/
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

	/**
	* @test
	*/
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

	/**
	* @test
	*/
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

	/**
	* @test
	*/
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

	/**
	* @test
	*/
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

	/**
	* @test
	*/
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

	/**
	* @test
	*/
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

	/**
	* @test
	*/
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

	/**
	* @test
	*/
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

	/**
	* @test
	*/
	public void function getOrderByHQLTest(){
		makePublic(variables.entity,"getOrderByHQL");
		var orderBy = [
			{
				propertyIdentifier="_account.lastName",
				direction="DESC"
			},
			{
				propertyIdentifier="_account.company",
				direction="DESC"
			},
			{
				propertyIdentifier="_account.firstName",
				direction="ASC"
			}
		];

		var orderByHQL = variables.entity.getOrderByHQL(orderBy);
		//not truly false, using Compare to test case-sensitive strings 1 is greater, 0 is equal, -1 is less than. Coldfusion saying 0 is equal, i know awesome! :)
		assertFalse(Compare(" ORDER BY _account.lastName DESC ,_account.company DESC ,_account.firstName ASC ",orderByHQL));

		//addToDebug(orderByHQL);
	}

	/**
	* @test
	*/
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

	/**
	* @test
	*/
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

	/**
	* @test
	*/
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

	/**
	* @test
	*/
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

	/**
	* @test
	*/
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

	/**
	* @test
	*/
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


// ************ New test cases added by Mindfire ************//

	/**
	* @test
	*/
	public void function applyDataTest_pageShowTest_for_default_pageshow_value(){
		var collectionEntity = variables.entityService.getAccountCollectionList();
		var data = {};

		collectionEntity.applyData(data);
		assertEquals(collectionEntity.getPageRecordsShow(),10);
	}

	/**
	* @test
	*/
	public void function applyDataTest_pageShowTest_queryString_default_currentPageDeclaration(){
		var collectionEntity = variables.entityService.getAccountCollectionList();

		var queryString = '?p:show=2';

		collectionEntity.applyData(queryString);

		assertEquals(collectionEntity.getPageRecordsShow(),2);
		assertEquals(collectionEntity.getCurrentPageDeclaration(),1);
	}

	
	/**
	* @test
	*/
	public void function applyDataTest_filterTest_queryString_incorrent_firstname(){
		var collectionEntity = variables.entityService.getAccountCollectionList();

		var queryString = '?f:firstName:eq=Ryan';
		collectionEntity.applyData(queryString);
		var filter = collectionEntity.getCollectionConfigStruct().filterGroups[1].filterGroup[1];
		assert(filter.propertyIdentifier == '_account.firstName');
		assert(filter.comparisonOperator == '=');
		assertfalse(filter.value == 'Mindfire');
		assert(collectionEntity.getHQL() Contains '_account.firstName = ');
	}

	

	/**
	* @test
	*/
	public void function applyDataTest_filterTest_queryString_incorrent_propertyIdentifire(){
		var collectionEntity = variables.entityService.getAccountCollectionList();

		var queryString = '?f:firstName:eq=Ryan';
		collectionEntity.applyData(queryString);
		var filter = collectionEntity.getCollectionConfigStruct().filterGroups[1].filterGroup[1];
		assertfalse(filter.propertyIdentifier == '_account.lastName');
		assert(filter.comparisonOperator == '=');
		assert(filter.value == 'Ryan');
		assert(collectionEntity.getHQL() Contains '_account.firstName = ');
	}

	

	/**
	* @test
	*/
	public void function applyDataTest_pageShowTest_for_negative_pageshow_value(){
		var collectionEntity = variables.entityService.getAccountCollectionList();
		var data = {};

		data['p:show'] = -2;
		collectionEntity.applyData(data);

		assertEquals(collectionEntity.getPageRecordsShow(),10); // Returns defult values for negative values in Pagination.
	}


	/**
	* @test
	*/
	public void function applyDataTest_pageShowTest_queryString_default_pageshow(){
		var collectionEntity = variables.entityService.getAccountCollectionList();

		var queryString = '?p:current=3';

		collectionEntity.applyData(queryString);

		assertEquals(collectionEntity.getPageRecordsShow(),10);
		assertEquals(collectionEntity.getCurrentPageDeclaration(),3);
	}


	/**
	* @test
	*/
	public void function applyDataTest_pageShowTest_queryString_default_pageshow_default_currentPageDeclaration(){
		var collectionEntity = variables.entityService.getAccountCollectionList();

		var queryString = '';
		collectionEntity.applyData(queryString);

		assertEquals(collectionEntity.getPageRecordsShow(),10);
		assertEquals(collectionEntity.getCurrentPageDeclaration(),1);
	}

	

	/**
	* @test
	*/
	public void function applyDataTest_filterTest_queryString_incorrent_comparisonOperator(){
		var collectionEntity = variables.entityService.getAccountCollectionList();

		var queryString = '?f:firstName:eq=Ryan';
		collectionEntity.applyData(queryString);
		var filter = collectionEntity.getCollectionConfigStruct().filterGroups[1].filterGroup[1];
		assert(filter.propertyIdentifier == '_account.firstName');
		assertfalse(filter.comparisonOperator == '>');
		assert(filter.value == 'Ryan');
		assert(collectionEntity.getHQL() Contains '_account.firstName = ');
	}

	

	/**
	* @test
	*/
	public void function applyDataTest_filterTest_queryString_incorrent_hql(){
		var collectionEntity = variables.entityService.getAccountCollectionList();

		var queryString = '?f:firstName:eq=Ryan';
		collectionEntity.applyData(queryString);
		var filter = collectionEntity.getCollectionConfigStruct().filterGroups[1].filterGroup[1];
		assert(filter.propertyIdentifier == '_account.firstName');
		assert(filter.comparisonOperator == '=');
		assert(filter.value == 'Ryan');
		assertfalse(collectionEntity.getHQL() Contains '_account.lastName = ');
	}

	public void function getRecordOptionsTest(){
		var recordOptions = variables.entity.getRecordOptions();
		assert(structKeyExists(recordOptions[1],'name') && structKeyExists(recordOptions[1],'value'));
	}

	public void function getMergeCollectionOptionsTest(){
		variables.entity.setCollectionID(createUUID());

		var accountCollectionData = {
			collectionid = createUUID(),
			collectionName = createUUID(),
			collectionCode = 'account#createUUID()#',
			collectionObject="Account",
			collectionConfig = '
				{
					"baseEntityName":"SlatwallAccount",
					"baseEntityAlias":"_account"

				}
			'
		};

		var accountCollection = createPersistedTestEntity('collection',accountCollectionData);

		var mergeCollectionRecords = variables.entity.getMergeCollectionOptions();
		assert(arrayLen(mergeCollectionRecords));
		var foundAccountCollection = false;
		for(var record in mergeCollectionRecords){
			if(record.name == accountCollectionData.collectionName){
				foundAccountCollection = true;
			}
			assert(record.value != variables.entity.getCollectionID());
		}
		assert(foundAccountCollection == true);

	};

	/**
	* @test
	*/
	public void function singleKeywordSearchTest(){

		var uniqueNumberForDescription = createUUID();

		var productData1 = {
			productID = '',
			productName = 'ProductABC',
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData1);

		var productData2 = {
			productID = '',
			productName = 'ProductBCD',
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData2);

		var productData3 = {
			productID = '',
			productName = 'ProductCDE',
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData3);

		var productData4 = {
			productID = '',
			productName = 'ProductDEF',
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData4);


		var myCollection = variables.entityService.getProductCollectionList();
		myCollection.setDisplayProperties('productID');
		myCollection.addDisplayProperty('productName', 'Product Name', {'isSearchable' = true});
		myCollection.addDisplayProperty('productDescription', 'Product Description', {'isSearchable' = true});
		myCollection.addFilter('productDescription',uniqueNumberForDescription);
		myCollection.setKeywords('ProductABC');

		var pageRecords = myCollection.getRecords();
		assertTrue(arraylen(pageRecords) == 1,  "Wrong amount of products returned! Expecting 1 records but returned #arrayLen(pageRecords)#");

	}


	/**
	* @test
	*/
	public void function singleKeywordSearchAndSingleColumnTest(){

		var uniqueNumberForDescription = createUUID();

		var productData1 = {
			productID = '',
			productName = 'ProductABC',
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData1);

		var productData2 = {
			productID = '',
			productName = 'ProductBCD',
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData2);

		var productData3 = {
			productID = '',
			productName = 'ProductCDE',
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData3);

		var productData4 = {
			productID = '',
			productName = 'ProductDEF',
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData4);


		var myCollection = variables.entityService.getProductCollectionList();
		myCollection.setDisplayProperties('productID');
		myCollection.addDisplayProperty('productDescription', 'Product Description', {'isSearchable' = true});
		myCollection.addFilter('productDescription',uniqueNumberForDescription);
		myCollection.setKeywords('#uniqueNumberForDescription#');



		var pageRecords = myCollection.getRecords();
		assertTrue(arraylen(pageRecords) == 4,  "Wrong amount of products returned! Expecting 4 records but returned #arrayLen(pageRecords)#");

	}


	/**
	* @test
	*/
	public void function KeywordsSearchTest(){

		var uniqueNumberForDescription = createUUID();

		var productData1 = {
			productID = '',
			productName = 'ProductABC',
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData1);

		var productData2 = {
			productID = '',
			productName = 'ProductBCD',
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData2);

		var productData3 = {
			productID = '',
			productName = 'ProductCDE',
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData3);

		var productData4 = {
			productID = '',
			productName = 'ProductDEF',
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData4);


		var myCollection = variables.entityService.getProductCollectionList();
		myCollection.setDisplayProperties('productID');
		myCollection.addDisplayProperty('productName', 'Product Name', {'isSearchable' = true});
		myCollection.addDisplayProperty('productDescription', 'Product Description', {'isSearchable' = true});
		myCollection.addFilter('productDescription',uniqueNumberForDescription);
		myCollection.setKeywords('ProductABC #uniqueNumberForDescription#');

		var pageRecords = myCollection.getRecords();
		assertTrue(arraylen(pageRecords) == 1,  "Wrong amount of products returned! Expecting 1 records but returned #arrayLen(pageRecords)#");

	}


	/**
	* @test
	*/
	public void function propertyIdentifierBadCasingCollectionTest(){
		var uniqueNumberForDescription = createUUID();

		var productWithoutActiveSkusData = {
			productID = '',
			productName = 'ProductUnitTest',
			productDescription = uniqueNumberForDescription,
			skus = [
			{
				skuID = '',
				skuCode= createUUID(),
				activeFlag = false
			},
			{
				skuID = '',
				skuCode= createUUID(),
				activeFlag = false
			}
				]
		};
		var productWithoutActiveSkus = createPersistedTestEntity('product', productWithoutActiveSkusData);

		//skus will default as active
		var productWithActiveSkusData = {
			productID = '',
			productName = 'ProductUnitTest',
			productDescription = uniqueNumberForDescription,
			skus = [
			{
				skuID = '',
				skuCode= 'aa'&createUUID()
			},
			{
				skuID = '',
				skuCode= 'ab'&createUUID()
			},
			{
				skuID = '',
				skuCode= 'ac'&createUUID()
			},
			{
				skuID = '',
				skuCode= 'ad'&createUUID()
			},
			{
				skuID = '',
				skuCode= 'ae'&createUUID(),
				activeFlag = 'false'
			}
				]
		};
		//By default Active flag is true.
		var SkusInActiveProducts = createPersistedTestEntity('product', productWithActiveSkusData);

		var myProductCollection = variables.entityService.getProductCollectionList();
		myProductCollection.setDisplayProperties('productname,productdescription,AcTiVeFlAg');
		myProductCollection.addFilter('productname','ProductUnitTest');
		myProductCollection.addFilter('productdescription',trim(uniqueNumberForDescription));
		myProductCollection.addFilter('skus.activeflag','YES');

		assertEquals(myProductCollection.getRecordsCount(),1);

		var pageRecords = myProductCollection.getPageRecords();


		assertTrue(arrayLen(pageRecords) == 1, "Wrong amount of products returned! Expecting 1 record but returned #arrayLen(pageRecords)#");

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
