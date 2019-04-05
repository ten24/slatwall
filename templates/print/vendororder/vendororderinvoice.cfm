<cfparam name="print" type="any" />	
<cfparam name="printData" type="struct" default="#structNew()#" />
<cfparam name="vendorOrder" type="any" />

<cfoutput>
	<div id="container" style="width: 625px; font-family: arial; font-size: 12px;background:##fff;">
		<div style="background-color: ##ffffff; width: 100%; padding: 20px; text-align:center;">
			<cfif cgi.server_name CONTAINS "ten24dev">
				
				<!--- client header/image goes here --->
				
			</cfif>
		</div>
		<div id="top" style="width: 325px; margin: 0; padding: 0;">
			<h1 style="font-size: 20px;">Purchase Order</h1>
			
			<table id="orderInfo" style="border-spacing: 0px; border-collapse: collapse; border: 1px solid ##d8d8d8; text-align: left; font-size: 12px; width: 350px;">
				<tbody>
					<tr>
						<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Order Number:</strong></td>
						<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"> #vendorOrder.getVendorOrderNumber()#</td>
					</tr>
					<tr>
						<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Vendor:</strong></td>
						<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"> #vendorOrder.getVendor().getVendorName()#</td>
					</tr>
					<tr>
						<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Shipping And Handling Cost:</strong></td>
						<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#vendorOrder.getShippingAndHandlingCost()#</a></td>
					</tr>
					<cfif not isNull(vendorOrder.getBillToLocation())>
					<tr>
						<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Bill To:</strong></td>
						<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"> #vendorOrder.getBillToLocation().getLocationName()#</td>
					</tr>
					</cfif>
				</tbody>
			</table>
		</div>
		
		<br style="clear:both;" />
		
		<div id="vendorOrderItems" style="margin-top: 15px; float: left; clear: both; width: 600px;">
			<table id="styles" style="border-spacing: 0px; border-collapse: collapse; border: 1px solid ##d8d8d8; text-align: left; font-size: 12px; width:600px;">
				<thead>
					<tr>
						<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Sku Code</th>
						<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Product</th>
						<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Price</th>
						<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Qty</th>
						<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Total</th>
					</tr>
				</thead>
				<tbody>
					<cfloop array="#vendorOrder.getVendorOrderItems()#" index="local.orderItem">
						<tr>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#local.orderItem.getSku().getSkuCode()#</td>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#local.orderItem.getSku().getProduct().getTitle()#</td>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#local.orderItem.getFormattedValue('cost', 'currency')# </td> 
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#NumberFormat(local.orderItem.getQuantity())# </td>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#local.orderItem.getFormattedValue('extendedCost', 'currency')#</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
		</div>
				
		<br style="clear:both;" />

		<div id="bottom" style="margin-top: 15px; float: left; clear: both; width: 600px;">
			<table id="total" style="border-spacing: 0px; border-collapse: collapse; border: 1px solid ##d8d8d8; text-align: left; font-size: 12px; width:200px; float:left;">
				<thead>
					<tr>
						<th colspan="2" style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Totals</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Subtotal</strong></td>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#vendorOrder.getFormattedValue('subtotal', 'currency')#</td>
						</tr>
						<tr>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;"><strong>Total</strong></td>
							<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#vendorOrder.getFormattedValue('total', 'currency')#</td>
						</tr>
				</tbody>
			</table>
		</div>
		
		
		<cfif arrayLen(vendorOrder.getComments()) >
			<div id="commentSection">
				<table>
					<thead>
						<tr>
							<th class="head-default" align="left" width="60%">Comment(s)</th>
							<th class="head-default" align="left" width="25%">Created By</th>
							<th class="head-default" align="left" width="15%">Created Dated Time</th>
						</tr>
					</thead>
					<tbody>
						<cfloop array="#vendorOrder.getComments()#" index="commentRelationship">
							<tr>
								<td>#commentRelationship['comment'].getCommentWithLinks()#</td>
								<td><cfif !isNull(commentRelationship['comment'].getCreatedByAccount())>#commentRelationship['comment'].getCreatedByAccount().getFullName()#</cfif></td>
								<td>#dateFormat(commentRelationship['comment'].getCreatedDateTime(), 'mm/dd/yyyy')#</td>
							</tr>
						</cfloop>
					</tbody>
				</table>
			</div>
		</cfif>		
	</div>
</cfoutput>

<style>
	#commentSection{
		padding-top:35pt;
	}
</style