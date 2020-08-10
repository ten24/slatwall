<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.locationConfiguration" type="any">
<cfparam name="rc.location" type="any" default="#rc.locationConfiguration.getLocation()#">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.locationConfiguration#" property="activeFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.locationConfiguration#" property="locationConfigurationName" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.locationConfiguration#" property="locationConfigurationCapacity" edit="#rc.edit#">				
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>