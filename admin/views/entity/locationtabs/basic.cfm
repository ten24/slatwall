<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.location" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.location#" property="activeFlag" edit="#rc.edit#" >
			<hb:HibachiPropertyDisplay object="#rc.location#" property="locationName" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.location#" property="parentLocation" edit="#rc.location.getNewFlag()#" valueOptions="#$.slatwall.getService('locationService').getLocationParentOptions()#">
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>	
</cfoutput>