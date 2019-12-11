<cfimport prefix="swa" taglib="../../../../../tags" />
<cfimport prefix="hb" taglib="../../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.volumeRebuildBatch" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfset rc.volumeRebuildBatchOrderCollectionList = rc.volumeRebuildBatch.getVolumeRebuildBatchOrdersCollectionList() />
<cfset rc.volumeRebuildBatchOrderCollectionList.setDisplayProperties('order.orderNumber,order.account.username,order.orderStatusType.typeCode',{isVisible=true,isSearchable=true}) />

<!--- ottSchedule, using ID to improve performance --->
<cfset rc.volumeRebuildBatchOrderCollectionList.setOrderBy('createdDateTime|asc')/>


<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiListingDisplay
				recordDetailAction="admin:entity.detailorder"
				collectionList="#rc.volumeRebuildBatchOrderCollectionList#"
				usingPersonalCollection="false"
			>
			</hb:HibachiListingDisplay>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>	

