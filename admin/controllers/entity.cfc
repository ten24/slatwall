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
component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiControllerEntity" {

	property name="addressService" type="any";
	property name="currencyService" type="any";
	property name="emailService" type="any";
	property name="fileService" type="any";
	property name="hibachiService" type="any";
	property name="imageService" type="any";
	property name="measurementService" type="any";
	property name="optionService" type="any";
	property name="orderService" type="any";
	property name="paymentService" type="any";
	property name="permissionService" type="any";
	property name="promotionService" type="any";
	property name="scheduleService" type="any";
	property name="settingService" type="any";
	property name="skuService" type="any";
	property name="loyaltyService" type="any";
	property name="typeService" type="any";

	this.publicMethods='';

	this.anyAdminMethods='';
	this.anyAdminMethods=listAppend(this.anyAdminMethods, 'saveSetting');
	this.anyAdminMethods=listAppend(this.anyAdminMethods, 'deleteSetting');
	this.anyAdminMethods=listAppend(this.anyAdminMethods, 'detailSetting');
	this.anyAdminMethods=listAppend(this.anyAdminMethods, 'editSetting');

	this.secureMethods='';
	this.secureMethods=listAppend(this.secureMethods, 'settings');
	this.secureMethods=listAppend(this.secureMethods, 'downloadFile');

	// Address Zone Location\
	public void function createAddressZoneLocation(required struct rc) {
		editAddressZoneLocation(rc);
	}

	public void function editAddressZoneLocation(required struct rc) {
		param name="rc.addressZoneID" default="";
		param name="rc.addressID" default="";

		rc.addressZoneLocation = getAddressService().getAddress( rc.addressID, true );
		rc.addressZone = getAddressService().getAddressZone( rc.addressZoneID );
		rc.edit=true;

		getFW().setView("admin:entity.detailaddresszonelocation");
	}

	public void function deleteAddressZoneLocation(required struct rc) {
		param name="rc.addressZoneID" default="";
		param name="rc.addressID" default="";

		rc.addressZoneLocation = getAddressService().getAddress( rc.addressID, true );
		rc.addressZone = getAddressService().getAddressZone( rc.addressZoneID );

		rc.addressZone.removeAddressZoneLocation( rc.addressZoneLocation );

		getFW().redirect(action="admin:entity.detailaddresszone", queryString="addressZoneID=#rc.addressZoneID#&messageKeys=admin.setting.deleteaddresszonelocation_success");
	}
	
	public void function deleteFormResponse(required struct rc) {
		param name="rc.formResponseID" default="";
		rc.formResponse = getService('formService').getFormResponse(rc.formResponseID);

		arguments.rc.sRedirectAction = "admin:entity.detailform";
		arguments.rc.sRedirectQS = "formID=#rc.formResponse.getForm().getFormID()#";
		genericDeleteMethod(entityName="formResponse", rc=arguments.rc);
	}

	// Country
	public void function editCountry(required struct rc) {
		rc.country = getAddressService().getCountry(rc.countryCode);
		rc.edit = true;
	}

	public void function detailCountry(required struct rc) {
		rc.country = getAddressService().getCountry(rc.countryCode);
	}

	// Currency
	public void function editCurrency(required struct rc) {
		rc.currency = getCurrencyService().getCurrency(rc.currencyCode);
		rc.edit = true;
	}

	public void function detailCurrency(required struct rc) {
		rc.currency = getCurrencyService().getCurrency(rc.currencyCode);
	}

	// File
	public void function downloadFile(required struct rc) {
		populateRenderAndRedirectFailureValues(arguments.rc);
		var file = getFileService().downloadFile(fileID=rc.fileID);

		if (file.hasErrors())
		{
			file.showErrorsAndMessages();
			renderOrRedirectFailure( defaultAction=arguments.rc.entityActionDetails.detailAction, maintainQueryString=true, rc=arguments.rc);
		}
	}

	// Email
	public void function preprocessEmail(required struct rc) {
		genericPreProcessMethod(entityName="Email", rc=arguments.rc);
		rc.email = getEmailService().processEmail(rc.email, rc, "createFromTemplate");
	}

	// Measurement Unit
	public void function editMeasurementUnit(required struct rc) {
		rc.measurementUnit = getMeasurementService().getMeasurementUnit(rc.unitCode);
		rc.edit = true;
	}

	public void function detailMeasurementUnit(required struct rc) {
		rc.measurementUnit = getMeasurementService().getMeasurementUnit(rc.unitCode);
	}


	// Order
	public void function detailOrder(required struct rc) {
		if(structKeyExists(rc,'subscriptionOrderItemID')){
			var subscriptionOrderItem = getService('orderService').getSubscriptionOrderItem(rc.subscriptionOrderItemID);
			if(!isNull(subscriptionOrderItem)){
				rc.order = subscriptionOrderItem.getOrderItem().getOrder();	
			}
		}
		genericDetailMethod(entityName="Order", rc=arguments.rc);
		if(!isNull(rc.order) && rc.order.getStatusCode() eq "ostNotPlaced") {
			rc.entityActionDetails.listAction = "admin:entity.listcartandquote";
			rc.entityActionDetails.backAction = "admin:entity.listcartandquote";
		}
	}

	public void function editOrder(required struct rc) {
		if(structKeyExists(rc,'subscriptionOrderItemID')){
			var subscriptionOrderItem = getService('orderService').getSubscriptionOrderItem(rc.subscriptionOrderItemID);
			if(!isNull(subscriptionOrderItem)){
				rc.order = subscriptionOrderItem.getOrderItem().getOrder();	
			}
		}
		genericEditMethod(entityName="Order", rc=arguments.rc);
		if(!isNull(rc.order) && rc.order.getStatusCode() eq "ostNotPlaced") {
			rc.entityActionDetails.listAction = "admin:entity.listcartandquote";
			rc.entityActionDetails.backAction = "admin:entity.listcartandquote";
		}
	}

	public void function listOrder(required struct rc) {
		genericListMethod(entityName="Order", rc=arguments.rc);

		arguments.rc.orderSmartList.addInFilter('orderStatusType.systemCode', 'ostNew,ostProcessing,ostOnHold,ostClosed,ostCanceled');
		arguments.rc.orderSmartList.addOrder("orderOpenDateTime|DESC");
	}

	// Order (Carts and quotes)
	public void function listCartAndQuote(required struct rc) {
		genericListMethod(entityName="Order", rc=arguments.rc);

		arguments.rc.orderSmartList.addInFilter('orderStatusType.systemCode', 'ostNotPlaced');
		arguments.rc.orderSmartList.addOrder("createdDateTime|DESC");

		arguments.rc.entityActionDetails.createAction="admin:entity.createOrder";
		getFW().setView("admin:entity.listorder");
	}

	// Order Payment
	public any function createorderpayment( required struct rc ) {
		param name="rc.orderID" type="string" default="";
		param name="rc.paymentMethodID" type="string" default="";

		rc.orderPayment = getOrderService().newOrderPayment();
		rc.order = getOrderService().getOrder(rc.orderID);
		rc.paymentMethod = getPaymentService().getPaymentMethod(rc.paymentMethodID);

		rc.edit = true;

	}

	// Order Return
	public any function createreturnorder( required struct rc ) {
		param name="rc.originalorderid" type="string" default="";

		rc.originalOrder = getOrderService().getOrder(rc.originalOrderID);

		rc.edit = true;
	}

	// Permission Group
	public void function editPermissionGroup(required struct rc){
		//rc.permissions = getPermissionService().getPermissions();
		rc.entityPermissionDetails = createObject("Slatwall.org.Hibachi.HibachiAuthenticationService").getEntityPermissionDetails();

		super.genericEditMethod('PermissionGroup',rc);
	}

	public void function createPermissionGroup(required struct rc){
		//rc.permissions = getPermissionService().getPermissions();
		rc.entityPermissionDetails = createObject("Slatwall.org.Hibachi.HibachiAuthenticationService").getEntityPermissionDetails();

		super.genericCreateMethod('PermissionGroup',rc);
	}

	public void function detailPermissionGroup(required struct rc){
		//rc.permissions = getPermissionService().getPermissions();
		rc.entityPermissionDetails = createObject("Slatwall.org.Hibachi.HibachiAuthenticationService").getEntityPermissionDetails();

		super.genericDetailMethod('PermissionGroup',rc);
	}

	// Promotion
	public void function createPromotion(required struct rc) {
		super.genericCreateMethod('Promotion', rc);

		if( rc.promotion.isNew() ) {
			rc.promotionPeriod = getPromotionService().newPromotionPeriod();
		}
	}

	// Setting
	public void function createSetting(required struct rc) {
		super.genericCreateMethod('Setting', rc);
		rc.pageTitle = rc.$.slatwall.rbKey('setting.#rc.settingName#');
	}

	// Sku Currency
	public void function createSkuCurrency(required struct rc) {
		super.genericCreateMethod('SkuCurrency', rc);
		rc.pageTitle = rc.$.slatwall.rbKey('admin.entity.editSkuCurrency', {currencyCode=rc.currencyCode});
	}

	public void function editSkuCurrency(required struct rc) {
		super.genericEditMethod('SkuCurrency', rc);
		rc.pageTitle = rc.$.slatwall.rbKey('admin.entity.editSkuCurrency', {currencyCode=rc.currencyCode});
	}

	// State
	public void function createState(required struct rc) {
		param name="rc.countryCode" default="";

		rc.country = getAddressService().getCountry( rc.countryCode );
		rc.state = getAddressService().newState();
		rc.state.setCountryCode( rc.countryCode );
		rc.edit = true;
	}

	public void function editState(required struct rc) {
		param name="rc.countryCode" default="";
		param name="rc.stateCode" default="";

		rc.country = getAddressService().getCountry( rc.countryCode );
		var arr = getAddressService().listState({stateCode=rc.stateCode, countryCode=rc.countryCode});
		rc.state =  arr[1];
		rc.edit = true;
	}

	public void function detailState(required struct rc) {
		param name="rc.countryCode" default="";
		param name="rc.stateCode" default="";

		rc.country = getAddressService().getCountry(rc.countryCode);
		var arr = getAddressService().listState({stateCode=rc.stateCode, countryCode=rc.countryCode});
		rc.state =  arr[1];
	}

	public void function deleteState(required struct rc) {
		param name="rc.countryCode" default="";
		param name="rc.stateCode" default="";

		rc.country = getAddressService().getCountry(rc.countryCode);
		var arr = getAddressService().listState({stateCode=rc.stateCode, countryCode=rc.countryCode});
		rc.state =  arr[1];

		// Check how the delete went
		var deleteOK = getAddressService().deleteState(rc.state);

		// Place the id in the URL for redirects in case this was a new entity before
		url['stateCode'] = rc.state.getStateCode();
		url['countryCode'] = rc.countryCode;

		// SUCCESS
		if (deleteOK) {
			// Show the Generica Action Success Message
			getHibachiScope().showMessage( replace(getHibachiScope().rbKey( "admin.entity.delete_success" ), "${itemEntityName}", rbKey('entity.state'), "all" ), "success");

			// Render or Redirect a Success
			renderOrRedirectSuccess( defaultAction="admin:entity.liststate", maintainQueryString=true, rc=arguments.rc);

		// FAILURE
		} else {

			// Show all of the specific messages & error messages for the entity
			entity.showErrorsAndMessages();

			// Render or Redirect a faluire
			renderOrRedirectFailure( defaultAction="admin:entity.detailstate", maintainQueryString=true, rc=arguments.rc);
		}
	}

	public void function saveState(required struct rc) {
		param name="rc.countryCode" default="";
		param name="rc.stateCode" default="";

		rc.country = getAddressService().getCountry(rc.countryCode);
		var arr = getAddressService().listState({stateCode=rc.stateCode, countryCode=rc.countryCode});
		if(arrayLen(arr)) {
			rc.state = arr[1];
		} else {
			rc.state = getAddressService().newState();
		}
		rc.state.setCountryCode( rc.countryCode );
		rc.state.setStateCode( rc.stateCode );

		rc.state = getAddressService().saveState(rc.state, rc);

		// Place the id in the URL for redirects in case this was a new entity before
		url['stateCode'] = rc.state.getStateCode();
		url['countryCode'] = rc.countryCode;

		// SUCCESS
		if(!rc.state.hasErrors()) {
			// Show the Generica Action Success Message
			getHibachiScope().showMessage( replace(getHibachiScope().rbKey( "admin.entity.save_success" ), "${itemEntityName}", rbKey('entity.state'), "all" ) , "success");

			// Show all of the specific messages & error messages for the entity
			rc.state.showErrorsAndMessages();

			// Render or Redirect a Success
			renderOrRedirectSuccess( defaultAction="admin:entity.detailstate", maintainQueryString=true, rc=arguments.rc);

		// FAILURE
		} else {

			// Show all of the specific messages & error messages for the entity
			rc.state.showErrorsAndMessages();

			// Render or Redirect a faluire
			renderOrRedirectFailure( defaultAction="editstate", maintainQueryString=true, rc=arguments.rc);
		}
	}

	// Stock Adjustment
	public void function createStockAdjustment(required struct rc) {
		param name="rc.stockAdjustmentType" type="string" default="satLocationTransfer";

		arguments.rc.sRedirectAction = 'admin:entity.editstockadjustment';

		// Call the generic logic
		genericCreateMethod(entityName="StockAdjustment", rc=arguments.rc);

		// Set the type correctly
		rc.stockAdjustment.setStockAdjustmentType( getTypeService().getTypeBySystemCode(rc.stockAdjustmentType) );
	}

	// Task
	public void function saveTask(required struct rc){
		rc.runningFlag=false;

		super.genericSaveMethod('Task',rc);
	}



	// Task Schedule
	public void function saveTaskSchedule(required struct rc){

		rc.nextRunDateTime = getScheduleService().getSchedule(rc.schedule.scheduleid).getNextRunDateTime(rc.startDateTime,rc.endDateTime);

		super.genericSaveMethod('TaskSchedule',rc);
	}
	
	public void function deleteCustomPropertyFile(required struct rc){
		var entityService = getHibachiService().getServiceByEntityName(arguments.rc.entityName);
		var entity = entityService.invokeMethod('get#arguments.rc.entityName#By#arguments.rc.entityName#ID',{1=arguments.rc['#arguments.rc.entityName#ID']});
		invoke(entity,'remove#arguments.rc.attributeCode#');
		var attribute = getService('attributeService').getAttributeByAttributeCode(arguments.rc.attributeCode);
		var filePath = ExpandPath(entity.invokeMethod('get#arguments.rc.attributeCode#FileUrl'));
		var isFile = attribute.getAttributeInputType() == 'file';
		if(isFile && FileExists(filePath)){
			FileDelete(filePath);
		}
		renderOrRedirectSuccess( defaultAction="admin:entity.detailstate", maintainQueryString=true, rc=arguments.rc);
	}
}
