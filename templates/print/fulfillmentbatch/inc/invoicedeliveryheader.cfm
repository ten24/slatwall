<cfoutput>

	<style>
		.invoice-temp {font-size: 13px; color: ##000; font-family: Arial, sans-serif; max-width: 700px; margin: 0 auto;}
		.invoice-temp p {margin: 0;}
		.invoice-temp table {font-size: 13px;}
		.invoice-temp .bill-to {margin: 20px 0;}
		.invoice-temp .col1 {width: 50%; float: left; margin-right: 20px; margin-bottom:30px;}
		.invoice-temp .col2 {width: 30%; float: right; margin-bottom:30px;}
		.invoice-temp .col2.left {float: left;}
		table.invoice-list {width: 100%; text-align: left; margin: 30px -5px;}
		table.invoice-list th {border-bottom: 3px solid black;}
		table.invoice-list td {border-bottom: 1px solid black;}
		.invoice-total {float: right; width: 40%; padding-bottom:15pt;}
		.footer {clear:both; font-size: 12px; padding-top: 15pt;}
	</style>
	<!-- POD Template -->
	<div class="invoice-temp">
		<div class="invoice-intro">
			<div class="col1">
				
				<!---client image goes here--->
				
			    <div style="margin-top:20px;">
    			    <p><strong>Please Remit Payment to:</strong></p>
    			    100 Enterprise Way, Ste. G300<br>
    			    Scotts Valley, CA 95066<br>
    			    800-321-4407
			    </div>
			</div>
			
			<div class="col2">
				<h1>INVOICE</h1>
				
				<table cellpadding="3" cellspacing="0" border="0">
					<tbody>
						<tr>
						    <td><strong>INVOICE DATE</strong></td>
						    <td>#DateFormat(order.getOrderOpenDateTime(), "MM/DD/YYYY")#</td>
						</tr>
						<tr>
						    <td><strong>INVOICE NO.</strong></td>
						    <td>#order.getOrderNumber()#</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
		
		<div style="clear:both;"></div>
		
		<div class="customer-info" style="margin-bottom:25px;">
			<div class="col1">
				<table cellpadding="0" cellspacing="0" border="0">
					  <tbody>
						  <tr>
							  <td>
							  	<strong>Bill To:</strong><br>
								<!--- Address from "Payment Method" --->
								<cfif Len(order.getOrderPayments()) EQ 1>
									<cfloop array="#order.getOrderPayments()#" index="orderPayment">
										<cfif orderPayment.getOrderPaymentStatusType().getSystemCode() EQ "opstActive" AND orderPayment.getAmount() GT 0 AND not isNull(orderPayment.getBillingAddress()) >
										  <cfif NOT isNull(orderPayment.getBillingAddress())>
											#orderPayment.getBillingAddress().getName()#<br />
										  </cfif>
										  <cfif NOT isNull(orderPayment.getBillingAddress()) AND NOT isNull(orderPayment.getBillingAddress().getCompany())>
											 #orderPayment.getBillingAddress().getCompany()#<br />
										  </cfif>
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
								<!--- Address from "Account Addresses" --->
								<cfelseif NOT isNull(order.getBillingAddress())>
									<cfif NOT isNull(order.getBillingAddress().getName())>
										#order.getBillingAddress().getName()#<br />
									</cfif>
									<cfif NOT isNull(order.getBillingAddress().getCompany())>
										#order.getBillingAddress().getCompany()#<br />
									</cfif>
									<cfif NOT isNull(order.getBillingAddress().getStreetAddress())>
										#order.getBillingAddress().getStreetAddress()#<br />
									</cfif>
									<cfif NOT isNull(order.getBillingAddress().getStreet2Address())>
										#order.getBillingAddress().getStreet2Address()#<br />
									</cfif>
									<cfif NOT isNull(order.getBillingAddress().getLocality())>
										#order.getBillingAddress().getLocality()#<br />
									</cfif>
									<cfif NOT isNull(order.getBillingAddress().getCity()) and not isNull(order.getBillingAddress().getStateCode()) and not isNull(order.getBillingAddress().getPostalCode())>
										#order.getBillingAddress().getCity()#, #order.getBillingAddress().getStateCode()# #order.getBillingAddress().getPostalCode()#<br />
									<cfelse>
										<cfif NOT isNull(order.getBillingAddress().getCity())>
											#order.getBillingAddress().getCity()#<br />
										</cfif>
										<cfif NOT isNull(order.getBillingAddress().getStateCode())>
											#order.getBillingAddress().getStateCode()#<br />
										</cfif>
										<cfif NOT isNull(order.getBillingAddress().getPostalCode())>
											#order.getBillingAddress().getPostalCode()#<br />
										</cfif>
									</cfif>
									<cfif isNull(order.getBillingAddress().getName()) 
									AND isNull(order.getBillingAddress().getStreetAddress()) 
									AND isNull(order.getBillingAddress().getLocality()) 
									AND isNull(order.getBillingAddress().getCity()) 
									AND isNull(order.getBillingAddress().getStateCode()) 
									AND isNull(order.getBillingAddress().getPostalCode())>
										Information not available
									</cfif>
								</cfif>
							</td>
						  </tr>
					  </tbody>
				</table><!--- end of .bill-to --->
			</div><!--- end of .col1 --->
			<div class="col2">
				<table cellpadding="0" cellspacing="0" border="0">
					<tbody>
						<tr>
							<td align="left" style="font-family:  Arial, sans-serif; font-size: 13px; line-height:18px; color: ##190d10; mso-line-height-rule: exactly;">
								<cfset labelArray=listToArray(orderDelivery.getContainerLabel(),",") />
								<cfif NOT arrayLen(labelArray)>
										<div id="shippingAddress">
											<strong>Ship To:</strong><br />
											<cfif Len(orderDelivery.getShippingAddress().getName())>#orderDelivery.getShippingAddress().getName()#<br /></cfif>
											<cfif Len(orderDelivery.getShippingAddress().getCompany())>#orderDelivery.getShippingAddress().getCompany()#<br /></cfif>
											<cfif Len(orderDelivery.getShippingAddress().getStreetAddress())>#orderDelivery.getShippingAddress().getStreetAddress()#<br /></cfif>
											<cfif Len(orderDelivery.getShippingAddress().getStreet2Address())>#orderDelivery.getShippingAddress().getStreet2Address()#<br /></cfif>
											#orderDelivery.getShippingAddress().getCity()#, #orderDelivery.getShippingAddress().getStateCode()# #orderDelivery.getShippingAddress().getPostalCode()#<br />
											#orderDelivery.getShippingAddress().getCountryCode()#
										</div>
								<cfelse>
									<cfloop array="#order.getOrderFulfillments()#" index="local.orderFulfillment">
										<cfif local.orderFulfillment.getFulfillmentMethodType() EQ "shipping">
											<div id="shippingAddress" style="width:290px; margin-right:10px; float:left;">
												<strong>Ship To:</strong><br />
												<cfif len(local.orderFulfillment.getAddress().getName())>#local.orderFulfillment.getAddress().getName()#<br /></cfif>
												<cfif not isNull(order.getAccount()) and len(order.getAccount().getCompany())>#order.getAccount().getCompany()#<br /></cfif>
												<cfif len(local.orderFulfillment.getAddress().getStreetAddress())>#local.orderFulfillment.getAddress().getStreetAddress()#<br /></cfif>
												<cfif len(local.orderFulfillment.getAddress().getStreet2Address())>#local.orderFulfillment.getAddress().getStreet2Address()#<br /></cfif>
												#local.orderFulfillment.getAddress().getCity()#, #local.orderFulfillment.getAddress().getStateCode()# #local.orderFulfillment.getAddress().getPostalCode()#
												#local.orderFulfillment.getAddress().getCountryCode()#
											</div>
										<cfelseif local.orderFulfillment.getFulfillmentMethodType() EQ "pickup">
											<div id="pickup" style="width:190px; margin-right:10px; float:left;">
												<strong>Store Pickup</strong><br />
												<cfif not isNull(local.orderFulfillment.getPickupDate()) AND Len(local.orderFulfillment.getPickupDate())>
													<p>Pickup Date: <strong>#dateformat(local.orderFulfillment.getPickupDate(),"mmm d, yyyy")#</strong></p>
												</cfif>
											</div>
										<cfelse>
											Information not available
	 									</cfif>
									</cfloop>
								</cfif>
							</td>
						</tr>
					</tbody>
				</table>
			</div><!-- end of .col2 -->
		</div>
</cfoutput>