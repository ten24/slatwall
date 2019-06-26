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



<cfparam name="rc.accountPayment" type="any" />
<cfparam name="rc.account" type="any" />
<cfparam name="rc.paymentMethod" type="any" />
<cfparam name="rc.accountPaymentTypeSystemCode" type="string" />
<cfparam name="rc.edit" type="boolean" default="tr" />

<cfsilent>
	<cfset local.amount = rc.account.getTermAccountBalance() />
</cfsilent>

<cfoutput>
	<hb:HibachiEntityDetailForm object="#rc.accountPayment#" edit="#rc.edit#" forceSSLFlag="#$.slatwall.setting('globalForceCreditCardOverSSL')#">
		
		<input type="hidden" name="account.accountID" value="#rc.account.getAccountID()#" />
		<input type="hidden" name="paymentMethod.paymentMethodID" value="#rc.paymentMethod.getPaymentMethodID()#" />
		
		<cfif rc.accountPaymentTypeSystemCode eq "aptCharge">
			<input type="hidden" name="accountPaymentType.typeID" value="444df32dd2b0583d59a19f1b77869025" />
		<cfelse>
			<input type="hidden" name="accountPaymentType.typeID" value="444df32e9b448ea196c18c66e1454c46" />
		</cfif>
		
		<!--- Credit Card --->
		<cfif rc.paymentMethod.getPaymentMethodType() eq "creditCard">
			
			<input type="hidden" name="process" value="1" />
			
			<hb:HibachiPropertyRow>
				<hb:HibachiPropertyList>
					<cfif rc.accountPaymentTypeSystemCode eq "aptCharge">
						<hb:HibachiFieldDisplay fieldname="processContext" title="#$.slatwall.rbKey('admin.order.createorderpayment.transactionType')#" fieldtype="select" valueOptions="#[{value='authorizeAndCharge', name=$.slatwall.rbKey('define.authorizeAndCharge')}, {value='authorize', name=$.slatwall.rbKey('define.authorize')}]#" edit="true">
					<cfelse>
						<hb:HibachiFieldDisplay fieldname="processContext" title="#$.slatwall.rbKey('admin.order.createorderpayment.transactionType')#" fieldtype="select" valueOptions="#[{value='credit', name=$.slatwall.rbKey('define.credit')}]#" edit="true">
					</cfif>
					<hb:HibachiPropertyDisplay object="#rc.accountPayment#" property="amount" edit="#rc.edit#" value="#local.amount#" />
				</hb:HibachiPropertyList>
			</hb:HibachiPropertyRow>
			
			<hb:HibachiPropertyRow>
				<hb:HibachiPropertyList divClass="col-md-6">
					<swa:SlatwallAddressDisplay address="#$.slatwall.getService("addressService").newAddress()#" fieldnameprefix="billingAddress." edit="#rc.edit#" />
				</hb:HibachiPropertyList>
				<hb:HibachiPropertyList divClass="col-md-6">
					<hb:HibachiPropertyDisplay object="#rc.accountPayment#" property="nameOnCreditCard" edit="#rc.edit#" />
					<hb:HibachiPropertyDisplay object="#rc.accountPayment#" property="creditCardNumber" edit="#rc.edit#" />
					<hb:HibachiPropertyDisplay object="#rc.accountPayment#" property="expirationMonth" edit="#rc.edit#" />
					<hb:HibachiPropertyDisplay object="#rc.accountPayment#" property="expirationYear" edit="#rc.edit#" />
					<hb:HibachiPropertyDisplay object="#rc.accountPayment#" property="securityCode" edit="#rc.edit#" />
				</hb:HibachiPropertyList>
			</hb:HibachiPropertyRow>
			
		<!--- Check --->
		<cfelseif rc.paymentMethod.getPaymentMethodType() eq "check">
			<hb:HibachiPropertyDisplay object="#rc.orderPayment#" property="amount" edit="#rc.edit#" value="#local.amount#" />
		<!--- Cash --->
		<cfelseif rc.paymentMethod.getPaymentMethodType() eq "cash">	
			<hb:HibachiPropertyDisplay object="#rc.orderPayment#" property="amount" edit="#rc.edit#" value="#local.amount#" />
		<!--- ??? --->
		<cfelse>
			<hb:HibachiPropertyDisplay object="#rc.orderPayment#" property="amount" edit="#rc.edit#" value="#local.amount#" />	
		</cfif>
		
	</hb:HibachiEntityDetailForm>
</cfoutput>