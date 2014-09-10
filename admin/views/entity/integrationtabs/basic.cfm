<cfparam name="rc.integration" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.integration#" edit="#rc.edit#">
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList>
				<cf_HibachiPropertyDisplay object="#rc.integration#" property="integrationPackage" edit="false">
				<cf_HibachiPropertyDisplay object="#rc.integration#" property="activeFlag" edit="#rc.edit#" />
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
	</cf_HibachiEntityDetailForm>
</cfoutput>