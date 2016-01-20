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
	<div class="container s-login-container">

		<div class="s-login-wrapper col-xs-6 col-xs-offset-3">

			<div class="s-logo">

				<img src="#request.slatwallScope.getBaseURL()#/assets/images/logo-1x.png" alt="Slatwall"
					 srcset="#request.slatwallScope.getBaseURL()#/assets/images/logo-2x.png 2x">
			</div>
			<hb:HibachiMessageDisplay />

			<!--- RESET PASSWORD FROM FORGOT PASSWORD EMAIL --->
			<cfif len(rc.swprid) eq 64>

				<form id="adminResetPasswordForm" action="?s=1" class="s-form-signin" method="post">
					<h2>Reset Password</h2>
					<input type="hidden" name="slatAction" value="admin:main.resetPassword" />
					<input type="hidden" name="swprid" value="#rc.swprid#" />
					<input type="hidden" name="accountID" value="#left(rc.swprid, 32)#" />

					<cfif structKeyExists(rc,'processObject')>
						<cfset processObject = rc.processObject />
					<cfelse>
						<cfset processObject = rc.fw.getHibachiScope().getAccount(left(rc.swprid, 32)).getProcessObject("resetPassword") />
					</cfif>

					<hb:HibachiErrorDisplay object="#processObject#" errorName="swprid" />
					<hb:HibachiPropertyDisplay object="#processObject#" property="password" edit="true" fieldAttributes="placeholder='Password'" />
					<hb:HibachiPropertyDisplay object="#processObject#" property="passwordConfirm" edit="true" fieldAttributes="placeholder='Confirm Password'"/>

					<button type="submit" class="btn btn-lg s-btn-ten24 pull-right">Reset & Login</button>
				</form>

			<cfelseif rc.accountAuthenticationExists>
				<cfset authorizeProcessObject = rc.fw.getHibachiScope().getAccount().getProcessObject("login") />
				<cfset updateProcessObject = rc.fw.getHibachiScope().getAccount().getProcessObject("updatePassword") />

				<!--- UPDATE PASSWORD BECAUSE OF FORCE RESET --->
				<cfif (authorizeProcessObject.hasError('passwordUpdateRequired') OR updateProcessObject.hasErrors())>

					<form id="adminLoginForm" action="?s=1" class="s-form-signin" method="post">
						<h2>Password Update Required</h2>
						<input type="hidden" name="slatAction" value="admin:main.updatePassword" />
						<hb:HibachiPropertyDisplay object="#updateProcessObject#" property="emailAddress" edit="true" title="#rc.fw.getHibachiScope().rbKey('entity.account.emailAddress')#" fieldAttributes="autocomplete='off' placeholder='Email Address'" />
						<hb:HibachiPropertyDisplay object="#updateProcessObject#" property="existingPassword" edit="true" fieldAttributes="placeholder='Old Password'"/>
						<hb:HibachiPropertyDisplay object="#updateProcessObject#" property="password" edit="true" fieldAttributes="placeholder='Password'"/>
						<hb:HibachiPropertyDisplay object="#updateProcessObject#" property="passwordConfirm" edit="true" fieldAttributes="placeholder='Confirm Password'"/>
						<button type="submit" class="btn btn-lg s-btn-ten24 pull-right">#$.slatwall.rbKey('define.login')#</button>
					</form>
				<!--- LOGIN & FORGOT PASSWORD --->
				<cfelse>

					<!--- LOGIN --->
					<cfset authorizeProcessObject = rc.fw.getHibachiScope().getAccount().getProcessObject("login") />
					<form class="s-form-signin" action="?s=1" id="j-login-wrapper" method="post" novalidate="novalidate">
						<!--- <h2>#$.slatwall.rbKey('define.login')#</h2> --->
						<input type="hidden" name="slatAction" value="admin:main.authorizelogin" />
						<cfif structKeyExists(rc, "sRedirectURL")>
							<input type="hidden" name="sRedirectURL" value="#rc.sRedirectURL#" />
						</cfif>
						<hb:HibachiPropertyDisplay object="#authorizeProcessObject#" property="emailAddress" edit="true" title="#rc.fw.getHibachiScope().rbKey('entity.account.emailAddress')#" fieldAttributes="autocomplete='off' placeholder='Email Address' required" />
						<hb:HibachiPropertyDisplay object="#authorizeProcessObject#" property="password" edit="true" title="#rc.fw.getHibachiScope().rbKey('entity.account.password')#" fieldAttributes="autocomplete='off' placeholder='Password' required" />
						<a href="##" id="j-forgot-password" class="s-forgot-password-link s-login-link" tabindex="-1">Forgot Password</a>
						<button type="submit" class="btn btn-lg btn-primary">#$.slatwall.rbKey('define.login')#</button>
					</form>

					<!--- FORGOT PASSWORD --->
					<cfset forgotPasswordProcessObject = rc.fw.getHibachiScope().getAccount().getProcessObject("forgotPassword") />
					<form class="s-form-signin" action="?s=1"  method="post" id="j-forgot-password-wrapper" novalidate="novalidate">
						<h2>#$.slatwall.rbKey('admin.main.forgotPassword')#</h2>
						<input type="hidden" name="slatAction" value="admin:main.forgotpassword" />
						<a href="##" id="j-back-to-login" class="s-login-link"><i class="fa fa-angle-double-left"></i> Back To Login</a>
						<hb:HibachiPropertyDisplay object="#forgotPasswordProcessObject#" property="emailAddress" edit="true" fieldAttributes="autocomplete='off' placeholder='Email'" />
						<button type="submit" class="btn btn-lg btn-primary">#$.slatwall.rbKey('admin.main.sendPasswordReset')#</button>
					</form>

					<!--- INTEGRATION LOGINS --->
					<cfloop array="#rc.integrationLoginHTMLArray#" index="loginHTML">
						<hr />
						#loginHTML#
					</cfloop>

				</cfif>

			<cfelse>

				<!--- CREATE SUPER USER --->
				<form id="adminCreateSuperUserForm" class="s-form-signin" action="?s=1" method="post">
					<h2>Setup Super User</h2>
					<input type="hidden" name="slatAction" value="admin:main.setupinitialadmin" />
					<cfset processObject = rc.fw.getHibachiScope().getAccount().getProcessObject("setupInitialAdmin") />
					<hb:HibachiPropertyDisplay object="#processObject#" property="firstName" edit="true" title="#rc.fw.getHibachiScope().rbKey('entity.account.firstName')#" fieldAttributes="placeholder='First Name'" />
					<hb:HibachiPropertyDisplay object="#processObject#" property="lastName" edit="true" title="#rc.fw.getHibachiScope().rbKey('entity.account.lastName')#" fieldAttributes="placeholder='Last Name'" />
					<hb:HibachiPropertyDisplay object="#processObject#" property="company" edit="true" title="#rc.fw.getHibachiScope().rbKey('entity.account.company')#" fieldAttributes="placeholder='Company'" />
					<hb:HibachiPropertyDisplay object="#processObject#" property="emailAddress" edit="true" fieldAttributes="placeholder='Email'"/>
					<hb:HibachiPropertyDisplay object="#processObject#" property="emailAddressConfirm" edit="true" fieldAttributes="placeholder='Confirm Email'" />
					<hb:HibachiPropertyDisplay object="#processObject#" property="password" edit="true" fieldAttributes="placeholder='Password'"/>
					<hb:HibachiPropertyDisplay object="#processObject#" property="passwordConfirm" edit="true" fieldAttributes="placeholder='Confirm Password'"/>
					<button type="submit" class="btn btn-lg btn-primary pull-right">Create & Login</button>
				</form>

			</cfif>

		</div>
	</div>

</cfoutput>