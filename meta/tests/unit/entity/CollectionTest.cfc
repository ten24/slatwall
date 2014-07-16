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
	
	public void function getCollectionObjectOptionsTest(){
		variables.entity.setBaseEntityName('Account');
		assert(isArray(variables.entity.getEntityNameOptions()));
	}
	
	public void function deserializeCollectionConfigTest(){
		makePublic(variables.entity,'deserializeCollectionConfig');
		
	}
	
	public void function getHQLFilteringWithOtherCollectionTest(){
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
	
	public void function getHQLTest(){
		var collectionBestAcountEmailAddressesData = {
			collectionid = '',
			collectionCode = 'BestAccountEmailAddresses',
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
					"joins":[
						{
							"associationName":"accountEmailAddresses",
							"alias":"Account_accountEmailAddresses",
							"joins":[
								{
									"associationName":"accountEmailType",
									"alias":"Account_accountEmailAddresses_accountEmailType"
								}
							]
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
					
				}
			'
		};

		var collectionEntity = createTestEntity('collection',collectionEntityData);
		
		var collectionEntityHQL = collectionEntity.getHQL();
		
		request.debug(collectionEntityHQL);
		request.debug(collectionEntity);
		request.debug(collectionEntity.gethqlParams());
		//ORMExecuteQuery('FROM SlatwallAccount where accountID = :p1',{p1='2'});
		
		//var query = collectionEntity.executeHQL();
		var query = ORMExecuteQuery(collectionEntityHQL,collectionEntity.gethqlParams());
		request.debug(query);
		
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
		request.debug(joinHQL);
		
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
