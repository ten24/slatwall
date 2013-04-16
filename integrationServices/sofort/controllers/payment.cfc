<cfcomponent extends="Slatwall.frontend.controllers.BaseController">

<cffunction name="init" returnType="any" access="public" output="false">
	<cfargument name="fw" type="any" required="true" />

	<cfset variables.payment = new Slatwall.integrationServices.sofort.Payment() />
	<cfset super.init(argumentCollection=arguments) />

	<cfreturn this />
</cffunction>


<cffunction name="new" returntype="struct" access="public" output="false">
	<cfargument name="rc" type="struct" required="true" hint="Request-Context" />

	<cfset rc.result = variables.payment.newPayment($.slatwall.cart()) />

	<cfif isValid('url',rc.result)>
		<cflocation url="#rc.result#" addToken="false" />
	</cfif>

	<cfreturn rc />
</cffunction>


<cffunction name="verify" returntype="struct" access="public" output="false">
	<cfargument name="rc" type="struct" required="true" hint="Request-Context" />

	<cfparam name="rc.transactionId" type="string" default="" />
	<cfset variables.payment.verifyPayments($.slatwall.cart(),rc.transactionId) />

	<cfif $.slatwall.cart().getTotal() LTE $.slatwall.cart().getPaymentAmountAuthorizedTotal()>
		<cfset getFW().redirectExact($.createHREF(filename='order-confirmation',queryString='slatAction=frontend:checkout.processOrder&orderId=#$.slatwall.cart().getOrderId()#')) />
	<cfelse>
		<cfset getFW().redirectExact($.createHREF(filename='checkout',queryString='slatAction=frontend:checkout.detail&payment=error#chr(35)#payment')) />
	</cfif>

	<cfreturn rc />
</cffunction>


<cffunction name="abort" returntype="struct" access="public" output="false">
	<cfargument name="rc" type="struct" required="true" hint="Request-Context" />

	<cfset getFW().redirectExact($.createHREF(filename='checkout',queryString='slatAction=frontend:checkout.detail&payment=abort#chr(35)#payment')) />

	<cfreturn rc />
</cffunction>

</cfcomponent>