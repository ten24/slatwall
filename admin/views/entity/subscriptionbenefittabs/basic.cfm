<cfparam name="rc.subscriptionBenefit" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.subscriptionBenefit#" edit="#rc.edit#">
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList>
				<cf_HibachiPropertyDisplay object="#rc.subscriptionBenefit#" property="subscriptionBenefitName" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.subscriptionBenefit#" property="accessType" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.subscriptionBenefit#" property="maxUseCount" edit="#rc.edit#">
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
	</cf_HibachiEntityDetailForm>
</cfoutput>