<cfparam name="rc.loyalty" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList>
			<cf_HibachiPropertyDisplay object="#rc.loyalty#" property="activeFlag" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.loyalty#" property="loyaltyName" edit="#rc.edit#">
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
</cfoutput>