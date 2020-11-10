<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.cyclecountgroup" type="any">
<cfparam name="rc.edit" type="boolean">

<cfset locationCollectionSmartList = $.slatwall.getService("locationService").getCollectionSmartList() />
<cfset locationCollectionSmartList.addFilter("collectionObject","Location") />
<cfset locationCollectionSmartList.addOrder("collectionName|ASC") />

<cfset selectedLocationCollectionIDs = "" />
<cfloop array="#rc.cyclecountgroup.getLocationCollectionsSmartlist().getRecords()#" index="locationCollection">
	<cfset selectedLocationCollectionIDs = listAppend(selectedLocationCollectionIDs, locationCollection.getCollectionID()) />
</cfloop>
<cfoutput>
	<hb:HibachiListingDisplay smartList="#locationCollectionSmartList#"
							  multiselectFieldName="LocationCollections"
							  multiselectValues="#selectedLocationCollectionIDs#"
							  multiselectTitle="#$.slatwall.rbKey('define.primary')#"
							  edit="#rc.edit#">
		<hb:HibachiListingColumn propertyIdentifier="collectionName" tdclass="primary" />
	</hb:HibachiListingDisplay>
</cfoutput>
