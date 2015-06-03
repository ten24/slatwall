<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.physicalCount" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<input type="hidden" name="physical.physicalID" value="#rc.physical.getPhysicalID()#" />
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.physicalCount#" property="location" edit="#rc.edit#" />
			<hb:HibachiPropertyDisplay object="#rc.physicalCount#" property="countPostDateTime" edit="#rc.edit#" />
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>