<!---

    Slatwall - An Open Source eCommerce Platform
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
<cfparam name="$" type="any" />
<cfparam name="orderFulfillment" type="any" />

<!--- Currently setup to only send the most recent delivery confirmation --->
<cfset local.orderDeliveries = orderFulfillment.getOrder().getOrderDeliveries() />
<cfset local.orderDelivery = local.orderDeliveries[1] />
<cfloop array="#local.orderDeliveries#" index="local.thisOrderDelivery" >
	<cfif local.orderDelivery.getCreatedDateTime() LT local.thisOrderDelivery.getCreatedDateTime()>
		<cfset local.orderDelivery = local.thisOrderDelivery />
	</cfif>
</cfloop>

<cfoutput>
	<html>
	<body style="font-family: arial; font-size: 12px;">
		<div id="container" style="width: 625px;">
			
			<!--- Add Logo Here  --->
			<!--- <img src="http://Full_URL_Path_To_Company_Logo/logo.jpg" border="0" style="float: right;"> --->
			
			<div id="top" style="width: 325px; margin: 0; padding: 0;">
				<h1 style="font-size: 20px;">Delivery Confirmation</h1>
				
				<table id="orderInfo" style="border-spacing: 0px; border-collapse: collapse; border: 1px solid ##d8d8d8; text-align: left; font-size: 12px; width: 350px;">
					<tbody>
						<tr>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Order Number:</strong></td>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"> #orderDelivery.getOrder().getOrderNumber()#</td>
						</tr>
						<tr>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Order Placed:</strong></td>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"> #DateFormat(orderDelivery.getOrder().getOrderOpenDateTime(), "DD/MM/YYYY")# - #TimeFormat(orderDelivery.getOrder().getOrderOpenDateTime(), "short")#</td>
						</tr>
						<tr>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Customer:</strong></td>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"> #orderDelivery.getOrder().getAccount().getFullName()#</td>
						</tr>
						<cfif !isNull(orderDelivery.getTrackingNumber()) && len(orderDelivery.getTrackingNumber())>
							<tr>
								<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Tracking Number:</strong></td>
								<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"> #orderDelivery.getTrackingNumber()#</td>
							</tr>
						</cfif>
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
							<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Qty</th>
						</tr>
					</thead>
					<tbody>
						<cfloop array="#orderDelivery.getOrderDeliveryItems()#" index="local.deliveryItem">
							<tr>
								<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#local.deliveryItem.getOrderItem().getSku().getSkuCode()#</td>
								<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#local.deliveryItem.getOrderItem().getSku().getProduct().getTitle()#</td>
								<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><cfif len(local.deliveryItem.getOrderItem().getSku().displayOptions())>#local.deliveryItem.getOrderItem().getSku().displayOptions()#</cfif></td>
								<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#NumberFormat(local.deliveryItem.getQuantity())# </td>
							</tr>
						</cfloop>
					</tbody>
				</table>
			</div>
			
			<br style="clear:both;" />

		</div>
	</body>
	</html>
</cfoutput>