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
<cfparam name="rc.accountAuthenticationExists" type="boolean" />
<cfparam name="rc.swprid" type="string" default="" />
<cfparam name="rc.integrationLoginHTMLArray" type="array" />

<cfoutput>
	<div class="s-login">
		<hb:HibachiMessageDisplay />

		<div class="well tabable s-login-box">

			<!--- RESET PASSWORD FROM FORGOT PASSWORD EMAIL --->
			<cfif len(rc.swprid) eq 64>

				<h2>Reset Password</h2>
				<br />
				<form id="adminResetPasswordForm" action="?s=1" class="form-horizontal s-login-reset" method="post">
					<input type="hidden" name="slatAction" value="admin:main.resetPassword" />
					<input type="hidden" name="swprid" value="#rc.swprid#" />
					<input type="hidden" name="accountID" value="#left(rc.swprid, 32)#" />

					<cfset processObject = rc.fw.getHibachiScope().getAccount().getProcessObject("resetPassword") />

					<hb:HibachiErrorDisplay object="#processObject#" errorName="swprid" />

					<hb:HibachiPropertyDisplay object="#processObject#" property="password" edit="true" />
					<hb:HibachiPropertyDisplay object="#processObject#" property="passwordConfirm" edit="true" />

					<button type="submit" class="btn btn-sm s-btn-ten24 pull-right">Reset & Login</button>
				</form>

			<cfelseif rc.accountAuthenticationExists>

				<cfset authorizeProcessObject = rc.fw.getHibachiScope().getAccount().getProcessObject("login") />
				<cfset updateProcessObject = rc.fw.getHibachiScope().getAccount().getProcessObject("updatePassword") />

				<!--- UPDATE PASSWORD BECAUSE OF FORCE RESET --->
				<cfif (authorizeProcessObject.hasError('passwordUpdateRequired') OR updateProcessObject.hasErrors())>

					<h3>Password Update Required</h3>
					<br />

					<form id="adminLoginForm" action="?s=1" class="form-horizontal" method="post">
						<input type="hidden" name="slatAction" value="admin:main.updatePassword" />

								<hb:HibachiPropertyDisplay object="#updateProcessObject#" property="emailAddress" edit="true" title="#rc.fw.getHibachiScope().rbKey('entity.account.emailAddress')#" fieldAttributes="autocomplete='off'" />
						<hb:HibachiPropertyDisplay object="#updateProcessObject#" property="existingPassword" edit="true" />
						<hb:HibachiPropertyDisplay object="#updateProcessObject#" property="password" edit="true" />
						<hb:HibachiPropertyDisplay object="#updateProcessObject#" property="passwordConfirm" edit="true" />

						<button type="submit" class="btn btn-sm s-btn-ten24 pull-right">#$.slatwall.rbKey('define.login')#</button>

					</form>

				<!--- LOGIN & FORGOT PASSWORD --->
				<cfelse>

					<!--- LOGIN --->
					<h2>#$.slatwall.rbKey('define.login')#</h2>
					<cfset authorizeProcessObject = rc.fw.getHibachiScope().getAccount().getProcessObject("login") />
					<form id="adminLoginForm" action="?s=1" class="form-horizontal" method="post" style="display:inline-block;width:100%;">
						<input type="hidden" name="slatAction" value="admin:main.authorizelogin" />
						<cfif structKeyExists(rc, "sRedirectURL")>
							<input type="hidden" name="sRedirectURL" value="#rc.sRedirectURL#" />
						</cfif>


								<hb:HibachiPropertyDisplay object="#authorizeProcessObject#" property="emailAddress" edit="true" title="#rc.fw.getHibachiScope().rbKey('entity.account.emailAddress')#" fieldAttributes="autocomplete='off'" />
						<hb:HibachiPropertyDisplay object="#authorizeProcessObject#" property="password" edit="true" title="#rc.fw.getHibachiScope().rbKey('entity.account.password')#" />

						<button type="submit" class="btn btn-sm s-btn-ten24 pull-right">#$.slatwall.rbKey('define.login')#</button>

					</form>
					<hr style="border-top:1px solid ##DDD;"/>

					<!--- FORGOT PASSWORD --->
					<h2>#$.slatwall.rbKey('admin.main.forgotPassword')#</h2>
					<cfset forgotPasswordProcessObject = rc.fw.getHibachiScope().getAccount().getProcessObject("forgotPassword") />
					<form id="adminForgotPasswordForm" action="?s=1" class="form-horizontal" method="post">
						<input type="hidden" name="slatAction" value="admin:main.forgotpassword" />

								<hb:HibachiPropertyDisplay object="#forgotPasswordProcessObject#" property="emailAddress" edit="true" fieldAttributes="autocomplete='off'" />

						<button type="submit" class="btn btn-sm s-btn-ten24 pull-right">#$.slatwall.rbKey('admin.main.sendPasswordReset')#</button>

	                    <div class="clearfix"></div>
					</form>

					<!--- INTEGRATION LOGINS --->
					<cfloop array="#rc.integrationLoginHTMLArray#" index="loginHTML">
						<hr />
						#loginHTML#
					</cfloop>

				</cfif>

			<!--- CREATE SUPER USER --->
			<cfelse>
				<sw-admin-create-super-user
				>
				</sw-admin-create-super-user>
				<!---begin angular login form --->
				<!---<h2>Create Super Administrator Account</h2>
				<br />
				<form id="adminCreateSuperUserForm" action="?s=1" class="form-horizontal" method="post" style="display:inline-block;width:100%;">
					<input type="hidden" name="slatAction" value="admin:main.setupinitialadmin" />

					<cfset processObject = rc.fw.getHibachiScope().getAccount().getProcessObject("setupInitialAdmin") />

					<hb:HibachiPropertyDisplay object="#processObject#" property="firstName" edit="true" title="#rc.fw.getHibachiScope().rbKey('entity.account.firstName')#" />
					<hb:HibachiPropertyDisplay object="#processObject#" property="lastName" edit="true" title="#rc.fw.getHibachiScope().rbKey('entity.account.lastName')#" />
					<hb:HibachiPropertyDisplay object="#processObject#" property="company" edit="true" title="#rc.fw.getHibachiScope().rbKey('entity.account.company')#" />
					<hb:HibachiPropertyDisplay object="#processObject#" property="emailAddress" edit="true" />
					<hb:HibachiPropertyDisplay object="#processObject#" property="emailAddressConfirm" edit="true" />
					<hb:HibachiPropertyDisplay object="#processObject#" property="password" edit="true" />
					<hb:HibachiPropertyDisplay object="#processObject#" property="passwordConfirm" edit="true" />
					<button type="submit" class="btn btn-sm s-btn-ten24 pull-right">Create & Login</button>

				</form>--->
				
			</cfif>
		</div>
	</div>
</cfoutput>
