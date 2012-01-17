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


<div class="svoadminorderdetail">
	<div class="basicOrderInfo">
		<table class="listing-grid stripe" id="basicOrderInfo">
			<tr>
				<th colspan="2">#$.Slatwall.rbKey("admin.order.detail.basicorderinfo")#</th>
			</tr>
			<cf_SlatwallPropertyDisplay object="#rc.Order#" property="OrderNumber" edit="#rc.edit#" displayType="table">
			<cf_SlatwallPropertyDisplay object="#rc.Order.getReferencedOrder()#" property="OrderNumber" edit="#rc.edit#" displayType="table" title="#rc.$.Slatwall.rbKey('entity.order.OrderNumberToOriginal')#">
			<cf_SlatwallPropertyDisplay object="#rc.Order.getOrderType()#" title="#rc.$.Slatwall.rbKey('entity.order.orderType')#" property="Type" edit="#rc.edit#"  displayType="table">
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
		</table>
	</div>
	<div class="paymentInfo">
		<table class="listing-grid stripe" >
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
		
		<div style="display:inline-block; width:300px;">
				<p><strong>#$.Slatwall.rbKey("admin.order.detail.ordertotals")#</strong></p>
				<dl class="orderTotals">
					<dt>#$.Slatwall.rbKey("admin.order.detail.subtotal")#</dt> 
					<dd>#rc.order.getFormattedValue('subtotal', 'currency')#</dd>
					<dt>#$.Slatwall.rbKey("admin.order.detail.totaltax")#</dt>
					<dd>#rc.order.getFormattedValue('taxTotal', 'currency')#</dd>
					<dt>#$.Slatwall.rbKey("admin.order.detail.totalFulfillmentRefund")#</dt>
					<dd>#rc.order.getFormattedValue('fulfillmentRefundTotal', 'currency')#</dd>
					<!---<dt>#$.Slatwall.rbKey("admin.order.detail.totalDiscounts")#</dt>
					<dd>#rc.order.getFormattedValue('discountTotal', 'currency')#</dd>--->
					<dt><strong>#$.Slatwall.rbKey("admin.order.detail.total")#</strong></dt> 
					<dd><strong>#rc.order.getFormattedValue('total', 'currency')#</strong></dd>
				</dl>
			</dt>
		</div>
		<!---<div style="display:inline-block; width:300px;">		
			<div class="buttons">
				<!--- Only show return button if order is a sales order --->
				<cfif rc.order.getOrderType().getSystemCode() EQ "otSalesOrder"> 
					<cf_SlatwallActionCaller action="admin:order.createOrderReturn" text="#$.slatwall.rbKey('admin.order.createOrderReturn')#" queryString="orderID=#rc.Order.getOrderID()#" class="button" disabled="#ArrayLen(rc.order.getOrderDeliveries()) EQ 0#" />
				</cfif>	
				
				<!--- Display buttons of available order actions --->
				<cfloop array="#local.orderActionOptions#" index="local.thisAction">
				<cfset local.action = lcase( replace(local.thisAction.getOrderActionType().getSystemCode(),"oat","","one") ) />
					<cfif local.action neq "cancel" or (local.action eq "cancel" and !rc.order.getQuantityDelivered())>
					<cf_SlatwallActionCaller action="admin:order.#local.action#order" querystring="orderid=#rc.Order.getOrderID()#" class="button" confirmRequired="true" />
					</cfif>
				</cfloop>
			</div>	
		</div>--->
		
		
	</div>
	
	<div class="clear">
	
		
		<table class="listing-grid stripe">
			<tr>
				<th>#$.slatwall.rbKey("entity.sku.skucode")#</th>
				<th class="varWidth">#$.slatwall.rbKey("entity.product.brand")# - #$.slatwall.rbKey("entity.product.productname")#</th>
				<!---<th>#$.slatwall.rbKey("admin.order.list.actions")#</th>--->
				<th>#$.slatwall.rbKey("entity.orderitem.status")#</th>
				<th>#$.slatwall.rbKey("entity.orderitem.price")#</th>
				<th>#$.slatwall.rbKey("admin.order.detail.quantityreturned")#</th>
				<th>#$.slatwall.rbKey("entity.orderitem.extendedprice")#</th>
			</tr>
				
			<cfloop array="#rc.order.getOrderItems()#" index="local.orderItem">
				<tr>
					<td>#local.orderItem.getSku().getSkuCode()#</td>
					<td class="varWidth">
						<strong>#local.orderItem.getSku().getProduct().getBrand().getBrandName()# #local.orderItem.getSku().getProduct().getProductName()#</strong>
						<cfif local.orderItem.hasAttributeValue() or arrayLen(local.orderItem.getSku().getOptions())>
						  <ul class="inlineAdmin">
				          	<li class="zoomIn">           
								<a class="customizations detail" id="show_#local.orderItem.getOrderItemID()#" title="#$.slatwall.rbKey('admin.order.orderItem.optionsandcustomizations')#" href="##">#$.slatwall.rbKey("admin.order.orderItem.optionsandcustomizations")#</a>
							</li>
							<li class="zoomOut">           
								<a class="customizations detail" id="show_#local.orderItem.getOrderItemID()#" title="#$.slatwall.rbKey('admin.order.orderItem.optionsandcustomizations')#" href="##">#$.slatwall.rbKey("admin.order.orderItem.optionsandcustomizations")#</a>
							</li>
				          </ul>
						  <div class="clear" style="display:none;">
						  <hr>
							<cfif arrayLen(local.orderItem.getSku().getOptions())>
								<div><h5>Options</h5>
									<ul>
									<cfloop array="#local.orderItem.getSku().getOptions()#" index="local.option" >
										<li>#local.option.getOptionGroup().getOptionGroupName()#: #local.option.getOptionName()#</li>
									</cfloop>
									</ul>
								</div>
							</cfif>
							<cfif arrayLen(local.orderItem.getAttributeValues())>
								<div><h5>Customizations</h5>
									#local.orderItem.displayCustomizations(format="htmlList")#
								</div>
							</cfif>
						  </div> 
						</cfif>
					</td>				
					<td>#local.orderItem.getOrderItemStatusType().getType()#</td>				
					<td>#local.orderItem.getFormattedValue('price', 'currency')#</td>
					<td>#int(local.orderItem.getQuantity())#</td>
					<td>#local.orderItem.getFormattedValue('extendedPrice', 'currency')#</td>
				</tr>
			</cfloop>
		</table>
		<!---<div class="shippingAddress">
			<h5>#$.slatwall.rbKey("entity.orderFulfillment.shippingAddress")#</h5>
			<cf_SlatwallAddressDisplay address="#local.orderFulfillment.getShippingAddress()#" edit="false" />
		</div>
		<div class="shippingMethod">
			<h5>#$.slatwall.rbKey("entity.orderFulfillment.shippingMethod")#</h5>
			#local.orderFulfillment.getShippingMethod().getShippingMethodName()#	
		</div>--->
		<!---<div class="totals">
			<dl class="fulfillmentTotals">
				<dt>
					#$.slatwall.rbKey("entity.orderFulfillment.subtotal")#:
				</dt>
				<dd>
					#local.order.getFormattedValue('subTotal', 'currency')#
				</dd>
				<dt>
					#$.slatwall.rbKey("entity.orderFulfillment.shippingCharge")#:
				</dt>
				<dd>
					#local.order.getFormattedValue('fulfillmentRefundTotal', 'currency')#
				</dd>
				<dt>
					#$.slatwall.rbKey("entity.orderFulfillment.tax")#:
				</dt>
				<dd>
					#local.order.getFormattedValue('taxTotal', 'currency')#
				</dd>
				<!--- discounts for fulfillment --->
				<cfif local.orderFulfillment.getItemDiscountAmountTotal() gt 0>
					<dt>
						#$.slatwall.rbKey("entity.orderFulfillment.itemDiscountAmountTotal")#:
					</dt>
					<dd class="discountAmount">
						 - #local.orderFulfillment.getFormattedValue('itemDiscountAmountTotal', 'currency')#
					</dd>
				</cfif>
				<cfif local.orderFulfillment.getDiscountAmount() gt 0>
					<dt>
						#$.slatwall.rbKey("entity.orderFulfillmentShipping.discountAmount")#:
					</dt>
					<dd class="discountAmount">
						 - #local.orderFulfillment.getFormattedValue('discountAmount', 'currency')#
					</dd>
				</cfif>
				<dt>
					#$.slatwall.rbKey("entity.orderFulfillment.total")#:
				</dt>
				<dd>
					#local.orderFulfillment.getFormattedValue('totalCharge', 'currency')#
				</dd>
			</dl>
		</div>
		<div class="clear"></div>--->
		
	
		
	</div>
</div>
</cfoutput>
