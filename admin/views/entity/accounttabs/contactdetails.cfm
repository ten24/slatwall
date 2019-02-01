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


<cfparam name="rc.account" type="any" />

<cfoutput>
	<hb:HibachiPropertyRow>
		<!--- Email Addresses --->
		<hb:HibachiPropertyList divClass="col-md-6">
			<hb:HibachiListingDisplay title="#$.slatwall.rbKey('entity.accountEmailAddress_plural')#" smartList="#rc.account.getAccountEmailAddressesSmartList()#"
									  recordEditAction="admin:entity.editaccountemailaddress"
									  recordEditQueryString="accountID=#rc.account.getAccountID()#&sRedirectAction=admin:entity.detailAccount"
									  recordEditModal=true
									  recordDeleteAction="admin:entity.deleteaccountemailaddress"
									  recordDeleteQueryString="accountID=#rc.account.getAccountID()#&sRedirectAction=admin:entity.detailAccount"
									  selectFieldName="primaryEmailAddress.accountEmailAddressID"
									  selectValue="#rc.account.getPrimaryEmailAddress().getAccountEmailAddressID()#"
									  selectTitle="#$.slatwall.rbKey('define.primary')#"
									  edit="#rc.edit#">

				<hb:HibachiListingColumn tdclass="primary" propertyIdentifier="emailAddress" />
				<hb:HibachiListingColumn propertyIdentifier="accountEmailType.typeName" />
				<hb:HibachiListingColumn propertyIdentifier="verifiedFlag" />
			</hb:HibachiListingDisplay>
			<hb:HibachiActionCaller action="admin:entity.createaccountemailaddress" class="btn btn-default" icon="plus" queryString="sRedirectAction=admin:entity.detailaccount&accountID=#rc.account.getAccountID()#" modal=true />
		</hb:HibachiPropertyList>

		<!--- Phone Numbers --->
		<hb:HibachiPropertyList divClass="col-md-6">
			<hb:HibachiListingDisplay title="#$.slatwall.rbKey('entity.accountPhoneNumber_plural')#" smartList="#rc.account.getAccountPhoneNumbersSmartList()#"
									  recordEditAction="admin:entity.editaccountphonenumber"
									  recordEditQueryString="accountID=#rc.account.getAccountID()#&sRedirectAction=admin:entity.detailAccount"
									  recordEditModal=true
									  recordDeleteAction="admin:entity.deleteaccountphonenumber"
									  recordDeleteQueryString="accountID=#rc.account.getAccountID()#&sRedirectAction=admin:entity.detailAccount"
									  selectFieldName="primaryPhoneNumber.accountPhoneNumberID"
									  selectValue="#rc.account.getPrimaryPhoneNumber().getAccountPhoneNumberID()#"
									  selectTitle="#$.slatwall.rbKey('define.primary')#"
									  edit="#rc.edit#">

				<hb:HibachiListingColumn tdclass="primary" propertyIdentifier="phoneNumber" />
				<hb:HibachiListingColumn propertyIdentifier="accountPhoneType.typeName" />

			</hb:HibachiListingDisplay>

			<hb:HibachiActionCaller action="admin:entity.createaccountphonenumber" class="btn btn-default" icon="plus" queryString="sRedirectAction=admin:entity.detailaccount&accountID=#rc.account.getAccountID()#" modal=true />
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
	<hr />
	<hb:HibachiPropertyRow>
		<!--- Addresses --->
		<hb:HibachiPropertyList divClass="col-md-12">
			<hb:HibachiListingDisplay title="#$.slatwall.rbKey('entity.accountAddress_plural')#" smartList="#rc.account.getAccountAddressesSmartList()#"
									  recordEditAction="admin:entity.editaccountaddress"
									  recordEditQueryString="accountID=#rc.account.getAccountID()#&sRedirectAction=admin:entity.detailAccount"
									  recordEditModal=true
									  recordDeleteAction="admin:entity.deleteaccountaddress"
									  recordDeleteQueryString="accountID=#rc.account.getAccountID()#&sRedirectAction=admin:entity.detailAccount"
									  selectFieldName="primaryAddress.accountAddressID"
									  selectValue="#rc.account.getPrimaryAddress().getAccountAddressID()#"
									  selectTitle="#$.slatwall.rbKey('define.primary')#"
									  edit="#rc.edit#">

				<hb:HibachiListingColumn tdclass="primary" propertyIdentifier="accountAddressName" />
				<hb:HibachiListingColumn propertyIdentifier="address.name" />
				<hb:HibachiListingColumn propertyIdentifier="address.streetAddress" />
				<hb:HibachiListingColumn propertyIdentifier="address.street2Address" />
				<hb:HibachiListingColumn propertyIdentifier="address.city" />
				<hb:HibachiListingColumn propertyIdentifier="address.stateCode" />
				<hb:HibachiListingColumn propertyIdentifier="address.postalCode" />
				<hb:HibachiListingColumn propertyIdentifier="address.countryCode" />
			</hb:HibachiListingDisplay>

			<hb:HibachiActionCaller action="admin:entity.createaccountaddress" class="btn btn-default" icon="plus" queryString="sRedirectAction=admin:entity.detailaccount&accountID=#rc.account.getAccountID()#" modal=true />
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>
