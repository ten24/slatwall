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
<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.order" type="any" />
<cfparam name="rc.orderID" type="string" />
<cfparam name="rc.orderNumber" type="string" />

<cfoutput>
	<div class="svoorderdetail">
		
		<cfif (rc.orderNumber neq "" or rc.orderID neq "") and rc.order.isNew()>
			<p class="error">The order details that you have requested either can't be found in our system, or your account doesn't have access to those order details.</p>
		</cfif>
		<cfif rc.order.isNew()>
			<form action="?nocache=1">
			<p>Look up your order status</p>
			<dl>
				<dt>Order Number</dt>
				<dd><input name="orderNumber" value="#rc.orderNumber#" /></dd>
				<dt>Last Name on Order</dt>
				<dd><input name="lastName" value="#rc.lastName#" /></dd>
				<dt>Email Address on Order</dt>
				<dd><input name="emailAddress" value="#rc.emailAddress#" /></dd>
			</dl>
			<button type="submit">Find Order</button>
			</form>
		<cfelse>
			<dl>
				<swa:SlatwallPropertyDisplay object="#rc.order#" property="OrderNumber">
				<swa:SlatwallPropertyDisplay object="#rc.order.getOrderStatusType()#" title="#rc.$.Slatwall.rbKey('entity.order.orderStatusType')#" property="Type">
				<swa:SlatwallPropertyDisplay object="#rc.order#" property="orderOpenDateTime">
				<swa:SlatwallPropertyDisplay object="#rc.order#" property="total">
			</dl>
			<table>
				<tr>
					<th>#$.slatwall.rbKey("entity.sku.skucode")#</th>
					<th class="varWidth">#$.slatwall.rbKey("entity.product.brand")# - #$.slatwall.rbKey("entity.product.productname")#</th>
					<th>#$.slatwall.rbKey("entity.orderitem.price")#</th>
					<th>#$.slatwall.rbKey("entity.orderitem.quantity")#</th>
					<th>#$.slatwall.rbKey("define.quantityshipped")#</th>
					<th>#$.slatwall.rbKey("entity.orderitem.extendedprice")#</th>
				</tr>
				<cfloop array="#rc.order.getOrderItems()#" index="local.orderItem">
					<tr>
						<td>#local.orderItem.getSku().getSkuCode()#</td>
						<td class="varWidth"><cfif Not isNull(local.orderItem.getSku().getProduct().getBrand())>#local.orderItem.getSku().getProduct().getBrand().getBrandName()# </cfif>#local.orderItem.getSku().getProduct().getProductName()#</td>
						<td>#local.orderItem.getFormattedValue('price', 'currency')#</td>
						<td>#int(local.orderItem.getQuantity())#</td>
						<td>#local.orderItem.getQuantityDelivered()#</td>
						<td>#local.orderItem.getFormattedValue('extendedPrice', 'currency')#</td>
					</tr>
				</cfloop>
			</table>
		</cfif>
	</div>
</cfoutput>
