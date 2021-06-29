<cfoutput>
	<!---add cfimport of hibachitags so that we can take advantage of HibachiCache--->
	<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags"/>
	<cfinclude template="#arguments.contentPath#"/>
</cfoutput> 