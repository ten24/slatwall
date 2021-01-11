<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.batch" type="any" />
<cfparam name="rc.edit" type="boolean" default="false" />
<cfoutput>

	<cfset local.entityQueueCollectionList = getHibachiScope().getService('HibachiEntityQueueService').getEntityQueueCollectionList()/>
	<cfset local.displayProperties = "baseObject,processMethod,tryCount,createdDateTime,integration.integrationName,mostRecentError"/>
	<cfset local.entityQueueCollectionList.setDisplayProperties(
	local.displayProperties,
	{
		isVisible=true,
		isSearchable=true,
		isDeletable=true
	})/>
	
	<cfset local.entityQueueCollectionList.addDisplayProperty(
	displayProperty='entityQueueID',
	columnConfig={
		isVisible=false,
		isSearchable=false,
		isDeletable=false
	})/>
	
	<cfset local.entityQueueCollectionList.addFilter('batch.batchID', rc.batch.getBatchID()) />
	
	<hb:HibachiListingDisplay 
		collectionList="#local.entityQueueCollectionList#"
		usingPersonalCollection="true"
		personalCollectionKey='#request.context.entityactiondetails.itemname#'
		recordDetailAction="admin:entity.detailentityqueue"
		recordEditAction="admin:entity.editentityqueue"
	>
	</hb:HibachiListingDisplay>
	
</cfoutput>
