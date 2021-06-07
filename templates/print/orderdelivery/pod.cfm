<cfparam name="print" type="any" />
<cfparam name="printData" type="struct" default="#structNew()#" />
<cfparam name="orderDelivery" type="any" />
<cfset order=orderDelivery.getOrder()>

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
	h4 {border-bottom:2px solid black; }
	</style>


	<!-- POD Template -->
	<div class="invoice-temp">
	    <div class="invoice-intro">
			<div style="width: 100%; text-align:center;">
				<cfif cgi.server_name CONTAINS "ten24dev">
				
					<!---Clieny header/image goes here--->
					
				</cfif>
			</div>
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
										
										<div id="shippingMethod" style="width:190px; margin-right:10px; float:left;">
											<cfif not isNull(local.orderFulfillment.getShippingMethod())>
												<br><strong>Shipping Method: </strong><br>
												#local.orderFulfillment.getShippingMethod().getShippingMethodName()#
											</cfif>
											<cfif not isNull(local.orderFulfillment.getEstimatedShippingDate())>
												<br><strong>Estimated Shipping Date:</strong><br>
												#DateFormat(local.orderFulfillment.getEstimatedShippingDate(), "MM/DD/YYYY")#
											</cfif>
										</div>
									<cfelseif local.orderFulfillment.getFulfillmentMethodType() EQ "email">
										<div id="emailAddress" style="width:190px; margin-right:10px; float:left;">
											<strong>Delivery Email</strong><br /><br />
											#orderFulfillment.getEmailAddress()#
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
		
		<div style="clear:both; height:30px;">&nbsp;</div>
		
	    <table class="invoice-list" cellspacing="5">
	        <thead>
	            <tr>
	                <th>Quantity</th>
	                <th>Size</th>
	                <th>Description</th>
					<th>SKU</th>
	            </tr>
	        </thead>
			<cfset local.totalQuantity=0>
			<cfset local.orderItemCollectionList = orderDelivery.getOrderDeliveryItemsCollectionList()>
			<cfset local.orderItemCollectionList.setDisplayProperties('orderItem.sku.skuCode,orderItem.sku.calculatedSkuDefinition,quantity,orderItem.sku.product.calculatedTitle')>
			<cfset local.orderItemCollectionList.addFilter('quantity', 0, '>' )>
			
			<cfloop array="#local.orderItemCollectionList.getRecords()#" index="local.orderItem">
				<cfset local.totalQuantity+=local.orderItem['quantity']>
				<tr>
	                <td style="text-align:right; padding-right:20px;">#NumberFormat(local.orderItem['quantity'])#</td>
	                <td>#local.orderItem['orderItem_sku_calculatedSkuDefinition']#</td>
	                <td>#local.orderItem['orderItem_sku_product_calculatedTitle']#</td>
					<td>#local.orderItem['orderItem_sku_skuCode']#</td>
				</tr>
			</cfloop>
            <tr>
                <td style="border:none; font-weight:bold; text-align:right; padding-right:20px;">#totalQuantity#</td>
            </tr>
	    </table>
	    
	     <cfif not isNull(order.getorderNotes())>
		    <div style="clear:both;">
		    	<h4>Customer Comments</h4>
		    	<p>#getHibachiScope().getService('HibachiUtilityService').hibachiHTMLEditFormat(order.orderNotes())#</p>
		    </div>
		    <div style="clear:both; height:30px;">&nbsp;</div>
	    </cfif>
	    
		<table class="signature" style="clear:both;">
	        <tbody>
	            <tr>
	                <td>Print Name</td>
	                <td>Signature</td>
	                <td>Date</td>
	            </tr>
	        </tbody>
	    </table>

		<table>
			<tr>
				<td style="width:70px; height:70px; border: 1px solid black; border-bottom:2px solid black; border-right:2px solid black;"></td>
				<td style="padding-left:10px;">Total Number of Pieces</td>
			</tr>
		</table>
		
	</div><!-- end of .container -->
</cfoutput>