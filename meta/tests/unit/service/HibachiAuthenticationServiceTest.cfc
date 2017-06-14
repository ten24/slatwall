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
		
		variables.service = request.slatwallScope.getService("hibachiAuthenticationService");
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
		var canRead = variables.service.authenticateEntityCrudByAccount("read","order",peasantyAccount);
		assert(canRead);
		
		//now let's add a record
		var orderData = { 
			orderID=""
		};
		var order = createPersistedTestEntity('Order',orderData);
		
		var otherOrderData = {
			orderID=""
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
		
		
		var restrictionConfig = serializeJson(collectionEntity.getCollectionConfigStruct()['filterGroups']); 
		var permissionRecordRestrictionData = {
			permissionRecordRestrictionID="",
			permission={
				permissionID=permission.getPermissionID()
			},
			restrictionConfig=restrictionConfig
		};
		var permissionRecordRestriction = createPersistedTestEntity('PermissionRecordRestriction',permissionRecordRestrictionData);
		permission.addPermissionRecordRestriction(permissionRecordRestriction);
		permissionRecordRestriction.setPermission(permission);
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
		assertEquals(arraylen(permissionRecordRestrictions),1);
		//verify that we have refined the list based on restrictions
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
		
		var orderItemCollectionList = request.slatwallScope.getService('orderService').getOrderItemCollectionList();
		orderItemCollectionList.setRequestAccount(peasantyAccount);
		orderItemCollectionList.setDisplayProperties('order.orderID,orderItemID');
		
		orderItemCollectionList.addFilter('orderItemID','#orderItem.getOrderItemID()#,#otherOrderItem.getOrderItemID()#','IN');
		var orderItemRecords = orderItemCollectionList.getRecords();
		
		debug(orderItemRecords);
		
		//verify that when records was applied that our order record permissions are also applied if our display options include order data
		
		assertEquals(arraylen(orderItemRecords),1);		
		
	}
	
	
}


