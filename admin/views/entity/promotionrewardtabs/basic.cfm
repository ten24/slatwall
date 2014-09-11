<cfparam name="rc.promotionreward" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList>
			<input type="hidden" name="rewardType" value="#rc.rewardType#" />
			<input type="hidden" name="promotionperiod.promotionperiodID" value="#rc.promotionperiod.getPromotionperiodID()#" />
			<input type="hidden" name="promotionperiodID" value="#rc.promotionperiod.getPromotionperiodID()#" />
			
			<cf_HibachiPropertyDisplay object="#rc.promotionreward#" property="amountType" fieldType="select" edit="#rc.edit#" />
			<cf_HibachiPropertyDisplay object="#rc.promotionreward#" property="amount" edit="#rc.edit#" />
			<cf_HibachiDisplayToggle selector="select[name=amountType]" showValues="percentageOff" loadVisable="#rc.promotionReward.getNewFlag() || rc.promotionReward.getValueByPropertyIdentifier('amountType') eq 'percentageOff'#">
				<cf_HibachiPropertyDisplay object="#rc.promotionreward#" property="roundingRule" edit="#rc.edit#" />
			</cf_HibachiDisplayToggle>
			<cfif listFindNoCase("merchandise,subscription,contentaccess", rc.rewardType)>
				<cfif rc.rewardType eq "subscription">
					<cf_HibachiPropertyDisplay object="#rc.promotionreward#" property="applicableTerm" edit="#rc.edit#" />
				</cfif>
				<cf_HibachiPropertyDisplay object="#rc.promotionreward#" property="maximumUsePerOrder" edit="#rc.edit#" />
				<cf_HibachiPropertyDisplay object="#rc.promotionreward#" property="maximumUsePerItem" edit="#rc.edit#" />
				<cf_HibachiPropertyDisplay object="#rc.promotionreward#" property="maximumUsePerQualification" edit="#rc.edit#" />
			</cfif>
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
</cfoutput>