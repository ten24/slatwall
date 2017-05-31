<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "end">
	
	<cfset attributes.contentData = thisTag.generatedContent/>
	<cfassociate basetag="cf_HibachiCache" datacollection=attributes.contentData>
	
	<cfset thisTag.generatedContent = " $[[insertUnCachedKey]] "/>
	
</cfif>