<cfparam name="print" type="any" />
<cfparam name="printData" type="struct" default="#structNew()#" />
<cfparam name="fulfillmentBatch" type="any" />

<cfoutput>
	<style>
		@media print {
			.invoice-page-break{
				page-break-after: always;
			}
		}
	</style>
	<cfloop array="#fulfillmentBatch.getFulfillmentBatchItems()#" index="batchItem">
		<cfset local.batchPageCount = 1 />
		<cfif not isNull(batchItem.getOrderFulfillment())>
			<cfset order = batchItem.getOrderFulfillment().getOrder() />
			<div id="container#order.getOrderId()#-#local.batchPageCount#" class="invoice invoice-page-break" style="font-family: arial; font-size: 12px;background:##fff;">

				<cfinclude template="inc/invoiceheader.cfm" />

				<br style="clear:both;" />

				<div id="orderItems#order.getOrderId()#-#local.batchPageCount#" style="margin-top: 15px; clear: both;">
					<table class="invoice-list" cellspacing="5">
						<thead>
							<tr>
								<th>Quantity</th>
								<th>Size</th>
								<th>Description</th>
								<th>SKU</th>
								<th>Price</th>
								<th>Total Price</th>
							</tr>
						</thead>
						<cfset local.totalQuantity=0>
						<cfset local.orderItemCollectionList = order.getOrderItemsCollectionList()>
						<cfset local.orderItemCollectionList.setDisplayProperties('sku.skuCode,sku.calculatedSkuDefinition,quantity,sku.product.calculatedTitle,calculatedDiscountAmount,calculatedExtendedPrice,calculatedExtendedPriceAfterDiscount,price,sku.product.productType.productTypeName,orderItemType.systemCode,sku.product.productName')>
						<cfloop array="#local.orderItemCollectionList.getRecords()#" index="local.orderItem">
							<cfset local.totalQuantity+=local.orderItem['quantity']>
							<tr>
								<td>#NumberFormat(local.orderItem['quantity'])#</td>
								<td>
									<cfif local.orderItem['sku_calculatedSkuDefinition'] contains "Size: ">
										#replace(local.orderItem['sku_calculatedSkuDefinition'],"Size: ","")#
									</cfif>
								</td>
								<td>
				                		#local.orderItem['sku_product_productName']#
			                	</td>
							
								<td>#local.orderItem['sku_skuCode']#</td>
								<td style="text-align:right;">#LSCurrencyFormat(local.orderItem['price'], "local")#</td>
								<td style="text-align:right;">
									<cfif local.orderItem['calculatedDiscountAmount'] GT 0>
										<span style="text-decoration:line-through; color:##cc0000;">#LSCurrencyFormat(orderItem['calculatedExtendedPrice'], "local")#</span><br />
										#LSCurrencyFormat(local.orderItem['calculatedExtendedPriceAfterDiscount'], "local")#
									<cfelse>
										#LSCurrencyFormat(local.orderItem['calculatedExtendedPrice'], "local")#
									</cfif>
								</td>
							</tr>
						</cfloop>
						<cfset local.returnItemCollectionList = getHibachiScope().getService('OrderService').getOrderItemCollectionList()>
						<cfset local.returnItemCollectionList.addFilter('order.orderID', order.getOrderID()) />
						<cfset local.returnItemCollectionList.setDisplayProperties('sku.skuCode,sku.calculatedSkuDefinition,quantity,sku.product.calculatedTitle,calculatedDiscountAmount,calculatedExtendedPrice,calculatedExtendedPriceAfterDiscount,price, sku.product.productType.productTypeName,sku.product.productName')>
						<cfset local.returnItemCollectionList.addFilter('orderItemType.systemCode', 'oitReturn') />
						
						<cfloop array="#local.returnItemCollectionList.getRecords()#" index="local.orderItem">
							<cfset local.totalQuantity = local.totalQuantity - local.orderItem['quantity']>
							<tr style="color:red">
				                <td style="text-align:right; padding-right:20px;">(#NumberFormat(local.orderItem['quantity'])#)</td>
								<td>
									<cfif local.orderItem['sku_calculatedSkuDefinition'] contains "Size: ">
										#replace(local.orderItem['sku_calculatedSkuDefinition'],"Size: ","")#
									</cfif>
								</td>
								<td>
					                
				                		#local.orderItem['sku_product_productName']#
				              
			                	</td>
				                
								<td>#local.orderItem['sku_skuCode']#</td>
				                <td style="text-align:right;">(#LSCurrencyFormat(local.orderItem['price'], "local")#)</td>
								
								<td style="text-align:right;">
									<cfif local.orderItem['calculatedDiscountAmount'] GT 0 AND IsNumeric(local.orderItem['calculatedExtendedPrice']) AND isNumeric(local.orderItem['calculatedExtendedPriceAfterDiscount'])>
										<span style="text-decoration:line-through; color:##cc0000;">(#LSCurrencyFormat(orderItem['calculatedExtendedPrice'], "local")#)</span><br />
										(#LSCurrencyFormat(local.orderItem['calculatedExtendedPriceAfterDiscount'], "local")#)
									<cfelseif IsNumeric(#local.orderItem['calculatedExtendedPrice']#)>
										(#LSCurrencyFormat(local.orderItem['calculatedExtendedPrice'], "local")#)
									</cfif>
								</td>
							</tr>
						</cfloop>
						
						<tr>
							<td style="border:none; font-weight:bold;">#totalQuantity#</td>
						</tr>
					</table>
					</div>

					<br style="clear:both;" />
					
					<table class="invoice-total" cellspacing="5">
				        <tbody>
				            <tr>
				                <td><strong>Subtotal:</strong></td>
				                <td style="text-align:right;">#order.getFormattedValue('subtotal', 'currency')#</td>
				            </tr>
				            <tr>
				                <td><strong>Shipping & Handling:</strong></td>
				                <td style="text-align:right;">#order.getFormattedValue('fulfillmentTotal', 'currency')#</td>
				            </tr>
				            <tr>
				                <td><strong>Tax:</strong></td>
				                <td style="text-align:right;">#order.getFormattedValue('taxTotal', 'currency')#</td>
				            </tr>
							<cfif order.getDiscountTotal()>
								<tr>
									<td><strong>Discounts</strong></td>
									<td style="text-align:right; color:##cc0000">-#order.getFormattedValue('discountTotal', 'currency')#</td>
								</tr>
							</cfif>
				            <tr>
				                <td><strong>Total:</strong></td>
				                <td style="text-align:right;">#order.getFormattedValue('total', 'currency')#</td>
				            </tr>
				            <tr>
				                <td><strong>Balance Due:</strong></td>
				                <td style="text-align:right;">#LSCurrencyFormat(order.getPaymentAmountDue('total', 'currency'), "local")#</td>
				            </tr>
							<tr>
				                <td colspan="2" style="text-align:center; border-bottom:1px solid black;">PAYMENTS RECEIVED</td>
				            </tr>
							<cfloop array="#order.getOrderPayments()#" index="orderPayment">
								<cfif orderPayment.getAmountReceived() NEQ 0 >
									<cfif orderPayment.getOrderPaymentStatusType().getSystemCode() EQ "opstActive">
										<tr>
											<td><strong>#orderPayment.getPaymentMethod().getPaymentMethodName()#</strong></td>
											<td style="text-align:right;">#orderPayment.getFormattedValue('amountReceived', 'currency')#</td>
										</tr>
										<tr>
											<td>#orderPayment.getCreditCardType()# #orderPayment.getCreditCardLastFour()#</td>
											<td style="text-align:right;">#dateFormat(orderPayment.getCreatedDateTime(),'mm/dd/yyyy')#</td>
										</tr>
									</cfif>
								</cfif>
							</cfloop>
				        </tbody>
				    </table>
				</div>
			    <div class="footer">

			    </div>
			</div>
		</cfif>
		
	</cfloop>
</cfoutput>