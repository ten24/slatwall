<cfparam name="rc.UID" default="" />
<cfparam name="rc.UIDSig" default="" />
<cfparam name="rc.UIDSignature" default="" />

<cfoutput>
	<div class="well tabable" style="width:400px;margin: 0px auto;">
		<h3>Link Slatwall Account</h3>
		<br />
		<p>Because you have never used this social media profile before with your account, you will need to connect it with your existing slatwall account.</p>
		<cfset authorizeProcessObject = $.slatwall.getAccount().getProcessObject("login") />
		<form action="?s=1" class="form-horizontal" method="post">
			<input type="hidden" name="slatAction" value="gigya:main.attachExistingUser" />
			<input type="hidden" name="UID" value="#rc.UID#" />
			<input type="hidden" name="UIDSig" value="#rc.UIDSig#" />
			<input type="hidden" name="UIDSignature" value="#rc.UIDSignature#" />
			
			<cfif structKeyExists(rc, "sRedirectURL")>
				<input type="hidden" name="sRedirectURL" value="#rc.sRedirectURL#" />
			</cfif>
			<fieldset class="dl-horizontal">
				<fieldset class="dl-horizontal">
					<cf_HibachiPropertyDisplay object="#authorizeProcessObject#" property="emailAddress" edit="true" title="#rc.fw.getHibachiScope().rbKey('entity.account.emailAddress')#" />
					<cf_HibachiPropertyDisplay object="#authorizeProcessObject#" property="password" edit="true" title="#rc.fw.getHibachiScope().rbKey('entity.account.password')#" />
				</fieldset>
				<button type="submit" class="btn btn-primary pull-right">Link Accounts</button>
			</fieldset>
		</form>
	</div>
</cfoutput>