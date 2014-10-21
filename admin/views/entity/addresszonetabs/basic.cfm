<cfparam name="rc.addressZone" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList>
			<cf_HibachiPropertyDisplay object="#rc.addressZone#" property="addressZoneName" edit="#rc.edit#">
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
</cfoutput>