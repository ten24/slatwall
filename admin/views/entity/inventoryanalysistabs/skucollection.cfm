<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.inventoryAnalysis" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.inventoryAnalysis#" property="skuCollection" edit="#rc.edit#" />
			<!--- <hb:HibachiPropertyDisplay object="#rc.inventoryAnalysis#" property="skuCollectionConfig" edit="#rc.edit#" /> --->
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>
