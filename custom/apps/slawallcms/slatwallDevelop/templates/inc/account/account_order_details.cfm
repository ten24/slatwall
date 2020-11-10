<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="../../../tags" />

<cfif isNull(order) and structKeyExists(url, "orderid") AND $.slatwall.getEntity('order','#url.orderID#').getAccount().getAccountID() EQ $.slatwall.getAccount().getAccountID()>
	<cfset order = $.slatwall.getEntity('order', '#url.orderID#')>
<cfelse>
	<cflocation url="/my-account/" addtoken="false" > 
</cfif>

<cfoutput>
<cfif NOT isNull(order.getModifiedDateTime())>
	<p class="float-right">Last updated on: #DateTimeFormat(order.getModifiedDateTime(), "mmmm dd, yyyy 'at' hh:nn tt")#</p>
</cfif>
<cfif $.slatwall.content().getUrlTitle() EQ "order">
	<h3>Order ###order.getOrderNumber()#</h3>
<cfelse>
    <h3>Quote Details</h3>
</cfif>

        <!--- Address & Payment Indo --->
	    <div class="row">
		    <!--- Shipping --->
		    <div class="col-md-6 mt-1">
    			<div class="card">
    				<cfif arrayLen(order.getOrderFulfillments())>
		                <cfloop array="#order.getOrderFulfillments()#" index="orderFulfillment">
							<cfif orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "shipping">
							    <h5 class="card-header">Shipping</h5>
                                <div class="card-body">
                                    <h6>Shipping Address</h6>
                                    <address>#orderFulfillment.getShippingAddress().getAddressName()#</address>
                                    <cfif not isNull(orderFulfillment.getShippingMethod())>
    									<h6>Shipping Method</h6>
    									<address>#orderFulfillment.getShippingMethod().getShippingMethodName()# (#orderFulfillment.getFormattedValue('chargeAfterDiscount')#)</address>
    				                </cfif>
    				            </div>
							<cfelseif orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "pickup">
								<h5 class="card-header">Pick Up</h5>
							<cfelseif orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "email">
								<h5 class="card-header">Gift Card Details</h5>
								<div class="card-body">
    								<h6>Gift Card Recipient</h6>
    								<address>
    									<cfloop array = "#orderFulfillment.getOrderFulfillmentItems()#" index = "item">
    										<cfloop array = "#item.getOrderItemGiftRecipients()#" index = "recipient">
    											#recipient.getFirstName()# #recipient.getLastName()#<br>
    											#recipient.getEmailAddress()#
    											<cfif trim(len(recipient.getGiftMessage()))>
    												<br>Gift Card Message<br>
    												#trim(left(recipient.getGiftMessage(),200))#<br>
    											</cfif>
    										</cfloop>
    									</cfloop>
    				                </address>
    				            </div>
    				        <cfelse> 
    				        	<h5 class="card-header">Delivery Information Unavailable</h5>
							</cfif>
						</cfloop>
					</cfif>
    			</div>
    		</div>
			<!--- Billing & Payment --->
			<div class="col-md-6 mt-1">
			    <div class="card">
				    <h5 class="card-header">Billing & Payment</h5>
    				<div class="card-body">
    					<cfif not isNull(orderPayment)>
    						<div>
    							<h5>Billing Address:</h5>								
    							#orderPayment.getBillingAddress().getName()#<br>
    							<cfif not isNull(orderPayment.getBillingAddress().getStreetAddress())>
    							    #orderPayment.getBillingAddress().getStreetAddress()#<br>								
    							</cfif>	
    							<cfif not isNull(orderPayment.getBillingAddress().getStreet2Address())>
    								#orderPayment.getBillingAddress().getStreet2Address()#<br />
    							</cfif>	
    							<cfif not isNull(orderPayment.getBillingAddress().getCity())>
    							    #orderPayment.getBillingAddress().getCity()#,
    							</cfif>
    							<cfif not isNull(orderPayment.getBillingAddress().getStateCode())>
    							    #orderPayment.getBillingAddress().getStateCode()# #orderPayment.getBillingAddress().getPostalCode()#
    							</cfif>
    							<cfif not isNull(orderPayment.getBillingAddress().getPhoneNumber())>
    								<br>#orderPayment.getBillingAddress().getPhoneNumber()#
    							</cfif>	
    						</div>
    					<cfelse>
    					    <cfif $.slatwall.content().getUrlTitle() EQ "order">
    					      <cfif not isNull(order.getCalculatedTotal()) >
    					        <h5>$#order.getCalculatedTotal()#</h5>
    					        </cfif>
    					    <cfelse>
    					        <p>Not entered.</p>
                            </cfif>
    					</cfif>		
    	                <cfloop array="#order.getOrderPayments()#" index="orderPayment">
    						<cfif orderPayment.getOrderPaymentStatusType().getSystemCode() EQ "opstActive" AND orderPayment.getAmount() GT 0>		<!--- Billing Address --->			
    							<cfif not isNull(orderPayment) AND not isNull(orderPayment.getBillingAddress().getStreetAddress())>
    								<h5>Billing Address</h5>								
									<cfif not isNull(orderPayment.getBillingAddress().getName())>
								    	<br>#orderPayment.getBillingAddress().getName()#
									</cfif>
									<cfif not isNull(orderPayment.getBillingAddress().getStreetAddress())>
									    <br>#orderPayment.getBillingAddress().getStreetAddress()#							
									</cfif>
									<cfif not isNull(orderPayment.getBillingAddress().getStreet2Address())>
										<br>#orderPayment.getBillingAddress().getStreet2Address()#
									</cfif>
									<cfif not isNull(orderPayment.getBillingAddress().getCity())>
									    <br>#orderPayment.getBillingAddress().getCity()#, 
									</cfif>
									<cfif not isNull(orderPayment.getBillingAddress().getStateCode())>
									    #orderPayment.getBillingAddress().getStateCode()# #orderPayment.getBillingAddress().getPostalCode()#<br>
									</cfif>
									<cfif not isNull(orderPayment.getBillingAddress().getPhoneNumber())>
										#orderPayment.getBillingAddress().getPhoneNumber()#<br>
									</cfif>	
    							</cfif>	
    							<!--- Credit Card --->
    		                	<cfif orderPayment.getPaymentMethod().getPaymentMethodType() EQ "creditCard">
									<h5>Credit Card</h5>
									<cfif orderPayment.getCreditCardType() EQ 'Visa'>
										<br><i class="fa fa-cc-visa" aria-hidden="true"></i> ending in XXXX#orderPayment.getCreditCardLastFour()#
									</cfif>
									<cfif orderPayment.getCreditCardType() EQ 'MasterCard'>
										<br><i class="fa fa-cc-mastercard" aria-hidden="true"></i> ending in XXXX#orderPayment.getCreditCardLastFour()#
									</cfif>
									<cfif orderPayment.getCreditCardType() EQ 'American Express'>
										<br><i class="fa fa-cc-amex" aria-hidden="true"></i> ending in XXXX#orderPayment.getCreditCardLastFour()#
									</cfif>
    							</cfif>
    							<!--- Gift Card --->
    							<cfif orderPayment.getPaymentMethod().getPaymentMethodType() EQ "giftCard">
    		                		<h5>Gift Card</h5>
    								<p>Card ##: #orderPayment.getgiftCardNumberEncrypted()#</p>
								    <ul>
						    		    <li>Amount Applied: - #orderPayment.getFormattedValue('amount','currency')#</li>
						        		<li>New Gift Card Balance: #orderpayment.getGiftCard().getFormattedValue('balanceAmount','currency')#</li>
						    		</ul>
    						    </cfif>
    					    	<!--- Purchase Order --->	
    				    		<cfif (orderPayment.getPaymentMethod().getPaymentMethodType() EQ "termPayment")>
    					    		<div>
    					    			<cfif structKeyExists($.slatwall.getErrors(),'purchaseOrder') && len($.slatwall.getErrors()['purchaseOrder'][1])>
    					    				<div class="alert alert-danger" role="alert">
    											#$.slatwall.getErrors()['purchaseOrder'][1]#
    										</div>
    				    				</cfif>
    								    <h5>Purchase Order</h5>
    						    		<form action="?s=1&orderID=#url.orderID#" method="post">
    										<!--- Hidden slatAction to update the account --->
    										<input type="hidden" name="slatAction" value="etr:cart.updateOrderPayment" />
    										<input type="hidden" name="orderPaymentID" value="#orderPayment.getOrderPaymentID()#">
    										
    										<cfif len(orderPayment.getPurchaseOrder())>
    											Current purchase order: #orderPayment.getPurchaseOrder()#
    										</cfif>
    										
    				                    	<sw:FormField type="file" name="purchaseOrder" valueObject="#orderPayment#" valueObjectProperty="purchaseOrder" class="form-control" />
    				                    	<sw:ErrorDisplay object="#orderPayment#" errorName="purchaseOrder" />
    				                    	
    										<cfif $.slatwall.hasSuccessfulAction( "etr:cart.updateOrderPayment" )>
    										   <div class="alert alert-success">
    										       <i class="fa fa-info-circle"></i> Your purchase order was successfully uploaded.
    										   </div>
    										</cfif>
    										<cfif $.slatwall.hasFailureAction( "etr:cart.updateOrderPayment" )>
    										    <div class="alert alert-danger">
    										        <i class="fa fa-info-circle"></i> Your purchase order failed to upload.
    										    </div>
    										</cfif>
    				                    	<button class="btn btn-secondary">Submit</button>
    			                    	</form>
    			                    </div>
    							</cfif>						
    						</cfif>
    					</cfloop>	
    				</div>
				</div>
			</div>
		</div>
		
    	<!--- Items Purchased --->
    	<div class="row">
        	<div class="col-12">
    	        <cfloop array="#order.getOrderItems()#" index="local.orderItem">
    	        	<div class="bg-light mt-3 mb-3 p-2 pb-3">
    	        		<div class="col-xl-3 col-lg-12 mt-2 mb-2">
    	        			<cfset local.smallimages = $.slatwall.getService("ImageService").getResizedImageByProfileName("#local.orderItem.getSku().getProduct().getDefaultSku().getSkuID()#","small") />
    	        			<cfif arrayLen(local.smallimages)>
								<a href="/#$.slatwall.getSite().getSiteCode()#/#$.slatwall.setting('globalURLKeyProduct')#/#local.orderItem.getSku().getProduct().getUrlTitle()#">
								    <img src="#local.smallimages[1]#" alt="#local.orderItem.getSku().getProduct().getProductName()#">
								</a>
							</cfif>
									
    	        		</div>
    	        		<div class="col-xl-2 col-lg-12 mt-2">
    	        			<h5><a href="/#$.slatwall.getSite().getSiteCode()#/#$.slatwall.setting('globalURLKeyProduct')#/#local.orderItem.getSku().getProduct().getUrlTitle()#">#local.orderItem.getSku().getProduct().getProductName()#</a></h5>
    	        		</div>
    	        		<cfif $.slatwall.content().getUrlTitle() EQ "order">
    	        		<div class="col-xl-2 col-lg-12 mt-2">
    	        		<cfelse>
    	                <div class="col-xl-4 col-lg-12 mt-2">
    	        		</cfif>
    	                    <strong>#local.orderItem.getFormattedValue('price', 'currency')# (#NumberFormat(local.orderItem.getQuantity())#)</strong><br>
    	                    <cfif len(local.orderItem.getSku().getCalculatedSkuDefinition())>
    	                        #local.orderItem.getSku().getCalculatedSkuDefinition()#
    	                    </cfif>
    	        		</div>
    	        		<div class="col-xl-2 col-lg-12 mt-2">
    	        			#local.orderItem.getFormattedValue('calculatedItemTotal', 'currency')#
    	        		</div>
    	        		<cfif 
    	        		$.slatwall.content().getUrlTitle() EQ "order" 
    	        		AND local.orderItem.getSku().getProduct().getActiveFlag() EQ true
    	        		AND local.orderItem.getSku().getProduct().getPublishedFlag() EQ true>
        	        		<div class="col-xl-2 col-lg-12 mt-2">
        	        			<a href="/shopping-cart/?slatAction=public:cart.change&orderID=#order.getOrderID()#&abandonedCart=true&utm_source=abandonedCart&utm_medium=email&utm_campaign=Abandoned%20Cart%201%20Day" class="btn btn-secondary"><i class="fa fa-shopping-cart"></i> Reorder</a>
        	        		</div>
    	        		</cfif>
    	        	</div>
    			</cfloop>
    		</div>
    	</div>

        <!--- Order Details --->
        <div class="row">
    		<div class="col-md-12">
    			<div class="card">
    			    <cfif $.slatwall.content().getUrlTitle() EQ "order">
            			<h5 class="card-header">Order Summary</h5>
            		<cfelse>
            		    <h5 class="card-header">Quote Summary</h5>
            		</cfif>
            		<div class="card-body">
            			<p>Subtotal:
            			    <span class="pull-right">#order.getFormattedValue('subTotalAfterItemDiscounts')#</span>
            			</p>
            			<p>Shipping:
            			    <span class="pull-right">#order.getFormattedValue('fulfillmentTotal')#</span>
            			</p>
            			<cfif order.getDiscountTotal() GT 0>
            				<p>Discount:
            				    <span class="pull-right text-danger">- #order.getFormattedValue('discountTotal')#</span>
            			    </p>
            			</cfif>
            			<p>Tax:
            			    <span class="pull-right">#order.getFormattedValue('calculatedTaxTotal')#</span>
            			</p>
            			<hr />				
            			<p>Total:
            			    <span class="pull-right">#order.getFormattedValue('calculatedTotal')#</span>
            			</p>
            			<cfif order.getPaymentAmountReceivedTotal() GT 0>
	            			<p>Received:
	            			    <span class="pull-right">(#order.getFormattedValue('paymentAmountReceivedTotal')#)</span>
	            			</p>
            			</cfif>
            			<cfif order.getPaymentAmountCreditedTotal() GT 0>
	            			<p>Credited:
	            			    <span class="pull-right">(#order.getFormattedValue('paymentAmountCreditedTotal')#)</span>
	            			</p>
            			</cfif>
            			<cfif order.getCalculatedTotal() NEQ order.getPaymentAmountDue()>
	            			<p>Balance Due:
	            			    <span class="pull-right">#order.getFormattedValue('paymentAmountDue')#</span>
	            			</p>
            			</cfif>
            			<cfif $.slatwall.content().getUrlTitle() EQ "order">
            			    <a href="javascript:window.print();" class="btn btn-primary"><i class="fa fa-print"></i> Print Order</a>
            			<cfelse>
            			    <a href="javascript:window.print();" class="btn btn-primary mt-1"><i class="fa fa-print"></i> Print Quote</a>
            			    <a href="/shopping-cart/?slatAction=public:cart.change&orderID=#order.getOrderID()#&abandonedCart=true&utm_source=abandonedCart&utm_medium=email&utm_campaign=Abandoned%20Cart%201%20Day" class="btn btn-secondary mt-1">Resume Checkout</a>
            			</cfif>
            		</div>
            	</div>
    		</div>
    	</div>
    </div>
</cfoutput>