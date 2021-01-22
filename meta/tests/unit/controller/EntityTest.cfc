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
		variables.controllerSlatwallFW1Application = createObject("component", "Slatwall.Application");
		variables.entityController = getEntityController();
		
		

	}

	private any function getEntityController(){
		var entityController = createObject("component",'Slatwall.admin.controllers.entity');
		entityController.framework = variables.controllerSlatwallFW1Application;
		entityController.setFW(variables.controllerSlatwallFW1Application);
		entityController.setAddressService(createObject("component","Slatwall.model.service.AddressService"));
		entityController.setCurrencyService(createObject("component","Slatwall.model.service.CurrencyService"));
		entityController.setEmailService(createObject("component","Slatwall.model.service.EmailService"));
		entityController.setFileService(createObject("component","Slatwall.model.service.FileService"));
		entityController.setHibachiService(createObject("component","Slatwall.model.service.HibachiService"));
		entityController.setImageService(createObject("component","Slatwall.model.service.ImageService"));
		entityController.setMeasurementService(createObject("component","Slatwall.model.service.MeasurementService"));
		entityController.setOptionService(createObject("component","Slatwall.model.service.OptionService"));
		entityController.setOrderService(createObject("component","Slatwall.model.service.OrderService"));
		entityController.setPaymentService(createObject("component","Slatwall.model.service.PaymentService"));
		entityController.setPromotionService(createObject("component","Slatwall.model.service.PromotionService"));
		entityController.setScheduleService(createObject("component","Slatwall.model.service.ScheduleService"));
		entityController.setSettingService(createObject("component","Slatwall.model.service.SettingService"));
		entityController.setSkuService(createObject("component","Slatwall.model.service.SkuService"));
		entityController.setLoyaltyService(createObject("component","Slatwall.model.service.LoyaltyService"));
		entityController.setTypeService(createObject("component","Slatwall.model.service.TypeService"));

		return entityController;
	}

	/**
	* @test
	*/
	public void function loadEntityTest(){
		var accountData = {
			accountID=""
		};
		var account = createPersistedTestEntity('Account',accountData);

		var rc = {
			"slatAction"="entity.detailaccount",
			"accountID"=account.getAccountID(),
			$=request.slatwallScope
		};

		variables.entityController.before(rc=rc);
		
		variables.entityController.detailAccount(rc=rc);
		
		assert(structKeyExists(rc,'account'));
	}
	
	private void function redirectFake(){
		this.redirectCalled = true;
		this.redirectarguments = arguments;
	}
	
	/**
	* @test
	*/
	public void function detailPagePermissionsTest(){
		variables.controllerSlatwallFW1Application.redirect=redirectFake;
		variables.controllerSlatwallFW1Application.redirectCalled = false;
		
		var accountData = {
			accountID="",
			firstName="what Ho",
			lastName="knave"
			
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
		var canRead = request.slatwallScope.getService('HibachiAuthenticationService').authenticateEntityCrudByAccount("read","order",peasantyAccount);
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
		
		
		var permissionRecordRestrictionData = {
			permissionRecordRestrictionID="",
			permission={
				permissionID=permission.getPermissionID()
			}
		};
		var permissionRecordRestriction = createPersistedTestEntity('PermissionRecordRestriction',permissionRecordRestrictionData);
		permission.addPermissionRecordRestriction(permissionRecordRestriction);
		permissionRecordRestriction.setPermission(permission);
		permissionRecordRestriction.setCollectionConfig(serializeJson(collectionEntity.getCollectionConfigStruct()));
		PersistTestEntity(permissionRecordRestriction,{});
		assert(!isNull(permissionRecordRestriction.getPermission()));
		assert(permissionRecordRestriction.getPermission().getEntityClassName() == 'Order');
		assert(arraylen(permission.getPermissionRecordRestrictions()));
		
		debug(permissionRecordRestriction.getRestrictionConfig());
		
		//make this request use our account with restrictions 
		allDataCollection.setRequestAccount(peasantyAccount);
		//assert that we can find the pemission record
		var permissionRecordRestrictionCollectionList = request.slatwallScope.getService('HibachiCollectionService').getPermissionRecordRestrictionCollectionList();
		permissionRecordRestrictionCollectionList.setPermissionAppliedFlag(true);
		//permissionRecordRestrictionCollectionList.setDisplayProperties('permission.entityClassName');
		permissionRecordRestrictionCollectionList.addFilter('permission.accessType','entity');
		permissionRecordRestrictionCollectionList.addFilter('permission.entityClassName','#allDataCollection.getCollectionObject()#');
		permissionRecordRestrictionCollectionList.addFilter('permission.permissionGroup.accounts.accountID',peasantyAccount.getAccountID());
		
		var permissionRecordRestrictions = permissionRecordRestrictionCollectionList.getRecords(true);
		assertEquals(arraylen(permissionRecordRestrictions),1);
		//verify that we have refined the list based on restrictions
		allDataCollection.applyPermissions();
		debug(allDataCollection.getRecords(true));
		assertEquals(arraylen(allDataCollection.getRecords(true)),1);
		assertEquals(allDataCollection.getRecords(true)[1]['orderID'],order.getOrderID());
		request.slatwallScope.getSession().setAccount(peasantyAccount);
		
		
		
		var rc = {
			"slatAction"="entity.detailorder",
			"orderID"=otherOrder.getOrderID(),
			$=request.slatwallScope
		};
		ORMClearSession();
//try catch not working via postload method. Need to do manual assertion until I can figure out how to suppress error for assertion		
//		try{
//			variables.entityController.before(rc=rc);
//			//because we suppress redirect it will pass to other code
//	
//			variables.entityController.detailAccount(rc=rc);
//		}catch(any e){}
//		assert(!structKeyExists(rc,'order'));
		
	}


}


