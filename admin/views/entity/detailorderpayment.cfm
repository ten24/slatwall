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
<cfparam name="rc.orderPayment" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.orderPayment#" edit="#rc.edit#">
		<cf_HibachiEntityActionBar type="detail" object="#rc.orderPayment#" edit="#rc.edit#"
								   backaction="admin:entity.detailorder"
								   backquerystring="orderID=#rc.orderPayment.getOrder().getOrderID()#"
								   deleteQueryString="redirectAction=admin:entity.detailOrder&orderID=#rc.orderPayment.getOrder().getOrderID()#">
			<cf_HibachiProcessCaller entity="#rc.orderPayment#" action="admin:entity.preprocessorderpayment" processContext="createTransaction" type="list" modal="true">
		</cf_HibachiEntityActionBar>
		
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList divClass="span6">
				<cfif rc.orderPayment.getPaymentMethodType() eq "creditCard">
					<cf_HibachiPropertyDisplay object="#rc.orderPayment#" property="nameOnCreditCard" edit="#rc.edit#" />
					<cf_HibachiPropertyDisplay object="#rc.orderPayment#" property="creditCardType" />
					<cf_HibachiPropertyDisplay object="#rc.orderPayment#" property="expirationMonth" edit="#rc.edit#" />
					<cf_HibachiPropertyDisplay object="#rc.orderPayment#" property="expirationYear" edit="#rc.edit#" />
				<cfelseif rc.orderPayment.getPaymentMethodType() eq "termPayment">
					<cf_HibachiPropertyDisplay object="#rc.orderPayment#" property="termPaymentAccount" edit="false" />
					<cf_HibachiPropertyDisplay object="#rc.orderPayment#" property="paymentTerm" edit="false" />
				</cfif>
				
				<cfif listFindNoCase("creditCard,termPayment", rc.orderPayment.getPaymentMethodType()) or not isNull(rc.orderPayment.getBillingAddress())>
					<hr />
					<cf_HibachiPropertyDisplay object="#rc.orderPayment.getBillingAddress()#" property="name" edit="#rc.edit#" title="Address nickname"/>
					<cf_HibachiPropertyDisplay object="#rc.orderPayment.getBillingAddress()#" property="company" edit="#rc.edit#" />
					<cf_HibachiPropertyDisplay object="#rc.orderPayment.getBillingAddress()#" property="streetAddress" edit="#rc.edit#" />
					<cf_HibachiPropertyDisplay object="#rc.orderPayment.getBillingAddress()#" property="street2Address" edit="#rc.edit#" />
					<cf_HibachiPropertyDisplay object="#rc.orderPayment.getBillingAddress()#" property="city" edit="#rc.edit#" />
					<cf_HibachiPropertyDisplay object="#rc.orderPayment.getBillingAddress()#" property="stateCode" edit="#rc.edit#" />
					<cf_HibachiPropertyDisplay object="#rc.orderPayment.getBillingAddress()#" property="postalCode" edit="#rc.edit#" />
					<cf_HibachiPropertyDisplay object="#rc.orderPayment.getBillingAddress()#" property="countryCode" edit="#rc.edit#" />
				</cfif>
			</cf_HibachiPropertyList>
			<cf_HibachiPropertyList divClass="span6">
				<cf_HibachiPropertyDisplay object="#rc.orderPayment#" property="dynamicAmountFlag" edit="false" />
				<cf_HibachiPropertyDisplay object="#rc.orderPayment#" property="amount" edit="#rc.edit and not rc.orderPayment.getDynamicAmountFlag()#" />
				<hr />
				<cf_HibachiPropertyDisplay object="#rc.orderPayment#" property="amountAuthorized" />
				<cf_HibachiPropertyDisplay object="#rc.orderPayment#" property="amountReceived" />
				<cf_HibachiPropertyDisplay object="#rc.orderPayment#" property="amountCredited" />
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
		
		<cf_HibachiTabGroup object="#rc.orderPayment#">
			<cf_HibachiTab view="admin:entity/orderpaymenttabs/paymenttransactions" />
			
			<!--- Custom Attributes --->
			<cfloop array="#rc.orderPayment.getAssignedAttributeSetSmartList().getRecords()#" index="attributeSet">
				<cf_SlatwallAdminTabCustomAttributes object="#rc.orderPayment#" attributeSet="#attributeSet#" />
			</cfloop>
		</cf_HibachiTabGroup>
		
	</cf_HibachiEntityDetailForm>
</cfoutput>
