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

<hb:HibachiListingDisplay smartList="#rc.account.getChildAccountRelationshipsSmartList()#"
						  recordDetailAction="admin:entity.detailaccount"
						  recordEditAction="admin:entity.editaccount"
						  recordEditActionProperty="childAccount.accountID"
						  recordDetailActionProperty="childAccount.accountID"
						  recordDeleteAction="admin:entity.deleteaccountrelationship"
						  recordDeleteQueryString="sRedirectAction=admin:entity.detailaccount&accountID=#rc.account.getAccountID()#"
						  >

	<hb:HibachiListingColumn propertyIdentifier="childAccount.firstName" />
	<hb:HibachiListingColumn propertyIdentifier="childAccount.lastName" />
	<hb:HibachiListingColumn propertyIdentifier="childAccount.accountCode" />
	<hb:HibachiListingColumn tdclass="primary" propertyIdentifier="childAccount.company" />
	<hb:HibachiListingColumn propertyIdentifier="childAccount.primaryPhoneNumber.phoneNumber" />
	<hb:HibachiListingColumn propertyIdentifier="childAccount.primaryEmailAddress.emailAddress" />
	<hb:HibachiListingColumn propertyIdentifier="childAccount.guestAccountFlag" />
	<hb:HibachiListingColumn propertyIdentifier="childAccount.organizationFlag" />
	<hb:HibachiListingColumn propertyIdentifier="accountRelationshipRole.accountRelationshipRoleName" />
	<hb:HibachiListingColumn propertyIdentifier="approvalFlag" />
</hb:HibachiListingDisplay>
<hb:HibachiActionCaller action="admin:entity.preprocessaccount" entity="account" class="btn btn-default" icon="plus" querystring="sRedirectAction=admin:entity.detailaccount&parentAccountID=#rc.account.getAccountID()#&processcontext=addaccountrelationship" />

