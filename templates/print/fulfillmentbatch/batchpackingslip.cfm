<cfparam name="print" type="any" />
<cfparam name="printData" type="struct" default="#structNew()#" />
<cfparam name="fulfillmentbatch" type="any" />
<cfset orderDeliveries = []>
<cfset containers = [] />

<cfset orderContainer = {} />

<cfloop array="#fulfillmentbatch.getFulfillmentBatchItems()#" index="batchItem">
	<cfif !isNull(batchItem.getOrderFulfillment()) AND batchItem.getOrderFulfillment().getOrder().hasOrderDelivery() >
		
		<cfloop array="#batchItem.getOrderFulfillment().getOrder().getOrderDeliveries()#" index="orderDelivery">
			
			<cfif orderDelivery.hasContainer() >
				
				<cfif isNull(orderContainer['#orderDelivery.getOrder().getOrderID()#'])>
					<cfset orderContainer['#orderDelivery.getOrder().getOrderID()#'].containerCount = 0 />
				</cfif>
				
				<cfset orderContainer['#orderDelivery.getOrder().getOrderID()#'].containerCount += arrayLen(orderDelivery.getContainers()) />
				<cfset orderContainer['#orderDelivery.getOrder().getOrderID()#'].printedContainers = 0 />
				
				<cfloop array="#orderDelivery.getContainers()#" index="container">
					<cfset arrayAppend(containers, container)>
				</cfloop>
			<cfelse>
				<cfset arrayAppend(orderDeliveries, orderDelivery)>
			</cfif>
		</cfloop>
	</cfif>
</cfloop>

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
	@media print {
		.invoice{
			page-break-after: always;
		}
	}
	</style>

	<!-- POD Template -->
	<div class="invoice-temp">
		<cfset local.batchPageCount = 1 />
		
		
		<!--- Code for container logic --->
		<cfloop array="#containers#" index="container">
			<cfset order = container.getOrderDelivery().getOrder() />
			
			<div id="container#container.getContainerId()#-#local.batchPageCount#" class="invoice" style="font-family: arial; font-size: 12px;background:##fff;">
				<cfset orderContainer['#order.getOrderID()#'].printedContainers  += 1 />
				<cfset printedContainer = orderContainer['#order.getOrderID()#'].printedContainers />
				<cfset containerCount = orderContainer['#order.getOrderID()#'].containerCount />
				
				<cfinclude template="inc/packingslipheader.cfm" />
	
				<table id="styles#container.getContainerId()#-#local.batchPageCount#" class="invoice-list" cellspacing="5">
					<thead>
						<tr>
							<th>Quantity</th>
							<th>Size</th>
							<th>Description</th>
							<th>SKU</th>
						</tr>
					</thead>
					<tbody>
						<cfset local.totalQuantity=0>
						
						<cfset local.containerItemCollectionList = container.getContainerItemsCollectionList()>
						<cfset local.containerItemCollectionList.setDisplayProperties('sku.skuCode,sku.calculatedSkuDefinition,quantity,sku.product.calculatedTitle,sku.product.productName,sku.bundleFlag')>
						<!--- Use Region instead of Appelation once that field is available at the product level --->
	
						<cfset local.count = 1 />
						
						<cfloop array="#local.containerItemCollectionList.getRecords()#" index="local.containerItem">
							<cfset local.totalQuantity+=local.containerItem['quantity']>
	
							<cfif local.count++ mod 10 eq 0>
								<cfinclude template="inc/packingslipclosetable.cfm" />
								<cfset local.batchPageCount++ />
							</cfif>
	
							<tr>
								<td style="text-align:right; padding-right:30px;">#NumberFormat(local.containerItem['quantity'])#</td>
								<td>
									<cfif local.containerItem['sku_calculatedSkuDefinition'] contains "Size: ">
										#replace(local.containerItem['sku_calculatedSkuDefinition'],"Size: ","")#
									</cfif>
								</td>
								<td>
									
				                		#local.containerItem['sku_product_productName']#
			                	</td>
								<td>#local.containerItem['sku_skuCode']#</td>
							</tr>
						</cfloop>
						
						<tr>
							<td style="border:none; font-weight:bold; text-align:right; padding-right:30px;">#totalQuantity#</td>
						</tr>
					</tbody>
				</table>
				
				<cfif not isNull(order.getorderNotes())>
				    <div style="clear:both;">
				    	<h4 style="border-bottom:2px solid black;">Customer Comments</h4>
				    	<p>#getHibachiScope().getService('HibachiUtilityService').hibachiHTMLEditFormat(order.getorderNotes())#</p>
				    </div>
			    </cfif>
			    
			    <table>
					<tr>
						<td style="width:70px; height:70px; border: 1px solid black; border-bottom:2px solid black; border-right:2px solid black; text-align: center;"></td>
						<td style="padding-left:10px;">Total Number of Pieces</td>
					</tr>
				</table>
			</div>
		</cfloop>
	
		<cfset printedContainer = 1 />
		<cfset containerCount = 1 />
				
		<!--- Legacy code to handle order deliveries before container logic --->
		<cfloop array="#orderDeliveries#" index="orderDelivery">
			<cfset order = orderDelivery.getOrder() />
			
			<div id="container#order.getOrderId()#-#local.batchPageCount#" class="invoice" style="font-family: arial; font-size: 12px;background:##fff;">
				<cfinclude template="inc/packingslipheader.cfm" />
	
				<table id="styles#order.getOrderId()#-#local.batchPageCount#" class="invoice-list" cellspacing="5">
					<thead>
						<tr>
							<th>Quantity</th>
							<th>Size</th>
							<th>Description</th>
							<th>SKU</th>
						</tr>
					</thead>
					<tbody>
						<cfset local.totalQuantity=0>
						<cfset local.orderDeliveryItemCollectionList = orderDelivery.getOrderDeliveryItemsCollectionList()>
						<cfset local.orderDeliveryItemCollectionList.setDisplayProperties('orderItem.sku.skuCode,orderItem.sku.skuId,orderItem.sku.calculatedSkuDefinition,quantity,orderItem.sku.product.calculatedTitle,orderItem.sku.product.productName,orderItem.sku.bundleFlag')>

					<cfset local.count = 1 />

						<cfloop array="#local.orderDeliveryItemCollectionList.getRecords()#" index="local.orderDeliveryItem">
							<cfif not local.orderDeliveryItem['orderItem_sku_bundleFlag']>
								<cfset local.totalQuantity+=local.orderDeliveryItem['quantity']>
						
							<cfif local.count++ mod 10 eq 0>
									<cfinclude template="inc/packingslipclosetable.cfm" />
									<cfset local.batchPageCount++ />
								</cfif>
	
								<tr>
									<td style="text-align:right; padding-right:30px;">#NumberFormat(local.orderDeliveryItem['quantity'])#</td>
									<td>
										<cfif local.orderDeliveryItem['orderItem_sku_calculatedSkuDefinition'] contains "Size: ">
											#replace(local.orderDeliveryItem['orderItem_sku_calculatedSkuDefinition'],"Size: ","")#
										</cfif>
									</td>
									<td>
					                		#local.orderDeliveryItem['orderItem_sku_product_productName']#
				                
				                	</td>
									<td>#local.orderDeliveryItem['orderItem_sku_skuCode']#</td>
								</tr>
							<cfelse>
							
								<cfset local.sku = getHibachiScope().getService('SkuService').getSku(local.orderDeliveryItem['orderItem_sku_skuId']) />
								
								<cfif local.count++ mod 10 eq 0>
									<cfinclude template="inc/packingslipclosetable.cfm" />
									<cfset local.batchPageCount++ />
								</cfif>
								
								<cfloop index="local.bundledSku" array="#local.sku.getBundledSkus()#">
									<cfset local.totalQuantity+= local.bundledSku.getBundledQuantity() * local.orderDeliveryItem['quantity']>
									
									<tr>
										<td style="text-align:right; padding-right:30px;">#NumberFormat(local.bundledSku.getBundledQuantity() * local.orderDeliveryItem['quantity'])#</td>
										<td>
											<cfif local.bundledSku.getBundledSku().getCalculatedSkuDefinition() contains "Size: ">
												#replace(local.bundledSku.getBundledSku().getCalculatedSkuDefinition(),"Size: ","")#
											</cfif>
										</td>
										<td>
										
						                		#local.bundledSku.getBundledSku().getProduct().getProductName()#
					                	
					                	</td>
										<td>#local.bundledSku.getBundledSku().getSkuCode()#</td>
									</tr>
								</cfloop>
							</cfif>
						</cfloop>
						<tr>
							<td style="border:none; font-weight:bold; text-align:right; padding-right:30px;">#totalQuantity#</td>
						</tr>
					</tbody>
				</table>
				<cfif not isNull(order.getorderNotes())>
				    <div style="clear:both;">
				    	<h4 style="border-bottom:2px solid black;">Customer Comments</h4>
				    	<p>#getHibachiScope().getService('HibachiUtilityService').hibachiHTMLEditFormat(order.getorderNotes())#</p>
				    </div>
			    </cfif>
			    <table>
					<tr>
						<td style="width:70px; height:70px; border: 1px solid black; border-bottom:2px solid black; border-right:2px solid black; text-align: center;"></td>
						<td style="padding-left:10px;">Total Number of Pieces</td>
					</tr>
				</table>
			</div>
		</cfloop>
	</div>
</cfoutput>