<cfparam name="print" type="any" />
<cfparam name="printData" type="struct" default="#structNew()#" />
<cfparam name="fulfillmentBatch" type="any" />

<cfoutput>
	<style>
	.invoice-temp {font-size: 13px; color: ##000; font-family: Arial, sans-serif; max-width: 700px; margin: 0 auto;}
	.invoice-temp p {margin: 0;}
	.invoice-intro {text-align: center; margin: 20px 5px 20px;}
	.invoice-intro p {text-align: left;}
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
	</style>

	<!-- POD Template -->
	<div class="invoice-temp">
	    <div class="invoice-intro">
			<div style="width: 100%; text-align:center;">
				<!---img src="" border="0"  width="300px"--->
			</div>
			<br />
			<h1>PICK LIST</h1>
			<cfif !isNull(fulfillmentBatch.getAssignedAccount())>
	        	<p>Picker Name: #fulfillmentBatch.getAssignedAccount().getFullName()#</p>
			</cfif>
			<p>Print Date: #DateFormat(Now(), "mm/dd/yyyy")#</p>
			<cfif not isNull(fulfillmentBatch.getFulfillmentBatchName())>
				<p>Batch Name: #fulfillmentBatch.getFulfillmentBatchName()#</p>
			</cfif>
			<cfif not isNull(fulfillmentBatch.getFulfillmentBatchNumber())>
				<p>Batch Number: #fulfillmentBatch.getFulfillmentBatchNumber()#</p>
			</cfif>
	    </div>

		<div style="clear:both;">&nbsp;</div>

		<table class="invoice-list" cellspacing="5">
			<thead>
				<tr>
					<th>Size</th>
					<th>Description</th>d
					<th>SKU</th>
					<th>Stock Location</th>
					<th>Stocking Location</th>
					<th>Quantity</th>
				</tr>
			</thead>
			<cfset local.OrderItemCollectionList = getHibachiScope().getService('fulfillmentService').getOrderItemCollectionList()>
			<cfset local.OrderItemCollectionList.addFilter('orderFulfillment.fulfillmentBatchItems.fulfillmentBatch.fulfillmentBatchID', fulfillmentBatch.getFulfillmentBatchID())>
			<cfset local.OrderItemCollectionList.addFilter('fulfillmentBatchItems.fulfillmentBatch.fulfillmentBatchID', fulfillmentBatch.getFulfillmentBatchID(),'=','OR')>
			<cfset local.OrderItemCollectionList.setDisplayProperties(
				'orderItemID,
				quantity,
				stock.location,
				stock.location.locationName,
				stock.location.locationID,
				sku.skuCode,
				sku.calculatedSkuDefinition,
				sku.product.calculatedTitle,
				sku.product.productName,
				sku.product.productType.productTypeName,
				sku.bundleFlag,
				sku.skuID'
			)>
			<cfset local.records = local.OrderItemCollectionList.getRecords() />
			
			<cfscript>
				
				var local.skuCodeHashMap = {};
				var local.totalQuantity = 0;
				for(var local.orderItem in local.records){
					var local.skuCode = local.orderItem['sku_skuCode'];
					if(structKeyExists(local.skuCodeHashMap,local.skuCode)){
						local.skuCodeHashMap[local.skuCode]['quantity'] = local.skuCodeHashMap[local.skuCode]['quantity'] + local.orderItem['quantity'];
					} else {
						local.skuCodeHashMap[local.skuCode] = local.orderItem;
					}
				}
				
			</cfscript>

			<cfloop collection="#local.skuCodeHashMap#" item="key">

				<cfset var local.orderItem = local.skuCodeHashMap[key] />	

				<!--- Logic to setup the data for the bundle sku --->
				<cfif local.orderItem['sku_bundleFlag']>
					<cfset sku = getHibachiScope().getService('SkuService').getSku(local.orderItem['sku_skuID']) />
					
					<cfloop index="bundledSku" array="#sku.getBundledSkus()#">
						
						<cfset local.totalOrderItemQuantity = bundledSku.getBundledQuantity() * local.orderItem['quantity']>
													
						<tr>
							<td>
									
								<cfif bundledSku.getBundledSku().getCalculatedSkuDefinition() contains "Size: ">
									#replace( bundledSku.getBundledSku().getCalculatedSkuDefinition() ,"Size: ","")#
								</cfif>
							</td>
							<td>
								<!--- <cfif not isNull(bundledSku.getBundledSku().getSkuName()) AND False>
									#bundledSku.getBundledSku().getSkuName()# --->
							
			                		#bundledSku.getBundledSku().getProduct().getProductName()#
			            
			                </td>
							
							<td>#bundledSku.getBundledSku().getSkuCode()#</td>
							
							<cfif len( trim ( local.orderItem['stock_location_locationName'] ) )>
								<td>#local.orderItem['stock_location_locationName']#</td>
							<cfelse>
								<td>#fulfillmentBatch.getLocations()[1].getLocationName()#</td>
							</cfif>
						
							<cfif len(trim(local.orderItem['stock_location_locationID']))>
								<cfset local.bundledStock = getHibachiScope().getService('Stockservice').getStockBySkuIDAndLocationID(skuID=bundledSku.getBundledSku().getSkuID(), locationID=local.orderItem['stock_location_locationID'] )/>
							<cfelse>
								<cfset local.bundledStock = getHibachiScope().getService('Stockservice').getStockBySkuIDAndLocationID(skuID=bundledSku.getBundledSku().getSkuID(), locationID=fulfillmentBatch.getLocations()[1].getLocationID() )/>
							</cfif>
							
							
							<cfif isNull(local.bundledStock)>
								<td>#local.orderItem['stock_location']#</td>
							<cfelseif not isNull( local.bundledStock.getlocation() )>
								<td>#local.bundledStock.getLocation().getLocationName()#</td>
							<cfelse >
								<td></td>
							</cfif>
							
							<td style="text-align:right; padding-right:20px;">#NumberFormat(local.totalOrderItemQuantity)#</td>
						</tr>
						<cfset local.totalQuantity = local.totalQuantity + local.totalOrderItemQuantity />
					</cfloop>
				<cfelse>
					<cfset local.totalOrderItemQuantity = local.orderItem['quantity']>

					<cfset local.totalQuantity = local.totalQuantity + local.totalOrderItemQuantity />
					<tr>
						<td>
							<cfif local.orderItem['sku_calculatedSkuDefinition'] contains "Size: ">
								#replace(local.orderItem['sku_calculatedSkuDefinition'],"Size: ","")#
							</cfif>
						</td>
						<td>
		                		#local.orderItem['sku_product_productName']#
		                </td>
						
						<td>#local.orderItem['sku_skuCode']#</td>
						
						<cfif len(trim( local.orderItem['stock_location_locationName'])) >
							<td>#local.orderItem['stock_location_locationName']#</td>
						<cfelse>
							<td>#fulfillmentBatch.getLocations()[1].getLocationName()#</td>
						</cfif>
						
						
						<td style="text-align:right; padding-right:20px;">#NumberFormat(local.totalOrderItemQuantity)#</td>
					</tr>

				</cfif>
				

			</cfloop>

			<tr>
				<td style="border:none; font-weight:bold;">&nbsp;</td>
				<td style="border:none; font-weight:bold;">&nbsp;</td>
				<td style="border:none; font-weight:bold;">&nbsp;</td>
				<td style="border:none; font-weight:bold;">&nbsp;</td>
				<td style="border:none; font-weight:bold;">&nbsp;</td>
				<td style="border:none; font-weight:bold;">&nbsp;</td>
				<td style="border:none; font-weight:bold; text-align:right; padding-right:20px;">#local.totalQuantity#</td>
			</tr>
		</table>
	</div>
</cfoutput>