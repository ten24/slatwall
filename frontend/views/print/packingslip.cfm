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
<cfparam name="rc.orderDeliveryShipping" type="any" />

<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
	<head>
		<style type="text/css">
			* {font-family:Arial, Helvetica, sans-serif; color:##000000;}
			
			p, div, dt, dd, td, th {font-size:13px; text-align:left;}
			
			html, body {width:auto; height:auto;}
			
			h1 {border-bottom:1px solid ##cccccc; font-size:20px;}
			
			table {margin:0px; border:0px; border-collapse:collapse; width:100%;}
			th, td {padding:5px 20px 5px 10px;}
			th		{border-bottom:2px solid ##cccccc;}
			td		{border-bottom:1px solid ##cccccc;}
			
			dl {margin:0px; with:230px;}
			dt {margin:0px; clear:both; float:left; width:120px; padding:4px; font-weight:bold; padding-top:4px; border:1px solid ##cccccc;}
			dd {margin:0px; float:left; width:100px; padding:4px; border:1px solid ##cccccc;}
			
			div.shippingAddress {float:left; margin-top:20px;}
			div.orderDetails {float:right; margin-top:20px;}
			div.items {clear:both; margin-top:80px;}
			div.footer {margin-top:80px;}
			
			th.quantity, td.quantity {text-align:right; width:50px;}
			tr.total td {font-weight:bold; background-color:##dddddd;}
			
			.clear {clear:both;}
		</style>
		<script type="text/javascript">
			window.onload = function() {
				setTimeout("window.print()", 100);	
			}
		</script>
	</head>
	<body>
		<h1>Packing Slip</h1>
		<div class="shippingAddress">
			<swa:SlatwallAddressDisplay address="#rc.orderDeliveryShipping.getShippingAddress()#" edit="false" />
		</div>
		<div class="orderDetails">
			<dl>
				<dt>Order Number</dt>
				<dd>#rc.orderDeliveryShipping.getOrder().getOrderNumber()#</dd>
				<dt>Date Shipped</dt>
				<dd>#dateFormat(rc.orderDeliveryShipping.getDeliveryOpenDateTime(),"medium")#</dd>
				<dt>Shipping Method</dt>
				<dd>#rc.orderDeliveryShipping.getShippingMethod().getShippingMethodName()#</dd>
			</dl>
		</div>
		<br class="clear" />
		<div class="items">
			<table>
				<tr>
					<th class="skuCode">Sku Code</th>
					<th class="item">Item</th>
					<th class="quantity">Quantity</th>
				</tr>
			<cfloop array="#rc.orderDeliveryShipping.getOrderDeliveryItems()#" index="item">
				<tr>
					<td class="skuCode">#item.getOrderItem().getSku().getSkuCode()#</td>
					<td class="item">#item.getOrderItem().getSku().getProduct().getTitle()# - #item.getOrderItem().getSku().displayOptions()#</td>
					<td class="quantity">#item.getQuantity()#</td>
				</tr>
			</cfloop>
				<tr class="total">
					<td>Total</td>
					<td></td>
					<td class="quantity">#rc.orderDeliveryShipping.getTotalQuantityDelivered()#</td>
				</tr>
			</table>
		</div>
		<br class="clear" />
		<div class="footer">
			<p>Thank you for your order!</p>
		</div>
	</body>
</html>
</cfoutput>
