<cfparam name="rc.order" type="any" />


<cfoutput>
<table class="table table-striped table-bordered table-condensed">
	<tr>
		<th>#$.slatwall.rbKey('entity.integrations3request.createddatetime')#</th>
		<th>#$.slatwall.rbKey('entity.product')#</th>
		<th>#$.slatwall.rbKey('entity.integrations3request.s3requestid')#</th>
		<th>#$.slatwall.rbKey('entity.integrations3request.remoteIP')#</th>
		<th>#$.slatwall.rbKey('entity.integrations3request.userAgent')#</th>
	</tr>

	<cfloop array="#rc.order.getOrderDeliveries()#" index="local.orderDelivery">
		<cfset local.integrationS3Requests = getBeanFactory().getBean('integrationS3RequestService').listIntegrationS3RequestByOrderDelivery(local.orderDelivery) />

		<cfloop array="#local.integrationS3Requests#" index="local.integrationS3Request">
			<tr>
				<td class="primary">#local.integrationS3Request.getFormattedValue('createdDateTime')#</td>
				<td>#local.integrationS3Request.getOrderDeliveryItem().getOrderItem().getSku().getProduct().getTitle()#</td>
				<td>#local.integrationS3Request.getS3RequestID()#</td>
				<td>#local.integrationS3Request.getRemoteIP()#</td>
				<td>#local.integrationS3Request.getUserAgent()#</td>
			</tr>
		</cfloop>
	</cfloop>
</table>
</cfoutput>