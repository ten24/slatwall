<cfparam name="print" type="any" />
<cfparam name="printData" type="struct" default="#structNew()#" />
<cfparam name="orderDelivery" type="any" />

<cfoutput>
	<cfset var order=orderDelivery.getOrder()>
	<cfset local.batchPageCount = 1 />

	<div id="container#order.getOrderId()#" class="invoice" style="font-family: arial; font-size: 12px;background:##fff;">

		<cfinclude template="../fulfillmentbatch/inc/invoicedeliveryheader.cfm" />

		<br style="clear:both;" />
		
		<cfset local.orderPaymentCollectionList = getService('orderService').getOrderPaymentCollectionList() />
		<cfset local.orderPaymentCollectionList.addFilter('order.orderID',order.getOrderID()) />
		<cfset local.orderPaymentCollectionList.addFilter('purchaseOrderNumber','null','IS NOT') />
		<cfset local.orderPaymentCollectionList.addFilter('orderPaymentStatusType.systemCode','opstActive','=') />
		<cfset local.orderPaymentCollectionList.setDisplayProperties('purchaseOrderNumber,paymentTerm.paymentTermName,paymentTerm.term.termID,paymentDueDate') />
		<cfset local.orderPayments = local.orderPaymentCollectionList.getRecords() />
		
		<cfset local.orderPayment = structNew() />
		<cfloop array="#local.orderPayments#" index="local.currentOrderPayment">
			<cfif len(local.currentOrderPayment['purchaseOrderNumber']) >
				<cfset local.orderPayment = local.currentOrderPayment />
			</cfif>
		</cfloop>
		
		<table class="invoice-list" cellspacing="5">
			<thead>
				<tr>
					<cfif structKeyExists(local.orderPayment, 'purchaseOrderNumber') AND len(trim(local.orderPayment['purchaseOrderNumber'])) >
						<th>DUE DATE</th>
						<th>CUSTOMER PO NO.</th>
					</cfif>
					<cfif not isNull(local.orderFulfillment) >
						<th>SHIP VIA</th>
					</cfif>
					<cfif !order.getQuoteFlag()>
						<th>ORDER DATE</th>
						<th>TERMS</th>
					</cfif>
				</tr>
			</thead>
			<tbody>
				<cfif structKeyExists(local.orderPayment, 'purchaseOrderNumber') AND len(trim(local.orderPayment['purchaseOrderNumber'])) >
					<td><cfif structKeyExists(local.orderPayment,'dueDate')>#dateformat( local.orderPayment['paymentDueDate'],'mm/dd/yyyy' )#</cfif></td>
					<td>#local.orderPayment['purchaseOrderNumber']#</td>
				</cfif>
				<cfif not isNull(local.orderFulfillment)>
					<td>
						<cfif not isNull(local.orderFulfillment.getShippingIntegration()) >
							<strong>#local.orderFulfillment.getShippingIntegration().getIntegrationName()#</strong><br>
						</cfif>
						<cfif not isNull(local.orderFulfillment.getShippingMethod()) >
							#local.orderFulfillment.getShippingMethod().getShippingMethodName()#
						</cfif>
					</td>
				</cfif>
				<cfif !order.getQuoteFlag()>
					<td>#dateFormat( order.getOrderOpenDateTime(),'mm/dd/yyyy' )#</td>
					<td>
						<cfif structKeyExists(local.orderPayment, 'paymentTerm_paymentTermName') AND len(trim(local.orderPayment['paymentTerm_paymentTermName'])) >
							#local.orderPayment['paymentTerm_paymentTermName']#
						<cfelse>
							Pre-Paid
						</cfif>
					</td>
				</cfif>
			</tbody>
		</table>
		
		<cfset local.totalDeliveredSubtotal=0>

		<div style="float:right; width:45%;margin-right:0;padding-right:0;">
			<table cellspacing="5" style="width:100%;">
		        <tbody>
		        	
		        	<tr>
		                <td><strong>Subtotal of Items Shipped:</strong></td>
		                <td style="text-align:right;">
		                	#LSCurrencyFormat(local.totalDeliveredSubtotal)#
		                </td>
		            </tr>
		        
		        </tbody>
		    </table>
	    </div>
		
		<cfif not isNull(order.getOrderNotes())>
			<div style="margin:70px auto 40px auto;padding:0 10px;clear:both;max-width:700px;">
	    		<h4 style="border-bottom:2px solid black;">Comments</h4>
	    		<p>#encodeForHTML(order.getOrderNotes())#</p>
	    	</div>
		</cfif>
		
		<cfif len( trim( print.getPrintContent() ) )>
		    <div class="footer">
		    	#print.getPrintContent()#
		    </div>
		</cfif>
	</div>
</cfoutput>
