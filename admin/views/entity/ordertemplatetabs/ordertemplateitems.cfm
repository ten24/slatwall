<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.orderTemplate" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfset rc.skuCollectionList = getHibachiScope().getService('SkuService').getSkuCollectionList() />

<cfset rc.orderTemplateItemCollectionList = getHibachiScope().getService('OrderService').getOrderTemplateItemCollectionList() />

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>

				<hb:HibachiListingDisplay 
					collectionList="#rc.skuCollectionlist#"
					usingPersonalCollection="false"
				>
				</hb:HibachiListingDisplay>	

		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>	
