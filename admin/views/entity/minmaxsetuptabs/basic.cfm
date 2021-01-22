<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.minMaxSetup" type="any" />
<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.minMaxSetup#" property="setupName" edit="#rc.edit#"/>
			<hb:HibachiPropertyDisplay object="#rc.minMaxSetup#" property="location" edit="#rc.edit#"/>
			<hb:HibachiPropertyDisplay object="#rc.minMaxSetup#" property="minQuantity" edit="#rc.edit#"/>
			<hb:HibachiPropertyDisplay object="#rc.minMaxSetup#" property="maxQuantity" edit="#rc.edit#"/>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>
