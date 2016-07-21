<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.orderFulfillment" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList divClass="col-md-6">

			<cfif !rc.orderFulfillment.getNewFlag()>
 				<hb:HibachiPropertyDisplay object="#rc.orderFulfillment#" property="orderFulfillmentStatusType">
			</cfif>

			<!--- Email --->
			<cfif rc.orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "email">
				<hb:HibachiPropertyDisplay object="#rc.orderFulfillment#" property="emailAddress" edit="#rc.edit#">

			<!--- Pickup --->
			<cfelseif rc.orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "pickup">
				<hb:HibachiPropertyDisplay object="#rc.orderFulfillment#" property="pickupLocation" edit="#rc.edit#">

			<!--- Shipping --->
			<cfelseif rc.orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "shipping">

				<hb:HibachiPropertyDisplay object="#rc.orderFulfillment#" property="shippingMethod" edit="#rc.edit#">
				<hr />
				<swa:SlatwallAdminAddressDisplay address="#rc.orderFulfillment.getAddress()#" fieldnameprefix="shippingAddress." edit="#rc.edit#" showPhoneNumber="true">

			</cfif>

			<cfif rc.orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "auto">
				<!--- TODO: Add Fulfill From Location --->
			</cfif>
		</hb:HibachiPropertyList>
		<hb:HibachiPropertyList divClass="col-md-6">

			<!--- Totals --->
			<hb:HibachiPropertyTable>
				<hb:HibachiPropertyTableBreak header="#$.slatwall.rbkey('define.summary')#" />
				<hb:HibachiPropertyDisplay object="#rc.orderFulfillment#" property="quantityUndelivered" edit="false" displayType="table">
				<hb:HibachiPropertyDisplay object="#rc.orderFulfillment#" property="quantityDelivered" edit="false" displayType="table">
				<hb:HibachiPropertyDisplay object="#rc.orderFulfillment#" property="totalShippingWeight" edit="false" displayType="table">
				<hb:HibachiPropertyTableBreak header="#$.slatwall.rbkey('admin.entity.detailOrderFulfillment.item_totals')#" />
				<hb:HibachiPropertyDisplay object="#rc.orderFulfillment#" property="subtotalAfterDiscounts" edit="false" displayType="table">
				<hb:HibachiPropertyDisplay object="#rc.orderFulfillment#" property="taxAmount" edit="false" displayType="table">
				<hb:HibachiPropertyDisplay object="#rc.orderFulfillment#" property="subtotalAfterDiscountsWithTax" edit="false" displayType="table">
				<hb:HibachiPropertyTableBreak header="#$.slatwall.rbkey('admin.entity.detailOrderFulfillment.fulfillment_totals')#" />
				<hb:HibachiPropertyDisplay object="#rc.orderFulfillment#" property="fulfillmentCharge" edit="false" displayType="table">
				<hb:HibachiPropertyDisplay object="#rc.orderFulfillment#" property="discountAmount" edit="false" displayType="table">
				<hb:HibachiPropertyTableBreak header="" />
				<hb:HibachiPropertyDisplay object="#rc.orderFulfillment#" property="chargeAfterDiscount" edit="false" displayType="table" titleClass="table-total" valueClass="table-total">
			</hb:HibachiPropertyTable>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>