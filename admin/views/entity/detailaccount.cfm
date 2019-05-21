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


<cfparam name="rc.account" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiEntityDetailForm object="#rc.account#" edit="#rc.edit#">
		<hb:HibachiEntityActionBar type="detail" object="#rc.account#" edit="#rc.edit#">
			<hb:HibachiProcessCaller entity="#rc.account#" action="admin:entity.preprocessaccount" processContext="createPassword" type="list" modal="true" hideDisabled="false" />
			<hb:HibachiProcessCaller entity="#rc.account#" action="admin:entity.preprocessaccount" processContext="changePassword" type="list" modal="true" />
			<!--- If the logged in user is a super user, or they own this account then allow api token generation. --->
			<cfif getHibachiScope().getAccount().getSuperUserFlag() || getHibachiScope().getAccount().getAccountID() eq rc.account.getAccountID()>
				<hb:HibachiProcessCaller entity="#rc.account#" action="admin:entity.preprocessaccount" processContext="generateAPIAccessKey"  type="list" modal="true" />
			</cfif>
			<cfif !isNull(getHibachiScope().getService("integrationService").getIntegrationByIntegrationPackage("slatwallpos")) AND 
				  getHibachiScope().getService("integrationService").getIntegrationByIntegrationPackage("slatwallpos").getActiveFlag() >
				
				<hb:HibachiProcessCaller entity="#rc.account#" action="admin:entity.preprocessaccount" processContext="changePosPin"  type="list" modal="true" />
			
			</cfif>
			<li class="divider"></li>
			<hb:HibachiActionCaller action="admin:entity.createaccountaddress" queryString="accountID=#rc.account.getAccountID()#&sRedirectAction=admin:entity.detailAccount" type="list" modal=true />
			<hb:HibachiActionCaller action="admin:entity.createaccountemailaddress" queryString="accountID=#rc.account.getAccountID()#&sRedirectAction=admin:entity.detailAccount" type="list" modal=true />
			<hb:HibachiActionCaller action="admin:entity.createaccountphonenumber" queryString="accountID=#rc.account.getAccountID()#&sRedirectAction=admin:entity.detailAccount" type="list" modal=true />
			<hb:HibachiActionCaller action="admin:entity.createaccountpaymentmethod" queryString="accountID=#rc.account.getAccountID()#&sRedirectAction=admin:entity.detailAccount" type="list" modal=true />
			<hb:HibachiActionCaller action="admin:entity.createaccountloyalty" queryString="accountID=#rc.account.getAccountID()#&sRedirectAction=admin:entity.detailAccount" type="list" modal=true />
			<hb:HibachiActionCaller action="admin:entity.createcomment" querystring="accountID=#rc.account.getAccountID()#&sRedirectAction=admin:entity.detailAccount" modal="true" type="list" />
			<li class="divider"></li>
			<hb:HibachiProcessCaller entity="#rc.account#" action="admin:entity.preprocessaccount" processContext="clone" queryString="sRedirectAction=admin:entity.detailAccount" type="list" modal="true" hideDisabled="false" />
			<!--- Allow the user to merge any two accounts into one. --->
			<hb:HibachiProcessCaller entity="#rc.account#" action="admin:entity.preprocessaccount" processContext="mergeAccount" queryString="sRedirectAction=admin:entity.detailAccount" type="list" modal="true" hideDisabled="false" />
			
		</hb:HibachiEntityActionBar>

		<hb:HibachiEntityDetailGroup object="#rc.account#">
			<hb:HibachiEntityDetailItem view="admin:entity/accounttabs/basic" open="true" text="#$.slatwall.rbKey('admin.define.basic')#" />
			<hb:HibachiEntityDetailItem view="admin:entity/accounttabs/termpaymentdetails" />
			<hb:HibachiEntityDetailItem view="admin:entity/accounttabs/contactdetails" />
			<hb:HibachiEntityDetailItem property="accountPaymentMethods" count="#rc.account.getAccountPaymentMethodsSmartList().getRecordsCount()#" />
			<hb:HibachiEntityDetailItem view="admin:entity/accounttabs/giftcards" count="#rc.account.getGiftCardsCount()#" />
			<hb:HibachiEntityDetailItem property="priceGroups" />
			<hb:HibachiEntityDetailItem property="orders" count="#rc.ordersPlacedSmartList.getRecordsCount()#" />
			<hb:HibachiEntityDetailItem view="admin:entity/accounttabs/cartsandquotes" count="#rc.ordersNotPlacedSmartList.getRecordsCount()#" />
			<hb:HibachiEntityDetailItem property="accountPayments" />
			<hb:HibachiEntityDetailItem property="accountLoyalties" count="#rc.account.getAccountLoyaltiesSmartList().getRecordsCount()#" />
			<hb:HibachiEntityDetailItem property="productReviews" />
			<hb:HibachiEntityDetailItem view="admin:entity/accounttabs/subscriptionusage" count="#rc.account.getSubscriptionUsagesSmartList().getRecordsCount()#" />
			<hb:HibachiEntityDetailItem property="permissionGroups" />
			<hb:HibachiEntityDetailItem view="admin:entity/accounttabs/parentaccounts" count="#rc.account.getParentAccountRelationShipsSmartList().getRecordsCount()#"/>
			<hb:HibachiEntityDetailItem view="admin:entity/accounttabs/childaccounts" count="#rc.account.getChildAccountRelationShipsSmartList().getRecordsCount()#"/>
			<hb:HibachiEntityDetailItem view="admin:entity/accounttabs/accountsettings"/>
			

			<!--- Custom Attributes --->
			<cfloop array="#rc.account.getAssignedAttributeSetSmartList().getRecords()#" index="attributeSet">
				<swa:SlatwallAdminTabCustomAttributes object="#rc.account#" attributeSet="#attributeSet#" />
			</cfloop>

			<!--- Comments --->
			<swa:SlatwallAdminTabComments object="#rc.account#" />
		</hb:HibachiEntityDetailGroup>

	</hb:HibachiEntityDetailForm>
</cfoutput>