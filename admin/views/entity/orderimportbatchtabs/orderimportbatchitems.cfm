<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.orderImportBatch" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfset rc.orderImportBatchItemCollectionList = rc.orderImportBatch.getOrderImportBatchItemsCollectionList() />
<cfset rc.orderImportBatchItemCollectionList.setDisplayProperties('orderImportBatchItemStatusType.typeName,originalOrderNumber,accountNumber,skuCode,quantity,name,streetAddress,street2Address,city,stateCode,locality,postalCode,countryCode,phoneNumber',{isVisible=true,isSearchable=true}) />

<!--- ottSchedule, using ID to improve performance --->
<cfset rc.orderImportBatchItemCollectionList.setOrderBy('accountNumber|asc')/>


<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiListingDisplay
				collectionList="#rc.orderImportBatchItemCollectionList#"
				usingPersonalCollection="false"
			>
			</hb:HibachiListingDisplay>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>	