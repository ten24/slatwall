<cfparam name="rc.accountPayment" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList divClass="col-md-6">
			<cfif rc.accountPayment.getPaymentMethodType() eq "creditCard">
				<cf_HibachiPropertyDisplay object="#rc.accountPayment#" property="nameOnCreditCard" edit="#rc.edit#" />
				<cf_HibachiPropertyDisplay object="#rc.accountPayment#" property="creditCardType" />
				<cf_HibachiPropertyDisplay object="#rc.accountPayment#" property="expirationMonth" edit="#rc.edit#" />
				<cf_HibachiPropertyDisplay object="#rc.accountPayment#" property="expirationYear" edit="#rc.edit#" />
			</cfif>
		</cf_HibachiPropertyList>
		<cf_HibachiPropertyList divClass="col-md-6">
			<cf_HibachiPropertyDisplay object="#rc.accountPayment#" property="amount" />
			<cf_HibachiPropertyDisplay object="#rc.accountPayment#" property="amountReceived" />
			<cf_HibachiPropertyDisplay object="#rc.accountPayment#" property="amountCredited" />
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
</cfoutput>