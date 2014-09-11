<cfparam name="rc.brand" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList>
			<cf_HibachiPropertyDisplay object="#rc.Brand#" property="activeFlag" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.Brand#" property="brandName" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.Brand#" property="brandWebsite" edit="#rc.edit#">
			<cfif not rc.brand.isNew()>
				<cf_HibachiPropertyDisplay object="#rc.Brand#" property="urlTitle" edit="#rc.edit#">
			</cfif>
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
</cfoutput>