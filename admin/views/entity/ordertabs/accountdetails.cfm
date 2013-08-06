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
<cfparam name="rc.order" type="any" />
<cfparam name="rc.account" type="any" default="#rc.order.getAccount()#"/>
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cf_HibachiPropertyRow>
		
		<!--- Left Side --->
		<cf_HibachiPropertyList divClass="span4">
			
			<!--- Email Addresses --->
			<h5>#$.slatwall.rbKey('entity.accountEmailAddress_plural')#</h5>
			<cf_HibachiListingDisplay smartList="#rc.account.getAccountEmailAddressesSmartList()#">
				<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="emailAddress" />
				<cf_HibachiListingColumn propertyIdentifier="accountEmailType.type" />
				<cf_HibachiListingColumn propertyIdentifier="verifiedFlag" />
			</cf_HibachiListingDisplay>
			
			<hr />
			<br />
			
			<!--- Phone Numbers --->
			<h5>#$.slatwall.rbKey('entity.accountPhoneNumber_plural')#</h5>
			<cf_HibachiListingDisplay smartList="#rc.account.getAccountPhoneNumbersSmartList()#">
				<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="phoneNumber" />
				<cf_HibachiListingColumn propertyIdentifier="accountPhoneType.type" />
			</cf_HibachiListingDisplay>
			
			<hr />
			<br />
			
			<!--- Price Gruops --->
			<h5>#$.slatwall.rbKey('entity.priceGroup_plural')#</h5>
			<cf_HibachiListingDisplay smartList="#rc.account.getPriceGroupsSmartList()#">
				<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="priceGroupName" />
			</cf_HibachiListingDisplay>
			
			<hr />
			<br />
			
			<!--- Term Account Info --->
			<h5>#$.slatwall.rbKey('admin.order.accountDetails.termAccountCreditDetails.info')#</h5>	
			<cf_HibachiPropertyDisplay object="#rc.account#" property="termAccountAvailableCredit" edit="false">
			<cf_HibachiPropertyDisplay object="#rc.account#" property="termAccountBalance" edit="false">
			
		</cf_HibachiPropertyList>
		
		<!--- Right Side --->
		<cf_HibachiPropertyList divClass="span8">
			
			<!--- Payment Methods --->
			<h5>#$.slatwall.rbKey('entity.accountPaymentMethod_plural')#</h5>
			<cf_HibachiListingDisplay smartList="#rc.account.getAccountPaymentMethodsSmartList()#"
								  recordDetailAction="admin:entity.detailaccountpaymentmethod"
								  recordDetailQueryString="accountID=#rc.account.getAccountID()#"
								  recordDetailModal=true>
								    
				<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="accountPaymentMethodName" />
				<cf_HibachiListingColumn propertyIdentifier="paymentMethod.paymentMethodName" />
			</cf_HibachiListingDisplay>
			
			<hr />
			<br />
			
			<!--- Addresses --->
			<h5>#$.slatwall.rbKey('entity.accountAddress_plural')#</h5>
			<cf_HibachiListingDisplay smartList="#rc.account.getAccountAddressesSmartList()#">
				<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="accountAddressName" />
				<cf_HibachiListingColumn propertyIdentifier="address.name" />
				<cf_HibachiListingColumn propertyIdentifier="address.streetAddress" />
				<cf_HibachiListingColumn propertyIdentifier="address.street2Address" />
				<cf_HibachiListingColumn propertyIdentifier="address.city" />
				<cf_HibachiListingColumn propertyIdentifier="address.stateCode" />
				<cf_HibachiListingColumn propertyIdentifier="address.postalCode" />
			</cf_HibachiListingDisplay>	
			
			<hr />
			<br />
			
			<!--- Comments --->
			<h5>#$.slatwall.rbKey('entity.comment_plural')#</h5>
			<cf_SlatwallAdminCommentsDisplay object="#rc.account#" adminComments="false" />
			
		</cf_HibachiPropertyList>
		
	</cf_HibachiPropertyRow>

</cfoutput>
