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
																			
	This is a print template designed to be used to customize the print job	
	that slatwall does.  If you would like to customize this template, it	
	should first be coppied into the /custom/templates/ directory in the	
	same folder path naming convention that it currently resides inside.	
																			
	All print templates have 2 objects that are passed in (seen below):		
																			
	print: This is the actually print entity that will have print settings	
	that will eventually be persisted to the database as a log of this		
	print job as long as the "Log Print" setting is set to true.			
																			
	printData: This is a structure used to set values that will get			
	populated into the print entity once this processing is complete.		
																			
	It will also be used as a final stringReplace() struct for any ${} keys	
	that have not already been relpaced.									
																			
	Lastly, the base object that is being used for this print should also	
	be injected into the template and paramed at the top.					
																			
--->
<cfparam name="print" type="any" />	
<cfparam name="printData" type="struct" default="#structNew()#" />
<cfparam name="order" type="any" />

<cfoutput>
	<div id="container" style="width: 625px; font-family: arial; font-size: 12px;background:##fff;">
		
		<!--- Add Logo Here  --->
		<!--- <img src="http://Full_URL_Path_To_Company_Logo/logo.jpg" border="0" style="float: right;"> --->
		
		<div id="top" style="width: 325px; margin: 0; padding: 0;">
			<h1 style="font-size: 20px;">Invoice</h1>
			
			<table id="orderInfo" style="border-spacing: 0px; border-collapse: collapse; border: 1px solid ##d8d8d8; text-align: left; font-size: 12px; width: 350px;">
				<tbody>
					<tr>
						<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Order Number:</strong></td>
						<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"> #order.getOrderNumber()#</td>
					</tr>
					<tr>
						<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Order Placed:</strong></td>
						<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"> #DateFormat(order.getOrderOpenDateTime(), "DD/MM/YYYY")# - #TimeFormat(order.getOrderOpenDateTime(), "short")#</td>
					</tr>
					<tr>
						<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Customer:</strong></td>
						<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"> #order.getAccount().getFirstName()# #order.getAccount().getLastName()#</td>
					</tr>
					<tr>
						<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Email:</strong></td>
						<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"> <a href="mailto:#order.getAccount().getEmailAddress()#">#order.getAccount().getEmailAddress()#</a></td>
					</tr>
					<tr>
						<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Phone:</strong></td>
						<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"> #order.getAccount().getPhoneNumber()#</td>
					</tr>
				</tbody>
			</table>
		</div>
		
		<br style="clear:both;" />
		
		<div id="orderItems" style="margin-top: 15px; float: left; clear: both; width: 600px;">
			<table id="styles" style="border-spacing: 0px; border-collapse: collapse; border: 1px solid ##d8d8d8; text-align: left; font-size: 12px; width:600px;">
				<thead>
					<tr>
						<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Sku Code</th>
						<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Product</th>
						<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Options</th>
						<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Price</th>
						<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Qty</th>
						<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Total</th>
					</tr>
				</thead>
				<tbody>
					<cfloop array="#order.getOrderItems()#" index="local.orderItem">
						<tr>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#local.orderItem.getSku().getSkuCode()#</td>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#local.orderItem.getSku().getProduct().getTitle()#</td>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><cfif len(local.orderItem.getSku().displayOptions())>#local.orderItem.getSku().displayOptions()#</cfif></td>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#local.orderItem.getFormattedValue('price', 'currency')# </td> 
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#NumberFormat(local.orderItem.getQuantity())# </td>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">
								<cfif orderItem.getDiscountAmount() GT 0>
									<span style="text-decoration:line-through; color:##cc0000;">#orderItem.getFormattedValue('extendedPrice', 'currency')#</span><br />
									#local.orderItem.getFormattedValue('extendedPriceAfterDiscount', 'currency')#
								<cfelse>
									#local.orderItem.getFormattedValue('extendedPrice', 'currency')#
								</cfif>
							</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
		</div>
				
		<br style="clear:both;" />

		<div id="bottom" style="margin-top: 15px; float: left; clear: both; width: 600px;">
			<cfloop array="#order.getOrderFulfillments()#" index="local.orderFulfillment">
				<cfif local.orderFulfillment.getFulfillmentMethodType() EQ "shipping">
					<cfif not local.orderFulfillment.getAddress().getNewFlag()>
						<div id="shippingAddress" style="width:190px; margin-right:10px; float:left;">
							<strong>Shipping Address</strong><br /><br />
							<cfif len(local.orderFulfillment.getAddress().getName())>#local.orderFulfillment.getAddress().getName()#<br /></cfif>
							<cfif len(local.orderFulfillment.getAddress().getStreetAddress())>#local.orderFulfillment.getAddress().getStreetAddress()#<br /></cfif>
							<cfif len(local.orderFulfillment.getAddress().getStreet2Address())>#local.orderFulfillment.getAddress().getStreet2Address()#<br /></cfif>
							#local.orderFulfillment.getAddress().getCity()#, #local.orderFulfillment.getAddress().getStateCode()# #local.orderFulfillment.getAddress().getPostalCode()#<br />
							#local.orderFulfillment.getAddress().getCountryCode()#
						</div>
					</cfif>
					<cfif not isNull(local.orderFulfillment.getShippingMethod())>
						<div id="shippingMethod" style="width:190px; margin-right:10px; float:left;">
							<strong>Shipping Method</strong><br /><br />
							#local.orderFulfillment.getShippingMethod().getShippingMethodName()#
						</div>
					</cfif>
				<cfelseif orderFulfillment.getFulfillmentMethodType() EQ "email">
					<div id="emailAddress" style="width:190px; margin-right:10px; float:left;">
						<strong>Delivery Email</strong><br /><br />
						#orderFulfillment.getEmailAddress()#
					</div>
				<cfelseif orderFulfillment.getFulfillmentMethodType() EQ "auto">
					<div id="fulfillmentAuto" style="width:190px; margin-right:10px; float:left;">
						<strong>Auto Fulfilled</strong><br /><br />
					</div>
				</cfif>
			</cfloop>
			<table id="total" style="border-spacing: 0px; border-collapse: collapse; border: 1px solid ##d8d8d8; text-align: left; font-size: 12px; width:200px; float:left;">
				<thead>
					<tr>
						<th colspan="2" style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Totals</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Subtotal</strong></td>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#order.getFormattedValue('subtotal', 'currency')#</td>
						</tr>
						<tr>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Delivery Charges</strong></td>
						<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#order.getFormattedValue('fulfillmentTotal', 'currency')#</td>
					</tr>
					<tr>
						<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Tax</strong></td>
						<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#order.getFormattedValue('taxTotal', 'currency')#</td>
					</tr>
					<cfif order.getDiscountTotal()>
					<tr>
						<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Discounts</strong></td>
						<td style="border: 1px solid ##d8d8d8; padding:0px 5px; color:##cc0000;">-#order.getFormattedValue('discountTotal', 'currency')#</td>
					</tr>
					</cfif>
					<tr>
						<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Total</strong></td>
						<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#order.getFormattedValue('total', 'currency')#</td>
					</tr>
				</tbody>
			</table>
		</div>
		
		<br style="clear:both;" />
		
		<cfif arrayLen(order.getOrderPayments())>
			<div id="orderPayments" style="margin-top: 15px; float: left; clear: both; width: 600px;">
				<table id="payment" style="border-spacing: 0px; border-collapse: collapse; border: 1px solid ##d8d8d8; text-align: left; font-size: 12px; width:600px;">
					<thead>
						<tr>
							<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Payment Method</th>
							<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Payment Amount</th>
						</tr>
					</thead>
					<tbody>
						<cfloop array="#order.getOrderPayments()#" index="orderPayment">
							<cfif orderPayment.getOrderPaymentStatusType().getSystemCode() EQ "opstActive">
								<tr>
									<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#orderPayment.getPaymentMethod().getPaymentMethodName()#</td>
									<td style="border: 1px solid ##d8d8d8; padding:0px 5px; width:100px;">#orderPayment.getFormattedValue('amount', 'currency')#</td>
								</tr>
							</cfif>
						</cfloop>
					</tbody>
				</table>
			</div>
		</cfif>
	</div>
</cfoutput>

