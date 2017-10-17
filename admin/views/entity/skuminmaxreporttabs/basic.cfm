<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.skuMinMaxReport" type="any" />
<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.skuMinMaxReport#" property="reportName" edit="#rc.edit#"/>
			<hb:HibachiPropertyDisplay object="#rc.skuMinMaxReport#" property="location" edit="#rc.edit#"/>
			<hb:HibachiPropertyDisplay object="#rc.skuMinMaxReport#" property="minQuantity" edit="#rc.edit#"/>
			<hb:HibachiPropertyDisplay object="#rc.skuMinMaxReport#" property="maxQuantity" edit="#rc.edit#"/>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>
