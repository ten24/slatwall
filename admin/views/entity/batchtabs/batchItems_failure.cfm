<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.batch" type="any" />
<cfparam name="rc.edit" type="boolean" default="false" />
<cfoutput>

	<cfset local.entityQueueFailureCollectionList = getHibachiScope().getService('HibachiEntityQueueService').getEntityQueueFailureCollectionList()/>
	<cfset local.displayFailureProperties = "baseObject,processMethod,tryCount,createdDateTime,integration.integrationName,mostRecentError"/>
	<cfset local.entityQueueFailureCollectionList.setDisplayProperties(
	local.displayFailureProperties,
	{
		isVisible=true,
		isSearchable=true,
		isDeletable=true
	})/>
	
	<cfset local.entityQueueFailureCollectionList.addDisplayProperty(
	displayProperty='entityQueueFailureID',
	columnConfig={
		isVisible=false,
		isSearchable=false,
		isDeletable=false
	})/>
	
	<cfset local.entityQueueFailureCollectionList.addFilter('batch.batchID', rc.batch.getBatchID()) />
	
	<hb:HibachiListingDisplay 
		collectionList="#local.entityQueueFailureCollectionList#"
		usingPersonalCollection="true"
		personalCollectionKey='#request.context.entityactiondetails.itemname#_failure'
		recordDetailAction="admin:entity.detailentityqueuefailure"
		recordEditAction="admin:entity.editentityqueuefailure"
	>
	</hb:HibachiListingDisplay>
	
</cfoutput>
