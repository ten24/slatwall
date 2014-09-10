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
		
		variables.service = request.slatwallScope.getBean("collectionService");
	}
	
	public void function getTransientCollectionConfigStructByURLParamsTest(){
	/*	var rc = {
			entityName = 'account',
			columns
		};
		
		var collectionConfigStruct = variables.service.getTransientCollectionConfigStructByURLParams(rc);
		request.debug(collectionConfigStruct);
	}*/
	
	public void function getCapitalCaseTest(){
		MakePublic(variables.service,'capitalCase');
		var word = 'testingword';
		word = variables.service.capitalCase(word);
		assertEquals('Testingword',word);
	}
	
	public void function getTransientCollectionByEntityNameTest(){
		var entityName = 'product';
		var collectionEntity = variables.service.getTransientCollectionByEntityName(entityName);
		assertEquals('SlatwallProduct',collectionEntity.getBaseEntityName());
		assertEquals('SlatwallProduct',collectionEntity.getCollectionConfigStruct().baseentityname);
		assertEquals('Product',collectionEntity.getCollectionConfigStruct().baseentityalias);
	}
	
	
	public void function getFormattedPageRecordsTest(){
		//need product to be able to get in a paginated list
		var productData = {
			productid = '',
			productName = 'testproduct1'
			
		};
		var product = createPersistedTestEntity('product',productData);
		var productData2 = {
			productid = '',
			productName = 'testproduct2'
			
		};
		var product2 = createPersistedTestEntity('product',productData2);
		
		var entityName = 'product';
		var collectionEntity = variables.service.getTransientCollectionByEntityName(entityName);
		
		//var paginatedCollectionOfEntities = collectionEntity.getPageRecords();
		
		var entityProperties = variables.service.getDefaultPropertiesByEntityName( entityName );
		var propertyIdentifiersList = variables.service.getPropertyIdentifiersList(entityProperties);
		var propertyIdentifiers = ListToArray(propertyIdentifiersList);
		var formattedPageRecords = variables.service.getFormattedPageRecords(collectionEntity,propertyIdentifiers);
		assertTrue(arraylen(formattedPageRecords['pageRecords']));
	}
	
	public void function getPropertyIdentifiersListTest(){
		var entityName = 'product';
		var entityProperties = variables.service.getPropertiesByEntityName( entityName );
		var propertyIdentifiersList = variables.service.getPropertyIdentifiersList(entityProperties);
		assertTrue(listLen(propertyIdentifiersList));
	}
	
	public void function getEntityNameColumnProperties_returns_valid_array() {
		var result = variables.service.getEntityNameColumnProperties( 'Account' );
		request.debug(result);
		assert( isArray( result ) );
	}
	
	// getEntityNameProperties()
	public void function getEntityNameProperties_returns_valid_array() {
		var result = variables.service.getEntityNameProperties( 'Account' );
		request.debug(result);
		assert( isArray( result ) );
	}
	
	public void function getEntityNameProperties_returns_properties_in_correct_sorted_order() {
		var result = variables.service.getEntityNameProperties( 'Account' );
		
		assertEquals( "accountAddresses", result[1].propertyIdentifier );
		assertEquals( "accountAuthentications", result[2].propertyIdentifier );
		assertEquals( "accountContentAccesses", result[3].propertyIdentifier );
		assertEquals( "accountEmailAddresses", result[4].propertyIdentifier );
		assertEquals( "accountID", result[5].propertyIdentifier );
		assertEquals( "accountLoyalties", result[6].propertyIdentifier );
		request.debug(result);
	}
	
	public void function getEntityNameOptionsTest(){
		var collectionEntityData = {
			collectionid = '',
			baseEntityName = 'Account'
		};
		var collectionEntity = createTestEntity('collection',collectionEntityData);
		var collectionEntityProperties = variables.service.getEntityNameProperties(collectionEntity.getBaseEntityName());
		request.debug(collectionEntityProperties);
		assert(isArray(collectionEntityProperties));
	}
	
	public void function getAPIResponseForEntityNameTest(){
		var accountData = {
			accountid = "",
			firstName = "john",
			lastName = "rambo"
		};
		var account = createPersistedTestEntity('account',accountData);
		var propertyIdentifiers = "";
		var apiResponse = variables.service.getAPIResponseForEntityName('account',propertyIdentifiers);
		request.debug(apiResponse);
		assert(isStruct(apiResponse));
	}
	
	public void function getAPIResponseForEntityNameTest_with_propertyIdentifier_parameters(){
		var accountData = {
			accountid = "",
			firstName = "john",
			lastName = "rambo"
		};
		var account = createPersistedTestEntity('account',accountData);
		var propertyIdentifiers = "Account.lastName,Account.firstName";
		var apiResponse = variables.service.getAPIResponseForEntityName('account',propertyIdentifiers);
		
		assertTrue(isStruct(apiResponse));
	}
	
	public void function getAPIResponseForBasicEntityWIthIDTest(){
		var accountData = {
			accountid = "",
			firstName = "john",
			lastName = "rambo"
		};
		var account = createPersistedTestEntity('account',accountData);
		
		var apiResponse = variables.service.getAPIResponseForBasicEntityWithID('account',account.getAccountID());
		request.debug(apiResponse);
	}
	
	public void function getAPIResponseForBasicEntityWIthIDTest_with_propertyIdentifier_parameters(){
		var accountData = {
			accountid = "",
			firstName = "john",
			lastName = "rambo"
		};
		var account = createPersistedTestEntity('account',accountData);
		
		var propertyIdentifiersList = "Account.firstName,Account.lastName";
		
		var apiResponse = variables.service.getAPIResponseForBasicEntityWithID('account',account.getAccountID(), propertyIdentifiersList);
		assertTrue(isStruct(apiResponse));
	}
	
	public void function getAPIResponseForCollectionTest(){
		var accountData = {
			accountid = "",
			firstName = "john",
			lastName = "rambo"
		};
		var account = createPersistedTestEntity('account',accountData);
		
		var collectionEntityData = {
			collectionid = '',
			collectionCode = 'RyansAccountOrders',
			collectionName = 'RyansAccountOrders',
			collectionConfig = '
				{
					"baseEntityName":"SlatwallAccount",
					"baseEntityAlias":"Account"
					
				}
			',
			baseEntityName = "SlatwallAccount"
		};
		var collectionEntity = createPersistedTestEntity('collection',collectionEntityData);
		
		var apiResponse = variables.service.getAPIResponseForCollection(collectionEntity);
		request.debug(apiResponse);
	}
	
	public void function getAPIResponseForCollectionTest_with_propertyIdentifier_parameters(){
		var accountData = {
			accountid = "",
			firstName = "john",
			lastName = "rambo"
		};
		var account = createPersistedTestEntity('account',accountData);
		
		var collectionEntityData = {
			collectionid = '',
			collectionCode = 'RyansAccountOrders',
			collectionName = 'RyansAccountOrders',
			collectionConfig = '
				{
					"baseEntityName":"SlatwallAccount",
					"baseEntityAlias":"Account"
					
				}
			',
			baseEntityName = "SlatwallAccount"
		};
		var collectionEntity = createPersistedTestEntity('collection',collectionEntityData);
		
		var propertyIdentifiersList = "Account.firstName,Account.lastName";
		
		var apiResponse = variables.service.getAPIResponseForCollection(collectionEntity,propertyIdentifiersList);
		request.debug(apiResponse);
	}
	
	public void function createTransientCollectionTest(){
		var transientCollection = variables.service.createTransientCollection('account');
		request.debug(transientCollection);
	}
	
}


