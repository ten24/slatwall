<!---

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
								
	Order Status Types			
	__________________			
	ostNotPlaced				
	ostNew						
	ostProcessing				
	ostOnHold					
	ostClosed					
	ostCanceled					
								
								
--->

<cfparam name="rc.edit" default="false" />
<cfparam name="rc.order" type="any" />

<cfoutput>
	<cf_SlatwallDetailForm object="#rc.order#" edit="#rc.edit#">
		<cf_SlatwallActionBar type="detail" object="#rc.order#" edit="#rc.edit#">
			<cf_SlatwallProcessCaller action="admin:order.processOrder" entity="#rc.order#" processContext="placeOrder" queryString="orderID=#rc.order.getOrderID()#" type="list" modal="true" />
			<!--- Add Order Item --->
			<cfif listFind("ostNotPlaced,ostNew,ostProcessing,ostOnHold", rc.order.getOrderStatusType().getSystemCode()) >
				<cf_SlatwallActionCaller action="admin:order.createorderitem" queryString="orderID=#rc.order.getOrderID()#" type="list" modal=true />
				
			</cfif>
			<!--- Add Order Payment --->
			<cfif listFindNoCase("ostNotPlaced,ostNew,ostProcessing,ostOnHold", rc.order.getOrderStatusType().getSystemCode())>
				<cfif rc.order.getPaymentAmountTotal() lt rc.order.getTotal()>
					<cfloop array="#rc.order.getPaymentMethodOptionsSmartList().getRecords()#" index="local.paymentMethod">
						<cf_SlatwallActionCaller type="list" text="#$.slatwall.rbKey('define.add')# #local.paymentMethod.getPaymentMethodName()# #$.slatwall.rbKey('define.charge')#" action="admin:order.createorderpayment" querystring="orderID=#rc.orderID#&paymentMethodID=#local.paymentMethod.getPaymentMethodID()#&orderPaymentTypeSystemCode=optCharge" modal=true />
					</cfloop>
				</cfif>
			</cfif>
			<cf_SlatwallProcessCaller action="admin:order.processOrder" entity="#rc.order#" processContext="placeOnHold" queryString="orderID=#rc.order.getOrderID()#" type="list" modal="true" />
			<cf_SlatwallProcessCaller action="admin:order.processOrder" entity="#rc.order#" processContext="takeOffHold" queryString="orderID=#rc.order.getOrderID()#" type="list" modal="true" />
			<cf_SlatwallProcessCaller action="admin:order.processOrder" entity="#rc.order#" processContext="cancelOrder" queryString="orderID=#rc.order.getOrderID()#" type="list" modal="true" />
			<cf_SlatwallProcessCaller action="admin:order.processOrder" entity="#rc.order#" processContext="closeOrder" queryString="orderID=#rc.order.getOrderID()#" type="list" modal="true" />
			<cf_SlatwallProcessCaller action="admin:order.processOrder" entity="#rc.order#" processContext="createReturn" queryString="orderID=#rc.order.getOrderID()#" type="list" />
		</cf_SlatwallActionBar>
		
		<cf_SlatwallDetailHeader>
			<cf_SlatwallPropertyList divclass="span4">
				<cfif rc.edit>
					<cf_SlatwallPropertyDisplay object="#rc.order#" property="account" fieldtype="textautocomplete" autocompletePropertyIdentifiers="adminIcon,fullName,emailAddress,phoneNumber,address.simpleRepresentation" edit="true">
				<cfelseif !isNull(rc.order.getAccount())>
					<cf_SlatwallPropertyDisplay object="#rc.order.getAccount()#" property="fullName" valuelink="?slatAction=admin:account.detailaccount&accountID=#rc.order.getAccount().getAccountID()#">
					<cf_SlatwallPropertyDisplay object="#rc.order.getAccount()#" property="emailAddress" valuelink="mailto:#rc.order.getAccount().getEmailAddress()#">
					<cf_SlatwallPropertyDisplay object="#rc.order.getAccount()#" property="phoneNumber">
				</cfif>
				<cf_SlatwallPropertyDisplay object="#rc.order#" property="orderOrigin" edit="#rc.edit#">
				<cf_SlatwallPropertyDisplay object="#rc.order#" property="orderStatusType">
				<cfif !isNull(rc.order.getReferencedOrder())>
					<cf_SlatwallPropertyDisplay object="#rc.order#" property="referencedOrder" valuelink="?slatAction=admin:order.detailorder&orderID=#rc.order.getReferencedOrder().getOrderID()#">
				</cfif>
				<cfif !isNull(rc.order.getOrderOpenDateTime())>
					<cf_SlatwallPropertyDisplay object="#rc.order#" property="orderOpenDateTime">
				</cfif>
				<cfif !isNull(rc.order.getOrderCloseDateTime())>
					<cf_SlatwallPropertyDisplay object="#rc.order#" property="orderCloseDateTime">
				</cfif>
			</cf_SlatwallPropertyList>
			<cfif not rc.order.isNew()>
				<cf_SlatwallPropertyList divclass="span4">
						<cf_SlatwallPropertyDisplay object="#rc.order#" property="paymentAmountTotal">
						<hr />
						<cf_SlatwallPropertyDisplay object="#rc.order#" property="paymentAmountReceivedTotal">
						<cf_SlatwallPropertyDisplay object="#rc.order#" property="paymentAmountCreditedTotal">
						<cfif arrayLen(rc.order.getReferencingOrders())>
							<hr />
							<cf_SlatwallPropertyDisplay object="#rc.order#" property="referencingPaymentAmountCreditedTotal">
						</cfif>
				</cf_SlatwallPropertyList>
				<cf_SlatwallPropertyList divclass="span4">
						<cf_SlatwallPropertyDisplay object="#rc.order#" property="subtotal">
						<cf_SlatwallPropertyDisplay object="#rc.order#" property="taxtotal">
						<cf_SlatwallPropertyDisplay object="#rc.order#" property="fulfillmenttotal">
						<cf_SlatwallPropertyDisplay object="#rc.order#" property="discounttotal">
						<hr />
						<cf_SlatwallPropertyDisplay object="#rc.order#" property="total">
				</cf_SlatwallPropertyList>
			</cfif>
		</cf_SlatwallDetailHeader>
		
		<cf_SlatwallTabGroup object="#rc.order#" allowComments="true" allowCustomAttributes="true">
			<cf_SlatwallTab view="admin:order/ordertabs/orderitems" count="#rc.order.getOrderItemsCount()#" />
			<cf_SlatwallTab view="admin:order/ordertabs/orderpayments" count="#rc.order.getOrderPaymentsCount()#" />
			<cfif rc.order.getOrderType().getSystemCode() eq "otSalesOrder" or rc.order.getOrderType().getSystemCode() eq "otExchangeOrder">
				<cf_SlatwallTab view="admin:order/ordertabs/orderfulfillments" count="#rc.order.getOrderFulfillmentsCount()#" />
				<cf_SlatwallTab view="admin:order/ordertabs/orderdeliveries" count="#rc.order.getOrderDeliveriesCount()#" />
			</cfif>
			<cfif rc.order.getOrderType().getSystemCode() eq "otReturnOrder" or rc.order.getOrderType().getSystemCode() eq "otExchangeOrder">
				<cf_SlatwallTab view="admin:order/ordertabs/orderreturns" count="#rc.order.getOrderReturnsCount()#" />
				<cf_SlatwallTab view="admin:order/ordertabs/stockreceivers" count="#rc.order.getStockReceiversCount()#" />
			</cfif>
			<cf_SlatwallTab view="admin:order/ordertabs/promotions" count="#rc.order.getPromotionCodesCount()#" />
			<cf_SlatwallTab view="admin:order/ordertabs/referencingOrders" count="#rc.order.getReferencingOrdersCount()#" />
		</cf_SlatwallTabGroup>
		
	</cf_SlatwallDetailForm>

</cfoutput>