<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.cyclecountgroup" type="any">
<cfparam name="rc.edit" type="boolean">

<cfset skuCollectionSmartList = $.slatwall.getService("skuService").getCollectionSmartList() />
<cfset skuCollectionSmartList.addFilter("collectionObject","Sku") />
<cfset skuCollectionSmartList.addOrder("collectionName|ASC") />

<cfif !isNull(rc.cyclecountgroup.getSkuCollection())>
	<cfset skuCollectionID = rc.cyclecountgroup.getSku().getCollectionID() />
<cfelse>
	<cfset skuCollectionID = "" />
</cfif>

<cfoutput>
	<hb:HibachiListingDisplay smartList="#skuCollectionSmartList#" selectFieldName="skuCollection.skuCollectionID" selectValue="#skuCollectionID#" edit="#rc.edit#">
		<hb:HibachiListingColumn propertyIdentifier="collectionName" tdclass="primary" />
	</hb:HibachiListingDisplay>
</cfoutput>
