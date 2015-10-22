<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC
	
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
    
    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
	
    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your 
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms 
    of your choice, provided that you follow these specific guidelines: 

	- You also meet the terms and conditions of the license of each 
	  independent module 
	- You must not alter the default display of the Slatwall name or logo from  
	  any part of the application 
	- Your custom code must not alter or create any files inside Slatwall, 
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets 
	the above guidelines as a combined work under the terms of GPL for this program, 
	provided that you include the source code of that other code when and as the 
	GNU GPL requires distribution of source code.
    
    If you modify this program, you may extend this exception to your version 
    of the program, but you are not obligated to do so.

Notes:

--->
<cfoutput>
	<div class="svocartdetail">
		#$.slatwall.getAllMessagesHTML()#
		#$.slatwall.cart().getAllMessagesHTML()#
		<form name="updateCart" method="post" action="?update=1">
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
						<cfif local.orderItem.getDiscountAmount() GT 0>
							<dd class="extended">#local.orderItem.getFormattedValue('extendedPrice', 'currency')#</dd>
							<dd class="discount">- #local.orderItem.getFormattedValue('discountAmount', 'currency')#</dd>
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

