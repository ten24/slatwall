<cfif thisTag.executionMode is "end">
	<cfset attributes.generatedContent = thistag.generatedContent />
	<cfset thistag.generatedContent = "" />
	<cfassociate basetag="cf_HibachiListingDisplay" datacollection="buttonGroup">
</cfif>