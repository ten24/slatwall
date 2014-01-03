<cfcomponent>
	
	<!--- 
	Dumps the provided object into a PDF.
	Useful for dumping objects out from a component for
	troubleshooting when cfdump output is unviewable.
	This function creates a PDF in the temp directory
	off the site root.  
	--->
	<cffunction name="dumpToPDF" access="public" hint="Dumps the provided object into a PDF.">
		<cfargument name="obj" type="any" required="true" hint="Object to dump into pdf">
		<cfargument name="filenm" type="string" required="false" default="untitled" hint="Filename of pdf to dump into">
		<cfset tempPath=ExpandPath("*.*")> 
		<cfset tempDirectory=GetDirectoryFromPath(tempPath)>
		<cfdocument format="PDF" filename="#tempDirectory#custom/#arguments.filenm#.pdf" overwrite="true"> 
			<cfdump var="#arguments.obj#" top="3">
		</cfdocument>
	</cffunction>
			
</cfcomponent>