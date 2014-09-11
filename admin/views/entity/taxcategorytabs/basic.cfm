<cfparam name="rc.taxCategory" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList>
			<cf_HibachiPropertyDisplay object="#rc.taxCategory#" property="activeFlag" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.taxCategory#" property="taxCategoryName" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.taxCategory#" property="taxCategoryCode" edit="#rc.edit#">
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
</cfoutput>