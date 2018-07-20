<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.cycleCountGroup" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			
			<hb:HibachiListingDisplay 
				collectionList="#rc.cycleCountGroup.getSkuCollection()#"
				collectionConfigFieldName="skuCollectionConfig"
				showSimpleListingControls="false"
				recordEditAction="admin:entity.edit#lcase(rc.cycleCountGroup.getSkuCollection().getCollectionObject())#"
				recordDetailAction="admin:entity.detail#lcase(rc.cycleCountGroup.getSkuCollection().getCollectionObject())#"
			>
				
			</hb:HibachiListingDisplay>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>