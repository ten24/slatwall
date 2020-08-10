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
		
		//variables.service = request.slatwallScope.getService("hibachiAuthenticationService");
		variables.service = variables.mockService.getHibachiAuthenticationServiceMock();
		
		var settingData = {
			settingID="",
			settingName="globalDisableRecordLevelPermissions",
			settingValue=0
		};
		var settingEntity = createPersistedTestEntity('Setting',settingData);
	}

	// getAuthenticationSubsystemNamesArray()
	/**
	* @test
	*/
	public void function getAuthenticationSubsystemNamesArray_returns_more_than_three_because_of_integrations() {
		var subsytemNamesArray = variables.service.getAuthenticationSubsystemNamesArray();
		assert(arrayLen(subsytemNamesArray) > 3);
	}

	// authenticateActionByAccount()
	/**
	* @test
	*/
	public void function authenticateActionByAccount_returns_false_for_mura_integration() {
		assertFalse( variables.service.authenticateActionByAccount('mura:main.default', request.slatwallScope.newEntity('Account')) );
	}
	/**
	* @test
	*/
	public void function getActionAuthenticationDetailsByAccountTest_recordLevelPerms(){
		var accountData = {
			accountID=""
			
		};
		var peasantyAccount = createPersistedTestEntity('Account',accountData);
		//make sure the account is going to enforce permission groups
		peasantyAccount.setSuperUserFlag(false);

		//set up a 		
		var permissionGroupData ={
			permissionGroupID="",
			permissionGroupName=createUUID()&'testPermgroup'
		};
		var permissionGroup = createPersistedTestEntity('PermissionGroup',permissionGroupData);
		peasantyAccount.addPermissionGroup(permissionGroup);
		permissionGroup.addAccount(peasantyAccount);
		
		assert(arrayLen(peasantyAccount.getPermissionGroups()));
		assert(arrayLen(permissionGroup.getAccounts()));
		
		//set up the account so that they can read orders
		var permissionData = {
			permissionID="",
			accessType="entity",
			entityClassName="Order",
			allowReadFlag=1
		};
		var permission = createPersistedTestEntity('Permission',permissionData);
		permission.setAccessType('entity');
		permission.setEntityClassName('Order');
		permission.setPermissionGroup(permissionGroup);
		permissionGroup.addPermission(permission);
		
		assert(!isNull(permission.getPermissionGroup()));
		//double check that read perms are good so far
		persistTestEntity(permissionGroup,{});
		var canRead = variables.service.authenticateEntityCrudByAccount("read","order",peasantyAccount);
		assert(canRead);
		
		//now let's add a record
		var orderData = { 
			orderID="",
			orderNumber=1
		};
		var order = createPersistedTestEntity('Order',orderData);
		
		var otherOrderData = {
			orderID="",
			orderNumber=2
		};
		
		var otherOrder = createPersistedTestEntity('Order',otherOrderData);
		//verify ouside of having an account that we can get all records
		var allDataCollection = createTestEntity('collection');
		allDataCollection.setCollectionObject('Order');
		allDataCollection.addFilter('orderID',"#order.getOrderID()#,#otherOrder.getOrderID()#",'IN');
		assertEquals(arraylen(allDataCollection.getRecords()),2);
		//set the permission applied flag back to false so we can test that the perms we create below can be applied and tested later
		allDataCollection.setPermissionAppliedFlag(false);
		
		//now record level perms restrictions
		//user should not have access to other order
		var collectionEntity = createTestEntity('Collection');
		collectionEntity.setCollectionObject('Order');
		collectionEntity.addFilter('orderID',order.getOrderID(),'=');
		
		
		var collectionConfig = serializeJson(collectionEntity.getCollectionConfigStruct()); 
		var permissionRecordRestrictionData = {
			permissionRecordRestrictionID="",
			permission={
				permissionID=permission.getPermissionID()
			}
		};
		var permissionRecordRestriction = createPersistedTestEntity('PermissionRecordRestriction',permissionRecordRestrictionData);
		
		
		permission.addPermissionRecordRestriction(permissionRecordRestriction);
		permissionRecordRestriction.setPermission(permission);
		
		permissionRecordRestriction.setCollectionConfig(collectionConfig);
		
		PersistTestEntity(permissionRecordRestriction,{});
		assert(!isNull(permissionRecordRestriction.getPermission()));
		assert(permissionRecordRestriction.getPermission().getEntityClassName() == 'Order');
		assert(arraylen(permission.getPermissionRecordRestrictions()));
		
		//make this request use our account with restrictions 
		allDataCollection.setRequestAccount(peasantyAccount);
		//assert that we can find the pemission record
		var permissionRecordRestrictionCollectionList = request.slatwallScope.getService('HibachiCollectionService').getPermissionRecordRestrictionCollectionList();
		permissionRecordRestrictionCollectionList.setPermissionAppliedFlag(true);
		//permissionRecordRestrictionCollectionList.setDisplayProperties('permission.entityClassName');
		permissionRecordRestrictionCollectionList.addFilter('permission.accessType','entity');
		permissionRecordRestrictionCollectionList.addFilter('permission.entityClassName','#allDataCollection.getCollectionObject()#');
		permissionRecordRestrictionCollectionList.addFilter('permission.permissionGroup.accounts.accountID',peasantyAccount.getAccountID());
		
		var permissionRecordRestrictions = permissionRecordRestrictionCollectionList.getRecords();
		request.slatwallScope.getService('hibachiAuthenticationService').clearVariablesKey('permissionRecordRestrictionMap');
		request.slatwallScope.getService('hibachiAuthenticationService').loadPermissionRecordRestrictionsCache();
		assertEquals(arraylen(permissionRecordRestrictions),1);
		//verify that we have refined the list based on restrictions
		debug(allDataCollection.getPermissionAppliedFlag());
		request.slatwallScope.getService('HibachiCacheService').setCache({});
		assertEquals(arraylen(allDataCollection.getRecords(true)),1);
		
		
		
		//set up order items so we can record level restrict them based on price
		var orderItemData = {
			orderItemID="",
			price=40
		};
		var orderItem = createPersistedTestEntity('OrderItem',orderItemData);
		
		var otherOrderItemData = {
			orderItemID="",
			price=10
		};
		var otherOrderItem = createPersistedTestEntity('OrderItem',otherOrderItemData);
		
		orderItem.setOrder(order);
		order.addOrderItem(orderItem);
		
		otherOrderItem.setOrder(otherOrder);
		otherOrder.addOrderItem(otherOrderItem);
		ormflush();
		assert(arraylen(order.getOrderItems()));
		assert(arraylen(otherorder.getOrderItems()));
		
		var orderItemCollectionList = request.slatwallScope.getService('orderService').getOrderItemCollectionList();
		orderItemCollectionList.setRequestAccount(peasantyAccount);
		orderItemCollectionList.setDisplayProperties('orderItemID,price,order.orderID');
		
		orderItemCollectionList.addFilter('orderItemID','#orderItem.getOrderItemID()#,#otherOrderItem.getOrderItemID()#','IN');
		var orderItemRecords = orderItemCollectionList.getRecords(true);
		//verify that when records was applied that our order record permissions are also applied if our display options include order data
		
		
		assertEquals(arraylen(orderItemRecords),1);	
		
	}
	
	/**
	* @test
	*/
	public void function getActionAuthenticationDetailsByAccountTest_recordLevelPerms_fkcolumnAccount(){
		
		//set up restricted user
		var accountData = {
			accountID=""
			
		};
		var peasantyAccount = createPersistedTestEntity('Account',accountData);
		//make sure the account is going to enforce permission groups
		peasantyAccount.setSuperUserFlag(false);
		
		

		//set up a permission Group
		var permissionGroupData ={
			permissionGroupID="",
			permissionGroupName=createUUID()&'testPermgroup'
		};
		var permissionGroup = createPersistedTestEntity('PermissionGroup',permissionGroupData);
		peasantyAccount.addPermissionGroup(permissionGroup);
		permissionGroup.addAccount(peasantyAccount);
		
		assert(arrayLen(peasantyAccount.getPermissionGroups()));
		assert(arrayLen(permissionGroup.getAccounts()));
		
		
		
		//set up the account so that they can read orders
		var permissionData = {
			permissionID="",
			accessType="entity",
			entityClassName="Order",
			allowReadFlag=1
		};
		var permission = createPersistedTestEntity('Permission',permissionData);
		permission.setAccessType('entity');
		permission.setEntityClassName('Order');
		permission.setPermissionGroup(permissionGroup);
		permissionGroup.addPermission(permission);
		
		assert(!isNull(permission.getPermissionGroup()));
		
		
		
		
		//set up the account so that they can read account
		var accountPermissionData = {
			permissionID="",
			accessType="entity",
			entityClassName="Account",
			allowReadFlag=1
		};
		var accountPermission = createPersistedTestEntity('Permission',accountPermissionData);
		accountPermission.setAccessType('entity');
		accountPermission.setEntityClassName('Account');
		accountPermission.setPermissionGroup(permissionGroup);
		permissionGroup.addPermission(accountPermission);
		
		assert(!isNull(accountPermission.getPermissionGroup()));
		assertEquals(arraylen(permissionGroup.getPermissions()),2);
		
		
		persistTestEntity(permissionGroup,{});
		//double check that read perms are good so far
		var canRead = variables.service.authenticateEntityCrudByAccount("read","order",peasantyAccount);
		assert(canRead);
		var canRead = variables.service.authenticateEntityCrudByAccount("read","Account",peasantyAccount);
		assert(canRead);
		
		
		
		//now let's add two order records
		var orderData = { 
			orderID="",
			orderNumber=1
		};
		var order = createPersistedTestEntity('Order',orderData);
		
		var otherOrderData = {
			orderID="",
			orderNumber=2
		};
		
		var otherOrder = createPersistedTestEntity('Order',otherOrderData);
		
		
		//verify ouside of having an account that we can get all records
		var allDataCollection = createTestEntity('collection');
		allDataCollection.setCollectionObject('Order');
		allDataCollection.addFilter('orderID',"#order.getOrderID()#,#otherOrder.getOrderID()#",'IN');
		
		assertEquals(arraylen(allDataCollection.getRecords()),2);
		//set the permission applied flag back to false so we can test that the perms we create below can be applied and tested later
		allDataCollection.setPermissionAppliedFlag(false);
		
		
		
		//now record level perms restrictions
		//user should not have access to other order
		var collectionEntity = createTestEntity('Collection');
		collectionEntity.setCollectionObject('Order');
		collectionEntity.addFilter('orderID',order.getOrderID(),'=');
		
		
		var collectionConfig = serializeJson(collectionEntity.getCollectionConfigStruct()); 
		var permissionRecordRestrictionData = {
			permissionRecordRestrictionID="",
			permission={
				permissionID=permission.getPermissionID()
			}
		};
		var permissionRecordRestriction = createPersistedTestEntity('PermissionRecordRestriction',permissionRecordRestrictionData);
		
		
		permission.addPermissionRecordRestriction(permissionRecordRestriction);
		permissionRecordRestriction.setPermission(permission);
		
		permissionRecordRestriction.setCollectionConfig(collectionConfig);
		
		PersistTestEntity(permissionRecordRestriction,{});
		assert(!isNull(permissionRecordRestriction.getPermission()));
		assert(permissionRecordRestriction.getPermission().getEntityClassName() == 'Order');
		assert(arraylen(permission.getPermissionRecordRestrictions()));
		
		ormflush();
		allDataCollection.setRequestAccount(peasantyAccount);
		request.slatwallScope.getService('HibachiCacheService').setCache({});
		assertEquals(arraylen(allDataCollection.getRecords(true)),1);
		
		//now record level perms restrictions
		//user should not have access to account
		var restrictedAccountData = {
			accountID=""
		};
		var restrictedAccount = createPersistedTestEntity('Account',restrictedAccountData);
		
		collectionEntity = createTestEntity('Collection');
		collectionEntity.setCollectionObject('Account');
		collectionEntity.addFilter('accountID',restrictedAccount.getAccountID(),'!=');
		
		
		collectionConfig = serializeJson(collectionEntity.getCollectionConfigStruct()); 
		permissionRecordRestrictionData = {
			permissionRecordRestrictionID="",
			permission={
				permissionID=accountPermission.getPermissionID()
			}
		};
		var accountPermissionRecordRestriction = createPersistedTestEntity('PermissionRecordRestriction',permissionRecordRestrictionData);
		
		
		accountPermission.addPermissionRecordRestriction(accountPermissionRecordRestriction);
		accountPermissionRecordRestriction.setPermission(accountPermission);
		
		accountPermissionRecordRestriction.setCollectionConfig(collectionConfig);
		
		PersistTestEntity(accountPermissionRecordRestriction,{});
		assert(!isNull(accountPermissionRecordRestriction.getPermission()));
		assert(accountPermissionRecordRestriction.getPermission().getEntityClassName() == 'Account');
		assertEquals(arraylen(accountPermission.getPermissionRecordRestrictions()),1);
		
		order.setAccount(restrictedAccount);
		ormflush();
		request.slatwallScope.getService('HibachiCacheService').setCache({});
		//make this request use our account with restrictions 
		var allDataCollection2 = createTestEntity('collection');
		allDataCollection2.setCollectionObject('Order');
		allDataCollection2.addFilter('orderID',"#order.getOrderID()#,#otherOrder.getOrderID()#",'IN');
		allDataCollection2.setRequestAccount(peasantyAccount);
		allDataCollection2.applyPermissions();
		//verify that we have refined the list based on restrictions
		
		assertEquals(arraylen(allDataCollection2.getRecords(true)),0);
		
	}
	
	
}


