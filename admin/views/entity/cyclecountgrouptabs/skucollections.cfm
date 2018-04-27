<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.cyclecountgroup" type="any">
<cfparam name="rc.edit" type="boolean">

<cfset skuCollectionSmartList = $.slatwall.getService("skuService").getCollectionSmartList() />
<cfset skuCollectionSmartList.addFilter("collectionObject","Sku") />
<cfset skuCollectionSmartList.addOrder("collectionName|ASC") />

<cfset selectedSkuCollectionIDs = "" />
<cfloop array="#rc.cyclecountgroup.getSkuCollectionsSmartlist().getRecords()#" index="skuCollection">
	<cfset selectedSkuCollectionIDs = listAppend(selectedSkuCollectionIDs, skuCollection.getCollectionID()) />
</cfloop>

<cfoutput>
	<hb:HibachiListingDisplay smartList="#skuCollectionSmartList#"
							  multiselectFieldName="skuCollections"
							  multiselectValues="#selectedSkuCollectionIDs#"
							  multiselectTitle="#$.slatwall.rbKey('define.primary')#"
							  edit="#rc.edit#">
		<hb:HibachiListingColumn propertyIdentifier="collectionName" tdclass="primary" />
	</hb:HibachiListingDisplay>
</cfoutput>