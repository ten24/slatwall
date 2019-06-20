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
			
			<hb:HibachiPropertyDisplay object="#rc.orderFulfillment#" property="estimatedShippingDate" edit="#rc.edit#">
				
			<!--- Email --->
			<cfif rc.orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "email">
				<hb:HibachiPropertyDisplay object="#rc.orderFulfillment#" property="emailAddress" edit="#rc.edit#">

			<!--- Pickup --->
			<cfelseif rc.orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "pickup">
				<hb:HibachiPropertyDisplay object="#rc.orderFulfillment#" property="pickupLocation" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.orderFulfillment#" property="pickupDate" edit="#rc.edit#">

			<!--- Shipping --->
			<cfelseif rc.orderFulfillment.getFulfillmentMethod().getFulfillmentMethodType() eq "shipping">
				<cfif rc.edit eq "true">
					<hb:HibachiPropertyDisplay object="#rc.orderFulfillment#" property="shippingAddress" hint="#$.slatwall.rbkey('entity.orderfulfillment.shippingaddress.hint')#" edit="false">
					<hr>
					<hb:HibachiPropertyDisplay object="#rc.orderFulfillment#" property="accountAddress" edit="#rc.edit#">
					
				<cfelse>
					<hb:HibachiPropertyDisplay object="#rc.orderFulfillment#" property="shippingAddress" edit="#rc.edit#">	
				</cfif>
				
				<hb:HibachiPropertyDisplay object="#rc.orderFulfillment#" property="shippingMethod" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.orderFulfillment#" valueOptions="#rc.orderFulfillment.getShippingIntegrationOptions()#" property="shippingIntegration" edit="#rc.edit#">
				<cfif NOT isNull(rc.orderFulfillment.getHandlingFee()) AND rc.orderFulfillment.getHandlingFee() GT 0 >
					<hb:HibachiPropertyDisplay object="#rc.orderFulfillment#" property="handlingFee" edit="false">
				</cfif>
				<hr />
				
				<hb:HibachiDisplayToggle selector="select[name='accountAddress.accountAddressID']" showValues="" loadVisable="#isNull(rc.orderFulfillment.getAccountAddress())#">
					<swa:SlatwallAdminAddressDisplay address="#rc.orderFulfillment.getAddress()#" fieldnameprefix="shippingAddress." edit="#rc.edit#" showPhoneNumber="true">
				</hb:HibachiDisplayToggle>
				<cfif $.slatwall.setting('globalAllowThirdPartyShippingAccount')>
					<hb:HibachiPropertyDisplay object="#rc.orderFulfillment#" property="thirdPartyShippingAccountIdentifier" edit="#rc.edit#">
				</cfif>
				<cfif rc.edit eq "true">
					<hb:HibachiPropertyDisplay object="#rc.orderFulfillment#" property="saveAccountAddressFlag" fieldtype="yesno" edit="#rc.edit#"></hb:HibachiPropertyDisplay>
				</cfif>
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
				<hb:HibachiPropertyDisplay object="#rc.orderFulfillment#" property="chargeTaxAmount" edit="false" displayType="table">
				<hb:HibachiPropertyTableBreak header="" />
				<hb:HibachiPropertyDisplay object="#rc.orderFulfillment#" property="chargeAfterDiscount" edit="false" displayType="table" titleClass="table-total" valueClass="table-total">
			</hb:HibachiPropertyTable>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>