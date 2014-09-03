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
<cfparam name="rc.edit" type="boolean" />

<!--- Set up the order / carts smart lists --->
<cfset rc.ordersPlacedSmartList = rc.account.getOrdersPlacedSmartList() />
<cfset rc.ordersNotPlacedSmartList = rc.account.getOrdersNotPlacedSmartList() />

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.account#" edit="#rc.edit#">
		<cf_HibachiEntityActionBar type="detail" object="#rc.account#" edit="#rc.edit#">
			<cf_HibachiProcessCaller entity="#rc.account#" action="admin:entity.preprocessaccount" processContext="createPassword" type="list" modal="true" hideDisabled="false" />
			<cf_HibachiProcessCaller entity="#rc.account#" action="admin:entity.preprocessaccount" processContext="changePassword" type="list" modal="true" />
			<li class="divider"></li>
			<cf_HibachiActionCaller action="admin:entity.createaccountaddress" queryString="accountID=#rc.account.getAccountID()#&sRedirectAction=admin:entity.detailAccount" type="list" modal=true />
			<cf_HibachiActionCaller action="admin:entity.createaccountemailaddress" queryString="accountID=#rc.account.getAccountID()#&sRedirectAction=admin:entity.detailAccount" type="list" modal=true />
			<cf_HibachiActionCaller action="admin:entity.createaccountphonenumber" queryString="accountID=#rc.account.getAccountID()#&sRedirectAction=admin:entity.detailAccount" type="list" modal=true />
			<cf_HibachiActionCaller action="admin:entity.createaccountpaymentmethod" queryString="accountID=#rc.account.getAccountID()#&sRedirectAction=admin:entity.detailAccount" type="list" modal=true />
			<cf_HibachiActionCaller action="admin:entity.createaccountloyalty" queryString="accountID=#rc.account.getAccountID()#&sRedirectAction=admin:entity.detailAccount" type="list" modal=true />
			<cf_HibachiActionCaller action="admin:entity.createcomment" querystring="accountID=#rc.account.getAccountID()#&sRedirectAction=admin:entity.detailAccount" modal="true" type="list" />
		</cf_HibachiEntityActionBar>
		
		<cf_HibachiEntityDetailGroup object="#rc.account#">
			<cf_HibachiEntityDetailItem view="admin:entity/accounttabs/basic" open="true" text="#$.slatwall.rbKey('admin.define.basic')#" />
			<cf_HibachiEntityDetailItem view="admin:entity/accounttabs/contactdetails" />
			<cf_HibachiEntityDetailItem property="accountPaymentMethods" count="#rc.account.getAccountPaymentMethodsSmartList().getRecordsCount()#" />
			<cf_HibachiEntityDetailItem property="priceGroups" />
			<cf_HibachiEntityDetailItem property="orders" count="#rc.ordersPlacedSmartList.getRecordsCount()#" />
			<cf_HibachiEntityDetailItem view="admin:entity/accounttabs/cartsandquotes" count="#rc.ordersNotPlacedSmartList.getRecordsCount()#" />
			<cf_HibachiEntityDetailItem property="accountPayments" />
			<cf_HibachiEntityDetailItem property="accountLoyalties" count="#rc.account.getAccountLoyaltiesSmartList().getRecordsCount()#" />
			<cf_HibachiEntityDetailItem property="productReviews" />
			<cf_HibachiEntityDetailItem view="admin:entity/accounttabs/subscriptionusage" count="#rc.account.getSubscriptionUsagesSmartList().getRecordsCount()#" />
			<cf_HibachiEntityDetailItem property="permissionGroups" />
			<cf_HibachiEntityDetailItem view="admin:entity/accounttabs/accountsettings" />
			
			<!--- Custom Attributes --->
			<cfloop array="#rc.account.getAssignedAttributeSetSmartList().getRecords()#" index="attributeSet">
				<cf_SlatwallAdminTabCustomAttributes object="#rc.account#" attributeSet="#attributeSet#" />
			</cfloop>
			
			<!--- Comments --->
			<cf_SlatwallAdminTabComments object="#rc.account#" />
		</cf_HibachiEntityDetailGroup>
		
	</cf_HibachiEntityDetailForm>
</cfoutput>