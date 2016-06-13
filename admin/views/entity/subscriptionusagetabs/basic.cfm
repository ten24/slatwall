<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.subscriptionUsage" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList divClass="col-md-6">
			<!--- Account --->
			<cfif rc.edit>
				<hb:HibachiPropertyDisplay object="#rc.subscriptionUsage#" property="account" fieldtype="textautocomplete" autocompletePropertyIdentifiers="adminIcon,fullName,company,emailAddress,phoneNumber,address.simpleRepresentation" edit="true">
			<cfelseif !isNull(rc.subscriptionUsage.getAccount())>
				<hb:HibachiPropertyDisplay object="#rc.subscriptionUsage.getAccount()#" property="fullName" valuelink="?slatAction=admin:entity.detailaccount&accountID=#rc.subscriptionUsage.getAccount().getAccountID()#" title="#$.slatwall.rbKey('entity.account')#">
			</cfif>
			<hb:HibachiPropertyDisplay object="#rc.subscriptionUsage#" property="currentStatusType" edit="false">
			<hb:HibachiPropertyDisplay object="#rc.subscriptionUsage#" property="subscriptionOrderItemType" edit="false">
			<hb:HibachiPropertyDisplay object="#rc.subscriptionUsage#" property="autoRenewFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.subscriptionUsage#" property="autoPayFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.subscriptionUsage#" property="initialTerm" edit="false">
			<hb:HibachiPropertyDisplay object="#rc.subscriptionUsage#" property="accountPaymentMethod" edit="#rc.edit#">
		</hb:HibachiPropertyList>
		<hb:HibachiPropertyList divClass="col-md-6">
			<hb:HibachiPropertyDisplay object="#rc.subscriptionUsage#" property="expirationDate" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.subscriptionUsage#" property="gracePeriodTerm" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.subscriptionUsage#" property="nextBillDate" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.subscriptionUsage#" property="nextReminderEmailDate" edit="#rc.edit#">
			<cfif !isNull(rc.subscriptionUsage.getInitialSku())>
				<hb:HibachiPropertyDisplay object="#rc.subscriptionUsage.getInitialSku()#" property="skuCode" edit="false" title="#$.slatwall.getRBKey('define.initialSku')#" valuelink="#$.slatwall.buildURL(action='admin:entity.detailsku',querystring='skuID=#rc.subscriptionUsage.getInitialSku().getSkuID()#')#">
			</cfif>
			<cfif rc.edit>
				<cfif !isNull(rc.subscriptionUsage.getRenewalSku())>
					<cfset renewalSkuID = rc.subscriptionUsage.getRenewalSku().getSkuID() />
				<cfelse>
					<cfset renewalSkuID = "" />
				</cfif>
				<hb:HibachiPropertyDisplay object="#rc.subscriptionUsage#" property="useRenewalSku" edit=true>
				<hb:HibachiDisplayToggle selector="input[name='useRenewalSku']" showvalues="1" loadVisable="#!isNull(rc.subscriptionUsage.getRenewalSku())#">
					<swa:SlatwallErrorDisplay object="#rc.subscriptionUsage#" errorName="renewalSku" />
					<hb:HibachiListingDisplay smartList="#rc.subscriptionUsage.getSubscriptionSkuSmartList()#"
											  selectValue="#renewalSkuID#"
											  selectFieldName="renewalSku.skuID"
											  title="#$.slatwall.rbKey('define.renewalSku')#"
											  edit="#rc.edit#">
						<hb:HibachiListingColumn propertyIdentifier="skuCode" />
						<hb:HibachiListingColumn propertyIdentifier="skuName" />
						<hb:HibachiListingColumn propertyIdentifier="subscriptionTerm.subscriptionTermName" title="#$.slatwall.getRBKey('define.renewalTerm')#"/>
						<hb:HibachiListingColumn propertyIdentifier="renewalPrice" />
					</hb:HibachiListingDisplay>
				</hb:HibachiDisplayToggle>
			<cfelseif !isNull(rc.subscriptionUsage.getRenewalSku())>
				<hb:HibachiPropertyDisplay object="#rc.subscriptionUsage.getRenewalSku()#" fieldname="renewalSku.skuCode" property="skuCode" edit="#rc.edit#" title="#$.slatwall.getRBKey('define.renewalSku')#" valuelink="#$.slatwall.buildURL(action='admin:entity.detailsku',querystring='skuID=#rc.subscriptionUsage.getRenewalSku().getSkuID()#')#"/>
			</cfif>
			<hb:HibachiPropertyDisplay object="#rc.subscriptionUsage#" property="renewalPrice" edit="#rc.edit#">
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>

</cfoutput>

