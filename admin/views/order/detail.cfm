<!---

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

--->
<cfparam name="rc.edit" default="false" />
<cfparam name="rc.Order" type="any" />

<cfset local.orderActionOptions = rc.Order.getActionOptions() />
<cfset local.account = rc.Order.getAccount() />
<cfset local.payments = rc.Order.getOrderPayments() />

<cfoutput>

<ul id="navTask">
	<cf_SlatwallActionCaller action="admin:order.list" type="list">
	<cf_SlatwallActionCaller action="admin:order.listcart" type="list">
</ul>

<!--- Display buttons of available order actions --->
<cfloop array="#local.orderActionOptions#" index="local.thisAction">
<cfset local.action = lcase( replace(local.thisAction.getOrderActionType().getSystemCode(),"oat","","one") ) />
	<cfif local.action neq "cancel" or (local.action eq "cancel" and !rc.order.getQuantityDelivered())>
	<cf_SlatwallActionCaller action="admin:order.#local.action#order" querystring="orderid=#rc.Order.getOrderID()#" class="button" confirmRequired="true" />
	</cfif>
</cfloop>

<div class="svoadminorderdetail">
	<div class="basicOrderInfo">
		<table class="listing-grid stripe" id="basicOrderInfo">
			<tr>
				<th colspan="2">#$.Slatwall.rbKey("admin.order.detail.basicorderinfo")#</th>
			</tr>
			<cf_SlatwallPropertyDisplay object="#rc.Order#" property="OrderNumber" edit="#rc.edit#" displayType="table">
			<cf_SlatwallPropertyDisplay object="#rc.Order.getOrderStatusType()#" title="#rc.$.Slatwall.rbKey('entity.order.orderStatusType')#" property="Type" edit="#rc.edit#"  displayType="table">
			<cf_SlatwallPropertyDisplay object="#rc.Order#" property="OrderOpenDateTime" edit="#rc.edit#"  displayType="table">
			<tr>
				<td class="property">
					#rc.$.Slatwall.rbKey("entity.order.account")#
				</td>
				<td>
					#rc.Order.getAccount().getFullName()#  
					<a href="#buildURL(action='admin:account.detail',queryString='accountID=#local.account.getAccountID()#')#">
						<img src="#$.slatwall.getSlatwallRootPath()#/staticAssets/images/admin.ui.user.png" height="16" width="16" alt="" />
					</a>
				</td>
			</tr>
			<cf_SlatwallPropertyDisplay object="#local.account#" property="primaryEmailAddress" edit="#rc.edit#" displayType="table">
			<cf_SlatwallPropertyDisplay object="#local.account#" property="primaryPhoneNumber" edit="#rc.edit#" displayType="table">
	 		<cf_SlatwallPropertyDisplay object="#rc.Order#" property="OrderTotal" edit="#rc.edit#" displayType="table">
		</table>
	</div>
	<div class="paymentInfo">
		<table class="listing-grid stripe">
			<tr>
				<th class="varWidth">#$.Slatwall.rbKey("entity.orderPayment.paymentMethod")#</th>
				<th>#$.Slatwall.rbKey("entity.orderPayment.amount")#</th>
				<th>&nbsp</th>
			</tr>
			<cfloop array="#local.payments#" index="local.thisPayment">
			<tr>
				<td class="varWidth">#$.Slatwall.rbKey("entity.paymentMethod." & local.thisPayment.getPaymentMethod().getPaymentMethodID())#</td>
				<td>#local.thisPayment.getFormattedValue('amount', 'currency')#</td>
				<td class="administration">
		          <ul class="one">
		          	<li class="zoomIn">           
						<a class="paymentDetails detail" id="show_#local.thisPayment.getOrderPaymentID()#" title="Payment Detail" href="##">#$.slatwall.rbKey("admin.order.detail.paymentDetails")#</a>
					</li>
					<li class="zoomOut">           
						<a class="paymentDetails detail" id="show_#local.thisPayment.getOrderPaymentID()#" title="Payment Detail" href="##">#$.slatwall.rbKey("admin.order.detail.paymentDetails")#</a>
					</li>
		          </ul>     						
				</td>
			</tr>
			<tr id="orderDetail_#local.thisPayment.getOrderPaymentID()#" style="display:none;">
				<td colspan="3">
					<!--- set up order payment in params struct to pass into view which shows information specific to the payment method --->
					<cfset local.params.orderPayment = local.thisPayment />
					<div class="paymentDetails">
					#view("order/payment/#lcase(local.thisPayment.getPaymentMethod().getPaymentMethodID())#", local.params)#
					</div>
				</td>
			</tr>
			</cfloop>
		</table>
		<p><strong>#$.Slatwall.rbKey("admin.order.detail.ordertotals")#</strong></p>
		<dl class="orderTotals">
			<dt>#$.Slatwall.rbKey("admin.order.detail.subtotal")#</dt> 
			<dd>#rc.order.getFormattedValue('subtotal', 'currency')#</dd>
			<dt>#$.Slatwall.rbKey("admin.order.detail.totaltax")#</dt>
			<dd>#rc.order.getFormattedValue('taxTotal', 'currency')#</dd>
			<dt>#$.Slatwall.rbKey("admin.order.detail.totalFulfillmentCharge")#</dt>
			<dd>#rc.order.getFormattedValue('fulfillmentTotal', 'currency')#</dd>
			<dt>#$.Slatwall.rbKey("admin.order.detail.totalDiscounts")#</dt>
			<dd>#rc.order.getFormattedValue('discountTotal', 'currency')#</dd>
			<dt><strong>#$.Slatwall.rbKey("admin.order.detail.total")#</strong></dt> 
			<dd><strong>#rc.order.getFormattedValue('total', 'currency')#</strong></dd>
		</dl>
	</div>
	<div class="clear">
		<div class="tabs initActiveTab ui-tabs ui-widget ui-widget-content ui-corner-all">
			<ul>
				<li><a href="##tabOrderFulfillments" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.order.detail.tab.orderFulfillments")#</span></a></li>	
				<li><a href="##tabOrderDeliveries" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.order.detail.tab.orderDeliveries")#</span></a></li>
<!---				<li><a href="##tabOrderActivityLog" onclick="return false;"><span>#rc.$.Slatwall.rbKey("admin.order.detail.tab.orderActivityLog")#</span></a></li>--->
			</ul>
		
			<div id="tabOrderFulfillments">
				<cfset local.fulfillmentNumber = 0 />
				<cfloop array="#rc.order.getOrderFulfillments()#" index="local.thisOrderFulfillment">
					<cfset local.fulfillmentNumber++ />
					<h4>#$.Slatwall.rbKey("entity.fulfillment")# #local.fulfillmentNumber#</h4>
					<div class="buttons">
						<cfif local.thisOrderFulfillment.isProcessable()>
						<cf_SlatwallActionCaller action="admin:order.detailorderfulfillment" text="#$.slatwall.rbKey('admin.orderfulfillment.process')#" queryString="orderfulfillmentid=#local.thisOrderFulfillment.getOrderFulfillmentID()#" class="button" />
						</cfif>
					</div>
					<!--- set up order fullfillment in params struct to pass into view which shows information specific to the fulfillment method --->
					<cfset local.params.orderfulfillment = local.thisOrderFulfillment />
					#view("order/ordertabs/fulfillment/#local.thisOrderFulfillment.getFulfillmentMethodID()#", local.params)#
				</cfloop>
			</div>
			
			<div id="tabOrderDeliveries">
				<cfset local.orderDeliveries = rc.order.getOrderDeliveries() />
				<cfset local.deliveryNumber = 0 />
				<cfif arrayLen(local.orderDeliveries)>
					<cfloop array="#local.orderDeliveries#" index="local.thisOrderDelivery">
						<cfset local.deliveryNumber++ />
						<!--- set up order delivery in params struct to pass into view which shows information specific to the fulfillment method--->
						<cfset local.params.orderDelivery = local.thisOrderDelivery />
						<cfset local.params.orderID = rc.order.getOrderID() />
						<cfset local.params.deliveryNumber = local.deliveryNumber />
						#view("order/ordertabs/delivery/#local.thisOrderDelivery.getFulfillmentMethod().getFulfillmentmethodID()#", local.params)# 
					</cfloop>
				<cfelse>
					#$.slatwall.rbKey("admin.order.detail.noorderdeliveries")#
				</cfif>
			</div>
		<!---	<div id="tabOrderActivityLog">
				
			</div>--->
		</div> <!-- tabs -->
	</div>
</div>
</cfoutput>
