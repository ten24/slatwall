<cfoutput>

				</tbody>
			</table>
		</div>
		<div id="container#order.getOrderId()#-#++local.batchPageCount#" class="invoice" style="width: 625px; font-family: arial; font-size: 12px;background:##fff;">
			<cfinclude template="packingslipheader.cfm" />
				
			<table id="styles#order.getOrderId()#-#local.batchPageCount#" class="invoice-list" cellspacing="5">
				<thead>
					<tr>
						<th>Style</th>
						<th>Quantity</th>
						<th>Size</th>
						<th>Description</th>
					</tr>
				</thead>
				<tbody> 
</cfoutput> 