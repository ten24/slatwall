<cfoutput>
				</tbody>
			</table>
		</div>
	</div>
	<div id="container#order.getOrderId()#-#++local.batchPageCount#" class="invoice" style="width: 625px; font-family: arial; font-size: 12px;background:##fff;">
		<cfinclude template="inc/invoiceheader.cfm" />
		
		<div id="orderItems#order.getOrderId()#-#local.batchPageCount#" style="margin-top: 15px; float: left; clear: both; width: 600px;">
		
		<table id="styles#order.getOrderId()#-#local.batchPageCount#" style="border-spacing: 0px; border-collapse: collapse; border: 1px solid ##d8d8d8; text-align: left; font-size: 12px; width:600px;">
			<thead>
				<tr>
					<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Sku Code</th>
					<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Product</th>
					<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Options</th>
					<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Price</th>
					<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Qty</th>
					<th style="background: ##f9f9f9; border: 1px solid ##d8d8d8; padding: 0px 5px;">Total</th>
				</tr>
			</thead>
			<tbody>
</cfoutput> 