<cfimport prefix="swa" taglib="../../../../../tags" />
<cfimport prefix="hb" taglib="../../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.volumeRebuildBatch" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfset rc.volumeRebuildBatchOrderItemCollectionList = rc.volumeRebuildBatch.getVolumeRebuildBatchOrderItemsCollectionList() />
<cfset rc.volumeRebuildBatchOrderItemCollectionList.setDisplayProperties('skuCode,oldPersonalVolume,newPersonalVolume,oldCommissionableVolume,newCommissionableVolume,oldTaxableAmount,newTaxableAmount,oldRetailCommission,newRetailCommission,oldRetailValueVolume,newRetailValueVolume,oldProductPackVolume,newProductPackVolume',{isVisible=true,isSearchable=true}) />

<!--- ottSchedule, using ID to improve performance --->
<cfset rc.volumeRebuildBatchOrderItemCollectionList.setOrderBy('skuCode|asc')/>


<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiListingDisplay
				collectionList="#rc.volumeRebuildBatchOrderItemCollectionList#"
				usingPersonalCollection="false"
			>
			</hb:HibachiListingDisplay>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>	

