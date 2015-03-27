<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.subscriptionTerm" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList divClass="col-md-6">
			<hb:HibachiPropertyDisplay object="#rc.subscriptionTerm#" property="subscriptionTermName" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.subscriptionTerm#" property="initialTerm" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.subscriptionTerm#" property="renewalTerm" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.subscriptionTerm#" property="gracePeriodTerm" edit="#rc.edit#">
		</hb:HibachiPropertyList>
		<hb:HibachiPropertyList divClass="col-md-6">
			<!---<hb:HibachiPropertyDisplay object="#rc.subscriptionTerm#" property="allowProrateFlag" edit="#rc.edit#">--->
			<hb:HibachiPropertyDisplay object="#rc.subscriptionTerm#" property="autoRenewFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.subscriptionTerm#" property="autoPayFlag" edit="#rc.edit#">
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>