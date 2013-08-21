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

<cfoutput>
	<cf_HibachiPropertyRow>
		<!--- Email Addresses --->
		<cf_HibachiPropertyList divClass="span6">
			<h5>#$.slatwall.rbKey('entity.accountEmailAddress_plural')#</h5>
			<cf_HibachiListingDisplay smartList="#rc.account.getAccountEmailAddressesSmartList()#"
									  recordEditAction="admin:entity.editaccountemailaddress"
									  recordEditQueryString="accountID=#rc.account.getAccountID()#&sRedirectAction=admin:entity.detailAccount"
									  recordEditModal=true
									  recordDeleteAction="admin:entity.deleteaccountemailaddress"
									  recordDeleteQueryString="accountID=#rc.account.getAccountID()#&sRedirectAction=admin:entity.detailAccount"
									  selectFieldName="primaryEmailAddress.accountEmailAddressID"
									  selectValue="#rc.account.getPrimaryEmailAddress().getAccountEmailAddressID()#"
									  selectTitle="#$.slatwall.rbKey('define.primary')#"
									  edit="#rc.edit#">
						
				<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="emailAddress" />
				<cf_HibachiListingColumn propertyIdentifier="accountEmailType.type" />
				<cf_HibachiListingColumn propertyIdentifier="verifiedFlag" />
			</cf_HibachiListingDisplay>
			
			<cf_HibachiActionCaller action="admin:entity.createaccountemailaddress" class="btn" icon="plus" queryString="sRedirectAction=admin:entity.detailaccount&accountID=#rc.account.getAccountID()#" modal=true />
		</cf_HibachiPropertyList>
		
		<!--- Phone Numbers --->
		<cf_HibachiPropertyList divClass="span6">
			<h5>#$.slatwall.rbKey('entity.accountPhoneNumber_plural')#</h5>
			<cf_HibachiListingDisplay smartList="#rc.account.getAccountPhoneNumbersSmartList()#"
									  recordEditAction="admin:entity.editaccountphonenumber"
									  recordEditQueryString="accountID=#rc.account.getAccountID()#&sRedirectAction=admin:entity.detailAccount"
									  recordEditModal=true
									  recordDeleteAction="admin:entity.deleteaccountphonenumber"
									  recordDeleteQueryString="accountID=#rc.account.getAccountID()#&sRedirectAction=admin:entity.detailAccount"
									  selectFieldName="primaryPhoneNumber.accountPhoneNumberID"
									  selectValue="#rc.account.getPrimaryPhoneNumber().getAccountPhoneNumberID()#"
									  selectTitle="#$.slatwall.rbKey('define.primary')#"
									  edit="#rc.edit#">
						
				<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="phoneNumber" />
				<cf_HibachiListingColumn propertyIdentifier="accountPhoneType.type" />
				
			</cf_HibachiListingDisplay>
			
			<cf_HibachiActionCaller action="admin:entity.createaccountphonenumber" class="btn" icon="plus" queryString="sRedirectAction=admin:entity.detailaccount&accountID=#rc.account.getAccountID()#" modal=true />
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
	<hr />
	<cf_HibachiPropertyRow>
		<!--- Addresses --->
		<cf_HibachiPropertyList divClass="span12">
			<h5>#$.slatwall.rbKey('entity.accountAddress_plural')#</h5>
			<cf_HibachiListingDisplay smartList="#rc.account.getAccountAddressesSmartList()#"
									  recordEditAction="admin:entity.editaccountaddress"
									  recordEditQueryString="accountID=#rc.account.getAccountID()#&sRedirectAction=admin:entity.detailAccount"
									  recordEditModal=true
									  recordDeleteAction="admin:entity.deleteaccountaddress"
									  recordDeleteQueryString="accountID=#rc.account.getAccountID()#&sRedirectAction=admin:entity.detailAccount"
									  selectFieldName="primaryAddress.accountAddressID"
									  selectValue="#rc.account.getPrimaryAddress().getAccountAddressID()#"
									  selectTitle="#$.slatwall.rbKey('define.primary')#"
									  edit="#rc.edit#">
						
				<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="accountAddressName" />
				<cf_HibachiListingColumn propertyIdentifier="address.name" />
				<cf_HibachiListingColumn propertyIdentifier="address.streetAddress" />
				<cf_HibachiListingColumn propertyIdentifier="address.street2Address" />
				<cf_HibachiListingColumn propertyIdentifier="address.city" />
				<cf_HibachiListingColumn propertyIdentifier="address.stateCode" />
				<cf_HibachiListingColumn propertyIdentifier="address.postalCode" />
			</cf_HibachiListingDisplay>
			
			<cf_HibachiActionCaller action="admin:entity.createaccountaddress" class="btn" icon="plus" queryString="sRedirectAction=admin:entity.detailaccount&accountID=#rc.account.getAccountID()#" modal=true />
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
</cfoutput>
