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
			<hb:HibachiPropertyDisplay object="#rc.loyaltyAccruement#" property="accruementEvent" edit="false">
			<hb:HibachiPropertyDisplay object="#rc.loyaltyAccruement#" property="accruementType" edit="false">

			<!--- TYPE - POINTS --->
			<cfif rc.loyaltyAccruement.getAccruementType() EQ 'points' >
				<hb:HibachiPropertyDisplay object="#rc.loyaltyAccruement#" property="pointType" edit="false" >
				
				<cfif rc.loyaltyAccruement.getPointType() EQ 'fixed' >
					<hb:HibachiPropertyDisplay object="#rc.loyaltyAccruement#" property="pointQuantity" edit="false">
				</cfif>	
				
			</cfif>
			
			<!--- TYPE - GIFT CARD --->
			<cfif rc.loyaltyAccruement.getAccruementType() EQ 'giftCard' >
				<hb:HibachiPropertyDisplay object="#rc.loyaltyAccruement.getGiftCardSku()#" property="skuCode" edit="false" />
			</cfif>
			
			<!--- TYPE - PROMOTION --->
			<cfif rc.loyaltyAccruement.getAccruementType() EQ 'promotion' >
				<hb:HibachiPropertyDisplay object="#rc.loyaltyAccruement.getPromotion()#" property="promotionName" edit="false" />
			</cfif>
			
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>