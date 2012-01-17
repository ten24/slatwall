/*

    Slatwall - An e-commerce plugin for Mura CMS
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
	property name="orderService" type="any";
	property name="paymentService" type="any";
	property name="LocationService" type="any";
	
	public void function before(required struct rc) {
		param name="rc.orderID" default="";
		param name="rc.keyword" default="";
	}
	
	public void function default(required struct rc) {
		getFW().redirect("admin:order.list");
	}

    public void function list(required struct rc) {
		param name="rc.orderby" default="orderOpenDateTime|DESC";
		param name="rc.statusCode" default="ostNew,ostProcessing";
		param name="rc.orderDateStart" default="";
		param name="rc.orderDateEnd" default="";
		// show advanced search fields if they have been filled
		if(len(trim(rc.orderDateStart)) > 0 || len(trim(rc.orderDateEnd)) > 0 || (len(rc.statusCode) && rc.statusCode != "ostNew,ostProcessing" )) {
			rc.showAdvancedSearch = 1;
		}
		rc.orderSmartList = getOrderService().searchOrders(data=arguments.rc);
		rc.orderStatusOptions = getOrderService().getOrderStatusOptions();
    }    
	
	public void function detail(required struct rc) {
	   rc.order = getOrderService().getOrder(rc.orderID);
	   rc.shippingServices = getService("settingService").getShippingServices();
	   if(!isNull(rc.order) and !rc.order.isNew()) {
	       rc.itemTitle &= ": Order No. " & rc.order.getOrderNumber();
	   } else {
	       getFW().redirect("admin:order.list");
	   }
	}
	
	public void function detailReturn(required struct rc) {
	   rc.order = getOrderService().getOrder(rc.orderID);
	   
	   if(!isNull(rc.order) and !rc.order.isNew()) {
	       rc.itemTitle &= ": Order No. " & rc.order.getOrderNumber();
	   } else {
	       getFW().redirect("admin:order.list");
	   }
	}

	public void function createOrderReturn(required struct rc) {
		rc.order = getOrderService().getOrder(rc.orderID);
		//rc.shippingServices = getService("settingService").getShippingServices();
		
		if(isNull(rc.order)) {
		   getFW().redirect("admin:order.list");
		}
		
		// Set up the locations smart list to return an array that is compatible with the cf_slatwallformfield output tag
		rc.locationSmartList = getLocationService().getLocationSmartList();
		rc.locationSmartList.addSelect(propertyIdentifier="locationName", alias="name");
		rc.locationSmartList.addSelect(propertyIdentifier="locationId", alias="value");

		rc.itemTitle &= ": Order No. " & rc.order.getOrderNumber();
		getFW().setView(action="admin:order.createorderreturn");
	}
	
	public void function saveOrderReturn(required struct rc) {
		param name="rc.orderID";
		rc.order = getOrderService().getOrder(rc.orderID);
		
		if(getService("OrderService").createOrderReturn(rc)) {
			rc.message = rc.$.slatwall.rbKey("admin.order.saveOrderReturn_success");
		} else {
			rc.message = rc.$.slatwall.rbKey("admin.order.saveOrderReturn_error");
		}
		getFW().redirect(action="admin:order.detail", queryString="orderID=#rc.order.getOrderID()#", preserve="message");
	}
	

    public void function listcart(required struct rc) {
		rc["F:orderStatusType_systemCode"] ="ostNotPlaced";
		rc.orderby = "createdDateTime|DESC";
		rc.cartSmartList = getOrderService().getOrderSmartList(data=arguments.rc);
    } 
    
    public void function detailcart(required struct rc) {
    	rc.order = getOrderService().getOrder(rc.orderID);
		if(isNull(rc.order)) {
		   getFW().redirect("admin:order.listcart");
		}
    } 

	public void function exportOrders(required struct rc) {
		getOrderService().exportOrders(data=arguments.rc);
	}
	
	public void function applyOrderActions(required struct rc) {
		for( var i=1; i<=listLen(rc.orderActions); i++ ) {
			local.thisOrderID = listFirst(listGetAt(rc.orderActions,i),"_");
			local.thisOrderActionTypeID = listLast(listGetAt(rc.orderActions,i),"_");
			var applied = getOrderService().applyOrderAction(local.thisOrderID,local.thisOrderActionTypeID);
		}
		if( applied ) {
			rc.message = rc.$.slatwall.rbKey("admin.order.applyOrderActions_success");
			getFW().redirect(action="admin:order.list", preserve="message");
		}
	}
	
	public void function cancelorder(required struct rc) {
		rc.order = getOrderService().getOrder(rc.orderID);
		var response = getOrderService().cancelOrder(rc.order);
		if( !response.hasErrors() ) {
			rc.message = rc.$.slatwall.rbKey("admin.order.cancelorder_success");
		} else {
			rc.message = response.getError("cancel");
			rc.messageType = "error";
		}
		rc.itemTitle &= ": Order No. " & rc.order.getOrderNumber();
		getFW().setView(action="admin:order.detail");
	}
	
	public void function chargeOrderPayment(required struct rc) {
		var orderPayment = getOrderService().getOrderPayment(rc.orderPaymentID);
		if(!isNull(orderPayment)) {
			var chargeOK = getOrderService().chargeOrderPayment(orderPayment, rc.providerTransactionID);
			if(chargeOK) {
				rc.message = rc.$.slatwall.rbKey("admin.order.chargeOrderPayment_success");
				getFW().redirect(action="admin:order.detail", queryString="orderID=#orderPayment.getOrder().getOrderID()#",preserve="message");
			} else {
				rc.errorBean = orderPayment.getErrorBean();
				rc.messagetype = "error";
				rc.message = rc.$.slatwall.rbKey("admin.order.chargeOrderPayment_error");
				getFW().redirect(action="admin:order.detail", queryString="orderID=#orderPayment.getOrder().getOrderID()#",preserve="message,messagetype,errorBean");
			}
		} else {
			rc.message = rc.$.slatwall.rbKey("admin.order.orderpayment_notexists");
			rc.messageType = "error";
			getFW().redirect(action="admin:order.list",preserve="message,messagetype");
		}
	}
	
	public void function refundOrderPayment(required struct rc) {
		rc.orderPayment = getOrderService().getOrderPayment(rc.orderPaymentID);
		if(isNull(rc.orderPayment)) {
			rc.message = rc.$.slatwall.rbKey("admin.order.orderpayment_notexists");
			rc.messageType = "error";
			getFW().redirect(action="admin:order.list",preserve="message,messagetype");		
		}
	}
	
	public void function processOrderPaymentRefund(required struct rc) {
		var orderPayment = getOrderService().getOrderPayment(rc.orderPaymentID);
		var refundOK = false;
		if(!isNull(orderPayment)) {
			// make sure that the refund amount entered is within the limits
			if(isNumeric(rc.refundAmount) && rc.refundAmount > 0 && rc.refundAmount <= orderPayment.getAmountCharged()) {
				refundOK = getPaymentService().processPayment(orderPayment,"credit",rc.refundAmount,rc.providerTransactionID);
				if(refundOK) {
					rc.message = rc.$.slatwall.rbKey("admin.order.refundOrderPayment_success");
					getFW().redirect(action="admin:order.detail", queryString="orderID=#orderPayment.getOrder().getOrderID()#",preserve="message");
				} else {
					rc.errorBean = orderPayment.getErrorBean();
					rc.messagetype = "error";
					rc.message = rc.$.slatwall.rbKey("admin.order.refundOrderPayment_error");
					getFW().redirect(action="admin:order.detail", queryString="orderID=#orderPayment.getOrder().getOrderID()#",preserve="message,messagetype,errorBean");
				}	
			} else {
				rc.message = rc.$.slatwall.rbKey("admin.order.refundorderpayment_invalidAmount");
				rc.message = replaceNoCase(rc.message,"{amountCharged}",dollarFormat(orderPayment.getAmountCharged()),"one");
				rc.messageType = "error";
				getFW().redirect(action="admin:order.detail",querystring="orderID=#orderPayment.getOrder().getOrderID()#",preserve="message,messagetype");
			}
		} else {
			rc.message = rc.$.slatwall.rbKey("admin.order.orderpayment_notexists");
			rc.messageType = "error";
			getFW().redirect(action="admin:order.list",preserve="message,messagetype");				
		}
	}
	
	/****** Order Fulfillments *****/
	
	public void function listOrderFulfillments(required struct rc) {
		param name="rc['F:order_orderstatustype_systemcode']" default="ostNew,ostProcessing";
		rc.fulfillmentSmartList = getOrderService().getOrderFulfillmentSmartList(data=arguments.rc);
	}
	
	public void function detailOrderFulfillment(required struct rc) {
		rc.orderFulfillment = getOrderService().getOrderFulfillment(rc.orderfulfillmentID);
		if(isNull(rc.orderFulfillment)) {
			getFW().redirect(action="admin:order.listOrderFulfillments");
		}
		
		// Set up the locations smart list to return an array that is compatible with the cf_slatwallformfield output tag
		rc.locationSmartList = getLocationService().getLocationSmartList();
		rc.locationSmartList.addSelect(propertyIdentifier="locationName", alias="name");
		rc.locationSmartList.addSelect(propertyIdentifier="locationId", alias="value");
	}
	
	public void function processOrderFulfillment(required struct rc) {
		param name="rc.locationID";
		
		rc.orderFulfillment = getOrderService().getOrderFulfillment(rc.orderFulfillmentID);
		
		if(rc.orderFulfillment.isProcessable()) {
			var orderDeliveryItemsStruct = rc.orderItems;
			// call service to process fulfillment. Returns an orderDelivery
			var orderDelivery = getOrderService().processOrderFulfillment(rc.orderfulfillment, orderDeliveryItemsStruct, rc.locationID);
			if(!orderDelivery.hasErrors()) {
				getFW().redirect(action="admin:print", queryString="returnAction=admin:order.list&printAction=packingSlip&orderDeliveryShippingID=#orderDelivery.getOrderDeliveryID()#");
				
				// rc.message = rc.$.slatwall.rbKey("admin.order.processorderfulfillment_success");
				// getFW().redirect(action="admin:order.listorderfulfillments", preserve="message");
			} else {
				rc.itemTitle = rc.$.slatwall.rbKey("admin.order.detailOrderFulfillment");
				rc.message = orderDelivery.getError("orderDeliveryItems")[1];
				rc.messagetype = "warning";
				getFW().setView("admin:order.detailOrderFulfillment");
			}
		} else {
			rc.itemTitle = rc.$.slatwall.rbKey("admin.order.detailOrderFulfillment");
			rc.message = rc.$.slatwall.rbKey("admin.order.processOrderFulfillment.notProcessable");
			rc.messagetype = "error";
			getFW().setView("admin:order.detailOrderFulfillment");			
		}
	}

}
