<cfparam name="rc.order" type="any" />


<cfoutput>
<cfif arrayLen(rc.order.getOrderItems())>
	<table class="table table-striped table-bordered table-condensed">
		<tr>
			<th>#$.slatwall.rbKey('entity.product')#</th>
			<th>#$.slatwall.rbKey('entity.product.price')#</th>
		</tr>
		<cfloop array="#rc.order.getOrderItems()#" index="local.orderItem">
			<tr>
				<td class="primary">#local.orderItem.getSku().getProduct().getTitle()#</td>
				<td>#local.orderItem.getSku().getProduct().getFormattedValue('price')#</td>
			</tr>
		</cfloop>
	</table>
</cfif>
</cfoutput>