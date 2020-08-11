<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="../../../tags" />
<cfoutput>
<div class="tab-pane" id="orders">
	<h5>Order History</h5>
	
	<!--- Setup an accordian view for existing orders --->
	<div class="accordion" id="order-history-acc">
		
		<!--- Loop over all of the orders that this account has placed --->
		<cfloop array="#$.slatwall.account().getOrdersPlacedSmartList().getRecords()#" index="order">
	  	
		  	<!--- create a DOM ID to be used for open and closing --->
		  	<cfset orderDOMID = "oid#order.getOrderID()#" />
			
			<div class="accordion-group">
				
				<!--- This is the top accordian header row --->
				<div class="accordion-heading">
					<a class="accordion-toggle" data-toggle="collapse" data-parent="##order-history-acc" href="###orderDOMID#">Order ## #order.getOrderNumber()# &nbsp;&nbsp;&nbsp; | &nbsp;&nbsp;&nbsp; #order.getFormattedValue('orderOpenDateTime', 'date' )# &nbsp;&nbsp;&nbsp; | &nbsp;&nbsp;&nbsp; #order.getFormattedValue('total')# <span class="pull-right">Status: #order.getOrderStatusType().getTypeName()#</span></a>
				</div>
				
				<!--- This is the accordian details when expanded --->
				<div id="#orderDOMID#" class="accordion-body collapse">
					
					<div class="accordion-inner">
							
						<!--- Overview & Status --->
						<h5>Overview & Status</h5>
						<div class="row">
							
							<div class="span4">
								<table class="table table-bordered table-condensed">
									<tr>
										<td>Order Status</td>
										<td>#order.getOrderStatusType().getTypeName()#</td>
									</tr>
									<tr>
										<td>Order ##</td>
										<td>#order.getOrderNumber()#</td>
									</tr>
									<tr>
										<td>Order Placed</td>
										<td>#order.getFormattedValue('orderOpenDateTime')#</td>
									</tr>
								</table>
							</div>
							<div class="span4 offset3 pull-right">
								<table class="table table-bordered table-condensed">
									<tr>
										<td>Subtotal</td>
										<td>#order.getFormattedValue('subTotalAfterItemDiscounts')#</td>
									</tr>
									<tr>
										<td>Delivery Charges</td>
										<td>#order.getFormattedValue('fulfillmentChargeAfterDiscountTotal')#</td>
									</tr>
									<tr>
										<td>Taxes</td>
										<td>#order.getFormattedValue('taxTotal')#</td>
									</tr>
									<tr>
										<td><strong>Total</strong></td>
										<td><strong>#order.getFormattedValue('total')#</strong></td>
									</tr>
									<cfif order.getDiscountTotal() gt 0>
										<tr>
											<td colspan="2" class="text-error">You saved #order.getFormattedValue('discountTotal')# on this order.</td>
										</tr>
									</cfif>
								</table>
							</div>
						</div>
						
						<!--- Start: Order Details --->
						<hr />
						<h5>Order Details</h5>
						<cfloop array="#order.getOrderFulfillments()#" index="orderFulfillment">
							
							<!--- Start: Fulfillment Table --->
							<table class="table table-bordered table-condensed">
								<tr>
									<!--- Fulfillment Details --->
									<td class="well span3" rowspan="#arrayLen(orderFulfillment.getOrderFulfillmentItems()) + 1#">
										
										<!--- Fulfillment Name --->
										<strong>#orderFulfillment.getFulfillmentMethod().getFulfillmentMethodName()#</strong><br />
										
										<!--- Fulfillment Details: Email --->
										<cfif orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "email">
											<strong>Email Address:</strong> #orderFulfillment.getEmailAddress()#<br />
											
										<!--- Fulfillment Details: Pickup --->
										<cfelseif orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "pickup" and not isNull(orderFulfillment.getPickupLocation())>
											<strong>Pickup Location:</strong> #orderFulfillment.getPickupLocation().getLocationName()#<br />
											<sw:AddressDisplay address="#orderFulfillment.getPickupLocation().getPrimaryAddress().getAddress()#" />
											
										<!--- Fulfillment Details: Shipping --->
										<cfelseif orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "shipping">
											<sw:AddressDisplay address="#orderFulfillment.getAddress()#" />
											<cfif not isNull(orderFulfillment.getShippingMethod())>
												<strong>Shipping Method:</strong> #orderFulfillment.getShippingMethod().getShippingMethodName()#<br />
											</cfif>
											
										</cfif>
										
										<br />
										<!--- Delivery Fee --->
										<strong>Delivery Fee:</strong> #orderFulfillment.getFormattedValue('chargeAfterDiscount')#
									</td>
									
									<!--- Additional Header Rows --->
									<th>Sku Code</th>
									<th>Product Title</th>
									<th>Qty.</th>
									<th>Price</th>
									<th>Status</th>
								</tr>
								
								<!--- Loop over the actual items in this orderFulfillment --->
								<cfloop array="#orderFulfillment.getOrderFulfillmentItems()#" index="orderItem">
									
									<tr>
										<!--- Sku Code --->
										<td>#orderItem.getSku().getSkuCode()#</td>
										
										<!--- Product Title --->
										<td>#orderItem.getSku().getProduct().getTitle()#</td>
										
										<!--- Quantity --->
										<td>#htmlEditFormat( orderItem.getQuantity() )#</td>
										
										<!--- Price --->
										<td>
											<cfif orderItem.getExtendedPrice() gt orderItem.getExtendedPriceAfterDiscount()>
												<span style="text-decoration:line-through;">#orderItem.getFormattedValue('extendedPrice')#</span> <span class="text-error">#orderItem.getFormattedValue('extendedPriceAfterDiscount')#</span><br />
											<cfelse>
												#orderItem.getFormattedValue('extendedPriceAfterDiscount')#	
											</cfif>
										</td>
										
										<!--- Status --->
										<td>#orderItem.getOrderItemStatusType().getTypeName()#</td>
									</tr>
								</cfloop>
								
							</table>
							<!--- End: Fulfillment Table --->
								
						</cfloop>
						<!--- End: Order Details --->
						
						<!--- Start: Order Payments --->
						<hr />
						<h5>Order Payments</h5>
						<table class="table table-bordered table-condensed table-striped">
							<tr>
								<th>Payment Details</td>
								<th>Amount</td>
							</tr>
							<cfloop array="#order.getOrderPayments()#" index="orderPayment">
								<cfif orderPayment.getOrderPaymentStatusType().getSystemCode() EQ "opstActive">
									<tr>
										<td>#orderPayment.getSimpleRepresentation()#</td>
										<td>#orderPayment.getFormattedValue('amount')#</td>
									</tr>
								</cfif>
							</cfloop>
						</table>
						<!--- End: Order Payments --->
							
						<!--- Start: Order Deliveries --->
						<cfif arrayLen(order.getOrderDeliveries())>
							<hr style="border-top-style:dashed !important; border-top-width:5px !important;" />
							<h5>Order Deliveries</h5>
							
							<cfloop array="#order.getOrderDeliveries()#" index="orderDelivery">
								<table class="table table-bordered table-condensed">
									<tr>
										<!--- Delivery Details --->
										<td class="well span3" rowspan="#arrayLen(orderDelivery.getOrderDeliveryItems()) + 1#">
											
											<!--- Fulfillment Name --->
											<strong>Date:</strong> #orderDelivery.getFormattedValue('createdDateTime')#<br />
											
											<!--- Fulfillment Details: Email --->
											<cfif orderDelivery.getFulfillmentMethod().getFulfillmentMethodType() eq "email">
												<strong>Emailed To:</strong> #orderFulfillment.getEmailAddress()#<br />
												
											<!--- Fulfillment Details: Pickup --->
											<cfelseif orderDelivery.getFulfillmentMethod().getFulfillmentMethodType() eq "pickup">
												<strong>Picked Up At:</strong> #orderDelivery.getPickupLocation().getLocationName()#<br />
												
											<!--- Fulfillment Details: Shipping --->
											<cfelseif orderDelivery.getFulfillmentMethod().getFulfillmentMethodType() eq "shipping">
												<strong>Shipped To:</strong><br />
												<sw:AddressDisplay address="#orderDelivery.getShippingAddress()#" />
												<cfif not isNull(orderDelivery.getTrackingNumber())>
													<br />
													<strong>Tracking Number: <a href="##">#orderDelivery.getTrackingNumber()#</a></strong>
												</cfif>
											</cfif>
											
											<!--- Amount Captured --->
											<cfif not isNull(orderDelivery.getPaymentTransaction())>
												<br />
												<strong>Charged:</strong> #orderDelivery.getPaymentTransaction().getFormattedValue('amountReceived')#
											</cfif>
											
										</td>
										
										<!--- Additional Header Rows --->
										<th>Sku Code</th>
										<th>Product Title</th>
										<th>Qty.</th>
									</tr>
									<cfloop array="#orderDelivery.getOrderDeliveryItems()#" index="orderDeliveryItem">
										<tr>
											<td>#orderDeliveryItem.getOrderItem().getSku().getSkuCode()#</td>
											<td>#orderDeliveryItem.getOrderItem().getSku().getProduct().getTitle()#</td>
											<td>#orderDeliveryItem.getQuantity()#</td>
										</tr>
									</cfloop>
								</table>
							</cfloop>
							
						</cfif>
						<!--- End: Order Deliveries --->
							
					</div> <!--- END: accordion-inner --->
					
				</div> <!--- END: accordion-body --->
				
			</div> <!--- END: accordion-group --->
				
		</cfloop>
		
	</div>
	
</div>
</cfoutput>