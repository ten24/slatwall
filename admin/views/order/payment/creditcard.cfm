<!---

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

--->

<cfoutput>

<cfset local.creditcardTransactions = local.orderPayment.getCreditCardTransactions() />
<table class="paymentDetails">
	<tr>
		<th>#$.Slatwall.rbKey("entity.orderPaymentCreditCard.creditCardType")#</th>
		<th>#$.Slatwall.rbKey("entity.orderPaymentCreditCard.expirationDate")#</th>
		<th>#$.Slatwall.rbKey("entity.orderPaymentCreditCard.billingAddress")#</th>
		<th>#$.Slatwall.rbKey("entity.creditcardtransaction.authorizationcode")#</th>
		<th>#$.Slatwall.rbKey("entity.orderPaymentCreditCard.amountAuthorized")#</th>
		<th>#$.Slatwall.rbKey("entity.orderPaymentCreditCard.amountCharged")#</th>
		<th>#$.Slatwall.rbKey("entity.orderPayment.amountRefunded")#</th>
	</tr>
	<tr>
		<td>
			#local.orderPayment.getCreditCardType()#<br>
			#$.slatwall.rbKey("entity.orderPaymentCreditCard.CreditCardLastFour")#: #local.orderPayment.getCreditCardLastFour()#
		</td>
		<td>#local.orderPayment.getExpirationDate()#</td>
		<td><cfif !isNull(local.orderPayment.getBillingAddress())><cf_SlatwallAddressDisplay address="#local.orderPayment.getBillingAddress()#" edit="false" /></cfif></td>
		<td>
			#listChangeDelims(local.orderPayment.getAuthorizationCodes(),"<br>")#
		</td>
		<td>#local.orderPayment.getFormattedValue('amountAuthorized', 'currency')#</td>
		<td>#local.orderPayment.getFormattedValue('amountCharged', 'currency')#</td>
		<td>#local.orderPayment.getFormattedValue('amountCredited', 'currency')#</td>		
	</tr>
</table>
<!--- display link to refund payment if amount has been charged --->
<cfif local.orderPayment.getAmountCharged() gt 0>
	<!--- get the transactionID for the last charged transaction --->
	<cfloop array="#local.creditcardTransactions#" index="local.thistransaction">
		<cfif local.thistransaction.getAmountCharged() GT 0>
			<cfbreak />
		</cfif>
	</cfloop>
	<cf_SlatwallActionCaller action="admin:order.refundOrderPayment" querystring="orderPaymentID=#local.orderPayment.getOrderPaymentID()#&providerTransactionID=#local.thistransaction.getProviderTransactionID()#" class="button">
</cfif>

<!--- display link to charge card if full authorized amount hasn't been charged yet --->
<cfif local.orderPayment.getAmountAuthorized() gt local.orderpayment.getAmountCharged()>
	<!--- get the transactionID for the last authorized transaction --->
	<cfloop array="#local.creditcardTransactions#" index="local.thistransaction">
		<cfif local.thistransaction.getAmountAuthorized() GT local.thistransaction.getAmountCharged()>
			<cfbreak />
		</cfif>
	</cfloop>
	<cf_SlatwallActionCaller action="admin:order.chargeOrderPayment" querystring="orderPaymentID=#local.orderPayment.getOrderPaymentID()#&providerTransactionID=#local.thistransaction.getProviderTransactionID()#" confirmRequired="true" class="button">
</cfif>
	
</cfoutput>