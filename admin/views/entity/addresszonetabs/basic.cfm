<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.addressZone" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.addressZone#" property="addressZoneName" edit="#rc.edit#">
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>