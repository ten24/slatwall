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
			<hb:HibachiPropertyDisplay object="#rc.loyaltyAccruement#" property="accruementEvent" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.loyaltyAccruement#" property="accruementType" edit="#rc.edit#">
			<hb:HibachiDisplayToggle selector="select[name='accruementType']" showValues="points">
				<hb:HibachiPropertyDisplay object="#rc.loyaltyAccruement#" property="pointType" edit="#rc.edit#">
				<hb:HibachiDisplayToggle selector="select[name='pointType']" showValues="fixed" >
					<hb:HibachiPropertyDisplay object="#rc.loyaltyAccruement#" property="pointQuantity" edit="#rc.edit#">
				</hb:HibachiDisplayToggle>
				<hb:HibachiDisplayToggle selector="select[name='pointType']" showValues="pointsPerCurrencyUnit" >
					<h1>LINK ENTITAY</h1>
				</hb:HibachiDisplayToggle>
			</hb:HibachiDisplayToggle>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>