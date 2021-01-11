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
	* 
	* Test cases for between date filter
	*/
	
	public void function dateFilter_between(){

		var uniqueNumberForDescription = createUUID();
		var startDateTime = createDateTime(2018, 8, 3, 0, 0, 0);
		
		var productData1 = {
			productID = '',
			productName = 'dProduct',
			purchaseStartDateTime = dateAdd('d', 1, startDateTime),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData1);

		var productData2 = {
			productID = '',
			productName = 'cProduct',
			purchaseStartDateTime = dateAdd('d', 2, startDateTime),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData2);

		var productData3 = {
			productID = '',
			productName = 'bProduct',
			purchaseStartDateTime = dateAdd('d', 3, startDateTime),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData3);

		var productData4 = {
			productID = '',
			productName = 'aProduct',
			purchaseStartDateTime = dateAdd('d', 4, startDateTime),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData4);
		
		var productData5 = {
			productID = '',
			productName = 'eProduct',
			purchaseStartDateTime = dateAdd('d', 5, startDateTime),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData5);

		//Today
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
				               "value":"1533303982000-1533563182000",
				               "ormtype":"timestamp",
				               "conditionDisplay":"In Range"
				               
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
		assertTrue(arraylen(pageRecords) == 3,  "Wrong amount of products returned! Expecting 3 records but returned #arrayLen(pageRecords)#");
	}
	
	/**
	* @test
	* 
	* Test cases for today date filter
	*/
	public void function dateFilter_today(){

		var uniqueNumberForDescription = createUUID();
		
		var productData1 = {
			productID = '',
			productName = 'dProduct',
			purchaseStartDateTime = now(),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData1);

		var productData2 = {
			productID = '',
			productName = 'cProduct',
			purchaseStartDateTime = now(),
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

		//Today
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
				               "measureType":"today",
				               "measureCriteria":"calculation",
				               "criteriaNumberOf":"0",
				               "value":"0",
				               "displayValue":"Today",
				               "ormtype":"timestamp",
				               "conditionDisplay":"Today"
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
		assertTrue(arraylen(pageRecords) == 2,  "Wrong amount of products returned! Expecting 2 records but returned #arrayLen(pageRecords)#");
	}
	
	/**
	* @test
	* 
	* Test cases for yesterday date filter
	*/
	public void function dateFilter_yesterday(){

		var uniqueNumberForDescription = createUUID();
		
		var productData3 = {
			productID = '',
			productName = 'bProduct',
			purchaseStartDateTime = DateAdd('d', -1, now()),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData3);

		var productData4 = {
			productID = '',
			productName = 'aProduct',
			purchaseStartDateTime = DateAdd('d', -1, now()),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData4);

		//Yesterday
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
				               "measureType":"yesterday",
				               "measureCriteria":"calculation",
				               "criteriaNumberOf":"1",
				               "value":"1",
				               "displayValue":"Yesterday",
				               "ormtype":"timestamp",
				               "conditionDisplay":"Yesterday"
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
		assertTrue(arraylen(pageRecords) == 2,  "Wrong amount of products returned! Expecting 2 records but returned #arrayLen(pageRecords)#");
	}
	
	/**
	* @test
	* 
	* Test cases for thisWeek date filter
	*/
	public void function dateFilter_thisWeek(){

		var uniqueNumberForDescription = createUUID();
		var firstOfWeek = DateAdd("d",  - (DayOfWeek(Now()) - 1), Now());
		var productData1 = {
			productID = '',
			productName = 'aProduct',
			purchaseStartDateTime = firstOfWeek,
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData1);

		var productData2 = {
			productID = '',
			productName = 'bProduct',
			purchaseStartDateTime = DateAdd('d', 3, firstOfWeek),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData2);
		
		var productData3 = {
			productID = '',
			productName = 'cProduct',
			purchaseStartDateTime = DateAdd('d', 7, firstOfWeek),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData3);

		//thisWeek
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
				               "measureType":"thisWeek",
				               "measureCriteria":"calculation",
				               "criteriaNumberOf":"0",
				               "value":"0",
				               "displayValue":"This Week",
				               "ormtype":"timestamp",
				               "conditionDisplay":"This Week"
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
		assertTrue(arraylen(pageRecords) == 3,  "Wrong amount of products returned! Expecting 3 records but returned #arrayLen(pageRecords)#");
	}
	
	/**
	* @test
	* 
	* Test cases for thisMonth date filter
	*/
	public void function dateFilter_thisMonth(){

		var uniqueNumberForDescription = createUUID();
		var firstOfMonth = createDate(year(now()), month(now()), 1);
		var productData1 = {
			productID = '',
			productName = 'aProduct',
			purchaseStartDateTime = firstOfMonth,
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData1);

		var productData2 = {
			productID = '',
			productName = 'bProduct',
			purchaseStartDateTime = DateAdd('d', 10, firstOfMonth),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData2);
		
		var productData3 = {
			productID = '',
			productName = 'cProduct',
			purchaseStartDateTime = DateAdd('d', 16, firstOfMonth),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData3);
		
		var productData4 = {
			productID = '',
			productName = 'dProduct',
			purchaseStartDateTime = DateAdd('d', 28, firstOfMonth),
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
				               "measureType":"thisMonth",
				               "measureCriteria":"calculation",
				               "criteriaNumberOf":"0",
				               "value":"0",
				               "displayValue":"This Month",
				               "ormtype":"timestamp",
				               "conditionDisplay":"This Month"
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
	* 
	* Test cases for thisQuarter date filter
	*/
	public void function dateFilter_thisQuarter(){

		var uniqueNumberForDescription = createUUID();
		var firstOfQuarter = CreateDate(year(now()), ( ( floor(month(now()) / 3) ) )*3 + 1, 1);
		var productData1 = {
			productID = '',
			productName = 'aProduct',
			purchaseStartDateTime = firstOfQuarter,
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData1);

		var productData2 = {
			productID = '',
			productName = 'bProduct',
			purchaseStartDateTime = DateAdd('m', 1, firstOfQuarter),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData2);
		
		var productData3 = {
			productID = '',
			productName = 'cProduct',
			purchaseStartDateTime = DateAdd('m', 2, firstOfQuarter),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData3);
		
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
				               "measureType":"thisQuarter",
				               "measureCriteria":"calculation",
				               "criteriaNumberOf":"0",
				               "value":"0",
				               "displayValue":"This Quarter",
				               "ormtype":"timestamp",
				               "conditionDisplay":"This Quarter"
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
		assertTrue(arraylen(pageRecords) == 3,  "Wrong amount of products returned! Expecting 3 records but returned #arrayLen(pageRecords)#");
	}
	
	/**
	* @test
	* 
	* Test cases for thisYear date filter
	*/
	public void function dateFilter_thisYear(){

		var uniqueNumberForDescription = createUUID();
		var firstOfYear = CreateDate(year(now()), 1, 1);
		var productData1 = {
			productID = '',
			productName = 'aProduct',
			purchaseStartDateTime = firstOfYear,
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData1);

		var productData2 = {
			productID = '',
			productName = 'bProduct',
			purchaseStartDateTime = DateAdd('m', 6, firstOfYear),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData2);
		
		var productData3 = {
			productID = '',
			productName = 'cProduct',
			purchaseStartDateTime = DateAdd('m', 11, firstOfYear),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData3);
		
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
				               "measureType":"thisYear",
				               "measureCriteria":"calculation",
				               "criteriaNumberOf":"0",
				               "value":"0",
				               "displayValue":"This Year",
				               "ormtype":"timestamp",
				               "conditionDisplay":"This Year"
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
		assertTrue(arraylen(pageRecords) == 3,  "Wrong amount of products returned! Expecting 3 records but returned #arrayLen(pageRecords)#");
	}
	
	/**
	* @test
	* 
	* Test cases for last (N) Hour date filter
	*/
	public void function dateFilter_lastHour(){

		var uniqueNumberForDescription = createUUID();
		var criteriaNumberOf = 3;
		var firstOfCriteria = DateAdd("h", -criteriaNumberOf, Now());
		var productData1 = {
			productID = '',
			productName = 'aProduct',
			purchaseStartDateTime = firstOfCriteria,
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData1);
		
		var productData2 = {
			productID = '',
			productName = 'bProduct',
			purchaseStartDateTime = DateAdd("h", 1, firstOfCriteria),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData2);
		
		var productData3 = {
			productID = '',
			productName = 'cProduct',
			purchaseStartDateTime = DateAdd("h", 2, firstOfCriteria),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData3);
		
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
				               "measureType":"lastHour",
				               "measureCriteria":"calculation",
				               "criteriaNumberOf":"#criteriaNumberOf#",
				               "value":"#criteriaNumberOf#",
				               "displayValue":"Last N Hour",
				               "ormtype":"timestamp",
				               "conditionDisplay":"Last N Hour"
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
		assertTrue(arraylen(pageRecords) == 3,  "Wrong amount of products returned! Expecting 3 records but returned #arrayLen(pageRecords)#");
	}
	
	/**
	* @test
	* 
	* Test cases for last (N) Days date filter
	*/
	public void function dateFilter_lastDay(){

		var uniqueNumberForDescription = createUUID();
		var criteriaNumberOf = 10;
		var firstOfCriteria = DateAdd("d", -criteriaNumberOf, Now());
		var productData1 = {
			productID = '',
			productName = 'aProduct',
			purchaseStartDateTime = firstOfCriteria,
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData1);
		
		var productData2 = {
			productID = '',
			productName = 'bProduct',
			purchaseStartDateTime = DateAdd("d", 3, firstOfCriteria),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData2);
		
		var productData3 = {
			productID = '',
			productName = 'cProduct',
			purchaseStartDateTime = DateAdd("d", criteriaNumberOf - 1, firstOfCriteria),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData3);
		
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
				               "measureType":"lastDay",
				               "measureCriteria":"calculation",
				               "criteriaNumberOf":"#criteriaNumberOf#",
				               "value":"#criteriaNumberOf#",
				               "displayValue":"Last N Days",
				               "ormtype":"timestamp",
				               "conditionDisplay":"Last N Days"
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
		assertTrue(arraylen(pageRecords) == 3,  "Wrong amount of products returned! Expecting 3 records but returned #arrayLen(pageRecords)#");
	}
	
	/**
	* @test
	* 
	* Test cases for last (N) Weeks date filter
	*/
	public void function dateFilter_lastWeek(){

		var uniqueNumberForDescription = createUUID();
		var criteriaNumberOf = 5;
		var firstOfCriteria = DateAdd("d",  - (DayOfWeek(Now()) - 1), Now());
		firstOfCriteria = DateAdd("d",  - criteriaNumberOf * 7, firstOfCriteria);
		
		var productData1 = {
			productID = '',
			productName = 'aProduct',
			purchaseStartDateTime = firstOfCriteria,
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData1);
		
		var productData2 = {
			productID = '',
			productName = 'bProduct',
			purchaseStartDateTime = DateAdd("w", 2, firstOfCriteria),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData2);
		
		var productData3 = {
			productID = '',
			productName = 'cProduct',
			purchaseStartDateTime = DateAdd("w", criteriaNumberOf - 1, firstOfCriteria),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData3);
		
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
				               "measureType":"lastWeek",
				               "measureCriteria":"calculation",
				               "criteriaNumberOf":"#criteriaNumberOf#",
				               "value":"#criteriaNumberOf#",
				               "displayValue":"Last N Week",
				               "ormtype":"timestamp",
				               "conditionDisplay":"Last N Week"
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
		assertTrue(arraylen(pageRecords) == 3,  "Wrong amount of products returned! Expecting 3 records but returned #arrayLen(pageRecords)#");
	}
	
	/**
	* @test
	* 
	* Test cases for last (N) Month date filter
	*/
	public void function dateFilter_lastMonth(){

		var uniqueNumberForDescription = createUUID();
		var criteriaNumberOf = 5;
		var firstOfCriteria = createDate(year(now()), month(now()), 1);
		firstOfCriteria = DateAdd("m",  - criteriaNumberOf, firstOfCriteria);
		
		var productData1 = {
			productID = '',
			productName = 'aProduct',
			purchaseStartDateTime = firstOfCriteria,
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData1);
		
		var productData2 = {
			productID = '',
			productName = 'bProduct',
			purchaseStartDateTime = DateAdd("m", 2, firstOfCriteria),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData2);
		
		var productData3 = {
			productID = '',
			productName = 'cProduct',
			purchaseStartDateTime = DateAdd("m", criteriaNumberOf - 1, firstOfCriteria),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData3);
		
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
				               "measureType":"lastMonth",
				               "measureCriteria":"calculation",
				               "criteriaNumberOf":"#criteriaNumberOf#",
				               "value":"#criteriaNumberOf#",
				               "displayValue":"Last N Month",
				               "ormtype":"timestamp",
				               "conditionDisplay":"Last N Month"
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
		assertTrue(arraylen(pageRecords) == 3,  "Wrong amount of products returned! Expecting 3 records but returned #arrayLen(pageRecords)#");
	}
	
	/**
	* @test
	* 
	* Test cases for last (N) Quarter date filter
	*/
	public void function dateFilter_lastQuarter(){

		var uniqueNumberForDescription = createUUID();
		var criteriaNumberOf = 5;
		var firstOfCriteria = CreateDate(year(now()), ( ( floor(month(now()) / 3) ) )*3 + 1, 1);
		firstOfCriteria = DateAdd("m",  - criteriaNumberOf * 3, firstOfCriteria);
		
		var productData1 = {
			productID = '',
			productName = 'aProduct',
			purchaseStartDateTime = firstOfCriteria,
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData1);
		
		var productData2 = {
			productID = '',
			productName = 'bProduct',
			purchaseStartDateTime = DateAdd("m", 6, firstOfCriteria),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData2);
		
		var productData3 = {
			productID = '',
			productName = 'cProduct',
			purchaseStartDateTime = DateAdd("m", criteriaNumberOf - 1, firstOfCriteria),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData3);
		
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
				               "measureType":"lastQuarter",
				               "measureCriteria":"calculation",
				               "criteriaNumberOf":"#criteriaNumberOf#",
				               "value":"#criteriaNumberOf#",
				               "displayValue":"Last N Quarter",
				               "ormtype":"timestamp",
				               "conditionDisplay":"Last N Quarter"
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
		assertTrue(arraylen(pageRecords) == 3,  "Wrong amount of products returned! Expecting 3 records but returned #arrayLen(pageRecords)#");
	}
	
	/**
	* @test
	* 
	* Test cases for last (N) Year date filter
	*/
	public void function dateFilter_lastYear(){

		var uniqueNumberForDescription = createUUID();
		var criteriaNumberOf = 5;
		var firstOfCriteria = CreateDate(year(now()), 1, 1);
		firstOfCriteria = DateAdd("yyyy",  - criteriaNumberOf, firstOfCriteria);
		
		var productData1 = {
			productID = '',
			productName = 'aProduct',
			purchaseStartDateTime = firstOfCriteria,
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData1);
		
		var productData2 = {
			productID = '',
			productName = 'bProduct',
			purchaseStartDateTime = DateAdd("yyyy", 1, firstOfCriteria),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData2);
		
		var productData3 = {
			productID = '',
			productName = 'cProduct',
			purchaseStartDateTime = DateAdd("yyyy", criteriaNumberOf - 1, firstOfCriteria),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData3);
		
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
				               "measureType":"lastYear",
				               "measureCriteria":"calculation",
				               "criteriaNumberOf":"#criteriaNumberOf#",
				               "value":"#criteriaNumberOf#",
				               "displayValue":"Last N Year",
				               "ormtype":"timestamp",
				               "conditionDisplay":"Last N Year"
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
		assertTrue(arraylen(pageRecords) == 3,  "Wrong amount of products returned! Expecting 3 records but returned #arrayLen(pageRecords)#");
	}
	
	/**
	* @test
	* 
	* Test cases for more than (N) Days Ago date filter
	*/
	public void function dateFilter_moreDays(){

		var uniqueNumberForDescription = createUUID();
		var criteriaNumberOf = 5;
		var firstOfCriteria = DateAdd("d",  - criteriaNumberOf, now());
		
		var productData1 = {
			productID = '',
			productName = 'aProduct',
			purchaseStartDateTime = DateAdd("d", -1, firstOfCriteria),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData1);
		
		var productData2 = {
			productID = '',
			productName = 'bProduct',
			purchaseStartDateTime = DateAdd("d", -3, firstOfCriteria),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData2);
		
		var productData3 = {
			productID = '',
			productName = 'cProduct',
			purchaseStartDateTime = DateAdd("d", - (criteriaNumberOf - 1), firstOfCriteria),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData3);
		
		var productData4 = {
			productID = '',
			productName = 'dProduct',
			purchaseStartDateTime = Now(),
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
				               "comparisonOperator":"<",
				               "measureType":"moreDays",
				               "measureCriteria":"calculation",
				               "criteriaNumberOf":"#criteriaNumberOf#",
				               "value":"#criteriaNumberOf#",
				               "displayValue":"More than N Day Ago",
				               "ormtype":"timestamp",
				               "conditionDisplay":"More than N Day Ago"
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
		assertTrue(arraylen(pageRecords) == 3,  "Wrong amount of products returned! Expecting 3 records but returned #arrayLen(pageRecords)#");
	}
	
	/**
	* @test
	* 
	* Test cases for more than (N) Weeks Ago date filter
	*/
	public void function dateFilter_moreWeeks(){

		var uniqueNumberForDescription = createUUID();
		var criteriaNumberOf = 5;
		
		var firstOfCriteria = DateAdd("d",  - (DayOfWeek(Now()) - 1), Now());
		firstOfCriteria = DateAdd("d",  - criteriaNumberOf * 7, firstOfCriteria);
		
		var productData1 = {
			productID = '',
			productName = 'aProduct',
			purchaseStartDateTime = DateAdd("w", -1, firstOfCriteria),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData1);
		
		var productData2 = {
			productID = '',
			productName = 'bProduct',
			purchaseStartDateTime = DateAdd("d", -3, firstOfCriteria),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData2);
		
		var productData3 = {
			productID = '',
			productName = 'cProduct',
			purchaseStartDateTime = DateAdd("w", - (criteriaNumberOf - 1), firstOfCriteria),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData3);
		
		var productData4 = {
			productID = '',
			productName = 'dProduct',
			purchaseStartDateTime = Now(),
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
				               "comparisonOperator":"<",
				               "measureType":"moreWeeks",
				               "measureCriteria":"calculation",
				               "criteriaNumberOf":"#criteriaNumberOf#",
				               "value":"#criteriaNumberOf#",
				               "displayValue":"More than N Week Ago",
				               "ormtype":"timestamp",
				               "conditionDisplay":"More than N Week Ago"
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
		assertTrue(arraylen(pageRecords) == 3,  "Wrong amount of products returned! Expecting 3 records but returned #arrayLen(pageRecords)#");
	}
	
	/**
	* @test
	* 
	* Test cases for more than (N) Months Ago date filter
	*/
	public void function dateFilter_moreMonths(){

		var uniqueNumberForDescription = createUUID();
		var criteriaNumberOf = 5;
		
		var firstOfCriteria = createDate(year(now()), month(now()), 1);
		firstOfCriteria = DateAdd("m",  - criteriaNumberOf, firstOfCriteria);
		
		var productData1 = {
			productID = '',
			productName = 'aProduct',
			purchaseStartDateTime = DateAdd("m", -1, firstOfCriteria),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData1);
		
		var productData2 = {
			productID = '',
			productName = 'bProduct',
			purchaseStartDateTime = DateAdd("m", -3, firstOfCriteria),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData2);
		
		var productData3 = {
			productID = '',
			productName = 'cProduct',
			purchaseStartDateTime = DateAdd("m", - (criteriaNumberOf - 1), firstOfCriteria),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData3);
		
		var productData4 = {
			productID = '',
			productName = 'dProduct',
			purchaseStartDateTime = firstOfCriteria,
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
				               "comparisonOperator":"<",
				               "measureType":"moreMonths",
				               "measureCriteria":"calculation",
				               "criteriaNumberOf":"#criteriaNumberOf#",
				               "value":"#criteriaNumberOf#",
				               "displayValue":"More than N Month Ago",
				               "ormtype":"timestamp",
				               "conditionDisplay":"More than N Month Ago"
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
		assertTrue(arraylen(pageRecords) == 3,  "Wrong amount of products returned! Expecting 3 records but returned #arrayLen(pageRecords)#");
	}
	
	/**
	* @test
	* 
	* Test cases for more than (N) Years Ago date filter
	*/
	public void function dateFilter_moreYears(){

		var uniqueNumberForDescription = createUUID();
		var criteriaNumberOf = 5;
		
		var firstOfCriteria = CreateDate(year(now()), 1, 1);
		firstOfCriteria = DateAdd("yyyy",  - criteriaNumberOf, firstOfCriteria);
		
		var productData1 = {
			productID = '',
			productName = 'aProduct',
			purchaseStartDateTime = DateAdd("m", -1, firstOfCriteria),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData1);
		
		var productData2 = {
			productID = '',
			productName = 'bProduct',
			purchaseStartDateTime = DateAdd("yyyy", -3, firstOfCriteria),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData2);
		
		var productData3 = {
			productID = '',
			productName = 'cProduct',
			purchaseStartDateTime = DateAdd("w", - (criteriaNumberOf - 1), firstOfCriteria),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData3);
		
		var productData4 = {
			productID = '',
			productName = 'dProduct',
			purchaseStartDateTime = now(),
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
				               "comparisonOperator":"<",
				               "measureType":"moreYears",
				               "measureCriteria":"calculation",
				               "criteriaNumberOf":"#criteriaNumberOf#",
				               "value":"#criteriaNumberOf#",
				               "displayValue":"More than N Year Ago",
				               "ormtype":"timestamp",
				               "conditionDisplay":"More than N Year Ago"
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
		assertTrue(arraylen(pageRecords) == 3,  "Wrong amount of products returned! Expecting 3 records but returned #arrayLen(pageRecords)#");
	}
	
	/**
	* @test
	* 
	* Test cases for exact (N) Days Ago date filter
	*/
	public void function dateFilter_exactDays(){

		var uniqueNumberForDescription = createUUID();
		var criteriaNumberOf = 5;
		
		var firstOfCriteria = DateAdd("d",  - criteriaNumberOf, now());
		
		var productData1 = {
			productID = '',
			productName = 'aProduct',
			purchaseStartDateTime = DateAdd("d", -1, firstOfCriteria),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData1);
		
		var productData2 = {
			productID = '',
			productName = 'bProduct',
			purchaseStartDateTime = DateAdd("d", 1, firstOfCriteria),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData2);
		
		var productData3 = {
			productID = '',
			productName = 'cProduct',
			purchaseStartDateTime = firstOfCriteria,
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData3);
		
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
				               "measureType":"exactDays",
				               "measureCriteria":"calculation",
				               "criteriaNumberOf":"#criteriaNumberOf#",
				               "value":"#criteriaNumberOf#",
				               "displayValue":"Exact N Day Ago",
				               "ormtype":"timestamp",
				               "conditionDisplay":"Exact N Day Ago"
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
		assertTrue(arraylen(pageRecords) == 1,  "Wrong amount of products returned! Expecting 1 record but returned #arrayLen(pageRecords)#");
	}
	
	/**
	* @test
	* 
	* Test cases for exact (N) Months Ago date filter
	*/
	public void function dateFilter_exactMonths(){

		var uniqueNumberForDescription = createUUID();
		var criteriaNumberOf = 5;
		
		var firstOfCriteria = createDate(year(now()), month(now()), 1);
		firstOfCriteria = DateAdd("m",  - criteriaNumberOf, firstOfCriteria);
		
		var productData1 = {
			productID = '',
			productName = 'aProduct',
			purchaseStartDateTime = DateAdd("d", -1, firstOfCriteria),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData1);
		
		var productData2 = {
			productID = '',
			productName = 'bProduct',
			purchaseStartDateTime = DateAdd("d", 10, firstOfCriteria),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData2);
		
		var productData3 = {
			productID = '',
			productName = 'cProduct',
			purchaseStartDateTime = firstOfCriteria,
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData3);
		
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
				               "measureType":"exactMonths",
				               "measureCriteria":"calculation",
				               "criteriaNumberOf":"#criteriaNumberOf#",
				               "value":"#criteriaNumberOf#",
				               "displayValue":"Exact N Months Ago",
				               "ormtype":"timestamp",
				               "conditionDisplay":"Exact N Months Ago"
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
		assertTrue(arraylen(pageRecords) == 2,  "Wrong amount of products returned! Expecting 2 record but returned #arrayLen(pageRecords)#");
	}
	
	/**
	* @test
	* 
	* Test cases for exact (N) Years Ago date filter
	*/
	public void function dateFilter_exactYears(){

		var uniqueNumberForDescription = createUUID();
		var criteriaNumberOf = 5;
		
		var firstOfCriteria = createDate(year(now()), 1, 1);
		firstOfCriteria = DateAdd("yyyy",  - criteriaNumberOf, firstOfCriteria);
		
		var productData1 = {
			productID = '',
			productName = 'aProduct',
			purchaseStartDateTime = DateAdd("d", -1, firstOfCriteria),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData1);
		
		var productData2 = {
			productID = '',
			productName = 'bProduct',
			purchaseStartDateTime = DateAdd("m", 6, firstOfCriteria),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData2);
		
		var productData3 = {
			productID = '',
			productName = 'cProduct',
			purchaseStartDateTime = firstOfCriteria,
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData3);
		
		var productData4 = {
			productID = '',
			productName = 'dProduct',
			purchaseStartDateTime = DateAdd("m", 13, firstOfCriteria),
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
				               "measureType":"exactYears",
				               "measureCriteria":"calculation",
				               "criteriaNumberOf":"#criteriaNumberOf#",
				               "value":"#criteriaNumberOf#",
				               "displayValue":"Exact N Year Ago",
				               "ormtype":"timestamp",
				               "conditionDisplay":"Exact N Year Ago"
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
		assertTrue(arraylen(pageRecords) == 2,  "Wrong amount of products returned! Expecting 2 record but returned #arrayLen(pageRecords)#");
	}
	
	/**
	* @test
	* 
	* Test cases for exact (N) Day From Now date filter
	*/
	public void function dateFilter_exactDayFromNow(){

		var uniqueNumberForDescription = createUUID();
		var criteriaNumberOf = 5;
		
		var firstOfCriteria = DateAdd("d",  criteriaNumberOf, now());
		
		var productData1 = {
			productID = '',
			productName = 'aProduct',
			purchaseStartDateTime = Now(),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData1);
		
		var productData2 = {
			productID = '',
			productName = 'bProduct',
			purchaseStartDateTime = firstOfCriteria,
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData2);
		
		var productData3 = {
			productID = '',
			productName = 'cProduct',
			purchaseStartDateTime = DateAdd("d", -1, firstOfCriteria),
			productDescription = uniqueNumberForDescription
		};
		createPersistedTestEntity('product', productData3);
		
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
				               "measureType":"exactDayFromNow",
				               "measureCriteria":"calculation",
				               "criteriaNumberOf":"#criteriaNumberOf#",
				               "value":"#criteriaNumberOf#",
				               "displayValue":"Exact N Day From Now",
				               "ormtype":"timestamp",
				               "conditionDisplay":"Exact N Day From Now"
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
		assertTrue(arraylen(pageRecords) == 1,  "Wrong amount of products returned! Expecting 1 record but returned #arrayLen(pageRecords)#");
	}

}