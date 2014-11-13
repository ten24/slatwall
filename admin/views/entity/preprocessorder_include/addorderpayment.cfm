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
<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.order" type="any" />
<cfparam name="rc.addOrderPaymentProcessObject" type="any" />

<cfoutput>
	<cfif arrayLen(rc.addOrderPaymentProcessObject.getAccountPaymentMethodIDOptions()) gt 1>
		<hb:HibachiPropertyDisplay object="#rc.addOrderPaymentProcessObject#" property="accountPaymentMethodID" edit="#rc.edit#">
	</cfif>
	
	<!--- New Payment Method --->
	<hb:HibachiDisplayToggle selector="select[name='accountPaymentMethodID']" showValues="" loadVisable="#!len(rc.addOrderPaymentProcessObject.getAccountPaymentMethodID())#">
		
		<input type="hidden" name="newOrderPayment.orderPaymentID" value="#rc.addOrderPaymentProcessObject.getNewOrderPayment().getOrderPaymentID()#" />
		
		<!--- New Payment Type --->
		<hb:HibachiPropertyDisplay object="#rc.addOrderPaymentProcessObject.getNewOrderPayment()#" property="paymentMethod" fieldName="newOrderPayment.paymentMethod.paymentMethodID" valueOptions="#rc.addOrderPaymentProcessObject.getPaymentMethodIDOptions()#" edit="#rc.edit#">
		
		<cfset loadPaymentMethodType = rc.addOrderPaymentProcessObject.getPaymentMethodIDOptions()[1]['paymentmethodtype'] />
		<cfif !isNull(rc.addOrderPaymentProcessObject.getNewOrderPayment().getPaymentMethod())>
			<cfset loadPaymentMethodType = rc.addOrderPaymentProcessObject.getNewOrderPayment().getPaymentMethod().getPaymentMethodType() />
		</cfif>
		
		<!--- Credit Card Payment Details --->
		<hb:HibachiDisplayToggle selector="select[name='newOrderPayment.paymentMethod.paymentMethodID']" valueAttribute="paymentmethodtype" showValues="creditCard" loadVisable="#loadPaymentMethodType eq 'creditCard'#">
			<h5>#$.slatwall.rbKey('admin.define.creditCardDetails')#</h5>
			<hb:HibachiPropertyDisplay object="#rc.addOrderPaymentProcessObject.getNewOrderPayment()#" fieldName="newOrderPayment.creditCardNumber" property="creditCardNumber" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.addOrderPaymentProcessObject.getNewOrderPayment()#" fieldName="newOrderPayment.nameOnCreditCard" property="nameOnCreditCard" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.addOrderPaymentProcessObject.getNewOrderPayment()#" fieldName="newOrderPayment.expirationMonth" property="expirationMonth" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.addOrderPaymentProcessObject.getNewOrderPayment()#" fieldName="newOrderPayment.expirationYear" property="expirationYear" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.addOrderPaymentProcessObject.getNewOrderPayment()#" fieldName="newOrderPayment.securityCode" property="securityCode" edit="#rc.edit#">
		</hb:HibachiDisplayToggle>
		
		<!--- Term Payment Details --->
		<hb:HibachiDisplayToggle selector="select[name='newOrderPayment.paymentMethod.paymentMethodID']" valueAttribute="paymentmethodtype" showValues="termPayment" loadVisable="#loadPaymentMethodType eq 'termPayment'#">
			<h5>#$.slatwall.rbKey('admin.define.termPaymentDetails')#</h5>
			<hb:HibachiPropertyDisplay object="#rc.addOrderPaymentProcessObject.getNewOrderPayment()#" property="purchaseOrderNumber" fieldName="newOrderPayment.purchaseOrderNumber" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.addOrderPaymentProcessObject.getNewOrderPayment()#" property="paymentTerm" fieldName="newOrderPayment.paymentTerm.paymentTermID" valueOptions="#rc.addOrderPaymentProcessObject.getPaymentTermIDOptions()#" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.order.getAccount()#" property="termAccountBalance" edit="false">
			<hb:HibachiPropertyDisplay object="#rc.order.getAccount()#" property="termAccountAvailableCredit" edit="false">
		</hb:HibachiDisplayToggle>
		
		<!--- Gift Card Details --->
		<hb:HibachiDisplayToggle selector="select[name='newOrderPayment.paymentMethod.paymentMethodID']" valueAttribute="paymentmethodtype" showValues="giftCard" loadVisable="#loadPaymentMethodType eq 'giftCard'#">
			<h5>#$.slatwall.rbKey('admin.define.giftCardDetails')#</h5>
			<hb:HibachiPropertyDisplay object="#rc.addOrderPaymentProcessObject.getNewOrderPayment()#" fieldName="newOrderPayment.giftCardNumber" property="giftCardNumber" edit="#rc.edit#">
		</hb:HibachiDisplayToggle>
		
		<!--- Check Details --->
		<hb:HibachiDisplayToggle selector="select[name='newOrderPayment.paymentMethod.paymentMethodID']" valueAttribute="paymentmethodtype" showValues="check" loadVisable="#loadPaymentMethodType eq 'check'#">
			<h5>#$.slatwall.rbKey('admin.define.checkDetails')#</h5>
			<hb:HibachiPropertyDisplay object="#rc.addOrderPaymentProcessObject.getNewOrderPayment()#" fieldName="newOrderPayment.checkNumber" property="checkNumber" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.addOrderPaymentProcessObject.getNewOrderPayment()#" fieldName="newOrderPayment.bankRoutingNumber" property="bankRoutingNumber" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.addOrderPaymentProcessObject.getNewOrderPayment()#" fieldName="newOrderPayment.bankAccountNumber" property="bankAccountNumber" edit="#rc.edit#">
		</hb:HibachiDisplayToggle>
		
		<!--- Billing Address --->
		<hb:HibachiDisplayToggle selector="select[name='newOrderPayment.paymentMethod.paymentMethodID']" valueAttribute="paymentmethodtype" showValues="creditCard,check,termPayment" loadVisable="#listFindNoCase('creditCard,check,termPayment', loadPaymentMethodType)#">
			<h5>#$.slatwall.rbKey('entity.orderPayment.billingAddress')#</h5>
			<hb:HibachiPropertyDisplay object="#rc.addOrderPaymentProcessObject#" property="accountAddressID" edit="#rc.edit#">
			<hb:HibachiDisplayToggle selector="select[name='accountAddressID']" showValues="" loadVisable="#!len(rc.addOrderPaymentProcessObject.getAccountAddressID())#">
				<swa:SlatwallAdminAddressDisplay address="#rc.addOrderPaymentProcessObject.getNewOrderPayment().getBillingAddress()#" fieldNamePrefix="newOrderPayment.billingAddress." edit="#rc.edit#" />
			</hb:HibachiDisplayToggle>	
		</hb:HibachiDisplayToggle>
		
		<!--- Save Order Payment as Account Payment Method --->
		<cfset loadVisable = 0 />
		<cfif structKeyExists(rc.addOrderPaymentProcessObject.getPaymentMethodIDOptions()[1], 'allowsaveflag') and rc.addOrderPaymentProcessObject.getPaymentMethodIDOptions()[1]['allowsaveflag']> 
			<cfset loadVisable = 1 />
		</cfif>
		<cfif !isNull(rc.addOrderPaymentProcessObject.getNewOrderPayment().getPaymentMethod()) AND !isNUll(rc.addOrderPaymentProcessObject.getNewOrderPayment().getPaymentMethod().getAllowSaveFlag())>
			<cfset loadVisable = rc.addOrderPaymentProcessObject.getNewOrderPayment().getPaymentMethod().getAllowSaveFlag() />
		</cfif>
		<hb:HibachiDisplayToggle selector="select[name='newOrderPayment.paymentMethod.paymentMethodID']" valueAttribute="allowsaveflag" showValues="true,YES,yes" loadVisable="#loadVisable#">
			
			<hr />
			
			<!--- Save New Payment Method --->
			<hb:HibachiPropertyDisplay object="#rc.addOrderPaymentProcessObject#" property="saveAccountPaymentMethodFlag" edit="#rc.edit#" />
			
			<!--- Save New Payment Method Name --->
			<hb:HibachiDisplayToggle selector="input[name='saveAccountPaymentMethodFlag']" loadVisable="#rc.addOrderPaymentProcessObject.getValueByPropertyIdentifier('saveAccountPaymentMethodFlag')#">
				<hb:HibachiPropertyDisplay object="#rc.addOrderPaymentProcessObject#" property="saveAccountPaymentMethodName" edit="#rc.edit#" />
			</hb:HibachiDisplayToggle>
		</hb:HibachiDisplayToggle>
		
	</hb:HibachiDisplayToggle>
	
</cfoutput>
