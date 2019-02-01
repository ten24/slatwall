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

	This is an email template designed to be used to customize the emails
	that slatwall sends.  If you would like to customize this template, it
	should first be coppied into the /custom/templates/ directory in the
	same folder path naming convention that it currently resides inside.

	All email templates have 2 objects that are passed in (seen below):

	email: This is the actually email entity that will have things like a
	to, from, ext... that will eventually be persisted to the database as
	a log of this e-mail so long as the "Log Email" setting is set to true

	emailData: This is a structure used to set values that will get
	populated into the email entity once this processing is complete.
	Typically you will want to set emailData.htmlBody & emailData.textBody
	however, you can also set any of the other properties as well.  If you
	do not set emailData.htmlBody, then the output of this include will be
	used as the htmlBody, and no textBody will be set.
	It will also be used as a final stringReplace() struct for any ${} keys
	that have not already been relpaced.  Another key field that you can
	set in the emailData is voidSend=true which will cancel the sending of
	this e-mail.

	Lastly, the base object that is being used for this email should also
	be injected into the template and paramed at the top.

--->
<cfparam name="email" type="any" />
<cfparam name="emailData" type="struct" default="#structNew()#" />
<cfparam name="orderDelivery" type="any" />

<cfsavecontent variable="emailData.emailBodyHTML">
	<cfoutput>
		<div id="container" style="width: 625px; font-family: arial; font-size: 12px;background:##fff;">

			<!--- Add Logo Here  --->
			<!--- <img src="http://Full_URL_Path_To_Company_Logo/logo.jpg" border="0" style="float: right;"> --->

			<div id="top" style="width: 325px; margin: 0; padding: 0;">
				<h1 style="font-size: 20px;">Order Delivery Confirmation</h1>

				<table id="orderInfo" style="border-spacing: 0px; border-collapse: collapse; border: 1px solid ##d8d8d8; text-align: left; font-size: 12px; width: 350px;">
					<tbody>
						<tr>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Order Number</strong></td>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"> #orderDelivery.getOrder().getOrderNumber()#</td>
						</tr>
						<tr>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Order Placed</strong></td>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"> #DateFormat(orderDelivery.getOrder().getOrderOpenDateTime(), "DD/MM/YYYY")# - #TimeFormat(orderDelivery.getOrder().getOrderOpenDateTime(), "short")#</td>
						</tr>
						<tr>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Customer</strong></td>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"> #orderDelivery.getOrder().getAccount().getFirstName()# #orderDelivery.getOrder().getAccount().getLastName()#</td>
						</tr>
						<tr>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Email</strong></td>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"> <a href="mailto:#orderDelivery.getOrder().getAccount().getEmailAddress()#">#orderDelivery.getOrder().getAccount().getEmailAddress()#</a></td>
						</tr>
						<cfif len(orderDelivery.getOrder().getAccount().getPhoneNumber())>
							<tr>
								<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Phone</strong></td>
								<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"> #orderDelivery.getOrder().getAccount().getPhoneNumber()#</td>
							</tr>
						</cfif>
					</tbody>
				</table>
			</div>

			<br style="clear:both;" />

            <div id="fulfillmentDetails" style="margin-top: 15px; float: left; clear: both; width: 600px;">
            	<h2 style="font-size: 18px;">Delivery Details</h2>

                <table id="fulfillment" style="border-spacing: 0px; border-collapse: collapse; border: 1px solid ##d8d8d8; text-align: left; font-size: 12px; width:600px;">
                	<tr>
						<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Delivered Via:</strong></td>
						<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"> #orderDelivery.getFulfillmentMethod().getFulfillmentMethodName()#</td>
					</tr>
					<cfif orderDelivery.getFulfillmentMethod().getFulfillmentMethodType() EQ "email">
						<tr>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Delivery Email</strong></td>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"> #orderDelivery.getOrderFulfillment().getEmailAddress()#</td>
						</tr>
					<cfelseif orderDelivery.getFulfillmentMethod().getFulfillmentMethodType() EQ "pickup">
			       		<tr>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Picked Up From</strong></td>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"> #orderDelivery.getLocation().getLocationName()#</td>
						</tr>
					<cfelseif orderDelivery.getFulfillmentMethod().getFulfillmentMethodType() EQ "shipping">
						<cfif not isNull(orderDelivery.getTrackingNumber()) and len(orderDelivery.getTrackingNumber())>
							<tr>
								<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Tracking Number</strong></td>
								<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"> #orderDelivery.getTrackingNumber()#</td>
							</tr>
						</cfif>
						<tr>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Shipping Method</strong></td>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"> #orderDelivery.getShippingMethod().getShippingMethodName()#</td>
						</tr>
						<tr>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Shipping Address</strong></td>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">
								<cfif len(orderDelivery.getShippingAddress().getName())>#orderDelivery.getShippingAddress().getName()#</cfif>
								<cfif len(orderDelivery.getShippingAddress().getStreetAddress())>#orderDelivery.getShippingAddress().getStreetAddress()#</cfif>
								<cfif len(orderDelivery.getShippingAddress().getStreet2Address())>#orderDelivery.getShippingAddress().getStreet2Address()#</cfif>
								#orderDelivery.getShippingAddress().getCity()#, #orderDelivery.getShippingAddress().getStateCode()# #orderDelivery.getShippingAddress().getPostalCode()#
								#orderDelivery.getShippingAddress().getCountryCode()#
							</td>
						</tr>
			       	</cfif>
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
						<cfloop array="#orderDelivery.getOrderDeliveryItems()#" index="local.orderDeliveryItem">
							<tr>
								<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#local.orderDeliveryItem.getOrderItem().getSku().getSkuCode()#</td>
								<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#local.orderDeliveryItem.getOrderItem().getSku().getProduct().getTitle()#</td>
								<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><cfif len(local.orderDeliveryItem.getOrderItem().getSku().displayOptions())>#local.orderDeliveryItem.getOrderItem().getSku().displayOptions()#</cfif></td>
								<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#local.orderDeliveryItem.getOrderItem().getFormattedValue('price', 'currency')# </td>
								<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#NumberFormat(local.orderDeliveryItem.getOrderItem().getQuantity())# </td>
								<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">
									<cfif local.orderDeliveryItem.getOrderItem().getDiscountAmount() GT 0>
										<span style="text-decoration:line-through; color:##cc0000;">#local.orderDeliveryItem.getOrderItem().getFormattedValue('extendedPrice', 'currency')#</span><br />
										#local.orderDeliveryItem.getOrderItem().getFormattedValue('extendedPriceAfterDiscount', 'currency')#
									<cfelse>
										#local.orderDeliveryItem.getOrderItem().getFormattedValue('extendedPrice', 'currency')#
									</cfif>
								</td>
							</tr>
						</cfloop>
					</tbody>
				</table>
			</div>

		</div>
	</cfoutput>
</cfsavecontent>
<cfsavecontent variable="emailData.emailBodyText">
	<cfoutput>
        Order Delivery Confirmation
        ---------------------------

        Order Number: #orderDelivery.getOrder().getOrderNumber()#
		Order Placed: #DateFormat(orderDelivery.getOrder().getOrderOpenDateTime(), "DD/MM/YYYY")# - #TimeFormat(orderDelivery.getOrder().getOrderOpenDateTime(), "short")#
		Customer: #orderDelivery.getOrder().getAccount().getFirstName()# #orderDelivery.getOrder().getAccount().getLastName()#

		Delivery Info:
		===========================================================================
		Delivered Via: #orderDelivery.getFulfillmentMethod().getFulfillmentMethodName()#
		<cfif orderDelivery.getFulfillmentMethod().getFulfillmentMethodType() EQ "email">
		Delivery Email: #orderDelivery.getOrderFulfillment().getEmailAddress()#
		<cfelseif orderDelivery.getFulfillmentMethod().getFulfillmentMethodType() EQ "pickup">
       	Picked Up From: #orderDelivery.getLocation().getLocationName()#
		<cfelseif orderDelivery.getFulfillmentMethod().getFulfillmentMethodType() EQ "shipping">
		<cfif not isNull(orderDelivery.getTrackingNumber()) and len(orderDelivery.getTrackingNumber())>
		Tracking Number : #orderDelivery.getTrackingNumber()#
		</cfif>
		Shipping Method : #orderDelivery.getShippingMethod().getShippingMethodName()#
        Ship-To Address:
        <cfif len(orderDelivery.getShippingAddress().getName())>#orderDelivery.getShippingAddress().getName()#</cfif>
		<cfif len(orderDelivery.getShippingAddress().getStreetAddress())>#orderDelivery.getShippingAddress().getStreetAddress()#</cfif>
		<cfif len(orderDelivery.getShippingAddress().getStreet2Address())>#orderDelivery.getShippingAddress().getStreet2Address()#</cfif>
		#orderDelivery.getShippingAddress().getCity()#, #orderDelivery.getShippingAddress().getStateCode()# #orderDelivery.getShippingAddress().getPostalCode()#
		#orderDelivery.getShippingAddress().getCountryCode()#
		</cfif>

		Items Delivered:
		===========================================================================
		<cfloop array="#orderDelivery.getOrderDeliveryItems()#" index="local.orderDeliveryItem">
		#local.orderDeliveryItem.getOrderItem().getSku().getProduct().getTitle()#
		<cfif len(local.orderDeliveryItem.getOrderItem().getSku().displayOptions())>#local.orderDeliveryItem.getOrderItem().getSku().displayOptions()#</cfif>
		#local.orderDeliveryItem.getOrderItem().getFormattedValue('price', 'currency')# | #NumberFormat(local.orderDeliveryItem.getOrderItem().getQuantity())# | #local.orderDeliveryItem.getOrderItem().getFormattedValue('extendedPrice', 'currency')#
		---------------------------------------------------------------------------
		</cfloop>


	</cfoutput>
</cfsavecontent>

