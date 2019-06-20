<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.cyclecountbatch" type="any">
<cfparam name="rc.edit" type="boolean">

<cfset local.physicalCountCollection = rc.cyclecountbatch.getPhysicalCountCollectionList() />
<cfset local.physicalCountCollection.setDisplayProperties(displayPropertiesList='countPostDateTime',columnConfig={
		isSearchable="true",
		isVisible="true",
		isDeletable="true"}) />
<cfset local.physicalCountCollection.addDisplayProperty(displayProperty='physicalCountID',columnConfig={
		isSearchable="true",
		isVisable="false",
		isDeletable="false"}) />
<cfset local.physicalCountCollection.addDisplayAggregate(propertyIdentifier='physicalCountItems.physicalCountItemID',aggregateFunction='COUNT',aggregateAlias='physicalCountItemCount',columnConfig={
		isSearchable="true",
		isVisible="true",
		isDeletable="false"}) />

<cfoutput>
	<hb:HibachiListingDisplay
		collectionList="#local.physicalCountCollection#"
		recordDetailAction="admin:entity.detail#lcase(local.physicalCountCollection.getCollectionObject())#"
	>
	<!--	<hb:HibachiListingColumn tdclass="primary" propertyIdentifier="countPostDateTime" />-->
	<!--<hb:HibachiListingColumn propertyIdentifier="physicalCountItemCount" />-->
	</hb:HibachiListingDisplay>
</cfoutput>
