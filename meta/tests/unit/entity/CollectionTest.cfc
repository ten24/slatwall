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
		
		variables.entityService = "collectionService";
		variables.entity = request.slatwallScope.getService( variables.entityService ).newCollection();
	}
	
	public void function getAggregateHQLTest(){
		makePublic(variables.entity,"getAggregateHQL");
		var propertyIdentifier = "Account.firstName";
		var aggregate = {
			aggregateFunction = "count",
			aggregateAlias = "Account_firstName"
		};
		
		var aggregateHQL = variables.entity.getAggregateHQL(aggregate,propertyIdentifier);
		request.debug(aggregateHQL);
		assertFalse(Compare("COUNT(Account.firstName) as Account_firstName",trim(aggregateHQL)));
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
	
	
	/* TODO:write complete test data to verify getRecords and getRecordsCount methods*/
	/*
	public void function getRecordsCountTest(){
		var collectionEntityData = {
			collectionid = '',
			collectionCode = 'RyansAccountOrders',
			collectionName = 'RyansAccountOrders',
			collectionConfig = '{
				"baseEntityName":"SlatwallAccount",
				"baseEntityAlias":"Account"
			}
			',
			baseEntityName = "SlatwallAccount"
			
		};
		var collectionEntity = createPersistedTestEntity('collection',collectionEntityData);
		
		var recordsCount = collectionEntity.getRecordsCount();
		
		request.debug(recordsCount);
		request.debug(collectionEntity.getHQL());
		
	}
	
	public void function getRecords(){
		var collectionEntityData = {
			collectionid = '',
			collectionCode = 'RyansAccountOrders',
			collectionName = 'RyansAccountOrders',
			collectionConfig = '{
				"baseEntityName":"SlatwallAccount",
					"baseEntityAlias":"Account"
			}
			',
			baseEntityName = "SlatwallAccount"
			
		};
		var collectionEntity = createPersistedTestEntity('collection',collectionEntityData);
		
		var records = collectionEntity.getRecords();
		
		request.debug(records);
	}
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
	
	public void function getHQLFilteringWithOtherCollectionTest(){
		var collectionEntityData = {
			collectionid = '',
			collectionCode = 'RyansAccountOrders',
			collectionName = 'RyansAccountOrders',
			collectionObject = 'SlatwallAccount',
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
					"baseEntityAlias":"Account",
					"columns":[
						{
							"propertyIdentifier":"Account.orders"
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
							"propertyIdentifier":"Account.lastName",
							"direction":"DESC"
						},
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
			'
		};
		var collectionEntity2 = createTestEntity('collection',collectionEntityData2);
		
		var collectionEntityHQL = collectionEntity.getHQL();
		
		request.debug(collectionEntityHQL);
		request.debug(collectionEntity);
		request.debug(collectionEntity.gethqlParams());
		var testquery = ORMExecuteQuery(collectionEntityHQL,collectionEntity.gethqlParams());
		request.debug(testquery);
		
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
		request.debug(pageRecords);
	}*/
	
	public void function validate_as_save_for_a_new_instance_doesnt_pass(){
		
	}
	
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
		//request.debug(collectionEntity.getPostOrderBys());
		
		//collectionEntity.addPostFilterGroup(postFilterGroup);
		
		//request.debug(collectionEntity.getPostFilterGroups());
		
		//var collectionEntityHQL = collectionEntity.getHQL();
		
		//request.debug(collectionEntityHQL);
		//request.debug(collectionEntity);
		//request.debug(collectionEntity.gethqlParams());
		//ORMExecuteQuery('FROM SlatwallAccount where accountID = :p1',{p1='2'});
		
		//var query = collectionEntity.executeHQL();
		//var query = ORMExecuteQuery(collectionEntityHQL,collectionEntity.gethqlParams());
		
	}
	
	public void function getHQLTest_date_in_range(){
		var collectionData = {
			collectionid = '',
			collectionName='dateInRange',
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
		var collectionEntity = createPersistedTestEntity('collection',collectionData);
		request.debug(collectionEntity.getPageRecords());
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
		
		request.debug(collectionBestAcountEmailAddresses.getPageRecords());
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
		/*request.debug(ORMExecuteQuery("SELECT attributeValue 
					FROM SlatwallAttributeValue
					WHERE attribute.attributeID = '2c909fea47fa423b014884fd8eea0919'"));*/
		
		var collectionEntity = createPersistedTestEntity('collection',collectionEntityData);
		request.debug(collectionEntity.getPageRecords());
		
		
		
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
		request.debug(collectionEntity.getPageRecords());
		
		
		
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
		request.debug(collectionEntity.getPageRecords());
		
		
		
	}
	
	public void function getHQLTest_emptyFilterGroup(){
		var collectionBestAcountEmailAddressesData = {
			collectionid = '',
			collectionCode = 'BestAccountEmailAddresses',
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
		//request.debug(collectionEntity.getHQL());
		 
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
		/*request.debug(ORMExecuteQuery("SELECT attributeValue 
					FROM SlatwallAttributeValue
					WHERE attribute.attributeID = '2c909fea47fa423b014884fd8eea0919'"));*/
		
		var collectionEntity = createPersistedTestEntity('collection',collectionEntityData);
		request.debug(collectionEntity.getPageRecords());
		
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
		request.debug(selectionsHQL);
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
		request.debug(filterHQL);
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
		
		request.debug(filterGroupHQL);
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
		
		var filterGroupsHQL = variables.entity.getFilterGroupsHQL(filterGroups);
		
		request.debug(filterGroupsHQL);
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
		
		request.debug(orderByHQL); 
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
	
	public void function HQLTestWithExistingCollection(){
			
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
		
		var collectionEntity = createPersistedTestEntity('collection',CollectionEntityData);
		request.debug(collectionEntity.getHQL());
	}
	
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
		request.debug(collectionEntity.getPageRecords());
	}
	
	public void function getHQLForCollectionFilterTest(){
		var collectionBestAcountEmailAddressesData = {
			collectionid = '',
			collectionCode = 'BestAccountEmailAddresses',
			collectionObject="Account",
			collectionConfig = '
				{
					"baseEntityName":"SlatwallAccount",
					"baseEntityAlias":"_account",
					
					"filterGroups":[
						{
							"filterGroup":[
								{
									"propertyIdentifier":"_account.firstName",
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
		
		
		var filter = {
						propertyIdentifier="_account.accountEmailAddresses",
						collectionID=collectionBestAcountEmailAddresses.getCollectionID(),
						criteria="One"
					};
						
		MakePublic(variables.entity,'getHQLForCollectionFilter');
		
		var HQL = variables.entity.getHQLForCollectionFilter(filter);
		request.debug(HQL);
	}
	
	public void function getCollectionObjectParentChildTest(){
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
		request.debug(result);
	}
	
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
