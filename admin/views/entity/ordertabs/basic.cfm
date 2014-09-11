<cfparam name="rc.order" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList divclass="col-md-6">
			
			<!--- Account --->
			<cfif rc.edit>
				<cf_HibachiPropertyDisplay object="#rc.order#" property="account" fieldtype="textautocomplete" autocompletePropertyIdentifiers="adminIcon,fullName,company,emailAddress,phoneNumber,address.simpleRepresentation" edit="true">
			<cfelseif !isNull(rc.order.getAccount())>
				<cf_HibachiPropertyDisplay object="#rc.order.getAccount()#" property="fullName" valuelink="?slatAction=admin:entity.detailaccount&accountID=#rc.order.getAccount().getAccountID()#">
				<cf_HibachiPropertyDisplay object="#rc.order.getAccount()#" property="emailAddress" valuelink="mailto:#rc.order.getAccount().getEmailAddress()#">
				<cf_HibachiPropertyDisplay object="#rc.order.getAccount()#" property="phoneNumber">
			</cfif>
			
			<!--- Origin --->
			<cf_HibachiPropertyDisplay object="#rc.order#" property="orderOrigin" edit="#rc.edit#">
			
			<!--- Order Type --->
			<cf_HibachiPropertyDisplay object="#rc.order#" property="orderType" edit="#rc.edit#">

			<!--- Default Stock Location --->
			<cf_HibachiPropertyDisplay object="#rc.order#" property="defaultStockLocation" edit="#rc.edit#">
			
			<!--- Referenced Order --->
			<cfif !isNull(rc.order.getReferencedOrder())>
				<cf_HibachiPropertyDisplay object="#rc.order#" property="referencedOrder" valuelink="?slatAction=admin:entity.detailorder&orderID=#rc.order.getReferencedOrder().getOrderID()#">
			</cfif>
			
		</cf_HibachiPropertyList>
		<cf_HibachiPropertyList divclass="col-md-6">
			
			<!--- Totals --->
			<cf_HibachiPropertyTable>
				<cf_HibachiPropertyTableBreak header="#$.slatwall.rbKey('admin.entity.detailorder.overview')#" />
				<cf_HibachiPropertyDisplay object="#rc.order#" property="orderStatusType" edit="false" displayType="table">
				<cfif !isNull(rc.order.getOrderOpenDateTime())>
					<cf_HibachiPropertyDisplay object="#rc.order#" property="orderOpenDateTime" edit="false" displayType="table">
				</cfif>
				<cfif !isNull(rc.order.getOrderCloseDateTime())>
					<cf_HibachiPropertyDisplay object="#rc.order#" property="orderCloseDateTime" edit="false" displayType="table">
				</cfif>
				<cf_HibachiPropertyDisplay object="#rc.order#" property="currencyCode" edit="false" displayType="table">
				<cf_HibachiPropertyDisplay object="#rc.order#" property="subTotal" edit="false" displayType="table">
				<cf_HibachiPropertyDisplay object="#rc.order#" property="taxTotal" edit="false" displayType="table">
				<cf_HibachiPropertyDisplay object="#rc.order#" property="fulfillmentTotal" edit="false" displayType="table">
				<cf_HibachiPropertyDisplay object="#rc.order#" property="discountTotal" edit="false" displayType="table">
				<cf_HibachiPropertyDisplay object="#rc.order#" property="total" edit="false" displayType="table" titleClass="table-total" valueClass="table-total">
				<cf_HibachiPropertyTableBreak header="#$.slatwall.rbKey('admin.entity.detailorder.payments')#" />
				<cf_HibachiPropertyDisplay object="#rc.order#" property="paymentAmountReceivedTotal" edit="false" displayType="table">
				<cf_HibachiPropertyDisplay object="#rc.order#" property="paymentAmountCreditedTotal" edit="false" displayType="table">
				<cfif arrayLen(rc.order.getReferencingOrders())>
					<cf_HibachiPropertyDisplay object="#rc.order#" property="referencingPaymentAmountCreditedTotal" edit="false" displayType="table">
				</cfif>
				<cf_HibachiPropertyDisplay object="#rc.order#" property="paymentAmountDue" edit="false" displayType="table" titleClass="table-total" valueClass="table-total">
			</cf_HibachiPropertyTable>
			
		</cf_HibachiPropertyList>
		
	</cf_HibachiPropertyRow>
</cfoutput>