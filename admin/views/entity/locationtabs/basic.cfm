<cfparam name="rc.location" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList>
			<cf_HibachiPropertyDisplay object="#rc.location#" property="activeFlag" edit="#rc.edit#" >
			<cf_HibachiPropertyDisplay object="#rc.location#" property="locationName" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.location#" property="parentLocation" edit="#rc.edit#" valueOptions="#$.slatwall.getService('locationService').getLocationParentOptions()#">
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>	
</cfoutput>