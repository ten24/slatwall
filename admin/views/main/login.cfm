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
<cfparam name="rc.accountAuthenticationExists" type="boolean" />
<cfparam name="rc.swprid" type="string" default="" />
<cfparam name="rc.integrationLoginHTMLArray" type="array" />
		
<cfoutput>
	<div style="width:100%;">
		<cf_HibachiMessageDisplay />
		
		<cfif len(rc.swprid) eq 64>
			<div class="well" style="width:400px;margin: 0px auto;">
				<h3>Reset Password</h3>
				<br />
				<form id="adminResetPasswordForm" action="?s=1" class="form-horizontal" method="post">
					<input type="hidden" name="slatAction" value="admin:main.resetPassword" />
					<input type="hidden" name="swprid" value="#rc.swprid#" />
					<input type="hidden" name="accountID" value="#left(rc.swprid, 32)#" />

					<cfset processObject = rc.fw.getHibachiScope().getAccount().getProcessObject("resetPassword") />
										
					<cf_HibachiErrorDisplay object="#processObject#" errorName="swprid" />
					
					<fieldset class="dl-horizontal">
						
						<cf_HibachiPropertyDisplay object="#processObject#" property="password" edit="true" />
						<cf_HibachiPropertyDisplay object="#processObject#" property="passwordConfirm" edit="true" />
						<button type="submit" class="btn btn-primary pull-right">Reset & Login</button>
					</fieldset>
				</form>
			</div>
		<cfelseif rc.accountAuthenticationExists>
			<div class="well tabable" style="width:400px;margin: 0px auto;">
				<h3>#$.slatwall.rbKey('define.login')#</h3>
				<br />
				<cfset authorizeProcessObject = rc.fw.getHibachiScope().getAccount().getProcessObject("login") />
				<form id="adminLoginForm" action="?s=1" class="form-horizontal" method="post">
					<input type="hidden" name="slatAction" value="admin:main.authorizelogin" />
					<cfif structKeyExists(rc, "sRedirectURL")>
						<input type="hidden" name="sRedirectURL" value="#rc.sRedirectURL#" />
					</cfif>
					<fieldset class="dl-horizontal">
						<fieldset class="dl-horizontal">
							<cf_HibachiPropertyDisplay object="#authorizeProcessObject#" property="emailAddress" edit="true" title="#rc.fw.getHibachiScope().rbKey('entity.account.emailAddress')#" />
							<cf_HibachiPropertyDisplay object="#authorizeProcessObject#" property="password" edit="true" title="#rc.fw.getHibachiScope().rbKey('entity.account.password')#" />
						</fieldset>
						<button type="submit" class="btn btn-primary pull-right">#$.slatwall.rbKey('define.login')#</button>
					</fieldset>
				</form>
				<hr />
				<h5>#$.slatwall.rbKey('admin.main.forgotPassword')#</h5>
				<cfset forgotPasswordProcessObject = rc.fw.getHibachiScope().getAccount().getProcessObject("forgotPassword") />
				<form id="adminForgotPasswordForm" action="?s=1" class="form-horizontal" method="post">
					<input type="hidden" name="slatAction" value="admin:main.forgotpassword" />
					<fieldset class="dl-horizontal">
						<fieldset class="dl-horizontal">
							<cf_HibachiPropertyDisplay object="#forgotPasswordProcessObject#" property="emailAddress" edit="true" />
						</fieldset>
						<button type="submit" class="btn btn-primary pull-right">#$.slatwall.rbKey('admin.main.sendPasswordReset')#</button>
					</fieldset>
				</form>
				<!--- Integration Logins --->
				<cfloop array="#rc.integrationLoginHTMLArray#" index="loginHTML">
					<hr />
					#loginHTML#
				</cfloop>
			</div>
		<cfelse>
			<div class="well" style="width:400px;margin: 0px auto;">
				<h3>Create Super Administrator Account</h3>
				<br />
				<form id="adminCreateSuperUserForm" action="?s=1" class="form-horizontal" method="post">
					<input type="hidden" name="slatAction" value="admin:main.setupinitialadmin" />
					
					<cfset processObject = rc.fw.getHibachiScope().getAccount().getProcessObject("setupInitialAdmin") />
							
					<fieldset class="dl-horizontal">
						<cf_HibachiPropertyDisplay object="#processObject#" property="firstName" edit="true" title="#rc.fw.getHibachiScope().rbKey('entity.account.firstName')#" />
						<cf_HibachiPropertyDisplay object="#processObject#" property="lastName" edit="true" title="#rc.fw.getHibachiScope().rbKey('entity.account.lastName')#" />
						<cf_HibachiPropertyDisplay object="#processObject#" property="company" edit="true" title="#rc.fw.getHibachiScope().rbKey('entity.account.company')#" />
						<cf_HibachiPropertyDisplay object="#processObject#" property="emailAddress" edit="true" />
						<cf_HibachiPropertyDisplay object="#processObject#" property="emailAddressConfirm" edit="true" />
						<cf_HibachiPropertyDisplay object="#processObject#" property="password" edit="true" />
						<cf_HibachiPropertyDisplay object="#processObject#" property="passwordConfirm" edit="true" />
						<button type="submit" class="btn btn-primary pull-right">Create & Login</button>
					</fieldset>
				</form>
			</div>
		</cfif>
	</div>
</cfoutput>
