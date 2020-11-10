<cfoutput>

	<style>
	.invoice-temp {font-size: 13px; color: ##000; font-family: Arial, sans-serif; max-width: 700px; margin: 0 auto;}
	.invoice-temp p {margin: 0;}
	.invoice-intro {text-align: center; margin: 20px 5px 40px;}
	.invoice-temp table {font-size: 13px;}
	.invoice-temp .bill-to {margin: 20px 0;}
	.invoice-temp .col1 {width: 50%; float: left; margin-right: 20px;}
	.invoice-temp .col2 {width: 40%; float: right;}
	table.invoice-list {width: 100%; text-align: left; margin: 30px -5px;}
	table.invoice-list th {border-bottom: 3px solid black;}
	table.invoice-list td {border-bottom: 1px solid black;}
	.invoice-total {float: right; width: 40%;}
	table.signature {width: 75%; margin-top: 30px; margin-bottom: 10px;display: inline-table;}
	table.signature td {border-top: 1px solid black;}
	</style>


	<!-- POD Template -->
	<div class="invoice-temp">
		<div class="invoice-intro">
			<div style="width: 100%; text-align:center;">
		
		<!---client header/image goes here--->
		
			</div>
		</div>
		
		<div class="customer-info" style="margin-bottom:30px; clear:both; display:block;">
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
									  <cfif not isNull(order.getAccount().getPhoneNumber())>
										 Tel: #order.getAccount().getPhoneNumber()#<br />
									  </cfif>
									  <cfif not isNull(order.getAccount().getEmailAddress())>
										 E-Mail: #order.getAccount().getEmailAddress()#<br />
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
								<cfif orderFulfillment.getFulfillmentMethodType() EQ "shipping">
									<div id="shippingAddress" style="width:290px; margin-right:10px; float:left;">
										<strong>Ship To:</strong><br />
										<cfif len(orderFulfillment.getAddress().getName())>#orderFulfillment.getAddress().getName()#<br /></cfif>
										<cfif len(orderFulfillment.getAddress().getStreetAddress())>#orderFulfillment.getAddress().getStreetAddress()#<br /></cfif>
										<cfif len(orderFulfillment.getAddress().getStreet2Address())>#orderFulfillment.getAddress().getStreet2Address()#<br /></cfif>
										#orderFulfillment.getAddress().getCity()#, #orderFulfillment.getAddress().getStateCode()# #orderFulfillment.getAddress().getPostalCode()#
										#orderFulfillment.getAddress().getCountryCode()#
									</div>
									
									<div id="shippingMethod" style="width:190px; margin-right:10px; float:left;">
										<cfif not isNull(orderFulfillment.getShippingMethod())>
											<br><strong>Shipping Method: </strong><br>
											#orderFulfillment.getShippingMethod().getShippingMethodName()#
										</cfif>
										<cfif not isNull(orderFulfillment.getEstimatedShippingDate())>
											<br><strong>Estimated Shipping Date:</strong><br>
											#DateFormat(orderFulfillment.getEstimatedShippingDate(), "MM/DD/YYYY")#
										</cfif>
									</div>
				
								<cfelseif orderFulfillment.getFulfillmentMethodType() EQ "email">
									<div id="emailAddress" style="width:190px; margin-right:10px; float:left;">
										<strong>Delivery Email</strong><br /><br />
										#orderFulfillment.getEmailAddress()#
									</div>
								<cfelseif orderFulfillment.getFulfillmentMethodType() EQ "auto">
									<div id="fulfillmentAuto" style="width:190px; margin-right:10px; float:left;">
										<strong>Auto Fulfilled</strong><br /><br />
									</div>
								<cfelseif orderFulfillment.getFulfillmentMethodType() EQ "pickup">
									<div id="pickup" style="width:190px; margin-right:10px; float:left;">
										<strong>Store Pickup</strong><br />
										<cfif not isNull(orderFulfillment.getPickupDate()) AND Len(orderFulfillment.getPickupDate())>
											<p>Pickup Date: <strong>#dateformat(orderFulfillment.getPickupDate(),"mmm d, yyyy")#</strong></p>
										</cfif>
										<br/><br />
									</div>
 								</cfif>
							</td>
						</tr>
					</tbody>
				</table>
			</div><!-- end of .col2 -->
		</div>
</cfoutput>