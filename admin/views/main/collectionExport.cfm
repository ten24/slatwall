<!--- Make sure that only a super user can export a report --->
<cfset isSuperUser =  $.slatwall.getAccount().getSuperUserFlag() />
<cfif isSuperUser EQ "YES">
	<cfset $.slatwall.getService('collectionService').collectionsExport(rc) />
</cfif>
