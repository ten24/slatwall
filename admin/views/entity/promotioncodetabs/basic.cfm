<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />


<cfparam name="rc.promotionCode" type="any">
<cfparam name="rc.promotion" type="any" default="#rc.promotionCode.getPromotion()#">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.promotioncode#" property="promotioncode" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.promotioncode#" property="startDateTime" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.promotioncode#" property="endDateTime" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.promotioncode#" property="maximumUseCount" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.promotioncode#" property="maximumAccountUseCount" edit="#rc.edit#">
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>
