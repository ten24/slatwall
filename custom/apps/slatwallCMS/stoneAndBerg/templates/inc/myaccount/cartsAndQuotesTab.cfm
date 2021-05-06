<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="../../../tags" />
<cfoutput>
	<div class="tab-pane" id="carts-and-quotes">
		<h5>Shopping Carts & Quotes</h5>
		
		<div class="accordion" id="cart-and-quotes-acc">
			
			<cfset $.slatwall.account().getOrdersNotPlacedSmartList().addOrder('createdDateTime|DESC') />
			
			<!--- Loop over all of the 'notPlaced' orders --->
			<cfloop array="#$.slatwall.account().getOrdersNotPlacedSmartList().getRecords()#" index="order">
				
				<!--- Setup an orderID for the accordion --->
				<cfset orderDOMID = "oid#order.getOrderID()#" />
				
				<div class="accordion-group">
					
					<!--- Main Button to expand order --->
					<div class="accordion-heading">
						<a class="accordion-toggle" data-toggle="collapse" data-parent="##cart-and-quotes-acc" href="###orderDOMID#">#order.getFormattedValue('createdDateTime', 'date')# <cfif order.getOrderID() eq $.slatwall.cart().getOrderID()><span class="pull-right"><i class="icon-shopping-cart"></i></span></cfif></a>
					</div>
					
					<!--- Saved order content --->
					<div id="#orderDOMID#" class="accordion-body collapse">
						
						<div class="accordion-inner">
							
							<!--- Overview & Status --->
							<h5>Overview & Status</h5>
							<div class="row">
								
								<div class="span4">
									<table class="table table-bordered table-condensed">
										<tr>
											<td>Cart Created</td>
											<td>#order.getFormattedValue('createdDateTime')#</td>
										</tr>
										<tr>
											<td>Last Updated</td>
											<td>#order.getFormattedValue('modifiedDateTime')#</td>
										</tr>
									</table>
								</div>
								<div class="span4 pull-right">
									<table class="table table-bordered table-condensed">
										<tr>
											<td>Current Subtotal</td>
											<td>#order.getFormattedValue('subTotalAfterItemDiscounts')#</td>
										</tr>
										<tr>
											<td>Est. Delivery Charges</td>
											<td>#order.getFormattedValue('fulfillmentChargeAfterDiscountTotal')#</td>
										</tr>
										<tr>
											<td>Est. Taxes</td>
											<td>#order.getFormattedValue('taxTotal')#</td>
										</tr>
										<tr>
											<td><strong>Est. Total</strong></td>
											<td><strong>#order.getFormattedValue('total')#</strong></td>
										</tr>
										<cfif order.getDiscountTotal() gt 0>
											<tr>
												<td colspan="2" class="text-error">This cart includes #order.getFormattedValue('discountTotal')# of savings.</td>
											</tr>
										</cfif>
									</table>
								</div>
							</div>
							
							<!--- Start: Order Details --->
							<hr />
							<h5>Cart Items</h5>
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
											<cfelseif orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "pickup">
												<strong>Pickup Location:</strong> #orderFulfillment.getPickupLocation().getLocationName()#<br />
												<sw:AddressDisplay address="#orderFulfillment.getPickupLocation().getPrimaryAddress().getAddress()#" />
												
											<!--- Fulfillment Details: Shipping --->
											<cfelseif orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "shipping">
												<cfif not orderFulfillment.getAddress().getNewFlag()>
													<sw:AddressDisplay address="#orderFulfillment.getAddress()#" />
												</cfif>
												<cfif not isNull(orderFulfillment.getShippingMethod())>
												<strong>Shipping Method:</strong> #orderFulfillment.getShippingMethod().getShippingMethodName()#<br />
												</cfif>
												
											</cfif>
											
											<!--- Delivery Fee --->
											<cfif orderFulfillment.getChargeAfterDiscount() gt 0>
												<br />
												<strong>Est. Delivery Fee:</strong> #orderFulfillment.getFormattedValue('chargeAfterDiscount')#
											</cfif>
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
								
							<!--- Action Buttons --->
							<cfif order.getOrderID() neq $.slatwall.cart().getOrderID()>
								<div class="row">
									<div class="span3 pull-right">
										<div class="btn-group pull-right">
											<a class="btn" href="?slatAction=public:cart.change&orderID=#order.getOrderID()#"><i class="icon-shopping-cart"></i> Swap to this Cart</a>
											<a class="btn" href="?slatAction=public:cart.delete&orderID=#order.getOrderID()#"><i class="icon-trash"></i> Delete</a>
										</div>
									</div>
								</div>
							</cfif>
									
						</div> <!--- END: accordion-inner --->
						
					</div> <!--- END: accordion-body --->
						
				</div> <!--- END: accordion-group --->
					
			</cfloop>
			
	 	</div>
	</div>
</cfoutput>