<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

--->
<cfparam name="rc.account" type="any" />
<cfparam name="rc.edit" type="boolean" />

<!--- Set up the order / carts smart lists --->
<cfset rc.ordersPlacedSmartList = rc.account.getOrdersPlacedSmartList() />
<cfset rc.ordersNotPlacedSmartList = rc.account.getOrdersNotPlacedSmartList() />

<cf_HibachiEntityDetailForm object="#rc.account#" edit="#rc.edit#">
	<cf_HibachiEntityActionBar type="detail" object="#rc.account#" edit="#rc.edit#">
		<cf_HibachiProcessCaller entity="#rc.account#" action="admin:entity.preprocessaccount" processContext="createPassword" type="list" modal="true" />
		<cf_HibachiProcessCaller entity="#rc.account#" action="admin:entity.preprocessaccount" processContext="changePassword" type="list" modal="true" />
		<li class="divider"></li>
		<cf_HibachiActionCaller action="admin:entity.createaccountaddress" queryString="accountID=#rc.account.getAccountID()#" type="list" modal=true />
		<cf_HibachiActionCaller action="admin:entity.createaccountemailaddress" queryString="accountID=#rc.account.getAccountID()#" type="list" modal=true />
		<cf_HibachiActionCaller action="admin:entity.createaccountphonenumber" queryString="accountID=#rc.account.getAccountID()#" type="list" modal=true />
		<cf_HibachiActionCaller action="admin:entity.createaccountpaymentmethod" queryString="accountID=#rc.account.getAccountID()#" type="list" modal=true />
		<cf_HibachiActionCaller action="admin:entity.createcomment" querystring="accountID=#rc.account.getAccountID()#&redirectAction=#request.context.slatAction#" modal="true" type="list" />
	</cf_HibachiEntityActionBar>
	
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList divclass="span6">
			<cf_HibachiPropertyDisplay object="#rc.account#" property="firstName" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.account#" property="lastName" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.account#" property="company" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.account#" property="superUserFlag" edit="#rc.edit and $.slatwall.getAccount().getSuperUserFlag()#">
		</cf_HibachiPropertyList>
		
		<!--- Totals --->
		<cf_HibachiPropertyList divclass="span6">
			<cf_HibachiPropertyTable>
				<cf_HibachiPropertyTableBreak header="#$.slatwall.rbKey('admin.entity.detailaccount.termPaymentDetails')#" />
				<cf_HibachiPropertyDisplay object="#rc.account#" property="termAccountBalance" edit="false" displayType="table">
				<cf_HibachiPropertyDisplay object="#rc.account#" property="termAccountAvailableCredit" edit="false" displayType="table">
				<cf_HibachiPropertyTableBreak header="#$.slatwall.rbKey('admin.entity.detailaccount.authenticationDetails')#" />
				<cf_HibachiPropertyDisplay object="#rc.account#" property="guestAccountFlag" edit="false" displayType="table">
				<cfloop array="#rc.account.getAccountAuthentications()#" index="accountAuthentication">
					<cfsavecontent variable="thisValue">
						<cf_HibachiActionCaller text="#$.slatwall.rbKey('define.remove')#" action="admin:entity.deleteAccountAuthentication" queryString="accountAuthenticationID=#accountAuthentication.getAccountAuthenticationID()#&redirectAction=admin:entity.detailAccount&accountID=#rc.account.getAccountID()#" />
					</cfsavecontent>
					<cf_HibachiFieldDisplay title="#accountAuthentication.getSimpleRepresentation()#" value="#thisValue#" edit="false" displayType="table">	
				</cfloop>
			</cf_HibachiPropertyTable>
		</cf_HibachiPropertyList>
				
	</cf_HibachiPropertyRow>
	
	<cf_HibachiTabGroup object="#rc.account#">
		<cf_HibachiTab view="admin:entity/accounttabs/contactdetails" />
		<cf_HibachiTab property="accountPaymentMethods" count="#rc.account.getAccountPaymentMethodsSmartList().getRecordsCount()#" />
		<cf_HibachiTab property="priceGroups" />
		<cf_HibachiTab property="orders" count="#rc.ordersPlacedSmartList.getRecordsCount()#" />
		<cf_HibachiTab view="admin:entity/accounttabs/cartsandquotes" count="#rc.ordersNotPlacedSmartList.getRecordsCount()#" />
		<cf_HibachiTab property="accountPayments" />
		<cf_HibachiTab property="productReviews" />
		<cf_HibachiTab view="admin:entity/accounttabs/subscriptionusage" count="#rc.account.getSubscriptionUsagesSmartList().getRecordsCount()#" />
		<cf_HibachiTab property="permissionGroups" />
		<cf_HibachiTab view="admin:entity/accounttabs/accountsettings" />
		
		<!--- Custom Attributes --->
		<cfloop array="#rc.account.getAssignedAttributeSetSmartList().getRecords()#" index="attributeSet">
			<cf_SlatwallAdminTabCustomAttributes object="#rc.account#" attributeSet="#attributeSet#" />
		</cfloop>
		
		<!--- Comments --->
		<cf_SlatwallAdminTabComments object="#rc.account#" />
	</cf_HibachiTabGroup>
	
</cf_HibachiEntityDetailForm>
