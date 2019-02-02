<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.inventoryAnalysis" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<!---<hb:HibachiPropertyDisplay object="#rc.inventoryAnalysis#" property="skuCollection" edit="#rc.edit#" />--->
			<!--- <hb:HibachiPropertyDisplay object="#rc.inventoryAnalysis#" property="skuCollectionConfig" edit="#rc.edit#" /> --->
			
			<hb:HibachiListingDisplay 
				collectionList="#rc.inventoryAnalysis.getSkuCollection()#"
				collectionConfigFieldName="skuCollectionConfig"
				showSimpleListingControls="false"
				recordEditAction="admin:entity.edit#lcase(rc.inventoryAnalysis.getSkuCollection().getCollectionObject())#"
				recordDetailAction="admin:entity.detail#lcase(rc.inventoryAnalysis.getSkuCollection().getCollectionObject())#"
			>
			</hb:HibachiListingDisplay>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>
