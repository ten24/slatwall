<cfparam name="rc.edit" default="false" />
<cfparam name="rc.order" type="any" />
<cfparam name="rc.orderDeliveryItemSmartList" type="any" />


<cfoutput>
<cf_HibachiEntityDetailForm object="#rc.order#" edit="#rc.edit#">
	<cfif rc.order.hasOrderDelivery()>
		<cf_HibachiEntityActionBar type="detail" pageTitle="Amazon S3 Order: #rc.order.getSimpleRepresentation()#" object="#rc.order.getOrderDeliveries()[1]#" showCancel="true" showCreate="false" showEdit="false" showDelete="false">
		</cf_HibachiEntityActionBar>
	<cfelse>
		<cf_HibachiEntityActionBar type="detail" pageTitle="Amazon S3 Order: #rc.order.getSimpleRepresentation()#" object="#rc.order#" showCancel="true" showCreate="false" showEdit="false" showDelete="false">
		</cf_HibachiEntityActionBar>
	</cfif>


	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList divclass="span6">
			<cfif !isNull(rc.order.getAccount())>
				<cf_HibachiPropertyDisplay object="#rc.order.getAccount()#" property="fullName" valuelink="?slatAction=admin:entity.detailaccount&accountID=#rc.order.getAccount().getAccountID()#">
				<cf_HibachiPropertyDisplay object="#rc.order.getAccount()#" property="emailAddress" valuelink="mailto:#rc.order.getAccount().getEmailAddress()#">
				<cf_HibachiPropertyDisplay object="#rc.order.getAccount()#" property="phoneNumber">
			</cfif>

			<!--- Origin --->
			<cf_HibachiPropertyDisplay object="#rc.order#" property="orderOrigin" edit="#rc.edit#">

			<!--- Order Type --->
			<cf_HibachiPropertyDisplay object="#rc.order#" property="orderType" edit="#rc.edit#">

			<!--- Referenced Order --->
			<cfif !isNull(rc.order.getReferencedOrder())>
				<cf_HibachiPropertyDisplay object="#rc.order#" property="referencedOrder" valuelink="?slatAction=admin:entity.detailorder&orderID=#rc.order.getReferencedOrder().getOrderID()#">
			</cfif>

		</cf_HibachiPropertyList>

		<cf_HibachiPropertyList divclass="span6">
			<!--- Totals --->
			<cf_HibachiPropertyTable>
				<cf_HibachiPropertyTableBreak header="Overview" />
				<cf_HibachiPropertyDisplay object="#rc.order#" property="orderStatusType" edit="false" displayType="table">
				<cfif !isNull(rc.order.getOrderOpenDateTime())>
					<cf_HibachiPropertyDisplay object="#rc.order#" property="orderOpenDateTime" edit="false" displayType="table">
				</cfif>
				<cfif !isNull(rc.order.getOrderCloseDateTime())>
					<cf_HibachiPropertyDisplay object="#rc.order#" property="orderCloseDateTime" edit="false" displayType="table">
				</cfif>
				<cf_HibachiPropertyDisplay object="#rc.order#" property="subtotal" edit="false" displayType="table">
				<cf_HibachiPropertyDisplay object="#rc.order#" property="taxtotal" edit="false" displayType="table">
				<cf_HibachiPropertyDisplay object="#rc.order#" property="fulfillmenttotal" edit="false" displayType="table">
				<cf_HibachiPropertyDisplay object="#rc.order#" property="discounttotal" edit="false" displayType="table">
				<cf_HibachiPropertyTableBreak header="Payments" />
				<cf_HibachiPropertyDisplay object="#rc.order#" property="paymentAmountReceivedTotal" edit="false" displayType="table">
				<cf_HibachiPropertyDisplay object="#rc.order#" property="paymentAmountCreditedTotal" edit="false" displayType="table">
				<cfif arrayLen(rc.order.getReferencingOrders())>
					<cf_HibachiPropertyDisplay object="#rc.order#" property="referencingPaymentAmountCreditedTotal" edit="false" displayType="table">
				</cfif>
				<cf_HibachiPropertyTableBreak header="" />
				<cf_HibachiPropertyDisplay object="#rc.order#" property="total" edit="false" displayType="table" titleClass="table-total" valueClass="table-total">
			</cf_HibachiPropertyTable>
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>


	<cf_HibachiTabGroup object="#rc.order#">
		<cf_HibachiTab view="admin:entity/ordertabs/orderpayments" count="#rc.order.getOrderPaymentsCount()#" />

		<cfif rc.order.getOrderType().getSystemCode() eq "otSalesOrder" or rc.order.getOrderType().getSystemCode() eq "otExchangeOrder">
			<cf_HibachiTab view="admin:entity/ordertabs/orderfulfillments" count="#rc.order.getOrderFulfillmentsCount()#" />
			<cf_HibachiTab view="admin:entity/ordertabs/orderdeliveries" count="#rc.order.getOrderDeliveriesCount()#" />
		</cfif>

		<cf_HibachiTab view="s3:admin/ordertabs/products" count="#arrayLen(rc.order.getOrderItems())#" />
		<cf_HibachiTab view="s3:admin/ordertabs/downloads" />

		<cf_HibachiTab view="admin:entity/ordertabs/promotions" count="#rc.order.getPromotionCodesCount()#" />

		<cfif NOT isNull(rc.order.getAccount()) AND NOT rc.order.getAccount().getNewFlag()>
			<cf_HibachiTab view="admin:entity/ordertabs/accountdetails" />
		</cfif>

		<cf_SlatwallAdminTabComments object="#rc.order#" />
	</cf_HibachiTabGroup>

<!---	<cf_HibachiListingDisplay smartList="#rc.orderDeliveryItemSmartList#">
		<cf_HibachiListingColumn propertyIdentifier="createdDateTime" />
		<cf_HibachiListingColumn propertyIdentifier="orderItem.sku.product.productName" />
		<cf_HibachiListingColumn propertyIdentifier="orderDeliveryItemID" />
	</cf_HibachiListingDisplay>
</cf_HibachiEntityDetailForm>--->
</cfoutput>