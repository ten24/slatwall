/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

*/
component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiControllerEntity" {

	property name="addressService" type="any";
	property name="currencyService" type="any";
	property name="emailService" type="any";
	property name="imageService" type="any";
	property name="measurementService" type="any";
	property name="optionService" type="any";
	property name="orderService" type="any";
	property name="paymentService" type="any";
	property name="permissionService" type="any";
	property name="promotionService" type="any";
	property name="settingService" type="any";
	property name="skuService" type="any";
	
	
	this.publicMethods='';
	this.anyAdminMethods='';
	this.secureMethods='';
	
	// Address Zone Location
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
		rc.order = getOrderService().getOrder(rc.orderID);
		if(rc.order.getStatusCode() eq "ostNotPlaced") {
			rc.entityActionDetails.listAction = "admin:entity.listcartandquote";
		}
		genericDetailMethod(entityName="Order", rc=arguments.rc);
	}
	
	public void function editOrder(required struct rc) {
		rc.order = getOrderService().getOrder(rc.orderID);
		if(rc.order.getStatusCode() eq "ostNotPlaced") {
			rc.entityActionDetails.listAction = "admin:entity.listcartandquote";
		}
		genericEditMethod(entityName="Order", rc=arguments.rc);
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
	
	// Stock Adjustment
	public void function createStockAdjustment(required struct rc) {
		param name="rc.stockAdjustmentType" type="string" default="satLocationTransfer";
		
		// Call the generic logic
		genericCreateMethod(entityName="StockAdjustment", rc=arguments.rc);
		
		// Set the type correctly
		rc.stockAdjustment.setStockAdjustmentType( getSettingService().getTypeBySystemCode(rc.stockAdjustmentType) );
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
	
}