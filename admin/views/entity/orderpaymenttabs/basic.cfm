<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.orderPayment" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList divClass="col-md-6">
			<cfif rc.orderPayment.getPaymentMethodType() eq "creditCard">
				<hb:HibachiPropertyDisplay object="#rc.orderPayment#" property="nameOnCreditCard" edit="#rc.edit#" />
				<hb:HibachiPropertyDisplay object="#rc.orderPayment#" property="creditCardType" />
				<hb:HibachiPropertyDisplay object="#rc.orderPayment#" property="expirationMonth" edit="#rc.edit#" />
				<hb:HibachiPropertyDisplay object="#rc.orderPayment#" property="expirationYear" edit="#rc.edit#" />
			<cfelseif rc.orderPayment.getPaymentMethodType() eq "termPayment">
				<hb:HibachiPropertyDisplay object="#rc.orderPayment#" property="termPaymentAccount" edit="false" />
				<hb:HibachiPropertyDisplay object="#rc.orderPayment#" property="paymentTerm" edit="false" />
			<cfelseif rc.orderPayment.getPaymentMethodType() eq "giftCard">
				<hb:HibachiPropertyDisplay object="#rc.orderPayment#" property="giftCardNumberEncrypted" valueLink="#$.slatwall.buildUrl(action="admin:entity.detailgiftcard", querystring='giftCardID=' & rc.orderPayment.getGiftCard().getGiftCardID())#" edit="false">
			</cfif>
			<hb:HibachiPropertyDisplay object="#rc.orderPayment#" property="companyPaymentMethodFlag" edit="#rc.edit#"/>
			<cfif ( listFindNoCase("creditCard,termPayment", rc.orderPayment.getPaymentMethodType()) or not isNull(rc.orderPayment.getBillingAddress()) ) and rc.orderPayment.getPaymentMethodType() neq "giftCard">
				<hr />
				<swa:SlatwallAdminAddressDisplay address="#rc.orderPayment.getBillingAddress()#" fieldnameprefix="billingAddress." edit="#rc.edit#">
			</cfif>
		</hb:HibachiPropertyList>
		<hb:HibachiPropertyList divClass="col-md-6">
			<hb:HibachiPropertyDisplay object="#rc.orderPayment#" property="purchaseOrderNumber" edit="#rc.edit#"/>
			<hb:HibachiPropertyDisplay object="#rc.orderPayment#" property="dynamicAmountFlag" edit="false" />
			<hb:HibachiPropertyDisplay object="#rc.orderPayment#" property="orderPaymentType" />
			<hb:HibachiPropertyDisplay object="#rc.orderPayment#" property="amount" edit="#rc.edit and not rc.orderPayment.getDynamicAmountFlag()#" />
			<hr />
			<hb:HibachiPropertyDisplay object="#rc.orderPayment#" property="amountAuthorized" />
			<hb:HibachiPropertyDisplay object="#rc.orderPayment#" property="amountReceived" />
			<hb:HibachiPropertyDisplay object="#rc.orderPayment#" property="amountCredited" />
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>
