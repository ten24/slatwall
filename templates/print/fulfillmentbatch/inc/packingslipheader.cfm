<cfoutput>
	<div id="container#order.getOrderId()#-#local.batchPageCount#" class="invoice" style="width: 625px; font-family: arial; font-size: 12px;background:##fff;">
		<div class="invoice-intro">
			<cfif cgi.server_name CONTAINS "ten24dev">
				
				<!---client header/image goes here--->
			
			</cfif>	
		</div>

		<div class="customer-info" style="margin-bottom:25px;">
			<div class="col1">
				<table cellpadding="0" cellspacing="0" border="0">
					<tbody>
						<tr>
							<td><strong>Invoice Number: &nbsp;&nbsp;</strong></td>
							<td>#order.getOrderNumber()#</td>
						</tr>
						<tr>
							<td><strong>Date: </strong></td>
							<td>#DateFormat(order.getOrderOpenDateTime(), "MM/DD/YYYY")#</td>
						</tr>
						<tr>
							<td><strong>Package Number: </strong></td>
							<td>#printedContainer# of #containerCount#</td>
						</tr>
					</tbody>
				</table>

				<table cellpadding="0" cellspacing="0" border="0">
						<tbody>
							<tr>
								<td>
									<br><strong>Bill To:</strong><br>
									#order.getAccount().getFirstName()# #order.getAccount().getLastName()#<br />
										<cfif not isNull(order.getBillingAddress().getStreetAddress())>
											#order.getBillingAddress().getStreetAddress()#<br />
										</cfif>
										<cfif not isNull(order.getBillingAddress().getStreet2Address())>
											#order.getBillingAddress().getStreet2Address()#<br />
										</cfif>
										<cfif not isNull(order.getBillingAddress().getLocality())>
											#order.getBillingAddress().getLocality()#<br />
										</cfif>
										<cfif not isNull(order.getBillingAddress().getCity()) and not isNull(order.getBillingAddress().getStateCode()) and not isNull(order.getBillingAddress().getPostalCode())>
											#order.getBillingAddress().getCity()#, #order.getBillingAddress().getStateCode()# #order.getBillingAddress().getPostalCode()#<br />
										<cfelse>
											<cfif not isNull(order.getBillingAddress().getCity())>
												#order.getBillingAddress().getCity()#<br />
											</cfif>
											<cfif not isNull(order.getBillingAddress().getStateCode())>
												#order.getBillingAddress().getStateCode()#<br />
											</cfif>
											<cfif not isNull(order.getBillingAddress().getPostalCode())>
												#order.getBillingAddress().getPostalCode()#<br />
											</cfif>
										</cfif>
										<br>
										<cfif not isNull(order.getAccount().getPrimaryPhoneNumber().getPhoneNumber())>
											Tel: #order.getAccount().getPrimaryPhoneNumber().getPhoneNumber()#<br />
										</cfif>
										<cfif not isNull(order.getAccount().getPrimaryEmailAddress().getEmailAddress())>
											E-Mail: #order.getAccount().getPrimaryEmailAddress().getEmailAddress()#<br />
										</cfif>
								</td>
							</tr>
						</tbody>
					</table><!-- end of .bill-to -->

			</div><!-- end of .col1 -->
			<div class="col2">
				<table cellpadding="0" cellspacing="0" border="0">
					<tbody>
						<tr>
							<td align="left" style="font-family:  Arial, sans-serif; font-size: 13px; line-height:18px; color: ##190d10; mso-line-height-rule: exactly;">
								<cfloop array="#order.getOrderFulfillments()#" index="local.orderFulfillment">
									<cfif local.orderFulfillment.getFulfillmentMethodType() EQ "shipping">
										<div id="shippingAddress" style="width:290px; margin-right:10px; float:left;">
											<strong>Ship To:</strong><br />
											<cfif len(local.orderFulfillment.getAddress().getName())>#local.orderFulfillment.getAddress().getName()#<br /></cfif>
											<cfif len(local.orderFulfillment.getAddress().getStreetAddress())>#local.orderFulfillment.getAddress().getStreetAddress()#<br /></cfif>
											<cfif len(local.orderFulfillment.getAddress().getStreet2Address())>#local.orderFulfillment.getAddress().getStreet2Address()#<br /></cfif>
											#local.orderFulfillment.getAddress().getCity()#, #local.orderFulfillment.getAddress().getStateCode()# #local.orderFulfillment.getAddress().getPostalCode()#
											#local.orderFulfillment.getAddress().getCountryCode()#
										</div>
										<cfif not isNull(local.orderFulfillment.getShippingMethod())>
											<div id="shippingMethod" style="width:190px; margin-right:10px; float:left;">
												<br><strong>Shipping Method: </strong><br>
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
							</td>
						</tr>
					</tbody>
				</table>
			</div><!-- end of .col2 -->
		</div>

		<div style="clear:both; height:30px;">&nbsp;</div>
</cfoutput>