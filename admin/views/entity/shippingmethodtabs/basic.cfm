<cfparam name="rc.shippingMethod" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList>
			<cf_HibachiPropertyDisplay object="#rc.shippingMethod#" property="activeFlag" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.shippingMethod#" property="shippingMethodName" edit="#rc.edit#">
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
</cfoutput>