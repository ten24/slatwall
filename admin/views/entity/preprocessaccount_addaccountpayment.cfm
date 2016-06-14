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
<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />


<cfparam name="rc.account" type="any" />
<cfparam name="rc.processObject" type="any" />
<cfparam name="rc.edit" type="boolean" />

<!--- Set AngularJS controller --->
<div ng-controller="preprocessaccount_addaccountpayment">
<cfoutput>
	<hb:HibachiEntityProcessForm entity="#rc.account#" edit="#rc.edit#" sRedirectAction="admin:entity.detailaccount" forceSSLFlag="#$.slatwall.setting('globalForceCreditCardOverSSL')#">
		
		<hb:HibachiEntityActionBar type="preprocess" object="#rc.account#" backAction="entity.detailaccount" backQueryString="accountID=#rc.account.getAccountID()#">
		</hb:HibachiEntityActionBar>
		
		<hb:HibachiPropertyRow>
			<hb:HibachiPropertyList>
				<hb:HibachiPropertyList divClass="col-md-6">
				<!--- Add a hidden field for the accountID --->
				<input type="hidden" name="newAccountPayment.account.accountID" value="#rc.account.getAccountID()#" />
				
				<hb:HibachiPropertyDisplay object="#rc.processObject.getNewAccountPayment()#" property="amount" fieldName="newAccountPayment.amount" edit="#rc.edit#"fieldAttributes="ng-model='amount' ng-change='updateSubTotal()' placeholder='0' ng-readonly='!paymentTypeLock'">
				<hb:HibachiPropertyDisplay object="#rc.processObject#" property="currencyCode" fieldName="newAccountPayment.currencyCode" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.processObject.getNewAccountPayment()#" property="accountPaymentType" fieldName="newAccountPayment.accountPaymentType.typeID" edit="#rc.edit#" fieldAttributes="ng-model='paymentType' ng-change='updatePaymentType()' ng-init='paymentType = ""444df32dd2b0583d59a19f1b77869025""'">
				<hb:HibachiPropertyDisplay object="#rc.processObject#" property="accountPaymentMethodID" edit="#rc.edit#">
				</hb:HibachiPropertyList>
				<hb:HibachiPropertyList divClass="col-md-6">
				<!--- New Payment Method --->
				<hb:HibachiDisplayToggle selector="select[name='accountPaymentMethodID']" showValues="" loadVisable="#!len(rc.processObject.getAccountPaymentMethodID())#">
					
					<input type="hidden" name="newAccountPayment.accountPaymentID" value="" />
					
					<!--- New Payment Type --->
					<hb:HibachiPropertyDisplay object="#rc.processObject.getNewAccountPayment()#" property="paymentMethod" fieldName="newAccountPayment.paymentMethod.paymentMethodID" valueOptions="#rc.processObject.getPaymentMethodIDOptions()#" edit="#rc.edit#">
					
					<!--- Save Account Payment as Account Payment Method --->
					<cfset loadVisable = rc.processObject.getNewAccountPayment().getPaymentMethodOptions()[1]['allowsave'] />
					<cfif !isNull(rc.processObject.getNewAccountPayment().getPaymentMethod())>
						<cfset loadVisable = rc.processObject.getNewAccountPayment().getPaymentMethod().getAllowSaveFlag() />
					</cfif>
					<hb:HibachiDisplayToggle selector="select[name='newAccountPayment.paymentMethod.paymentMethodID']" valueAttribute="allowsave" showValues="true" loadVisable="#loadVisable#">
						
						<!--- Save New Payment Method --->
						<hb:HibachiPropertyDisplay object="#rc.processObject#" property="saveAccountPaymentMethodFlag" edit="#rc.edit#" />
						
						<!--- Save New Address Name --->
						<hb:HibachiDisplayToggle selector="input[name='saveAccountPaymentMethodFlag']">
							<hb:HibachiPropertyDisplay object="#rc.processObject#" property="saveAccountPaymentMethodName" edit="#rc.edit#" />
						</hb:HibachiDisplayToggle>
					</hb:HibachiDisplayToggle>
					
					<cfset loadPaymentMethodType = rc.processObject.getNewAccountPayment().getPaymentMethodOptions()[1]['paymentmethodtype'] />
					<cfif !isNull(rc.processObject.getNewAccountPayment().getPaymentMethod())>
						<cfset loadPaymentMethodType = rc.processObject.getNewAccountPayment().getPaymentMethod().getPaymentMethodType() />
					</cfif>
					
					<!--- Credit Card Payment Details --->
					<hb:HibachiDisplayToggle selector="select[name='newAccountPayment.paymentMethod.paymentMethodID']" valueAttribute="paymentmethodtype" showValues="creditCard" loadVisable="#loadPaymentMethodType eq 'creditCard'#">
						<h5>#$.slatwall.rbKey('admin.define.creditCardDetails')#</h5>
						<hb:HibachiPropertyDisplay object="#rc.processObject.getNewAccountPayment()#" fieldName="newAccountPayment.creditCardNumber" property="creditCardNumber" edit="#rc.edit#">
						<hb:HibachiPropertyDisplay object="#rc.processObject.getNewAccountPayment()#" fieldName="newAccountPayment.nameOnCreditCard" property="nameOnCreditCard" edit="#rc.edit#">
						<hb:HibachiPropertyDisplay object="#rc.processObject.getNewAccountPayment()#" fieldName="newAccountPayment.expirationMonth" property="expirationMonth" edit="#rc.edit#">
						<hb:HibachiPropertyDisplay object="#rc.processObject.getNewAccountPayment()#" fieldName="newAccountPayment.expirationYear" property="expirationYear" edit="#rc.edit#">
						<hb:HibachiPropertyDisplay object="#rc.processObject.getNewAccountPayment()#" fieldName="newAccountPayment.securityCode" property="securityCode" edit="#rc.edit#">
					</hb:HibachiDisplayToggle>
					
					<!--- Term Payment Details --->
					<hb:HibachiDisplayToggle selector="select[name='newAccountPayment.paymentMethod.paymentMethodID']" valueAttribute="paymentmethodtype" showValues="termPayment" loadVisable="#loadPaymentMethodType eq 'termPayment'#">
						<h5>#$.slatwall.rbKey('admin.define.termPaymentDetails')#</h5>
						<hb:HibachiPropertyDisplay object="#rc.account#" property="termAccountBalance" edit="false">
						<hb:HibachiPropertyDisplay object="#rc.account#" property="termAccountAvailableCredit" edit="false">
					</hb:HibachiDisplayToggle>
					
					<!--- Gift Card Details --->
					<hb:HibachiDisplayToggle selector="select[name='newAccountPayment.paymentMethod.paymentMethodID']" valueAttribute="paymentmethodtype" showValues="giftCard" loadVisable="#loadPaymentMethodType eq 'giftCard'#">
						<h5>#$.slatwall.rbKey('admin.define.giftCardDetails')#</h5>
						<hb:HibachiPropertyDisplay object="#rc.processObject.getNewAccountPayment()#" fieldName="newAccountPayment.giftCardNumber" property="giftCardNumber" edit="#rc.edit#">
					</hb:HibachiDisplayToggle>
					
					<!--- Check Details --->
					<hb:HibachiDisplayToggle selector="select[name='newAccountPayment.paymentMethod.paymentMethodID']" valueAttribute="paymentmethodtype" showValues="check" loadVisable="#loadPaymentMethodType eq 'check'#">
						<h5>#$.slatwall.rbKey('admin.define.checkDetails')#</h5>
						<hb:HibachiPropertyDisplay object="#rc.processObject.getNewAccountPayment()#" fieldName="newAccountPayment.checkNumber" property="checkNumber" edit="#rc.edit#">
						<hb:HibachiPropertyDisplay object="#rc.processObject.getNewAccountPayment()#" fieldName="newAccountPayment.bankRoutingNumber" property="bankRoutingNumber" edit="#rc.edit#">
						<hb:HibachiPropertyDisplay object="#rc.processObject.getNewAccountPayment()#" fieldName="newAccountPayment.bankAccountNumber" property="bankAccountNumber" edit="#rc.edit#">
					</hb:HibachiDisplayToggle>
					
					<!--- Billing Address --->
					<hb:HibachiDisplayToggle selector="select[name='newAccountPayment.paymentMethod.paymentMethodID']" valueAttribute="paymentmethodtype" showValues="creditCard,check,termPayment" loadVisable="#listFindNoCase('creditCard,check,termPayment', loadPaymentMethodType)#">
						<h5>#$.slatwall.rbKey('entity.accountPayment.billingAddress')#</h5>
						<hb:HibachiPropertyDisplay object="#rc.processObject#" property="accountAddressID" edit="#rc.edit#">
						<hb:HibachiDisplayToggle selector="select[name='accountAddressID']" showValues="" loadVisable="#!len(rc.processObject.getAccountAddressID())#">
							<swa:SlatwallAdminAddressDisplay address="#rc.processObject.getNewAccountPayment().getBillingAddress()#" fieldNamePrefix="newAccountPayment.billingAddress." edit="#rc.edit#" />
						</hb:HibachiDisplayToggle>	
					</hb:HibachiDisplayToggle>
				</hb:HibachiDisplayToggle>
				</hb:HibachiPropertyList>
			</hb:HibachiPropertyList>
			
		</hb:HibachiPropertyRow>
		
		<cfset orderPaymentList = rc.account.getTermOrderPaymentsByDueDateSmartList() />

		<br /><br />
		<table class="table table-bordered table-hover">
			<tr>
				<th>#$.slatwall.rbKey('entity.AccountPayment.termOffsetOrderNum')#</th>
				<th>#$.slatwall.rbKey('entity.AccountPayment.termOffsetTerm')#</th>
				<th>#$.slatwall.rbKey('entity.AccountPayment.termOffsetDueDate')#</th>
				<th>#$.slatwall.rbKey('entity.AccountPayment.termOffsetTotalAmount')#</th>
				<th>#$.slatwall.rbKey('entity.AccountPayment.termOffsetReceived')#</th>
				<th>#$.slatwall.rbKey('entity.AccountPayment.termOffsetUnReceived')#</th>
				<th>#$.slatwall.rbKey('entity.Account.Type')#</th>
				<th>#$.slatwall.rbKey('entity.AccountPayment.termOffsetAmount')#</th>
				
			</tr>
			<cfset i=0 />
			<cfset orderPaymentAmount=0 />
			<cfset orderPaymentRecieved=0 />
			<cfset orderPaymentUnrecieved=0 />
			
			<cfloop array="#orderPaymentList.getRecords()#" index="orderPayment">
				<cfset i++ />
				<tr>
					<td>
						<cfif 	!isNull(orderPayment.getOrder()) 
								&& !isNull(orderPayment.getOrder().getOrderNumber())
						>
							#orderPayment.getOrder().getOrderNumber()#
						</cfif>
					</td>
					<td>
						<cfif 	!isNull(orderPayment.getPaymentTerm()) 
								&& !isNull(orderPayment.getPaymentTerm().getPaymentTermName())
						>
							#orderPayment.getPaymentTerm().getPaymentTermName()#
						</cfif>
					</td>
					<td>#orderPayment.getFormattedValue('paymentDueDate', 'date' )#</td>
					<td>#orderPayment.getOrder().getFormattedValue('paymentAmountTotal')#</td>
					<td>#orderPayment.getOrder().getFormattedValue('paymentAmountReceivedTotal')#</td>
					<td>#orderPayment.getOrder().getFormattedValue('paymentAmountDue')#</td>
					
					<td>
						<hb:HibachiFormField fieldType='select' fieldName='appliedOrderPayments[#i#].paymentTypeID' valueOptions='#rc.processObject.getNewAccountPayment().getAccountPaymentAppliedOptions()#' fieldAttributes="ng-model='appliedOrderPayment.input#i#.paymentType' ng-hide='paymentTypeLock' ng-change='updateSubTotal()' ng-init='appliedOrderPayment.input#i#.paymentType = ""444df32dd2b0583d59a19f1b77869025""'" />
						<div ng-if="paymentTypeLock">{{paymentTypeName}}</div>
					</td>
					<td>
						<input type="number" name="appliedOrderPayments[#i#].amount" class="span1" ng-model="appliedOrderPayment.input#i#.amount" placeholder="0" min="0" step="0.01" ng-change="updateSubTotal()" />
						<input type="hidden" name="appliedOrderPayments[#i#].orderPaymentID" value="#orderPayment.getOrderPaymentID()#" />
					</td>
				</tr>
				
				<cfset orderPaymentAmount = orderPaymentAmount + orderPayment.getOrder().getPaymentAmountTotal() />
				<cfset orderPaymentRecieved = orderPaymentRecieved + orderPayment.getOrder().getPaymentAmountReceivedTotal() />
				<cfset orderPaymentUnrecieved = orderPaymentUnrecieved + orderPayment.getOrder().getPaymentAmountDue() />
			</cfloop>
			
			<tr>
				<td><strong>#$.slatwall.rbKey('entity.AccountPayment.termOffsetTotals')#</strong></td>
				<td colspan="2"></td>
				<td><strong>#NumberFormat(orderPaymentAmount, '0.00')#</strong></td>
				<td><strong>#NumberFormat(orderPaymentRecieved, '0.00')#</strong></td>
				<td><strong>#NumberFormat(orderPaymentUnrecieved, '0.00')#</strong></td>
				<td><strong>#$.slatwall.rbKey('entity.AccountPayment.termOffsetUnassigned')#</strong><br />

				<div ng-if="amountUnapplied != 0 && amountUnapplied != null">
					<strong class='text-error span2'>#$.slatwall.rbKey('entity.AccountPayment.termOffsetUnappliedWarning1')# {{amountUnapplied | number:2}} #$.slatwall.rbKey('entity.AccountPayment.termOffsetUnappliedWarning2')#</strong>
				</div>
				</td>
				<td>
					<input type="text" name="appliedOrderPayments[#i+1#].amount" class="uneditable-input span1" placeholder="0" readonly ng-model="amountUnapplied" />
					<input type="hidden" name="appliedOrderPayments[#i+1#].orderPaymentID" value="" />
				</td>
			</tr>
			<tr>
 				<td colspan="6"></td>
 				<td><strong>#$.slatwall.rbKey('entity.AccountPayment.termOffsetTotal')# {{paymentTypeName}} #$.slatwall.rbKey('entity.AccountPayment.termOffsetAmount')#</strong></td>
 				<td>{{amount | number:2}}</td>
 			</tr>
 			<tr>
 				<td colspan="6"></td>
 				<td><strong>#$.slatwall.rbKey('entity.AccountPayment.termOffsetAccountBalance')#</strong></td>
 				<td>{{#rc.account.getTermAccountBalance()# + accountBalanceChange | number:2}}</td>
 			</tr>				
		</table>
	</hb:HibachiEntityProcessForm>
</cfoutput>
</div>
