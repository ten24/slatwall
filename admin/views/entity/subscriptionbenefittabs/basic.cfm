<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.subscriptionBenefit" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList>
			<cf_HibachiPropertyDisplay object="#rc.subscriptionBenefit#" property="subscriptionBenefitName" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.subscriptionBenefit#" property="accessType" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.subscriptionBenefit#" property="maxUseCount" edit="#rc.edit#">
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
</cfoutput>