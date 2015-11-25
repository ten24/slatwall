<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.promotionreward" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<input type="hidden" name="rewardType" value="#rc.rewardType#" />
			<input type="hidden" name="promotionperiod.promotionperiodID" value="#rc.promotionperiod.getPromotionperiodID()#" />
			<input type="hidden" name="promotionperiodID" value="#rc.promotionperiod.getPromotionperiodID()#" />
			
			<hb:HibachiPropertyDisplay object="#rc.promotionreward#" property="amountType" fieldType="select" edit="#rc.edit#" />
			<hb:HibachiPropertyDisplay object="#rc.promotionreward#" property="amount" edit="#rc.edit#" />
			<hb:HibachiDisplayToggle selector="select[name=amountType]" showValues="percentageOff" loadVisable="#rc.promotionReward.getNewFlag() || rc.promotionReward.getValueByPropertyIdentifier('amountType') eq 'percentageOff'#">
				<hb:HibachiPropertyDisplay object="#rc.promotionreward#" property="roundingRule" edit="#rc.edit#" />
			</hb:HibachiDisplayToggle>
			<hb:HibachiDisplayToggle selector="select[name=amountType]" showValues="amountOff,amount" loadVisable="#listfind('amountOff,amount',rc.promotionReward.getValueByPropertyIdentifier('amountType')) neq 0#">
				<hb:HibachiPropertyDisplay object="#rc.promotionreward#" property="currencyCode" fieldType="select" edit="#rc.edit#" />
			</hb:HibachiDisplayToggle>
			<cfif listFindNoCase("merchandise,subscription,contentaccess", rc.rewardType)>
				<cfif rc.rewardType eq "subscription">
					<hb:HibachiPropertyDisplay object="#rc.promotionreward#" property="applicableTerm" edit="#rc.edit#" />
				</cfif>
				<hb:HibachiPropertyDisplay object="#rc.promotionreward#" property="maximumUsePerOrder" edit="#rc.edit#" />
				<hb:HibachiPropertyDisplay object="#rc.promotionreward#" property="maximumUsePerItem" edit="#rc.edit#" />
				<hb:HibachiPropertyDisplay object="#rc.promotionreward#" property="maximumUsePerQualification" edit="#rc.edit#" />
			</cfif>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>