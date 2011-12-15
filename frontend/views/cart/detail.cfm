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
	<div class="svocartdetail">
		<form name="updateCart" method="post">
			<input type="hidden" name="slatAction" value="frontend:cart.update" />
		<cfif not arrayLen($.slatwall.cart().getOrderItems())>
			<p class="noitems">#$.slatwall.rbKey('frontend.cart.detail.noitems')#</p>
		<cfelse>
			<div class="orderItems">
				<cfset formIndex = 0 />
				<cfloop array="#$.slatwall.cart().getOrderItems()#" index="local.orderItem">
					<cfset formIndex ++ />
					<dl class="orderItem">
						<dt class="image">#local.orderItem.getSku().getImage(size="small")#</dt>
						<dt class="title"><a href="#local.orderItem.getSku().getProduct().getProductURL()#" title="#local.orderItem.getSku().getProduct().getTitle()#">#local.orderItem.getSku().getProduct().getTitle()#</a></dt>
						<dd class="options">#local.orderItem.getSku().displayOptions()#</dd>
						<dd class="customizations">#local.orderItem.displayCustomizations()#</dd>
						<dd class="price">#local.orderItem.getFormattedValue('price', 'currency')#</dd>
						<dd class="quantity">
							<input type="hidden" name="orderItems[#formIndex#].orderItemID" value="#local.orderItem.getOrderItemID()#" />
							<input name="orderItems[#formIndex#].quantity" value="#NumberFormat(local.orderItem.getQuantity(),"0")#" size="3" />
							<a href="?slatAction=frontend:cart.removeItem&orderItemID=#local.orderItem.getOrderItemID()#">Remove</a>
						</dd>
						<cfif local.orderItem.getDiscountAmount()>
							<dd class="extended">#local.orderItem.getFormattedValue('price', 'extendedPrice')#</dd>
							<dd class="discount">- #local.orderItem.getFormattedValue('discountAmount', 'extendedPrice')#</dd>
							<dd class="extendedAfterDiscount">#local.orderItem.getFormattedValue('extendedPriceAfterDiscount', 'currency')#</dd>
						<cfelse>
							<dd class="extendedAfterDiscount">#local.orderItem.getFormattedValue('extendedPriceAfterDiscount', 'currency')#</dd>
						</cfif>
					</dl>
				</cfloop>
				<dl class="totals">
					<dt class="subtotal">Subtotal</dt>
					<dd class="subtotal">#$.slatwall.cart().getFormattedValue('subtotal', 'currency')#</dd>
					<dt class="shipping">Delivery</dt>
					<dd class="shipping">#$.slatwall.cart().getFormattedValue('fulfillmentTotal', 'currency')#</dd>
					<dt class="tax">Tax</dt>
					<dd class="tax">#$.slatwall.cart().getFormattedValue('taxTotal', 'currency')#</dd>
					<cfif $.slatwall.cart().getDiscountTotal() gt 0>
						<dt class="discount">Discount</dt>
						<dd class="discount">- #$.slatwall.cart().getFormattedValue('discountTotal', 'currency')#</dd>
					</cfif>
					<dt class="total">Total</dt>
					<dd class="total">#$.slatwall.cart().getFormattedValue('total', 'currency')#</dd>
				</dl>
			</div>
			<div class="actionButtons">
				<a href="#$.createHREF(filename='shopping-cart', querystring='slatAction=frontend:cart.clearCart')#" title="Clear Cart" class="frontendcartdetail clearCart button">Clear Cart</a>
				<a href="#$.createHREF(filename='shopping-cart')#" title="Update Cart" class="frontendcartdetail updateCart button">Update Cart</a>
				<a href="#$.createHREF(filename='checkout')#" title="Checkout" class="frontendcheckoutdetail checkout button">Checkout</a>
			</div>
		</cfif>
		</form>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				jQuery('div.actionButtons a.updateCart').click(function(e){
					e.preventDefault();
					jQuery('form[name="updateCart"]').submit();
				});
			});
		</script>
		#view("frontend:cart/promotioncode")#
	</div>
</cfoutput>
