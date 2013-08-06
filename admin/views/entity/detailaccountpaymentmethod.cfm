<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC
	
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
    
    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
	
    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your 
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms 
    of your choice, provided that you follow these specific guidelines: 

	- You also meet the terms and conditions of the license of each 
	  independent module 
	- You must not alter the default display of the Slatwall name or logo from  
	  any part of the application 
	- Your custom code must not alter or create any files inside Slatwall, 
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets 
	the above guidelines as a combined work under the terms of GPL for this program, 
	provided that you include the source code of that other code when and as the 
	GNU GPL requires distribution of source code.
    
    If you modify this program, you may extend this exception to your version 
    of the program, but you are not obligated to do so.

Notes:

--->
<cfparam name="rc.accountPaymentMethod" type="any">
<cfparam name="rc.account" type="any" default="#rc.accountPaymentMethod.getAccount()#">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.accountPaymentMethod#" edit="#rc.edit#" 
								saveActionQueryString="accountID=#rc.account.getAccountID()#"
								saveActionHash="tabaccountpaymentmethods">
								
		<cf_HibachiEntityActionBar type="detail" object="#rc.accountPaymentMethod#" edit="#rc.edit#"
					backAction="admin:entity.detailAccount" 
					backQueryString="accountID=#rc.account.getAccountID()#"
					cancelAction="admin:entity.detailAccount"
					cancelQueryString="accountID=#rc.account.getAccountID()#"
					deleteQueryString="redirectAction=admin:entity.detailAccount&accountID=#rc.account.getAccountID()#" />

		<!--- Hidden field to attach this to the account --->
		<input type="hidden" name="account.accountID" value="#rc.account.getAccountID()#" />
		
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList divClass="span6">
				<cf_HibachiPropertyDisplay object="#rc.accountPaymentMethod#" property="activeFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.accountPaymentMethod#" property="accountPaymentMethodName" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.accountPaymentMethod#" property="paymentMethod" edit="#rc.edit#">
				
				<cfset loadPaymentMethodType = rc.accountPaymentMethod.getPaymentMethodOptions()[1]['paymentmethodtype'] />
				<cfif !isNull(rc.accountPaymentMethod.getPaymentMethod())>
					<cfset loadPaymentMethodType = rc.accountPaymentMethod.getPaymentMethod().getPaymentMethodType() />
				</cfif>
				
				<!--- Credit Card Details --->
				<cf_HibachiDisplayToggle selector="select[name='paymentMethod.paymentMethodID']" valueAttribute="paymentmethodtype" showValues="creditCard" loadVisable="#loadPaymentMethodType eq 'creditCard'#">
					<hr />
					<h5>#$.slatwall.rbKey('admin.define.creditCardDetials')#</h5>
					<cf_HibachiPropertyDisplay object="#rc.accountPaymentMethod#" property="creditCardNumber" edit="#rc.edit#" />
					<cf_HibachiPropertyDisplay object="#rc.accountPaymentMethod#" property="nameOnCreditCard" edit="#rc.edit#" />
					<cf_HibachiPropertyDisplay object="#rc.accountPaymentMethod#" property="expirationMonth" edit="#rc.edit#" />
					<cf_HibachiPropertyDisplay object="#rc.accountPaymentMethod#" property="expirationYear" edit="#rc.edit#" />
					<cf_HibachiPropertyDisplay object="#rc.accountPaymentMethod#" property="securityCode" edit="#rc.edit#" />
				</cf_HibachiDisplayToggle>
				
				<!--- Gift Card Details --->
				<cf_HibachiDisplayToggle selector="select[name='paymentMethod.paymentMethodID']" valueAttribute="paymentmethodtype" showValues="giftCard" loadVisable="#loadPaymentMethodType eq 'giftCard'#">
					<hr />
					<h5>#$.slatwall.rbKey('admin.define.giftCardDetails')#</h5>
					<cf_HibachiPropertyDisplay object="#rc.accountPaymentMethod#" property="giftCardNumber" edit="#rc.edit#" />
				</cf_HibachiDisplayToggle>
				
				<!--- Term Payment Details --->
				<!--- Just uses Billing Address --->
			</cf_HibachiPropertyList>
			<cf_HibachiPropertyList divClass="span6">
				<!--- Billing Address Details --->
				<cf_HibachiDisplayToggle selector="select[name='paymentMethod.paymentMethodID']" valueAttribute="paymentmethodtype" showValues="creditCard,termPayment" loadVisable="#listFindNoCase('creditCard,termPayment', loadPaymentMethodType)#">
					<h5>#$.slatwall.rbKey('entity.accountpaymentmethod.billingaddress')#</h5>
					<cf_SlatwallAdminAddressDisplay address="#rc.accountPaymentMethod.getBillingAddress()#" fieldNamePrefix="billingaddress." edit="#rc.edit#">
				</cf_HibachiDisplayToggle>
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
		
		<cf_HibachiTabGroup object="#rc.accountPaymentMethod#">
			<cf_HibachiTab property="paymentTransactions" />
		</cf_HibachiTabGroup>
	</cf_HibachiEntityDetailForm>
</cfoutput>
