<cfparam name="rc.content" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList>
			<cf_HibachiPropertyDisplay object="#rc.content#" property="title">
			<cf_HibachiPropertyDisplay object="#rc.content#" property="activeFlag" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.content#" property="contentTemplateType" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.content#" property="productListingPageFlag" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.content#" property="allowPurchaseFlag" edit="#rc.edit#">
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
</cfoutput>