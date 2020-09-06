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
<cfimport prefix="swa" taglib="../../../tags"/>
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags"/>

<cfparam name="rc.account" type="any"/>
<cfparam name="rc.processObject" type="any"/>
<cfparam name="rc.edit" type="boolean"/>

<!--- Set AngularJS controller --->
<div ng-controller="preprocessaccount_addaccountpayment">
	<cfoutput>
		<hb:hibachientityprocessform entity="#rc.account#" edit="#rc.edit#" 
		                             sredirectaction="admin:entity.detailaccount" 
		                             forcesslflag="#$.slatwall.setting('globalForceCreditCardOverSSL')#">
		
			<hb:hibachientityactionbar type="preprocess" object="#rc.account#" 
			                           backaction="entity.detailaccount" 
			                           backquerystring="accountID=#rc.account.getAccountID()#">
			</hb:hibachientityactionbar>
			
			<hb:hibachipropertyrow>
				<hb:hibachipropertylist>
					<hb:hibachipropertylist divclass="col-md-6">
						<!--- Add a hidden field for the accountID --->
						<input type="hidden" name="newAccountPayment.account.accountID" 
						       value="#rc.account.getAccountID()#"/>
						
						<hb:hibachipropertydisplay object="#rc.processObject.getNewAccountPayment()#" 
						                           property="amount" fieldname="newAccountPayment.amount" 
						                           edit="#rc.edit#" 
						                           fieldattributes="ng-model='amount' ng-change='updateSubTotal()' placeholder='0' ng-readonly='!paymentTypeLock'">
						<hb:hibachipropertydisplay object="#rc.processObject#" property="currencyCode" 
						                           fieldname="newAccountPayment.currencyCode" edit="#rc.edit#">
						<hb:hibachipropertydisplay object="#rc.processObject.getNewAccountPayment()#" 
						                           property="accountPaymentType" 
						                           fieldname="newAccountPayment.accountPaymentType.typeID" 
						                           edit="#rc.edit#" 
						                           fieldattributes="ng-model='paymentType' ng-change='updatePaymentType()' ng-init='paymentType = ""444df32dd2b0583d59a19f1b77869025""'">
						<hb:hibachidisplaytoggle selector="select[name='newAccountPayment.accountPaymentType.typeID']" 
						                         loadvisable="#true#" 
						                         showvalues="444df32e9b448ea196c18c66e1454c46,444df32dd2b0583d59a19f1b77869025">
							<hb:hibachipropertydisplay object="#rc.processObject#" property="accountPaymentMethodID" 
							                           edit="#rc.edit#">
						</hb:hibachidisplaytoggle>
					</hb:hibachipropertylist>
					<input type="hidden" name="newAccountPayment.accountPaymentID" value=""/>
					<hb:hibachidisplaytoggle selector="select[name='newAccountPayment.accountPaymentType.typeID']" 
					                         loadvisable="#true#" 
					                         showvalues="444df32e9b448ea196c18c66e1454c46,444df32dd2b0583d59a19f1b77869025">
						<hb:hibachipropertylist divclass="col-md-6">
							<!--- New Payment Method --->
							<hb:hibachidisplaytoggle selector="select[name='accountPaymentMethodID']" 
							                         loadvisable="#len(rc.processObject.getAccountPaymentMethodID()) < 1#">
							
								<!--- New Payment Type --->
								<hb:hibachipropertydisplay object="#rc.processObject.getNewAccountPayment()#" 
								                           property="paymentMethod" 
								                           fieldname="newAccountPayment.paymentMethod.paymentMethodID" 
								                           valueoptions="#rc.processObject.getPaymentMethodIDOptions()#" 
								                           edit="#rc.edit#">
								
								<!--- Save Account Payment as Account Payment Method --->
								<cfset loadVisable = arrayLen(rc.processObject.getNewAccountPayment().getPaymentMethodOptions()) 
								                     && structKeyExists(rc.processObject.getNewAccountPayment().getPaymentMethodOptions()[1], 
								                                        'allowsave') && rc.processObject.getNewAccountPayment().getPaymentMethodOptions()[1]['allowsave']/>
								<cfif !isNull(rc.processObject.getNewAccountPayment().getPaymentMethod())>
									<cfset loadVisable = rc.processObject.getNewAccountPayment().getPaymentMethod().getAllowSaveFlag()/>
								</cfif>
								<hb:hibachidisplaytoggle selector="select[name='newAccountPayment.paymentMethod.paymentMethodID']" 
								                         valueattribute="allowsave" showvalues="true" 
								                         loadvisable="#loadVisable#">
								
									<!--- Save New Payment Method --->
									<hb:hibachipropertydisplay object="#rc.processObject#" 
									                           property="saveAccountPaymentMethodFlag" edit="#rc.edit#"/>
									
									<!--- Save New Address Name --->
									<hb:hibachidisplaytoggle selector="input[name='saveAccountPaymentMethodFlag']">
										<hb:hibachipropertydisplay object="#rc.processObject#" 
										                           property="saveAccountPaymentMethodName" edit="#rc.edit#"/>
									</hb:hibachidisplaytoggle>
								</hb:hibachidisplaytoggle>
								
								<cfset loadPaymentMethodType = arrayLen(rc.processObject.getNewAccountPayment().getPaymentMethodOptions()) 
								                               && structKeyExists(rc.processObject.getNewAccountPayment().getPaymentMethodOptions()[1], 
								                                                  'paymentmethodtype') && !isNull(rc.processObject.getNewAccountPayment().getPaymentMethodOptions()[1]['paymentmethodtype'])/>
								<cfif !isNull(rc.processObject.getNewAccountPayment().getPaymentMethod())>
									<cfset loadPaymentMethodType = rc.processObject.getNewAccountPayment().getPaymentMethod().getPaymentMethodType()/>
								<cfelse>
									<cfset loadPaymentMethodType = rc.processObject.getPaymentMethodIDOptions()[1]['paymentmethodtype']/>
								</cfif>
								<!--- Credit Card Payment Details --->
								<hb:hibachidisplaytoggle selector="select[name='newAccountPayment.paymentMethod.paymentMethodID']" 
								                         valueattribute="paymentmethodtype" showvalues="creditCard" 
								                         loadvisable="#loadPaymentMethodType eq 'creditCard'#">
									<h5>
										#$.slatwall.rbKey('admin.define.creditCardDetails')#
									</h5>
									<hb:hibachipropertydisplay object="#rc.processObject.getNewAccountPayment()#" 
									                           fieldname="newAccountPayment.creditCardNumber" 
									                           property="creditCardNumber" edit="#rc.edit#">
									<hb:hibachipropertydisplay object="#rc.processObject.getNewAccountPayment()#" 
									                           fieldname="newAccountPayment.nameOnCreditCard" 
									                           property="nameOnCreditCard" edit="#rc.edit#">
									<hb:hibachipropertydisplay object="#rc.processObject.getNewAccountPayment()#" 
									                           fieldname="newAccountPayment.expirationMonth" 
									                           property="expirationMonth" edit="#rc.edit#">
									<hb:hibachipropertydisplay object="#rc.processObject.getNewAccountPayment()#" 
									                           fieldname="newAccountPayment.expirationYear" 
									                           property="expirationYear" edit="#rc.edit#">
									<hb:hibachipropertydisplay object="#rc.processObject.getNewAccountPayment()#" 
									                           fieldname="newAccountPayment.securityCode" 
									                           property="securityCode" edit="#rc.edit#">
								</hb:hibachidisplaytoggle>
								
								<!--- Term Payment Details --->
								<hb:hibachidisplaytoggle selector="select[name='newAccountPayment.paymentMethod.paymentMethodID']" 
								                         valueattribute="paymentmethodtype" showvalues="termPayment" 
								                         loadvisable="#loadPaymentMethodType eq 'termPayment'#">
									<h5>
										#$.slatwall.rbKey('admin.define.termPaymentDetails')#
									</h5>
									<hb:hibachipropertydisplay object="#rc.account#" property="termAccountBalance" edit="false">
									<hb:hibachipropertydisplay object="#rc.account#" property="termAccountAvailableCredit" 
									                           edit="false">
								</hb:hibachidisplaytoggle>
								
								<!--- Gift Card Details --->
								<hb:hibachidisplaytoggle selector="select[name='newAccountPayment.paymentMethod.paymentMethodID']" 
								                         valueattribute="paymentmethodtype" showvalues="giftCard" 
								                         loadvisable="#loadPaymentMethodType eq 'giftCard'#">
									<h5>
										#$.slatwall.rbKey('admin.define.giftCardDetails')#
									</h5>
									<hb:hibachipropertydisplay object="#rc.processObject.getNewAccountPayment()#" 
									                           fieldname="newAccountPayment.giftCardNumber" 
									                           property="giftCardNumber" edit="#rc.edit#">
								</hb:hibachidisplaytoggle>
								
								<!--- Check Details --->
								<hb:hibachidisplaytoggle selector="select[name='newAccountPayment.paymentMethod.paymentMethodID']" 
								                         valueattribute="paymentmethodtype" showvalues="check" 
								                         loadvisable="#loadPaymentMethodType eq 'check'#">
									<h5>
										#$.slatwall.rbKey('admin.define.checkDetails')#
									</h5>
									<hb:hibachipropertydisplay object="#rc.processObject.getNewAccountPayment()#" 
									                           fieldname="newAccountPayment.checkNumber" property="checkNumber" 
									                           edit="#rc.edit#">
									<hb:hibachipropertydisplay object="#rc.processObject.getNewAccountPayment()#" 
									                           fieldname="newAccountPayment.bankRoutingNumber" 
									                           property="bankRoutingNumber" edit="#rc.edit#">
									<hb:hibachipropertydisplay object="#rc.processObject.getNewAccountPayment()#" 
									                           fieldname="newAccountPayment.bankAccountNumber" 
									                           property="bankAccountNumber" edit="#rc.edit#">
								</hb:hibachidisplaytoggle>
								
								<!--- Billing Address --->
								<hb:hibachidisplaytoggle selector="select[name='newAccountPayment.paymentMethod.paymentMethodID']" 
								                         valueattribute="paymentmethodtype" 
								                         showvalues="creditCard,check,termPayment" 
								                         loadvisable="#listFindNoCase('creditCard,check,termPayment', loadPaymentMethodType)#">
									<h5>
										#$.slatwall.rbKey('entity.accountPayment.billingAddress')#
									</h5>
									<hb:hibachipropertydisplay object="#rc.processObject#" property="accountAddressID" 
									                           edit="#rc.edit#">
									<hb:hibachidisplaytoggle selector="select[name='accountAddressID']" showvalues="" 
									                         loadvisable="#!len(rc.processObject.getAccountAddressID())#">
										<swa:slatwalladminaddressdisplay address="#rc.processObject.getNewAccountPayment().getBillingAddress()#" 
										                                 fieldnameprefix="newAccountPayment.billingAddress." 
										                                 edit="#rc.edit#"/>
									</hb:hibachidisplaytoggle>
								</hb:hibachidisplaytoggle>
							</hb:hibachidisplaytoggle>
						</hb:hibachipropertylist>
					</hb:hibachidisplaytoggle>
				</hb:hibachipropertylist>
			</hb:hibachipropertyrow>
			
			<cfset orderPaymentList = rc.account.getTermOrderPaymentsByDueDateSmartList()/>
		
			<br/>
			<br/>
			<table class="table table-bordered table-hover">
				<tr>
					<th>
						#$.slatwall.rbKey('entity.AccountPayment.termOffsetOrderNum')#
					</th>
					<th>
						#$.slatwall.rbKey('entity.AccountPayment.termOffsetTerm')#
					</th>
					<th>
						#$.slatwall.rbKey('entity.AccountPayment.termOffsetDueDate')#
					</th>
					<th>
						#$.slatwall.rbKey('entity.AccountPayment.termOffsetTotalAmount')#
					</th>
					<th>
						#$.slatwall.rbKey('entity.AccountPayment.termOffsetReceived')#
					</th>
					<th>
						#$.slatwall.rbKey('entity.AccountPayment.termOffsetCredited')#
					</th>
					<th>
						#$.slatwall.rbKey('entity.AccountPayment.termOffsetUnReceived')#
					</th>
					<th>
						#$.slatwall.rbKey('entity.Account.Type')#
					</th>
					<th>
						#$.slatwall.rbKey('entity.AccountPayment.termOffsetAmount')#
					</th>
				</tr>
				<cfset i = 0/>
				<cfset orderPaymentAmount = 0/>
				<cfset orderPaymentRecieved = 0/>
				<cfset orderPaymentUnrecieved = 0/>
				<cfset orderPaymentCredited = 0/>
			
				<cfloop array="#orderPaymentList.getRecords()#" index="orderPayment">
					<cfset i++/>
					<tr>
						<td>
							<cfif !isNull(orderPayment.getOrder()) && !isNull(orderPayment.getOrder().getOrderNumber())>
								#orderPayment.getOrder().getOrderNumber()#
							</cfif>
						</td>
						<td>
							<cfif !isNull(orderPayment.getPaymentTerm()) && !isNull(orderPayment.getPaymentTerm().getPaymentTermName())>
								#orderPayment.getPaymentTerm().getPaymentTermName()#
							</cfif>
						</td>
						<td>
							#orderPayment.getFormattedValue('paymentDueDate', 'date')#
						</td>
						<td>
							#orderPayment.getOrder().getFormattedValue('paymentAmountTotal')#
						</td>
						<td>
							#orderPayment.getOrder().getFormattedValue('paymentAmountReceivedTotal')#
						</td>
						<td>
							#orderPayment.getOrder().getFormattedValue('paymentAmountCreditedTotal')#
						</td>
						<cfset disabledAttribute = ""/>
						<cfif orderPayment.getOrder().getPaymentAmountDue() eq 0>
							<cfset disabledAttribute = 'disabled="disabled"'/>
						</cfif>
						<td <cfif len(disabledAttribute)>bgcolor="##EEEEEE"</cfif>>
							#orderPayment.getOrder().getFormattedValue('paymentAmountDue')#
						</td>
						
						<td>
							<hb:hibachiformfield fieldtype='select' fieldname='appliedOrderPayments[#i#].paymentTypeID' 
							                     valueoptions='#rc.processObject.getNewAccountPayment().getAccountPaymentAppliedOptions()#' 
							                     fieldattributes="ng-model='appliedOrderPayment.input#i#.paymentType' ng-hide='paymentTypeLock' ng-change='updateSubTotal()' ng-init='appliedOrderPayment.input#i#.paymentType = ""444df32dd2b0583d59a19f1b77869025""'"/>
							<div ng-if="paymentTypeLock">
								{{paymentTypeName}}
							</div>
						</td>
						<cfset disabledAttribute = ""/>
						<cfif orderPayment.getOrder().getPaymentAmountDue() eq 0>
							<cfset disabledAttribute = 'disabled="disabled"'/>
						</cfif>
						<td <cfif len(disabledAttribute)>bgcolor="##EEEEEE"</cfif>>
							
							<input type="number" name="appliedOrderPayments[#i#].amount" #disabledAttribute# class="span1" 
							       ng-model="appliedOrderPayment.input#i#.amount" placeholder="0" min="0" step="0.01"
							       ng-change="updateSubTotal()"/>
							<input type="hidden" name="appliedOrderPayments[#i#].orderPaymentID" 
							       value="#orderPayment.getOrderPaymentID()#"/>
						</td>
					</tr>
					
					<cfset orderPaymentAmount = orderPaymentAmount + orderPayment.getOrder().getPaymentAmountTotal()/>
					<cfset orderPaymentRecieved = orderPaymentRecieved + orderPayment.getOrder().getPaymentAmountReceivedTotal()/>
					<cfset orderPaymentUnrecieved = orderPaymentUnrecieved + orderPayment.getOrder().getPaymentAmountDue()/>
					<cfset orderPaymentCredited = orderPaymentCredited + orderPayment.getOrder().getPaymentAMountCreditedTotal()/>
				</cfloop>
			
				<tr>
					<td>
						<strong>
							#$.slatwall.rbKey('entity.AccountPayment.termOffsetTotals')#
						</strong>
					</td>
					<td colspan="2">
					</td>
					<td>
						<strong>
							#NumberFormat(orderPaymentAmount, '0.00')#
						</strong>
					</td>
					<td>
						<strong>
							#NumberFormat(orderPaymentRecieved, '0.00')#
						</strong>
					</td>
					<td>
						<strong>
							#NumberFormat(orderPaymentCredited, '0.00')#
						</strong>
					</td>
					<td>
						<strong>
							#NumberFormat(orderPaymentUnrecieved, '0.00')#
						</strong>
					</td>
					<td>
						<strong ng-init="amountUnassigned = #rc.account.getAmountUnassigned()#;updateSubTotal();">
							#$.slatwall.rbKey('entity.AccountPayment.termOffsetUnassigned')#
						</strong>
						<br/>
						
						<div ng-if="amountUnapplied != 0 && amountUnapplied != null">
							<strong class='text-error span2'>
								#$.slatwall.rbKey('entity.AccountPayment.termOffsetUnappliedWarning1')# 
								{{amountUnapplied | number:2}} 
								#$.slatwall.rbKey('entity.AccountPayment.termOffsetUnappliedWarning2')#
							</strong>
						</div>
					</td>
					<td>
						
						<input  type="text" name="appliedOrderPayments[#i+1#].amount" class="uneditable-input span1" 
						       placeholder="0" readonly ng-model="amountUnapplied"/>
						<input type="hidden" name="appliedOrderPayments[#i+1#].orderPaymentID" value=""/>
					</td>
				</tr>
				<tr>
					<td colspan="6">
					</td>
					<td>
						<strong>
							#$.slatwall.rbKey('entity.AccountPayment.termOffsetTotal')# 
							{{paymentTypeName}} 
							#$.slatwall.rbKey('entity.AccountPayment.termOffsetAmount')#
						</strong>
					</td>
					<td>
						{{amount | number:2}}
					</td>
				</tr>
				
				<tr>
					<td colspan="6">
					</td>
					<td>
						<strong>
							#$.slatwall.rbKey('entity.AccountPayment.termOffsetAccountBalance')#
						</strong>
					</td>
					<td>
						{{
						#rc.account.getTermAccountBalance()# 
						+ accountBalanceChange | number:2}}
					</td>
				</tr>
			</table>
		</hb:hibachientityprocessform>
	</cfoutput>
</div>