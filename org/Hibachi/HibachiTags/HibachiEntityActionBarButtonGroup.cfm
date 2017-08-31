<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "end">
	<cfset attributes.generatedContent = thistag.generatedContent />
	<cfset thistag.generatedContent = "" />
	<cfassociate basetag="cf_HibachiEntityActionBar" datacollection="buttonGroups">
</cfif>