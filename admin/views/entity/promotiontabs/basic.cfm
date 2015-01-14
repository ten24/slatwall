<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.promotion" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.Promotion#" property="activeFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.Promotion#" property="promotionName" edit="#rc.edit#">
			<cfif rc.promotion.isNew()>
				<hr />
				<h5>#$.slatwall.rbKey('admin.pricing.detailpromotion.initialperiod')#</h5><br />
				<hb:HibachiPropertyDisplay object="#rc.promotionPeriod#" fieldName="promotionPeriods[1].startDateTime" property="startDateTime" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.promotionPeriod#" fieldName="promotionPeriods[1].endDateTime" property="endDateTime" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.promotionPeriod#" fieldName="promotionPeriods[1].maximumUseCount" property="maximumUseCount" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.promotionPeriod#" fieldName="promotionPeriods[1].maximumAccountUseCount" property="maximumAccountUseCount" edit="#rc.edit#">
				<input type="hidden" name="promotionPeriods[1].promotionPeriodID" value="#rc.promotionPeriod.getPromotionPeriodID()#" />
			</cfif>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>