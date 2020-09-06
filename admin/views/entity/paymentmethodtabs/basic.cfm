<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.paymentMethod" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList divClass="col-md-6">
			<hb:HibachiPropertyDisplay object="#rc.paymentMethod#" property="activeFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.paymentMethod#" property="paymentMethodName" edit="#rc.edit#">
			<cfif listFindNoCase("creditCard,giftCard,external", rc.paymentMethod.getPaymentMethodType())>
				<hb:HibachiPropertyDisplay object="#rc.paymentMethod#" property="paymentIntegration" edit="#rc.edit#">
			</cfif>
			<cfif listFindNoCase("creditCard,giftCard,external,termPayment", rc.paymentMethod.getPaymentMethodType())>
				<hb:HibachiPropertyDisplay object="#rc.paymentMethod#" property="allowSaveFlag" edit="#rc.edit#">
			</cfif>
			<cfif listFindNoCase("creditCard,giftCard", rc.paymentMethod.getPaymentMethodType())>
				<hb:HibachiPropertyDisplay object="#rc.paymentMethod#" property="saveAccountPaymentMethodEncryptFlag" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.paymentMethod#" property="saveOrderPaymentEncryptFlag" edit="#rc.edit#">
			</cfif>
		</hb:HibachiPropertyList>
		<hb:HibachiPropertyList divClass="col-md-6">
			<cfif listFindNoCase("creditCard,giftCard,external", rc.paymentMethod.getPaymentMethodType())>
				<hb:HibachiPropertyDisplay object="#rc.paymentMethod#" property="saveAccountPaymentMethodTransactionType" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.paymentMethod#" property="saveOrderPaymentTransactionType" edit="#rc.edit#">
			</cfif>
			<hb:HibachiPropertyDisplay object="#rc.paymentMethod#" property="placeOrderChargeTransactionType" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.paymentMethod#" property="placeOrderCreditTransactionType" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.paymentMethod#" property="subscriptionRenewalTransactionType" edit="#rc.edit#">
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>