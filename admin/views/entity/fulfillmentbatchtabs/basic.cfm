<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.fulfillmentBatch" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	
	<sw-listing-display
		data-collection="'FulfillmentBatchItem'"
		data-edit="true"
		data-has-search="true"
		data-record-detail-action="admin:entity.detailfulfillmentBatchItem"
		data-is-angular-route="false"
		data-angular-links="false"
		data-has-action-bar="true" 
		data-persisted-collection-config="true" 
		data-multiselect-field-name="fulfillmentBatchItemID" 
		data-name="fulfillmentBatchItemTable" 
		data-multi-slot="true">
		
		<!--- Filters --->
		<sw-listing-filter data-property-identifier="fulfillmentBatch.fulfillmentBatchID" data-comparison-operator="=" data-comparison-value="#rc.fulfillmentBatch.getFulfillmentBatchID()#"></sw-listing-column>
		
		<!--- Columns --->
		<sw-listing-column data-property-identifier="orderFulfillment.order.orderNumber" data-title="Fulfillments"></sw-listing-column>
		<sw-listing-column data-property-identifier="orderFulfillment.order.orderOpenDateTime" data-title="Date"></sw-listing-column>
		<sw-listing-column data-property-identifier="orderFulfillment.shippingMethod.shippingMethodName" data-title="Shipping"></sw-listing-column>
		<sw-listing-column data-property-identifier="orderFulfillment.shippingAddress.stateCode" data-title="State"></sw-listing-column>
		<sw-listing-column data-property-identifier="orderFulfillment.orderFulfillmentStatusType.typeName" data-title="Status"></sw-listing-column>

	</sw-listing-display>
</cfoutput>