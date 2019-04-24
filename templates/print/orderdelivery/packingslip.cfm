<cfparam name="print" type="any" />
<cfparam name="printData" type="struct" default="#structNew()#" />
<cfparam name="orderDelivery" type="any" />
<cfset local.order=orderDelivery.getOrder()>

<cfoutput>
	<style>
	.invoice-temp {font-size: 13px; color: ##000; font-family: Arial, sans-serif; max-width: 700px; margin: 0 auto;}
	.invoice-temp p {margin: 0;}
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
	.footer {font-size: 12px;}
	</style>

	<!-- POD Template -->
	<div class="invoice-temp">
	    <div class="invoice-intro">
			<div class="col1">
			
			<!---client image and info goes here--->
			
			</div>
			
			<div class="col2">
			    <h1>PACKING SLIP</h1>
			    
			    <table cellpadding="3" cellspacing="0" border="0" style="margin-bottom:20px;">
					<tbody>
						<tr>
						    <td><strong>INVOICE DATE</strong></td>
						    <td>#DateFormat(local.order.getOrderOpenDateTime(), "MM/DD/YYYY")#</td>
						</tr>
						<tr>
						    <td><strong>CUSTOMER</strong></td>
						    <td>#order.getAccount().getFirstName()# #order.getAccount().getLastName()#</td>
						</tr>
						<tr>
						    <td><strong>INVOICE NO.</strong></td>
						    <td>#order.getOrderNumber()#</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>

	    <div class="customer-info" style="margin-bottom:25px;">
	        <div class="col1">
				<table cellpadding="0" cellspacing="0" border="0" style="margin-top:30px;">
					  <tbody>
						  <tr>
							  <td>
								<br><strong>Bill To:</strong><br>
								<cfif not isNull(order.getBillingAddress().getCompany()) >
									#order.getBillingAddress().getName()#<br />
								</cfif>
								  <cfif not isNull(order.getBillingAddress().getCompany())>
									#order.getBillingAddress().getCompany()#<br />
								  </cfif>
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
								  <cfif not isNull(order.getAccount().getPhoneNumber())>
									 Phone ## #order.getAccount().getPhoneNumber()#<br />
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
								<cfif orderDelivery.getFulfillmentMethod().getFulfillmentMethodType() EQ "shipping">
									<div id="shippingAddress" style="width:290px; margin-right:10px; float:left;">
										<strong>Ship To:</strong><br />
										<cfif len(orderDelivery.getOrderFulfillment().getAddress().getName())>#orderDelivery.getOrderFulfillment().getAddress().getName()#<br /></cfif>
										<cfif not isNull(order.getAccount()) and len(order.getAccount().getCompany())>#order.getAccount().getCompany()#<br /></cfif>
										<cfif len(orderDelivery.getOrderFulfillment().getAddress().getStreetAddress())>#orderDelivery.getOrderFulfillment().getAddress().getStreetAddress()#<br /></cfif>
										<cfif len(orderDelivery.getOrderFulfillment().getAddress().getStreet2Address())>#orderDelivery.getOrderFulfillment().getAddress().getStreet2Address()#<br /></cfif>
										#orderDelivery.getOrderFulfillment().getAddress().getCity()#, #orderDelivery.getOrderFulfillment().getAddress().getStateCode()# #orderDelivery.getOrderFulfillment().getAddress().getPostalCode()#
										#orderDelivery.getOrderFulfillment().getAddress().getCountryCode()#
									</div>
								<cfelseif orderDelivery.getFulfillmentMethod().getFulfillmentMethodType() EQ "email">
									<div id="emailAddress" style="width:190px; margin-right:10px; float:left;">
										<strong>Delivery Email</strong><br /><br />
										#orderDelivery.getOrderFulfillment().getEmailAddress()#
									</div>
								<cfelseif orderDelivery.getFulfillmentMethod().getFulfillmentMethodType() EQ "auto">
									<div id="fulfillmentAuto" style="width:190px; margin-right:10px; float:left;">
										<strong>Auto Fulfilled</strong><br /><br />
									</div>
								<cfelseif orderDelivery.getFulfillmentMethod().getFulfillmentMethodType() EQ "pickup">
									<div id="pickup" style="width:190px; margin-right:10px; float:left;">
										<strong>Store Pickup</strong><br />
										<cfif not isNull(local.orderFulfillment.getPickupDate()) AND Len(local.orderFulfillment.getPickupDate())>
											<p>Pickup Date: <strong>#dateformat(orderDelivery.getOrderFulfillment().getPickupDate(),"mmm d, yyyy")#</strong></p>
										</cfif>
									</div>
 								</cfif>
 								<cfif not isNull(orderDelivery.getOrderFulfillment().getAddress().getPhoneNumber())>
								 Phone ## #orderDelivery.getOrderFulfillment().getAddress().getPhoneNumber()#<br />
							  </cfif>
							</td>
						</tr>
					</tbody>
				</table>
	        </div><!--- end of .col2 --->
	    </div>
		
		<div style="clear:both; height:30px;">&nbsp;</div>
		<cfset local.orderPaymentCollectionList = getService('orderService').getOrderPaymentCollectionList() />
		<cfset local.orderPaymentCollectionList.addFilter('order.orderID',local.order.getOrderID()) />
		<cfset local.orderPaymentCollectionList.addFilter('purchaseOrderNumber','null','IS NOT') />
		<cfset local.orderPaymentCollectionList.addFilter('orderPaymentStatusType.systemCode','opstActive','=') />
		<cfset local.orderPaymentCollectionList.setDisplayProperties('purchaseOrderNumber,paymentTerm.paymentTermName,paymentTerm.term.termID') />
		<cfset local.orderPayments = local.orderPaymentCollectionList.getRecords() />
		<cfloop array="#local.orderPayments#" index="local.currentOrderPayment">
			<cfif len(local.currentOrderPayment['purchaseOrderNumber']) >
				<cfset local.orderPayment = local.currentOrderPayment />
			</cfif>
		</cfloop>
		<cfif structKeyExists(local,'orderPayment') && len(trim(local.orderPayment['paymentTerm_term_termID'])) >
			<cfset local.paymentTerm = getService('paymentService').getTerm(local.orderPayment.paymentTerm_term_termID) />
			<cfset local.orderPayment['dueDate'] = local.paymentTerm.getEndDate(local.order.getOrderOpenDateTime()) />
		</cfif>
		<table class="invoice-list" cellspacing="5">
			<thead>
				<tr>
					<cfif structKeyExists(local,'orderPayment') AND len(trim(local.orderPayment['purchaseOrderNumber'])) >
						<th>DUE DATE</th>
						<th>CUSTOMER PO NO.</th>
					</cfif>
					<th>SHIP VIA</th>
					<th>SALESPERSON</th>
					<th>ORDER DATE</th>
					<th>TERMS</th>
				</tr>
			</thead>
			<tbody>
				<cfif structKeyExists(local,'orderPayment') AND len(trim(local.orderPayment['purchaseOrderNumber'])) >
					<td><cfif structKeyExists(local.orderPayment,'dueDate')>#dateformat( local.orderPayment['dueDate'],'mm/dd/yyy' )#</cfif></td>
					<td>#local.orderPayment['purchaseOrderNumber']#</td>
				</cfif>
				<td>
					<cfif not isNull(orderDelivery.getOrderFulfillment().getShippingIntegration()) ><strong>#orderDelivery.getOrderFulfillment().getShippingIntegration().getIntegrationName()#</strong><br></cfif>
					<cfif not isNull(orderDelivery.getOrderFulfillment().getShippingMethod()) >#orderDelivery.getOrderFulfillment().getShippingMethod().getShippingMethodName()#</cfif>
				</td>
				<td><!---#local.order.getSalesPerson()#---></td>
				<td>#dateFormat( local.order.getOrderOpenDateTime(),'mm/dd/yyyy' )#</td>
				<td><cfif structKeyExists(local,'orderPayment') AND len(trim(local.orderPayment['paymentTerm_paymentTermName'])) >#local.orderPayment['paymentTerm_paymentTermName']#</cfif></td>
			</tbody>
		</table>
		
	    <table class="invoice-list" cellspacing="5">
	        <thead>
	            <tr>
	                <th>ITEM NO.</th>
	                <th>DESCRIPTION</th>
	                <th>ORDER QUANTITY</th>
	                <th>SHIP QUANTITY</th>
					<th>B/O QUANTITY</th>
					<th>SHIPMENT DATE</th>
					<th>PACKED</th>
	            </tr>
	        </thead>
			<cfset local.totalQuantity=0>
			<cfset local.orderDeliveryItemCollectionList = orderDelivery.getOrderDeliveryItemsCollectionList()>
			<cfset local.orderDeliveryItemCollectionList.setDisplayProperties('orderItem.quantity,orderItem.sku.skuCode,orderItem.sku.skuName,quantity,orderItem.sku.product.calculatedTitle,orderItem.sku.product.productCode')>
			<cfset local.orderDeliveryItemCollectionList.addDisplayAggregate('orderItem.orderDeliveryItems.quantity','sum','orderItem_quantityDelivered') />
			<cfset local.orderDeliveryItemCollectionList.addFilter('quantity', 0, '>' )>
			
			<cfset local.orderDeliveryItemCollectionList.setOrderBy('orderItem.sku.skuName|ASC')>
			<cfloop array="#local.orderDeliveryItemCollectionList.getRecords()#" index="local.orderDeliveryItem">
				<cfset local.totalQuantity+=local.orderDeliveryItem['quantity']>
				<tr>
					<td>#local.orderDeliveryItem['orderItem_sku_skuCode']#</td>
					<td>#local.orderDeliveryItem['orderItem_sku_skuName']#</td>
	                <td>#NumberFormat(local.orderDeliveryItem['orderItem_quantity'])#</td>
	                <td>#NumberFormat(local.orderDeliveryItem['quantity'])#</td>
	                <td>#NumberFormat(local.orderDeliveryItem['orderItem_quantity'] - local.orderDeliveryItem['orderItem_quantityDelivered'])#</td>
	                <td></td>
	                <td></td>
	            </tr>
			</cfloop>
	    </table>
	    
	     <cfif not isNull(local.order.getOrderNotes())>
		    <div style="clear:both;">
		    	<h4>Customer Comments</h4>
		    	<p>#encodeForHTML(local.order.getOrderNotes())#</p>
		    </div>
		    <div style="clear:both; height:30px;">&nbsp;</div>
	    </cfif>
	    
	    <cfif len( trim( print.getPrintContent() ) )>
		    <div class="footer">
		    	#print.getPrintContent()#
		    </div>
		</cfif>
		
	</div><!--- end of .container --->
</cfoutput>
