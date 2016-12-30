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
<cfparam name="rc.edit" type="string" default="" />
<cfparam name="rc.orderRequirementsList" type="string" default="" />
<cfparam name="rc.account" type="any" />
 

<!--- Mura Variables --->
<cfparam name="request.status" default="">
<cfparam name="request.isBlocked" default="false">

<cfoutput>
	<div class="svocheckoutaccount">
		<h3 id="checkoutAccountTitle" class="titleBlock">Account <cfif not listFind(rc.orderRequirementsList, 'account')><a href="?edit=account" class="editLink">Edit</a></cfif></h3>
		<div id="checkoutAccountContent" class="contentBlock">
			<cfif listFind(rc.orderRequirementsList, 'account') || rc.edit eq "account">
				<cfif listFind(rc.orderRequirementsList, 'account')>
					<cfset $.event('loginSlatAction', 'frontend:checkout.loginAccount') />
					#view("frontend:account/login")#
				</cfif>
				<div class="accountDetails">
					<form name="account" method="post" action="?update=1">
						<input type="hidden" name="slatAction" value="frontend:checkout.saveorderaccount" />
						<input type="hidden" name="siteID" value="#$.event('siteID')#" />
						<input type="hidden" name="account.accountID" value="#rc.account.getAccountID()#" />
						<cfif rc.edit eq "account"><h5>Edit Account Details</h5><cfelse><h5>New Customer</h5></cfif>
						<dl>
							<swa:SlatwallErrorDisplay object="#rc.account#" errorName="cmsError" />
							<swa:SlatwallPropertyDisplay object="#rc.account#" fieldname="account.firstName" property="firstName" edit="true">
							<swa:SlatwallPropertyDisplay object="#rc.account#" fieldname="account.lastName" property="lastName" edit="true">
							<swa:SlatwallPropertyDisplay object="#rc.account#" fieldname="account.company" property="company" edit="true">
							<swa:SlatwallPropertyDisplay object="#rc.account#" fieldname="account.emailAddress" property="emailAddress" edit="true">
							<swa:SlatwallPropertyDisplay object="#rc.account#" fieldname="account.phoneNumber" property="phoneNumber" edit="true">
							<cfif rc.account.isGuestAccount()>
								<dt class="spdguestcheckout">
									<label for="account.createMuraAccount">#$.slatwall.rbKey('frontend.checkout.detail.guestcheckout')#</label>
								</dt>
								<dd id="spdguestcheckout">
									<input type="radio" name="account.guestAccount" value="1" />#$.slatwall.rbKey('frontend.checkout.detail.checkoutAsGuest')#
									<input type="radio" name="account.guestAccount" value="0" checked="checked" />#$.slatwall.rbKey('frontend.checkout.detail.saveAccount')#<br />
								</dd>
								<dt class="spdpassword guestHide">
									<label for="account.password">Password</label>
								</dt>
								<dd id="spdpassword" class="guestHide">
									<input type="password" name="account.password" value="" />
									<swa:SlatwallErrorDisplay object="#rc.account#" errorName="password" for="password" />
								</dd>
							<cfelse>
								<a href="?doaction=logout">Logout</a>
							</cfif>
						</dl>
						<button type="submit">Save</button>
					</form>
				</div>
			<cfelseif not listFind(rc.orderRequirementsList, 'account')>
				<div class="accountDetails">
					<dl class="accountInfo">
						<dt class="fullName">#rc.account.getFullName()#</dt>
						<dd class="primaryEmail">#rc.account.getEmailAddress()#</dd>
					</dl>
				</div>
			</cfif>
		</div>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				jQuery("input[name='account.guestAccount']").change(function(){
					if(jQuery("input[name='account.guestAccount']:checked").val() == 0) {
						jQuery(".guestHide").show();
					} else {
						jQuery(".guestHide").hide();
					}
				});
			});
		</script>
	</div>
</cfoutput>
