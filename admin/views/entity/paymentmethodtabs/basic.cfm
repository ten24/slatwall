<cfparam name="rc.paymentMethod" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList divClass="col-md-6">
			<cf_HibachiPropertyDisplay object="#rc.paymentMethod#" property="activeFlag" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.paymentMethod#" property="paymentMethodName" edit="#rc.edit#">
			<cfif listFindNoCase("creditCard,giftCard,external", rc.paymentMethod.getPaymentMethodType())>
				<cf_HibachiPropertyDisplay object="#rc.paymentMethod#" property="paymentIntegration" edit="#rc.edit#">
			</cfif>
			<cfif listFindNoCase("creditCard,giftCard,external,termPayment", rc.paymentMethod.getPaymentMethodType())>
				<cf_HibachiPropertyDisplay object="#rc.paymentMethod#" property="allowSaveFlag" edit="#rc.edit#">
			</cfif>
			<cfif listFindNoCase("creditCard,giftCard", rc.paymentMethod.getPaymentMethodType())>
				<cf_HibachiPropertyDisplay object="#rc.paymentMethod#" property="saveAccountPaymentMethodEncryptFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.paymentMethod#" property="saveOrderPaymentEncryptFlag" edit="#rc.edit#">
			</cfif>
		</cf_HibachiPropertyList>
		<cf_HibachiPropertyList divClass="col-md-6">
			<cfif listFindNoCase("creditCard,giftCard,external", rc.paymentMethod.getPaymentMethodType())>
				<cf_HibachiPropertyDisplay object="#rc.paymentMethod#" property="saveAccountPaymentMethodTransactionType" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.paymentMethod#" property="saveOrderPaymentTransactionType" edit="#rc.edit#">
			</cfif>
			<cf_HibachiPropertyDisplay object="#rc.paymentMethod#" property="placeOrderChargeTransactionType" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.paymentMethod#" property="placeOrderCreditTransactionType" edit="#rc.edit#">
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
</cfoutput>