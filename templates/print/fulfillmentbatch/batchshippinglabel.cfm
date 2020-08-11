<cfparam name="print" type="any" />	
<cfparam name="printData" type="struct" default="#structNew()#" />
<cfparam name="fulfillmentbatch" type="any" />

<style>
@media print {
	img {
        width: auto;
        max-height: 8in;
		display: block;
		margin-left: auto;
		margin-right: auto;
		margin-top: 1in;
	}
    @page {
        size: auto;
        margin: 0mm;
    }
	.print-label { 
		page-break-after: always; 
	}
}
</style>

<cfoutput>

	
	<cfloop array="#fulfillmentbatch.getFulfillmentBatchItems()#" index="batchItem">
			
		<cfif not isNull(batchItem.getOrderFulfillment())>
			<cfset orderFulfillment = batchItem.getOrderFulfillment() />
			<cfset order = orderFulfillment.getOrder() />
			<cfset deliveries = order.getOrderDeliveries()>
			
			<cfloop array="#deliveries#" index="orderDelivery" >
				<cfset deliveryItem = orderDelivery.getOrderDeliveryItems()[1]>
				<cfset  dId = deliveryItem.getOrderItem().getOrderFulfillment().getOrderFulfillmentID()>
					<cfset labelArray=listToArray(orderDelivery.getContainerLabel(),",") />
					<cfloop array="#labelArray#" index="label">
						<div id="container#orderDelivery.getOrderDeliveryID()#" class="print-label" style="font-family: arial; font-size: 12px;background:##fff;">
							<img src="data:image/png;base64,#label#"  alt="barcode">
						</div>
					</cfloop>
					<cfif NOT ArrayLen(labelArray)>
						<div id="bottom" style="margin-top: 15px; float: left; clear: both; width: 600px;">
							<div id="shippingAddress#orderDelivery.getOrderDeliveryID()#" style="width:190px; margin-right:10px; float:left;">
								<strong>Shipping Address</strong><br /><br />
								<cfif len(orderDelivery.getShippingAddress().getName())>#orderDelivery.getShippingAddress().getName()#<br /></cfif>
								<cfif len(orderDelivery.getShippingAddress().getStreetAddress())>#orderDelivery.getShippingAddress().getStreetAddress()#<br /></cfif>
								<cfif len(orderDelivery.getShippingAddress().getStreet2Address())>#orderDelivery.getShippingAddress().getStreet2Address()#<br /></cfif>
								#orderDelivery.getShippingAddress().getCity()#, #orderDelivery.getShippingAddress().getStateCode()# #orderDelivery.getShippingAddress().getPostalCode()#<br />
								#orderDelivery.getShippingAddress().getCountryCode()#
							</div>
						</div>
					</cfif>
			</cfloop>
		</cfif>
	</cfloop>
</cfoutput>