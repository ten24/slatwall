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
<cfparam name="rc.subscriptionUsage" type="any" />
<cfparam name="rc.processObject" type="any" />

<cfoutput>
	<cf_HibachiEntityProcessForm entity="#rc.subscriptionUsage#" edit="#rc.edit#" sRedirectAction="admin:entity.detailSubscriptionUsage">
		
		<cf_HibachiEntityActionBar type="preprocess" object="#rc.subscriptionUsage#">
		</cf_HibachiEntityActionBar>
		
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList>
				<!--- Extend or Prorate --->
				<cf_HibachiPropertyDisplay object="#rc.processObject#" property="renewalStartType" edit="true" />
				
				<!--- Extend Details --->
				<cf_HibachiDisplayToggle selector="select[name='renewalStartType']" showValues="extend" loadVisable="#rc.processObject.getRenewalStartType() eq 'extend'#">
					<cf_HibachiPropertyDisplay object="#rc.subscriptionUsage#" property="renewalPrice" edit="false" />
					<cf_HibachiPropertyDisplay object="#rc.processObject#" property="extendExpirationDate" edit="false" />
				</cf_HibachiDisplayToggle>
				
				<!--- Prorate Details --->
				<cf_HibachiDisplayToggle selector="select[name='renewalStartType']" showValues="prorate" loadVisable="#rc.processObject.getRenewalStartType() eq 'prorate'#">
					<cf_HibachiPropertyDisplay object="#rc.processObject#" property="proratedPrice" edit="false" />
					<cf_HibachiPropertyDisplay object="#rc.processObject#" property="prorateExpirationDate" edit="false" />
				</cf_HibachiDisplayToggle>
				
				<hr />
				
				<cf_HibachiPropertyDisplay object="#rc.processObject#" property="renewalPaymentType" edit="true" />
				
				<!--- Copy Account Payment Method --->
				<cf_HibachiDisplayToggle selector="select[name='renewalPaymentType']" showValues="accountPaymentMethod" loadVisable="#rc.processObject.getRenewalPaymentType() eq 'accountPaymentMethod'#">
					<cf_HibachiPropertyDisplay object="#rc.processObject#" property="accountPaymentMethod" edit="true" />	
				</cf_HibachiDisplayToggle>
				
				<!--- Copy Order Payment --->
				<cf_HibachiDisplayToggle selector="select[name='renewalPaymentType']" showValues="orderPayment" loadVisable="#rc.processObject.getRenewalPaymentType() eq 'orderPayment'#">
					<cf_HibachiPropertyDisplay object="#rc.processObject#" property="orderPayment" edit="true" />
				</cf_HibachiDisplayToggle>
				
				<!--- New Order Payment --->
				<cf_HibachiDisplayToggle selector="select[name='renewalPaymentType']" showValues="new" loadVisable="#rc.processObject.getRenewalPaymentType() eq 'new'#">
					
					<input type="hidden" name="newOrderPayment.orderPaymentID" value="" />
		
					<!--- New Payment Type --->
					<cf_HibachiPropertyDisplay object="#rc.processObject.getNewOrderPayment()#" property="paymentMethod" fieldName="newOrderPayment.paymentMethod.paymentMethodID" edit="#rc.edit#">
					
					<cfset loadPaymentMethodType = rc.processObject.getNewOrderPayment().getPaymentMethodOptions()[1]['paymentmethodtype'] />
					<cfif !isNull(rc.processObject.getNewOrderPayment().getPaymentMethod())>
						<cfset loadPaymentMethodType = rc.processObject.getNewOrderPayment().getPaymentMethod().getPaymentMethodType() />
					</cfif>
					
					<!--- Credit Card Payment Details --->
					<cf_HibachiDisplayToggle selector="select[name='newOrderPayment.paymentMethod.paymentMethodID']" valueAttribute="paymentmethodtype" showValues="creditCard" loadVisable="#loadPaymentMethodType eq 'creditCard'#">
						<h5>#$.slatwall.rbKey('admin.define.creditCardDetails')#</h5>
						<cf_HibachiPropertyDisplay object="#rc.processObject.getNewOrderPayment()#" fieldName="newOrderPayment.creditCardNumber" property="creditCardNumber" edit="#rc.edit#">
						<cf_HibachiPropertyDisplay object="#rc.processObject.getNewOrderPayment()#" fieldName="newOrderPayment.nameOnCreditCard" property="nameOnCreditCard" edit="#rc.edit#">
						<cf_HibachiPropertyDisplay object="#rc.processObject.getNewOrderPayment()#" fieldName="newOrderPayment.expirationMonth" property="expirationMonth" edit="#rc.edit#">
						<cf_HibachiPropertyDisplay object="#rc.processObject.getNewOrderPayment()#" fieldName="newOrderPayment.expirationYear" property="expirationYear" edit="#rc.edit#">
						<cf_HibachiPropertyDisplay object="#rc.processObject.getNewOrderPayment()#" fieldName="newOrderPayment.securityCode" property="securityCode" edit="#rc.edit#">
					</cf_HibachiDisplayToggle>
					
					<!--- Term Payment Details --->
					<cf_HibachiDisplayToggle selector="select[name='newOrderPayment.paymentMethod.paymentMethodID']" valueAttribute="paymentmethodtype" showValues="termPayment" loadVisable="#loadPaymentMethodType eq 'termPayment'#">
						<h5>#$.slatwall.rbKey('admin.define.termPaymentDetails')#</h5>
						<cf_HibachiPropertyDisplay object="#rc.subscriptionUsage.getAccount()#" property="termAccountBalance" edit="false">
						<cf_HibachiPropertyDisplay object="#rc.subscriptionUsage.getAccount()#" property="termAccountAvailableCredit" edit="false">
					</cf_HibachiDisplayToggle>
					
					<!--- Gift Card Details --->
					<cf_HibachiDisplayToggle selector="select[name='newOrderPayment.paymentMethod.paymentMethodID']" valueAttribute="paymentmethodtype" showValues="giftCard" loadVisable="#loadPaymentMethodType eq 'giftCard'#">
						<h5>#$.slatwall.rbKey('admin.define.giftCardDetails')#</h5>
						<cf_HibachiPropertyDisplay object="#rc.processObject.getNewOrderPayment()#" fieldName="newOrderPayment.giftCardNumber" property="giftCardNumber" edit="#rc.edit#">
					</cf_HibachiDisplayToggle>
					
					<!--- Check Details --->
					<cf_HibachiDisplayToggle selector="select[name='newOrderPayment.paymentMethod.paymentMethodID']" valueAttribute="paymentmethodtype" showValues="check" loadVisable="#loadPaymentMethodType eq 'check'#">
						<h5>#$.slatwall.rbKey('admin.define.checkDetails')#</h5>
						<cf_HibachiPropertyDisplay object="#rc.processObject.getNewOrderPayment()#" fieldName="newOrderPayment.checkNumber" property="checkNumber" edit="#rc.edit#">
						<cf_HibachiPropertyDisplay object="#rc.processObject.getNewOrderPayment()#" fieldName="newOrderPayment.bankRoutingNumber" property="bankRoutingNumber" edit="#rc.edit#">
						<cf_HibachiPropertyDisplay object="#rc.processObject.getNewOrderPayment()#" fieldName="newOrderPayment.bankAccountNumber" property="bankAccountNumber" edit="#rc.edit#">
					</cf_HibachiDisplayToggle>
					
					<!--- Billing Address --->
					<cf_HibachiDisplayToggle selector="select[name='newOrderPayment.paymentMethod.paymentMethodID']" valueAttribute="paymentmethodtype" showValues="creditCard,check,termPayment" loadVisable="#listFindNoCase('creditCard,check,termPayment', loadPaymentMethodType)#">
						<h5>#$.slatwall.rbKey('entity.orderPayment.billingAddress')#</h5>
						<cf_SlatwallAdminAddressDisplay address="#rc.processObject.getNewOrderPayment().getBillingAddress()#" filedNamePrefix="newOrderPayment.billingAddresss." edit="#rc.edit#" />
					</cf_HibachiDisplayToggle>
					
					<!--- Save Order Payment as Account Payment Method --->
					<cfset loadVisable = rc.processObject.getNewOrderPayment().getPaymentMethodOptions()[1]['allowsave'] />
					<cfif !isNull(rc.processObject.getNewOrderPayment().getPaymentMethod())>
						<cfset loadVisable = rc.processObject.getNewOrderPayment().getPaymentMethod().getAllowSaveFlag() />
					</cfif>
					<cf_HibachiDisplayToggle selector="select[name='newOrderPayment.paymentMethod.paymentMethodID']" valueAttribute="allowsave" showValues="YES" loadVisable="#loadVisable#">
						
						<hr />
						
						<!--- Save New Payment Method --->
						<cf_HibachiPropertyDisplay object="#rc.processObject#" property="saveAccountPaymentMethodFlag" edit="#rc.edit#" />
						
						<!--- Save New Address Name --->
						<cf_HibachiDisplayToggle selector="input[name='saveAccountPaymentMethodFlag']" loadVisable="#rc.processObject.getValueByPropertyIdentifier('saveAccountPaymentMethodFlag')#">
							<cf_HibachiPropertyDisplay object="#rc.processObject#" property="saveAccountPaymentMethodName" edit="#rc.edit#" />
							<cf_HibachiPropertyDisplay object="#rc.processObject#" property="updateSubscriptionUsageAccountPaymentMethodFlag" edit="#rc.edit#" />
						</cf_HibachiDisplayToggle>
					</cf_HibachiDisplayToggle>
				</cf_HibachiDisplayToggle>
						
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
		
	</cf_HibachiEntityProcessForm>
</cfoutput>
