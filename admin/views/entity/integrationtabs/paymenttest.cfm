<cfset creditCardRequestBean = createObject("component", "Slatwall.model.transient.payment.CreditCardTransactionRequestBean").init() />

<cfset creditCardRequestBean.setnameOnCreditCard("Paul John") />

<cfset creditCardRequestBean.settransactionType("authorizeAndCharge") />
<cfset creditCardRequestBean.settransactionType("authorize") />
<cfset creditCardRequestBean.settransactionType("chargePreAuthorization") />

<cfset creditCardRequestBean.setProviderTransactionID("77556") />

<cfset creditCardRequestBean.setCreditCardNumber("4111111111111111") />

<cfset creditCardRequestBean.setTransactionAmount("40") />

<cfset creditCardRequestBean.setExpirationMonth("12") />
<cfset creditCardRequestBean.setExpirationYear("15") />

<cfset creditCardRequestBean.settransactionID(createuuid()) />

<cfset response = rc.integration.getIntegrationCFC("payment").processCreditCard(creditCardRequestBean) />
<cfdump var="#response#" />




