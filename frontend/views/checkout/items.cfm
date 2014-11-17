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
	<div class="svocheckoutitems">
		<h3 id="checkoutItemsTitle" class="titleBlick">Order Items</h3>
		<div id="checkoutItemsContent" class="contentBlock orderItems">
			<cfloop array="#$.slatwall.cart().getOrderItems()#" index="local.orderItem">
				<dl class="orderItem">
					<dt class="image">#local.orderItem.getSku().getImage(size="small")#</dt>
					<dt class="title"><a href="#local.orderItem.getSku().getProduct().getProductURL()#" title="#local.orderItem.getSku().getProduct().getTitle()#">#local.orderItem.getSku().getProduct().getTitle()#</a></dt>
					<dd class="options">#local.orderItem.getSku().displayOptions()#</dd>
					<dd class="price">#local.orderItem.getFormattedValue('price', 'currency')#</dd>
					<dd class="quantity">#NumberFormat(local.orderItem.getQuantity(),"0")#</dd>
					<cfif local.orderItem.getDiscountAmount()>
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
				<dt class="delivery">Delivery</dt>
				<dd class="delivery">#$.slatwall.cart().getFormattedValue('fulfillmentTotal', 'currency')#</dd>
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
	</div>
</cfoutput>
