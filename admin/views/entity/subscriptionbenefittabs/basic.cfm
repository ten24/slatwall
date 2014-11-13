<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.subscriptionBenefit" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.subscriptionBenefit#" property="subscriptionBenefitName" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.subscriptionBenefit#" property="accessType" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.subscriptionBenefit#" property="maxUseCount" edit="#rc.edit#">
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>