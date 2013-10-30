<cfparam name="local.email"					type="any" />
<cfparam name="local.orderDelivery"	type="any" />
<cfparam name="local.emailData"			type="struct" default="#structNew()#" />


<cfsilent>
	<cfset local.order = orderDelivery.getOrder() />

	<cfset local.emailData.emailTo = order.getAccount().getEmailAddress() />
	<cfloop array="#order.getOrderFulfillments()#" index="local.orderFulfillment">
		<cfif NOT isNull(orderFulfillment.getEmailAddress()) AND len(orderFulfillment.getEmailAddress())>
			<cfset local.emailData.emailTo = orderFulfillment.getEmailAddress() />

			<cfbreak />
		</cfif>
	</cfloop>

	<cfset local.downloadLink = "http://" />
	<cfset local.downloadLink &= CGI.HTTP_HOST /> <!--- This adds the current domain name --->
	<cfset local.downloadLink &= CGI.SCRIPT_NAME /> <!--- This adds the script name which includes the sub-directories that a site is in --->
	<cfset local.downloadLink &= "?slatAction=s3:public.get&id=" /> <!--- This is what tells the page to execute the download reset --->
</cfsilent>


<cfsavecontent variable="local.emailData.emailBodyHTML">
	<cfoutput>
		<div id="container" style="width: 625px; font-family: arial; font-size: 12px;background:##fff;">

			<!--- Add Logo Here  --->
			<!--- <img src="http://Full_URL_Path_To_Company_Logo/logo.jpg" border="0" style="float: right;"> --->

			<div id="top" style="width: 325px; margin: 0; padding: 0;">
				<h1 style="font-size: 20px;">Order Delivery Confirmation</h1>

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
							<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Price</th>
							<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Download</th>
						</tr>
					</thead>
					<tbody>
						<cfloop array="#order.getOrderItems()#" index="local.orderItem">
							<tr>
								<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#local.orderItem.getSku().getSkuCode()#</td>
								<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#local.orderItem.getSku().getProduct().getTitle()#</td>
								<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">
									<cfif orderItem.getDiscountAmount() GT 0>
										<span style="text-decoration:line-through; color:##cc0000;">#orderItem.getFormattedValue('extendedPrice', 'currency')#</span><br />
										#local.orderItem.getFormattedValue('extendedPriceAfterDiscount', 'currency')#
									<cfelse>
										#local.orderItem.getFormattedValue('extendedPrice', 'currency')#
									</cfif>
								</td>
								<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">
									<cfif local.orderItem.hasOrderDeliveryItem()>
										<cfloop array="#local.orderItem.getOrderDeliveryItems()#" index="local.orderDeliveryItem">
											<a href="#local.downloadLink##local.orderDeliveryItem.getOrderDeliveryItemId()#">#local.downloadLink##local.orderDeliveryItem.getOrderDeliveryItemId()#</a>
										</cfloop>
									</cfif>
								</td>
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
								<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#order.getFormattedValue('subtotal', 'currency')#</td>
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
								<tr>
									<td style="border: 1px solid ##d8d8d8; padding:0px 5px;">#orderPayment.getPaymentMethod().getPaymentMethodName()#</td>
									<td style="border: 1px solid ##d8d8d8; padding:0px 5px; width:100px;">#orderPayment.getFormattedValue('amount', 'currency')#</td>
								</tr>
							</cfloop>
						</tbody>
					</table>
				</div>
			</cfif>
		</div>
	</cfoutput>
</cfsavecontent>
<cfsavecontent variable="local.emailData.emailBodyText">
	<cfoutput>
		Order Number: #order.getOrderNumber()#
		Order Placed: #DateFormat(order.getOrderOpenDateTime(), "DD/MM/YYYY")# - #TimeFormat(order.getOrderOpenDateTime(), "short")#
		Customer: #order.getAccount().getFirstName()# #order.getAccount().getLastName()#

		Items:
		===========================================================================
		<cfloop array="#order.getOrderItems()#" index="orderItem">
		#orderItem.getSku().getProduct().getTitle()#
		<cfif len(orderItem.getSku().displayOptions())>#orderItem.getSku().displayOptions()#</cfif>
		#orderItem.getFormattedValue('price', 'currency')# | #NumberFormat(orderItem.getQuantity())# | #orderItem.getFormattedValue('extendedPrice', 'currency')#
		---------------------------------------------------------------------------
		</cfloop>

		===========================================================================
		Subtotal: #order.getFormattedValue('Subtotal', 'currency')#
		<cfif order.getDiscountTotal() GT 0>
			Discount: #order.getFormattedValue('discountTotal', 'currency')#
		</cfif>
		Tax: #order.getFormattedValue('taxTotal', 'currency')#
		Total: #order.getFormattedValue('total', 'currency')#
	</cfoutput>
</cfsavecontent>


<cfsilent>
<cfset local.email.setEmailTo(local.emailData.emailTo) />
<cfset local.email.setEmailBodyHTML(local.emailData.emailBodyHTML) />
<cfset local.email.setEmailBodyText(local.emailData.emailBodyText) />
</cfsilent>