<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.loyaltyAccruement" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.loyaltyAccruement#" property="activeFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.loyaltyAccruement#" property="startDateTime" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.loyaltyAccruement#" property="endDateTime" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.loyaltyAccruement#" property="expirationTerm" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.loyaltyAccruement#" property="accruementType" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.loyaltyAccruement#" property="pointType" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.loyaltyAccruement#" property="pointQuantity" edit="#rc.edit#">				
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>