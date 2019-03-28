<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.account" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList divclass="col-md-6">
			<hb:HibachiPropertyDisplay object="#rc.account#" property="firstName" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.account#" property="lastName" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.account#" property="company" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.account#" property="accountCreatedSite" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.account#" property="superUserFlag" edit="#rc.edit and $.slatwall.getAccount().getSuperUserFlag()#">
			<hb:HibachiPropertyDisplay object="#rc.account#" property="taxExemptFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.account#" property="testAccountFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.account#" property="verifiedAccountFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.account#" property="organizationFlag" edit="#rc.edit#">
			<cfif not isNull(rc.account.getOrganizationFlag())  and rc.account.getOrganizationFlag()>
				<hb:HibachiPropertyDisplay object="#rc.account#" property="accountCode" edit="#rc.edit#">
			</cfif>
		</hb:HibachiPropertyList>

		<!--- Overview --->
		<hb:HibachiPropertyList divclass="col-md-6">
			<hb:HibachiPropertyTable>

				<!--- Authentication Details --->
				<hb:HibachiPropertyTableBreak header="#$.slatwall.rbKey('admin.entity.detailaccount.authenticationDetails')#" hint="#$.slatwall.rbKey("admin.entity.detailaccount.authenticationDetails_hint")#" />
				<hb:HibachiPropertyDisplay object="#rc.account#" property="guestAccountFlag" edit="false" displayType="table">
				<cfloop array="#rc.account.getActiveAccountAuthentications()#" index="accountAuthentication">
					<cfsavecontent variable="thisValue">
						<hb:HibachiActionCaller text="#$.slatwall.rbKey('define.remove')#" action="admin:entity.deleteAccountAuthentication" queryString="accountAuthenticationID=#accountAuthentication.getAccountAuthenticationID()#&redirectAction=admin:entity.detailAccount&accountID=#rc.account.getAccountID()#" />
					</cfsavecontent>
					<hb:HibachiFieldDisplay ignoreHTMLEditFormat="true" title="#accountAuthentication.getSimpleRepresentation()#" value="#thisValue#" edit="false" displayType="table">
				</cfloop>
				<cfsavecontent variable="faValue">
					<!--- Check display button to disable two factor authentication --->
					<cfif rc.account.getTwoFactorAuthenticationFlag()>
						<hb:HibachiProcessCaller action="admin:entity.processAccount" entity="#rc.account#" processContext="removeTwoFactorAuthentication" class="btn btn-primary" modal="false" />
					<!--- Display button to enable two factor authentication --->
					<cfelse>
						<p>#$.slatwall.rbKey('admin.entity.accounttabs.twofactorauthentication.disabled')#</p>
						<p>#$.slatwall.rbKey('admin.entity.accounttabs.twofactorauthentication.security_info')#</p>
						<hb:HibachiProcessCaller action="admin:entity.preProcessAccount" entity="#rc.account#" processContext="addTwoFactorAuthentication" class="btn btn-primary" modal="true" />
					</cfif>
					<!---<hb:HibachiProcessCaller action="admin:entity.processAccount" entity="#rc.account#" processContext="removeTwoFactorAuthentication" class="btn btn-primary" modal="false" />--->
				</cfsavecontent>
				<hb:HibachiFieldDisplay ignoreHTMLEditFormat="true" title="#$.slatwall.rbKey('admin.entity.accounttabs.twofactorauthentication')#" value="#faValue#" edit="false" displayType="table">
			</hb:HibachiPropertyTable>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>
