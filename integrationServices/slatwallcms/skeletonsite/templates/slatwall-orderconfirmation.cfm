<cfimport prefix="sw" taglib="../../../../../tags" />
<cfinclude template="_slatwall-header.cfm" />
<cfoutput>

<cfif isNull($.slatwall.getSession().getLastPlacedOrderID())>
	<cflocation url="/" addtoken="false" >
<cfelse>
	<cfset order = $.slatwall.getService("orderService").getOrder($.slatwall.getSession().getLastPlacedOrderID()) >
</cfif>

<div class="container">
    
    <h1 class="my-4">#$.slatwall.content('title')#</h4>
    
     #$.slatwall.content('contentBody')#
        
    <div class="row mt-4">
		<!--- Billing & Payment --->
		<div class="col-md-4">
		    <div class="card mb-4">
    			<h5 class="card-header">Billing &amp; Payment</h5>
    			<div class="card-body">
    				
        		    <cfset local.paymentService = $.slatwall.getService('PaymentService') />
        		    <cfset appliedPaymentsCollectionList = order.getOrderPaymentsCollectionList() />
        		    <cfset appliedPaymentsCollectionList.addFilter('orderPaymentType.systemCode', 'optCharge') />
        		    <cfset appliedPaymentsCollectionList.addFilter('orderPaymentStatusType.systemCode', 'opstActive') />
        		    <cfset local.appliedPaymentsRecords = appliedPaymentsCollectionList.getRecords(formatRecords=false) />
        			
        			<cfif arraylen(local.appliedPaymentsRecords)>
        				<h6>Billing Address</h6>
        			    <cfloop array="#local.appliedPaymentsRecords#" index="orderPayment">
        			    	<cfset local.orderPayment = local.paymentService.getOrderPayment(orderPayment['orderPaymentID']) />
        				    <address>
        					    <cfif not isNull(local.orderPayment.getBillingAddress().getName())>
        						   #local.orderPayment.getBillingAddress().getName()#<br>
        					    </cfif>
        					    <cfif not isNull(local.orderPayment.getBillingAddress().getStreetAddress())>
        						   #local.orderPayment.getBillingAddress().getStreetAddress()#<br>
        					    </cfif>
        					    <cfif not isNull(local.orderPayment.getBillingAddress().getStreet2Address())>
        						   #local.orderPayment.getBillingAddress().getStreet2Address()#<br />
        					    </cfif>
        					    <cfif not isNull(local.orderPayment.getBillingAddress().getLocality())>
        						   #local.orderPayment.getBillingAddress().getLocality()#<br />
        					    </cfif>
        					    <cfif not isNull(local.orderPayment.getBillingAddress().getCity()) and not isNull(local.orderPayment.getBillingAddress().getStateCode()) and not isNull(local.orderPayment.getBillingAddress().getPostalCode())>
        						   #local.orderPayment.getBillingAddress().getCity()#, #local.orderPayment.getBillingAddress().getStateCode()# #local.orderPayment.getBillingAddress().getPostalCode()#<br />
        					    <cfelse>
        						    <cfif not isNull(local.orderPayment.getBillingAddress().getCity())>
        							   #local.orderPayment.getBillingAddress().getCity()#<br />
        						    </cfif>
        						    <cfif not isNull(local.orderPayment.getBillingAddress().getStateCode())>
        							   #local.orderPayment.getBillingAddress().getStateCode()#<br />
        						    </cfif>
        						    <cfif not isNull(local.orderPayment.getBillingAddress().getPostalCode())>
        							   #local.orderPayment.getBillingAddress().getPostalCode()#<br />
        						    </cfif>
        					    </cfif>
        					    <cfif not isNull(local.orderPayment.getBillingAddress().getCountryCode())>
        						   #local.orderPayment.getBillingAddress().getCountryCode()#<br />
        					    </cfif>
        				    </address>
        
        				    <h6>Payment Method</h6>
        				    
        				    <cfif local.orderPayment.getPaymentMethod().getPaymentMethodName() EQ 'Purchase Order'>
        					   <p>Purchase Order ## <strong>#local.orderPayment.getPurchaseOrderNumber()#</strong></p>
        				    <cfelse>
        					   <p>#local.orderPayment.getCreditCardType()# ending in **** #local.orderPayment.getCreditCardLastFour()#</p>
        				    </cfif>
        				    <cfbreak>
        			    </cfloop>
        			<cfelse>
        				<p>No billing information has been saved.</p>
        			</cfif>
        		</div>
    		</div>
		</div>
			
		<!--- Shipping --->
		<div class="col-md-4">
			
			<cfset shippingAddress = order.getorderFulfillments()[1].getShippingAddress()>
			<div class="card mb-4">
				<h5 class="card-header">Shipping</h5>
				<div class="card-body">
    				<h6>Shipping Address</h6>
    				<address>
    					<cfif Len(trim(shippingAddress.getName()))>
    						#shippingAddress.getName()#<br>
    					</cfif>
    					#shippingAddress.getStreetAddress()# #shippingAddress.getStreet2Address()#<br>
    					#shippingAddress.getCity()#,
    					#shippingAddress.getStateCode()#
    					#shippingAddress.getPostalCode()#<br>
    					#shippingAddress.getCountryCode()#
    				</address>
				
    				<cfif order.getorderFulfillments()[1].getFulfillmentMethodType() EQ "shipping">
    					<h6>Shipping Method</h6>
    					<p>#order.getorderFulfillments()[1].getShippingMethod().getShippingMethodName()#</p>
    				</cfif>
    			</div>
			</div>
    	</div>
    	
    	<!--- Order Summary --->
    	<div class="col-md-4">
    	    <div class="card mb-4">
    		    <h5 class="card-header">Order Summary</h5>
    		    <ul class="list-group list-group-flush">
        	    	<cfif len(order.getOrderNumber())>
        			    <li class="list-group-item d-flex justify-content-between align-items-center">
        				   Order Number
        				   <span>###order.getOrderNumber()#</span>
        			    </li>
        		    </cfif>
        		    <li class="list-group-item d-flex justify-content-between align-items-center">
        			   Subtotal
        			   <span>#order.getFormattedValue('subtotal', 'currency')#</span>
        		    </li>
        		    <cfif order.getDiscountTotal()>
        			    <li class="list-group-item d-flex justify-content-between align-items-center">
        				   Discounts Applied
        				   <span class="text-danger">- #order.getFormattedValue('discountTotal', 'currency')#</span>
        			    </li>
        		    </cfif>
        		    <li class="list-group-item d-flex justify-content-between align-items-center">
        			   Tax
        			   <span>#order.getFormattedValue('taxTotal', 'currency')#</span>
        		    </li>
        		    <cfif not isNull(order.getFulfillmentTotal()) AND order.getFulfillmentTotal() GT 0>
        			    <li class="list-group-item d-flex justify-content-between align-items-center">
        				   Shipping and Handling
        				   <span>#order.getFormattedValue('fulfillmentTotal', 'currency')#</span>
        			    </li>
        		    </cfif>
        		    <li class="list-group-item d-flex justify-content-between align-items-center">
        			   Total
        			   <strong>#order.getFormattedValue('total', 'currency')#</strong>
        		    </li>
                </ul>
            </div>
		</div>
	</div>

	<!--- Order Items --->
	<div class="card">
		<h5 class="card-header">Your Order</h5>
		<div class="card-body">
		    <cfloop array="#order.getOrderItems()#" index="local.orderItem">
    		    <div class="row mb-2">
    		        <div class="col-12 col-sm-12 col-md-2 text-center">
    		            <a href="#local.orderItem.getSku().getProduct().getProductURL()#/">
    						<img src="#local.orderItem.getSku().getProduct().getResizedImagePath(width='97')#" alt="#encodeForHTML(orderItem.getSku().getProduct().getTitle())#">
    					</a>
    		        </div>
    		        <div class="col-12 text-sm-center col-sm-12 text-md-left col-md-4">
	    		        <cfif local.orderItem.getSku().getBundleFlag()>
	    		    		<h5><a href="#local.orderItem.getSku().getProduct().getProductURL()#">#local.orderItem.getSku().getProduct().getProductName()#</a></h5>
	            			<ul class="list-unstyled">
	            				<cfLoop array="#local.orderItem.getSku().getBundledSkus()#" index="local.bundledSku">
	            					<cfset local.sku = local.bundledSku.getBundledSku() />
        							<li><a href="#local.sku.getProduct().getProductURL()#">#local.sku.getProduct().getProductName()#</a></li>
            						<li><small class="text-secondary">Product Code: #local.sku.getProduct().getProductCode()#</small></li>
            						<li><small class="text-secondary">Sku Code: #local.sku.getSkuCode()#</small></li>
            						<li><small class="text-secondary">#local.sku.getSkuDefinition()#</small></li>
            						<li><small class="text-secondary">QTY: #local.bundledSku.getBundledQuantity()#</small></li>
	            				</cfLoop>
	            			</ul>
	    		    	<cfelse>	
	    		            <h5><a href="#local.orderItem.getSku().getProduct().getProductURL()#">#local.orderItem.getSku().getProduct().getProductName()#</a></h5>
	            			<ul class="list-unstyled">
	            			    <li><small class="text-secondary">#local.orderItem.getSku().getProduct().getProductType().getProductTypeName()#</small></li>
	            			    <li><small class="text-secondary">Product Code: #local.orderItem.getSku().getProduct().getProductCode()#</small></li>
	            			    <li><small class="text-secondary">Sku Code: #local.orderItem.getSku().getSkuCode()#</small></li>
	            				<li><small class="text-secondary">#local.orderItem.getSku().getSkuDefinition()#</small></li>
	            			</ul>
            			</cfif>
    		        </div>
	                <div class="col-12 col-sm-12 text-sm-center col-md-6 text-md-right row">
	                    <div class="col-4 col-sm-6 pt-2">
	                        Qty: #local.orderItem.getQuantity()#
	                    </div>
	                    <div class="col-4 col-sm-6 text-md-right pt-2">
	                        #DollarFormat(local.orderItem.getPrice() * local.orderItem.getQuantity())#
	                    </div>
	                </div>
    		    </div>
    	    </cfloop>
    	</div>
	</div>
</div>
<cfinclude template="_slatwall-footer.cfm" />
</cfoutput> 