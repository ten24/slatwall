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

<cfparam name="local.orderFulfillment" type="any" />

<cfoutput>
<cfif local.orderFulfillment.isProcessable()>
<form name="ProcessFulfillment" action=#buildURL(action="admin:order.processorderfulfillment")# method="post">
	<input type="hidden" name="orderfulfillmentID" value="#local.orderFulfillment.getOrderFulfillmentID()#" />
</cfif>
	<div class="shippingAddress">
		<h5>#$.slatwall.rbKey("entity.orderFulfillment.shippingAddress")#</h5>
		<cf_SlatwallAddressDisplay address="#local.orderFulfillment.getShippingAddress()#" edit="false" />
	</div>
	<div class="shippingMethod">
		<h5>#$.slatwall.rbKey("entity.orderFulfillment.shippingMethod")#</h5>
		#local.orderFulfillment.getShippingMethod().getShippingMethodName()#	
	</div>
	#$.slatwall.rbKey("entity.order.orderNumber")#: #local.orderFulfillment.getOrder().getOrderNumber()#<br>
	#$.slatwall.rbKey("entity.order.orderOpenDateTime")#: #DateFormat(local.orderFulfillment.getOrder().getOrderOpenDateTime(), "medium")#
	<table class="listing-grid stripe">
		<tr>
			<th>#$.slatwall.rbKey("entity.sku.skucode")#</th>
			<th class="varWidth">#$.slatwall.rbKey("entity.product.brand")# - #$.slatwall.rbKey("entity.product.productname")#</th>
			<!---<th>#$.slatwall.rbKey("admin.order.list.actions")#</th>--->
			<th>#$.slatwall.rbKey("entity.orderitem.status")#</th>
			<th>#$.slatwall.rbKey("entity.orderitem.price")#</th>
			<th>#$.slatwall.rbKey("entity.orderitem.quantity")#</th>
			<th>#$.slatwall.rbKey("admin.order.detail.quantityshipped")#</th>
			<th>#$.slatwall.rbKey("entity.orderItem.extendedPrice")#</th>
			<th>Qty. to Ship</th>
		</tr>
			
		<cfloop array="#local.orderFulfillment.getOrderFulfillmentItems()#" index="local.orderItem">
			<tr>
				<td>#local.orderItem.getSku().getSkuCode()#</td>
				<td class="varWidth">#local.orderItem.getSku().getProduct().getBrand().getBrandName()# #local.orderItem.getSku().getProduct().getProductName()#</td>			
				<td>#local.orderItem.getOrderItemStatusType().getType()#</td>
				<td>#local.orderItem.getFormattedValue('price', 'currency')#</td>
				<td>#int(local.orderItem.getQuantity())#</td>
				<td>#local.orderItem.getQuantityDelivered()#</td>
				<td>#local.orderItem.getFormattedValue('price', 'extendedPrice')#</td>
				<td>
				<cfif local.orderItem.getQuantityUndelivered() gt 0>
					<div>
						<select name="orderItems.#local.orderItem.getOrderItemID()#" id="qtyFulFilled#local.orderItem.getOrderItemID()#">
							<cfloop from="#local.orderItem.getQuantityUndelivered()#" to="0" step="-1" index="local.i">
								<option value="#local.i#"<cfif local.i eq local.orderItem.getQuantity()> selected="selected"</cfif>>#local.i#</option>
							</cfloop>
						</select>
					</div>
				<cfelse>
					#$.slatwall.rbKey('define.notapplicable')#
				</cfif>			
				</td>
			</tr>
		</cfloop>
	</table>
	<cfif local.orderFulfillment.isProcessable()>
		#$.Slatwall.rbKey("admin.order.detailOrderFulfillmentShipping.enterTrackingNumber")#:<br />
		<input type="text" name="orderItems.trackingNumber" /><br />
		<cf_SlatwallActionCaller action="admin:order.processorderfulfillment" class="button" type="submit">
	</cfif>
	<div class="totals">
		<dl class="fulfillmentTotals">
			<dt>
				#$.slatwall.rbKey("entity.orderFulfillment.subtotal")#:
			</dt>
			<dd>
				
				#local.orderFulfillment.getFormattedValue('subTotal', 'currency')#
			</dd>
			<dt>
				#$.slatwall.rbKey("entity.orderFulfillment.shippingCharge")#:
			</dt>
			<dd>
				#local.orderFulfillment.getFormattedValue('shippingCharge', 'currency')#
			</dd>
			<dt>
				#$.slatwall.rbKey("entity.orderFulfillment.tax")#:
			</dt>
			<dd>
				#local.orderFulfillment.getFormattedValue('tax', 'currency')#
			</dd>
			<dt>
				#$.slatwall.rbKey("entity.orderFulfillment.total")#:
			</dt>
			<dd>
				#local.orderFulfillment.getFormattedValue('totalCharge', 'currency')#
			</dd>
		</dl>
	</div>
	</form>
</cfoutput>