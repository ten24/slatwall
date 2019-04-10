<cfparam name="print" type="any" />	
<cfparam name="printData" type="struct" default="#structNew()#" />
<cfparam name="stockAdjustment" type="any" />

<cfoutput>
	<script src="#request.slatwallScope.getBaseURL()#/custom/js/JsBarcode.all.min.js"></script>
	
	<div style="margin-bottom: 5%">
		<div style="float:left; width:35%" >
			<cfif stockAdjustment.getStockAdjustmentTypeSystemCode() EQ 'satLocationTransfer'>
				<h3>Location Transfer</h3>
			<cfelseif stockAdjustment.getStockAdjustmentTypeSystemCode() EQ 'satManualIn'>
				<h3>Manual In</h3>
			<cfelse>
				<h3>Manual Out</h3>
			</cfif>
		</div>
		
		<div> 
			<h3>Transfer Number## #stockAdjustment.getReferenceNumber()#</h3>
		</div> 
	</div>

	<div> 
		<table width="100%">
			<thead>
				<tr>
					<th class="head-default" align="left" width="20%">Date #dateFormat(stockAdjustment.getCreatedDateTime(), 'mm/dd/yyyy')#</th>
					<th class="head-default" align="left" width="15%">Location</th>
					<th class="head-default" align="right" width="10%">Qty</th>
					<th class="head-default" align="right" width="15%">Cost</th>
					<th class="head-default" align="right" width="10%">Total</th>
					<th class="head-default" align="right" width="15%">Stock Location</th>
				</tr>
			</thead>
			<tbody>
				<cfset totalQty = 0 />
				<cfset totalCost = 0 />
				<cfset totalPrice = 0 />
				<cfset var stockAdjustmentItemSmartList = stockAdjustment.getStockAdjustmentItemsSmartList() />
				<cfset stockAdjustmentItemSmartList.addOrder('sku.product.productName') /> 
				
				<cfloop array="#stockAdjustmentItemSmartList.getRecords()#" index="stockAdjustmentItem">
					<cfset product = '#stockAdjustmentItem.getSku().getProduct()#' />
					<cfset itemCostTotal = stockAdjustmentItem.getQuantity() * stockAdjustmentItem.getCost() />
					<cfset itemPriceTotal = stockAdjustmentItem.getQuantity() * stockAdjustmentItem.getSku().getLivePriceByCurrencyCode(stockAdjustmentItem.getCurrencyCode())/> 
					
					<!--- Total Calculations --->
					<cfset totalQty += stockAdjustmentItem.getQuantity() />
					<cfset totalCost += itemCostTotal />
					<cfset totalPrice += itemPriceTotal />
					
					<!--- Product Data Line --->
					<tr class="top_padding">
						<td></td>
						<td align="left">#stockAdjustmentItem.getSku().getSkuCode()#</td>
						<td colspan="5" align="left">#product.getProductName()#</td>
					</tr>
					<!--- To Location Line --->
					<cfif not isNull(stockAdjustment.getToLocation())>
						<tr <cfif stockAdjustment.getStockAdjustmentTypeSystemCode() EQ 'satManualIn' > class="border_bottom"</cfif>>
							<td></td>
							<td>#stockAdjustment.getToLocation().getLocationCode()#</td>
							<td align="right">#stockAdjustmentItem.getQuantity()#</td>
							<td align="right">#dollarFormat(stockAdjustmentItem.getCost())#</td>
							<td align="right">#dollarFormat(itemCostTotal)#</td>
							<td align="right">
								<cfif not isNull(stockAdjustmentItem.getToStock()) AND not isNull(stockAdjustmentItem.getToStock().getlocation()) >
									#stockAdjustmentItem.getToStock().getStockingLocation()#
								</cfif>
							</td>
						</tr>
					</cfif>
					<!--- From Location Line --->
					<cfif not isNull(stockAdjustment.getFromLocation()) >
						<tr class="border_bottom">
							<td></td>
							<td>#stockAdjustment.getFromLocation().getLocationCode()#</td>
							<td align="right">(#stockAdjustmentItem.getQuantity()#)</td>
							<td align="right">#dollarFormat( stockAdjustmentItem.getCost() * -1 )#</td>
							<td align="right">(#dollarFormat(itemCostTotal)#)</td>
							<td>
								<cfif not isNull(stockAdjustmentItem.getFromStock()) AND not isNull(stockAdjustmentItem.getFromStock().getLocation()) >
									#stockAdjustmentItem.getFromStock().getStockingLocation()#
								</cfif>								
							</td>
						</tr>
					</cfif>
				</cfloop>
				
				<cfif stockAdjustment.getStockAdjustmentTypeSystemCode() EQ 'satLocationTransfer'>
					<cfset totalQtyIn = totalQty />
					<cfset totalCostIn = totalCost />
					<cfset totalPriceIn = totalPrice />
					
					<cfset totalQtyOut = totalQty />
					<cfset totalCostOut = totalCost />
					<cfset totalPriceOut = totalPrice />
					
				<cfelseif stockAdjustment.getStockAdjustmentTypeSystemCode() EQ 'satManualIn'>
					<cfset totalQtyIn = totalQty />
					<cfset totalCostIn = totalCost />
					<cfset totalPriceIn = totalPrice />
					
					<cfset totalQtyOut = 0 />
					<cfset totalCostOut = 0 />
					<cfset totalPriceOut = 0 />
					
				<cfelse>
					<cfset totalQtyIn = 0 />
					<cfset totalCostIn = 0 />
					<cfset totalPriceIn = 0 />
					
					<cfset totalQtyOut = totalQty />
					<cfset totalCostOut = totalCost />
					<cfset totalPriceOut = totalPrice />
				</cfif>
				
				<!--- Ending Totals --->
				<tr class="total_top_padding" >
					<td></td>
					<td align="right"><strong>Total Quanty</strong></td>
					<td></td>
					<td align="right"><strong>Total Cost</strong></td>
					<td></td>
					<td align="right"><strong>Total Price</strong></td>
					<td></td>
				</tr>
				<tr>
					<td></td>
					<td align="right">IN</td>
					<td align="right">#totalQtyIn#</td>
					<td align="right">IN</td>
					<td align="right">#dollarFormat(totalCostIn)#</td>
					<td align="right">IN</td>
					<td align="right">#dollarFormat(totalPriceIn)#</td>
				</tr>
				<tr>
					<td></td>
					<td align="right">OUT</td>
					<td align="right">(#totalQtyOut#)</td>
					<td align="right">OUT</td>
					<td align="right">(#dollarFormat(totalCostOut)#)</td>
					<td align="right">OUT</td>
					<td align="right">(#dollarFormat(totalPriceOut)#)</td>
				</tr>
			</tbody>
		</table>
	</div> 
	
	<cfif arrayLen(stockAdjustment.getComments()) >
		<div id="commentSection">
			<table>
				<thead>
					<tr>
						<th class="head-default" align="left" width="60%">Comment(s)</th>
						<th class="head-default" align="left" width="25%">Created By</th>
						<th class="head-default" align="left" width="15%">Created Date</th>
					</tr>
				</thead>
				<tbody>
					<cfloop array="#stockAdjustment.getComments()#" index="commentRelationship">
						<tr>
							<td>#commentRelationship['comment'].getCommentWithLinks()#</td>
							<td><cfif !isNull(commentRelationship['comment'].getCreatedByAccount())>#commentRelationship['comment'].getCreatedByAccount().getFullName()#</cfif></td>
							<td>#dateFormat(commentRelationship['comment'].getCreatedDateTime(), 'mm/dd/yyyy')#</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
		</div>
	</cfif>
	<script type="text/javascript">
		JsBarcode(".barcode").init();
	</script> 
</cfoutput> 

<style>
	tr.border_bottom td {
	  border-bottom:1pt dashed black;
	  padding-bottom:5pt;
	}
	
	tr.top_padding td {
		padding-top:10pt;
	}
	
	tr.total_top_padding td {
		padding-top:20pt;
	}
	
	.head-default {
	    border-bottom: 1px solid black;
	}
	
	table {
		border-spacing: 0;
    	border-collapse: collapse;
    	font-size:10pt;
	}
	
	td { 
	    padding: 10pt;
	}
	
	#commentSection{
		padding-top:35pt;
	}
	
</style>