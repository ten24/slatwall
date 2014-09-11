<cfparam name="rc.promotionQualifier" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList>
			<cfif listFindNoCase("merchandise,subscription,contentaccess", rc.qualifierType)>
				<cf_HibachiPropertyDisplay object="#rc.promotionQualifier#" property="minimumItemQuantity" edit="#rc.edit#" />
				<cf_HibachiPropertyDisplay object="#rc.promotionQualifier#" property="maximumItemQuantity" edit="#rc.edit#" />
				<cf_HibachiPropertyDisplay object="#rc.promotionQualifier#" property="minimumItemPrice" edit="#rc.edit#" />
				<cf_HibachiPropertyDisplay object="#rc.promotionQualifier#" property="maximumItemPrice" edit="#rc.edit#" />
				<cf_HibachiPropertyDisplay object="#rc.promotionQualifier#" property="rewardMatchingType" edit="#rc.edit#" />
			<cfelseif rc.qualifierType eq "fulfillment">
				<cf_HibachiPropertyDisplay object="#rc.promotionQualifier#" property="minimumFulfillmentWeight" edit="#rc.edit#" />
				<cf_HibachiPropertyDisplay object="#rc.promotionQualifier#" property="maximumFulfillmentWeight" edit="#rc.edit#" />
			<cfelseif rc.qualifierType eq "order">
				<cf_HibachiPropertyDisplay object="#rc.promotionQualifier#" property="minimumOrderQuantity" edit="#rc.edit#" />
				<cf_HibachiPropertyDisplay object="#rc.promotionQualifier#" property="maximumOrderQuantity" edit="#rc.edit#" />
				<cf_HibachiPropertyDisplay object="#rc.promotionQualifier#" property="minimumOrderSubtotal" edit="#rc.edit#" />
				<cf_HibachiPropertyDisplay object="#rc.promotionQualifier#" property="maximumOrderSubtotal" edit="#rc.edit#" />
			</cfif>
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
</cfoutput>