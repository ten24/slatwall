<cfparam name="rc.orderFulfillment" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList divClass="col-md-6">
			
			<!--- Email --->
			<cfif rc.orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "email">
				<cf_HibachiPropertyDisplay object="#rc.orderFulfillment#" property="emailAddress" edit="#rc.edit#">
			
			<!--- Pickup --->
			<cfelseif rc.orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "pickup">
				<cf_HibachiPropertyDisplay object="#rc.orderFulfillment#" property="pickupLocation" edit="#rc.edit#">
				
			<!--- Shipping --->
			<cfelseif rc.orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "shipping">
				
				<cf_HibachiPropertyDisplay object="#rc.orderFulfillment#" property="shippingMethod" edit="#rc.edit#">
				<hr />
				<cf_SlatwallAdminAddressDisplay address="#rc.orderFulfillment.getAddress()#" fieldnameprefix="shippingAddress." edit="#rc.edit#">
			
			</cfif>
			
			<cfif rc.orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "auto">
				<!--- TODO: Add Fulfill From Location --->
			</cfif>
		</cf_HibachiPropertyList>
		<cf_HibachiPropertyList divClass="col-md-6">
			
			<!--- Totals --->
			<cf_HibachiPropertyTable>
				<cf_HibachiPropertyTableBreak header="#$.slatwall.rbkey('define.summary')#" />
				<cf_HibachiPropertyDisplay object="#rc.orderFulfillment#" property="quantityUndelivered" edit="false" displayType="table">
				<cf_HibachiPropertyDisplay object="#rc.orderFulfillment#" property="quantityDelivered" edit="false" displayType="table">
				<cf_HibachiPropertyDisplay object="#rc.orderFulfillment#" property="totalShippingWeight" edit="false" displayType="table">
				<cf_HibachiPropertyTableBreak header="#$.slatwall.rbkey('admin.entity.detailOrderFulfillment.item_totals')#" />
				<cf_HibachiPropertyDisplay object="#rc.orderFulfillment#" property="subtotalAfterDiscounts" edit="false" displayType="table">
				<cf_HibachiPropertyDisplay object="#rc.orderFulfillment#" property="taxAmount" edit="false" displayType="table">
				<cf_HibachiPropertyDisplay object="#rc.orderFulfillment#" property="subtotalAfterDiscountsWithTax" edit="false" displayType="table">
				<cf_HibachiPropertyTableBreak header="#$.slatwall.rbkey('admin.entity.detailOrderFulfillment.fulfillment_totals')#" />
				<cf_HibachiPropertyDisplay object="#rc.orderFulfillment#" property="fulfillmentCharge" edit="false" displayType="table">
				<cf_HibachiPropertyDisplay object="#rc.orderFulfillment#" property="discountAmount" edit="false" displayType="table">
				<cf_HibachiPropertyTableBreak header="" />
				<cf_HibachiPropertyDisplay object="#rc.orderFulfillment#" property="chargeAfterDiscount" edit="false" displayType="table" titleClass="table-total" valueClass="table-total">
			</cf_HibachiPropertyTable>
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
</cfoutput>