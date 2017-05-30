<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.cyclecountgroup" type="any">
<cfparam name="rc.edit" type="boolean">

<cfset locationCollectionSmartList = $.slatwall.getService("locationService").getCollectionSmartList() />
<cfset locationCollectionSmartList.addFilter("collectionObject","Location") />
<cfset locationCollectionSmartList.addOrder("collectionName|ASC") />

<cfif !isNull(rc.cyclecountgroup.getLocationCollection())>
	<cfset locationCollectionID = rc.cyclecountgroup.getLocationCollection().getCollectionID() />
<cfelse>
	<cfset locationCollectionID = "" />
</cfif>

<cfoutput>
	<hb:HibachiListingDisplay smartList="#locationCollectionSmartList#" selectFieldName="locationCollection.collectionID" selectValue="#locationCollectionID#"  edit="#rc.edit#">
		<hb:HibachiListingColumn propertyIdentifier="collectionName" tdclass="primary" />
	</hb:HibachiListingDisplay>
</cfoutput>
