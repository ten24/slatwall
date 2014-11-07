<cfparam name="rc.account" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList divclass="col-md-8">
			<cf_HibachiPropertyDisplay object="#rc.account#" property="firstName" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.account#" property="lastName" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.account#" property="company" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.account#" property="superUserFlag" edit="#rc.edit and $.slatwall.getAccount().getSuperUserFlag()#">
		</cf_HibachiPropertyList>
		
		<!--- Overview --->
		<cf_HibachiPropertyList divclass="col-md-4">
			<cf_HibachiPropertyTable>
				
				<!--- Term Payment Details --->
				<cf_HibachiPropertyTableBreak header="#$.slatwall.rbKey('admin.entity.detailaccount.termPaymentDetails')#" />
				<cf_HibachiPropertyDisplay object="#rc.account#" property="termAccountBalance" edit="false" displayType="table">
				<cf_HibachiPropertyDisplay object="#rc.account#" property="termAccountAvailableCredit" edit="false" displayType="table">
				
				<!--- Authentication Details --->
				<cf_HibachiPropertyTableBreak header="#$.slatwall.rbKey('admin.entity.detailaccount.authenticationDetails')#" hint="#$.slatwall.rbKey("admin.entity.detailaccount.authenticationDetails_hint")#" />
				<cf_HibachiPropertyDisplay object="#rc.account#" property="guestAccountFlag" edit="false" displayType="table">
				<cfloop array="#rc.account.getActiveAccountAuthentications()#" index="accountAuthentication">
					<cfsavecontent variable="thisValue">
						<cf_HibachiActionCaller text="#$.slatwall.rbKey('define.remove')#" action="admin:entity.deleteAccountAuthentication" queryString="accountAuthenticationID=#accountAuthentication.getAccountAuthenticationID()#&redirectAction=admin:entity.detailAccount&accountID=#rc.account.getAccountID()#" />
					</cfsavecontent>
					<cf_HibachiFieldDisplay title="#accountAuthentication.getSimpleRepresentation()#" value="#thisValue#" edit="false" displayType="table">	
				</cfloop>
			</cf_HibachiPropertyTable>
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
</cfoutput>