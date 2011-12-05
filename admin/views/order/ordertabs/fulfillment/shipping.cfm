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
	<table class="listing-grid stripe">
		<tr>
			<th>#$.slatwall.rbKey("entity.sku.skucode")#</th>
			<th class="varWidth">#$.slatwall.rbKey("entity.product.brand")# - #$.slatwall.rbKey("entity.product.productname")#</th>
			<!---<th>#$.slatwall.rbKey("admin.order.list.actions")#</th>--->
			<th>#$.slatwall.rbKey("entity.orderitem.status")#</th>
			<th>#$.slatwall.rbKey("entity.orderitem.price")#</th>
			<th>#$.slatwall.rbKey("entity.orderitem.quantity")#</th>
			<th>#$.slatwall.rbKey("admin.order.detail.quantityshipped")#</th>
			<th>#$.slatwall.rbKey("entity.orderitem.extendedprice")#</th>
		</tr>
			
		<cfloop array="#local.orderFulfillment.getOrderFulfillmentItems()#" index="local.orderItem">
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
				<td>#lsCurrencyFormat(local.orderItem.getPrice())#</td>
				<td>#int(local.orderItem.getQuantity())#</td>
				<td>#local.orderItem.getQuantityDelivered()#</td>
				<td>#lsCurrencyFormat(local.orderItem.getExtendedPrice())#</td>
			</tr>
		</cfloop>
	</table>
	<div class="shippingAddress">
		<h5>#$.slatwall.rbKey("entity.orderFulfillment.shippingAddress")#</h5>
		<cf_SlatwallAddressDisplay address="#local.orderFulfillment.getShippingAddress()#" edit="false" />
	</div>
	<div class="shippingMethod">
		<h5>#$.slatwall.rbKey("entity.orderFulfillment.shippingMethod")#</h5>
		#local.orderFulfillment.getShippingMethod().getShippingMethodName()#	
	</div>
	<div class="totals">
		<dl class="fulfillmentTotals">
			<dt>
				#$.slatwall.rbKey("entity.orderFulfillment.subtotal")#:
			</dt>
			<dd>
				#lsCurrencyFormat( local.orderFulfillment.getSubTotal() )#
			</dd>
			<dt>
				#$.slatwall.rbKey("entity.orderFulfillment.shippingCharge")#:
			</dt>
			<dd>
				#lsCurrencyFormat( local.orderFulfillment.getShippingCharge() )#
			</dd>
			<dt>
				#$.slatwall.rbKey("entity.orderFulfillment.tax")#:
			</dt>
			<dd>
				#lsCurrencyFormat( local.orderFulfillment.getTax() )#
			</dd>
			<!--- discounts for fulfillment --->
			<cfif local.orderFulfillment.getItemDiscountAmountTotal() gt 0>
				<dt>
					#$.slatwall.rbKey("entity.orderFulfillment.itemDiscountAmountTotal")#:
				</dt>
				<dd class="discountAmount">
					 - #lsCurrencyFormat( local.orderFulfillment.getItemDiscountAmountTotal() )#
				</dd>
			</cfif>
			<cfif local.orderFulfillment.getDiscountAmount() gt 0>
				<dt>
					#$.slatwall.rbKey("entity.orderFulfillmentShipping.discountAmount")#:
				</dt>
				<dd class="discountAmount">
					 - #lsCurrencyFormat( local.orderFulfillment.getDiscountAmount() )#
				</dd>
			</cfif>
			<dt>
				#$.slatwall.rbKey("entity.orderFulfillment.total")#:
			</dt>
			<dd>
				#lsCurrencyFormat( local.orderFulfillment.getTotalCharge() )#
			</dd>
		</dl>
	</div>
	<div class="clear"></div>
</cfoutput>