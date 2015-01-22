<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.promotionQualifier" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<cfif listFindNoCase("merchandise,subscription,contentaccess", rc.qualifierType)>
				<hb:HibachiPropertyDisplay object="#rc.promotionQualifier#" property="minimumItemQuantity" edit="#rc.edit#" />
				<hb:HibachiPropertyDisplay object="#rc.promotionQualifier#" property="maximumItemQuantity" edit="#rc.edit#" />
				<hb:HibachiPropertyDisplay object="#rc.promotionQualifier#" property="minimumItemPrice" edit="#rc.edit#" />
				<hb:HibachiPropertyDisplay object="#rc.promotionQualifier#" property="maximumItemPrice" edit="#rc.edit#" />
				<hb:HibachiPropertyDisplay object="#rc.promotionQualifier#" property="rewardMatchingType" edit="#rc.edit#" />
			<cfelseif rc.qualifierType eq "fulfillment">
				<hb:HibachiPropertyDisplay object="#rc.promotionQualifier#" property="minimumFulfillmentWeight" edit="#rc.edit#" />
				<hb:HibachiPropertyDisplay object="#rc.promotionQualifier#" property="maximumFulfillmentWeight" edit="#rc.edit#" />
			<cfelseif rc.qualifierType eq "order">
				<hb:HibachiPropertyDisplay object="#rc.promotionQualifier#" property="minimumOrderQuantity" edit="#rc.edit#" />
				<hb:HibachiPropertyDisplay object="#rc.promotionQualifier#" property="maximumOrderQuantity" edit="#rc.edit#" />
				<hb:HibachiPropertyDisplay object="#rc.promotionQualifier#" property="minimumOrderSubtotal" edit="#rc.edit#" />
				<hb:HibachiPropertyDisplay object="#rc.promotionQualifier#" property="maximumOrderSubtotal" edit="#rc.edit#" />
			</cfif>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>