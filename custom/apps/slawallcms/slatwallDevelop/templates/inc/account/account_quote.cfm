									
					<cfelse>
					    <p>Not entered.</p>
					    <button class="button">Resume Checkout</button>
					</cfif>
				</div><!-- end of .order-shipping -->
				
				<div class="order-billing">
					<h3>Billing & Payment</h3>
					<cfif not isNull(orderPayment)>
						<address class="row">
							<div class="col-md-12">
							<strong>Billing Address: </strong>								
							#orderPayment.getBillingAddress().getName()#<br>
							#orderPayment.getBillingAddress().getStreetAddress()#<br>								
							<cfif not isNull(orderPayment.getBillingAddress().getStreet2Address())>
								#orderPayment.getBillingAddress().getStreet2Address()#<br />
							</cfif>	
							#orderPayment.getBillingAddress().getCity()#, #orderPayment.getBillingAddress().getStateCode()# #orderPayment.getBillingAddress().getPostalCode()#
							<cfif not isNull(orderPayment.getBillingAddress().getPhoneNumber())>
								<br>#orderPayment.getBillingAddress().getPhoneNumber()#
							</cfif>								
							</div>
						</address>
						<cfelse>
					    
					</cfif>	
					
					<cfloop array="#order.getOrderPayments()#" index="orderPayment">
						<cfif orderPayment.getOrderPaymentStatusType().getSystemCode() EQ "opstActive" AND orderPayment.getAmount() GT 0>					
							<cfif not isNull(orderPayment)>
								<address class="row">
									<div class="col-md-12">
									<strong>Billing Address: </strong>								
									#orderPayment.getBillingAddress().getName()#<br>
									#orderPayment.getBillingAddress().getStreetAddress()#<br>								
									<cfif not isNull(orderPayment.getBillingAddress().getStreet2Address())>
										#orderPayment.getBillingAddress().getStreet2Address()#<br />
									</cfif>	
									#orderPayment.getBillingAddress().getCity()#, #orderPayment.getBillingAddress().getStateCode()# #orderPayment.getBillingAddress().getPostalCode()#
									<cfif not isNull(orderPayment.getBillingAddress().getPhoneNumber())>
										<br>#orderPayment.getBillingAddress().getPhoneNumber()#
									</cfif>								
									</div>
								</address>
							</cfif>	
		                	<cfif orderPayment.getPaymentMethod().getPaymentMethodType() EQ "creditCard">
								<div class="row">
									<div class="col-md-12">
										<h6><strong>Credit Card</strong></h6>
										<cfif orderPayment.getCreditCardType() EQ 'Visa'>
											<img src="/custom/apps/slatwallcms/assets/images/visa.png" alt="Visa" class="creditcard"> ending in XXXX#orderPayment.getCreditCardLastFour()#
										<cfelseif orderPayment.getCreditCardType() EQ 'MasterCard'>
											<img src="/custom/apps/slatwallcms/assets/images/mastercard.png" alt="MasterCard" class="creditcard"> ending in XXXX#orderPayment.getCreditCardLastFour()#
										<cfelseif orderPayment.getCreditCardType() EQ 'American Express'>
											<img src="/custom/apps/slatwallcms/assets/images/americanexpress.png" alt="American Express" class="creditcard"> ending in XXXX#orderPayment.getCreditCardLastFour()#
										<cfelse>
										</cfif>
									</div>
								</div>
		                	<cfelseif orderPayment.getPaymentMethod().getPaymentMethodType() EQ "giftCard">
								<div class="row">
									<div class="col-md-12">
									    <h6><strong>Gift Card <span class="pull-right">###orderPayment.getgiftCardNumberEncrypted()#</span></strong</h6>
									    <ul>
							    		    <li>Amount Applied <span class="pull-right red">- #orderPayment.getFormattedValue('amount','currency')#</span></li>
							        		<li>New Gift Card Balance <span class="pull-right">#orderpayment.getGiftCard().getFormattedValue('balanceAmount','currency')#</span></li>
							    		</ul>
						    		</div>
					    		</div>
							</cfif>						
						</cfif>
					</cfloop>					
				</div><!-- end of .order-billing -->
			</div><!-- end of .order-content -->
		<div class="order-details">
			<div class="info-block-title">
				<h5>Order Details</h5>	
			</div>
			<p>
				Item Total:
				<span class="pull-right">#order.getFormattedValue('subTotalAfterItemDiscounts')#</span>
			</p>
			<p>
				Shipping:
				<span class="pull-right">#order.getFormattedValue('fulfillmentTotal')#</span>
			</p>
			<p>
				Tax:
				<span class="pull-right">#order.getFormattedValue('calculatedTaxTotal')#</span>
			</p>			
			<hr />				
			<p>
				Total:
				<span class="pull-right">#order.getFormattedValue('calculatedTotal')#</span>
			</p>
		</div><!-- end of .order-details -->
	</div><!-- end of .order-info -->
	
	<!--- DISPLAY ITEMS PURCHASED --->
	<article class="item_purchased-bar" id="recentOrders">
    	<h3>Your Order Items</h3>
    	
    	<div class="single-order">
	        <cfloop array="#order.getOrderItems()#" index="local.orderItem">
	        	<div class="row">
        			<div class="col1">
	        			<img src="#local.orderItem.getSku().getProduct().getResizedImagePath(width='120',height='120')#" alt="#local.orderItem.getSku().getSkuName()#">
	        		</div>
	        		<div class="col2">
	        			<!---<h3><a href="#m.createHREF( filename='store', siteid=m.event('siteID') )##$.slatwall.setting('globalURLKeyProduct')#/#local.orderItem.getSku().getProduct().getUrlTitle()#">#local.orderItem.getSku().getSkuName()#</a></h3>--->
	        		</div>
	        		<div class="col3">
	                    <strong>#local.orderItem.getFormattedValue('price', 'currency')# (#NumberFormat(local.orderItem.getQuantity())#)</strong>
	                    <cfif len(local.orderItem.getSku().getCalculatedSkuDefinition())>
	                        <small>#local.orderItem.getSku().getCalculatedSkuDefinition()#</small>
	                    </cfif>        			
	        		</div>
	        		<div class="col4">
	        			#local.orderItem.getFormattedValue('calculatedItemTotal', 'currency')#
	        		</div>
	        	</div>
			</cfloop>	
		</div>
	</article>
</article>
</cfoutput>
