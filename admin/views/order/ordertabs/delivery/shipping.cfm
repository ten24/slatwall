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

<cfoutput>
	<div class="orderDelivery">
		<h4>#$.Slatwall.rbKey("entity.orderDelivery")# #local.deliveryNumber#</h4>
		<cfif not isNull(local.orderDelivery.getShippingAddress())>
		<div class="shippingAddress">
			<h5>#$.slatwall.rbKey("entity.orderFulfillment.shippingAddress")#</h5>
			<cf_SlatwallAddressDisplay address="#local.orderDelivery.getShippingAddress()#" edit="false" />
		</div>
		</cfif>
		<div class="shippingMethod">
			<h5>#$.slatwall.rbKey("entity.orderFulfillment.shippingMethod")#</h5>
			#local.orderDelivery.getShippingMethod().getShippingMethodName()#<br>
			(#local.orderDelivery.getShippingMethod().getShippingProviderMethodName()#)<br>
			#$.slatwall.rbKey("entity.orderDeliveryShipping.trackingNumber")#: #local.orderDelivery.getTrackingNumber()#
		</div>
		<p>#$.slatwall.rbKey("entity.orderDelivery.deliveryOpenDateTime")#: #LSDateFormat(local.orderDelivery.getDeliveryOpenDateTime())#, #LSTimeFormat(local.orderDelivery.getDeliveryOpenDateTime())#</p>
		<p>#$.slatwall.rbKey("entity.orderDelivery.deliveryCloseDateTime")#: #LSDateFormat(local.orderDelivery.getDeliveryCloseDateTime())#, #LSTimeFormat(local.orderDelivery.getDeliveryCloseDateTime())#</p>
		<table class="listing-grid stripe">
			<tr>
				<th>#$.slatwall.rbKey("entity.sku.skucode")#</th>
				<th class="varWidth">#$.slatwall.rbKey("entity.product.brand")# - #$.slatwall.rbKey("entity.product.productname")#</th>
				<th>#$.slatwall.rbKey("entity.orderitem.price")#</th>
				<th>#$.slatwall.rbKey("admin.order.detail.quantityshipped")#</th>
				<th>#$.slatwall.rbKey("entity.orderitem.extendedprice")#</th>
			</tr>
				
			<cfloop array="#local.orderDelivery.getOrderDeliveryItems()#" index="local.thisOrderDeliveryItem">
				<tr>
					<td>#local.thisOrderDeliveryItem.getOrderItem().getSku().getSkuCode()#</td>
					<td class="varWidth">#local.thisOrderDeliveryItem.getOrderItem().getSku().getProduct().getBrand().getBrandName()# #local.thisOrderDeliveryItem.getOrderItem().getSku().getProduct().getProductName()#</td>				
					<td>#local.thisOrderDeliveryItem.getFormattedValue('price', 'currency')#</td>
					<td>#local.thisOrderDeliveryItem.getQuantityDelivered()#</td>
					<td>#local.thisOrderDeliveryItem.getFormattedValue('extendedPrice', 'currency')#</td>
				</tr>
			</cfloop>
		</table>
		<a href="#buildURL(action="admin:print", queryString="returnAction=admin:order.list&printAction=packingSlip&orderDeliveryShippingID=#local.orderDelivery.getOrderDeliveryID()#")#" title="Reprint Packing Slip" class="button">Reprint Packing Slip</a>
	</div>
</cfoutput>