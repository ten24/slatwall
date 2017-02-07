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
		
		variables.service = request.slatwallScope.getBean("hibachiCollectionService");
		variables.defaultCollectionOptions = setUpCollectionOptions({});
	}
	
	private struct function setUpCollectionOptions(required struct rc){
		var currentPage = 1;
		if(structKeyExists(arguments.rc,'P:Current')){
			currentPage = arguments.rc['P:Current'];
		}
		var pageShow = 10;
		if(structKeyExists(arguments.rc,'P:Show')){
			pageShow = arguments.rc['P:Show'];
		}
		
		var keywords = "";
		if(structKeyExists(arguments.rc,'keywords')){
			keywords = arguments.rc['keywords'];
		}
		var filterGroupsConfig = ""; 
		if(structKeyExists(arguments.rc,'filterGroupsConfig')){
			filterGroupsConfig = arguments.rc['filterGroupsConfig'];
		}
		var joinsConfig = ""; 
		if(structKeyExists(arguments.rc,'joinsConfig')){
			joinsConfig = arguments.rc['joinsConfig'];
		}
		
		var propertyIdentifiersList = "";
		if(structKeyExists(arguments.rc,"propertyIdentifiersList")){
			propertyIdentifiersList = arguments.rc['propertyIdentifiersList'];
		}
		
		var columnsConfig = "";
		if(structKeyExists(arguments.rc,'columnsConfig')){
			columnsConfig = arguments.rc['columnsConfig'];
		}
		
		var isDistinct = false;
		if(structKeyExists(arguments.rc, "isDistinct")){
			isDistinct = arguments.rc['isDistinct'];
		}
		
		var allRecords = false;
		if(structKeyExists(arguments.rc,'allRecords')){
			allRecords = arguments.rc['allRecords'];
		}
		
		var defaultColumns = false;
		if(structKeyExists(arguments.rc,'defaultColumns')){
			defaultColumns = arguments.rc['defaultColumns'];
		}
		
		var collectionOptions = {
			currentPage=currentPage,
			pageShow=pageShow,
			keywords=keywords,
			filterGroupsConfig=filterGroupsConfig,
			joinsConfig=joinsConfig,
			propertyIdentifiersList=propertyIdentifiersList,
			isDistinct=isDistinct,
			columnsConfig=columnsConfig,
			allRecords=allRecords,
			defaultColumns=defaultColumns
		};
		return collectionOptions;
	}
	
	public void function getHibachiPropertyIdentifierByCollectionPropertyIdentifierTest(){
		var collectionPropertyIdentifier = '_sku_product.brand.brandID';
		var hibachiPropertyIdentifier = variables.service.getHibachiPropertyIdentifierByCollectionPropertyIdentifier(collectionPropertyIdentifier);
		assertEquals(hibachiPropertyIdentifier,'product.brand.brandid');
		
		var collectionPropertyIdentifier = 'Account.firstName';
		var hibachiPropertyIdentifier = variables.service.getHibachiPropertyIdentifierByCollectionPropertyIdentifier(collectionPropertyIdentifier);
		
	}
	
	public void function getCapitalCaseTest(){
		MakePublic(variables.service,'capitalCase');
		var word = 'testingword';
		word = variables.service.capitalCase(word);
		assertEquals('Testingword',word);
	}
	
	public void function getTransientCollectionByEntityNameTest(){
		var entityName = 'product';
		var collectionEntity = variables.service.getTransientCollectionByEntityName(entityName,variables.defaultCollectionOptions);
		assertEquals('product',collectionEntity.getCollectionObject());
		assertEquals('product',collectionEntity.getCollectionConfigStruct().baseentityname);
		assertEquals('_product',collectionEntity.getCollectionConfigStruct().baseentityalias);
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
		var collectionEntity = variables.service.getTransientCollectionByEntityName(entityName,variables.defaultCollectionOptions);
		
		//var paginatedCollectionOfEntities = collectionEntity.getPageRecords();
		
		var entityProperties = variables.service.getDefaultPropertiesByEntityName( entityName );
		var propertyIdentifiersList = variables.service.getPropertyIdentifiersList(entityProperties);
		var propertyIdentifiers = ListToArray(propertyIdentifiersList);
		var formattedPageRecords = variables.service.getFormattedPageRecords(collectionEntity,propertyIdentifiers);
		assertTrue(arraylen(formattedPageRecords['pageRecords']));
	}
	
	public void function collectionsExportTest(){
		var collectionConfig = '{
			"baseEntityName":"Account",
			"baseEntityAlias":"_account",
			"columns":[{"isDeletable":false,"isSearchable":true,"title":"accountID","isVisible":false,"ormtype":"id","propertyIdentifier":"_account.accountID","isExportable":true},{"isDeletable":true,"isSearchable":true,"title":"Super User","isVisible":true,"ormtype":"boolean","propertyIdentifier":"_account.superUserFlag","isExportable":true},{"isDeletable":true,"isSearchable":true,"title":"First Name","isVisible":true,"ormtype":"string","propertyIdentifier":"_account.firstName","isExportable":true},{"isDeletable":true,"isSearchable":true,"title":"Last Name","isVisible":true,"ormtype":"string","propertyIdentifier":"_account.lastName","isExportable":true},{"isDeletable":true,"isSearchable":true,"title":"Company","isVisible":true,"ormtype":"string","propertyIdentifier":"_account.company","isExportable":true},{"isDeletable":true,"isSearchable":true,"title":"Account Locked","isVisible":true,"ormtype":"timestamp","propertyIdentifier":"_account.loginLockExpiresDateTime","isExportable":true},{"isDeletable":true,"isSearchable":true,"title":"Failed Login Attempts","isVisible":true,"ormtype":"integer","propertyIdentifier":"_account.failedLoginAttemptCount","isExportable":true},{"isDeletable":true,"isSearchable":true,"title":"Tax Exempt","isVisible":true,"ormtype":"boolean","propertyIdentifier":"_account.taxExemptFlag","isExportable":true},{"isDeletable":true,"isSearchable":true,"title":"URL Title","isVisible":true,"ormtype":"string","propertyIdentifier":"_account.urlTitle","isExportable":true}]
		}';
		var collectionData={
			collectionID="",
			collectionConfig=collectionConfig,
			collectionObject="Account"
		};
		var collectionEntity = createPersistedTestEntity('Collection',collectionData);
		var data = {
			collectionExportID=collectionEntity.getCollectionID()
		};
		var hibachiServiceFake = {};
		hibachiSerivceFake.export = exportFake;
		variables.service.setHibachiService(hibachiSerivceFake);
		variables.service.collectionsExport(data);
	}
	
	
	
	private void function exportFake(){
		return;
	}
	
	public void function getExportableColumnsByCollectionConfigTest(){
		var collectionConfig = '{
			"baseEntityName":"Account",
			"baseEntityAlias":"_account",
			"columns":[
				{"isDeletable":false,"isSearchable":true,"title":"accountID","isVisible":false,"ormtype":"id","propertyIdentifier":"_account.accountID","isExportable":true},
				{"isDeletable":true,"isSearchable":true,"title":"Super User","isVisible":true,"ormtype":"boolean","propertyIdentifier":"_account.superUserFlag","isExportable":true},
				{"isDeletable":true,"isSearchable":true,"title":"First Name","isVisible":true,"ormtype":"string","propertyIdentifier":"_account.firstName","isExportable":true},
				{"isDeletable":true,"isSearchable":true,"title":"Last Name","isVisible":true,"ormtype":"string","propertyIdentifier":"_account.lastName","isExportable":true},
				{"isDeletable":true,"isSearchable":true,"title":"Failed Login Attempts","isVisible":true,"ormtype":"integer","propertyIdentifier":"_account.failedLoginAttemptCount","isExportable":true},
				{"isDeletable":true,"isSearchable":true,"title":"Tax Exempt","isVisible":true,"ormtype":"boolean","propertyIdentifier":"_account.taxExemptFlag","isExportable":true},
				{"isDeletable":true,"isSearchable":true,"title":"URL Title","isVisible":true,"ormtype":"string","propertyIdentifier":"_account.urlTitle","isExportable":true},
				
				{"isDeletable":true,"isSearchable":true,"title":"Company","isVisible":true,"ormtype":"string","propertyIdentifier":"_account.company","isExportable":false},
				{"isDeletable":true,"isSearchable":true,"title":"Account Locked","isVisible":true,"ormtype":"timestamp","propertyIdentifier":"_account.loginLockExpiresDateTime","isExportable":false}
			]
		}';
		var collectionData={
			collectionID="",
			collectionConfig=collectionConfig
		};
		var collectionEntity = createPersistedTestEntity('Collection',collectionData);
		var exportableColumns = variables.service.getExportableColumnsByCollectionConfig(collectionEntity.getCollectionConfigStruct());
		for(var column in exportableColumns){
			assert(column.propertyIdentifier != '_account.company' && column.propertyIdentifier != '_account.loginLockExpiresDateTime');
		}
		
	}
	
	public void function getHeadersListByCollectionConfigColumnsTest(){
		var columns = [
			{"isDeletable"=false,"isSearchable"=true,"title"="accountID","isVisible"=false,"ormtype"="id","propertyIdentifier"="_account.accountID","isExportable"=true},
			{"isDeletable"=true,"isSearchable"=true,"title"="Super User","isVisible"=true,"ormtype"="boolean","propertyIdentifier"="_account.superUserFlag","isExportable"=true},
			{"isDeletable"=true,"isSearchable"=true,"title"="First Name","isVisible"=true,"ormtype"="string","propertyIdentifier"="_account.firstName","isExportable"=true},
			{"isDeletable"=true,"isSearchable"=true,"title"="Last Name","isVisible"=true,"ormtype"="string","propertyIdentifier"="_account.lastName","isExportable"=true},
			{"isDeletable"=true,"isSearchable"=true,"title"="Failed Login Attempts","isVisible"=true,"ormtype"="integer","propertyIdentifier"="_account.failedLoginAttemptCount","isExportable"=true},
			{"isDeletable"=true,"isSearchable"=true,"title"="Tax Exempt","isVisible"=true,"ormtype"="boolean","propertyIdentifier"="_account.taxExemptFlag","isExportable"=true},
			{"isDeletable"=true,"isSearchable"=true,"title"="URL Title","isVisible"=true,"ormtype"="string","propertyIdentifier"="_account.urlTitle","isExportable"=true},
			
			{"isDeletable"=true,"isSearchable"=true,"title"="Company","isVisible"=true,"ormtype"="string","propertyIdentifier"="_account.company","isExportable"=false},
			{"isDeletable"=true,"isSearchable"=true,"title"="Account Locked","isVisible"=true,"ormtype"="timestamp","propertyIdentifier"="_account.loginLockExpiresDateTime","isExportable"=false}
		];
		var collectionConfig = '{
			"baseEntityName":"Account",
			"baseEntityAlias":"_account"
		}';
		var collectionData={
			collectionID="",
			collectionConfig=collectionConfig,
			collectionObject="Account"
		};
		var collectionEntity = createPersistedTestEntity('Collection',collectionData);
		collectionEntity.getCollectionConfigStruct().columns = columns;
		
		assertEquals(variables.service.getHeadersListByCollection(collectionEntity),'accountID,superUserFlag,firstName,lastName,failedLoginAttemptCount,taxExemptFlag,urlTitle,company,loginLockExpiresDateTime');
	}
	
	public void function getPropertyIdentifiersListTest(){
		var entityName = 'product';
		var entityProperties = variables.service.getPropertiesByEntityName( entityName );
		var propertyIdentifiersList = variables.service.getPropertyIdentifiersList(entityProperties);
		assertTrue(listLen(propertyIdentifiersList));
		
		var test = request.slatwallScope.getService('hibachiValidationService').getValidationsByContext(variables.service.newCollection(),'delete');
	}
	
//	public void function getEntityNameColumnProperties_returns_valid_array() {
//		var result = variables.service.getEntityNameColumnProperties( 'Account' );
//		//addToDebug(result);
//		assert( isArray( result ) );
//	}
//	
//	// getEntityNameProperties()
//	public void function getEntityNameProperties_returns_valid_array() {
//		var result = variables.service.getEntityNameProperties( 'Account',variables.defaultCollectionOptions );
//		//addToDebug(result);
//		assert( isArray( result ) );
//	}
	
//	public void function getEntityNameProperties_returns_properties_in_correct_sorted_order() {
//		var result = variables.service.getEntityNameProperties( 'Account' );
//		
//		assertEquals( "accountAddresses", result[1].propertyIdentifier );
//		assertEquals( "accountAuthentications", result[2].propertyIdentifier );
//		assertEquals( "accountContentAccesses", result[3].propertyIdentifier );
//		assertEquals( "accountEmailAddresses", result[4].propertyIdentifier );
//		assertEquals( "accountID", result[5].propertyIdentifier );
//		assertEquals( "accountLoyalties", result[6].propertyIdentifier );
//		//addToDebug(result);
//	}
//	
//	public void function getEntityNameOptionsTest(){
//		var collectionEntityData = {
//			collectionid = '',
//			collectionObject = 'Account'
//		};
//		var collectionEntity = createTestEntity('collection',collectionEntityData);
//		var collectionEntityProperties = variables.service.getEntityNameProperties(collectionEntity.getCollectionObject());
//		//addToDebug(collectionEntityProperties);
//		assert(isArray(collectionEntityProperties));
//	}
	
	public void function getAPIResponseForEntityNameTest(){
		var accountData = {
			accountid = "",
			firstName = "john",
			lastName = "rambo"
		};
		var account = createPersistedTestEntity('account',accountData);
		var propertyIdentifiers = "";
		var collectionOptions = setupCollectionOptions({propertyIdentifiersList=propertyIdentifiers});
		var apiResponse = variables.service.getAPIResponseForEntityName('account',collectionOptions);
		//addToDebug(apiResponse);
		assert(isStruct(apiResponse));
	}
	
	public void function getAPIResponseForEntityNameTest_with_propertyIdentifier_parameters(){
		var accountData = {
			accountid = "",
			firstName = "john",
			lastName = "rambo"
		};
		var account = createPersistedTestEntity('account',accountData);
		var propertyIdentifiers = "lastName,firstName";
		var collectionOptions = setupCollectionOptions({propertyIdentifiersList=propertyIdentifiers});
		var apiResponse = variables.service.getAPIResponseForEntityName('account',collectionOptions,false);
		
		assertTrue(isStruct(apiResponse));
	}
	
	public void function getAPIResponseForBasicEntityWIthIDTest(){
		var accountData = {
			accountid = "",
			firstName = "john",
			lastName = "rambo"
		};
		var account = createPersistedTestEntity('account',accountData);
		
		
		var apiResponse = variables.service.getAPIResponseForBasicEntityWithID('account',account.getAccountID(),variables.defaultCollectionOptions);
		//addToDebug(apiResponse);
	}
	
	/*public void function getAPIResponseForBasicEntityWIthIDTest_with_propertyIdentifier_parameters(){
		var accountData = {
			accountid = "asdfs",
			firstName = "john",
			lastName = "rambo"
		};
		var account = createPersistedTestEntity('account',accountData);
		var collectionOptions = variables.defaultCollectionOptions;
		var propertyIdentifiersList = "Account.firstName,Account.lastName";
		collectionOptions.propertyIdentifiersList = propertyIdentifiersList;
		var apiResponse = variables.service.getAPIResponseForBasicEntityWithID('account',account.getAccountID(), collectionOptions);
		assertTrue(isStruct(apiResponse));
	}*/
	
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
			collectionObject="Account",
			collectionConfig = '
				{
					"baseEntityName":"SlatwallAccount",
					"baseEntityAlias":"_ccount"
					
				}
			'
		};
		var collectionEntity = createPersistedTestEntity('collection',collectionEntityData);
		
		var apiResponse = variables.service.getAPIResponseForCollection(collectionEntity,variables.defaultCollectionOptions);
		//addToDebug(apiResponse);
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
					"baseEntityAlias":"_account"
					
				}
			',
			collectionObject = "Account"
		};
		var collectionEntity = createPersistedTestEntity('collection',collectionEntityData);
		
		var propertyIdentifiersList = "firstName,lastName";
		
		var apiResponse = variables.service.getAPIResponseForCollection(collectionEntity,setupCollectionOptions({propertyIdentifiersList=propertyIdentifiersList}),false);
		//addToDebug(apiResponse);
	}
	
	
}


