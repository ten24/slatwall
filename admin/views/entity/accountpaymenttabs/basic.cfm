<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.accountPayment" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList divClass="col-md-6">
			<cfif rc.accountPayment.getPaymentMethodType() eq "creditCard">
				<hb:HibachiPropertyDisplay object="#rc.accountPayment#" property="nameOnCreditCard" edit="#rc.edit#" />
				<hb:HibachiPropertyDisplay object="#rc.accountPayment#" property="creditCardType" />
				<hb:HibachiPropertyDisplay object="#rc.accountPayment#" property="expirationMonth" edit="#rc.edit#" />
				<hb:HibachiPropertyDisplay object="#rc.accountPayment#" property="expirationYear" edit="#rc.edit#" />
			</cfif>
		</hb:HibachiPropertyList>
		<hb:HibachiPropertyList divClass="col-md-6">
			<hb:HibachiPropertyDisplay object="#rc.accountPayment#" property="amount" />
			<hb:HibachiPropertyDisplay object="#rc.accountPayment#" property="amountReceived" />
			<hb:HibachiPropertyDisplay object="#rc.accountPayment#" property="amountCredited" />
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>