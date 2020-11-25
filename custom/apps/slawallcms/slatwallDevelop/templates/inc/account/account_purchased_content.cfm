<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="../../../tags" />
<cfoutput>
	<div class="tab-pane" id="purchased-content">
		<h5>Purchased Content Access</h5>
		
		<table class="table">
			<tr>
				<th>Content Title</th>
				<th>Order Number</th>
				<th>Date Purchased</th>
			</tr>
			
			<cfloop array="#$.slatwall.getAccount().getAccountContentAccessesSmartList().getRecords()#" index="accountContentAccess">
				<cfloop array="#accountContentAccess.getContents()#" index="content">
					<tr>
						<td>#content.getTitle()#</td>
						<td>#accountContentAccess.getOrderItem().getOrder().getOrderNumber()#</td>
						<td>#accountContentAccess.getOrderItem().getOrder().getFormattedValue('orderOpenDateTime')#</td>
					</tr>
				</cfloop>
			</cfloop>
		</table>
		
	</div>
</cfoutput>