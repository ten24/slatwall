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
component extends="BaseController" persistent="false" accessors="true" output="false" {

	// fw1 Auto-Injected Service Properties
	property name="locationService" type="any";
	property name="orderService" type="any";
	property name="paymentService" type="any";
	property name="skuService" type="any";
	
	this.publicMethods='';
	
	this.anyAdminMethods='';
	
	this.secureMethods='';
	this.secureMethods=listAppend(this.secureMethods, '**order');
	this.secureMethods=listAppend(this.secureMethods, 'processOrder');
	this.secureMethods=listAppend(this.secureMethods, '*orderDelivery');
	this.secureMethods=listAppend(this.secureMethods, '**orderFulfillment');
	this.secureMethods=listAppend(this.secureMethods, 'processOrderFulfillment');
	this.secureMethods=listAppend(this.secureMethods, '**orderItem');
	this.secureMethods=listAppend(this.secureMethods, '**orderPayment');
	this.secureMethods=listAppend(this.secureMethods, 'processOrderPayment');
	this.secureMethods=listAppend(this.secureMethods, '*orderReturn');
	this.secureMethods=listAppend(this.secureMethods, 'detailPaymentTransaction');
	
	public void function default(required struct rc) {
		getFW().redirect("admin:order.listorder");
	}
	
	public any function createreturnorder( required struct rc ) {
		param name="rc.originalorderid" type="string" default="";
		
		rc.originalOrder = getOrderService().getOrder(rc.originalOrderID);
		
		rc.edit = true;
	}
	
	public any function createorderpayment( required struct rc ) {
		param name="rc.orderID" type="string" default="";
		param name="rc.paymentMethodID" type="string" default="";
		
		rc.orderPayment = getOrderService().newOrderPayment();
		rc.order = getOrderService().getOrder(rc.orderID);
		rc.paymentMethod = getPaymentService().getPaymentMethod(rc.paymentMethodID);
		
		rc.edit = true;
		
	}
	
	public any function createOrderItem(required struct rc) {
		param name="rc.orderID" type="string" default="";
		
		rc.orderItem = getOrderService().newOrderItem();
		rc.order = getOrderService().getOrder(rc.orderID);

	}

	public any function addOrderItem(required struct rc) {
		param name="rc.orderID" type="any" default="";
		param name="rc.skuID" type="any" default="";
		param name="rc.quantity" type="any" default="";
		param name="rc.orderFulfillmentID" type="any" default="";
		
		arguments.rc.order = getOrderService().getOrder(arguments.rc.orderID);
		var sku = getSkuService().getSku(arguments.rc.skuID);
		var orderFulfillment = getOrderService().getOrderFulfillment(arguments.rc.orderFulfillmentID);
		
		if(!isNull(orderFulfillment)) {
			getOrderService().addOrderItem(order=arguments.rc.order, sku=sku, quantity=arguments.rc.quantity, orderFulfillment=orderFulfillment);	
		} else {
			getOrderService().addOrderItem(order=arguments.rc.order, sku=sku, quantity=arguments.rc.quantity, data=arguments.rc);
		}
		
		// If no errors redirect to success
		if(!rc.order.hasErrors()) {
			getFW().redirect(action='admin:order.detailOrder', queryString='orderID=#rc.orderID#&messagekeys=admin.order.saveorder_success');	
		}
		
		for( var p in arguments.rc.order.getErrors() ) {
			var thisErrorArray = arguments.order.getErrors()[p];
			for(var i=1; i<=arrayLen(thisErrorArray); i++) {
				showMessage(thisErrorArray[i], "error");
			}
		}
		
		getFW().setView(action='admin:order.detailOrder');
		arguments.rc.slatAction = 'admin:order.detailOrder';
		arguments.rc.pageTitle = replace(rbKey('admin.define.detail'), "${itemEntityName}", rbKey('entity.order'));	
	}
}
