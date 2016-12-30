<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.order" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList divclass="col-md-6">

			<!--- Account --->
			<cfif rc.edit>
				<hb:HibachiPropertyDisplay object="#rc.order#" property="account" fieldtype="textautocomplete" autocompletePropertyIdentifiers="adminIcon,fullName,company,emailAddress,phoneNumber,address.simpleRepresentation" edit="true">
			<cfelseif !isNull(rc.order.getAccount())>
				<hb:HibachiPropertyDisplay object="#rc.order.getAccount()#" property="fullName" valuelink="?slatAction=admin:entity.detailaccount&accountID=#rc.order.getAccount().getAccountID()#" title="#$.slatwall.rbKey('entity.account')#">
				<hb:HibachiPropertyDisplay object="#rc.order.getAccount()#" property="emailAddress" valuelink="mailto:#rc.order.getAccount().getEmailAddress()#">
				<hb:HibachiPropertyDisplay object="#rc.order.getAccount()#" property="phoneNumber">
			</cfif>

			<!--- Origin --->
			<hb:HibachiPropertyDisplay object="#rc.order#" property="orderOrigin" edit="#rc.edit#">

			<!--- Order Type --->
			<hb:HibachiPropertyDisplay object="#rc.order#" property="orderType" edit="#rc.edit#">

			<!--- Default Stock Location --->
			<hb:HibachiPropertyDisplay object="#rc.order#" property="defaultStockLocation" edit="#rc.edit#">

			<!--- Order IP Address --->
			<cfif !isNull(rc.order.getOrderOpenIPAddress())>
				<hb:HibachiPropertyDisplay object="#rc.order#" property="orderOpenIPAddress" edit="false">
			</cfif>

			<!--- Referenced Order --->
			<cfif !isNull(rc.order.getReferencedOrder())>
				<hb:HibachiPropertyDisplay object="#rc.order#" property="referencedOrder" valuelink="?slatAction=admin:entity.detailorder&orderID=#rc.order.getReferencedOrder().getOrderID()#">
				<hb:HibachiPropertyDisplay object="#rc.order#" property="referencedOrderType">
			</cfif>

			<!--- Assigned Account --->
			<cfif rc.edit>
				<hb:HibachiPropertyDisplay object="#rc.order#" property="assignedAccount" fieldtype="textautocomplete" autocompletePropertyIdentifiers="adminIcon,fullName,company,emailAddress,phoneNumber,address.simpleRepresentation" edit="true">
			<cfelseif !isNull(rc.order.getAssignedAccount())>
				<hb:HibachiPropertyDisplay object="#rc.order.getAssignedAccount()#" property="fullName" valuelink="?slatAction=admin:entity.detailaccount&accountID=#rc.order.getAssignedAccount().getAccountID()#" title="#$.slatwall.rbKey('entity.order.assignedAccount')#">
			</cfif>

		</hb:HibachiPropertyList>
		<hb:HibachiPropertyList divclass="col-md-6">

			<!--- Totals --->
			<hb:HibachiPropertyTable>
				<hb:HibachiPropertyTableBreak header="#$.slatwall.rbKey('admin.entity.detailorder.overview')#" />
				<hb:HibachiPropertyDisplay object="#rc.order#" property="orderStatusType" edit="false" displayType="table">
				<cfif !isNull(rc.order.getOrderOpenDateTime())>
					<hb:HibachiPropertyDisplay object="#rc.order#" property="orderOpenDateTime" edit="false" displayType="table">
				</cfif>
				<cfif !isNull(rc.order.getOrderCloseDateTime())>
					<hb:HibachiPropertyDisplay object="#rc.order#" property="orderCloseDateTime" edit="false" displayType="table">
				</cfif>
				<hb:HibachiPropertyDisplay object="#rc.order#" property="currencyCode" edit="false" displayType="table">
				<hb:HibachiPropertyDisplay object="#rc.order#" property="subTotal" edit="false" displayType="table">
				<hb:HibachiPropertyDisplay object="#rc.order#" property="taxTotal" edit="false" displayType="table">
				<hb:HibachiPropertyDisplay object="#rc.order#" property="fulfillmentTotal" edit="false" displayType="table">
				<hb:HibachiPropertyDisplay object="#rc.order#" property="discountTotal" edit="false" displayType="table">
				<hb:HibachiPropertyDisplay object="#rc.order#" property="total" edit="false" displayType="table" titleClass="table-total" valueClass="table-total">
				<hb:HibachiPropertyTableBreak header="#$.slatwall.rbKey('admin.entity.detailorder.status')#" />
				<hb:HibachiPropertyDisplay object="#rc.order#" property="estimatedFulfillmentDateTime" edit="false" displayType="table"  />
				<hb:HibachiPropertyDisplay object="#rc.order#" property="estimatedDeliveryDateTime" edit="false" displayType="table" />
				<hb:HibachiPropertyDisplay object="#rc.order#" property="nextEstimatedFulfillmentDateTime" edit="false" displayType="table" />
				<hb:HibachiPropertyDisplay object="#rc.order#" property="nextEstimatedDeliveryDateTime" edit="false" displayType="table" />
				<hb:HibachiPropertyTableBreak header="#$.slatwall.rbKey('admin.entity.detailorder.payments')#" />
				<hb:HibachiPropertyDisplay object="#rc.order#" property="paymentAmountReceivedTotal" edit="false" displayType="table">
				<hb:HibachiPropertyDisplay object="#rc.order#" property="paymentAmountCreditedTotal" edit="false" displayType="table">
				<cfif arrayLen(rc.order.getReferencingOrders())>
					<hb:HibachiPropertyDisplay object="#rc.order#" property="referencingPaymentAmountCreditedTotal" edit="false" displayType="table">
				</cfif>
				<hb:HibachiPropertyDisplay object="#rc.order#" property="paymentAmountDue" edit="false" displayType="table" titleClass="table-total" valueClass="table-total">

				<cfif rc.order.hasGiftCardOrderPaymentAmount()>
					<hb:HibachiPropertyDisplay object="#rc.order#" property="paymentAmountDueAfterGiftCards" edit="false" displayType="table" titleClass="table-total" valueClass="table-total">
				</cfif>
			</hb:HibachiPropertyTable>

		</hb:HibachiPropertyList>

	</hb:HibachiPropertyRow>
</cfoutput>
