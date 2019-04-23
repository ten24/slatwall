<cfparam name="print" type="any" />
<cfparam name="printData" type="struct" default="#structNew()#" />
<cfparam name="fulfillmentBatch" type="any" />

<cfoutput>
	<style>
		@media print {
			.invoice-temp {
				page-break-after: always;
			}
		}
	</style>
	<cfloop array="#fulfillmentBatch.getFulfillmentBatchItems()#" index="local.batchItem">
		<cfif not isNull(local.batchItem.getOrderFulfillment())>
			<cfset orderFulfillment = local.batchItem.getOrderFulfillment() >
			<cfset order = orderFulfillment.getOrder() >

				<cfset local.batchPageCount = 1 />
				<div id="container#orderFulfillment.getOrderFulfillmentID()#-#local.batchPageCount#" class="proof-of-delivery">

					<cfinclude template="inc/podheader.cfm" />

					<cfinclude template="../inc/podtable.cfm" />

					<cfinclude template="../inc/ordernotes.cfm" />

					<cfinclude template="../inc/podsignature.cfm" />
				</div>
		</cfif>
	</cfloop>
</cfoutput>