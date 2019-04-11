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
	.invoice-total {float: right; width: 40%; padding-bottom:15pt;}
	.footer {clear:both; border-top:1pt black solid; padding-top: 15pt;}
	</style>


	<!-- POD Template -->
	<div class="invoice-temp">
		<div class="invoice-intro">
			<div style="width: 100%; text-align:center;">
				<cfif cgi.server_name CONTAINS "ten24dev">
				
					<!---client header image goes here--->
					
				</cfif>
			</div>
			<h1>INVOICE</h1>
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
								  <cfif order.getBillingAddress().isNew() >
										<cfloop array="#order.getOrderPayments()#" index="orderPayment">
											<cfif orderPayment.getOrderPaymentStatusType().getSystemCode() EQ "opstActive" AND orderPayment.getAmount() GT 0 AND not isNull(orderPayment.getBillingAddress()) >
											  <cfif not isNull(orderPayment.getBillingAddress().getStreetAddress())> 
												#orderPayment.getBillingAddress().getStreetAddress()#<br />
											  </cfif>
											  <cfif not isNull(orderPayment.getBillingAddress().getStreet2Address())>
												 #orderPayment.getBillingAddress().getStreet2Address()#<br />
											  </cfif>
											  <cfif not isNull(orderPayment.getBillingAddress().getLocality())>
												 #orderPayment.getBillingAddress().getLocality()#<br />
											  </cfif>
											  <cfif not isNull(orderPayment.getBillingAddress().getCity()) and not isNull(orderPayment.getBillingAddress().getStateCode()) and not isNull(orderPayment.getBillingAddress().getPostalCode())>
												 #orderPayment.getBillingAddress().getCity()#, #orderPayment.getBillingAddress().getStateCode()# #orderPayment.getBillingAddress().getPostalCode()#<br />
											  <cfelse>
												  <cfif not isNull(orderPayment.getBillingAddress().getCity())>
													 #orderPayment.getBillingAddress().getCity()#<br />
												  </cfif>
												  <cfif not isNull(orderPayment.getBillingAddress().getStateCode())>
													 #orderPayment.getBillingAddress().getStateCode()#<br />
												  </cfif>
												  <cfif not isNull(orderPayment.getBillingAddress().getPostalCode())>
													 #orderPayment.getBillingAddress().getPostalCode()#<br />
												  </cfif>
											  </cfif>
											  <cfbreak>
											</cfif>
										</cfloop>
									</cfif>
									  <br>#order.getAccount().getPhoneNumber()#<br />
									  #order.getAccount().getEmailAddress()#<br />
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
												<br>
												<cfif local.orderFulfillment.getOrderFulfillmentStatusType().getSystemCode() EQ 'ofstFulfilled'>
													<cfset local.orderDeliveryCollectionList = getHibachiScope().getService('OrderService').getOrderDeliveryCollectionList() />
													<cfset local.orderDeliveryCollectionList.addFilter('order.orderID', order.getOrderID()) />
													<cfset local.orderDeliveryCollectionList.addFilter('orderDeliveryItems.orderItem.orderFulfillment.orderFulfillmentID', local.orderFulfillment.getOrderFulfillmentID()) />
													<cfset local.orderDeliveryCollectionList.addDisplayProperty('createdDateTime') />
													<cfset local.orderDeliveryCollectionList.setDistinct(true) />
														
													<cfloop array="#local.orderDeliveryCollectionList.getRecords()#" index="orderDelivery">
													 Fulfillment Date(s): #dateFormat(orderDelivery.createdDateTime, 'mm/dd/yyy')#<br>
													</cfloop>
												<cfelseif not isNull(local.orderFulfillment.getEstimatedShippingDate())>
													Estimated Shipping Date: 
													#dateFormat(local.orderFulfillment.getEstimatedShippingDate(), 'mm/dd/yyy')#
												</cfif>
											</div>
										</cfif>
									<cfelseif local.orderFulfillment.getFulfillmentMethodType() EQ "email">
										<div id="emailAddress" style="width:190px; margin-right:10px; float:left;">
											<strong>Delivery Email</strong><br /><br />
											#local.orderFulfillment.getEmailAddress()#
										</div>
									<cfelseif local.orderFulfillment.getFulfillmentMethodType() EQ "auto">
										<div id="fulfillmentAuto" style="width:190px; margin-right:10px; float:left;">
											<strong>Auto Fulfilled</strong><br /><br />
										</div>
									<cfelseif local.orderFulfillment.getFulfillmentMethodType() EQ "pickup">
										<div id="pickup" style="width:190px; margin-right:10px; float:left;">
											<strong>Store Pickup</strong><br />
											<cfif not isNull(local.orderFulfillment.getPickupDate()) AND Len(local.orderFulfillment.getPickupDate())>
												<p>Pickup Date: <strong>#dateformat(local.orderFulfillment.getPickupDate(),"mmm d, yyyy")#</strong></p>
											</cfif>
											<br/><br />
										</div>
 									</cfif>
								</cfloop>
							</td>
						</tr>
					</tbody>
				</table>
			</div><!-- end of .col2 -->
		</div>

</cfoutput>