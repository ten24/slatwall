<cfimport prefix="swa" taglib="../../../../../tags" />
<cfimport prefix="hb" taglib="../../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.promotionreward" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<!---<cfdump var="#rc.promotionreward#" top=3 />--->
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<input type="hidden" name="rewardType" value="#rc.rewardType#" />
			<input type="hidden" name="promotionperiod.promotionperiodID" value="#rc.promotionperiod.getPromotionperiodID()#" />
			<input type="hidden" name="promotionperiodID" value="#rc.promotionperiod.getPromotionperiodID()#" />
			<cfif rc.rewardType NEQ "canPlaceOrder" AND rc.rewardType NEQ "rewardSku" >
				<hb:HibachiPropertyDisplay object="#rc.promotionreward#" property="amountType" fieldType="select" edit="#rc.edit#" />
				<hb:HibachiPropertyDisplay object="#rc.promotionreward#" property="amount" edit="#rc.edit#" />
				<hb:HibachiDisplayToggle selector="select[name=amountType]" showValues="percentageOff" loadVisable="#rc.promotionReward.getNewFlag() || rc.promotionReward.getValueByPropertyIdentifier('amountType') eq 'percentageOff'#">
					<hb:HibachiPropertyDisplay object="#rc.promotionreward#" property="roundingRule" edit="#rc.edit#" />
				</hb:HibachiDisplayToggle>
				<hb:HibachiDisplayToggle selector="select[name=amountType]" showValues="amountOff,amount" loadVisable="#listfind('amountOff,amount',rc.promotionReward.getValueByPropertyIdentifier('amountType')) neq 0#">
					<hb:HibachiPropertyDisplay object="#rc.promotionreward#" property="currencyCode" fieldType="select" edit="#rc.edit#" />
				</hb:HibachiDisplayToggle>
				<cfif listFindNoCase("merchandise,subscription,contentaccess", rc.rewardType)>
					<hb:HibachiPropertyDisplay object="#rc.promotionreward#" property="publishedFlag" edit="#rc.edit#" />
					<cfif rc.rewardType eq "subscription">
						<hb:HibachiPropertyDisplay object="#rc.promotionreward#" property="applicableTerm" edit="#rc.edit#" />
					</cfif>
					<hb:HibachiPropertyDisplay object="#rc.promotionreward#" property="maximumUsePerOrder" edit="#rc.edit#" />
					<hb:HibachiPropertyDisplay object="#rc.promotionreward#" property="maximumUsePerItem" edit="#rc.edit#" />
					<hb:HibachiPropertyDisplay object="#rc.promotionreward#" property="maximumUsePerQualification" edit="#rc.edit#" />
				</cfif>
			</cfif>
			<cfif rc.rewardType EQ "rewardSku">
				<hb:HibachiPropertyDisplay object="#rc.promotionreward#" property="rewardSkuQuantity" edit="#rc.edit#" />
				<hb:HibachiPropertyDisplay object="#rc.promotionreward#" property="showRewardSkuInCartFlag" edit="#rc.edit#" />
			</cfif>
			<cfif !isNull(rc.promotionReward.getAmountType()) AND rc.promotionreward.getAmountType() NEQ 'amountOff'>
				<hb:HibachiPropertyDisplay object="#rc.promotionreward#" property="personalVolumeAmount" edit="#rc.edit#" />
				<hb:HibachiPropertyDisplay object="#rc.promotionreward#" property="taxableAmountAmount" edit="#rc.edit#" />
				<hb:HibachiPropertyDisplay object="#rc.promotionreward#" property="commissionableVolumeAmount" edit="#rc.edit#" />
				<hb:HibachiPropertyDisplay object="#rc.promotionreward#" property="retailCommissionAmount" edit="#rc.edit#" />
				<hb:HibachiPropertyDisplay object="#rc.promotionreward#" property="productPackVolumeAmount" edit="#rc.edit#" />
				<hb:HibachiPropertyDisplay object="#rc.promotionreward#" property="retailValueVolumeAmount" edit="#rc.edit#" />
			</cfif>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>