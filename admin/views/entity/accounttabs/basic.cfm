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
			<hb:HibachiPropertyDisplay object="#rc.account#" property="superUserFlag" edit="#rc.edit and $.slatwall.getAccount().getSuperUserFlag()#">
			<hb:HibachiPropertyDisplay object="#rc.account#" property="taxExemptFlag" edit="#rc.edit#">
		</hb:HibachiPropertyList>
		
		<!--- Overview --->
		<hb:HibachiPropertyList divclass="col-md-6">
			<hb:HibachiPropertyTable>
				
				<!--- Term Payment Details --->
				<hb:HibachiPropertyTableBreak header="#$.slatwall.rbKey('admin.entity.detailaccount.termPaymentDetails')#" />
				<hb:HibachiPropertyDisplay object="#rc.account#" property="termAccountBalance" edit="false" displayType="table">
				<hb:HibachiPropertyDisplay object="#rc.account#" property="termAccountAvailableCredit" edit="false" displayType="table">
				
				<!--- Authentication Details --->
				<hb:HibachiPropertyTableBreak header="#$.slatwall.rbKey('admin.entity.detailaccount.authenticationDetails')#" hint="#$.slatwall.rbKey("admin.entity.detailaccount.authenticationDetails_hint")#" />
				<hb:HibachiPropertyDisplay object="#rc.account#" property="guestAccountFlag" edit="false" displayType="table">
				<cfloop array="#rc.account.getActiveAccountAuthentications()#" index="accountAuthentication">
					<cfsavecontent variable="thisValue">
						<hb:HibachiActionCaller text="#$.slatwall.rbKey('define.remove')#" action="admin:entity.deleteAccountAuthentication" queryString="accountAuthenticationID=#accountAuthentication.getAccountAuthenticationID()#&redirectAction=admin:entity.detailAccount&accountID=#rc.account.getAccountID()#" />
					</cfsavecontent>
					<hb:HibachiFieldDisplay ignoreHTMLEditFormat="true" title="#accountAuthentication.getSimpleRepresentation()#" value="#thisValue#" edit="false" displayType="table">	
				</cfloop>
			</hb:HibachiPropertyTable>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>