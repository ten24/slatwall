<cfoutput>
	<!---add cfimport of hibachitags so that we can take advantage of HibachiCache--->
	<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags"/>
	<hb:HibachiCache>
		<cfinclude template="#arguments.contentPath#"/>
	</hb:HibachiCache>
</cfoutput>