<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.loyaltyAccruement" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList>
			<cf_HibachiPropertyDisplay object="#rc.loyaltyAccruement#" property="activeFlag" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.loyaltyAccruement#" property="startDateTime" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.loyaltyAccruement#" property="endDateTime" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.loyaltyAccruement#" property="expirationTerm" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.loyaltyAccruement#" property="accruementType" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.loyaltyAccruement#" property="pointType" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.loyaltyAccruement#" property="pointQuantity" edit="#rc.edit#">				
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
</cfoutput>