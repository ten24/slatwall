<cfparam name="rc.locationConfiguration" type="any">
<cfparam name="rc.location" type="any" default="#rc.locationConfiguration.getLocation()#">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList>
			<cf_HibachiPropertyDisplay object="#rc.locationConfiguration#" property="activeFlag" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.locationConfiguration#" property="locationConfigurationName" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.locationConfiguration#" property="locationConfigurationCapacity" edit="#rc.edit#">				
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
</cfoutput>