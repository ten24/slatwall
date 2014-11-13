<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.subscriptionTerm" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList divClass="col-md-6">
			<cf_HibachiPropertyDisplay object="#rc.subscriptionTerm#" property="subscriptionTermName" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.subscriptionTerm#" property="initialTerm" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.subscriptionTerm#" property="renewalTerm" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.subscriptionTerm#" property="gracePeriodTerm" edit="#rc.edit#">
		</cf_HibachiPropertyList>
		<cf_HibachiPropertyList divClass="col-md-6">
			<!---<cf_HibachiPropertyDisplay object="#rc.subscriptionTerm#" property="allowProrateFlag" edit="#rc.edit#">--->
			<cf_HibachiPropertyDisplay object="#rc.subscriptionTerm#" property="autoRenewFlag" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.subscriptionTerm#" property="autoPayFlag" edit="#rc.edit#">
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
</cfoutput>