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
<cfparam name="rc.account" type="any" />
<cfparam name="rc.processObject" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cf_HibachiEntityProcessForm entity="#rc.account#" edit="#rc.edit#" sRedirectAction="admin:entity.detailaccount">
		
		<cf_HibachiEntityActionBar type="preprocess" object="#rc.account#">
		</cf_HibachiEntityActionBar>
		
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList>
				<cf_HibachiPropertyList divClass="span6">
				<!--- Add a hidden field for the accountID --->
				<input type="hidden" name="newAccountPayment.account.accountID" value="#rc.account.getAccountID()#" />
				
				<!---<cf_HibachiPropertyDisplay object="#rc.processObject.getNewAccountPayment()#" property="amount" fieldName="newAccountPayment.amount" edit="#rc.edit#">--->
				<cf_HibachiPropertyDisplay object="#rc.processObject#" property="currencyCode" fieldName="newAccountPayment.currencyCode" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.processObject.getNewAccountPayment()#" property="accountPaymentType" fieldName="newAccountPayment.accountPaymentType.typeID" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.processObject#" property="accountPaymentMethodID" edit="#rc.edit#">
				</cf_HibachiPropertyList>
				<cf_HibachiPropertyList divClass="span6">
				<!--- New Payment Method --->
				<cf_HibachiDisplayToggle selector="select[name='accountPaymentMethodID']" showValues="" loadVisable="#!len(rc.processObject.getAccountPaymentMethodID())#">
					
					<input type="hidden" name="newAccountPayment.accountPaymentID" value="" />
					
					<!--- New Payment Type --->
					<cf_HibachiPropertyDisplay object="#rc.processObject.getNewAccountPayment()#" property="paymentMethod" fieldName="newAccountPayment.paymentMethod.paymentMethodID" valueOptions="#rc.processObject.getPaymentMethodIDOptions()#" edit="#rc.edit#">
					
					<!--- Save Account Payment as Account Payment Method --->
					<cfset loadVisable = rc.processObject.getNewAccountPayment().getPaymentMethodOptions()[1]['allowsave'] />
					<cfif !isNull(rc.processObject.getNewAccountPayment().getPaymentMethod())>
						<cfset loadVisable = rc.processObject.getNewAccountPayment().getPaymentMethod().getAllowSaveFlag() />
					</cfif>
					<cf_HibachiDisplayToggle selector="select[name='newAccountPayment.paymentMethod.paymentMethodID']" valueAttribute="allowsave" showValues="true" loadVisable="#loadVisable#">
						
						<!--- Save New Payment Method --->
						<cf_HibachiPropertyDisplay object="#rc.processObject#" property="saveAccountPaymentMethodFlag" edit="#rc.edit#" />
						
						<!--- Save New Address Name --->
						<cf_HibachiDisplayToggle selector="input[name='saveAccountPaymentMethodFlag']">
							<cf_HibachiPropertyDisplay object="#rc.processObject#" property="saveAccountPaymentMethodName" edit="#rc.edit#" />
						</cf_HibachiDisplayToggle>
					</cf_HibachiDisplayToggle>
					
					<cfset loadPaymentMethodType = rc.processObject.getNewAccountPayment().getPaymentMethodOptions()[1]['paymentmethodtype'] />
					<cfif !isNull(rc.processObject.getNewAccountPayment().getPaymentMethod())>
						<cfset loadPaymentMethodType = rc.processObject.getNewAccountPayment().getPaymentMethod().getPaymentMethodType() />
					</cfif>
					
					<!--- Credit Card Payment Details --->
					<cf_HibachiDisplayToggle selector="select[name='newAccountPayment.paymentMethod.paymentMethodID']" valueAttribute="paymentmethodtype" showValues="creditCard" loadVisable="#loadPaymentMethodType eq 'creditCard'#">
						<h5>#$.slatwall.rbKey('admin.define.creditCardDetails')#</h5>
						<cf_HibachiPropertyDisplay object="#rc.processObject.getNewAccountPayment()#" fieldName="newAccountPayment.creditCardNumber" property="creditCardNumber" edit="#rc.edit#">
						<cf_HibachiPropertyDisplay object="#rc.processObject.getNewAccountPayment()#" fieldName="newAccountPayment.nameOnCreditCard" property="nameOnCreditCard" edit="#rc.edit#">
						<cf_HibachiPropertyDisplay object="#rc.processObject.getNewAccountPayment()#" fieldName="newAccountPayment.expirationMonth" property="expirationMonth" edit="#rc.edit#">
						<cf_HibachiPropertyDisplay object="#rc.processObject.getNewAccountPayment()#" fieldName="newAccountPayment.expirationYear" property="expirationYear" edit="#rc.edit#">
						<cf_HibachiPropertyDisplay object="#rc.processObject.getNewAccountPayment()#" fieldName="newAccountPayment.securityCode" property="securityCode" edit="#rc.edit#">
					</cf_HibachiDisplayToggle>
					
					<!--- Term Payment Details --->
					<cf_HibachiDisplayToggle selector="select[name='newAccountPayment.paymentMethod.paymentMethodID']" valueAttribute="paymentmethodtype" showValues="termPayment" loadVisable="#loadPaymentMethodType eq 'termPayment'#">
						<h5>#$.slatwall.rbKey('admin.define.termPaymentDetails')#</h5>
						<cf_HibachiPropertyDisplay object="#rc.account#" property="termAccountBalance" edit="false">
						<cf_HibachiPropertyDisplay object="#rc.account#" property="termAccountAvailableCredit" edit="false">
					</cf_HibachiDisplayToggle>
					
					<!--- Gift Card Details --->
					<cf_HibachiDisplayToggle selector="select[name='newAccountPayment.paymentMethod.paymentMethodID']" valueAttribute="paymentmethodtype" showValues="giftCard" loadVisable="#loadPaymentMethodType eq 'giftCard'#">
						<h5>#$.slatwall.rbKey('admin.define.giftCardDetails')#</h5>
						<cf_HibachiPropertyDisplay object="#rc.processObject.getNewAccountPayment()#" fieldName="newAccountPayment.giftCardNumber" property="giftCardNumber" edit="#rc.edit#">
					</cf_HibachiDisplayToggle>
					
					<!--- Check Details --->
					<cf_HibachiDisplayToggle selector="select[name='newAccountPayment.paymentMethod.paymentMethodID']" valueAttribute="paymentmethodtype" showValues="check" loadVisable="#loadPaymentMethodType eq 'check'#">
						<h5>#$.slatwall.rbKey('admin.define.checkDetails')#</h5>
						<cf_HibachiPropertyDisplay object="#rc.processObject.getNewAccountPayment()#" fieldName="newAccountPayment.checkNumber" property="checkNumber" edit="#rc.edit#">
						<cf_HibachiPropertyDisplay object="#rc.processObject.getNewAccountPayment()#" fieldName="newAccountPayment.bankRoutingNumber" property="bankRoutingNumber" edit="#rc.edit#">
						<cf_HibachiPropertyDisplay object="#rc.processObject.getNewAccountPayment()#" fieldName="newAccountPayment.bankAccountNumber" property="bankAccountNumber" edit="#rc.edit#">
					</cf_HibachiDisplayToggle>
					
					<!--- Billing Address --->
					<cf_HibachiDisplayToggle selector="select[name='newAccountPayment.paymentMethod.paymentMethodID']" valueAttribute="paymentmethodtype" showValues="creditCard,check,termPayment" loadVisable="#listFindNoCase('creditCard,check,termPayment', loadPaymentMethodType)#">
						<h5>#$.slatwall.rbKey('entity.accountPayment.billingAddress')#</h5>
						<cf_HibachiPropertyDisplay object="#rc.processObject#" property="accountAddressID" edit="#rc.edit#">
						<cf_HibachiDisplayToggle selector="select[name='accountAddressID']" showValues="" loadVisable="#!len(rc.processObject.getAccountAddressID())#">
							<cf_SlatwallAdminAddressDisplay address="#rc.processObject.getNewAccountPayment().getBillingAddress()#" fieldNamePrefix="newAccountPayment.billingAddress." edit="#rc.edit#" />
						</cf_HibachiDisplayToggle>	
					</cf_HibachiDisplayToggle>
				</cf_HibachiDisplayToggle>
				</cf_HibachiPropertyList>
			</cf_HibachiPropertyList>
			
		</cf_HibachiPropertyRow>
		
		<cfset orderList = rc.account.getTermOrderPaymentsByDueDateSmartList() />
		
		<!---<cfdump var=#orderList# top=3 />--->
		
		<br /><br />
		<table class="table table-striped table-bordered table-condensed">
			<tr>
				<th>Order Number</th>
				<th>Order Payment Amount</th>
				<th>Amount Unrecieved</th>
				<th>Amount to Apply</th>
			</tr>
				
			<cfloop array="#orderList.getRecords()#" index="orderItem">
				<tr>
					<td><!---#orderItem.getOrderNumber()#---></td>
					<td><!---#orderItem.getPaymentAmountReceivedTotal()#---></td>
					<td><!---#orderItem.getPaymentAmountDue()#---></td>
					<td><input type="text" name="toBePaid" value="" class="span1" /></td>
				</tr>
			</cfloop>
				
			<tr>
				<td colspan="3"><strong>(Additional Unassigned Amount)</td>
				<td><input type="text" name="toBePaid" value="" class="span1" /></td>
			</tr>	
				
		</table>
		
	</cf_HibachiEntityProcessForm>
</cfoutput>
