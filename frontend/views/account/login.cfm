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
<!--- Mura Variables --->
<cfparam name="request.status" default="" />
<cfparam name="request.isBlocked" default="false" />
<cfparam name="rc.forgotPasswordResult" default="" />

<cfoutput>
	<div class="svoaccountlogin">
		<cfif request.status eq 'failed'>
			<cfif isDate(session.blockLoginUntil) and session.blockLoginUntil gt now()>
				<cfset request.isBlocked=true />
				<p id="loginMsg" class="error">#$.slatwall.rbKey('validate.account.loginblocked')#</p>
			<cfelse>
				<p id="loginMsg" class="error">#$.slatwall.rbKey('validate.account.loginfailed')#</p>
			</cfif>
		</cfif>
		<cfif len(rc.forgotPasswordResult)>
			<cfif FindNoCase('is not a valid',rc.forgotPasswordResult)>
				<div class="error">#$.slatwall.rbKey('validate.account.forgotnotvalid')#
			<cfelseif FindNoCase('no account',rc.forgotPasswordResult)>
				<div class="error">#$.slatwall.rbKey('validate.account.forgotnotfound')#
			<cfelse>
				<div class="notice">#$.slatwall.rbKey('validate.account.forgotsuccess')#</cfif>
			</div>
		</cfif>
		<form name="loginAccount" method="post" action="?nocache=1">
			<h5>Account Login</h5>
			<dl>
				<dt>E-Mail Address</dt>
				<dd><input type="text" name="username" value="" /></dd>
				<dt>Password</dt>
				<dd><input type="password" name="password" value="" /></dd>
			</dl>
			<cfif $.event('loginSlatAction') neq "">
				<cfset loginSlatAction = $.event('loginSlatAction') />
			<cfelse>
				<cfset loginSlatAction = "frontend:account.login" />
			</cfif>
			<input type="hidden" name="slatAction" value="#loginSlatAction#" />
			<input type="hidden" name="returnURL" value="#$.event('returnURL')#" />
			<button type="submit">Login</button>
			<a href="##" class="forgotPassword">Forgot Password</a>
			<div class="forgotPassword" style="display:none;">
				<p>#$.slatwall.rbKey('validate.account.forgotloginmessage')#</p>
				Email Address: <input type="text" name="forgotPasswordEmail" value="" /><button type="submit">Submit</button>
			</div>
		</form>
		<script type="text/javascript">
			jQuery(document).ready(function() {
				jQuery('a.forgotPassword').click(function(e){
					e.preventDefault();
					jQuery('div.forgotPassword').toggle();
				});
			});
		</script>
	</div>
</cfoutput>
