<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.priceGroup" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.priceGroup#" property="activeFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.priceGroup#" property="priceGroupName" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.priceGroup#" property="priceGroupCode" edit="#rc.edit#">
			<cfif arrayLen( rc.priceGroup.getParentPriceGroupOptions() ) gt 1>
				<hb:HibachiPropertyDisplay object="#rc.priceGroup#" property="parentPriceGroup" edit="#rc.edit#">
			</cfif>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>