<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.priceGroup" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList>
			<cf_HibachiPropertyDisplay object="#rc.priceGroup#" property="activeFlag" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.priceGroup#" property="priceGroupName" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.priceGroup#" property="priceGroupCode" edit="#rc.edit#">
			<cfif arrayLen( rc.priceGroup.getParentPriceGroupOptions() ) gt 1>
				<cf_HibachiPropertyDisplay object="#rc.priceGroup#" property="parentPriceGroup" edit="#rc.edit#">
			</cfif>
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
</cfoutput>